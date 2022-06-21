wpa_supplicant -i wlp3s0 -c ./wpa_supplicant.conf &
dhclient
ping -c 3 www.baidu.com

