import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    objectName: "notesPage"
    allowedOrientations: Orientation.All

    PageHeader {
        objectName: "notesHeader"
        title: qsTr("Заметки")
        extraContent.children: [
            IconButton {
                objectName: "historyButton"
                icon.source: "image://theme/icon-m-clock"
                anchors.verticalCenter: parent.verticalCenter
                onClicked: pageStack.push(Qt.resolvedUrl("HistoryPage.qml"))
            }
        ]
    }

    SilicaListView {
        id: notesListView
        anchors.fill: parent
        clip: true
        spacing: Theme.paddingMedium

        model: noteModel

        delegate: ListItem {
            id: listItem
            width: parent.width
            contentHeight: contentColumn.height + 2 * Theme.paddingMedium

            Rectangle {
                anchors.fill: parent
                anchors {
                    leftMargin: Theme.horizontalPageMargin
                    rightMargin: Theme.horizontalPageMargin
                }
                color: Theme.rgba(Theme.secondaryColor, 0.06)
                radius: 12
            }

            Column {
                id: contentColumn
                anchors {
                    left: parent.left
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                    leftMargin: Theme.horizontalPageMargin + Theme.paddingMedium
                    rightMargin: Theme.horizontalPageMargin + Theme.paddingMedium
                }
                spacing: Theme.paddingSmall

                Row {
                    width: parent.width

                    Label {
                        text: title
                        color: Theme.primaryColor
                        font.pixelSize: Theme.fontSizeMedium
                        font.bold: true
                        width: parent.width - 80
                        elide: Text.ElideRight
                    }

                    Label {
                        text: duration > 0 ? formatDuration(duration) : ""
                        color: Theme.secondaryColor
                        font.pixelSize: Theme.fontSizeSmall
                        anchors.verticalCenter: parent.verticalCenter
                        width: 70
                        horizontalAlignment: Text.AlignRight
                    }
                }

                Label {
                    width: parent.width
                    text: model.text
                    color: Theme.secondaryColor
                    font.pixelSize: Theme.fontSizeSmall
                    elide: Text.ElideRight
                    maximumLineCount: 1
                    wrapMode: Text.WordWrap
                }

                Label {
                    text: createdAt ? Qt.formatDateTime(createdAt, "dd.MM.yyyy hh:mm") : ""
                    color: Theme.secondaryColor
                    font.pixelSize: Theme.fontSizeTiny
                }
            }

            menu: ContextMenu {
                MenuItem {
                    text: qsTr("Открыть")
                    onClicked: {
                        pageStack.push(Qt.resolvedUrl("NotesEditorPage.qml"), {
                            "noteTitle": title,
                            "noteText": model.text,
                            "noteDate": createdAt ? Qt.formatDateTime(createdAt, "dd.MM.yyyy hh:mm") : "",
                            "noteDuration": duration > 0 ? formatDuration(duration) : ""
                        })
                    }
                }
                MenuItem {
                    text: qsTr("Удалить")
                    onClicked: listItem.remorseDelete(function() {
                        noteModel.removeNote(index)
                    })
                }
            }

            onClicked: {
                pageStack.push(Qt.resolvedUrl("NotesEditorPage.qml"), {
                    "noteTitle": title,
                    "noteText": model.text,
                    "noteDate": createdAt ? Qt.formatDateTime(createdAt, "dd.MM.yyyy hh:mm") : "",
                    "noteDuration": duration > 0 ? formatDuration(duration) : ""
                })
            }
        }

        ViewPlaceholder {
            enabled: notesListView.count === 0
            text: qsTr("Нет заметок")
            hintText: qsTr("Запишите голосовую заметку на вкладке Запись")
        }
    }

    Rectangle {
        anchors {
            left: parent.left
            bottom: parent.bottom
            bottomMargin: 140
            leftMargin: Theme.paddingLarge
        }
        width: 70
        height: 70
        radius: 35
        color: Theme.highlightColor
        z: 10

        Label {
            anchors.centerIn: parent
            text: "+"
            color: "white"
            font.pixelSize: 40
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                pageStack.push(Qt.resolvedUrl("NotesEditorPage.qml"), {
                    "noteTitle": "",
                    "noteText": "",
                    "noteDate": "",
                    "noteDuration": ""
                })
            }
        }
    }

    function formatDuration(seconds) {
        var m = Math.floor(seconds / 60)
        var s = seconds % 60
        return (m < 10 ? "0" : "") + m + ":" + (s < 10 ? "0" : "") + s
    }
}
