---
title: 'Snippets'
description: 'Sammlung von Codesnippets für Linux, Git, Mastodon, Samba und Proxmox - alles was sonst nirgends hinpasst.'
summary: "All der Kram, der sonst nirgends hin gehört"
tags:
  - homelab
  - linux
  - bash
  - snippets
---

## Snippets

{{< links file="it" >}}

### Git: was wird beim push übertragen

Welche Commits sind enthalten

```bash
git log @{u}..HEAD --oneline
```

Was ist der Inahl† aller Commits (diff)

```bash
git diff @{u}..HEAD
```

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

### Git - Alle Repos clonen

```bash
tea login add
for i in $(tea repos ls --fields ssh -o simple -l git.example.com -T source); do git clone $i; done
```

### Zone aus Samba extrahieren

{{< readfile file="extract_zone.sh" code="true" lang="bash" >}}

### Festplatten in Proxmox bewegen

Dieses Script migriert alle Festplatten einer VM auf einen anderen Storage

{{< readfile file="move_all_disks.sh" code="true" lang="bash" >}}

---

## Proxmox: NoVNC Konsolen-Fehler zwischen Nodes
Wenn sich die VNC-Konsole von VMs auf anderen Nodes im Cluster nicht öffnen lässt (Connection Timeout).

* **Zertifikate & SSH-Keys im Cluster neu synchronisieren (Oft die Lösung):**
  `pvecm updatecerts --force`
* **SSH-Verbindung manuell testen (um Key zu akzeptieren):**
  `ssh root@<andere-node-ip>`
* **Veralteten/Falschen SSH-Key eines Nodes löschen:**
  `ssh-keygen -f "/root/.ssh/known_hosts" -R "<andere-node-ip>"`
* **Hosts-Datei auf Fehler prüfen:**
  `cat /etc/hosts`

---

Siehe auch:

- [Linux Storage]({{< ref "linux_storage.md" >}}) - RAID, LVM, Verschlüsselung, Partitionierung
- [Podman]({{< ref "podman.md" >}}) - Container bauen und mit systemd starten
