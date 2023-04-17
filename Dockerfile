FROM postgis/postgis:15-3.3

ADD create_dbs.sh /docker-entrypoint-initdb.d/99_create_dbs.sh
