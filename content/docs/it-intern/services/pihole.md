---
title: Pihole
description: Beschreibung von Pihole
slug: pihole
---

## Quelle

[Docker Hub Pihole](https://hub.docker.com/r/pihole/pihole)

[Docker Hub cn2pihole](https://hub.docker.com/r/ricariel/cn2pihole)

## Repository

[Github](https://github.com/pi-hole/docker-pi-hole)

[Hersteller core-networks to pihole](https://git.zyria.de/pyrox/core-networks2pihole-docker)

## Dokumentation

[Hersteller Container](https://github.com/pi-hole/docker-pi-hole)

[Hersteller core-networks to pihole](https://git.zyria.de/pyrox/core-networks2pihole-docker)

## Funktion

Pihole stellt den DNS hinter dem Active Directory Server bereit. Die Filterlisten enthalten die meisten unerwünschten Domains ohne den Anspruch vollstädnig zu sein. Die Allowlist  wird großzügig auf Nutzeranfrage gefüllt.

Cn2pihole ist ein Werkzeug die aktuelle Zonendatei von Core-Networks für unsere Domains beim Start für Ṕihole zur  Verfügung zu stellen. Es dient als Fallback für Ausfälle vom Upstream DNS damit intern weiter gearbeitet werden kann.
