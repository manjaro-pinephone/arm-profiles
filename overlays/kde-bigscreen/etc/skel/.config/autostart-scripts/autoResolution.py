#!/usr/bin/python3

import sys
import os
import json
import time
import subprocess
import dbus
from PyQt5 import QtCore, QtDBus

class AutoResolution():

    def __init__(self):
        self.item = "org.kde.KScreen"
        self.path = "/backend"
        self.interface = "org.kde.kscreen.Backend"
        self.logFilePath = "/tmp/logresolution.txt"
        self.supportedDisplayModeList = []
        self.supportedDisplayModeList.clear()
        #self.check_if_target_reached() - does not currently work
        self.get_x_supported_modes()

    def check_if_target_reached(self):
        logFile = open('/tmp/resolutionTarget.txt', 'a')
        try:
            target_service = subprocess.check_output(["systemctl", "status", "graphical.target"])
            target_output = target_service.decode("utf-8")
        except subprocess.CalledProcessError as e:
            target_output = e.output.decode("utf-8")

        target_out_split = target_output.split("\n")
        target_extract_active = target_out_split[2].split(" ")
        target_isActive = target_extract_active[4]
        if target_isActive == "active":
            print("Got Active Target", file=logFile)
            logFile.close()
            self.get_session_type()
        else:
            print("Active Target Not Reached", file=logFile)
            time.sleep(5)
            self.check_if_target_reached()

    def get_session_type(self):
        logFile2 = open('/tmp/sessionType.txt', 'a')
        print("In Get Session Type", file=logFile2)
        try:
            sessionType = subprocess.check_output(["echo", "-n", os.environ["XDG_SESSION_TYPE"]]).decode("utf-8")
        except subprocess.CalledProcessError as e:
            print(e.output.decode("utf-8"), file=logFile2)
        print(sessionType, file=logFile2)
        if sessionType == "wayland":
            print("found wayland", file=logFile2)
            self.get_wayland_supported_modes()
        else:
            print("found x", file=logFile2)
            self.get_x_supported_modes()

    def get_session_type_xrandr(self):
        # Try fetching session type even earlier than graphical target
        get_session = subprocess.check_output(["xrandr"])
        get_output = get_session.decode("utf-8")
        get_output_string = get_output.split("\n")
        get_output_string_split = get_output_string[2].split(" ")
        sessionType = get_output_string_split[0]
        if sessionType == "XWAYLAND0":
            print("found wayland", file=logFile2)
            self.get_wayland_supported_modes()
        else:
            print("found x", file=logFile2)
            self.get_x_supported_modes()

    def get_session_type_dbus(self):
        # Requires watch on dbus-org.freedesktop.login1 service
        bus = dbus.SystemBus()
        sesObj = bus.get_object('org.freedesktop.login1', '/org/freedesktop/login1/session/self')
        iface = dbus.Interface(sesObj, dbus_interface="org.freedesktop.DBus.Properties")
        iface_m = iface.get_dbus_method("Get", dbus_interface=None)
        sessionType = iface_m("org.freedesktop.login1.Session", "Type")
        print(sessionType)
        if sessionType == "wayland":
            print("found wayland", file=logFile2)
            self.get_wayland_supported_modes()
        else:
            print("found x", file=logFile2)
            self.get_x_supported_modes()

    def get_x_supported_modes(self):
        bus = QtDBus.QDBusConnection.sessionBus()
        kscreenObject = QtDBus.QDBusInterface(self.item, self.path, self.interface, bus)
        results = kscreenObject.call("getConfig").arguments()
        for x in results[0]['outputs']:
            if x['type'] == 6.0:
               displayID = results[0]['outputs'][0]['id']
               displayWidth = results[0]['outputs'][0]['size']['width']
               displayHeight = results[0]['outputs'][0]['size']['height']
               displayPrefMode = results[0]['outputs'][0]['preferredModes']
               displayModes = results[0]['outputs'][0]['modes']
               for modes in displayModes:
                   if modes['size']['width'] == 1920 and modes['size']['height'] == 1080:
                       self.supportedDisplayModeList.append(modes)
               self.set_display_size(displayID, displayWidth, displayHeight)

    def get_wayland_supported_modes(self):
        logFileWayland = open('/tmp/setWaylandResolution.txt', 'a')
        print("In Get Wayland Supported Modes", file=logFileWayland)
        try:
            waylandSessionObject = subprocess.check_output(["kscreen-doctor", "-o", "-j"]).decode("utf-8")
            print(waylandSessionObject, file=logFileWayland)
        except subprocess.CalledProcessError as e:
            print(e.output, file=logFileWayland)
        begin, end = waylandSessionObject.find('{'), waylandSessionObject.rfind('}')
        filtered_waylandSessionObject = waylandSessionObject[begin: end+1]
        print(filtered_waylandSessionObject, file=logFileWayland)
        results = json.loads(filtered_waylandSessionObject)
        for x in results['outputs']:
            if x['type'] == 6.0:
               displayID = results['outputs'][0]['id']
               displayWidth = results['screen']['currentSize']['width']
               displayHeight = results['screen']['currentSize']['height']
               displayModes = results['outputs'][0]['modes']
               for modes in displayModes:
                   if modes['size']['width'] == 1920 and modes['size']['height'] == 1080:
                       self.supportedDisplayModeList.append(modes)
                       print(modes, file=logFileWayland)
               self.set_display_size(displayID, displayWidth, displayHeight)

    def set_display_size(self, displayId, displayWidth, displayHeight):
        if displayHeight > 1080 and displayWidth > 1920:
           setDisplayMode = self.supportedDisplayModeList[0]['id']
           setDisplayId = int(displayId)
           setDisplayArgs = "output.{0}.mode.{1}".format(setDisplayId, setDisplayMode)
           setDisplayConfig = subprocess.call(["kscreen-doctor", setDisplayArgs])
           bus = dbus.SessionBus()
           remote_object = bus.get_object("org.kde.bigscreen", "/Plugin")
           remote_object.autoResolutionChanged(dbus_interface = "org.kde.bigscreen")

autoResolution = AutoResolution()
