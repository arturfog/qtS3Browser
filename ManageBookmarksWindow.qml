import QtQuick 2.11
import QtQuick.Window 2.3

Window {
    id: about_win
    x: 100; y: 100; width: 300; height: 200
    minimumHeight: 200; maximumHeight: 200
    minimumWidth: 200

    title: "Manage bookmarks"

    function addBookmarks() {
        var bookmarksLen = s3Model.getBookmarksNumQML();
        if(bookmarksLen > 0) {
            var keys = s3Model.getBookmarksQML()
            for(var i = 0; i < bookmarksLen; i++){
                var newObject = Qt.createQmlObject('
import QtQuick 2.11;
import QtQuick.Controls 2.2;
Row {
id: bookmarks_item
Text { width: 200; text: "' + keys[i] +'" }
Button {text: "Remove"; onClicked: { s3Model.removeBookmarkQML("' + keys[i] + '") } }
}',
                bookmarks_list, "dynamicBookmarks");
            }
        }
    }

    Column {
        id: bookmarks_list
        Component.onCompleted: addBookmarks()
    }
}
