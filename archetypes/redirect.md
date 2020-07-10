---
title: "{{ replace .Name "-" " " | title }}"
draft: true
date: {{ .Date }}
type: "redirect"
redirect: "/page"
---

CONTENT NOT RENDERED

Only insert details here if you want to enter any additional detail about the purpose of the redirect, otherwise you can just leave this portion of your file blank. 

redirect property should contain path relative to `.Site.BaseURL`.  That is actual all lowercase web url path, not directories below content.

