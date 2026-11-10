---
title: Samba Schema
description: "Das Samba Schema wurde durch folgende Entitäten erweitert"
summary: "Active Directory Schema Erweiterungen"
tags:
  - homelab
  - software
  - samba
  - active directory
---

## ms-MCS-AdmPwd und ms-MCS-AdmPwdExpirationTime

{{< readfile file="laps-1.ldif" code="true" lang="LDAP" >}}

## modify computer

{{< readfile file="laps-2.ldif" code="true" lang="LDAP" >}}

## ldapPublicKey

{{< readfile file="Sshpubkey.ldif" code="true" lang="LDAP" >}}

## modify user

{{< readfile file="Sshpubkey-2.ldif" code="true" lang="LDAP" >}}

## mailQuota

Grenze für das Postfach eines Kontos, etwa `5G`. Dovecot liest sie über den Global Catalog; ohne Wert ist das Postfach unbegrenzt. OID und Syntax entsprechen dem Attribut aus dem Schema von qmail-ldap.

{{< readfile file="mailquota-1.ldif" code="true" lang="LDAP" >}}

## modify organizationalPerson

{{< readfile file="mailquota-2.ldif" code="true" lang="LDAP" >}}
