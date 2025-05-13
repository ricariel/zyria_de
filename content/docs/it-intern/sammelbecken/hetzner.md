# Server bei Hetzner

## Hardware

Aktuell sind alle Server bei Hetzner [AX101](https://www.hetzner.com/de/dedicated-rootserver/ax101) Server.
Die Server sind Ipv6 only bestellt und beziehen eine IPv4 aus einem [Hetzner vSwitch](https://docs.hetzner.com/de/robot/dedicated-server/network/vswitch/).

### cl05

- Standardserver (Proxmox Node)
- Genutzt für daily Business
- Standort: [FSN1-DC6](https://docs.hetzner.com/de/cloud/general/locations/)

### cl06

- Standardserver (Proxmox Node)
- Genutzt für daily Business
- Standort: [FSN1-DC6](https://docs.hetzner.com/de/cloud/general/locations/)

### cl07

- Standardserver (Proxmox Node) und Proxmox Backup Server
- Genutzt für IT, Entwicklung, Backup und als Lastreserve
- Standort: [HEL1-DC5](https://docs.hetzner.com/de/cloud/general/locations/)
- Dieser Server hat zusätzlich zwei Datacenter 16TB Festplatten eingebaut.

## Hetzner Config

Im [Robot](https://robot.hetzner.com/server) Reverse-DNS-Eintrag - Ipv4 und Ipv6 - setzen. Auch an den [vswitch](https://robot.hetzner.com/vswitch/index) denken.

## Dienste

### Proxmox Node

Alle physikalisch vorhandene Server werden mit folgender Konfiguration installiert:

```bash
git clone https://www.casa-due-pur.de/git/fabrice.kirchner/hetzner-install.git
./install.sh FQDN CRYPT_PASS IPV4
systemctl reboot
```

Nach der Installation von Proxmox (post-install Script) muss der Server neu gestartet werden.
> systemctl reboot

Sollte die Installation über das Hetzner Script fehlschlagen, folgende Anleitung nutzen:
[Proxmox Install on Top of Debian](https://pve.proxmox.com/wiki/Install_Proxmox_VE_on_Debian_11_Bullseye)

### Proxmox Backup Server

Der Installation von [Proxmox Backup Server](https://pbs.proxmox.com/docs/installation.html) folgen.

### Einrichtung des Servers mittels Ansible

```Bash
ansible-playbook --limit <servername> site.yml -k -K
```

### Tang und Clevis

Wie in [dieser Anleitung](https://www.networkshinobi.com/clevis-and-tang-network-bound-disk-encryption/) installieren auf allen physischen Hosts.
Hinzufügen zu den internen Tang Servern

```bash
clevis luks bind -d /dev/md1 tang '{"url": "http://[ipv6]"}'
```
