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


MouseArea {
    hoverEnabled: true
    acceptedButtons: Qt.NoButton

    property int borderWidth

    cursorShape: {
        const p = Qt.point(mouseX, mouseY)
        const b = borderWidth + 15
        if (p.x < b && p.y < b) 
            return Qt.SizeFDiagCursor
        if (p.x >= width - b && p.y >= height - b) 
            return Qt.SizeFDiagCursor
        if (p.x >= width - b && p.y < b) 
            return Qt.SizeBDiagCursor
        if (p.x < b && p.y >= height - b) 
            return Qt.SizeBDiagCursor
        if (p.x < b || p.x >= width - b) 
            return Qt.SizeHorCursor
        if (p.y < b || p.y >= height - b) 
            return Qt.SizeVerCursor
    }

}
