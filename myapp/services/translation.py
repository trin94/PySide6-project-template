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


from typing import Optional

from PySide6.QtCore import QTranslator, QObject, QLocale
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine


class TranslationService(QObject):

    def __init__(self):
        super().__init__()
        self._application: Optional[QGuiApplication] = None
        self._engine: Optional[QQmlApplicationEngine] = None
        self._translator = QTranslator()

    def initialize_with(self, application: QGuiApplication, engine: QQmlApplicationEngine):
        self._application = application
        self._engine = engine

    def load(self, language: str) -> None:
        self._load_translator_for(language)
        self._update_layout_direction_for(language)
        self._retranslate()

    def _load_translator_for(self, language: str):
        resource = self._translation_path_for(language)
        self._application.removeTranslator(self._translator)
        self._translator.load(resource)
        self._application.installTranslator(self._translator)

    def _update_layout_direction_for(self, language: str) -> None:
        self._application.setLayoutDirection(QLocale(language).textDirection())

    def _retranslate(self):
        self._engine.retranslate()

    @staticmethod
    def _translation_path_for(locale: str):
        return f':/i18n/{locale}.qm'
