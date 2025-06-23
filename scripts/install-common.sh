#!/bin/env sh

set -e

dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
dnf remove -y \
    ptyxis \
    gnome-software \
    htop \
    gnome-classic-session \
    gnome-shell-extension-apps-menu \
    gnome-shell-extension-background-logo \
    gnome-shell-extension-launch-new-instance \
    gnome-shell-extension-places-menu \
    gnome-shell-extension-window-list \
    open-vm-tools \
    open-vm-tools-desktop \
    qemu-guest-agent \
    spice-vdagent \
    spice-webdavd \
    virtualbox-guest-additions

dnf swap -y ffmpeg-free ffmpeg --allowerasing
dnf swap -y libavcodec-free libavcodec-freeworld --allowerasing
dnf remove -y pipewire-libs-extra
# rpmfusion doesn't always have their media packages in sync with Fedora
dnf5 config-manager setopt rpmfusion-nonfree-updates-testing.enabled=1 rpmfusion-free-updates-testing.enabled=1
dnf group install -y multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin --allowerasing
dnf5 config-manager setopt rpmfusion-nonfree-updates-testing.enabled=0 rpmfusion-free-updates-testing.enabled=0
dnf copr enable -y alternateved/eza
dnf copr enable -y pgdev/ghostty
dnf config-manager addrepo --from-repofile=https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
dnf install -y \
    acpi \
    akmod-v4l2loopback \
    btop \
    direnv \
    dmidecode \
    eza \
    ffmpegthumbnailer \
    ghostty \
    git \
    gnome-boxes \
    gstreamer1-vaapi \
    helm \
    iperf3 \
    kubectl \
    lm_sensors \
    lshw \
    nmcli \
    mpv \
    ncdu \
    pavucontrol \
    podman-compose \
    sysstat \
    tailscale \
    terraform \
    vdpauinfo \
    vulkan-tools \
    zsh \
    zsh-syntax-highlighting

dnf clean all

# Remove btop and nvtop shortcuts
rm /usr/share/applications/btop.desktop /usr/share/applications/nvtop.desktop
