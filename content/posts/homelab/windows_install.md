---
title: 'Windows Installation'
tags:
  - windows
  - homelab
---

## Anleitung: Neuen Windows-Rechner in Active Directory (AD) aufnehmen

Diese Anleitung beschreibt den Prozess, wie man einen fabrikneuen Windows-Rechner (im "Out-of-Box Experience"-Modus, OOBE) einrichtet, die erzwungene Anmeldung mit einem Microsoft-Konto umgeht und den Rechner anschließend in eine lokale Active Directory-Domäne aufnimmt.

### Voraussetzungen

* **Physischer Zugriff** auf den neuen Rechner.
* Ein **Netzwerkkabel (LAN)** mit Verbindung zum lokalen Netzwerk, in dem sich der Domänencontroller (DC) befindet.
* Der **vollqualifizierte Domänenname (FQDN)** der Domäne (z. B. `meinefirma.local`).
* Ein **Active Directory-Benutzerkonto** mit der Berechtigung, Computer zur Domäne hinzuzufügen (z. B. ein Domänen-Admin-Konto).
* Die **IP-Adresse des Domänencontrollers**, da dieser auch als DNS-Server fungieren muss.

### Bios prüfen

* Prüfe alle Bioseinstellungen
* Gehe alle Einstellungen durch und passe so notwendig an.
* Dokumentiere іm Inventar alle Änderungen.

---

### Teil 1: Windows-Ersteinrichtung (OOBE) ohne Microsoft-Konto

Das Ziel ist, die Ersteinrichtung mit einem **lokalen Administratorkonto** abzuschließen. Moderne Windows-Versionen (besonders Home/Pro) versuchen, die Erstellung eines Microsoft-Kontos zu erzwingen, wenn eine Internetverbindung besteht.

#### Methode A: Der "OOBE\BYPASSNRO"-Befehl (Empfohlen für Win 11)

Dies ist die zuverlässigste Methode, um die Option "Ich habe kein Internet" zu erzwingen.

1. Man startet den neuen Rechner. Man führt die ersten Schritte aus (Sprache, Region, Tastaturlayout).
2. Man erreicht den Bildschirm "Stellen wir eine Verbindung mit einem Netzwerk her". **Man schließt den PC noch NICHT an das LAN-Kabel an.**
3. Man drückt die Tastenkombination `Shift` + `F10`. Ein schwarzes Eingabeaufforderungsfenster (CMD) öffnet sich.
4. Man gibt folgenden Befehl ein und drückt `Enter`:

    ```bash
    OOBE\BYPASSNRO
    ```

5. Der Computer wird sofort neu gestartet und durchläuft die OOBE erneut.
6. Man wählt wieder Region und Tastatur.
7. Wenn man zum Netzwerkbildschirm kommt, sieht man nun (trotz der Aufforderung, sich zu verbinden) eine neue Option: **"Ich habe kein Internet"**. Man wählt diese aus.
8. Auf dem nächsten Bildschirm wählt man **"Mit eingeschränkter Einrichtung fortfahren"**.
9. Man wird nun aufgefordert, einen **lokalen Benutzer** zu erstellen. Man gibt einen Benutzernamen ein (z. B. `LokalerAdmin` oder `Support`).
10. Man vergibt ein sicheres lokales Passwort. (Man kann die Sicherheitsfragen bei Bedarf mit beliebigen Werten füllen).
11. Man schließt die restlichen OOBE-Schritte ab (Datenschutzeinstellungen etc.), bis man den Desktop sieht.

#### Methode B: Die "Dummy-E-Mail"-Methode (Alternativ)

Wenn Methode A fehlschlägt oder man bereits mit dem Internet verbunden ist:

1. Man führt die OOBE bis zum Anmeldebildschirm "Mit Microsoft anmelden" durch.
2. Man gibt eine **nicht existierende E-Mail-Adresse** ein, z. B.: `no@thankyou.com` oder `a@a.com`.
3. Man klickt auf "Weiter".
4. Man gibt ein beliebiges Passwort ein (z. B. `123`) und klickt auf "Anmelden".
5. Windows zeigt eine Fehlermeldung an wie "Ein Fehler ist aufgetreten" oder "Dieses Konto wurde gesperrt".
6. Man klickt auf "Weiter".
7. Windows sollte nun aufgeben und einem die Erstellung eines **lokalen Kontos** anbieten.
8. Man erstellt das lokale Administratorkonto wie in Methode A beschrieben.

---

### Teil 2: Vorbereitung des Rechners für den Domänenbeitritt

Nachdem man sich mit dem in Teil 1 erstellten lokalen Administratorkonto am Desktop angemeldet hat:

1. **Netzwerk verbinden:** Man schließt jetzt das LAN-Kabel an.
2. **DNS-Server prüfen (Kritisch!):** Der Rechner *muss* den Domänencontroller als DNS-Server verwenden, sonst kann er die Domäne nicht finden.
   * Man drückt `Win` + `R`, gibt `ncpa.cpl` ein und drückt `Enter`.
   * Man klickt mit der rechten Maustaste auf die "Ethernet"-Verbindung -> "Eigenschaften".
   * Man wählt "Internetprotokoll, Version 4 (TCP/IPv4)" und klickt auf "Eigenschaften".
   * **WICHTIG:** Wenn der Netzwerk-DHCP den korrekten DNS (den DC) nicht automatisch zuweist, muss man ihn hier manuell eintragen:
       * Man wählt "Folgende DNS-Serveradressen verwenden".
       * Man gibt bei "Bevorzugter DNS-Server" die **IP-Adresse des Domänencontrollers** ein.
   * Man klickt auf "OK", um die Fenster zu schließen.

3. **(Optional, aber empfohlen) Computername ändern:**
   * Standardmäßig haben Rechner kryptische Namen (z. B. `DESKTOP-L8A4D3J`). Es ist Best Practice, vor dem Domänenbeitritt einen aussagekräftigen Namen zu vergeben (z. B. `WKS-IT-01`).
   * Man drückt `Win` + `R`, gibt `sysdm.cpl` ein und drückt `Enter`.
   * Man klickt im Tab "Computername" auf die Schaltfläche "Ändern...".
   * Man gibt den neuen **Computernamen** ein.
   * Man klickt auf "OK". Man wird zu einem Neustart aufgefordert. **Man startet den PC neu.**

---

### Teil 3: Der Domäne beitreten (Domain Join)

Man meldet sich nach dem Neustart (falls man den Namen geändert hat) wieder mit dem lokalen Admin-Konto an.

1. Man öffnet erneut die Systemeigenschaften: Man drückt `Win` + `R`, gibt `sysdm.cpl` ein und drückt `Enter`.
2. Man klickt im Tab "Computername" auf die Schaltfläche "Ändern...".
3. Man wählt unter "Mitglied von" die Option **"Domäne"** aus.
4. Man gibt den **vollqualifizierten Domänennamen (FQDN)** der Domäne ein (z. B. `meinefirma.local`).
5. Man klickt auf "OK".
6. Es erscheint ein Anmeldefenster. Man gibt hier die **Anmeldedaten eines AD-Benutzers** ein, der die Berechtigung hat, Computer hinzuzufügen (z. B. `MEINEFIRMA\Administrator` oder ein delegiertes Konto).
7. Man klickt auf "OK".
8. Wenn die Verbindung erfolgreich war, erscheint die Meldung: **"Willkommen in der Domäne [meinefirma.local]"**.
9. Man bestätigt alle folgenden Dialoge. Man wird aufgefordert, den Computer neu zu starten. Man führt den **Neustart** durch.

---

### Teil 4: Überprüfung und Anmeldung

Nach dem Neustart befindet sich der Rechner in der Domäne.

1. Auf dem Anmeldebildschirm sieht man nun die Option, sich anzumelden (eventuell muss man auf "Anderer Benutzer" klicken).
2. Man meldet sich jetzt nicht mehr mit dem lokalen Konto an, sondern mit einem **Domänen-Benutzerkonto**.
   * Benutzername: `BENUTZERNAME@meinefirma.local` (UPN)
   * *Oder* im Format: `MEINEFIRMA\Benutzername` (SamAccountName)
   * Passwort: Das AD-Passwort des Benutzers.
3. Der Rechner erstellt ein neues Benutzerprofil für diesen Domänenbenutzer.
4. **Überprüfung (Optional):** Um sicherzugehen, öffnet man nach der Anmeldung erneut `sysdm.cpl`. Unter "Computername" sollte nun der "Vollständige Computername" als `[computername].[meinefirma.local]` angezeigt werden.
