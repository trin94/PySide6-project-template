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


import QtQuick.Controls
import components.shared


MyAppAutoWidthMenu {
    title: qsTranslate("HeaderBar", "&Menu 2")

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
