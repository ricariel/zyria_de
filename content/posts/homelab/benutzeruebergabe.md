---
title: "Standardprozess: Benutzer-Onboarding und Übergabe"
description: Dieser Prozess beschreibt die standardisierten Schritte für die Erstellung, Konfiguration und sichere Übergabe von Benutzerkonten an neue oder bestehende Mitarbeiter.
---

## Prozess: Benutzer-Onboarding und Übergabe

Dieses Dokument definiert den standardisierten Ablauf zur Bereitstellung von Benutzerkonten. Die Einhaltung dieser Schritte gewährleistet Sicherheit, Nachvollziehbarkeit und einen reibungslosen Start für den Benutzer.

### 1. Phase: Vorbereitung und Kontoerstellung

Diese Schritte werden von der IT-Abteilung nach Eingang einer autorisierten Anforderung (z.B. durch die Personalabteilung oder eine Führungskraft) durchgeführt.

#### 1.1. Namenskonventionen
* **Benutzername (Schema):** `vorname.nachname`
* **E-Mail-Adresse (Schema):** `vorname.nachname@userdomain`
    * *Beispiel:* `hans.mustermann@example.com`

#### 1.2. Kontoanlage im Active Directory (AD)
1.  **Vorlage verwenden:** Um konsistente Berechtigungen sicherzustellen, wird das Konto eines bestehenden Benutzers mit vergleichbarer Rolle oder Abteilung als Vorlage kopiert.
2.  **Benutzerdaten eintragen:** Alle relevanten Felder (Vollständiger Name, Beschreibung, Abteilung etc.) sorgfältig ausfüllen.
3.  **Initialpasswort setzen:** Ein sicheres, zufällig generiertes und langes temporäres Passwort vergeben. Dieses Passwort wird nur für die Ersteinrichtung verwendet.
4.  **E-Mail-Adresse zuweisen:** Die E-Mail-Adresse gemäß der oben genannten Namenskonvention im Benutzerkonto eintragen.
5.  **Postfach initialisieren:** Eine Willkommens-E-Mail an die neue Adresse senden. Dies stößt die Erstellung des Postfachs auf dem Mail-Server (z.B. Microsoft Exchange) an.
6.  **Konto-Status:** Falls das Konto nicht sofort benötigt wird, sollte es aus Sicherheitsgründen initial **deaktiviert** werden.

#### 1.3. Kommunikation
* Nach erfolgreicher Erstellung des Kontos wird eine Bestätigung an den Anfordernden (z.B. die Führungskraft) gesendet.

---

### 2. Phase: Sichere Übergabe an den Benutzer

Diese Phase findet direkt mit dem Benutzer statt und erfordert dessen persönliche Anwesenheit oder eine anderweitig sichere Identitätsprüfung.

#### 2.1. Vorbereitende Maßnahmen am Tag der Übergabe
1.  **Identitätsprüfung:** Die Identität des Benutzers ist zweifelsfrei sicherzustellen (z.B. durch persönlichen Abgleich mit einem Ausweisdokument oder durch Bestätigung einer vertrauenswürdigen Person wie dem direkten Vorgesetzten).
2.  **Konto aktivieren:** Falls das Konto deaktiviert war, muss es jetzt aktiviert werden.
3.  **Willkommenspasswort setzen:** Das Passwort des Benutzers auf ein standardisiertes, einmalig gültiges Willkommenspasswort zurücksetzen.
4.  **Passwortänderung erzwingen:** Die Option **"Benutzer muss Kennwort bei der nächsten Anmeldung ändern"** im AD muss zwingend aktiviert sein. Dies ist ein kritischer Sicherheitsschritt.

#### 2.2. Interaktive Übergabe mit dem Benutzer
1.  **Erstanmeldung:** Der Benutzer gibt seinen Benutzernamen (`vorname.nachname`) am System ein.
2.  **Passworteingabe:** Der IT-Mitarbeiter gibt das zuvor festgelegte Willkommenspasswort ein.
3.  **Neues Passwort festlegen:** Das System fordert den Benutzer nun auf, sein eigenes, geheimes Passwort festzulegen. Der Benutzer muss dabei auf die Einhaltung der Passwortrichtlinien hingewiesen werden:
    * Mindestens 12 Zeichen Länge
    * Verwendung von Sonderzeichen (z.B. `!`, `?`, `#`, `$`)
    * Kombination aus Groß- und Kleinbuchstaben
    * Verwendung von Ziffern
4.  **Bestätigung:** Der erfolgreiche Anmeldevorgang mit dem neuen Passwort wird gemeinsam überprüft.

#### 2.3. Einweisung und Schulung
1.  **Grundlagen der Systemnutzung:** Eine kurze Einweisung in die wichtigsten Funktionen geben:
    * An- und Abmeldung (Login/Logoff)
    * Sperren des Bildschirms (`Win + L`)
    * Ändern des eigenen Passworts (`Strg + Alt + Entf`)
    * Kontaktwege zum IT-Helpdesk (Telefon, E-Mail, Ticketsystem)
2.  **Sicherheit und Best Practices:** Den Benutzer für wichtige Sicherheitsthemen sensibilisieren:
    * Erkennen von Phishing- und Spam-E-Mails
    * Umgang mit vertraulichen Daten
    * Wichtigkeit von Geheimhaltung des Passworts
3.  **Offene Fragen:** Dem Benutzer die Möglichkeit geben, Fragen zu stellen und diese verständlich beantworten.

---

### 3. Phase: Nachbereitung und Abschluss

1.  **Übergabeprotokoll:** Es wird empfohlen, ein kurzes Übergabeprotokoll zu erstellen, auf dem der Benutzer den Erhalt der Zugangsdaten und die erfolgte Einweisung per Unterschrift bestätigt.
2.  **Abschluss der Anforderung:** Der Anfordernde wird über die erfolgreiche Übergabe informiert und das zugehörige IT-Ticket wird geschlossen.
