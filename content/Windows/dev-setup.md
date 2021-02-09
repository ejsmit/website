---
title: "My Windows setup"
date: 2021-02-01
subtitle: 'Windows Terminal and console tools developer setup '
description: ''
tags: [windows, terminal]
---

## Summary

This is not a full Windows configuration guide.   It is just a list of a few tools that I use 
and my current configuration.  Most of these tools are console tools that can also be used
when I ssh into my Windows box.


## Installation Instructions

### Powershell

Install the latest powershell core from an administrative powershell
```
winget install Microsoft.PowerShell
```

Links:

* [Windows Documentation](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-windows)
* [Github page](https://aka.ms/powershell-release?tag=stable)

Powershell core is installed by default in `$env:ProgramFiles\PowerShell\<version>`


### Windows Terminal

Install the latest Windows Terminal from an administrative powershell
```
winget install Microsoft.WindowsTerminal
```


### openssh

Install openssh using instructions in [SSH using certificates from a local CA]( {{< ref "linux/ssh-certs-ca.md" >}} )

Because I usually need PowerShell when connecting through ssh, I run the following for the current version 7:

```
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "$env:ProgramFiles\PowerShell\7\pwsh.exe" -PropertyType String -Force
get-service sshd | restart-service
```

### scoop

Installer for windows developer packages.  Does not require admin privileges, and installs everything inside
home directory.

```
$env:SCOOP='D:\rsmit\scoop'
[environment]::setEnvironmentVariable('SCOOP',$env:SCOOP,'User')
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')

scoop install sudo
```

If this does not work try this first
```
Set-ExecutionPolicy RemoteSigned -scope CurrentUser
```

### git

Install the latest git from an administrative powershell
```
winget install Git
```

### text editor

Install a text editor that can be used only from a console without popping up new windows.  This is really
useful when connecting through a ssh session.

```
scoop install micro
```

### yori and sdir

[Yori](http://www.malsmith.net/yori/) is a replacement for Windows CMD.  Colours, better keyboard shortcuts, 
completion, and more....

```
scoop install yori
```

This also gives you `sdir` which is now available everywhere, even powershell. Much better looking directtory listings.


### post-git and starship

Install both of these using scoop.  To be safe also make sure that the latest vcredist2019 package is installed.
Also install a font that can display all of starship's symbols.

```
scoop bucket add extras
scoop install extras/vcredist2019

scoop bucket add nerd-fonts
sudo scoop install CascadiaCode-NF-Mono

scoop install starship
scoop install posh-git
```

Now edit you $PROFILE using the command `micro $PROFILE` and edit it to include the following:
```
# posh-git should be second so that it does not update the prompt.  We only want the
# completion to be available. Starship does the git prompt.                                           
Invoke-Expression (&starship init powershell)                                                         
Import-Module posh-git                           
```


### python

`miniconda` is available through scoop and winget, but I prefer `miniforge` these days.  Similar to miniconda, just 
with conda-forge as default channel.   Unfortunately this still means a manual install.


```
$url = "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Windows-x86_64.exe"
$downloads = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path	
$outfile = join-path $downloads Miniforge3-Windows-x86_64.exe

Invoke-WebRequest -Uri $url -OutFile $outfile
start-process -filepath $outfile -ArgumentList "/InstallationType=JustMe /AddToPath=1 /RegisterPython=0 /S /D=d:\rsmit\miniforge3" -wait
```







