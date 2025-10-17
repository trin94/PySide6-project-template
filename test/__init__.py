# SPDX-FileCopyrightText: <Your Name>
#
# SPDX-License-Identifier: GPL-3.0-or-later


try:
    import test.rc_project  # noqa: F401
except ImportError:
    import sys

    print("Can not find resource module \"test.generated_resources\"", file=sys.stderr)
    print("To execute individual tests, please run \"just test\" once before", file=sys.stderr)
    sys.exit(1)
