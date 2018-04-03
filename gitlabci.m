%% test raw mariadb mex file

retval = mariadb_('mariadb', 3306, 'root', 'password', 'octave', 'select version() as version')
assert(2 == length(retval), 'data length must be 2')
assert(1 == strcmp(retval{1}, 'version'), 'first cell value must be string "version"')
assert(1 == strfind (retval{2}, '10.2.13-MariaDB') || strfind (retval{2}, '5.7.21'), 'check for mariadb/mysql version')

%% classdef tests

sql = mariadb('hostname', 'mariadb', 'password', 'password');
retval = sql.query('select version() as version');
assert(2 == length(retval), 'data length mus be 2')
assert(1 == strcmp(retval{1}, 'version'), 'first cell value must be string "version"')
assert(1 == strfind (retval{2}, '10.2.13-MariaDB') || strfind (retval{2}, '5.7.21'), 'check for mariadb/mysql version')

sql.output = 'mat';
retval = sql.query('select version() as version');
assert(1 == ismatrix(retval), 'return value must be a Matrix')
