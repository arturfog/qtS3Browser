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
import QtQuick 2.11
import QtQuick.Window 2.3

Window {
    id: about_win
    x: 100; y: 100;
    minimumHeight: 360; maximumHeight: 360
    minimumWidth: 440; maximumWidth: 440

    title: "About qtS3Browser"

    Column {
        width: parent.width
        Image {
            id: app_icon_256
            source: "qrc:icons/256_app.png"
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "qtS3Browser v1.0"
            font.pointSize: 16
        }
        Rectangle {
            width: parent.width
            height: 10
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Author: Artur Fogiel"
            font.pointSize: 14
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: '<a href="https://github.com/arturfog/qtS3Browser">https://github.com/arturfog/qtS3Browser</a>'
            onLinkActivated: Qt.openUrlExternally("https://github.com/arturfog/qtS3Browser")
            font.pointSize: 12
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Copyright© 2018"
            font.pointSize: 10
        }
    }
}
