# Atafami Assets

Актуальный каталог `assets/icons/`: **19 PNG**. Названия файлов являются частью публичного URL, поэтому при замене ассетов проверяй соответствие aliases в `project/ui/ThemeUI.luau` и потребителей в Source.

## Core semantic aliases

| Alias | Файл |
| --- | --- |
| `config` | `ci--file-document.png` |
| `config-load` | `ci--file-upload.png` |
| `config-create` | `ci--file-add.png` |
| `config-overwrite` | `ci--file-edit.png` |
| `config-delete` | `ci--file-remove.png` |
| `dropdown` | `dashicons--arrow-up-alt2.png` |
| `search` | `ant-design--search-outlined.png` |
| `gear` | `gravity-ui--gear.png` |
| `settings` | `cil--apps-settings.png` |
| `reset-all` | `akar-icons--arrow-cycle.png` |
| `key` | `fa6-solid--key.png` |
| `discord` | `akar-icons--discord-fill.png` |
| `button-action` | `icon-park-solid--click.png` |
| `unload` | `akar-icons--door.png` |

## Дополнительные файлы

Эти PNG используются по прямому имени, вне core alias-словаря:

- `akar-icons--eye-open.png`
- `ant-design--home-outlined.png`
- `flowbite--egg-outline.png`
- `material-symbols--swords-outline.png`
- `mdi--paw.png`

Стрелка `dropdown` в исходном изображении направлена вверх; UI поворачивает её по состоянию. Все запросы, memory/disk cache и logical cancellation находятся в ThemeUI, а не в ScriptUI или KeyUI.

Для новых иконок сначала обнови файлы Release, затем ThemeUI aliases и только после этого ссылки потребителей. Новые имена URL позволяют не смешивать старые изображения с прежними ключами disk cache.
