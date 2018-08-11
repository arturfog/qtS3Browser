import QtQuick 2.11
import QtQuick.Window 2.3

Window {
    id: about_win
    x: 100; y: 100; width: 360; height: 250
    minimumHeight: 250; maximumHeight: 200
    minimumWidth: 360

    title: "Manage bookmarks"

    function addBookmarks() {
        var bookmarksLen = s3Model.getBookmarksNumQML();
        if(bookmarksLen > 0) {
            var keys = s3Model.getBookmarksKeysQML()
            var values = s3Model.getBookmarksLinksQML()
            for(var i = 0; i < bookmarksLen; i++){
                var newObject = Qt.createQmlObject('
import QtQuick 2.11;
import QtQuick.Controls 2.2;

Column {
Rectangle {
  width: parent.width;
  height: 3;
}
Row {
 id: bookmarks_item
 x: 10
 Image {
     source: "icons/32_bookmark.png"
 }

 Rectangle {
   width: 10
   height: 10
 }

 Column {
   width: 200;

   Text {
     font.pointSize: 12
     text: "' + keys[i] +'"
   }

   Text {
     font.pointSize: 8
     text: \'<a href="' + values[i] +'">' + values[i] + '</a>\'
   }
 }

 Button {
  text: "Remove";
  onClicked: { s3Model.removeBookmarkQML("' + keys[i] + '") }
 }
}

Rectangle {
  width: about_win.width;
  height: 3;
}

Rectangle {
  width: about_win.width;
  height: 1;
  color: "black"
}

Rectangle {
  width: about_win.width;
  height: 1;
}

}
',
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
