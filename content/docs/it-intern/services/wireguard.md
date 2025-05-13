---
title: Wireguard
description: "Beschreibung von Wireguard"
---

## Quelle

[Docker Hub Bastion](https://hub.docker.com/r/ricariel/bastion)

[Docker Hub Wireguard](https://hub.docker.com/r/linuxserver/wireguard)

[Docker Hub wg-portal](https://hub.docker.com/r/wgportal/wg-portal)

## Repository

[Bastion](https://git.zyria.de/pyrox/docker-ssh-bastion)

[Github wireguard](https://github.com/linuxserver/docker-wireguard)

[Github wg-portal](https://github.com/h44z/wg-portal)

## Dokumentation

[Hersteller Bastion](https://git.zyria.de/pyrox/docker-ssh-bastion)

[Linuxserver.io wireguard](https://docs.linuxserver.io/images/docker-wireguard)

[Github wg-portal](https://github.com/h44z/wg-portal)

## Funktion

Der Bastion Container stellt einen SSH Jumphost bereit. Primär für die Nutzung
von Ansible. Damit lassen sich alle Geräte hinter den NATs erreichen, welche im
VPN sind.

Wireguard stellt ein hinreichend sicheres VPN bereit, welches von alles Clients
und Windows Maschinen genutzt wird. Aktuell sind die Drucker nicht
angeschlossen. Auch ein Standorttunnel über lokale Router ist nicht realisiert,
da die Router mit IPv6 in Wireguard Tunneln nicht zurechtkommen.

Wg-portal stellt eine leichte Möglichkeit bereit den Mitarbeitern vordefinierte
Zugänge zum VPN bereitzustellen. Der Container nutzt das Netzwerk des wireguard
Containers und muss deshalb mit ihm zusammen neu gestartet werden.

Alle Services sind öffentlich erreichbar.
