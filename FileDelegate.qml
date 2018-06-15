import QtQuick 2.0
import QtQuick.Layouts 1.1

Rectangle {
    id:delegate
    width: view.width
    height:34
    color: "transparent"
    Row {
        anchors.fill: parent
        spacing: 3

        Image {

            id: icon
            width: delegate.height - 2
            height:width
            source: "image://iconProvider/"+filePath
        }

        Text {
            wrapMode: Text.NoWrap
            elide: Text.ElideRight
            text: fileName
            width: parent.width - 140
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            width: 100
            text: {
                if (fileIsDir) {
                    "DIR"
                } else {
                    var size = folder.get(index, "fileSize")
                    var postfix = " B"

                    if (size > 1024) {
                        size = Math.floor(size / 1024)
                        postfix = " KB"
                    }

                    if (size > 1024) {
                        size = Math.floor(size / 1024)
                        return size + " MB"
                    }

                    return size + postfix
                }
            }
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
