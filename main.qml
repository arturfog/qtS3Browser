import QtQuick 2.11
import QtQuick.Window 2.3
import QtQml.Models 2.3
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.2

ApplicationWindow {
    id: app_window
    visible: true
    width: 840
    height: 480
    minimumWidth: 840
    title: qsTr("s3FileBrowser")

    property var createBucketWindow: CreateItemWindow {
        win_title: qsTr("Create bucket")
        create_action: 0
    }

    property var createFolderWindow: CreateItemWindow {
        win_title: qsTr("Create folder")
        create_action: 1
    }

    property var createBookmarkWindow: CreateBookmarkWindow {}
    property var aboutWindow: AboutWindow {}
    property var settingsWindow: SettingsWindow {}
    property var manageBookmarksWindow: ManageBookmarksWindow {}
    property var progressWindow: OperationProgressWindow {}

    onAfterRendering: {
        s3_panel.connected = s3Model.isConnectedQML()
        file_panel.connected = s3Model.isConnectedQML()
    }

    menuBar: MenuBar {
        id: menu_bar

        Menu {
            title: qsTr("File")
            MenuItem {
                text: qsTr("Settings")
                icon.source: "icons/32_settings_icon.png"
                onTriggered: settingsWindow.visible = true
            }
            MenuSeparator { }
            MenuItem {
                text: qsTr("Close")
                icon.source: "icons/32_close_icon.png"
                onTriggered: Qt.quit();
            }
        }

        Menu {
            title: "S3"
            MenuItem {
                text: qsTr("Connect...")
                icon.source: "icons/32_connect_icon.png"
                onTriggered: {
                    if(s3Model.getStartPathQML() !== "s3://") {
                        s3Model.gotoQML(s3Model.getStartPathQML())
                        s3_panel.path = s3Model.getS3PathQML()
                    } else {
                        s3Model.getBucketsQML()
                    }

                }
                enabled: !s3_panel.connected

            }
            MenuSeparator { }
            MenuItem {
                text: qsTr("Create bucket")
                icon.source: "icons/32_bucket_icon.png"
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
                icon.source: "icons/32_new_folder_icon.png"
                enabled: false
            }
            MenuSeparator { }
            MenuItem {
                text: qsTr("Disconnect...")
                icon.source: "icons/32_disconnect_icon.png"
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
                icon.source: "icons/32_bookmark2.png"
                onTriggered: {
                    createBookmarkWindow.visible = true
                }
            }
            MenuItem {
                text: qsTr("Manage bookmarks")
                icon.source: "icons/32_edit_icon.png"
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
                    icon.source: "icons/32_bookmark.png"
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
                icon.source: "icons/32_about_icon.png"
                onTriggered: {
                    aboutWindow.visible = true
                }
            }
        }
    }


    Row {
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
