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
import QtQml.Models 2.3
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Window {
    id: create_bookmark_win
    x: 100; y: 100; width: 300; height: 220
    minimumHeight: 200; maximumHeight: 220
    minimumWidth: 200

    title: "Create bookmark"

    Column {
        width: parent.width
        height: parent.height

        Rectangle {
            width: parent.width
            height: 10
        }

        Row {
            width: parent.width
            Image {
                source: "qrc:icons/32_home_icon.png"
            }

            Text {
                x: 10
                text: "Bookmark name"
                font.pointSize: 10
            }
        }

        Rectangle {
            width: parent.width
            height: 10
        }

        Rectangle {
            x: 10
            width: parent.width - 20
            height: 34
            border.color: "black"
            color: "white"
            border.width: 1

            TextInput {
                id: bookmarkName
                x: 5
                width: parent.width
                anchors.verticalCenter: parent.verticalCenter
                text: "Name"
                maximumLength: 128
            }
        }

        Rectangle {
            width: parent.width
            height: 10
        }

        Row {
            width: parent.width
            Image {
                source: "qrc:icons/32_home_icon.png"
            }

            Text {
                x: 10
                text: "S3 URL"
                font.pointSize: 10
            }
        }

        Rectangle {
            width: parent.width
            height: 10
        }

        Rectangle {
            x: 10
            width: parent.width - 20
            height: 34
            border.color: "black"
            color: "white"
            border.width: 1

            TextInput {
                id: bookmarkPath
                x: 5
                width: parent.width
                anchors.verticalCenter: parent.verticalCenter
                text: "s3://"
                maximumLength: 128
            }
        }

        Rectangle {
            width: parent.width
            height: 10
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter

            Button {
                id: cw_cb
                text: "Create"
                onClicked: {
                    s3Model.addBookmarkQML(bookmarkName.text, bookmarkPath.text)
                    close()
                }
            }

            Rectangle {
                width: 5
                height: parent.height
            }


            Button {
                text: "Cancel"
                onClicked: {
                    close()
                }
            }
        }
    }
}
