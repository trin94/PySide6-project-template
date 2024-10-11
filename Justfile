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

PYTHON_DIR := invocation_directory() + '/' + if os_family() == 'windows' { 'venv/Scripts' } else { 'venv/bin' }
PYTHON := PYTHON_DIR + if os_family() == 'windows' { '/python.exe' } else { '/python3' }

#

TOOL_CLI_LUPDATE := PYTHON_DIR + '/pyside6-lupdate'
TOOL_CLI_PROJECT := PYTHON_DIR + '/pyside6-project'
TOOL_CLI_QML_TESTRUNNER := 'qmltestrunner'

#

SOURCES_DIR_DATA := 'data'
SOURCES_DIR_I18N := 'i18n'
SOURCES_DIR_PYTHON := 'myapp'
SOURCES_DIR_PYTHON_TEST := 'test'
SOURCES_DIR_QML := 'qml'
SOURCES_FILE_MAIN := 'main.py'

PROJECT_FILE_NAME := 'project'
RELEASE_DIR := 'build/release'
PYTHON_QML_MODULE := 'pyobjects'

export QT_QPA_PLATFORM := 'offscreen'
export QT_QUICK_CONTROLS_STYLE := 'Material'
export QT_QUICK_CONTROLS_MATERIAL_VARIANT := 'dense'

_default:
    @just --list

# Build full project into build/release
[group('build')]
build: build-develop
    @mkdir -p {{ RELEASE_DIR }}
    @cp -r {{ SOURCES_DIR_PYTHON }} {{ RELEASE_DIR }}
    @cp {{ SOURCES_FILE_MAIN }} {{ 'rc_' + PROJECT_FILE_NAME + '.py' }} {{ RELEASE_DIR }}

# Build and compile resources into source directory
[group('build')]
build-develop: _check-pyside-setup clean _generate_pyproject_file
    @{{ TOOL_CLI_PROJECT }} build --quiet

# Remove ALL generated files
[group('build')]
clean:
    @rm -rf {{ RELEASE_DIR }}
    @rm -rf {{ PYTHON_QML_MODULE }}
    @rm -rf {{ SOURCES_DIR_I18N + '/*.qm' }}
    @rm -f {{ PROJECT_FILE_NAME + '.json' }}
    @rm -f {{ PROJECT_FILE_NAME + '.pyproject' }}
    @rm -f {{ PROJECT_FILE_NAME + '.qrc' }}
    @rm -f {{ 'rc_' + PROJECT_FILE_NAME + '.py' }}


# Add new language
[group('i18n')]
add-translation locale: _check-pyside-setup
    @{{ TOOL_CLI_LUPDATE }} -source-language en_US -target-language {{ locale }} -ts {{ SOURCES_DIR_I18N + '/' + locale + '.ts ' }}
    @echo ""
    @just update-translations

# Update *.ts files by traversing the source code
[group('i18n')]
update-translations: _check-pyside-setup _generate_lupdate_json_file
    @{{ TOOL_CLI_LUPDATE }} \
        -locations none \
        -project {{ PROJECT_FILE_NAME + '.json' }}

# Run Python and QML tests
[group('test')]
test: test-python test-qml

# Run Python tests
[group('test')]
test-python: build-develop
    @{{ PYTHON }} -m pytest test

# Run QML tests
[group('test')]
test-qml: _check-qml-setup
    @{{ TOOL_CLI_QML_TESTRUNNER }} \
        -silent \
        -input {{ SOURCES_DIR_QML }}

###
### Helper recipes
###

_generate_lupdate_json_file:
    @{{ PYTHON }} build-aux/generate-lupdate-project-file.py \
        --relative-to . \
        --include-directory {{ SOURCES_DIR_QML }} \
        --include-directory {{ SOURCES_DIR_PYTHON }} \
        --include-directory {{ SOURCES_DIR_I18N }} \
        --include-file {{ SOURCES_FILE_MAIN }} \
        --out-file {{ PROJECT_FILE_NAME + '.json' }}

_generate_pyproject_file: _generate-qrc-file
    @{{ PYTHON }} build-aux/generate-pyproject-file.py \
        --relative-to . \
        --include-directory {{ SOURCES_DIR_QML }} \
        --include-directory {{ SOURCES_DIR_DATA }} \
        --include-directory {{ SOURCES_DIR_PYTHON }} \
        --include-directory {{ SOURCES_DIR_I18N }} \
        --include-file {{ SOURCES_FILE_MAIN }} \
        --include-file {{ PROJECT_FILE_NAME + '.qrc' }} \
        --out-file {{ PROJECT_FILE_NAME + '.pyproject' }}

_generate-qrc-file:
    @{{ PYTHON }} build-aux/generate-qrc-file.py \
        --relative-to . \
        --include-directory {{ SOURCES_DIR_QML }} \
        --include-directory {{ SOURCES_DIR_DATA }} \
        --include-directory {{ SOURCES_DIR_I18N }} \
        --out-file {{ PROJECT_FILE_NAME + '.qrc' }}

_check-pyside-setup:
    @which {{ PYTHON }}
    @which {{ TOOL_CLI_LUPDATE }}
    @which {{ TOOL_CLI_PROJECT }}
    @echo ''

_check-qml-setup:
    @which {{ TOOL_CLI_QML_TESTRUNNER }}
    @echo ''
