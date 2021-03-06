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
import QtQuick.Controls 2.3
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
        } else {
            s3_create_dir_btn.enabled = true
        }

        s3_browser.footerText = s3Model.getItemsCountQML()+" Items";
    }

    id:delegate
    width: view.width
    height:34
    color: "transparent"

    Row {
        anchors.fill: parent

        CheckBox {
            id: check
            anchors.verticalCenter: parent.verticalCenter
            rightPadding: 10

            onCheckedChanged: {
                if(checked) {
                    s3_browser.multiSelectItems += 1
                } else {
                    s3_browser.multiSelectItems -= 1
                }
            }
        }

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
            font.pointSize: getSmallFontSize()
            width: parent.width - 140
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            id: i_size
            width: 100
            font.pointSize: getSmallFontSize()
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
            icon.source: "qrc:icons/32_about_icon.png"
            icon.color: "transparent"
            enabled: connected
            text: qsTr('Info') + tsMgr.emptyString
            onClicked: {
                infoWindow.x = app_window.x + (app_window.width / 2) - (infoWindow.width / 2)
                infoWindow.y = app_window.y + (app_window.height / 2) - (infoWindow.height / 2)
                infoWindow.name = fileName
                infoWindow.path = "s3://" + s3Model.getS3PathQML() + fileName
                var size = s3Model.getObjectSizeQML(i_fileName.text)
                infoWindow.size = size
                infoWindow.modified = s3Model.getModificationDateQML(fileName)
                infoWindow.owner = s3Model.getOwnerQML(fileName)
                infoWindow.visible = true
            }
        }
        MenuItem {
            icon.source: "qrc:icons/32_file_icon.png"
            icon.color: "transparent"
            enabled: connected
            text: qsTr('Copy S3 path') + tsMgr.emptyString
            onClicked: {
                var fileName = s3Model.getItemNameQML(view.currentIndex)
                s3_browser_clipboard.copy("s3://" + s3Model.getS3PathQML() + fileName)
            }
        }
        MenuItem {
            id: downloadMenuItem
            icon.source: "qrc:icons/32_download_icon.png"
            icon.color: "transparent"
            enabled: connected && s3Model.canDownload()
            text: qsTr('Download') + tsMgr.emptyString
            onClicked: { download() }
        }
        MenuItem {
            visible: multiSelectItems > 1
            height: (multiSelectItems > 1) ? downloadMenuItem.height : 0
            icon.source: "qrc:icons/32_download_icon.png"
            icon.color: "transparent"
            enabled: connected && s3Model.canDownload()
            text: qsTr('Download') + " " + multiSelectItems + " " + qsTr("items") + tsMgr.emptyString
            onClicked: {
                dlDialog.msg = qsTr('Download') + " " + multiSelectItems + " " + qsTr("items") + tsMgr.emptyString + " ?"
                dlDialog.open()
            }
        }
        MenuItem {
            icon.source: "qrc:icons/32_endpoint_icon.png"
            icon.color: "transparent"
            enabled: connected
            text: qsTr('Presign link') + tsMgr.emptyString
            onClicked: {
                var fileName = s3Model.getItemNameQML(view.currentIndex)
                presignWindow.key = s3Model.getPathWithoutBucket() + fileName
                presignWindow.x = app_window.x + (app_window.width / 2) - (presignWindow.width / 2)
                presignWindow.y = app_window.y + (app_window.height / 2) - (presignWindow.height / 2)
                presignWindow.visible = true
            }
        }
        MenuItem {
            icon.source: "qrc:icons/32_delete_icon.png"
            icon.color: "transparent"
            enabled: connected && !ftModel.isTransferring()
            text: qsTr('Delete') + tsMgr.emptyString
            onClicked: {
                if(!ftModel.isTransferring()) {
                    var fileName = s3Model.getItemNameQML(view.currentIndex)
                    delDialog.msg = qsTr("Remove ") + fileName + " ?"
                    delDialog.open()
                } else {
                    s3Error.visible = true
                }
            }
        }
        MenuItem {
            visible: multiSelectItems > 1
            height: (multiSelectItems > 1) ? downloadMenuItem.height : 0
            icon.source: "qrc:icons/32_delete_icon.png"
            icon.color: "transparent"
            enabled: connected && !ftModel.isTransferring()
            text: qsTr('Delete') + " " + multiSelectItems + " " + qsTr("items") + tsMgr.emptyString
            onClicked: {
                delDialog.msg = qsTr('Delete') + " " + multiSelectItems + " " + qsTr("items") + tsMgr.emptyString + " ?"
                delDialog.open()
            }
        }
    }

    Item {
        id: s3_browser_clipboard
        opacity: 0

        function copy(text) {
            helper.text = text;
            helper.selectAll();
            helper.copy();
        }

        TextEdit {
            id: helper
        }
    }

    MouseArea {
        x: 35
        width: parent.width - 35
        height: parent.height
        id:mouseArea
        //anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: {
            view.currentIndex = index
            if (mouse.button === Qt.RightButton) {
                contextMenu.popup()
            } else {
            }
        }

        onDoubleClicked:  {
            if(i_size.text == "DIR") {
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
}
