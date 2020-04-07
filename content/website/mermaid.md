---
title: "Mermaid charts"
date: 2020-04-07
subtitle: 'Using mermaid to draw html charts in a Hugo website'
description: ''
tags: [website, hugo, mermaid, charts]
---
## Shortcodes

Mermaid charts are created using Hugo shortcodes.  Here is a simple example.

```md
{{</* mermaid align="left" */>}}
graph LR
    Start --> Stop
{{</* /mermaid */>}}
```

{{< mermaid align="left">}}
graph LR
    Start --> Stop
{{< /mermaid >}}


See more at <https://mermaid-js.github.io/mermaid/#/>
