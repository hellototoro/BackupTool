# PowerShell构建脚本 - CMake版本
Write-Host "=== 系统备份工具构建脚本 (CMake) ===" -ForegroundColor Green

# 设置Qt环境变量
$QtDir = "C:\Programs\Qt\6.8.2\mingw_64"
$env:PATH = "$QtDir\bin;$env:PATH"

# 检查并添加MinGW到PATH
$MinGWPaths = @(
    "C:\Programs\Qt\Tools\mingw1310_64\bin",
    "C:\Programs\Qt\Tools\mingw1120_64\bin",
    "C:\Programs\Qt\Tools\mingw_64\bin"
)

$MinGWFound = $false
foreach ($MinGWPath in $MinGWPaths) {
    if (Test-Path $MinGWPath) {
        $env:PATH = "$MinGWPath;$env:PATH"
        Write-Host "找到MinGW编译器: $MinGWPath" -ForegroundColor Green
        $MinGWFound = $true
        break
    }
}

if (-not $MinGWFound) {
    Write-Host "警告: 未找到MinGW编译器，请确保已安装Qt开发工具" -ForegroundColor Yellow
}

Write-Host "当前工作目录: $(Get-Location)"
Write-Host "Qt路径: $QtDir"

try {
    # 创建并清理构建目录
    Write-Host "`n创建并清理构建目录..." -ForegroundColor Cyan
    if (Test-Path "build") {
        Remove-Item -Recurse -Force "build"
    }
    New-Item -ItemType Directory -Name "build" | Out-Null
    Set-Location "build"

    # 配置CMake项目
    Write-Host "`n配置CMake项目..." -ForegroundColor Cyan
    $cmakeConfig = Start-Process -FilePath "cmake" -ArgumentList @("-G", "MinGW Makefiles", "-DCMAKE_BUILD_TYPE=Release", "..") -Wait -PassThru -NoNewWindow
    
    if ($cmakeConfig.ExitCode -ne 0) {
        throw "CMake配置失败，退出代码: $($cmakeConfig.ExitCode)"
    }

    # 编译项目
    Write-Host "`n编译项目..." -ForegroundColor Cyan
    $buildProcess = Start-Process -FilePath "cmake" -ArgumentList @("--build", ".", "--config", "Release") -Wait -PassThru -NoNewWindow
    
    if ($buildProcess.ExitCode -ne 0) {
        throw "编译失败，退出代码: $($buildProcess.ExitCode)"
    }

    Write-Host "`n编译成功！" -ForegroundColor Green
    Write-Host "可执行文件位于: build\bin\BackupTool.exe" -ForegroundColor Green
    
    # 检查可执行文件是否存在
    if (Test-Path "bin\BackupTool.exe") {
        $fileInfo = Get-Item "bin\BackupTool.exe"
        Write-Host "文件大小: $([math]::Round($fileInfo.Length / 1KB, 2)) KB" -ForegroundColor Cyan
        Write-Host "创建时间: $($fileInfo.CreationTime)" -ForegroundColor Cyan
    }

} catch {
    Write-Host "`n错误: $_" -ForegroundColor Red
    exit 1
} finally {
    # 返回原目录
    Set-Location ".."
}

Write-Host "`n构建完成！" -ForegroundColor Green
