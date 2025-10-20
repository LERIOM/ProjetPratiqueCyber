# Projet — Injection de logs & README d'utilisation

Ce dossier contient :
- `inject_logs.sh` : script bash pour injecter des documents JSON simulant les 5 scénarios d'intrusion dans Elasticsearch sur **localhost:9200**.
- `README.md` : ce fichier.

---

## Pré-requis
- Elasticsearch doit être accessible à `http://localhost:9200` **sans** authentification (configuration labo).
- `curl` doit être installé (généralement déjà présent).
- Exécuter les opérations en tant que `root` ou via `sudo` si nécessaire.

---

## Utilisation
1.  Copier le script sur votre VM (si ce n'est pas déjà le cas) et le rendre exécutable :
    ```bash
    # S'assurer que le script est sur la VM
    chmod +x inject_logs.sh
    sudo ./inject_logs.sh
    ```

2.  Le script va insérer 5 documents (un par scénario) dans des index nommés `syslog-ng-YYYY.MM.DD`.

3.  Vérifications rapides :
    ```bash
    # Lister les index pour confirmer la création
    curl -s 'http://localhost:9200/_cat/indices?v'

    # Rechercher tous les événements injectés (qui contiennent le champ threat_type)
    curl -s 'http://localhost:9200/syslog-ng-*/_search?q=threat_type:*&pretty'

    # Exemple : récupérer uniquement les événements de type SQL injection
    curl -s 'http://localhost:9200/syslog-ng-*/_search?q=threat_type:sql_injection&pretty'
    ```

---

## Description Détaillée et Justification des Scénarios d'Attaque

Cette section détaille les 5 scénarios de menaces simulés par le script. Chaque scénario a été choisi pour représenter une tactique d'attaque courante et critique, offrant une base solide pour la création de règles de détection en temps réel.

### 1. Injection SQL (`sql_injection`) 🛡️
-   **Description :** Le log simule une requête HTTP GET contenant une charge utile malveillante (`UNION SELECT`) dans un paramètre d'URL. Il s'agit d'une tentative classique d'extraire des données sensibles (identifiants, mots de passe) de la base de données de l'application.
-   **Justification du choix :** L'injection SQL reste l'une des vulnérabilités web les plus critiques (cf. **OWASP Top 10**). Sa détection est fondamentale pour protéger les applications contre le vol de données et la compromission.
-   **Indicateurs Clés :**
    -   `threat_type`: `"sql_injection"`
    -   `uri`: `"/products.php?id=1 UNION SELECT username,password FROM users"`

### 2. Téléversement de Web Shell (`webshell_upload`) 💻
-   **Description :** Ce log représente une requête HTTP POST qui téléverse un fichier nommé `shell.php`. Un web shell est un script malveillant qui fournit à l'attaquant un accès distant pour exécuter des commandes sur le serveur.
-   **Justification du choix :** Le téléversement d'un web shell est une technique post-exploitation courante qui offre à l'attaquant une persistance durable sur le système. La détection précoce de l'upload est cruciale pour empêcher une prise de contrôle complète.
-   **Indicateurs Clés :**
    -   `threat_type`: `"webshell_upload"`
    -   `method`: `"POST"`
    -   `file_name`: `"shell.php"`

### 3. Attaque par Force Brute SSH (`ssh_bruteforce`) 🔑
-   **Description :** Le log `sshd` signale un échec d'authentification par mot de passe pour le compte `root` depuis une IP externe. C'est un événement unique qui, agrégé avec d'autres, révèle une attaque par force brute.
-   **Justification du choix :** Les attaques par force brute contre les services exposés (SSH, RDP) sont constantes et automatisées. Détecter des schémas d'échecs multiples permet de bloquer proactivement les IP malveillantes.
-   **Indicateurs Clés :**
    -   `threat_type`: `"ssh_bruteforce"`
    -   `program`: `"sshd"`
    -   `message`: `"Failed password for root from 203.0.113.45..."`

### 4. Inondation SYN (`syn_flood`) 🌊
-   **Description :** Ce log simule une alerte de pare-feu qui a détecté et bloqué un grand nombre de paquets TCP avec le drapeau `SYN`. Cette technique vise à épuiser les ressources du serveur ciblé.
-   **Justification du choix :** Le SYN Flood est une forme classique d'attaque par déni de service (DoS/DDoS). Sa détection au niveau du réseau est essentielle pour déclencher des mécanismes de défense et assurer la continuité de service.
-   **Indicateurs Clés :**
    -   `threat_type`: `"syn_flood"`
    -   `program`: `"kernel"`
    -   `message`: `"...PROTO=TCP ... FLAGS=SYN"`

### 5. Mouvement Latéral (`lateral_movement`) ➡️
-   **Description :** Un événement Windows (EventID 4624) montre une connexion réseau réussie (Logon Type 3) d'un compte de service (`svc_backup`) depuis un poste de travail inhabituel, ce qui est un comportement anormal.
-   **Justification du choix :** La détection du mouvement latéral est capitale pour identifier un attaquant qui a déjà pénétré le périmètre du réseau. Surveiller les connexions anormales de comptes sensibles permet de stopper une attaque avant qu'elle n'atteigne des actifs critiques.
-   **Indicateurs Clés :**
    -   `threat_type`: `"lateral_movement"`
    -   `event_id`: `4624`
    -   `logon_type`: `3`
    -   `notes`: `"svc_backup logged on from workstation not seen before"`

---

## Si Elasticsearch est protégé par authentification
Si votre cluster Elastic a activé la sécurité (username/password), éditez `inject_logs.sh` et ajoutez l'option `-u username:password` à chaque commande `curl`. Exemple :
```bash
curl -u elastic:CHANGE_ME -s -X POST "http://localhost:9200/${index}/_doc" -H "Content-Type: application/json" -d "${doc}"