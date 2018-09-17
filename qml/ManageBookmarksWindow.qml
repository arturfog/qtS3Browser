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
import QtQuick 2.5
import QtQuick.Window 2.0
import QtQuick.Controls 2.3
import QtGraphicalEffects 1.0
Window {
    id: about_win
    x: 100; y: 100; width: 440; height: 290
    minimumHeight: 290; maximumHeight: 800
    minimumWidth: 440
    color: "#f8f9fa"
    title: "Manage bookmarks"

    function addBookmarks() {
        var bookmarksLen = s3Model.getBookmarksNumQML();
        if(bookmarksLen > 0) {
            var keys = s3Model.getBookmarksKeysQML()
            var values = s3Model.getBookmarksLinksQML()
            for(var i = 0; i < bookmarksLen; i++){
                var newObject = Qt.createQmlObject('
import QtQuick 2.5;
import QtQuick.Controls 2.2;

Column {
 width: parent.width;
 Row {
  width: parent.width;
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
    width: parent.width - 160;
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
    icon.color: "transparent"
    onClicked: { s3Model.removeBookmarkQML("' + keys[i] + '") }
  }
}

Rectangle {
    width: parent.width
    height: 5
}

Rectangle {
    width: parent.width
    color: "#dbdbdb"
    height: 1
}

Rectangle {
    width: parent.width
    height: 5
}

}
',
                bookmarks_list, "dynamicBookmarks");
            }
        } else {
            var emptyObject = Qt.createQmlObject('
import QtQuick 2.5;
import QtQuick.Controls 2.2;

Column {
width: about_win.width

Image {
source: "qrc:icons/128_add_bookmark.png"
anchors.horizontalCenter: parent.horizontalCenter
}

Text {
x:10
width: parent.width;
height: 40;
wrapMode: Text.Wrap
text: qsTr("There are no bookmarks, click below to create one")
font.pointSize: 12
}

Button {
text: qsTr("Add bookmark");
icon.source: "qrc:icons/32_add_bookmark.png"
icon.color: "transparent"
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

        DropShadow {
            anchors.fill: manage_bookmark_rect
            horizontalOffset: 1
            verticalOffset: 2
            radius: 8.0
            samples: 17
            color: "#aa000000"
            source: manage_bookmark_rect
        }

        Rectangle {
            color: "#3367d6"
            width: parent.width
            height: 50

            Row {
                x:10
                height: parent.height
                width: parent.width

                Image {
                    source: "qrc:icons/32_edit_icon.png"
                    anchors.verticalCenter: parent.verticalCenter
                }

                Rectangle {
                    width: 5
                    height: parent.height
                    color: "transparent"
                }

                Text {
                    color: "white"
                    text: qsTr("Manage bookmarks")
                    font.bold: true
                    font.pointSize: 14
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        Rectangle {
            id: manage_bookmark_rect
            y: 60
            anchors.horizontalCenter: parent.horizontalCenter
            color: "white"
            width: parent.width - 50
            height: parent.height - 80
            border.color: "#efefef"
            border.width: 1
            radius: 5

            Column {
                y: 10
                id: bookmarks_list
                width: parent.width
                Component.onCompleted: addBookmarks()
            }
        }
    }
}
