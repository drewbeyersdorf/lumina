#!/usr/bin/env python3
"""demo-state.py — emit a synthetic 'fleet' feed (generic drives + moving transfers) so the
screensaver runs live for anyone, with no real data. The page also has a built-in demo
fallback, so this is optional — use it if you want the MB/s + flows to wander on a timer.

Pipe it on a loop:  while true; do python3 demo-state.py > state.json; sleep 1.5; done
"""
import json, math, time

t = time.time()
def osc(a, b, period, ph=0):  # smooth wander
    return a + (b - a) * (0.5 + 0.5 * math.sin(t / period + ph))

drives = [
    {"name": "CAM-A", "role": "source", "kind": "camera-sony", "label": "F-01",
     "clips": 42, "total": 1_000_000_000_000, "used": 520_000_000_000},
    {"name": "CAM-B", "role": "source", "kind": "camera-sony", "label": "F-02",
     "clips": 17, "total": 256_000_000_000, "used": 80_000_000_000},
    {"name": "DRIVE-1", "role": "source", "kind": "data", "label": "D-01",
     "total": 500_000_000_000, "used": 460_000_000_000},
    {"name": "ARCHIVE", "role": "archive", "kind": "archive",
     "total": 16_000_000_000_000, "used": 820_000_000_000},
]
edges = [
    {"from": "CAM-A", "to": "cloud", "kind": "footage",
     "pct": int(t * 7) % 100, "speed": int(osc(28, 64, 6))},
    {"from": "CAM-A", "to": "vault", "kind": "footage",
     "pct": int(t * 9) % 100, "speed": int(osc(40, 78, 4.5))},
    {"from": "DRIVE-1", "to": "vault", "kind": "data", "pct": 0, "speed": 0},
]
print(json.dumps({
    "ts": time.strftime("%H:%M:%S"),
    "drives": drives,
    "cloud": {"name": "Cloud", "used": 1_700_000_000_000, "total": 22_000_000_000_000},
    "edges": edges,
    "totalSpeed": sum(e["speed"] for e in edges),
}))
