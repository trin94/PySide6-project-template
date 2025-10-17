// SPDX-FileCopyrightText: <Your Name>
//
// SPDX-License-Identifier: GPL-3.0-or-later

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
