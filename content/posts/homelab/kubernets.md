---
title: Kubernetes Snippets
description: Sammlung von Snippets, welche immer mal wieder benötigt wurden
tags:
  - Kubernetes
  - Homelab
  - K3s
---

## Finalizer löschen

´´´bash
kubectl get linstorsatellites.piraeus.io -o name | sed -e 's/.*\///g' | xargs -I {} kubectl patch linstorsatellites.piraeus.io {} -p '{"metadata": {"finalizers": null}}' --type merge
´´´

## Update Postgres mit Podman/Docker

´´´bash
podman run --rm --name pgauto -it \
  --mount type=bind,source=./,target=/var/lib/postgresql/data \
  -e POSTGRES_PASSWORD=password \
  -e PGAUTO_ONESHOT=yes \
  -e PGAUTO_REINDEX=no \
  pgautoupgrade/pgautoupgrade:16-bookworm
´´´

## Zeige alle Nodes mit dem Label performance

´´´bash
kubectl get nodes -o=jsonpath="{range .items[*]}{.metadata.name}: {.metadata.labels.performance}{'\n'}{end}"
´´´

## Lösche alle Events

´´´bash
kubectl delete events --all -A
´´´
