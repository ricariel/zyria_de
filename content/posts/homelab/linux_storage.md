---
title: 'Linux Storage'
description: 'Snippets für Linux-Storage-Verwaltung: RAID, LVM, Festplattenverschlüsselung und Partitionierung mit parted.'
summary: "RAID, LVM, LUKS-Verschlüsselung und Partitionierung unter Linux."
tags:
  - linux
  - storage
  - lvm
  - raid
  - homelab
  - snippets
---

Sammlung von Snippets rund um Storage-Verwaltung unter Linux.

<!--more-->

## RAID

### RAID löschen

```bash
mdadm --stop /dev/md0
for i in "0" "1"; do  mdadm --zero-superblock /dev/nvme"$i"n1; done
```

### RAID erstellen

```bash
yes | mdadm --create -n 2 -l 1 /dev/md0 /dev/nvme[01]n1p1
```

## Dateisystem

### Partition mit ext4 formatieren

```bash
mkfs.ext4 /dev/md0
```

oder mit Label:

```bash
yes | mkfs.ext4 -L boot /dev/md0
```

### Swap erstellen

```bash
mkswap -f /dev/vg-name/swap
```

## Festplattenverschlüsselung (LUKS)

### Verschlüsseln

```bash
cryptsetup --batch-mode -c aes-cbc-essiv:sha256 -s 256 -y luksFormat /dev/nvme0n1p4
```

### Öffnen

```bash
cryptsetup luksOpen /dev/md1 crypt-root
```

## Partitionierung mit parted

```bash
for i in "0" "1"; do
parted -a optimal /dev/nvme"$i"n1 --script \
unit s \
mklabel gpt \
mkpart esp 2048 128MB \
mkpart grub 128MB 2048MB \
mkpart raid 2048MB 50GB \
mkpart linux 50GB 100% \
set 1 esp on \
set 2 raid on \
set 3 raid on;
done
```

## LVM

### Gerät hinzufügen und Volumes erstellen

```bash
pvcreate /dev/mapper/crypt-root
vgcreate vg-name /dev/mapper/crypt-root

lvcreate -n root -L 4G vg-name
lvcreate -n var-log -l100%FREE vg-name
```
