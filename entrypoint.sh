bash
#!/usr/bin/env bash
set -Eeuo pipefail

PORT="${PORT:-7860}"
PASSWORD="${PASSWORD:-}"

if [[ -z "$PASSWORD" ]]; then
    echo "ERROR: Set PASSWORD in Render Environment Variables."
    exit 1
fi

mkdir -p /workspace/vms /workspace/isos
chown -R lab:lab /workspace

echo "===================================="
echo "       SAM CLOUD LAB"
echo "===================================="
echo "IDE port: ${PORT}"
echo "QEMU mode: TCG software emulation"
echo "KVM required: NO"
echo "Workspace: /workspace"
echo "VM disks: /workspace/vms"
echo "ISO files: /workspace/isos"
echo "===================================="

exec sudo -u lab -H env \
    HOME=/home/lab \
    PASSWORD="$PASSWORD" \
    /usr/bin/code-server \
        --bind-addr "0.0.0.0:${PORT}" \
        --auth password \
        --disable-telemetry \
        --disable-update-check \
        /workspace
