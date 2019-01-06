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

    property double currentBytes: 0
    property double totalBytes: 0
    property string icon: "qrc:icons/32_transfer_icon.png"

    property var lastDate: new Date()
    property double lastTotalBytes: 0
    property double transferSpeedBytes: 0
    property int secondsLeft: 0

    onVisibleChanged: {
        lastTotalBytes = 0
        totalBytes = 0
        transferSpeedBytes = 0
        secondsLeft = 0
        lastDate = new Date()
        updateTransfersQueue()
        updateTransfers()
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

    function updateTransfers() {
        var transfersLen = ftModel.getTransferProgressNum();

        for(var i = transfers_list.children.length; i > 0 ; i--) {
          transfers_list.children[i-1].destroy()
        }

        if(transfersLen > 0) {
            for(i = 0; i < transfersLen; i++)
            {
                var key = ftModel.getTransfersProgressKey(i);
                var currentBytes = ftModel.getTransfersCopiedBytes(key)
                var totalBytes = ftModel.getTransfersTotalBytes(key)
                var currentProgress = (((currentBytes / totalBytes) * 100) | 0)

var newObject = Qt.createQmlObject('
import QtQuick 2.5;
import QtQuick.Controls 2.2;

Rectangle {
    x: 5
    width: parent.width - 10;
    height: 65
    color: "transparent"

        Row {
            x: 10
            y: 4
            width: parent.width
            height: 40

            Text {
                wrapMode: Text.NoWrap
                elide: Text.ElideRight
                width: parent.width - 560
                height: 40
                text: "' + key + '"
                verticalAlignment: Text.AlignVCenter
                font.pointSize: getSmallFontSize()
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

            ProgressBar {
                id: current_pb
                height: parent.height
                width: 160
                value: ' + currentProgress + '
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
                text: Number(' + currentProgress + ')  + " %" + tsMgr.emptyString
                verticalAlignment: Text.AlignVCenter
                font.pointSize: getSmallFontSize()
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

            Image {
                source: "qrc:icons/32_server_icon.png"
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                height: 40
                width: 120
                text: qsTr("Copied: ") + getSizeString(' + currentBytes + ') + tsMgr.emptyString
                verticalAlignment: Text.AlignVCenter
                font.pointSize: getSmallFontSize()
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

            Image {
                source: "qrc:icons/32_hdd_icon2.png"
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                height: 40
                text: qsTr("Total: ") + getSizeString(' + totalBytes + ') + tsMgr.emptyString
                verticalAlignment: Text.AlignVCenter
                font.pointSize: getSmallFontSize()
            }
        }

    Rectangle {
        width: parent.width
        color: "gray"
        height: 1
    }
}
', transfers_list, "dynamicTransfers");
            }
        }
    }

    function updateTransfersQueue() {
        var transfersLen = ftModel.getTransfersNumQML();
        var keys = ftModel.getTransfersKeysQML()

        for(var i = transfers_queue_list.children.length; i > 0 ; i--) {
          transfers_queue_list.children[i-1].destroy()
        }

        var emptyObject = null;

        if(transfersLen > 0) {
            for(i = 0; i < transfersLen; i++)
            {
                var srcPath = ftModel.getTransferSrcPathQML(i)
                var dstPath = ftModel.getTransferDstPathQML(i)
                var icon = ftModel.getTransferIconQML(keys[i])
                var newObject = Qt.createQmlObject('
import QtQuick 2.5;
import QtQuick.Controls 2.2;

Rectangle {
    x: 5
    width: parent.width - 10;
    height: 65
    color: "transparent"

    Row {
        width: parent.width;
        height: 45
        anchors.verticalCenter: parent.verticalCenter
        id: bookmarks_item
        x: 10

        Image
        {
            source: "qrc:icons/' + icon +'"
        }

        Rectangle
        {
            width: 10
            height: 10
        }

        Column {
          width: parent.width - 390;
          Text {
            font.pointSize: 14
            text: "' + keys[i] +'"
           }

           Text {
             font.pointSize: 8
             text: \'<a href="' + srcPath +'">' + srcPath + '</a>\'
           }
           Text {
             font.pointSize: 8
             text: "' + dstPath + '"
           }
        }
    }

Rectangle {
    width: parent.width
    color: "gray"
    height: 1
}
}
                ', transfers_queue_list, "dynamicTransfersQueue");
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
            currentBytes = current
            totalBytes = total
            updateTransfers()

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

            if(s3Model.isTransferring()) {
                cancel_btn.visible = true
            } else {
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
                text: qsTr("File transfers") + tsMgr.emptyString
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
                text: qsTr("Cancel") + tsMgr.emptyString
                icon.source: "qrc:icons/32_cancel_icon.png"
                icon.color: "transparent"
                visible: false
                onClicked: {
                    if(s3Model.isTransferring()) {
                        s3Model.cancelDownloadUploadQML()
                        ftModel.clearTransfersProgress()
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
        id: transfers_progress_rect
        y: 60
        anchors.horizontalCenter: parent.horizontalCenter
        color: "white"
        width: parent.width - 50
        height: parent.height / 2 - y
        border.color: "lightgray"
        border.width: 2
        radius: 5

        Row {
            x: 10
            y: 5
            width: parent.width
            height: 40

            Image {
                source: "qrc:icons/32_transfers_icon.png"
                anchors.verticalCenter: parent.verticalCenter
            }
            // ------------------ currently transferred file ----------------
            Text {
                wrapMode: Text.NoWrap
                elide: Text.ElideRight
                width: parent.width - 400
                height: 40
                text: qsTr("Transfers progress") + tsMgr.emptyString
                verticalAlignment: Text.AlignVCenter
                font.pointSize: getMediumFontSize()
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

            Image {
                source: "qrc:icons/32_dl_speed_icon.png"
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                height: 40
                width: 100
                text: qsTr("Speed: ") + getSizeString(transferSpeedBytes) + "/s" + tsMgr.emptyString
                verticalAlignment: Text.AlignVCenter
                font.pointSize: getSmallFontSize()
            }
        }

        Rectangle {
            width: parent.width
            color: "#dbdbdb"
            y:45
            height: 1
        }

        Rectangle
        {
            id: transfers_frame
            x: 5
            y: 50
            width: parent.width - 10
            height: parent.height - 80
            clip: true

            MouseArea {
                parent: transfers_progress_rect      // specify the `visual parent`
                height: parent.height
                width: parent.width - 160;
                onWheel:
                {
                    if(transfers_frame.height < transfers_list.height)
                    {
                        if (wheel.angleDelta.y > 0)
                        {
                            vbar.decrease()

                        }
                        else
                        {
                            vbar.increase()
                        }
                    }
                }
            }


            ScrollBar {
                    id: vbar
                    hoverEnabled: true
                    active: true
                    orientation: Qt.Vertical
                    size: transfers_frame.height / transfers_list.height
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
    // ------------------------------------------------------------
    Rectangle {
        id: manage_transfers_rect
        y: transfers_progress_rect.height + transfers_progress_rect.y + 20
        anchors.horizontalCenter: parent.horizontalCenter
        color: "white"
        width: parent.width - 50
        height: parent.height - y - 50
        border.color: "lightgray"
        border.width: 2
        radius: 5

        onVisibleChanged: {
            transfers_list.update()
        }

        Timer {
            interval: 500
            running: true
            repeat: true
            onTriggered: {
                var pendingTransfers = ftModel.getTransfersNumQML()
                if(pendingTransfers > 0) {
                    var src = ftModel.getTransferSrcPathQML(0);
                    var dst = ftModel.getTransferDstPathQML(0);

                    if(s3Model.isConnectedQML() && (s3Model.isTransferring() === false))
                    {
                        cancel_btn.visible = false
                        if(ftModel.getTransferModeQML(0) === 1)
                        {
                            s3Model.downloadQML(src, dst)
                            ftModel.removeTransferQML(0);
                            updateTransfersQueue()
                        }
                        else if (ftModel.getTransferModeQML(0) === 0)
                        {
                            s3Model.uploadQML(src, dst)
                            ftModel.removeTransferQML(0);
                            updateTransfersQueue()
                        }
                    }
                }
            }
        }

        Row {
            x: 10
            y: 5
            width: parent.width
            height: 40

            Image {
                source: "qrc:icons/32_traffic_icon.png"
                anchors.verticalCenter: parent.verticalCenter
            }
            // ------------------ currently transferred file ----------------
            Text {
                wrapMode: Text.NoWrap
                elide: Text.ElideRight
                width: parent.width - 50
                height: 40
                text: qsTr("Transfers queue") + tsMgr.emptyString
                verticalAlignment: Text.AlignVCenter
                font.pointSize: getMediumFontSize()
            }
        }

        Rectangle {
            width: parent.width
            color: "#dbdbdb"
            y:45
            height: 1
        }

        Rectangle
        {
            id: frame
            x: 5
            y: 50
            width: parent.width - 10
            height: parent.height - 80
            clip: true

            MouseArea {
                parent: manage_transfers_rect      // specify the `visual parent`
                height: parent.height
                width: parent.width - 160;
                onWheel:
                {
                    if(frame.height < transfers_queue_list.height)
                    {
                        if (wheel.angleDelta.y > 0)
                        {
                            vbar_queue.decrease()

                        }
                        else
                        {
                            vbar_queue.increase()
                        }
                    }
                }
            }

            ScrollBar {
                    id: vbar_queue
                    hoverEnabled: true
                    active: true
                    orientation: Qt.Vertical
                    size: frame.height / transfers_queue_list.height
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
            }

            Column {
                y: -vbar_queue.position * height
                id: transfers_queue_list
                width: parent.width
            }
        }
    }
}
