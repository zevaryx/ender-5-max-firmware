# Ender 5 Max Firmware Repository

Repository of firmware and root tools for the Ender 5 Max.

Once Creality releases a web page for the Ender 5 Max firmware, the script will be updated to pull automatically from that.

Root tools based on the Crealtiy firmware scripts made by [@pellcorp](https://github.com/pellcorp) for the K1 series: <https://github.com/pellcorp/creality/tree/main/firmware>

## Pre-rooted firmware

### I WILL NOT BE HELD RESPONSIBLE IF YOU BRICK YOUR PRINTER - CREATING AND INSTALLING CUSTOM FIRMWARE IS RISKY

Default password is `creality_2025` in the pre-rooted firmware

To create pre-rooted firmware, run `create.sh` and place the resulting .img file on a flash drive, then plug it into your printer.

Pre-rooted firmware OTA images can be found in the releases. Versions will always start with `V6` to allow for easy flashing

### How to install

Simply place the .img file from the latest release on the right on a flash drive and insert it into the screen of the printer. Navigate to the home page if it's not already there, and it'll pop up asking to update

### How to compile

#### WIP, but includes the basics

On an Ubuntu-based system, we need to install some dependencies

```bash
sudo apt-get update && sudo apt-get install p7zip squashfs-tools whois git
```

This will install the required commands to run the create script:

```bash
git clone https://github.com/zevaryx/ender-5-max-firmware.git e5m-firmware
cd e5m-firmware
chmod +x ./create.sh
./create.sh
```

This will build the image and save the pre-rooted image to the current directory