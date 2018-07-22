import QtQuick 2.11
import QtQuick.Window 2.3
import QtQuick.Controls 2.2

Window {
    id: progress_win
    x: 100; y: 100; width: 300; height: 100
    minimumHeight: 100; maximumHeight: 200
    minimumWidth: 200

    title: "About qtS3Browser"

    Column {
        height: parent.height
        Text {
            height: 40
            text: "Copying file: "
        }
        Row {
            height: 40
            width: parent.width
            ProgressBar {
                height: parent.height
                width: 100
                value: 0.5
            }

            Text {
                height: parent.height
                text: "10 %"
                verticalAlignment: parent.verticalCenter
            }

            Button {
                x: 10
                height: parent.height
                text: "Cancel"
            }
        }
    }
}
