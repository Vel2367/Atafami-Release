# Atafami Release

Public obfuscated frontend builds and menu resources. Editable game sources stay private and are distributed through Luarmor.

## Frontend

| Path | Purpose |
| --- | --- |
| [assets/loader.luau](assets/loader.luau) | One shared entry: detects the game, checks the key and starts its Luarmor script. |
| [assets/ui/keyUI.luau](assets/ui/keyUI.luau) | Key-entry form. |
| [assets/ui/scriptUI.luau](assets/ui/scriptUI.luau) | Shared UI and game-independent lifecycle runtime, API version 2. |

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Vel2367/Atafami-Release/main/assets/loader.luau"))()
```

The loader currently supports +1 Upgrade Per Kill. Enter your own key in the form. Game payloads are managed separately in Luarmor and must use the matching API 2 frontend at assets/ui/scriptUI.luau; a previous payload must be updated to the current private game source.

Frontend files use two local Obscura passes (native, then lightweight). Helper attribution is retained in [THIRD_PARTY.txt](THIRD_PARTY.txt). Game sources, tests, diagnostic adapters and administrative credentials are not included.

## Assets

| Path | Contents |
| --- | --- |
| [assets/menu/catalog.json](assets/menu/catalog.json) | Version 1 resource catalog with a revision and repository-relative asset paths. |
| [assets/menu/icons/](assets/menu/icons/) | 34 PNG icons with the public filenames used by UI modules. |
| [assets/menu/animations/](assets/menu/animations/) | The original user-provided SVG used as the loading-animation source. |
| [assets/menu/backgrounds/](assets/menu/backgrounds/) | Two bundled backgrounds: atafami-default.png and halloween-night.jpg. |
| [assets/menu/theme/](assets/menu/theme/) | Version 1 JSON data presets: [Default](assets/menu/theme/Default.json) and [Halloween](assets/menu/theme/Halloween.json). |

Themes store colors, dimming, and a repository-relative background path. The filename stem supplies the preset ID and label; optional Name is metadata ignored by the library. Default and Halloween JSON files are the preset data source.

ScriptUI fetches individual menu files from this public repository into atafami/menu in the executor workspace; it does not clone or download the Release repository. The UI creates atafami/configs for profiles. Catalog backgrounds and personal PNG/JPG images share atafami/menu/backgrounds. A saved catalog tracks resource revisions; source modules, diagnostics, and generated audit reports do not belong in Release.

## Attribution

The six Tabler outline PNGs (run, eye, search, settings, arrows-move, and arrows-diagonal-2) are by Paweł Kuna from [tabler/tabler-icons](https://github.com/tabler/tabler-icons). The MIT license below applies to this collection.

The IconMind resize handle was supplied as a PNG attachment without a license notice. The Gridicons resize arrow, current atafami-default.png, and spinner SVG were supplied by the user and are preserved unchanged.

halloween-night.jpg is a photo by [Zdeněk Macháček on Unsplash](https://unsplash.com/photos/a-carved-jack-o-lantern-in-the-dark-QgIkEq4knaA), used under the [Unsplash License](https://unsplash.com/license). The downloaded JPEG is preserved unchanged.

## Tabler license

MIT License

Copyright (c) 2020-2026 Paweł Kuna

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
