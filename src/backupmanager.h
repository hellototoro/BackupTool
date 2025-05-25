#ifndef BACKUPMANAGER_H
#define BACKUPMANAGER_H

#include <QObject>
#include <QProcess>
#include <QTimer>
#include <QJsonObject>
#include <QJsonDocument>
#include <QDateTime>

class BackupManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isBackupRunning READ isBackupRunning NOTIFY backupStateChanged)
    Q_PROPERTY(int progress READ progress NOTIFY progressChanged)
    Q_PROPERTY(QString currentTask READ currentTask NOTIFY currentTaskChanged)
    Q_PROPERTY(QString lastBackupTime READ lastBackupTime NOTIFY lastBackupTimeChanged)

public:
    explicit BackupManager(QObject *parent = nullptr);

    bool isBackupRunning() const { return m_isBackupRunning; }
    int progress() const { return m_progress; }
    QString currentTask() const { return m_currentTask; }
    QString lastBackupTime() const { return m_lastBackupTime; }

public slots:
    void startFullBackup();
    void startSelectiveBackup(const QStringList &items);
    void cancelBackup();
    void setBackupDirectory(const QString &directory);

signals:
    void backupStateChanged();
    void progressChanged();
    void currentTaskChanged();
    void lastBackupTimeChanged();
    void backupCompleted(bool success, const QString &message);
    void backupError(const QString &error);

private slots:
    void processFinished(int exitCode, QProcess::ExitStatus exitStatus);
    void processError(QProcess::ProcessError error);
    void updateProgress();
    void processNextBackup();

private:
    void backupWindowsSoftwareList();
    void backupWSLDistributions();
    void backupMinicondaEnvironments();
    void backupOhMyBashConfig();
    void backupOhMyPoshConfig();
    void backupSystemConfigs();
    void createBackupManifest();
    void executeCommand(const QString &command, const QStringList &arguments = {});
    void setCurrentTask(const QString &task);
    void setProgress(int progress);
    void loadLastBackupTime();
    void saveLastBackupTime();

    QProcess *m_process;
    bool m_isBackupRunning;
    int m_progress;
    QString m_currentTask;
    QString m_backupDirectory;
    QString m_lastBackupTime;
    QStringList m_backupQueue;
    int m_currentBackupIndex;
    QJsonObject m_backupManifest;
    QTimer *m_progressTimer;
};

#endif // BACKUPMANAGER_H
