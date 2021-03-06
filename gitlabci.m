%% test raw mariadb mex file

HOSTNAME = getenv('MYSQL_HOST');
if length(HOSTNAME) == 0
  HOSTNAME = '127.0.0.1'
end

MARIADB_10_4 = "10.4.4-MariaDB";
MARIADB_10_3 = "10.3.14-MariaDB";
MARIADB_10_2 = "10.2.17-MariaDB";
MARIADB_10_1 = "10.1.35-MariaDB";
MARIADB_10_0 = "10.0.36-MariaDB";
MARIADB_5_5 = "5.5.61-MariaDB";
MYSQL_5_7 = "5.7.21";

function retval = check_version (input_string)
	retval = strfind (input_string, "10.") || strfind (input_string, "5.");
end

testMex = @(x) strcat('MEX FILE: ', x);
testClassdef = @(x) strcat('CLASSDEF: ', x);

retval = mariadb_(HOSTNAME, 3306, 'root', 'password', 'select version() as version');

assert(2 == length(retval), 
  testMex('data length must be 2'))
  
assert(1 == strcmp(retval{1}, 'version'), 
  testMex('first cell value must be string "version"'))
  
assert(1 == check_version(retval{2}), 
  testMex('check for mariadb/mysql version'))

%% classdef tests
sql = mariadb('hostname', HOSTNAME, 'password', 'password');

retval = sql.query('select version() as version');

assert(2 == length(retval),
  testClassdef('data length must be 2'))

assert(1 == strcmp(retval{1}, 'version'),
  testClassdef('first cell value must be string "version"'))

assert(1 == check_version(retval{2}),
  testClassdef('check for mariadb/mysql version'))

% test change output format
sql.output = 'mat';
retval = sql.query('select version() as version');

assert(1 == ismatrix(retval),
  testClassdef('return value must be a Matrix'))

assert(0 == numel(sql.query('create database if not exists octave')),
  testClassdef('create database octave'))

% test change database
sql.database = 'octave';
assert(0 == numel(sql.query('create table a (idx int)')),
  testClassdef('create table a'))

% test connection with given database
sql = mariadb('hostname', HOSTNAME, 'password', 'password', 'database', 'octave');
sql.output = 'mat';
assert(0 == numel(sql.query('insert into a (idx) values (1),(2),(3),(4)')),
  testClassdef('insert data into table a'))

retval = sql.query('select * from a');
assert(10 == sum(retval(~isnan(retval))),
  testClassdef('sum all numbers of table a'))
assert(isnan(retval(1)),
  testClassdef('first element is not a number'))
