# Ender 5 Max Firmware Repository

Repository of firmware and root tools for the Ender 5 Max.

Root tools based on the Crealtiy firmware scripts made by [@pellcorp](https://github.com/pellcorp) for the K1 series: <https://github.com/pellcorp/creality/tree/main/firmware>

[SimpleAF Discord Server](https://discord.gg/tGGVn5qjgv)

## How to install

### I WILL NOT BE HELD RESPONSIBLE IF YOU BRICK YOUR PRINTER - CREATING AND INSTALLING CUSTOM FIRMWARE IS RISKY

1. Download the latest pre-rooted firmware [from the releases](https://github.com/zevaryx/ender-5-max-firmware/releases)
    - Make sure you download the file ending in .img!
2. Place the pre-rooted firmware onto a flash drive
    - Should be formatted in FAT32 or NTFS
3. Plug the flash drive into the printer and navigate to the home page (if you were not already there)
4. Accept the update and let it finish installing

Congratulations! You can now SSH as root

The default password is `creality_2025` in the pre-rooted firmware

## How to downgrade/go back to stock

### UNTESTED. THIS MAY BRICK YOUR PRINTER. I AM NOT RESPONSIBLE FOR ANY BRICKED PRINTERS AS A RESULT FROM ATTEMPTING THIS.

1. SSH as root
2. Run the following:

    ```bash
    # Get the current version, regardless of what it is
    VERSION=$(grep 'ota_version' '/etc/ota_info' | awk -F'=' '{print $2}')

    # Forcefully set the version to 1.0.0.0, which is below the minimum
    for file in /etc/ota_info /usr/data/creality/userdata/config/system_version.json; do
        sed -i -e "s/${VERSION}/1.0.0.0/g" $file
    done

    # Reboot the system to force reloading of the files from disk
    reboot
    ```

3. Download the v1.2.0.10 firmware from here:

    <https://github.com/zevaryx/ender-5-max-firmware/raw/refs/heads/main/F004_ota_img_V1.2.0.10.img>

4. Place the v1.2.0.10 firmware onto a flash drive
5. Plug it into the printer and accept the update

This will install the earliest publicly available (by DM from support) firmware for the Ender 5 Max, allowing you to upgrade to the latest or any other version.

## Build your own firmware

### WIP, but includes the basics

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
