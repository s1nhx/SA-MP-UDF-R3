#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#include UDF.ahk
#IfWinActive AMAZING ONLINE
#CommentFlag ;

; Крайне рекомендую подгружать скрипты именно будучи в игре, а не заранее и т.п.
; Так легче защитить себя от крашей

antiCrash() ; Немного защиты не помешает ;)

:?:/weather::
addChatMessageEx(0xFFFFFF, "Наберите номер погоды на клавиатуре. Управление отключено на 3 секунды.")
Input, UserInput, T3
numbersOnly := RegExReplace(UserInput, "[^\d]", "") ; Убираем буквы со строки из набранных клавиш
if (StrLen(numbersOnly) > 1) ; Если число оказалось двузначным..
{
    extracted := SubStr(numbersOnly, 1, 1) ; Обрезаем его до двузначного значения
}
setWeather(+numbersOnly) ; + перед переменной указывает ей тип данных int
addChatMessageEx(0xFFFFFF, "Установленная погода: " . +numbersOnly)