import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';

class ProfilePage extends StatelessWidget {
  // Get.find<T>() - 依赖查找：从GetX容器中获取AuthService实例
  // 这里直接获取已注册的AuthService，不需要创建新实例
  final AuthService _authService = Get.find<AuthService>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我的'),
        backgroundColor: Colors.orange,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.orange.shade50, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 用户信息卡片
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange.shade600, Colors.orange.shade800],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16),
                    // Obx() - 响应式Widget：监听_authService.username的变化
                    // 当用户名发生变化时，这个Text会自动更新显示
                    Obx(() => Text(
                      _authService.username.isNotEmpty ? _authService.username : '投资达人',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                    SizedBox(height: 8),
                    // Obx() - 另一个响应式Widget：监听token变化
                    // 当token变化时，用户ID显示会自动更新
                    Obx(() => Text(
                      '用户ID：${_authService.token.isNotEmpty ? _authService.token.substring(0, 8) + '...' : '未登录'}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                      ),
                    )),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatItem('关注', '128'),
                        _buildStatItem('粉丝', '256'),
                        _buildStatItem('获赞', '1.2K'),
                      ],
                    ),
                  ],
                ),
              ),
              
              // 功能菜单
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildMenuItem(
                      icon: Icons.account_balance_wallet,
                      title: '我的资产',
                      subtitle: '查看资产详情',
                      color: Colors.blue,
                    ),
                    _buildDivider(),
                    _buildMenuItem(
                      icon: Icons.history,
                      title: '交易记录',
                      subtitle: '查看历史交易',
                      color: Colors.green,
                    ),
                    _buildDivider(),
                    _buildMenuItem(
                      icon: Icons.favorite,
                      title: '我的收藏',
                      subtitle: '收藏的股票和基金',
                      color: Colors.red,
                    ),
                    _buildDivider(),
                    _buildMenuItem(
                      icon: Icons.notifications,
                      title: '消息通知',
                      subtitle: '系统消息和提醒',
                      color: Colors.orange,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              
              // 工具菜单
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildMenuItem(
                      icon: Icons.help,
                      title: '帮助中心',
                      subtitle: '常见问题解答',
                      color: Colors.purple,
                    ),
                    _buildDivider(),
                    _buildMenuItem(
                      icon: Icons.feedback,
                      title: '意见反馈',
                      subtitle: '提交建议和问题',
                      color: Colors.teal,
                    ),
                    _buildDivider(),
                    _buildMenuItem(
                      icon: Icons.info,
                      title: '关于我们',
                      subtitle: '版本信息和联系方式',
                      color: Colors.indigo,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              
              // 退出登录按钮
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  onPressed: () {
                    _showLogoutDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade50,
                    foregroundColor: Colors.red,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.red.shade200),
                    ),
                  ),
                  child: Text(
                    '退出登录',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: color,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.grey.shade800,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade600,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.grey.shade400,
      ),
      onTap: () {
        // 处理点击事件
      },
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      indent: 72,
      color: Colors.grey.shade100,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('确认退出'),
          content: Text('您确定要退出登录吗？'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('取消'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                // 处理退出登录逻辑
                await _authService.logout();
                
                // Get.snackbar() - 显示退出成功提示
                // 退出登录后，AuthWrapper中的Obx会自动检测到状态变化并跳转到登录页
                Get.snackbar(
                  '退出成功',
                  '已退出登录',
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.TOP,
                );
              },
              child: Text(
                '确认',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
