/*
Copyright 2023

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/


import QtQuick
import QtQuick.Controls
import components
import handlers


ApplicationWindow {
    id: window
    visible: true
    width: 1280
    height: 720
    flags: Qt.FramelessWindowHint | Qt.Window

    LayoutMirroring.enabled: Qt.application.layoutDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    property ApplicationWindow appWindow: window
    property int windowBorder: 5

    MyAppWindowBorderMouseCurser {
        borderWidth: windowBorder
        anchors.fill: parent
    }

    MyAppWindowResizeHandler {
        borderWidth: windowBorder
    }

    MyAppMainPage {
        anchors.fill: parent
        anchors.margins: appWindow.visibility === Window.Windowed ? windowBorder : 0
    }

    Component.onCompleted: {
        // load language from settings
        // Qt.uiLanguage = ...
    }

}
