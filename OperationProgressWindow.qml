import QtQuick 2.11
import QtQuick.Window 2.3
import QtQuick.Controls 2.2

Window {
    id: progress_win
    x: 100; y: 100; width: 500; height: 200
    minimumHeight: 200; maximumHeight: 200
    minimumWidth: 300; maximumWidth: 500

    title: "Progress"

    ProgressItem {
    }
}
