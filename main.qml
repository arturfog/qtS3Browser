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

    statusBar: StatusBar {
            RowLayout {
                anchors.fill: parent
                Label { text: "Read Only" }
            }
        }

    menuBar: MenuBar {
        Menu {
            title: "File"
            MenuItem { text: "Open..." }
            MenuItem {
                text: "Close"
                onTriggered: Qt.quit();
            }
        }

        Menu {
            title: "Edit"
            MenuItem { text: "Cut" }
            MenuItem { text: "Copy" }
            MenuItem { text: "Paste" }
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
                anchors.fill: parent
                path: "file:///home/" // let's start with the Home folder
            }
        }

        Column {
            width: 30
            height: parent.height

            Button {
                width: parent.width
                text: Left
            }

            Button {
                width: parent.width
                text: Right
            }
        }

        Column {
            width: parent.width / 2
            height: parent.height
            S3Browser {
                anchors.fill: parent
                path: "file:///home/" // let's start with the Home folder
            }
        }
    }
}
