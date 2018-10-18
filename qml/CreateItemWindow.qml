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
    // ------------- configuration -------------
    id: create_item_win
    x: app_window.x
    y: app_window.y
    width: 400
    height: 200
    minimumHeight: 200
    minimumWidth: 400
    maximumHeight: 250
    title: win_title
    // ------------- windows modes -------------
    readonly property int createBucket: 0
    readonly property int createS3Folder: 1
    readonly property int createLocalFolder: 2
    // ------------- properties -------------
    property string win_title: ""
    property int create_action: 0
    property string borderColor: "gray"
    // ------------- event handlers -------------
    onVisibilityChanged: {
        itemName.text = ""
        create_item_win.height = 200
    }

    function extendInputText(input, input_field, input_field_rect) {
        let sizeInc = 40;
        if(input.text.length > 40 && input_field.height === 30) {
            input_field_rect.height += sizeInc
            input_field.height += sizeInc
            create_item_win.height += sizeInc
            create_item_win.maximumHeight += sizeInc
        } else if(input.text.length <= 40 && input_field.height > 30) {
            input_field_rect.height -= sizeInc
            input_field.height -= sizeInc
            create_item_win.height -= sizeInc
            create_item_win.maximumHeight -= sizeInc
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

    property CustomMessageDialog msgDialog: CustomMessageDialog {
        win_title: "Error"
        msg: "Directory already exists"
        ico: StandardIcon.Warning
        yesAction: function() { close() }
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
                source: {
                    if(create_action === createBucket) {
                        "qrc:icons/32_bucket_icon.png"
                    } else {
                        "qrc:icons/32_new_folder_icon.png"
                    }
                }
                anchors.verticalCenter: parent.verticalCenter
            }

            Rectangle {
                width: 5
                height: parent.height
                color: "transparent"
            }

            Text {
                color: "white"
                text: {
                    if(create_action === createBucket) {
                        qsTr("Create bucket")
                    } else if(create_action === createS3Folder) {
                        qsTr("Create S3 directory")
                    } else {
                        qsTr("Create local directory")
                    }
                }
                font.bold: true
                font.pointSize: 14
                height: parent.height
                verticalAlignment: Text.AlignVCenter
            }
        }
    }
    // ------------- content frame shadow -------------
    DropShadow {
        anchors.fill: create_item_rect
        horizontalOffset: 1
        verticalOffset: 2
        radius: 8.0
        samples: 17
        color: "#aa000000"
        source: create_item_rect
    }
    // ------------- content frame -------------
    Rectangle {
        id: create_item_rect
        y: 60
        anchors.horizontalCenter: parent.horizontalCenter
        color: "white"
        width: parent.width - 50
        height: 85
        border.color: "#efefef"
        border.width: 1
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

                Text {
                    width: parent.width
                    height: 40
                    text: {
                        if(create_action === createBucket) {
                            "Bucket name"
                        } else {
                            "Directory name"
                        }
                    }
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
            // ------------- input text -------------
            Rectangle {
                id: item_name_input_rect
                x: 10
                width: parent.width - 20
                height: 30
                border.color: "gray"
                border.width: 1
                radius: 20
                color: "#efefef"

                TextInput {
                    id: itemName
                    x: 10
                    width: parent.width - 20
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: 10
                    maximumLength: 128
                    wrapMode: Text.WrapAnywhere
                    onActiveFocusChanged: focusChangedHandler(itemName, item_name_input_rect);
                    onTextChanged: extendInputText(itemName, item_name_input_rect, create_item_rect)
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
                text: qsTr("Create")
                icon.source: "qrc:icons/32_add_icon.png"
                icon.color: "transparent"
                onClicked: {
                    if (create_action === createBucket) {
                        s3Model.createBucketQML(itemName.text)
                    } else if (create_action === createS3Folder) {
                        s3Model.createFolderQML(itemName.text)
                    } else {
                        if(!fsModel.createFolderQML(itemName.text)) {
                            msgDialog.visible = true
                        }
                    }

                    if(create_action !== createLocalFolder) {
                        s3Model.refreshQML()
                        close()
                    }
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
                    close()
                }
            }
        }
    }
}

