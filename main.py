#!/usr/bin/env python


def main():
    import rc_project  # noqa

    from src.startup import perform_startup

    perform_startup()


if __name__ == "__main__":
    main()
