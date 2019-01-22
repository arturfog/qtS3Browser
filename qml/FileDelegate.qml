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
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.2
import QtQuick.Controls 2.3
Rectangle {
    id:delegate
    width: view.width
    height:34
    color: "transparent"

    property bool isSelected: false

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
            font.pointSize: getSmallFontSize()
            width: parent.width - 130
            anchors.verticalCenter: parent.verticalCenter

            color: isSelected ? "blue" : "black"
        }

        Text {
            width: 100
            font.pointSize: getSmallFontSize()
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

    Menu {
        id: contextMenu
        MenuItem {
            icon.source: "qrc:icons/32_about_icon.png"
            icon.color: "transparent"
            text: qsTr('Info') + tsMgr.emptyString
            onClicked: {
                infoWindow.x = app_window.x + (app_window.width / 2) - (infoWindow.width / 2)
                infoWindow.y = app_window.y + (app_window.height / 2) - (infoWindow.height / 2)
                infoWindow.name = fileName
                infoWindow.path = filePath
                infoWindow.size = folder.get(view.currentIndex, "fileSize")
                infoWindow.modified = folder.get(view.currentIndex, "fileModified")
                infoWindow.visible = true
            }
        }
        MenuItem {
            icon.source: "qrc:icons/32_upload_icon.png"
            icon.color: "transparent"
            enabled: connected
            text: qsTr('Upload') + tsMgr.emptyString
            onClicked: { upload() }
        }
        MenuItem {
            icon.source: "qrc:icons/32_delete_icon.png"
            icon.color: "transparent"
            text: qsTr('Delete') + tsMgr.emptyString
            onClicked: {
                var fileName = folder.get(view.currentIndex, "fileName")
                msgDialog.msg = qsTr("Remove ") + fileName + " ?"
                msgDialog.open()
            }
        }
    }

    MouseArea {
        Keys.onReturnPressed: {
            var url = folder.get(view.currentIndex, "fileURL")
            folder.get(view.currentIndex, "fileIsDir") ? view.path = url : Qt.openUrlExternally(url)
        }

        id:mouseArea
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: {
            view.currentIndex = index
            if (mouse.button === Qt.RightButton) {
                contextMenu.popup()
            } else {
                isSelected = !isSelected
            }
        }

        onDoubleClicked: {
            fileIsDir ? view.path = fileURL : Qt.openUrlExternally(fileURL)
            s3Model.setFileBrowserPath(view.path)
        }
    }
}
