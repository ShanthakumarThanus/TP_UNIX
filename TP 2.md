## Thanus SHANTHAKUMAR  - TP 02 : Services, processus signaux 

## 1 Secure Shell : SSH

### 1.1 Exercice : Connection ssh root (reprise fin tp-01)

### 1.2 Exercice : Authentification par clef / Généreation de clefs

Commande pour générer une paire de clés SSH : `ssh-keygen`
La clé est généré sans passphrase, dans le répertoire par défaut (C:\Users\Theepiga/.ssh/id_rsa).

L'Empreinte de clé publique est : SHA256:XSPAf9jVzAgM63SPmorb7JVzebfsXtQw8Bg+6DURyBI theepiga@DESKTOP-BDT7ILB

### 1.3 Exercice : Authentification par clef / Connection serveur

### 1.4 Authentification par clef : depuis la machine hote

connexion avec SSH : `ssh -i ~/.ssh/id_rsa.pub root@localhost -p 2222` 

### 1.5 Sécurisez 

La procédure pour sécuriser la machine via ssh pour root par clef seulement afin d'éviter les tentatives d'authentification par brute force ssh, est le suivant :

Générer une paire de clés SSH :

    Utilisez ssh-keygen pour créer une paire de clés (clé publique et clé privée).

Copier la clé publique sur le serveur :

    Utilisez ssh-copy-id ou copiez manuellement la clé publique dans le fichier ~/.ssh/authorized_keys du serveur.

Configurer le fichier SSH sur le serveur :

    Modifiez /etc/ssh/sshd_config pour désactiver l'authentification par mot de passe et autoriser l'accès root par clé.
    Exemple de configuration :

    plaintext

    PermitRootLogin yes
    PasswordAuthentication no
    ChallengeResponseAuthentication no

Redémarrer le service SSH :

    Pour appliquer les modifications, redémarrez le service SSH avec systemctl restart sshd ou service ssh restart.

Les attaques de type brute-force ssh consiste à effectuer une succession d'essais pour découvrir un couple utilisateur/mot de passe valide afin de prendre le contrôle de la machine à l'aide d'une connexion SSH.

D'autres techniques que j'ai trouvé pour protéger contre ce type d'attaque :

Changer de port : 
Avantage : Permet d'éviter un bon nombre d'attaques car certains robots ne tentent de se connecter que sur le port par défaut.
Inconvénient : Il arrive que la plupart des ports soient bloqués en sortie, et que seuls certains ports couramment utilisés (comme 22, 80 et 443) soient disponibles sur certains réseaux. 

Configurer le nombre de tentatives d'authentification par connexion : Réduire le nombre de tentatives de connexion.
Avantage : Permet de limiter l'efficacité des attaques lors de l'utilisation de règles basées sur le nombre
de connexions puisque la connexion sera alors fermée automatiquement après un certains nombre de tentatives prédéfini. 
Inconvénient : Ce paramètre tient compte de toutes les tentatives d'authentification (mot de passe, clé SSH...). Un utilisateur ayant deux clés SSH disponibles aura donc deux tentatives d'authentification
décomptées automatiquement, si aucune de ces deux clés n'est acceptée.

Configuration du pare-feu : La configuration d'un pare-feu permets d'établir une liste noire de machines ou réseaux pour les empêcher d'accéder au service.
Avantage : Permet de réduire le nombre d'attaques provenant de réseaux connus pour beaucoup pratiquer ce genre d'attaque.
Inconvénient : Dans la pratique, cela ne se révèle pourtant que très peu efficace, puisqu'il faut tout d'abord trouver la liste des machines ou réseaux à bloquer, puis la maintenir.

## 2.1 Exercice : Etude des processus UNIX

### 1 :
J'ai affiché la liste de tous les processus tournant sur ma machine à l'aide de la commande `ps -e`.
1.1 - TIME : Temps CPU cumulé, utilisateur plus système.
1.2 - Le processus ayant le plus utilisé le processeur sur la machine est "kworker/0:0-eve". Commande utilisé : "ps -eo pid,comm,%cpu --sort=-%cpu
1.3 - Le premier processus lancé après le démarrage du sysème est "systemd"
1.4 - Ma machine a démarré à 14:04. Commande utilisé : `uptime`. Résultat : 15:39:28 up  1:35,  2 users,  load average: 0,00, 0,00, 0,00.
1.5 - Le nombre approximatif de processus créés depuis le démarrage "boot" de ma machine peut être établi à l'aide de cette commande : `ls /proc | grep '^[0-9]' | wc -l`.
Le nombre de processus créés depuis le démarrage "boot" est : 80.

### 2 :
2.1 - Commande utilisé pour afficher le PPID d'un processus : `ps -o ppid= -p <"pid d'un processus">`. Test avec `ps -o ppid= -p 584`, renvoie "1".
2.2 - Commande utilisé pour afficher tous les processus ancêtres de la commande ps en cours d'exécution : `pstree -p | grep -A 10 ps`.

### 3
3.1 Pour afficher la liste ordonnée de tous les processus ancêtres de la commande ps en cours d'exécution avec pstree : `pstree -p | grep -A 10 -B 10 'ps'`.

### 4
4.1 - Dans top, pour afficher la liste de processus triée par occupation mémoire et décroissante, il faut appuyer simultanément sur `Shift + m`. 
4.2 - Le processus le plus gourmand sur la machine Debian est sshd (PID 624). sshd signifie "SSH daemon" est un programme qui s'exécute en arrière-plan sur les systèmes
Linux/Unix et qui permet aux utilisateurs de se connecter à une machine à distance via le protocole SSH. 

4.3 :
- La commandes permettant de passer l'affichage en couleur dnas top est tout simplement la touche `z`.
- Mettre en avant la colonne de tri : `x`. 
- Changer la colonne de trie : `Shift + f`.

4.4 
La commande `htop` contient de nombreux avantages par rapport à `top`. Les avantages sont :
- interface plus conviviale et adaptée à la taille de l'affichage (des couleurs sont présent !)
- possibilité d'arrêter (ou de killer) un processus sans connaître son PID
- possibilité de modifier en direct la priorité d'un processus sans connaître son PID
- pas de délai entre les actions
- support de la souris
La commande `htop` contient également des défauts malheureusement, tels que :
- `htop` n'est pas installé par défaut, j'ai dû exécuter la commande `sudo apt install htop` avant de pouvoir l'utiliser
- `htop` est plus gourmand sur la mémoire et le CPU en raison de son interface graphique et de son rafraîchissement plus détaillé, ce sont des facteurs à considérer
lorsque l'on travail sur des systèmes très limités en ressources

## 3 Exercice 2 : Arrêet d'un processus

