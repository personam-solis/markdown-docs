# **PostgreSQL**
These are some basic notes for PostgreSQL. Although you can run the below commands/query on *any* PG server, it is easier to use the supplied docker container.

<br>
 
**Docker Cheat-sheet:**
* Run adhoc bash commands: `docker exec -u 'postgres:postgres' imdb-test /bin/bash -c '<COMMAND>'`
* Log into DB server: `docker container exec -it imdb /bin/bash -c 'psql -U postgres -W -d imdbdata'`



<br>
<br>

## **Info**
Things to keep in mind

* **Tablespaces** are sym linked inside of `$PGDATA/pg_tblspc` to map it back to the DB
  * This is important because the Tablespace can be *ANYWHERE* on the host.
* *Users* and *Groups* are 'Roles'
* You can create a group role simply by adding a flag that it can inherit. Afterwards, grant it access like normal and then add roles to it
  * `CREATE ROLE <ROLE_NAME> INHERIT;`
  * `GRANT <PERMISSIONS> TO <GROUP_ROLE>`
  * `GRANT <GROUP_ROLE> TO <EXISTING_ROLE;`

<br>

## **Introspection Commands**
Common and useful introspection commands
| Command | Purpose | Notes |
|---------|---------|-------|
| `\?` | Shows all introspection commands | |
| `\h <KEYWORD>` | Get help on a SQL statement | |
| `\l+` | *List* all databases | |
| `\c <DB>` | *Connect* to another database | Changes the local namespace |
| `\errverbose` | Shows the last error message verbosely | |
| `\d+` | *Describe* tables and views for current database | Only for what the user has access to. |
| `\dg+` | Describe roles | |
| `\dE+` | Describe foreign tables | |
| `\dn+` | Describe schemas in the current database | |
| `\dy+` | Describe event triggers | |
| `\dS+` | Describe system tables | Most useful for showing all system tables in the system `postgres` database |
| `\sv+ <VIEW_NAME>` | Show the list view definition | |
| `\z` | Describe table, view, and sequence access privileges | same as `\dp` |
| `\x` | Turn on *expanded* display (toggle) | Show results as a list instead of a table. Useful for long columns |

<br>

## **Admin Queries/Commands**
These are some basic queries that are common and useful from an administrative perspective.

| Query/Command | Purpose | Notes |
|---------------|---------|-------|
| `SELECT pid, wait_event_type, wait_event, state, query FROM pg_stat_activity WHERE wait_event IS NOT NULL AND state IS NOT Null;` | Get all queries that are running on active connections | You can use this to kill conn. that are running too long |
| `CREATE DATABASE <NEW_DB> TEMPLATE <EXISTING_DB>;` | Create a copy of an existing database | |
| `SELECT pg_size_pretty(pg_database_size(pg_database.datname)) AS size, pg_database.datname AS db_name FROM pg_database;` | Get the size of all databases | |
| `<COLUMN_NAME> int GENERATED ALWAYS AS IDENTITY, PRIMARY KEY ( <COLUMN_NAME> );` | When creating a table, have postgres auto-assign an integer and use that as the Primary Key |  |
| `CREATE SCHEMA IF NOT EXISTS <NAME> AUTHORIZATION <ROLE>;` | Create a schema and add the role to it | |
| `ALTER TABLE <TABLE> SET SCHEMA <SCHEMA>;` | Add an existing table to a schema | *WARNING: You can break everything if you do this. Understand ALL views, functions, and Triggers.* |
| `SELECT inet_server_addr();` | Get the IP(s) that the server listens on | |
| `SELECT inet_server_port();` | Get the port that the server listens on | |

<br>

## **Shell Commands**
Commands used from the OS. This uses postgres utilities that are installed alongside the database engine.

| Command | Purpose | Notes |
|---------|---------|-------|
| `oid2name` | Map the Main Object ID in a directory with a database and tablespace | Used to determine which OID in `$PGDATA/base` belongs to what |
| `oid2name -d <database>` | Search through `$PGDATA/base` for the database you want, and map FileNode to specific table | Since files in the dir cannot be >1GB, an extension is added to the FileNode `$PGDATA/base/<OID>/<FileNode>.<Integer>` |
| `oid2name -s` | Show all Tablespace OID's | |

<br>

<br>

## **Useful DB Queries/Commands**

These are some basic queries that are common and useful to general users.

| Query/Command | Purpose | Notes |
|---------------|---------|-------|
| `SET search_path TO <SCHEMA>;` | Change the current search path | You can always use fully qualified objects `schema.object_name` |
| `SELECT schemaname, tablename, tableowner FROM pg_tables WHERE schemaname NOT IN ('pg_catalog', 'information_schema') ORDER BY schemaname DESC;` | Show all tables across all schemas that are not part of the system | |

<br>

<br>

## **Functions**

<br>

<br>

## **Triggers**

<br>

<br>

## **Partition**

<br>

<br>

## **General Notes**

**Schemas**
Schemas contain database objects such as tables, views, indexes, data types, functions, stored procedures and operators. A database contains one or more named schemas, which in turn contain tables.

Each schema is its own namespace; there are no conflict with objects across schemas, but they can in the schema. You can switch between namespaces, but if you need to reference multiple schemas or ones with name conflicts, use the full object name.

To access an object regardless of search path.: `schema_name.object_name`

<br>

**View**
In its simplest form, a view is a query that is atomatically executed when you access the table.
