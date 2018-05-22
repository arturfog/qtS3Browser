import QtQuick 2.9
import QtQuick.Window 2.2
import QtQml.Models 2.2
import QtQuick.Controls 1.5

TreeView {
        model: fileSystemModel
        rootIndex: rootPathIndex
        selection: sel

        TableViewColumn {
            title: "Name"
            role: "fileName"
            resizable: true
        }

        TableViewColumn {
            title: "Size"
            role: "size"
            resizable: true
            horizontalAlignment : Text.AlignRight
            width: 70
        }

        TableViewColumn {
            title: "Permissions"
            role: "displayableFilePermissions"
            resizable: true
            width: 100
        }

        TableViewColumn {
            title: "Date Modified"
            role: "lastModified"
            resizable: true
        }

        onActivated : {
            var url = fileSystemModel.data(index, FileSystemModel.UrlStringRole)
            Qt.openUrlExternally(url)
        }
    }
