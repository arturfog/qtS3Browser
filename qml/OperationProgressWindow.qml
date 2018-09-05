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
import QtQuick.Controls 2.2

Window {
    id: progress_win
    x: 100; y: 100; width: 500; height: 200
    minimumHeight: 200; maximumHeight: 200
    minimumWidth: 300; maximumWidth: 500

    title: "Progress"

    property double currentProgress: 0
    property double currentBytes: 0
    property double totalBytes: 0
    property string currentFile: ""

    property var lastDate: new Date()
    property double lastTotalBytes: 0
    property double transferSpeedBytes: 0

    onVisibleChanged: {
        if(visible === false) {
            lastTotalBytes = 0
            totalBytes = 0
            transferSpeedBytes = 0
            s3Model.refreshQML()
        } else {
            lastDate = new Date()
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

    Connections {
        target: s3Model
        onSetProgressSignal: {
            currentBytes = current
            totalBytes = total

            var currentDate = new Date()
            var miliseconds = currentDate.getMilliseconds() - lastDate.getMilliseconds()

            if(totalBytes > 0 && miliseconds > 0 && lastTotalBytes < totalBytes) {
                console.log("miliseconds: " + miliseconds)

                var bytesdiff = totalBytes - lastTotalBytes

                if(bytesdiff > 0) {
                    transferSpeedBytes = (bytesdiff / (miliseconds / 1000))
                    console.log("bytesdiff: " + bytesdiff + " " + transferSpeedBytes)
                }


            }

            lastTotalBytes = totalBytes
            lastDate = currentDate

            currentProgress = (((current / total) * 100) | 0)
            currentFile = s3Model.getCurrentFileQML()

            if(currentProgress == 100) {
                cancel_btn.text = "Close"
            }
        }
    }

    Item {
        id: progress_item
        height: parent.height
        width: parent.width

        Column {
            y: 10
            height: parent.height
            width: parent.width
            Text {
                x: 10
                height: 30
                text: "Copying file: " + currentFile
                verticalAlignment: Text.AlignVCenter
            }

            Row {
                id: file_progress_row
                height: 30
                width: parent.width
                x: 10
                ProgressBar {
                    id: current_pb
                    height: parent.height
                    width: parent.width - 70
                    value: currentProgress
                    to: 100.0
                }

                Text {
                    id: current_txt
                    height: parent.height
                    width: 50
                    text: Number(currentProgress)  + " %"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            Text {
                x: 10
                height: 30
                text: "Details: "
                verticalAlignment: Text.AlignVCenter
            }

            Row {
                height: 30
                width: parent.width
                x: 10

                Text {
                    height: parent.height
                    width: 50
                    text: getSizeString(currentBytes)
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }

                Text {
                    height: parent.height
                    width: 50
                    text: getSizeString(totalBytes)
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            Row {
                height: 30
                width: parent.width
                x: 10

                Text {
                    height: parent.height
                    width: 50
                    text: getSizeString(transferSpeedBytes)
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }


            Button {
                id: cancel_btn
                x: 10
                height: 40
                text: "Cancel"
                onClicked: {
                    if(currentProgress < 100) {
                        s3Model.cancelDownloadUploadQML()
                    }

                    close()
                }
            }
        }
    }
}
