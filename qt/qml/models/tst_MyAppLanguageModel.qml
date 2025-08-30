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
