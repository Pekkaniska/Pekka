// Добавляет команду отчета в список команд.
//
// Параметры:
//	КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов.
//
Функция ДобавитьКомандуОтчета(КомандыОтчетов) Экспорт
	
	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.ТоварыВЯчейках) Тогда
		
		КомандаОтчет = КомандыОтчетов.Добавить();
		
		КомандаОтчет.Менеджер = Метаданные.Отчеты.ТоварыВЯчейках.ПолноеИмя();
		КомандаОтчет.Представление = НСтр("ru= 'Товары в ячейках'");
		
		
		КомандаОтчет.Важность = "Обычное";
		КомандаОтчет.МножественныйВыбор = Ложь;
		
		КомандаОтчет.ДополнительныеПараметры.Вставить("ИмяКоманды", "ПоНоменклатуре");
		
		КомандаОтчет.КлючВарианта = "ПоНоменклатуреКонтекст";
		
		Возврат КомандаОтчет;
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Добавляет команду отчета в список команд.
//
// Параметры:
//	КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов.
//
Функция ДобавитьКомандуОтчетаДвиженияТовара(КомандыОтчетов) Экспорт
	
	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.ТоварыВЯчейках) Тогда
		
		КомандаОтчет = КомандыОтчетов.Добавить();
		
		КомандаОтчет.Менеджер = Метаданные.Отчеты.ТоварыВЯчейках.ПолноеИмя();
		КомандаОтчет.Представление = НСтр("ru= 'Движения товара в ячейках'");
		
		
		КомандаОтчет.Важность = "Обычное";
		КомандаОтчет.МножественныйВыбор = Ложь;
		
		КомандаОтчет.ДополнительныеПараметры.Вставить("ИмяКоманды", "ПоНоменклатуре");
		
		КомандаОтчет.КлючВарианта = "ДвиженияТоваровВЯчейкеКонтекст";
		
		Возврат КомандаОтчет;
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции
