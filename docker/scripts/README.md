# Projet — Injection de logs & README d'utilisation

Ce dossier contient :
- `inject_logs.sh` : script bash pour injecter des documents JSON simulant les 5 scénarios d'intrusion dans Elasticsearch sur **localhost:9200**.
- `README.md` : ce fichier.

## Pré-requis
- Elasticsearch doit être accessible à `http://localhost:9200` **sans** authentification (configuration labo).
- `curl` doit être installé (généralement déjà présent).
- Exécuter les opérations en tant que `root` ou via `sudo` si nécessaire.

## Utilisation
1. Copier le script sur ta VM (si ce n'est pas déjà le cas):
```bash
# depuis ta machine locale (si le fichier est accessible), ou s'assurer qu'il est sur la VM
chmod +x inject_logs.sh
sudo ./inject_logs.sh
```

2. Le script va insérer 5 documents (un par scénario) dans des index nommés `syslog-ng-YYYY.MM.DD`.

3. Vérifications rapides:
```bash
# Lister les index
curl -s 'http://localhost:9200/_cat/indices?v'

# Rechercher les événements injectés
curl -s 'http://localhost:9200/syslog-ng-*/_search?q=threat_type:*&pretty'

# Exemple : récupérer uniquement les événements SQL injection
curl -s 'http://localhost:9200/syslog-ng-*/_search?q=threat_type:sql_injection&pretty'
```

## Contenu des scénarios injectés
1. **sql_injection** — Requête HTTP suspecte contenant `UNION SELECT`.
2. **webshell_upload** — POST upload avec `shell.php`.
3. **ssh_bruteforce** — échec d'authentification SSH depuis IP malveillante.
4. **syn_flood** — logs firewall indiquant SYN massifs.
5. **lateral_movement** — événement Windows (EventID 4624) indiquant connexion réseau d'un compte sensible.

## Si Elasticsearch est protégé par authentification
Si ton cluster Elastic a activé la sécurité (username/password), édite `inject_logs.sh` et ajoute l'option `-u username:password` à chaque commande `curl`. Exemple :
```bash
curl -u elastic:CHANGE_ME -s -X POST "http://localhost:9200/${index}/_doc" -H "Content-Type: application/json" -d "${doc}"
```

## Étapes suivantes recommandées
- Importer un **index pattern** `syslog-ng-*` dans Kibana (Stack Management → Index Patterns) pour voir les documents dans Discover.
- Créer des **detection rules** dans Kibana (ou utiliser Elastic Security) pour déclencher alertes sur `threat_type:*`.
- Optionnel : écrire un script pour lire les alertes et envoyer un message Slack/email.

## Fichiers
- `inject_logs.sh` — script d'injection.
