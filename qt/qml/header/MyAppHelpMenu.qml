// SPDX-FileCopyrightText: <Your Name>
//
// SPDX-License-Identifier: GPL-3.0-or-later

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
