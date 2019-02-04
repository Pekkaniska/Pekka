
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗначенияДляВыбора = Неопределено;
	
	Параметры.Свойство("ЗначенияДляВыбора", ЗначенияДляВыбора);	
	
	Если ЗначенияДляВыбора = Неопределено Тогда
		ВызватьИсключение НСтр("ru = 'Не заданы значения для выбора'");
	КонецЕсли;
	
	Для каждого ЭлементКоллекции Из ЗначенияДляВыбора Цикл
		
		НоваяСтрока = Список.Добавить();
		
		НоваяСтрока.Пометка               = ЭлементКоллекции.Пометка;
		НоваяСтрока.ПредставлениеЗначения = ЭлементКоллекции.Представление;
		НоваяСтрока.ИдентификаторЗначения = ЭлементКоллекции.Значение;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	Для каждого ЭлементКоллекции Из Список Цикл
		ЭлементКоллекции.Пометка = Ложь;
	КонецЦикла;
		
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	Для каждого ЭлементКоллекции Из Список Цикл
		ЭлементКоллекции.Пометка = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	
	ВыбранныеЗначения = Новый СписокЗначений;
	
	Для каждого ЭлементКоллекции Из Список Цикл
		Если ЭлементКоллекции.Пометка Тогда
			ВыбранныеЗначения.Добавить(
				ЭлементКоллекции.ИдентификаторЗначения, 
				ЭлементКоллекции.ПредставлениеЗначения,
				ЭлементКоллекции.Пометка);
		КонецЕсли;
	КонецЦикла;
	
	Закрыть(Новый Структура("ВыбранныеЗначения", ВыбранныеЗначения));
	
КонецПроцедуры

#КонецОбласти
