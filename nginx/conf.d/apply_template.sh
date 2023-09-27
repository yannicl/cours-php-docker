
#!/bin/bash
source ../../.env

> site.conf
for id in $(seq 10 40); do 
cat <<Endoftemplate >> site.conf

server {
    index index.php;
    server_name site$id.$DOMAIN;
    root /var/www/html/site$id/html;
    location ~ \.php$ {
        try_files \$uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass php-fpm:90$id;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_param PATH_INFO \$fastcgi_path_info;
    }
}

Endoftemplate

done

exit

