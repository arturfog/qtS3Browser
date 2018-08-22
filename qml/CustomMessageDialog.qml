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
