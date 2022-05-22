/*
MIT

Copyright (c) 2022

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/


import QtQuick
import QtQuick.Controls


Item {
    id: headerBarContent
    width: parent.width
    height: menuBar.height

    Row {
        width: parent.width
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
            width: headerBarContent.width - menuBar.width * 2
            height: menuBar.height
            elide: LayoutMirroring.enabled ? Text.ElideLeft: Text.ElideRight
        }

        Item {
            id: buttonWrapper
            width: menuBar.width
            height: menuBar.height

            MyAppWindowMinimizeButton {
                height: buttonWrapper.height
                anchors.right: maximizeButton.left

                onClicked: {
                    appWindow.showMinimized()
                }
            }

            MyAppWindowMaximizeButton {
                id: maximizeButton
                height: buttonWrapper.height
                anchors.right: closeButton.left
                maximized: appWindow.visibility === Window.Maximized

                onClicked: {
                    if (appWindow.visibility === Window.Maximized) {
                        appWindow.showNormal()
                    } else {
                        appWindow.showMaximized()
                    }
                }
            }

            MyAppWindowCloseButton {
                id: closeButton
                height: buttonWrapper.height
                anchors.right: buttonWrapper.right

                onClicked: {
                    appWindow.close()
                }
            }
        }
    }

}
