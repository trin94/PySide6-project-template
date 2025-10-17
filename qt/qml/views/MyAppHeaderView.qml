// SPDX-FileCopyrightText: <Your Name>
//
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Controls

import pyobjects

import "../shared"
import "../models"

Item {
    id: root

    required property MyAppHeaderViewModel viewModel

    readonly property alias menuBarWidth: menuBar.width
    readonly property alias menuBarHeight: menuBar.height

    height: menuBarHeight

    DragHandler {
        target: null
        grabPermissions: TapHandler.CanTakeOverFromAnything

        onActiveChanged: {
            if (active) {
                root.viewModel.requestWindowDrag();
            }
        }
    }

    TapHandler {
        onDoubleTapped: root.viewModel.requestToggleMaximize()
    }

    Row {
        width: root.width
        spacing: 0

        MenuBar {
            id: menuBar

            background: null

            MyAppAutoWidthMenu {
                title: qsTranslate("HeaderBar", "&Menu 1")

                Action {
                    text: qsTranslate("HeaderBar", "&Action 1")
                    shortcut: "CTRL+N"
                    onTriggered: console.log("Action 1 pressed")
                }

                Action {
                    text: qsTranslate("HeaderBar", "&Action 2")
                    onTriggered: console.log("Action 2 pressed")
                }

                Action {
                    text: qsTranslate("HeaderBar", "&Action 3")
                    onTriggered: console.log("Action 3 pressed")
                }

                Action {
                    text: qsTranslate("HeaderBar", "&Action 4")
                    onTriggered: console.log("Action 4 pressed")
                }

                MenuSeparator {}

                Action {
                    text: qsTranslate("HeaderBar", "&Action 5")
                    onTriggered: console.log("Action 5 pressed")
                }
            }

            MyAppAutoWidthMenu {
                title: qsTranslate("HeaderBar", "&Menu 2")

                Action {
                    text: qsTranslate("HeaderBar", "&Action 1")
                    shortcut: "CTRL+N"
                    onTriggered: console.log("Action 1 pressed")
                }

                Action {
                    text: qsTranslate("HeaderBar", "&Action 2")
                    onTriggered: console.log("Action 2 pressed")
                }

                MenuSeparator {}

                Action {
                    text: qsTranslate("HeaderBar", "&Action 3")
                    onTriggered: console.log("Action 3 pressed")
                }
            }

            MyAppAutoWidthMenu {
                title: qsTranslate("HeaderBar", "&Options")

                MyAppAutoWidthMenu {
                    title: qsTranslate("HeaderBar", "&Language")

                    Repeater {
                        model: MyAppLanguageModel {}

                        MenuItem {
                            required property string language  // from model
                            required property string abbrev  // from model

                            text: qsTranslate("Languages", language)
                            onTriggered: root.viewModel.setLanguage(abbrev)
                        }
                    }
                }

                MenuSeparator {}

                Action {
                    text: qsTranslate("HeaderBar", "Showcase translated Qt internal strings")
                    onTriggered: root.viewModel.showMessageDialog()
                }
            }

            MyAppAutoWidthMenu {
                title: qsTranslate("HeaderBar", "&Help")

                Action {
                    text: qsTranslate("HeaderBar", "&Action 1")
                    shortcut: "CTRL+N"
                    onTriggered: console.log("Action 1 pressed")
                }

                Action {
                    text: qsTranslate("HeaderBar", "&Action 2")
                    onTriggered: console.log("Action 2 pressed")
                }

                MenuSeparator {}

                Action {
                    text: qsTranslate("HeaderBar", "&Action 3")
                    onTriggered: console.log("Action 3 pressed")
                }
            }
        }

        Label {
            width: root.width - root.menuBarWidth * 2
            height: root.menuBarHeight
            text: Application.name
            elide: LayoutMirroring.enabled ? Text.ElideRight : Text.ElideLeft
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            leftPadding: 25
            rightPadding: 25
        }

        Item {
            width: root.menuBarWidth
            height: root.menuBarHeight

            ToolButton {
                id: _minimizeButton

                height: root.height
                width: visible ? implicitWidth : 0
                focusPolicy: Qt.NoFocus
                anchors.right: _maximizeButton.left
                icon.width: 20
                icon.height: 20
                icon.source: "qrc:/data/icons/minimize_24dp_1F1F1F_FILL0_wght400_GRAD0_opsz24.svg"

                onClicked: root.viewModel.requestMinimize()
            }

            ToolButton {
                id: _maximizeButton

                readonly property url iconMaximize: "qrc:/data/icons/open_in_full_24dp_1F1F1F_FILL0_wght400_GRAD0_opsz24.svg"
                readonly property url iconNormalize: "qrc:/data/icons/close_fullscreen_24dp_1F1F1F_FILL0_wght400_GRAD0_opsz24.svg"

                height: root.height
                width: visible ? implicitWidth : 0
                focusPolicy: Qt.NoFocus
                anchors.right: _closeButton.left
                icon.width: 18
                icon.height: 18
                icon.source: root.viewModel.isMaximized ? iconNormalize : iconMaximize

                onClicked: root.viewModel.requestToggleMaximize()
            }

            ToolButton {
                id: _closeButton

                height: root.height
                width: visible ? implicitWidth : 0
                focusPolicy: Qt.NoFocus
                anchors.right: parent.right

                icon {
                    width: 18
                    height: 18
                    source: "qrc:/data/icons/close_24dp_1F1F1F_FILL0_wght400_GRAD0_opsz24.svg"
                }

                onClicked: root.viewModel.requestClose()

                Binding {
                    when: root.viewModel.isWindows
                    target: _closeButton
                    property: "icon.color"
                    value: "#FFFFFD"
                    restoreMode: Binding.RestoreNone
                }

                Binding {
                    when: root.viewModel.isWindows
                    target: _closeButton.background
                    property: "color"
                    value: "#C42C1E"
                    restoreMode: Binding.RestoreNone
                }
            }
        }
    }
}
