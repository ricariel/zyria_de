---
title: 'Unifi Snippets'
description: 'Sammlung von Codesnippets'
summary: "All der Kram, der sonst nirgends hin gehört"
---

## Snippets

### Latest Firmware URL

[ubnt.com](https://fw-update.ubnt.com/api/firmware?filter=eq~~channel~~release&filter=eq~~product~~uvc&filter=eq~~platform~~s2l&sort=-version)

```bash
 curl "https://fw-update.ubnt.com/api/firmware?filter=eq~~channel~~release&filter=eq~~product~~uvc&filter=eq~~platform~~s2l&sort=-version" | jq -r '._embedded.firmware[] | [.version, ._links.data.href] | @tsv'
 ```

### Upgrade via SSH

- SCP the firmware binary to the /tmp folder of the camera or
```bash
curl firmware_url -k --output /tmp/fwupdate.bin
```
- SSH in to the camera
- cd to /tmp
- mv binary to fwupdate.bin
- fwupdate -m

### Kamera in Standalone Mode versetzen

```bash
ubnt_ipc_cli -T=ubnt_nvr -r=1 -m='{"functionName":"ChangeNvrSettings","standaloneEnabled":1}'
```

### Kamera in Home Assistant hinzufügen

Nutze Generic Camera

| Feld | Wert / Tipp |
|---|---|
|Still Image URL | http://192.168.1.xx/snap.jpg |
|Stream Source	| rtsp://192.168.1.xx:554/s0 |
|RTSP Transport	| Wähle TCP (statt Auto oder UDP) |
|Authentication	| Starte mit Basic |
|Verify SSL	| Deaktivieren (da die Kamera meist ein selbstsigniertes Zertifikat hat) |
