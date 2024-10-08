# UNIX - TP 01 : Installation Serveurs 


### Partie Installation :

### Partie SSH :

#### Commandes utilisés :

`apt search ssh`
`apt install ssh`

`dpkg -l | wc -l` : m’affiche 325

`ip addr show`
`apt install openssh-server`
`systemctl enable –now ssh.service`
`systemctl status sshd`

Commande utilisé pour se connecter au serveur : `ssh root@localhost -p 2222`(redirection des ports)

## 2.5

`$LANG` : affiche le résultat suivant -> `fr_FR.UTF-8`. Cela permets d'afficher les paramètres régionaux du système. Ici, `fr_FR.UTF-8` signifie que la langue par défaut est le français (France) et que l'encodage utilisé est UTF-8.

`hostname` : Renvoie le nom de la machine hôte. Cela renvoie 'serveur1'

domaine : Pour afficher le domaine, il faut exécuter la commande `hostname -d`. Ici cela m'affiche le résultat suivant : `ufr-info-p6.jussieu.fr`

La vérification de l'emplacement depots via la commande `cat /etc/apt/sources.list | grep -v -E '^#|^$'` affiche : 

`deb http://deb.debian.org/debian/ bookworm main
deb-src http://deb.debian.org/debian/ bookworm main
deb http://security.debian.org/debian-security bookworm-security main
deb-src http://security.debian.org/debian-security bookworm-security main
deb http://deb.debian.org/debian/ bookworm-updates main
deb-src http://deb.debian.org/debian/ bookworm-updates main`
. Cette commande affiche toutes  les lignes du fichier "source.list" pour voir les dépôts configurés.

Résultat de la commande `cat /etc/shadow | grep -vE ’:\*:|:!\*:’` : 

`root:$y$j9T$zKGHxrni6Ob7fHmYoCwcG0$yqvawmF9aqtCa6dXiJrUo/LvuqjYputX5U9iGdm.GM0:19996:0:99999:7:::
messagebus:!:19996::::::
avahi-autoipd:!:19996::::::
sshd:!:19998::::::` . Cela affiche les hachages de mot de passe chiffrés pour les comptes utilisateurs du système.

Résultat de la commande `cat /etc/passwd | grep -vE 'nologin|sync` : root:x:0:0:root:/root:/bin/bash

`fdisk -l` : Affiche les informations des disques durs et les partitions du système
`fdisk -x` : Similaire à la commande précédente, avec l'UUID, qui est l'identifiant permettant d'identifier chaque périphérique de stockage et de partition

`df -h` : Indique l'espace utilisé et disponible sur le système de fichiers contenant chaque fichier donné en paramètre. L'option -h affiche les tailles en puissances de 1024.

`preseed` : Est une commande permettant d'automatiser l'installation d'un système Debian. Ceci fonctionne en pré répondant au question posées par l'installateur, noté dans ce fichier. 

## 3.2 rescue mode

Pour modifier le mot de passe root, il faut :

Accéder à GRUB :

Démarre Debian et appuie sur la touche Shift ou Esc pour accéder au menu GRUB.
Modifier l’entrée de démarrage :

Sélectionne l'entrée Debian normale dans GRUB, puis appuie sur la touche e pour éditer la ligne de démarrage.
Modifier les options du noyau :

Repère la ligne qui commence par linux, et à la fin de cette ligne, ajoute :
bash
Copier le code
init=/bin/bash
Cela va démarrer directement dans un shell root.
Changer le mot de passe root :

Une fois dans le shell, remonte la partition racine en lecture/écriture :
bash
Copier le code
mount -o remount,rw /
Change le mot de passe root avec la commande :
bash
Copier le code
passwd root
Entre un nouveau mot de passe, puis confirme le.
Redémarrage :

Redémarre le système avec la commande :
bash
Copier le code
reboot


## 3.3 redimensionnement partition

Pour redimensionner la partition racine sans interface graphique, voici les étapes :

Sauvegarde des données : Sauvegarde toutes les données importantes avant toute manipulation.

Vérification de l’espace disponible :

Utilise df -h pour vérifier l’espace disponible sur les disques.
Mode single-user (monoutilisateur) :

Il est nécessaire de démarrer le système en mode monoutilisateur pour éviter que la partition racine soit active. Démarre dans ce mode en modifiant l'entrée GRUB comme précédemment, mais en ajoutant single à la ligne du noyau.
Démonter ou démonter la partition racine :

Si tu redimensionnes une partition qui est utilisée, démarre depuis un Live USB en mode console ou un environnement de secours.
Utiliser fdisk ou parted pour redimensionner la partition :

Par exemple, avec fdisk :
bash
Copier le code
sudo fdisk /dev/sda
Supprime la partition existante et recrée-la avec la taille modifiée. Fais attention à bien recréer la partition avec les mêmes secteurs de début pour ne pas perdre de données.
Redimensionner le système de fichiers :

Après avoir modifié la taille de la partition, redimensionne le système de fichiers avec resize2fs :
bash
Copier le code
sudo resize2fs /dev/sda1
Vérification finale :

Utilise df -h pour vérifier que le redimensionnement a bien été pris en compte.
