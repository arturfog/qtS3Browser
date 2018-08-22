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
    id: settings_win
    x: 100; y: 100; width: 400; height: 440
    minimumHeight: 300; maximumHeight: 440
    minimumWidth: 300

    title: "Settings"

    onVisibilityChanged: {
        startPath.text = s3Model.getStartPathQML()
        secretKey.text = s3Model.getSecretKeyQML()
        accessKey.text = s3Model.getAccesKeyQML()
        endpointURL.text = s3Model.getEndpointQML()
    }

    Column {
        width: parent.width
        height: parent.height

        Row {
            x: 10
            y: 10
            width: parent.width - 20
            height: 34

            Image {
                source: "qrc:icons/32_home_icon.png"
            }

            Text {
                width: parent.width
                anchors.verticalCenter: parent.verticalCenter
                text: "S3 Start Path"
                font.pointSize: 12
            }
        }

        Rectangle {
            x: 10
            y: 55
            width: parent.width - 20
            height: 34
            border.color: "black"
            color: "white"
            border.width: 1

            TextInput {
                id: startPath
                x: 5
                width: parent.width
                anchors.verticalCenter: parent.verticalCenter
                //text: s3Model.getStartPathQML()
                maximumLength: 48
            }
        }

        Rectangle {
            width: parent.width
            height: 10
        }

        Row {
            x: 10
            y: 10
            width: parent.width - 20
            height: 34

            Image {
                source: "qrc:icons/32_secret_icon.png"
            }

            Text {
                width: parent.width
                anchors.verticalCenter: parent.verticalCenter
                text: "Secret Key"
                font.pointSize: 12
            }
        }

        Rectangle {
            x: 10
            y: 55
            width: parent.width - 20
            height: 34
            border.color: "black"
            color: "white"
            border.width: 1

            TextInput {
                id: secretKey
                x: 5
                width: parent.width
                anchors.verticalCenter: parent.verticalCenter
                //text: s3Model.getSecretKeyQML()
                maximumLength: 48
            }
        }

        Rectangle {
            width: parent.width
            height: 10
        }


        Row {
            x: 10
            y: 10
            width: parent.width - 20
            height: 34

            Image {
                source: "qrc:icons/32_key_icon.png"
            }

            Text {
                width: parent.width
                anchors.verticalCenter: parent.verticalCenter
                text: "Access Key"
                font.pointSize: 12
            }
        }

        Rectangle {
            x: 10
            y: 55
            width: parent.width - 20
            height: 34
            border.color: "black"
            color: "white"
            border.width: 1

            TextInput {
                id: accessKey
                x: 5
                width: parent.width
                anchors.verticalCenter: parent.verticalCenter
                //text: s3Model.getAccesKeyQML()
                maximumLength: 48
            }
        }

        Rectangle {
            width: parent.width
            height: 10
        }


        Row {
            x: 10
            y: 10
            width: parent.width - 20
            height: 34

            Image {
                source: "qrc:icons/32_region_icon.png"
            }

            Text {
                width: parent.width
                anchors.verticalCenter: parent.verticalCenter
                text: "Region"
                font.pointSize: 12
            }
        }

        Rectangle {
            x: 10
            y: 55
            width: parent.width - 20
            height: 40
            border.color: "black"
            color: "white"
            border.width: 1

            ComboBox {
                id: s3region
                width: parent.width
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

        Rectangle {
            width: parent.width
            height: 10
        }


        Row {
            x: 10
            y: 10
            width: parent.width - 20
            height: 34

            Image {
                source: "qrc:icons/32_endpoint_icon.png"
            }

            Text {
                width: parent.width
                anchors.verticalCenter: parent.verticalCenter
                text: "Endpoint URL"
                font.pointSize: 12
            }
        }

        Rectangle {
            x: 10
            y: 55
            width: parent.width - 20
            height: 34
            border.color: "black"
            color: "white"
            border.width: 1

            TextInput {
                id: endpointURL
                x: 5
                width: parent.width
                anchors.verticalCenter: parent.verticalCenter
                //text: s3Model.getEndpointQML()
                maximumLength: 48
            }
        }

        Rectangle {
            x: 10
            y: 55
            width: parent.width - 20
            height: 50

            Row {
                y: 10
                height: parent.height
                anchors.horizontalCenter: parent.horizontalCenter
                Button {
                    text: "Save"
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
                    onClicked: {
                        close()
                    }
                }
            }
        }
    }
}
