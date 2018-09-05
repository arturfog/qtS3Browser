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
import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.3
import QtQuick.Dialogs 1.2
import Qt.labs.folderlistmodel 2.2

import QtQuick.Layouts 1.3

Item {
    id: browser
    width: 300
    property alias path: view.path

    property bool connected: false
    property CustomMessageDialog msgDialog: CustomMessageDialog {
        win_title: "Remove?"
        msg: {
            var fileName = folder.get(view.currentIndex, "fileName")
            "Remove " + fileName + " ?"
        }
    }



    Keys.onUpPressed: {
        var newIndex = view.currentIndex - 1;
        if (newIndex < 0) {
            newIndex = 0
        }
        view.currentIndex = newIndex
    }

    Keys.onDownPressed: {
        var newIndex = view.currentIndex + 1;
        if (newIndex >= view.count) {
            newIndex = view.count - 1;
        } else {
            view.currentIndex = newIndex
        }
    }

    Keys.onReturnPressed: {
        var url = folder.get(view.currentIndex, "fileURL")
        folder.get(view.currentIndex, "fileIsDir") ? view.path = url : Qt.openUrlExternally(url)
    }

    Keys.onDeletePressed: {
        if(folder.parentFolder.toString().length > 0) {
            view.path = folder.parentFolder
        }
    }

    focus: true

    ToolBar {
        width: parent.width
        height: 48

        Row {
            anchors.fill: parent
            ToolButton {
                height: parent.height
                icon.source: "qrc:icons/32_up_icon.png"
                icon.color: "transparent"
                text: qsTr("Up")
                onClicked: {
                    if(folder.parentFolder.toString().length > 0) {
                        view.path = folder.parentFolder
                    }
                }
            }

            ToolButton {
                height: parent.height
                icon.source: "qrc:icons/32_refresh_icon.png"
                icon.color: "transparent"
                text: qsTr("Refresh")
            }

            ToolButton {
                id: file_upload_btn
                height: parent.height
                icon.source: "qrc:icons/32_upload_icon.png"
                icon.color: "transparent"
                text: qsTr("Upload")
                enabled: connected
                onClicked: {
                    var filePath = folder.get(view.currentIndex, "filePath")
                    app_window.progressWindow.visible = true
                    if(!folder.get(view.currentIndex, "fileIsDir")) {
                        s3Model.uploadFileQML(filePath)
                    } else {
                        s3Model.uploadDirQML(filePath)
                    }
                }
            }

            ToolButton {
                height: parent.height
                icon.source: "qrc:icons/32_delete_icon.png"
                icon.color: "transparent"
                text: qsTr("Delete")
                onClicked: {
                    msgDialog.open()
                }
            }

            ToolButton {
                height: parent.height
                icon.source: "qrc:icons/32_new_folder_icon.png"
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
                        icon.source: "qrc:icons/32_go_icon.png"
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

            footerPositioning: ListView.OverlayFooter
            footer: Rectangle {
                width: browser.width
                height: 40
                z:2
                color: "#ededed"

                Column {
                    height: parent.height
                    Row {
                        Rectangle {
                            width: browser.width - file_search_btn.width
                            height: 20
                            border.color: "orange"
                            border.width: 1
                            radius: 10
                            TextInput {
                                x:10
                                text: ""
                                width: parent.width
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                        RoundButton {
                            id: file_search_btn
                            height: 20
                            icon.source: "qrc:icons/32_go_icon.png"
                            icon.color: "transparent"
                            flat: true
                        }
                    }

                    Text {
                        width: parent.width
                        height: 20
                        text: "["+folder.count+" Items]"
                        //anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }
    }
}
