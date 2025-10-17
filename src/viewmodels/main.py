# SPDX-FileCopyrightText: <Your Name>
#
# SPDX-License-Identifier: GPL-3.0-or-later

from PySide6.QtCore import Property, QObject, Signal, QTimer, QDateTime
from PySide6.QtQml import QmlElement

QML_IMPORT_NAME = "pyobjects"
QML_IMPORT_MAJOR_VERSION = 1


@QmlElement
class MyAppMainViewModel(QObject):
    timeChanged = Signal(str)

    def __init__(self):
        super().__init__()
        self._time = current_time()

        self._timer = QTimer()
        self._timer.timeout.connect(self._update_time)
        self._timer.setInterval(1000)
        self._timer.start()

    @Property(str, notify=timeChanged)
    def time(self) -> str:
        return self._time

    def _update_time(self):
        update_time = current_time()
        if self._time != update_time:
            self._time = update_time
            self.timeChanged.emit(update_time)


def current_time() -> str:
    return QDateTime.currentDateTime().toString("yyyy-MM-dd hh:mm:ss")
