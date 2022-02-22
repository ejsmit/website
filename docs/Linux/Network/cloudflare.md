---
title: "Cloudflare DNS Settings"
date: 2019-05-18T19:49:11+01:00
description: "Commonly used code fragments to copy from"
draft: false

math: false
diagram: false
featured: false
comment: false

tags: [dns, privacy]
categories: [network]
images: []
---

## Links

- <https://www.cloudflare.com/learning/dns/what-is-1.1.1.1/>
- <https://1.1.1.1/>


## ipv4 addresses

```
1.1.1.1
1.0.0.1
```

## ipv6 addresses

```
2606:4700:4700::1111
2606:4700:4700::1001
```

## dns over https

<https://developers.cloudflare.com/1.1.1.1/dns-over-https>

Yes you still need regular DNS present to resolve the url below!  Usually used inside browser, while
the rest of the system uses regular DNS.

```
https://cloudflare-dns.com/dns-query
```

### udp wireformat

DNS wireformat is defined in RFC1035.

examples using both GET and PUT
```
curl -H 'accept: application/dns-message' -v 'https://cloudflare-dns.com/dns-query?dns=q80BAAABAAAAAAAAA3d3dwdleGFtcGxlA2NvbQAAAQAB' | hexdump

echo -n 'q80BAAABAAAAAAAAA3d3dwdleGFtcGxlA2NvbQAAAQAB' | base64 -D | curl -H 'content-type: application/dns-message' --data-binary @- https://cloudflare-dns.com/dns-query -o - | hexdump
```

### json

```
curl -H 'accept: application/dns-json' 'https://cloudflare-dns.com/dns-query?name=example.com&type=AAAA'
```
