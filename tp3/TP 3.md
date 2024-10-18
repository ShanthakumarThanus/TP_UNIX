# TP 03 Shell bash - Thanus SHANTHAKUMAR

## Exercice : paramètres

- Voici le script "analyse.sh" : 

    #!/bin/bash

    printf "Bonjour, vous avez rentrée $# paramètres. \n"
    printf "Le nom du script est $0. \n"
    printf "Le 3ème paramètre est $3. \n"

    for var in "$@"
    do
            printf "Voici la liste des paramètres : $var \n"
    done

## Exercice : vérification du nombre de paramètres

- Voici le script "concat.sh" :

    if [ "$#" -ne 2 ]; then
        printf "Erreur : Veuillez saisir 2 arguments"
        exit 1
    fi

    arg1=$1
    arg2=$2
    CONCAT="${arg1} ${arg2}"

    printf "Résultat : $CONCAT"

## Exercice : argument type et droits

- Voici le script "test-fichier.sh" :

    if [ "$#" -ne 1 ]; then
        printf "Erreur : Veuillez saisir un arguments"
        exit 1
    fi

    fichier=$1

    if [ ! -e "$fichier" ]; then
            printf "Le fichier '$fichier' n'existe pas."
            exit 1
    fi

    type_fichier=$(file -b "$fichier")

    permissions=$(ls -l "$fichier" | awk '{print $1}')

    printf "Type du fichier : $type_fichier"
    printf "Permissions d'accès pour l'utilisateur : $permissions"

## Exercice : Afficher le contenu d’un répertoire

- Voici le script "listedir.sh" :



