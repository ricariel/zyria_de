---
title: 'Hetzner Server'
description: 'Unsere Server bei Hetzner'
date: 2023-10-19T13:28:04+02:00
weight: 50
---

## Server bei Hetzner

### Hardware

Aktuell sind alle Server bei Hetzner [AX101](https://www.hetzner.com/de/dedicated-rootserver/ax101) Server.
Die Server sind Ipv6 only bestellt und beziehen eine IPv4 aus einem [Hetzner vSwitch](https://docs.hetzner.com/de/robot/dedicated-server/network/vswitch/).

### Hetzner Config

Im [Robot](https://robot.hetzner.com/server) Reverse-DNS-Eintrag - Ipv4 und Ipv6 - setzen. Auch an den [vswitch](https://robot.hetzner.com/vswitch/index) denken.

### Dienste

#### Proxmox Node

Alle physikalisch vorhandene Server werden mit folgender Konfiguration installiert:

```bash
git clone https://git.zyria.de/pyrox/hetzner-install.git
./install.sh FQDN CRYPT_PASS IPV4
systemctl reboot
```

Nach der Installation von Proxmox (post-install Script) muss der Server neu gestartet werden.
> systemctl reboot

Sollte die Installation über das Hetzner Script fehlschlagen, folgende Anleitung nutzen:
[Proxmox Install on Top of Debian](https://pve.proxmox.com/wiki/Install_Proxmox_VE_on_Debian_11_Bullseye)

#### Proxmox Backup Server

Der Installation von [Proxmox Backup Server](https://pbs.proxmox.com/docs/installation.html) folgen.

#### Einrichtung des Servers mittels Ansible

```Bash
ansible-playbook --limit <servername> site.yml -k -K
```

#### Tang und Clevis

Wie in [dieser Anleitung](https://www.networkshinobi.com/clevis-and-tang-network-bound-disk-encryption/) installieren auf allen physischen Hosts.
Hinzufügen zu den internen Tang Servern

```bash
clevis luks bind -d /dev/md1 tang '{"url": "http://[ipv6]"}'
```
