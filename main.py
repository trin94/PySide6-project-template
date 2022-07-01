#!/usr/bin/env python


def main():
    from myapp.startup import perform_startup

    perform_startup()


if __name__ == '__main__':
    print("Called from PySide6 project template")
    main()
