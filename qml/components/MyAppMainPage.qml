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
import QtQuick.Layouts
import components.header


Page {
    anchors.fill: parent
    header: MyAppHeader {}

    ColumnLayout {
        id: aboutTab
        spacing: 8
        width: parent.width

        Rectangle { color: "transparent"; height: 30; width: 10 }

        Image {
            source: "qrc:/data/app-icon.svg"
            asynchronous: true
            Layout.alignment: Qt.AlignHCenter
        }

        Rectangle { color: "transparent"; height: 45; width: 10 }

        Label {
            text: Qt.application.name + ' (' +  Qt.application.version + ')'
            font.bold: true
            font.pixelSize: Qt.application.font.pixelSize * 1.5
            Layout.alignment: Qt.AlignHCenter
        }

        Label {
            text: 'Running on ' +  Qt.platform.os
            font.bold: true
            font.pixelSize: Qt.application.font.pixelSize * 1.5
            Layout.alignment: Qt.AlignHCenter
        }

        Rectangle { color: "transparent"; height: 45; width: 10 }

        Label {
            text: qsTranslate("MainPage", "Have fun!")
            color: Material.accent
            font.bold: true
            font.pixelSize: Qt.application.font.pixelSize * 2
            Layout.alignment: Qt.AlignHCenter
        }
    }

}


