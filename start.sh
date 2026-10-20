#!/system/bin/sh
# Run as root (MT Manager: long-press -> Execute as root). Place esp + start.sh in /data/local/tmp.
# usage: start.sh [package]   (package optional; default = any process that maps libil2cpp.so)
DIR=/data/local/tmp
BIN="$DIR/esp"
LOG="$DIR/esp.log"

[ "$(id -u)" = "0" ] || { echo "need root"; exit 1; }
[ -f "$BIN" ] || { echo "missing $BIN"; exit 1; }
chmod 755 "$BIN"

OLD=$(pidof esp)
[ -n "$OLD" ] && kill $OLD 2>/dev/null && sleep 1

cd "$DIR" || exit 1
nohup "$BIN" "$@" > "$LOG" 2>&1 &
sleep 2
if kill -0 $! 2>/dev/null; then
    echo "esp started pid=$! (log: $LOG)"
else
    echo "esp exited early:"; cat "$LOG"
fi
