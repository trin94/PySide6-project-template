# Copyright
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, version 3.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.

# Inspired and based on:
#  - https://github.com/zhiyiYo/PyQt-Frameless-Window
#  - https://gitee.com/Virace/pyside6-qml-frameless-window/tree/main


from typing import Optional

from PySide6.QtCore import QCoreApplication, QEvent, QObject, Qt
from PySide6.QtGui import QCursor, QGuiApplication, QWindow


class LinuxEventFilter(QObject):

    def __init__(self, border_width=None) -> None:
        super().__init__()
        self.border_width = border_width

        self._app: QGuiApplication = QCoreApplication.instance()
        self._window: Optional[QWindow] = None

    def eventFilter(self, obj, event):
        if event.type() != QEvent.Type.MouseButtonPress and event.type() != QEvent.Type.MouseMove:
            return False

        if self._window is None:
            self._window = self._app.topLevelWindows()[0]

        pos = QCursor.pos() - self._window.position()
        edges = Qt.Edge(0)
        if pos.x() < self.border_width:
            edges |= Qt.Edge.LeftEdge
        if pos.x() >= self._window.width() - self.border_width:
            edges |= Qt.Edge.RightEdge
        if pos.y() < self.border_width:
            edges |= Qt.Edge.TopEdge
        if pos.y() >= self._window.height() - self.border_width:
            edges |= Qt.Edge.BottomEdge

        if event.type() == QEvent.Type.MouseMove and self._window.windowState() == Qt.WindowState.WindowNoState:
            if edges in (Qt.Edge.LeftEdge | Qt.Edge.TopEdge, Qt.Edge.RightEdge | Qt.Edge.BottomEdge):
                self._app.setOverrideCursor(Qt.CursorShape.SizeFDiagCursor)
            elif edges in (Qt.Edge.RightEdge | Qt.Edge.TopEdge, Qt.Edge.LeftEdge | Qt.Edge.BottomEdge):
                self._app.setOverrideCursor(Qt.CursorShape.SizeBDiagCursor)
            elif edges in (Qt.Edge.TopEdge, Qt.Edge.BottomEdge):
                self._app.setOverrideCursor(Qt.CursorShape.SizeVerCursor)
            elif edges in (Qt.Edge.LeftEdge, Qt.Edge.RightEdge):
                self._app.setOverrideCursor(Qt.CursorShape.SizeHorCursor)
            else:
                self._app.restoreOverrideCursor()

        if event.type() == QEvent.Type.MouseButtonPress and edges:
            self._window.startSystemResize(edges)
            return True

        return super().eventFilter(obj, event)
