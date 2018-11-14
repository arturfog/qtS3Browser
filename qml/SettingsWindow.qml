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
Window {
    id: settings_win
    width: 640; height: 640
    minimumHeight: 350; maximumHeight: 640
    minimumWidth: 640
    color: "#f8f9fa"
    title: "Settings"

    property string borderColor: "gray"
    readonly property int labelFontSize: 11
    readonly property int inputFontSize: getSmallFontSize()

    onVisibilityChanged: {
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
                verticalAlignment: Text.AlignVCenter
            }
        }
    }

    // ------------- S3 start path -------------
    DropShadow {
        anchors.fill: start_path_rect
        horizontalOffset: 1
        verticalOffset: 2
        radius: 8.0
        samples: 17
        color: "#aa000000"
        source: start_path_rect
    }

    Rectangle {
        y: 60
        id: start_path_rect
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
                    source: "qrc:icons/32_home_icon.png"
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
            // ------------- input field top gap -------------
            Rectangle {
                width: parent.width
                height: 5
            }

            Rectangle {
                id: start_path_input_rect
                x: 10
                width: parent.width - 20
                height: 30
                border.color: borderColor
                border.width: 1
                radius: 20
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
    // ------------- secret key -------------
    DropShadow {
        anchors.fill: secret_key_rect
        horizontalOffset: 1
        verticalOffset: 2
        radius: 8.0
        samples: 17
        color: "#aa000000"
        source: secret_key_rect
    }


    Rectangle {
        y: start_path_rect.y + start_path_rect.height + 20
        id: secret_key_rect
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
            // ------------- input field top gap -------------
            Rectangle {
                width: parent.width
                height: 5
            }


            Rectangle {
                id: secret_key_input_rect
                x: 10
                width: parent.width - 20
                height: 30
                border.color: borderColor
                border.width: 1
                radius: 20
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
    // ------------- access key -------------
    DropShadow {
        anchors.fill: access_key_rect
        horizontalOffset: 1
        verticalOffset: 2
        radius: 8.0
        samples: 17
        color: "#aa000000"
        source: access_key_rect
    }


    Rectangle {
        id: access_key_rect
        y: secret_key_rect.y + secret_key_rect.height + 20
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
            // ------------- input field top gap -------------
            Rectangle {
                width: parent.width
                height: 5
            }


            Rectangle {
                id: access_key_input_rect
                x: 10
                width: parent.width - 20
                height: 30
                border.color: borderColor
                border.width: 1
                radius: 20
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
    // ------------- region -------------
    DropShadow {
        anchors.fill: region_rect
        horizontalOffset: 1
        verticalOffset: 2
        radius: 8.0
        samples: 17
        color: "#aa000000"
        source: region_rect
    }


    Rectangle {
        y: access_key_rect.y + access_key_rect.height + 20
        id: region_rect
        anchors.horizontalCenter: parent.horizontalCenter
        color: "white"
        width: parent.width - 50
        height: 85
        border.color: "#efefef"
        border.width: 1
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
            // ------------- combo box top gap -------------
            Rectangle {
                width: parent.width
                height: 5
            }

            Rectangle {
                id: region_input_rect
                x: 10
                width: parent.width - 20
                height: 30
                border.color: "gray"
                border.width: 1
                radius: 20
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
            // ------------- combo box top gap -------------
            Rectangle {
                width: parent.width
                height: 5
            }

            Rectangle {
                id: timeout_input_rect
                x: 10
                width: parent.width - 20
                height: 30
                border.color: "gray"
                border.width: 1
                radius: 20
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
    // ------------- endpoint url -------------
    DropShadow {
        anchors.fill: endpoint_url_rect
        horizontalOffset: 1
        verticalOffset: 2
        radius: 8.0
        samples: 17
        color: "#aa000000"
        source: endpoint_url_rect
    }


    Rectangle {
        y: region_rect.y + region_rect.height + 20
        id: endpoint_url_rect
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
            // ------------- input field top gap -------------
            Rectangle {
                width: parent.width
                height: 5
            }


            Rectangle {
                id: endpoint_input_rect
                x: 10
                width: parent.width - 20
                height: 30
                border.color: borderColor
                border.width: 1
                radius: 20
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
    // ------------- save/cancel buttons -------------
    Rectangle {
        x: 10
        y: endpoint_url_rect.y + endpoint_url_rect.height + 10
        width: parent.width - 20
        height: 50
        Row {
            y: 10
            height: parent.height
            anchors.horizontalCenter: parent.horizontalCenter
            // ------------- save -------------
            Button {
                font.pointSize: labelFontSize
                text: "Save"
                icon.source: "qrc:icons/32_save_icon.png"
                icon.color: "transparent"
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
                    close()
                }
            }
            // ------------- buttons gap -------------
            Rectangle {
                width: 5
                height: parent.height
            }
            // ------------- cancel -------------
            Button {
                font.pointSize: labelFontSize
                text: "Cancel"
                icon.source: "qrc:icons/32_cancel_icon.png"
                icon.color: "transparent"
                onClicked: {
                    close()
                }
            }
        }
    }
}
