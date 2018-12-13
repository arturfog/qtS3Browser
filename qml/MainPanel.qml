import QtQuick 2.0

Row {
    property alias s3_panel: s3_panel
    property alias file_panel: file_panel

    width: parent.width
    height: parent.height

    Column {
        width: parent.width / 2
        height: parent.height

        FileBrowser {
            id: file_panel
            height: parent.height
            width: parent.width
            path: "file://" + fsModel.getHomePath()
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
