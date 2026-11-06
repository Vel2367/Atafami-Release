# Atafami Release

Public distribution files for the Atafami hub. The loader selects the game, opens keyUI, validates the user's game key with Luarmor and starts the protected game script.

## Run

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Vel2367/Atafami-Release/main/loader.luau"))()
```

## Layout

| Path | Purpose |
| --- | --- |
| `loader.luau` | Public hub entry point. |
| `ui/keyUI.luau` | Key input and loader status UI. |
| `ui/scriptUI.luau` | UI library loaded by protected game scripts. |
| `menu/icons/` | Public UI icons. |
| `menu/backgrounds/` | Public backgrounds. |
| `menu/theme/` | Public theme data. |
| `menu/animations/` | Public decorative animation resources. |
| `menu/catalog.json` | Resource catalog with paths relative to this repository root. |

There is no outer `assets/` directory.

## Build and local state

The three Luau distribution files are obfuscated with MoonVeil 2.1.1, using VM mode and the Cat VM. Editable sources and tests are maintained separately.

The loader creates `atafami` in the executor workspace. UI resources are cached under `atafami/menu/`; settings and game configuration also remain in the executor workspace.

Only public distribution files and public resources belong here. Private game sources, administrative credentials and user keys must not be committed.
