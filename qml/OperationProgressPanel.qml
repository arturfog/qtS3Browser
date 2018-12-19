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
import QtQuick 2.9
import QtQuick.Window 2.3
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
Item {
    id: progress_win
    width: parent.width; height: parent.height

    property double currentProgress: 0
    property double currentBytes: 0
    property double totalBytes: 0
    property string currentFile: ""
    property string icon: "qrc:icons/32_transfer_icon.png"

    property var lastDate: new Date()
    property double lastTotalBytes: 0
    property double transferSpeedBytes: 0
    property int secondsLeft: 0

    readonly property int modeDL: 0
    readonly property int modeUPLOAD: 1

    property int mode: modeDL

    onVisibleChanged: {
        lastTotalBytes = 0
        totalBytes = 0
        transferSpeedBytes = 0
        secondsLeft = 0
        lastDate = new Date()
        addTransfers()
    }

    function getSizeString(bytes) {
        if(bytes > 1048576) {
            return Number(bytes / 1048576).toFixed(1)  + " MB"
        } else if(bytes >= 1024) {
            return Number(bytes / 1024).toFixed(1)  + " KB"
        } else {
            return Number(bytes)  + " B"
        }
    }

    function pad(number) {
        if(number < 10) {
            return "0" + number
        }

        return number
    }

    function addTransfers() {
        var transfersLen = ftModel.getTransfersNumQML();

        for(var i = transfers_list.children.length; i > 0 ; i--) {
          transfers_list.children[i-1].destroy()
        }

        var emptyObject = null;

        if(transfersLen > 0) {
            for(i = 0; i < transfersLen; i++)
            {
                var newObject = Qt.createQmlObject('
import QtQuick 2.5;
import QtQuick.Controls 2.2;

Rectangle {
    x: 5
    width: parent.width - 10;
    height: 60
    color: "lightgray"

    Row {
        width: parent.width;
        height: 40
        anchors.verticalCenter: parent.verticalCenter
        id: bookmarks_item
        x: 10

        Image
        {
            source: "qrc:icons/32_amazon_icon.png"
        }

        Rectangle
        {
            width: 10
            height: 10
        }
    }
}
                ', transfers_list, "dynamicTransfers");
            }
        }
    }

    function secondsToEta(seconds) {
        var s = 0
        var m = 0
        var h = 0

        if(seconds > 0) {
            s = (seconds % 60)

            if(seconds >= 60) {
                m = ( Number( (seconds - s) / 60 ) % 60 )
            }

            if(seconds >= 3600) {
                h = Number( ( s - (m * 60) ) / 3600 );
            }
        }
        return pad(h) + ":" + pad(m) + ":" + pad(s)
    }

    Connections {
        target: s3Model
        onSetProgressSignal: {
            cancel_btn.visible = true
            currentBytes = current
            totalBytes = total

            var currentDate = new Date()
            var seconds = currentDate.getSeconds() - lastDate.getSeconds()

            if(totalBytes > 0 && seconds > 0) {
                var bytesdiff = current - lastTotalBytes
                secondsLeft = (totalBytes - currentBytes) / transferSpeedBytes
                if(bytesdiff > 0) {
                    transferSpeedBytes = (bytesdiff / seconds)
                }
                lastTotalBytes = current
            }

            lastDate = currentDate

            currentProgress = (((current / total) * 100) | 0)
            currentFile = s3Model.getCurrentFileQML()

            if(currentProgress >= 100) {
                cancel_btn.visible = false
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
                source: icon
                anchors.verticalCenter: parent.verticalCenter
            }

            Rectangle {
                width: 5
                height: parent.height
                color: "transparent"
            }

            Text {
                color: "white"
                text: "File transfers"
                font.bold: true
                font.pointSize: getLargeFontSize()
                height: parent.height
                width: parent.width - 230
                verticalAlignment: Text.AlignVCenter
            }

            Button {
                id: cancel_btn
                height: 40
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("Cancel")
                icon.source: "qrc:icons/32_cancel_icon.png"
                icon.color: "transparent"
                visible: false
                onClicked: {
                    if(currentProgress < 100) {
                        s3Model.cancelDownloadUploadQML()
                        if(mode == modeDL) {
                            var path = s3Model.getFileBrowserPath() + currentFile
                            fsModel.removeQML(path)
                        }
                    }
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

    // ------------------------------------------------------------
    Rectangle {
        id: operation_progress_rect
        y: 60
        anchors.horizontalCenter: parent.horizontalCenter
        color: "white"
        width: parent.width - 150
        height: 180
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
                    source: "qrc:icons/32_file_icon.png"
                    anchors.verticalCenter: parent.verticalCenter
                }
                // ------------------ currently transferred file ----------------
                Text {
                    wrapMode: Text.NoWrap
                    elide: Text.ElideRight
                    width: parent.width - 50
                    height: 40
                    text: currentFile
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: getSmallFontSize()
                }
            }

            Rectangle {
                width: parent.width
                color: "#dbdbdb"
                height: 1
            }
            // ------------------ progress bar and precentage row ----------------
            Row {
                x: 10
                y: 10
                width: parent.width
                height: 40

                ProgressBar {
                    id: current_pb
                    height: parent.height
                    width: parent.width - 90
                    value: currentProgress
                    to: 100.0
                }

                Rectangle {
                    width: 5
                    height: parent.height
                    color: "transparent"
                }

                Rectangle {
                    width: 1
                    color: "#dbdbdb"
                    height: parent.height - 5
                }

                Rectangle {
                    width: 5
                    height: parent.height
                    color: "transparent"
                }

                Text {
                    height: 40
                    text: Number(currentProgress)  + " %"
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: 12
                }
            }

            Rectangle {
                width: parent.width
                color: "#dbdbdb"
                height: 1
            }

            // ------------------ total item size and currently transferred bytes ----------------
            Row {
                x: 20
                y: 20
                width: parent.width
                height: 40

                Image {
                    source: "qrc:icons/32_server_icon.png"
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    height: 40
                    width: 100
                    text: "Copied: " + getSizeString(currentBytes)
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: getSmallFontSize()
                }

                Rectangle {
                    width: 80
                    height: parent.height
                    color: "transparent"
                }

                Rectangle {
                    width: 1
                    color: "#dbdbdb"
                    height: parent.height - 5
                }

                Rectangle {
                    width: 80
                    height: parent.height
                    color: "transparent"
                }

                Image {
                    source: "qrc:icons/32_hdd_icon2.png"
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    height: 40
                    text: "Total: " + getSizeString(totalBytes)
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: getSmallFontSize()
                }
            }

            Rectangle {
                width: parent.width
                color: "#dbdbdb"
                height: 1
            }

            Row {
                x: 20
                y: 10
                width: parent.width
                height: 40

                Image {
                    source: "qrc:icons/32_dl_speed_icon.png"
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    height: 40
                    width: 100
                    text: "Speed: " + getSizeString(transferSpeedBytes) + "/s"
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: getSmallFontSize()
                }

                Rectangle {
                    width: 80
                    height: parent.height
                    color: "transparent"
                }

                Rectangle {
                    id: lower_divider
                    width: 1
                    color: "#dbdbdb"
                    height: parent.height - 5
                }

                Rectangle {
                    width: 80
                    height: parent.height
                    color: "transparent"
                }

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
                    height: 40
                    text: "ETA: " + secondsToEta(secondsLeft)
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: getSmallFontSize()
                }
            }
        }
    }
    // ------------------------------------------------------------
    Rectangle {
        id: manage_transfers_rect
        y: operation_progress_rect.height + operation_progress_rect.y + 20
        anchors.horizontalCenter: parent.horizontalCenter
        color: "white"
        width: parent.width - 150
        height: 250
        border.color: "lightgray"
        border.width: 2
        radius: 5

        onVisibleChanged: {
            transfers_list.update()
        }

        Rectangle
        {
            id: frame
            x: 5
            y: 10
            width: parent.width - 10
            height: parent.height - 30
            clip: true

            ScrollBar {
                    id: vbar
                    hoverEnabled: true
                    active: true
                    orientation: Qt.Vertical
                    size: frame.height / transfers_list.height
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
            }

            Column {
                y: -vbar.position * height
                id: transfers_list
                width: parent.width
            }
        }
    }
}
