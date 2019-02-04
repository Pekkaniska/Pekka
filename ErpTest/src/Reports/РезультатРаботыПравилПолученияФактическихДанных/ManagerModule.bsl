#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

#Область КомандыПодменюОтчеты

// Добавляет команду отчета в список команд.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов.
//
Функция ДобавитьКомандуОтчетаПоСтатьеБюджетов(КомандыОтчетов) Экспорт

	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.РезультатРаботыПравилПолученияФактическихДанных) 
			И ПолучитьФункциональнуюОпцию("ИспользоватьБюджетирование") Тогда
		
		КомандаОтчет = КомандыОтчетов.Добавить();
		
		КомандаОтчет.Менеджер = Метаданные.Отчеты.РезультатРаботыПравилПолученияФактическихДанных.ПолноеИмя();
		КомандаОтчет.Представление = НСтр("ru = 'Результат работы правил'");
		
		КомандаОтчет.МножественныйВыбор = Ложь;
		КомандаОтчет.Важность = "Обычное";
		КомандаОтчет.ДополнительныеПараметры.Вставить("ИмяКоманды", "ПоСтатьеБюджетов");
		КомандаОтчет.КлючВарианта = "РезультатРаботыПравилПоСтатьеБюджетов";
		
		Возврат КомандаОтчет;
		
	КонецЕсли;

	Возврат Неопределено;

КонецФункции

// Добавляет команду отчета в список команд.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов.
//
Функция ДобавитьКомандуОтчетаПоПоказателюБюджетов(КомандыОтчетов) Экспорт

	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.РезультатРаботыПравилПолученияФактическихДанных) 
			И ПолучитьФункциональнуюОпцию("ИспользоватьБюджетирование") Тогда
		
		КомандаОтчет = КомандыОтчетов.Добавить();
		
		КомандаОтчет.Менеджер = Метаданные.Отчеты.РезультатРаботыПравилПолученияФактическихДанных.ПолноеИмя();
		КомандаОтчет.Представление = НСтр("ru = 'Результат работы правил'");
		
		КомандаОтчет.МножественныйВыбор = Ложь;
		КомандаОтчет.Важность = "Обычное";
		КомандаОтчет.ДополнительныеПараметры.Вставить("ИмяКоманды", "ПоПоказателюБюджетов");
		КомандаОтчет.КлючВарианта = "РезультатРаботыПравилПоПоказателюБюджетов";
		
		Возврат КомандаОтчет;
		
	КонецЕсли;

	Возврат Неопределено;

КонецФункции

#КонецОбласти

#КонецОбласти
		
#КонецЕсли