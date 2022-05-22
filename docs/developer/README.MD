# Development Setup

* [Linux](setup-on-linux.md)
* [Windows](setup-on-windows.md)

This project assumes that a virtual environment is used.

# Makefile targets

For a complete overview please look into the Makefile. The most important targets are documented here:

* `check-pyside-setup`  
  Checks if PySide is correctly set up
* `check-qml-setup`  
  Checks if Qml (for tests only) is correctly set up


* `build`  
  Builds the project into build/release/myapp
* `build-clean`  
  Cleans up the build directory


* `test`  
  Runs all tests
* `test-python`  
  Runs all Python tests
* `test-qml`  
  Runs all Qml tests
* `test-clean`  
  Cleans up the compiled resources in the test directory


* `develop-build`  
  Generates resources and copies them into the source directory.  
  This allows to develop/debug the project normally
* `develop-clean`  
  Cleans up the compiled resources in the source directory


* `update-translations`  
  Traverses *qml* & *py* files to update translation files
* `create-new-translation`  
  Allows to add translations to the
  project: `make create-new-translation lang=<locale>` (`make create-new-translation lang=es`)


* `clean`  
  Cleans up **all** generated files

# Workflow

Run `make develop-build` after each change in the `data`, `i18n`, or `qml` directories.
This will *compile* everything into a Python file and move it into the `myapp` directory
where it will be picked up on app start.

# Architecture

* **QML Layer** is the user interface layer
* **PyObject Layer** is the glue layer of Python and Qml
* **Service Layer** is the application logic layer

# Tips

* If you're on Linux, and you're using PyCharm or something similar:
  Create a run configuration that runs the `develop-build` makefile target before the application.
* Adding new languages is described [here](adding-new-languages.md)
