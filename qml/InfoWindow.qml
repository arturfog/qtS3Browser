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
import QtQuick 2.5
import QtQuick.Window 2.0
import QtGraphicalEffects 1.0

Window {
    id: info_win
    minimumHeight: 320; maximumHeight: 320
    minimumWidth: 640; maximumWidth: 640
    width: 640; height: 320;
    color: "#f8f9fa"
    title: "Info"

    property string name: ""
    property string path: ""
    property string size: ""
    property string owner: ""
    property string modified: ""
    property string etag: ""

    function getSizeString(bytes) {
        if(bytes === "DIR") {
            return "DIR"
        }

        if(bytes > 1048576) {
            return Number(bytes / 1048576).toFixed(1)  + " MB"
        } else if(bytes >= 1024) {
            return Number(bytes / 1024).toFixed(1)  + " KB"
        } else {
            return Number(bytes)  + " B"
        }
    }

    // ------------- header -------------
    Rectangle {
        color: "#3367d6"
        width: parent.width
        height: 80

        Row {
            x:10
            height: parent.height
            width: parent.width

            Image {
                source: "image://iconProvider/" + ((name.lastIndexOf("/") > 0) ? "//" : path)
                width: 32
                height: 32
                anchors.verticalCenter: parent.verticalCenter
            }

            Rectangle {
                width: 5
                height: parent.height
                color: "transparent"
            }

            Text {
                color: "white"
                text: name
                elide: Text.ElideRight
                font.bold: true
                font.pointSize: 14
                height: 80
                width: parent.width - 80
                verticalAlignment: Text.AlignVCenter
            }
        }
    }
    // ------------- header end -------------

    Rectangle {
        id: info_rect
        y: 90
        anchors.horizontalCenter: parent.horizontalCenter
        color: "white"
        width: parent.width - 50
        height: 210
        border.color: "lightgray"
        border.width: 2
        radius: 5
        Column {
            width: parent.width
            Row {
                x: 10
                width: parent.width
                height: 40
                Text {
                    width: parent.width / 2
                    height: 40
                    text: "Size"
                    font.bold: true
                    verticalAlignment: Text.AlignVCenter
                }

                Text {
                    width: parent.width / 2
                    height: 40
                    text: getSizeString(size)
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Rectangle {
                width: parent.width
                color: "#dbdbdb"
                height: 1
            }

            Row {
                x: 10
                width: parent.width
                height: 40
                Text {
                    width: parent.width / 2
                    height: 40
                    text: "Modification date"
                    font.bold: true
                    verticalAlignment: Text.AlignVCenter
                }

                Text {
                    width: parent.width / 2
                    height: 40
                    text: modified
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Rectangle {
                width: parent.width
                color: "#dbdbdb"
                height: 1
            }

            Row {
                x: 10
                width: parent.width
                height: 40
                Text {
                    width: parent.width / 2
                    height: 40
                    text: "Permissions"
                    font.bold: true
                    verticalAlignment: Text.AlignVCenter
                }

                Text {
                    width: parent.width / 2
                    height: 40
                    text: fsModel.permissions(path)
                    verticalAlignment: Text.AlignVCenter
                }
            }


            Rectangle {
                width: parent.width
                color: "#dbdbdb"
                height: 1
            }

            Row {
                x: 10
                width: parent.width
                height: 40
                Text {
                    width: parent.width / 2
                    height: 40
                    text: "Owner"
                    font.bold: true
                    verticalAlignment: Text.AlignVCenter
                }

                Text {
                    width: parent.width / 2
                    height: 40
                    text: fsModel.getOwner(path)
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Rectangle {
                width: parent.width
                color: "#dbdbdb"
                height: 1
            }

            Row {
                x: 10
                width: parent.width
                height: 40
                visible: etag === "" ? false : true
                Text {
                    width: parent.width / 2
                    height: 40
                    text: "ETag"
                    font.bold: true
                    verticalAlignment: Text.AlignVCenter
                }

                Text {
                    width: parent.width / 2
                    height: 40
                    text: fsModel.getOwner(path)
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Rectangle {
                width: parent.width
                color: "#dbdbdb"
                height: 1
                visible: etag === "" ? false : true
            }

            Row {
                x: 10
                width: parent.width
                height: 50
                Text {
                    width: parent.width / 2
                    height: 40
                    text: "Path"
                    font.bold: true
                    verticalAlignment: Text.AlignVCenter
                }

                TextEdit {
                    width: (parent.width - 20) / 2
                    wrapMode: Text.WrapAnywhere
                    height: 50
                    text: path
                    readOnly: true
                    selectByMouse: true
                    font.pointSize: 10
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }
}
