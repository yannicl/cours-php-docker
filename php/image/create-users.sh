#!/bin/bash

for i in $(seq 10 40); do 
groupadd --gid "20$i" "site$i";
useradd --uid "20$i" --gid "site$i" "site$i";
done