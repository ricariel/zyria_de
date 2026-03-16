---
title: "Solarflow mit Home Assistant"
description: "Zendure Solarflow-Akku vom Cloud-Zwang befreien und lokal per MQTT in Home Assistant integrieren."
summary: "Den Solarflow-Akku per Bluetooth-Manager vom Cloud-Zwang befreien und lokal per MQTT mit Home Assistant verbinden."
date: 2024-04-01T00:00:00+02:00
draft: false
tags:
  - solar
  - solarflow
  - home-assistant
  - mqtt
  - energie
---

Der Zendure Solarflow Hub kommuniziert standardmäßig über die Zendure-Cloud. Mit dem
[Solarflow Bluetooth Manager](https://github.com/reinhard-brandstaedter/solarflow-bt-manager)
lässt sich das Gerät vom Cloud-Zwang befreien und direkt an einen lokalen MQTT-Broker binden.

<!--more-->

## Voraussetzungen

- Home Assistant (z. B. auf einem Raspberry Pi oder als VM)
- MQTT-Broker (z. B. Mosquitto Add-on in Home Assistant)
- Bluetooth-fähiges Gerät in Reichweite des Solarflow Hub
- [Solarflow Bluetooth Manager](https://github.com/reinhard-brandstaedter/solarflow-bt-manager)

## Solarflow vom Cloud-Zwang befreien

Der Solarflow Bluetooth Manager verbindet sich per Bluetooth mit dem Hub und leitet die Daten
an einen lokalen MQTT-Broker weiter, anstatt sie an die Zendure-Cloud zu schicken.

```bash
docker run -d \
  --name solarflow-bt-manager \
  --restart unless-stopped \
  --privileged \
  --network host \
  reinhardbrandstaedter/solarflow-bt-manager:latest
```

Die Konfiguration erfolgt über Umgebungsvariablen:

```bash
MQTT_HOST=<IP deines MQTT-Brokers>
MQTT_PORT=1883
```

## Home Assistant Integration

Ist der MQTT-Broker eingerichtet, erscheinen die Solarflow-Entitäten automatisch in Home Assistant
über MQTT Discovery – sofern die Discovery im MQTT-Broker und in Home Assistant aktiviert ist.

Alternativ steht das Git-Repo
[z-master42/solarflow](https://github.com/z-master42/solarflow/tree/main)
mit fertigen Home-Assistant-Konfigurationen und Automationsbeispielen zur Verfügung.

## Steuerung mit Solarflow Control

Wer die Einspeiseleistung dynamisch regeln möchte (z. B. abhängig vom aktuellen Verbrauch),
kann [Solarflow Control](https://github.com/reinhard-brandstaedter/solarflow-control) nutzen.
Es liest die aktuellen Verbrauchs- und Erzeugungsdaten per MQTT und passt die Ausgangsleistung
des Solarflow Hub automatisch an.

## Stromzähler auslesen mit Tasmota

Um den Hausverbrauch in Home Assistant zu messen, bietet sich ein
[Hichi IR-Lesekopf](https://ottelo.jimdofree.com/stromzähler-auslesen-tasmota/)
mit einem ESP8266/ESP32 und Tasmota an. Der Lesekopf wird an den IR-Port des Stromzählers
gehalten und sendet die Werte per MQTT direkt an Home Assistant.

## Links

{{< links file="solar" >}}
