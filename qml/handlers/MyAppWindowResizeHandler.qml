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


DragHandler {
    target: null
    grabPermissions: TapHandler.TakeOverForbidden

    property int borderWidth

    onActiveChanged: {
        if (active) {
            const p = centroid.position
            const b = borderWidth + 15
            let e = 0
            if (p.x < b)
                e |= Qt.LeftEdge
            if (p.x >= width - b)
                e |= Qt.RightEdge
            if (p.y < b)
                e |= Qt.TopEdge
            if (p.y >= height - b)
                e |= Qt.BottomEdge
            appWindow.startSystemResize(e)
        }
    }

}
