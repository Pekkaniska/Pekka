#Область ПрограммныйИнтерфейс

Функция ВидыПодключаемыхКоманд() Экспорт
	
	Результат = Новый Массив;
	Возврат Результат;
	
КонецФункции

#Область КомандыДокументовВЕТИС

Процедура КомандыИсходящейТранспортнойОперации(Команды) Экспорт
	
	//++ НЕ ГОСИС
	ИнтеграцияВЕТИСУТКлиентСервер.КомандыИсходящейТранспортнойОперации(Команды);
	//-- НЕ ГОСИС
	
КонецПроцедуры

Процедура КомандыВходящейТранспортнойОперации(Команды) Экспорт
	
	//++ НЕ ГОСИС
	ИнтеграцияВЕТИСУТКлиентСервер.КомандыВходящейТранспортнойОперации(Команды);
	//-- НЕ ГОСИС
	
КонецПроцедуры

Процедура КомандыПроизводственнойОперации(Команды) Экспорт
	
	//++ НЕ ГОСИС
	ИнтеграцияВЕТИСУТКлиентСервер.КомандыПроизводственнойОперации(Команды);
	//-- НЕ ГОСИС
	
КонецПроцедуры

Процедура КомандыИнвентаризацииПродукции(Команды) Экспорт
	
	//++ НЕ ГОСИС
	ИнтеграцияВЕТИСУТКлиентСервер.КомандыИнвентаризацииПродукции(Команды);
	//-- НЕ ГОСИС
	
КонецПроцедуры


#КонецОбласти

#Область УправлениеВидимостьюКомандВЕТИС

Процедура УправлениеВидимостьюКомандИсходящейТранспортнойОперации(Форма, КомандыОбъекта) Экспорт
	
	//++ НЕ ГОСИС
	ИнтеграцияВЕТИСУТКлиентСервер.УправлениеВидимостьюКомандИсходящейТранспортнойОперации(Форма, КомандыОбъекта);
	//-- НЕ ГОСИС
	
КонецПроцедуры

Процедура УправлениеВидимостьюКомандВходящейТранспортнойОперации(Форма, КомандыОбъекта) Экспорт
	
	//++ НЕ ГОСИС
	ИнтеграцияВЕТИСУТКлиентСервер.УправлениеВидимостьюКомандВходящейТранспортнойОперации(Форма, КомандыОбъекта);
	//-- НЕ ГОСИС
	
КонецПроцедуры

Процедура УправлениеВидимостьюКомандПроизводственнойОперации(Форма, КомандыОбъекта) Экспорт
	
	//++ НЕ ГОСИС
	ИнтеграцияВЕТИСУТКлиентСервер.УправлениеВидимостьюКомандПроизводственнойОперации(Форма, КомандыОбъекта);
	//-- НЕ ГОСИС
	
КонецПроцедуры

Процедура УправлениеВидимостьюКомандИнвентаризацииПродукции(Форма, КомандыОбъекта) Экспорт
	
	//++ НЕ ГОСИС
	ИнтеграцияВЕТИСУТКлиентСервер.УправлениеВидимостьюКомандИнвентаризацииПродукции(Форма, КомандыОбъекта);
	//-- НЕ ГОСИС
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

