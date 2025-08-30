# Copyright 2024
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

PROJECT_FILE_NAME := 'project'

SOURCES_DIR_DATA := 'data'
SOURCES_DIR_I18N := 'i18n'
SOURCES_DIR_PYTHON := 'src'
SOURCES_DIR_PYTHON_TEST := 'test'
SOURCES_DIR_QML := 'qt/qml'
SOURCES_FILE_MAIN := 'main.py'

@_default:
    just --list

# Initialize repository
[group('build')]
@init ARGS='--group dev':
    uv sync {{ ARGS }}

# Build full project into build/release
[group('build')]
@build:
    echo "build"

# Build and compile resources into source directory
[group('build')]
@build-develop:
    echo "build-develop"

# Remove ALL generated files
[group('build')]
@clean:
	echo "clean"

# Add new language
[group('i18n')]
@add-translation locale:
    echo "add-translation {{locale}}"

# Update *.ts files by traversing the source code
[group('i18n')]
@update-translations:
    echo "update-translations"

# Run Python and QML tests
[group('test')]
@test:
	echo "test"

# Run Python tests
[group('test')]
@test-python:
    echo "test-python"

# Run QML tests
[group('test')]
@test-qml:
    echo "test-qml"

@update_pyproject_file: _generate-qrc-file
	echo "update_pyproject_file"
	uv run python build-aux/update-pyproject-file.py \
	    --relative-to . \
	    --include-directory {{ SOURCES_DIR_QML }} \
	    --include-directory {{ SOURCES_DIR_DATA }} \
	    --include-directory {{ SOURCES_DIR_PYTHON }} \
	    --include-directory {{ SOURCES_DIR_I18N }} \
	    --include-file {{ SOURCES_FILE_MAIN }} \
	    --include-file {{ PROJECT_FILE_NAME + '.qrc' }}

@_generate-qrc-file:
    uv run python build-aux/generate-qrc-file.py \
        --relative-to . \
        --include-directory {{ SOURCES_DIR_QML }} \
        --include-directory {{ SOURCES_DIR_DATA }} \
        --include-directory {{ SOURCES_DIR_I18N }} \
        --out-file {{ PROJECT_FILE_NAME + '.qrc' }}
