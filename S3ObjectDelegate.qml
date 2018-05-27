import QtQuick 2.0

Rectangle {
    id:delegate
    width: view.width
    height:34
    //color: view.colors[index & 3]
    Row {
        anchors.fill: parent
        Image {
            id: icon
            width: delegate.height - 2
            height:width
            source: "image://iconProvider/"+filePath
        }
        Text {
            id: i_fileName
            text: fileName
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    MouseArea {
        id:mouseArea
        anchors.fill: parent
        onDoubleClicked: s3Model.getObjects(i_fileName.text)
    }
}
