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
import QtQuick.Controls
import QtQuick.Layouts

import pyobjects

import "../header"


Page {
    id: root

    required property var appWindow

    anchors {
        fill: root
    }

    header: MyAppHeader {
        appWindow: root.appWindow
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
            text: qsTranslate("MainPage", "Exposed from Python: '%1'").arg(SingletonPyObject.exposed_property)

            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 45
        }
    }

}
