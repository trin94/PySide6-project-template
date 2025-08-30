# MIT License
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import textwrap

import pytest
from update_pyproject_file import determine_new_pyproject_lines


def test_raises_tool_pyside6_project_missing():
    lines = []
    with pytest.raises(KeyError, match='.*Could not find "\\[tool.pyside6-project\\]".*'):
        determine_new_pyproject_lines(lines, [])

    lines = ["#[tool.pyside6-project]"]
    with pytest.raises(KeyError, match='.*Could not find "\\[tool.pyside6-project\\]".*'):
        determine_new_pyproject_lines(lines, [])


def test_raises_tool_pyside6_project_files_missing():
    lines = ["[tool.pyside6-project]"]
    with pytest.raises(KeyError, match='.*Could not find "files" in "\\[tool.pyside6-project\\]".*'):
        determine_new_pyproject_lines(lines, [])

    lines = ["[tool.pyside6-project]", "#files = []"]
    with pytest.raises(KeyError, match='.*Could not find "files" in "\\[tool.pyside6-project\\]".*'):
        determine_new_pyproject_lines(lines, [])


def test_determine_new_pyproject_lines_simple():
    lines = textwrap.dedent("""

        [tool.pyside6-project]
        files = []

    """)
    actual = determine_new_pyproject_lines(lines.splitlines(keepends=True), [])
    expected = textwrap.dedent("""

        [tool.pyside6-project]
        files = [
            # WARNING! This list is auto updated by the just build helper
        ]

    """)
    assert "".join(actual) == expected


def test_determine_new_pyproject_lines_advanced():
    lines = textwrap.dedent("""

        [tool.pyside6-project]
        files = [
         #

        ]


        [tool.uv]

    """)
    actual = determine_new_pyproject_lines(
        lines.splitlines(keepends=True),
        [
            "main.py",
            "data/app-icon.svg",
        ],
    )
    expected = textwrap.dedent("""

        [tool.pyside6-project]
        files = [
            # WARNING! This list is auto updated by the just build helper
            "main.py",
            "data/app-icon.svg",
        ]


        [tool.uv]

    """)
    assert "".join(actual) == expected
