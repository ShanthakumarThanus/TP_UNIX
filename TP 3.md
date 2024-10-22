# TP 03 Shell bash - Thanus SHANTHAKUMAR

## Exercice : paramètres

Voici le script "analyse.sh" : 

    ```bash
    #!/bin/bash

    printf "Bonjour, vous avez rentrée $# paramètres. \n"
    printf "Le nom du script est $0. \n"
    printf "Le 3ème paramètre est $3. \n"

    for var in "$@"
    do
            printf "Voici la liste des paramètres : $var \n"
    done
    ```

## Exercice : vérification du nombre de paramètres

Voici le script "concat.sh" :

    ```bash
    #!/bin/bash
    
    if [ "$#" -ne 2 ]; then
        printf "Erreur : Veuillez saisir 2 arguments"
        exit 1
    fi

    arg1=$1
    arg2=$2
    CONCAT="${arg1} ${arg2}"

    printf "Résultat : $CONCAT"
    ```

## Exercice : argument type et droits

Voici le script "test-fichier.sh" :

    ```bash
    #!/bin/bash
    
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
    ```

## Exercice : Afficher le contenu d'un répertoire

Voici le script "listedir.sh" :

    ```bash
    #!/bin/bash

    if [ -z "$1" ]; then
    printf "Veuillez saisir le chemin du répertoire."
    exit 1
    fi

    printf "Fichiers dans le répertoire $1 :"
    find "$1" -maxdepth 1 -type f

    printf -e "\nSous-répertoires dans le répertoire $1 :"
    find "$1" -maxdepth 1 -type d ! -path "$1"
    ```

## Exercice : Lister les utilisateurs

Voici le script pour afficher la liste des noms de login des utilisateurs définis dans /etc/passwd ayant un UID supérieur à 100 : 

    ```bash
    #!/bin/bash
    
    while IFS=: read -r username _ uid _; do
    if [ "$uid" -gt 100 ]; then
        printf "$username \n"
    fi
    done < /etc/passwd
    ```

La commande `for user in $(cat /etc/passwd); do echo $user;` présente un problème lorsqu'elle divise le contenu en éléments individuels en fonction des espaces, ce qui ne convient pas pour parcourir chaque ligne. Résolution du problème à l'aide de : 

    `cut` :

    ```bash
    #!/bin/bash

    while IFS=: read -r ligne; do
    username=$(printf "$ligne" | cut -d: -f1)
    uid=$(printf "$ligne" | cut -d: -f3)
    if [ "$uid" -gt 100 ]; then
        printf "$username : $uid"
    fi
    done < /etc/passwd
    ```

    et `awk` :

    ```bash
    #!/bin/bash

    awk -F: '$3 > 100 {print $1}' /etc/passwd
    ```


## Exercice : Mon utilisateur existe t’il

Script pour vérifier si un utilisateur existe déjà, soit par son login, soit par son UID :

    ```bash
    #!/bin/bash

    # Vérifier si un argument est fourni
    if [ -z "$1" ] || [ -z "$2" ]; then
    printf "Usage: $0 <login|uid> <value>"
    exit 1
    fi

    # Vérification par login
    if [ "$1" == "login" ]; then
    uid=$(grep "^${2}:" /etc/passwd | cut -d: -f3)
    [ -n "$uid" ] && printf "UID de l'utilisateur $2 : $uid"
    fi

    # Vérification par UID
    if [ "$1" == "uid" ]; then
    login=$(awk -F: -v uid="$2" '$3 == uid {print $1}' /etc/passwd)
    [ -n "$login" ] && printf "L'utilisateur avec l'UID $2 est : $login"
    fi
    ```

## Exercice : Creation utilisateur

Script pour créer un compte utilisateur :

    ```bash
    #!/bin/bash

    # vérification root
    if [ "$USER" != "root" ]; then
        printf "Ce script doit être exécuté en tant que root."
        exit 1
    fi

    # demande les informations nécessaires
    read -p "Login: " login
    read -p "Nom: " nom
    read -p "Prenom: " prenom
    read -p "UID: " uid
    read -p "GID: " gid
    read -p "Commentaires: " commentaires

    # vérification si utilisateur existe déjà
    if id -u "$login" >/dev/null 2>&1; then
        printf "L'utilisateur $login existe déjà."
        exit 1
    fi

    # vérifier si le répertoire home existe déjà
    if [ -d "/home/$login" ]; then
        printf "Le répertoire /home/$login existe déjà."
        exit 1
    fi

    # créer le nouvel utilisateur
    useradd -m -d "/home/$login" -u "$uid" -g "$gid" -c "$nom $prenom, $commentaires" "$login"

    # vérifier si la création a réussi
    if [ $? -eq 0 ]; then
        printf "Utilisateur $login créé avec succès."
    else
        printf "Échec de la création de l'utilisateur $login."
        exit 1
    fi
    ```

## Exercice : lecture au clavier

- Comment quitter more ? Avec la touche "q"
- Comment avancer d'une ligne ? Appuyer sur "Entrée"
- Comment avancer d'une page ? Appuyer sur "Espace"
- Comment remonter d'une page ? Appuyer sur "b"
- Comment chercher une chaîne de caractères ? Appuyer sur "/"
- Passer à l'occurence suivante ? Appuyer de nouveau sur "/" puis "Entrée"

Script qui propose à l'utilisateur de visualiser page par page chaque fichier texte du répertoire spécifié en argument :

    ```bash
    # vérifier si l'argument donné est bien un répertoire
    if [ -z "$1" ]; then
        printf "Veuillez saisir le nom du fichier"
        exit 1
    fi

    # boucle for pour parcourir chaque fichier du répertoire
    for file in "$1"/*; do
        # vérifier si c'est un fichier .txt
        if file "$file" | grep -q "text"; then
        # demande à l'utilisateur, la réponse sera stockée dans "response"
        read -p "Voulez-vous visualiser le fichier $file ? (y/n) : " response
                if [ "$response" = "y" ]; then
                        more "$file"
                fi
        fi
    done
    ```

## Exercice : appréciation

Script qui demande à l'utilisateur de saisir une note et qui affiche un message en fonction de la note saisi :

    ```bash
    #!/bin/bash

    while true; do
            read -p "Saississez une note (pour quitter, appuyez sur la touche "q") : " note

            if [ "$note" = "q" ]; then
                    exit 0
            fi

            if [ "$note" -ge 16 ] && [ "$note" -le 20 ]; then
                    printf "Très bien"
            elif [ "$note" -ge 14 ] && [ "$note" -lt 16 ]; then
                    printf "Bien"
            elif [ "$note" -ge 12 ] && [ "$note" -lt 14 ]; then
                    printf "Assez bien"
            elif [ "$note" -ge 10 ] && [ "$note" -lt 12 ]; then
                    printf "Moyen"
            elif [ "$note" -lt 10 ]; then
                    printf "Insuffisant"
            else
                    printf "Note invalide. Veuillez saisir une note entre 0 et 20 ou appuyez sur q pour quitter."
            fi
    done
    ```
