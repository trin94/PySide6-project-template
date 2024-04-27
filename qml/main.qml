/*
Copyright

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/


import QtQuick
import QtQuick.Controls
import app


ApplicationWindow {
    id: root

    property var appWindow: _shared
    property int windowBorder: 5

    width: 1280
    height: 720
    flags: Qt.FramelessWindowHint | Qt.Window
    visible: true

    LayoutMirroring.enabled: Qt.application.layoutDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    MyAppMainPage {
        anchors {
            fill: parent
            margins: _private.windowBorder
        }
    }

    Component.onCompleted: {
        // load language from settings
        // Qt.uiLanguage = ...
    }

    QtObject {
        id: _private  // Implementation details not to expose to child items

        readonly property int windowBorder: root.fullscreen || root.maximized ? 0 : 1
    }

    QtObject {
        id: _shared  // Properties and functions to expose to child items

        readonly property var visibility: root.visibility

        function startSystemMove() {
            root.startSystemMove()
        }

        function showMinimized() {
            root.showMinimized()
        }

        function showMaximized() {
            root.showMaximized()
        }

        function showNormal() {
            root.showNormal()
        }

        function close() {
            root.close()
        }
    }

}
