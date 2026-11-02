# Atafami Release

Public menu assets and theme data used by Atafami UI modules. Executable libraries remain in [Atafami-Source](https://github.com/Vel2367/Atafami-Source).

## Assets

| Path | Contents |
| --- | --- |
| [assets/menu/catalog.json](assets/menu/catalog.json) | Version 1 resource catalog with a revision and repository-relative asset paths. |
| [assets/menu/icons/](assets/menu/icons/) | 34 PNG icons with the public filenames used by UI modules. |
| [assets/menu/animations/](assets/menu/animations/) | The original user-provided SVG used as the loading-animation source. |
| [assets/menu/backgrounds/](assets/menu/backgrounds/) | Two bundled backgrounds: atafami-default.png and halloween-night.jpg. |
| [assets/menu/theme/](assets/menu/theme/) | Version 1 JSON data presets: [Default](assets/menu/theme/Default.json) and [Halloween](assets/menu/theme/Halloween.json). |

Themes store colors, dimming, and a repository-relative background path. The filename stem supplies the preset ID and label; optional Name is metadata ignored by the library. Default and Halloween JSON files are the preset data source.

ScriptUI_defolt downloads catalog resources directly from this public repository into atafami/assets/menu in the executor workspace. A local Atafami-Release checkout is unnecessary. The UI creates atafami/configs for profiles and atafami/backgrounds for personal PNG/JPG images. A saved catalog tracks resource revisions; source modules, diagnostics, and generated audit reports do not belong in Release.

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
