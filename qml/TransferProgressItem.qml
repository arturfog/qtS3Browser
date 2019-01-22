import QtQuick 2.5;
import QtQuick.Controls 2.2;

Rectangle {
    property string key: ""
    property int currentProgress: 0
    property int currentBytes: 0
    property int totalBytes: 0

    x: 5
    width: parent.width - 10;
    height: 65
    color: "transparent"

    Row {
        x: 10
        y: 4
        width: parent.width
        height: 40

        Text {
            wrapMode: Text.NoWrap
            elide: Text.ElideRight
            width: parent.width - 560
            height: 40
            text: key
            verticalAlignment: Text.AlignVCenter
            font.pointSize: getSmallFontSize()
        }

        Rectangle {
            width: 5
            height: parent.height
            color: "transparent"
        }

        Rectangle {
            width: 1
            color: "#dbdbdb"
            height: parent.height - 5
        }

        Rectangle {
            width: 5
            height: parent.height
            color: "transparent"
        }

        ProgressBar {
            id: current_pb
            height: parent.height
            width: 160
            value: currentProgress
            to: 100.0
        }

        Rectangle {
            width: 5
            height: parent.height
            color: "transparent"
        }

        Rectangle {
            width: 1
            color: "#dbdbdb"
            height: parent.height - 5
        }

        Rectangle {
            width: 5
            height: parent.height
            color: "transparent"
        }

        Text {
            height: 40
            text: Number(currentProgress)  + " %"
            verticalAlignment: Text.AlignVCenter
            font.pointSize: getSmallFontSize()
        }

        Rectangle {
            width: 5
            height: parent.height
            color: "transparent"
        }

        Rectangle {
            width: 1
            color: "#dbdbdb"
            height: parent.height - 5
        }

        Rectangle {
            width: 5
            height: parent.height
            color: "transparent"
        }

        Image {
            source: "qrc:icons/32_server_icon.png"
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            height: 40
            width: 120
            text: qsTr("Copied: ") + getSizeString(currentBytes) + tsMgr.emptyString
            verticalAlignment: Text.AlignVCenter
            font.pointSize: getSmallFontSize()
        }

        Rectangle {
            width: 5
            height: parent.height
            color: "transparent"
        }

        Rectangle {
            width: 1
            color: "#dbdbdb"
            height: parent.height - 5
        }

        Rectangle {
            width: 5
            height: parent.height
            color: "transparent"
        }

        Image {
            source: "qrc:icons/32_hdd_icon2.png"
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            height: 40
            text: qsTr("Total: ") + getSizeString(totalBytes) + tsMgr.emptyString
            verticalAlignment: Text.AlignVCenter
            font.pointSize: getSmallFontSize()
        }
    }

    Rectangle {
        width: parent.width
        color: "gray"
        height: 1
    }
}
