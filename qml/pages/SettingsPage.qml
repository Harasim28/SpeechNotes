import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    objectName: "settingsPage"
    allowedOrientations: Orientation.All

    PageHeader {
        objectName: "settingsHeader"
        title: qsTr("Настройки")
    }

    SilicaFlickable {
        id: flickable
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            bottomMargin: 120
        }
        contentHeight: contentColumn.height + Theme.paddingLarge

        Column {
            id: contentColumn
            width: parent.width
            spacing: Theme.paddingMedium
            anchors.top: parent.top
            anchors.topMargin: Theme.paddingMedium

            TextSwitch {
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * Theme.horizontalPageMargin
                text: qsTr("Автоматическая расшифровка")
                checked: true
            }

            SectionHeader {
                text: qsTr("Распознавание")
            }

            ComboBox {
                id: modelCombo
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * Theme.horizontalPageMargin
                label: qsTr("Модель")
                currentIndex: 0
                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("Whisper tiny (быстрая)")
                        onClicked: {
                            transcriptWorker.modelPath = "/usr/share/ru.alx114.SpeechNotes/models/ggml-tiny-q8_0.bin"
                            modelInfo.text = qsTr("39M параметров, ~14с/1с аудио")
                        }
                    }
                    MenuItem {
                        text: qsTr("Whisper small (точная)")
                        onClicked: {
                            transcriptWorker.modelPath = "/usr/share/ru.alx114.SpeechNotes/models/ggml-small-q8_0.bin"
                            modelInfo.text = qsTr("244M параметров, ~60с/1с аудио")
                        }
                    }
                }
            }

            Label {
                id: modelInfo
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * Theme.horizontalPageMargin
                text: qsTr("39M параметров, ~14с/1с аудио")
                color: Theme.secondaryColor
                font.pixelSize: Theme.fontSizeSmall
                wrapMode: Text.WordWrap
            }

            SectionHeader {
                text: qsTr("О приложении")
            }

            Rectangle {
                width: parent.width - 2 * Theme.horizontalPageMargin
                x: Theme.horizontalPageMargin
                height: 240
                color: Theme.rgba(Theme.secondaryColor, 0.08)
                radius: 16

                Column {
                    anchors {
                        fill: parent
                        margins: Theme.paddingLarge
                    }
                    spacing: Theme.paddingMedium

                    Image {
                        anchors.horizontalCenter: parent.horizontalCenter
                        source: "../icons/86x86/ru.alx114.SpeechNotes.png"
                        width: 86
                        height: 86
                        fillMode: Image.PreserveAspectFit
                    }

                    Label {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: qsTr("SpeechNotes")
                        font.pixelSize: Theme.fontSizeLarge
                        color: Theme.highlightColor
                        font.bold: true
                    }

                    Label {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: qsTr("Версия 1.0.0")
                        color: Theme.secondaryColor
                        font.pixelSize: Theme.fontSizeSmall
                    }

                    Label {
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: parent.width
                        text: qsTr("Голосовые заметки с офлайн-расшифровкой")
                        color: Theme.secondaryColor
                        font.pixelSize: Theme.fontSizeSmall
                        wrapMode: Text.WordWrap
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Label {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: qsTr("Разработчик: ru.alx114")
                        color: Theme.secondaryColor
                        font.pixelSize: Theme.fontSizeTiny
                    }
                }
            }

            Item {
                height: Theme.paddingLarge
                width: parent.width
            }
        }
    }

    VerticalScrollDecorator {
        flickable: flickable
    }
}