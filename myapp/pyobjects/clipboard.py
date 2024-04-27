from PySide6.QtCore import Slot, QObject
from PySide6.QtGui import QClipboard
from PySide6.QtQml import QmlElement

QML_IMPORT_NAME = "pyobjects"
QML_IMPORT_MAJOR_VERSION = 1


@QmlElement
class MyClipboardPyObject(QObject):
    def __init__(self):
        super().__init__()
        self._clipboard = QClipboard()

    @Slot(str)
    def copy_to_clipboard(self, text: str) -> None:
        self._clipboard.setText(text)
