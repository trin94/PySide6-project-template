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
import QtQuick.Controls
import QtQuick.Dialogs
import shared
import models


MyAppAutoWidthMenu {
    title: qsTranslate("HeaderBar", "&Options")

    MyAppAutoWidthMenu {
        title: qsTranslate("HeaderBar", "&Language")

        Repeater {
            model: MyAppLanguageModel {}

            MenuItem {
                text: qsTranslate("Languages", model.language)
                onTriggered: timer.start()

                Timer {
                    // Delay it so possible animations have time
                    id: timer
                    interval: 125
                    onTriggered: Qt.uiLanguage = model.abbrev
                }
            }
        }
    }

    MenuSeparator { }

    Action {
        id: action

        text: qsTranslate("HeaderBar", "Showcase translated Qt strings")

        property var loader: Loader { }

        property var component: Component {
            MessageDialog {
                title: qsTranslate("MessageBoxes", "Title")
                text: qsTranslate("MessageBoxes", "Change the language and look at the 'Yes' and 'Cancel' buttons")
                buttons: MessageDialog.Yes | MessageDialog.Cancel
                visible: true

                onAccepted: { action.loader.sourceComponent = null }
                onRejected: { action.loader.sourceComponent = null }
            }
        }

        onTriggered: {
            loader.sourceComponent = component
        }
    }

}
