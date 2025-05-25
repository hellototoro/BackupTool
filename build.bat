@echo off
echo 设置Qt环境...

REM 设置Qt环境变量
set QT_DIR=C:\Programs\Qt\6.8.2\mingw_64
set PATH=%QT_DIR%\bin;%PATH%

REM 检查MinGW是否存在
if exist "C:\Programs\Qt\Tools\mingw1310_64\bin" (
    set PATH=C:\Programs\Qt\Tools\mingw1310_64\bin;%PATH%
    echo 找到MinGW编译器
) else (
    echo 警告: 未找到MinGW编译器，请确保已安装Qt开发工具
)

echo 当前工作目录: %CD%
echo Qt路径: %QT_DIR%

echo.
echo 创建并清理构建目录...
if exist "build" rmdir /s /q "build"
mkdir "build"
cd "build"

echo.
echo 配置CMake项目...
cmake -G "MinGW Makefiles" -DCMAKE_BUILD_TYPE=Release ..

if %errorlevel% neq 0 (
    echo 错误: CMake配置失败
    cd ..
    pause
    exit /b 1
)

echo.
echo 编译项目...
cmake --build . --config Release

if %errorlevel% neq 0 (
    echo 错误: 编译失败
    cd ..
    pause
    exit /b 1
)

echo.
echo 编译成功！
echo 可执行文件位于: build\bin\BackupTool.exe
cd ..
pause
