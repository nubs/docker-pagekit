Quick and dirty Dockerfile for [Pagekit](http://www.pagekit.com/)

## Standalone

### Start

You will have to link a mysql service in order to use this container. I suggest using `orchardup/mysql`:

```
$ docker run \
    --name pagekit_db_1 \
    -e MYSQL_ROOT_PASSWORD=changethis \
    -e MYSQL_DATABASE=pagekit \
    -d \
    orchardup/mysql
...
$ docker run \
    --name pagekit_web_1 \
    --link pagekit_db_1:pagekit_db_1 \
    -P -d \
    ubermuda/pagekit
...
```

Then check the randomly allocated port:

```
$ docker port pagekit_web_1 80
0.0.0.0:49156
```

The port will likely be different for you.

You can now access your Pagekit installation at http://localhost:49156/ (or whatever port Docker assigned to port 80 of your `pagekit_web_1` container).

### Stop

```
$ docker stop pagekit_web_1 pagekit_db_1
```

### Restart

After having stopped the containers, you can restart them with `docker restart`:

```
$ docker start pagekit_db_1 pagekit_web_1
```

The order in which you start container is important here, because `pagekit_web_1` needs a link from `pagekit_db_1`, so you have to start the db container first.

Also, please note that a new random port will be allocated to port 80 of `pagekit_web_1`, you have to use `docker port` again to get it.

## With [fig](http://www.fig.sh/)

### Start

This is much more simple than running everything by hand:

```
$ git clone https://github.com/ubermuda/docker-pagekit
$ cd docker-pagekit
$ fig up
```

Then use `fig ps` to determine the allocated port:

```
$ fig ps
        Name                Command         State        Ports
------------------------------------------------------------------
dockerpagekit_db_1     /usr/local/bin/run   Up       3306/tcp
dockerpagekit_data_1   /bin/true            Exit 0
dockerpagekit_web_1    /init.sh             Up       49159->80/tcp
```

You can now access your Pagekit instance at `http://localhost:49159/`.

### Stop

Use `fig stop`:

```
$ fig stop
Stopping dockerpagekit_web_1...
Stopping dockerpagekit_db_1...
```

### Restart

To properly restart your Pagekit containers, use `fig start`:

```
$ fig start
Starting dockerpagekit_db_1...
Starting dockerpagekit_data_1...
Starting dockerpagekit_web_1...
```

Note that if you `fig stop` then `fig up` again, you will have to reinstall Pagekit, except it will fail because the database will already contain your user.

Use `fig ps` again to get the new allocated port.