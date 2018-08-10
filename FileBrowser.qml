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
    property bool connected: false
    Keys.forwardTo: view

    ToolBar {
        width: parent.width
        height: 48

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
                id: file_upload_btn
                height: parent.height
                icon.source: "icons/32_upload_icon.png"
                icon.color: "transparent"
                text: qsTr("Upload")
                enabled: connected && !folder.get(view.currentIndex, "fileIsDir")
                onClicked: {
                    var filePath = folder.get(view.currentIndex, "filePath")
                    app_window.progressWindow.visible = true
                    s3Model.uploadQML(filePath)
                }
            }

            ToolButton {
                height: parent.height
                icon.source: "icons/32_delete_icon.png"
                icon.color: "transparent"
                text: qsTr("Delete")
            }

            ToolButton {
                height: parent.height
                icon.source: "icons/32_new_folder_icon.png"
                icon.color: "transparent"
                text: "New"
                onClicked: {
                    createFolderWindow.x = app_window.x
                    createFolderWindow.y = app_window.y
                    createFolderWindow.visible = true
                }
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
                width: browser.width
                height: 72
                z:2

                Rectangle {
                    width: parent.width
                    border.width: 2
                    border.color: "black"
                    height: 32

                    TextInput {
                        id: file_browser_path_text
                        x:5
                        width: parent.width - file_browser_path_go.width - 2
                        anchors.verticalCenter: parent.verticalCenter
                        text: view.path
                    }
                    Button {
                        id: file_browser_path_go
                        y: 2
                        x: file_browser_path_text.width
                        height: 28
                        icon.source: "icons/32_delete_icon.png"
                        icon.color: "transparent"
                        text: qsTr("Go")
                        onClicked: {
                            path = file_browser_path_text.text
                        }
                    }
                }



                Row {
                    width: parent.width
                    height: 32
                    Rectangle {
                        width: parent.width - 102
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
