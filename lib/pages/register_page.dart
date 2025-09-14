import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';
import 'login_page.dart';
import '../widgets/layout.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _inviteCodeController = TextEditingController();
  // Get.put() - 依赖注入：获取或创建AuthService实例
  // 与登录页面相同，这里获取认证服务来处理注册逻辑
  final AuthService _authService = Get.put(AuthService());

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _inviteCodeController.dispose();
    super.dispose();
  }

  // 处理注册逻辑
  // Future<void> - 异步方法，不返回具体值，只表示注册操作完成
  // async关键字使方法可以执行异步操作，如网络请求、数据库操作等
  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // await关键字等待异步操作完成
      // _authService.register()返回Future<bool>，表示注册是否成功
      // 这里等待注册结果，然后根据结果进行相应的UI处理
      final success = await _authService.register(
        _usernameController.text.trim(),
        _passwordController.text,
        _confirmPasswordController.text,
      );

      if (success) {
        // Get.offAll() - 注册成功后清除所有页面栈，直接进入主界面
        // 防止用户返回到注册页面
        Get.offAll(() => MainLayout());

        // Get.snackbar() - 显示注册成功提示
        // 使用绿色背景表示成功状态
        Get.snackbar(
          '注册成功',
          '欢迎加入我们！',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      } else {
        // 注册失败时显示错误提示
        // 红色背景表示错误状态
        Get.snackbar(
          '注册失败',
          '用户名已存在或密码不匹配',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      // 异常处理：显示网络错误提示
      // Get.snackbar提供统一的错误提示样式
      Get.snackbar(
        '注册失败',
        '网络错误，请重试',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade600, Colors.blue.shade800],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Logo和标题
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                    child: Icon(Icons.trending_up, size: 50, color: Colors.white),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '投资理财',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  Text('让财富增值，让生活更美好', style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.8))),
                  SizedBox(height: 48),

                  // 注册表单
                  Container(
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: Offset(0, 10)),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            '创建账户',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 32),

                          // 用户名输入框
                          TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: '用户名',
                              prefixIcon: Icon(Icons.person_outline),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '请输入用户名';
                              }
                              if (value.length < 3) {
                                return '用户名至少3位';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),

                          // 密码输入框
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: '密码',
                              prefixIcon: Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '请输入密码';
                              }
                              if (value.length < 6) {
                                return '密码至少6位';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),

                          // 确认密码输入框
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirmPassword,
                            decoration: InputDecoration(
                              labelText: '确认密码',
                              prefixIcon: Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword = !_obscureConfirmPassword;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '请确认密码';
                              }
                              if (value != _passwordController.text) {
                                return '两次输入的密码不一致';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),

                          // 邀请码输入框（可选）
                          TextFormField(
                            controller: _inviteCodeController,
                            decoration: InputDecoration(
                              labelText: '邀请码（可选）',
                              prefixIcon: Icon(Icons.card_giftcard_outlined),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                            ),
                            // 邀请码是可选的，不需要验证
                          ),
                          SizedBox(height: 24),

                          // 注册按钮
                          ElevatedButton(
                            onPressed: _isLoading ? null : _handleRegister,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade600,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                            child: _isLoading
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : Text('注册', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          ),
                          SizedBox(height: 16),

                          // 登录链接
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('已有账户？', style: TextStyle(color: Colors.grey.shade600)),
                              TextButton(
                                onPressed: () {
                                  // Get.to() - 导航到登录页面
                                  // 用户可以返回到注册页面
                                  Get.to(() => LoginPage());
                                },
                                child: Text(
                                  '立即登录',
                                  style: TextStyle(color: Colors.blue.shade600, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
