import QtQuick 2.11
import QtQuick.Window 2.3
import QtQml.Models 2.3
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Window {
    id: create_item_win
    x: 100; y: 100; width: 300; height: 100
    minimumHeight: 100; maximumHeight: 100
    minimumWidth: 250

    property var win_title: String
    property var create_action: Number

    title: win_title

    Rectangle {
        width: parent.width
        height: parent.height

        Rectangle {
            x: 10
            y: 10
            width: parent.width - x - 10
            height: 34
            border.color: "black"
            color: "white"
            border.width: 1

            TextInput {
                id: itemName
                x: 5
                width: parent.width
                anchors.verticalCenter: parent.verticalCenter
                text: "Bucket name"
                maximumLength: 128
            }
        }

        Row {
            y: 55
            anchors.horizontalCenter: parent.horizontalCenter

            Button {
                id: cw_cb
                text: "Create"
                onClicked: {
                    if (create_action === 0) {
                        s3Model.createBucketQML(itemName.text)
                    } else {
                        s3Model.createFolderQML(itemName.text)
                    }
                    s3Model.refreshQML()
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
