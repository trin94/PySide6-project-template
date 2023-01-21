# Copyright 2023
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



MAKE_FILE:= $(lastword $(MAKEFILE_LIST))
SHELL:=/bin/bash
PYTHON:=$(shell type -p python3 || echo python)

#####       #####
##### Names #####
#####       #####
NAME_APPLICATION=myapp

NAME_DIRECTORY_BUILD=build

NAME_DIRECTORY_BUILD_HELPERS=build-aux
NAME_DIRECTORY_DATA=data
NAME_DIRECTORY_I18N=i18n
NAME_DIRECTORY_PY_SOURCES=myapp
NAME_DIRECTORY_PY_TESTS=test
NAME_DIRECTORY_QML_SOURCES=qml
NAME_DIRECTORY_QML_TESTS=qml

NAME_FILE_MAIN_ENTRY=main.py
NAME_FILE_GENERATED_RESOURCES=generated_resources.py


#####       #####
##### Tools #####
#####       #####
TOOL_CLI_LUPDATE=pyside6-lupdate
TOOL_CLI_LRELEASE=pyside6-lrelease
TOOL_CLI_RCC=pyside6-rcc
TOOL_CLI_QML_TESTRUNNER=qmltestrunner


#####                      #####
##### Existing Directories #####
#####                      #####
DIRECTORY_ROOT:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
DIRECTORY_BUILD_HELPERS=${DIRECTORY_ROOT}/${NAME_DIRECTORY_BUILD_HELPERS}
DIRECTORY_DATA=${DIRECTORY_ROOT}/${NAME_DIRECTORY_DATA}
DIRECTORY_I18N=${DIRECTORY_ROOT}/${NAME_DIRECTORY_I18N}
DIRECTORY_PY_SOURCES=${DIRECTORY_ROOT}/${NAME_DIRECTORY_PY_SOURCES}
DIRECTORY_PY_TESTS=${DIRECTORY_ROOT}/${NAME_DIRECTORY_PY_TESTS}
DIRECTORY_QML_SOURCES=${DIRECTORY_ROOT}/${NAME_DIRECTORY_QML_SOURCES}
DIRECTORY_QML_TESTS=${DIRECTORY_ROOT}/${NAME_DIRECTORY_QML_TESTS}


#####                #####
##### Existing Files #####
#####                #####
FILE_APP_ENTRY=${DIRECTORY_ROOT}/${NAME_FILE_MAIN_ENTRY}


#####                       #####
##### Generated Directories #####
#####                       #####
DIRECTORY_BUILD=${DIRECTORY_ROOT}/${NAME_DIRECTORY_BUILD}
DIRECTORY_BUILD_QRC_QML=${DIRECTORY_BUILD}/qrc-${NAME_DIRECTORY_QML_SOURCES}
DIRECTORY_BUILD_QRC_DATA=${DIRECTORY_BUILD}/qrc-${NAME_DIRECTORY_DATA}
DIRECTORY_BUILD_QRC_I18N=${DIRECTORY_BUILD}/qrc-${NAME_DIRECTORY_I18N}
DIRECTORY_BUILD_TRANSLATIONS=${DIRECTORY_BUILD}/translations
DIRECTORY_BUILD_RESOURCES=${DIRECTORY_BUILD}/resources
DIRECTORY_BUILD_RELEASE=${DIRECTORY_BUILD}/release
DIRECTORY_BUILD_PY=${DIRECTORY_BUILD_RELEASE}/${NAME_DIRECTORY_PY_SOURCES}


#####                 #####
##### Generated Files #####
#####                 #####
FILE_BUILD_QRC_QML=${DIRECTORY_BUILD_QRC_QML}/${NAME_DIRECTORY_QML_SOURCES}.qrc
FILE_BUILD_QRC_DATA=${DIRECTORY_BUILD_QRC_DATA}/${NAME_DIRECTORY_DATA}.qrc
FILE_BUILD_QRC_I18N=${DIRECTORY_BUILD_QRC_I18N}/${NAME_DIRECTORY_I18N}.qrc
FILE_BUILD_QRC_I18N_JSON=${DIRECTORY_BUILD_QRC_I18N}/${NAME_APPLICATION}.json
FILE_BUILD_TRANSLATIONS_JSON=${DIRECTORY_BUILD_TRANSLATIONS}/${NAME_APPLICATION}.json
FILE_BUILD_RESOURCES=${DIRECTORY_BUILD_RESOURCES}/${NAME_FILE_GENERATED_RESOURCES}

FILE_PY_SOURCES_RESOURCES=${DIRECTORY_PY_SOURCES}/${NAME_FILE_GENERATED_RESOURCES}
FILE_PY_TEST_RESOURCES=${DIRECTORY_PY_TESTS}/${NAME_FILE_GENERATED_RESOURCES}


#####                 #####
##### Build commands  #####
#####                 #####
build: \
	check-pyside-setup \
	build-clean \
	develop-clean \
	compile-resources \

	@# Builds the project into ${DIRECTORY_BUILD_RELEASE}

	@rm -rf \
		${DIRECTORY_BUILD_PY}
	@mkdir -p \
		${DIRECTORY_BUILD_PY}
	@cp -r \
		${DIRECTORY_PY_SOURCES}/. \
		${DIRECTORY_BUILD_PY}
	@cp \
		${FILE_BUILD_RESOURCES} \
		${DIRECTORY_BUILD_PY}
	@cp \
		${FILE_APP_ENTRY} \
		${DIRECTORY_BUILD_RELEASE}
	@echo ''; \
		echo 'Please find the finished project in ${DIRECTORY_BUILD_RELEASE}'


build-clean:
	@# Cleans up the build directory

	@rm -rf \
		${DIRECTORY_BUILD}


test: \
	test-python \
	test-qml


test-python: \
	check-pyside-setup \
	prepare-test

	@${PYTHON} -m \
		pytest test


test-qml: \
	check-qml-setup

	@${TOOL_CLI_QML_TESTRUNNER} \
		-input ${DIRECTORY_QML_TESTS}


test-clean:
	@# Cleans up the compiled resources in the test directory

	@rm -rf \
		${FILE_PY_TEST_RESOURCES}


develop-build: \
	check-pyside-setup \
	develop-clean \
	compile-resources

	@# Generates resources and copies them into the source directory
	@# This allows to develop/debug the project normally

	@cp \
		${FILE_BUILD_RESOURCES} ${DIRECTORY_PY_SOURCES}


develop-clean:
	@# Cleans up the compiled resources in the source directory

	@rm -rf \
		${FILE_PY_SOURCES_RESOURCES}


update-translations: \
	check-pyside-setup \
	xtask-prepare-translation-extractions

	@# Traverses *.qml and *.py files to update translation files
	@# Requires translations in .py:   QCoreApplication.translate("context", "string")
	@# Requires translations in .qml:  qsTranslate("context", "string")

	@cd ${DIRECTORY_BUILD_TRANSLATIONS}; \
		${TOOL_CLI_LUPDATE} \
			-locations none \
			-project ${FILE_BUILD_TRANSLATIONS_JSON}
	@cp -r \
		${DIRECTORY_BUILD_TRANSLATIONS}/${NAME_DIRECTORY_I18N}/*.ts \
		${DIRECTORY_I18N}


create-new-translation: \
	check-pyside-setup \
	xtask-prepare-translation-extractions

	@# Allows to add translations to the project: make create-new-translation lang=<locale>

ifeq ($(lang), $(''))
	@echo "Usage: 'make create-new-translation lang=<locale>'"
else
	@cd ${DIRECTORY_BUILD_TRANSLATIONS}; \
		${TOOL_CLI_LUPDATE} \
			-verbose \
			-source-language en \
			-target-language $(lang) \
			-ts ${DIRECTORY_I18N}/$(lang).ts
	@$(MAKE) -s -f $(MAKE_FILE) update-translations
endif


clean: \
	build-clean \
	develop-clean \
	test-clean

	@# Cleans up all generated files


#####                       #####
##### Build helper commands #####
#####                       #####
check-pyside-setup:

	@which ${PYTHON}
	@which ${TOOL_CLI_LUPDATE}
	@which ${TOOL_CLI_LRELEASE}
	@which ${TOOL_CLI_RCC}
	@echo ''


check-qml-setup:

	@which ${TOOL_CLI_QML_TESTRUNNER}
	@echo ''


prepare-test: \
	test-clean \
	compile-resources

	@cp \
		${FILE_BUILD_RESOURCES} \
		${FILE_PY_TEST_RESOURCES}


compile-resources: \
	xtask-generate-qrc-data \
	xtask-generate-qrc-i18n \
	xtask-generate-qrc-qml

	@rm -rf \
		${DIRECTORY_BUILD_RESOURCES}
	@mkdir -p \
	 	${DIRECTORY_BUILD_RESOURCES}
	@cp -r \
		${DIRECTORY_BUILD_QRC_QML}/. \
	 	${DIRECTORY_BUILD_QRC_DATA}/. \
	 	${DIRECTORY_BUILD_QRC_I18N}/. \
	 	${DIRECTORY_BUILD_RESOURCES}
	@${TOOL_CLI_RCC} \
		${DIRECTORY_BUILD_RESOURCES}/${NAME_DIRECTORY_DATA}.qrc \
		${DIRECTORY_BUILD_RESOURCES}/${NAME_DIRECTORY_I18N}.qrc \
		${DIRECTORY_BUILD_RESOURCES}/${NAME_DIRECTORY_QML_SOURCES}.qrc \
		-o ${FILE_BUILD_RESOURCES}


xtask-generate-qrc-data:
	@rm -rf \
		${DIRECTORY_BUILD_QRC_DATA}
	@mkdir -p \
		${DIRECTORY_BUILD_QRC_DATA}
	@cp -r \
		${DIRECTORY_DATA} \
		${DIRECTORY_BUILD_QRC_DATA}
	@cd \
		${DIRECTORY_BUILD_QRC_DATA}/${NAME_DIRECTORY_DATA}; \
			${TOOL_CLI_RCC} \
				--project | sed 's,<file>./,<file>${NAME_DIRECTORY_DATA}/,' > ${FILE_BUILD_QRC_DATA}


xtask-generate-qrc-i18n:
	@rm -rf \
		${DIRECTORY_BUILD_QRC_I18N}
	@mkdir -p \
		${DIRECTORY_BUILD_QRC_I18N}
	@cp -r \
		${DIRECTORY_I18N} ${DIRECTORY_BUILD_QRC_I18N}
	@${DIRECTORY_BUILD_HELPERS}/generate-lupdate-project-file.py \
		--relative-to ${DIRECTORY_BUILD_QRC_I18N} \
		--out-file ${FILE_BUILD_QRC_I18N_JSON}
	@cd \
		${DIRECTORY_BUILD_QRC_I18N}; \
			${TOOL_CLI_LRELEASE} \
				-project ${FILE_BUILD_QRC_I18N_JSON}
	@cd \
		${DIRECTORY_BUILD_QRC_I18N}/${NAME_DIRECTORY_I18N}; \
			rm \
				${FILE_BUILD_QRC_I18N_JSON} \
				*.ts
	@cd \
		${DIRECTORY_BUILD_QRC_I18N}/${NAME_DIRECTORY_I18N}; \
			${TOOL_CLI_RCC} \
				--project | sed 's,<file>./,<file>${NAME_DIRECTORY_I18N}/,' > ${FILE_BUILD_QRC_I18N}


xtask-generate-qrc-qml:
	@rm -rf \
		${DIRECTORY_BUILD_QRC_QML}
	@mkdir -p \
		${DIRECTORY_BUILD_QRC_QML}
	@cp -r \
		${DIRECTORY_QML_SOURCES} \
		${DIRECTORY_BUILD_QRC_QML}
	@cd \
		${DIRECTORY_BUILD_QRC_QML}/${NAME_DIRECTORY_QML_SOURCES}; \
			${TOOL_CLI_RCC} \
				--project | sed 's,<file>./,<file>${NAME_DIRECTORY_QML_SOURCES}/,' > ${FILE_BUILD_QRC_QML}


xtask-prepare-translation-extractions:
	@rm -rf \
		${DIRECTORY_BUILD_TRANSLATIONS}
	@mkdir -p \
		${DIRECTORY_BUILD_TRANSLATIONS}
	@cp -r \
		${DIRECTORY_I18N} \
		${DIRECTORY_PY_SOURCES} \
		${DIRECTORY_QML_SOURCES} \
		${DIRECTORY_BUILD_TRANSLATIONS}
	@${DIRECTORY_BUILD_HELPERS}/generate-lupdate-project-file.py \
		--relative-to ${DIRECTORY_BUILD_TRANSLATIONS} \
		--out-file ${FILE_BUILD_TRANSLATIONS_JSON}
