cat << EOF

###########
# WARNING #
###########

THIS SCRIPT IS PROVIDED WITHOUT WARRANTY. 
I WILL NOT BE HELD RESPONSIBLE IF YOU BRICK YOUR PRINTER.
CREATING AND INSTALLING CUSTOM FIRMWARE IS RISKY.
DOWNGRADING TO STOCK IS EVEN RISKIER.

########################
# YOU HAVE BEEN WARNED #
########################

EOF

SELECTED_VER="1.2.0.10"
IMAGE="https://github.com/zevaryx/ender-5-max-firmware/releases/download/v6.2.0.10/F004_ota_img_V1.2.0.10.img"
CHECKSUM="https://github.com/zevaryx/ender-5-max-firmware/releases/download/v6.2.0.10/F004_ota_img_V1.2.0.10.img.sha256"
FILENAME="F004_ota_img_V1.2.0.10.img"

echo "Downgrading to ${SELECTED_VER}"

# Get the current version, regardless of what it is
LOCAL_VERSION=$(grep 'ota_version' '/etc/ota_info' | awk -F'=' '{print $2}')

# Forcefully set the version to 1.0.0.0, which is below the minimum
for file in /etc/ota_info /usr/data/creality/userdata/config/system_version.json; do
    sed -i -e "s/${LOCAL_VERSION}/1.0.0.0/g" $file
done

# Download the wanted release
cd /usr/data
mkdir -p .firmware_downgrade
cd .firmware_downgrade
wget --no-check-certificate "${IMAGE}"
wget --no-check-certificate "${CHECKSUM}"

echo "Validating that the image downloaded successfully, please wait"
sha256sum -c *.sha256 || exit 1

echo "Installing OTA..."
/etc/ota_bin/local_ota_update.sh "/usr/data/.firmware_downgrade/${FILENAME}"

echo "Cleaning up..."
rm -rf /usr/data/.firmware_downgrade

echo "Done! Please turn the printer off and on again, then factory reset to finish up the downgrade"