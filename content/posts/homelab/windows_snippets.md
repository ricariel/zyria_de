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
