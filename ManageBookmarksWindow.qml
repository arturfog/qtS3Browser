import QtQuick 2.11
import QtQuick.Window 2.3

Window {
    id: about_win
    x: 100; y: 100; width: 340; height: 250
    minimumHeight: 250; maximumHeight: 200
    minimumWidth: 320

    title: "Manage bookmarks"

    function addBookmarks() {
        var bookmarksLen = s3Model.getBookmarksNumQML();
        if(bookmarksLen > 0) {
            var keys = s3Model.getBookmarksKeysQML()
            for(var i = 0; i < bookmarksLen; i++){
                var newObject = Qt.createQmlObject('
import QtQuick 2.11;
import QtQuick.Controls 2.2;

Row {
id: bookmarks_item

Text {
width: 200;
text: "' + keys[i] +'"
}

Button {
text: "Remove";
onClicked: { s3Model.removeBookmarkQML("' + keys[i] + '") } }
}',
                bookmarks_list, "dynamicBookmarks");
            }
        } else {
            var emptyObject = Qt.createQmlObject('
import QtQuick 2.11;
import QtQuick.Controls 2.2;

Column {
width: about_win.width

Image {
source: "icons/128_add_bookmark.png"
anchors.horizontalCenter: parent.horizontalCenter
}

Text {
x:10
width: 300;
height: 60;
wrapMode: Text.Wrap
text: "There are no bookmarks, click below to create one"
font.pointSize: 12
}

Button {
text: "Add bookmark";
anchors.horizontalCenter: parent.horizontalCenter
onClicked: { createBookmarkWindow.visible = true; close() } }
}',
            bookmarks_list, "dynamicBookmarks");
        }
    }

    Column {
        id: bookmarks_list
        Component.onCompleted: addBookmarks()
    }
}
