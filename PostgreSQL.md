# **PostgreSQL**

These are some basic notes for PostgreSQL. Although you can run the below commands/query on *any* PG server, it is easier to use the supplied docker container.

<br>
 
## **Docker Cheat-sheet**

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

<br>

### **Foreign Key**

A Foreign key is a type of column constraint where it references another table's **Primary key**; it searches the column of the primary key to ensure that the value exists. 

This is meant for insert statements where the value of an attribute **already** exists. If the value does not already exist, then the insert statement fails.

```sql
CREATE TABLE IF NOT EXISTS products (
  product_no integer PRIMARY KEY,
  name text,
  price numeric
);

CREATE TABLE IF NOT EXISTS orders (
  order_id serial PRIMARY KEY,
  product_no integer REFERENCES products(product_no),
  quantity smallint
);
```

You can also do multiple columns:
`FOREIGN KEY (col1, col2) REFERENCES other_table (col4, col5);`

If you want the primary key to be deleted on all tables that it references, then you can add `ON DELETE CASCADE`

**Another way to do it**

```sql
CONSTRAINT fk_customer
      FOREIGN KEY(customer_id) 
      REFERENCES customers(customer_id)
      ON DELETE SET NULL
```

<br>

### **Views**

A view is a select statement that is auto created and can be referenced by a user.

```sql
CREATE OR REPLACE VIEW <NAME> AS
  SELECT...
;
```

If you want the table to be dropped every time a user disconnects:

```sql
CREATE VIEW TEMP <NAME> AS
  SELECT...
;
```

<br>

<br>

## **Data Types**

Common data types for tables

<br>

### **Numeric**

| Name | Description | # | Name | Description |
|------|-------------|---|------|-------------|
| `smallint` | -32768 to +32767 | # | `integer` | -2147483648 to +2147483647 |
| `bigint` | -9223372036854775808 to +9223372036854775807 | # | `numeric` | Variable user-specified precision up to 131072 digits before the decimal point <br> up to 16383 digits after the decimal point |
| `real` | Variable-precision 6 decimal digits precision | # | `double precision` | Variable-precision 15 decimal digits precision |
| `smallserial` | Autoincrementing integer 1 to 32767 | # | `serial` | Autoincrementing integer 1 to 2147483647 |
| `bigserial` | Autoincrementing integer 1 to 9223372036854775807 | # | `X` | X |

<br>

### **Text**

| Name | Description | # | Name | Description |
|------|-------------|---|------|-------------|
| `char(n)` | Variable-length with limit | # | `varchar(n)` | Fixed-length, blank-padded |
| `bpchar` | Variable unlimited length, blank-trimmed | # | `text` | Variable unlimited length |
| `json` | JSON data types enforce each stored value is valid | # | `jsonb` | Data is stored in a decomposed binary format. <br> Slower to write, faster to process. |

<br>

### **Geometric**

| Name | Description | # | Name | Description |
|------|-------------|---|------|-------------|
| `point` | Point on a plane : `(x,y)` | # | `line` | Infinite line: `{A,B,C}` <br> represented by linear equation `A`*x* + `B`*y* + `C` = 0 |
| `lseg` | Finite line segment : `((x1,y1),(x2,y2))` | # | `box` | Rectangular box : `((x1,y1),(x2,y2))` |
| `polygon` | Polygon : `((x1,y1),...)` | # | `circle` | Circle (center point and radius): `<(x,y),r>` |

<br>

### **Misc.**

| Name | Description | # | Name | Description |
|------|-------------|---|------|-------------|
| `boolean` | `true` or `false` | # | `<DATA_TYPE>[]` | Array: Create a one-dimentional array (add `[]` for more) |
| `inet` | Network Host IP or Network address with CIDR <br> (`192.168.0.0/24` or `192.168.0.1/24`) | # | `macaddr` | Network MAC address of a device <br> (`08:00:2b:01:02:03`, `08-00-2b-01-02-03`, or `08002b010203`) |
| `timestamp` | Date and Time `YYYY-MM-DD hh:mm:dd`, you can include timezone | # | `date` | Date without time, several methods but just use `YYYY-MM-DD` |
| `time` | Time without date `hh:mm:ss` Add timezone to end with `MST` | # | `interval <N> <UNIT>` | Positive or negative integer: <br> units - `year`, `month`, `week`, `day`, `hour`, `minute`, `second` |

<br>

<br>

## **Tables Cheat-Sheet**

| Line | Purpose |
|------|---------|
| `DROP TABLE IF EXISTS` | Drop a table if it exists |
| `CREATE TABLE <NAME> (` <br> `<COLUMN> INT GENERATED ALWAYS AS IDENTITY);` | This clause creates the column as an identity column. It will have an implicit sequence attached to it and the column in new rows will automatically have values from the sequence assigned to it. Such a column is implicitly NOT NULL |
| `PARTITION OF parent_table { FOR VALUES partition_bound_spec \| DEFAULT }` | Creates the table as a partition of the specified parent table. The table can be created either as a partition for specific values using FOR VALUES or as a default partition using DEFAULT |
| `TABLESPACE tablespace_name` | Store table in specific tablespace |
| `FOREIGN KEY (<COLUMN>) REFERENCES <Ref-Table> (<Ref-Column>) ON DELETE RESTRICT ` | Produce an error indicating that the deletion or update would create a foreign key constraint violation |
| `UNIQUE (<COLUMN>) NULLS DISTINCT` | Ensure that the values in a column are distinct and ignore NULL, add `NULLS NOT DISTINCT` to reverse |
| `ALTER TABLE <NAME> ADD <NEW_COLUMN> <DATATYPE\|OPTIONS>;` | Add a new column to a table |

<br>

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
| `CREATE INDEX <NAME> ON <TABLE> (<COLUMN>);` | Create an index on specific column in table | Always create indexes on the most executed and costly queries not a single query |

<br>

<br>

## **INSERT**

| Command | Purpose |
|---------|---------|
| `INSERT INTO <table_name> AS <alias>` | Insert as another role |
| `INSERT INTO .... RETURNING *` | Returning gives you an output and is like a select statement. this outputs what you inserted to verify |
| `INSERT INTO films VALUES ('UA502', 'Bananas', 105, '1971-07-13', 'Comedy');` | Simple insert that assumes you are inserting in the order of the columns |
| `INSERT INTO films (code, title, did) VALUES ('T_601', 'Yojimbo', 106);` | Specify the column then their values |

<br>

<br>

## **Functions**

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
