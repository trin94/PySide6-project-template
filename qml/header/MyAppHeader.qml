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
