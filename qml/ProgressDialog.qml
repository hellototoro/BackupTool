import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Dialog {
    id: root
    modal: true
    width: 480
    height: 260
    anchors.centerIn: parent

    property int progress: 0
    property string currentTask: ""

    signal cancelRequested()

    background: Rectangle {
        color: window.cardColor
        radius: 12
        border.width: 0
        
        // 扁平化阴影效果
        Rectangle {
            anchors.fill: parent
            anchors.topMargin: 6
            anchors.leftMargin: 6
            color: window.isDarkMode ? "#1a1a1a" : "#d0d0d0"
            radius: 12
            z: -1
            opacity: 0.5
        }
        
        // 额外的阴影层
        Rectangle {
            anchors.fill: parent
            anchors.topMargin: 12
            anchors.leftMargin: 12
            color: window.isDarkMode ? "#0d0d0d" : "#c0c0c0"
            radius: 12
            z: -2
            opacity: 0.3
        }
    }

    header: Rectangle {
        height: 70
        color: "transparent"
        
        RowLayout {
            anchors.centerIn: parent
            spacing: 15
            
            // 进度图标
            Rectangle {
                width: 32
                height: 32
                radius: 16
                color: window.accentColor
                
                Text {
                    anchors.centerIn: parent
                    text: "⟳"
                    color: "white"
                    font.pointSize: 16
                    font.bold: true
                    
                    RotationAnimation on rotation {
                        loops: Animation.Infinite
                        from: 0
                        to: 360
                        duration: 2000
                    }
                }
            }
            
            Label {
                text: "备份进行中..."
                font.pointSize: 18
                font.bold: true
                color: window.textColor
            }
        }
    }

    contentItem: ColumnLayout {
        spacing: 20

        Label {
            text: root.currentTask
            color: window.textColor
            font.pointSize: 11
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
        }

        // 进度条
        ProgressBar {
            id: progressBar
            Layout.fillWidth: true
            Layout.margins: 25
            Layout.preferredHeight: 12
            value: root.progress / 100.0
            
            background: Rectangle {
                color: window.isDarkMode ? "#404040" : "#e8e8e8"
                radius: 6
                implicitHeight: 12
            }
            
            contentItem: Item {
                Rectangle {
                    width: progressBar.visualPosition * parent.width
                    height: parent.height
                    radius: 6
                    color: window.accentColor
                    
                    // 进度条的渐变效果
                    Rectangle {
                        width: parent.width
                        height: parent.height / 2
                        anchors.top: parent.top
                        radius: 6
                        color: Qt.lighter(window.accentColor, 1.3)
                        opacity: 0.6
                    }
                }
            }
        }

        Label {
            text: root.progress + "%"
            color: window.textColor
            font.pointSize: 12
            font.bold: true
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
        }

        Button {
            text: "取消"
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 120
            Layout.preferredHeight: 50
            
            background: Rectangle {
                color: parent.down ? Qt.lighter(window.errorColor, 1.1) : window.errorColor
                radius: 8
                border.width: 0
                
                // 按钮阴影
                Rectangle {
                    anchors.fill: parent
                    anchors.topMargin: 3
                    anchors.leftMargin: 3
                    color: window.isDarkMode ? "#2d1b1b" : "#d0a0a0"
                    radius: 8
                    z: -1
                    opacity: 0.4
                }
                
                // 按钮按下效果
                scale: parent.down ? 0.95 : 1.0
                
                Behavior on scale {
                    NumberAnimation { duration: 100 }
                }
                
                Behavior on color {
                    ColorAnimation { duration: 150 }
                }
            }
            
            contentItem: Text {
                text: parent.text
                color: "white"
                font.pointSize: 12
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            
            onClicked: root.cancelRequested()
        }
    }
}
