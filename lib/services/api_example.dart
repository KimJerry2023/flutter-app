import 'dart:convert';
import 'dart:math' as math;
import 'request_service.dart';

/// API使用示例
/// 展示如何使用RequestService的拦截器功能
class ApiExample {
  final RequestService _requestService = RequestService.instance;

  /// 初始化API服务
  void initializeApiService() {
    // 设置基础URL
    _requestService.baseUrl = 'https://api.example.com';

    // 添加自定义请求拦截器 - 仿照你提供的axios拦截器
    _requestService.addRequestInterceptor((config) async {
      print('请求拦截器: 处理请求 ${config.method} ${config.url}');

      // 处理绝对URL - 如果URL包含http://或https://，清空baseURL
      if (config.url.contains('http://') || config.url.contains('https://')) {
        config.baseUrl = '';
        print('检测到绝对URL，清空baseURL');
      }

      // 设置重试次数
      config.retryCount = config.retryCount;

      // 添加自定义头部
      config.headers['X-Client-Version'] = '1.0.0';
      config.headers['X-Platform'] = 'Flutter';

      // 记录请求配置
      print('最终请求配置: ${config.headers}');

      return config;
    });

    // 添加自定义响应拦截器 - 仿照你提供的axios响应拦截器
    _requestService.addResponseInterceptor((response) async {
      print('响应拦截器: 处理响应 ${response.statusCode}');

      // 解析响应数据
      final json = _requestService.parseJsonResponse(response);
      if (json != null) {
        final code = json['code'] ?? response.statusCode;
        print('业务状态码: $code');

        // 自定义业务逻辑处理
        if (code == 403) {
          print('请求过于频繁，触发限流');
          // 可以在这里添加特殊的限流处理逻辑
        }

        // 记录响应数据
        print('响应数据: ${json.toString().substring(0, math.min(100, json.toString().length))}...');
      }

      return response;
    });

    // 添加错误拦截器
    _requestService.addErrorInterceptor((error) async {
      print('错误拦截器: 捕获到错误 - $error');

      // 这里可以添加错误处理逻辑，比如：
      // - 记录错误日志
      // - 显示用户友好的错误消息
      // - 重定向到错误页面等

      return error;
    });
  }

  /// 示例：获取用户信息
  Future<Map<String, dynamic>?> getUserInfo(String userId) async {
    try {
      final response = await _requestService.get('/users/$userId');

      if (_requestService.isSuccessResponse(response)) {
        return _requestService.parseJsonResponse(response);
      } else {
        print('获取用户信息失败: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('请求异常: $e');
      return null;
    }
  }

  /// 示例：创建用户
  Future<bool> createUser(Map<String, dynamic> userData) async {
    try {
      final response = await _requestService.post('/users', body: userData);

      return _requestService.isSuccessResponse(response);
    } catch (e) {
      print('创建用户异常: $e');
      return false;
    }
  }

  /// 示例：使用绝对URL的请求
  Future<Map<String, dynamic>?> getExternalData() async {
    try {
      // 这个请求会触发拦截器中的绝对URL处理逻辑
      final response = await _requestService.get('https://jsonplaceholder.typicode.com/posts/1');

      if (_requestService.isSuccessResponse(response)) {
        return _requestService.parseJsonResponse(response);
      } else {
        print('获取外部数据失败: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('请求异常: $e');
      return null;
    }
  }

  /// 示例：使用ApiResponse包装器
  Future<ApiResponse<User>> getUserWithWrapper(String userId) async {
    try {
      final response = await _requestService.get('/users/$userId');

      return _requestService.handleResponse<User>(response, (json) => User.fromJson(json));
    } catch (e) {
      return ApiResponse.error('网络请求失败: $e');
    }
  }

  /// 示例：动态设置语言
  Future<void> changeLanguage(String language) async {
    await _requestService.setLanguage(language);
    print('语言已切换为: $language');

    // 后续的请求将自动包含新的语言设置
    final response = await _requestService.get('/localized-content');
    print('本地化内容请求状态: ${response.statusCode}');
  }
}

/// 用户模型示例
class User {
  final String id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] is String ? json['id'] as String : (json['id']?.toString() ?? ''),
      name: json['name'] is String ? json['name'] as String : (json['name']?.toString() ?? ''),
      email: json['email'] is String ? json['email'] as String : (json['email']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email};
  }
}

/// 使用示例
void main() async {
  final apiExample = ApiExample();

  // 初始化API服务
  apiExample.initializeApiService();

  // 示例1: 获取用户信息
  final userInfo = await apiExample.getUserInfo('123');
  print('用户信息: $userInfo');

  // 示例2: 创建用户
  final success = await apiExample.createUser({'name': '张三', 'email': 'zhangsan@example.com'});
  print('创建用户成功: $success');

  // 示例3: 获取外部数据（绝对URL）
  final externalData = await apiExample.getExternalData();
  print('外部数据: $externalData');

  // 示例4: 使用包装器
  final userResponse = await apiExample.getUserWithWrapper('123');
  if (userResponse.success) {
    print('用户数据: ${userResponse.data?.name}');
  } else {
    print('获取用户失败: ${userResponse.error}');
  }

  // 示例5: 切换语言
  await apiExample.changeLanguage('en');

  // 示例6: 测试响应拦截器
  await testResponseInterceptor(apiExample);
}

/// 测试响应拦截器功能
Future<void> testResponseInterceptor(ApiExample apiExample) async {
  print('\n=== 测试响应拦截器功能 ===');

  try {
    // 测试正常响应
    print('1. 测试正常响应...');
    try {
      final normalResponse = await apiExample.getUserInfo('123');
      print('正常响应处理完成: $normalResponse');
    } catch (e) {
      print('正常请求被响应拦截器处理: $e');
    }

    // 模拟401错误测试
    print('2. 响应拦截器已配置401自动处理（token刷新逻辑）');
    print('   - 当收到401响应时，会自动尝试刷新token');
    print('   - 如果刷新失败或重试次数过多，会自动跳转登录页');

    // 模拟业务错误测试
    print('3. 响应拦截器已配置业务错误处理');
    print('   - 非200/201状态码会显示错误提示');
    print('   - 错误消息支持多语言显示');
  } catch (e) {
    print('响应拦截器测试出错: $e');
  }

  print('=== 响应拦截器测试完成 ===\n');
}
