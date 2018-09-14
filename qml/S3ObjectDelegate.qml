/*
# Copyright (C) 2018  Artur Fogiel
# This file is part of qtS3Browser.
#
# qtS3Browser is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# qtS3Browser is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with qtS3Browser.  If not, see <http://www.gnu.org/licenses/>.
*/
import QtQuick 2.9
import QtQuick.Controls.Material 2.2
import QtQuick.Controls 2.4
Rectangle {

    function getSize() {
        if (filePath == "/") {
            return "DIR"
        } else {
            var size = s3Model.getObjectSizeQML(i_fileName.text)
            if(size === "0") {
                return "..."
            }

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

    onFocusChanged: {
        if(s3Model.getCurrentPathDepthQML() <= 0) {
            s3_create_dir_btn.enabled = false
            menu_s3_create_dir.enabled = false
            s3_download_btn.enabled = false
        } else {
            s3_create_dir_btn.enabled = true
            menu_s3_create_dir.enabled = true
            s3_download_btn.enabled = true
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
            id: i_size
            width: 100
            text: {
                if (filePath == "/") {
                    return "DIR"
                } else {
                    return getSize()
                }
            }
            anchors.verticalCenter: parent.verticalCenter
        }

    }

    Menu {
        id: contextMenu
        MenuItem {
            text: qsTr('Download')
        }
        MenuItem {
            text: qsTr('Delete')
        }
    }

    MouseArea {
        id:mouseArea
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: {
            view.currentIndex = index

            if (mouse.button === Qt.RightButton)
            {
                contextMenu.popup()
                console.log("Right")
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
