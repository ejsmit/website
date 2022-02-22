---
title: "Configuring GPG"
description: "GPG config and key management"
date: 2019-05-24T13:42:37+01:00
draft: false

math: false
diagram: false
featured: false
comment: false

tags: [gpg, crypto]
categories: [security]
images: []
---

This guide explains how to configure GPG and some basic key management operations.  
It is not meant to be extremely secure, just good enough for home lab use.
<!--more-->

## Updates

- August 2021: remove some old content that I don't use any more
- September 2021: Add details about copying and importing keys to other hosts.

## Resources

These guides go into more detail about extremely secure setups.

- https://dev.to/benjaminblack/signing-git-commits-with-modern-encryption-1koh
- https://github.com/drduh/YubiKey-Guide
- https://blogs.itemis.com/en/openpgp-on-the-job-part-3-install-and-configure
- https://blogs.itemis.com/en/openpgp-on-the-job-part-4-generating-keys
- https://github.blog/2021-05-10-security-keys-supported-ssh-git-operations/
- https://www.yubico.com/blog/github-now-supports-ssh-security-keys/
- https://github.com/vorburger/vorburger.ch-Notes/blob/develop/security/ed25519-sk.md

## Software requirements

These are all ubuntu packages.  

Basic software requirements:
- gpg
- gpg-agent
- pinentry-curses  (or pinentry-tty)

Could not get anything to work with pinentry-qt or any other graphical frontend.  Also note that
modern ubuntu systems has transitioned to gpg 2 as default.  just installing `gpg` gives version 2.  
You need to explicity install `gnupg1` to get the old version 1. Package `gnupg2` is officially marked as
a transitional package, giving the same contents as `gpg`, except under the app name `gpg2`.


### Sensible configuration files

My dotfiles already takes care of these.

~/.gnupg/gpg.conf:

```
personal-cipher-preferences AES256 AES192 AES
personal-digest-preferences SHA512 SHA384 SHA256
personal-compress-preferences ZLIB BZIP2 ZIP Uncompressed
default-preference-list SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed
cert-digest-algo SHA512
s2k-digest-algo SHA512
s2k-cipher-algo AES256
charset utf-8
fixed-list-mode
no-comments
no-emit-version
no-greeting
keyid-format 0xlong
list-options show-uid-validity
verify-options show-uid-validity
with-fingerprint
require-cross-certification
no-symkey-cache
use-agent
throw-keyids
```
~/.gnupg/gpg-agent-conf:
```
#enable-ssh-support
ttyname $GPG_TTY
default-cache-ttl 60
max-cache-ttl 120
pinentry-program /usr/bin/pinentry-curses
```

~/.bashrc:
```
export GPG_TTY=$(tty)
```



## Initial Setup

{{< alert "Do this once only" warning >}}

### Create new master key

```bash
gpg --expert --full-generate-key
```

Generate a `(8) RSA (set your own capabilities)` key, and remove everything except certify.
Use 4096 bits, without any expiry date.  Full name and email, use short name for comment.

View keys at ay time with
```bash
gpg -k    # public
gpg -K    # secret
```

Useful tip:
```bash
export KEYID=.....
```
This will allow you to use $KEYID in commands instead of the actual key id.  Always reboot
after working with secret keys to ensure any temporary variables are cleared.


### Add new userid (new email)

```bash
gpg --expert --edit-key $KEYID
```
Use the comment value specified above...

The following commands create a new userid, prompting for new full name, email and comment fields.
It then sets this new uid as primary and saves the key.
```gpg
adduid
uid 2
trust (select ultimate)
uid 1
primary
save
```

### Add subkeys

```bash
gpg --expert --edit-key $KEYID
```

Starting from the same interactive shell as above, use the following.   The new key command
will prompt for key type (individual RSA keys for signing, encryption and authentication),
bits (4096) and expiry date (1y - I like my signing keys to expire after 1 year)

```gpg
addkey
```
`save` when done with all subkeys.


### Backup

```bash
gpg --armor --export-secret-keys    $KEYID > master.priv.key
gpg --armor --export-secret-subkeys $KEYID > master.sub.priv.key
gpg --armor --export $KEYID  > master.pub.key
gpg --output master.revoke.cert --gen-revoke $KEYID
gpg --export-ownertrust > ownertrust.txt
```

move all key files to a safe location.  zip up complete dir and save as well.


### Disable master key

For newer installations just use the following command:
```bash
gpg --delete-secret-key $KEYID
gpg --import master.sub.priv.key
```

This key file is still in your backups, and you will need to restore it again to make
future changes to subkeys.   But for now the already created subkeys will work perfectly
well without the master secret key present.



### Copying keys

Easiest way is to copy whole `.gnupg` directory.  Remember if copying from original backup it
may contain the master key, and for safety you may want to remove it again.

This works fine if you have similar environment and versions.

Otherwise use key export and import:

```bash
gpg --import master.pub.key
gpg --import master.sub.priv.key
gpg --import-ownertrust < ownertrust.txt
```
