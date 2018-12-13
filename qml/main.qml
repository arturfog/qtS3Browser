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
import QtQuick.Window 2.0
import QtQml.Models 2.1
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.0
import QtQuick.Controls.Material 2.0
import QtQuick.Dialogs 1.1

ApplicationWindow {
    id: app_window
    visible: true
    width: 960
    height: 480
    minimumWidth: 800
    minimumHeight: 400
    title: qsTr("s3FileBrowser")

    function getTinyFont() {
        if(Qt.platform.os == "windows") {
            return 7
        } else {
            return 9
        }
    }

    function getSmallFontSize() {
        if(Qt.platform.os == "windows") {
            return 8
        } else {
            return 10
        }
    }

    function getMediumFontSize() {
        if(Qt.platform.os == "windows") {
            return 10
        } else {
            return 12
        }
    }

    function getLargeFontSize() {
        if(Qt.platform.os == "windows") {
            return 12
        } else {
            return 14
        }
    }

    function getWindowFlags() {
        if(Qt.platform.os == "windows") {
            return Qt.Window
        }
        if(Qt.platform.os == "linux") {
            return Qt.WindowActive | Qt.WindowCloseButtonHint
        }

        return Qt.WindowStaysOnTopHint | Qt.WindowCloseButtonHint
    }

    property int uiFontSize: 10
    property int windowFlags: Qt.WindowStaysOnTopHint | Qt.WindowCloseButtonHint

    property CreateBookmarkWindow createBookmarkWindow: CreateBookmarkWindow {flags: getWindowFlags() }
    property SettingsWindow settingsWindow: SettingsWindow {flags: getWindowFlags()}
    property ManageBookmarksWindow manageBookmarksWindow: ManageBookmarksWindow {flags: getWindowFlags() }
    property OperationProgressWindow progressWindow: OperationProgressWindow {flags: getWindowFlags() }
    property InfoWindow infoWindow: InfoWindow {flags: getWindowFlags() }

    property CustomMessageDialog invalidCredentialsDialog: CustomMessageDialog {
        win_title: "Missing credentials"
        msg: "Before connecting, please configure access and secret keys in settings"
        buttons: StandardButton.Ok
        ico: StandardIcon.Warning
    }

    property CustomMessageDialog s3Error: CustomMessageDialog {
        win_title: "S3 Error"
        msg: ""
        buttons: StandardButton.Ok
        ico: StandardIcon.Warning
    }

    property CustomMessageDialog createBucketsDialog: CustomMessageDialog {
        win_title: "Create bucket ?"
        msg: "There are no buckets. Do you want to create one ?"
        yesAction: function() {
            createBucketWindow.visible = true
        }
    }

    property CreateItemWindow createBucketWindow: CreateItemWindow {
        win_title: qsTr("Create S3 bucket")
        flags: getWindowFlags()
    }

    property CreateItemWindow createS3FolderWindow: CreateItemWindow {
        win_title: qsTr("Create S3 folder")
        flags: getWindowFlags()
    }

    onAfterRendering: {
        mainPanel.s3_panel.connected = s3Model.isConnectedQML()
        mainPanel.file_panel.connected = s3Model.isConnectedQML()

        if(mainPanel.s3_panel.connected) {
            connect_btn.icon.source = "qrc:icons/32_disconnect_icon.png"
        }
    }

    Connections {
        target: s3Model
        onShowErrorSignal: {
            s3Error.msg = msg
            s3Error.open()
        }
    }

    Connections {
        target: s3Model
        onNoBucketsSignal: {
            if(s3Model.getItemsCountQML() === 0) {
                createBucketsDialog.open()
            }
        }
    }


    Row {
        height: parent.height
        width: parent.width
        // ------------ Gray 48px row on left ----------------
        Row {
            width: 48
            height: parent.height

            Rectangle {
                height: parent.height
                width: parent.width - 2
                color: "gray"

                Column {
                    width: 48
                    // ------------ Connect ----------------
                    Button {
                        id:connect_btn
                        width: 48
                        flat: true
                        icon.source: "qrc:icons/32_connect_icon.png"
                        icon.color: "transparent"

                        hoverEnabled: true
                        ToolTip.delay: 1000
                        ToolTip.timeout: 5000
                        ToolTip.visible: hovered
                        ToolTip.text: qsTr("Connect/Disconnect")

                        onClicked: {
                            if(!mainPanel.s3_panel.connected) {
                                var canDisconnect = false

                                if(s3Model.getStartPathQML() !== "s3://" && s3Model.getAccesKeyQML() !== "") {
                                    s3Model.gotoQML(s3Model.getStartPathQML())
                                    mainPanel.s3_panel.path = s3Model.getS3PathQML()
                                    canDisconnect = true
                                } else if (s3Model.getAccesKeyQML() !== ""){
                                    s3Model.getBucketsQML()
                                    canDisconnect = true
                                } else {
                                    invalidCredentialsDialog.open()
                                }
                            } else {
                                icon.source = "qrc:icons/32_connect_icon.png"
                                s3Model.clearItemsQML()
                                s3Model.setConnectedQML(false)
                                mainPanel.s3_panel.connected = s3Model.isConnectedQML()
                                mainPanel.file_panel.connected = s3Model.isConnectedQML()
                                mainPanel.s3_panel.path = s3Model.getStartPathQML()
                            }
                        }
                    }
                    // ------------ File manager ----------------
                    Button {
                        id: fm_btn
                        width: 48
                        flat: true
                        icon.source: "qrc:icons/32_fm_icon.png"
                        icon.color: "transparent"

                        down: true

                        hoverEnabled: true
                        ToolTip.delay: 1000
                        ToolTip.timeout: 5000
                        ToolTip.visible: hovered
                        ToolTip.text: qsTr("File/S3 manager")

                        onClicked: {
                            aboutPanel.visible = false
                            mainPanel.visible = true

                            fm_btn.down = true
                            about_btn.down = false
                        }
                    }
                    // ------------ Bookmarks ----------------
                    Button {
                        width: 48
                        flat: true
                        icon.source: "qrc:icons/32_bookmark2.png"
                        icon.color: "transparent"

                        hoverEnabled: true
                        ToolTip.delay: 1000
                        ToolTip.timeout: 5000
                        ToolTip.visible: hovered
                        ToolTip.text: qsTr("Bookmarks")

                        onClicked: {
                            manageBookmarksWindow.x = app_window.x + (app_window.width / 2) - (manageBookmarksWindow.width / 2)
                            manageBookmarksWindow.y = app_window.y + (app_window.height / 2) - (manageBookmarksWindow.height / 2)
                            manageBookmarksWindow.visible = true
                        }
                    }
                    // ------------ Settings ----------------
                    Button {
                        width: 48
                        flat: true
                        icon.source: "qrc:icons/32_settings_icon.png"
                        icon.color: "transparent"

                        hoverEnabled: true
                        ToolTip.delay: 1000
                        ToolTip.timeout: 5000
                        ToolTip.visible: hovered
                        ToolTip.text: qsTr("Settings")

                        onClicked: {
                            settingsWindow.x = app_window.x + (app_window.width / 2) - (settingsWindow.width / 2)
                            settingsWindow.y = app_window.y + (app_window.height / 2) - (settingsWindow.height / 2)
                            settingsWindow.visible = true
                        }
                    }
                    // ------------ About ----------------
                    Button {
                        id: about_btn
                        width: 48
                        flat: true
                        icon.source: "qrc:icons/32_about_icon.png"
                        icon.color: "transparent"

                        hoverEnabled: true
                        ToolTip.delay: 1000
                        ToolTip.timeout: 5000
                        ToolTip.visible: hovered
                        ToolTip.text: qsTr("About")

                        onClicked: {
                            mainPanel.visible = false
                            aboutPanel.visible = true

                            fm_btn.down = false
                            about_btn.down = true
                        }
                    }
                    // ------------ Close ----------------
                    Button {
                        width: 48
                        flat: true
                        icon.source: "qrc:icons/32_close_icon.png"
                        icon.color: "transparent"

                        hoverEnabled: true
                        ToolTip.delay: 1000
                        ToolTip.timeout: 5000
                        ToolTip.visible: hovered
                        ToolTip.text: qsTr("Close")

                        onClicked: {
                            s3Model.cancelDownloadUploadQML()
                            s3Model.clearItemsQML()
                            s3Model.setConnectedQML(false)
                            Qt.quit()
                        }
                    }
                }
            }
            // ------------ Black 1px bar on right side ----------------
            Column {
                width: 2
                height: parent.height

                Rectangle {
                    height: parent.height
                    width: 1
                    color: "black"
                }
            }
        }
        // ------------ Container for file and s3 browser ----------------
        Row {
            id:contentPanel
            focus: true
            //Keys.forwardTo: [file_panel, s3_panel]
            x:48
            anchors.top: parent.top
            height: parent.height
            width: parent.width - x

            MainPanel {
                id:mainPanel
            }

            AboutPanel {
                id:aboutPanel
                visible: false
            }
        }
    }
}
