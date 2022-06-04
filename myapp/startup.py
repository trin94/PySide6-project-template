# MIT
#
# Copyright (c) 2022
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import os
import sys


class PreStartUp:
    """Necessary steps for environment, Python and Qt"""

    @staticmethod
    def set_qt_application_name():
        from PySide6.QtCore import QCoreApplication
        QCoreApplication.setApplicationName('my app name')
        QCoreApplication.setOrganizationName('my org name')

    @staticmethod
    def set_qt_application_version():
        from PySide6.QtCore import QCoreApplication
        QCoreApplication.setApplicationVersion('my app version')

    @staticmethod
    def prepare_dependency_injection():
        from myapp.injections import configure_injections
        configure_injections()

    @staticmethod
    def inject_environment_variables():
        # Qt expects 'qtquickcontrols2.conf' at root level, but the way we handle resources does not allow that.
        # So we need to override the path here
        os.environ['QT_QUICK_CONTROLS_CONF'] = ':/data/qtquickcontrols2.conf'


class StartUp:
    """Necessary steps for myapp"""

    @staticmethod
    def import_resources():
        try:
            import myapp.generated_resources
        except ImportError as e:
            print(e, file=sys.stderr)
            sys.exit(1)

    @staticmethod
    def import_bindings():
        try:
            import myapp.pyobjects
        except ImportError as e:
            print(e, file=sys.stderr)
            sys.exit(1)

    @staticmethod
    def start_application():
        from myapp.application import MyApplication
        app = MyApplication(sys.argv)

        app.set_window_icon()
        app.set_up_internationalization()
        app.set_up_signals()
        app.set_up_imports()
        app.start_engine()
        app.verify()

        sys.exit(app.exec())


def perform_startup():
    we = PreStartUp()
    we.set_qt_application_name()
    we.set_qt_application_version()
    we.prepare_dependency_injection()
    we.inject_environment_variables()

    we = StartUp()
    we.import_resources()
    we.import_bindings()
    we.start_application()
