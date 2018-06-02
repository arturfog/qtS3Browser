import QtQuick 2.9
import QtQuick.Window 2.2
import QtQml.Models 2.2
import QtQuick.Controls 1.5
import QtQuick.Layouts 1.0

Window {
    id: create_item_win
    x: 100; y: 100; width: 300; height: 100

    property var win_title: String
    property var create_action: Number

    title: win_title

        Rectangle {
            width: parent.width
            height: 34
            z:2
            border.color: "black"
            border.width: 1

            TextInput {
                id: itemName
                anchors.verticalCenter: parent.verticalCenter
                text: "New"
            }
        }

        Row {
            y: 48
            height: 48
            width: 150
            anchors.horizontalCenter: parent.horizontalCenter
            Button {
                id: cw_cb
                text: "Create"
                onClicked: {
                    if (create_action === 0) {
                        s3Model.createBucket(itemName.text)
                        s3Model.refresh()
                        close()
                    } else {
                        s3Model.createFolder(itemName.text)
                    }
                }
            }
            Button {
                text: "Cancel"
                onClicked: {
                    close()
                }
            }
        }

}
