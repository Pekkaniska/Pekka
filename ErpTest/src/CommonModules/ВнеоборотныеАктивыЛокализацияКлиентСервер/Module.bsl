////////////////////////////////////////////////////////////////////////////////
// Процедуры подсистемы "Внеоборотные активы", предназначенные для локализации.
// 
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

Функция ЭтоНедвижимоеИмущество(ГруппаОС) Экспорт

	Возврат ГруппаОС = ПредопределенноеЗначение("Перечисление.ГруппыОС.Здания")
		ИЛИ ГруппаОС = ПредопределенноеЗначение("Перечисление.ГруппыОС.Сооружения")
		ИЛИ ГруппаОС = ПредопределенноеЗначение("Перечисление.ГруппыОС.МноголетниеНасаждения")
		ИЛИ ГруппаОС = ПредопределенноеЗначение("Перечисление.ГруппыОС.ПрочееИмуществоТребующееГосударственнойРегистрации")
		ИЛИ ГруппаОС = ПредопределенноеЗначение("Перечисление.ГруппыОС.ОбъектыПриродопользования")
		ИЛИ ГруппаОС = ПредопределенноеЗначение("Перечисление.ГруппыОС.ЗемельныеУчастки");

КонецФункции
 
#КонецОбласти
