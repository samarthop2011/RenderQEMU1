```bash
#!/usr/bin/env bash
set -Eeuo pipefail

NAME="${1:-}"
SIZE="${2:-8G}"

if [[ -z "$NAME" ]]; then
    echo "Usage: vm-create NAME [DISK_SIZE]"
    echo "Example: vm-create debian-test 8G"
    exit 1
fi

if [[ ! "$NAME" =~ ^[a-zA-Z0-9._-]+$ ]]; then
    echo "Invalid VM name."
    exit 1
fi

DISK="/workspace/vms/${NAME}.qcow2"

if [[ -e "$DISK" ]]; then
    echo "Disk already exists: $DISK"
    exit 1
fi

mkdir -p /workspace/vms

qemu-img create -f qcow2 "$DISK" "$SIZE"

echo "VM disk created: $DISK"
echo "Next: vm-run $NAME /workspace/isos/installer.iso"
```
