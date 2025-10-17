// SPDX-FileCopyrightText: <Your Name>
//
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick


Item {
    id: root

    required property var appWindow

    width: parent.width
    height: headerBar.height

    TapHandler {
        gesturePolicy: TapHandler.DragThreshold

        onTapped: {
            if (tapCount === 2) {
                if (root.appWindow.visibility === Window.Maximized) {
                    root.appWindow.showNormal()
                } else {
                    root.appWindow.showMaximized()
                }
            }
        }
    }

    DragHandler {
        target: null
        grabPermissions: TapHandler.CanTakeOverFromAnything

        onActiveChanged: {
            if (active) {
                root.appWindow.startSystemMove()
            }
        }
    }

    MyAppHeaderContent {
        id: headerBar

        appWindow: root.appWindow
    }

}
