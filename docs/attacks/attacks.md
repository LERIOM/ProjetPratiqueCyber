# Justification des Scénarios d'Attaque

Ce document détaille la justification de chaque scénario d'attaque choisi pour le projet de détection d'anomalies.
---

### Scénario 1 : 

---

### Scénario 2 : Scan de Ports (Nmap Scan) 

#### Justification

Le scan de ports est une étape de **reconnaissance active** quasi systématique avant une attaque ciblée. Sa détection est un indicateur précoce d'un intérêt malveillant.

* **Objectif Pédagogique** : Ce scénario démontre la capacité à détecter des menaces non basées sur une charge utile (payload), mais sur un comportement anormal du réseau. L'IDS doit corréler plusieurs événements (tentatives de connexion rapides sur de nombreux ports depuis une seule source) pour déclencher une alerte.
* **Pertinence pour le Projet** : Il illustre la détection en temps réel de menace potentielle avant qu'une véritable intrusion n'ait lieu, permettant une réponse proactive.

---

### Scénario 3 : Attaque par Force Brute sur SSH 

#### Justification

Le protocole SSH est un point d'accès critique pour l'administration des serveurs Linux. Les attaques par force brute sont une méthode courante et persistante pour tenter d'obtenir un accès non autorisé.

* **Objectif Pédagogique** : Ce cas met en évidence l'importance de la collecte de logs provenant des systèmes hôtes (logs d'authentification) et pas seulement du trafic réseau. Il teste la capacité du système à agréger et analyser des logs d'application pour y déceler des schémas suspects.
* **Pertinence pour le Projet** : Il répond directement à l'exigence de collecte et de gestion des logs prioritairess journaux d'authentification sont critiques pour la sécurité d'un serveur.

---

### Scénario 4 : Ping Externe (Reconnaissance ICMP) 

#### Justification

Bien que souvent bénin, un ping provenant d'une source externe inattendue peut être le premier signe qu'un attaquant cartographie un réseau pour identifier des cibles actives.

* **Objectif Pédagogique** : Ce scénario simple valide que le système de détection n'est pas limité aux protocoles applicatifs comme TCP et UDP, mais qu'il surveille également des protocoles de contrôle comme ICMP. Cela garantit une surveillance plus complète du réseau.
* **Pertinence pour le Projet** : Il permet de créer une règle de détection simple mais efficace pour démontrer une compréhension de base des différents protocoles réseau et de leur pertinence en matière de sécurité.

---

### Scénario 5 : Injection SQL (SQLi) 

#### Justification

Il s'agit de l'une des attaques les plus critiques et répandues contre les applications web. Un attaquant insère ou "injecte" des commandes SQL malveillantes dans les entrées d'un formulaire ou les paramètres d'une URL pour manipuler la base de données du serveur.

* **Objectif Pédagogique** : Ce scénario teste la capacité de l'IDS à effectuer une inspection approfondie du contenu (Deep Packet Inspection) des requêtes HTTP. Il ne s'agit pas seulement de vérifier les adresses IP ou les ports, mais de rechercher activement des chaînes de caractères et des syntaxes SQL dangereuses (`' OR 1=1`, `UNION SELECT`) dans les données applicatives. Cela démontre une détection au niveau de la couche 7 (applicative).
* **Pertinence pour le Projet** : L'injection SQL est une menace fondamentale et sa détection est une fonctionnalité essentielle pour tout SIEM protégeant des applications web. Intégrer ce cas prouve une compréhension approfondie des vulnérabilités applicatives et valide la capacité du système à analyser le trafic pour y trouver des *payloads* malveillants, ce qui va au-delà de la simple surveillance réseau.