
#!/bin/bash
> users.conf
for id in $(seq 10 40); do 

pass=$(uuidgen --random)

cat <<Endoftemplate >> users.conf
site$id:$pass:20$id:101:html
Endoftemplate

done

exit

