import QtQuick 2.11
import QtQuick.Window 2.3
import QtQml.Models 2.3
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Window {
    id: settings_win
    x: 100; y: 100; width: 300; height: 200
    minimumHeight: 200; maximumHeight: 200
    minimumWidth: 200

    title: "Settings"

    Rectangle {
        width: parent.width
        height: parent.height
        color: "transparent"

        Rectangle {
            x: 10
            y: 10
            width: parent.width - 20
            height: 34

            Text {
                width: parent.width
                anchors.verticalCenter: parent.verticalCenter
                text: "S3 start path"
            }
        }

        Rectangle {
            x: 10
            y: 55
            width: parent.width - 20
            height: 34
            border.color: "black"
            color: "white"
            border.width: 1

            TextInput {
                id: startPath
                x: 5
                width: parent.width
                anchors.verticalCenter: parent.verticalCenter
                text: "s3://"
                maximumLength: 128
            }
        }

        Row {
            y: 110
            anchors.horizontalCenter: parent.horizontalCenter

            Button {
                text: "Save"
                onClicked: {
                    close()
                }
            }

            Rectangle {
                width: 5
                height: parent.height
            }


            Button {
                text: "Cancel"
                onClicked: {
                    close()
                }
            }
        }
    }
}
