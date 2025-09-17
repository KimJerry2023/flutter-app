import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'error_code.dart';

/// 请求配置类
class RequestConfig {
  String url;
  String method;
  Map<String, String> headers;
  Map<String, dynamic>? body;
  Map<String, String>? queryParameters;
  String baseUrl;
  int retryCount;

  RequestConfig({
    required this.url,
    required this.method,
    required this.headers,
    this.body,
    this.queryParameters,
    this.baseUrl = '',
    this.retryCount = 0,
  });
}

/// 请求拦截器类型定义
typedef RequestInterceptor = Future<RequestConfig> Function(RequestConfig config);
typedef ResponseInterceptor = Future<http.Response> Function(http.Response response);
typedef ErrorInterceptor = Future<dynamic> Function(dynamic error);

/// 全局请求服务
/// 自动添加token和language头部信息
/// token可以为空，language默认为中文zh
class RequestService extends GetxController {
  // 静态getter - 提供全局访问RequestService实例的便捷方法
  static RequestService get instance => Get.find();

  // 响应式语言设置
  final RxString _language = 'zh'.obs;

  // 基础URL，可以根据需要配置
  String baseUrl = '';

  // 拦截器列表
  final List<RequestInterceptor> _requestInterceptors = [];
  final List<ResponseInterceptor> _responseInterceptors = [];
  final List<ErrorInterceptor> _errorInterceptors = [];

  // Token刷新相关状态
  bool _isRefreshing = false;
  final List<Function> _onRefreshedCallbacks = [];

  // Getter方法
  String get language => _language.value;

  @override
  void onInit() {
    super.onInit();
    _loadLanguage();
    _setupDefaultInterceptors();
  }

  /// 设置默认拦截器
  void _setupDefaultInterceptors() {
    // 添加默认的请求拦截器
    addRequestInterceptor((config) async {
      // 处理绝对URL - 如果URL包含http://或https://，清空baseURL
      if (config.url.contains('http://') || config.url.contains('https://')) {
        config.baseUrl = '';
      }

      // 获取token并添加到headers
      final token = AuthService.instance.token;
      if (token.isNotEmpty) {
        config.headers['Authorization'] = 'Bearer $token';
      }

      // 添加语言设置
      final locale = _language.value;
      if (locale.isNotEmpty) {
        config.headers['Accept-Language'] = locale;
        config.headers['Language'] = locale;
      }

      return config;
    });

    // 添加默认的响应拦截器
    addResponseInterceptor((response) async {
      final json = parseJsonResponse(response);
      if (json == null) return response;

      final code = (json['code'] is int)
          ? json['code'] as int
          : int.tryParse(json['code']?.toString() ?? '') ?? response.statusCode;
      final errorMessage = getErrorMessage(code, _language.value);

      // 处理401未授权错误
      if (code == 401) {
        // 检查重试次数
        final retryCountHeader = response.request?.headers['X-Retry-Count'];
        final retryCount = int.tryParse(retryCountHeader ?? '0') ?? 0;

        if (retryCount >= 1) {
          await goLogin();
          throw Exception('重试次数过多，已清除认证信息');
        }

        if (!_isRefreshing) {
          _isRefreshing = true;
          try {
            final newToken = await _refreshToken();
            if (newToken != null) {
              // 更新token
              final authService = AuthService.instance;
              await authService.setToken(newToken);

              _isRefreshing = false;
              _onRefreshed();

              // 重新发起原请求需要在调用层处理
              return response;
            } else {
              _isRefreshing = false;
              await goLogin();
              throw Exception('Token刷新失败');
            }
          } catch (e) {
            _isRefreshing = false;
            await goLogin();
            throw e;
          }
        } else {
          // 如果正在刷新token，等待刷新完成
          await Future.delayed(Duration(milliseconds: 100));
          return response;
        }
      }

      // 处理其他业务错误
      if (code != 200 && code != 201) {
        // 显示错误提示
        Get.snackbar(
          '错误',
          errorMessage,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
        throw Exception(errorMessage);
      }

      return response;
    });
  }

  /// 添加请求拦截器
  void addRequestInterceptor(RequestInterceptor interceptor) {
    _requestInterceptors.add(interceptor);
  }

  /// 添加响应拦截器
  void addResponseInterceptor(ResponseInterceptor interceptor) {
    _responseInterceptors.add(interceptor);
  }

  /// 添加错误拦截器
  void addErrorInterceptor(ErrorInterceptor interceptor) {
    _errorInterceptors.add(interceptor);
  }

  /// 移除请求拦截器
  void removeRequestInterceptor(RequestInterceptor interceptor) {
    _requestInterceptors.remove(interceptor);
  }

  /// 移除响应拦截器
  void removeResponseInterceptor(ResponseInterceptor interceptor) {
    _responseInterceptors.remove(interceptor);
  }

  /// 移除错误拦截器
  void removeErrorInterceptor(ErrorInterceptor interceptor) {
    _errorInterceptors.remove(interceptor);
  }

  /// 清空所有拦截器
  void clearInterceptors() {
    _requestInterceptors.clear();
    _responseInterceptors.clear();
    _errorInterceptors.clear();
  }

  /// 加载本地存储的语言设置
  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString('language') ?? 'zh';
    _language.value = savedLanguage;
  }

  /// 设置语言
  Future<void> setLanguage(String language) async {
    _language.value = language;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
  }

  /// 处理请求拦截器
  Future<RequestConfig> _processInterceptors(RequestConfig config) async {
    RequestConfig processedConfig = config;

    for (final interceptor in _requestInterceptors) {
      try {
        processedConfig = await interceptor(processedConfig);
      } catch (e) {
        // 如果拦截器出错，尝试错误拦截器
        await _processErrorInterceptors(e);
        rethrow;
      }
    }

    return processedConfig;
  }

  /// 处理响应拦截器
  Future<http.Response> _processResponseInterceptors(http.Response response) async {
    http.Response processedResponse = response;

    for (final interceptor in _responseInterceptors) {
      try {
        processedResponse = await interceptor(processedResponse);
      } catch (e) {
        // 如果响应拦截器出错，尝试错误拦截器
        await _processErrorInterceptors(e);
        rethrow;
      }
    }

    return processedResponse;
  }

  /// 处理错误拦截器
  Future<void> _processErrorInterceptors(dynamic error) async {
    for (final interceptor in _errorInterceptors) {
      try {
        await interceptor(error);
      } catch (e) {
        // 错误拦截器本身出错，记录日志但不抛出
        print('Error interceptor failed: $e');
      }
    }
  }

  /// 执行带重试的HTTP请求
  Future<http.Response> _executeWithRetry(
    Future<http.Response> Function() requestFunction,
    RequestConfig config,
  ) async {
    int currentRetry = 0;
    const maxRetries = 3;

    while (currentRetry <= maxRetries) {
      try {
        final response = await requestFunction();
        // 处理响应拦截器
        final processedResponse = await _processResponseInterceptors(response);
        return processedResponse;
      } catch (e) {
        currentRetry++;
        config.retryCount = currentRetry;

        if (currentRetry > maxRetries) {
          await _processErrorInterceptors(e);
          rethrow;
        }

        // 等待一段时间后重试
        await Future.delayed(Duration(milliseconds: 1000 * currentRetry));
      }
    }

    throw Exception('Max retries exceeded');
  }

  /// 获取通用请求头
  Map<String, String> _getHeaders({Map<String, String>? additionalHeaders}) {
    // 获取token，可能为空
    final token = AuthService.instance.token;

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Accept-Language': _language.value,
      'Language': _language.value, // 添加Language头部
    };

    // 如果token不为空，添加Authorization头部
    if (token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
      headers['Token'] = token; // 也可以直接用Token头部
    }

    // 合并额外的头部信息
    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    return headers;
  }

  /// GET请求
  Future<http.Response> get(String path, {Map<String, String>? queryParameters, Map<String, String>? headers}) async {
    // 创建请求配置
    final config = RequestConfig(
      url: path,
      method: 'GET',
      headers: _getHeaders(additionalHeaders: headers),
      queryParameters: queryParameters,
      baseUrl: baseUrl,
    );

    // 处理拦截器
    final processedConfig = await _processInterceptors(config);

    // 构建最终URI
    final uri = _buildUriFromConfig(processedConfig);

    // 执行带重试的请求
    return await _executeWithRetry(() async {
      final response = await http.get(uri, headers: processedConfig.headers);
      _logRequest('GET', uri.toString(), processedConfig.headers, null, response);
      return response;
    }, processedConfig);
  }

  /// POST请求
  Future<http.Response> post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) async {
    // 创建请求配置
    final config = RequestConfig(
      url: path,
      method: 'POST',
      headers: _getHeaders(additionalHeaders: headers),
      body: body,
      queryParameters: queryParameters,
      baseUrl: baseUrl,
    );

    // 处理拦截器
    final processedConfig = await _processInterceptors(config);

    // 构建最终URI和body
    final uri = _buildUriFromConfig(processedConfig);
    final jsonBody = processedConfig.body != null ? jsonEncode(processedConfig.body) : null;

    // 执行带重试的请求
    return await _executeWithRetry(() async {
      final response = await http.post(uri, headers: processedConfig.headers, body: jsonBody);
      _logRequest('POST', uri.toString(), processedConfig.headers, jsonBody, response);
      return response;
    }, processedConfig);
  }

  /// PUT请求
  Future<http.Response> put(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) async {
    // 创建请求配置
    final config = RequestConfig(
      url: path,
      method: 'PUT',
      headers: _getHeaders(additionalHeaders: headers),
      body: body,
      queryParameters: queryParameters,
      baseUrl: baseUrl,
    );

    // 处理拦截器
    final processedConfig = await _processInterceptors(config);

    // 构建最终URI和body
    final uri = _buildUriFromConfig(processedConfig);
    final jsonBody = processedConfig.body != null ? jsonEncode(processedConfig.body) : null;

    // 执行带重试的请求
    return await _executeWithRetry(() async {
      final response = await http.put(uri, headers: processedConfig.headers, body: jsonBody);
      _logRequest('PUT', uri.toString(), processedConfig.headers, jsonBody, response);
      return response;
    }, processedConfig);
  }

  /// DELETE请求
  Future<http.Response> delete(
    String path, {
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) async {
    // 创建请求配置
    final config = RequestConfig(
      url: path,
      method: 'DELETE',
      headers: _getHeaders(additionalHeaders: headers),
      queryParameters: queryParameters,
      baseUrl: baseUrl,
    );

    // 处理拦截器
    final processedConfig = await _processInterceptors(config);

    // 构建最终URI
    final uri = _buildUriFromConfig(processedConfig);

    // 执行带重试的请求
    return await _executeWithRetry(() async {
      final response = await http.delete(uri, headers: processedConfig.headers);
      _logRequest('DELETE', uri.toString(), processedConfig.headers, null, response);
      return response;
    }, processedConfig);
  }

  /// PATCH请求
  Future<http.Response> patch(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) async {
    // 创建请求配置
    final config = RequestConfig(
      url: path,
      method: 'PATCH',
      headers: _getHeaders(additionalHeaders: headers),
      body: body,
      queryParameters: queryParameters,
      baseUrl: baseUrl,
    );

    // 处理拦截器
    final processedConfig = await _processInterceptors(config);

    // 构建最终URI和body
    final uri = _buildUriFromConfig(processedConfig);
    final jsonBody = processedConfig.body != null ? jsonEncode(processedConfig.body) : null;

    // 执行带重试的请求
    return await _executeWithRetry(() async {
      final response = await http.patch(uri, headers: processedConfig.headers, body: jsonBody);
      _logRequest('PATCH', uri.toString(), processedConfig.headers, jsonBody, response);
      return response;
    }, processedConfig);
  }

  /// 构建URI
  Uri _buildUri(String path, Map<String, String>? queryParameters) {
    final fullUrl = baseUrl.isEmpty ? path : '$baseUrl$path';

    if (queryParameters != null && queryParameters.isNotEmpty) {
      return Uri.parse(fullUrl).replace(queryParameters: queryParameters);
    }

    return Uri.parse(fullUrl);
  }

  /// 从配置构建URI
  Uri _buildUriFromConfig(RequestConfig config) {
    final fullUrl = config.baseUrl.isEmpty ? config.url : '${config.baseUrl}${config.url}';

    if (config.queryParameters != null && config.queryParameters!.isNotEmpty) {
      return Uri.parse(fullUrl).replace(queryParameters: config.queryParameters);
    }

    return Uri.parse(fullUrl);
  }

  /// 记录请求日志
  void _logRequest(String method, String url, Map<String, String> headers, String? body, http.Response response) {
    print('=== HTTP Request ===');
    print('$method $url');
    print('Headers: $headers');
    if (body != null) {
      print('Body: $body');
    }
    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');
    print('===================');
  }

  /// 记录错误日志
  void _logError(String method, String url, dynamic error) {
    print('=== HTTP Error ===');
    print('$method $url');
    print('Error: $error');
    print('==================');
  }

  /// 便捷方法：解析JSON响应
  Map<String, dynamic>? parseJsonResponse(http.Response response) {
    try {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      print('JSON解析错误: $e');
      return null;
    }
  }

  /// 便捷方法：检查响应是否成功
  bool isSuccessResponse(http.Response response) {
    return response.statusCode >= 200 && response.statusCode < 300;
  }

  /// 便捷方法：处理通用API响应
  ApiResponse<T> handleResponse<T>(http.Response response, T Function(Map<String, dynamic>) fromJson) {
    if (isSuccessResponse(response)) {
      final json = parseJsonResponse(response);
      if (json != null) {
        return ApiResponse.success(fromJson(json));
      } else {
        return ApiResponse.error('响应数据为空');
      }
    } else {
      final json = parseJsonResponse(response);
      final message = (json?['message']?.toString()) ?? (json?['error']?.toString()) ?? '请求失败';
      return ApiResponse.error(message, statusCode: response.statusCode);
    }
  }

  /// 处理登录过期，跳转到登录页
  Future<void> goLogin() async {
    final authService = AuthService.instance;
    await authService.clearAuth();

    // 显示登录过期提示
    Get.dialog(
      AlertDialog(
        title: Text('提示'),
        content: Text('您的登录已过期，请重新登录'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // 关闭对话框
              Get.offAllNamed('/login'); // 跳转到登录页并清除所有页面栈
            },
            child: Text('确定'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  /// 刷新token
  Future<String?> _refreshToken() async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}/user/refresh_token'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer ${AuthService.instance.token}'},
      );

      if (response.statusCode == 200) {
        final json = parseJsonResponse(response);
        return json?['token'] as String?;
      }
      return null;
    } catch (e) {
      print('刷新token失败: $e');
      return null;
    }
  }

  /// 通知所有等待的请求token已刷新
  void _onRefreshed() {
    for (final callback in _onRefreshedCallbacks) {
      callback();
    }
    _onRefreshedCallbacks.clear();
  }
}

/// API响应包装类
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? error;
  final int? statusCode;

  ApiResponse.success(this.data) : success = true, error = null, statusCode = null;

  ApiResponse.error(this.error, {this.statusCode}) : success = false, data = null;
}
