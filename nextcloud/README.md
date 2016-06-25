# docker
somewhat experimental nextcloud container, built on debian (jessie), php7 and apache2.4

```cmdline
docker run --name nextcloud -p 8888:80 -t mrxra/nextcloud:latest
```
or with an 'nextcloud' data volume (with subdirectories config and data)

```cmdline
docker run --name nextcloud -p 8888:80 -v nextcloud:/nextcloud -t mrxra/nextcloud:latest
```

http://localhost:8888/nextcloud
