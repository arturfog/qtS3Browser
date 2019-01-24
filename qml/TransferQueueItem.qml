import QtQuick 2.5;
import QtQuick.Controls 2.2;

Rectangle {
    id: queueItem
    property string srcPath: ""
    property string dstPath: ""
    property string icon: ""
    property int i: 0
    property variant keys: [""]

    x: 5
    width: parent.width - 10;
    height: 65
    color: "transparent"

    Row {
        width: parent.width;
        height: 45
        anchors.verticalCenter: parent.verticalCenter
        id: bookmarks_item
        x: 10

        Image
        {
            source: "qrc:icons/" + icon
        }

        Rectangle
        {
            width: 10
            height: 10
        }

        Column {
            width: parent.width - 220;
            Text {
                font.pointSize: 14
                text: keys[i]
            }

            Text {
                font.pointSize: 8
                text: '<a href="' + srcPath +'">' + srcPath + '</a>'
            }
            Text {
                font.pointSize: 8
                text: dstPath
            }
        }

        Button {
            text: "Cancel"
            icon.source: "qrc:icons/32_cancel_icon.png"
            icon.color: "transparent"
            onClicked: {
                ftModel.removeTransferQML(i)
                updateTransfersQueue()
            }
        }
    }

    Rectangle {
        width: parent.width
        color: "gray"
        height: 1
    }
}
