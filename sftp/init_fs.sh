#!/bin/bash
for id in $(seq 10 40); do 
rm -rf /home/site$id/html
if [ ! -d "/home/site$id" ] 
then
    mkdir /home/site$id
fi
chown root /home/site$id
chgrp root /home/site$id
chmod 755 /home/site$id
if [ ! -d "/home/site$id/html" ] 
then
    mkdir /home/site$id/html
fi
chown site$id /home/site$id/html
chgrp 101 /home/site$id/html
chmod 750 /home/site$id/html

cat <<Endoftemplate > /home/site$id/html/index.php
<!DOCTYPE html>
<html>
<head>
<title>Hello World from site10</title>
</head>
<body>
<h1>My first PHP page</h1>
<?php
echo "Hello World from site10!";
?>
</body>
</html>
Endoftemplate

chmod 644 /home/site$id/html/index.php

done

exit
