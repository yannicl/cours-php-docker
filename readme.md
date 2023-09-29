# Dockerized PHP Mysql Sftp multiple sites
This dockerized environnement allows you to deploy PHP and Mysql for multiple sites. This setup may be used to offer students with an environnement to deploy their code.

Each site has :
- a dedicated subdomain
- an isolated website folder
- a dedicated PHP process
- a Mysql database with an administrative acces through Phymyadmin
- SFTP access to the website folder

The account provisionning is performed before docker containers are created through bash file.

A single set of containers is created for all sites :
- Nginx container for static file handling and front door
- Php-fpm container for PHP execution
- Mysql container for databases
- Phpmyadmin container for database management
- SFTP container for remote access

## Site isolation

Isolation between the sites is based on unix users and groups.

Website folders are shared between Nginx, SFTP and PHP-FPM containers via docker volume. 

On SFTP the site user belongs to the same group gid than the nginx group of the Nginx container. Because of that any folder and file created by site user is accessible to the Nginx process as long as group read permission are granted.

On SFTP and PHP-FPM container, a unix user is created for each site. The same user gid is used on both containers.

The file structure and permission seen on the sftp container :

```
/home/site10/html/index.php
```

```
drwxr-xr-x  33 root   root            4096 Sep 24 01:42 home
drwxr-xr-x   3 root   root            4096 Sep 24 01:43 site10 
drwxr-x---   2 site10 systemd-journal 4096 Sep 25 00:38 html
-rw-r--r--   1 site10 systemd-journal 169 Sep 24 01:46 index.php
```

The file structure and permission seen on the nginx container :

```
/var/www/html/site10/html/index.php
```

```
drwxr-xr-x  1 root root  4096 Sep 25 02:01 var
drwxr-xr-x  3 root root  4096 Sep 25 02:01 www
drwxr-xr-x 33 root root  4096 Sep 24 01:42 html
drwxr-xr-x  3 root root  4096 Sep 24 01:43 site10
drwxr-x---  2 2010 nginx 4096 Sep 25 00:38 html
-rw-r--r--  1 2010 nginx  169 Sep 24 01:46 index.php
```

The file structure and permission seen on the PHP-FPM container :

```
/var/www/html/site10/html/index.php
```

```
drwxr-xr-x  1 root   root  4096 Sep 25 02:01 var
drwxr-xr-x  3 root   root  4096 Sep 25 02:01 www
drwxr-xr-x 33 root   root  4096 Sep 24 01:42 html
drwxr-xr-x  3 root   root  4096 Sep 24 01:43 site10
drwxr-x---  2 site10 101   4096 Sep 25 00:38 html
-rw-r--r--  1 site10 101    169 Sep 24 01:46 index.php
```

## File init

Run the *init_fs.sh* in the sftp server to reinit the filesystem.