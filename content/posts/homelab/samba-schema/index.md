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
