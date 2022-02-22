---
title: "Raspberry Pi Networking"
description: "Basic network configuration tasks on Raspbian."
date: 2021-09-27
draft: false

math: false
diagram: false
featured: false
comment: false

tags: [raspbian, raspberry pi, network, wifi, dhcp]
categories: [linux]
images: []
---

Even though Raspbian is based on Debian its networking configuration is much simpler than
other Debian based systems.  Almost all configuration  is done through the dhcp client.
<!--more-->

## Dynamic (dhcp) address

The default `/etc/dhcpcd.conf` will give you a dynamic ip address.  There is no specific configuration
that need to be present in the file.  As long as there is no static configuration section (see below)
the raspberry pi will use dhcp to assign a dynamic aip address.   

## Static address

Add the following lines to `/etc/dhcpcd.conf`

```text
# static IP configuration:
interface eth0
    static domain_name=home
    static domain_search=home
    static ip_address=192.168.0.10/24
    static ip6_address=fd50:12ab:34cd:56ef::ff/64
    static routers=192.168.0.1
    static domain_name_servers=192.168.0.2 
```

# WiFi 

To connect to a wireless network you need to edit the `/etc/wpa_supplicant/wpa_supplicant.conf` file 
with the wifi network details:

```text
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
country=GB
update_config=1

network={
 ssid="HOMEWIFI"
 psk="my_wifi_password"
}
```
Multiple `network` sections can exist for different wifi networks that you can connect to.

Again the default configuration will provide a dhcp assigned ip address.  No additional changes are needed
for dynamic addressing.


## Disable Wifi

When I use a Raspberry Pi as a server I usually disable wifi and bluetooth.  The way I do it that seem to 
work is to append `disable-wifi,disable-bt` to `dtoverlay=` in `/boot/config.txt`

```text
dtoverlay=disable-wifi,disable-bt
```
 
## Resources

- https://www.raspberrypi.org/documentation/computers/configuration.html








