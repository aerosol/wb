# Front Matter

`wb` optionally accepts documents with YAML Front Matter.
Example:

```
---
title: The Hobbit
property: Some
date: 2021-01-01
tags:
 - one
 - two
 - three
---

# Bilbo
```

Currently only the following properties are subject to special treatment:
  - `title` (see [[title]]) 
  - `tags` (see [[document tags]]) 

Other attributes are ignored, yet accessible in the [[Single Template]].

