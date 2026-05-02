# Dolby Audio for Ubuntu on Lenovo Slim 7x
## Implemented as a native DSP in Pipewire
I converted some Dolby EQ settings from Windows into a Pipewire filter chain. This is the original factory-tuned speaker response approximated as an Impulse Response using Room Eq Wizard. I then added in a custom Bankstown Bass tuning, 2 stage Compressor, and LR4 Crossover. The audio is also loudness corrected to sound good at low volumes too (just like Asahi Audio for Macs!). For the Movie profile simple stereo widening and a voice filter is added. All gain values are adjusted to avoid clipping using Carla.

This laptop has two full range speakers either side of the keyboard deck ("Rear"), and two woofers under the front ("Front").

Providing you have run `slim7x-audio-patch.sh` the Power Amplifier is set to 0 dB so 100% master volume should be a safe upper limit. It is useful to install `Pavucontrol` to set volumes. I have "Built-in Audio Speaker" set at 100%, and my Dolby Atmos at 90% most of the time.

I added folders with source files and screenshots if you want to do the whole process yourself in Room Eq Wizard and Carla. Dolby also have more digital audio filters such as "Detailed", "Balanced", "Warm". I added the "Balanced" filters by zero-centering and then 10% blending with the speaker response (as Dolby seem to do).

Let me know if you find any bugs.

# Bugs
Presets seem to conflict so you can only have one in the menu at a time (e.g. Music or Movie).

# Setup
1. Make sure you are running Ubuntu Concept from https://launchpad.net/~ubuntu-concept/+archive/ubuntu/x1e
2. Add `snd-soc-x1e80100.i_accept_the_danger=1` to your kernel command line if necessary
3. Install the latest Alsa UCM Configuration from https://github.com/alsa-project/alsa-ucm-conf
4. `sudo apt install lsp-plugins calf-plugins bankstown-lv2`
5. Download this repository and unzip
6. Run `slim7x-audio-patch.sh`
7. Run `slim7x-dolby-install.sh`
8. Switch to Dolby Atmos - Music as the Output Device in Sound Settings
9. Use `dolby-switch.sh` to change between Music and Movie presets

# Setup for a different computer
This method should work for any computer that has been Dolby tuned. Ignore steps 1-3 and 6. If your computer has only 2 speakers there is an example .conf to adapt.

# FAQ
1. Why not use EasyEffects? As far as I know EasyEffects can't upmix sound to 4 speakers.
2. Is this as good as Asahi Audio for Macbooks? I use the same pipewire filter chain they do, but not the Voltage/Current sensing so technically no, but it does sound good.
3. Which Bankstown settings did you use? Custom tuning based on slightly tweaking Macbook Air M1 13 inch 2020 profile.
4. Did you use AI? No! Aside from some minor help with file formatting, this is all my own work.

# Sources I used
`Windows/Windows/System32/DriverStore/FileRepository/dax3_ext_qc.inf_arm64_16835e993a9f5725/AUCD_DEV_0C29_SUBSYS_IDEA4002_ADCM_SUBSYS_IDEA4002.xml` (Dolby settings)

https://github.com/sambow23/nixstuff/tree/main/hosts/t14s (for speaker protection)

https://github.com/AsahiLinux/asahi-audio (for bankstown)

https://www.roomeqwizard.com/ (for creating the impulse response)

https://flathub.org/en/apps/org.audacityteam.Audacity (optional, for trimming the impulse response using stereogram view)

https://flathub.org/en/apps/studio.kx.carla (for adjusting gains)

https://x42-plugins.com/x42/x42-zconvolver (Convolver plugin for Carla)

https://www.notebookcheck.net/Lenovo-Yoga-Slim-7x-14-G9-review-Multimedia-laptop-with-Snapdragon-X-Elite-and-great-3K-OLED-display.875964.0.html (speaker measurements)

# Notes
I found 4 Dolby .xml files in my Windows DriverStore. This seemed the most likely to be for the Slim 7x.

Decibel values seem to be stored as x10 the real values to avoid decimal points in the xml.

Convert decibels to linear for pipewire: linear = 10^(decibels/20).
