#Область ПрограммныйИнтерфейс

// Функция определяет использование статусов серий вида "Можно указать" для
//  документов государственных информационных систем
//
// Параметры:
//  ПараметрыУказанияСерий - Произвольный - Параметры указания серий.
// 
// Возвращаемое значение:
//  Булево - использование статусов.
//
Функция ИспользоватьСтатусСерийМожноУказать(ПараметрыУказанияСерий) Экспорт
	
	//++ НЕ ГОСИС
	
	//  ПараметрыУказанияСерий - Структура - см НоменклатураКлиентСервер.ПараметрыУказанияСерий.
	Если ПараметрыУказанияСерий.ПолноеИмяОбъекта = "Документ.ВходящаяТранспортнаяОперацияВЕТИС"
		Или ПараметрыУказанияСерий.ПолноеИмяОбъекта = "Документ.ЗапросСкладскогоЖурналаВЕТИС"
		Или ПараметрыУказанияСерий.ПолноеИмяОбъекта = "Документ.ИнвентаризацияПродукцииВЕТИС"
		Или ПараметрыУказанияСерий.ПолноеИмяОбъекта = "Документ.ИсходящаяТранспортнаяОперацияВЕТИС"
		Или ПараметрыУказанияСерий.ПолноеИмяОбъекта = "Документ.ПроизводственнаяОперацияВЕТИС" Тогда
		Возврат Истина;
	КонецЕсли;
	//-- НЕ ГОСИС
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти