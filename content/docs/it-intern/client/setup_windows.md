---
title: Setup Windows Client
description: Wie man einen Windows Client in die Firma einbindet.
---

- Windows Rechner mit Professional Version kaufen (Aufgeräumt wird über Ansible)
- Windows Rechner vollständig laden
- Beim ersten Anschalten lokalen Benutzer oder Domäne auswählen.
- Lokaler Benutzer ist der Hauptnutzer des Gerätes.
- Kennwort wird in der IT Datenbank gesichert
- Alle Datensammelei während des Setups verbieten
- Rechner in Domäne aufnehmen
- Ansible Setup Script starten (liegt im ansible-main Repo unter files)
- Ansible Variablen setzen für den Host (VPN)
- Ansible laufen lassen (Neustarts notwendig und werden nicht durch Ansible
  ausgeführt. Einfach solang bis es durchläuft)

- Wawi testen
- Rechner ausliefern und mit dem Endnutzer einrichten (Wawi, Mail, Browser)
