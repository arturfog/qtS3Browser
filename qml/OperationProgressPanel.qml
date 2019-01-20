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

    property int sumTotalKBytes: 0
    property int sumCurrentKBytes: 0
    property var lastDate: new Date()
    property var lastDateFast: new Date()
    property int transferSpeedBytes: 0
    property int secondsLeft: 0
    property bool needsRefresh: false

    onVisibleChanged: {
        lastDate = 0
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

    function getSizeString2(kbytes) {
        if(kbytes > 1048576) {
            return Number(kbytes / 1048576).toFixed(1)  + " GB"
        } else if(kbytes >= 1024) {
            return Number(kbytes / 1024).toFixed(1)  + " MB"
        } else {
            return Number(kbytes)  + " KB"
        }
    }

    function pad(number) {
        if(number < 10) {
            return "0" + number
        }

        return number
    }

    function createTransferProgressObject(key, currentProgress, currentBytes, totalBytes) {
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
                        text: Number(' + currentProgress + ')  + " %"
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

    function updateTransferProgressObject(children_, currentProgress, currentBytes) {
        var progressBar_ = children_.children[0].children[4]
        var progressText_ = children_.children[0].children[8]
        var currentText_ = children_.children[0].children[13]
        var totalText_ = children_.children[0].children[18]

        progressBar_.value = currentProgress
        progressText_.text = Number(currentProgress)  + " %"
        currentText_.text = qsTr("Copied: ") + getSizeString(currentBytes) + tsMgr.emptyString
        //totalText_.text = qsTr("Total: ") + getSizeString(totalBytes) + tsMgr.emptyString
    }

    function deleteTransferProgressObject(children_) {
        children_.destroy();
    }

    function updateTransfers() {
        var transfersLen = ftModel.getTransferProgressNum()
        var transfersItemsLen = transfers_list.children.length

        if(transfersLen > 0) {
            for(var i = 0; i < transfersLen; i++)
            {
                var keyExists = false;
                var key = ftModel.getTransfersProgressKey(i);
                var currentBytes = ftModel.getTransfersCopiedBytes(key)
                var totalBytes = ftModel.getTransfersTotalBytes(key)
                var currentProgress = (((currentBytes / totalBytes) * 100) | 0)
                transfersItemsLen = transfers_list.children.length

                for(var j = transfersItemsLen; j > 0 ; j--) {
                  var children_ = transfers_list.children[j - 1]
                  var key_ = children_.children[0].children[0].text
                  if(key_ === key) {
                      if(currentProgress >= 100) {
                          deleteTransferProgressObject(children_)
                          break;
                      }
                      keyExists = true
                      break
                  }
                }

                if(keyExists) {
                    updateTransferProgressObject(children_, currentProgress, currentBytes)
                } else if(currentProgress < 100) {
                    createTransferProgressObject(key, currentProgress, currentBytes, totalBytes)
                }
            }
            if(ftModel.getTransferDirection() === 0) {
                sumTotalKBytes = s3Model.getCurrentUploadTotalBytes()
            } else {
                sumTotalKBytes = ftModel.getAllTransfersTotalBytes()
            }
            sumCurrentKBytes = ftModel.getAllTransfersCurrentBytes()
        } else {
            transfersItemsLen = transfers_list.children.length
            for(i = transfersItemsLen; i > 0 ; i--) {
              transfers_list.children[i-1].destroy();
            }
        }
    }

    function createTransferQueueObject(srcPath, dstPath, icon, keys, i) {
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
                      width: parent.width - 220;
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

                    Button {
                      text: "Cancel"
                      icon.source: "qrc:icons/32_cancel_icon.png"
                      icon.color: "transparent"
                      onClicked: {
                        ftModel.removeTransferQML(' + i + ')
                        updateTransfersQueue()
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
                createTransferQueueObject(srcPath, dstPath, icon, keys, i)
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
            if(lastDate === 0) {
                sumCurrentKBytes = 0
                sumTotalKBytes = 0
                transferSpeedBytes = 0
                secondsLeft = 0
                lastDate = new Date()
                lastDateFast = new Date()
            }

            var currentDate = new Date()
            var seconds = (currentDate - lastDate) / 1000
            if(seconds > 0) {
                transferSpeedBytes = sumCurrentKBytes / seconds
                if(transferSpeedBytes > 0) {
                    secondsLeft = ((sumTotalKBytes - sumCurrentKBytes) / transferSpeedBytes)
                }
            }

            // wait 100 ms
            if ( (currentDate - lastDateFast) >= 100) {
                updateTransfers();
                lastDateFast = currentDate
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
                    if(ftModel.isTransferring()) {
                        ftModel.clearTransfersQueue()
                        s3Model.cancelDownloadUploadQML()
                        ftModel.clearTransfersProgress()
                        cancel_btn.visible = false
                        lastDate = 0

                        updateTransfersQueue()
                        updateTransfers()
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
                width: parent.width - 520
                height: 40
                text: qsTr("Transfers progress") + tsMgr.emptyString
                verticalAlignment: Text.AlignVCenter
                font.pointSize: getMediumFontSize()
            }


            //-----------------------------------------
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

            Rectangle {
                width: 5
                height: parent.height
                color: "transparent"
            }

            Text {
                height: 40
                text: qsTr("Copied: ") + getSizeString2(sumCurrentKBytes)
                verticalAlignment: Text.AlignVCenter
                font.pointSize: getSmallFontSize()
            }

            Rectangle {
                width: 5
                height: parent.height
                color: "transparent"
            }
            //-----------------------------------------


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
                text: qsTr("Speed: ") + getSizeString2(transferSpeedBytes) + "/s" + tsMgr.emptyString
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

                    if(s3Model.isConnectedQML() && (ftModel.isTransferring() === false))
                    {
                        if(ftModel.getTransferModeQML(0) === 1)
                        {
                            s3Model.downloadQML(src, dst)
                        }
                        else if (ftModel.getTransferModeQML(0) === 0)
                        {
                            s3Model.uploadQML(src, dst)
                        }
                        ftModel.removeTransferQML(0);
                        updateTransfersQueue()
                    }
                }

                if(!ftModel.isTransferring()) {
                    if(progress_win.visible === true) {
                        cancel_btn.visible = false;
                        updateTransfers();
                        vbar.position = 0
                        vbar_queue.position = 0
                    }

                    if(s3Model.isConnectedQML() && needsRefresh) {
                        s3Model.refreshQML()
                        mainPanel.file_panel.refresh()
                        needsRefresh = false
                    }
                } else {
                    cancel_btn.visible = true;
                    needsRefresh = true
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
