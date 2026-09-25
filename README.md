# Atafami Release

Public delivery repository for Atafami HUB.

## Current state

At the moment this repository publishes the public runtime assets used by Atafami:

```text
assets/
└─ icons/
```

The production `project/` runtime bundle is **not published yet**. It will be added only after the production-delivery/release pipeline is implemented and accepted.

The private readable source, development tests, previews, legacy references and internal documentation are not distributed from this repository.

## v0.0.3.1 icon manifest

19 supplied PNGs, copied without transformations. ThemeUI is the sole resolver/cache/request owner. Arrow artwork points up; presentation rotates it for closed dropdowns and section collapse.

| Semantic name | PNG |
|---|---|
| `config` | `ci--file-document.png` |
| `config-load` | `ci--file-upload.png` |
| `config-create` | `ci--file-add.png` |
| `config-overwrite` | `ci--file-edit.png` |
| `config-delete` | `ci--file-remove.png` |
| `dropdown` | `dashicons--arrow-up-alt2.png` |
| `search` | `ant-design--search-outlined.png` |
| `gear` | `ep--setting.png` |
| `settings` | `cil--apps-settings.png` |
| `reset-all` | `akar-icons--arrow-cycle.png` |
| `key` | `akar-icons--key.png` |
| `discord` | `akar-icons--discord-fill.png` |
| `button-action` | `fluent--cursor-click-20-filled.png` |
| `unload` | `akar-icons--door.png` |

Direct filename assets (outside core aliases):

- `akar-icons--eye-open.png`
- `ant-design--home-outlined.png`
- `flowbite--egg-outline.png`
- `material-symbols--swords-outline.png`
- `mdi--paw.png`

Removed historical assets: `akar-icons--gear.png`, `button-action.png`, `dashicons--arrow-down-alt2.png`, `discord.png`, `eos-icons--arrow-rotate.png`, `flowbite--egg-solid.png`, `key.png`, `skull.png`.

Core aliases `gear_v1`, `settings_v2`, `egg`, `paw-print` were removed. Game-specific assets use explicit filenames.
