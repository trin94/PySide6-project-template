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

TOOL_CLI_LUPDATE := PYTHON_DIR + '/pyside6-lupdate'
TOOL_CLI_LRELEASE := PYTHON_DIR + '/pyside6-lrelease'
TOOL_CLI_RCC := PYTHON_DIR + '/pyside6-rcc'
TOOL_CLI_QML_TESTRUNNER := 'qmltestrunner'

export QT_QPA_PLATFORM := 'offscreen'
export QT_QUICK_CONTROLS_STYLE := 'Material'
export QT_QUICK_CONTROLS_MATERIAL_VARIANT := 'dense'

#####      #####
##### Names #####
#####      #####

NAME_APPLICATION := 'myapp'
NAME_DIRECTORY_BUILD := 'build'
NAME_DIRECTORY_BUILD_HELPERS := 'build-aux'
NAME_DIRECTORY_DATA := 'data'
NAME_DIRECTORY_I18N := 'i18n'
NAME_DIRECTORY_PY_SOURCES := 'myapp'
NAME_DIRECTORY_PY_TESTS := 'test'
NAME_DIRECTORY_QML_SOURCES := 'qml'
NAME_DIRECTORY_QML_TESTS := 'qml'
NAME_FILE_MAIN_ENTRY := 'main.py'
NAME_FILE_GENERATED_RESOURCES := 'generated_resources.py'

#####                     #####
##### Existing Directories #####
#####                     #####

DIRECTORY_ROOT := invocation_directory()
DIRECTORY_BUILD_HELPERS := DIRECTORY_ROOT + '/' + NAME_DIRECTORY_BUILD_HELPERS
DIRECTORY_DATA := DIRECTORY_ROOT + '/' + NAME_DIRECTORY_DATA
DIRECTORY_I18N := DIRECTORY_ROOT + '/' + NAME_DIRECTORY_I18N
DIRECTORY_PY_SOURCES := DIRECTORY_ROOT + '/' + NAME_DIRECTORY_PY_SOURCES
DIRECTORY_PY_TESTS := DIRECTORY_ROOT + '/' + NAME_DIRECTORY_PY_TESTS
DIRECTORY_QML_SOURCES := DIRECTORY_ROOT + '/' + NAME_DIRECTORY_QML_SOURCES
DIRECTORY_QML_TESTS := DIRECTORY_ROOT + '/' + NAME_DIRECTORY_QML_TESTS

#####               #####
##### Existing Files #####
#####               #####

FILE_APP_ENTRY := DIRECTORY_ROOT + '/' + NAME_FILE_MAIN_ENTRY

#####                      #####
##### Generated Directories #####
#####                      #####

DIRECTORY_BUILD := DIRECTORY_ROOT + '/' + NAME_DIRECTORY_BUILD
DIRECTORY_BUILD_QRC_QML := DIRECTORY_BUILD + '/qrc-' + NAME_DIRECTORY_QML_SOURCES
DIRECTORY_BUILD_QRC_DATA := DIRECTORY_BUILD + '/qrc-' + NAME_DIRECTORY_DATA
DIRECTORY_BUILD_QRC_I18N := DIRECTORY_BUILD + '/qrc-' + NAME_DIRECTORY_I18N
DIRECTORY_BUILD_TRANSLATIONS := DIRECTORY_BUILD + '/translations'
DIRECTORY_BUILD_RESOURCES := DIRECTORY_BUILD + '/resources'
DIRECTORY_BUILD_RELEASE := DIRECTORY_BUILD + '/release'
DIRECTORY_BUILD_PY := DIRECTORY_BUILD_RELEASE + '/' + NAME_DIRECTORY_PY_SOURCES

#####                #####
##### Generated Files #####
#####                #####

FILE_BUILD_QRC_QML := DIRECTORY_BUILD_QRC_QML + '/' + NAME_DIRECTORY_QML_SOURCES + '.qrc'
FILE_BUILD_QRC_DATA := DIRECTORY_BUILD_QRC_DATA + '/' + NAME_DIRECTORY_DATA + '.qrc'
FILE_BUILD_QRC_I18N := DIRECTORY_BUILD_QRC_I18N + '/' + NAME_DIRECTORY_I18N + '.qrc'
FILE_BUILD_QRC_I18N_JSON := DIRECTORY_BUILD_QRC_I18N + '/' + NAME_APPLICATION + '.json'
FILE_BUILD_TRANSLATIONS_JSON := DIRECTORY_BUILD_TRANSLATIONS + '/' + NAME_APPLICATION + '.json'
FILE_BUILD_RESOURCES := DIRECTORY_BUILD_RESOURCES + '/' + NAME_FILE_GENERATED_RESOURCES
FILE_PY_SOURCES_RESOURCES := DIRECTORY_PY_SOURCES + '/' + NAME_FILE_GENERATED_RESOURCES
FILE_PY_TEST_RESOURCES := DIRECTORY_PY_TESTS + '/' + NAME_FILE_GENERATED_RESOURCES

# Build full project into build/release
build: _check-pyside-setup _clean-build _clean-develop _compile-resources
    @rm -rf \
        {{ DIRECTORY_BUILD_PY }}
    @mkdir -p \
        {{ DIRECTORY_BUILD_PY }}
    @cp -r \
        {{ DIRECTORY_PY_SOURCES }}/. \
        {{ DIRECTORY_BUILD_PY }}
    @cp \
        {{ FILE_BUILD_RESOURCES }} \
        {{ DIRECTORY_BUILD_PY }}
    @cp \
        {{ FILE_APP_ENTRY }} \
        {{ DIRECTORY_BUILD_RELEASE }}
    @echo ''; \
        echo 'Please find the finished project in {{ DIRECTORY_BUILD_RELEASE }}'

# Run Python and QML tests
test: test-python test-qml

# Run Python tests
test-python: _check-pyside-setup _clean-test _compile-resources
    @cp \
      {{ FILE_BUILD_RESOURCES }} \
      {{ FILE_PY_TEST_RESOURCES }}
    @{{ PYTHON }} -m \
    pytest test

# Run QML tests
test-qml: _check-qml-setup
    @{{ TOOL_CLI_QML_TESTRUNNER }} \
        -silent \
        -input {{ DIRECTORY_QML_TESTS }}

# Build and compile resources into source directory
build-develop: _check-pyside-setup _clean-develop _compile-resources
    @# Generates resources and copies them into the source directory
    @# This allows to develop/debug the project normally

    @cp \
    	{{ FILE_BUILD_RESOURCES }} {{ DIRECTORY_PY_SOURCES }}

# Update *.ts files by traversing the source code
update-translations: _check-pyside-setup _clean-develop _prepare-translation-extractions
    @# Traverses *.qml and *.py files to update translation files
    @# Requires translations in .py:   QCoreApplication.translate("context", "string")
    @# Requires translations in .qml:  qsTranslate("context", "string")

    @cd {{ DIRECTORY_BUILD_TRANSLATIONS }}; \
    	{{ TOOL_CLI_LUPDATE }} \
    		-locations none \
    		-project {{ FILE_BUILD_TRANSLATIONS_JSON }}
    @cp -r \
    	{{ DIRECTORY_BUILD_TRANSLATIONS }}/{{ NAME_DIRECTORY_I18N }}/*.ts \
    	{{ DIRECTORY_I18N }}

# Add new language
add-translation locale: _check-pyside-setup _prepare-translation-extractions
    @cd {{ DIRECTORY_BUILD_TRANSLATIONS }}; \
        {{ TOOL_CLI_LUPDATE }} \
            -verbose \
            -source-language en_US \
            -target-language {{ locale }} \
            -ts {{ DIRECTORY_I18N }}/{{ locale }}.ts
    @echo ''
    @just update-translations

# Remove ALL generated files
clean: _clean-build _clean-develop _clean-test

_clean-build:
    @rm -rf \
    	{{ DIRECTORY_BUILD }}

_clean-develop:
    @rm -rf \
    	{{ FILE_PY_SOURCES_RESOURCES }}

_clean-test:
    @rm -rf \
    	{{ FILE_PY_TEST_RESOURCES }}

_check-pyside-setup:
    @which {{ PYTHON }}
    @which {{ TOOL_CLI_LUPDATE }}
    @which {{ TOOL_CLI_LRELEASE }}
    @which {{ TOOL_CLI_RCC }}
    @echo ''

_check-qml-setup:
    @which {{ TOOL_CLI_QML_TESTRUNNER }}
    @echo ''

_compile-resources: _generate-qrc-data _generate-qrc-i18n _generate-qrc-qml
    @rm -rf \
    	{{ DIRECTORY_BUILD_RESOURCES }}
    @mkdir -p \
     	{{ DIRECTORY_BUILD_RESOURCES }}
    @cp -r \
    	{{ DIRECTORY_BUILD_QRC_QML }}/. \
     	{{ DIRECTORY_BUILD_QRC_DATA }}/. \
     	{{ DIRECTORY_BUILD_QRC_I18N }}/. \
     	{{ DIRECTORY_BUILD_RESOURCES }}
    @{{ TOOL_CLI_RCC }} \
    	{{ DIRECTORY_BUILD_RESOURCES }}/{{ NAME_DIRECTORY_DATA }}.qrc \
    	{{ DIRECTORY_BUILD_RESOURCES }}/{{ NAME_DIRECTORY_I18N }}.qrc \
    	{{ DIRECTORY_BUILD_RESOURCES }}/{{ NAME_DIRECTORY_QML_SOURCES }}.qrc \
    	-o {{ FILE_BUILD_RESOURCES }}

_generate-qrc-data:
    @rm -rf \
    	{{ DIRECTORY_BUILD_QRC_DATA }}
    @mkdir -p \
    	{{ DIRECTORY_BUILD_QRC_DATA }}
    @cp -r \
    	{{ DIRECTORY_DATA }} \
    	{{ DIRECTORY_BUILD_QRC_DATA }}
    @cd \
    	{{ DIRECTORY_BUILD_QRC_DATA }}/{{ NAME_DIRECTORY_DATA }}; \
    		{{ TOOL_CLI_RCC }} \
    			--project | sed 's,<file>./,<file>{{ NAME_DIRECTORY_DATA }}/,' > {{ FILE_BUILD_QRC_DATA }}

_generate-qrc-i18n:
    @rm -rf \
    	{{ DIRECTORY_BUILD_QRC_I18N }}
    @mkdir -p \
    	{{ DIRECTORY_BUILD_QRC_I18N }}
    @cp -r \
    	{{ DIRECTORY_I18N }} {{ DIRECTORY_BUILD_QRC_I18N }}
    @{{ DIRECTORY_BUILD_HELPERS }}/generate-lupdate-project-file.py \
    	--relative-to {{ DIRECTORY_BUILD_QRC_I18N }} \
    	--out-file {{ FILE_BUILD_QRC_I18N_JSON }}
    @cd \
    	{{ DIRECTORY_BUILD_QRC_I18N }}; \
    		{{ TOOL_CLI_LRELEASE }} \
    			-project {{ FILE_BUILD_QRC_I18N_JSON }}
    @cd \
    	{{ DIRECTORY_BUILD_QRC_I18N }}/{{ NAME_DIRECTORY_I18N }}; \
    		rm \
    			{{ FILE_BUILD_QRC_I18N_JSON }} \
    			*.ts
    @cd \
    	{{ DIRECTORY_BUILD_QRC_I18N }}/{{ NAME_DIRECTORY_I18N }}; \
    		{{ TOOL_CLI_RCC }} \
    			--project | sed 's,<file>./,<file>{{ NAME_DIRECTORY_I18N }}/,' > {{ FILE_BUILD_QRC_I18N }}

_generate-qrc-qml:
    @rm -rf \
    	{{ DIRECTORY_BUILD_QRC_QML }}
    @mkdir -p \
    	{{ DIRECTORY_BUILD_QRC_QML }}
    @cp -r \
    	{{ DIRECTORY_QML_SOURCES }} \
    	{{ DIRECTORY_BUILD_QRC_QML }}
    @cd \
    	{{ DIRECTORY_BUILD_QRC_QML }}/{{ NAME_DIRECTORY_QML_SOURCES }}; \
    		{{ TOOL_CLI_RCC }} \
    			--project | sed 's,<file>./,<file>{{ NAME_DIRECTORY_QML_SOURCES }}/,' > {{ FILE_BUILD_QRC_QML }}

_prepare-translation-extractions:
    @rm -rf \
    	{{ DIRECTORY_BUILD_TRANSLATIONS }}
    @mkdir -p \
    	{{ DIRECTORY_BUILD_TRANSLATIONS }}
    @cp -r \
    	{{ DIRECTORY_I18N }} \
    	{{ DIRECTORY_PY_SOURCES }} \
    	{{ DIRECTORY_QML_SOURCES }} \
    	{{ DIRECTORY_BUILD_TRANSLATIONS }}
    @{{ DIRECTORY_BUILD_HELPERS }}/generate-lupdate-project-file.py \
    	--relative-to {{ DIRECTORY_BUILD_TRANSLATIONS }} \
    	--out-file {{ FILE_BUILD_TRANSLATIONS_JSON }}
