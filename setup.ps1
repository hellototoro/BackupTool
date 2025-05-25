# 创建资源目录
New-Item -ItemType Directory -Force -Path "resources"

# 创建一个简单的图标文件（这里用文本代替，实际项目中应该是真实的PNG图标）
@"
# 这里应该是应用程序图标
# 在实际项目中，请提供一个真实的PNG图标文件
"@ | Out-File -FilePath "resources\icon.png" -Encoding UTF8

Write-Host "项目结构创建完成!"
Write-Host "请确保已安装以下依赖："
Write-Host "- Qt 6.0+"
Write-Host "- CMake 3.16+"
Write-Host ""
Write-Host "构建项目："
Write-Host "mkdir build"
Write-Host "cd build" 
Write-Host "cmake .."
Write-Host "cmake --build ."
