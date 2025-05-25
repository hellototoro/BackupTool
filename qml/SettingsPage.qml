import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    id: root

    background: Rectangle {
        color: window.backgroundColor
    }

    header: Label {
        text: "设置"
        font.pointSize: 18
        font.bold: true
        color: window.textColor
        leftPadding: 20
        topPadding: 20
        bottomPadding: 20
    }

    ScrollView {
        anchors.fill: parent
        anchors.margins: 20

        ColumnLayout {
            width: parent.width
            spacing: 20

            // 备份设置
            GroupBox {
                Layout.fillWidth: true
                title: "备份设置"
                
                background: Rectangle {
                    color: window.cardColor
                    radius: 8
                    border.color: window.isDarkMode ? "#404040" : "#e0e0e0"
                    border.width: 1
                }
                
                label: Label {
                    text: parent.title
                    color: window.textColor
                    font.bold: true
                }

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 15

                    RowLayout {
                        Label {
                            text: "默认备份目录:"
                            color: window.textColor
                        }
                        
                        TextField {
                            id: backupDirField
                            Layout.fillWidth: true
                            text: configBackup.getBackupDirectory()
                            color: window.textColor
                            
                            background: Rectangle {
                                color: window.isDarkMode ? "#404040" : "#ffffff"
                                border.color: parent.activeFocus ? window.accentColor : (window.isDarkMode ? "#606060" : "#cccccc")
                                border.width: 1
                                radius: 4
                            }
                        }
                        
                        Button {
                            text: "浏览"
                            onClicked: {
                                // TODO: 打开文件夹选择对话框
                            }
                        }
                    }

                    CheckBox {
                        text: "自动备份"
                        color: window.textColor
                    }

                    CheckBox {
                        text: "压缩备份文件"
                        color: window.textColor
                    }
                }
            }

            // 高级设置
            GroupBox {
                Layout.fillWidth: true
                title: "高级设置"
                
                background: Rectangle {
                    color: window.cardColor
                    radius: 8
                    border.color: window.isDarkMode ? "#404040" : "#e0e0e0"
                    border.width: 1
                }
                
                label: Label {
                    text: parent.title
                    color: window.textColor
                    font.bold: true
                }

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 15

                    CheckBox {
                        text: "备份前验证WSL状态"
                        color: window.textColor
                        checked: true
                    }

                    CheckBox {
                        text: "包含隐藏文件"
                        color: window.textColor
                        checked: true
                    }

                    RowLayout {
                        Label {
                            text: "最大备份保留数量:"
                            color: window.textColor
                        }
                        
                        SpinBox {
                            from: 1
                            to: 50
                            value: 10
                            
                            background: Rectangle {
                                color: window.isDarkMode ? "#404040" : "#ffffff"
                                border.color: window.isDarkMode ? "#606060" : "#cccccc"
                                border.width: 1
                                radius: 4
                            }
                        }
                    }
                }
            }
        }
    }
}
