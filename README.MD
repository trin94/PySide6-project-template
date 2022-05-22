# PySide6 + QtQuick Project Template

Project template to get started with PySide6 and QtQuick quickly without worrying about tooling

![screenshot](docs/picture.png)

# Features

* Internationalization including (LTR/RTL)
* Resources compiled ahead of time:
    * Everything in `data`, `i18n`, and `qml` will be compiled into a Python file
    * Final build only consists of Python files
* Testing preconfigured (Python + Qml)
* CI preconfigured
* Client side window decorations implemented
* Qt creator not required (use your favorite text editor)

# Development Setup

## First Steps

1. Set up the development environment for your OS (please look [here](docs/developer) for a guide)
2. Run `make develop-build` to compile resources
3. Run `python main.py` to start the app

## Read Further

* Qt6 documentation: https://doc.qt.io/
* PySide6 documentation: https://doc.qt.io/qtforpython/contents.html

# Dependencies

* Dependency Injection: https://pypi.org/project/Inject/
* PySide6 https://pypi.org/project/PySide6/
* PyTest https://pypi.org/project/pytest/


* App Icon: https://commons.wikimedia.org/wiki/File:Qt_logo_2016.svg
* Material Icons: https://fonts.google.com/icons?selected=Material+Icons

# FAQ

* Only **PySide6**? Can I substitute **PySide6** with **PyQt6**?
  > No. Resources will be compiled ahead of time and PyQt6 dropped support for this.
