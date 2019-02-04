#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	АдресныйОбъект = Параметры.Идентификатор;
	Если Параметры.Отбор Тогда
		ЗаполнитьСписокДомов(Параметры.Дом);
	Иначе
		ЗаполнитьСписокДомов(Неопределено);
	КонецЕсли;
	
	// позиционирование
	Отбор = Новый Структура("Дом", Параметры.Дом);
	Если ЗначениеЗаполнено(Параметры.ТипСтроения) Тогда
		Если ВРег(Параметры.ТипСтроения) = НСтр("ru = 'КОРПУС'") Тогда
			Отбор.Вставить("Корпус", Параметры.Строение);
			Отбор.Вставить("Строение", "");
		Иначе
			Отбор.Вставить("Строение", Параметры.Строение);
			Отбор.Вставить("Корпус", "");
		КонецЕсли;
	КонецЕсли;
	
	Строки = СписокДомов.НайтиСтроки(Отбор);
	Если Строки.Количество() > 0 Тогда
		Элементы.СписокДомов.ТекущаяСтрока = Строки[0].ПолучитьИдентификатор();
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЭтоМобильныйКлиент() Тогда // Временное решение для работы в мобильном клиенте, будет удалено в следующих версиях
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаВыбрать", "Видимость", Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НайтиОчистка(Элемент, СтандартнаяОбработка)
	СписокДомов.Очистить();
	ЗаполнитьСписокДомов(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура НомерДомаСтроенияАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ТекстПоиска = ?(ПустаяСтрока(Текст), Найти, Текст);
	ПодключитьОбработчикОжидания("НайтиИЗаполнитьСписокДомов", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокДомовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Закрыть(Элементы.СписокДомов.ТекущиеДанные.Значение);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	Если Элементы.СписокДомов.ТекущиеДанные <> Неопределено Тогда
		Закрыть(Элементы.СписокДомов.ТекущиеДанные.Значение);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура НайтиИЗаполнитьСписокДомов()
	ЗаполнитьСписокДомов(ТекстПоиска + "%");
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокДомов(Текст)
	
	СписокДомов.Очистить();
	СтрокаПоиска = ?(ЗначениеЗаполнено(Текст), Текст, "");
	ПорцияПриПоиске = 2000;
	ПолныйСписокДомов = Обработки.РасширенныйВводКонтактнойИнформации.СписокДомов(АдресныйОбъект, СтрокаПоиска, ПорцияПриПоиске);
	Если ПолныйСписокДомов = Неопределено ИЛИ ПолныйСписокДомов.Количество() = 0 Тогда
		Элементы.ФормаВыбрать.Доступность = Ложь;
	Иначе
		СписокДомов.Загрузить(ПолныйСписокДомов);
		Элементы.ФормаВыбрать.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

