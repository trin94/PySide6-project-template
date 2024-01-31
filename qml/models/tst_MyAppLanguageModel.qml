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


import QtQuick 2.0
import QtTest

Item {
    property var model: MyAppLanguageModel {}

    TestCase {
        name: "MyAppLanguageModelTest"

        function test_language_de_exists(data) {
            const languages = extractLanguages()
            verify(languages.includes('de_DE'))
        }

        function test_language_en_exists(data) {
            const languages = extractLanguages()
            verify(languages.includes('en_US'))
        }

        function test_language_he_exists(data) {
            const languages = extractLanguages()
            verify(languages.includes('he_IL'))
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
