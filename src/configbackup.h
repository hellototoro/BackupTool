#ifndef CONFIGBACKUP_H
#define CONFIGBACKUP_H

#include <QObject>
#include <QStringList>

class ConfigBackup : public QObject
{
    Q_OBJECT

public:
    explicit ConfigBackup(QObject *parent = nullptr);

public slots:
    QString getBackupDirectory();
    void setBackupDirectory(const QString &directory);
    QStringList getAvailableBackupItems();
    bool restoreFromBackup(const QString &backupPath, const QStringList &items);

signals:
    void restoreCompleted(bool success, const QString &message);

private:
    QString m_backupDirectory;
};

#endif // CONFIGBACKUP_H
