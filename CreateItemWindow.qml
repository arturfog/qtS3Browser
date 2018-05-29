import QtQuick 2.9
import QtQuick.Window 2.2
import QtQml.Models 2.2
import QtQuick.Controls 1.5
import QtQuick.Layouts 1.0

Window {
    x: 100; y: 100; width: 300; height: 100
    title: "Create bucket"

        Rectangle {
            width: parent.width
            height: 34
            z:2
            border.color: "black"
            border.width: 1

            TextInput {
                id: itemName
                anchors.verticalCenter: parent.verticalCenter
                text: "view.path"
            }
        }

        Row {
            y: 48
            height: 48
            width: 150
            anchors.horizontalCenter: parent.horizontalCenter
            Button {
                text: "Create"
                onClicked: {
                    s3Model.createBucket(itemName.text)
                    s3Model.refresh()
                    close()
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
