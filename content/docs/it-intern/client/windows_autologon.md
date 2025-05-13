---
title: 'Windows autologon'
---

## AutoLogon

Erstelle eine .reg Datei mit folgendem Inhalt und führe sie auf dem Zielrechner
aus.

```registry
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon]
"AutoAdminLogon"="1"
"DefaultUserName"="BENUTZERNAME"
"DefaultDomainName"="DOMÄNE"
"DefaultPassword"='*****'
```
