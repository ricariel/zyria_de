---
title: Zammad
description: "Beschreibung von Pihole"
---

## Quelle

## Repository

[Zammad](https://github.com/zammad)

[Helm](https://github.com/zammad/zammad-helm)

## Dokumentation

[Admin Dokumentation](https://admin-docs.zammad.org/de/latest/index.html)

[Zentrale Dokumentation](https://docs.zammad.org/en/latest/index.html)

[Console Settings](https://docs.zammad.org/en/latest/admin/console/hidden-settings.html)

## Funktion

## Anpassungen

Anpassungen, welche auf der rake console durchgeführt werden müssen.

```bash
Setting.set('system_bcc', 'service+Sent@casa-due-pur.de')

Setting.set('ui_ticket_create_notes', {
      :"phone-in"=>"Du erstellst einen eingehenden Anruf.",
      :"phone-out"=>"Du erstellst einen ausgehenden Anruf.",
      :"email-out"=>"Du wirst eine E-Mail senden."
  })

Setting.set('ui_ticket_add_article_hint', {
      :"note-internal"=>"Du erstellst eine INTERNE Notiz. Nur andere Mitarbeiter werden diese sehen können.",
      :"note-public"=>"Du erstellst eine öffentlich Notiz. Der Kunde kann diese unter Umständen sehen.",
      :"phone-internal" => "Du erstellst eine INTERNE Telefonnotiz. Nur andere Mitarbeiter werden diese sehen können.",
      :"phone-public"=>"Du erstellst eine öffentliche Telefonnotiz. Der Kunde kann diese unter Umständen sehen.",
      :"email-internal" => "Du erstellst eine externe Mail. Der Kunde kann diese sehen.",
      :"email-public"=>"Du erstellst eine externe Email. Der Kunde kann diese sehen."
  })

Setting.set('ui_user_organization_selector_with_email', true)


Setting.set('ui_sidebar_open_ticket_indicator_colored', true)
```
