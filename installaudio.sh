#!/bin/bash
set -e

echo "Cloning and installing AudioReach topology"
#if the directory already exists, remove it first
if [ -d "audioreach-topology" ]; then
    echo "Directory audioreach-topology already exists. Removing it first."
    rm -rf audioreach-topology
fi
git clone https://github.com/linux-msm/audioreach-topology
cd audioreach-topology
export FW_LOCATION=/lib/firmware
cmake .
make
sudo make install


cd ..

# UCM config.
#
# The device ids for this machine were fixed in alsa-ucm-conf v1.2.16
# (commit 9577cd31, "ucm2: Qualcomm: fix device ids for surface pro 12in").
# Anything older -- including Ubuntu 26.04, which ships 1.2.15.3 -- carries
# the pre-fix config, which routes playback through MultiMedia2 on hw:1 and
# capture through MultiMedia4 on hw:3. The topology installed above only
# creates MultiMedia1 playback (hw:0) and MultiMedia2 capture (hw:1), so on
# those releases the speakers and mic are simply silent, with no error.
#
# Detect that case and drop the fixed config in, keeping the packaged one
# diverted so an apt upgrade can't quietly put the broken version back.
UCM_DIR=/usr/share/alsa/ucm2/Qualcomm/x1e80100
UCM_CONF="$UCM_DIR/Surface12in-HiFi.conf"
UCM_TAG=v1.2.16.1

if [ ! -f "$UCM_CONF" ]; then
    echo "WARNING: $UCM_CONF not found -- is alsa-ucm-conf installed?"
elif ! grep -q "Audio Mixer MultiMedia2\|MultiMedia4 Mixer" "$UCM_CONF"; then
    echo "UCM config already has the fixed device ids, nothing to do."
else
    echo "UCM config predates the device-id fix (alsa-ucm-conf < 1.2.16); replacing it."

    tmp=$(mktemp)
    curl -fsSL -o "$tmp" \
        "https://raw.githubusercontent.com/alsa-project/alsa-ucm-conf/$UCM_TAG/ucm2/Qualcomm/x1e80100/Surface12in-HiFi.conf"

    # Divert the packaged file so dpkg keeps its hands off ours on upgrade.
    if command -v dpkg-divert >/dev/null && \
       ! dpkg-divert --list "$UCM_CONF" | grep -q .; then
        sudo dpkg-divert --local --rename --divert "$UCM_CONF.stock" --add "$UCM_CONF"
    fi

    sudo cp "$tmp" "$UCM_CONF"
    rm -f "$tmp"
    echo "Installed the $UCM_TAG UCM config; reboot or restart pipewire/pulseaudio to pick it up."
fi
