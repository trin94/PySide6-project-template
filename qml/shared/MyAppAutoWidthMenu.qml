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


Menu {

    /*
    Taken and adapted from:
    https://martin.rpdev.net/2018/03/13/qt-quick-controls-2-automatically-set-the-width-of-menus.html
    */

    width: {
        let result = 0
        let padding = 0
        for (let i = 0; i < count; ++i) {
            let item = itemAt(i)

            if (!isMenuSeparator(item)) {
                result = Math.max(item.contentItem.implicitWidth, result)
                padding = Math.max(item.padding, padding)
            }
        }
        return result + padding * 2
    }

    function isMenuSeparator(item) {
        return item instanceof MenuSeparator
    }

}
