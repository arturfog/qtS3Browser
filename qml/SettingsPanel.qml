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
    property var inputForRightClick: secretKey
    property int selectStart
    property int selectEnd
    property int curPos

    onVisibleChanged: {
        startPath.text = settingsModel.getStartPathQML()
        secretKey.text = settingsModel.getSecretKeyQML()
        accessKey.text = settingsModel.getAccesKeyQML()
        endpointURL.text = settingsModel.getEndpointQML()
        logsPath.text = settingsModel.getLogsDirQML()
        enableLogs.checked = settingsModel.getLogsEnabledQML()
    }

    function extendInputText(input, input_field, input_field_rect) {
        let sizeInc = 40;
        if(input.text.length > 40 && input_field.height === 30) {
            input_field.height += sizeInc
            input_field_rect.height += sizeInc
            input_field.parent.y += 20
        } else if(input.text.length <= 40 && input_field.height > 30) {
            input_field_rect.height -= sizeInc
            input_field.height -= sizeInc
            input_field.parent.y -= 20
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
                inputForRightClick.cut()
            }
        }
        MenuItem {
            text: "Copy"
            onTriggered: {
                inputForRightClick.copy()
            }
        }
        MenuItem {
            text: "Paste"
            onTriggered: {
                inputForRightClick.paste()
            }
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
                text: qsTr("Settings") + tsMgr.emptyString
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
                text: qsTr("Save") + tsMgr.emptyString
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
                                            endpointURL.text,
                                            logsPath.text,
                                            enableLogs.checked
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
            // --------------------------
        }
    }

    ScrollView {
        y: 60
        width: parent.width
        height: parent.height - 50
        contentHeight: start_path_rect.height + secret_key_rect.height +
                       access_key_rect.height + region_rect.height +
                       endpoint_url_rect.height + advanced_rect.height +
                       logging_rect.height + 140
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
                width: parent.width / 2
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
                        text: qsTr("S3 Start Path") + tsMgr.emptyString
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
                            selectByMouse: true

                            MouseArea {
                                anchors.fill: parent
                                acceptedButtons: Qt.RightButton
                                hoverEnabled: true
                                onClicked: {
                                    inputForRightClick = startPath
                                    selectStart = inputForRightClick.selectionStart;
                                    selectEnd = inputForRightClick.selectionEnd;
                                    curPos = inputForRightClick.cursorPosition;
                                    var parentValue = getAbsolutePosition(inputForRightClick);
                                    contextMenu.x = mouse.x;
                                    contextMenu.y = parentValue.y
                                    contextMenu.open();
                                    inputForRightClick.cursorPosition = curPos;
                                    inputForRightClick.select(selectStart,selectEnd);
                                }
                            }
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
                        source: "qrc:icons/32_language_icon.png"
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
                        text: qsTr("Language") + tsMgr.emptyString
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
                            model: [ "English",
                                "Polski" ]
                            onCurrentTextChanged: {
                                if(currentText == "Polski") {
                                    tsMgr.selectLanguage("pl")
                                } else {
                                    tsMgr.selectLanguage("en")
                                }
                            }
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
                        text: qsTr("Secret Key") + tsMgr.emptyString
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
                            selectByMouse: true

                            MouseArea {
                                anchors.fill: parent
                                acceptedButtons: Qt.RightButton
                                hoverEnabled: true
                                onClicked: {
                                    inputForRightClick = secretKey
                                    selectStart = inputForRightClick.selectionStart;
                                    selectEnd = inputForRightClick.selectionEnd;
                                    curPos = inputForRightClick.cursorPosition;
                                    var parentValue = getAbsolutePosition(inputForRightClick);
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
                        text: qsTr("Access Key") + tsMgr.emptyString
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
                            selectByMouse: true

                            MouseArea {
                                anchors.fill: parent
                                acceptedButtons: Qt.RightButton
                                hoverEnabled: true
                                onClicked: {
                                    inputForRightClick = accessKey
                                    var parentValue = getAbsolutePosition(inputForRightClick);
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
                        text: qsTr("Region") + tsMgr.emptyString
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
                            currentIndex: settingsModel.getRegionIdxQML()
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
                        text: qsTr("Network timeout (seconds)") + tsMgr.emptyString
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
                            currentIndex: settingsModel.getTimeoutIdxQML()
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
                        text: qsTr("Show advanced options") + tsMgr.emptyString
                        font.pointSize: labelFontSize
                        onClicked: {
                            if(endpoint_url_rect.visible) {
                                text =  qsTr("Show advanced options") + tsMgr.emptyString
                                endpoint_url_rect.visible = false
                                logging_rect.visible = false
                            } else {
                                text =  qsTr("Hide advanced options") + tsMgr.emptyString
                                endpoint_url_rect.visible = true
                                logging_rect.visible = true
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
                        text: qsTr("Endpoint URL") + tsMgr.emptyString
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
                            selectByMouse: true

                            MouseArea {
                                anchors.fill: parent
                                acceptedButtons: Qt.RightButton
                                hoverEnabled: true
                                onClicked: {
                                    inputForRightClick = endpointURL
                                    var parentValue = getAbsolutePosition(inputForRightClick);
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
        // ----------------------------------------
        // ----------- logging settings -----------
        Rectangle {
            y: endpoint_url_rect.y + endpoint_url_rect.height + 20
            id: logging_rect
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
                        source: "qrc:icons/32_logs_icon.png"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Rectangle {
                        width: 5
                        height: parent.height
                        color: "transparent"
                    }

                    Text {
                        width: parent.width - 200
                        height: 40
                        text: qsTr("Log files directory") + tsMgr.emptyString
                        verticalAlignment: Text.AlignVCenter
                        font.pointSize: labelFontSize
                    }

                    Switch {
                        id:enableLogs
                        text: qsTr("Enable logs") + tsMgr.emptyString
                    }
                }

                Rectangle {
                    width: parent.width
                    color: "#dbdbdb"
                    height: 1
                }

                Row {
                    width: parent.width - 20
                    height: 40

                    Rectangle {
                        width: 10
                        color: "transparent"
                        height: parent.height
                    }

                    Rectangle {
                        id: logging_input_rect
                        x: 20
                        width: parent.width - 150
                        height: 30
                        //anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        border.color: borderColor
                        border.width: 1
                        color: "#efefef"

                        TextInput {
                            id: logsPath
                            x: 10
                            width: parent.width - 20
                            height: parent.height
                            verticalAlignment: Text.AlignVCenter
                            font.pointSize: inputFontSize
                            maximumLength: 128
                            wrapMode: Text.WrapAnywhere
                            text: "file:///tmp"
                            onTextChanged: extendInputText(logsPath, logging_input_rect, logging_rect)
                            onActiveFocusChanged: focusChangedHandler(logsPath, logging_input_rect)
                        }
                    }

                    Rectangle {
                        width: 10
                        color: "transparent"
                        height: parent.height
                    }

                    FileDialog {
                        id: fileDialog
                        title: qsTr("Please choose a folder") + tsMgr.emptyString
                        folder: shortcuts.home
                        selectFolder : true
                        onAccepted: {
                            logsPath.text = fileDialog.fileUrl
                        }
                        onRejected: {
                            console.log("Canceled")
                        }
                    }

                    // ------------- log path btn -------------
                    Button {
                        id: logpath_btn
                        font.pointSize: labelFontSize
                        text: qsTr("Select dir") + tsMgr.emptyString
                        icon.source: "qrc:icons/32_save_icon.png"
                        icon.color: "transparent"
                        anchors.verticalCenter: parent.verticalCenter
                        height: 30
                        onClicked: {
                            fileDialog.visible = true
                        }

                        background: Rectangle {
                            implicitWidth: 100
                            implicitHeight: 30
                            opacity: enabled ? 1 : 0.3
                            color: logpath_btn.down ? "#dddedf" : "#eeeeee"

                            Rectangle {
                                width: parent.width
                                height: 1
                                color: logpath_btn.down ? "#17a81a" : "#21be2b"
                                anchors.bottom: parent.bottom
                            }
                        }
                    }
                    // --------------------------
                }
            }
        }
        // ----------------------------------------
    }
}
