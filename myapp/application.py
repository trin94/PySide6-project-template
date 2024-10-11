# Copyright
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


import platform
import sys

from PySide6.QtCore import QUrl, QTranslator, QLocale, QLibraryInfo
from PySide6.QtGui import QGuiApplication, QIcon
from PySide6.QtQml import QQmlApplicationEngine


class MyApplication(QGuiApplication):

    def __init__(self, args):
        super().__init__(args)
        self._engine = QQmlApplicationEngine()
        self._translator_myapp = QTranslator()
        self._translator_qt = QTranslator()

    def set_window_icon(self):
        icon = QIcon(':/data/app-icon.svg')
        self.setWindowIcon(icon)

    def set_up_signals(self):
        self.aboutToQuit.connect(self._on_quit)
        self._engine.uiLanguageChanged.connect(self._retranslate)

    def _on_quit(self) -> None:
        del self._engine

    def _retranslate(self):
        self.removeTranslator(self._translator_qt)
        self.removeTranslator(self._translator_myapp)

        identifier = self._engine.uiLanguage()
        locale = QLocale(identifier)

        self._translator_qt.load(locale, "qtbase", "_", QLibraryInfo.location(QLibraryInfo.TranslationsPath))
        self._translator_myapp.load(f':/i18n/{identifier}.qm')

        self.installTranslator(self._translator_qt)
        self.installTranslator(self._translator_myapp)

        self.setLayoutDirection(locale.textDirection())

    def start_engine(self):
        self._engine.addImportPath(':/qml')
        self._engine.load(QUrl.fromLocalFile(':/qml/main.qml'))

    def configure_frameless_window(self):
        if platform.system() == "Windows":
            from myapp.framelesswindow.win import WindowsEventFilter
            from myapp.framelesswindow.win import WindowsWindowEffect

            self._event_filter = WindowsEventFilter(border_width=5)
            self.installNativeEventFilter(self._event_filter)

            hwnd = self.topLevelWindows()[0].winId()

            self._effects = WindowsWindowEffect()
            self._effects.addShadowEffect(hwnd)
            self._effects.addWindowAnimation(hwnd)
        elif platform.system() == 'Linux':
            from myapp.framelesswindow.linux import LinuxEventFilter
            self._event_filter = LinuxEventFilter(border_width=5)
            self.installEventFilter(self._event_filter)

    def verify(self):
        if not self._engine.rootObjects():
            sys.exit(-1)
