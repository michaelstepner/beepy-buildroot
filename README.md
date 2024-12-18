[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)

# Beepy: Build-Your-Own Buildroot OS

This repository provides a lightweight [Buildroot-based](#about-beepys-buildroot-os) OS image for your Beepy, and a friendly user interface to help you generate a personalized OS image.

- **Option 1:** [Download a pre-built Buildroot OS image](https://github.com/michaelstepner/beepy-buildroot/releases), flash it onto your SD card, pop it into your Beepy, then configure the settings.
    - ℹ️ Make sure you've updated your Beepy's [firmware](https://github.com/ardangelo/beepberry-rp2040/releases/) version. The latest Buildroot OS images have been tested with firmware version 3.8.
    - ⚠️ After booting into Buildroot OS, use `passwd` to change the default password and consider turning off password-based SSH authentication for extra security.

- **Option 2:** Follow the [instructions](#instructions-for-building-your-own-os-image) below to build your own Buildroot OS image with your configuration already built into the image.
    - ✨ When you download the custom image you've generated, your settings are already built-in: wifi network config, SSH authorized keys, time zone, hostname, etc.

## Instructions for building your own OS image

These instructions explain how to create a custom OS image in the cloud, without configuring a build environment on your local computer. It will take about 3.5 hours to compile an OS image in the cloud. For advice about local builds, see the [README in the docker subdirectory](./docker/README.md).

### Step 0: 🌟 Star this repo (optional)

- Starring this repository will let me know this has been useful to you!

### Step 1: 🔐 Manually copy this repo to a private repo

- You'll be building your own custom Buildroot OS image using GitHub Actions in a *private* GitHub repository, because your personal configuration might contain some private information.

- On a system with `git` and [`gh`](https://cli.github.com/) installed, run the following:

    ```
    git clone https://github.com/michaelstepner/beepy-buildroot.git my-beepy-buildroot
    cd my-beepy-buildroot
    git remote remove origin
    gh repo create my-beepy-buildroot --private --source=.
    git push --set-upstream origin main
    gh repo view my-beepy-buildroot --web
    ```

### Step 2: 📦 Build your own custom OS image

- In the GitHub web interface for your new `my-beepy-buildroot` repository, click on `Actions` then `Build image`.
- Click the grey `Run workflow ▾` button, and enter your configuration choices.
    - If you specify an SSH public key, this will be added as an authorized key for the `beepy` user and password-based SSH authentication will be disabled.
    - ⚠️ If you do not specify an SSH public key, the `beepy` user can be accessed via SSH using the password `beepbeep`. You should change the password using `passwd` and/or disable password-based SSH authentication as soon as possible for security.
- Click the green `Run workflow` button.
- After approximately 3.5 hours (measured in October 2024), your GitHub Actions run should complete and your custom image will be ready for download.

### Step 3: 🚀 Flash your custom image onto your SD card

- In the GitHub web interface for your new `my-beepy-buildroot` repository, click on `Actions` then `Build image`.
    - After the build has completed successfully, click on the run with the green checkmark.
- At the bottom of the Summary page, in the Artifacts panel, download `sdcard.img`.
    - ℹ️ **Recommended:** delete the `sdcard.img` file from the GitHub Artifacts on the summary page once you've downloaded it, so that it ceases to be counted against your limited [Storage for Actions and Packages](https://github.com/settings/billing/summary#usage).
- Use the [Raspberry Pi Imager tool](https://www.raspberrypi.com/software/) to flash the image to your SD card. (Or an alternative tool if you prefer.)
    - Raspberry Pi Device: `Raspberry Pi Zero 2 W`
    - Operating System: scroll all the way to the bottom and select `Use custom`, then select the `sdcard.img.zip` file you just downloaded.
    - Storage: select your SD card.
    - Click `Next`.
    - When prompted "Would you like to apply OS customization settings?" choose `No`. Your customizations are already built into your customized image, and the Raspberry Pi Imager tool isn't able to customize the Buildroot-based OS.
- 🎁 Insert the SD card you just flashed into your Beepy and enjoy your freshly configured Buildroot-based OS!
    - The initial boot will take about 30 seconds to resize disk partitions to fill your SD card. Subsequent boots take around 8 seconds from power-on to tmux.

## System Requirements

- Beepy v1 hardware with a Raspberry Pi Zero 2 W and the original Sharp black & white screen.
- Beepy [firmware version](https://github.com/ardangelo/beepberry-rp2040/releases/) 3.4 or higher installed.
    - You should ideally use the latest firmware version, and report issues if you encounter problems.

## About Beepy's Buildroot OS

[Compared to a full-blown Raspbian-based operating system](https://beepy.sqfmi.com/docs/getting-started#3-choose-an-operating-system), a [Buildroot](https://buildroot.org/)-based system is slimmed down, boots fast, and is pre-configured with Beepy device drivers and a set of useful software. Buildroot OS does not have a built-in package manager (like `apt`) that facilitates updates. Instead, packages are compiled at the time the Buildroot OS image is created, and updates are made by building a new SD card with an updated version of Buildroot OS.

Tailored for on-the-go communication, it ships with the following applications:

- `gomuks` - Beeper command line client
- `mosh` - Mobile remote shell
- `w3m` - Text based browser
- `aerc` - Command line email client
- `nmtui` - Network management
- Python 3 with `pip`

For keybindings and modifier key behaviors, see an [overview with visual keymaps](https://beepy.sqfmi.com/docs/firmware/keyboard) or the more detailed [`beepy-kbd` documentation](https://github.com/ardangelo/beepberry-keyboard-driver/blob/main/README.md).

## Acknowledgements

This repository is based on the work of [Andrew D'Angelo](http://andrew.uni.cx/) published at [ardangelo/beepberry-buildroot](https://github.com/ardangelo/beepberry-buildroot). The hard work of configuring the Buildroot-based OS for the first time was done by Andrew and the contributors in that repository.
