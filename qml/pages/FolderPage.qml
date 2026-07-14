import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    objectName: "folderPage"
    allowedOrientations: Orientation.All

    property string folderName: ""

    PageHeader {
        objectName: "folderHeader"
        title: folderName.length > 0 ? folderName : qsTr("Папки")
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: contentColumn.height + Theme.paddingLarge

        Column {
            id: contentColumn
            width: parent.width
            spacing: Theme.paddingMedium

            SilicaListView {
                width: parent.width
                height: Math.min(400, contentHeight)
                clip: true
                spacing: Theme.paddingSmall

                model: ListModel {
                    ListElement { name: "Рабочие"; count: 5; icon: "💼" }
                    ListElement { name: "Личные"; count: 3; icon: "👤" }
                    ListElement { name: "Идеи"; count: 7; icon: "💡" }
                    ListElement { name: "Учеба"; count: 2; icon: "📚" }
                }

                delegate: ListItem {
                    id: folderItem
                    width: parent.width - 2 * Theme.horizontalPageMargin
                    x: Theme.horizontalPageMargin

                    onClicked: {
                        pageStack.push(Qt.resolvedUrl("NotesPage.qml"))
                    }

                    Row {
                        anchors {
                            left: parent.left
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                            leftMargin: Theme.paddingMedium
                            rightMargin: Theme.paddingMedium
                        }
                        spacing: Theme.paddingLarge

                        Label {
                            text: icon
                            font.pixelSize: Theme.fontSizeLarge
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Column {
                            spacing: 2

                            Label {
                                text: name
                                color: Theme.primaryColor
                                font.pixelSize: Theme.fontSizeMedium
                            }

                            Label {
                                text: qsTr("%1 заметок").arg(count)
                                color: Theme.secondaryColor
                                font.pixelSize: Theme.fontSizeSmall
                            }
                        }

                        Label {
                            text: "›"
                            color: Theme.secondaryColor
                            font.pixelSize: Theme.fontSizeExtraLarge
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                        }
                    }

                    menu: ContextMenu {
                        MenuItem {
                            text: qsTr("Переименовать")
                            onClicked: {
                            }
                        }
                        MenuItem {
                            text: qsTr("Удалить")
                            onClicked: folderItem.remorseDelete(function() {
                            })
                        }
                    }
                }
            }

            Button {
                width: parent.width - 2 * Theme.horizontalPageMargin
                x: Theme.horizontalPageMargin
                text: qsTr("📁 Создать папку")
                onClicked: {
                }
            }
        }
    }
}
