# Snippets

## Raid löschen

```bash
mdadm --stop /dev/md0
for i in "0" "1"; do  mdadm --zero-superblock /dev/nvme"$i"n1; done
```

## Raid erstellen

```bash
yes | mdadm --create -n 2 -l 1 /dev/md0 /dev/nvme[01]n1p1
```

## Partition mit ext4 formatieren

> mkfs.ext4 /dev/md0

oder
> yes | mkfs.ext4 -L boot /dev/md0

Swap:
> mkswap -f /dev/vg-name/swap

## Festplatten Verschlüsselung

### verschlüsseln

> cryptsetup --batch-mode -c aes-cbc-essiv:sha256 -s 256 -y luksFormat /dev/nvme0n1p4

### öffnen

> cryptsetup luksOpen /dev/md1 crypt-root

## Festplatte Partitionieren

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

set 2 bios_grub on \
set 2 boot on \
```

## LVM

### Gerät hinzufügen

```bash
pvcreate /dev/mapper/crypt-root
vgcreate vg-name /dev/mapper/crypt-root

lvcreate -n root -L 4G vg-name
lvcreate -n var-log -l100%FREE vg-name
```

### LVM vergrößern

[Link](https://www.thomas-krenn.com/de/wiki/LVM_vergrößern)

## Backup

[BorgBackup bei Hetzner](https://wiki.hetzner.de/index.php/BorgBackup)

## Git

Alle Repos mit Zugriff auf den lokalen Rechner clonen

```bash
tea login add
for i in $(tea repos ls --fields ssh -o simple -l www.casa-due-pur.de -T source); do git clone $i; done
```
