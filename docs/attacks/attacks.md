# Justification des Scénarios d'Attaque

Ce document détaille la justification de chaque scénario d'attaque choisi pour le projet de détection d'anomalies.
---

### Scénario 1 : 🕸️

---

### Scénario 2 : Scan de Ports (Nmap Scan) 🚪

#### Justification

Le scan de ports est une étape de **reconnaissance active** quasi systématique avant une attaque ciblée. Sa détection est un indicateur précoce d'un intérêt malveillant.

* **Objectif Pédagogique** : Ce scénario démontre la capacité à détecter des menaces non basées sur une charge utile (payload), mais sur un **comportement anormal du réseau**. L'IDS doit corréler plusieurs événements (tentatives de connexion rapides sur de nombreux ports depuis une seule source) pour déclencher une alerte.
* **Pertinence pour le Projet** : Il illustre la **détection en temps réel** de menace potentielle avant qu'une véritable intrusion n'ait lieu, permettant une réponse proactive.

---

### Scénario 3 : Attaque par Force Brute sur SSH 🔑

#### Justification

Le protocole SSH est un point d'accès critique pour l'administration des serveurs Linux. Les attaques par force brute sont une méthode courante et persistante pour tenter d'obtenir un accès non autorisé.

* **Objectif Pédagogique** : Ce cas met en évidence l'importance de la **collecte de logs provenant des systèmes hôtes** (logs d'authentification) et pas seulement du trafic réseau. Il teste la capacité du système à agréger et analyser des logs d'application pour y déceler des schémas suspects.
* **Pertinence pour le Projet** : Il répond directement à l'exigence de **collecte et de gestion des logs prioritaires**s journaux d'authentification sont critiques pour la sécurité d'un serveur.

---

### Scénario 4 : Attaque par Inondation ICMP (Ping Flood) 🌊

#### Justification
Ce scénario démontre comment un outil aussi simple que le `ping` peut être utilisé pour mener une attaque par déni de service (DDoS) efficace. L'objectif n'est pas d'exploiter une faille, mais de submerger la cible sous un volume massif de requêtes **ICMP Echo Request**. En forçant le serveur et snort à traiter et à répondre à des milliers de pings par seconde, l'attaque sature sa bande passante et épuise ses ressources CPU, le rendant inaccessible pour le trafic légitime. Intégrer ce cas est pertinent car il teste la capacité du SIEM à détecter les attaques volumétriques, l'une des formes les plus courantes de DDoS. Il valide que le système peut identifier des schémas anormaux basés sur la fréquence et le volume du trafic, même pour un protocole de diagnostic à priori inoffensif.

---

### Scénario 5 : Injection SQL (SQLi) 💉

#### Justification

Il s'agit de l'une des attaques les plus critiques et répandues contre les applications web. Un attaquant insère ou "injecte" des commandes SQL malveillantes dans les entrées d'un formulaire ou les paramètres d'une URL pour manipuler la base de données du serveur.

* **Objectif Pédagogique** : Ce scénario teste la capacité de l'IDS à effectuer une **inspection approfondie du contenu (Deep Packet Inspection)** des requêtes HTTP. Il ne s'agit pas seulement de vérifier les adresses IP ou les ports, mais de rechercher activement des chaînes de caractères et des syntaxes SQL dangereuses (`' OR 1=1`, `UNION SELECT`) dans les données applicatives. Cela démontre une détection au niveau de la couche 7 (applicative).
* **Pertinence pour le Projet** : L'injection SQL est une menace fondamentale et sa détection est une fonctionnalité essentielle pour tout SIEM protégeant des applications web. Intégrer ce cas prouve une compréhension approfondie des vulnérabilités applicatives et valide la capacité du système à analyser le trafic pour y trouver des *payloads* malveillants, ce qui va au-delà de la simple surveillance réseau.