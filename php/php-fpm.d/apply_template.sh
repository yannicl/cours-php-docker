
#!/bin/bash
cat <<Endoftemplate > zz-docker.conf
[global]
daemonize = no

Endoftemplate

cat <<Endoftemplate > docker.conf
[global]
error_log = /proc/self/fd/2

; https://github.com/docker-library/php/pull/725#issuecomment-443540114
log_limit = 8192

Endoftemplate

> "site.conf"

for id in $(seq 10 40); do 

cat <<Endoftemplate >> zz-docker.conf
[site$id]
listen = 90$id

Endoftemplate

cat <<Endoftemplate >> docker.conf
[site$id]
; php-fpm closes STDOUT on startup, so sending logs to /proc/self/fd/1 does not work.
; https://bugs.php.net/bug.php?id=73886
access.log = /proc/self/fd/2
clear_env = no

; Ensure worker stdout and stderr are sent to the main error log.
catch_workers_output = yes
decorate_workers_output = no

Endoftemplate

cat <<Endoftemplate >> "site.conf"
[site$id]

user = site$id
group = site$id

listen = 127.0.0.1:90$id

pm = dynamic
pm.max_children = 5
pm.start_servers = 2
pm.min_spare_servers = 1
pm.max_spare_servers = 3
; See https://www.digitalocean.com/community/tutorials/how-to-host-multiple-websites-securely-with-nginx-and-php-fpm-on-ubuntu-14-04
php_admin_value[disable_functions] = exec,passthru,shell_exec,system,proc_open,popen,curl_exec,curl_multi_exec,parse_ini_file,show_source
php_admin_flag[allow_url_fopen] = off

Endoftemplate

done

exit

