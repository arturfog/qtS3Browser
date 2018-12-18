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
import QtQuick.Window 2.1
import QtQml.Models 2.1
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0
import QtQuick 2.9
import QtQuick.Controls.Material 2.1
import QtQuick.Controls 2.3
import QtQuick.Dialogs 1.1


Item {
    width: parent.width
    height: parent.height

    property string borderColor: "gray"
    readonly property int labelFontSize: getMediumFontSize()
    readonly property int inputFontSize: getSmallFontSize()

    onVisibleChanged: {
        startPath.text = s3Model.getStartPathQML()
        secretKey.text = s3Model.getSecretKeyQML()
        accessKey.text = s3Model.getAccesKeyQML()
        endpointURL.text = s3Model.getEndpointQML()
    }

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
                source: "qrc:icons/32_settings_icon.png"
                anchors.verticalCenter: parent.verticalCenter
            }

            Rectangle {
                width: 5
                height: parent.height
                color: "transparent"
            }

            Text {
                color: "white"
                text: "Settings"
                font.bold: true
                font.pointSize: getLargeFontSize()
                height: parent.height
                width: parent.width - 230;
                verticalAlignment: Text.AlignVCenter
            }
            // ------------- save -------------
            Button {
                id: control
                font.pointSize: labelFontSize
                text: "Save"
                icon.source: "qrc:icons/32_save_icon.png"
                icon.color: "transparent"
                anchors.verticalCenter: parent.verticalCenter
                onClicked: {
                    s3Model.saveSettingsQML(startPath.text,
                                            accessKey.text,
                                            secretKey.text,
                                            s3region.currentIndex,
                                            s3region.currentText,
                                            timeout.currentIndex,
                                            timeout.currentText,
                                            endpointURL.text
                                            )
                }

                background: Rectangle {
                        implicitWidth: 100
                        implicitHeight: 40
                        opacity: enabled ? 1 : 0.3
                        color: control.down ? "#dddedf" : "#eeeeee"

                        Rectangle {
                            width: parent.width
                            height: 1
                            color: control.down ? "#17a81a" : "#21be2b"
                            anchors.bottom: parent.bottom
                        }
                    }
            }
        }
    }

    ScrollView {
        y: 60
        width: parent.width
        height: parent.height - 50
        contentHeight: start_path_rect.height + secret_key_rect.height +
                       access_key_rect.height + region_rect.height +
                       endpoint_url_rect.height + advanced_rect.height + 120
        clip: true
        // ------------- S3 start path -------------
        Rectangle {
            id: start_path_rect
            anchors.horizontalCenter: parent.horizontalCenter
            color: "white"
            width: parent.width - 150
            height: 85
            border.color: "lightgray"
            border.width: 2
            radius: 5

            Column {
                width: parent.width
                height: parent.height
                // ------------- icon | title row -------------
                Row {
                    x: 10
                    y: 10
                    width: parent.width
                    height: 40

                    Image {
                        source: "qrc:icons/32_home_icon.png"
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
                        text: "S3 Start Path"
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

                        width: parent.width
                        height: 30
                        border.color: borderColor
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        border.width: 1
                        color: "#efefef"

                        TextInput {
                            id: startPath
                            x: 10
                            width: parent.width - 20
                            height: parent.height
                            verticalAlignment: Text.AlignVCenter
                            font.pointSize: inputFontSize
                            maximumLength: 128
                            wrapMode: Text.WrapAnywhere
                            onTextChanged: extendInputText(startPath, start_path_input_rect, start_path_rect)
                            onActiveFocusChanged: focusChangedHandler(startPath, start_path_input_rect)
                        }
                    }
                }
            }
        }
        // ------------- secret key -------------
        Rectangle {
            y: start_path_rect.y + start_path_rect.height + 20
            id: secret_key_rect
            anchors.horizontalCenter: parent.horizontalCenter
            color: "white"
            width: parent.width - 150
            height: 85
            border.color: "lightgray"
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
                // ------------- icon | title row -------------
                Row {
                    x: 10
                    y: 10
                    width: parent.width
                    height: 40

                    Image {
                        source: "qrc:icons/32_secret_icon.png"
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
                        text: "Secret Key"
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
                        id: secret_key_input_rect

                        x: 10
                        width: parent.width
                        height: 30
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        border.color: borderColor
                        border.width: 1
                        color: "#efefef"

                        TextInput {
                            id: secretKey
                            x: 10
                            width: parent.width - 20
                            height: parent.height
                            verticalAlignment: Text.AlignVCenter
                            font.pointSize: inputFontSize
                            maximumLength: 128
                            wrapMode: Text.WrapAnywhere
                            onTextChanged: extendInputText(secretKey, secret_key_input_rect, secret_key_rect)
                            onActiveFocusChanged: focusChangedHandler(secretKey, secret_key_input_rect)
                        }

                    }
                }
            }
        }
        // ------------- access key -------------
        Rectangle {
            id: access_key_rect
            y: secret_key_rect.y + secret_key_rect.height + 20
            anchors.horizontalCenter: parent.horizontalCenter
            color: "white"
            width: parent.width - 150
            height: 85
            border.color: "lightgray"
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
                // ------------- icon | title row -------------
                Row {
                    x: 10
                    y: 10
                    width: parent.width
                    height: 40
                    Image {
                        source: "qrc:icons/32_key_icon.png"
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
                        text: "Access Key"
                        verticalAlignment: Text.AlignVCenter
                        font.pointSize: labelFontSize
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
                        id: access_key_input_rect
                        x: 10
                        height: 30
                        width: parent.width
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        border.color: borderColor
                        border.width: 1
                        color: "#efefef"

                        TextInput {
                            id: accessKey
                            x: 10
                            width: parent.width - 20
                            height: parent.height
                            verticalAlignment: Text.AlignVCenter
                            font.pointSize: inputFontSize
                            maximumLength: 128
                            wrapMode: Text.WrapAnywhere
                            onTextChanged: extendInputText(accessKey, access_key_input_rect, access_key_rect)
                            onActiveFocusChanged: focusChangedHandler(accessKey, access_key_input_rect)
                        }

                    }
                }
            }
        }
        // ------------- region -------------
        Rectangle {
            y: access_key_rect.y + access_key_rect.height + 20
            id: region_rect
            anchors.horizontalCenter: parent.horizontalCenter
            color: "white"
            width: parent.width - 150
            height: 85
            border.color: "lightgray"
            border.width: 2
            radius: 5

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
                        source: "qrc:icons/32_region_icon.png"
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
                        text: "Region"
                        verticalAlignment: Text.AlignVCenter
                        font.pointSize: labelFontSize
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
                        id: region_input_rect
                        x: 10
                        width: parent.width
                        height: 30
                        border.color: "gray"
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        border.width: 1
                        color: "#f8f9fa"

                        ComboBox {
                            id: s3region
                            width: parent.width
                            height: parent.height
                            font.pointSize: inputFontSize
                            currentIndex: s3Model.getRegionIdxQML()
                            model: [ "us-east-1",
                                "us-east-2",
                                "eu-central-1",
                                "eu-west-1",
                                "eu-west-2",
                                "eu-west-3" ]
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
                        text: "Network timeout (seconds)"
                        verticalAlignment: Text.AlignVCenter
                        font.pointSize: labelFontSize
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
                        id: timeout_input_rect
                        x: 10
                        width: parent.width
                        height: 30
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        border.color: "gray"
                        border.width: 1
                        color: "#f8f9fa"

                        ComboBox {
                            id: timeout
                            width: parent.width
                            height: parent.height
                            font.pointSize: inputFontSize
                            currentIndex: s3Model.getTimeoutIdxQML()
                            model: [ "3",
                                "5",
                                "10",
                                "15",
                                "20",
                                "25",
                                "30" ]
                        }

                    }
                }
            }
        }

        // ------------- advanced -------------
        Rectangle {
            y: region_rect.y + region_rect.height + 20
            id: advanced_rect
            anchors.horizontalCenter: parent.horizontalCenter
            color: "white"
            width: parent.width - 150
            height: 50
            border.color: "lightgray"
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
                // ------------- icon | title row -------------
                Row {
                    x: 50
                    width: parent.width
                    height: 40

                    Button {
                        y: 4
                        flat: true
                        width: parent.width - 100
                        height: 40
                        text: qsTr("Show advanced options")
                        font.pointSize: labelFontSize
                        onClicked: {
                            if(endpoint_url_rect.visible) {
                                text =  qsTr("Show advanced options")
                                endpoint_url_rect.visible = false
                            } else {
                                text =  qsTr("Hide advanced options")
                                endpoint_url_rect.visible = true
                            }
                        }
                    }
                }
            }
        }

        // ------------- endpoint url -------------
        Rectangle {
            y: advanced_rect.y + advanced_rect.height + 20
            id: endpoint_url_rect
            anchors.horizontalCenter: parent.horizontalCenter
            color: "white"
            width: parent.width - 150
            height: 85
            border.color: "lightgray"
            border.width: 2
            radius: 5
            visible: false

            Column {
                width: parent.width
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
                        text: "Endpoint URL"
                        verticalAlignment: Text.AlignVCenter
                        font.pointSize: labelFontSize
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
                        id: endpoint_input_rect
                        x: 10
                        width: parent.width
                        height: 30
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        border.color: borderColor
                        border.width: 1
                        color: "#efefef"

                        TextInput {
                            id: endpointURL
                            x: 10
                            width: parent.width - 20
                            height: parent.height
                            verticalAlignment: Text.AlignVCenter
                            font.pointSize: inputFontSize
                            maximumLength: 128
                            wrapMode: Text.WrapAnywhere
                            onTextChanged: extendInputText(endpointURL, endpoint_input_rect, endpoint_url_rect)
                            onActiveFocusChanged: focusChangedHandler(endpointURL, endpoint_input_rect)
                        }
                    }
                }
            }
        }
    }
}
