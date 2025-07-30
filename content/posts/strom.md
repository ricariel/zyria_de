---
title: Linksammlung rund um Strom
date: 2024-03-08T12:52:37+02:00
---

Linksammlung zum Thema Strom in meinem Heim.

<!--more-->

## Hichi IR und Home Assistant

[Stromzähler mit einem ESP8266 / ESP32 mit Tasmota auslesen und darstellen](https://ottelo.jimdofree.com/stromzähler-auslesen-tasmota/)

## Solarflow Hoymiles Homeassistant

[Git Repo mit nützlichen Infos](https://github.com/z-master42/solarflow/tree/main)

## Solarflow

Steuerung des Solarflow
[Solarflow Control](https://github.com/reinhard-brandstaedter/solarflow-control)

Von Cloud trennen und an den loaklen MQTT binden
[Solarflow Bluetooth Manager](https://github.com/reinhard-brandstaedter/solarflow-bt-manager)

Eine Statusseite
[Solarflow Statuspage and Control](https://github.com/reinhard-brandstaedter/solarflow-statuspage)

Telegram Austauschgruppe
[Private Zendure Austauschgruppe](https://t.me/+nEPrpHst6xFmZTky)

[Zendure SolarFlow - Speicher für BKW - Sammelthread](https://www.photovoltaikforum.com/thread/198769-zendure-solarflow-speicher-für-bkw-sammelthread/)

### Steckerlayout Solarflow Batteriesystem

Stecker-Pinout (Draufsicht auf Hub/Akku, nicht auf den  Kabelstecker):

<!--- editorconfig-checker-disable --->
```text
    _._._._._._
   /     _     \
  /     /G\     \
 /  _   \_/   _  \
|  / \       / \  |
| | + |     | - | |
|  \_/       \_/  |
|       (1)       |
 \(2)         (5)/
  \   (3) (4)   /
   \_._._._._._/

```
<!--- editorconfig-checker-enable --->

- +: Main positive power connection
- -: Main negative power connection (also used by battery as communication ground)
- G: Ground provided by hub, not connected in battery
- 1: +5V supply from battery to hub (possibly used during startup on battery power, unconnected on battery bottom port)
- 2: CAN_L
- 3: CAN_H
- 4: Hub button press detection (active low, pulled up by both hub and battery, chained between Öl batteries)
- 5: Hub presence detection (active low, pulled up by battery, grounded in hub, unconnected on battery bottom port)
