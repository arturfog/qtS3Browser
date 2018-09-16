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
import QtQuick 2.6
import QtQuick.Window 2.3
import QtQml.Models 2.3
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
Window {
    id: create_item_win
    x: app_window.x
    y: app_window.y
    width: 400; height: 200
    minimumHeight: 200; maximumHeight: 130
    minimumWidth: 400

    property var win_title: String
    property var create_action: Number

    title: win_title

    onVisibilityChanged: {
        itemName.text = ""
    }

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
                    if(create_action === 0) {
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
                    if(create_action === 0) {
                        qsTr("Create bucket")
                    } else {
                        qsTr("Create directory")
                    }
                }
                font.bold: true
                font.pointSize: 14
                height: parent.height
                verticalAlignment: Text.AlignVCenter
            }
        }
    }

    DropShadow {
        anchors.fill: create_item_rect
        horizontalOffset: 1
        verticalOffset: 2
        radius: 8.0
        samples: 17
        color: "#aa000000"
        source: create_item_rect
    }

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

            Row {
                x: 10
                y: 10
                width: parent.width
                height: 40
                Image {
                    source: {
                        if(create_action === 0) {
                            "qrc:icons/32_edit_icon.png"
                        } else {
                            "qrc:icons/32_edit_icon.png"
                        }
                    }
                }

                Text {
                    width: parent.width
                    height: 40
                    text: {
                        if(create_action === 0) {
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

            Rectangle {
                id: item_name_input_rect
                x: 10
                width: parent.width - 20
                height: 30
                border.color: "gray"
                border.width: 2
                radius: 20
                color: "#efefef"

                TextInput {
                    id: itemName
                    x: 10
                    width: parent.width
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: 10
                    maximumLength: 128

                    onActiveFocusChanged: {
                        if(itemName.focus) {
                            item_name_input_rect.color = "white"
                            item_name_input_rect.border.color = "orange"
                        } else {
                            item_name_input_rect.color = "#efefef"
                            item_name_input_rect.border.color = "gray"
                        }
                    }
                }
            }
        }
    }

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
                onClicked: {
                    if (create_action === 0) {
                        s3Model.createBucketQML(itemName.text)
                    } else {
                        s3Model.createFolderQML(itemName.text)
                    }
                    s3Model.refreshQML()
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
                    close()
                }
            }
        }
    }
}

