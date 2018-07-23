import QtQuick 2.11
import QtQuick.Window 2.3
import QtQuick.Controls 2.2

Window {
    id: progress_win
    x: 100; y: 100; width: 500; height: 200
    minimumHeight: 200; maximumHeight: 200
    minimumWidth: 300; maximumWidth: 500

    title: "Progress"

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
                height: parent.height
                width: parent.width - 70
                value: 0.5
            }

            Text {
                height: parent.height
                width: 50
                text: "10 %"
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
                height: parent.height
                width: parent.width - 70
                value: 0.5
            }

            Text {
                height: parent.height
                width: 50
                text: "10 %"
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
