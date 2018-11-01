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
    minimumHeight: 350; maximumHeight: 350
    minimumWidth: 440; maximumWidth: 440
    width: 440; height: 350;
    color: "#f8f9fa"
    title: "Info"

    property string name: ""
    property string path: ""

    // ------------- header -------------
    Rectangle {
        color: "#3367d6"
        width: parent.width
        height: 50

        Row {
            x:10
            height: parent.height
            width: parent.width

            Image {
                source: "image://iconProvider/"+path
                width: 48
                height: 48
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
                font.bold: true
                font.pointSize: 14
                height: parent.height
                verticalAlignment: Text.AlignVCenter
            }
        }
    }

    DropShadow {
        anchors.fill: info_rect
        horizontalOffset: 1
        verticalOffset: 2
        radius: 8.0
        samples: 17
        color: "#aa000000"
        source: info_rect
    }

    Rectangle {
        id: info_rect
        y: 60
        anchors.horizontalCenter: parent.horizontalCenter
        color: "white"
        width: parent.width - 50
        height: 180
        border.color: "#efefef"
        border.width: 1
        radius: 5
        Column {
            width: parent.width
            Row {
                width: parent.width
                height: 40
                Text {
                    width: parent.width
                    height: 40
                    text: "Size"
                    verticalAlignment: Text.AlignVCenter
                    //font.pointSize: labelFontSize
                }
            }

            Rectangle {
                width: parent.width
                color: "#dbdbdb"
                height: 1
            }

            Row {
                width: parent.width
                height: 40
                Text {
                    width: parent.width
                    height: 40
                    text: "Modification date"
                    verticalAlignment: Text.AlignVCenter
                    //font.pointSize: labelFontSize
                }
            }


            Rectangle {
                width: parent.width
                color: "#dbdbdb"
                height: 1
            }

            Row {
                width: parent.width
                height: 40
                Text {
                    width: parent.width
                    height: 40
                    text: "Owner"
                    verticalAlignment: Text.AlignVCenter
                    //font.pointSize: labelFontSize
                }
            }
        }
    }
}
