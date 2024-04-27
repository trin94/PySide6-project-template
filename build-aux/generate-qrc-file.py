#!/usr/bin/env python
#
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

import argparse
import sys
import textwrap
from pathlib import Path


# noinspection DuplicatedCode
class ArgumentValidator:
    _errors = []

    def validate_directory(self, directory: Path):
        if not directory.exists():
            self._errors.append(f"Directory {directory} does not exist")
        elif not directory.is_dir():
            self._errors.append(f"Directory {directory} is not a directory")

    def validate_directories(self, directories: list[Path]):
        for directory in directories:
            self.validate_directory(directory)

    def validate_files(self, files: list[Path]):
        for file in files:
            self._validate_file(file)

    def _validate_file(self, file: Path):
        if not file.exists():
            self._errors.append(f"File {file} does not exist")
        elif not file.is_file():
            self._errors.append(f"File {file} is not a file")

    def break_on_errors(self):
        if errors := self._errors:
            for error in errors:
                print(error, file=sys.stderr)
            sys.exit(1)


class QrcFileGenerator:
    _files = []

    def __init__(self, root_dir: Path):
        self._root_dir = root_dir

    def add(self, directories: list[Path], files: list[Path]) -> None:
        for directory in directories:
            for path in directory.rglob("*"):
                if path.is_file():
                    self._files.append(path)
        self._files.extend(files)

    def replace_suffixes(self, before: str, after: str) -> None:
        files = set()
        for file in self._files:
            if file.suffix == before:
                files.add(file.with_suffix(after))
            else:
                files.add(file)

        self._files = list(files)

    def make_files_relative(self) -> None:
        self._files = [path.relative_to(self._root_dir) for path in self._files]

    def sort_files(self) -> None:
        self._files = sorted(self._files)

    def write_to(self, output: Path) -> None:
        line_sep = "\n" + 4 * "    "
        files = line_sep.join([f"<file>{file}</file>" for file in self._files])

        data = textwrap.dedent(f"""\
        <!-- WARNING! All changes made in this file will be lost! -->
        <!DOCTYPE RCC><RCC version="1.0">
            <qresource>
                {files}
            </qresource>
        </RCC>
        """)
        output.write_text(data, encoding="utf-8")


# noinspection DuplicatedCode
def main():
    parser = argparse.ArgumentParser(description="Create a qrc file")
    parser.add_argument("--relative-to", type=str, required=True, help="Root directory to look for files")
    parser.add_argument(
        "--include-directory",
        type=str,
        action="append",
        default=[],
        help="Directory to include. Can be used multiple times",
    )
    parser.add_argument(
        "--include-file", type=str, action="append", default=[], help="File to include. Can be used multiple times"
    )
    parser.add_argument("--out-file", type=str, required=True, help="Path of the json project file to generate")
    run(parser.parse_args())


# noinspection DuplicatedCode
def run(args: argparse.Namespace):
    root_dir = Path(args.relative_to).absolute()
    out_file = Path(args.out_file)
    directories = [Path(path).absolute() for path in args.include_directory]
    files = [Path(path).absolute() for path in args.include_file]

    validator = ArgumentValidator()
    validator.validate_directory(root_dir)
    validator.validate_directories(directories)
    validator.validate_files(files)
    validator.break_on_errors()

    generator = QrcFileGenerator(root_dir)
    generator.add(directories, files)
    generator.replace_suffixes(before=".ts", after=".qm")
    generator.make_files_relative()
    generator.sort_files()
    generator.write_to(out_file)


if __name__ == "__main__":
    main()
