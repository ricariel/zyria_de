---
title: 'Podman Snippets'
description: 'Snippets für Podman: Multi-Arch-Images bauen, Kubernetes-Manifeste mit systemd starten und Images in Registries pushen.'
summary: "Podman-Befehle für Multi-Arch-Container, Kubernetes-Manifeste und Registry-Push."
tags:
  - podman
  - container
  - kubernetes
  - homelab
  - snippets
---

Nützliche Podman-Befehle für den täglichen Betrieb.

<!--more-->

## Kubernetes Manifest mit systemd starten

```bash
systemctl enable --now podman-kube@$(systemd-escape $(pwd)/).service
```

## Multi-Arch-Image bauen und pushen[^1]

```bash
export IMAGE_VERSION=$(git tag --sort=-version:refname | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' | sort -V | tail -n 1)

podman manifest create keel:${IMAGE_VERSION}

podman build --platform linux/amd64,linux/arm64 --manifest localhost/keel:${IMAGE_VERSION} -f Dockerfile

podman manifest push localhost/keel:${IMAGE_VERSION} docker://git.zyria.de/pyrox/keel:${IMAGE_VERSION}

podman manifest push localhost/keel:${IMAGE_VERSION} docker://docker.io/ricariel/keel:${IMAGE_VERSION}
```

[^1]: [https://blog.while-true-do.io/podman-multi-arch-images/](https://blog.while-true-do.io/podman-multi-arch-images/)
