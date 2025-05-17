#!/bin/env sh

set -e

# Change to the directory where the script is located
cd "$(dirname "$0")"

DATE_TAG=$(date "+%Y%m%d-%H%M%S")
CURRENT_IMAGE_ID=$(podman images --format "{{.ID}}" cremin.dev/jonathan/ublue-silverblue-nvidia:42)


echo "Pulling base image"
# ensure the base image is up to date
podman pull ghcr.io/ublue-os/silverblue-nvidia:42

echo "Starting build"
podman build -t cremin.dev/jonathan/ublue-silverblue-nvidia:42 .

NEW_IMAGE_ID=$(podman images --format "{{.ID}}" cremin.dev/jonathan/ublue-silverblue-nvidia:42)


# Start build and check if any layers were changed (looking for "Using cache" messages)
if [ "$CURRENT_IMAGE_ID" = "$NEW_IMAGE_ID" ]; then
    echo "No changes detected, skipping push"
else
    echo "Image updated, pushing to registry"
    # Add the tags
    podman tag cremin.dev/jonathan/ublue-silverblue-nvidia:42 cremin.dev/jonathan/ublue-silverblue-nvidia:42-${DATE_TAG} cremin.dev/jonathan/ublue-silverblue-nvidia:latest
    # Push the image
    podman push --authfile ~/.config/containers/auth.json cremin.dev/jonathan/ublue-silverblue-nvidia:42-${DATE_TAG}
    podman push --authfile ~/.config/containers/auth.json cremin.dev/jonathan/ublue-silverblue-nvidia:42
    podman push --authfile ~/.config/containers/auth.json cremin.dev/jonathan/ublue-silverblue-nvidia:latest
fi