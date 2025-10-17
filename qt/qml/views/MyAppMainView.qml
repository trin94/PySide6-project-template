// SPDX-FileCopyrightText: <Your Name>
//
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import pyobjects

Page {
    id: root

    readonly property MyAppMainViewModel viewModel: MyAppMainViewModel {}

    anchors {
        fill: root
    }

    ColumnLayout {
        spacing: 8
        width: root.width

        Image {
            source: "qrc:/data/app-icon.svg"
            asynchronous: true

            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 308
            Layout.preferredHeight: 226
            Layout.topMargin: 30
        }

        Label {
            text: Qt.application.name + ' (' + Qt.application.version + ')'

            font {
                bold: true
                pixelSize: Qt.application.font.pixelSize * 1.5
            }

            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 45
        }

        Label {
            text: 'Running on ' + Qt.platform.os

            font {
                bold: true
                pixelSize: Qt.application.font.pixelSize * 1.5
            }

            Layout.alignment: Qt.AlignHCenter
        }

        Label {
            text: qsTranslate("MainPage", "Have fun!")
            color: Material.accent

            font {
                bold: true
                pixelSize: Qt.application.font.pixelSize * 1.5
            }

            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 45
        }

        Label {
            text: qsTranslate("MainPage", "Current time exposed from Python: %1").arg(root.viewModel.time)

            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 45
        }
    }
}
