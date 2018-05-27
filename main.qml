import QtQuick 2.9
import QtQuick.Window 2.2
import QtQml.Models 2.2
import QtQuick.Controls 1.5
import QtQuick.Layouts 1.0

ApplicationWindow {
    visible: true
    width: 800
    height: 480
    title: qsTr("s3FileBrowser")

    property var testWindow: CreateItemWindow {

    }

    statusBar: StatusBar {
            RowLayout {
                anchors.fill: parent
                Label { text: "Read Only" }
            }
        }

    menuBar: MenuBar {
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
                onTriggered: s3Model.getBuckets()
            }
            MenuSeparator { }
            MenuItem {
                text: "Create bucket"
                onTriggered: {
                    testWindow.visible = true
                }
            }
            MenuItem { text: "Create directory" }
            MenuItem { text: "Download" }
            MenuItem { text: "Upload" }
            MenuSeparator { }
            MenuItem { text: "Disconnect" }
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
        anchors.margins: 2 * 12 + row.height

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
