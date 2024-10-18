#!/bin/bash

printf "Bonjour, vous avez rentrée $# \n"
printf "Le nom du script est $0 \n"
printf "Le 3ème paramètre est $3 \n"

for var in "$@"
do
        printf "Voici la liste des paramètres : $var \n"
done