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
	curl https://git.osuv.de/m/mUnittest/raw/branch/master/mUnittest.m > mUnittest.m
	octave-cli --eval 'quit(or(0, mUnittest("gitlabci")))'

debug: ## debug
	docker stop db2 && echo "stopped db2" || echo "there was no db2 container"
	docker run -d --rm -p 3306:3306 -e MYSQL_ROOT_PASSWORD=password --name db2 mariadb
	sleep 10
	$(MAKE) mysql
	octave-cli bug.m


macos_mysql: ## build against -lmysqlclient
		mkoctfile --mex  -DDEBUG -L/usr/lib -L/usr/local/lib -L/usr/local/Cellar/mysql/8.0.30_1/lib -lmysqlclient -I/usr/local/Cellar/mysql/8.0.30_1/include/mysql mariadb.c
		mv mariadb.mex mariadb_.mex

macos_mariadb: ## build against -lmariadbclient
		mkoctfile --mex  -DDEBUG -L/usr/lib -L/usr/local/lib -L/usr/local/Cellar/mariadb/10.8.3_1/lib -lmariadb -I/usr/local/Cellar/mysql/8.0.30_1/include/mysql mariadb.c
		mv mariadb.mex mariadb_.mex