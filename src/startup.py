# SPDX-FileCopyrightText: <Your Name>
#
# SPDX-License-Identifier: GPL-3.0-or-later

import os
import sys


class StartUp:

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
        import src.viewmodels  # noqa: F401

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
