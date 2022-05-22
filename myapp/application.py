# MIT
#
# Copyright (c) 2022
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


import sys

import inject
from PySide6.QtCore import QUrl
from PySide6.QtGui import QGuiApplication, QIcon
from PySide6.QtQml import QQmlApplicationEngine

from myapp.services import TranslationService


class MyApplication(QGuiApplication):
    _translator = inject.attr(TranslationService)

    def __init__(self, args):
        super().__init__(args)
        self._engine = QQmlApplicationEngine()

    def set_window_icon(self):
        icon = QIcon(':/data/app-icon.svg')
        self.setWindowIcon(icon)

    def initialize_translator(self):
        self._translator.initialize_with(application=self, engine=self._engine)

    def set_up_signals(self):
        self.aboutToQuit.connect(self._on_quit)

    def _on_quit(self) -> None:
        del self._engine

    def set_up_imports(self):
        self._engine.addImportPath(':/qml')

    def start_engine(self):
        self._engine.load(QUrl.fromLocalFile(':/qml/main.qml'))

    def verify(self):
        if not self._engine.rootObjects():
            sys.exit(-1)
