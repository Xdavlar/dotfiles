#!/usr/bin/env bash

DISK="${1:-windows.qcow2}"
ISO="${2}"

# Create disk if it doesn't exist
if [ ! -f "$DISK" ]; then
    qemu-img create -f qcow2 "$DISK" 40G
    echo "Created disk: $DISK"
fi

# Build QEMU command
CMD="qemu-system-x86_64 \
    -enable-kvm \
    -m 8G \
    -smp 4 \
    -cpu host \
    -drive file=$DISK,if=virtio,cache=writeback \
    -nic user,model=virtio-net-pci \
    -vga virtio \
    -display sdl"

# Add ISO if provided (for installation)
if [ -n "$ISO" ]; then
    CMD="$CMD -cdrom $ISO -boot d"
fi

exec $CMD
