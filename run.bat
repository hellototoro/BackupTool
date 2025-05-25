@echo off
echo.
echo ===================================================
echo    系统备份工具 - 启动脚本
echo ===================================================
echo.

REM 检查可执行文件是否存在
if not exist "build\bin\BackupTool.exe" (
    echo 错误: 未找到可执行文件 build\bin\BackupTool.exe
    echo 请先运行 build.bat 或 build.ps1 编译项目
    pause
    exit /b 1
)

echo 正在启动系统备份工具...
echo.

REM 设置Qt环境变量
set QT_DIR=C:\Programs\Qt\6.8.2\mingw_64
set PATH=%QT_DIR%\bin;%PATH%

REM 检查并添加MinGW到PATH (运行时可能需要一些Qt库)
if exist "C:\Programs\Qt\Tools\mingw1310_64\bin" (
    set PATH=C:\Programs\Qt\Tools\mingw1310_64\bin;%PATH%
)

REM 启动应用程序
start "" "build\bin\BackupTool.exe"

echo 应用程序已启动！
echo 如果遇到问题，请检查:
echo 1. Qt运行时库是否正确安装
echo 2. 系统权限是否足够
echo 3. WSL是否正常运行（如果需要备份WSL相关内容）
echo.
pause
