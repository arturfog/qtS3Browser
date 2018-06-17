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

        ToolButton {
            width:48
            height: parent.height
            icon.source: "icons/32_up_icon.png"
            icon.color: "transparent"
            onClicked: {
                s3Model.goBack()
                path = s3Model.getS3Path()
            }
        }

        ToolButton {
            width: 48
            height: parent.height
            icon.source: "icons/32_refresh_icon.png"
            icon.color: "transparent"
            onClicked: s3Model.refresh()
        }

        ToolButton {
            width: 48
            height: parent.height
            icon.source: "icons/32_download_icon.png"
            icon.color: "transparent"
        }

        ToolButton {
            width: 48
            height: parent.height
            icon.source: "icons/32_delete_icon.png"
            icon.color: "transparent"
            onClicked: {
                s3Model.remove(view.currentIndex)
            }
        }

        ToolButton {
            width: 48
            height: parent.height
            icon.source: "icons/32_new_folder_icon.png"
            icon.color: "transparent"
            onClicked: {
                createFolderWindow.visible = true
            }
        }
    }

    ScrollView {
        width: parent.width
        height: parent.height - top_buttons_row.height
        y: top_buttons_row.height
        clip: true
        ListView {
            id: view
            property string path : s3Model.getS3Path()

            width: parent.width
            height: parent.height

            model: s3Model

            delegate: S3ObjectDelegate { }

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
                    color: "orange"

                    TextInput {
                        anchors.verticalCenter: parent.verticalCenter
                        text: path
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
                        width: 1
                        height: 32
                        color: "black"
                    }

                    Rectangle {
                        width: 100
                        height: 32
                        Text {
                            x: 3
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
