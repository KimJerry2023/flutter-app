# Flutter投资理财App - PowerShell快速启动脚本
# 使用方法：在PowerShell中运行 .\start_flutter.ps1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   Flutter投资理财App - 快速启动脚本" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 检查Flutter环境
Write-Host "[1/4] 检查Flutter环境..." -ForegroundColor Yellow
try {
    $flutterVersion = flutter --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Flutter环境正常" -ForegroundColor Green
        Write-Host $flutterVersion[0] -ForegroundColor Gray
    } else {
        throw "Flutter命令执行失败"
    }
} catch {
    Write-Host "✗ 错误：Flutter未安装或未配置到PATH环境变量" -ForegroundColor Red
    Write-Host "请先安装Flutter：https://flutter.dev/docs/get-started/install" -ForegroundColor Yellow
    Read-Host "按任意键退出"
    exit 1
}

Write-Host ""
Write-Host "[2/4] 清理项目..." -ForegroundColor Yellow
try {
    flutter clean | Out-Null
    Write-Host "✓ 项目清理完成" -ForegroundColor Green
} catch {
    Write-Host "⚠ 警告：清理项目时出现问题" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "[3/4] 获取依赖..." -ForegroundColor Yellow
try {
    flutter pub get | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ 依赖获取完成" -ForegroundColor Green
    } else {
        throw "获取依赖失败"
    }
} catch {
    Write-Host "✗ 错误：获取依赖失败" -ForegroundColor Red
    Read-Host "按任意键退出"
    exit 1
}

Write-Host ""
Write-Host "[4/4] 检查可用设备..." -ForegroundColor Yellow
flutter devices

Write-Host ""
Write-Host "请选择启动方式：" -ForegroundColor Cyan
Write-Host "[1] 启动调试模式 (推荐，支持热重载)" -ForegroundColor White
Write-Host "[2] 启动Web版本" -ForegroundColor White
Write-Host "[3] 启动桌面版本 (Windows)" -ForegroundColor White
Write-Host "[4] 只运行分析检查" -ForegroundColor White
Write-Host "[5] 运行测试" -ForegroundColor White
Write-Host "[6] 打开VSCode" -ForegroundColor White
Write-Host "[0] 退出" -ForegroundColor White
Write-Host ""

$choice = Read-Host "请输入选择 (0-6)"

switch ($choice) {
    "1" {
        Write-Host "启动调试模式..." -ForegroundColor Green
        Write-Host "提示：修改代码后按 'r' 热重载，按 'R' 热重启，按 'q' 退出" -ForegroundColor Yellow
        flutter run --debug
    }
    "2" {
        Write-Host "启动Web版本..." -ForegroundColor Green
        Write-Host "浏览器将自动打开 http://localhost:3000" -ForegroundColor Yellow
        flutter run -d web-server --web-port=3000
    }
    "3" {
        Write-Host "启动Windows桌面版本..." -ForegroundColor Green
        flutter run -d windows
    }
    "4" {
        Write-Host "运行代码分析..." -ForegroundColor Green
        flutter analyze
        Write-Host ""
        Write-Host "代码分析完成！" -ForegroundColor Green
    }
    "5" {
        Write-Host "运行测试..." -ForegroundColor Green
        flutter test
        Write-Host ""
        Write-Host "测试完成！" -ForegroundColor Green
    }
    "6" {
        Write-Host "打开VSCode..." -ForegroundColor Green
        code .
    }
    "0" {
        Write-Host "退出..." -ForegroundColor Yellow
        exit 0
    }
    default {
        Write-Host "无效选择，请重新运行脚本" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "脚本执行完成！" -ForegroundColor Green
Read-Host "按任意键退出"
