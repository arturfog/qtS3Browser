import QtQuick 2.11
import QtQuick.Layouts 1.3

Rectangle {
    id:delegate
    width: view.width
    height:34
    color: "transparent"

    Row {
        anchors.fill: parent

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
            width: parent.width - 130
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
