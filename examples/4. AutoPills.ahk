#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#include UDF.ahk
#IfWinActive AMAZING ONLINE
#CommentFlag ;

; Крайне рекомендую подгружать скрипты именно будучи в игре, а не заранее и т.п.
; Так легче защитить себя от крашей

antiCrash() ; Немного защиты не помешает ;)

while true
{
    sleep, 500 ; Меньше задержки вызывает (вроде) краши из-за частых обращений к памяти. Амазингу это, похоже, не нравится
    lastLine := getChatLineEx()
    StringLower, lastLine, lastLine
    toCompare := "таблет" ; Конечно, игрок может написать что-то другое, однако это лишь пример
    if (InStr(lastLine, toCompare))
    {
        sendChat("/do История болезни в руках.")
        sleep, 700
        sendChat("Здравствуйте. По сиптомам, записанным в истории болезни, я определил ваш недуг.")
        sleep, 800
        sendChat("/me открыл сумку, висящую на плече")
        sleep, 700
        sendChat("/todo Это должно помочь*протягивая лекарство из сумки")
        sleep, 200
        sendInput, {F6}
        sleep, 50
        sendInput, {Raw}/heal
        sendInput, {Space}
    }
}