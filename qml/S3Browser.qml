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
        win_title: "Remove ?"
        yesAction: function() {
            s3Model.removeQML(view.currentIndex);
        }
    }

    property CustomMessageDialog overwriteDialog: CustomMessageDialog {
        win_title: "Overwrite ?"
        yesAction: function() { downloadInternal() }
    }

    property CustomMessageDialog s3Error: CustomMessageDialog {
        win_title: "S3 Error"
        msg: "There is transfer in progress. Please wait for it to complete."
        buttons: StandardButton.Ok
        ico: StandardIcon.Warning
    }

    function downloadInternal() {
        if(!s3Model.isTransferring()) {
            s3Model.downloadQML(view.currentIndex)
            switchPanel(transfer_btn, progressPanel)
        } else {
            // download in progress, add transfer to queue
            var fileName = s3Model.getItemNameQML(view.currentIndex)
            var s3path = "s3://" + s3Model.getS3PathQML() + fileName

            var path = s3Model.getFileBrowserPath()
            var localPath = "file://" + path + fileName
            ftModel.addTransferQML(fileName, s3path, localPath)
        }
    }

    function download() {
        var fileName = s3Model.getItemNameQML(view.currentIndex)
        var path = s3Model.getFileBrowserPath()

        if(fsModel.fileExistsQML(path + fileName)) {
            overwriteDialog.msg = "File " + fileName + " exists. Overwrite ?"
            overwriteDialog.visible = true
        } else {
            downloadInternal()
        }
    }

    ToolBar {
        width: parent.width
        height: 48
        id: top_buttons_row

        Row {
            anchors.fill: parent
            ToolButton {
                font.pointSize: getSmallFontSize()
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
                font.pointSize: getSmallFontSize()
                height: parent.height
                icon.source: "qrc:icons/32_refresh_icon.png"
                icon.color: "transparent"
                text: "Refresh"
                enabled: connected
                onClicked: s3Model.refreshQML()
            }

            ToolButton {
                id: s3_create_dir_btn
                font.pointSize: getSmallFontSize()
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

            ToolButton {
                font.pointSize: getSmallFontSize()
                height: parent.height
                text: qsTr("Create bucket")
                icon.source: "qrc:icons/32_bucket_icon.png"
                icon.color: "transparent"
                enabled: s3_panel.connected
                onClicked: {
                    createBucketWindow.x = app_window.x + (app_window.width / 2) - (createBucketWindow.width / 2)
                    createBucketWindow.y = app_window.y + (app_window.height / 2) - (createBucketWindow.height / 2)
                    createBucketWindow.create_action = createBucketWindow.createBucket
                    createBucketWindow.visible = true
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
                        font.pointSize: getTinyFont()
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
                        font.pointSize: getSmallFontSize()
                        selectByMouse: true
                        width: parent.width - 135
                        anchors.verticalCenter: parent.verticalCenter
                        wrapMode: Text.WrapAnywhere
                        text: path.replace("s3://","")

                        Keys.onReturnPressed: {
                            if(s3_browser_path_text.text === "") {
                                s3Model.getBucketsQML()
                            } else {
                                s3Model.gotoQML("s3://" + s3_browser_path_text.text)
                            }
                            s3_panel.connected = s3Model.isConnectedQML()
                            file_panel.connected = s3Model.isConnectedQML()
                        }
                    }

                    Button {
                        id: s3_browser_path_go
                        x: s3_browser_path_text.width + s3_browser_path_text.x
                        height: parent.height
                        icon.source: "qrc:icons/32_go_icon.png"
                        icon.color: "transparent"
                        flat: true
                        width: 40
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
                            font.pointSize: getSmallFontSize()
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
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
                            font.pointSize: getSmallFontSize()
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
                id: s3_footer
                width: s3_browser.width
                height: 40
                color: "#ededed"
                z: 2
                visible: connected

                Column {
                    height: parent.height
                    // ------------- search row -------------
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
                            // ------------- search input field -------------
                            TextInput {
                                id: s3_search_txt
                                x:30
                                text: ""
                                selectByMouse: true
                                maximumLength: 25
                                width: parent.width
                                anchors.verticalCenter: parent.verticalCenter

                                onActiveFocusChanged: {
                                    if(text.length > 0) {
                                        s3_search_txt.focus = true
                                        s3_search_txt.cursorPosition = length;
                                    }
                                }

                                onTextChanged: {
                                    if(text.length > 0) {
                                        s3Model.search(text);
                                    } else {
                                        s3Model.searchReset();
                                    }
                                }
                            }
                        }
                        // ------------- clear button -------------
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
                // ------------- bottom status -------------
                Text {
                    y: 22
                    width: parent.width
                    height: 20
                    font.pointSize: getTinyFont()
                    text: footerText
                }
            }
        }
    }
}
