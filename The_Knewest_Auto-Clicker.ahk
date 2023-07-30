#NoEnv
#Persistent
SendMode Input

defaultDelay := 10
defaultDelayType := "Milliseconds"
defaultHotkey := "NumpadSub"
defaultMode := 0
defaultTheme := "Light"
defaultLanguage := "English"
delay := defaultDelay
delayType := defaultDelayType
hotkey := defaultHotkey
mode := defaultMode
theme := defaultTheme
language := defaultLanguage
clickLoopRunning := 0

IniRead, delay, %A_ScriptDir%\settings.ini, Settings, Delay, %defaultDelay%
IniRead, delayType, %A_ScriptDir%\settings.ini, Settings, DelayType, %defaultDelayType%
IniRead, hotkey, %A_ScriptDir%\settings.ini, Settings, Hotkey, %defaultHotkey%
IniRead, mode, %A_ScriptDir%\settings.ini, Settings, Mode, %defaultMode%
IniRead, theme, %A_ScriptDir%\settings.ini, Settings, Theme, %defaultTheme%
IniRead, language, %A_ScriptDir%\settings.ini, Settings, Language, %defaultLanguage%

autoClickerSettings := {"English": "Auto-Clicker Settings", "Japanese": "自動クリッカーの設定", "Chinese": "自动点击设置", "Russian": "Настройки автокликера"}
holdToClick := {"English": "Hold to Auto-Click", "Japanese": "自動クリックを保持", "Chinese": "按住自动点击", "Russian": "Удерживайте, чтобы автокликнуть"}
toggleToClick := {"English": "Toggle to Auto-Click", "Japanese": "切り替えてクリック", "Chinese": "切换自动点击", "Russian": "Переключить автоклик"}
delayLabel := {"English": "Delay:", "Japanese": "遅延：", "Chinese": "延迟：", "Russian": "Задержка:"}
delayTypeLabel := {"English": "Delay Type:", "Japanese": "遅延タイプ：", "Chinese": "延迟类型：", "Russian": "Тип задержки:"}
hotkeyLabel := {"English": "Hotkey:", "Japanese": "ホットキー：", "Chinese": "热键：", "Russian": "Горячая клавиша:"}
modeLabel := {"English": "Mode:", "Japanese": "モード：", "Chinese": "模式：", "Russian": "Режим:"}
uiSettings := {"English": "UI Settings", "Japanese": "UI設定", "Chinese": "UI设置", "Russian": "Настройки интерфейса"}
toggleThemeLabel := {"English": "Toggle Theme (%theme% Mode)", "Japanese": "テーマ切替（%theme%モード）", "Chinese": "切换主题（%theme%模式）", "Russian": "Переключить тему (%theme% режим)"}
saveSettings := {"English": "Save Settings", "Japanese": "設定を保存", "Chinese": "保存设置", "Russian": "Сохранить настройки"}
languageMapping := {"English": "English", "Japanese": "日本語", "Chinese": "中文", "Russian": "Русский"}
selectedLanguageLabel := {"English": " (Selected language)", "Japanese": " (選択した言語)", "Chinese": " (选定的语言)", "Russian": " (Выбранный язык)"}
delayTypeMapping := {"English": "Milliseconds|Seconds|Minutes|Hours", "Japanese": "ミリ秒|秒|分|時間", "Chinese": "毫秒|秒|分钟|小时", "Russian": "Миллисекунды|Секунды|Минуты|Часы"}
githubButtonLabel := {"English": "Open Github Page", "Japanese": "Githubページを開く", "Chinese": "打开 Github 页面", "Russian": "Открыть страницу Github"}
discordButtonLabel := {"English": "Join Discord Server", "Japanese": "Discordサーバーに参加する", "Chinese": "加入 Discord 服务器", "Russian": "Присоединиться к серверу Discord"}

Hotkey, ~*%hotkey%, HotkeyDown, On
Hotkey, ~*%hotkey% Up, HotkeyUp, On

CreateGUI:
defaultLanguageChoice := languageMapping[language]

Gui, New
Gui, +LastFound +AlwaysOnTop
if (theme == "Light") {
    Gui, Color, 0xFFFFFF
    Gui, Font, s12 c000000
} else {
    Gui, Color, 0x000000
    Gui, Font, s12 cFFFFFF
}

Gui, Add, Text, x10 y10 w440 vTitle, The Knewest Auto-Clicker [v1.1]
Gui, Font, s10

Gui, Add, GroupBox, x10 y40 w440 h280 , % autoClickerSettings[language]

Gui, Add, Text, x20 y60 w90, % delayLabel[language]
if (theme == "Light") {
    Gui, Font, s10 c000000
} else {
    Gui, Font, s10 c000000
}
Gui, Add, Edit, x120 y60 w90 vDelay, %delay%

if (theme == "Light") {
    Gui, Font, s10 c000000
} else {
    Gui, Font, s10 cFFFFFF
}

Gui, Add, Text, x230 y60 w90, % delayTypeLabel[language]

delayTypes := StrSplit(delayTypeMapping[language], "|")
delayTypeIndex := delayTypes.HasKey(delayType) ? delayTypes[delayType] : 1

delayTypeList := ""
Loop, % delayTypes.MaxIndex() {
    if (delayTypes[A_Index] == delayType)
        delayTypeIndex := A_Index
    delayTypeList .= delayTypes[A_Index] . "|"   
}

delayTypeList := SubStr(delayTypeList, 1, -1)

Gui, Add, DropDownList, x330 y60 w100 vDelayType gDelayTypeChange Choose%delayTypeIndex%, % delayTypeList

Gui, Add, Text, x20 y100 w90, % hotkeyLabel[language]
Gui, Add, Button, x120 y100 w310 gChangeHotkey vChangeHotkey, %hotkey%
Gui, Add, Text, x20 y140 w90, % modeLabel[language]
Gui, Add, Radio, x120 y140 vHoldMode gModeChange, % holdToClick[language]
Gui, Add, Radio, x120 y160 vToggleMode gModeChange, % toggleToClick[language]

if(mode == 0) {
    GuiControl,, HoldMode, 1
} else {
    GuiControl,, ToggleMode, 1
}

Gui, Add, GroupBox, x10 y330 w440 h90 , % uiSettings[language]
Gui, Add, Button, x20 y350 w400 gToggleTheme vToggleTheme, % StrReplace(toggleThemeLabel[language], "%theme%", theme)
defaultLanguageChoice := languageMapping[language] . selectedLanguageLabel[language]
Gui, Add, DropDownList, x20 y390 w400 vLanguageChoice gLanguageChange, %defaultLanguageChoice%||English|日本語|中文|Русский

Gui, Add, Button, x10 y440 w440 gSaveSettings, % saveSettings[language]

Gui, Add, Button, x10 y480 w210 gOpenGithub, % githubButtonLabel[language]
Gui, Add, Button, x230 y480 w210 gOpenDiscord, % discordButtonLabel[language]

Gui, Add, Text, x10 y520 w440 center, © (Boost Software License 1.0) Knew 2023-2023

Gui, Show, w460 h560, The Knewest Auto-Clicker [v1.1]
WinMove, The Knewest Auto-Clicker [v1.1],, %X%, %Y%

return

HotkeyDown:
    if (!clickLoopRunning) {
        Click
        clickLoopRunning := 1
        SetTimer, ClickLoop, % GetDelayByType(delay, delayType)
    }
    else if (mode) {
        clickLoopRunning := 0
        SetTimer, ClickLoop, Off
    }
return

HotkeyUp:
    if (!mode && clickLoopRunning) {
        clickLoopRunning := 0
        SetTimer, ClickLoop, Off
    }
return

ClickLoop:
    Click
return

ChangeHotkey:
    InputBox, NewHotkey, Change Hotkey, Please press the new hotkey:
    if (NewHotkey != "") {
        Hotkey, ~*%hotkey%, Off
        Hotkey, ~*%hotkey% Up, Off
        hotkey := NewHotkey
        Hotkey, ~*%hotkey%, HotkeyDown, On
        Hotkey, ~*%hotkey% Up, HotkeyUp, On
        GuiControl,, ChangeHotkey, %hotkey%
    }
return

ModeChange:
    GuiControlGet, NewMode,, ToggleMode
    mode := NewMode ? 1 : 0
return

ToggleTheme:
    WinGetPos, X, Y
    Gui, Submit, NoHide
    theme := theme == "Light" ? "Dark" : "Light"
    Gui, Destroy
    Goto, CreateGUI
return

LanguageChange:
    WinGetPos, X, Y
    Gui, Submit, NoHide
    GuiControlGet, selected_text, , LanguageChoice
    for eng, native in languageMapping {
        if (selected_text = (native . selectedLanguageLabel[eng]) || selected_text = native) {
            language := eng
        }
    }
    Gui, Destroy
    Goto, CreateGUI
return

DelayTypeChange:
    GuiControlGet, delayType, , DelayType
return

IniRead, delay, %A_ScriptDir%\settings.ini, Settings, Delay, %defaultDelay%
IniRead, hotkey, %A_ScriptDir%\settings.ini, Settings, Hotkey, %defaultHotkey%
IniRead, mode, %A_ScriptDir%\settings.ini, Settings, Mode, %defaultMode%
IniRead, theme, %A_ScriptDir%\settings.ini, Settings, Theme, %defaultTheme%
IniRead, language, %A_ScriptDir%\settings.ini, Settings, Language, %defaultLanguage%

IniRead, delayTypeEnglish, %A_ScriptDir%\settings.ini, Settings, DelayType, %defaultDelayType%
delayTypeMappingEnglish := {"Milliseconds": "Milliseconds", "Seconds": "Seconds", "Minutes": "Minutes", "Hours": "Hours"}
delayType := delayTypeMappingEnglish[delayTypeEnglish]

SaveSettings:
    Gui, Submit, NoHide
    IniWrite, %delay%, %A_ScriptDir%\settings.ini, Settings, Delay
    IniWrite, %delayType%, %A_ScriptDir%\settings.ini, Settings, DelayType
    IniWrite, %hotkey%, %A_ScriptDir%\settings.ini, Settings, Hotkey
    IniWrite, %mode%, %A_ScriptDir%\settings.ini, Settings, Mode
    IniWrite, %theme%, %A_ScriptDir%\settings.ini, Settings, Theme
    IniWrite, %language%, %A_ScriptDir%\settings.ini, Settings, Language
return

OpenGithub:
    Run, https://github.com/Knewest/the-knewest-auto-clicker
return

OpenDiscord:
    Run, https://discord.gg/NqqqzajfK4
return

GuiClose:
    ExitApp
return

GetDelayByType(Delay, Type){
    If (Type == "Seconds")
        Return Delay * 1000
    Else If (Type == "Minutes")
        Return Delay * 60000
    Else If (Type == "Hours")
        Return Delay * 3600000
    Else
        Return Delay
}


; Version 1.1 of The Knewest Auto-Clicker
; Copyright (Boost Software License 1.0) 2023-2023 Knew
; Link to source: https://github.com/Knewest/the-knewest-auto-clicker
; Support server (Discord): https://discord.gg/NqqqzajfK4
