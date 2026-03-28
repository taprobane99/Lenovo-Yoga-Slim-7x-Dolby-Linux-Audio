# Dolby Audio for Ubuntu on the Lenovo Slim 7x
I converted the Dolby Settings from Windows into a Pipewire filter chain. This includes FIR Convolvers, 7 Band Compressors, and Limiters. I also added in the Bankstown Bass Enhancer from Asahi Linux. In my opinion audio with the normal preset now sounds nearly as good as on Windows, and matches the approach Asahi take with Macbook Audio.

I haven't added any adjustments of my own, so you are getting as close as possible to Dolby tuning with the normal preset.

If requested I can convert the "Movie" and "Voice" presets. There is no auto-conversion script as there are too many differences between EasyEffects and Pipewire, so I do it manually.

The "enhanced" preset uses a different approach to speaker tuning. I am not using it but include it in case anyone prefers it. It is dangerous as it doesn't obey the speaker volume cap. Use with extreme caution! ⚠️

Let me know if you find any bugs.

# Bugs
Volume is at 100% when loading, but this shoudn't be that high when using the normal preset.

# Setup
1. Make sure you are running Ubuntu Concept from https://launchpad.net/~ubuntu-concept/+archive/ubuntu/x1e
2. Add `snd-soc-x1e80100.i_accept_the_danger=1` to your kernel command line if necessary
3. Install the latest Alsa UCM Configuration from https://github.com/alsa-project/alsa-ucm-conf
4. `sudo apt install lsp-plugins calf-plugins bankstown-lv2`
5. Download this repository and unzip
6. Run `Slim7x-audio-patch.sh` to cap the volume on your speakers (no guarantee that this will work as only tested on my machine, so lower your volume the first time you play music after running it)
7. Run `Slim7x-dolby-install.sh`
8. Switch to Dolby Atmos - Music (Balanced) as the Output Device in Sound Settings

# Sources I used
`Windows/Windows/System32/DriverStore/FileRepository/dax3_ext_qc.inf_arm64_16835e993a9f5725/AUCD_DEV_0C29_SUBSYS_IDEA4002_ADCM_SUBSYS_IDEA4002.xml` (Dolby settings)

https://github.com/sambow23/nixstuff/tree/main/hosts/t14s (for speaker protection)

https://github.com/AsahiLinux/asahi-audio (for bankstown)

https://github.com/antoinecellerier/speaker-tuning-to-easyeffects (normal preset)

https://github.com/mister2d/thinkpad-linux-audio (enhanced preset)

# Notes
I found 4 Dolby .xml files in my Windows DriverStore. This seemed the most likely to be for the Slim 7x.

convert decibels easyeffects to linear for pipewire: linear = 10^(decibels/20)
