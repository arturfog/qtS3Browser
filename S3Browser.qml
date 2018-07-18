import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Dialogs 1.2
import Qt.labs.folderlistmodel 2.2

import QtQuick.Layouts 1.3

Item {
    id: browser
    property alias path: view.path
    width: 300
    height: 400

    ToolBar {
        width: parent.width
        height: 48
        id: top_buttons_row

//        Row {
//            width: parent.width
//            height: 2
//            Rectangle {
//                width: parent.width
//                height: 1
//                color: "black"
//            }
//        }

        Row {
            anchors.fill: parent
            ToolButton {
                height: parent.height
                icon.source: "icons/32_up_icon.png"
                icon.color: "transparent"
                text: "Up"
                onClicked: {
                    s3Model.goBackQML()
                    path = s3Model.getS3PathQML()
                }
            }

            ToolButton {
                height: parent.height
                icon.source: "icons/32_refresh_icon.png"
                icon.color: "transparent"
                text: "Refresh"
                onClicked: s3Model.refreshQML()
            }

            ToolButton {
                height: parent.height
                icon.source: "icons/32_download_icon.png"
                icon.color: "transparent"
                text: "Download"
                onClicked: {
                    s3Model.downloadQML(view.currentIndex)
                }
            }

            ToolButton {
                height: parent.height
                icon.source: "icons/32_delete_icon.png"
                icon.color: "transparent"
                text: "Delete"
                onClicked: {
                    s3Model.removeQML(view.currentIndex)
                }
            }

            ToolButton {
                height: parent.height
                icon.source: "icons/32_new_folder_icon.png"
                icon.color: "transparent"
                text: "New"
                onClicked: {
                    createFolderWindow.visible = true
                }
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
            property string path : s3Model.getS3PathQML()

            width: parent.width
            height: parent.height

            model: s3Model

            delegate: S3ObjectDelegate { }

            headerPositioning: ListView.OverlayHeader

            header: Column {
                width: browser.width
                height: 72
                z:2

                Rectangle {
                    width: parent.width - 2
                    border.width: 2
                    border.color: "black"
                    height: 32
                    color: "orange"

                    TextInput {
                        x:5
                        width: parent.width
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
                z: 0
            }
            focus: true
            highlightFollowsCurrentItem: true
            highlightMoveDuration:1
            smooth: true

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
