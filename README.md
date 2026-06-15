# Lumina

A live **data-art screensaver**. Your real data — files moving between drives, to a local
vault, up to the cloud — streams as comets of light across a slow rotation of public-domain
masterworks. Each comet picks up the exact pigment of the painting beneath it, so the same
data glows gold across Hokusai's sky and deep indigo through the shadow of the wave.

It runs on a plain web page. No build step, no dependencies, no account. Point it at a small
JSON feed and it animates; with no feed it runs a built-in demo.

![Lumina over Hokusai's Great Wave](screenshot.png)

## Run it

```bash
./serve.sh            # opens http://localhost:8787/  (built-in demo data)
./serve.sh --demo     # same, but with an animated demo feed (numbers wander)
```

Click the page for fullscreen. That's the whole thing.

## The seven paintings

A deliberately dark, single-light-source set — nocturnes, storms, moonrises — so the data is
the only thing truly alight. Each one moves the data differently:

| Painting | Artist (year) | How the data moves |
|---|---|---|
| Under the Wave off Kanagawa | Hokusai (1831) | **curl** — comets surge in a high arc, like the wave |
| Nocturne: Blue and Gold | Whistler (1872) | **drift** — slow horizontal shimmer, like lamplight on water |
| Moonlight, Night in St Cloud | Munch (1893) | **beam** — cool, vertical, moonlit |
| Ships at Sea During Storm | Jules Dupré (1844) | **storm** — fast, turbulent spray |
| Moonrise | George Inness (1891) | **rise** — gentle, sparse, ascending |
| The Assumption of the Virgin | El Greco (1577) | **ascend** — light rises heavenward |
| The Girl by the Window | Munch (1893) | **drift** — quiet, inward |

Every painting is **public domain**. See [CREDITS.md](CREDITS.md) for sources and provenance.

## Feeding it your own data

The page polls `state.json` every 1.5s. Give it this shape:

```json
{
  "ts": "14:22:01",
  "totalSpeed": 90,
  "drives": [
    {"name":"CAM-A","role":"source","kind":"camera-sony","label":"F-01","clips":42,"total":1000000000000,"used":520000000000},
    {"name":"DRIVE-1","role":"source","kind":"data","label":"D-01","total":500000000000,"used":460000000000},
    {"name":"ARCHIVE","role":"archive","kind":"archive","total":16000000000000,"used":820000000000}
  ],
  "cloud": {"name":"Cloud","used":1700000000000,"total":22000000000000},
  "edges": [
    {"from":"CAM-A","to":"cloud","kind":"footage","pct":63,"speed":47},
    {"from":"DRIVE-1","to":"vault","kind":"data","pct":0,"speed":0}
  ]
}
```

- `drives[].role`: `source` (left), `archive` (the center vault), shown as labeled nodes.
- `edges[]`: each active transfer becomes a stream of comets. `to` is `"vault"` or `"cloud"`.
- `kind`: `footage` comets run warm, `data` comets run cool.
- `label`: the short name shown on each node (e.g. `F-01`).

Write that file from anything — a backup script, a `df` loop, an rsync wrapper. Whatever
produces it, Lumina just reads it.

## Make it yours

Open `index.html` and edit the `ART` array near the top — swap in your own public-domain
images (drop the JPGs in `art/`) and tune each painting's motion: `b` brightness, `v`
vignette, `sp` speed, `wob` wobble, `arc` path lift, `gh` trail length, `flow` style.

## License

Code: [MIT](LICENSE). Paintings: public domain (see CREDITS.md). Use it however you like.
