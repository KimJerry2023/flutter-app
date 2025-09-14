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
  Future<void> _loadAuthData() async {
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
  Future<bool> login(String username, String password) async {
    try {
      // 模拟登录API调用
      await Future.delayed(Duration(seconds: 1));
      
      // 简单的验证逻辑（实际项目中应该调用真实的API）
      if (username.isNotEmpty && password.isNotEmpty) {
        // 生成模拟token
        final token = 'token_${DateTime.now().millisecondsSinceEpoch}';
        
        // 保存到本地存储
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
      print('登录失败: $e');
      return false;
    }
  }
  
  // 注册
  Future<bool> register(String username, String password, String confirmPassword) async {
    try {
      // 模拟注册API调用
      await Future.delayed(Duration(seconds: 1));
      
      // 简单的验证逻辑
      if (username.isNotEmpty && password.isNotEmpty && password == confirmPassword) {
        // 生成模拟token
        final token = 'token_${DateTime.now().millisecondsSinceEpoch}';
        
        // 保存到本地存储
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
      print('注册失败: $e');
      return false;
    }
  }
  
  // 退出登录
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('username');
      
      // 退出登录时清空所有响应式状态
      // 这些变化会自动触发UI更新，用户会看到登录界面
      _token.value = '';
      _username.value = '';
      _isLoggedIn.value = false;
    } catch (e) {
      print('退出登录失败: $e');
    }
  }
  
  // 检查token是否有效
  bool isTokenValid() {
    return _token.value.isNotEmpty && _isLoggedIn.value;
  }
}
