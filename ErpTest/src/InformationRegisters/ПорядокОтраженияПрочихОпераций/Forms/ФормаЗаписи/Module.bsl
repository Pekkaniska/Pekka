
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Запись, ЭтотОбъект);

	ПриЧтенииСозданииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриЧтенииСозданииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ПорядокОтраженияПрочихОпераций");
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Запись.Субконто1 = Субконто1;
	Запись.Субконто2 = Субконто2;
	Запись.Субконто3 = Субконто3;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СчетУчетаПриИзменении(Элемент)
	
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура Субконто1ПриИзменении(Элемент)
	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Субконто2ПриИзменении(Элемент)
	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Субконто3ПриИзменении(Элемент)
	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Субконто1НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СпособыСубконтоНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Субконто2НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СпособыСубконтоНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Субконто3НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СпособыСубконтоНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	УправлениеЭлементамиФормы();
	ПолучитьПредставлениеСтрокиДокумента();
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура УправлениеЭлементамиФормы()
	
	ПоляФормы = Новый Структура(
		"Субконто1, Субконто2, Субконто3",
		"Субконто1", "Субконто2", "Субконто3");
	ЗаголовкиПолей = Новый Структура(
		"Субконто1, Субконто2, Субконто3",
	    "ЗаголовокСубконто1", "ЗаголовокСубконто2", "ЗаголовокСубконто3");
	БухгалтерскийУчетКлиентСервер.ПриВыбореСчета(Запись.СчетУчета, ЭтаФорма, ПоляФормы, ЗаголовкиПолей);
	
	Субконто1 = Запись.Субконто1;
	Субконто2 = Запись.Субконто2;
	Субконто3 = Запись.Субконто3;
	
	МассивЭлементов = Новый Массив;
	МассивЭлементов.Добавить("Субконто1");
	МассивЭлементов.Добавить("Субконто2");
	МассивЭлементов.Добавить("Субконто3");
	
	Для Каждого ЭлементФормы Из МассивЭлементов Цикл
		Элементы[ЭлементФормы].Видимость = Элементы[ЭлементФормы].Доступность;
		Элементы["Заголовок" + ЭлементФормы].Видимость = Элементы[ЭлементФормы].Доступность;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьПредставлениеСтрокиДокумента()
	
	ТипЗначения = ТипЗнч(Запись.Документ);
#Область РасходныйКассовыйОрдер
	Если ТипЗначения = Тип("ДокументСсылка.РасходныйКассовыйОрдер") Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДанныеДокумента.Контрагент.Представление КАК КонтрагентПредставление,
		|	ДанныеДокумента.СтатьяДвиженияДенежныхСредств.Представление КАК СтатьяПредставление,
		|	ДанныеДокумента.Валюта.Представление КАК ВалютаПредставление,
		|	ДанныеДокумента.СуммаДокумента
		|ИЗ
		|	Документ.РасходныйКассовыйОрдер КАК ДанныеДокумента
		|ГДЕ
		|	ДанныеДокумента.Ссылка = &Ссылка";
		Запрос.УстановитьПараметр("Ссылка", Запись.Документ);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			ТекстПредставлениеСтрокиДокумента = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Контрагент: %1; Статья ДДС: %2; Сумма: %3 %4'"),
				Выборка.КонтрагентПредставление,
				Выборка.СтатьяПредставление,
				Выборка.СуммаДокумента,
				Выборка.ВалютаПредставление);
		КонецЕсли;
	КонецЕсли;
#КонецОбласти

#Область ВнутреннееПотреблениеТоваров
	Если ТипЗначения = Тип("ДокументСсылка.ВнутреннееПотреблениеТоваров") Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Строки.НомерСтроки КАК НомерСтроки,
		|	Строки.Номенклатура КАК Номенклатура,
		|	Строки.Характеристика КАК Характеристика
		|ИЗ
		|	Документ.ВнутреннееПотреблениеТоваров.Товары КАК Строки
		|ГДЕ
		|	Строки.Ссылка = &Ссылка
		|	И Строки.ИдентификаторСтроки = &ИдентификаторСтроки";
		Запрос.УстановитьПараметр("Ссылка", Запись.Документ);
		Запрос.УстановитьПараметр("ИдентификаторСтроки", Запись.ИдентификаторСтроки);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			НоменклатураПредставление = НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати(
				Выборка.Номенклатура,
				Выборка.Характеристика);
			ТекстПредставлениеСтрокиДокумента = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Строка: %1, %2'"),
				Выборка.НомерСтроки,
				НоменклатураПредставление);
		КонецЕсли;
	КонецЕсли;
#КонецОбласти

#Область ПриобретениеУслугПрочихАктивов
	Если ТипЗначения = Тип("ДокументСсылка.ПриобретениеУслугПрочихАктивов") Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТаблицаРасходы.НомерСтроки КАК НомерСтроки,
		|	ТаблицаРасходы.Содержание КАК Содержание
		|ИЗ
		|	Документ.ПриобретениеУслугПрочихАктивов.Расходы КАК ТаблицаРасходы
		|ГДЕ
		|	ТаблицаРасходы.Ссылка = &Ссылка
		|	И ТаблицаРасходы.ИдентификаторСтроки = &ИдентификаторСтроки";
		Запрос.УстановитьПараметр("Ссылка", Запись.Документ);
		Запрос.УстановитьПараметр("ИдентификаторСтроки", Запись.ИдентификаторСтроки);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			ТекстПредставлениеСтрокиДокумента = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Строка: %1, %2'"),
				Выборка.НомерСтроки,
				Выборка.Содержание);
		КонецЕсли;
	КонецЕсли;
#КонецОбласти

#Область ПрочиеДоходыРасходы
	Если ТипЗначения = Тип("ДокументСсылка.ПрочиеДоходыРасходы") Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Строки.НомерСтроки КАК НомерСтроки,
		|	Строки.СтатьяРасходов КАК СтатьяДоходовРасходов,
		|	Строки.СтатьяАктивовПассивов КАК СтатьяАктивовПассивов
		|ИЗ
		|	Документ.ПрочиеДоходыРасходы.ПрочиеРасходы КАК Строки
		|ГДЕ
		|	Строки.Ссылка = &Ссылка
		|	И Строки.ИдентификаторСтроки = &ИдентификаторСтроки
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Строки.НомерСтроки КАК НомерСтроки,
		|	Строки.СтатьяДоходов КАК СтатьяДоходовРасходов,
		|	Строки.СтатьяАктивовПассивов КАК СтатьяАктивовПассивов
		|ИЗ
		|	Документ.ПрочиеДоходыРасходы.ПрочиеДоходы КАК Строки
		|ГДЕ
		|	Строки.Ссылка = &Ссылка
		|	И Строки.ИдентификаторСтроки = &ИдентификаторСтроки";
		Запрос.УстановитьПараметр("Ссылка", Запись.Документ);
		Запрос.УстановитьПараметр("ИдентификаторСтроки", Запись.ИдентификаторСтроки);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			ТекстПредставлениеСтрокиДокумента = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Строка: %1, %2, %3'"),
				Выборка.НомерСтроки,
				Выборка.СтатьяДоходовРасходов,
				Выборка.СтатьяАктивовПассивов);
		КонецЕсли;			
	КонецЕсли;
#КонецОбласти
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма)
	
	ПараметрыЗаписи = ПолучитьСписокПараметров(ЭтаФорма, "Субконто%Индекс%");
	БухгалтерскийУчетКлиентСервер.ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, ЭтаФорма, "Субконто%Индекс%", "Субконто%Индекс%", ПараметрыЗаписи); 
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьСписокПараметров(ЭтаФорма, ШаблонИмяПоляОбъекта)
	
	СписокПараметров = Новый Структура;
	Для Индекс = 1 По 3 Цикл
		ИмяПоля = СтрЗаменить(ШаблонИмяПоляОбъекта, "%Индекс%", Индекс);
		Если ТипЗнч(ЭтаФорма[ИмяПоля]) = Тип("СправочникСсылка.Контрагенты") Тогда
			СписокПараметров.Вставить("Контрагент", ЭтаФорма[ИмяПоля]);
		ИначеЕсли БухгалтерскийУчетКлиентСерверПереопределяемый.ПолучитьОписаниеТиповДоговора().СодержитТип(ТипЗнч(ЭтаФорма[ИмяПоля])) Тогда
			СписокПараметров.Вставить("ДоговорКонтрагента", ЭтаФорма[ИмяПоля]);
		ИначеЕсли ТипЗнч(ЭтаФорма[ИмяПоля]) = Тип("СправочникСсылка.Номенклатура") Тогда
			СписокПараметров.Вставить("Номенклатура", ЭтаФорма[ИмяПоля]);
		ИначеЕсли ТипЗнч(ЭтаФорма[ИмяПоля]) = Тип("СправочникСсылка.Склады") Тогда
			СписокПараметров.Вставить("Склад", ЭтаФорма[ИмяПоля]);
		КонецЕсли;
	КонецЦикла;
	
	Запись = ЭтаФорма.Запись;
	СписокПараметров.Вставить("Организация", Запись.Организация);
	СписокПараметров.Вставить("СчетУчета",   Запись.СчетУчета);
	
	Возврат СписокПараметров;
	
КонецФункции

&НаКлиенте
Процедура СпособыСубконтоНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПараметрыЗаписи = ПолучитьСписокПараметров(ЭтаФорма, "Субконто%Индекс%");
	ОбщегоНазначенияБПКлиент.НачалоВыбораЗначенияСубконто(ЭтаФорма, Элемент, СтандартнаяОбработка, ПараметрыЗаписи);

КонецПроцедуры

#КонецОбласти

#КонецОбласти
