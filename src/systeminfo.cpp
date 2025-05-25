#include "systeminfo.h"
#include <QProcess>
#include <QDebug>
#include <QDir>

SystemInfo::SystemInfo(QObject *parent)
    : QObject(parent)
    , m_hasOhMyBash(false)
    , m_hasOhMyPosh(false)
{
    refreshSystemInfo();
}

void SystemInfo::refreshSystemInfo()
{
    detectSystemVersion();
    detectWSLDistributions();
    detectCondaEnvironments();
    detectOhMyBash();
    detectOhMyPosh();
}

void SystemInfo::detectWSLDistributions()
{
    QProcess process;
    process.start("powershell", {"-Command", "wsl --list --quiet"});
    process.waitForFinished(5000);
    
    if (process.exitCode() == 0) {
        QString output = QString::fromLocal8Bit(process.readAllStandardOutput());
        QStringList lines = output.split('\n', Qt::SkipEmptyParts);
        
        m_wslDistributions.clear();
        for (const QString &line : lines) {
            QString trimmed = line.trimmed();
            if (!trimmed.isEmpty()) {
                m_wslDistributions.append(trimmed);
            }
        }
        
        emit wslDistributionsChanged();
    }
}

void SystemInfo::detectCondaEnvironments()
{
    QProcess process;
    process.start("powershell", {"-Command", "wsl conda env list --json"});
    process.waitForFinished(5000);
    
    if (process.exitCode() == 0) {
        QString output = QString::fromLocal8Bit(process.readAllStandardOutput());
        // 简单解析conda环境列表
        QStringList lines = output.split('\n', Qt::SkipEmptyParts);
        
        m_condaEnvironments.clear();
        for (const QString &line : lines) {
            if (line.contains("envs") || line.contains("base")) {
                QString trimmed = line.trimmed();
                if (!trimmed.isEmpty() && !trimmed.startsWith("#")) {
                    m_condaEnvironments.append(trimmed.split(' ').first());
                }
            }
        }
        
        emit condaEnvironmentsChanged();
    }
}

void SystemInfo::detectSystemVersion()
{
    QProcess process;
    process.start("powershell", {"-Command", "(Get-CimInstance Win32_OperatingSystem).Caption"});
    process.waitForFinished(3000);
    
    if (process.exitCode() == 0) {
        m_systemVersion = QString::fromLocal8Bit(process.readAllStandardOutput()).trimmed();
        emit systemVersionChanged();
    }
}

void SystemInfo::detectOhMyBash()
{
    QProcess process;
    process.start("powershell", {"-Command", "wsl test -d ~/.oh-my-bash && echo 'found' || echo 'not found'"});
    process.waitForFinished(3000);
    
    if (process.exitCode() == 0) {
        QString output = QString::fromLocal8Bit(process.readAllStandardOutput()).trimmed();
        m_hasOhMyBash = output.contains("found");
        emit hasOhMyBashChanged();
    }
}

void SystemInfo::detectOhMyPosh()
{
    // 检查PowerShell配置文件中是否有oh-my-posh
    QProcess process;
    process.start("powershell", {"-Command", "Test-Path $PROFILE && Get-Content $PROFILE | Select-String 'oh-my-posh' || echo 'not found'"});
    process.waitForFinished(3000);
    
    if (process.exitCode() == 0) {
        QString output = QString::fromLocal8Bit(process.readAllStandardOutput()).trimmed();
        m_hasOhMyPosh = output.contains("oh-my-posh") && !output.contains("not found");
        emit hasOhMyPoshChanged();
    }
}
