---
title: 'Windows Snippets'
description: 'Nützliche PowerShell- und CMD-Snippets für Windows-Administration: RDP, Chocolatey, Gruppenrichtlinien und mehr.'
summary: "PowerShell- und CMD-Snippets für Windows-Administration."
tags:
  - windows
  - powershell
  - homelab
  - snippets
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

### Windows – Schlüssel extrahieren

{{< readfile file="getkey.vbs" code="true" lang="vbscript" >}}

### Windows – Reset aller lokalen Sicherheitsrichtlinien

```cmd
secedit /configure /cfg %windir%\inf\defltbase.inf /db defltbase.sdb /verbose
```

### Windows – Einspielen neuer lokaler Sicherheitsrichtlinien

```cmd
secedit /configure /db %windir%\security\new.sdb /cfg C:\Temp\Unternehmenssicherheit_W11.inf /overwrite /log C:\Temp\security_log.txt
```

### Windows – Reset aller Policies

{{< readfile file="resetPolicies.bat" code="true" lang="cmd" >}}

### Windows – Reset der User Folder Redirection Policy

{{< readfile file="userFolderRedirectionReset.reg" code="true" lang="registry" >}}


