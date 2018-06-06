import QtQuick 2.5
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2
import Qt.labs.folderlistmodel 2.1
import QtQuick.Controls.Material 2.2

Item {
    id: browser
    property alias path: view.path
    width: 300
    height: parent.height

    Row {
        width: parent.width
        height: 48
        z:2

        Button {
            width: 48
            height: parent.height
            icon.source: "icons/32_up_icon.png"
            icon.color: "transparent"
            onClicked: view.path = folder.parentFolder
        }

        Button {
            width: 48
            height: parent.height
            icon.source: "icons/32_refresh_icon.png"
            icon.color: "transparent"
        }

        Button {
            width: 48
            height: parent.height
            icon.source: "icons/32_upload_icon.png"
            icon.color: "transparent"
            onClicked: {
                var filePath = folder.get(view.currentIndex, "filePath")
                s3Model.uploadQML(filePath)
            }
        }

        Button {
            width: 48
            height: parent.height
            icon.source: "icons/32_delete_icon.png"
            icon.color: "transparent"
        }
    }

    Row {
        width: parent.width
        height: parent.height - 48
        y: 48
        ListView {
            id: view
            property string path

            width: parent.width
            height: parent.height

            model: FolderListModel {
                id: folder
                folder: view.path
            }

            delegate: FileDelegate { }

            headerPositioning: ListView.OverlayHeader

            header: Rectangle {
                width: browser.width
                height: 34
                z:2
                border.color: "black"
                border.width: 1

                TextInput {
                    anchors.verticalCenter: parent.verticalCenter
                    text: view.path
                }
            }

            highlight: Rectangle {
                color: "lightblue"
                opacity: 0.5
                z: 2
            }
            focus: true
            highlightFollowsCurrentItem: true

            footerPositioning: ListView.OverlayFooter
            footer: Rectangle {
                width: browser.width
                height: 34
                z:2
                Row {
                    anchors.fill: parent
                    Text {
                        text: "["+folder.count+" Files]"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }
    }
}
