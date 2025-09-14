import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';
import 'register_page.dart';
import '../widgets/layout.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  // Get.put() - 依赖注入：获取或创建AuthService实例
  // 如果AuthService已经存在，则返回现有实例；否则创建新实例
  // 这里用于获取认证服务实例来处理登录逻辑
  final AuthService _authService = Get.put(AuthService());
  
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await _authService.login(
        _usernameController.text.trim(),
        _passwordController.text,
      );

      if (success) {
        // Get.offAll() - 导航到新页面并清除所有之前的页面
        // 相当于Navigator.pushAndRemoveUntil，确保用户无法返回到登录页面
        Get.offAll(() => MainLayout());
        
        // Get.snackbar() - 显示底部消息提示
        // 比Flutter原生的SnackBar更简单易用，支持更多自定义选项
        Get.snackbar(
          '登录成功',
          '欢迎回来！',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      } else {
        // 登录失败时显示错误提示
        // Get.snackbar支持多种位置和样式配置
        Get.snackbar(
          '登录失败',
          '用户名或密码错误',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      // 异常处理：显示网络错误提示
      // Get.snackbar会自动处理显示和隐藏逻辑
      Get.snackbar(
        '登录失败',
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
            colors: [
              Colors.blue.shade600,
              Colors.blue.shade800,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo和标题
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.trending_up,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 32),
                  Text(
                    '投资理财',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '让财富增值，让生活更美好',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  SizedBox(height: 48),
                  
                  // 登录表单
                  Container(
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            '登录账户',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 32),
                          
                          // 用户名输入框
                          TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: '用户名',
                              prefixIcon: Icon(Icons.person_outline),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '请输入用户名';
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
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
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
                          SizedBox(height: 24),
                          
                          // 登录按钮
                          ElevatedButton(
                            onPressed: _isLoading ? null : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade600,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: _isLoading
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : Text(
                                    '登录',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                          SizedBox(height: 16),
                          
                          // 注册链接
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '还没有账户？',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Get.to() - 导航到新页面
                                  // 相当于Navigator.push，支持返回上一页
                                  Get.to(() => RegisterPage());
                                },
                                child: Text(
                                  '立即注册',
                                  style: TextStyle(
                                    color: Colors.blue.shade600,
                                    fontWeight: FontWeight.w600,
                                  ),
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
