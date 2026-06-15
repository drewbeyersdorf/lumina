#!/bin/bash
# serve.sh — run Lumina locally. Opens at http://localhost:8787/
# Click the page for fullscreen. Press the data feed of your choice:
#   ./serve.sh            # built-in demo data (no feed needed)
#   ./serve.sh --demo     # animated demo feed via demo-state.py (MB/s wanders)
DIR="$(cd "$(dirname "$0")" && pwd)"
PORT="${PORT:-8787}"
if [ "$1" = "--demo" ]; then
  ( while true; do python3 "$DIR/demo-state.py" > "$DIR/state.json.tmp" 2>/dev/null \
      && mv "$DIR/state.json.tmp" "$DIR/state.json"; sleep 1.5; done ) &
  echo "demo feed running (pid $!)"
fi
echo "Lumina → http://localhost:$PORT/   (click for fullscreen)"
command -v open >/dev/null && open "http://localhost:$PORT/" 2>/dev/null
exec python3 -m http.server "$PORT" -d "$DIR"
