---
title: 'Ist ein Server erreichbar?'
description: 'Ping Server'
date: 2023-10-19T13:28:04+02:00
---

## Wie teste ich, ob ein Server prinzipiell erreichbar ist?

Der Befehl ping ist auf allen Rechnern installert. Unter Windows muss dafür das
Programm cmd.exe gestartet werden. Dies findest du mit der Sucher oder unter
C:\Windows\System32\cmd.exe

So sieht ein Ping via IPv6 aus:

```cmd
C:\>ping example.com -6

Ping wird ausgeführt für example.com [2a01:4f8:151:317c::2] mit 32 Bytes Daten:
Antwort von 2a01:4f8:151:317c::2: Zeit=23ms
Antwort von 2a01:4f8:151:317c::2: Zeit=17ms
Antwort von 2a01:4f8:151:317c::2: Zeit=19ms
Antwort von 2a01:4f8:151:317c::2: Zeit=16ms

Ping-Statistik für 2a01:4f8:151:317c::2:
    Pakete: Gesendet = 4, Empfangen = 4, Verloren = 0
    (0% Verlust),
Ca. Zeitangaben in Millisek.:
    Minimum = 16ms, Maximum = 23ms, Mittelwert = 18ms
```

Und nochmal via IPv4

```cmd
C:\>ping example.com -4

Ping wird ausgeführt für example.com [159.69.238.82] mit 32 Bytes Daten:
Antwort von 159.69.238.82: Bytes=32 Zeit=19ms TTL=62
Antwort von 159.69.238.82: Bytes=32 Zeit=17ms TTL=62
Antwort von 159.69.238.82: Bytes=32 Zeit=18ms TTL=62
Antwort von 159.69.238.82: Bytes=32 Zeit=17ms TTL=62

Ping-Statistik für 159.69.238.82:
    Pakete: Gesendet = 4, Empfangen = 4, Verloren = 0
    (0% Verlust),
Ca. Zeitangaben in Millisek.:
    Minimum = 17ms, Maximum = 19ms, Mittelwert = 17ms
```

{{% alert title="Achtung" color="warning" %}} Wenn in der Statistik hinter
**Verloren** etwas anderes als 0 steht, ist das ein Problem.

```cmd
Pakete: Gesendet = 4, Empfangen = 1, Verloren = 3
```

{{% /alert %}}
