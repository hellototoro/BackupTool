# 系统备份工具 - PowerShell启动脚本

Write-Host "=======================================================" -ForegroundColor Green
Write-Host "       系统备份工具 - PowerShell启动脚本" -ForegroundColor Green  
Write-Host "=======================================================" -ForegroundColor Green
Write-Host ""

# 检查可执行文件是否存在
if (-not (Test-Path "build\bin\BackupTool.exe")) {
    Write-Host "错误: 未找到可执行文件 build\bin\BackupTool.exe" -ForegroundColor Red
    Write-Host "请先运行 build.bat 或 build.ps1 编译项目" -ForegroundColor Yellow
    Read-Host "按任意键退出"
    exit 1
}

Write-Host "正在启动系统备份工具..." -ForegroundColor Yellow
Write-Host ""

# 设置Qt环境变量
$QtDir = "C:\Programs\Qt\6.8.2\mingw_64"
$env:PATH = "$QtDir\bin;$env:PATH"

# 检查并添加MinGW到PATH (运行时可能需要一些Qt库)
$MinGWPaths = @(
    "C:\Programs\Qt\Tools\mingw1310_64\bin",
    "C:\Programs\Qt\Tools\mingw1120_64\bin",
    "C:\Programs\Qt\Tools\mingw_64\bin"
)

foreach ($MinGWPath in $MinGWPaths) {
    if (Test-Path $MinGWPath) {
        $env:PATH = "$MinGWPath;$env:PATH"
        break
    }
}

try {
    # 启动应用程序
    Start-Process -FilePath "build\bin\BackupTool.exe" -WindowStyle Normal
    Write-Host "应用程序已启动！" -ForegroundColor Green
} catch {
    Write-Host "启动失败: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "如果遇到问题，请检查:" -ForegroundColor Yellow
Write-Host "1. Qt运行时库是否正确安装" -ForegroundColor White
Write-Host "2. 系统权限是否足够" -ForegroundColor White
Write-Host "3. WSL是否正常运行（如果需要备份WSL相关内容）" -ForegroundColor White
Write-Host "4. PowerShell执行策略是否允许运行脚本" -ForegroundColor White
Write-Host ""
Read-Host "按任意键退出"
