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

# Step 1: Reduce Power Amplifer Volume (Range 0-31, step = 1.5 dB, 12 = +9 dB, 2 = -6 dB, 1 = -7.5 dB)
patch_file 1 "/usr/share/alsa/ucm2/codecs/wsa884x/four-speakers/SpeakerSeq.conf" "PA Volume' 12" "PA Volume' 2"

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

# --- 3. Finalize ---

echo ""
echo "Patching process complete."
echo "Reloading ALSA UCM configuration..."
alsaucm reload

echo "Success! Your audio settings are now patched and protected."
