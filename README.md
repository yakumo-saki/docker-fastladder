# docker-fastladder

[![CircleCI](https://dl.circleci.com/status-badge/img/gh/yakumo-saki/docker-fastladder/tree/master.svg?style=svg)](https://dl.circleci.com/status-badge/redirect/gh/yakumo-saki/docker-fastladder/tree/master)

fastladder container with docker-compose.

## how to run.

```
cd <cloned directory>
git clone https://github.com/fastladder/fastladder.git build
docker build .

cp env.production.sample env.production

<edit env.production>

<edit docker-compose.yml for your environment>

docker-compose up -d
```

Web server starts up in port 5000.

## editing env.production
### obtain secret_key_base

```
<needs ruby>
# $ irb
# irb> require 'securerandom'
# irb> SecureRandom.hex(64)
# irb=> "secure random string"
```
