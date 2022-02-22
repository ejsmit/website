---
title: "SSH setup for GitHub"
description: 'Public Key Authentication and Certificates'
date: 2020-04-07
draft: false

math: false
diagram: false
featured: false
comment: false

tags: [git, ssh, github, crypto]
categories: [security]
images: []
---

The easiest way of connecting to github from the git command line is to use
ssh keys for authentication, especially now that the old username and password
logins are have been replaced with generated token logins.  This does however
requre a bit of setup to get working.  
<!--more-->

### Updates

* January 2021: Change from rsa to ed25519 keys.

## Creating a new key

I use the names `id_25519_github` and `and id_25519_github.pub` for my keys, using a unique key from evey host that I need to connect from.  Use a keepass long random password.

```bash
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_github
```

To add to the ssh agent use:

```bash
ssh-add  ~/.ssh/id_ed25519_github
ssh-add -L
```

## Configuring GitGub

Open the user settings pagem and find SSH and GPG keys on the left.   Click on ne SSH key
and call it `user@host`, using your current username that you are using on the host you are
connecting from.  

```bash
cat ~/.ssh/id_ed25519_github.pub
```

Copy and paste it into the key field on GitHub


## Test your connection

```bash
ssh -T git@github.com
```

Check the output. You should see something like *Hi username! You've successfully authenticated, but GitHub does not provide shell access.*

## projects ssh instead of https

to fix existing projects that use https use the following:

```bash
git remote remove origin
git remote add origin git@github.com:user/project.git
```

The easiest is to just copy the url from the github web interface.  That way you know it is correct
without any typing mistakes.
