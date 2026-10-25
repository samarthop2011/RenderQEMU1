
#!/usr/bin/env bash
set -Eeuo pipefail

NAME="${1:-}"
ISO="${2:-}"
RAM="${3:-1024}"
CPUS="${4:-1}"

if [[ -z "$NAME" || -z "$ISO" ]]; then
    echo "Usage: vm-run NAME ISO_PATH [RAM_MB] [CPUS]"
    echo "Example: vm-run debian-test /workspace/isos/debian.iso 1024 1"
    exit 1
fi

if [[ ! "$NAME" =~ ^[a-zA-Z0-9._-]+$ ]]; then
    echo "Invalid VM name."
    exit 1
fi

if [[ ! "$RAM" =~ ^[0-9]+$ || ! "$CPUS" =~ ^[0-9]+$ ]]; then
    echo "RAM and CPU count must be numbers."
    exit 1
fi

if (( RAM < 256 || RAM > 8192 || CPUS < 1 || CPUS > 4 )); then
    echo "RAM must be 256-8192 MB and CPUs must be 1-4."
    exit 1
fi

DISK="/workspace/vms/${NAME}.qcow2"
PIDFILE="/workspace/vms/${NAME}.pid"
LOGFILE="/workspace/vms/${NAME}.log"

[[ -f "$DISK" ]] || {
    echo "Disk not found. Run vm-create first."
    exit 1
}

[[ -f "$ISO" ]] || {
    echo "ISO not found: $ISO"
    exit 1
}

if [[ -f "$PIDFILE" ]] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
    echo "VM already running."
    exit 1
fi

rm -f "$PIDFILE"

nohup qemu-system-x86_64 \
    -accel tcg,thread=multi \
    -machine pc \
    -cpu qemu64 \
    -smp "$CPUS" \
    -m "$RAM" \
    -drive "file=${DISK},format=qcow2,if=virtio" \
    -cdrom "$ISO" \
    -boot order=d,menu=on \
    -display none \
    -serial "file:${LOGFILE}" \
    -monitor none \
    -netdev user,id=net0 \
    -device virtio-net-pci,netdev=net0 \
    -no-reboot \
    >/dev/null 2>&1 &

PID=$!
echo "$PID" > "$PIDFILE"

sleep 2

if kill -0 "$PID" 2>/dev/null; then
    echo "QEMU VM started!"
    echo "Name: $NAME"
    echo "PID: $PID"
    echo "RAM: ${RAM} MB"
    echo "CPUs: $CPUS"
    echo "Mode: TCG software emulation"
    echo "Serial log: $LOGFILE"
    echo "Check: tail -f $LOGFILE"
    echo "Stop: vm-stop $NAME"
else
    rm -f "$PIDFILE"
    echo "QEMU failed to start. Check the container logs."
    exit 1
fi
