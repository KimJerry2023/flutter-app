import 'package:flutter/material.dart';

class FinancePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('理财'),
        backgroundColor: Colors.purple,
        elevation: 0,
        actions: [IconButton(icon: Icon(Icons.history), onPressed: () {})],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple.shade50, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 资产概览
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.purple.shade600, Colors.purple.shade800]),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.purple.withOpacity(0.3), blurRadius: 10, offset: Offset(0, 5))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('总资产', style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 16)),
                    SizedBox(height: 8),
                    Text(
                      '¥128,456.78',
                      style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('今日收益', style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14)),
                            Text(
                              '+¥1,234.56',
                              style: TextStyle(color: Colors.green.shade300, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('累计收益', style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14)),
                            Text(
                              '+¥12,456.78',
                              style: TextStyle(color: Colors.green.shade300, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              // 理财产品分类
              Text(
                '理财产品',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
              ),
              SizedBox(height: 16),

              // 产品分类标签
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryChip('全部', true),
                    SizedBox(width: 8),
                    _buildCategoryChip('货币基金', false),
                    SizedBox(width: 8),
                    _buildCategoryChip('债券基金', false),
                    SizedBox(width: 8),
                    _buildCategoryChip('股票基金', false),
                    SizedBox(width: 8),
                    _buildCategoryChip('混合基金', false),
                  ],
                ),
              ),
              SizedBox(height: 16),

              // 理财产品列表
              Column(
                children: [
                  _buildFinanceProduct('余额宝', '货币基金', '2.35%', '7日年化', '低风险', Colors.blue, '¥10,000起购'),
                  SizedBox(height: 12),
                  _buildFinanceProduct('招商银行理财', '债券基金', '3.85%', '预期年化', '中低风险', Colors.green, '¥50,000起购'),
                  SizedBox(height: 12),
                  _buildFinanceProduct('华夏成长基金', '股票基金', '8.45%', '近1年收益', '中高风险', Colors.orange, '¥1,000起购'),
                  SizedBox(height: 12),
                  _buildFinanceProduct('易方达蓝筹', '混合基金', '12.67%', '近1年收益', '中高风险', Colors.purple, '¥1,000起购'),
                ],
              ),
              SizedBox(height: 24),

              // 我的持仓
              Text(
                '我的持仓',
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
                    _buildHoldingItem(
                      key: ValueKey('holding_yuebao'),
                      name: '余额宝',
                      amount: '¥25,000.00',
                      profit: '+¥156.78',
                      percent: '+0.63%',
                      profitColor: Colors.green,
                    ),
                    Divider(),
                    _buildHoldingItem(
                      key: ValueKey('holding_cmb'),
                      name: '招商银行理财',
                      amount: '¥50,000.00',
                      profit: '+¥1,234.56',
                      percent: '+2.47%',
                      profitColor: Colors.green,
                    ),
                    Divider(),
                    _buildHoldingItem(
                      key: ValueKey('holding_huaxia'),
                      name: '华夏成长基金',
                      amount: '¥15,000.00',
                      profit: '-¥234.56',
                      percent: '-1.56%',
                      profitColor: Colors.red,
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

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.purple : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey.shade700,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildFinanceProduct(
    String name,
    String type,
    String rate,
    String rateType,
    String risk,
    Color color,
    String minAmount,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(Icons.account_balance_wallet, color: color, size: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
                ),
                SizedBox(height: 4),
                Text(type, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                SizedBox(height: 4),
                Text(minAmount, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                rate,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
              ),
              Text(rateType, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              SizedBox(height: 4),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                child: Text(
                  risk,
                  style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHoldingItem({
    Key? key,
    required String name,
    required String amount,
    required String profit,
    required String percent,
    required Color profitColor,
  }) {
    return Padding(
      key: key,
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey.shade800),
              ),
              Text(amount, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                profit,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: profitColor),
              ),
              Text(percent, style: TextStyle(fontSize: 14, color: profitColor)),
            ],
          ),
        ],
      ),
    );
  }
}
