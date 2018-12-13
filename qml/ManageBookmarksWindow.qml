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
    id: man_boomarks_win
    width: 640;
    height: 320
    minimumHeight: 320; maximumHeight: 800
    minimumWidth: 640
    color: "#f8f9fa"
    title: "Manage bookmarks"

    onVisibleChanged: {
        addBookmarks()
    }

    function addBookmarks() {
        var bookmarksLen = s3Model.getBookmarksNumQML();

        for(var i = bookmarks_list.children.length; i > 0 ; i--) {
          bookmarks_list.children[i-1].destroy()
        }

        var emptyObject = null;

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
    width: parent.width - 280;
    Text {
      font.pointSize: 14
      text: "' + keys[i] +'"
     }

     Text {
       font.pointSize: 8
       text: \'<a href="' + values[i] +'">' + values[i] + '</a>\'
     }
  }

  Row {
      Button {
        text: "Open"
        icon.source: "qrc:icons/32_go_icon.png"
        icon.color: "transparent"
        onClicked: {
            s3Model.gotoQML("' + values[i] +'")
            s3_panel.path = s3Model.getS3PathQML()
            s3_panel.connected = s3Model.isConnectedQML()
            file_panel.connected = s3Model.isConnectedQML()
            close()
        }
      }

      Rectangle {
        width: 5
        height: 10
      }

      Button {
        text: "Remove";
        icon.source: "qrc:icons/32_delete_icon.png"
        icon.color: "transparent"
        onClicked: {
          s3Model.removeBookmarkQML("' + keys[i] + '")
          if(s3Model.getBookmarksNumQML() == 0) {
            close()
        }
      }
    }
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
            man_boomarks_win.maximumHeight = man_boomarks_win.height
            man_boomarks_win.maximumWidth = man_boomarks_win.width

            emptyObject = Qt.createQmlObject('
import QtQuick 2.5;
import QtQuick.Controls 2.2;

Column {
width: man_boomarks_win.width

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
font.pointSize: getMediumFontSize()
}

Button {
text: qsTr("Add bookmark");
icon.source: "qrc:icons/32_add_bookmark.png"
icon.color: "transparent"
anchors.horizontalCenter: parent.horizontalCenter
onClicked: {
  createBookmarkWindow.x = app_window.x + (app_window.width / 2) - (createBookmarkWindow.width / 2)
  createBookmarkWindow.y = app_window.y + (app_window.height / 2) - (createBookmarkWindow.height / 2)
  createBookmarkWindow.visible = true; close()
}
}
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
                    font.pointSize: getLargeFontSize()
                    height: parent.height
                    width: parent.width - 280;
                    verticalAlignment: Text.AlignVCenter
                }

                Rectangle {
                    width: 5
                    height: parent.height
                    color: "transparent"
                }

                Button {
                    text: qsTr("Add bookmark");
                    icon.source: "qrc:icons/32_add_bookmark.png"
                    icon.color: "transparent"
                    anchors.verticalCenter: parent.verticalCenter
                    onClicked: {
                      createBookmarkWindow.x = app_window.x + (app_window.width / 2) - (createBookmarkWindow.width / 2)
                      createBookmarkWindow.y = app_window.y + (app_window.height / 2) - (createBookmarkWindow.height / 2)
                      createBookmarkWindow.visible = true; close()
                    }
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

            onVisibleChanged: {
                bookmarks_list.update()
            }

            Column {
                y: 10
                id: bookmarks_list
                width: parent.width
            }
        }
    }
}
