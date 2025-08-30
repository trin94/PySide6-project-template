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

from PySide6.QtCore import QLibraryInfo, QLocale, QTranslator, QUrl
from PySide6.QtGui import QGuiApplication, QIcon
from PySide6.QtQml import QQmlApplicationEngine


class MyApplication(QGuiApplication):

    def __init__(self, args):
        super().__init__(args)
        self._engine = QQmlApplicationEngine()
        self._translator = QTranslator()
        self._translator_qt = QTranslator()

        self._event_filter = None
        self._effects = None

    def set_window_icon(self):
        icon = QIcon(":/data/app-icon.svg")
        self.setWindowIcon(icon)

    def set_up_signals(self):
        self.aboutToQuit.connect(self._on_quit)
        self._engine.uiLanguageChanged.connect(self._retranslate)

    def _on_quit(self) -> None:
        del self._engine

    def _retranslate(self):
        language_code = self._engine.uiLanguage()
        locale = QLocale(language_code)

        self.removeTranslator(self._translator_qt)
        self.removeTranslator(self._translator)

        self._translator_qt.load(locale, "qtbase", "_", QLibraryInfo.location(QLibraryInfo.LibraryPath.TranslationsPath))
        self._translator.load(f":/i18n/{language_code}.qm")

        self.installTranslator(self._translator_qt)
        self.installTranslator(self._translator)

        self.setLayoutDirection(locale.textDirection())

    def set_up_window_event_filter(self):
        if platform.system() == "Windows":
            from src.framelesswindow.win import WindowsEventFilter
            self._event_filter = WindowsEventFilter(border_width=5)
            self.installNativeEventFilter(self._event_filter)
        elif platform.system() == "Linux":
            from src.framelesswindow.linux import LinuxEventFilter
            self._event_filter = LinuxEventFilter(border_width=5)
            self.installEventFilter(self._event_filter)

    def start_engine(self):
        self._engine.load(QUrl.fromLocalFile(":/qt/qml/main.qml"))

    def set_up_window_effects(self):
        if sys.platform == "win32":
            hwnd = self.topLevelWindows()[0].winId()
            from src.framelesswindow.win import WindowsWindowEffect
            self._effects = WindowsWindowEffect()
            self._effects.addShadowEffect(hwnd)
            self._effects.addWindowAnimation(hwnd)

    def verify(self):
        if not self._engine.rootObjects():
            sys.exit(-1)
