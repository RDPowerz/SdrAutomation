# SdrAutomation
SdrAutomation: Some scripts to automate use of SDR applications.  

The initial script is one that starts gqrx.  

Typically it is run on a Pi and uses the default session manager, lxsession, to start it.  

It only works with the X Windows System enabled.

See no-wayland.txt if you want to switch from Wayland to X.

Steps:

0) Install needed tools 

```
$ sudo apt install -y wmctrl netcat xdotool
```

1) Setup LXDE autostart

a) make config dir 

```
$ mkdir -p ~/.config/lxsession/LXDE-pi
```

b) copy system autostart into our directory

```
$ cp /etc/xdg/lxsession/LXDE-pi/autostart ~/.config/lxsession/LXDE-pi/autostart
```

c) add a line to the end of our autostart to start our script (or any other script you want to start)

```
$ cat | tee --append ~/.config/lxsession/LXDE-pi/autostart
echo "@bash $HOME/scripts/start-gqrx-wsjtx.sh"
<Ctrl-D>
```

d) check result

```
$ cat ~/.config/lxsession/LXDE-pi/autostart
```

2) Reboot and it should auto-start gqrx and wsjx
