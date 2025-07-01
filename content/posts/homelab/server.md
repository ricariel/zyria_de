---
title: "Server"
description: "Beschreibung der Serverlandschaft"
tags:
  - homelab
  - hardware
  - maschinen
---

Alle Maschinen dienen der Virtualisierung von diversen Systemen. Wir brauche die Flexibilität Systeme schnell skalieren zu können und auch durch neue zu ersetzen.

<!--more-->

## Physisch vorhandene Server

Die Installation von zusätzlichen Diensten auf den physischen Servern sollte dringend vermieden werden. So ein zusätzlicher Dienst installiert werden musste, ist eine Dokumentation dringend erforderlich.

## Virtuelle Maschinen

Virtuelle Maschinen sind so zu provisionieren, dass ein Server ausfallen kann
und alle Dienste auf den verbliebenen Servern laufen können.
Damit wir flexibel bleiben bei der Migration zu anderen Hostern und vielleicht
in die Cloud werden virtuelle Maschinen anhand der Matrix bei
[Hetzner](https://www.hetzner.com/de/cloud) dimensioniert.

Auf den virtuellen Maschinen wird primär Docker eingesetzt. In Ausnahmefällen
nutzen wir auch dedizierte virtuelle Maschinen für einzelne Dienste(Active
Directory,Windows). So kein Docker eingesetzt wird, sollte darauf geachtet
werden, dass pro Dienst eine Maschine bereitgestellt wird.
