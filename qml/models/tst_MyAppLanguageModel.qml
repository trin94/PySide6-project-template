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


import QtQuick 2.0
import QtTest

Item {
    property var model: MyAppLanguageModel {}

    TestCase {
        name: "MyAppLanguageModelTest"

        function test_language_de_exists(data) {
            const languages = extractLanguages()
            verify(languages.includes('de'))
        }

        function test_language_en_exists(data) {
            const languages = extractLanguages()
            verify(languages.includes('en'))
        }

        function test_language_he_exists(data) {
            const languages = extractLanguages()
            verify(languages.includes('he'))
        }

        function extractLanguages() {
            const languages = []
            for (let i = 0; i < model.count; i++){
                languages.push(model.get(i).abbrev)
            }
            return languages
        }
    }
}

