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
import components
import handlers
import pyobjects


ApplicationWindow {
    id: window
    visible: true
    width: 1280
    height: 720
    flags: Qt.FramelessWindowHint | Qt.Window

    LayoutMirroring.enabled: Qt.application.layoutDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    property ApplicationWindow appWindow: window
    property int windowBorder: 5

    MyAppWindowBorderMouseCurser {
        borderWidth: windowBorder
        anchors.fill: parent
    }

    MyAppWindowResizeHandler {
        borderWidth: windowBorder
    }

    MyAppMainPage {
        anchors.fill: parent
        anchors.margins: appWindow.visibility === Window.Windowed ? windowBorder : 0
    }

    Component.onCompleted: {
        // load language from settings
        // TranslationPyObject.load_translation('de')
    }

}
