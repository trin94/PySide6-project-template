# Copyright
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


import os
import sys


class StartUp:
    """Necessary steps for environment, Python and Qt"""

    @staticmethod
    def configure_qt_application_data():
        from PySide6.QtCore import QCoreApplication
        QCoreApplication.setApplicationName("my app name")
        QCoreApplication.setOrganizationName("my org name")
        QCoreApplication.setApplicationVersion("my app version")

    @staticmethod
    def configure_environment_variables():
        # Qt expects "qtquickcontrols2.conf" at root level, but the way we handle resources does not allow that.
        # So we need to override the path here
        os.environ["QT_QUICK_CONTROLS_CONF"] = ":/data/qtquickcontrols2.conf"

    @staticmethod
    def import_bindings():
        import src.pyobjects  # noqa: F401

    @staticmethod
    def start_application():
        from src.application import MyApplication
        app = MyApplication(sys.argv)

        app.set_window_icon()
        app.set_up_signals()
        app.set_up_window_event_filter()
        app.start_engine()
        app.set_up_window_effects()
        app.verify()

        sys.exit(app.exec())


def perform_startup():
    we = StartUp()

    we.configure_qt_application_data()
    we.configure_environment_variables()
    we.import_bindings()

    we.start_application()
