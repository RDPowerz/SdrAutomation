#!/bin/bash -x

(   # catch the output...

    # start gqrx first 
    PULSE_SERVER="unix:/run/user/1000/pulse/native" \
      /usr/local/bin/gqrx --conf airspyhf+ft8-remote.conf  \
      > /tmp/gqrx-$USER.log 2>&1 &
    
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
           break
        fi

        # nope, try again
        echo "try $i: dsp start did not work"
        sleep $SLEEP
        i=`expr $i + 1`
    done
    
    # start wsjx regardless, we want it to point to local pulse port
    PULSE_SERVER="unix:/run/user/1000/pulse/native" wsjtx \
      > /tmp/wsjtx-$USER.log 2>&1 &

    # loop waiting for wsjtx to do its stupid popup
    i=0
    while [ $i -lt $MAXTRY ]
    do
        hexwin=`wmctrl -l | awk '/WSJT-X$/ {print $1}'`
        if [ ! -z "$hexwin" ]
        then
           echo "try $i: locate window worked!"
           break
        fi
        echo "try $i: locate window did not work"
        sleep $SLEEP
        i=`expr $i + 1`
    done
    
    # try to close the stupid popup
    hexwin=`wmctrl -l | awk '/WSJT-X$/ {print $1}'`
    decwin=$(printf "%i" $hexwin)
    if [ ! -z "$hexwin" ]
    then
        xdotool windowactivate --sync $decwin key KP_Enter
    fi

) |& tee /tmp/sdr-startup-$USER.log
