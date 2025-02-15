# SdrAutomation
Some scripts to automate use of SDR applications.  

The initial script is start-gqrx-fullscreen.sh which starts gqrx with a pre-built configuration file, sends commands to start DSP and to go into full screen mode.

The second script is start-gqrx-wsjtx.sh which as the name suggests starts both gqrx and wsjtx.

The scripts assume you already have gqrx and wsjtx installed and configured.

For gqrx it assumes you have saved a configuration called my-default.conf and that this configuration enables remote control so that udp commands can turn on the DSP.

Typically these scripts are run on a Pi and use the default session manager, lxsession, to start them.  On my system I copy the scripts to the $HOME/scripts directory.

The scripts only work with the X Windows System enabled.  See the no-wayland.txt file in this repo if you want to switch from Wayland to X.

Steps:

0) Install tools used by this script 


```
$ sudo apt install -y wmctrl netcat-openbsd xdotool
```

1) Setup LXDE autostart

a) make our config dir 

```
$ mkdir -p ~/.config/lxsession/LXDE-pi
```

b) copy system autostart into our directory

```
$ cp /etc/xdg/lxsession/LXDE-pi/autostart ~/.config/lxsession/LXDE-pi/autostart
```

c) add a line to the end of our autostart to start our script which has been copied in $HOME/scripts/start-gqrx-fullscreen.sh (or any other script you want to start)

```
$ echo "@bash $HOME/scripts/start-gqrx-fullscreen.sh" | tee --append ~/.config/lxsession/LXDE-pi/autostart
```

d) check result

```
$ cat ~/.config/lxsession/LXDE-pi/autostart
```

2) Reboot and it should auto-start gqrx in full screen mode.

3) As of 14 Feb 2025, start-gqrx-wsjtx is not tested with current Raspberry Pi OS Bookworm, but it did work on an older version of Linux.
