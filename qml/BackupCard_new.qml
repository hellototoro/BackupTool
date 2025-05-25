import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    Layout.fillWidth: true
    Layout.preferredHeight: 120
    color: window.cardColor
    radius: 8
    border.color: window.isDarkMode ? "#404040" : "#e0e0e0"
    border.width: 1

    property string title: ""
    property string description: ""
    property string icon: ""
    property bool enabled: true

    signal backupRequested()

    states: [
        State {
            name: "hovered"
            when: mouseArea.containsMouse && root.enabled
            PropertyChanges {
                target: root
                color: window.isDarkMode ? "#3d3d3d" : "#f8f8f8"
                border.color: window.accentColor
            }
        },
        State {
            name: "disabled"
            when: !root.enabled
            PropertyChanges {
                target: root
                opacity: 0.5
            }
        }
    ]

    transitions: Transition {
        PropertyAnimation {
            properties: "color,border.color,opacity"
            duration: 200
            easing.type: Easing.OutCubic
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        enabled: root.enabled
        onClicked: root.backupRequested()
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 15
        spacing: 15

        // 图标区域
        Item {
            Layout.preferredWidth: 60
            Layout.preferredHeight: 60
            Layout.alignment: Qt.AlignVCenter

            Rectangle {
                id: iconBackground
                anchors.centerIn: parent
                width: 50
                height: 50
                color: window.accentColor
                radius: 25

                Text {
                    anchors.centerIn: parent
                    text: root.icon
                    font.pointSize: 18
                    color: "white"
                    font.family: "Segoe UI Emoji"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        // 内容区域
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignVCenter
            spacing: 8

            Label {
                text: root.title
                font.pointSize: 12
                font.bold: true
                color: window.textColor
                Layout.fillWidth: true
                elide: Text.ElideRight
            }

            Label {
                text: root.description
                font.pointSize: 10
                color: window.isDarkMode ? "#cccccc" : "#666666"
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
                Layout.fillHeight: true
                verticalAlignment: Text.AlignTop
            }
        }

        // 备份按钮区域
        Item {
            Layout.preferredWidth: 80
            Layout.preferredHeight: 60
            Layout.alignment: Qt.AlignVCenter

            Button {
                anchors.centerIn: parent
                width: 70
                height: 35
                text: "备份"
                enabled: root.enabled
                
                background: Rectangle {
                    color: parent.pressed ? Qt.darker(window.accentColor, 1.2) : window.accentColor
                    radius: 4
                    opacity: parent.enabled ? 1.0 : 0.5
                }
                
                contentItem: Text {
                    text: parent.text
                    color: "white"
                    font.pointSize: 10
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                
                onClicked: root.backupRequested()
            }
        }
    }
}
