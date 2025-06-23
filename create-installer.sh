#!/bin/env sh

set -e

cd "$(dirname "$0")"

sudo podman run \
    --rm \
    -it \
    --privileged \
    --pull=newer \
    --security-opt label=type:unconfined_t \
    -v ./config.toml:/config.toml:ro \
    -v ./output:/output \
    -v /var/lib/containers/storage:/var/lib/containers/storage \
    quay.io/centos-bootc/bootc-image-builder:latest \
    --type iso \
    --rootfs btrfs \
	--use-librepo=True \
    --chown 1000:1000 \
    cremin.dev/jonathan/ublue-silverblue-main:42
