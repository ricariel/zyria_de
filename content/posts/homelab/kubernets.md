---
title: Kubernetes Snippets
description: Sammlung von Snippets, welche immer mal wieder benötigt wurden
tags:
  - Kubernetes
  - Homelab
  - K3s
---

Hier Sammle ich Snippets, welche mir das Tippen ersparen sollen und für Kubernetes öfter mal gebraucht werden.

<!--more-->

## Lösche alle Longhorn Backups älter als 60 Tage

```bash

kubectl get backups.longhorn.io -n longhorn-system -o json | \
jq -r '.items[] | select((.metadata.creationTimestamp | fromdateiso8601) < (now - 60*60*24*60)) | .metadata.name' | \
xargs -I {} kubectl delete backups.longhorn.io/{} -n longhorn-system

```
## Lösche alle nicht Completed Longhorn Backups

```bash

kubectl get backups.longhorn.io -n longhorn-system | grep -v "Completed" | awk '{print $1}' | xargs -I {} kubectl delete backups.longhorn.io/{} -n longhorn-system

```

## Kubernetes Nutzer hinzufügen

[Quelle](https://aungzanbaw.medium.com/a-step-by-step-guide-to-creating-users-in-kubernetes-6a5a2cfd8c71)

## Lösche alte ReplicaSets

```bash

kubectl get rs --all-namespaces -o wide | awk '$3==0 && $4==0 && $5==0 {print "-n", $1, $2}' | xargs -L1 kubectl delete rs

```

## OCI Helm Chart in Forgejo importieren

```bash
helm pull oci://codeberg.org/wrenix/helm-charts/forgejo-runner --version 0.6.6
helm push *.tgz oci://git.example.com/username
helm cm-push *.tgz repo
```

## Finalizer löschen

```bash
kubectl get linstorsatellites.piraeus.io -o name | sed -e 's/.*\///g' | xargs -I {} kubectl patch linstorsatellites.piraeus.io {} -p '{"metadata": {"finalizers": null}}' --type merge
```

## Update Postgres mit Podman/Docker

```bash
podman run --rm --name pgauto -it \
  --mount type=bind,source=./,target=/var/lib/postgresql/data \
  -e POSTGRES_PASSWORD=password \
  -e PGAUTO_ONESHOT=yes \
  -e PGAUTO_REINDEX=no \
  pgautoupgrade/pgautoupgrade:16-bookworm
```

## Zeige alle Nodes mit dem Label performance

```bash
kubectl get nodes -o=jsonpath="{range .items[*]}{.metadata.name}: {.metadata.labels.performance}{'\n'}{end}"
```

## Lösche alle Events

```bash
kubectl delete events --all -A
```

## Lösche alle nicht gebundenen Images

```bash
/usr/local/bin//k3s crictl rmi --prune
```
