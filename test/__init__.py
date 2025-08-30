# Copyright
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, version 3.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.


try:
    import test.rc_project  # noqa: F401
except ImportError:
    import sys

    print("Can not find resource module \"test.generated_resources\"", file=sys.stderr)
    print("To execute individual tests, please run \"just test\" once before", file=sys.stderr)
    sys.exit(1)
