
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	Если Параметры.Свойство("МассивГруппПродукции") Тогда
		СписокГруппПродукции.ЗагрузитьЗначения(Параметры.МассивГруппПродукции);
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаГруппыПродукции;
		Заголовок = НСтр("ru = 'Список групп (видов) продукции'")
	ИначеЕсли Параметры.Свойство("МассивМатериалов") Тогда
		СписокМатериалов.ЗагрузитьЗначения(Параметры.МассивМатериалов);
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаМатериалы;
		Заголовок = НСтр("ru = 'Список материалов'")
	ИначеЕсли Параметры.Свойство("МассивВидовРабот") Тогда
		СписокВидовРабот.ЗагрузитьЗначения(Параметры.МассивВидовРабот);
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаВидыРабот;
		Заголовок = НСтр("ru = 'Список видов работ сотрудников'")
	ИначеЕсли Параметры.Свойство("МассивПодразделений") Тогда
		СписокПодразделений.ЗагрузитьЗначения(Параметры.МассивПодразделений);
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаПодразделения;
		Заголовок = НСтр("ru = 'Список подразделений'");
	ИначеЕсли Параметры.Свойство("МассивПродукции") Тогда
		СписокПродукции.ЗагрузитьЗначения(Параметры.МассивПродукции);
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаПродукция;
		Заголовок = НСтр("ru = 'Список продукции'")		
	Иначе
		Элементы.Страницы.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.СписокГруппПродукцииЗначение.ВыборГруппИЭлементов = ГруппыИЭлементы.Элементы;
	Элементы.СписокПродукцииЗначение.ВыборГруппИЭлементов = ГруппыИЭлементы.Элементы;
	Элементы.СписокМатериаловЗначение.ВыборГруппИЭлементов = ГруппыИЭлементы.Элементы;
	
	МассивТиповНоменклатуры = Новый Массив;
	МассивТиповНоменклатуры.Добавить(Перечисления.ТипыНоменклатуры.Товар);
	МассивТиповНоменклатуры.Добавить(Перечисления.ТипыНоменклатуры.Работа);
	
	НовыйПараметр = Новый ПараметрВыбора("Отбор.ТипНоменклатуры", Новый ФиксированныйМассив(МассивТиповНоменклатуры));
	НовыйМассив = Новый Массив();
	НовыйМассив.Добавить(НовыйПараметр);
	НовыеПараметры = Новый ФиксированныйМассив(НовыйМассив);
	
	Элементы.СписокПродукцииЗначение.ПараметрыВыбора = НовыеПараметры;
	
	МассивТиповНоменклатуры.Добавить(Перечисления.ТипыНоменклатуры.МногооборотнаяТара);
	
	НовыйПараметр = Новый ПараметрВыбора("Отбор.ТипНоменклатуры", Новый ФиксированныйМассив(МассивТиповНоменклатуры));
	НовыйМассив = Новый Массив();
	НовыйМассив.Добавить(НовыйПараметр);
	НовыеПараметры = Новый ФиксированныйМассив(НовыйМассив);
	
	Элементы.СписокМатериаловЗначение.ПараметрыВыбора = НовыеПараметры;
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиВСправочник(Команда)
	
	МассивДанных = Новый Массив;
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаГруппыПродукции Тогда
		СписокДанных = СписокГруппПродукции;
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаМатериалы Тогда
		СписокДанных = СписокМатериалов;
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаВидыРабот Тогда
		СписокДанных = СписокВидовРабот;
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаПодразделения Тогда
		СписокДанных = СписокПодразделений;
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаПродукция Тогда
		СписокДанных = СписокПродукции;
	КонецЕсли;
	Для Каждого Элемент Из СписокДанных Цикл
		Если МассивДанных.Найти(Элемент.Значение) = Неопределено
			И ЗначениеЗаполнено(Элемент.Значение) Тогда
			МассивДанных.Добавить(Элемент.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Закрыть(МассивДанных);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти
