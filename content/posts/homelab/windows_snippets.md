---
title: 'Windows Snippets'
description: 'Sammlung von Codesnippets'
summary: "All der Kram, der sonst nirgends hin gehört"
---

## Snippets

### Remotedesktop aktivieren und in der Firewall freischalten

```powershell
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fDenyTSConnections" -value 0
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
```

### Chocolatey vcredist dependency hell lösen

```powershell

choco install chocolatey-core.extension chocolatey-dotnetfx.extension -y --source="'https://community.chocolatey.org/api/v2/'" --force --ignore-dependencies

choco install vcredist140 vcredist-all -y --source="'https://community.chocolatey.org/api/v2/'"

choco upgrade all
```
