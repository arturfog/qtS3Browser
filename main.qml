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
    minimumWidth: 800
    title: qsTr("s3FileBrowser")

    property var createBucketWindow: CreateItemWindow {
        win_title: "Create bucket"
        create_action: 0
    }

    property var createFolderWindow: CreateItemWindow {
        win_title: "Create folder"
        create_action: 1
    }

    property var createBookmarkWindow: CreateBookmarkWindow {

    }

    menuBar: MenuBar {
        id: menu_bar

        Menu {
            title: "File"
            MenuItem {
                text: "Close"
                onTriggered: Qt.quit();
            }
        }

        Menu {
            title: "S3"
            MenuItem {
                text: "Connect..."
                onTriggered: s3Model.getBucketsQML()
            }
            MenuSeparator { }
            MenuItem {
                text: "Create bucket"
                onTriggered: {
                    createBucketWindow.visible = true
                }
            }
            MenuItem {
                text: "Create directory"
                onTriggered: {
                    createFolderWindow.visible = true
                }
            }
            MenuItem { text: "Download" }
            MenuItem { text: "Upload" }
        }

        Menu {
            title: "Bookmarks"
            MenuItem {
                text: "Create bookmark"
                onTriggered: {
                    createBookmarkWindow.visible = true
                }
            }
            MenuSeparator { }
            MenuItem { text: "Empty" }
        }

        Menu {
            title: "Help"
            MenuItem { text: "About" }
        }
    }


    Row {
        anchors.top: parent.top
        anchors.fill: parent

        Column {
            width: parent.width / 2
            height: parent.height

            FileBrowser {
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
                height: parent.height
                width: parent.width
            }
        }
    }
}
