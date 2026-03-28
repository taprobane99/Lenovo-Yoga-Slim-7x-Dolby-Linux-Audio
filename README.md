# Dolby Audio for Ubuntu on Lenovo Slim 7x
## Implemented natively in Pipewire
I converted the Dolby Settings from Windows into a Pipewire filter chain. This includes the original factory-tuned Stereo FIR Convolver, 7 Band Compressor, and Limiter. I also added in a custom Bankstown Bass tuning. In my opinion audio with the normal preset now sounds as good as on Windows, and matches the filter pipeline Asahi Linux use for Mac Audio.

This project also upmixes the sound to use all 4 speakers on the Slim 7x (only the front tweeters are active by default).

If requested I can convert the "Voice" preset. There is no auto-conversion script as there are too many differences between EasyEffects and Pipewire, so I do it manually.

The alternative preset uses a different approach to speaker tuning - replacing the multiband compressor with an Exciter and Autogain. You need to manually install it, replacing the normal preset.

Let me know if you find any bugs.

# Bugs
Volume is at 100% when loading, but this shouldn't sound too loud because of the volume cap.

The capture volumes block may cause temporary audio artifacts when using volume sliders rather than fixed interval volume keys.

Presets seem to conflict so only have one installed at a time (e.g. Music or Movie).

# Setup
1. Make sure you are running Ubuntu Concept from https://launchpad.net/~ubuntu-concept/+archive/ubuntu/x1e
2. Add `snd-soc-x1e80100.i_accept_the_danger=1` to your kernel command line if necessary
3. Install the latest Alsa UCM Configuration from https://github.com/alsa-project/alsa-ucm-conf
4. `sudo apt install lsp-plugins calf-plugins bankstown-lv2`
5. Download this repository and unzip
6. Run `Slim7x-audio-patch.sh` to upmix to all 4 speakers, and cap the volume on your speakers (no guarantee that this will work as only tested on my machine, so lower your volume the first time you play music after running it)
7. Run `Slim7x-dolby-install.sh`
8. Switch to Dolby Atmos - Music (Balanced) as the Output Device in Sound Settings
9. Use `dolby-switch.sh` to change between Music and Movie presets

# FAQ
1. Why not use EasyEffects? As far as I know EasyEffects can't upmix sound to 4 speakers
2. Is this as good as Asahi Audio for Macbooks? Hopefully. I use the same pipewire filter chain they do.
3. Which Bankstown settings did you use? Custom tuning based on slightly tweaking Macbook Air M1 13 inch 2020 profile, and adding high pass filter

# Sources I used
`Windows/Windows/System32/DriverStore/FileRepository/dax3_ext_qc.inf_arm64_16835e993a9f5725/AUCD_DEV_0C29_SUBSYS_IDEA4002_ADCM_SUBSYS_IDEA4002.xml` (Dolby settings)

https://github.com/sambow23/nixstuff/tree/main/hosts/t14s (for speaker protection)

https://github.com/AsahiLinux/asahi-audio (for bankstown)

https://github.com/antoinecellerier/speaker-tuning-to-easyeffects (for converting Dolby to Easyeffects)

https://github.com/mister2d/thinkpad-linux-audio (alternative preset)

https://www.notebookcheck.net/Lenovo-Yoga-Slim-7x-14-G9-review-Multimedia-laptop-with-Snapdragon-X-Elite-and-great-3K-OLED-display.875964.0.html (speaker measurements)

# Notes
I found 4 Dolby .xml files in my Windows DriverStore. This seemed the most likely to be for the Slim 7x.

Convert decibels easyeffects to linear for pipewire: linear = 10^(decibels/20)
