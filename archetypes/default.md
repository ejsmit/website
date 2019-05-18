---
title: "{{ replace .Name "-" " " | title }}"
date: {{ .Date }}
draft: true
subtitle: ''
description: ''

resources:
- name: header
  src: image.jpg
  title: this is title and alt text
  params:
    license: #"Public Domain"
    original: #"https://commons.wikimedia.org/wiki/File:Victor_Hugo_by_%C3%89tienne_Carjat_1876_-_full.jpg"

---
