---
title: "Hetzner Server installieren"
description: "Wir wir eine Maschine bei Hetzner zu einem Proxmox Server machen."
summary: "Anbei ist der Ablauf beschrieben einen Hetzner Server in das System einzubinden."
---

## [Bestellung](https://robot.hetzner.com/order) von Servern

1. IPv4 Option. Nach der Installation wird diese direkt gekündigt. Die IPv4 Adresse bekommt der Server später über den [Vswitch](https://robot.hetzner.com/vswitch/index).
1. Server werden immer mit Rescue System bestellt. Wir installieren unsere Maschinen selbst.
1. Bei der Bestellung unbedingt einen [SSH Key hinterlegen](https://robot.hetzner.com/key/index).
1. [Status](https://docs.hetzner.com/de/general/others/order-processing/) prüfen und Puffer von etwa acht Stunden einplanen. (Lieber einen Tag zu früh bezahlen als ohne Server sein)

## Nach der Bestellung

1. Alle notwendigen Informationen werden uns Email zugesandt.
1. Prüfe den Fingerprint des Public Keys in der Email. Sollte der Key nicht stimmen, starte den Server erneut und mit korrekten Schlüssel in das [Rescue System](https://robot.hetzner.com/server).
1. Prüfe beim Einloggen den Host-Key Fingerprint. Sollte dieser nicht korrekt sein, wende dich an den Hetzner Support
1. Hetzner überprüft seine Hardware vor der Auslieferung. Sollte etwas auffällig sein, Server reklamieren. So der Server bereits eine längere Laufzeit hinter sich hat, die Lebensdauer der SSD überprüfen und gegebenenfalls tauschen lassen.

## Installation

1. Git auf dem Server installieren
1. [Repository](https://git.casa-due-pur.de/fabrice.kirchner/hetzner-install.git) holen
1. Daten beschaffen:

  a. FQDN = überlege einen passenden Namen für die Maschine.
  a. CRYPT_PASS = lass dir ein sicheres Passwort in deinem Passwortgenerator
    generieren.
  a. IPV4 = Die Adresse aus der Auslieferungsmail von Hetzner

1. > ./install.sh FQDN CRYPT_PASS IPV4
1. Neustart, wenn keine Fehlermeldungen kamen.

1. TODO: STORAGE beschreiben
1. Remote unlock einrichten.
    Per SSH funktioniert das entsperren der Luks Partitionen bereits. Damit dies automatisch funktioniert, müssen noch alle Tang Server hinzugefügt werden, welche die Partitionen entsperren dürfen. Dazu als erstes die neue IP in der Firewall freischalten und dann folgende Kommandos auf der Kommandozeile eingeben:

  ```bash
    clevis luks bind -d /dev/md1 tang '{"url": "http://[2003:a:b16:4700:56b2:3ff:fefd:3ec9]"}'
    # cl07
    clevis luks bind -d /dev/md1 tang '{"url": "http://[2a01:4f9:5a:5393::2]"}'
    # cl06
    clevis luks bind -d /dev/md1 tang '{"url": "http://[2a01:4f8:151:3184::2]"}'
    # cl05
    clevis luks bind -d /dev/md1 tang '{"url": "http://[2a01:4f8:151:317c::2]"}'
  ```
