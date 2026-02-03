#!/bin/bash
# Senior Arch Linux Installer - War Architecture Version
# Standard: Feb 2026

set -e

# Diagnostic check for environmental readiness
echo "Checking environment for Senior Installation Strategy..."

if [ ! -d /sys/firmware/efi/efivars ]; then
    echo "ERROR: UEFI not detected. This script is strictly for UEFI systems."
    exit 1
fi

# We provide the script as a template for the user to refine based on their specific disk
cat << 'EOF' > /tmp/optimized_install.sh
#!/bin/bash
# Optimized for Feb 2026

set -e

# Update mirrors
reflector --country 'United States,Peru' --latest 15 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

# Assume DISK is passed as first argument
DISK=$1
if [ -z "$DISK" ]; then
    echo "Usage: $0 /dev/sdX or /dev/nvmeX"
    exit 1
fi

# Robust manual partitioning bypasses archinstall bugs
echo "Cleaning $DISK..."
sgdisk -Z $DISK
sgdisk -n 1:0:+1G -t 1:ef00 -c 1:"BOOT" $DISK
sgdisk -n 2:0:0 -t 2:8300 -c 2:"ROOT" $DISK

echo "Formatting..."
mkfs.vfat -F 32 ${DISK}p1 || mkfs.vfat -F 32 ${DISK}1
mkfs.ext4 ${DISK}p2 || mkfs.ext4 ${DISK}2

echo "Mounting..."
mount ${DISK}p2 /mnt
mount --mkdir ${DISK}p1 /mnt/boot

echo "Pacstrapping (Excluding buggy pipewire configs during base)..."
pacstrap -K /mnt base linux linux-firmware base-devel networkmanager vim git

genfstab -U /mnt >> /mnt/etc/fstab

echo "Base installed. Enter arch-chroot /mnt to finish configuration."
EOF

chmod +x /tmp/optimized_install.sh
echo "Script generated at /tmp/optimized_install.sh"
echo "Instructions: Run it with your target disk, e.g., /tmp/optimized_install.sh /dev/nvme0n1"
