import QtQuick 2.11
import QtQuick.Window 2.3
import QtQuick.Controls 2.2

Window {
    id: about_win
    x: 100; y: 100; width: 300; height: 200
    minimumHeight: 200; maximumHeight: 200
    minimumWidth: 200

    title: "Manage bookmarks"

    Row {
       Text {
           text: "abc"
       }
       Button {
           text: "Remove"
       }
    }
}
