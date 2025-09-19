---
title: Linksammlung rund um Strom
date: 2024-03-08T12:52:37+02:00
---

Linksammlung zum Thema Strom in meinem Heim.

<!--more-->

{{< links file="solar" >}}

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

### Solarflow Mqtt Zugangsdaten

```python
# Mqtt Username = device_id
# Password=

#!/usr/bin/python
import hashlib
device_id = "<DEVICEID>"
md5_hash = hashlib.md5(device_id.encode()).hexdigest().upper()[8:24]
print(md5_hash)

```
