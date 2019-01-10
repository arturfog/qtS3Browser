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
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0
import QtQuick.Dialogs 1.2

Window {
    id: presign_win
    minimumHeight: 300; maximumHeight: 300
    minimumWidth: 640; maximumWidth: 640
    width: 640; height: 300;
    title: qsTr("Generate presign link")

    property string borderColor: "gray"
    readonly property int labelFontSize: getMediumFontSize()
    readonly property int inputFontSize: getSmallFontSize()

    function extendInputText(input, input_field, input_field_rect) {
        let sizeInc = 40;
        if(input.text.length > 40 && input_field.height === 30) {
            input_field_rect.height += sizeInc
            input_field.height += sizeInc
            settings_win.maximumHeight += sizeInc
            settings_win.height += sizeInc
        } else if(input.text.length <= 40 && input_field.height > 30) {
            input_field_rect.height -= sizeInc
            input_field.height -= sizeInc
            settings_win.maximumHeight -= sizeInc
            settings_win.height -= sizeInc
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

    // ------------- header rectangle -------------
    Rectangle {
        color: "#3367d6"
        width: parent.width
        height: 50

        Row {
            x: 10
            height: parent.height
            width: parent.width

            Image {
                source: { "qrc:icons/32_new_folder_icon.png" }
                anchors.verticalCenter: parent.verticalCenter
            }

            Rectangle {
                width: 5
                height: parent.height
                color: "transparent"
            }

            Text {
                color: "white"
                text: qsTr("Generate presign link") + tsMgr.emptyString
                font.bold: true
                font.pointSize: 14
                height: parent.height
                verticalAlignment: Text.AlignVCenter
            }
        }
    }

    // ------------- content frame -------------
    Rectangle {
        id: create_item_rect
        y: 60
        anchors.horizontalCenter: parent.horizontalCenter
        color: "white"
        width: parent.width - 50
        height: 165
        border.color: "lightgray"
        border.width: 2
        radius: 5

        Column {
            width: parent.width
            height: parent.height
            // ------------- input property title -------------
            Row {
                x: 10
                y: 10
                width: parent.width
                height: 40

                Image {
                    source: "qrc:icons/32_endpoint_icon.png"
                    anchors.verticalCenter: parent.verticalCenter
                }

                Rectangle {
                    width: 5
                    height: parent.height
                    color: "transparent"
                }

                Text {
                    width: parent.width
                    height: 40
                    text: qsTr("Generated link") + tsMgr.emptyString
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: labelFontSize
                }
            }


            Rectangle {
                width: parent.width
                color: "#dbdbdb"
                height: 1
            }

            // ------------- input text -------------
            Rectangle {
                width: parent.width - 20
                height: 40
                x: 10

                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    y: 10
                    id: item_name_input_rect
                    width: parent.width
                    height: 30
                    border.color: "gray"
                    border.width: 1
                    color: "#efefef"

                    TextInput {
                        id: itemName
                        x: 10
                        width: parent.width
                        height: parent.height
                        verticalAlignment: Text.AlignVCenter
                        font.pointSize: getSmallFontSize()
                        maximumLength: 128
                        wrapMode: Text.WrapAnywhere
                        onActiveFocusChanged: focusChangedHandler(itemName, item_name_input_rect);
                        onTextChanged: extendInputText(itemName, item_name_input_rect, create_item_rect)
                    }
                }
            }
            // ------------- S3 start path -------------
            Rectangle {
                id: start_path_rect
                anchors.horizontalCenter: parent.horizontalCenter
                color: "transparent"
                width: parent.width
                height: 85

                Column {
                    width: parent.width / 2
                    height: parent.height

                    Rectangle {
                        width: parent.width
                        color: "#dbdbdb"
                        height: 1
                    }

                    // ------------- icon | title row -------------
                    Row {
                        x: 10
                        y: 10
                        width: parent.width
                        height: 40

                        Image {
                            source: "qrc:icons/32_clock_icon.png"
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Rectangle {
                            width: 5
                            height: parent.height
                            color: "transparent"
                        }

                        Text {
                            width: parent.width
                            height: 40
                            text: qsTr("Timeout") + tsMgr.emptyString
                            verticalAlignment: Text.AlignVCenter
                            font.pointSize: labelFontSize
                        }
                    }

                    Rectangle {
                        width: parent.width
                        color: "#dbdbdb"
                        height: 1
                    }

                    // --------------------------
                    Rectangle {
                        width: parent.width - 20
                        height: 40
                        x: 10
                        Rectangle {
                            id: start_path_input_rect
                            x: 10
                            width: parent.width
                            height: 30
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter

                            SpinBox {
                                id: startPath
                                x: 10
                                width: parent.width - 20
                                height: parent.height
                                font.pointSize: inputFontSize
                            }
                        }
                    }
                }

                Column {
                    x: parent.width / 2
                    width: parent.width / 2
                    height: parent.height

                    Rectangle {
                        width: parent.width
                        color: "#dbdbdb"
                        height: 1
                    }
                    // ------------- icon | title row -------------
                    Row {
                        x: 10
                        y: 10
                        width: parent.width
                        height: 40

                        Rectangle {
                            width: 5
                            height: parent.height
                            color: "transparent"
                        }
                    }

                    Rectangle {
                        width: parent.width
                        color: "#dbdbdb"
                        height: 1
                    }

                    Rectangle {
                        width: parent.width - 20
                        height: 40
                        x: 10
                        Rectangle {
                            id: language_input_rect
                            x: 10
                            width: parent.width
                            height: 30
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            border.color: "gray"
                            border.width: 1
                            color: "#f8f9fa"

                            ComboBox {
                                id: language
                                width: parent.width
                                height: parent.height
                                font.pointSize: inputFontSize
                                //currentIndex: settingsModel.getTimeoutIdxQML()
                                model: [ "seconds",
                                    "minutes" ]
                                onCurrentTextChanged: {

                                }
                            }

                        }
                    }
                }
            }
        }
    }
    // ------------- bottom buttons frame -------------
    Column {
        x:5
        y:create_item_rect.y + create_item_rect.height + 10
        width: parent.width
        height: parent.height

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            Button {
                id: cw_cb
                text: qsTr("Generate") + tsMgr.emptyString
                icon.source: "qrc:icons/32_add_icon.png"
                icon.color: "transparent"
                font.pointSize: getSmallFontSize()
                onClicked: {
                        var ret = s3Model
                }

                background: Rectangle {
                        implicitWidth: 100
                        implicitHeight: 40
                        opacity: enabled ? 1 : 0.3
                        color: cw_cb.down ? "#dddedf" : "#eeeeee"

                        Rectangle {
                            width: parent.width
                            height: 1
                            color: cw_cb.down ? "#17a81a" : "#21be2b"
                            anchors.bottom: parent.bottom
                        }
                    }
            }

            Rectangle {
                width: 5
                height: parent.height
            }


            Button {
                id:cancel_btn
                text: qsTr("Cancel") + tsMgr.emptyString
                icon.source: "qrc:icons/32_cancel_icon.png"
                icon.color: "transparent"
                font.pointSize: getSmallFontSize()
                onClicked: {
                    close()
                }

                background: Rectangle {
                        implicitWidth: 100
                        implicitHeight: 40
                        opacity: enabled ? 1 : 0.3
                        color: cancel_btn.down ? "#dddedf" : "#eeeeee"

                        Rectangle {
                            width: parent.width
                            height: 1
                            color: cancel_btn.down ? "#17a81a" : "#21be2b"
                            anchors.bottom: parent.bottom
                        }
                    }
            }
        }
    }
}
