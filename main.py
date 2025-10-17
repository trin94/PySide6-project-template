# SPDX-FileCopyrightText: <Your Name>
#
# SPDX-License-Identifier: GPL-3.0-or-later


def main():
    import rc_project  # noqa

    from src.startup import perform_startup

    perform_startup()


if __name__ == "__main__":
    main()
