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
