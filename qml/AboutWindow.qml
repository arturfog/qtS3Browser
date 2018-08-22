import QtQuick 2.11
import QtQuick.Window 2.3

Window {
    id: about_win
    x: 100; y: 100;
    minimumHeight: 360; maximumHeight: 360
    minimumWidth: 440; maximumWidth: 440

    title: "About qtS3Browser"

    Column {
        width: parent.width
        Image {
            id: app_icon_256
            source: "qrc:icons/256_app.png"
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "qtS3Browser v1.0"
            font.pointSize: 16
        }
        Rectangle {
            width: parent.width
            height: 10
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Author: Artur Fogiel"
            font.pointSize: 14
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: '<a href="https://github.com/arturfog/qtS3Browser">https://github.com/arturfog/qtS3Browser</a>'
            onLinkActivated: Qt.openUrlExternally("https://github.com/arturfog/qtS3Browser")
            font.pointSize: 12
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Copyright© 2018"
            font.pointSize: 10
        }
    }
}
