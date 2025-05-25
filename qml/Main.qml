import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs
import BackupTool 1.0

ApplicationWindow {
    id: window
    width: 1000
    height: 700
    visible: true
    title: "系统备份工具"
    flags: Qt.Window | Qt.FramelessWindowHint
    
    property bool isDarkMode: true
    property real dragStartX: 0
    property real dragStartY: 0

    BackupManager {
        id: backupManager
        onBackupCompleted: {
            if (success) {
                showMessage("备份完成", message, "success")
            } else {
                showMessage("备份失败", message, "error")
            }
        }
        onBackupError: {
            showMessage("备份错误", error, "error")
        }
    }

    SystemInfo {
        id: systemInfo
        Component.onCompleted: refreshSystemInfo()
    }

    ConfigBackup {
        id: configBackup
    }

    // 扁平化主题颜色
    readonly property color backgroundColor: isDarkMode ? "#2b2b2b" : "#f8f9fa"
    readonly property color cardColor: isDarkMode ? "#3c3c3c" : "#ffffff"
    readonly property color textColor: isDarkMode ? "#ffffff" : "#212529"
    readonly property color accentColor: "#007bff"
    readonly property color successColor: "#28a745"
    readonly property color errorColor: "#dc3545"
    readonly property color borderColor: isDarkMode ? "#495057" : "#dee2e6"
    readonly property color hoverColor: isDarkMode ? "#495057" : "#e9ecef"

    color: "transparent"
    
    // 圆角窗口背景
    Rectangle {
        id: windowBackground
        anchors.fill: parent
        color: backgroundColor
        radius: 15
        border.width: 1
        border.color: borderColor
        
        // 添加阴影效果
        Rectangle {
            anchors.fill: parent
            anchors.topMargin: 3
            anchors.leftMargin: 3
            color: "#40000000"
            radius: 15
            z: -1
        }
    }

    // 自定义标题栏
    header: Rectangle {
        height: 50
        color: window.cardColor
        border.width: 0
        radius: 15
        
        // 为了保持圆角，只在顶部显示圆角
        Rectangle {
            anchors.fill: parent
            anchors.topMargin: 15
            color: window.cardColor
        }
        
        Rectangle {
            anchors.bottom: parent.bottom
            width: parent.width
            height: 1
            color: window.borderColor
        }
        
        // 拖拽区域
        MouseArea {
            id: titleBarMouseArea
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton
            property point lastMousePos: Qt.point(0, 0)
            
            onPressed: {
                lastMousePos = Qt.point(mouseX, mouseY)
            }
            
            onMouseXChanged: {
                if (pressed) {
                    window.x += (mouseX - lastMousePos.x)
                }
            }
            
            onMouseYChanged: {
                if (pressed) {
                    window.y += (mouseY - lastMousePos.y)
                }
            }
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 20
            anchors.rightMargin: 15
            anchors.topMargin: 10
            anchors.bottomMargin: 10
            spacing: 15

            // 应用图标和标题
            RowLayout {
                spacing: 10
                
                Rectangle {
                    width: 30
                    height: 30
                    color: window.accentColor
                    radius: 6
                    
                    Text {
                        anchors.centerIn: parent
                        text: "🔧"
                        font.pointSize: 14
                        color: "white"
                    }
                }
                
                Label {
                    text: "系统备份工具"
                    font.pointSize: 14
                    font.bold: true
                    color: window.textColor
                }
            }

            Item { Layout.fillWidth: true }

            // 状态信息
            Label {
                text: "就绪"
                color: window.textColor
                font.pointSize: 10
                opacity: 0.7
            }

            // 主题切换
            Rectangle {
                width: 60
                height: 30
                color: window.isDarkMode ? window.accentColor : window.borderColor
                radius: 15
                
                Rectangle {
                    width: 26
                    height: 26
                    radius: 13
                    color: "white"
                    anchors.verticalCenter: parent.verticalCenter
                    x: window.isDarkMode ? parent.width - width - 2 : 2
                    
                    Behavior on x {
                        PropertyAnimation { duration: 200 }
                    }
                }
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: window.isDarkMode = !window.isDarkMode
                }
            }
            
            // 最小化按钮
            Rectangle {
                width: 30
                height: 30
                color: minimizeMouseArea.containsMouse ? window.hoverColor : "transparent"
                radius: 4
                
                Text {
                    anchors.centerIn: parent
                    text: "−"
                    color: window.textColor
                    font.pointSize: 16
                    font.bold: true
                }
                
                MouseArea {
                    id: minimizeMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: window.showMinimized()
                }
            }

            // 关闭按钮
            Rectangle {
                width: 30
                height: 30
                color: closeMouseArea.containsMouse ? window.errorColor : "transparent"
                radius: 4
                
                Text {
                    anchors.centerIn: parent
                    text: "×"
                    color: closeMouseArea.containsMouse ? "white" : window.textColor
                    font.pointSize: 16
                    font.bold: true
                }
                
                MouseArea {
                    id: closeMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: Qt.quit()
                }
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20
        
        // 让内容区域的顶部适应圆角标题栏
        anchors.topMargin: 0

        // 系统信息卡片
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 120
            color: window.cardColor
            radius: 12
            border.width: 0
            Layout.topMargin: 20
            
            // 阴影效果（扁平化风格的轻微阴影）
            Rectangle {
                anchors.fill: parent
                anchors.topMargin: 2
                anchors.leftMargin: 2
                color: window.isDarkMode ? "#1a1a1a" : "#f0f0f0"
                radius: 12
                z: -1
                opacity: 0.3
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 15

                Label {
                    text: "系统信息"
                    font.pointSize: 14
                    font.bold: true
                    color: textColor
                }

                GridLayout {
                    columns: 2
                    columnSpacing: 30
                    rowSpacing: 5

                    Label {
                        text: "操作系统:"
                        color: textColor
                    }
                    Label {
                        text: systemInfo.systemVersion
                        color: textColor
                        font.bold: true
                    }

                    Label {
                        text: "WSL发行版:"
                        color: textColor
                    }
                    Label {
                        text: systemInfo.wslDistributions.length + " 个"
                        color: textColor
                        font.bold: true
                    }

                    Label {
                        text: "OhMyBash:"
                        color: textColor
                    }
                    Label {
                        text: systemInfo.hasOhMyBash ? "✓ 已安装" : "✗ 未安装"
                        color: systemInfo.hasOhMyBash ? successColor : errorColor
                        font.bold: true
                    }

                    Label {
                        text: "OhMyPosh:"
                        color: textColor
                    }
                    Label {
                        text: systemInfo.hasOhMyPosh ? "✓ 已安装" : "✗ 未安装"
                        color: systemInfo.hasOhMyPosh ? successColor : errorColor
                        font.bold: true
                    }
                }
            }
        }

        // 备份选项
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true

            GridLayout {
                width: parent.width
                columns: 2
                columnSpacing: 20
                rowSpacing: 20

                BackupCard {
                    title: "Windows软件列表"
                    description: "备份已安装的Windows软件列表"
                    icon: "💻"
                    enabled: true
                    onBackupRequested: backupManager.startSelectiveBackup(["软件列表"])
                }

                BackupCard {
                    title: "WSL发行版"
                    description: "备份WSL发行版配置和数据"
                    icon: "🐧"
                    enabled: systemInfo.wslDistributions.length > 0
                    onBackupRequested: backupManager.startSelectiveBackup(["WSL发行版"])
                }

                BackupCard {
                    title: "Miniforge环境"
                    description: "备份conda虚拟环境配置"
                    icon: "🐍"
                    enabled: systemInfo.condaEnvironments.length > 0
                    onBackupRequested: backupManager.startSelectiveBackup(["Miniforge环境"])
                }

                BackupCard {
                    title: "OhMyBash配置"
                    description: "备份Bash shell配置文件"
                    icon: "🔧"
                    enabled: systemInfo.hasOhMyBash
                    onBackupRequested: backupManager.startSelectiveBackup(["OhMyBash配置"])
                }

                BackupCard {
                    title: "OhMyPosh配置"
                    description: "备份PowerShell主题配置"
                    icon: "🎨"
                    enabled: systemInfo.hasOhMyPosh
                    onBackupRequested: backupManager.startSelectiveBackup(["OhMyPosh配置"])
                }

                BackupCard {
                    title: "系统配置"
                    description: "备份系统信息和功能配置"
                    icon: "⚙️"
                    enabled: true
                    onBackupRequested: backupManager.startSelectiveBackup(["系统配置"])
                }
            }
        }

        // 操作按钮
        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Button {
                text: "完整备份"
                font.pointSize: 12
                font.bold: true
                Layout.preferredHeight: 50
                background: Rectangle {
                    color: parent.pressed ? Qt.darker(window.accentColor, 1.1) : window.accentColor
                    radius: 8
                }
                contentItem: Text {
                    text: parent.text
                    color: "white"
                    font: parent.font
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                enabled: !backupManager.isBackupRunning
                onClicked: backupManager.startFullBackup()
            }

            Button {
                text: backupManager.isBackupRunning ? "取消备份" : "选择备份目录"
                font.pointSize: 12
                font.bold: true
                Layout.preferredHeight: 50
                background: Rectangle {
                    color: parent.pressed ? Qt.darker(parent.enabled ? window.errorColor : "#6c757d", 1.1) : 
                           (parent.enabled ? (backupManager.isBackupRunning ? window.errorColor : "#6c757d") : "#495057")
                    radius: 8
                }
                contentItem: Text {
                    text: parent.text
                    color: "white"
                    font: parent.font
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: {
                    if (backupManager.isBackupRunning) {
                        backupManager.cancelBackup()
                    } else {
                        folderDialog.open()
                    }
                }
            }

            Item { Layout.fillWidth: true }

            Button {
                text: "刷新信息"
                font.pointSize: 12
                background: Rectangle {
                    color: parent.pressed ? Qt.darker("#666666", 1.2) : "#666666"
                    radius: 6
                }
                contentItem: Text {
                    text: parent.text
                    color: "white"
                    font: parent.font
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: systemInfo.refreshSystemInfo()
            }
        }
    }

    // 进度对话框
    ProgressDialog {
        id: progressDialog
        visible: backupManager.isBackupRunning
        progress: backupManager.progress
        currentTask: backupManager.currentTask
        onCancelRequested: backupManager.cancelBackup()
    }

    // 文件夹选择对话框
    FolderDialog {
        id: folderDialog
        title: "选择备份目录"
        onAccepted: {
            backupManager.setBackupDirectory(selectedFolder.toString().replace("file:///", ""))
        }
    }

    // 消息提示
    function showMessage(title, message, type) {
        messageDialog.title = title
        messageDialog.text = message
        messageDialog.open()
    }

    Dialog {
        id: messageDialog
        modal: true
        standardButtons: Dialog.Ok
        anchors.centerIn: parent
        
        background: Rectangle {
            color: cardColor
            radius: 8
            border.color: isDarkMode ? "#404040" : "#e0e0e0"
            border.width: 1
        }
        
        contentItem: Text {
            text: messageDialog.text
            color: textColor
            wrapMode: Text.WordWrap
        }
    }
}
