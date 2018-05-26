import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import Qt.labs.folderlistmodel 2.1

Item {
    id: browser
    property alias path: view.path
    width: 300
    height: 200
    ListView {
        id: view
        property var colors: ["white","#E0FFE0","white","#EEEEFF" ]
        property string path

        anchors.fill: parent

        model: s3Model

        delegate: FileDelegate { }

        headerPositioning: ListView.OverlayHeader

        header: Rectangle {
            width: browser.width
            height: 34
            color: "yellow"
            z:2
            Row {
                anchors.fill: parent
                Button {
                    width:32
                    height :32
                    text: "<<<"
                    onClicked: view.path = folder.parentFolder
                }
                Text {
                    text: s3Model.getS3Path()
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
        footerPositioning: ListView.OverlayHeader
        footer: Rectangle {
            width: browser.width
            height: 34
            color: "yellow"
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
