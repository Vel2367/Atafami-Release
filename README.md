# Atafami Release

Публичная поставка ScriptUI_defolt и ресурсов Atafami.

## UI

[ui/ScriptUI_defolt.luau](ui/ScriptUI_defolt.luau) — самостоятельная библиотека версии **1.22.2**, ContractVersion 1. Она не требует ScriptUI_old, ThemeUI или других Luau-модулей.

Подключение и установка фона описаны в [ui/README.md](ui/README.md). Разработчик создаёт вкладки и контролы, а библиотека владеет GUI, вводом, анимациями, иконками и своими ресурсами. Формат CFG — Version 1 / Flags.

## Ресурсы

- [assets/icons/](assets/icons/) — опубликованные PNG-иконки и исходные сведения об их происхождении.
- [assets/menu/halloween.jpg](assets/menu/halloween.jpg) — предоставленный пользователем фон, опубликованный без изменения байтов.
- [assets/README.md](assets/README.md) — каталог ресурсов.

Прежний пакет fog/grain `assets/ui/defolt/background-v1/` удалён: актуальная библиотека его не загружает. Оформление использует локальные изображения, цветную подложку и затемнение.

Рабочие исходники, тесты и игровой runtime находятся в [Atafami-Source](https://github.com/Vel2367/Atafami-Source). Key backend, game routing и Luarmor delivery не входят в эту поставку.

