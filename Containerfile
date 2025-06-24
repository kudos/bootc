ARG SOURCE_IMAGE="${SOURCE_IMAGE:-ghcr.io/ublue-os/silverblue-main}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-42}"

FROM ${SOURCE_IMAGE}:${FEDORA_MAJOR_VERSION}

ARG NVIDIA_BUILD="${NVIDIA_BUILD:-"false"}"

COPY etc /etc

COPY scripts scripts

RUN ./scripts/install-common.sh

# My nvidia workstation needs this for its watercooling.
RUN if [[ "$NVIDIA_BUILD" == "true" ]]; then ./scripts/install-coolercontrol.sh; fi

RUN authselect enable-feature with-fingerprint

LABEL org.opencontainers.image.description="Built on ${SOURCE_IMAGE}:${FEDORA_MAJOR_VERSION}, adding more batteries" \
  org.opencontainers.image.source="https://cremin.dev/jonathan/bootc" \
  org.opencontainers.image.title="silverblue" \
  org.opencontainers.image.url="https://cremin.dev/jonathan/bootc" \
  org.opencontainers.image.created="" \
  org.opencontainers.image.licenses="Unlicensed" \
  org.opencontainers.image.revision="" \
  org.opencontainers.image.version=""
