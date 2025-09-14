import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

// GetxController - GetX状态管理的基础控制器类
// 继承GetxController后，这个类就具备了响应式状态管理能力
// 可以管理observable变量，处理生命周期方法，以及提供依赖注入功能
class AuthService extends GetxController {
  // 静态getter - 提供全局访问AuthService实例的便捷方法
  // Get.find()会从GetX的依赖注入容器中查找AuthService实例
  static AuthService get instance => Get.find();
  
  // RxBool - 响应式布尔变量，使用.obs扩展方法创建
  // 当值发生变化时，所有监听这个变量的Obx()Widget会自动重建
  final RxBool _isLoggedIn = false.obs;
  
  // RxString - 响应式字符串变量
  // 同样具备响应式特性，值变化时会通知所有监听者
  final RxString _token = ''.obs;
  final RxString _username = ''.obs;
  
  // Getter方法 - 提供对私有observable变量的只读访问
  // 通过.value属性获取observable变量的当前值
  bool get isLoggedIn => _isLoggedIn.value;
  String get token => _token.value;
  String get username => _username.value;
  
  // onInit() - GetxController的生命周期方法
  // 在控制器初始化时调用，类似于StatefulWidget的initState()
  // 这里用于加载本地存储的认证数据
  @override
  void onInit() {
    super.onInit();
    _loadAuthData();
  }
  
  // 加载本地存储的认证数据
  // Future<void> - 异步方法，返回一个Future对象，表示一个可能在未来完成的操作
  // async关键字使方法可以执行异步操作，如文件I/O、网络请求等
  Future<void> _loadAuthData() async {
    // await关键字用于等待异步操作完成
    // SharedPreferences.getInstance()返回Future<SharedPreferences>，需要等待获取实例
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';
    final username = prefs.getString('username') ?? '';
    
    if (token.isNotEmpty) {
      // 从本地存储恢复认证状态时，更新响应式变量
      // 这会触发UI自动更新，显示已登录状态
      _token.value = token;
      _username.value = username;
      _isLoggedIn.value = true;
    }
  }
  
  // 登录
  // Future<bool> - 异步方法，返回Future<bool>，表示登录操作的结果（成功/失败）
  // 调用者可以使用await等待结果，或使用.then()处理结果
  Future<bool> login(String username, String password) async {
    try {
      // 模拟登录API调用
      // Future.delayed() - 创建一个延迟的Future，用于模拟网络请求的延迟
      // 在实际应用中，这里应该是真实的HTTP API调用
      await Future.delayed(Duration(seconds: 1));
      
      // 简单的验证逻辑（实际项目中应该调用真实的API）
      if (username.isNotEmpty && password.isNotEmpty) {
        // 生成模拟token
        final token = 'token_${DateTime.now().millisecondsSinceEpoch}';
        
        // 保存到本地存储
        // SharedPreferences的setString方法返回Future<bool>，表示保存操作是否成功
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        await prefs.setString('username', username);
        
        // 更新响应式状态 - 通过.value属性赋值会触发所有监听这些变量的Obx()Widget重建
        // 这是GetX响应式编程的核心：数据变化自动驱动UI更新
        _token.value = token;
        _username.value = username;
        _isLoggedIn.value = true;
        
        return true;
      }
      return false;
    } catch (e) {
      // 异常处理 - 如果异步操作中发生异常，会被catch块捕获
      // 这确保了方法总是返回一个值，而不是抛出异常
      print('登录失败: $e');
      return false;
    }
  }
  
  // 注册
  // Future<bool> - 异步方法，返回Future<bool>，表示注册操作的结果（成功/失败）
  // 与login方法类似，但包含额外的密码确认验证
  Future<bool> register(String username, String password, String confirmPassword) async {
    try {
      // 模拟注册API调用
      // Future.delayed() - 模拟网络延迟，实际应用中替换为真实的API调用
      await Future.delayed(Duration(seconds: 1));
      
      // 简单的验证逻辑
      if (username.isNotEmpty && password.isNotEmpty && password == confirmPassword) {
        // 生成模拟token
        final token = 'token_${DateTime.now().millisecondsSinceEpoch}';
        
        // 保存到本地存储
        // 多个await操作按顺序执行，每个都等待前一个完成
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        await prefs.setString('username', username);
        
        // 更新响应式状态 - 注册成功后同样更新observable变量
        // 触发UI自动更新，用户界面会立即反映登录状态的变化
        _token.value = token;
        _username.value = username;
        _isLoggedIn.value = true;
        
        return true;
      }
      return false;
    } catch (e) {
      // 异常处理 - 捕获异步操作中可能发生的任何异常
      print('注册失败: $e');
      return false;
    }
  }
  
  // 退出登录
  // Future<void> - 异步方法，不返回具体值，只表示操作完成
  // 用于清理用户数据和重置应用状态
  Future<void> logout() async {
    try {
      // 获取SharedPreferences实例，用于删除本地存储的数据
      final prefs = await SharedPreferences.getInstance();
      // 删除认证相关的本地数据
      // remove方法返回Future<bool>，表示删除操作是否成功
      await prefs.remove('auth_token');
      await prefs.remove('username');
      
      // 退出登录时清空所有响应式状态
      // 这些变化会自动触发UI更新，用户会看到登录界面
      _token.value = '';
      _username.value = '';
      _isLoggedIn.value = false;
    } catch (e) {
      // 异常处理 - 即使删除操作失败，也要确保状态被重置
      print('退出登录失败: $e');
    }
  }
  
  // 检查token是否有效
  bool isTokenValid() {
    return _token.value.isNotEmpty && _isLoggedIn.value;
  }
  
  /// 设置token（用于token刷新）
  Future<void> setToken(String newToken) async {
    _token.value = newToken;
    
    // 保存到本地存储
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', newToken);
    
    // 如果设置了新token，则认为用户已登录
    if (newToken.isNotEmpty) {
      _isLoggedIn.value = true;
    }
  }
  
  /// 清除认证信息（用于登录过期处理）
  Future<void> clearAuth() async {
    await logout();
  }
}
