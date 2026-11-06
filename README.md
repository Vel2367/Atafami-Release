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
