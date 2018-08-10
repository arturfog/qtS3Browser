import QtQuick 2.11

Rectangle {
    onFocusChanged: {
        if(filePath == "/") {
            s3_download_btn.enabled = false
        } else {
            s3_download_btn.enabled = true
        }

        if(s3Model.getCurrentPathDepthQML() <= 0) {
            s3_create_dir_btn.enabled = false
        } else {
            s3_create_dir_btn.enabled = true
        }

        s3_browser.footerText = "["+s3Model.getItemsCountQML()+" Items]";
    }
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
            id: i_fileName
            wrapMode: Text.NoWrap
            elide: Text.ElideRight
            text: fileName
            width: parent.width - 135
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            width: 100
            text: {
                if (filePath == "/") {
                    "DIR"
                } else {
                    var size = s3Model.getObjectSizeQML(index)
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
            if(filePath == "/") {
                s3_download_btn.enabled = false
            } else {
                s3_download_btn.enabled = true
            }
        }

        onDoubleClicked:  {
            s3Model.getObjectsQML(i_fileName.text)
            path = s3Model.getS3PathQML()

            if(s3Model.getCurrentPathDepthQML() <= 0) {
                s3_create_dir_btn.enabled = false
            } else {
                s3_create_dir_btn.enabled = true
            }
        }
    }
}
