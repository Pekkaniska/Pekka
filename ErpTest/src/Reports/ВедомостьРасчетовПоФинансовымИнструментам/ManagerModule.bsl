#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Добавляет команду отчета в список команд.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов.
//
Функция ДобавитьКомандуОтчета(КомандыОтчетов) Экспорт
	
	Результат = Неопределено;
	
	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.ВедомостьРасчетовПоФинансовымИнструментам) Тогда
		
		КомандаОтчет = КомандыОтчетов.Добавить();
		КомандаОтчет.Менеджер = Метаданные.Отчеты.ВедомостьРасчетовПоФинансовымИнструментам.ПолноеИмя();
		КомандаОтчет.Представление = НСтр("ru = 'Ведомость расчетов'");
		КомандаОтчет.МножественныйВыбор = Истина;
		КомандаОтчет.Важность = "Обычное";
		КомандаОтчет.КлючВарианта = "ВедомостьРасчетовПоФинансовымИнструментамКонтекст";
		Результат = КомандаОтчет;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли