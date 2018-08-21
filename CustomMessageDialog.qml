import QtQuick 2.11
import QtQuick.Dialogs 1.2

MessageDialog {
    property string win_title: ""
    property string msg: ""
    property int buttons: StandardButton.Yes | StandardButton.No
    property var yesAction: function(){ }
    property var noAction: function(){ }
    property var ico: StandardIcon.Question

    id: msg_dialog
    title: win_title
    icon: ico
    text: msg
    standardButtons: buttons
    onYes: yesAction()
    onNo: noAction()
}
