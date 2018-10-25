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
import QtQuick.Window 2.1
import QtQml.Models 2.1
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtGraphicalEffects 1.0
Window {
    id: create_bookmark_win
    width: 450; height: 260
    minimumHeight: 290; maximumHeight: 290
    minimumWidth: 450
    color: "#f8f9fa"
    title: qsTr("Create bookmark")

    property string borderColor: "gray"

    function extendInputText(input, input_field, input_field_rect) {
        let sizeInc = 40;
        if(input.text.length > 40 && input_field.height === 30) {
            input_field_rect.height += sizeInc
            input_field.height += sizeInc
            create_bookmark_win.maximumHeight += sizeInc
            create_bookmark_win.height += sizeInc
        } else if(input.text.length <= 40 && input_field.height > 30) {
            input_field_rect.height -= sizeInc
            input_field.height -= sizeInc
            create_bookmark_win.maximumHeight -= sizeInc
            create_bookmark_win.height -= sizeInc
        }
    }

    function focusChangedHandler(input_field, input_rect) {
        if(input_field.focus) {
            input_rect.color = "white"
            input_rect.border.color = "orange"
        } else {
            input_rect.color = "#efefef"
            input_rect.border.color = borderColor
        }
    }

    Rectangle {
        color: "#3367d6"
        width: parent.width
        height: 50

        Row {
            x:10
            height: parent.height
            width: parent.width

            Image {
                source: "qrc:icons/32_bookmark2.png"
                anchors.verticalCenter: parent.verticalCenter
            }

            Rectangle {
                width: 5
                height: parent.height
                color: "transparent"
            }

            Text {
                color: "white"
                text: qsTr("Create bookmark")
                font.bold: true
                font.pointSize: 14
                height: parent.height
                verticalAlignment: Text.AlignVCenter
            }
        }
    }

    DropShadow {
        anchors.fill: create_bookmark_rect
        horizontalOffset: 1
        verticalOffset: 2
        radius: 8.0
        samples: 17
        color: "#aa000000"
        source: create_bookmark_rect
    }

    Rectangle {
        id: create_bookmark_rect
        y: 60
        anchors.horizontalCenter: parent.horizontalCenter
        color: "white"
        width: parent.width - 50
        height: 165
        border.color: "#efefef"
        border.width: 1
        radius: 5

        Column {
            width: parent.width
            height: parent.height

            Row {
                x: 10
                y: 10
                width: parent.width
                height: 40
                Image {
                    source: "qrc:icons/32_bookmark.png"
                }

                Text {
                    width: parent.width
                    height: 40
                    text: qsTr("Bookmark name")
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: 12
                }
            }


            Rectangle {
                width: parent.width
                color: "#dbdbdb"
                height: 1
            }

            Rectangle {
                width: parent.width
                height: 5
            }

            Rectangle {
                id: bookmark_name_input_rect
                x: 10
                width: parent.width - 20
                height: 30
                border.color: borderColor
                border.width: 1
                radius: 20
                color: "#efefef"

                TextInput {
                    id: bookmarkName
                    x: 10
                    width: parent.width - 20
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: 10
                    maximumLength: 128
                    wrapMode: Text.WrapAnywhere
                    onTextChanged: extendInputText(bookmarkName, bookmark_name_input_rect, create_bookmark_rect)
                    onActiveFocusChanged: focusChangedHandler(bookmarkName, bookmark_name_input_rect)

                }
            }

            Rectangle {
                width: parent.width
                height: 5
            }

            Rectangle {
                width: parent.width
                color: "#dbdbdb"
                height: 1
            }

            Row {
                x: 10
                y: 10
                width: parent.width
                height: 40
                Image {
                    source: "qrc:icons/32_endpoint_icon.png"
                }

                Text {
                    width: parent.width
                    height: 40
                    text: qsTr("S3 URL")
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: 12
                }
            }

            Rectangle {
                width: parent.width
                color: "#dbdbdb"
                height: 1
            }

            Rectangle {
                width: parent.width
                height: 5
            }

            Rectangle {
                id: bookmark_url_input_rect
                x: 10
                width: parent.width - 20
                height: 30
                border.color: borderColor
                border.width: 1
                radius: 20
                color: "#efefef"

                TextInput {
                    id: bookmarkPath
                    x: 10
                    width: parent.width - 20
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: 10
                    maximumLength: 128
                    text: "s3://"
                    wrapMode: Text.WrapAnywhere
                    onTextChanged: extendInputText(bookmarkPath, bookmark_url_input_rect, create_bookmark_rect)
                    onActiveFocusChanged: focusChangedHandler(bookmarkPath, bookmark_url_input_rect)
                }
            }

            Rectangle {
                width: parent.width
                height: 5
            }
        }
    }

    Row {
        height: 30
        y: create_bookmark_rect.y + create_bookmark_rect.height + 10
        anchors.horizontalCenter: parent.horizontalCenter

        Button {
            id: create_btn
            text: qsTr("Create")
            icon.source: "qrc:icons/32_add_icon.png"
            icon.color: "transparent"
            enabled: (bookmarkName.length > 0 && bookmarkPath.length > 5)
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
            text: qsTr("Cancel")
            icon.source: "qrc:icons/32_cancel_icon.png"
            icon.color: "transparent"
            onClicked: {
                bookmarkName.text = ""
                bookmarkPath.text = "s3://"

                close()
            }
        }
    }
}
