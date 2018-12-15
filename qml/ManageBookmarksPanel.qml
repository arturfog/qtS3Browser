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

Item {
    id: man_boomarks_win
    width: parent.width
    height: parent.height

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

Rectangle {
 x: 5
 width: parent.width - 10;
 height: 60

 Row {
  width: parent.width;
  height: 40
  anchors.verticalCenter: parent.verticalCenter
  id: bookmarks_item
  x: 10

  Image {
    source: "qrc:icons/32_amazon_icon.png"
  }

  Rectangle {
    width: 10
    height: 10
  }

  Column {
    width: parent.width - 390;
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
        id:add' + i + '
        text: "Open"
        icon.source: "qrc:icons/32_go_icon.png"
        icon.color: "transparent"
        onClicked: {
            s3Model.gotoQML("' + values[i] +'")
            s3_panel.path = s3Model.getS3PathQML()
            s3_panel.connected = s3Model.isConnectedQML()
            file_panel.connected = s3Model.isConnectedQML()
        }
                    background: Rectangle {
                            implicitWidth: 100
                            implicitHeight: 40
                            opacity: enabled ? 1 : 0.3
                            color: add' + i + '.down ? "#dddedf" : "#eeeeee"

                            Rectangle {
                                width: parent.width
                                height: 1
                                color: add' + i + '.down ? "#17a81a" : "#21be2b"
                                anchors.bottom: parent.bottom
                            }
                        }
      }

      Rectangle {
        width: 5
        height: 10
      }

      Button {
        id:e' + i + '
        text: "Edit";
        icon.source: "qrc:icons/32_edit_icon.png"
        icon.color: "transparent"
        onClicked: {
                  createBookmarkWindow.x = app_window.x + (app_window.width / 2) - (createBookmarkWindow.width / 2)
                  createBookmarkWindow.y = app_window.y + (app_window.height / 2) - (createBookmarkWindow.height / 2)
                  createBookmarkWindow.visible = true;
        }
                    background: Rectangle {
                            implicitWidth: 100
                            implicitHeight: 40
                            opacity: enabled ? 1 : 0.3
                            color: e' + i + '.down ? "#dddedf" : "#eeeeee"

                            Rectangle {
                                width: parent.width
                                height: 1
                                color: e' + i + '.down ? "#17a81a" : "#21be2b"
                                anchors.bottom: parent.bottom
                            }
                        }
      }

      Rectangle {
        width: 5
        height: 10
      }

      Button {
        id:d' + i + '
        text: "Remove";
        icon.source: "qrc:icons/32_delete_icon.png"
        icon.color: "transparent"
        onClicked: {
          s3Model.removeBookmarkQML("' + keys[i] + '")
        }
                    background: Rectangle {
                            implicitWidth: 100
                            implicitHeight: 40
                            opacity: enabled ? 1 : 0.3
                            color: d' + i + '.down ? "#dddedf" : "#eeeeee"

                            Rectangle {
                                width: parent.width
                                height: 1
                                color: d' + i + '.down ? "#17a81a" : "#21be2b"
                                anchors.bottom: parent.bottom
                            }
                        }
      }
    }
  }

Rectangle {
    width: parent.width
    color: "#dbdbdb"
    height: 1
}

}
',
                bookmarks_list, "dynamicBookmarks");
            }
        }
    }

    ScrollView {
        width: parent.width
        height: parent.height
        clip: true

        Rectangle {
            color: "#3367d6"
            width: parent.width
            height: 50

            Row {
                x:10
                height: parent.height
                width: parent.width

                Image {
                    source: "qrc:icons/32_bookmark2.png"
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
                    id: add
                    text: qsTr("Add bookmark");
                    icon.source: "qrc:icons/32_add_bookmark.png"
                    icon.color: "transparent"
                    anchors.verticalCenter: parent.verticalCenter
                    onClicked: {
                      createBookmarkWindow.x = app_window.x + (app_window.width / 2) - (createBookmarkWindow.width / 2)
                      createBookmarkWindow.y = app_window.y + (app_window.height / 2) - (createBookmarkWindow.height / 2)
                      createBookmarkWindow.visible = true;
                    }

                    background: Rectangle {
                            implicitWidth: 100
                            implicitHeight: 40
                            opacity: enabled ? 1 : 0.3
                            color: add.down ? "#dddedf" : "#eeeeee"

                            Rectangle {
                                width: parent.width
                                height: 1
                                color: add.down ? "#17a81a" : "#21be2b"
                                anchors.bottom: parent.bottom
                            }
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
            border.color: "lightgray"
            border.width: 2
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
