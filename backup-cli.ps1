# 独立备份脚本 - 无需GUI的命令行备份工具
# 可以在没有Qt环境的机器上使用

param(
    [string]$BackupDir = "",
    [switch]$WindowsSoftware,
    [switch]$WSL,
    [switch]$Conda,
    [switch]$OhMyBash, 
    [switch]$OhMyPosh,
    [switch]$SystemConfig,
    [switch]$All,
    [switch]$Help
)

function Show-Help {
    Write-Host "系统备份工具 - 命令行版本" -ForegroundColor Green
    Write-Host ""
    Write-Host "用法:" -ForegroundColor Yellow
    Write-Host "  .\backup-cli.ps1 [选项]" -ForegroundColor White
    Write-Host ""
    Write-Host "选项:" -ForegroundColor Yellow
    Write-Host "  -BackupDir <路径>    指定备份目录" -ForegroundColor White
    Write-Host "  -WindowsSoftware     备份Windows软件列表" -ForegroundColor White
    Write-Host "  -WSL                 备份WSL发行版" -ForegroundColor White
    Write-Host "  -Conda               备份Conda环境" -ForegroundColor White
    Write-Host "  -OhMyBash            备份OhMyBash配置" -ForegroundColor White
    Write-Host "  -OhMyPosh            备份OhMyPosh配置" -ForegroundColor White
    Write-Host "  -SystemConfig        备份系统配置" -ForegroundColor White
    Write-Host "  -All                 备份所有项目" -ForegroundColor White
    Write-Host "  -Help                显示此帮助信息" -ForegroundColor White
    Write-Host ""
    Write-Host "示例:" -ForegroundColor Yellow
    Write-Host "  .\backup-cli.ps1 -All -BackupDir 'D:\Backups'" -ForegroundColor White
    Write-Host "  .\backup-cli.ps1 -WSL -Conda" -ForegroundColor White
}

function Backup-WindowsSoftware {
    param($OutputDir)
    Write-Host "正在备份Windows软件列表..." -ForegroundColor Yellow
    $OutputFile = Join-Path $OutputDir "windows_software_list.txt"
    try {
        Get-WmiObject -Class Win32_Product | Select-Object Name, Version, Vendor | Out-File -FilePath $OutputFile -Encoding UTF8
        Write-Host "✓ Windows软件列表备份完成" -ForegroundColor Green
    } catch {
        Write-Host "✗ Windows软件列表备份失败: $($_.Exception.Message)" -ForegroundColor Red
    }
}

function Backup-WSL {
    param($OutputDir)
    Write-Host "正在备份WSL发行版..." -ForegroundColor Yellow
    $WSLDir = Join-Path $OutputDir "wsl_distributions"
    New-Item -ItemType Directory -Force -Path $WSLDir | Out-Null
    
    try {
        # 获取WSL发行版列表
        wsl --list --verbose | Out-File -FilePath (Join-Path $WSLDir "wsl_list.txt") -Encoding UTF8
        
        # 导出主要发行版（假设是Ubuntu）
        $Distributions = wsl --list --quiet
        foreach ($Distro in $Distributions) {
            $DistroName = $Distro.Trim()
            if ($DistroName -and $DistroName -ne "") {
                Write-Host "  导出发行版: $DistroName" -ForegroundColor Cyan
                $ExportPath = Join-Path $WSLDir "$DistroName`_backup.tar"
                wsl --export $DistroName $ExportPath
            }
        }
        Write-Host "✓ WSL发行版备份完成" -ForegroundColor Green
    } catch {
        Write-Host "✗ WSL备份失败: $($_.Exception.Message)" -ForegroundColor Red
    }
}

function Backup-Conda {
    param($OutputDir)
    Write-Host "正在备份Conda环境..." -ForegroundColor Yellow
    $CondaDir = Join-Path $OutputDir "conda_environments"
    New-Item -ItemType Directory -Force -Path $CondaDir | Out-Null
    
    try {
        # 备份环境列表
        wsl conda env list | Out-File -FilePath (Join-Path $CondaDir "conda_env_list.txt") -Encoding UTF8
        
        # 导出base环境
        wsl conda env export --name base | Out-File -FilePath (Join-Path $CondaDir "base_environment.yml") -Encoding UTF8
        
        Write-Host "✓ Conda环境备份完成" -ForegroundColor Green
    } catch {
        Write-Host "✗ Conda环境备份失败: $($_.Exception.Message)" -ForegroundColor Red
    }
}

function Backup-OhMyBash {
    param($OutputDir)
    Write-Host "正在备份OhMyBash配置..." -ForegroundColor Yellow
    $BashDir = Join-Path $OutputDir "ohmybash_config"
    New-Item -ItemType Directory -Force -Path $BashDir | Out-Null
    
    try {
        # 备份配置文件
        wsl cp ~/.bashrc (Join-Path $BashDir "bashrc_backup") 2>$null
        wsl cp ~/.bash_profile (Join-Path $BashDir "bash_profile_backup") 2>$null
        wsl cp -r ~/.oh-my-bash (Join-Path $BashDir "oh-my-bash_backup") 2>$null
        
        Write-Host "✓ OhMyBash配置备份完成" -ForegroundColor Green
    } catch {
        Write-Host "✗ OhMyBash配置备份失败: $($_.Exception.Message)" -ForegroundColor Red
    }
}

function Backup-OhMyPosh {
    param($OutputDir)
    Write-Host "正在备份OhMyPosh配置..." -ForegroundColor Yellow
    $PoshDir = Join-Path $OutputDir "ohmyposh_config"
    New-Item -ItemType Directory -Force -Path $PoshDir | Out-Null
    
    try {
        # 备份PowerShell配置文件
        if (Test-Path $PROFILE) {
            Copy-Item -Path $PROFILE -Destination (Join-Path $PoshDir "Microsoft.PowerShell_profile.ps1") -ErrorAction SilentlyContinue
        }
        
        # 备份OhMyPosh主题文件
        $OhMyPoshConfig = "$env:USERPROFILE\.oh-my-posh"
        if (Test-Path $OhMyPoshConfig) {
            Copy-Item -Path $OhMyPoshConfig -Destination (Join-Path $PoshDir "oh-my-posh_backup") -Recurse -ErrorAction SilentlyContinue
        }
        
        Write-Host "✓ OhMyPosh配置备份完成" -ForegroundColor Green
    } catch {
        Write-Host "✗ OhMyPosh配置备份失败: $($_.Exception.Message)" -ForegroundColor Red
    }
}

function Backup-SystemConfig {
    param($OutputDir)
    Write-Host "正在备份系统配置..." -ForegroundColor Yellow
    $SystemDir = Join-Path $OutputDir "system_configs"
    New-Item -ItemType Directory -Force -Path $SystemDir | Out-Null
    
    try {
        # 备份系统信息
        Get-ComputerInfo | Out-File -FilePath (Join-Path $SystemDir "system_info.txt") -Encoding UTF8
        
        # 备份Windows功能
        Get-WindowsOptionalFeature -Online | Out-File -FilePath (Join-Path $SystemDir "windows_features.txt") -Encoding UTF8
        
        Write-Host "✓ 系统配置备份完成" -ForegroundColor Green
    } catch {
        Write-Host "✗ 系统配置备份失败: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# 主逻辑
if ($Help) {
    Show-Help
    exit
}

if (-not $WindowsSoftware -and -not $WSL -and -not $Conda -and -not $OhMyBash -and -not $OhMyPosh -and -not $SystemConfig -and -not $All) {
    Write-Host "错误: 请指定至少一个备份选项，或使用 -Help 查看帮助" -ForegroundColor Red
    exit 1
}

# 设置备份目录
if ($BackupDir -eq "") {
    $BackupDir = Join-Path $env:USERPROFILE "Documents\SystemBackups"
}

$Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$BackupPath = Join-Path $BackupDir $Timestamp
New-Item -ItemType Directory -Force -Path $BackupPath | Out-Null

Write-Host "=======================================================" -ForegroundColor Green
Write-Host "       系统备份工具 - 命令行版本" -ForegroundColor Green
Write-Host "=======================================================" -ForegroundColor Green
Write-Host "备份目录: $BackupPath" -ForegroundColor Cyan
Write-Host "开始时间: $(Get-Date)" -ForegroundColor Cyan
Write-Host ""

# 执行备份
if ($All -or $WindowsSoftware) { Backup-WindowsSoftware -OutputDir $BackupPath }
if ($All -or $WSL) { Backup-WSL -OutputDir $BackupPath }
if ($All -or $Conda) { Backup-Conda -OutputDir $BackupPath }
if ($All -or $OhMyBash) { Backup-OhMyBash -OutputDir $BackupPath }
if ($All -or $OhMyPosh) { Backup-OhMyPosh -OutputDir $BackupPath }
if ($All -or $SystemConfig) { Backup-SystemConfig -OutputDir $BackupPath }

# 创建备份清单
$Manifest = @{
    timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    backup_directory = $BackupPath
    items_backed_up = @()
}

if ($All -or $WindowsSoftware) { $Manifest.items_backed_up += "Windows软件列表" }
if ($All -or $WSL) { $Manifest.items_backed_up += "WSL发行版" }
if ($All -or $Conda) { $Manifest.items_backed_up += "Conda环境" }
if ($All -or $OhMyBash) { $Manifest.items_backed_up += "OhMyBash配置" }
if ($All -or $OhMyPosh) { $Manifest.items_backed_up += "OhMyPosh配置" }
if ($All -or $SystemConfig) { $Manifest.items_backed_up += "系统配置" }

$Manifest | ConvertTo-Json | Out-File -FilePath (Join-Path $BackupPath "backup_manifest.json") -Encoding UTF8

Write-Host ""
Write-Host "=======================================================" -ForegroundColor Green
Write-Host "备份完成!" -ForegroundColor Green
Write-Host "备份位置: $BackupPath" -ForegroundColor Cyan
Write-Host "完成时间: $(Get-Date)" -ForegroundColor Cyan
Write-Host "=======================================================" -ForegroundColor Green
