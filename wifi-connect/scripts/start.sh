#!/usr/bin/env bash

export DBUS_SYSTEM_BUS_ADDRESS=unix:path=/host/run/dbus/system_bus_socket

if [[ ! -z $CHECK_CONN_FREQ ]] 
    then
        freq=$CHECK_CONN_FREQ
    else
        freq=120
fi

# Optional step - it takes couple of seconds (or longer) to establish a WiFi connection
# sometimes. In this case, following checks will fail and wifi-connect
# will be launched even if the device will be able to connect to a WiFi network.
# If this is your case, you can wait for a while and then check for the connection.
sleep 10

while [[ true ]]; do
    echo "Checking internet connectivity ..."
    # Choose a condition for running WiFi Connect according to your use case:

    # 1. Is there a default gateway?
    # ip route | grep default

    # 2. Is there Internet connectivity?
    # nmcli -t g | grep full

    # 3. Is there Internet connectivity via a ping?
    # wget --spider http://google.com 2>&1
    # wget --spider --no-check-certificate 1.1.1.1 > /dev/null 2>&1

    # 4. Is there an active WiFi connection?
    iwgetid -r
    
    if [ $? -eq 0 ]; then
        echo "Skipping Wifi-Connect. Will check again in $freq seconds"
    else
        echo "Starting Wifi-Connect."
        ./wifi-connect
    fi
    
    sleep $freq

done

# Start your application here.
# sleep infinity
