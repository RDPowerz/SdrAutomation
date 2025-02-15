#!/bin/bash -x
#
# Note: This script only works with X and not with Wayland; see the file
#       no-wayland.txt for hints on how to disable Wayland
# Note: This script expects gqrx "remote control" to be enabled so that
#       it will accept commands from 'nc' via udp.
# Note: Change this string to match the config file that you want to use.
#       Use File -> Save Configuration in gqrx to create this file after you 
#       have enabled remote controla and have qqrx working correctly otherwise
CONF="--conf my-default.conf"

(   # catch the output...

    # start gqrx first 
    gqrx $CONF > /tmp/gqrx-$USER.log 2>&1 &
    
    SLEEP=2
    MAXTRY=20
    
    # loop waiting for gqrx to respond to a command to start its dsp
    i=0
    while [ $i -lt $MAXTRY ]
    do
        # check for the crash detected popup
        hexwin=`wmctrl -l | awk '/Crash Detected!/ {print $1}'`
        decwin=$(printf "%i" $hexwin)
        if [ ! -z "$hexwin" ]
        then
            xdotool windowactivate --sync $decwin key KP_Enter
        fi

        # check for the configure io popup
        hexwin=`wmctrl -l | awk '/Configure I\/O devices/ {print $1}'`
        decwin=$(printf "%i" $hexwin)
        if [ ! -z "$hexwin" ]
        then
            xdotool windowactivate --sync $decwin key KP_Enter
        fi

        # see if gqrx responds to a command to start its dsp
        s=`(echo "U DSP 1" | nc -i1 -N 127.0.0.1 7356 2>&1)`
        if [ "$s" = "RPRT 0" ]
        then
            echo "try $i: dsp start worked!"
            # send F11 to maximize the gqrx main window
            hexwin=`wmctrl -l | awk '/Gqrx/ {print $1}'`
            decwin=$(printf "%i" $hexwin)
            xdotool windowactivate --sync $decwin key F11
            break
        fi

        # nope, try again
        echo "try $i: dsp start did not work"
        sleep $SLEEP
        i=`expr $i + 1`
    done
    
) |& tee /tmp/sdr-startup-$USER.log
