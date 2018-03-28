% test mex-mariadb

function last_words()
    disp ("all test passed")
end

retval = mariadb('mariadb', 3306, 'root', 'password', 'octave', 'select version() as version')

assert(2 == length(retval))
assert(1 == strcmp(retval{1}, 'version'))
assert(1 == strfind (retval{2}, '10.2.13-MariaDB') || strfind (retval{2}, '5.7.21'))

atexit ("last_words");