# Development Setup

* [Linux](dev-setup-linux.md)
* [Windows](dev-setup-windows.md)

This project assumes that a virtual environment is used.

# Just recipes

```shell
$ just --list
Available recipes:
    add-translation locale    # Allows adding additional languages
    build                     # Builds the project into build/release
    build-develop             # Builds the project. This will add all compiled resources into the Python source directory.
    clean                     # Removes ALL generated files
    test                      # Runs all Python and QML tests
    test-python               # Runs all Python tests
    test-qml                  # Runs all QML tests
    update-translations       # Traverses QML and Python files and updates translation files with new strings
```

# Workflow

Run `just build-develop` after each change in the `data`, `i18n`, or `qml` directories.
This will *compile* everything into a Python file and move it into the `myapp` directory
where it will be picked up on app start.

# Tips

* If you're on Linux, and you're using PyCharm or something similar:
  Create a run configuration that runs the `build-develop` recipe before the application.
* Adding new languages is described [here](internationalization.md)
