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


ListModel {
    readonly property var languagesForTranslationTool: [
        qsTranslate("Languages", "English"),
        qsTranslate("Languages", "German"),
        qsTranslate("Languages", "Hebrew"),
    ]

    ListElement {
        language: "English"
        abbrev: "en-US"
    }
    ListElement {
        language: "German"
        abbrev: "de-DE"
    }
    ListElement {
        language: "Hebrew"
        abbrev: "he-IL"
    }
}
