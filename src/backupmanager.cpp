#include "backupmanager.h"
#include <QDir>
#include <QStandardPaths>
#include <QJsonArray>
#include <QDebug>
#include <QSettings>

BackupManager::BackupManager(QObject *parent)
    : QObject(parent)
    , m_process(nullptr)
    , m_isBackupRunning(false)
    , m_progress(0)
    , m_currentBackupIndex(0)
{
    m_progressTimer = new QTimer(this);
    connect(m_progressTimer, &QTimer::timeout, this, &BackupManager::updateProgress);
    
    // 设置默认备份目录
    QString defaultBackupDir = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation) + "/SystemBackups";
    setBackupDirectory(defaultBackupDir);
    
    loadLastBackupTime();
}

void BackupManager::startFullBackup()
{
    if (m_isBackupRunning) {
        return;
    }

    m_backupQueue.clear();
    m_backupQueue << "软件列表" << "WSL发行版" << "Miniforge环境" << "OhMyBash配置" << "OhMyPosh配置" << "系统配置";
    
    m_isBackupRunning = true;
    m_progress = 0;
    m_currentBackupIndex = 0;
    
    emit backupStateChanged();
    emit progressChanged();
    
    // 创建备份目录
    QDir backupDir(m_backupDirectory);
    if (!backupDir.exists()) {
        backupDir.mkpath(".");
    }
    
    QString timestamp = QDateTime::currentDateTime().toString("yyyyMMdd_hhmmss");
    m_backupDirectory = backupDir.absolutePath() + "/" + timestamp;
    QDir().mkpath(m_backupDirectory);
    
    m_progressTimer->start(100);
    processNextBackup();
}

void BackupManager::startSelectiveBackup(const QStringList &items)
{
    if (m_isBackupRunning) {
        return;
    }

    m_backupQueue = items;
    m_isBackupRunning = true;
    m_progress = 0;
    m_currentBackupIndex = 0;
    
    emit backupStateChanged();
    emit progressChanged();
    
    // 创建备份目录
    QDir backupDir(m_backupDirectory);
    if (!backupDir.exists()) {
        backupDir.mkpath(".");
    }
    
    QString timestamp = QDateTime::currentDateTime().toString("yyyyMMdd_hhmmss");
    m_backupDirectory = backupDir.absolutePath() + "/" + timestamp;
    QDir().mkpath(m_backupDirectory);
    
    m_progressTimer->start(100);
    processNextBackup();
}

void BackupManager::processNextBackup()
{
    if (m_currentBackupIndex >= m_backupQueue.size()) {
        // 备份完成
        createBackupManifest();
        saveLastBackupTime();
        
        m_isBackupRunning = false;
        m_progress = 100;
        m_progressTimer->stop();
        
        emit backupStateChanged();
        emit progressChanged();
        emit backupCompleted(true, "备份已成功完成！");
        return;
    }
    
    QString currentItem = m_backupQueue[m_currentBackupIndex];
    setCurrentTask("正在备份: " + currentItem);
    
    if (currentItem == "软件列表") {
        backupWindowsSoftwareList();
    } else if (currentItem == "WSL发行版") {
        backupWSLDistributions();
    } else if (currentItem == "Miniforge环境") {
        backupMinicondaEnvironments();
    } else if (currentItem == "OhMyBash配置") {
        backupOhMyBashConfig();
    } else if (currentItem == "OhMyPosh配置") {
        backupOhMyPoshConfig();
    } else if (currentItem == "系统配置") {
        backupSystemConfigs();
    }
    
    m_currentBackupIndex++;
}

void BackupManager::backupWindowsSoftwareList()
{
    setCurrentTask("正在备份Windows软件列表...");
    
    QString outputFile = m_backupDirectory + "/windows_software_list.txt";
    QString command = "powershell";
    QStringList arguments;
    arguments << "-Command" 
              << QString("Get-WmiObject -Class Win32_Product | Select-Object Name, Version, Vendor | Out-File -FilePath '%1' -Encoding UTF8").arg(outputFile);
    
    executeCommand(command, arguments);
}

void BackupManager::backupWSLDistributions()
{
    setCurrentTask("正在备份WSL发行版...");
    
    QString outputDir = m_backupDirectory + "/wsl_distributions";
    QDir().mkpath(outputDir);
    
    QString command = "powershell";
    QStringList arguments;
    arguments << "-Command" 
              << QString("wsl --list --verbose | Out-File -FilePath '%1/wsl_list.txt' -Encoding UTF8").arg(outputDir);
    
    executeCommand(command, arguments);
    
    // 导出每个发行版的配置
    arguments.clear();
    arguments << "-Command" 
              << QString("wsl --export Ubuntu '%1/ubuntu_backup.tar'").arg(outputDir);
    executeCommand(command, arguments);
}

void BackupManager::backupMinicondaEnvironments()
{
    setCurrentTask("正在备份Miniforge虚拟环境...");
    
    QString outputDir = m_backupDirectory + "/miniforge_environments";
    QDir().mkpath(outputDir);
    
    QString command = "powershell";
    QStringList arguments;
    
    // 备份环境列表
    arguments << "-Command" 
              << QString("wsl conda env list | Out-File -FilePath '%1/conda_env_list.txt' -Encoding UTF8").arg(outputDir);
    executeCommand(command, arguments);
    
    // 导出每个环境的配置
    arguments.clear();
    arguments << "-Command" 
              << QString("wsl conda env export --name base > '%1/base_environment.yml'").arg(outputDir);
    executeCommand(command, arguments);
}

void BackupManager::backupOhMyBashConfig()
{
    setCurrentTask("正在备份OhMyBash配置...");
    
    QString outputDir = m_backupDirectory + "/ohmybash_config";
    QDir().mkpath(outputDir);
    
    QString command = "powershell";
    QStringList arguments;
    arguments << "-Command" 
              << QString("wsl cp ~/.bashrc '%1/bashrc_backup' 2>/dev/null || echo 'bashrc not found'").arg(outputDir);
    executeCommand(command, arguments);
    
    arguments.clear();
    arguments << "-Command" 
              << QString("wsl cp ~/.bash_profile '%1/bash_profile_backup' 2>/dev/null || echo 'bash_profile not found'").arg(outputDir);
    executeCommand(command, arguments);
    
    arguments.clear();
    arguments << "-Command" 
              << QString("wsl cp -r ~/.oh-my-bash '%1/oh-my-bash_backup' 2>/dev/null || echo 'oh-my-bash not found'").arg(outputDir);
    executeCommand(command, arguments);
}

void BackupManager::backupOhMyPoshConfig()
{
    setCurrentTask("正在备份OhMyPosh配置...");
    
    QString outputDir = m_backupDirectory + "/ohmyposh_config";
    QDir().mkpath(outputDir);
    
    QString userProfile = QDir::homePath();
    QString command = "powershell";
    QStringList arguments;
    
    // 备份PowerShell配置文件
    arguments << "-Command" 
              << QString("Copy-Item -Path '$PROFILE' -Destination '%1/Microsoft.PowerShell_profile.ps1' -ErrorAction SilentlyContinue").arg(outputDir);
    executeCommand(command, arguments);
    
    // 备份OhMyPosh主题文件
    arguments.clear();
    arguments << "-Command" 
              << QString("Copy-Item -Path '$env:USERPROFILE\\.oh-my-posh' -Destination '%1/oh-my-posh_backup' -Recurse -ErrorAction SilentlyContinue").arg(outputDir);
    executeCommand(command, arguments);
}

void BackupManager::backupSystemConfigs()
{
    setCurrentTask("正在备份系统配置...");
    
    QString outputDir = m_backupDirectory + "/system_configs";
    QDir().mkpath(outputDir);
    
    QString command = "powershell";
    QStringList arguments;
    
    // 备份系统信息
    arguments << "-Command" 
              << QString("Get-ComputerInfo | Out-File -FilePath '%1/system_info.txt' -Encoding UTF8").arg(outputDir);
    executeCommand(command, arguments);
    
    // 备份已安装的Windows功能
    arguments.clear();
    arguments << "-Command" 
              << QString("Get-WindowsOptionalFeature -Online | Out-File -FilePath '%1/windows_features.txt' -Encoding UTF8").arg(outputDir);
    executeCommand(command, arguments);
}

void BackupManager::executeCommand(const QString &command, const QStringList &arguments)
{
    if (m_process) {
        m_process->deleteLater();
    }
    
    m_process = new QProcess(this);
    connect(m_process, QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished),
            this, &BackupManager::processFinished);
    connect(m_process, &QProcess::errorOccurred, this, &BackupManager::processError);
    
    m_process->start(command, arguments);
}

void BackupManager::processFinished(int exitCode, QProcess::ExitStatus exitStatus)
{
    Q_UNUSED(exitCode)
    Q_UNUSED(exitStatus)
    
    // 继续下一个备份任务
    QTimer::singleShot(500, this, &BackupManager::processNextBackup);
}

void BackupManager::processError(QProcess::ProcessError error)
{
    QString errorString = QString("备份过程中发生错误: %1").arg(error);
    emit backupError(errorString);
    
    // 继续下一个备份任务
    QTimer::singleShot(500, this, &BackupManager::processNextBackup);
}

void BackupManager::updateProgress()
{
    if (m_backupQueue.isEmpty()) {
        return;
    }
    
    int baseProgress = (m_currentBackupIndex * 100) / m_backupQueue.size();
    int currentProgress = baseProgress + (100 / m_backupQueue.size()) / 2; // 估算当前任务进度
    
    if (currentProgress > 100) {
        currentProgress = 100;
    }
    
    setProgress(currentProgress);
}

void BackupManager::createBackupManifest()
{
    m_backupManifest["timestamp"] = QDateTime::currentDateTime().toString(Qt::ISODate);
    m_backupManifest["backup_items"] = QJsonArray::fromStringList(m_backupQueue);
    m_backupManifest["backup_directory"] = m_backupDirectory;
    
    QJsonDocument doc(m_backupManifest);
    QString manifestPath = m_backupDirectory + "/backup_manifest.json";
    
    QFile file(manifestPath);
    if (file.open(QIODevice::WriteOnly)) {
        file.write(doc.toJson());
        file.close();
    }
}

void BackupManager::setCurrentTask(const QString &task)
{
    if (m_currentTask != task) {
        m_currentTask = task;
        emit currentTaskChanged();
    }
}

void BackupManager::setProgress(int progress)
{
    if (m_progress != progress) {
        m_progress = progress;
        emit progressChanged();
    }
}

void BackupManager::cancelBackup()
{
    if (m_process) {
        m_process->kill();
    }
    
    m_isBackupRunning = false;
    m_progressTimer->stop();
    
    emit backupStateChanged();
    emit backupCompleted(false, "备份已被取消");
}

void BackupManager::setBackupDirectory(const QString &directory)
{
    m_backupDirectory = directory;
}

void BackupManager::loadLastBackupTime()
{
    QSettings settings;
    m_lastBackupTime = settings.value("lastBackupTime", "从未备份").toString();
    emit lastBackupTimeChanged();
}

void BackupManager::saveLastBackupTime()
{
    QSettings settings;
    QString currentTime = QDateTime::currentDateTime().toString("yyyy-MM-dd hh:mm:ss");
    settings.setValue("lastBackupTime", currentTime);
    m_lastBackupTime = currentTime;
    emit lastBackupTimeChanged();
}
