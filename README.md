# mex mariadb client

Tested only with GNU Octave and MariaDB. I guess it will work for Matlab and MySQL too.


# Build

```
$ make
mkoctfile --mex  -L/usr/lib  -lmysqlclient -lpthread -lz -lm -ldl -lssl -lcrypto -I/usr/include/mysql mariadb.c
```


# example

```
octave:1> a = mariadb('127.0.0.1', 3306, 'root', 'password', 'testdb', 'select * from a')
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

# status

first draft. selecting may work. inserting, updating ect. works, but throws an error?






