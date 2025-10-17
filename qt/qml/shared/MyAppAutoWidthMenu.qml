// SPDX-FileCopyrightText: <Your Name>
//
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Controls


Menu {
    id: root

    /*
    Taken and adapted from:
    https://martin.rpdev.net/2018/03/13/qt-quick-controls-2-automatically-set-the-width-of-menus.html
    */

    readonly property bool mMirrored: count > 0 && itemAt(0).mirrored

    x: mMirrored ? -width + parent.width : 0

    width: {
        let result = 0
        let padding = 0
        for (let i = 0; i < root.count; ++i) {
            let item = root.itemAt(i)

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
