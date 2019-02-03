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
    width: 450; height: 300
    minimumHeight: 290; maximumHeight: 300
    minimumWidth: 450
    color: "#f8f9fa"

    property alias book_name: bookmarkName.text
    property alias book_path: bookmarkPath.text
    property alias win_title: create_bookmark_win.title
    property string borderColor: "gray"
    property int selectStart
    property int selectEnd
    property int curPos

    property string oldName: ""

    onVisibilityChanged: {
        oldName = bookmarkName.text
    }

    function extendInputText(input, input_field, input_field_rect) {
        let sizeInc = 40;
        if(input.text.length > 40 && input_field.height === 30) {
            input_field_rect.height += sizeInc
            input_field.height += sizeInc
            input_field.parent.height += sizeInc
            create_bookmark_win.maximumHeight += sizeInc
            create_bookmark_win.height += sizeInc
        } else if(input.text.length <= 40 && input_field.height > 30) {
            input_field_rect.height -= sizeInc
            input_field.height -= sizeInc
            input_field.parent.height -= sizeInc
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

    function getAbsolutePosition(node) {
        var returnPos = {};
        returnPos.x = 0;
        returnPos.y = 0;
        if(node !== undefined && node !== null) {
            var parentValue = getAbsolutePosition(node.parent);
            returnPos.x = parentValue.x + node.x;
            returnPos.y = parentValue.y + node.y;
        }
        return returnPos;
    }

    Menu {
        id: contextMenu
        MenuItem {
            text: "Cut"
            onTriggered: {
                bookmarkPath.cut()
            }
        }
        MenuItem {
            text: "Copy"
            onTriggered: {
                bookmarkPath.copy()
            }
        }
        MenuItem {
            text: "Paste"
            onTriggered: {
                bookmarkPath.paste()
            }
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
                text: create_bookmark_win.title
                font.bold: true
                font.pointSize: getLargeFontSize()
                height: parent.height
                verticalAlignment: Text.AlignVCenter
            }
        }
    }

    Rectangle {
        id: create_bookmark_rect
        y: 60
        anchors.horizontalCenter: parent.horizontalCenter
        color: "white"
        width: parent.width - 50
        height: 185
        border.color: "lightgray"
        border.width: 2
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
                    text: qsTr("Bookmark name") + tsMgr.emptyString
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: getMediumFontSize()
                }
            }


            Rectangle {
                width: parent.width
                color: "#dbdbdb"
                height: 1
            }

            Rectangle {
                width: parent.width - 20
                x: 10
                height: 50
                Rectangle {
                    id: bookmark_name_input_rect
                    y: 10
                    width: parent.width
                    height: 30
                    border.color: borderColor
                    border.width: 1
                    color: "#efefef"

                    TextInput {
                        id: bookmarkName
                        x: 10
                        width: parent.width - 20
                        height: parent.height
                        verticalAlignment: Text.AlignVCenter
                        font.pointSize: getSmallFontSize()
                        maximumLength: 128
                        wrapMode: Text.WrapAnywhere
                        onTextChanged: extendInputText(bookmarkName, bookmark_name_input_rect, create_bookmark_rect)
                        onActiveFocusChanged: focusChangedHandler(bookmarkName, bookmark_name_input_rect)
                    }
                }
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
                    text: qsTr("S3 URL") + tsMgr.emptyString
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: getMediumFontSize()
                }
            }

            Rectangle {
                width: parent.width
                color: "#dbdbdb"
                height: 1
            }

            Rectangle {
                x: 10
                width: parent.width - 20
                height: 40
                Rectangle {
                    id: bookmark_url_input_rect
                    y: 10
                    width: parent.width
                    height: 30
                    border.color: borderColor
                    border.width: 1
                    color: "#efefef"

                    TextInput {
                        id: bookmarkPath
                        x: 10
                        width: parent.width - 20
                        height: parent.height
                        verticalAlignment: Text.AlignVCenter
                        font.pointSize: getSmallFontSize()
                        maximumLength: 128
                        text: "s3://"
                        wrapMode: Text.WrapAnywhere
                        onTextChanged: extendInputText(bookmarkPath, bookmark_url_input_rect, create_bookmark_rect)
                        onActiveFocusChanged: focusChangedHandler(bookmarkPath, bookmark_url_input_rect)

                        MouseArea {
                            anchors.fill: parent
                            acceptedButtons: Qt.RightButton
                            hoverEnabled: true
                            onClicked: {
                                selectStart = bookmarkPath.selectionStart;
                                selectEnd = bookmarkPath.selectionEnd;
                                curPos = bookmarkPath.cursorPosition;
                                var parentValue = getAbsolutePosition(bookmarkPath);
                                contextMenu.x = mouse.x;
                                contextMenu.y = parentValue.y
                                contextMenu.open();
                            }
                        }
                    }
                }
            }

        }
    }

    Row {
        height: 30
        y: create_bookmark_rect.y + create_bookmark_rect.height + 10
        anchors.horizontalCenter: parent.horizontalCenter

        Button {
            id: create_btn
            text: qsTr("Create") + tsMgr.emptyString
            icon.source: "qrc:icons/32_add_icon.png"
            icon.color: "transparent"
            font.pointSize: getSmallFontSize()
            enabled: (bookmarkName.length > 0 && bookmarkPath.length > 5)
            onClicked: {                
                if(bookModel.hasBookmarkQML(oldName))
                {
                    bookModel.removeBookmarkQML(oldName)
                    bookModel.addBookmarkQML(bookmarkName.text, bookmarkPath.text)
                }
                else
                {
                    if(!bookModel.hasBookmarkQML(bookmarkName.text))
                    {
                        bookModel.addBookmarkQML(bookmarkName.text, bookmarkPath.text)
                    }
                    else
                    {

                    }
                }
                manageBookmarksPanel.addBookmarks();
                close()
            }
        }

        Rectangle {
            width: 5
            height: parent.height
        }

        Button {
            text: qsTr("Cancel") + tsMgr.emptyString
            icon.source: "qrc:icons/32_cancel_icon.png"
            icon.color: "transparent"
            font.pointSize: getSmallFontSize()
            onClicked: {
                bookmarkName.text = ""
                bookmarkPath.text = "s3://"
                oldName = ""

                close()
            }
        }
    }
}
