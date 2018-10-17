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
import QtQuick 2.5
import QtQuick.Controls 2.3
import QtQuick.Dialogs 1.1
import Qt.labs.folderlistmodel 2.0
import QtQuick.Layouts 1.0

Item {
    id: s3_browser

    width: 300
    height: 400

    property alias path: view.path

    property bool connected: false
    property string footerText: ""
    property CustomMessageDialog msgDialog: CustomMessageDialog {
        win_title: "Remove?"
        yesAction: function() {
            s3Model.removeQML(view.currentIndex);
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

    focus: true

    ToolBar {
        width: parent.width
        height: 48
        id: top_buttons_row

        Row {
            anchors.fill: parent
            ToolButton {
                font.pointSize: uiFontSize
                height: parent.height
                icon.source: "qrc:icons/32_up_icon.png"
                icon.color: "transparent"
                text: "Up"
                enabled: connected
                onClicked: {
                    s3Model.goBackQML()
                    path = s3Model.getS3PathQML()
                }
            }

            ToolButton {
                id: s3_refresh_btn
                font.pointSize: uiFontSize
                height: parent.height
                icon.source: "qrc:icons/32_refresh_icon.png"
                icon.color: "transparent"
                text: "Refresh"
                enabled: connected
                onClicked: s3Model.refreshQML()
            }

            ToolButton {
                id: s3_download_btn
                font.pointSize: uiFontSize
                height: parent.height
                icon.source: "qrc:icons/32_download_icon.png"
                icon.color: "transparent"
                text: "Download"
                enabled: connected && s3Model.canDownload()
                onClicked: {
                    app_window.progressWindow.title = qsTr("Download progress ...")
                    app_window.progressWindow.icon = "qrc:icons/32_download_icon.png"
                    app_window.progressWindow.visible = true
                    s3Model.downloadQML(view.currentIndex)

                }
            }

            ToolButton {
                font.pointSize: uiFontSize
                height: parent.height
                icon.source: "qrc:icons/32_delete_icon.png"
                icon.color: "transparent"
                text: "Delete"
                enabled: connected
                onClicked: {
                    var fileName = s3Model.getItemNameQML(view.currentIndex)
                    msgDialog.msg = "Remove " + fileName + " ?"
                    msgDialog.open()
                }
            }

            ToolButton {
                id: s3_create_dir_btn
                font.pointSize: uiFontSize
                height: parent.height
                icon.source: "qrc:icons/32_new_folder_icon.png"
                icon.color: "transparent"
                text: "New"
                enabled: false
                onClicked: {
                    createS3FolderWindow.x = app_window.x + (app_window.width / 2) - (createS3FolderWindow.width / 2)
                    createS3FolderWindow.y = app_window.y + (app_window.height / 2) - (createS3FolderWindow.height / 2)
                    createS3FolderWindow.create_action = createS3FolderWindow.createS3Folder
                    createS3FolderWindow.visible = true
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
                width: s3_browser.width
                height: 72
                z:2

                Rectangle {
                    width: parent.width - 2
                    border.width: 2
                    border.color: "orange"
                    height: 38
                    color: "#ffebcc"
                    radius: 20

                    Image {
                        x:10
                        source: "qrc:icons/32_amazon_icon.png"
                        anchors.verticalCenter: parent.verticalCenter
                        height: parent.height
                    }

                    Text {
                        x:50
                        width: 50
                        font.bold: true
                        font.pointSize: 8
                        anchors.verticalCenter: parent.verticalCenter
                        text: "s3://"
                    }

                    Rectangle {
                        width: 2
                        x: 90
                        height: parent.height
                        color: "orange"
                    }

                    TextInput {
                        id: s3_browser_path_text
                        x:95
                        font.pointSize: 10
                        selectByMouse: true
                        width: parent.width - s3_browser_path_go.width - 2
                        anchors.verticalCenter: parent.verticalCenter
                        wrapMode: Text.WrapAnywhere
                        text: path.replace("s3://","")
                    }

                    RoundButton {
                        id: s3_browser_path_go
                        x: s3_browser_path_text.width
                        height: parent.height
                        icon.source: "qrc:icons/32_go_icon.png"
                        icon.color: "transparent"
                        onClicked: {
                            if(s3_browser_path_text.text === "") {
                                s3Model.getBucketsQML()
                            } else {
                                s3Model.gotoQML("s3://" + s3_browser_path_text.text)
                            }
                            s3_panel.connected = s3Model.isConnectedQML()
                            file_panel.connected = s3Model.isConnectedQML()
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

            footerPositioning: ListView.OverlayHeader

            footer: Rectangle {
                id: s3_footer
                width: s3_browser.width
                height: 40
                color: "#ededed"
                z: 2

                Column {
                    anchors.fill: parent
                    Row {
                        Rectangle {
                            width: s3_browser.width - s3_search_btn.width
                            height: 20
                            border.color: "gray"
                            border.width: 1
                            radius: 20

                            Image {
                                x: 5
                                y: 2
                                source: "qrc:icons/24_find_icon.png"
                            }

                            TextInput {
                                id: s3_search_txt
                                x:30
                                text: ""
                                selectByMouse: true
                                width: parent.width
                                anchors.verticalCenter: parent.verticalCenter

                                onTextChanged: {
                                    if(text.length > 0) {
                                        s3Model.search(text)
                                    } else {
                                        s3Model.searchReset();
                                    }
                                }
                            }
                        }
                        RoundButton {
                            id: s3_search_btn
                            icon.source: "qrc:icons/32_clear_icon.png"
                            icon.color: "transparent"
                            onClicked: {
                                s3Model.searchReset()
                                s3_search_txt.clear()
                            }
                        }
                    }
                }

                Text {
                    y: 22
                    width: parent.width
                    height: 20
                    text: footerText
                }
            }
        }
    }
}
