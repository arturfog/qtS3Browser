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
    x: 100; y: 100; width: 480; height: 640
    minimumHeight: 350; maximumHeight: 640
    minimumWidth: 400
    color: "#f8f9fa"
    title: "Settings"

    property string borderColor: "gray"

    onVisibilityChanged: {
        startPath.text = s3Model.getStartPathQML()
        secretKey.text = s3Model.getSecretKeyQML()
        accessKey.text = s3Model.getAccesKeyQML()
        endpointURL.text = s3Model.getEndpointQML()
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
                font.pointSize: 14
                height: parent.height
                verticalAlignment: Text.AlignVCenter
            }
        }
    }

    // --------------------------------------------------------------------------
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
                id: start_path_input_rect
                x: 10
                width: parent.width - 20
                height: 30
                border.color: borderColor
                border.width: 2
                radius: 20
                color: "#efefef"

                TextInput {
                    id: startPath
                    x: 10
                    width: parent.width
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: 10
                    maximumLength: 48

                    onActiveFocusChanged: {
                        if(startPath.focus) {
                            start_path_input_rect.color = "white"
                            start_path_input_rect.border.color = "orange"
                        } else {
                            start_path_input_rect.color = "#efefef"
                            start_path_input_rect.border.color = borderColor
                        }
                    }
                }

            }
        }
    }
    // --------------------------------------------------------------------------
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
                id: secret_key_input_rect
                x: 10
                width: parent.width - 20
                height: 30
                border.color: borderColor
                border.width: 2
                radius: 20
                color: "#efefef"

                TextInput {
                    id: secretKey
                    x: 10
                    width: parent.width
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: 10
                    maximumLength: 48

                    onActiveFocusChanged: {
                        if(secretKey.focus) {
                            secret_key_input_rect.color = "white"
                            secret_key_input_rect.border.color = "orange"
                        } else {
                            secret_key_input_rect.color = "#efefef"
                            secret_key_input_rect.border.color = borderColor
                        }
                    }
                }

            }
        }
    }
    // --------------------------------------------------------------------------
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
        y: secret_key_rect.y + secret_key_rect.height + 20
        id: access_key_rect
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
                id: access_key_input_rect
                x: 10
                width: parent.width - 20
                height: 30
                border.color: borderColor
                border.width: 2
                radius: 20
                color: "#efefef"

                TextInput {
                    id: accessKey
                    x: 10
                    width: parent.width
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: 10
                    maximumLength: 48

                    onActiveFocusChanged: {
                        if(accessKey.focus) {
                            access_key_input_rect.color = "white"
                            access_key_input_rect.border.color = "orange"
                        } else {
                            access_key_input_rect.color = "#efefef"
                            access_key_input_rect.border.color = borderColor
                        }
                    }
                }

            }
        }
    }
    // --------------------------------------------------------------------------
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
            width: parent.width
            height: parent.height

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
                    source: "qrc:icons/32_region_icon.png"
                }

                Text {
                    width: parent.width
                    height: 40
                    text: "Region"
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
                id: region_input_rect
                x: 10
                width: parent.width - 20
                height: 30
                border.color: "gray"
                border.width: 2
                radius: 20
                color: "#f8f9fa"

                ComboBox {
                    id: s3region
                    width: parent.width
                    height: parent.height
                    currentIndex: s3Model.getRegionIdxQML()
                    model: [ "Default",
                        "us-east-1",
                        "us-east-2",
                        "eu-central-1",
                        "eu-west-1",
                        "eu-west-2",
                        "eu-west-3" ]
                }

            }
        }
    }
    // --------------------------------------------------------------------------
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
                id: endpoint_input_rect
                x: 10
                width: parent.width - 20
                height: 30
                border.color: borderColor
                border.width: 2
                radius: 20
                color: "#efefef"

                TextInput {
                    id: endpointURL
                    x: 10
                    width: parent.width
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: 10
                    maximumLength: 48

                    onActiveFocusChanged: {
                        if(endpointURL.focus) {
                            endpoint_input_rect.color = "white"
                            endpoint_input_rect.border.color = "orange"
                        } else {
                            endpoint_input_rect.color = "#efefef"
                            endpoint_input_rect.border.color = borderColor
                        }
                    }
                }

            }
        }
    }
    // --------------------------------------------------------------------------
    Rectangle {
        x: 10
        y: endpoint_url_rect.y + endpoint_url_rect.height + 10
        width: parent.width - 20
        height: 50

        Row {
            y: 10
            height: parent.height
            anchors.horizontalCenter: parent.horizontalCenter
            Button {
                text: "Save"
                icon.source: "qrc:icons/32_save_icon.png"
                icon.color: "transparent"
                onClicked: {
                    s3Model.saveSettingsQML(startPath.text,
                                            accessKey.text,
                                            secretKey.text,
                                            s3region.currentIndex,
                                            s3region.currentText,
                                            endpointURL.text
                                            )
                    close()
                }
            }

            Rectangle {
                width: 5
                height: parent.height
            }


            Button {
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
