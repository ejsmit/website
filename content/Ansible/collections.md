---
title: "Ansible Collections"
date: 2020-05-07
subtitle: 'Using ansible Collections'
description: ''
tags: [ansible]
draft: true
---

## Folder structure

A collection has a fixed folder structure:
```
my_namespace/
└──my_collection/
   ├── docs/
   ├── galaxy.yml
   ├── plugins/
   │   ├── modules/
   │   │   └── module1.py
   │   ├── inventory/
   │   └── .../
   ├── README.md
   ├── roles/
   │   ├── role1/
   │   ├── role2/
   │   └── .../
   ├── playbooks/
   │   ├── files/
   │   ├── vars/
   │   ├── templates/
   │   └── tasks/
   └── tests/
```

This is all good, but I am not a fan of the deep golder structure created when trying to import this collection.

Installing a collection creates a structure like 
`ansible_collections/my_namespace/my_collection/` wherever you try to install it.  And then the documentation recommends to place all of this inside a 
`./collections/` folder!
 
So I choose to skip the `./collections` folder and end up with just a 
`./ansible_collections` in the root.  Which is fine because I now also install downloaded roles in `./ansible_roles`, making it very obvious which roles and collections were downloaded.

And of course both of these folders are specifically listed in `.gitignore`.

## Configuration

Collections and roles are always installed into the first path found in the configuration file.  There can however be multiple search paths specified.

My ansible.cfg looks like this:

```
# Installs collections into [current dir]/ansible_collections/namespace/collection_name
collections_paths = .:collections:~/.ansible/collections:/usr/share/ansible/collections

# Installs roles into [current dir]/ansible_roles/namespace.rolename
roles_path = ansible_roles:roles:~/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
```



## Installing

Collections can be installed manually:

```
ansible-galaxy collection install my_namespace.my_collection:1.0.0
```

but it is easier to install using a requirements.yml file. 

Here is a simple example of a requirements.yml file from the docs:

```
---
roles:
  # Install a role from Ansible Galaxy.
  - name: geerlingguy.java
    version: 1.9.6

collections:
  # Install a collection from Ansible Galaxy.
  - name: geerlingguy.php_roles
    version: 0.9.3
    source: https://galaxy.ansible.com
```

and to import them:

```
ansible-galaxy role install -r requirements.yml
ansible-galaxy collection install -r requirements.yml
```

This will import them to the default paths configured above.


## Using

Two examples from the docs:

```
- hosts: all
  tasks:
    - import_role:
        name: my_namespace.my_collection.role1
    - my_namespace.mycollection.mymodule:
        option1: value
    - debug:
        msg: '{{ lookup("my_namespace.my_collection.lookup1", 'param1')| my_namespace.my_collection.filter1 }}'
```

To save some typing use the `collections` keyword.  This only works for actions or modules.


```
- hosts: all
  collections:
   - my_namespace.my_collection
  tasks:
    - import_role:
        name: role1
    - mymodule:
        option1: value
    - debug:
        msg: '{{ lookup("my_namespace.my_collection.lookup1", 'param1')| my_namespace.my_collection.filter1 }}'
```


