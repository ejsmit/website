---
title: "SSH using certificates from a local CA"
date: 2021-01-24
subtitle: 'how to set up and configure a local ssh CA'
description: ''
tags: [openssh, linux, windows, certificates]
---



## Summary 

This sections contains a short summary of exacly what need to happen to get everything to work.  
More detail will be added later on.  Also note this is heavily customised for my own environment.
It is not likely to work as is anywhere else.


### Setup

* Create CA keys.
* Initialise serial to 0.  It will auto increment in each sign script.

### Host Certificates

* host keys should already exist as part of distribution installation.
* [script] sign them manually using sign-host-keys.sh
* [ansible] add HostCertificate lines to sshd_config to make sshd server announce certificates to remote clients
* [ansible] add @cert-authority to global ssh_known_hosts to make clients trust remote server certificates
* Optional - remove extra lines from known_hosts.

## User Certificates

* [script] Create and sign user certificate using sign-user-keys.sh
* [ansible] add TrustedUserCAKeys to sshd_config to make sshd server trust user certificates
* [ansible] add AuthorizedPrincipalsFile to sshd_config to enable pricipals to usernames mappings
* [ansible] add username<->principals mappings files to each host
* Optional - remove local default id_rsa if is exists
* client ssh config file dotf.
* ssh-agent certificates load and test




## View certificates

This can be used to show the details of any of the certificates created below.  Useful to 
double check that everything was created correctly.

```
ssh-keygen -Lf id_ed25519-cert.pub
```


## Creating local CA

Once-off setup.  Should never need to do this again, except to start again from scratch.

`.private` is an encrypted volume that can be mounted when the ca keys are required.  Assume
all hosts can access the same volume.

```bash
mkdir -p ~/.private/apps/ssh-ca
cd ~/.private/apps/ssh-ca
ssh-keygen -t ed25519 -C CA -f ca-key
chmod 600 ca-key*
echo "0" > ca-key.serial.txt
```


## Manual steps on individual hosts

### Signing host keys

For me this is easy.  A single script.  Keys should already exist, and I just need to sign them.

*note: Raspbian installations still have DSA host keys.   I delete them.  DSA is old and even Ubuntu have 
removed these keys in their latest releases.*


```bash
sign-host-keys.sh
```

For reference here is it.   I need to do some nasty things because root
does not have access to my `private` mounted volume, so I cannot use 
`sudo` to give me access to both the `ca-key` file and `/etc/ssh` at the same time. 

I also create certificates valid for a year at a time.  At home my goal is ease of use and
some security, so I do not worry too much about certificates with a longer lifespan.  I can always 
revoke certificates if I need to.

Principal names are `hostname, hostname.local and hostname.home`.

```bash
#!/usr/bin/env bash

# exit when any command fails
set -e

function generate_all {
    ssh-keygen -s ~/.private/apps/ssh-ca/ca-key \
         -I "host:$(hostname)" \
         -n "$(hostname),$(hostname).local,$(hostname).home" \
         -V -5m:+365d \
         -h \
         -z +$serial \
         $temp_dir/ssh_host_*_key.pub
    count_certs=$(ls $temp_dir/ssh_host_*-cert.pub | wc -l)
    ((serial=serial+$count_certs))  
}

temp_dir=$(mktemp -d)
cp /etc/ssh/ssh_host_*_key.pub $temp_dir

serial=$(cat ~/.private/apps/ssh-ca/ca-key.serial.txt)
#echo "First serial to use: $serial"
count=$(ls $temp_dir/ssh_host_*_key.pub | wc -l)
#echo "Number of key files: $count"

generate_all

#echo "New serial to write $serial"
echo $serial >~/.private/apps/ssh-ca/ca-key.serial.txt

sudo cp $temp_dir/ssh_host*-cert.pub /etc/ssh
rm -Rf $temp_dir
```


### Creating and signing user keys

I standardised on ed25519 keys and certificates at home.   It is relatively new, very small compared
to rsa, and generally considered as a safe choice.  Even github use ed25519 in many of their examples.  

Again this is pretty easy for me.   I can just run a single script that does everything.

```bash
sign-user-keys.sh
```

The script is pretty straightforward compare the the host script.  Create a new ed25519 key and 
sign it.  Nothing else.

The principal name is the username prefixed with the word *user* to make sure it does not match the 
actual username.


```bash
#!/usr/bin/env bash

# exit when any command fails
set -e

echo "Creating new user key:"
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519

serial=$(cat ~/.private/apps/ssh-ca/ca-key.serial.txt)
# echo "First serial to use: $serial"

echo "Signing key using CA private key"
ssh-keygen -s ~/.private/apps/ssh-ca/ca-key \
    -I "user:$(whoami)@$(hostname)" \
    -n "user-$(whoami)" \
    -V -5m:+365d \
    -z $serial \
    ~/.ssh/id_ed25519.pub

((serial=serial+1))
#echo "New serial to write $serial"
echo $serial >~/.private/apps/ssh-ca/ca-key.serial.txt
```

## Ansible automatic configuration

All of this happens automatically through ansible playbooks.

- Copy the `ca-key.pub` file to each host and place in `/etc/ssh`, owned by root:root and mode 664. Ansible
has its own copy if the public key file.  
- Update `/etc/ssh/sshd_config` to add line `TrustedUserCAKeys /etc/ssh/ca-key.pub`.  This allows sshd to
trust user certificates signed by the CA. 
- Update `/etc/ssh/ssh_known_hosts` to add `@cert-authority * <contents of ca-key.pub>`.  This allows ssh
clients to trust remote sshd host certificates signed by the CA. 
- Create the `/etc/ssh/auth_principals` folder, and a file in that folder for each user that need to log
on locally using signed certificates.  This file should contain the list of principals, one per line, that 
are allowedto log on as that user.  For my raspberry pi hosts I will for example need a file called `pi` 
because that is the name of the local user, and its contents will be `user-rsmit` and `user-pi`, allowing me 
to log on from other raspberry pis and also my desktops where I use rsmit as username. 
- Update `/etc/ssh/sshd_config` to add line `AuthorizedPrincipalsFile /etc/ssh/auth_principals/%u`. This enables
the principal mapping using the file we created earlier.  Files hhould be mode 644.
- Update `/etc/ssh/sshd_config` to add a `HostCertificate <path to certificate file>` line for each host certificate
found in `/etc/ssh`.  This will enable sshd to announce that it has host certificates available in addition to 
the usual public keys




## Troubleshooting

### Client:

Can also replace the *-v* with *-vvv*
```bash
ssh hostname -v
```

### Server

No need to stop the server.  Just run another server in the foreground on a different port, using ^C to exit.  
Again the *-d* and be replaced with *-ddd*.

```bash
/usr/sbin/sshd -d -p 22222
ssh servername -p 22222 -v
```


## Windows

The setup on windows is slightly more manual.   Microsoft provides OpenSSH as a standard Windows feature
in Windows 10 and later.  The default shell when connected is Windows CMD.  

For some reason my sshd resets to manual startup after updates.   Still investigating why.....


```powershell
Get-WindowsCapability -Online | Where-Object {$_.Name -like 'OpenSSH*'} | Add-WindowsCapability -Online
Start-Service sshd
Set-Service sshd -StartupType Automatic
```

System-wide configuration and keys are in `C:\ProgramData\ssh`.  User configuration is in `$HOME/.ssh`.

Windows configuration is going to be more manual.  Also because of the differences in wildcard handling
between linux and Windows even filenames need to be specified manually.

Copy the following ssh-keygen command, making sure not to copy the final newline, edit the serial number
to the correct value, press enter and then manually add all the ssh_host_*_key.pub files to the final 
line from the command.   Wildcards are not allowed.  Replace computername with the correct value.  Cannot
use the %COMPUTERNAME% variable because it is all uppercase, which is not recognised as similar to lowercase
hostnames used by ssh.

```
cd \programdata\ssh
ssh-keygen -s p:/apps/ssh-ca/ca-key ^
     -I "host:%COMPUTERNAME%" ^
     -n "computername,computername.local,computername.home" ^
     -V -5m:+365d ^
     -h ^
     -z +21 ^
```

For user certificates the process is very similar. Edit the serial number and run the following:

```
ssh-keygen -t ed25519 -f %HOME%/.ssh/id_ed25519
ssh-keygen -s p:/apps/ssh-ca/ca-key ^
    -I "user:%USERNAME%@%COMPUTERNAME%" ^
    -n "user-%USERNAME%" ^
    -V -5m:+365d ^
    -z 25 ^
    %HOME%/.ssh/id_ed25519.pub
```

Update the ca serial number with the user serial +1.

Get a copy of the public key

```
copy p:\apps\ssh-ca\ca-key.pub c:\ProgramData\ssh
```

Add the following to `sssh_config`

```
HostCertificate __PROGRAMDATA__/ssh/ssh_host_rsa_key-cert.pub                                                
HostCertificate __PROGRAMDATA__/ssh/ssh_host_dsa_key-cert.pub                                                
HostCertificate __PROGRAMDATA__/ssh/ssh_host_ecdsa_key-cert.pub                                              
HostCertificate __PROGRAMDATA__/ssh/ssh_host_ed25519_key-cert.pub
TrustedUserCAKeys __PROGRAMDATA__/ssh/ca-key.pub                                                     
AuthorizedPrincipalsFile __PROGRAMDATA__/ssh/auth_principals/%u  
```

Create a directory called `auth_principals` and a file called `rsmit` with the following content:
```
user-rsmit
user-pi
```

Thats is.  Restart sshd and everythign will most likely fail because of permission problems.
Make sure everything  (all the certificates and keys, as well as the auth_principals files) are
owned by system, with only the system adn administrators to have full control, and nobody else 
to even have read access.


Finally configure your ssh-agent to load the keys and certificates.  In Windows private keys can
be removed after adding them to your ssh-agent, but I am not going to trust that and keep mine around.

```
Set-Service ssh-agent -StartupType Automatic
Start-Service ssh-agent
ssh-add
ssh-add -L
```

