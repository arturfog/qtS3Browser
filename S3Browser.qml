import QtQuick 2.5
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2
import Qt.labs.folderlistmodel 2.1

Item {
    id: browser
    property alias path: view.path
    width: 300
    height: 400

    Row {
        id: top_buttons_row
        width: parent.width
        height: 48
        z:2

        Button {
            width:48
            height: parent.height
            icon.source: "icons/32_up_icon.png"
            icon.color: "transparent"
            onClicked: {
                s3Model.goBack()
                path = s3Model.getS3Path()
            }
        }

        Button {
            width: 48
            height: parent.height
            icon.source: "icons/32_refresh_icon.png"
            icon.color: "transparent"
            onClicked: s3Model.refresh()
        }

        Button {
            width: 48
            height: parent.height
            icon.source: "icons/32_download_icon.png"
            icon.color: "transparent"
        }

        Button {
            width: 48
            height: parent.height
            icon.source: "icons/32_delete_icon.png"
            icon.color: "transparent"
            onClicked: {
                s3Model.remove(view.currentIndex)
            }
        }

        Button {
            width: 48
            height: parent.height
            icon.source: "icons/32_new_folder_icon.png"
            icon.color: "transparent"
            onClicked: {
                createFolderWindow.visible = true
            }
        }
    }

    Row {
        width: parent.width
        height: parent.height - top_buttons_row.height
        y: top_buttons_row.height
        ListView {
            id: view
            property string path : s3Model.getS3Path()

            width: parent.width
            height: parent.height

            model: s3Model

            delegate: S3ObjectDelegate { }

            headerPositioning: ListView.OverlayHeader

            header: Rectangle {
                width: browser.width
                height: 34
                z:2
                color: "orange"
                border.color: "black"
                border.width: 1

                TextInput {
                    anchors.verticalCenter: parent.verticalCenter
                    text: path
                }
            }

            highlight: Rectangle {
                color: "lightblue"
                opacity: 0.5
                z: 2
            }
            focus: true
            highlightFollowsCurrentItem: true

            footerPositioning: ListView.OverlayHeader

            footer: Rectangle {
                id: s3_footer
                width: browser.width
                height: 34
                color: app_window.color
                z: 2
                Row {
                    anchors.fill: parent
                    Text {
                        text: "["+s3Model.rowCount()+" Files]"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }
    }
}
