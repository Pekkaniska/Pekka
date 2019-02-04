
&НаКлиенте
Процедура ОсновныеДействияФормыОК(Команда)
	спрРейсСсылка=ОсновныеДействияФормыОК_Сервер();
	Закрыть(спрРейсСсылка);	
КонецПроцедуры

&НаСервере
Функция ОсновныеДействияФормыОК_Сервер()
	Если ЭтоНовый Тогда
		спрРейс 		= Справочники.уатРейсыМаршрутов.СоздатьЭлемент();
		спрРейс.Код 	= НомерРейса;
		спрРейс.Владелец = Маршрут;
	Иначе
		спрРейс 	= Рейс.ПолучитьОбъект();
		спрРейс.Код = НомерРейса;
	КонецЕсли;
	
	спрРейс.Записать();
	Возврат спрРейс.Ссылка;
КонецФункции

&НаКлиенте
Процедура ОсновныеДействияФормыОтмена(Команда)
	Закрыть();
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("Маршрут") Тогда
		Маршрут = Параметры.Маршрут;
	КонецЕсли;
	Если Параметры.Свойство("Рейс") Тогда
		Рейс = Параметры.Рейс;
		НомерРейса = Рейс.Код;
	КонецЕсли;
	Если Параметры.Свойство("ЭтоНовый") Тогда
		ЭтоНовый = Параметры.ЭтоНовый;
	КонецЕсли;
	Заголовок = ?(ЭтоНовый, "Добавить рейс", "Изменить рейс");
КонецПроцедуры
