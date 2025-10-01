#!/bin/env sh

set -e

SOURCE_IMAGE=ghcr.io/ublue-os/silverblue-main
FEDORA_MAJOR_VERSION=42
IMAGE=cremin.dev/jonathan/ublue-silverblue-main
NVIDIA_BUILD=false
PUSH=true

while getopts "n:p:" opt
do
    case $opt in
        n) NVIDIA_BUILD=$OPTARG ;;
        p) PUSH=$OPTARG ;;
    esac
done

if [[ $NVIDIA_BUILD == true ]]; then
    echo "Building NVIDIA image"
    SOURCE_IMAGE=ghcr.io/ublue-os/silverblue-nvidia
    FEDORA_MAJOR_VERSION="42"
    IMAGE=cremin.dev/jonathan/ublue-silverblue-nvidia
else
    echo "Building standard image"
fi

DATE_TAG=$(date "+%Y%m%d-%H%M%S")
CURRENT_IMAGE_ID=$(podman images --format "{{.ID}}" $IMAGE:$FEDORA_MAJOR_VERSION)

# ensure the base image is up to date
echo "Pulling base image"
podman pull $SOURCE_IMAGE:$FEDORA_MAJOR_VERSION

echo "Starting build"
podman build --build-arg NVIDIA_BUILD=$NVIDIA_BUILD --build-arg FEDORA_MAJOR_VERSION=$FEDORA_MAJOR_VERSION --build-arg SOURCE_IMAGE=$SOURCE_IMAGE -t $IMAGE:$FEDORA_MAJOR_VERSION .

NEW_IMAGE_ID=$(podman images --format "{{.ID}}" $IMAGE:$FEDORA_MAJOR_VERSION)

# Start build and check if any layers were changed (looking for "Using cache" messages)
if [ "$CURRENT_IMAGE_ID" = "$NEW_IMAGE_ID" ]; then
    echo "No changes detected, skipping push"
elif [ "$PUSH" = false ]; then
    echo "Skipping push"
else
    echo "Image updated, pushing to registry"
    # Add the tags
    podman tag $IMAGE:$FEDORA_MAJOR_VERSION $IMAGE:${FEDORA_MAJOR_VERSION}-${DATE_TAG} $IMAGE:latest
    # Push the image
    podman push --authfile ~/.config/containers/auth.json $IMAGE:${FEDORA_MAJOR_VERSION}-${DATE_TAG}
    podman push --authfile ~/.config/containers/auth.json $IMAGE:$FEDORA_MAJOR_VERSION
    podman push --authfile ~/.config/containers/auth.json $IMAGE:latest
fi
