#!/bin/bash
# serve.sh — run Lumina locally. Opens at http://localhost:8787/
#   ./serve.sh            # static demo data
#   ./serve.sh --demo     # animated demo feed (the numbers wander)
# Click the page for fullscreen.
DIR="$(cd "$(dirname "$0")" && pwd)"
PORT="${PORT:-8787}"
LOOP=""
if [ "$1" = "--demo" ]; then
  ( while true; do python3 "$DIR/demo-state.py" > "$DIR/state.json.tmp" 2>/dev/null \
      && mv "$DIR/state.json.tmp" "$DIR/state.json"; sleep 1.5; done ) &
  LOOP=$!; echo "demo feed running (pid $LOOP)"
else
  # seed a static feed so a fresh clone has data (no 404s in the log)
  [ -f "$DIR/state.json" ] || cp "$DIR/state.sample.json" "$DIR/state.json"
fi
SRV=""
trap '[ -n "$LOOP" ] && kill "$LOOP" 2>/dev/null; [ -n "$SRV" ] && kill "$SRV" 2>/dev/null' EXIT INT TERM
echo "Lumina → http://localhost:$PORT/   (click for fullscreen)"
command -v open >/dev/null && open "http://localhost:$PORT/" 2>/dev/null
python3 -m http.server "$PORT" -d "$DIR" & SRV=$!
wait "$SRV"
