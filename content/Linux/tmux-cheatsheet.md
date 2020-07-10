---
title: "tmux cheatsheet"
date: 2020-07-10T17:41:19+01:00
subtitle: 'quick summary of common tmux keys'
description: ''
tags: [tmux, linux]
---

## Default Prefix

Default prefix is `Ctrl-b`.


## Windows

```
tmux new-window
tmux neww  
tmux neww -n windowname
tmux new -s sessionname -n windowname
```

**prefix c**  
	create new window

**prefix ,**    
rename window

**prefix n|p**  and **prefix Ctrl n|Ctrl p**  
go to next/previous window

**prefix 1|2...**    
go to window #


## Panes

**prefix v|h**    
vertical or horisontal pane split

**prefix spacebar**    
cycle through default pane layouts.  Default layout splits panes evenly.  Use this to quickly make one big and one small pane.

**prefix q**    
displays big pane numbers overlay

**prefix !**    
convert pane to separate window

**prefix z**    
zoom pane to fullscreen.   Repeat to unzoom.


## Sessions

I dont usually create new sessions manually.

```
tmux new-session -s basic
tmux new -s sessionname
```

**prefix (|)**    
prev/next session


### detach and reattach

**prefix d**    
detach session

```
tmux attach
tmux attach -t sessionname
```

```
tmux list-sessions
tmux ls
tmux kill-session -t sessionname
```





