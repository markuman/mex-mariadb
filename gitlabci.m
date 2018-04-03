%% test raw mariadb mex file

testMex = @(x) strcat('MEX FILE: ', x);
testClasdef = @(x) strcat('CLASSDEF: ', x);

retval = mariadb_('mariadb', 3306, 'root', 'password', 'octave', 'select version() as version');

assert(2 == length(retval), 
  testMex('data length must be 2'))
  
assert(1 == strcmp(retval{1}, 'version'), 
  testMex('first cell value must be string "version"'))
  
assert(1 == strfind (retval{2}, '10.2.13-MariaDB') || strfind (retval{2}, '5.7.21'), 
  testMex('check for mariadb/mysql version'))

%% classdef tests
sql = mariadb('hostname', 'mariadb', 'password', 'password');

retval = sql.query('select version() as version');

assert(2 == length(retval),
  testClasdef('data length mus be 2'))

assert(1 == strcmp(retval{1}, 'version'),
  testClasdef('first cell value must be string "version"'))

assert(1 == strfind (retval{2}, '10.2.13-MariaDB') || strfind (retval{2}, '5.7.21'),
  testClasdef('check for mariadb/mysql version'))

sql.output = 'mat';
retval = sql.query('select version() as version');

assert(1 == ismatrix(retval),
  testClasdef('return value must be a Matrix'))
