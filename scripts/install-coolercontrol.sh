#!/bin/env sh

set -e

# Setup watercooling
dnf copr enable -y codifryed/CoolerControl
dnf install -y coolercontrol
systemctl enable coolercontrold
dnf clean all
