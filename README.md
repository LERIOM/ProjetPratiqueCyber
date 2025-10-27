# Projet détection d'anomalies par logs avec Docker : Snort et Syslog-ng

Ce projet déploie un système complet de gestion des informations et des événements de sécurité (SIEM) en utilisant Docker. Il intègre **Snort** pour la détection d'intrusions, la **pile Elastic (Elasticsearch et Kibana)** pour l'agrégation et la visualisation des logs, et **syslog-ng** comme transitaire de logs central.

L'ensemble de l'environnement est conteneurisé, ce qui le rend facile à déployer, à gérer et à faire évoluer.


## 🏛️ Architecture

Ce projet utilise une configuration Docker multi-conteneurs orchestrée avec `docker-compose`.

* **Snort (`snort`)** : Le système de détection d'intrusions (IDS) qui surveille le trafic réseau. Il est configuré pour fonctionner en mode IDS et écouter sur l'interface `eth0`. Toutes les alertes sont écrites dans le fichier `/var/log/snort/alert.fast`.
* **Syslog-ng (`syslog-ng`)** : Ce conteneur lit les alertes générées par Snort et les transfère directement à Elasticsearch pour l'indexation.
* **Elasticsearch (`elasticsearch`)** : Un puissant moteur de recherche et d'analyse qui stocke et indexe les logs envoyés par syslog-ng.
* **Kibana (`kibana`)** : La couche de visualisation de la pile ELK. Elle fournit une interface web pour explorer, rechercher et visualiser les données de logs stockées dans Elasticsearch.


## 📋 Prérequis

Cette méthode est compatible avec **Linux**, **macOS** et **Windows (via WSL 2)**.

Avant de commencer, vous devez installer **Docker Engine** et **Docker Compose**.

### Windows

1.  Assurez-vous que **WSL 2** est activé sur votre système.
2.  Téléchargez et installez **Docker Desktop for Windows** depuis le site officiel :
    * [https://www.docker.com/products/docker-desktop/](https://www.docker.com/products/docker-desktop/)

### macOS

Téléchargez et installez **Docker Desktop for Mac** depuis le site officiel. Le programme d'installation inclut Docker Engine et Docker Compose.
* [https://www.docker.com/products/docker-desktop/](https://www.docker.com/products/docker-desktop/)

### Linux (Distributions basées sur Debian/Ubuntu)

Ouvrez un terminal et exécutez les commandes suivantes pour installer Docker Engine et Docker Compose.

```bash
# Mettre à jour la liste des paquets
sudo apt-get update

# Installer Docker Engine et Docker Compose
sudo apt-get install docker.io docker-compose -y
```

## 🚀 Installation et Lancement avec Docker

Une fois que vous disposez des fichiers du projet sur votre machine, suivez ces étapes pour lancer l'environnement conteneurisé.

Ouvrez un terminal et naviguez jusqu'au répertoire racine de ce projet. C'est le dossier qui contient le fichier `docker-compose.yml` puis exécutez cette commande : 

```bash
docker-compose up --build
```

## 🛠️ Configuration de Kibana

Après avoir lancé les conteneurs, configurez Kibana pour visualiser les alertes.

### 1. Accéder à l'interface de Kibana

Patientez une à deux minutes que les services démarrent, puis ouvrez votre navigateur web et naviguez vers **`http://localhost:5601`**.


### 2. Créer une Vue de Données (Data View)

Vous allez indiquer à Kibana où trouver les données que `syslog-ng` envoie à Elasticsearch.

1.  Cliquez sur **Explore On My Own**.
    <br>
    <img src="./docs/images/step%201.png" alt="Step 1" title="Step 1" width="600"/>

2.  Dans le menu de gauche (icône ☰), naviguez vers **Management > Stack Management**.
    <br>
    <img src="./docs/images/step%202.png" alt="Step 2" title="Step 2" width="600"/>
    <br>
    <img src="./docs/images/step%203.png" alt="Step 3" title="Step 3" width="100"/>

3.  Dans la section "Kibana", cliquez sur **Data Views**.
    <br>
    <img src="./docs/images/step%204.png" alt="Step 4" title="Step 4" width="600"/>

4.  Cliquez sur le bouton **Create Data View**.
    <br>
    <img src="./docs/images/step%205.png" alt="Step 5" title="Step 5" width="600"/>

5.  Dans les champs "Name" et "Index pattern", tapez exactement **`snort-*`**. Kibana devrait confirmer qu'il a trouvé un index correspondant.

6.  Pour le champ "Timestamp", sélectionnez **`@timestamp`** dans la liste déroulante.

7.  Cliquez sur **Save data view to Kibana**.
    <br>
    <img src="./docs/images/step%206.png" alt="Step 6" title="Step 6" width="600"/>

8.  Vous pouvez maintenant admirer les logs d'alertes en allant dans **Snort Alerts** si Kibana ne vous a pas déjà affiché les logs.
    <br>
    <img src="./docs/images/step%207.png" alt="Step 7" title="Step 7" width="600"/>

## ✍️ Auteurs

* **Antony HUYNH** : `ahuynh@etu.uqac.ca`
* **Antoine RIOM** : `ariom@etu.uqac.ca`