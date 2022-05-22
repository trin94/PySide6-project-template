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


import unittest
from unittest.mock import MagicMock

import inject
from PySide6.QtCore import QResource

from myapp.services import TranslationService


class TestTranslationService(unittest.TestCase):
    _mocked_app: MagicMock
    _mocked_engine: MagicMock
    _translations: TranslationService

    def setUp(self):
        self._mocked_app = MagicMock()
        self._mocked_engine = MagicMock()

        self._translations = TranslationService()
        self._translations.initialize_with(application=self._mocked_app, engine=self._mocked_engine)

    def tearDown(self):
        inject.clear()

    def test_set_language_load_translation(self):
        service = self._translations
        service.load('de')

        self.assertTrue(self._mocked_app.installTranslator.called)

    def test_set_language_retranslate(self):
        service = self._translations
        service.load('it')

        self.assertTrue(self._mocked_engine.retranslate.called)

    def test_translation_language_doesnt_exists(self):
        service = self._translations
        locale = 'non-existent'

        path = service._translation_path_for(locale)
        self.assertFalse(QResource(path).isValid())

    def test_translation_language_de_exists(self):
        service = self._translations
        locale = 'de'

        path = service._translation_path_for(locale)
        self.assertTrue(QResource(path).isValid())
