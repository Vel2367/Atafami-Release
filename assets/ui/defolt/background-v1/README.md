# Atafami default UI background v1

Original PNG bytes, verified against `SOURCES.json` before publication:

- `fog_a.png`: Kenney Particle Pack `smoke_02.png`, 512 × 512.
- `fog_b.png`: Kenney Particle Pack `smoke_06.png`, 512 × 512.
- `grain_256.png`: Christoph Peters monochrome LLL blue noise, 256 × 256.

All three assets are CC0-1.0. Original notices and the CC0 text are in
`licenses/`. The manifest records exact upstream commits, URLs and SHA-256s.
The images have not been resized, recolored, blurred or re-encoded.

ScriptUI_defolt loads these files from Atafami-Release and keeps a separate
versioned disk cache at `atafami/ui_cache/defolt/background-v1`. Visual tint,
transparency, tiling and motion are applied by the UI at runtime.
