#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#include UDF.ahk
#IfWinActive AMAZING ONLINE

// Крайне рекомендую подгружать скрипты именно будучи в игре, а не заранее и т.п.
// Так легче защитить себя от крашей

antiCrash() // Немного защиты не помешает ;)

while true
{
    sleep, 500 // Меньше задержки вызывает (вроде) краши из-за частых обращений к памяти. Амазингу это, похоже, не нравится
    hp := getPlayerHealth()
    if (hp < 25)
    {
        addChatMessageEx(0xFFFFFF, "[LowHPWarnings] Внимание! Здоровье опустилось ниже 25 единиц!")
        sleep, 15000
    }
}