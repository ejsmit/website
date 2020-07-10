---
title: "create-react-app & Docker"
date: 2020-07-07
subtitle: 'how to dockerise a new react app'
description: ''
tags: [react, docker, javascript]

---


These instructions are not perfect, but they work for the small webapps I create.


## Installation

```bash 
npx create-react-app my-app
cd my-app
rm -r node_modules
```



## dockerfile.dev

used to host a dev server, and run tests.   Just use `docker-compose up` to start.   
No need to manually build container.  

```docker
FROM node:lts-alpine

RUN mkdir -p /home/node/app/node_modules \
    && chown -R node:node /home/node/app

WORKDIR /home/node/app
USER node

COPY package.json .
COPY yarn.lock .
RUN yarn install

COPY --chown=node:node . .
EXPOSE 3000

CMD ["yarn", "start"]
```

## dockerfile

Build the webapp in a temporary container, and then create a production `nginx` server to
host the app.  Should be ready to deploy anywhere.   Build using `docker build -t webapp .`.

```docker
FROM node:lts-alpine as builder

WORKDIR /app

COPY package.json .
COPY yarn.lock .
RUN yarn install --production

COPY . .

RUN yarn build


FROM nginx:alpine

COPY --from=builder /app/build /usr/share/nginx/html

```


## .dockerignore

```
node_modules
```

## docker-compose.yml

```yaml
version: "3"

services:
    web: 
        build: 
            context: .
            dockerfile: Dockerfile.dev
        ports: 
            - "3000:3000"
        volumes:
            - .:/home/node/app
            - node_modules:/home/node/app/node_modules
        environment:
            - CI=true
    tests:
        build: 
            context: .
            dockerfile: Dockerfile.dev
        depends_on:
            - web
        volumes:
            - .:/home/node/app:ro
            - node_modules:/home/node/app/node_modules:ro
        command: ["yarn", "test"]


volumes:
    node_modules:
```

## Other

Install and run `tmux`, and then run splitlogs.py inside tmux

### splitlogs.py

```python {linenos=true}
#!/usr/bin/python3

# Requires pyyaml

import os
import yaml

run = os.system
new_window = lambda cmd: run('tmux new-window -n "logs" "{}"'.format(cmd))
split_vertical = lambda cmd: run('tmux split-window "{}"'.format(cmd))
split_horizontal = lambda cmd: run('tmux split-window -h "{}"'.format(cmd))
even_vertical = lambda: run('tmux select-layout even-vertical')

if __name__ == '__main__':
    try:
        config_text = open('docker-compose.yaml').read()
    except IOError:
        config_text = open('docker-compose.yml').read()

    config = yaml.load(config_text, Loader=yaml.SafeLoader)

    services = list(config['services'].keys())
    print(services)
    new_window('docker-compose logs -f {}'.format(services[0]))

    for service in services[1:]:
        split_horizontal('docker-compose logs -f {}'.format(service))

    even_vertical()
```


