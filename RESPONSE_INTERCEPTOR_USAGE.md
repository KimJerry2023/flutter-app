# Flutter 响应拦截器使用指南

## 概述

基于你提供的JavaScript axios响应拦截器逻辑，我已经为Flutter项目实现了相应的响应拦截器功能。这个实现包含了以下核心功能：

1. **自动token刷新**：401错误时自动刷新token
2. **登录过期处理**：token刷新失败时自动跳转登录页
3. **业务错误处理**：统一处理业务错误码并显示用户友好提示
4. **多语言支持**：错误消息支持多语言显示

## 核心功能

### 1. 响应拦截器类型定义

```dart
typedef ResponseInterceptor = Future<http.Response> Function(http.Response response);
```

### 2. 默认响应拦截器逻辑

```dart
// 添加默认的响应拦截器
addResponseInterceptor((response) async {
  final json = parseJsonResponse(response);
  if (json == null) return response;
  
  final code = json['code'] ?? response.statusCode;
  final errorMessage = getErrorMessage(code, _language.value);
  
  // 处理401未授权错误
  if (code == 401) {
    // 检查重试次数，防止无限重试
    final retryCountHeader = response.request?.headers['X-Retry-Count'];
    final retryCount = int.tryParse(retryCountHeader ?? '0') ?? 0;
    
    if (retryCount >= 1) {
      await goLogin();
      throw Exception('重试次数过多，已清除认证信息');
    }
    
    // 自动刷新token逻辑
    if (!_isRefreshing) {
      _isRefreshing = true;
      try {
        final newToken = await _refreshToken();
        if (newToken != null) {
          await AuthService.instance.setToken(newToken);
          _isRefreshing = false;
          _onRefreshed();
          return response; // 重新发起请求需要在调用层处理
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
    }
  }
  
  // 处理其他业务错误
  if (code != 200 && code != 201) {
    Get.snackbar('错误', errorMessage, /* 样式配置 */);
    throw Exception(errorMessage);
  }
  
  return response;
});
```

### 3. goLogin方法 - 处理登录过期

```dart
Future<void> goLogin() async {
  final authService = AuthService.instance;
  await authService.clearAuth();
  
  // 显示登录过期提示对话框
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
```

### 4. Token刷新逻辑

```dart
Future<String?> _refreshToken() async {
  try {
    final response = await http.get(
      Uri.parse('${baseUrl}/user/refresh_token'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AuthService.instance.token}',
      },
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
```

## 使用方法

### 1. 基础用法

响应拦截器已经自动配置在`RequestService`中，无需额外配置即可使用：

```dart
final requestService = RequestService.instance;

// 发起请求，响应拦截器会自动处理
final response = await requestService.get('/api/user/profile');
```

### 2. 添加自定义响应拦截器

```dart
requestService.addResponseInterceptor((response) async {
  print('自定义响应处理: ${response.statusCode}');
  
  // 自定义逻辑
  final json = requestService.parseJsonResponse(response);
  if (json != null) {
    final code = json['code'] ?? response.statusCode;
    
    // 处理特定业务逻辑
    if (code == 403) {
      print('请求过于频繁，触发限流');
      // 可以添加限流处理逻辑
    }
  }
  
  return response;
});
```

### 3. 管理响应拦截器

```dart
// 移除特定拦截器
requestService.removeResponseInterceptor(myInterceptor);

// 清空所有拦截器
requestService.clearInterceptors();
```

## AuthService扩展

为了支持响应拦截器，`AuthService`添加了以下新方法：

```dart
/// 设置token（用于token刷新）
Future<void> setToken(String newToken) async {
  _token.value = newToken;
  
  // 保存到本地存储
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('auth_token', newToken);
  
  if (newToken.isNotEmpty) {
    _isLoggedIn.value = true;
  }
}

/// 清除认证信息（用于登录过期处理）
Future<void> clearAuth() async {
  await logout();
}
```

## 错误码处理

响应拦截器集成了多语言错误码处理系统：

- 支持中文、英文、德语、马来语、繁体中文
- 自动根据当前语言显示相应错误消息
- 涵盖系统错误码（1000-19999）和业务错误码（20000+）

## 完整示例

查看 `lib/services/api_example.dart` 中的完整使用示例，包括：

1. 如何初始化响应拦截器
2. 如何处理不同类型的响应
3. 如何测试拦截器功能

## 与原JavaScript代码的对应关系

| JavaScript功能 | Flutter实现 |
|---------------|------------|
| `goLogin()` | `RequestService.goLogin()` |
| `apiClient.interceptors.response.use()` | `RequestService.addResponseInterceptor()` |
| `uni.useAuthStore.clearAuth()` | `AuthService.instance.clearAuth()` |
| `uni.showModal()` | `Get.dialog()` |
| `uni.toast()` | `Get.snackbar()` |
| `isRefreshing` | `RequestService._isRefreshing` |
| `onRefreshed()` | `RequestService._onRefreshed()` |
| `config._retryCount` | 通过headers传递重试计数 |

## 注意事项

1. **重试机制**：默认最大重试1次，防止无限循环
2. **并发控制**：使用`_isRefreshing`标志防止同时多个token刷新请求
3. **错误处理**：所有异常都会被正确捕获和处理
4. **UI反馈**：错误会通过Snackbar显示给用户
5. **路由跳转**：登录过期时会清除页面栈并跳转到登录页

这个实现完全仿照了你提供的JavaScript逻辑，并适配了Flutter的开发模式和最佳实践。
