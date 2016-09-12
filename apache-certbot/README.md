# basic apache certbot container
...notes to myself

see: https://certbot.eff.org/docs/using.html#standalone

make sure example.com:80 and example.com:443 are accessible on the docker host

## get initial (test) certificates
...create named volume to store them...
```cmdline
docker volume create --name letsencrypt
```
...request and store certificates. this should leave the them in /var/lib/docker/volumes/letsencrypt/_data/
```cmdline
docker run -ti --rm -v letsencrypt:/etc/letsencrypt -p 80:80 -p 443:443 -t mrxra/apache-certbot bash -c "certbot certonly --standalone --test-cert -n --keep --agree-tos --email my@example.com -d example.com"
```

rinse and repeat (remove --test-cert) to get prod certificates...

## renew certificates
```cmdline
docker run -ti --rm -v letsencrypt:/etc/letsencrypt -p 80:80 -p 443:443 -t mrxra/apache-certbot bash -c "certbot renew --standalone"
```
