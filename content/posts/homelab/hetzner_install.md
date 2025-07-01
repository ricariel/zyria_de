---
title: "Hetzner Server"
description: "Wir wir eine Maschine bei Hetzner zu einem Proxmox Server machen."
summary: "Anbei ist der Ablauf beschrieben einen Hetzner Server in das System einzubinden."
series:
  - homelab
---

## Server bei Hetzner

### Hardware

Aktuell sind alle Server bei Hetzner [AX101](https://www.hetzner.com/de/dedicated-rootserver/ax101) Server.
Die Server sind Ipv6 only bestellt und beziehen eine IPv4 aus einem [Hetzner vSwitch](https://docs.hetzner.com/de/robot/dedicated-server/network/vswitch/).

### Hetzner Config

Im [Robot](https://robot.hetzner.com/server) Reverse-DNS-Eintrag - Ipv4 und Ipv6 - setzen. Auch an den [vswitch](https://robot.hetzner.com/vswitch/index) denken.

### [Bestellung](https://robot.hetzner.com/order) von Servern

1. IPv4 Option. Nach der Installation wird diese direkt gekündigt. Die IPv4 Adresse bekommt der Server später über den [Vswitch](https://robot.hetzner.com/vswitch/index).
1. Server werden immer mit Rescue System bestellt. Wir installieren unsere Maschinen selbst.
1. Bei der Bestellung unbedingt einen [SSH Key hinterlegen](https://robot.hetzner.com/key/index).
1. [Status](https://docs.hetzner.com/de/general/others/order-processing/) prüfen und Puffer von etwa acht Stunden einplanen. (Lieber einen Tag zu früh bezahlen als ohne Server sein)

### Nach der Bestellung

1. Alle notwendigen Informationen werden uns Email zugesandt.
1. Prüfe den Fingerprint des Public Keys in der Email. Sollte der Key nicht stimmen, starte den Server erneut und mit korrekten Schlüssel in das [Rescue System](https://robot.hetzner.com/server).
1. Prüfe beim Einloggen den Host-Key Fingerprint. Sollte dieser nicht korrekt sein, wende dich an den Hetzner Support
1. Hetzner überprüft seine Hardware vor der Auslieferung. Sollte etwas auffällig sein, Server reklamieren. So der Server bereits eine längere Laufzeit hinter sich hat, die Lebensdauer der SSD überprüfen und gegebenenfalls tauschen lassen.

### Installation

1. Git auf dem Server installieren
1. [Repository](https://git.casa-due-pur.de/fabrice.kirchner/hetzner-install.git) holen
1. Daten beschaffen:

  a. FQDN = überlege einen passenden Namen für die Maschine.
  a. CRYPT_PASS = lass dir ein sicheres Passwort in deinem Passwortgenerator
    generieren.
  a. IPV4 = Die Adresse aus der Auslieferungsmail von Hetzner

1. |

  ```bash
  git clone https://git.zyria.de/pyrox/hetzner-install.git
  ./install.sh FQDN CRYPT_PASS IPV4
  systemctl reboot
  ```

1. Neustart, wenn keine Fehlermeldungen kamen.

1. TODO: STORAGE beschreiben
1. Remote unlock einrichten.
    Per SSH funktioniert das entsperren der Luks Partitionen bereits. Damit dies automatisch funktioniert, müssen noch alle Tang Server hinzugefügt werden, welche die Partitionen entsperren dürfen. Dazu als erstes die neue IP in der Firewall freischalten und dann folgende Kommandos auf der Kommandozeile eingeben

Sollte die Installation über das Hetzner Script fehlschlagen, folgende Anleitung nutzen:
[Proxmox Install on Top of Debian](https://pve.proxmox.com/wiki/Install_Proxmox_VE_on_Debian_11_Bullseye)

### Tang und Clevis

Wie in [dieser Anleitung](https://www.networkshinobi.com/clevis-and-tang-network-bound-disk-encryption/) installieren auf allen physischen Hosts.
Hinzufügen zu den internen Tang Servern

```bash
clevis luks bind -d /dev/md1 tang '{"url": "http://[ipv6]"}'
```

### Proxmox Backup Server

Der Installation von [Proxmox Backup Server](https://pbs.proxmox.com/docs/installation.html) folgen.

### Einrichtung des Servers mittels Ansible

```Bash
ansible-playbook --limit <servername> site.yml -k -K
```
