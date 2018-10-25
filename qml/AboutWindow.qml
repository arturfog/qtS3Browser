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
    id: about_win
    minimumHeight: 350; maximumHeight: 350
    minimumWidth: 440; maximumWidth: 440
    width: 440; height: 350;
    color: "#f8f9fa"
    title: "About qtS3Browser"

    Rectangle {
        color: "#3367d6"
        width: parent.width
        height: 128
        Image {
            id: app_icon_256
            width: 128
            height: 128
            source: "qrc:icons/256_app.png"
            anchors.horizontalCenter: parent.horizontalCenter
        }

    }

    DropShadow {
        anchors.fill: app_name_rect
        horizontalOffset: 1
        verticalOffset: 2
        radius: 8.0
        samples: 17
        color: "#aa000000"
        source: app_name_rect
    }

    Rectangle {
        id: app_name_rect
        y: app_icon_256.y + app_icon_256.height + 10
        anchors.horizontalCenter: parent.horizontalCenter
        color: "white"
        width: parent.width - 50
        height: 80
        border.color: "#efefef"
        border.width: 1
        radius: 5

        Column {
            width: parent.width
            height: parent.height

            Text {
                x: 20
                y: 10
                width: parent.width
                text: "qtS3Browser"
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 14
                height: 40
            }


            Rectangle {
                width: parent.width
                color: "#dbdbdb"
                height: 1
            }

            Text {
                x: 20
                y: 10
                text: "Version: 1.0.3"
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 10
                height: 40
            }
        }
    }

    DropShadow {
        anchors.fill: rect
        horizontalOffset: 1
        verticalOffset: 2
        radius: 8.0
        samples: 17
        color: "#aa000000"
        source: rect
    }

    Rectangle {
        y: app_name_rect.y + app_name_rect.height + 20
        id: rect
        anchors.horizontalCenter: parent.horizontalCenter
        color: "white"
        width: parent.width - 50
        height: 80
        border.color: "#efefef"
        border.width: 1
        radius: 5

        Column {
            width: parent.width
            height: parent.height

            Rectangle {
                width: parent.width
                color: "#dbdbdb"
                height: 1
            }
            // ------------- author row -------------
            Row {
                x: 10
                y: 10
                width: parent.width
                height: 40
                Image {
                    source: "qrc:icons/32_author_icon.png"
                }

                Text {
                    width: parent.width
                    height: 40
                    text: "Artur Fogiel"
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: 12

                }
            }



            Rectangle {
                width: parent.width
                color: "#dbdbdb"
                height: 1
            }
            // ------------- github link row -------------
            Row {
                x: 10
                y: 10
                width: parent.width
                height: 40
                Image {
                    source: "qrc:icons/32_github_icon.png"
                }

                Text {
                    width: parent.width
                    height: 40
                    text: '<a href="https://github.com/arturfog/qtS3Browser">https://github.com/arturfog/qtS3Browser</a>'
                    verticalAlignment: Text.AlignVCenter
                    onLinkActivated: Qt.openUrlExternally("https://github.com/arturfog/qtS3Browser")
                    font.pointSize: 10
                }
            }
        }
    }
}
