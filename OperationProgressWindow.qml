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
    property double totalProgress: 0

    Connections {
        target: s3Model
        onSetProgressSignal: {
            console.log("a is ", current, "b is ", total)
            currentProgress = (current / total) * 100
            totalProgress = (current / total) * 100
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
                text: "Copying file: "
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
                text: "Total progress: "
                verticalAlignment: Text.AlignVCenter
            }

            Row {
                height: 30
                width: parent.width
                x: 10
                ProgressBar {
                    id: total_pb
                    height: parent.height
                    width: parent.width - 70
                    value: totalProgress
                    to: 100.0
                }

                Text {
                    height: parent.height
                    width: 50
                    text: Number(totalProgress) + " %"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            Button {
                x: 10
                height: 40
                text: "Cancel"
            }
        }
    }
}
