import 'package:flutter/material.dart';

class MarketPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('行情'),
        backgroundColor: Colors.green,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green.shade50, Colors.white],
          ),
        ),
        child: Column(
          children: [
            // 市场指数概览
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(16),
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
                  Text(
                    '主要指数',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildIndexCard('上证指数', '3,245.67', '+1.23%', Colors.red),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildIndexCard('深证成指', '12,456.78', '+0.89%', Colors.red),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildIndexCard('创业板指', '2,678.90', '-0.45%', Colors.green),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildIndexCard('科创50', '1,234.56', '+2.15%', Colors.red),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // 股票列表
            Expanded(
              child: Container(
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
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '热门股票',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          Text(
                            '实时更新',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          final stocks = [
                            {'name': '平安银行', 'code': '000001', 'price': '12.45', 'change': '+0.23', 'percent': '+1.88%', 'color': Colors.red},
                            {'name': '万科A', 'code': '000002', 'price': '18.67', 'change': '-0.12', 'percent': '-0.64%', 'color': Colors.green},
                            {'name': '中国平安', 'code': '601318', 'price': '45.23', 'change': '+0.89', 'percent': '+2.01%', 'color': Colors.red},
                            {'name': '招商银行', 'code': '600036', 'price': '38.90', 'change': '+0.45', 'percent': '+1.17%', 'color': Colors.red},
                            {'name': '五粮液', 'code': '000858', 'price': '156.78', 'change': '-2.34', 'percent': '-1.47%', 'color': Colors.green},
                            {'name': '贵州茅台', 'code': '600519', 'price': '1,678.90', 'change': '+12.45', 'percent': '+0.75%', 'color': Colors.red},
                            {'name': '比亚迪', 'code': '002594', 'price': '234.56', 'change': '+5.67', 'percent': '+2.48%', 'color': Colors.red},
                            {'name': '宁德时代', 'code': '300750', 'price': '189.23', 'change': '-3.45', 'percent': '-1.79%', 'color': Colors.green},
                            {'name': '腾讯控股', 'code': '00700', 'price': '345.67', 'change': '+8.90', 'percent': '+2.64%', 'color': Colors.red},
                            {'name': '阿里巴巴', 'code': '09988', 'price': '89.12', 'change': '-1.23', 'percent': '-1.36%', 'color': Colors.green},
                          ];
                          
                          final stock = stocks[index];
                          return _buildStockItem(
                            stock['name'] as String,
                            stock['code'] as String,
                            stock['price'] as String,
                            stock['change'] as String,
                            stock['percent'] as String,
                            stock['color'] as Color,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndexCard(String name, String value, String change, Color changeColor) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          SizedBox(height: 2),
          Text(
            change,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: changeColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockItem(String name, String code, String price, String change, String percent, Color changeColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade100),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade800,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  code,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      change,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: changeColor,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      percent,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: changeColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
