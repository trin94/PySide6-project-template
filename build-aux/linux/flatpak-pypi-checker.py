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
import re
import urllib.request
from dataclasses import dataclass


class RequirementsUpdater:
    """"""

    @dataclass(frozen=True)
    class Requirement:
        name: str
        version: str
        filters: list[str]  # filter1:filter2:filter3
        data: list = None

    _requirements: dict[str, Requirement] = {}  # name mapped to object

    @property
    def requirements(self) -> dict[str, Requirement]:
        return dict(self._requirements)

    def configure_for(self, dependencies: list[str]) -> None:
        for dependency in dependencies:
            name, filters = dependency.split("::")
            filters = [f.strip() for f in filters.split(":")]

            if "==" in name:
                name, _, version = re.split("(>=|==|<=)", name)
            elif "<=" in name:
                raise ValueError("Version requirement '<=' currently not supported")
            else:
                version = "latest"

            self._requirements[name] = self.Requirement(name, version, filters)

    def resolve(self) -> None:
        for requirement in self._requirements.values():
            name = requirement.name

            with urllib.request.urlopen(f"https://pypi.org/pypi/{name}/json", timeout=5) as connection:
                data = json.loads(connection.read().decode("utf-8").strip())

            version = data["info"]["version"] if requirement.version == "latest" else requirement.version
            filters = requirement.filters
            data = data["releases"][version]

            self._requirements[requirement.name] = self.Requirement(name, version, filters, data)

    def extract(self) -> list:
        """"""

        def find_first_filename_matching(files: list, must_contain_substr: list[str]) -> dict:
            for file in files:
                if all(f in file["filename"] for f in must_contain_substr):
                    return file
            raise StopIteration(
                f"Cannot find file containing all required substrings: {", ".join(must_contain_substr)}"
            )

        dependencies = []

        for requirement in self._requirements.values():
            filters = requirement.filters
            release = find_first_filename_matching(files=requirement.data, must_contain_substr=filters)
            value = {
                "name": requirement.name,
                "version": requirement.version,
                "filename": release["filename"],
                "sha256": release["digests"]["sha256"],
                "url": release["url"],
            }
            dependencies.append(value)

        dependencies.sort(key=lambda x: x["name"])

        return dependencies


def main():
    parser = argparse.ArgumentParser(description="Prints relevant info for flatpak pypi dependencies")
    parser.add_argument(
        "--dependency",
        type=str,
        action="append",
        default=[],
        help="dependency to consider: dependency::filename-filter1:filename-filter2",
    )
    run(parser.parse_args())


def run(args):
    updater = RequirementsUpdater()
    updater.configure_for(args.dependency)
    updater.resolve()

    dependencies = updater.extract()
    data = json.dumps(dependencies)

    print(data)


if __name__ == "__main__":
    main()
