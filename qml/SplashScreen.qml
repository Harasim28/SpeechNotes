import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: splashRoot
    anchors.fill: parent
    signal finished()

    Rectangle {
        anchors.fill: parent
        color: Theme.rgba(Theme.primaryColor, 0.12)

        Rectangle {
            anchors.fill: parent
            color: Theme.rgba(Theme.highlightColor, 0.06)
            opacity: 0.6
        }

        Column {
            anchors.centerIn: parent
            spacing: Theme.paddingLarge

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                source: "../icons/128x128/ru.alx114.SpeechNotes.png"
                width: 128
                height: 128
                fillMode: Image.PreserveAspectFit
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("SpeechNotes")
                color: Theme.highlightColor
                font.pixelSize: Theme.fontSizeExtraLarge
                font.bold: true
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Голосовые заметки")
                color: Theme.secondaryColor
                font.pixelSize: Theme.fontSizeMedium
            }

            BusyIndicator {
                anchors.horizontalCenter: parent.horizontalCenter
                running: true
                size: BusyIndicatorSize.Medium
            }
        }
    }

    Timer {
        running: true
        repeat: false
        interval: 2000
        onTriggered: {
            splashRoot.finished()
        }
    }
}