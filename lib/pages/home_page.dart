import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('首页'), backgroundColor: Colors.blue, elevation: 0),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 欢迎卡片
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.blue.shade600, Colors.blue.shade800]),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 10, offset: Offset(0, 5))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '欢迎回来！',
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('今天是个投资的好日子', style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 16)),
                  ],
                ),
              ),
              SizedBox(height: 24),

              // 快捷功能
              Text(
                '快捷功能',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildQuickActionCard(icon: Icons.trending_up, title: '查看行情', color: Colors.green),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildQuickActionCard(
                      icon: Icons.account_balance_wallet,
                      title: '我的资产',
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildQuickActionCard(icon: Icons.savings, title: '理财产品', color: Colors.purple),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildQuickActionCard(icon: Icons.analytics, title: '数据分析', color: Colors.teal),
                  ),
                ],
              ),
              SizedBox(height: 24),

              // 市场概览
              Text(
                '市场概览',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 8, offset: Offset(0, 2))],
                ),
                child: Column(
                  children: [
                    _buildMarketItem(
                      key: ValueKey('market_shanghai'),
                      name: '上证指数',
                      value: '3,245.67',
                      change: '+1.23%',
                      changeColor: Colors.red,
                    ),
                    Divider(),
                    _buildMarketItem(
                      key: ValueKey('market_shenzhen'),
                      name: '深证成指',
                      value: '12,456.78',
                      change: '+0.89%',
                      changeColor: Colors.red,
                    ),
                    Divider(),
                    _buildMarketItem(
                      key: ValueKey('market_chinext'),
                      name: '创业板指',
                      value: '2,678.90',
                      change: '-0.45%',
                      changeColor: Colors.green,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionCard({required IconData icon, required String title, required Color color}) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: color, size: 24),
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketItem({
    Key? key,
    required String name,
    required String value,
    required String change,
    required Color changeColor,
  }) {
    return Padding(
      key: key,
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey.shade800),
          ),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
              ),
              SizedBox(width: 8),
              Text(
                change,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: changeColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
