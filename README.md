# MonitorBox
MonitorBox : monitoring pro sans faux positifs. Recyclage de PC sous Debian, interface Terminal/Web + alertes critiques via Pager pour ne rater aucune urgence sous le flux des notifs mobiles. Zero-false-positive monitoring. Dual Terminal/Web views + Pager alerts to bypass smartphone notification clutter for critical emergencies.

# 📟 MonitorBox | Server Pulse

## 🇫🇷 Français

### 🛡️ Philosophie : En finir avec la fatigue des alertes

Le plus grand ennemi d'une équipe IT n'est pas la panne, c'est le **faux positif**. Lorsqu'un système de monitoring SaaS envoie des alertes injustifiées, l'équipe finit par les ignorer. C'est là que le danger survient : on rate la vraie panne au milieu du bruit numérique.

**Server Pulse** a été conçu avec une approche pragmatique :

1. **Zéro Faux Positif** : Le script intègre une logique de double vérification (Retry) avant de confirmer un incident.
2. **Souveraineté et Recyclage** : Pas besoin de serveurs puissants. Redonnez vie à une ancienne machine sous Debian. Si elle est lente, optimisez-la avec [Optinux](https://github.com/simple-group/optinux).
3. **Le retour du Pager** : Nos smartphones sont noyés sous les notifications (emails, Slack, réseaux sociaux). Si votre téléphone sonne, vous hésitez. Si votre **PAGER** sonne, vous *savez* que c'est une urgence critique. Ressusciter cette technologie "Old School" permet de sortir l'alerte de la pollution numérique.

### 🚀 Aspect Pratique & Technique

* **Dual-View** : Un affichage en temps réel dans le **TERMINAL** (idéal pour un écran de contrôle permanent) et une **INTERFACE WEB** moderne et réactive.
* **Hybride** : Surveillance simultanée du réseau (Ping avec temps de latence) et de l'applicatif (recherche de mots-clés via Curl).
* **Alertes Multi-niveaux** : Audio local (Espeak & MP3), interface visuelle, et transmission radio via Pager (via port série).
* **Léger** : Pas de base de données complexe. Un simple fichier `servers.conf` et du JavaScript statique.

---

## 🇺🇸 English

### 🛡️ Philosophy: Ending Alert Fatigue

The greatest enemy of an IT team isn't a system failure; it's the **false positive**. When SaaS monitoring systems send unjustified alerts, teams eventually stop looking at them. This "crying wolf" effect is dangerous: you miss the real disaster amidst the digital noise.

**Server Pulse** was built with a pragmatic mindset:

1. **Zero False Positives**: The script features a built-in double-check (Retry) logic before confirming any downtime.
2. **Sovereignty & Recycling**: No need for high-end hardware. Breathe new life into an old Linux Debian box. If the machine is sluggish, optimize it using [Optinux](https://github.com/simple-group/optinux).
3. **The Pager Revival**: Smartphones are flooded with notifications (emails, Slack, social media). When your phone pings, you hesitate. When your **PAGER** beeps, you *know* it's a critical emergency. Reviving this "Old School" technology extracts the alert from the digital pollution.

### 🚀 Practical & Technical Features

* **Dual-View**: Real-time monitoring via the **TERMINAL** (perfect for a persistent NOC display) and a modern, responsive **WEB INTERFACE**.
* **Hybrid Monitoring**: Simultaneous checks for network connectivity (Ping with latency tracking) and application health (Keyword search via Curl).
* **Multi-level Alerts**: Local audio (Espeak & MP3), visual web cues, and radio transmission for Pagers (via serial port).
* **Lightweight**: No heavy database required. Just a simple `servers.conf` file and static JavaScript.

---

### 📝 Crédits

* **Logiciel proposé par** : [SIMPLE CRM](https://simple-crm.ai)
* **Développement** : [Brice Cornet](https://www.ihaveto.be)

---

====
      MONITORBOX - GUIDE DU FICHIER SERVERS.CONF
=========================================================

Ce fichier vous permet de lister tous les serveurs et sites 
web que vous voulez surveiller. Le script lira ce fichier 
ligne par ligne.

---------------------------------------------------------
1. LA SYNTAXE (LA RÈGLE)
---------------------------------------------------------

Chaque ligne représente un serveur. Chaque information est 
séparée par un POINT-VIRGULE (;) comme ceci :

URL ; NOM ; PING ; MOT-CLÉ ; MESSAGE AUDIO ; PAGER

Il y a exactement 6 colonnes à remplir.

---------------------------------------------------------
2. DÉTAIL DES COLONNES
---------------------------------------------------------

1. URL : L'adresse complète du site (doit commencer par http ou https).
   Exemple : https://www.google.com

2. NOM : Le nom simplifié qui s'affichera sur votre écran.
   Exemple : Moteur Google

3. PING : Est-ce qu'on teste si le serveur répond au "ping" ?
   - Tapez "yes" pour activer.
   - Tapez "no" pour ignorer le ping.

4. MOT-CLÉ : Un mot qui doit obligatoirement être présent dans 
   la page. Si le mot disparaît, le script considère que le 
   site est en panne (ex: erreur 404 ou page blanche).
   Exemple : "Google" pour Google, ou "Wikipedia" pour Wikipédia.

5. MESSAGE AUDIO : Le texte que l'ordinateur va dire tout haut 
   via les haut-parleurs si le site tombe en panne.
   Exemple : "Alerte, le site Google ne répond plus"

6. PAGER : Est-ce qu'on envoie une alerte sur le Pager physique ?
   - Tapez "yes" pour envoyer l'alerte.
   - Tapez "no" pour ne rien envoyer.

---------------------------------------------------------
3. EXEMPLES CONCRETS
---------------------------------------------------------

Voici à quoi doit ressembler votre fichier servers.conf :

# Surveillance de Google (Ping activé + Pager activé)
https://www.google.com;Google Search;yes;Google;Attention, Google est inaccessible;yes

# Surveillance de Wikipédia (Pas de ping, seulement vérification du texte)
https://fr.wikipedia.org;Wikipedia FR;no;Wikipédia;Le serveur Wikipedia semble hors ligne;no

# Surveillance d'un serveur CRM interne
https://0101-zebridge.crm-simple.com;Serveur CRM;no;CRM;Alerte sur le serveur de production;yes

---------------------------------------------------------
4. ASTUCES ET ERREURS À ÉVITER
---------------------------------------------------------

- Ne mettez pas de point-virgule (;) à l'intérieur de vos 
  messages audio, sinon le script sera perdu.
- Les lignes commençant par un dièse (#) sont des commentaires, 
  le script ne les lira pas.
- Si vous modifiez ce fichier, le script prendra les changements 
  en compte lors du prochain tour de surveillance (cycle).

====
      MONITORBOX - SERVERS.CONF CONFIGURATION GUIDE
=========================================================

This file allows you to list all the servers and websites 
you want to monitor. The script reads this file line by line.

---------------------------------------------------------
1. THE SYNTAX (THE RULE)
---------------------------------------------------------

Each line represents one server. Each piece of information 
is separated by a SEMICOLON (;) as follows:

URL ; NAME ; PING ; KEYWORD ; AUDIO MESSAGE ; PAGER

There are exactly 6 columns to fill.

---------------------------------------------------------
2. COLUMN DETAILS
---------------------------------------------------------

1. URL: The full website address (must start with http or https).
   Example: https://www.google.com

2. NAME: The simplified name that will appear on your screen.
   Example: Google Search Engine

3. PING: Do we test if the server responds to a "ping"?
   - Type "yes" to enable.
   - Type "no" to ignore the ping.

4. KEYWORD: A word that must be present on the page. 
   If the word disappears, the script considers the site 
   to be down (e.g., 404 error or blank page).
   Example: "Google" for Google, or "Wikipedia" for Wikipedia.

5. AUDIO MESSAGE: The text the computer will speak out loud 
   through the speakers if the site goes down.
   Example: "Alert, Google website is no longer responding"

6. PAGER: Do we send an alert to the physical Pager?
   - Type "yes" to send the alert.
   - Type "no" to send nothing.

---------------------------------------------------------
3. CONCRETE EXAMPLES
---------------------------------------------------------

Here is what your servers.conf file should look like:

# Monitoring Google (Ping enabled + Pager enabled)
https://www.google.com;Google Search;yes;Google;Warning, Google is unreachable;yes

# Monitoring Wikipedia (No ping, text check only)
https://en.wikipedia.org;Wikipedia EN;no;Wikipedia;The Wikipedia server seems to be offline;no

# Monitoring an internal CRM server
https://0101-zebridge.crm-simple.com;CRM Server;no;CRM;Alert on the production server;yes

---------------------------------------------------------
4. TIPS AND ERRORS TO AVOID
---------------------------------------------------------

- Do not use semicolons (;) inside your audio messages, 
  otherwise the script will fail to read the line correctly.
- Lines starting with a hash (#) are comments; 
  the script will ignore them.
- If you modify this file, the script will apply the 
  changes during the next monitoring round (cycle).

====
