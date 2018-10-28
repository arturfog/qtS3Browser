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
Window {
    id: progress_win
    width: 500; height: 310
    minimumHeight: 310; maximumHeight: 310
    minimumWidth: 500; maximumWidth: 500

    title: "Progress"

    property double currentProgress: 0
    property double currentBytes: 0
    property double totalBytes: 0
    property string currentFile: ""
    property string icon: "qrc:icons/32_upload_icon.png"

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

        if(!visible) {
            s3Model.refreshQML()
        }
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
            currentBytes = current
            totalBytes = total

            var currentDate = new Date()
            var seconds = currentDate.getSeconds() - lastDate.getSeconds()

            if(totalBytes > 0 && seconds > 0) {
                console.log("seconds: " + seconds + " current:" + current)
                var bytesdiff = current - lastTotalBytes
                secondsLeft = (totalBytes - currentBytes) / transferSpeedBytes
                if(bytesdiff > 0) {
                    transferSpeedBytes = (bytesdiff / seconds)
                    console.log("bytesdiff: " + bytesdiff + " " + transferSpeedBytes)
                }
                lastTotalBytes = current
            }

            lastDate = currentDate

            currentProgress = (((current / total) * 100) | 0)
            currentFile = s3Model.getCurrentFileQML()

            if(currentProgress == 100) {
                cancel_btn.icon.source = "qrc:icons/32_close_icon.png"
                cancel_btn.text = "Close"
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
                text: title
                font.bold: true
                font.pointSize: 14
                height: parent.height
                verticalAlignment: Text.AlignVCenter
            }
        }
    }

    // ------------------------------------------------------------
    DropShadow {
        anchors.fill: operation_progress_rect
        horizontalOffset: 1
        verticalOffset: 2
        radius: 8.0
        samples: 17
        color: "#aa000000"
        source: operation_progress_rect
    }

    Rectangle {
        id: operation_progress_rect
        y: 60
        anchors.horizontalCenter: parent.horizontalCenter
        color: "white"
        width: parent.width - 50
        height: 180
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
                    source: "qrc:icons/32_file_icon.png"
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    width: parent.width
                    height: 40
                    text: currentFile
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

            Row {
                x: 10
                y: 10
                width: parent.width
                height: 40

                ProgressBar {
                    id: current_pb
                    height: parent.height
                    width: parent.width - 80
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

            Rectangle {
                width: parent.width
                height: 5
            }

            Row {
                x: 20
                y: 10
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
                    font.pointSize: 11
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
                    width: 30
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
                    font.pointSize: 11
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
                    font.pointSize: 11
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
                    width: 30
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
                    font.pointSize: 11
                }
            }
        }
    }

    Button {
        id: cancel_btn
        x: operation_progress_rect.width - cancel_btn.width
        y: operation_progress_rect.y + operation_progress_rect.height + 10
        height: 40
        text: qsTr("Cancel")
        icon.source: "qrc:icons/32_cancel_icon.png"
        icon.color: "transparent"
        onClicked: {
            if(currentProgress < 100) {
                s3Model.cancelDownloadUploadQML()
                if(mode == modeDL) {
                    var path = s3Model.getFileBrowserPath() + currentFile
                    console.log("removing not finished file: " + path)
                    fsModel.removeQML(path)
                }
            }

            close()
        }
    }
    // ------------------------------------------------------------
}
