---
title: "SSH setup for GitHub"
date: 2020-04-07
subtitle: 'Public Key Authentication and Certificates'
description: ''
tags: [git, ssh]
---
## Creating a new key

I use the names `id_rsa_github` and `and id_rsa_github.pub` for my keys, using a unique key from evey host that I need to connect from.  Use a keepass long random password.

```
ssh-keygen -t rsa -b 4096 -C "your_email@example.com" -f ~/.ssh/id_rsa_github
```

To add to the ssh agent use:

```
gpg-connect-agent UPDATESTARTUPTTY /bye
ssh-add  ~/.ssh/id_rsa_github
ssh-add -L
```

## Configuring GitGub

Open the user settings pagem and find SSH and GPG keys on the left.   Click on ne SSH key
and call it `user@host`, using your current username that you are using on the host you are
connecting from.  

```
cat ~/.ssh/id_rsa_github.pub | xclip
```

and paste it into the key field on GitHub


## Test your connection

```
ssh -T git@github.com
```

Check the output. You should see something like *Hi username! You've successfully authenticated, but GitHub does not provide shell access.*

## projects ssh instead of https

to fix existing projects that use https use the following:

```
git remote remove origin
git remote add origin git@github.com:user/project.git
```

The easiest is to just copy the url from the github web interface.  That way you know it is correct
without any typing mistakes.
