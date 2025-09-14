import 'package:flutter/material.dart';

// 基础组件页面
class BasicWidgetsPage extends StatelessWidget {
  const BasicWidgetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('基础组件'),
        centerTitle: true,
        backgroundColor: Theme.of(
          context,
        ).colorScheme.inversePrimary, // 使用主题色的反色作为背景
      ),
      body: ListView(
        padding: const EdgeInsets.all(16), // 内边距，四周各16像素
        children: [
          // Text widget组件
          _buildWidgetSection(context, 'Text widget组件', '用于显示文本内容，支持样式设置', [
            const Text(
              '这是普通文本',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const Text(
              '这是加粗文本',
              style: TextStyle(
                fontSize: 18,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              '这是斜体文本',
              style: TextStyle(
                fontSize: 18,
                color: Colors.green,
                fontStyle: FontStyle.italic,
              ),
            ),
            RichText(
              text: const TextSpan(
                text: '这是富文本',
                style: TextStyle(fontSize: 20, color: Colors.red),
                children: [
                  TextSpan(
                    text: '这是富文本的子文本',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ]),
          const SizedBox(height: 20), // 添加20像素的间距
          // Container组件
          _buildWidgetSection(context, 'Container组件', '用于布局和装饰子组件，支持样式设置', [
            Container(
              width: 100,
              height: 100,
              color: Colors.red,
              child: const Center(
                child: Text(
                  '红色容器',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
            Container(
              width: 120,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey, // 灰色阴影
                    blurRadius: 5, // 模糊半径
                    offset: const Offset(2, 2), // 偏移量
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  '圆角阴影',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
            Container(
              width: 150,
              height: 60,
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.green], // 渐变色
                  begin: Alignment.topLeft, // 渐变开始位置
                  end: Alignment.bottomRight, // 渐变结束位置
                ),
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: const Center(
                child: Text(
                  '渐变色',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ]),
          const SizedBox(height: 20), // 添加20像素的间距
          // Icon widget组件
          _buildWidgetSection(
            context,
            'Icon widget组件',
            '显示 Material Design 图标',
            [
              const Icon(Icons.home, size: 40, color: Colors.blue),
              const Icon(Icons.favorite, size: 40, color: Colors.red),
              const Icon(Icons.person, size: 40, color: Colors.green),
              const Icon(Icons.settings, size: 40, color: Colors.purple),
              const Icon(Icons.search, size: 40, color: Colors.orange),
            ],
          ),
          const SizedBox(height: 20), // 添加20像素的间距
          // Image widget组件
          _buildWidgetSection(context, 'Image widget组件', '显示图片', [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              child: const Icon(Icons.image, size: 50, color: Colors.grey),
            ),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              child: const Icon(Icons.image, size: 50, color: Colors.grey),
            ),
            Container(
              width: 120,
              height: 80,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10), // 圆角边框
              ),
              child: const ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)), // 裁剪圆角
                child: Icon(
                  Icons.photo, // 照片图标
                  size: 40,
                  color: Colors.grey,
                ),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  // 构建Widget展示区域的辅助方法
  Widget _buildWidgetSection(
    BuildContext context,
    String title,
    String description,
    List<Widget> widgets,
  ) {
    return Card(
      elevation: 4,
      margin: const EdgeInsetsGeometry.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary, // 使用主题色
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16, // 水平间距16像素
              runSpacing: 16, // 垂直间距16像素
              children: widgets, // 子组件列表
            ),
          ],
        ),
      ),
    );
  }
}
