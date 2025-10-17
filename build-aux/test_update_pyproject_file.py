# SPDX-FileCopyrightText: <Your Name>
#
# SPDX-License-Identifier: MIT

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
