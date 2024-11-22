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


import ctypes.wintypes

import PySide6.QtCore
import win32api
import win32con
import win32gui

from .c_structures import MINMAXINFO, NCCALCSIZE_PARAMS


class WindowsEventFilter(PySide6.QtCore.QAbstractNativeEventFilter):
    def __init__(self, border_width=None) -> None:
        super().__init__()
        self.border_width = border_width
        self.monitor_info = None

    def nativeEventFilter(self, eventType, message):
        msg = ctypes.wintypes.MSG.from_address(message.__int__())

        if not msg.hWnd:
            return False, 0

        if msg.message == win32con.WM_NCHITTEST and (self.border_width is not None):

            x, y, w, h = self.get_window_size(msg.hWnd)
            x_pos = (win32api.LOWORD(msg.lParam) - x) % 65536
            y_pos = win32api.HIWORD(msg.lParam) - y

            lx = x_pos < self.border_width
            rx = x_pos + 9 > w - self.border_width
            ty = y_pos < self.border_width
            by = y_pos > h - self.border_width

            if lx and ty:
                return True, win32con.HTTOPLEFT
            elif rx and by:
                return True, win32con.HTBOTTOMRIGHT
            elif rx and ty:
                return True, win32con.HTTOPRIGHT
            elif lx and by:
                return True, win32con.HTBOTTOMLEFT
            elif ty:
                return True, win32con.HTTOP
            elif by:
                return True, win32con.HTBOTTOM
            elif lx:
                return True, win32con.HTLEFT
            elif rx:
                return True, win32con.HTRIGHT
        elif msg.message == win32con.WM_NCCALCSIZE:
            if self.isWindowMaximized(msg.hWnd):
                self.monitorNCCALCSIZE(msg)
            return True, 0
        elif msg.message == win32con.WM_GETMINMAXINFO:
            if self.isWindowMaximized(msg.hWnd):
                window_rect = win32gui.GetWindowRect(msg.hWnd)
                if not window_rect:
                    return False, 0

                # get the monitor handle
                monitor = win32api.MonitorFromRect(window_rect)
                if not monitor:
                    return False, 0

                # get the monitor info
                self.monitor_info = win32api.GetMonitorInfo(monitor)
                monitor_rect = self.monitor_info["Monitor"]
                work_area = self.monitor_info["Work"]

                # convert lParam to MINMAXINFO pointer
                info = ctypes.cast(msg.lParam, ctypes.POINTER(MINMAXINFO)).contents

                # adjust the size of window
                info.ptMaxSize.x = work_area[2] - work_area[0]
                info.ptMaxSize.y = work_area[3] - work_area[1]
                info.ptMaxTrackSize.x = info.ptMaxSize.x
                info.ptMaxTrackSize.y = info.ptMaxSize.y

                # modify the upper left coordinate
                info.ptMaxPosition.x = abs(window_rect[0] - monitor_rect[0])
                info.ptMaxPosition.y = abs(window_rect[1] - monitor_rect[1])
                return True, 1
        return False, 0

    @classmethod
    def get_window_size(cls, hwnd):
        left, top, right, bottom = win32gui.GetWindowRect(hwnd)

        width = right - left
        height = bottom - top
        return left, top, width, height

    def monitorNCCALCSIZE(self, msg: ctypes.wintypes.MSG):
        monitor = win32api.MonitorFromWindow(msg.hWnd)
        if monitor is None and not self.monitor_info:
            return
        elif monitor is not None:
            self.monitor_info = win32api.GetMonitorInfo(monitor)
        params = ctypes.cast(msg.lParam,
                             ctypes.POINTER(NCCALCSIZE_PARAMS)).contents
        params.rgrc[0].left = self.monitor_info["Work"][0]
        params.rgrc[0].top = self.monitor_info["Work"][1]
        params.rgrc[0].right = self.monitor_info["Work"][2]
        params.rgrc[0].bottom = self.monitor_info["Work"][3]

    @classmethod
    def isWindowMaximized(cls, hwnd) -> bool:
        windowPlacement = win32gui.GetWindowPlacement(hwnd)
        if not windowPlacement:
            return False
        return windowPlacement[1] == win32con.SW_MAXIMIZE
