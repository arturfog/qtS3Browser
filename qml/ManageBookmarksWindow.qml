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
import QtQuick.Controls 2.4

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
      source: "qrc:icons/32_bookmark.png"
 }

 Rectangle {
   width: 10
   height: 10
 }

 Column {
   width: 200;

   Text {
     font.pointSize: 14
     text: "' + keys[i] +'"
   }

   Text {
     font.pointSize: 8
     text: \'<a href="' + values[i] +'">' + values[i] + '</a>\'
   }
 }

 Button {
  text: "Remove";
  icon.source: "qrc:icons/32_delete_icon.png"
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
source: "qrc:icons/128_add_bookmark.png"
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

    ScrollView {
        width: parent.width
        height: parent.height

        clip: true
        Column {
            id: bookmarks_list
            Component.onCompleted: addBookmarks()
        }
    }
}
