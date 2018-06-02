import QtQuick 2.0

Rectangle {
    id:delegate
    width: view.width
    height:34
    color: "white"
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
        onClicked: {
            view.currentIndex = index
        }
        onDoubleClicked: fileIsDir ? view.path = fileURL : Qt.openUrlExternally(fileURL)
    }
}
