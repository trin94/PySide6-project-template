// SPDX-FileCopyrightText: <Your Name>
//
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

import "../shared"
import "../models"


MyAppAutoWidthMenu {
    id: root

    title: qsTranslate("HeaderBar", "&Options")

    MyAppAutoWidthMenu {
        title: qsTranslate("HeaderBar", "&Language")

        Repeater {
            model: MyAppLanguageModel {}

            MenuItem {
                id: _itemDelegate

                required property string language  // from model
                required property string abbrev  // from model

                text: qsTranslate("Languages", _itemDelegate.language)

                onTriggered: {
                    animationDelayTimer.start()
                }

                Timer {
                    id: animationDelayTimer

                    interval: 125

                    onTriggered: {
                        Qt.uiLanguage = _itemDelegate.abbrev
                    }
                }
            }
        }
    }

    MenuSeparator {
    }

    Action {
        text: qsTranslate("HeaderBar", "Showcase translated Qt internal strings")

        property var factory: Component
        {
            MessageDialog {
                title: qsTranslate("MessageBoxes", "Title")
                text: qsTranslate("MessageBoxes", "Change the language and look at the 'Yes' and 'Cancel' buttons")
                buttons: MessageDialog.Yes | MessageDialog.Cancel
                visible: true
            }
        }

        onTriggered: {
            const dialog = factory.createObject(root)
            dialog.accepted.connect(dialog.destroy)
            dialog.rejected.connect(dialog.destroy)
            dialog.open()
        }
    }

}
