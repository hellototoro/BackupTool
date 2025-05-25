#include "configbackup.h"
#include <QStandardPaths>
#include <QDir>
#include <QFile>
#include <QProcess>

ConfigBackup::ConfigBackup(QObject *parent)
    : QObject(parent)
{
    m_backupDirectory = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation) + "/SystemBackups";
}

QString ConfigBackup::getBackupDirectory()
{
    return m_backupDirectory;
}

void ConfigBackup::setBackupDirectory(const QString &directory)
{
    m_backupDirectory = directory;
}

QStringList ConfigBackup::getAvailableBackupItems()
{
    QStringList items;
    items << "软件列表" << "WSL发行版" << "Miniforge环境" 
          << "OhMyBash配置" << "OhMyPosh配置" << "系统配置";
    return items;
}

bool ConfigBackup::restoreFromBackup(const QString &backupPath, const QStringList &items)
{
    // 实现恢复功能
    QDir backupDir(backupPath);
    if (!backupDir.exists()) {
        emit restoreCompleted(false, "备份目录不存在");
        return false;
    }

    bool success = true;
    QString message = "恢复完成";

    for (const QString &item : items) {
        if (item == "OhMyBash配置") {
            QDir ohMyBashDir(backupPath + "/ohmybash_config");
            if (ohMyBashDir.exists()) {
                // 恢复bash配置文件
                QProcess process;
                process.start("powershell", {"-Command", 
                    QString("wsl cp '%1/bashrc_backup' ~/.bashrc").arg(ohMyBashDir.absolutePath())});
                process.waitForFinished();
                
                if (process.exitCode() != 0) {
                    success = false;
                    message = "OhMyBash配置恢复失败";
                }
            }
        }
        // 可以添加更多恢复逻辑
    }

    emit restoreCompleted(success, message);
    return success;
}
