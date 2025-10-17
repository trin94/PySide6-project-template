# SPDX-FileCopyrightText: <Your Name>
#
# SPDX-License-Identifier: GPL-3.0-or-later

import sys

from PySide6.QtCore import Property, QObject, Signal, Slot, Qt, QTimer
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QmlElement

QML_IMPORT_NAME = "pyobjects"
QML_IMPORT_MAJOR_VERSION = 1


@QmlElement
class MyAppHeaderViewModel(QObject):
    isFullscreenChanged = Signal(bool)
    isMaximizedChanged = Signal(bool)

    windowDragRequested = Signal()
    minimizeAppRequested = Signal()
    toggleMaximizeAppRequested = Signal()
    closeAppRequested = Signal()

    languageSelected = Signal(str)
    messageDialogRequested = Signal()

    def __init__(self):
        super().__init__()
        self._is_fullscreen = False
        self._is_maximized = False

        self._window = QGuiApplication.topLevelWindows()[0]

        self._on_window_state_changed(self._window.windowState())
        self._window.windowStateChanged.connect(self._on_window_state_changed)

    @Property(bool, constant=True, final=True)
    def isWindows(self) -> bool:
        return sys.platform == "win32"

    @Property(bool, notify=isFullscreenChanged)
    def isFullscreen(self) -> bool:
        return self._is_fullscreen

    @Property(bool, notify=isMaximizedChanged)
    def isMaximized(self) -> bool:
        return self._is_maximized

    def _on_window_state_changed(self, state: Qt.WindowState) -> None:
        is_fullscreen = state == Qt.WindowState.WindowFullScreen
        is_maximized = state == Qt.WindowState.WindowMaximized

        if is_fullscreen != self._is_fullscreen:
            self._is_fullscreen = is_fullscreen
            self.isFullscreenChanged.emit(is_fullscreen)

        if is_maximized != self._is_maximized:
            self._is_maximized = is_maximized
            self.isMaximizedChanged.emit(is_maximized)

    @Slot()
    def requestWindowDrag(self) -> None:
        self.windowDragRequested.emit()

    @Slot()
    def requestMinimize(self) -> None:
        self.minimizeAppRequested.emit()

    @Slot()
    def requestToggleMaximize(self) -> None:
        self.toggleMaximizeAppRequested.emit()

    @Slot()
    def requestClose(self) -> None:
        self.closeAppRequested.emit()

    @Slot(str)
    def setLanguage(self, language: str) -> None:
        def _set_language():
            self.languageSelected.emit(language)

        QTimer.singleShot(150, _set_language)

    @Slot()
    def showMessageDialog(self) -> None:
        self.messageDialogRequested.emit()
