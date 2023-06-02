#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#include UDF.ahk
#IfWinActive AMAZING ONLINE

// Крайне рекомендую подгружать скрипты именно будучи в игре, а не заранее и т.п.
// Так легче защитить себя от крашей

antiCrash() // Немного защиты не помешает ;)

while true
{
    sleep, 500 // Меньше задержки вызывает (вроде) краши из-за частых обращений к памяти. Амазингу это, похоже, не нравится
    weapId := getPlayerWeaponId()
    if (weapId = 24)
    {
        weapAmmo := getWeaponAmmo()
        if (weapAmmo <= 10)
        {
            sendChat("/de 10")
        }
    }
}