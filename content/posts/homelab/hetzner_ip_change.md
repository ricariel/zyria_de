---
title: "Hetzner Server IP Adress tausch"
description: "Wie wir bei einem Hetzner Server die IP tauschen"
summary: "Anbei ist der Ablauf beschrieben einen Hetzner Server nach Hardwqre Tausch mit einer neuen IP zu versorgen"
tags:
  - homelab
  - extern
---

## Server bei Hetzner

Unsere Server haben einen 10G Uplink erhalten. Wir müssen also ein paar Modifikationen durchführen damit sie wieder Einsatzbereit sind.

Wir starten mit der Bestätigungsmail von Hetzner in der die geänderte Hardware, die neue Netzwerkkonfiguration sowie ein einmaligen root Kennwort hinterlegt sind.

## Ändern der IP in Corosync

Auf einem beliebigen anderen Proxmox Node müssen wir die Adresse in Corosync für diesen Node ändern

Dazu die Datei /etc/pve/corosync.conf öffnen und unter nodelist node ring0_addr ändern wo name = <node der modifiziert wurde>

## Auf dem Node selbst

- Per SSH Einloggen
- root Dateisystem entsperren (meist /dev/md1)
- root,boot mounten (am besten unter /target)


```bash
mount --bind /proc/ /target/proc/
mount --bind /dev/ /target/dev/
mount --bind /sys/ /target/sys/
mount --bind /run/ /target/run/
mount --bind /dev/pts /target/dev/pts
```

## Adresse und Interface Namen korrigieren

Speziell folgende Dateien überprüfen und neue IP sowie neuen Interfacenamen überall setzen.

etc/network/interfaces 

Nachfolgend auch zwingend statisch das Interface setzen:

etc/initramfs-tools/scripts/init-premount/ipv6

Zur Sicherheit noch einmal schauen ob noch irgendwo die alte IP genutzt wird.

```bash
egrep -ris '<alte ip>' /target/etc
```

Bearbeite das clevis unlock Setup 

```bash
clevis-luks-list
clevis-luks-edit
```

Initramfs update

```bash
update-initramfs -k all -u
```

## Proxmox Firewall anpassen

Die Proxmox Firewall muss so umgestellt werden, dass die alte IP durch die neue ersetzt wird (meist nur das Alias für die Hauptip des Nodes ändern.

## Nach den Arbeiten

- Läuft Corosync mit der richtigen IP?
- Ist der Node im Proxmox sichtbar?
- Ist der Storage verfügbar?
- Funktioniert der Sync zwischen den Maschinen?

### Maschinen migrieren

Alle Maschinen wieder auf den Node verschieben
