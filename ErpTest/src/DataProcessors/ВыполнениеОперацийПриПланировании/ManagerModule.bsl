#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

#Область Команды

// Заполняет список команд создания на основании.
//
// Параметры:
//  КомандыСоздатьНаОсновании	 - ТаблицаЗначений	 - состав полей см. в функции ВводНаОсновании.СоздатьКоллекциюКомандСоздатьНаОсновании.
// 
// Возвращаемое значение:
//  Массив - Список команд.
//
Функция ДобавитьКомандыСозданияНаОсновании(КомандыСоздатьНаОсновании) Экспорт

	СписокКоманд = Новый Массив;
	
	Возврат СписокКоманд;
	
КонецФункции

// Заполняет список команд отчетов.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов.
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов) Экспорт

	ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуСтруктураПодчиненности(КомандыОтчетов);

КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
