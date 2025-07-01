---
title: Logins
description: "Zugang zu den Servern"
tags:
  - homelab
  - service
---

Alle Zugangsdaten sind entweder in der Persönlichen Keepass Datendank (für
personalisierte Logindaten) oder in der IT Datenbank. Der Login auf die Server
geschieht über SSH Schlüssel. Ein Login mit dem Passwort ist nicht vorgesehen.

Für den externen Zugriff ist der Login über [VPN](https://vpn.zyria.de) oder einem Bastion Host
bastion@vpn.zyria.de:3022 möglich. {{< mdl-disable "<!-- markdownlint-disable MD034 -->" >}}

Generell sollte jedoch ein Login auf die Server nur zum Suchen von Fehlern
stattfinden. Die Verwaltung erfolgt ausschliesslich über Ansible. Jede händisch
durchgeführte Änderung muss im Nachhinein in Ansible eingepflegt und getestet
werden.
