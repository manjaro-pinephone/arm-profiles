# Manjaro ARM Sway Edition

Welcome to the Manjaro ARM Sway Edition. The following sections will give you an introduction to the default configuration. 
This configuration can be found in ```/etc/sway/```.

The directory hosts various configuration files of which the important ones are:

- ```/etc/sway/definitions```: host the global definitions such as the application launcher, terminal, the idle program, default and alternative modifier key, ...
- ```/etc/sway/config```: the default Sway configuration file. If you want to customize it, you should create a copy in ```$HOME/.config/sway``` and change it as needed.
- ```/etc/sway/config.d/99-autostart-applications```: contains all the programs that has to be started as soon as the Sway session initializes
- ```/etc/sway/themes/matcha```: the color configuration to match the matcha theme of Manjaro

## Basics

The default modifier key (**$mod**) is the Alt key.

Additionally, there are two kind of **movement key** sets:

- VIM mode: **h** / **j** / **k** / **l**
- Arrows: **left** / **down** / **up** / **right**

Sway has up to ten different workspaces that can be freely arranged on the available displays.

## Opening / Closing Applications

- open a new terminal window: **$mod** + **Enter**
- open the application launcher: **$mod** + **d**
- open the run command: **$mod** + **Shift** + **d**
- kill the application (forcefully): **$mod** + **Shift** + **q**

## Using Workspaces

- switch to another workspace: **$mod** + **0**-**9** (workspace no.)
- move an application to another workspace : **$mod** + **Shift** + **0**-**9** (workspace no.)

## Focussing Windows

- focus another application window: **$mod** + **\<movement-key\>** (see [Basics](#Basics))

## Moving Windows

- move the focused application window around on the current workspace: **$mod** + **Shift** + **\<movement-key\>** (see [Basics](#Basics))

## Modifying Windows

- toggle full-screen for the current application window: **$mod** + **f**
- split the current application window vertically: **$mod** + **v**
- split the current application window horizontally: **$mod** + **b**
- enter resize mode for the current application window: **$mod** + **r** (see [Resize Mode](#Resize%20Mode))

## Changing the Container Layout

- toggle between horizontal and vertical layout: **$mod** + **e**
- enable stacking of application windows: **$mod** + **s**
- enable tabbed application windows: **$mod** + **w**

## Floating Windows

- toggle floating mode for current application window: **$mod** + **Shift** + **Space**
- move floating application window around: **$mod** + **Shift** + **\<movement-key\>** (see [Basics](#Basics))
- switch between floating application window and tiled application window: **$mod** + **Space**

## Resize Mode

After activating the Resize Mode you should see a message in the statusbar.

- resize the current application window: **\<movement-key\>** (can be used together with **Shift** for larger offsets)
- increase the gaps between windows: **+** (can be used together with **Shift** for larger offsets)
- decrease the gaps between windows: **-** (can be used together with **Shift** for larger offsets)
- exit the resize mode: **Enter** or **ESC**

## Scratchpad Mode

Sway has a "scratchpad", which is a bag of holding for windows.  You can send windows there and get them back later.

- move the current application window to the Scratchpad: **$mod** + **Shift** + **Minus**
- activate the Scratchpad Mode: **$mod** + **Minus**

## Screenshots

- screenshot of the whole screen: **Print Screen**
- screenshot of the current application window: **$mod** + **Print Screen**
- screenshot of certain area of the screen: **$mod** + **Shift** + **Print Screen**

## Restart / Exit

- reload Sway configuration: **$mod** + **Shift** + **c**
- exit Sway session: **$mod** + **Shift** + **e**

## Appendix A: Chromium with Widevine for Netflix, Spotify and Co.

As part of the Sway profile you also received a custom bash script `/usr/local/bin/install_chromium_widevine.sh`, which when executed will create a custom systemd-spawn container in `/var/lib/machines/chromium_widevine` based on Debian 10 Buster armhf. Additionally, a compatible Chromium version incl. the required DRM extensions are installed into this container. This will take some time, but when finished you are able to either launch a custom Chromium-Widevine application either via the shell (`/usr/local/bin/launch_chromium_widevine.sh`), or via the application launcher (`Chromium-Widevine`).

## Appendix B: Pinebook related tweaks

If you have the predecessor of the Pinebook Pro you will have to do the following minor tweaks on the default installation:

- for the correct battery status in Waybar you will have to update it's config (default in `/etc/xdg/waybar/`) by copying it to `$HOME/.config/waybar` and change the value of the "bat" property in the battery section

```json
    "battery": {
        ...
        "bat": "cw2015-battery"         // <--- set to "axp20x-battery" for Pinebook
    },
```
