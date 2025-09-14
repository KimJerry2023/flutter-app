import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'services/auth_service.dart';
import 'services/request_service.dart';
import 'pages/login_page.dart';
import 'widgets/layout.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get.put() - 依赖注入：将服务实例注册到GetX的依赖注入容器中
    // 这样在整个应用中都可以通过Get.find()来获取这个实例
    // 相当于单例模式，确保整个应用只有一个服务实例
    Get.put(AuthService());
    Get.put(RequestService());
    
    // GetMaterialApp - GetX提供的MaterialApp替代品
    // 它包含了MaterialApp的所有功能，并添加了GetX的路由管理功能
    // 支持Get.to(), Get.off(), Get.offAll()等路由导航方法
    return GetMaterialApp(
      title: '投资理财App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AuthWrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get.find<T>() - 依赖查找：从GetX容器中获取指定类型的实例
    // 这里获取之前通过Get.put()注册的AuthService实例
    // 如果找不到会抛出异常，确保服务已正确注册
    final AuthService authService = Get.find<AuthService>();
    
    // Obx() - 响应式Widget：监听observable变量的变化并自动重建UI
    // 当authService中的任何observable变量（如_isLoggedIn）发生变化时，
    // Obx会自动重新执行build方法，实现响应式UI更新
    return Obx(() {
      // 根据登录状态显示不同页面
      if (authService.isLoggedIn) {
        return MainLayout();
      } else {
        return LoginPage();
      }
    });
  }
}

