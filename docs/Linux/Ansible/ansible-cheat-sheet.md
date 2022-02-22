---
title: "Ansible cheat sheet"
description: "Commonly used code fragments to copy from"
date: 2021-09-24
draft: false

math: false
diagram: false
featured: false
comment: false

tags: [ansible]
categories: [linux]
images: []
---

This page just contains some examples that I use to copy from when creating 
my own playbooks.  Most of this comes directly from the documentation.  
<!--more-->


### copy
```
- name: Copy file with owner and permissions
  ansible.builtin.copy:
    src: files/foo.conf
    dest: /etc/foo.conf
    owner: foo
    group: foo
    mode: '0644'

- name: Copy using inline content
  ansible.builtin.copy:
    content: '# This file was moved to /etc/other.conf'
    dest: /etc/mine.conf

- name: Copy a "sudoers" file on the remote machine for editing
  ansible.builtin.copy:
    src: /etc/sudoers
    dest: /etc/sudoers.edit
    remote_src: yes
    validate: /usr/sbin/visudo -csf %s
```


### file 
```
- name: Change file ownership, group and permissions
  ansible.builtin.file:
    path: /etc/foo.conf
    src: /tmp/bar  # only for links
    owner: foo
    group: foo
    mode: '0644'
    state: 'directory|absent|file|link|touch'
    recurse: false
```

### stat
```
- name: Get stats of a file
  ansible.builtin.stat:
    path: /etc/foo.conf
  register: st

- name: File exists
   debug:
      msg: "The file or directory exists"
    when: st.stat.exists

- name: is link
  ansible.builtin.debug:
    msg: "Path exists and is a symlink"
  when: st.stat.islnk is defined and st.stat.islnk

- name: is directory
  ansible.builtin.debug:
    msg: "Path exists and is a directory"
  when: st.stat.isdir is defined and st.stat.isdir
```


