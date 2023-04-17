#!/bin/bash

set -e

function create_db {
    DBNAME=$1
    DBUSER=$2
    DBPASS=$3

    if [ "x" = "x$DBNAME" ] || [ "x" = "x$DBUSER" ] || [ "x" = "x$DBPASS" ]
    then
        return
    fi
    # Two commands being run as root user
    PGPASSWORD="$POSTGRES_PASSWORD" \
        psql -c "CREATE ROLE $DBUSER SUPERUSER LOGIN PASSWORD '$DBPASS';" \
             -v ON_ERROR_STOP=1 \
             -U "$POSTGRES_USER" "$POSTGRES_DB"
    PGPASSWORD="$POSTGRES_PASSWORD" \
        psql -c "CREATE DATABASE $DBNAME WITH OWNER '$DBUSER';" \
             -v ON_ERROR_STOP=1 \
             -U "$POSTGRES_USER" "$POSTGRES_DB"
    # Five commands being run as database user
    PGPASSWORD="$DBPASS" \
        psql -c "CREATE EXTENSION postgis;" \
             -v ON_ERROR_STOP=1 \
             -U "$DBUSER" "$DBNAME"
    PGPASSWORD="$DBPASS" \
        psql -c "CREATE EXTENSION pg_trgm;" \
             -v ON_ERROR_STOP=1 \
             -U "$DBUSER" "$DBNAME"
    PGPASSWORD="$DBPASS" \
        psql -c "CREATE EXTENSION unaccent;" \
             -v ON_ERROR_STOP=1 \
             -U "$DBUSER" "$DBNAME"
    PGPASSWORD="$DBPASS" \
        psql -c "CREATE EXTENSION IF NOT EXISTS btree_gist;" \
             -v ON_ERROR_STOP=1 \
             -U "$DBUSER" "$DBNAME"
    PGPASSWORD="$DBPASS" \
        psql -c "CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\";" \
             -v ON_ERROR_STOP=1 \
             -U "$DBUSER" "$DBNAME"
    # Finally, one command being rnu as root
    PGPASSWORD="$POSTGRES_PASSWORD" \
        psql -c "ALTER ROLE $DBUSER NOSUPERUSER;" \
             -v ON_ERROR_STOP=1 \
             -U "$POSTGRES_USER" "$POSTGRES_DB"

}

# convert environment into arrays
ARR_DATABASES=($PG_DATABASES)
ARR_USERNAMES=($PG_USERNAMES)
ARR_PASSWORDS=($PG_PASSWORDS)

# are they the same length?
if [ "${#ARR_DATABASES[@]}" -ne "${#ARR_USERNAMES[@]}" ] ||
   [ "${#ARR_PASSWORDS[@]}" -ne "${#ARR_USERNAMES[@]}" ]
then
  echo "Error: Number of databases, users and passwords must match."
  exit 1
fi
for i in "${!ARR_DATABASES[@]}"
do
  create_db "${ARR_DATABASES[i]}" "${ARR_USERNAMES[i]}" "${ARR_PASSWORDS[i]}"
done
