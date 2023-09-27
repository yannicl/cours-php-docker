
#!/bin/bash
> users.txt
> scripts/users.sql
> scripts/databases.sql
for id in $(seq 10 40); do 

pass=$(uuidgen --random)
cat <<Endoftemplate >> users.txt
# site$id:$pass
Endoftemplate

cat <<Endoftemplate >> scripts/databases.sql
CREATE DATABASE site$id;
Endoftemplate

cat <<Endoftemplate >> scripts/users.sql
CREATE USER 'site$id'@'localhost' IDENTIFIED BY '$pass';
GRANT INSERT, UPDATE, DELETE, SELECT on site$id.* TO 'site$id'@'localhost' WITH GRANT OPTION;
CREATE USER 'site$id'@'%' IDENTIFIED BY '$pass';
GRANT ALL PRIVILEGES on site$id.* TO 'site$id'@'%' WITH GRANT OPTION;

Endoftemplate

done

exit

