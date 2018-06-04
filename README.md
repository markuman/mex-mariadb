# mex mariadb client

[![pipeline status](https://gitlab.com/markuman/mex-mariadb/badges/master/pipeline.svg)](https://gitlab.com/markuman/mex-mariadb/commits/master)

* https://gitlab.com/markuman/mex-mariadb
* https://git.osuv.de/m/mex-mariadb

Test condition
  * Linux + Octave + MariaDB 
  * Linux + Octave + MySQL
 
I guess it will work for Matlab too.


# Build

```
$ make
mkoctfile --mex  -L/usr/lib  -lmysqlclient -lpthread -lz -lm -ldl -lssl -lcrypto -I/usr/include/mysql mariadb.c
```


# example

you can take a look at `gitlabci.m` file too. the classdef file `mariadb.m` and the mex file `mariadb_.mex` are both used for testing.

## class def example
```
octave:1> sql = mariadb('hostname', '127.0.0.1', 'password', 'password');
octave:2> sql.query('create database octave')
ans = [](0x0)
```

to change a database, you can recreate your class  
or change the property `sql.database = 'octave'`.

```
octave:3> sql = mariadb('hostname', '127.0.0.1', 'password', 'password', 'database', 'octave');
octave:4> sql.query('create table a (idx int)');
octave:5> sql.query('insert into a (idx) values (1),(2),(3),(4)');
octave:6> sql.query('select * from a')
ans =
{
  [1,1] = idx
  [2,1] = 1
  [3,1] = 2
  [4,1] = 3
  [5,1] = 4
}
```

you can change the output format to matrix

```
octave:7> sql.output = 'mat'
sql =

<object mariadb>

octave:8> sql.query('select * from a')
ans =

   NaN
     1
     2
     3
     4

octave:9>
```

## return structure

the return structure is always a cell.

```
octave:1> a = mariadb_('127.0.0.1', 3306, 'root', 'password', 'testdb', 'select * from a')
a =
{
  [1,1] = idx
  [2,1] = 1
  [3,1] = 2
  [4,1] = 8
  [5,1] = 1
  [6,1] = 2
  [7,1] = 8
  [1,2] = b
  [2,2] = NULL
  [3,2] = NULL
  [4,2] = NULL
  [5,2] = 1
  [6,2] = 2
  [7,2] = 3
}
```

```
select * from a;

idx |b |
----|--|
1   |  |
2   |  |
8   |  |
1   |1 |
2   |2 |
8   |3 |
```

# mariadb()

## properties

* `hostname`
  * char, default `localhost`
* `port`
  * number, default `3306`
* `username`
  * char, default `root`
* `password`
  * char, default `password`
* `database`
  * char, default empty string. Connects to no database
* `command`
  * char, sql command
* `is_octave`
  * boolean, determines if class was init on matlab or octave
* `output`
  * char, defines the output format. currently supports only `mat` and `cell`

## methods

* `query(command)`
  * executes sql command
* `to_mat()`
  * only used internally to convert the cell output to matrix format.


