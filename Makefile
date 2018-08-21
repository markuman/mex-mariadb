build: ## build against -lmariadbclient
	mkoctfile --mex  -L/usr/lib  -lmariadbclient -lpthread -lz -lm -ldl -lssl -lcrypto -I/usr/include/mariadb mariadb.c
	mv mariadb.mex mariadb_.mex


mysql: ## build against -lmysqlclient
	mkoctfile --mex  -L/usr/lib  -lmysqlclient -lpthread -lz -lm -ldl -lssl -lcrypto -I/usr/include/mysql mariadb.c
	mv mariadb.mex mariadb_.mex


gcc: ## build mex file with GCC
	gcc -fpic -shared -L/usr/lib -lmysqlclient -lpthread -lz -lm -ldl -lssl -lcrypto -I/usr/include/mysql -I/usr/include/octave-4.4.0/octave/ mariadb.c -o mariadb_.mex

gcs: ## install google cloud shell dependencies
	sudo apt install octave liboctace-dev libmariadbclient-dev
	
centos: ## build mex file on centos 7
	gcc -std=gnu99 -fpic -shared -L/usr/lib64/mysql/ -lmysqlclient -lpthread -lz -lm -ldl -lssl -lcrypto -I/usr/include/mysql -I/usr/include/octave-3.8.2/octave/ mariadb.c -o mariadb_.mex

test: ## run tests
	octave-cli --eval 'quit(or(0, mUnittest("gitlabci")))'
