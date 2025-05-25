#ifndef SYSTEMINFO_H
#define SYSTEMINFO_H

#include <QObject>
#include <QStringListModel>

class SystemInfo : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QStringList wslDistributions READ wslDistributions NOTIFY wslDistributionsChanged)
    Q_PROPERTY(QStringList condaEnvironments READ condaEnvironments NOTIFY condaEnvironmentsChanged)
    Q_PROPERTY(QString systemVersion READ systemVersion NOTIFY systemVersionChanged)
    Q_PROPERTY(bool hasOhMyBash READ hasOhMyBash NOTIFY hasOhMyBashChanged)
    Q_PROPERTY(bool hasOhMyPosh READ hasOhMyPosh NOTIFY hasOhMyPoshChanged)

public:
    explicit SystemInfo(QObject *parent = nullptr);

    QStringList wslDistributions() const { return m_wslDistributions; }
    QStringList condaEnvironments() const { return m_condaEnvironments; }
    QString systemVersion() const { return m_systemVersion; }
    bool hasOhMyBash() const { return m_hasOhMyBash; }
    bool hasOhMyPosh() const { return m_hasOhMyPosh; }

public slots:
    void refreshSystemInfo();

signals:
    void wslDistributionsChanged();
    void condaEnvironmentsChanged();
    void systemVersionChanged();
    void hasOhMyBashChanged();
    void hasOhMyPoshChanged();

private:
    void detectWSLDistributions();
    void detectCondaEnvironments();
    void detectSystemVersion();
    void detectOhMyBash();
    void detectOhMyPosh();

    QStringList m_wslDistributions;
    QStringList m_condaEnvironments;
    QString m_systemVersion;
    bool m_hasOhMyBash;
    bool m_hasOhMyPosh;
};

#endif // SYSTEMINFO_H
