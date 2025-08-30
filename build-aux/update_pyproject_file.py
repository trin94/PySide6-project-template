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


import argparse
import sys
from collections.abc import Iterable
from pathlib import Path


class ArgumentValidator:
    def __init__(self) -> None:
        self._errors: list[str] = []

    def validate_directory(self, directory: Path) -> None:
        if not directory.exists():
            self._errors.append(f"Directory {directory} does not exist")
        elif not directory.is_dir():
            self._errors.append(f"Directory {directory} is not a directory")

    def validate_directories(self, directories: list[Path]) -> None:
        for directory in directories:
            self.validate_directory(directory)

    def validate_files(self, files: list[Path]) -> None:
        for file in files:
            self._validate_file(file)

    def _validate_file(self, file: Path) -> None:
        if not file.exists():
            self._errors.append(f"File {file} does not exist")
        elif not file.is_file():
            self._errors.append(f"File {file} is not a file")

    def break_on_errors(self) -> None:
        if errors := self._errors:
            for error in errors:
                print(error, file=sys.stderr)
            sys.exit(1)


class ProjectFileUpdater:
    _FILENAME = "pyproject.toml"
    _EXTENSIONS_IGNORED = frozenset({".pyc", ".qm"})

    def __init__(self, root_dir: Path) -> None:
        self._root_dir = root_dir
        self._files: set[Path] = set()

    def add(self, directories: list[Path], files: list[Path]) -> None:
        for directory in directories:
            for path in directory.rglob("*"):
                if path.is_file() and path.suffix not in self._EXTENSIONS_IGNORED:
                    self._files.add(path)
        for file in files:
            if file.is_file() and file.suffix not in self._EXTENSIONS_IGNORED:
                self._files.add(file)

    def make_files_relative(self) -> None:
        self._files = {p.relative_to(self._root_dir) for p in self._files}

    def sorted_files_as_str(self) -> list[str]:
        return [str(p.as_posix()) for p in sorted(self._files)]

    def update_pyproject_toml(self) -> None:
        pyproject_path = Path(self._FILENAME)
        original = pyproject_path.read_text(encoding="utf-8").splitlines(keepends=True)

        try:
            updated = determine_new_pyproject_lines(
                existing_lines=original,
                qt_files=self.sorted_files_as_str(),
            )
        except KeyError as e:
            print(str(e), file=sys.stderr)
            sys.exit(1)

        if updated != original:
            pyproject_path.write_text("".join(updated), encoding="utf-8")


def determine_new_pyproject_lines(existing_lines: list[str], qt_files: Iterable[str]) -> list[str]:
    start, end = determine_line_to_overwrite(existing_lines)
    lines: list[str] = [
        "files = [\n",
        "    # WARNING! This list is auto updated by the just build helper\n",
        *[f'    "{path}",\n' for path in qt_files],
        "]\n",
    ]
    return existing_lines[: start - 1] + lines + existing_lines[end:]


def determine_line_to_overwrite(lines: list[str]) -> tuple[int, int]:
    in_section = False
    files_start: int | None = None

    for i, raw in enumerate(lines):
        line = raw.strip()

        if not in_section:
            if line == "[tool.pyside6-project]":
                in_section = True
            continue

        if files_start is None and line.startswith("files ="):
            if line.endswith("]"):
                return i + 1, i + 1
            files_start = i + 1
            continue

        if files_start is not None and ("]" in line) and not line.startswith("#"):
            return files_start, i + 1

    if not in_section:
        raise KeyError('Could not find "[tool.pyside6-project]" in pyproject.toml')
    if files_start is None:
        raise KeyError('Could not find "files" in "[tool.pyside6-project]" table in pyproject.toml')

    raise ValueError('Could not update "files" in pyproject.toml')


def main() -> None:
    parser = argparse.ArgumentParser(description="Update tool.pyside6-project.files table in pyproject.toml")
    parser.add_argument(
        "--relative-to",
        type=str,
        required=True,
        help="Root directory to make files relative to",
    )
    parser.add_argument(
        "--include-directory",
        type=str,
        action="append",
        default=[],
        help="Directory to include",
    )
    parser.add_argument(
        "--include-file",
        type=str,
        action="append",
        default=[],
        help="File to include",
    )
    run(parser.parse_args())


def run(args) -> None:
    root_dir = Path(args.relative_to).absolute()
    directories = [Path(p).absolute() for p in args.include_directory]
    files = [Path(p).absolute() for p in args.include_file]

    validator = ArgumentValidator()
    validator.validate_directory(root_dir)
    validator.validate_directories(directories)
    validator.validate_files(files)
    validator.break_on_errors()

    updater = ProjectFileUpdater(root_dir)
    updater.add(directories, files)
    updater.make_files_relative()
    updater.update_pyproject_toml()


if __name__ == "__main__":
    main()
