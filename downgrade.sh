#!/bin/bash

# Use jq to parse raw releases and extract the wanted filename
get_filename() {
    RELEASES=$1
    TAG=$2
    VER=$3

    echo "${RELEASES}" | # Prime releases for processing
    jq ".[] | select(.tag_name==\"${TAG}\") | .assets[] | select((.name | ascii_downcase) == (\"F004_ota_img_${VER}.img\" | ascii_downcase)) | .name" -r # Get the filename
}

# Use jq to parse raw releases and extract the wanted download url
get_image() {
    RELEASES=$1
    TAG=$2
    VER=$3

    echo "${RELEASES}" | # Prime releases for processing
    jq ".[] | select(.tag_name==\"${TAG}\") | .assets[] | select((.name | ascii_downcase) == (\"F004_ota_img_${VER}.img\" | ascii_downcase)) | .browser_download_url" -r # Get the download url
}

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

# Let's get the version the user wants to install
RAW_RELEASES=$(curl --silent "https://api.github.com/repos/zevaryx/ender-5-max-firmware/releases")
TAGS=()
VERSIONS=()
IFS=$'\n' read -r -d '' -a TAGS < <( echo "${RAW_RELEASES}" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' && printf '\0' )
for tag in "${TAGS[@]}"; do
    rel=$(echo $tag | sed -E 's/v6(.*)/v1\1/')
    VERSIONS+=($rel)
done
SELECTED_VER=
SELECTED_TAG=
PS3="Select version to downgrade to: "

select ver in "${VERSIONS[@]}"; do
    SELECTED_VER="${VERSIONS[REPLY-1]}"
    SELECTED_TAG="${TAGS[REPLY-1]}"
    break
done

echo "Downgrading to ${SELECTED_VER}"

IMAGE=$(get_image "${RAW_RELEASES}" "${SELECTED_TAG}" "${SELECTED_VER}")
CHECKSUM="${IMAGE}.sha256"
FILENAME=$(get_filename "${RAW_RELEASES}" "${SELECTED_TAG}" "${SELECTED_VER}")

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