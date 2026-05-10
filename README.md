# Dolby Audio for Ubuntu on Lenovo Slim 7x
## Implemented as a native DSP in Pipewire
I converted some Dolby EQ settings from Windows into a Pipewire filter chain. This is the original factory speaker tuning approximated as an Impulse Response using RePhase. I then added in a custom Bankstown Bass tuning, 2 stage Compressor, and Linkwitz-Riley Crossover. The audio is also Loudness corrected to sound good at low volumes too (just like Asahi Audio for Macs). For the Movie profile, simple stereo widening and a voice filter is added. All gain values are adjusted to avoid clipping using Carla.

This laptop has two full range speakers either side of the keyboard deck ("Rear"), and two woofers under the front ("Front").

Providing you have run `slim7x-audio-patch.sh` the Power Amplifier is set to 0 dB so 100% master volume should be a safe upper limit. It is useful to install `Pavucontrol` to set volumes. I have "Built-in Audio Speaker" set at 100%, and my Dolby Atmos at 90% most of the time.

I added folders with source files and screenshots if you want to do the whole process yourself in RePhase and Carla. Dolby also have more digital audio filters such as "Detailed", "Balanced", "Warm". I added the "Balanced" filters by zero-centering and then 10% blending with the speaker tuning (as Dolby seem to do).

Let me know if you find any bugs.

# Setup
1. `sudo apt install libpipewire-0.3-modules lsp-plugins bankstown-lv2`
2. Download this repository and unzip
3. Run `slim7x-audio-patch.sh`
4. Run `slim7x-dolby-install.sh`
5. Switch to Dolby Atmos - Music or Movie as the Output Device in Sound Settings

# Setup for a different computer
This method can be modified for any laptop that has been Dolby tuned. Ignore step 3 if you don't have an X Elite series laptop. You may have a different tweeter/woofer arrangement. If your computer has only 2 speakers there is an example .conf to adapt.

# Audio balance is wrong (too bassy, too much treble, etc.)
You could try adjusting the balance live in Mini EQ (https://flathub.org/en/apps/io.github.bhack.mini-eq). Then use this to adjust the multiband compressor makeup gains in the pipewire .conf files (e.g. 1.12589 (1dB), 1.25893 (2dB), 1.41254 (3dB), 1.58489 (4dB), 1.77828 (5dB), 1.99526 (6dB)). Or create new impulse responses using the 'Detailed' or 'Warm' filters.

# FAQ
1. Why not use EasyEffects? As far as I know EasyEffects can't upmix sound to 4 speakers.
2. Is this as good as Asahi Audio for Macbooks? I use the same pipewire filter chain they do, but not the Voltage/Current sensing so technically no, but it does sound good.
3. Which Bankstown settings did you use? Custom tuning based on slightly tweaking Macbook Air M1 13 inch 2020 profile.
4. Did you use AI? No! Aside from some minor help with file formatting, this is all my own work.

# Sources I used
`Windows/Windows/System32/DriverStore/FileRepository/dax3_ext_qc.inf_arm64_16835e993a9f5725/AUCD_DEV_0C29_SUBSYS_IDEA4002_ADCM_SUBSYS_IDEA4002.xml` (Dolby settings)

https://github.com/sambow23/nixstuff/tree/main/hosts/t14s (for speaker protection)

https://github.com/AsahiLinux/asahi-audio (for bankstown)

https://www.rephase.org/ (for creating the impulse response)

https://flathub.org/en/apps/org.audacityteam.Audacity (optional, for trimming the impulse response using stereogram view)

https://flathub.org/en/apps/studio.kx.carla (for adjusting gains)

https://x42-plugins.com/x42/x42-zconvolver (Convolver plugin for Carla)

https://www.notebookcheck.net/Lenovo-Yoga-Slim-7x-14-G9-review-Multimedia-laptop-with-Snapdragon-X-Elite-and-great-3K-OLED-display.875964.0.html (speaker measurements)

# Notes
I found 4 Dolby .xml files in my Windows DriverStore. This seemed the most likely to be for the Slim 7x.

Decibel values seem to be stored as x10 the real values to avoid decimal points in the xml.

Convert decibels to linear for pipewire: linear = 10^(decibels/20).
