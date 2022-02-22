---
title: "Linux Open Ports"
date: 2019-05-18T19:49:11+01:00
subtitle: 'List the open ports, and the process that opened it'
draft: false

math: false
diagram: false
featured: false
comment: false

tags: [linux, internet, ports]
categories: [network]
images: []
---


## lsof

```bash
sudo lsof -i -P -n | grep LISTEN
```

* -i: list open ports
* -P: dont convert port numbers to names
* -n: don't do reverse dns lookups

## ss

netstat has been deprecated.  ss is its replacement.

```bash
sudo ss -tulpn | grep LISTEN
```

* -t: tcp
* -u: udp
* -l: listenng sockets
* -p: process id of listening process
* -n: don't do reverse dns lookups

