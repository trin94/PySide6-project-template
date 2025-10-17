// SPDX-FileCopyrightText: <Your Name>
//
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Controls

import "app"


ApplicationWindow {
    id: root

    readonly property var windowsFlags: Qt.CustomizeWindowHint | Qt.Window
    readonly property var linuxFlags: Qt.FramelessWindowHint | Qt.Window

    flags: Qt.platform.os === "windows" ? windowsFlags : linuxFlags

    width: 1280
    height: 720
    visible: true

    LayoutMirroring.enabled: Qt.application.layoutDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    MyAppMainPage {
        appWindow: _shared

        anchors {
            fill: root.contentItem
            margins: _private.windowBorder
        }
    }

    Component.onCompleted: {
        // load language from settings
        // Qt.uiLanguage = ...
    }

    QtObject {
        id: _private  // Implementation details not exposed to child items

        readonly property bool maximized: root.visibility === Window.Maximized
        readonly property bool fullscreen: root.visibility === Window.FullScreen
        readonly property int windowBorder: fullscreen || maximized ? 0 : 1
    }

    QtObject {
        id: _shared  // Properties and functions exposed to child items

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
