# fastladder-docker-compose
fastladder container with docker-compose.
Using MySQL.

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

## editing env.production
### obtain secret_key_base

```
<needs ruby>
# $ irb
# irb> require 'securerandom'
# irb> SecureRandom.hex(64)
# irb=> "secure random string"
```
