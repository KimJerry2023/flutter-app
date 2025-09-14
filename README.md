# Flutter开发环境配置说明

本项目已配置完整的Flutter开发环境，支持热加载、调试和代码质量检查。

## 🚀 快速开始

### 1. 安装推荐扩展
打开VSCode时，会自动提示安装推荐的扩展，包括：
- Dart & Flutter 扩展
- 代码格式化工具
- Git支持
- 主题和图标

### 2. 启动调试
使用以下方式之一启动应用：

#### 方法一：使用调试面板
1. 按 `F5` 或点击调试面板的"启动调试"
2. 选择调试配置：
   - **Flutter Debug (Hot Reload)** - 推荐用于开发
   - **Flutter Profile Mode** - 性能分析
   - **Flutter Release Mode** - 发布版本
   - **Flutter Web Debug** - Web开发
   - **Flutter Desktop** - 桌面应用

#### 方法二：使用命令面板
1. 按 `Ctrl+Shift+P` 打开命令面板
2. 输入 "Flutter: Select Device" 选择设备
3. 输入 "Flutter: Launch Emulator" 启动模拟器

## 🔥 热加载功能

### 自动热加载
- **保存时自动热重载**：修改代码并保存文件，应用会自动重新加载
- **无需重启**：大部分代码修改都能通过热重载完成，无需重启应用

### 手动热加载
- **热重载**：按 `Ctrl+S` 保存文件 或 按 `r` 键
- **热重启**：按 `R` 键（大写）
- **停止调试**：按 `Shift+F5`

### 热加载限制
以下情况需要热重启（按 `R`）：
- 修改 `main()` 函数
- 修改全局变量初始化
- 修改枚举类型
- 添加/删除依赖包

## 🛠️ 任务和命令

### 常用任务（Ctrl+Shift+P → Tasks: Run Task）
- **Flutter: Clean** - 清理项目
- **Flutter: Get Dependencies** - 获取依赖
- **Flutter: Analyze** - 代码分析
- **Flutter: Format Code** - 格式化代码
- **Flutter: Run Tests** - 运行测试
- **Flutter: Build APK** - 构建APK

### 快捷键
- `Ctrl+Shift+P` - 命令面板
- `F5` - 开始调试
- `Shift+F5` - 停止调试
- `Ctrl+F5` - 运行（不调试）
- `Ctrl+Shift+F5` - 重启调试

## 📁 项目结构

```
.vscode/
├── launch.json          # 调试配置
├── tasks.json           # 任务配置
├── settings.json        # 工作区设置
├── extensions.json      # 推荐扩展
└── README.md           # 本文档

lib/
├── main.dart           # 应用入口
├── pages/              # 页面文件
├── services/           # 服务层
└── widgets/            # 自定义组件
```

## ⚙️ 配置说明

### launch.json
- 配置多种调试模式
- 支持移动端、Web端、桌面端调试
- 启用热重载和VM服务

### settings.json
- 自动保存和格式化
- 热重载配置
- 文件排除规则
- 代码分析配置

### tasks.json
- Flutter常用命令
- 构建和测试任务
- 代码质量检查

### analysis_options.yaml
- 代码规范配置
- 静态分析规则
- 性能优化建议

## 🔧 故障排除

### 热加载不工作
1. 确保Flutter扩展已安装并启用
2. 检查设备连接状态
3. 尝试热重启（按 `R`）
4. 重启VSCode

### 调试器连接失败
1. 运行 `flutter doctor` 检查环境
2. 确保设备已连接并授权
3. 检查端口占用情况

### 代码分析错误
1. 运行 `flutter clean`
2. 运行 `flutter pub get`
3. 重启Dart分析服务器

## 📚 更多资源

- [Flutter官方文档](https://flutter.dev/docs)
- [Dart语言指南](https://dart.dev/guides)
- [VSCode Flutter扩展](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter)
- [Flutter热重载指南](https://flutter.dev/docs/development/tools/hot-reload)

## 🆘 获取帮助

如果遇到问题：
1. 查看VSCode输出面板的"Dart"和"Flutter"日志
2. 运行 `flutter doctor -v` 检查环境
3. 查看Flutter官方文档和社区论坛
4. 检查项目GitHub Issues

---

**提示**：首次运行项目时，Flutter会自动下载所需的依赖和工具，可能需要几分钟时间。
