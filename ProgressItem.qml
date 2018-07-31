import QtQuick 2.11
import QtQuick.Window 2.3
import QtQuick.Controls 2.2

Item {
    id: progress_item

    property double currentProgress: 0
    property double totalProgress: 0

    function setProgressQML(current, total){
        currentProgress = (current / total) * 100
        totalProgress = (current / total) * 100
        console.log("a is ", currentProgress, "b is ", totalProgress)
    }

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
