
#!/usr/bin/env bash
set -Eeuo pipefail

NAME="${1:-}"

if [[ -z "$NAME" || ! "$NAME" =~ ^[a-zA-Z0-9._-]+$ ]]; then
    echo "Usage: vm-stop NAME"
    exit 1
fi

PIDFILE="/workspace/vms/${NAME}.pid"

if [[ ! -f "$PIDFILE" ]]; then
    echo "VM PID file not found."
    exit 1
fi

PID="$(cat "$PIDFILE")"

if kill -0 "$PID" 2>/dev/null; then
    kill "$PID"
    echo "Stop signal sent to VM: $NAME"
else
    echo "VM is already stopped."
fi

rm -f "$PIDFILE"
