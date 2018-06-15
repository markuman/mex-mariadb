build:
	mkoctfile --mex  -L/usr/lib  -lmariadbclient -lpthread -lz -lm -ldl -lssl -lcrypto -I/usr/include/mariadb mariadb.c
	mv mariadb.mex mariadb_.mex


mysql:
	mkoctfile --mex  -L/usr/lib  -lmysqlclient -lpthread -lz -lm -ldl -lssl -lcrypto -I/usr/include/mysql mariadb.c
	mv mariadb.mex mariadb_.mex


gcc:
	gcc -fpic -shared -L/usr/lib -lmysqlclient -lpthread -lz -lm -ldl -lssl -lcrypto -I/usr/include/mysql -I/usr/include/octave-4.4.0/octave/ mariadb.c -o mariadb_.mex
