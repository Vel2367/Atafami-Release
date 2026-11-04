# Atafami Release

Public distribution repository. A new loader and keyUI are being designed and will replace the previous frontend together after executor tests and obfuscation.

## Layout

| Path | Purpose |
| --- | --- |
| `loader.luau` | Loader distribution file. |
| `ui/` | Public obfuscated UI modules. |
| `menu/icons/` | Public UI images, including the ATAFAMI wordmark, key and Discord icons. |
| `menu/backgrounds/` | Public backgrounds. |
| `menu/theme/` | Public theme data. |
| `menu/animations/` | Public decorative animation resources. |
| `menu/catalog.json` | Resource catalog; paths are relative to this repository root. |

There is no outer `assets/` directory.

## Current status

The executable files were moved without modifying their contents. They belong to the previous broken architecture and are not a validated new release. There is no compatibility or transition layer. Their complete replacement will be published only after the new build passes its tests, is obfuscated, and passes the same runtime checks.

## Local resources

The loader will create the executor-workspace root `atafami`. UI images will be downloaded from `https://raw.githubusercontent.com/Vel2367/Atafami-Release/main/menu/icons/` and cached under `atafami/menu/icons/`.

Only public distribution files and public resources belong here. Private game sources, administrative credentials and user keys must not be committed.
