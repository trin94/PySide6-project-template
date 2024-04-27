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
import json
import sys
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


class ProjectFileGenerator:
    _extensions_ignored = {".pyc", ".qm"}
    _extensions_translation = ".ts"
    _files = []

    def __init__(self, root_dir: Path):
        self._root_dir = root_dir

    def add(self, directories: list[Path], files: list[Path]):
        for directory in directories:
            for path in directory.rglob("*"):
                if path.is_file():
                    self._files.append(path)
        self._files.extend(files)

    def make_files_relative(self):
        self._files = [path.relative_to(self._root_dir) for path in self._files]

    def remove_irrelevant_files(self):
        self._files = [path for path in self._files if path.suffix not in self._extensions_ignored]

    def sort_files(self):
        self._files = sorted(self._files)

    def generate_project_file(self, outfile: Path):
        files = [str(path) for path in self._files if path.suffix != self._extensions_translation]
        translations = [str(path) for path in self._files if path.suffix == self._extensions_translation]
        structure = {
            "excluded": [],
            "includePaths": [],
            "projectFile": "",
            "sources": files,
            "translations": translations,
        }
        data = json.dumps([structure], indent=2, sort_keys=True)
        outfile.write_text(data, encoding="utf-8")


# noinspection DuplicatedCode
def main():
    parser = argparse.ArgumentParser(description="Create a json project file")
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
def run(args):
    root_dir = Path(args.relative_to).absolute()
    out_file = Path(args.out_file)
    directories = [Path(path).absolute() for path in args.include_directory]
    files = [Path(path).absolute() for path in args.include_file]

    validator = ArgumentValidator()
    validator.validate_directory(root_dir)
    validator.validate_directories(directories)
    validator.validate_files(files)
    validator.break_on_errors()

    generator = ProjectFileGenerator(root_dir=root_dir)
    generator.add(directories, files)
    generator.make_files_relative()
    generator.remove_irrelevant_files()
    generator.sort_files()
    generator.generate_project_file(outfile=out_file)


if __name__ == "__main__":
    main()
