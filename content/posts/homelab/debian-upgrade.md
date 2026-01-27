---
title: Debian Upgrade
description: Debian Upgrade
---

Wie man Debian zuverlässig auf den Stand bringt. Danke an [doku.lrz.de](https://doku.lrz.de/upgrade-auf-debian-13-trixie-1921298568.html) die dies bei jedem Release aufschreiben.

Debian stellt auch eine [Anleitung](https://www.debian.org/releases/stable/release-notes/upgrading.de.html) zur Verfügung.

Proxmox hat für jedes Release einen [Wiki](https://pve.proxmox.com/wiki/Category:Upgrade) Artikel. Auf für den [Proxmox Backup Server](https://pbs.proxmox.com/wiki/Category:Upgrade).

## Vorbereitungen

```bash
apt update
apt full-upgrade
```

## Paketquellen aktualisieren

### Versionen

| Versionsnummer | Versionsname | Replace |
|---|---|---|
| 9 | Stretch | :%s/stretch/buster/ |
| 10 | buster | :%s/buster/bullseye/ |
| 11 | bullseye | :%s/bullseye/bookworm/ |
| 12 | bookworm | :%s/bookworm/trixie/ |

### Default sources.list

```bash
cat <<EOF > /etc/apt/sources.list
deb http://deb.debian.org/debian trixie main contrib non-free non-free-firmware
deb http://deb.debian.org/debian trixie-updates main contrib non-free non-free-firmware
deb http://deb.debian.org/debian-security/ trixie-security main contrib non-free non-free-firmware
EOF
```

### Alle Sources ändern

```bash
sed -i 's:bookworm:trixie:' /etc/apt/sources.list
sed -i 's:bookworm:trixie:' /etc/apt/sources.list.d/*.list
```

### Apt Preferences prüfen

/etc/apt/preferences.d/*

/etc/apt/preferences

## Upgrade durchführen

```bash
apt update

# Möglicher Zwischenschritt
# apt upgrade --without-new-pkgs

apt upgrade


# Möglicher Zwischenschritt
# apt full-upgrade

apt dist-upgrade
```

## Netzwerkinterface prüfen

```bash
udevadm test-builtin net_setup_link /sys/class/net/enp1s0
```

## Neues sources Format realisieren

```bash
apt modernize-sources

apt update

rm /etc/apt/sources.list.bak /etc/apt/sources.list.d/*.bak
```

## Falls Cryptsetup genutzt wird

```bash
apt install systemd-cryptsetup
systemctl daemon-reload
update-initramfs -k all -u
```

## Nach dem Update

```bash
systemctl reboot
systemctl -a --failed
journalctl -b -p notice
```
### Übersprungene neue Konfigurationen prüfen

```bash
find /etc -name "*.dpkg-dist"
```

### Pakete aufräumen

```bash
apt autoremove
```

Per apt oder aptitude Pakete aufräumen
