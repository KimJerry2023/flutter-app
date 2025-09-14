# Flutter开发环境配置完成

## ✅ 已完成的配置

### 1. VSCode调试配置 (`.vscode/launch.json`)
- **Flutter Debug (Hot Reload)** - 支持热重载的调试模式
- **Flutter Profile Mode** - 性能分析模式
- **Flutter Release Mode** - 发布版本调试
- **Flutter Web Debug** - Web开发调试
- **Flutter Desktop** - 桌面应用调试（Windows/Linux/macOS）

### 2. 任务配置 (`.vscode/tasks.json`)
- Flutter Clean - 清理项目
- Get Dependencies - 获取依赖
- Analyze - 代码分析
- Build APK - 构建应用
- Run Tests - 运行测试
- Format Code - 格式化代码

### 3. 工作区设置 (`.vscode/settings.json`)
- **自动热重载** - 保存文件时自动热重载
- **代码格式化** - 保存时自动格式化
- **文件排除** - 排除不需要的文件和目录
- **调试优化** - 优化调试体验

### 4. 扩展推荐 (`.vscode/extensions.json`)
- Dart & Flutter 扩展
- 代码质量工具
- Git支持
- 主题和图标
- 实用工具

### 5. 代码分析配置 (`analysis_options.yaml`)
- 完整的代码规范配置
- 性能优化建议
- Flutter特定规则
- 静态分析优化

### 6. 快速启动脚本
- `start_flutter.bat` - Windows批处理脚本
- `start_flutter.ps1` - PowerShell脚本

## 🚀 使用方法

### 方法一：使用VSCode（推荐）
1. 打开VSCode
2. 按 `F5` 开始调试
3. 选择 "Flutter Debug (Hot Reload)"
4. 修改代码后按 `Ctrl+S` 保存，自动热重载

### 方法二：使用启动脚本
```bash
# Windows批处理
start_flutter.bat

# PowerShell
.\start_flutter.ps1
```

### 方法三：命令行
```bash
# 获取依赖
flutter pub get

# 启动调试模式
flutter run --debug

# 启动Web版本
flutter run -d web-server --web-port=3000
```

## 🔥 热重载功能

### 自动热重载
- 修改代码并保存（`Ctrl+S`）
- 应用会自动重新加载，无需手动操作

### 手动控制
- `r` - 热重载
- `R` - 热重启
- `q` - 退出调试

### 热重载限制
以下情况需要热重启：
- 修改 `main()` 函数
- 修改全局变量初始化
- 修改枚举类型
- 添加/删除依赖包

## 📱 支持的平台

- **Android** - 移动端调试
- **iOS** - 移动端调试（需要macOS）
- **Web** - 浏览器调试
- **Windows** - 桌面应用
- **Linux** - 桌面应用
- **macOS** - 桌面应用（需要macOS）

## 🛠️ 开发工具

### 快捷键
- `F5` - 开始调试
- `Shift+F5` - 停止调试
- `Ctrl+F5` - 运行（不调试）
- `Ctrl+Shift+P` - 命令面板
- `Ctrl+S` - 保存并热重载

### 命令面板常用命令
- `Flutter: Select Device` - 选择设备
- `Flutter: Launch Emulator` - 启动模拟器
- `Tasks: Run Task` - 运行任务
- `Dart: Restart Analysis Server` - 重启分析服务器

## 📊 代码质量

### 自动检查
- 保存时自动分析代码
- 实时显示错误和警告
- 自动格式化代码

### 手动检查
```bash
# 代码分析
flutter analyze

# 格式化代码
dart format lib

# 运行测试
flutter test
```

## 🔧 故障排除

### 常见问题
1. **热重载不工作** - 尝试热重启（按 `R`）
2. **设备连接失败** - 检查 `flutter devices`
3. **依赖问题** - 运行 `flutter clean && flutter pub get`
4. **分析服务器错误** - 重启VSCode或Dart分析服务器

### 环境检查
```bash
# 检查Flutter环境
flutter doctor -v

# 检查设备连接
flutter devices

# 检查依赖
flutter pub deps
```

## 📚 相关文档

- [VSCode配置说明](.vscode/README.md)
- [Flutter官方文档](https://flutter.dev/docs)
- [Dart语言指南](https://dart.dev/guides)

---

**配置完成！** 现在你可以享受高效的Flutter开发体验了。🎉
