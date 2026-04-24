#!/bin/bash

# Ensure the script is being run as root/sudo
if [[ $EUID -ne 0 ]]; then
   echo "⚠️  WARNING: You are not running this script as root."
   echo "Modifying /usr/share/alsa/ requires root privileges. Please run with 'sudo'."
   exit 1
fi

echo "Starting ALSA UCM2 configuration patching for Ubuntu..."
echo ""

# --- Helper Function ---

patch_file() {
    local step=$1
    local filepath=$2
    local old_str=$3
    local new_str=$4

    if [[ ! -f "$filepath" ]]; then
        echo "  [x] Error: File not found: $filepath"
        return
    fi

    # Check if the target string exists
    if grep -q "$old_str" "$filepath"; then
        # Use sed to replace the string in-place
        sed -i "s/$old_str/$new_str/g" "$filepath"
        echo "  [✓] Updated (Step $step): $filepath"
    elif grep -q "$new_str" "$filepath"; then
        echo "  [-] Already patched (Step $step): $filepath"
    else
        echo "  [!] String not found (Step $step): $filepath (Target: '$old_str')"
    fi
}

# --- 1. Apply Patches ---

# Step 1: Reduce Power Amplifer Volume (Range 0-31, step = 1.5 dB, 12 = +9 dB, 1 = -7.5 dB)
patch_file 1 "/usr/share/alsa/ucm2/codecs/wsa884x/four-speakers/SpeakerSeq.conf" "PA Volume' 12" "PA Volume' 6"

# Step 2: Reduce Digital Volume 1 (Range 0-124, step = 1.5 dB, 58 = -22 dB)
patch_file 2 "/usr/share/alsa/ucm2/codecs/qcom-lpass/wsa-macro/Wsa1SpeakerEnableSeq.conf" "Digital Volume' 68" "Digital Volume' 58"
patch_file 2 "/usr/share/alsa/ucm2/codecs/qcom-lpass/wsa-macro/Wsa2SpeakerEnableSeq.conf" "Digital Volume' 68" "Digital Volume' 58"

# Step 3: Reduce Digital Volume 2
patch_file 3 "/usr/share/alsa/ucm2/codecs/qcom-lpass/wsa-macro/four-speakers/init.conf" "Digital Volume' 84" "Digital Volume' 5"
patch_file 3 "/usr/share/alsa/ucm2/codecs/qcom-lpass/wsa-macro/init.conf" "Digital Volume' 84" "Digital Volume' 5"

# Step 4: Disable Compressors
patch_file 4 "/usr/share/alsa/ucm2/codecs/wsa884x/four-speakers/DefaultEnableSeq.conf" "COMP Switch' 1" "COMP Switch' 0"
patch_file 4 "/usr/share/alsa/ucm2/codecs/wsa884x/four-speakers/SpeakerSeq.conf" "COMP Switch' 1" "COMP Switch' 0"

# --- 2. Lock Package (Ubuntu Specific) ---

echo ""
echo "Locking 'alsa-ucm-conf' to prevent Ubuntu updates from overwriting these patches..."
apt-mark hold alsa-ucm-conf
echo "  [✓] Package 'alsa-ucm-conf' is now on hold."

# --- 3. Finalize ALSA ---

echo ""
echo "Patching process complete."
echo "Reloading ALSA UCM configuration..."
alsaucm reload

# --- 4. Set Initial WirePlumber Volume ---
echo ""
echo "Setting initial volume via WirePlumber..."
if [ -n "$SUDO_USER" ]; then
    # Dynamically find the current ID of the Built-in Speaker
    SPEAKER_ID=$(sudo -u "$SUDO_USER" XDG_RUNTIME_DIR=/run/user/$(id -u "$SUDO_USER") wpctl status | grep "Built-in Audio Speaker" | awk -F'.' '{print $1}' | awk '{print $NF}')

    if [ -n "$SPEAKER_ID" ]; then
        # Apply the volume to the dynamically found ID
        sudo -u "$SUDO_USER" XDG_RUNTIME_DIR=/run/user/$(id -u "$SUDO_USER") wpctl set-volume "$SPEAKER_ID" 0.07
        echo "  [✓] Volume set to 7% for Built-in Speaker (ID: $SPEAKER_ID)."
    else
        echo "  [!] Could not find the Built-in Speaker in wpctl status."
    fi
else
    echo "  [!] Could not set volume: Script was not run via sudo (cannot find user session)."
fi

echo ""
echo "Success! Your audio settings are now patched and protected."
