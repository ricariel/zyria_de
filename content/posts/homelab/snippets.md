---
title: 'Snippets'
description: 'Sammlung von Codesnippets'
summary: "All der Kram, der sonst nirgends hin gehört"
---

## Snippets

### SSH nur mit Passwort

```bash
ssh -o PubkeyAuthentication=no -o PreferredAuthentications=password
```

### Download Spam

```bash
wget -q -N -P /var/lib/spamassassin/training/downloads/ http://untroubled.org/spam/$$(date +%%Y-%%m.7z -d 'last month')
wget -q -N -P /var/lib/spamassassin/training/downloads/ http://untroubled.org/spam/$$(date +%%Y-%%m.7z)
```

### Mastodon Wartung

```bash
bundle exec rake db:migrate
tootctl statuses remove --days=7
tootctl preview_cards remove --days=7
tootctl media  remove --days=14
tootctl media remove-orphans
tootctl cache clear
tootctl accounts cull
```

### Podman Kubernetes Manifest starten mit systemd

```bash
systemctl enable --now podman-kube@$(systemd-escape $(pwd)/).service
```

### Container bauen mit Podman[^1]

```bash
export IMAGE_VERSION=$(git tag --sort=-version:refname | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' | sort -V | tail -n 1)

podman manifest create keel:${IMAGE_VERSION}

podman build --platform linux/amd64,linux/arm64 --manifest localhost/keel:${IMAGE_VERSION} -f Dockerfile

podman manifest push localhost/keel:${IMAGE_VERSION} docker://git.zyria.de/pyrox/keel:${IMAGE_VERSION}

podman manifest push localhost/keel:${IMAGE_VERSION} docker://docker.io/ricariel/keel:${IMAGE_VERSION}
```

[^1]: [https://blog.while-true-do.io/podman-multi-arch-images/](https://blog.while-true-do.io/podman-multi-arch-images/)

### Ram cache leeren

```bash
sync; echo 1 > /proc/sys/vm/drop_caches
```

### Leeren branch in git erstellen

```bash
git switch --orphan pages
git commit --allow-empty -m "Initial commit on orphan branch"
git push -u origin pages
```

### Zone aus Samba extrahieren

{{< readfile file="extract_zone.sh" code="true" lang="bash" >}}

### Schlüssel aus Windows extrahieren

{{< readfile file="getkey.vbs" code="true" lang="vbscript" >}}

### Festplatten in Proxmox bewegen

Dieses Script migriert alle Festplatten einer VM auf einen anderen Storage

{{< readfile file="move_all_disks.sh" code="true" lang="bash" >}}

### Reset aller lokalem Sicherheitsrichtlinien

```cmd
secedit /configure /cfg %windir%\inf\defltbase.inf /db defltbase.sdb /verbose
```

### Einspielen neuer lokaler Sicherheitsrichtlinien

```cmd
secedit /configure /db %windir%\security\new.sdb /cfg C:\Temp\Unternehmenssicherheit_W11.inf /overwrite /log C:\Temp\security_log.txt
```

### Reset aller Policies unter Windows

{{< readfile file="resetPolicies.bat" code="true" lang="cmd" >}}

### Reset der User Folder Redirection Policy unter Windows

{{< readfile file="userFolderRedirectionReset.reg" code="true" lang="registry" >}}

### Raid löschen

```bash
mdadm --stop /dev/md0
for i in "0" "1"; do  mdadm --zero-superblock /dev/nvme"$i"n1; done
```

### Raid erstellen

```bash
yes | mdadm --create -n 2 -l 1 /dev/md0 /dev/nvme[01]n1p1
```

### Partition mit ext4 formatieren

> mkfs.ext4 /dev/md0

oder
> yes | mkfs.ext4 -L boot /dev/md0

Swap:
> mkswap -f /dev/vg-name/swap

### Festplatten Verschlüsselung

#### verschlüsseln

> cryptsetup --batch-mode -c aes-cbc-essiv:sha256 -s 256 -y luksFormat /dev/nvme0n1p4

#### öffnen

> cryptsetup luksOpen /dev/md1 crypt-root

### Festplatte Partitionieren

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

### LVM

#### Gerät hinzufügen

```bash
pvcreate /dev/mapper/crypt-root
vgcreate vg-name /dev/mapper/crypt-root

lvcreate -n root -L 4G vg-name
lvcreate -n var-log -l100%FREE vg-name
```

#### LVM vergrößern

[Link](https://www.thomas-krenn.com/de/wiki/LVM_vergrößern)

### Backup

[BorgBackup bei Hetzner](https://wiki.hetzner.de/index.php/BorgBackup)

### Git

Alle Repos mit Zugriff auf den lokalen Rechner clonen

```bash
tea login add
for i in $(tea repos ls --fields ssh -o simple -l git.zyria.de -T source); do git clone $i; done
```
