# SPDX-FileCopyrightText: <Your Name>
#
# SPDX-License-Identifier: GPL-3.0-or-later

import pytest
from PySide6.QtCore import QFile


@pytest.mark.parametrize("file_path", [
    ":/data/app-icon.svg",
    ":/i18n/de-DE.qm",
    ":/i18n/he-IL.qm",
])
def test_resource_exist(file_path):
    file = QFile(file_path)
    assert file.exists()


def test_resource_does_not_exist():
    file = QFile(":/random/file/which/not.exists")
    assert not file.exists()
