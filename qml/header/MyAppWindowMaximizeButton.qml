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


import QtQuick.Controls


ToolButton {
    property bool maximized
    property url iconMaximize: "qrc:/data/icons/open_in_full_black_24dp.svg"
    property url iconNormalize: "qrc:/data/icons/close_fullscreen_black_24dp.svg"

    icon.source: maximized ? iconNormalize : iconMaximize
    icon.width: 18
    icon.height: 18
    focusPolicy: Qt.NoFocus

}
