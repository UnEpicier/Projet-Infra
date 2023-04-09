# Documentation pour l'automatisation

Avant d'utiliser cette documentation vous devez avoir créé 6 machines virtuelles avec chacune une ip différente mais dans le même réseau (exemple :10.108.1.10 / 10.108.1.11...)

## Connexion aux machine par échanges de clé


> ### Vérifier si ssh est bien installé sur votre machine

```sh
> ssh

usage: ssh [-46AaCfGgKkMNnqsTtVvXxYy] [-B bind_interface]

           [-b bind_address] [-c cipher_spec] [-D [bind_address:]port]

           [-E log_file] [-e escape_char] [-F configfile] [-I pkcs11]

           [-i identity_file] [-J [user@]host[:port]] [-L address]

           [-l login_name] [-m mac_spec] [-O ctl_cmd] [-o option] [-p port]

           [-Q query_option] [-R address] [-S ctl_path] [-W host:port]

           [-w local_tun[:remote_tun]] destination [command]
```

> si ceci est affiché alors ssh est installé sinon veuillez taper les commandes suivantes :

```sh
> sudo apt-get install openssh-server

> sudo systemctl enable ssh

> sudo systemctl start ssh
```


> ### Génération de la clé sur votre machine

```sh
```