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


Item {
    id: root

    required property var appWindow
    readonly property bool isWindows: Qt.platform.os === "windows"


    width: parent.width
    height: menuBar.height

    Row {
        width: root.width
        spacing: 0

        MenuBar {
            id: menuBar

            background: Rectangle {
                color: "transparent"
            }

            MyAppMenu1 {}
            MyAppMenu2 {}
            MyAppOptionsMenu {}
            MyAppHelpMenu {}
        }

        Label {
            text: Qt.application.name
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            width: root.width - menuBar.width * 2
            height: menuBar.height
            elide: LayoutMirroring.enabled ? Text.ElideLeft : Text.ElideRight
        }

        Item {
            id: buttonWrapper

            width: menuBar.width
            height: menuBar.height

            ToolButton {
                objectName: 'minimizeButton'

                height: buttonWrapper.height
                focusPolicy: Qt.NoFocus

                icon {
                    source: "qrc:/data/icons/minimize_black_24dp.svg"
                    width: 18
                    height: 18
                }

                anchors {
                    right: maximizeButton.left
                }

                onClicked: {
                    root.appWindow.showMinimized()
                }
            }

            ToolButton {
                id: maximizeButton

                focusPolicy: Qt.NoFocus
                height: buttonWrapper.height

                icon {
                    property bool maximized: root.appWindow.visibility === Window.Maximized
                    property url iconMaximize: "qrc:/data/icons/open_in_full_black_24dp.svg"
                    property url iconNormalize: "qrc:/data/icons/close_fullscreen_black_24dp.svg"

                    source: maximized ? iconNormalize : iconMaximize
                    width: 18
                    height: 18
                }

                anchors {
                    right: closeButton.left
                }

                onClicked: {
                    if (root.appWindow.visibility === Window.Maximized) {
                        root.appWindow.showNormal()
                    } else {
                        root.appWindow.showMaximized()
                    }
                }
            }

            ToolButton {
                id: closeButton

                height: buttonWrapper.height
                focusPolicy: Qt.NoFocus

                icon {
                    source: "qrc:/data/icons/close_black_24dp.svg"
                    width: 18
                    height: 18
                }

                anchors {
                    right: buttonWrapper.right
                }

                onClicked: {
                    root.appWindow.close()
                }

                Binding {
                    when: root.isWindows && closeButton.hovered
                    target: closeButton.background
                    property: "color"
                    value: "#C42C1E"
                }
            }
        }
    }

}
