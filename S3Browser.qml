import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import Qt.labs.folderlistmodel 2.1

Item {
    id: browser
    property alias path: view.path
    width: 300
    height: 200

    Row {
        width: parent.width
        height: 38
        Button {
            width:48
            iconSource: "icons/32_up_icon.png"
            onClicked: view.path = folder.parentFolder
        }

        Button {
            width: 48
            iconSource: "icons/32_refresh_icon.png"
        }

        Button {
            width: 48
            iconSource: "icons/32_download_icon.png"
        }
    }

    Row {
        width: parent.width
        height: parent.height - 38
        y: 38
        ListView {
            id: view
            property var colors: ["white","lightgray","white","lightgray" ]
            property string path

            width: parent.width
            height: parent.height

            model: s3Model

            delegate: S3ObjectDelegate { }

            headerPositioning: ListView.OverlayHeader

            header: Rectangle {
                width: browser.width
                height: 34
                z:2
                color: "orange"
                border.color: "black"
                border.width: 1

                TextInput {
                    anchors.verticalCenter: parent.verticalCenter
                    text: s3Model.getS3Path()
                }
            }
            footerPositioning: ListView.OverlayHeader
            footer: Rectangle {
                width: browser.width
                height: 34
                color: "orange"
                z:2
                Row {
                    anchors.fill: parent
                    Text {
                        text: "["+s3Model.rowCount()+" Files]"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }
    }
}
