import QtQuick 2.9
import QtQuick.Window 2.2
import QtQml.Models 2.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.0
import QtQuick.Controls.Material 2.1

ApplicationWindow {
    id: app_window
    visible: true
    width: 800
    height: 480
    title: qsTr("s3FileBrowser")

    property var createBucketWindow: CreateItemWindow {
        win_title: "Create bucket"
        create_action: 0
    }

    property var createFolderWindow: CreateItemWindow {
        win_title: "Create folder"
        create_action: 1
    }

    statusBar: StatusBar {
            RowLayout {
                anchors.fill: parent
                Label { text: "Read Only" }
            }
        }

    menuBar: MenuBar {
        id: menu_bar
        Menu {
            title: "File"
            MenuItem {
                text: "Close"
                iconSource: "icons/32_up_icon.png"
                onTriggered: Qt.quit();
            }
        }

        Menu {
            title: "S3"
            MenuItem {
                text: "Connect..."
                onTriggered: s3Model.getBuckets()
            }
            MenuSeparator { }
            MenuItem {
                text: "Create bucket"
                onTriggered: {
                    createBucketWindow.visible = true
                }
            }
            MenuItem { text: "Create directory" }
            MenuItem { text: "Download" }
            MenuItem { text: "Upload" }
        }

        Menu {
            title: "Bookmarks"
            MenuItem { text: "Create bookmark" }
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
        anchors.topMargin: 12
        anchors.fill: parent
        //anchors.margins: 2 * 12 + row.height

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
            width: 32
            height: parent.height
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
