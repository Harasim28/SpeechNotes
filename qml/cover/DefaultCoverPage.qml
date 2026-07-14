import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    objectName: "coverBackground"

    Image {
        anchors.centerIn: parent
        source: "../icons/172x172/ru.alx114.SpeechNotes.png"
        width: 86
        height: 86
        fillMode: Image.PreserveAspectFit
    }

    Label {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.verticalCenter
        anchors.topMargin: 60
        text: qsTr("SpeechNotes")
        color: Theme.primaryColor
        font.pixelSize: Theme.fontSizeLarge
        font.bold: true
    }

    Label {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.verticalCenter
        anchors.topMargin: 100
        text: qsTr("Голосовые заметки")
        color: Theme.secondaryColor
        font.pixelSize: Theme.fontSizeSmall
    }

    cover: CoverActionList {
        CoverAction {
            iconSource: "image://theme/icon-m-mic"
            onTriggered: {
                audioRecorder.startRecording()
            }
        }

        CoverAction {
            iconSource: "image://theme/icon-m-note"
            onTriggered: {
                mainWindow.activate()
                pageStack.replaceAbove(null, Qt.resolvedUrl("pages/NotesPage.qml"))
            }
        }
    }
}
