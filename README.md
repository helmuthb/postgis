# PostGIS

This creates a PostgreSQL server container image with PostGIS enabled and in databases installed.

It can be configured with the following environment variables:

| Variable            | Content                                                 |
|---------------------|---------------------------------------------------------|
| `POSTGRES_PASSWORD` | Password to be used for root user                       |
| `PG_DATABASES`      | List of databases to create (blank-separated)           |
| `PG_USERNAMES`      | List of corresponding users to create (blank-separated) |
| `PG_PASSWORDS`      | List of corresponding passwords (blank-separated)       |

The length of these lists has to be the same.
The elements are taken in order and assumed to belong together.
