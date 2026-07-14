import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    objectName: "noteEditorPage"
    allowedOrientations: Orientation.All

    property string noteTitle: ""
    property string noteText: ""
    property string noteDate: ""
    property string noteDuration: ""
    property var noteTags: []

    PageHeader {
        objectName: "editorHeader"
        title: noteTitle.length > 0 ? noteTitle : qsTr("Новая заметка")
        extraContent.children: [
            IconButton {
                objectName: "saveButton"
                icon.source: "image://theme/icon-m-save"
                anchors.verticalCenter: parent.verticalCenter
                onClicked: {
                    noteModel.addNote(titleField.text, textArea.text, "", 0)
                    pageStack.pop()
                }
            }
        ]
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: contentColumn.height + Theme.paddingLarge

        Column {
            id: contentColumn
            width: parent.width
            spacing: Theme.paddingMedium
            anchors.top: parent.top
            anchors.topMargin: Theme.paddingMedium

            Rectangle {
                width: parent.width - 2 * Theme.horizontalPageMargin
                x: Theme.horizontalPageMargin
                height: 50
                radius: 8
                color: Theme.rgba(Theme.secondaryColor, 0.08)
                visible: noteDate.length > 0 || noteDuration.length > 0

                Row {
                    anchors.centerIn: parent
                    spacing: Theme.paddingMedium

                    Label {
                        text: noteDate
                        color: Theme.secondaryColor
                        font.pixelSize: Theme.fontSizeSmall
                        visible: noteDate.length > 0
                    }

                    Label {
                        text: noteDuration
                        color: Theme.highlightColor
                        font.pixelSize: Theme.fontSizeSmall
                        visible: noteDuration.length > 0
                    }
                }
            }

            TextField {
                id: titleField
                width: parent.width - 2 * Theme.horizontalPageMargin
                x: Theme.horizontalPageMargin
                label: qsTr("Заголовок")
                placeholderText: qsTr("Введите заголовок")
                text: noteTitle
            }

            TextArea {
                id: textArea
                width: parent.width - 2 * Theme.horizontalPageMargin
                x: Theme.horizontalPageMargin
                height: Math.max(200, parent.height * 0.4)
                label: qsTr("Текст")
                placeholderText: qsTr("Введите текст заметки...")
                text: noteText
                wrapMode: Text.WordWrap
            }

            Button {
                width: parent.width - 2 * Theme.horizontalPageMargin
                x: Theme.horizontalPageMargin
                text: qsTr("Сохранить")
                onClicked: {
                    noteModel.addNote(titleField.text, textArea.text, "", 0)
                    pageStack.pop()
                }
            }
        }
    }
}
