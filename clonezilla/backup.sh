# $1 -> image, $2 -> device
ocs-sr -q2  -c -j2 -z2p -i 0 -sfsck -scs -senc -p reboot savedisk $1 $2