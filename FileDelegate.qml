import QtQuick 2.0

Rectangle {
    id:delegate
    width: view.width
    height:34
    color: view.colors[index & 3]
    Row {
        anchors.fill: parent
        Image {
            id: icon
            width: delegate.height - 2
            height:width
            source: "image://iconProvider/"+filePath
        }
        Text {
            text: fileName
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    MouseArea {
        id:mouseArea
        anchors.fill: parent
        //onClicked: fileIsDir ? view.path = fileURL : Qt.openUrlExternally(fileURL)
        onClicked: fileIsDir ? view.path = fileURL : 0
    }
}
