hostname = '127.0.0.1';
port = 3306;
username = 'root';
password = 'password';



a = mariadb_(hostname, port, username, password, 'create database if not exists octave', 'information_schema')
