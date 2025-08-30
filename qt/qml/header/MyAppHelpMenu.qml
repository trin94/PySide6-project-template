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

import "../shared"


MyAppAutoWidthMenu {
    title: qsTranslate("HeaderBar", "&Help")

    Action {
        text: qsTranslate("HeaderBar", "&Action 1")
        shortcut: "CTRL+N"

        onTriggered: {
            console.log("Action 1 pressed")
        }
    }

    Action {
        text: qsTranslate("HeaderBar", "&Action 2")

        onTriggered: {
            console.log("Action 2 pressed")
        }
    }

    MenuSeparator { }

    Action {
        text: qsTranslate("HeaderBar", "&Action 3")

        onTriggered: {
            console.log("Action 3 pressed")
        }
    }

}
