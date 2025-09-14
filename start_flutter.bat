@echo off
echo ========================================
echo    Flutter投资理财App - 快速启动脚本
echo ========================================
echo.

echo [1/4] 检查Flutter环境...
flutter doctor --version
if %errorlevel% neq 0 (
    echo 错误：Flutter未安装或未配置到PATH环境变量
    echo 请先安装Flutter：https://flutter.dev/docs/get-started/install
    pause
    exit /b 1
)

echo.
echo [2/4] 清理项目...
flutter clean
if %errorlevel% neq 0 (
    echo 警告：清理项目失败
)

echo.
echo [3/4] 获取依赖...
flutter pub get
if %errorlevel% neq 0 (
    echo 错误：获取依赖失败
    pause
    exit /b 1
)

echo.
echo [4/4] 检查可用设备...
flutter devices
echo.

echo 请选择启动方式：
echo [1] 启动调试模式 (推荐)
echo [2] 启动Web版本
echo [3] 启动桌面版本 (Windows)
echo [4] 只运行分析检查
echo [5] 运行测试
echo [0] 退出
echo.

set /p choice="请输入选择 (0-5): "

if "%choice%"=="1" (
    echo 启动调试模式...
    flutter run --debug
) else if "%choice%"=="2" (
    echo 启动Web版本...
    flutter run -d web-server --web-port=3000
) else if "%choice%"=="3" (
    echo 启动Windows桌面版本...
    flutter run -d windows
) else if "%choice%"=="4" (
    echo 运行代码分析...
    flutter analyze
    echo.
    echo 代码分析完成！
) else if "%choice%"=="5" (
    echo 运行测试...
    flutter test
    echo.
    echo 测试完成！
) else if "%choice%"=="0" (
    echo 退出...
    exit /b 0
) else (
    echo 无效选择，请重新运行脚本
)

echo.
echo 脚本执行完成！
pause
