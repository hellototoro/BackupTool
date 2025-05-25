# System Backup Tool

一个采用现代扁平化设计的无边框GUI备份工具，用于备份Windows系统软件列表、WSL配置、虚拟环境和shell配置。

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Platform](https://img.shields.io/badge/platform-Windows-blue.svg)
![Qt](https://img.shields.io/badge/Qt-6.0%2B-green.svg)
![CMake](https://img.shields.io/badge/CMake-3.16%2B-green.svg)

## 📸 界面预览

- ✅ 圆角边框设计
- ✅ 扁平化现代界面
- ✅ 深色/浅色主题切换
- ✅ 无边框窗口设计

## 🚀 功能特性

- 🖥️ **Windows软件列表备份** - 备份系统中已安装的软件列表
- 🐧 **WSL发行版备份** - 备份WSL中的Linux发行版配置
- 🐍 **Miniforge环境备份** - 备份conda虚拟环境配置
- 🔧 **OhMyBash配置备份** - 备份WSL中的Bash shell配置
- 🎨 **OhMyPosh配置备份** - 备份Windows PowerShell主题配置
- ⚙️ **系统配置备份** - 备份系统信息和功能配置
- 🌙 **深色/浅色主题** - 支持主题切换，现代扁平化设计
- 📊 **实时进度显示** - 显示备份进度和当前任务
- 🪟 **无边框设计** - 现代化的无边框窗口界面
- 🎯 **扁平化风格** - 简洁明了的Material Design风格

## 系统要求

- Windows 10/11
- Qt 6.0+
- CMake 3.16+
- 已安装WSL（可选）
- 已安装Miniforge3（可选）
- 已配置OhMyBash/OhMyPosh（可选）

## 🛠️ 构建说明

### 前置要求
- Windows 10/11
- Qt 6.0+
- CMake 3.16+
- MinGW编译器

### 快速构建

#### 使用构建脚本（推荐）

```powershell
# 使用PowerShell脚本（推荐）
.\build.ps1

# 或使用批处理脚本
.\build.bat
```

#### 手动构建

```bash
# 创建构建目录
mkdir build
cd build

# 配置CMake
cmake -G "MinGW Makefiles" -DCMAKE_BUILD_TYPE=Release ..

# 编译项目
cmake --build . --config Release
```

### 运行程序

```powershell
# 使用运行脚本
.\run.ps1

# 或直接运行
.\build\bin\BackupTool.exe
```

### 清理构建产物

```powershell
Remove-Item -Recurse -Force build
```

## 使用说明

1. 启动应用程序
2. 查看系统信息面板，了解当前系统配置
3. 选择需要备份的项目：
   - 点击单个备份卡片进行选择性备份
   - 点击"完整备份"进行全量备份
4. 选择备份目录（可选）
5. 等待备份完成

## 备份内容详情

### Windows软件列表
- 通过WMI获取已安装软件信息
- 包含软件名称、版本、供应商信息

### WSL发行版
- WSL发行版列表
- 发行版配置导出

### Miniforge环境
- Conda环境列表
- 环境配置文件（YAML格式）

### OhMyBash配置
- `.bashrc` 文件
- `.bash_profile` 文件
- `.oh-my-bash` 目录

### OhMyPosh配置
- PowerShell配置文件
- OhMyPosh主题文件

### 系统配置
- 系统信息
- Windows可选功能列表

## 备份文件结构

```
backup_YYYYMMDD_HHMMSS/
├── windows_software_list.txt
├── wsl_distributions/
│   ├── wsl_list.txt
│   └── ubuntu_backup.tar
├── miniforge_environments/
│   ├── conda_env_list.txt
│   └── base_environment.yml
├── ohmybash_config/
│   ├── bashrc_backup
│   ├── bash_profile_backup
│   └── oh-my-bash_backup/
├── ohmyposh_config/
│   ├── Microsoft.PowerShell_profile.ps1
│   └── oh-my-posh_backup/
├── system_configs/
│   ├── system_info.txt
│   └── windows_features.txt
└── backup_manifest.json
```

## 注意事项

- 首次使用时，请确保PowerShell执行策略允许运行脚本
- WSL相关功能需要WSL正常运行
- 某些系统配置可能需要管理员权限
- 备份文件可能较大，请确保有足够的磁盘空间

## 许可证

MIT License
