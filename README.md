# mex mariadb client

[![pipeline status](https://gitlab.com/markuman/mex-mariadb/badges/master/pipeline.svg)](https://gitlab.com/markuman/mex-mariadb/commits/master)

* https://gitlab.com/markuman/mex-mariadb
* https://github.com/markuman/mex-mariadb

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

# classdef

```
octave:2> m = mariadb();
octave:3> m.query('select version()')
ans =
{
  [1,1] = version()
  [2,1] = 10.2.13-MariaDB-10.2.13+maria~jessie
}
octave:4> m = mariadb('hostname', 'mariadb', 'password', 'password');
octave:5> m.query('select version()')
ans =
{
  [1,1] = version()
  [2,1] = 10.2.13-MariaDB-10.2.13+maria~jessie
}
octave:6>
```

# status

first draft. selecting may work. inserting, updating ect. works, but throws an error?

## TODO

* more classdef wrapper methods for comfortable usage
* better error handling?






