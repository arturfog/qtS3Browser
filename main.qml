import QtQuick 2.9
import QtQuick.Window 2.2
import QtQml.Models 2.2
import QtQuick.Controls 1.5

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("s3FileBrowser")


    Row {
        anchors.top: parent.top
        anchors.topMargin: 12
        anchors.fill: parent
        anchors.margins: 2 * 12 + row.height

       FileBrowser {
           anchors.margins: 24
           id: view1
       }

       FileBrowser {
           anchors.margins: 24
           id: view2
       }
    }
}
