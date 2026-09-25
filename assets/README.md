# Atafami Assets

Only PNGs referenced by the current libraries, previews and game-script callers are published here. Unused variants and the former CFG/dropdown assets were removed for v0.0.3.1.

The twelve supplied replacement PNGs are preserved byte-for-byte at their original 512 × 512 resolution. Retained assets keep their existing resolution. Images use transparent backgrounds and white shapes for runtime `ImageColor3` tinting.

| Asset | Current use |
| --- | --- |
| ci--file-upload.png | CFG Load |
| ci--file-add.png | CFG Create |
| ci--file-edit.png | CFG Overwrite |
| ci--file-remove.png | CFG Delete |
| ci--file-document.png | CFG trigger |
| cil--apps-settings.png | Settings tab |
| dashicons--arrow-down-alt2.png | Dropdown, MultiDropdown, CFG selector, Section chevron |
| eos-icons--arrow-rotate.png | Reset All |
| akar-icons--gear.png | MiniSection gear and existing Misc tab |
| ant-design--search-outlined.png | Search |
| flowbite--egg-solid.png | Existing egg tab |
| mdi--paw.png | Existing pets tab |
| button-action.png | Default action buttons and preview |
| key.png | KeyUI input |
| discord.png | Loader/KeyUI Discord action |
| skull.png | ScriptUI preview combat tab |

ThemeUI maps existing logical names (`config-load`, `dropdown`, `gear_v1`, `settings_v2`, etc.) to these filenames. New filenames give replacements new URL-based cache keys without deleting executor cache files. No unused duplicate PNGs are retained for aliases.

Raw icon base:

```text
https://raw.githubusercontent.com/Vel2367/Atafami-Release/main/assets/icons/
```

The supplied source PNGs retain their original provenance; this repository does not add a blanket license to third-party assets.
