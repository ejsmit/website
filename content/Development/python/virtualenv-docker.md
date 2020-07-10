---
title: "Using dockerfiles with a python virtualenv"
date: 2020-06-07
subtitle: 'how to dockerise a python app inside a virtualenv'
description: ''
tags: [python, docker, virtualenv]
---

## Why a virtualenv in a container?

Normally not needed as the container image itself is already a new clean environment.  But
I needed a multi-stage build where the python env should be created inside the builder and then 
copied over to the final image. 

A virtualenv gives a single directory with all of its dependencies that is easy to copy



## Dockerfile

```
FROM python:3.8-slim as bulder

ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Install dependencies:
COPY requirements.txt .
RUN pip install -r requirements.txt

FROM python:3.8-slim

ENV VIRTUAL_ENV=/opt/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

COPY --from=builder $VIRTUAL_ENV $VIRTUAL_ENV

# Run the application:
COPY myapp.py .
CMD ["python", "myapp.py"]
```


## References

<https://pythonspeed.com/articles/activate-virtualenv-dockerfile/>