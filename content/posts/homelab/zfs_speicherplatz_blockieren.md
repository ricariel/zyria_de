---
title: "Speicherplatz auf ZFS blockieren"
description: "Speicherplatz auf ZFS reservieren oder mit einer Dummy-Datei blockieren"
tags:
  - homelab
  - zfs
---

* **Kategorie:** Systemadministration / Storage
* **Status:** Aktiv
* **Zielgruppe:** IT-Infrastruktur / DevOps

---

## Übersicht

In dieser Dokumentation wird beschrieben, wie Speicherplatz auf ZFS-Pools gezielt blockiert oder reserviert werden kann. Dies ist häufig für Kapazitäts-Tests, zur Absicherung kritischer Datasets gegen "Disk Full"-Zustände oder für Software-Tests notwendig.

Es werden zwei Methoden beschrieben:

1. **Der native ZFS-Weg (Empfohlen):** Ressourcenschonend, sofort aktiv, ohne Schreiblast.
2. **Der Weg über eine Dummy-Datei:** Für Applikationen, die physische Dateien prüfen müssen (Achtung bei Kompression!).

---

## Methode 1: Native ZFS-Reservierung (Empfohlen)

ZFS bietet integrierte Mechanismen, um Speicherplatz zu reservieren, ohne tatsächliche Daten schreiben zu müssen. Dies blockiert den Platz für andere Datasets im selben Pool sofort und ohne Performance-Verlust.

### 1.1 `reservation` vs. `refreservation`

* **`reservation`**: Reserviert Speicherplatz für ein bestimmtes Dataset **inklusive** all seiner Snapshots und Kind-Datasets (Clones/Sub-Datasets).
* **`refreservation`**: Reserviert Speicherplatz **ausschließlich** für das Dataset selbst (Snapshots und Kind-Datasets sind von der Reservierung ausgeschlossen). Für die reine Blockierung ist dies meist die sicherere Wahl.

### 1.2 Durchführung

Um beispielsweise **50 GB** auf dem Dataset `meinpool/mein-dataset` zu blockieren/reservieren, wird folgender Befehl ausgeführt:

```bash
sudo zfs set refreservation=50G meinpool/mein-dataset
```

### 1.3 Überprüfung

Der reservierte Speicherplatz wird direkt vom Pool abgezogen und steht anderen Datasets nicht mehr zur Verfügung. Die Prüfung erfolgt via:

```bash
zfs get refreservation,used,available meinpool/mein-dataset
```

### 1.4 Aufhebung der Blockierung

Um die Reservierung wieder zu entfernen und den Speicherplatz freizugeben, wird der Wert auf `none` gesetzt:

```bash
sudo zfs set refreservation=none meinpool/mein-dataset
```

---

## Methode 2: Blockierung mittels Dummy-Datei

Falls ein Test-Szenario zwingend eine reale Datei im Dateisystem erfordert, muss die ZFS-Eigenschaft **Kompression (compression)** beachtet werden. Standardmäßig komprimiert ZFS Nullen extrem effizient, wodurch eine 10-GB-Null-Datei im Pool effektiv 0 Byte belegen würde.

### Option A: Über temporäre Deaktivierung der Kompression (Schneller)

Wenn die Datei schnell erstellt werden soll, schalten wir die Kompression kurzzeitig ab, schreiben die Datei mit Nullen (`/dev/zero`) und aktivieren die Kompression danach wieder.

#### 1. Kompression prüfen und deaktivieren

```bash
# Aktuellen Wert prüfen (für den späteren Rückbau merken, z.B. lz4 oder zstd)

zfs get compression meinpool/mein-dataset

# Kompression ausschalten

sudo zfs set compression=off meinpool/mein-dataset
```

#### 2. Datei mit `dd` schreiben

Nutze **nicht** `fallocate`, da dies je nach ZFS-Version oft nur dünn besiedelte Dateien (Sparse Files) erzeugt. Verwende stattdessen `dd`.

Beispiel für eine **10 GB** große Datei:

```bash
sudo dd if=/dev/zero of=/pool/dataset/blocker.dat bs=1M count=10000 status=progress
```

#### 3. Kompression wieder aktivieren

```bash
# Ersetze 'on' durch den vorherigen Wert (z. B. lz4), falls nötig

sudo zfs set compression=on meinpool/mein-dataset
```

---

### Option B: Über Zufallsdaten (Keine Änderung der Pool-Eigenschaften nötig)

Wenn die Kompression auf dem Dataset nicht verändert werden darf, muss die Datei mit unkomprimierbaren Zufallsdaten (`/dev/urandom`) gefüllt werden.

> ⚠️ **Achtung:** Dies erzeugt eine hohe CPU-Last und dauert je nach Systemgeschwindigkeit deutlich länger!

```bash
sudo dd if=/dev/urandom of=/pool/dataset/blocker.dat bs=1M count=10000 status=progress
```

#### 4. Freigabe des Speichers

Um den Platz wieder freizugeben, wird die Datei einfach gelöscht:

```bash
sudo rm /pool/dataset/blocker.dat
```

---

## Wichtige Hinweise & Best Practices

> ❗ **Wichtig bei Methode 2:** Das Löschen einer großen Dummy-Datei gibt den Speicherplatz auf ZFS unter Umständen nicht sofort im Pool frei, wenn im Hintergrund noch asynchrone ZFS-Zyklen (`txg_sync`) laufen oder ältere Snapshots existieren, die den Zustand vor dem Löschen festhalten.
>
> Wenn Snapshots aktiv sind, belegt die Dummy-Datei auch nach dem Löschen weiterhin Platz, bis die entsprechenden Snapshots gelöscht wurden!

---
*Dokumenten-Historie:*

* *v1.2 (2026-07-20): Ersterstellung der Dokumentation*
