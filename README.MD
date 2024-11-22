# Unofficial Opinionated Template for PySide6 with QtQuick

An unofficial and opinionated project template designed for a quick start with PySide6 and QtQuick.

![screenshot](docs/picture.png)

# Features

- Compatible with Python **3.9+**
- Supports internationalization,
  including [Right-to-Left User Interfaces](https://doc.qt.io/qt-6/qtquick-positioning-righttoleft.html)
- Leverages the [Qt Resource System](https://doc.qt.io/qt-6/resources.html) to compile resources in `data`, `i18n`, or
  `qml` into a Python file:
  - `data` accessible at `:/data` or `qrc:/data`
  - `i18n` accessible at `:/i18n` or `qrc:/i18n`
  - `qml` accessible at `:/qt/qml` or `qrc:/qt/qml`
- Final build consists solely of Python files
- Preconfigured testing (Python + QML)
- CI setup included
- Client-side window decorations implemented
- No need for Qt Creator; use your preferred text editor

# Development Setup

## Quick Start

This project requires the use of a virtual environment.

1. Prepare the development environment for the specific operating system:
   - [Linux](docs/dev-setup-linux.md)
   - [Windows](docs/dev-setup-windows.md)
2. Execute `just build-develop` to compile resources.
3. Launch the app by running `python main.py`.

## Just recipes

```just
$ just --list
Available recipes:
    [build]
    build                  # Build full project into build/release
    build-develop          # Build and compile resources into source directory
    clean                  # Remove ALL generated files

    [i18n]
    add-translation locale # Add new language
    update-translations    # Update *.ts files by traversing the source code

    [test]
    test                   # Run Python and QML tests
    test-python            # Run Python tests
    test-qml               # Run QML tests
```

## Workflow

After each modification in the `data`, `i18n`, or `qml` directories, run `just build-develop`.
This command will _compile_ all resources into a Python file and place it in the `myapp` directory,
which will be accessed on application startup.

## Internationalization

- Instructions for adding new languages can be found [here](docs/internationalization.md).

## Read Further

- Qt6: https://doc.qt.io
- Python: https://www.python.org
- PySide6: https://doc.qt.io/qtforpython/contents.html
- Examples for Qt, QtQuick & Python: https://pypi.org/project/PySide6-Examples/
- QML Coding Conventions: https://doc.qt.io/qt-6/qml-codingconventions.html
- Python & QML: https://doc.qt.io/qtforpython/PySide6/QtQml/index.html
- Scripting: https://doc.qt.io/qt-6/topics-scripting.html
- Importing JavaScript Resources in QML: https://doc.qt.io/qt-6/qtqml-javascript-imports.html
- Packaging on Linux: https://github.com/andyholmes/flatter

# Dependencies

- PySide6: https://pypi.org/project/PySide6
- PyTest: https://pypi.org/project/pytest
- Just: https://github.com/casey/just

- App Icon: https://commons.wikimedia.org/wiki/File:Qt_logo_2016.svg
- Material Icons: https://fonts.google.com/icons?selected=Material+Icons

# FAQ

- Is it exclusively **PySide6**? Can **PyQt6** be used instead of PySide6?
  > Yes, it should be possible but may require additional work.
