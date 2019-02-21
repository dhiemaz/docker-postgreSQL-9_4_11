# docker-postgreSQL-9_4_11
===========================

This is sample docker postgreSQL version 9.4.11 (build from source). The data directory is set to `/data` so you can use a data only volume.

    $ docker run -name postgresql-data -v /data ubuntu /bin/bash
    $ docker run -d -p 5432:5432 -volumes-from postgresql-data -e POSTGRESQL_USER=docker -e POSTGRESQL_PASS=docker -e POSTGRESQL_DB=docker docker/postgresql
    da809981545f
    $ psql -h localhost -U docker docker
 
