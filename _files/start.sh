#!/bin/bash

if [[ -f /home/ctf/pwn ]]; then
    chown root:ctf /home/ctf/pwn
    chmod 750 /home/ctf/pwn
fi

if [ -n $PORT ]; then
    if [[ $PORT -gt 0 ]]; then
        socat TCP4-LISTEN:10000,reuseaddr,fork,su=nobody TCP4:127.0.01:$PORT &
    else
        echo "PORT [$PORT] is not vaild!"
        exit 1
    fi
fi

if [ -z $TCPDUMP_ENABLE ]; then
    echo "Set TCPDUMP_ENABLE to enable packet capture."
else
    TCPDUMP_DIR=/var/lib/tcpdump
    if [ -z $TCPDUMP_ROTATE_SEC ]; then
        TCPDUMP_ROTATE_SEC=600
    fi
    TCPDUMP_FILENAME="capture-%F-%H-%M-%S.pcap"
    mkdir -p $TCPDUMP_DIR
    echo "TCPDUMP: capture port: 10000, rotate interval: ${TCPDUMP_ROTATE_SEC}s, capture filename: capture-\$time.pcap"
    exec /usr/sbin/tcpdump -i eth0 port 10000 -U -w $TCPDUMP_DIR/$TCPDUMP_FILENAME -G $TCPDUMP_ROTATE_SEC &
fi

if [[ -f /flag.sh ]]; then
    source /flag.sh
fi

export FLAG=not_flag
FLAG=not_flag

echo "Start Run Pwn"
exec /usr/sbin/chroot --userspec=ctf:ctf /home/ctf ./pwn
