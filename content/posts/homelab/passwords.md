---
title: Passwörter
slug: passworter
description: Wie werden Passwörter bei uns verwaltet
summary: "Umgang mit Passwörtern"
tags:
  - homelab
  - service
---

## Was wir nicht tun

* Passwörter werden nicht im Browser oder in Dokumenten z.B. Text,Word,Excel gesichert.
* Passwörter werden niemals durch Mitarbeiter verschickt. Nicht per Email, Telefon, SMS etc. Eine Ausnahme bildet die IT, welche im Ausnahmefall nicht persönlich vor Ort sein kann und selbstständig dafür sorgt, dass die Übertragung sicher ist. Für die Übertragung sind unten beschriebene Datenbanken gedacht. Hat ein Mitarbeiter keinen Zugriff auf eine Datenbank und benötigt ein Kennwort, bitte die IT kontaktieren.

## Wie wir mit Kennworten umehen

* Wir benutzen einen dezentralen Passwortmanager (unter Windows Keepassxc), welcher auf allen Rechnern installiert ist. Dieser ermöglicht das sichere Speichern von sensiblen Daten und ist universell im ganzen Unternehmen einsetzbar.
* Passwörter werden auch für den Transport von A nach B immer in einer Datenbank gesichert. Das Kennwort für diese Datenbank kann bei persönlichen Datenbanken selbst vergeben werden. Bei gemeinsam genutzen Datenbanken ist die IT Ansprechpartner für die Verwaltung der Kennwörter.
* Der Ablageort für gemeinsam genutze Kennwörter ist
  > Y:\Zugangsdaten
* Datenbanken werden mit wachsender größe Langsam. Das Aufteilen in mehrere Datenbanken sollte in Betracht gezogen werden, wenn es organisatorisch sinnvoll ist.
* Sich selbst Kennwörter ausdenken ist oft nicht ausreichend. Wir benutzen daher zufällig erzeugte Kennwörter aus Keepassxc. Die Kennwörter sind nicht dazu gedacht, dass sie von Hand irgendwo eingetragen werden müssen und dürfen somit sehr komplex sein.
* Keepassxc zeigt an, wenn ein Kennwort schwach ist oder sogar bereits öffentlich bekannt ist. Entsprechendes Kennwort muss umgehend geändert werden so möglich.
