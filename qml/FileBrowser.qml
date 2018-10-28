/*
# Copyright (C) 2018  Artur Fogiel
# This file is part of qtS3Browser.
#
# qtS3Browser is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# qtS3Browser is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with qtS3Browser.  If not, see <http://www.gnu.org/licenses/>.
*/
import QtQuick 2.9
import QtQuick.Controls.Material 2.1
import QtQuick.Controls 2.3
import QtQuick.Dialogs 1.1
import Qt.labs.folderlistmodel 2.1
import QtQuick.Layouts 1.0

Item {
    id: browser
    width: 300
    property alias path: view.path
    property bool connected: false

    property CustomMessageDialog msgDialog: CustomMessageDialog {
        win_title: "Remove?"
        yesAction: function() {
            console.log("blabla: " + view.currentIndex)
            var filePath = folder.get(view.currentIndex, "filePath")
            fsModel.removeQML(filePath);
        }
    }

    property CreateItemWindow createFolderWindow: CreateItemWindow {
        win_title: qsTr("Create folder")
    }

    function upload() {
        if(!s3Model.isTransferring()) {
            var filePath = folder.get(view.currentIndex, "filePath")
            app_window.progressWindow.title = qsTr("Upload progress ...")
            app_window.progressWindow.icon = "qrc:icons/32_upload_icon.png"
            app_window.progressWindow.x = app_window.x + (app_window.width / 2) - (app_window.progressWindow.width / 2)
            app_window.progressWindow.y = app_window.y + (app_window.height / 2) - (app_window.progressWindow.height / 2)
            app_window.progressWindow.visible = true
            app_window.progressWindow.mode = app_window.progressWindow.modeUPLOAD
            if(!folder.get(view.currentIndex, "fileIsDir")) {
                s3Model.uploadFileQML(filePath)
            } else {
                s3Model.uploadDirQML(filePath)
            }
        }
    }

    ToolBar {
        width: parent.width
        height: 48

        Row {
            anchors.fill: parent
            ToolButton {
                font.pointSize: uiFontSize
                height: parent.height
                icon.source: "qrc:icons/32_up_icon.png"
                icon.color: "transparent"
                text: qsTr("Up")
                onClicked: {
                    if(folder.parentFolder.toString().length > 0) {
                        view.path = folder.parentFolder
                        s3Model.setFileBrowserPath(view.path)
                    }
                }
            }

            ToolButton {
                font.pointSize: uiFontSize
                height: parent.height
                icon.source: "qrc:icons/32_refresh_icon.png"
                icon.color: "transparent"
                text: qsTr("Refresh")
            }

            ToolButton {
                id: file_upload_btn
                font.pointSize: uiFontSize
                height: parent.height
                icon.source: "qrc:icons/32_upload_icon.png"
                icon.color: "transparent"
                text: qsTr("Upload")
                enabled: connected
                onClicked: { upload() }
            }

            ToolButton {
                font.pointSize: uiFontSize
                height: parent.height
                icon.source: "qrc:icons/32_delete_icon.png"
                icon.color: "transparent"
                text: qsTr("Delete")
                onClicked: {
                    var fileName = folder.get(view.currentIndex, "fileName")
                    msgDialog.msg = "Remove " + fileName + " ?"
                    msgDialog.open()
                }
            }

            ToolButton {
                font.pointSize: uiFontSize
                height: parent.height
                icon.source: "qrc:icons/32_new_folder_icon.png"
                icon.color: "transparent"
                text: qsTr("New")
                onClicked: {
                    createFolderWindow.x = app_window.x + (app_window.width / 2) - (createFolderWindow.width / 2)
                    createFolderWindow.y = app_window.y + (app_window.height / 2) - (createFolderWindow.height / 2)
                    createFolderWindow.create_action = createFolderWindow.createLocalFolder
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

//        Keys.onReturnPressed: {
//            var url = folder.get(view.currentIndex, "fileURL")
//            folder.get(view.currentIndex, "fileIsDir") ? view.path = url : Qt.openUrlExternally(url)
//        }

//        Keys.onDeletePressed: {
//            if(folder.parentFolder.toString().length > 0) {
//                view.path = folder.parentFolder
//            }
//        }

        ListView {
            id: view
            property string path

            width: parent.width
            height: parent.height

            model: FolderListModel {
                id: folder
                showDirsFirst: true
                //showHidden: true
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
                    border.color: "lightblue"
                    color: "#e6f9ff"
                    height: 38
                    radius: 20

                    Image {
                        x:10
                        source: "qrc:icons/32_hdd_icon.png"
                        anchors.verticalCenter: parent.verticalCenter
                        height: parent.height
                    }

                    Text {
                        x:50
                        width: 50
                        font.bold: true
                        font.pointSize: 8
                        anchors.verticalCenter: parent.verticalCenter
                        text: "file://"
                    }

                    Rectangle {
                        width: 2
                        x: 90
                        height: parent.height
                        color: "lightblue"
                    }

                    TextInput {
                        id: file_browser_path_text
                        x:95
                        width: view.width - 135
                        maximumLength: 130
                        anchors.verticalCenter: parent.verticalCenter
                        text: view.path.replace("file://", "")
                        wrapMode: Text.WrapAnywhere
                        font.pointSize: 10
                        selectByMouse: true

                        Keys.onReturnPressed: {
                            if(fsModel.isDirQML(text)) {
                                path = "file://" + file_browser_path_text.text
                            }
                        }
                    }

                    RoundButton {
                        id: file_browser_path_go
                        x: file_browser_path_text.width + file_browser_path_text.x
                        radius: 20
                        height: parent.height
                        icon.source: "qrc:icons/32_go_icon.png"
                        icon.color: "transparent"
                        onClicked: {
                            path = "file://" + file_browser_path_text.text
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
                            font.pointSize: 10
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                folder.sortField = FolderListModel.Name
                                if(folder.sortReversed) {
                                    folder.sortReversed = false
                                } else {
                                    folder.sortReversed = true
                                }

                                console.log("Sorting")
                            }
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
                            font.pointSize: 10
                        }
                    }
                }

            }

            highlight: Rectangle {
                color: "lightblue"
                opacity: 0.5
                z: 0
            }

            highlightFollowsCurrentItem: true
            highlightMoveDuration:1
            smooth: true
            footerPositioning: ListView.OverlayFooter
            // ------------- footer -------------
            footer: Rectangle {
                width: browser.width
                height: 40
                z:2
                color: "#ededed"

                Column {
                    height: parent.height
                    // ------------- search row -------------
                    Row {
                        Rectangle {
                            width: browser.width - file_search_btn.width
                            height: 20
                            border.color: "gray"
                            border.width: 1
                            radius: 20

                            Image {
                                x: 5
                                y: 2
                                source: "qrc:icons/24_find_icon.png"
                            }
                            // ------------- search input field -------------
                            TextInput {
                                id: file_search_txt
                                x:30
                                text: ""
                                selectByMouse: true
                                width: parent.width
                                anchors.verticalCenter: parent.verticalCenter
                                maximumLength: 25

                                onActiveFocusChanged: {
                                    if(text.length > 0) {
                                        file_search_txt.focus = true
                                        file_search_txt.cursorPosition = length;
                                    }
                                }

                                onTextChanged: {
                                    folder.nameFilters = ["*" + text + "*"]
                                }
                            }
                        }
                        // ------------- clear button -------------
                        RoundButton {
                            id: file_search_btn
                            icon.source: "qrc:icons/32_clear_icon.png"
                            icon.color: "transparent"
                            onClicked: {
                                file_search_txt.clear()
                            }
                        }
                    }
                }
                // ------------- bottom status -------------
                Text {
                    y: 22
                    width: parent.width
                    height: 20
                    font.pointSize: 9
                    text: {
                        if(folder.count == 1) {
                            folder.count + " Item"
                        } else {
                            folder.count + " Items"
                        }
                    }
                }
            }
        }
    }
}
