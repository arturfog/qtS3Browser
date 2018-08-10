import QtQuick 2.11
import QtQuick.Window 2.3

Window {
    id: about_win
    x: 100; y: 100;
    minimumHeight: 350; maximumHeight: 350
    minimumWidth: 440; maximumWidth: 440

    title: "About qtS3Browser"

    Column {
        width: parent.width
        Image {
            id: app_icon_256
            source: "icons/256_app.png"
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Author: Artur"
            font.pointSize: 16
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: '<a href="https://github.com/arturfog/qtS3Browser">https://github.com/arturfog/qtS3Browser</a>'
            onLinkActivated: Qt.openUrlExternally("https://github.com/arturfog/qtS3Browser")
            font.pointSize: 14
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Copyright© 2018"
            font.pointSize: 12
        }
    }
}
