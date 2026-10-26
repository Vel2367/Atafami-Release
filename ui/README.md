# ScriptUI_defolt 1.22.2

Самостоятельная клиентская Luau-библиотека для Real executor. Публичный контракт: `Kind = "ScriptUIFoundation"`, `Variant = "defolt"`, `ContractVersion = 1`. Формат сохранений: CFG Version 1 / Flags. API нового варианта отличается от API ScriptUI_old; существующие игровые скрипты переводятся явно.

## Подключение

```luau
local UI = assert(loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Vel2367/Atafami-Release/main/ui/ScriptUI_defolt.luau"
)))()

local app = UI.new({
    Size = Vector2.new(580, 620),
    ScriptVersion = "v1.0.0",
    Tabs = {
        { Id = "main", Name = "Main", Icon = "tabler--run.png", Active = true },
    },
})

local section = assert(app:GetTab("main")):AddSection({ Id = "general", Name = "General" })
section:AddToggle({ Id = "enabled", Name = "Enabled", Default = false, Callback = function(enabled)
    print("Enabled:", enabled)
end })
```

RightShift открывает/закрывает меню. Автор задаёт версию своего скрипта через `ScriptVersion`; версия библиотеки находится в `UI.Version`. Нижняя панель показывает имя текущего плейса и версию скрипта. Search и Settings встроены.

## Установка опубликованного фона

Библиотека читает пользовательские картинки с локального диска. Установи фон один раз перед `UI.new`, чтобы он появился в Image и выбирался по умолчанию:

```luau
local wallpaper = "atafami/ui_cache/Menu/halloween.jpg"
if not isfile(wallpaper) then
    for _, folder in { "atafami", "atafami/ui_cache", "atafami/ui_cache/Menu" } do
        if not isfolder(folder) then makefolder(folder) end
    end
    writefile(wallpaper, game:HttpGet(
        "https://raw.githubusercontent.com/Vel2367/Atafami-Release/main/assets/menu/halloween.jpg"
    ))
end
```

Существующее изображение не перезаписывается. Если меню уже открыто, вызови `app:RefreshBackgrounds()` и `app:SetBackground("halloween.jpg")`. Дополнительные PNG/JPG размещаются в `atafami/ui_cache/Menu/`. Settings → Background позволяет выбрать Image, Dimming и Background color; Settings → Interface содержит общий Accent color.

## CFG и lifecycle

`app:ExportConfig()` и `app:ApplyConfig(document, { Emit = false })` работают с таблицей Version 1 / Flags. `Replay = true` повторно доставляет callbacks по контракту. Сохранённые пути, Id и Flag должны оставаться стабильными. Файлы CFG находятся в `atafami/configs/`, кэш иконок — в `atafami/ui_cache/Icon/`. Меню не удаляет пользовательские изображения.

`app:Destroy()` освобождает GUI и собственные ресурсы. Для действий Settings → Session автор передаёт `OnReload` и `OnUnload`; Reload пересоздаёт объявления UI и восстанавливает значения и раскладку. Продолжение после телепорта относится к runner Source и не входит в этот standalone-файл.

## Проверки поставки

Публикуется побайтовая копия ScriptUI_defolt 1.22.2 из Source. Host-тесты и установленные Roblox/Real определения проверяют контракты и типы, но не заменяют проверку нативного ввода и отрисовки в клиенте. Development preview и средства запуска тестов остаются в Source.

