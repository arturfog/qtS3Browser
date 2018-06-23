import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.3
import QtQuick.Dialogs 1.2
import Qt.labs.folderlistmodel 2.2

import QtQuick.Layouts 1.3

Item {
    id: browser
    property alias path: view.path
    width: 300
    Keys.forwardTo: view

    ToolBar {
        width: parent.width
        height: 48
        Row {
            anchors.fill: parent
            ToolButton {
                height: parent.height
                icon.source: "icons/32_up_icon.png"
                icon.color: "transparent"
                text: qsTr("Up")
                onClicked: view.path = folder.parentFolder
            }

            ToolButton {
                height: parent.height
                icon.source: "icons/32_refresh_icon.png"
                icon.color: "transparent"
                text: qsTr("Refresh")
            }

            ToolButton {
                height: parent.height
                icon.source: "icons/32_upload_icon.png"
                icon.color: "transparent"
                text: qsTr("Upload")
                onClicked: {
                    var filePath = folder.get(view.currentIndex, "filePath")
                    s3Model.uploadQML(filePath)
                }
            }

            ToolButton {
                height: parent.height
                icon.source: "icons/32_delete_icon.png"
                icon.color: "transparent"
                text: qsTr("Delete")
            }
        }
    }

    ScrollView {
        width: parent.width
        height: parent.height - 48
        y: 48
        clip: true

        ListView {
            id: view
            property string path

            width: parent.width
            height: parent.height

            model: FolderListModel {
                id: folder
                showDirsFirst: true
                folder: view.path
            }

            delegate: FileDelegate { }

            headerPositioning: ListView.OverlayHeader

            header: Column {
                width: browser.width - 5
                height: 72
                z:2

                Rectangle {
                    width: parent.width
                    border.width: 1
                    border.color: "black"
                    height: 32

                    TextInput {
                        anchors.verticalCenter: parent.verticalCenter
                        text: view.path
                    }
                }

                Row {
                    width: parent.width
                    height: 32
                    Rectangle {
                        width: parent.width - 100
                        height: 32
                        Text {
                            x: 30
                            width: 230
                            anchors.verticalCenter: parent.verticalCenter
                            text: "Name"

                        }
                    }
                    Rectangle {
                        width: 100
                        height: 32
                        Text {
                            width: 100
                            anchors.verticalCenter: parent.verticalCenter
                            text: "Size"
                        }
                    }
                }

            }

            highlight: Rectangle {
                color: "lightblue"
                opacity: 0.5
                z: 1
            }
            focus: true
            highlightFollowsCurrentItem: true

            Keys.onUpPressed: {
                var newIndex = currentIndex - 1;
                if (newIndex < 0)
                    newIndex = 0;
                //                if (currentIndex != newIndex)
                //                    selectionManager.toggleIndex(newIndex);
                view.currentIndex = newIndex
            }
            Keys.onDownPressed: {
                var newIndex = currentIndex + 1;
                view.currentIndex = newIndex
//                if (newIndex > count - 1)
//                    newIndex = count - 1;
//                if (currentIndex != newIndex)
//                    selectionManager.toggleIndex(newIndex);
            }

            footerPositioning: ListView.OverlayFooter
            footer: Rectangle {
                width: browser.width
                height: 34
                z:2
                Row {
                    anchors.fill: parent
                    Text {
                        text: "["+folder.count+" Items]"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }
    }
}
