# SPDX-FileCopyrightText: <Your Name>
#
# SPDX-License-Identifier: MIT

export QT_QPA_PLATFORM := 'offscreen'
export QT_QUICK_CONTROLS_MATERIAL_VARIANT := 'Dense'
export QT_QUICK_CONTROLS_STYLE := 'Material'

@_default:
    just --list

# Initialize repository
[group('build')]
@init ARGS='--group dev':
    uv sync {{ ARGS }}

# Build full project into build/release
[group('build')]
@build: clean
    just build-develop
    mkdir -p build/release
    cp -r src build/release
    cp main.py build/release
    cp rc_project.py build/release

# Build and compile resources into source directory
[group('build')]
@build-develop: _update_pyproject_file
    uv run pyside6-project build

# Remove ALL generated files
[group('build')]
@clean:
    find i18n -name "*.qm" -type f -delete
    rm -rf build pyobjects test/rc_project.py rc_project.py project.json project.qrc

# Add language; pattern: language-region ISO 639-1, ISO 3166-1; example: fr-FR
[group('i18n')]
@add-translation locale: _update_pyproject_file
    uv run pyside6-lupdate -source-language en-US -target-language {{ locale }} -ts i18n/{{ locale }}.ts
    just update-translations

# Update *.ts files by traversing the source code
[group('i18n')]
@update-translations: _update_pyproject_file _update_lupdate_project_file
    uv run pyside6-lupdate -locations none -project project.json

# Run Python and QML tests
[group('test')]
@test: test-python test-qml

# Run Python tests
[group('test')]
@test-python: _prepare-tests
    rm -f test/rc_project.py
    cp rc_project.py test/rc_project.py
    uv run pytest build-aux test

# Run QML tests
[group('test')]
test-qml: _prepare-tests
	#!/usr/bin/env bash
	uv run python -c '
	import sys
	from PySide6.QtQuickTest import QUICK_TEST_MAIN_WITH_SETUP
	from test.prepare_qml import MyTestSetup

	# Pass additional arguments to qmltestrunner:
	sys.argv += ["-silent"]
	sys.argv += ["-input", "qt/qml"]
	# sys.argv += ["-eventdelay", "50"]  # Simulate slower systems

	ex = QUICK_TEST_MAIN_WITH_SETUP("qmltestrunner", MyTestSetup, argv=sys.argv)
	sys.exit(ex)
	'

@_prepare-tests: build-develop
    rm -f test/rc_project.py
    cp rc_project.py test/rc_project.py

@_update_pyproject_file: _generate-qrc-file
	uv run python build-aux/update_pyproject_file.py \
	    --relative-to . \
	    --include-directory qt/qml \
	    --include-directory data \
	    --include-directory src \
	    --include-directory i18n \
	    --include-file main.py \
	    --include-file project.qrc

@_generate-qrc-file:
    uv run python build-aux/generate-qrc-file.py \
        --relative-to . \
        --include-directory qt/qml \
        --include-directory data \
        --include-directory i18n \
        --out-file project.qrc

@_update_lupdate_project_file:
	uv run python build-aux/generate-lupdate-project-file.py \
	    --relative-to . \
	    --include-directory qt/qml \
	    --include-directory src \
	    --include-directory i18n \
	    --include-file main.py \
	    --include-file project.qrc \
	    --out-file project.json
