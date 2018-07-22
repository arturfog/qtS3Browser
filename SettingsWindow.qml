import QtQuick 2.11
import QtQuick.Window 2.3
import QtQml.Models 2.3
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Window {
    id: settings_win
    x: 100; y: 100; width: 400; height: 400
    minimumHeight: 300; maximumHeight: 400
    minimumWidth: 300

    title: "Settings"

    Column {
        width: parent.width
        height: parent.height

        Rectangle {
            x: 10
            y: 10
            width: parent.width - 20
            height: 34

            Text {
                width: parent.width
                anchors.verticalCenter: parent.verticalCenter
                text: "S3 Start Path"
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

        Rectangle {
            x: 10
            y: 10
            width: parent.width - 20
            height: 34

            Text {
                width: parent.width
                anchors.verticalCenter: parent.verticalCenter
                text: "Secret Key"
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
                id: secretKey
                x: 5
                width: parent.width
                anchors.verticalCenter: parent.verticalCenter
                text: "Secret Key"
                maximumLength: 128
            }
        }

        Rectangle {
            x: 10
            y: 10
            width: parent.width - 20
            height: 34

            Text {
                width: parent.width
                anchors.verticalCenter: parent.verticalCenter
                text: "Access Key"
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
                id: accessKey
                x: 5
                width: parent.width
                anchors.verticalCenter: parent.verticalCenter
                text: "Access Key"
                maximumLength: 128
            }
        }

        Rectangle {
            x: 10
            y: 10
            width: parent.width - 20
            height: 34

            Text {
                width: parent.width
                anchors.verticalCenter: parent.verticalCenter
                text: "Region"
            }
        }

        Rectangle {
            x: 10
            y: 55
            width: parent.width - 20
            height: 40
            border.color: "black"
            color: "white"
            border.width: 1

            ComboBox {
                width: parent.width
                model: [ "Default",
                    "us-east-1 (N. Virginia)",
                    "us-east-2 (Ohio)",
                    "eu-central-1 (Frankfurt)",
                    "eu-west-1 (Ireland)",
                    "eu-west-2 (London)",
                    "eu-west-3 (Paris)" ]
            }
        }

        Rectangle {
            x: 10
            y: 55
            width: parent.width - 20
            height: 50

            Row {
                y: 10
                height: parent.height
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
}
