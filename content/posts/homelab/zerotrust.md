---
title:
description: Netzwerkkonzept auf Zero Trust
draft: true
---

## **Netzwerkkonzept für eine verteilte Unternehmens-Infrastruktur nach dem Zero-Trust-Modell**

**Datum:** 07. August 2025
**Version:** 1.0
**Autor:** IT-Leitung

## **1\. Einleitung und strategische Ausrichtung: Das Zero-Trust-Modell**

### **1.1. Abkehr vom Perimeterschutz**

Die traditionelle IT-Sicherheitsstrategie, oft als „Castle-and-Moat“-Modell bezeichnet, basiert auf der Annahme, dass eine klare Trennung zwischen einem vertrauenswürdigen internen Netzwerk und einem nicht vertrauenswürdigen externen Netzwerk existiert. Dieses Modell ist für die moderne Unternehmens-IT, die durch verteilte Standorte, externe Hoster, mobile Mitarbeiter im Homeoffice und Cloud-Dienste gekennzeichnet ist, nicht mehr tragfähig. Die bestehende Infrastruktur des Unternehmens, mit Servern bei einem externen Hoster, mehreren Bürostandorten und Laptops im Homeoffice, verdeutlicht die Auflösung eines klar definierten Netzwerkperimeters. Ein Angreifer, der einmal die äußere Verteidigungslinie (die „Burgmauer“) überwindet, kann sich in einem solchen flachen Netzwerk oft ungehindert seitlich bewegen („Lateral Movement“). Das Zero-Trust-Modell bricht mit dieser veralteten Annahme und etabliert eine neue Sicherheitsphilosophie.

### **1.2. Die Grundpfeiler von Zero Trust**

Das gesamte hier vorgestellte Architekturkonzept basiert auf den fundamentalen Prinzipien von Zero Trust, wie sie unter anderem vom National Institute of Standards and Technology (NIST) in der Publikation SP 800-207 definiert werden.1 Diese Prinzipien verlagern den Fokus der Sicherheit von der Netzwerkposition hin zur Identität des Benutzers und dem Zustand des zugreifenden Geräts.

* **Verify Explicitly (Explizit verifizieren):** Das Kernprinzip lautet „Never trust, always verify“ (Niemals vertrauen, immer verifizieren).3 Jede einzelne Zugriffsanfrage wird als potenziell feindlich betrachtet, unabhängig davon, ob sie aus dem internen Netzwerk oder dem Internet stammt. Authentifizierung und Autorisierung sind keine einmaligen Ereignisse am Netzwerkrand, sondern ein kontinuierlicher Prozess, der für jede Sitzung und jede Ressource neu bewertet wird.2 Dies erfordert eine dynamische Richtlinien-Engine, die den Kontext jeder Anfrage - Benutzeridentität, Gerätestatus, Standort, angeforderter Dienst - in Echtzeit bewertet.
* **Use Least Privilege Access (Zugriff mit geringsten Rechten):** Benutzer, Geräte und Applikationen erhalten nur die minimal notwendigen Berechtigungen, um ihre spezifischen Aufgaben zu erfüllen.2 Ein breiter Netzwerkzugriff, wie er bei klassischen VPN-Lösungen üblich ist, wird konsequent vermieden.2 Stattdessen wird der Zugriff granular auf einzelne Applikationen und Daten beschränkt. Dieses Prinzip ist die treibende Kraft hinter der Mikrosegmentierungsstrategie, die in diesem Konzept eine zentrale Rolle spielt.
* **Assume Breach (Von einer Kompromittierung ausgehen):** Die Architektur wird unter der Annahme entworfen, dass eine Kompromittierung bereits stattgefunden hat oder unvermeidlich ist.8 Alle Sicherheitsmaßnahmen zielen darauf ab, den potenziellen Schaden („Blast Radius“) eines Angriffs zu minimieren. Dies wird durch strikte Netzwerksegmentierung erreicht, die eine seitliche Bewegung des Angreifers im Netzwerk verhindert, sowie durch umfassende Protokollierung und Analyse, um Anomalien schnell zu erkennen und darauf zu reagieren.2

### **1.3. Die fünf Säulen der Zero-Trust-Architektur (nach CISA)**

Um einen ganzheitlichen und strukturierten Ansatz zu gewährleisten, orientiert sich dieses Konzept an den fünf komplementären Säulen, wie sie von der Cybersecurity and Infrastructure Security Agency (CISA) definiert werden 11:

* **Identity (Identität):** Die Identität von Benutzern und Systemen ist der neue Perimeter. Authentik, integriert mit dem bestehenden Active Directory, bildet das Fundament dieser Säule.
* **Devices (Geräte):** Jedes Gerät, das auf Unternehmensressourcen zugreift (Firmenlaptops, Server), muss inventarisiert, verifiziert und auf seinen Sicherheitszustand hin überprüft werden.
* **Networks (Netzwerke):** Das Netzwerk wird nicht mehr als vertrauenswürdig angesehen. Die Kommunikation wird durch Mikrosegmentierung isoliert und der gesamte Datenverkehr wird Ende-zu-Ende verschlüsselt. Dies wird durch Headscale und Wireguard realisiert.
* **Applications and Workloads (Anwendungen und Workloads):** Der Zugriff auf jede Anwendung - sei es der Samba Fileserver, ein Drucker oder ein Dienst im K3s-Cluster - wird individuell gesichert und autorisiert.
* **Data (Daten):** Daten werden klassifiziert, und der Zugriff darauf wird basierend auf den anderen vier Säulen gesteuert. Die Verschlüsselung der Daten im Transit (in-transit) und im Ruhezustand (at-rest) ist entscheidend.

## **2\. Architektonisches Fundament: Identitäts- und Zugriffsmanagement mit Authentik**

### **2.1. Authentik als zentraler Identity Provider (IDP) und Policy Decision Point (PDP)**

In einer Zero-Trust-Architektur ist die Identität der Dreh- und Angelpunkt aller Sicherheitsentscheidungen. Authentik wird in diesem Konzept als zentraler Identity Provider (IDP) etabliert. Es fungiert als die alleinige Quelle der Wahrheit („Single Source of Truth“) für die Authentifizierung von Benutzern und die Durchsetzung von Zugriffsrichtlinien. Gemäß dem NIST-Modell übernimmt Authentik die Rolle des Policy Decision Point (PDP) und der Policy Engine.3 Jede Zugriffsanfrage, unabhängig von ihrem Ursprung oder Ziel, wird an Authentik zur Überprüfung weitergeleitet und auf Basis definierter Richtlinien genehmigt oder abgelehnt.
Durch die Zentralisierung der Authentifizierungslogik in Authentik wird das bestehende Active Directory von seiner Rolle als primärer Sicherheitsgatekeeper entbunden und dient fortan als reines Benutzerverzeichnis. Dies ist ein strategisch wichtiger Schritt, um eine veraltete Infrastruktur zu modernisieren, ohne sie vollständig ersetzen zu müssen. Diese Entkopplung der Zugriffskontrollebene vom Identitätsspeicher erhöht die Agilität des Gesamtsystems erheblich. Sollte das Unternehmen zukünftig von Active Directory migrieren, muss lediglich die Datenquelle („Source“) in Authentik ausgetauscht werden, während alle komplexen Zugriffs-Flows und Richtlinien erhalten bleiben.

### **2.2. Integration des bestehenden Active Directory**

Die nahtlose Integration des vorhandenen Active Directory (AD) ist entscheidend für die Akzeptanz und eine reibungslose Implementierung. Authentik bietet hierfür eine robuste LDAP-Schnittstelle.12

* **Konfiguration als LDAP-Quelle:** Die Anbindung erfolgt über die Konfiguration einer neuen „LDAP Source“ in der Authentik-Admin-Oberfläche. Die wesentlichen Schritte sind:
  1. **Service-Account anlegen:** Im Active Directory wird ein dedizierter Service-Account mit einem starken, nicht ablaufenden Passwort erstellt. Dieser Account benötigt lediglich Leserechte auf die zu synchronisierenden Benutzer- und Gruppenobjekte.14
  2. **Verbindungs-URI festlegen:** Die Verbindung zum Domain Controller muss zwingend über LDAPS (LDAP over SSL, Port 636\) konfiguriert werden. Dies stellt die verschlüsselte Übertragung der Anmeldeinformationen sicher und ist eine Voraussetzung für die optionale Passwort-Rückschreibfunktion (ldaps://dc01.ihre-firma.de).14
  3. **Base DN definieren:** Der Base Distinguished Name (DN) wird so gesetzt, dass er die Organisationseinheiten (OUs) umfasst, in denen sich die relevanten Benutzer und Gruppen befinden.
  4. **Objektfilter anwenden:** Um nur Benutzerkonten und keine Computerkonten zu synchronisieren, wird ein spezifischer LDAP-Filter verwendet: (&(objectClass=user)(\!(objectClass=computer))).14
  5. **Attribut-Mappings:** Die Standard-Mappings von Authentik für Active Directory werden zugewiesen, um Attribute wie sAMAccountName, userPrincipalName, givenName, sn und memberOf korrekt zu übernehmen.13
* **Passwort-Management-Strategie:** Obwohl Authentik das Zurückschreiben von Passwörtern ins AD unterstützt, wird eine andere Strategie empfohlen: Das AD bleibt der autoritative Ort zur *Validierung* von Passwörtern, aber alle Aktionen wie Passwortänderungen oder \-zurücksetzungen durch den Benutzer werden ausschließlich über die Self-Service-Flows von Authentik abgewickelt. Dies gewährleistet, dass alle Passwortrichtlinien (Komplexität, Historie etc.), die in Authentik definiert sind, konsistent durchgesetzt werden.

### **2.3. Erzwingung von Multi-Faktor-Authentifizierung (MFA) mit Flows und Policies**

Die strikte und kontextabhängige Durchsetzung von MFA ist die direkte Umsetzung des „Verify Explicitly“-Prinzips. Authentiks flexible Architektur aus Flows, Stages und Policies ermöglicht eine granulare Steuerung, die weit über eine einfache, globale MFA-Pflicht hinausgeht.16

* **Flows und Stages:** Ein Flow in Authentik ist eine Abfolge von einzelnen Schritten, den sogenannten Stages. Ein typischer Anmelde-Flow besteht aus einer Identification Stage (Benutzername eingeben), einer Password Stage und einer User Login Stage.17 Um MFA zu erzwingen, wird einfach eine „Authenticator Validation Stage“ in den Flow eingefügt.18 Policies agieren dabei als Weichen oder Tore, die basierend auf dem Kontext der Anfrage entscheiden, ob eine Stage durchlaufen werden muss oder nicht.16
* **Gestaffelte MFA-Strategie:** Anstatt MFA für alle Zugriffe pauschal zu erzwingen, wird eine risikobasierte, gestaffelte Strategie implementiert. Dies erhöht die Sicherheit für kritische Ressourcen, ohne die Benutzerfreundlichkeit bei weniger sensiblen Zugriffen unnötig zu beeinträchtigen.
  * **Standardzugriff (1FA):** Für den Zugriff auf weniger kritische Ressourcen (z. B. ein internes Wiki) wird ein Standard-Flow ohne MFA-Stage verwendet.
  * **Sensibler Zugriff (MFA erforderlich):** Für den Zugriff auf den Samba Fileserver, administrative Oberflächen (Proxmox, Headscale) oder kritische Dienste im K3s-Cluster wird ein separater Flow erstellt, der eine „Authenticator Validation Stage“ enthält. Diese Stage kann so konfiguriert werden, dass sie einen zweiten Faktor wie TOTP (z.B. Google Authenticator), WebAuthn/Passkeys (z.B. YubiKey, Windows Hello) oder Duo Push-Benachrichtigungen erfordert.20
  * **Bedingter Zugriff (Conditional Access):** Authentik Policies ermöglichen die Erstellung von bedingten Zugriffsregeln. Beispielsweise kann eine GeoIP-Policy 22 so konfiguriert werden, dass MFA nur dann erzwungen wird, wenn der Anmeldeversuch von einem unbekannten Standort oder außerhalb des Landes erfolgt. Eine Endpoint-Policy kann in Verbindung mit dem Authentik-Browser-Plugin genutzt werden, um den Zustand des Endgeräts (z. B. Firewall aktiv) zu prüfen und basierend darauf die MFA-Anforderung anzupassen.20

Die folgende Tabelle skizziert eine beispielhafte Implementierung dieser gestaffelten MFA-Richtlinien.

| Ressource / Anwendung | Sensitivität | Zugriff von Intern/VPN | Zugriff von Extern | Authentik Flow | Erforderliche Faktoren |
| :---- | :---- | :---- | :---- | :---- | :---- |
| Intranet-Wiki | Niedrig | Standard-Login | Standard-Login | default-authentication-flow | Passwort |
| Samba Fileserver (Allgemein) | Mittel | MFA-Login | MFA-Login | mfa-required-flow | Passwort \+ TOTP/WebAuthn |
| Samba Fileserver (HR/Finanzen) | Hoch | MFA-Login | Zugriff gesperrt | mfa-required-flow \+ deny-external-policy | Passwort \+ TOTP/WebAuthn |
| Proxmox/Headscale Admin UI | Kritisch | MFA-Login | Zugriff gesperrt | mfa-required-flow \+ deny-external-policy | Passwort \+ WebAuthn (Hardware Key) |

## **3\. Das sichere Netzwerk-Fabric: Headscale und Wireguard als Fundament**

### **3.1. Architektur-Überblick**

Die Grundlage für die sichere Vernetzung aller Standorte, Server und Endgeräte bildet ein Overlay-Netzwerk, das auf Wireguard und Headscale basiert. In dieser Architektur ist es entscheidend, die Rollen der beiden Komponenten zu verstehen 23:

* **Headscale (Control Plane):** Headscale ist eine Open-Source-Implementierung des Tailscale-Koordinationsservers. Es fungiert als die zentrale Steuerungsebene („Control Plane“). Seine Hauptaufgaben sind die Verwaltung von Benutzer- und Geräteregistrierungen, der sichere Austausch von öffentlichen Wireguard-Schlüsseln zwischen den Geräten („Nodes“) und die Verteilung der Zugriffssteuerungslisten (ACLs).24 Wichtig ist: Headscale leitet keinen Nutzdatenverkehr.
* **Wireguard (Data Plane):** Wireguard ist das zugrundeliegende VPN-Protokoll, das die Datenebene („Data Plane“) bildet. Sobald zwei Geräte ihre öffentlichen Schlüssel und Endpunkt-Informationen (IP-Adresse und Port) über Headscale ausgetauscht haben, bauen sie einen direkten, Ende-zu-Ende-verschlüsselten Peer-to-Peer-Tunnel zueinander auf.24 Dieser direkte Datenfluss, auch durch komplexe NAT-Konfigurationen hindurch, sorgt für hohe Performance und geringe Latenz.

Diese Trennung von Kontroll- und Datenebene ist ein fundamentaler architektonischer Vorteil gegenüber traditionellen VPN-Konzentratoren, bei denen der gesamte Verkehr durch einen zentralen Engpass fließen muss. Ein temporärer Ausfall des Headscale-Servers unterbricht bestehende Wireguard-Verbindungen nicht, da die Geräte bereits über alle notwendigen Informationen für die direkte Kommunikation verfügen. Dies erhöht die Resilienz des Netzwerks erheblich und beeinflusst die Strategie für Hochverfügbarkeit, die sich auf eine schnelle Wiederherstellung des Kontrollservers konzentriert, anstatt auf eine komplexe, fehlertolerante Cluster-Lösung.27

### **3.2. Der Headscale Control Server**

* **Deployment:** Der Headscale-Server sollte auf einer dedizierten virtuellen Maschine oder einem Container innerhalb der Infrastruktur des externen Hosters (z. B. auf dem Proxmox-Cluster) betrieben werden. Die kritischen Anforderungen an diesen Server sind eine statische, öffentlich erreichbare IP-Adresse und die Absicherung der Kommunikation über HTTPS.29 Es wird dringend empfohlen, Headscale hinter einem Reverse Proxy (z. B. Nginx, Traefik) zu betreiben, der die TLS-Terminierung übernimmt und ein gültiges SSL-Zertifikat (z. B. von Let's Encrypt) bereitstellt.
* **DNS-Konfiguration:** Für den Headscale-Server muss ein stabiler, öffentlicher DNS-Eintrag (FQDN) konfiguriert werden, z. B. headscale.ihre-firma.de. Diese URL wird von allen Clients bei der Registrierung mit dem Parameter \--login-server verwendet und darf sich nicht ändern.

### **3.3. Node-Registrierung und \-Management**

Jedes Gerät, das Teil des sicheren Netzwerks werden soll, muss bei Headscale registriert und einem Benutzer zugeordnet werden.

* **Benutzer in Headscale:** Headscale verwaltet eine eigene Benutzerdatenbank, die als Container für die zugeordneten Geräte dient. Ein Benutzer wird über die Kommandozeile erstellt (headscale users create mitarbeiter-a).30 Für die Authentifizierung bei der Geräteregistrierung wird Headscale per OIDC an Authentik angebunden, sodass die Benutzer ihre bekannten AD-Anmeldedaten verwenden können.
* **Registrierungsprozess:** Es gibt zwei primäre Methoden, um ein neues Gerät („Node“) in das Netzwerk aufzunehmen:
  1. **Interaktive Anmeldung:** Dies ist die Standardmethode für Benutzergeräte (Laptops). Der Benutzer führt auf dem Gerät den Befehl tailscale up \--login-server=[https://headscale.ihre-firma.de](https://headscale.ihre-firma.de) aus. Daraufhin wird eine URL angezeigt, die im Browser geöffnet wird. Der Benutzer wird zu Authentik weitergeleitet, authentifiziert sich (inkl. MFA), und nach erfolgreicher Anmeldung wird das Gerät dem Benutzer in Headscale zugeordnet und registriert.
  2. **Pre-authenticated Keys:** Für Server (wie den Samba/AD-Server, K3s-Nodes) oder andere Geräte, bei denen eine interaktive Anmeldung nicht praktikabel ist, können vorab authentifizierte Schlüssel generiert werden. Mit dem Befehl headscale preauthkeys create \--user admin \--reusable=false \--ephemeral=false wird ein einmalig verwendbarer Schlüssel erstellt. Dieser Schlüssel wird dann auf dem Server im tailscale up-Befehl verwendet (--authkey=hskey-...), um das Gerät non-interaktiv und sicher zu registrieren.

## **4\. Mikrosegmentierung und Richtliniendurchsetzung mittels Headscale ACLs**

### **4.1. Das "Deny by Default"-Prinzip**

Die praktische Umsetzung der Zero-Trust-Prinzipien „Assume Breach“ und „Least Privilege Access“ erfolgt durch die Access Control Lists (ACLs) von Headscale. Die grundlegende Haltung dieser ACLs ist „Deny by Default“: Jegliche Kommunikation zwischen zwei beliebigen Geräten im Netzwerk ist standardmäßig verboten. Nur explizit in der ACL-Richtliniendatei definierte Verbindungen werden zugelassen.31 Dadurch wird eine strikte Mikrosegmentierung des Netzwerks erreicht, die eine unkontrollierte seitliche Bewegung eines Angreifers wirksam unterbindet.

### **4.2. Bausteine der ACLs: Groups, Tags und Hosts**

Die ACL-Datei von Headscale ist in einem menschenlesbaren JSON-Format (huJSON) verfasst und nutzt mehrere Bausteine zur Definition von Richtlinien 32:

* **Groups:** Gruppen fassen Benutzer basierend auf ihrer Rolle oder Abteilung zusammen. Diese Gruppen sollten idealerweise den Gruppenstrukturen aus dem Active Directory entsprechen (z. B. group:it-admins, group:finance, group:developers). Gruppen werden hauptsächlich im src-Feld (Quelle) von ACL-Regeln verwendet, um den Zugriff für ganze Benutzerkategorien zu definieren.32
* **Tags:** Tags dienen der Klassifizierung von Ressourcen (Geräten). Ein Server wird beispielsweise als tag:dc (Domain Controller) oder tag:fileserver-prod gekennzeichnet. Ein Drucker an Standort A erhält den Tag tag:printer-site-a. Diese Tags werden einem Gerät bei der Registrierung mit dem Flag \--advertise-tags=tag:dc zugewiesen.32
* **Tag Owners:** Um zu verhindern, dass ein normaler Benutzer seinen Laptop fälschlicherweise als Domain Controller deklariert, gibt es das tagOwners-Konzept. In diesem Abschnitt der ACL-Datei wird festgelegt, welche Benutzergruppen (groups) berechtigt sind, einen bestimmten Tag zu vergeben.32 Dies schafft eine Kette des Vertrauens: Die Identität eines Benutzers (verifiziert durch Authentik) bestimmt seine Gruppenzugehörigkeit, diese wiederum seine Berechtigung zur Vergabe von Tags, und der Tag klassifiziert die Ressource, für die dann die Zugriffsregeln gelten.
* **Hosts:** Dient zur Definition von statischen IP-Adressen oder ganzen Subnetzen, die über einen Subnet Router erreichbar sind (z. B. das Druckernetzwerk).32

### **4.3. Erstellung eines granularen Regelwerks**

Die eigentlichen Zugriffsregeln werden im acls-Abschnitt der Richtliniendatei definiert. Jede Regel besteht typischerweise aus vier Komponenten: action, src, dst und proto.32

* **action:** In der Regel "accept", da alles andere standardmäßig verboten ist.
* **src:** Die Quelle des Verbindungsversuchs. Dies kann ein Benutzer, eine Gruppe, ein Tag oder eine IP-Adresse sein.
* **dst:** Das Ziel der Verbindung. Die Syntax ist hier besonders mächtig. tag:fileserver-prod:\* erlaubt den Zugriff auf alle Ports des Zielgeräts. tag:fileserver-prod:445,139 beschränkt den Zugriff auf die spezifischen SMB-Ports.
* **proto:** Optional, um das Protokoll zu spezifizieren (z. B. tcp, udp, icmp).
* **Autogroups:** Headscale stellt spezielle, dynamische Gruppen zur Verfügung. autogroup:members umfasst alle Benutzer des Netzwerks. autogroup:self erlaubt einem Benutzer den Zugriff auf alle seine eigenen Geräte. autogroup:internet wird verwendet, um den ausgehenden Internetverkehr über einen definierten Exit-Node zu steuern.31

## **5\. Integration und Absicherung der Kerninfrastruktur**

### **5.1. Härtung von Active Directory und Samba im Zero-Trust-Kontext**

Die Domain Controller und der Samba Fileserver sind die Kronjuwelen der internen Infrastruktur und erfordern besondere Schutzmaßnahmen.

* **Netzwerk-Isolation:** Die Server, die diese Dienste auf dem Proxmox-Cluster hosten, werden als Nodes im Headscale-Netzwerk registriert und mit den entsprechenden Tags (tag:dc, tag:fileserver-prod) versehen. Die hostbasierten Firewalls auf diesen virtuellen Maschinen werden so konfiguriert, dass sie jeglichen eingehenden Verkehr blockieren, mit Ausnahme des für Wireguard benötigten UDP-Ports. Jeglicher administrativer Zugriff (Proxmox Web-UI, SSH) und Dienstzugriff (LDAPS, SMB, Kerberos) erfolgt ausschließlich über die verschlüsselte Wireguard-Schnittstelle. Physischer oder virtueller Netzwerkzugriff gewährt keinerlei Zugriff mehr auf die Dienste.
* **Protokoll-Härtung:** Es ist unerlässlich, veraltete und unsichere Authentifizierungsprotokolle zu deaktivieren, um Angriffe wie „Pass-the-Hash“ zu verhindern.
  * **Samba:** In der smb.conf werden strikte Sicherheitseinstellungen vorgenommen: ntlm auth \= disabled erzwingt die ausschließliche Verwendung von Kerberos, server min protocol \= SMB3\_11 deaktiviert ältere, unsichere SMB-Versionen und lanman auth \= no ist obligatorisch.34
  * **Active Directory:** Auf den Domain Controllern werden Richtlinien durchgesetzt, die LDAP Channel Binding erfordern (um Man-in-the-Middle-Angriffe auf LDAPS zu erschweren) und schwache Kerberos-Verschlüsselungsalgorithmen (wie RC4) deaktivieren. Die logische Trennung der Domain Controller vom Rest des Netzwerks wird durch die Headscale ACLs sichergestellt.35
* **Least Privilege in AD/Samba:** Das Prinzip der geringsten Rechte wird nicht nur auf Netzwerkebene, sondern auch innerhalb der Applikationen selbst umgesetzt. Dies beinhaltet die Implementierung eines gestaffelten Admin-Modells im AD (Tier 0 für Domain Admins, etc.) und die granulare Vergabe von NTFS-Berechtigungen auf den Samba-Freigaben basierend auf AD-Gruppen.35

### **5.2. Endpunktsicherheit für Windows-Clients und Homeoffice-Laptops**

In einem Zero-Trust-Modell ist jedes Endgerät ein potenzieller Angriffsvektor. Die Identität und Integrität des Geräts sind ebenso wichtige Signale für eine Zugriffsentscheidung wie die Identität des Benutzers.39

* **Geräteidentität und \-integrität:** Alle firmeneigenen Windows-Laptops werden als Nodes im Headscale-Netzwerk registriert. Ihr Sicherheitszustand („Posture“) wird zu einem entscheidenden Kriterium für den Zugriff.
* **Härtungsmaßnahmen:**
  * **Endpoint Management:** Der Einsatz einer zentralen Verwaltungslösung wie Microsoft Intune (falls Lizenzen vorhanden sind) oder einer Open-Source-Alternative ist entscheidend, um Sicherheitsrichtlinien auf allen Geräten durchzusetzen. Zu den Mindestanforderungen gehören: Festplattenverschlüsselung (BitLocker), die Installation eines Endpoint Detection and Response (EDR)-Tools, eine aktivierte und zentral verwaltete Host-Firewall sowie die Sicherstellung, dass Betriebssystem- und Anwendungspatches zeitnah installiert werden.39
  * **Authentik-Integration:** Während Headscale selbst keine direkte Überprüfung des Gerätezustands bietet, kann die Endpoint-Integration von Authentik als Annäherung dienen. Diese kann (derzeit für den Chrome-Browser) den Zustand von Attributen wie der aktivierten Firewall prüfen. Diese Information kann in den bedingten Zugriffsrichtlinien von Authentik verwendet werden, um beispielsweise MFA zu erzwingen, wenn die Firewall auf einem Gerät deaktiviert ist.20

### **5.3. Sichere Einbindung von Netzwerkdruckern an den Standorten**

Netzwerkdrucker stellen ein erhebliches Sicherheitsrisiko dar, da sie oft über veraltete Firmware verfügen und keinen Wireguard-Client ausführen können.43 Sie müssen daher isoliert und kontrolliert in das sichere Netzwerk integriert werden.

* **Lösung: Netzwerksegmentierung und Subnet Router:** Die Drucker an jedem Standort werden in ein eigenes, dediziertes VLAN verschoben, das vom restlichen Büronetzwerk vollständig isoliert ist. In diesem VLAN wird ein kleines, dediziertes Gerät (z. B. ein Raspberry Pi oder eine kleine Linux-VM) platziert. Dieses Gerät wird als Headscale-Node registriert und fungiert als „Subnet Router“. Es kündigt das Drucker-VLAN (z. B. 192.168.10.0/24) im gesamten Headscale-Netzwerk an.44
* **Zugriffskontrolle:** Der Zugriff auf die Drucker wird ausschließlich über Headscale-ACLs gesteuert. Eine Regel könnte beispielsweise lauten, dass die Gruppe group:all-employees auf Geräte mit dem Tag tag:printer-site-a auf den Ports 9100 (Raw-Printing), 631 (IPP) und 515 (LPD) zugreifen darf.45 Jeglicher anderer Zugriff auf die Drucker wird blockiert.
* **Secure Printing:** Ergänzend wird die Einführung einer Druckmanagement-Lösung (z. B. PaperCut) empfohlen. Solche Lösungen halten Druckaufträge in einer sicheren Warteschlange, bis der Benutzer sich physisch am Drucker authentifiziert (z. B. per PIN oder Karte) und den Auftrag freigibt. Dies verhindert, dass vertrauliche Dokumente unbeaufsichtigt im Ausgabefach liegen.45

Der Headscale Subnet Router ist die Schlüsseltechnologie, um bestehende („Brownfield“), nicht-mesh-fähige Geräte und Netzwerksegmente nahtlos und sicher in die moderne Zero-Trust-Architektur zu integrieren. Dieses Muster kann für alle Arten von Legacy-Geräten (IP-Kameras, IoT-Geräte etc.) wiederverwendet werden und bietet einen klaren Migrationspfad für die gesamte Infrastruktur.

## **6\. Standortvernetzung und Anbindung des K3s-Clusters**

### **6.1. Site-to-Site-Vernetzung**

Das im vorherigen Abschnitt beschriebene Konzept des Subnet Routers wird erweitert, um eine vollständige und sichere Vernetzung aller Unternehmensstandorte zu realisieren. An jedem physischen Standort wird ein dediziertes Gerät (z. B. eine Firewall oder ein kleiner Server) als Headscale Subnet Router konfiguriert. Dieses Gerät kündigt das lokale Subnetz des Standorts im gesamten Headscale-Netzwerk an. Dadurch entsteht ein sicheres Site-to-Site-VPN-Gefüge auf Basis von Wireguard, das den direkten und verschlüsselten Datenaustausch zwischen den Standorten ermöglicht. Der Datenverkehr zwischen den Standorten wird ebenfalls durch die zentralen Headscale-ACLs gesteuert, was eine granulare Kontrolle über die Inter-Site-Kommunikation erlaubt.

### **6.2. Architektur des K3s-Netzwerks**

Die bestehende Konfiguration des K3s-Clusters nutzt das Flannel CNI (Container Network Interface) mit dem wireguard-native-Backend.50 Dies bedeutet, dass K3s bereits ein eigenes, internes Wireguard-basiertes Overlay-Netzwerk für die gesamte Pod-zu-Pod-Kommunikation verwaltet. Es ist wichtig zu verstehen, dass dieses K3s-interne Wireguard-Netzwerk vollständig getrennt und unabhängig von dem unternehmensweiten Headscale-Wireguard-Mesh ist.

### **6.3. Routing zwischen Headscale-Mesh und K3s-Cluster**

Die größte technische Herausforderung besteht darin, eine sichere und kontrollierte Kommunikation zwischen dem Unternehmensnetzwerk (Headscale) und den Diensten innerhalb des K3s-Clusters zu ermöglichen.

* **Die Herausforderung:** Es existieren zwei voneinander isolierte Wireguard-Netzwerke. Ein Benutzer im Headscale-Netzwerk kann standardmäßig nicht auf eine Pod-IP oder eine ClusterIP im K3s-Netzwerk zugreifen.
* **Die Lösung - K3s-Knoten als Subnet Router:** Die eleganteste Lösung besteht darin, die beiden Netzwerke über die Subnet-Router-Funktionalität von Headscale zu verbinden. Mindestens einer der K3s-Worker-Nodes (aus Redundanzgründen idealerweise zwei) wird zusätzlich zu seiner Rolle im K3s-Cluster auch als Client im Headscale-Netzwerk registriert. Dieser Node wird dann als Headscale Subnet Router konfiguriert und kündigt die internen Netzwerkbereiche des K3s-Clusters - den Pod CIDR (z. B. 10.42.0.0/16) und den Service CIDR (z. B. 10.43.0.0/16) - im Headscale-Netzwerk an.44
* **Konfiguration:**
  1. Installation des Tailscale-Clients auf dem/den ausgewählten K3s-Node(s).
  2. Registrierung des Nodes bei Headscale mit den zusätzlichen Flags zum Ankündigen der Routen und zur Zuweisung eines Tags: tailscale up \--login-server=\<URL\> \--advertise-routes=10.42.0.0/16,10.43.0.0/16 \--advertise-tags=tag:k3s-gateway.
  3. Aktivierung des IP-Forwardings auf dem Linux-Kernel des K3s-Nodes (net.ipv4.ip\_forward=1).
  4. Genehmigung der angekündigten Routen in der administrativen Oberfläche von Headscale.
* **ACL-Steuerung:** Nach der Konfiguration wird der Zugriff auf die Dienste innerhalb des K3s-Clusters zentral über die Headscale-ACLs gesteuert. Der Zugriff erfolgt nicht mehr über Ingress-Controller, die Dienste im Internet exponieren, sondern direkt über die ClusterIPs. Um beispielsweise Entwicklern den Zugriff auf einen Dienst unter der IP 10.43.5.10 auf Port 8080 zu gewähren, wird folgende ACL-Regel definiert: {"action": "accept", "src": \["group:developers"\], "dst": \["10.43.5.10:8080"\]}.

Diese Architektur behandelt den K3s-Cluster als eine erstklassige, segmentierte Ressource innerhalb des gesamten Zero-Trust-Netzwerks. Die Zugriffskontrolle wird auf der Headscale-Ebene vereinheitlicht, was konsistent mit der Verwaltung aller anderen Unternehmensressourcen ist. Dies ermöglicht ein leistungsfähiges „Defense-in-Depth“-Modell: Kubernetes NetworkPolicies können für die feingranulare Steuerung des Ost-West-Verkehrs *innerhalb* des Clusters verwendet werden, während Headscale-ACLs den Nord-Süd-Verkehr, also den Zugriff *in den* Cluster hinein, absichern.

## **7\. Betriebskonzept: Hochverfügbarkeit und Skalierbarkeit**

### **7.1. Hochverfügbarkeit für Authentik**

Authentik ist als moderne, containerisierte Anwendung von Grund auf für Hochverfügbarkeit (HA) und horizontale Skalierbarkeit konzipiert. Die Architektur trennt die Anwendung in mehrere Komponenten (Server, Worker, PostgreSQL-Datenbank, Redis-Cache), die unabhängig voneinander skaliert werden können.51

* **Deployment-Empfehlung:** Die Bereitstellung von Authentik erfolgt idealerweise im K3s-Cluster. Das offizielle Helm-Chart für Authentik ermöglicht es, mehrere Replikate der Server- und Worker-Pods zu betreiben. Ein Kubernetes Service sorgt für die Lastverteilung zwischen den Pods und gewährleistet so die Ausfallsicherheit der Anwendungskomponenten.53
* **Zustandsbehaftete Komponenten (Stateful Components):**
  * **PostgreSQL:** Die Datenbank ist die kritischste Komponente. Es wird dringend empfohlen, einen externen, vom Hoster verwalteten und hochverfügbaren PostgreSQL-Dienst zu nutzen. Falls dies nicht möglich ist, sollte ein hochverfügbarer PostgreSQL-Cluster innerhalb von K3s mithilfe eines Operators wie CloudNativePG oder Crunchy Data PostgreSQL Operator bereitgestellt werden. Diese Operatoren verwalten komplexe Aufgaben wie Replikation, Failover und Backups automatisiert.56
  * **Redis:** Redis wird für Caching und als Message Queue verwendet. Ein Ausfall führt zum Verlust von Benutzersitzungen, beeinträchtigt aber nicht die Persistenz der Konfiguration. Für eine hochverfügbare Konfiguration sollte ein Redis-Cluster mit Redis Sentinel bereitgestellt werden, der die Überwachung der Nodes und ein automatisches Failover übernimmt. Das Bitnami Helm-Chart für Redis bietet eine einfache Möglichkeit, eine solche Konfiguration zu erstellen.59

### **7.2. Resilienz-Strategie für Headscale**

Im Gegensatz zu Authentik ist Headscale in seiner aktuellen Form nicht für einen aktiv-aktiven HA-Clusterbetrieb konzipiert. Es teilt keinen Laufzeitzustand zwischen mehreren Instanzen, was bedeutet, dass nur eine Instanz gleichzeitig aktiv sein kann.27

* **Die Herausforderung:** Ein traditioneller HA-Ansatz mit mehreren gleichzeitig laufenden Headscale-Instanzen ist nicht möglich.
* **Die Strategie: Rapid Disaster Recovery (DR):** Die Strategie muss sich darauf konzentrieren, die Wiederherstellungszeit (Recovery Time Objective, RTO) im Falle eines Ausfalls zu minimieren.
  1. **Externer Zustand:** Der wichtigste Schritt ist die Auslagerung des Zustands von Headscale in eine externe, hochverfügbare PostgreSQL-Datenbank. Obwohl SQLite für einfache Setups empfohlen wird, ist die Unterstützung für PostgreSQL der Schlüssel zu dieser DR-Strategie.62
  2. **Zustandslose Kontroll-Ebene:** Durch die externe Datenbank wird die Headscale-Anwendung selbst effektiv zustandslos. Mehrere virtuelle Maschinen oder Container können mit der identischen Konfiguration vorbereitet werden, um sich mit derselben Datenbank zu verbinden.
  3. **Failover-Mechanismus:** Der FQDN des Headscale-Servers (headscale.ihre-firma.de) wird über einen Load Balancer oder per DNS-Failover auf eine passive Standby-Instanz umgeleitet, falls die primäre Instanz ausfällt. Die Standby-Instanz verbindet sich mit der PostgreSQL-Datenbank und kann den Betrieb nahtlos übernehmen.
* **Client-Resilienz:** Es ist wichtig zu betonen, dass die Datenebene (die direkten Wireguard-Verbindungen zwischen den Clients) von einem kurzen Ausfall der Kontroll-Ebene unberührt bleibt. Bestehende Verbindungen funktionieren weiter.27 Der DR-Plan stellt primär sicher, dass neue Geräte dem Netzwerk beitreten und Richtlinien-Updates schnellstmöglich wieder verteilt werden können.

Die unterschiedlichen Designphilosophien - Authentik als komplexe Unternehmensanwendung für HA, Headscale als einfache Anwendung für Hobbyisten und kleine Organisationen 25 - erfordern fundamental verschiedene Betriebsmodelle. Der Versuch, Headscale in ein aktiv-aktives Cluster zu zwingen, wäre kontraproduktiv. Die richtige Strategie besteht darin, seinen Aufbau zu nutzen: den Zustand (Datenbank) von der Anwendung zu trennen und die Anwendungskomponente leicht und schnell austauschbar zu machen.

## **8\. Zusammenfassendes Architekturdiagramm und Implementierungspfad**

### **8.1. Gesamtarchitektur-Diagramm**

Das folgende Diagramm visualisiert die Zielarchitektur und das Zusammenspiel der einzelnen Komponenten. Es zeigt die logische Struktur des Netzwerks, die auf den Prinzipien von Zero Trust aufbaut.
*(Ein detailliertes Architekturdiagramm würde hier eingefügt werden. Es würde die folgenden Elemente und Beziehungen darstellen:)*

* **Zentrale Zone (Externer Hoster):**
  * Proxmox-Cluster mit VMs für Active Directory und Samba-Fileserver.
  * K3s-Cluster, in dem Authentik (mit HA-PostgreSQL/Redis) und andere Geschäftsanwendungen laufen.
  * Der Headscale-Server als zentrale Kontroll-Ebene.
  * Alle Server sind als Nodes im Headscale-Netzwerk registriert.
* **Standorte (Büro A, Büro B):**
  * Jeder Standort hat ein isoliertes VLAN für Drucker.
  * Ein Headscale Subnet Router pro Standort, der das Drucker-VLAN und das allgemeine Büro-LAN in das Mesh-Netzwerk integriert.
  * Windows-Clients sind direkt als Headscale-Nodes registriert.
* **Homeoffice:**
  * Mitarbeiter mit Firmenlaptops sind als einzelne Nodes im Headscale-Netzwerk registriert.
* **Verbindungen:**
  * Ein gestricheltes Overlay-Netzwerk (das Headscale/Wireguard-Mesh) verbindet alle Nodes (Server, Clients, Subnet Router) direkt miteinander.
  * Pfeile von allen Nodes zu Authentik (im K3s-Cluster) symbolisieren Authentifizierungsanfragen.
  * Pfeile von allen Nodes zum Headscale-Server symbolisieren die Kommunikation der Kontroll-Ebene.
  * Der Datenverkehr (z. B. vom Homeoffice-Laptop zum Samba-Server) wird als direkte Peer-to-Peer-Verbindung innerhalb des Overlays dargestellt.

### **8.2. Phasenweiser Implementierungsplan**

Die Umstellung auf eine Zero-Trust-Architektur ist ein tiefgreifender Prozess, der schrittweise erfolgen sollte, um den laufenden Betrieb nicht zu stören und eine schrittweise Adaption zu ermöglichen.

* **Phase 1: Fundament legen (ca. 1-2 Wochen)**
  1. **Deployment der Kontroll-Ebene:** Bereitstellung des Headscale-Servers auf einer VM beim Hoster mit öffentlicher IP und DNS-Konfiguration.
  2. **Deployment der Identitäts-Ebene:** Bereitstellung von Authentik im K3s-Cluster mit einer initialen (nicht-HA) Konfiguration.
  3. **Integration:** Anbindung des Active Directory als LDAP-Quelle in Authentik.
  4. **Initialer Rollout:** Registrierung aller Server (AD/Samba, K3s-Nodes) und der Laptops des IT-Admin-Teams im Headscale-Netzwerk. Erstellung einer initialen, restriktiven ACL, die nur den Admins den Zugriff auf die Server erlaubt.
* **Phase 2: Kernservices migrieren (ca. 2-3 Wochen)**
  1. **Absicherung des Managements:** Konfiguration der Host-Firewalls auf den Servern, um jeglichen Zugriff außerhalb des Wireguard-Tunnels zu blockieren. Das gesamte Server-Management erfolgt ab jetzt ausschließlich über das Headscale-Netzwerk.
  2. **MFA für Admins:** Erstellung und Zuweisung eines MFA-erforderlichen Anmelde-Flows in Authentik für alle administrativen Zugänge.
  3. **Samba-Härtung:** Umsetzung der empfohlenen Härtungsmaßnahmen für Samba und Active Directory.
* **Phase 3: Benutzer-Rollout (ca. 4-6 Wochen, je nach Unternehmensgröße)**
  1. **Gruppenweiser Rollout:** Schrittweise Registrierung der Laptops der Mitarbeiter im Headscale-Netzwerk.
  2. **ACL-Definition:** Erstellung und Anwendung von granularen ACLs für die verschiedenen Benutzergruppen (z. B. Finanzabteilung, Entwicklung).
  3. **Schulung:** Kommunikation und Schulung der Mitarbeiter über das neue Zugriffsmodell (kein klassisches VPN mehr, Authentifizierung über Authentik).
* **Phase 4: Standortvernetzung (ca. 1 Woche pro Standort)**
  1. **Drucker-Segmentierung:** Einrichtung der dedizierten Drucker-VLANs an den Standorten.
  2. **Subnet Router Deployment:** Installation und Konfiguration der Headscale Subnet Router an jedem Standort.
  3. **ACL-Anpassung:** Erweiterung der ACLs, um den Mitarbeitern den Zugriff auf die Drucker an ihrem jeweiligen Standort zu ermöglichen.
* **Phase 5: K3s-Integration und HA-Ausbau (laufend)**
  1. **K3s-Anbindung:** Konfiguration eines K3s-Nodes als Subnet Router zur Anbindung des Cluster-Netzwerks an das Headscale-Mesh.
  2. **SSO für Applikationen:** Migration interner Anwendungen im K3s-Cluster zur Nutzung von Authentik als SSO-Provider (OIDC/SAML).
  3. **Hochverfügbarkeit:** Umsetzung der HA-Strategien für Authentik (Skalierung im K3s-Cluster) und Headscale (DR-Setup mit externer PostgreSQL-DB).

#### **Referenzen**

1. NIST Offers 19 Ways to Build Zero Trust Architectures, Zugriff am August 7, 2025, [https://www.nist.gov/news-events/news/2025/06/nist-offers-19-ways-build-zero-trust-architectures](https://www.nist.gov/news-events/news/2025/06/nist-offers-19-ways-build-zero-trust-architectures)
2. Zero Trust security | What is a Zero Trust network? | Cloudflare, Zugriff am August 7, 2025, [https://www.cloudflare.com/learning/security/glossary/what-is-zero-trust/](https://www.cloudflare.com/learning/security/glossary/what-is-zero-trust/)
3. What is the NIST SP 800-207 cybersecurity framework? \- CyberArk, Zugriff am August 7, 2025, [https://www.cyberark.com/what-is/nist-sp-800-207-cybersecurity-framework/](https://www.cyberark.com/what-is/nist-sp-800-207-cybersecurity-framework/)
4. Zero Trust Networks | NIST, Zugriff am August 7, 2025, [https://www.nist.gov/programs-projects/zero-trust-networks](https://www.nist.gov/programs-projects/zero-trust-networks)
5. What is Zero Trust? \- Guide to Zero Trust Security \- CrowdStrike, Zugriff am August 7, 2025, [https://www.crowdstrike.com/en-us/cybersecurity-101/zero-trust-security/](https://www.crowdstrike.com/en-us/cybersecurity-101/zero-trust-security/)
6. 7 Core Principles of Zero Trust Security | NordLayer Learn, Zugriff am August 7, 2025, [https://nordlayer.com/learn/zero-trust/principles/](https://nordlayer.com/learn/zero-trust/principles/)
7. Zero Trust vs. the Principle of Least Privilege: What's the Differences? \- StrongDM, Zugriff am August 7, 2025, [https://www.strongdm.com/what-is/zero-trust-vs-principle-of-least-privilege](https://www.strongdm.com/what-is/zero-trust-vs-principle-of-least-privilege)
8. Zero Trust security in Azure | Microsoft Learn, Zugriff am August 7, 2025, [https://learn.microsoft.com/en-us/azure/security/fundamentals/zero-trust](https://learn.microsoft.com/en-us/azure/security/fundamentals/zero-trust)
9. What Is Microsegmentation? \- Palo Alto Networks, Zugriff am August 7, 2025, [https://www.paloaltonetworks.com/cyberpedia/what-is-microsegmentation](https://www.paloaltonetworks.com/cyberpedia/what-is-microsegmentation)
10. What is Microsegmentation? The Ultimate Guide to Zero Trust, Zugriff am August 7, 2025, [https://zeronetworks.com/blog/what-is-microsegmentation-our-definitive-guide](https://zeronetworks.com/blog/what-is-microsegmentation-our-definitive-guide)
11. The 5 Core Principles of the Zero-Trust Cybersecurity Model \- Imperva, Zugriff am August 7, 2025, [https://www.imperva.com/blog/5-core-principles-of-zero-trust/](https://www.imperva.com/blog/5-core-principles-of-zero-trust/)
12. Integrations overview | authentik, Zugriff am August 7, 2025, [https://integrations.goauthentik.io/](https://integrations.goauthentik.io/)
13. LDAP Source | authentik, Zugriff am August 7, 2025, [https://docs.goauthentik.io/docs/users-sources/sources/protocols/ldap](https://docs.goauthentik.io/docs/users-sources/sources/protocols/ldap)
14. Active Directory | authentik, Zugriff am August 7, 2025, [https://docs.goauthentik.io/docs/users-sources/sources/directory-sync/active-directory/](https://docs.goauthentik.io/docs/users-sources/sources/directory-sync/active-directory/)
15. Active Directory | authentik, Zugriff am August 7, 2025, [https://version-0-13.goauthentik.io/docs/integrations/sources/active-directory/index](https://version-0-13.goauthentik.io/docs/integrations/sources/active-directory/index)
16. Flows, stages, and policies: customizing your authentication with authentik, Zugriff am August 7, 2025, [https://goauthentik.io/blog/2024-08-27-flows-stages-and-policies/](https://goauthentik.io/blog/2024-08-27-flows-stages-and-policies/)
17. Flows \- authentik, Zugriff am August 7, 2025, [https://docs.goauthentik.io/docs/add-secure-apps/flows-stages/flow/](https://docs.goauthentik.io/docs/add-secure-apps/flows-stages/flow/)
18. Example \- authentik, Zugriff am August 7, 2025, [https://docs.goauthentik.io/docs/customize/blueprints/v1/example](https://docs.goauthentik.io/docs/customize/blueprints/v1/example)
19. Authenticator Validation stage \- authentik, Zugriff am August 7, 2025, [https://docs.goauthentik.io/docs/add-secure-apps/flows-stages/stages/authenticator\_validate/](https://docs.goauthentik.io/docs/add-secure-apps/flows-stages/stages/authenticator_validate/)
20. Not all MFA methods are created equally: what authentik supports (and why), Zugriff am August 7, 2025, [https://goauthentik.io/blog/2025-03-05-mfa-in-authentik/](https://goauthentik.io/blog/2025-03-05-mfa-in-authentik/)
21. Example flows \- Authentik docs, Zugriff am August 7, 2025, [https://docs.goauthentik.io/docs/add-secure-apps/flows-stages/flow/examples/flows](https://docs.goauthentik.io/docs/add-secure-apps/flows-stages/flow/examples/flows)
22. Policies | authentik, Zugriff am August 7, 2025, [https://docs.goauthentik.io/docs/customize/policies/](https://docs.goauthentik.io/docs/customize/policies/)
23. Differences between WireGuard, TailScale and HeadScale? : r/homelab \- Reddit, Zugriff am August 7, 2025, [https://www.reddit.com/r/homelab/comments/1alshvq/differences\_between\_wireguard\_tailscale\_and/](https://www.reddit.com/r/homelab/comments/1alshvq/differences_between_wireguard_tailscale_and/)
24. How it works \- Tailscale, Zugriff am August 7, 2025, [https://tailscale.com/blog/how-tailscale-works](https://tailscale.com/blog/how-tailscale-works)
25. Headscale, Zugriff am August 7, 2025, [https://headscale.net/](https://headscale.net/)
26. mikeroyal/WireGuard-Guide: WireGuard Guide. Learn all about WireGuard for Networking and in the Cloud (Microsoft Azure, AWS, and Google Cloud). \- GitHub, Zugriff am August 7, 2025, [https://github.com/mikeroyal/WireGuard-Guide](https://github.com/mikeroyal/WireGuard-Guide)
27. \[Feature\] multiple replicas of headscale instances · Issue \#2695 \- GitHub, Zugriff am August 7, 2025, [https://github.com/juanfont/headscale/issues/2695](https://github.com/juanfont/headscale/issues/2695)
28. Tailscale vs. Headscale : r/selfhosted \- Reddit, Zugriff am August 7, 2025, [https://www.reddit.com/r/selfhosted/comments/1lnnc4e/tailscale\_vs\_headscale/](https://www.reddit.com/r/selfhosted/comments/1lnnc4e/tailscale_vs_headscale/)
29. Requirements and Assumptions \- Headscale, Zugriff am August 7, 2025, [http://headscale.net/0.25.1/setup/requirements/](http://headscale.net/0.25.1/setup/requirements/)
30. Getting started \- Headscale, Zugriff am August 7, 2025, [https://headscale.net/stable/usage/getting-started/](https://headscale.net/stable/usage/getting-started/)
31. Understanding headscale/tailscale ACL \- Personal blog of Anurag Bhatia, Zugriff am August 7, 2025, [https://anuragbhatia.com/post/2024/04/understanding-headscale-tailscale-acl/](https://anuragbhatia.com/post/2024/04/understanding-headscale-tailscale-acl/)
32. ACLs \- Headscale, Zugriff am August 7, 2025, [https://headscale.net/stable/ref/acls/](https://headscale.net/stable/ref/acls/)
33. Features \- Headscale, Zugriff am August 7, 2025, [http://headscale.net/0.26.1/about/features/](http://headscale.net/0.26.1/about/features/)
34. Hardening Samba as an AD DC \- SambaWiki, Zugriff am August 7, 2025, [https://wiki.samba.org/index.php/Hardening\_Samba\_as\_an\_AD\_DC](https://wiki.samba.org/index.php/Hardening_Samba_as_an_AD_DC)
35. Top Active Directory Security Best Practices \- miniOrange, Zugriff am August 7, 2025, [https://www.miniorange.com/blog/active-directory-security-best-practices/](https://www.miniorange.com/blog/active-directory-security-best-practices/)
36. Securing Domain Controllers Against Attack | Microsoft Learn, Zugriff am August 7, 2025, [https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/plan/security-best-practices/securing-domain-controllers-against-attack](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/plan/security-best-practices/securing-domain-controllers-against-attack)
37. Active Directory Security Best Practices | Netwrix, Zugriff am August 7, 2025, [https://www.netwrix.com/active-directory-best-practices.html](https://www.netwrix.com/active-directory-best-practices.html)
38. How to Implement Zero Trust Architecture in Active Directory \- Lepide, Zugriff am August 7, 2025, [https://www.lepide.com/blog/how-to-implement-zero-trust-architecture-in-active-directory/](https://www.lepide.com/blog/how-to-implement-zero-trust-architecture-in-active-directory/)
39. Secure endpoints with Zero Trust | Microsoft Learn, Zugriff am August 7, 2025, [https://learn.microsoft.com/en-us/security/zero-trust/deploy/endpoints](https://learn.microsoft.com/en-us/security/zero-trust/deploy/endpoints)
40. What is Zero Trust Endpoint Security? \- SentinelOne, Zugriff am August 7, 2025, [https://www.sentinelone.com/cybersecurity-101/endpoint-security/zero-trust-endpoint-security/](https://www.sentinelone.com/cybersecurity-101/endpoint-security/zero-trust-endpoint-security/)
41. Zero Trust Endpoint Security: Your Defense Against Evolving Threats, Zugriff am August 7, 2025, [https://blog.netwrix.com/zero-trust-endpoint-security](https://blog.netwrix.com/zero-trust-endpoint-security)
42. Manage devices with Intune | Microsoft Learn, Zugriff am August 7, 2025, [https://learn.microsoft.com/en-us/security/zero-trust/manage-devices-with-intune-overview](https://learn.microsoft.com/en-us/security/zero-trust/manage-devices-with-intune-overview)
43. Network Printers and Security: In-Depth Overview \- Pharos, Zugriff am August 7, 2025, [https://www.pharos.com/pillar-page/printers-cybersecurity/](https://www.pharos.com/pillar-page/printers-cybersecurity/)
44. Routes \- Headscale, Zugriff am August 7, 2025, [https://headscale.net/stable/ref/routes/](https://headscale.net/stable/ref/routes/)
45. 7 Ways Print Management Supports a Zero Trust Security Environment, Zugriff am August 7, 2025, [https://www.datamaxtexas.com/blog/7-ways-print-management-supports-a-zero-trust-security-environment](https://www.datamaxtexas.com/blog/7-ways-print-management-supports-a-zero-trust-security-environment)
46. Zero Trust Security for Printers \- Xerox, Zugriff am August 7, 2025, [https://www.xerox.com/en-us/about/security-solutions/zero-trust-security](https://www.xerox.com/en-us/about/security-solutions/zero-trust-security)
47. UniFLOW Online for Zero Trust environments \- Canon Australia, Zugriff am August 7, 2025, [https://www.canon.com.au/business/zero-trust-print-environments](https://www.canon.com.au/business/zero-trust-print-environments)
48. Protect Your Data with Zero-Trust Printing | SAFEQ Blog \- Y Soft, Zugriff am August 7, 2025, [https://www.ysoft.com/safeq/blog/zero-trust-print/](https://www.ysoft.com/safeq/blog/zero-trust-print/)
49. How Printerlogic makes Printing easy and secure in Zero Trust network-access environments \- Vasion, Zugriff am August 7, 2025, [https://vasion.com/resources/how-printerlogic-makes-printing-easy-and-secure-in-zero-trust-network-access-environments/](https://vasion.com/resources/how-printerlogic-makes-printing-easy-and-secure-in-zero-trust-network-access-environments/)
50. Basic Network Options \- K3s \- Lightweight Kubernetes, Zugriff am August 7, 2025, [https://docs.k3s.io/networking/basic-network-options](https://docs.k3s.io/networking/basic-network-options)
51. Architecture | authentik, Zugriff am August 7, 2025, [https://docs.goauthentik.io/docs/core/architecture](https://docs.goauthentik.io/docs/core/architecture)
52. 3 ways you (might be) doing containers wrong | authentik, Zugriff am August 7, 2025, [https://goauthentik.io/blog/2023/10/26/you-might-be-doing-containers-wrong/item/](https://goauthentik.io/blog/2023/10/26/you-might-be-doing-containers-wrong/item/)
53. Authentik-remote-cluster Helm Chart \- Datree, Zugriff am August 7, 2025, [https://www.datree.io/helm-chart/authentik-remote-cluster-goauthentik](https://www.datree.io/helm-chart/authentik-remote-cluster-goauthentik)
54. Kubernetes | authentik, Zugriff am August 7, 2025, [https://docs.goauthentik.io/docs/add-secure-apps/outposts/integrations/kubernetes](https://docs.goauthentik.io/docs/add-secure-apps/outposts/integrations/kubernetes)
55. Release 0.12 \- authentik, Zugriff am August 7, 2025, [https://docs.goauthentik.io/docs/releases/0.12](https://docs.goauthentik.io/docs/releases/0.12)
56. PostgreSQL High Availability Options: A Guide \- Yugabyte, Zugriff am August 7, 2025, [https://www.yugabyte.com/postgresql/postgresql-high-availability/](https://www.yugabyte.com/postgresql/postgresql-high-availability/)
57. postgresql 12.8.2 \- Artifact Hub, Zugriff am August 7, 2025, [https://artifacthub.io/packages/helm/goauthentik/postgresql](https://artifacthub.io/packages/helm/goauthentik/postgresql)
58. Adding a Postgres High-Availability database to your Kubernetes cluster \- Medium, Zugriff am August 7, 2025, [https://medium.com/@martin.hodges/adding-a-postgres-high-availability-database-to-your-kubernetes-cluster-634ea5d6e4a1](https://medium.com/@martin.hodges/adding-a-postgres-high-availability-database-to-your-kubernetes-cluster-634ea5d6e4a1)
59. Redis High Availability | Redis Enterprise, Zugriff am August 7, 2025, [https://redis.io/technology/highly-available-redis/](https://redis.io/technology/highly-available-redis/)
60. High availability with Redis Sentinel | Docs, Zugriff am August 7, 2025, [https://redis.io/docs/latest/operate/oss\_and\_stack/management/sentinel/](https://redis.io/docs/latest/operate/oss_and_stack/management/sentinel/)
61. Configuration | authentik, Zugriff am August 7, 2025, [https://docs.goauthentik.io/docs/install-config/configuration/](https://docs.goauthentik.io/docs/install-config/configuration/)
62. Love headscale, we just took it to production and it's been great | Hacker News, Zugriff am August 7, 2025, [https://news.ycombinator.com/item?id=43563824](https://news.ycombinator.com/item?id=43563824)
63. FAQ \- Headscale, Zugriff am August 7, 2025, [http://headscale.net/0.26.1/about/faq/](http://headscale.net/0.26.1/about/faq/)
