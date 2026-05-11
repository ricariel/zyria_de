---
title: Server-,Diensteverwaltung
description: "Möglichkeiten die Server und Dienste zu verwalten"
tags:
  - extern
  - homelab
  - software
---

Wir verwenden zur generellen Verwaltung von Servern Ansible. Für manche Dienste
ist es jedoch notwendig oder praktikabler dies über vorhandene Portale zu
realisieren.

## Core-Networks (DNS)

Unsere DNS Server werden bei [Core-Networks](https://www.core-networks.de)
gehostet. In deren [Webinterface](https://iface.core-networks.de) lassen sich
alle relevanten Änderungen durchführen.

## Hetzner (Server,IP,Reverse DNS)

Hetzner bietet ein [Interface](https://robot.hetzner.com) zur Steuerung an. Dort
werden und müssen auch Reverse DNS Einträge angelegt. Für die
[Vswitch](https://robot.hetzner.com/vswitch/index) und für
[Server](https://robot.hetzner.com/server).

Cloudserver werden über ein eigenes
[Interface](https://console.hetzner.cloud/projects) gesteuert.

## Externes Monitoring

Monitoring für einzenle Dienste und alle Server und IP's über
[Hetrixtools](https://hetrixtools.com)

## Anydesk

Anydesk [Verwaltung](https://my.anydesk.com/login)

## Proxmox (VM)

Jeder Proxmox Host hat auch ein eigenes Webinterface, welches unter [https://example.com:8006/](https://example.com:8006/) erreichen lässt. Für einen angenehmeren Zugang steht der Zugang über den [Load Balancer](https://pve.example.com/) bereit.

## VPN

Wirguard läuft in einem Docker Container mit [Webinterface](https://vpn.example.com)
und wird komplett darüber konfiguriert.

## Konfiguration/Content (git)

Alle Konfigurationsdateien und Teile von statischem Content liegen auf einer
[Forgejo](https://git.example.com/) (ehemals Gitea) Instanz.

## Netzwerk

Wir setzen weitestgehend auf Zubehör von [Unifi](https://www.ui.com) um das
Netzwerk und Kameraüberwachung zu realisieren. Der
[Controller](unifi.example.com) läuft in einem Docker Container.

## Statusseite/Monitoring

Über [Uptime-Kuma](https://github.com/louislam/uptime-kuma) wurde ein
rudimentäres [Monitoring](https://status.example.com/dashboard) eingrichet
und den Mitarbeitern bekannt gegeben. Dies sollte die Erste Anlaufstelle sein,
wenn etwas nicht funktioniert.

## CI/CD

Das Forgejo eigene CI/CD Werkzeug wird genutzt.

## Spamerkennung

Zur Spamabwehr nutzen wir [Rspamd](https://rspamd.com). Das [Interface](https://rspamd.example.com/) ist lässt die Konfiguration relevanter Parameter zu und ermöglicht Debugging bei der Mailzustellung.

## Werbeblocker/DNS

[Pihole Webinterface](https://pihole.example.com/admin/)

## Backup
Proxmox Backup Server [Interface](https://pbs-(location).example.com:8007) installiert.
