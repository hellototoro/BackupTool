#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>

#include "backupmanager.h"
#include "systeminfo.h"
#include "configbackup.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    
    app.setApplicationName("System Backup Tool");
    app.setApplicationVersion("1.0.0");
    app.setOrganizationName("MyProjects");
    
    // 注册自定义类型到QML
    qmlRegisterType<BackupManager>("BackupTool", 1, 0, "BackupManager");
    qmlRegisterType<SystemInfo>("BackupTool", 1, 0, "SystemInfo");
    qmlRegisterType<ConfigBackup>("BackupTool", 1, 0, "ConfigBackup");

    QQmlApplicationEngine engine;
    
    // 创建管理器实例
    BackupManager backupManager;
    SystemInfo systemInfo;
    ConfigBackup configBackup;
    
    // 将C++对象暴露给QML
    engine.rootContext()->setContextProperty("backupManager", &backupManager);
    engine.rootContext()->setContextProperty("systemInfo", &systemInfo);
    engine.rootContext()->setContextProperty("configBackup", &configBackup);

    const QUrl url(QStringLiteral("qrc:/BackupTool/qml/Main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
