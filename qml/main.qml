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
import QtQuick.Window 2.3
import QtQml.Models 2.3
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.2
import QtQuick.Dialogs 1.2

ApplicationWindow {
    id: app_window
    visible: true
    width: 840
    height: 480
    minimumWidth: 840
    title: qsTr("s3FileBrowser")

    property CreateItemWindow createBucketWindow: CreateItemWindow {
        win_title: qsTr("Create bucket")
        create_action: 0
    }

    property CreateItemWindow createFolderWindow: CreateItemWindow {
        win_title: qsTr("Create folder")
        create_action: 1
    }

    property CreateBookmarkWindow createBookmarkWindow: CreateBookmarkWindow {}
    property AboutWindow aboutWindow: AboutWindow {}
    property SettingsWindow settingsWindow: SettingsWindow {}
    property ManageBookmarksWindow manageBookmarksWindow: ManageBookmarksWindow {}
    property OperationProgressWindow progressWindow: OperationProgressWindow {}

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

    onAfterRendering: {
        s3_panel.connected = s3Model.isConnectedQML()
        file_panel.connected = s3Model.isConnectedQML()
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

    menuBar: MenuBar {
        id: menu_bar

        Menu {
            title: qsTr("File")
            MenuItem {
                text: qsTr("Settings")
                icon.source: "qrc:icons/32_settings_icon.png"
                onTriggered: settingsWindow.visible = true
            }
            MenuSeparator { }
            MenuItem {
                text: qsTr("Close")
                icon.source: "qrc:icons/32_close_icon.png"
                onTriggered: Qt.quit();
            }
        }

        Menu {
            title: "S3"
            MenuItem {
                text: qsTr("Connect...")
                icon.source: "qrc:icons/32_connect_icon.png"
                onTriggered: {
                    if(s3Model.getStartPathQML() !== "s3://" && s3Model.getAccesKeyQML() !== "") {
                        s3Model.gotoQML(s3Model.getStartPathQML())
                        s3_panel.path = s3Model.getS3PathQML()
                    } else if (s3Model.getAccesKeyQML() !== ""){
                        s3Model.getBucketsQML()
                    } else {
                        invalidCredentialsDialog.open()
                    }

                }
                enabled: !s3_panel.connected

            }
            MenuSeparator { }
            MenuItem {
                text: qsTr("Create bucket")
                icon.source: "qrc:icons/32_bucket_icon.png"
                onTriggered: {
                    createBucketWindow.visible = true
                }
                enabled: s3_panel.connected
            }
            MenuItem {
                id: menu_s3_create_dir
                text: qsTr("Create directory")
                onTriggered: {
                    createFolderWindow.visible = true
                }
                icon.source: "qrc:icons/32_new_folder_icon.png"
                enabled: false
            }
            MenuSeparator { }
            MenuItem {
                text: qsTr("Disconnect...")
                icon.source: "qrc:icons/32_disconnect_icon.png"
                onTriggered: {
                    s3Model.clearItemsQML()
                    s3Model.setConnectedQML(false)
                    s3_panel.connected = s3Model.isConnectedQML()
                    file_panel.connected = s3Model.isConnectedQML()
                    s3_panel.path = s3Model.getStartPathQML()
                }
                enabled: s3_panel.connected

            }
        }

        Menu {
            id: bookmarks_menu
            title: qsTr("Bookmarks")
            onOpened: addBookmarks()

            MenuItem {
                text: qsTr("Create bookmark")
                icon.source: "qrc:icons/32_bookmark2.png"
                onTriggered: {
                    createBookmarkWindow.visible = true
                }
            }
            MenuItem {
                text: qsTr("Manage bookmarks")
                icon.source: "qrc:icons/32_edit_icon.png"
                onTriggered: {
                    manageBookmarksWindow.visible = true
                }
            }
            MenuSeparator { }

            function addBookmarks() {
                var bookmarksLen = s3Model.getBookmarksNumQML();
                if(bookmarksLen > 0) {
                    var keys = s3Model.getBookmarksKeysQML()
                    for(var i = 0; i < bookmarksLen; i++){
                        if(bookmarks_menu.count <= 3 + i) {
                            bookmarks_menu.addItem(menuItem.createObject(bookmarks_menu, { text: keys[i] }))
                        }
                    }
                }
            }

            Component {
                id: menuItem
                MenuItem {
                    icon.source: "qrc:icons/32_bookmark.png"
                    icon.color: "transparent"
                    onTriggered: {
                        var links = s3Model.getBookmarksLinksQML()
                        s3Model.gotoQML(links[bookmarks_menu.currentIndex - 3])
                        s3_panel.path = s3Model.getS3PathQML()
                        s3_panel.connected = s3Model.isConnectedQML()
                        file_panel.connected = s3Model.isConnectedQML()
                    }
                }
            }
        }

        Menu {
            title: qsTr("Help")
            MenuItem {
                text: qsTr("About")
                icon.source: "qrc:icons/32_about_icon.png"
                onTriggered: {
                    aboutWindow.visible = true
                }
            }
        }
    }


    Row {
        focus: true
        Keys.forwardTo: [file_panel, s3_panel]

        anchors.top: parent.top
        anchors.fill: parent

        Column {
            width: parent.width / 2
            height: parent.height

            FileBrowser {
                id: file_panel
                height: parent.height
                width: parent.width
                path: "file:///home/" // let's start with the Home folder
            }
        }

        Column {
            width: 3
            height: parent.height

            Rectangle {
                height: parent.height
                width: 1
                anchors.horizontalCenter: parent.horizontalCenter
                color: "black"
            }
        }

        Column {
            width: parent.width / 2
            height: parent.height
            S3Browser {
                id: s3_panel
                height: parent.height
                width: parent.width
            }
        }
    }
}
