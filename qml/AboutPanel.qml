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

Item {
    width: parent.width
    height: parent.height

    // ------------ Top bar ----------------
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

    Rectangle {
        id: app_name_rect
        y: app_icon_256.y + app_icon_256.height + 10
        anchors.horizontalCenter: parent.horizontalCenter
        color: "white"
        width: parent.width - (parent.width / 3)
        height: 80
        border.color: "lightgray"
        border.width: 2
        radius: 5

        Column {
            width: parent.width
            height: parent.height
            // ------------ App name ----------------
            Text {
                x: 20
                y: 10
                width: parent.width
                text: "qtS3Browser"
                verticalAlignment: Text.AlignVCenter
                font.pointSize: getLargeFontSize()
                height: 40
            }
            // ------------ Separator ----------------
            Rectangle {
                width: parent.width - 50
                anchors.horizontalCenter: parent.horizontalCenter
                color: "lightgray"
                height: 1
            }
            // ------------ Software version ----------------
            Text {
                x: 20
                y: 10
                text: qsTr("Version: ") + "1.0.13" + tsMgr.emptyString
                verticalAlignment: Text.AlignVCenter
                font.pointSize: getSmallFontSize()
                height: 40
            }
        }
    }

    Rectangle {
        y: app_name_rect.y + app_name_rect.height + 20
        id: rect
        anchors.horizontalCenter: parent.horizontalCenter
        //color: "white"
        color: "#efefef"
        width: parent.width - (parent.width / 3)
        height: 90
        border.color: "lightblue"
        border.width: 2
        radius: 5

        Column {
            width: parent.width
            height: parent.height

            Rectangle {
                width: parent.width
                color: "#dbdbdb"
                height: 1
            }
            // ------------- Author row -------------
            Row {
                x: 10
                y: 10
                width: parent.width
                height: 45
                Image {
                    source: "qrc:icons/32_author_icon.png"
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width
                    height: 40
                    text: "Artur Fogiel"
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: getMediumFontSize()

                }
            }
            // ------------ Separator ----------------
            Rectangle {
                width: parent.width - 50
                anchors.horizontalCenter: parent.horizontalCenter
                color: "lightblue"
                height: 1
            }
            // ------------- Github link row -------------
            Row {
                x: 10
                y: 10
                width: parent.width
                height: 40
                Image {
                    source: "qrc:icons/32_github_icon.png"
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width
                    height: 40
                    text: '<a href="https://github.com/arturfog/qtS3Browser">https://github.com/arturfog/qtS3Browser</a>'
                    verticalAlignment: Text.AlignVCenter
                    onLinkActivated: Qt.openUrlExternally("https://github.com/arturfog/qtS3Browser")
                    font.pointSize: getSmallFontSize()
                }
            }
        }
    }
}
