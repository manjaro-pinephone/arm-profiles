#!/usr/bin/python3

import cec
import uinput
import time
import psutil

u = uinput

KEYMAP = {
   0: u.KEY_ENTER,
   1: u.KEY_UP,
   2: u.KEY_DOWN,
   3: u.KEY_LEFT,
   4: u.KEY_RIGHT,
   9: u.KEY_HOMEPAGE,
  10: u.KEY_MENU,
  13: u.KEY_BACK,
  44: u.KEY_HOMEPAGE,
  68: u.KEY_PLAY,
  69: u.KEY_STOP,
  70: u.KEY_PAUSE,
  75: u.KEY_FASTFORWARD,
  76: u.KEY_REWIND,
 103: u.KEY_HOMEPAGE,
 113: u.KEY_BLUE,
 114: u.KEY_RED,
 115: u.KEY_YELLOW,
 116: u.KEY_GREEN
}

cec.init()
device = uinput.Device(KEYMAP.values())

print("Ready")
keystate = None
override = False

def check_override():
    global override
    if "kodi-x11" in (p.name() for p in psutil.process_iter()):
        override = True
    else:
        override = False

def onkey(event, key, state):
    assert event == 2
    global keystate
    global override
    check_override()
    if state == 0 and keystate is None:
        print("Got Key", key, "state", state)
        keystate = "down"
        if not override:
            device.emit(KEYMAP[key], 1)

    if state > 0:
        if keystate is None:
           print("Got key", key, "state", state)
           if not override:
               device.emit(KEYMAP[key], 1)

        print("Key {0} up after {1}".format(key, state))
        if not override:
            device.emit(KEYMAP[key], 0)
            keystate = None

cec.add_callback(onkey, cec.EVENT_KEYPRESS)

while True:
    time.sleep(9e9)
