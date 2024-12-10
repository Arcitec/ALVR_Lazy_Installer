#!/usr/bin/env bash

# Copyright (C) 2024 Arcitec
# SPDX-License-Identifier: GPL-2.0-only

set -e

# Use the latest launcher version.

ALVR_DOWNLOAD_URL="https://github.com/alvr-org/ALVR/releases/latest/download/alvr_launcher_linux.tar.gz"
ALVR_ICON_URL="https://raw.githubusercontent.com/alvr-org/ALVR/5152b06294d964eb4fbd012dcfad7fe1e076b578/resources/ALVR-Icon.svg"

# The launcher uses "base" dir for installing ALVR versions. We'll install the
# launcher itself into a custom subdirectory of that location, for neatness.

ALVR_BASE_DIR="${HOME}/.local/share/ALVR-Launcher"
ALVR_LAUNCHER_DIR="${ALVR_BASE_DIR}/launcher-bin"
ALVR_LAUNCHER_BIN="${ALVR_LAUNCHER_DIR}/ALVR Launcher"
ALVR_LAUNCHER_ICON="${ALVR_LAUNCHER_DIR}/alvr-icon.svg"
ALVR_DESKTOP_FILE="${HOME}/.local/share/applications/alvr-launcher.desktop"

# Grab the archive.

DOWNLOAD_TMP_DIR="$(mktemp -d)"
DOWNLOAD_FILE="${DOWNLOAD_TMP_DIR}/alvr_launcher_linux.tar.gz"

echo "Downloading to \"${DOWNLOAD_FILE}\"..."
curl -L -o "${DOWNLOAD_FILE}" "${ALVR_DOWNLOAD_URL}"

# Extract to the installation location and fetch the SVG icon.

echo "Extracting ALVR Launcher..."

rm -rfv "${ALVR_LAUNCHER_DIR}"
mkdir -pv "${ALVR_LAUNCHER_DIR}"

curl -L -o "${ALVR_LAUNCHER_ICON}" "${ALVR_ICON_URL}"

tar -xzvf "${DOWNLOAD_FILE}" --strip-components=1 -C "${ALVR_LAUNCHER_DIR}"

rm -fv "${DOWNLOAD_FILE}"
rmdir -v "${DOWNLOAD_TMP_DIR}"

# Create the desktop environment's launcher shortcut.

echo "Creating launcher shortcut at \"${ALVR_DESKTOP_FILE}\"..."
echo -e "[Desktop Entry]\nType=Application\nName=ALVR Launcher\nComment=Stream VR games from your PC to your headset\nExec=\"${ALVR_LAUNCHER_BIN// /\\s}\"\nIcon=${ALVR_LAUNCHER_ICON}\nCategories=Utility;" | tee "${ALVR_DESKTOP_FILE}"

echo "All done!"
