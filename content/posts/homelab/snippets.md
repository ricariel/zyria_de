---
title: 'Snippets'
description: 'Sammlung von Codesnippets für Linux, Git, Mastodon, Samba und Proxmox – alles was sonst nirgends hinpasst.'
summary: "All der Kram, der sonst nirgends hin gehört"
tags:
  - homelab
  - linux
  - bash
  - snippets
---

## Snippets

{{< links file="it" >}}

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

### Git – Alle Repos clonen

```bash
tea login add
for i in $(tea repos ls --fields ssh -o simple -l git.zyria.de -T source); do git clone $i; done
```

### Zone aus Samba extrahieren

{{< readfile file="extract_zone.sh" code="true" lang="bash" >}}

### Festplatten in Proxmox bewegen

Dieses Script migriert alle Festplatten einer VM auf einen anderen Storage

{{< readfile file="move_all_disks.sh" code="true" lang="bash" >}}

### Windows – Schlüssel extrahieren

{{< readfile file="getkey.vbs" code="true" lang="vbscript" >}}

### Windows – Reset aller lokalen Sicherheitsrichtlinien

```cmd
secedit /configure /cfg %windir%\inf\defltbase.inf /db defltbase.sdb /verbose
```

### Windows – Einspielen neuer lokaler Sicherheitsrichtlinien

```cmd
secedit /configure /db %windir%\security\new.sdb /cfg C:\Temp\Unternehmenssicherheit_W11.inf /overwrite /log C:\Temp\security_log.txt
```

### Windows – Reset aller Policies

{{< readfile file="resetPolicies.bat" code="true" lang="cmd" >}}

### Windows – Reset der User Folder Redirection Policy

{{< readfile file="userFolderRedirectionReset.reg" code="true" lang="registry" >}}

---

Siehe auch:
- [Linux Storage]({{< ref "linux_storage.md" >}}) – RAID, LVM, Verschlüsselung, Partitionierung
- [Podman]({{< ref "podman.md" >}}) – Container bauen und mit systemd starten
