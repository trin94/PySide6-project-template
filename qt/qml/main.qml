// SPDX-FileCopyrightText: <Your Name>
//
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

import pyobjects

import "views"

ApplicationWindow {
    id: root

    readonly property var windowsFlags: Qt.CustomizeWindowHint | Qt.Window
    readonly property var linuxFlags: Qt.FramelessWindowHint | Qt.Window

    property var factory: Component {
        MessageDialog {
            title: qsTranslate("MessageBoxes", "Title")
            text: qsTranslate("MessageBoxes", "Change the language and look at the 'Yes' and 'Cancel' buttons")
            buttons: MessageDialog.Yes | MessageDialog.Cancel
            visible: true
        }
    }

    flags: Qt.platform.os === "windows" ? windowsFlags : linuxFlags

    width: 1280
    height: 720
    visible: true

    LayoutMirroring.enabled: Qt.application.layoutDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    MyAppMainView {
        header: MyAppHeaderView {
            viewModel: _headerViewModel
        }

        anchors {
            fill: root.contentItem
            margins: _private.windowBorder
        }
    }

    MyAppHeaderViewModel {
        id: _headerViewModel

        onWindowDragRequested: root.startSystemMove()

        onMinimizeAppRequested: root.showMinimized()

        onToggleMaximizeAppRequested: {
            if (_private.maximized) {
                root.showNormal();
            } else {
                root.showMaximized();
            }
        }

        onCloseAppRequested: root.close()

        onLanguageSelected: language => Qt.uiLanguage = language

        onMessageDialogRequested: {
            const dialog = root.factory.createObject(root.contentItem);
            dialog.accepted.connect(dialog.destroy);
            dialog.rejected.connect(dialog.destroy);
            dialog.open();
        }
    }

    QtObject {
        id: _private

        readonly property bool maximized: root.visibility === Window.Maximized
        readonly property bool fullscreen: root.visibility === Window.FullScreen
        readonly property int windowBorder: fullscreen || maximized ? 0 : 1
    }
}
