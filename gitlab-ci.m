% test mex-mariadb

function last_words()
    disp ("all test passed")
end

%% test raw mariadb mex file

retval = mariadb_('mariadb', 3306, 'root', 'password', 'octave', 'select version() as version')
assert(2 == length(retval))
assert(1 == strcmp(retval{1}, 'version'))
assert(1 == strfind (retval{2}, '10.2.13-MariaDB') || strfind (retval{2}, '5.7.21'))

%% classdef tests

sql = mariadb('hostname', 'mariadb', 'password', 'password');
retval = sql.query('select version() as version');
assert(2 == length(retval))
assert(1 == strcmp(retval{1}, 'version'))
assert(1 == strfind (retval{2}, '10.2.13-MariaDB') || strfind (retval{2}, '5.7.21'))

sql.output = 'mat';
retval = sql.query('select version() as version');
assert(1 == ismatrix(retval))

atexit ("last_words");