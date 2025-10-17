// SPDX-FileCopyrightText: <Your Name>
//
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtTest


TestCase {
    id: testCase

    name: "MyAppLanguageModelTest"

    Component {
        id: objectUnderTest

        MyAppLanguageModel {}
    }

    function extractLanguagesFrom(model: MyAppLanguageModel): Array<string> {
        const languages = []
        for (let i = 0; i < model.count; i++) {
            languages.push(model.get(i).abbrev)
        }
        return languages
    }

    function test_languageExists_data() {
        return [
            {tag: 'de-DE', abbrev: 'de-DE'},
            {tag: 'en-US', abbrev: 'en-US'},
            {tag: 'he-IL', abbrev: 'he-IL'},
        ]
    }

    function test_languageExists(data) {
        const control = createTemporaryObject(objectUnderTest, testCase)
        verify(control)

        const languages = extractLanguagesFrom(control)
        verify(languages.includes(data.abbrev))
    }

    function test_languageDoesNotExist() {
        const control = createTemporaryObject(objectUnderTest, testCase)
        verify(control)

        const languages = extractLanguagesFrom(control)
        verify(!languages.includes('something-else'))
    }

}
