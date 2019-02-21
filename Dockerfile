FROM ubuntu:14.04
MAINTAINER Dimas Yudha P. "prawira.dimas.yudha@gmail.com"

# setup everything
RUN apt-get -y update
RUN apt-get install -y build-essential libc6-dev libc6-dev-i386 wget flex libreadline-dev zlib1g-dev
RUN apt-get clean

# prevent apt from starting postgres right after the installation
RUN echo "#!/bin/sh\nexit 101" > /usr/sbin/policy-rc.d; chmod +x /usr/sbin/policy-rc.d

# install PostgreSQL from source using version 9.4.11
RUN wget --quiet --no-check-certificate https://ftp.postgresql.org/pub/source/v9.4.11/postgresql-9.4.11.tar.gz
RUN tar -zxvf postgresql-9.4.11.tar.gz && rm postgresql-9.4.11.tar.gz
RUN cd postgresql-9.4.11 && ./configure && make install
RUN mkdir /usr/local/pgsql/data

# create user postgres
RUN useradd -m postgres && echo "postgres:postgres" | chpasswd && adduser postgres sudo

# copy configuration into docker
ADD postgresql.conf /usr/local/pgsql/data/postgresql.conf
ADD pg_hba.conf /usr/local/pgsql/data/pg_hba.conf
ADD pg_ident.conf /usr/local/pgsql/data/pg_ident.conf

RUN chown postgres:postgres /usr/local/pgsql/data/*.conf
ADD run /usr/local/bin/run
RUN chmod +x /usr/local/bin/run

VOLUME ["/data"]
EXPOSE 5432
CMD ["/usr/local/bin/run"]
