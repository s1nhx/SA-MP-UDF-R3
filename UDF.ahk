#CommentFlag //
#include common.ahk

/*

	Пожалуйста, не удаляйте авторов.

*/

/*

	AHK UDF для CR:MP и SA:MP версии 0.3.7 R3: Re-worked ver.


	Перевел, обновил, доработал и отредактировал Снегирев Максим
	..:: vk.com/drygok | vk.com/idDrygok | яМаксим.рф ::..


	Повторно доработал и обновил Яновский Иван
	..:: vk.com/sinhxxx ::..

*/

/*

	Доступные функции:

	*** Функции чтения, связанные с локальным персонажем ***
	- getPlayerHealth()																получить уровень здоровья (HP) игрока
	- getPlayerArmour()																получить уровень брони игрока
	- getPlayerMoney()																получить количество денег игрока
	- getPlayerSkinId()																получить ID скина игрока
	- getPlayerWeaponId()															получить ID оружия в руках
	- getWeaponAmmo()																получить кол-во патрон в текущем оружии

	*** Функции чтения, связанные с текущим транспортом ***
	- isPlayerInAnyVehicle()														проверить, находится ли игрок в транспорте (0 - если игрок не в транспорте, иначе вернется указатель на этот транспорт)
	- getVehicleHealth()															получить уровень здоровья текущего транспорта
	- isPlayerDriver()																проверить, за рулем ли игрок
	- getVehicleColor()																получить ID цветов текущего транспорта (возвращается одномерный массив с первым и вторым цветом)
	- getVehicleSpeed()																получить скорость транспорта

	*** Функции, связанные с координатами ***
	- getCoordinates()																получить координаты игрока или транспорта, в котором находится игрок (возвращается одномерный массив [X, Y, Z])
	- getPlayerCoordinates()														получить координаты игрока (возвращается одномерный массив [X, Y, Z])
	- getCameraCoordinates()														получить координаты камеры (возвращается одномерный массив [X, Y, Z])

	*** Функции, связанные с модулем мультиплеера ***
	- addChatMessageEx(color, text)													отправить сообщение в локальный чат (вывести самому себе)
	- sendChat(text)																отправить сообщение/команду в чат
	- isInChat()																	проверить, открыт ли чат у пользователя скрипта (true - чат открыт, false - чат закрыт)
	- getChatLineEx(line := 0)														получить заданную строку в чате (по стандарту: самая новая, нулевая)

	*** Функции, связанные с процессом самой игры ***
	- setWeather(id := 1)															визуально устанавливает погоду (сбрасывается после каждого входа/выхода в интерьер)
	- getWeather()																	получить ID текущей погоды
	- getGameScreenWidthHeight()													получить разрешение экрана (массив из двух элементов: длина и ширина соответственно)
	- antiCrash()																	(надеюсь) предотвращает некоторые игровые ошибки, уменьшая кол-во крашей
*/


// Если Вы не понимаете, что делаете - дальше путь закрыт. Ниже идет РЕАЛИЗАЦИЯ функций, трогать это не стоит.

// Функции чтения, связанные с локальным игроком
getPlayerHealth() {
	return Round(readFloat(hGTA, readDWORD(hGTA, 0xB6F5F0) + 0x540))
}

getPlayerArmour() {
	return Round(readFloat(hGTA, readDWORD(hGTA, 0xB6F5F0) + 0x548)) // Round()?
}

getPlayerMoney() {
	return readDWORD(hGTA, 0x0B7CE54)
}

getPlayerSkinId() {
	return readMem(hGTA, readDWORD(hGTA, 0xB6F5F0) + 0x22, 2, "byte")
}

getPlayerWeaponId() {
	return readDWORD(hGTA, 0xBAA410)
}

getWeaponAmmo()
{
	Ammo := 0
	slot := -1
    if(!CPed := readDWORD(hGTA, 0xB6F5F0))
        return -1
    if slot not between 0 and 12
    {
        VarSetCapacity(slot, 1)
        DllCall("ReadProcessMemory", "UInt", hGTA, "UInt", CPed + 0x718, "Str", slot, "UInt", 1, "UInt*", 0)
        slot := NumGet(slot, 0, "short")
        if slot >= 12544
            slot -= 12544
    }
    struct := CPed + 0x5AC
    VarSetCapacity(Ammo, 4)
    DllCall("ReadProcessMemory", "UInt", hGTA, "UInt", struct + (0x1C * slot), "Str", Ammo, "UInt", 4, "UInt*", 0)
    return NumGet(Ammo, 0, "int")
}

// Функции чтения, связанные с текущим транспортом
isPlayerInAnyVehicle() {
	return readDWORD(hGTA, 0xBA18FC)
}

getVehicleHealth() {
	return readFloat(hGTA, readDWORD(hGTA, 0xBA18FC) + 0x4C0)
}

isPlayerDriver() {
	return (readDWORD(hGTA, readDWORD(hGTA, 0xBA18FC) + 0x460) == readDWORD(hGTA, 0xB6F5F0))
}

getVehicleColor() {
	dwAddress := isPlayerInAnyVehicle()
	if (dwAddress == 0) {
		return -1
	}
	return [readMem(hGTA, dwAddress + 1076, 1, "byte"), readMem(hGTA, dwAddress + 1077, 1, "byte")]
}

getVehicleSpeed() {
	dwAddress := isPlayerInAnyVehicle()
	if (dwAddress == 0) {
		return -1
	}
	fSpeedX := readMem(hGTA, dwAddress + 0x44, 4, "float")
	fSpeedY := readMem(hGTA, dwAddress + 0x48, 4, "float")
	fSpeedZ := readMem(hGTA, dwAddress + 0x4C, 4, "float")

	fVehicleSpeed := sqrt((fSpeedX * fSpeedX) + (fSpeedY * fSpeedY) + (fSpeedZ * fSpeedZ))
	fVehicleSpeed := (fVehicleSpeed * 100) * 1.43

	return Round(fVehicleSpeed)
}

// Функции, связанные с координатами
getCoordinates() {
	dwAddress := isPlayerInAnyVehicle()
	if (dwAddress == 0)
		dwAddress := readDWORD(hGTA, 0xB6F5F0)
	dwAddress := readDWORD(hGTA, dwAddress + 0x14)

	return [readFloat(hGTA, dwAddress + 0x30), readFloat(hGTA, dwAddress + 0x34), readFloat(hGTA, dwAddress + 0x38)]
}

getPlayerCoordinates() {
	dwAddress := readDWORD(hGTA, readDWORD(hGTA, 0xB6F5F0) + 0x14)

	return [readFloat(hGTA, dwAddress + 0x30), readFloat(hGTA, dwAddress + 0x34), readFloat(hGTA, dwAddress + 0x38)]
}

getCameraCoordinates() {
	return [readFloat(hGTA, 0xB6F9CC), readFloat(hGTA, 0xB6F9D0), readFloat(hGTA, 0xB6F9D4)]
}

// Функции, связанные с модулем мультиплеера
addChatMessageEx(color, text) {
	if(!checkHandles())
		return -1

	VarSetCapacity(data2, 4, 0)
	NumPut(HexToDec(color), data2, 0, "Int")

	dwAddress := readDWORD(hGTA, dwSAMP + 0x26E8C8)
	VarSetCapacity(data1, 4, 0)
	NumPut(readDWORD(hGTA, dwAddress + 0x4), data1, 0, "Int")
	WriteRaw(hGTA, dwAddress + 0x4, &data2, 4)

	callWithParams(hGTA, dwSAMP + 0x67970, [["p", readDWORD(hGTA, dwSAMP + 0x26E8C8)], ["s", "" text]], true)
	WriteRaw(hGTA, dwAddress + 0x4, &data1, 4)
}

sendChat(text) {
	if(!checkHandles())
		return -1

	dwFunc := 0
	if (SubStr(text, 1, 1) == "/")
	{
		dwFunc := dwSAMP + 0x69190
	}
	else
	{
		dwFunc := dwSAMP + 0x5820
	}

	callWithParams(hGTA, dwFunc, [["s", "" text]], false)
}

isInChat() {
	return (readDWORD(hGTA, readDWORD(hGTA, dwSAMP + 0x26E8F4) + 0x61) > 0)
}

getChatLineEx(line := 0) {
    return readString(hGTA, readDWORD(hGTA, dwSAMP + 0x26E8C8) + 0x152 + ((99-line) * 0xFC), 0xFC)
}

// Функции, связанные с процессом самой игры
setWeather(id := 1) {
	VarSetCapacity(weather, 1, 0)
	NumPut(id, weather, 0, "Int")
	writeRaw(hGTA, 0xC81320, &weather, 1)
}

getWeather() {
    return readMem(hGTA, 0xC81320, 2, "byte")
}

getGameScreenWidthHeight() {
    return [readDword(hGTA, 0xC9C040), readDword(hGTA, 0xC9C044)]
}

antiCrash() {
    cReport := 0x5D00C
    writeMemory(hGTA, dwSAMP + cReport, 0x90909090, 4)
    cReport += 0x4
    writeMemory(hGTA, dwSAMP + cReport, 0x90, 1)
    cReport += 0x9
    writeMemory(hGTA, dwSAMP + cReport, 0x90909090, 4)
    cReport += 0x4
    writeMemory(hGTA, dwSAMP + cReport, 0x90, 1)
}

checkHandles() // Лучше сразу обновить переменные