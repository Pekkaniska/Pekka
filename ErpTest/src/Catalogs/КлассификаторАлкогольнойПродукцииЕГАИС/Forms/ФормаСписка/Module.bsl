#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ИнтеграцияЕГАИСПереопределяемый.НастроитьПодключаемоеОборудование(ЭтотОбъект);
	
	Поля = Новый Массив;
	Поля.Добавить("Сопоставлено");
	
	Список.УстановитьОграниченияИспользованияВГруппировке(Поля);
	Список.УстановитьОграниченияИспользованияВОтборе(Поля);
	Список.УстановитьОграниченияИспользованияВПорядке(Поля);
	
	СобытияФормЕГАИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтаФорма, "СканерШтрихкода");
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтаФорма);
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
	Если ИмяСобытия = "ИзменениеСопоставленияАлкогольнойПродукцииЕГАИС" Тогда
		
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("ПоискПоШтрихкодуЗавершение", ЭтотОбъект);
	
	СобытияФормЕГАИСКлиент.ВнешнееСобытиеПолученыШтрихкоды(
		ОповещениеПриЗавершении, ЭтотОбъект, Источник, Событие, Данные);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле = Элементы.Сопоставлено Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ТекущиеДанные = Элементы.Список.ТекущиеДанные;
		
		ИнтеграцияЕГАИСКлиент.ОткрытьФормуСопоставленияАлкогольнойПродукции(
			ТекущиеДанные.Ссылка,
			ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	Запрос = Новый Запрос();
	Запрос.Текст = Справочники.КлассификаторАлкогольнойПродукцииЕГАИС.ТекстЗапросаИнформацияОСопоставлении();
	Запрос.УстановитьПараметр("АлкогольнаяПродукция", Строки.ПолучитьКлючи());
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		СтрокаСписка = Строки[Выборка.Ссылка];
		
		Если Выборка.Количество = 1 Тогда
			СтрокаСписка.Данные["Сопоставлено"] = ИнтеграцияЕГАИСПереопределяемый.ПредставлениеНоменклатуры(
				Выборка.Номенклатура,
				Выборка.Характеристика, Неопределено);
			СтрокаСписка.Оформление["Сопоставлено"].УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветГиперссылкиГИСМ);
		ИначеЕсли Выборка.Количество > 1 Тогда
			Если СтрДлина(Выборка.НоменклатураНаименование) > 45 Тогда 
				СтрокаКоличество = СтрШаблон(НСтр("ru = '( + еще %1)'"), Выборка.Количество - 1);
				ДлинаНаименования = 45 - СтрДлина(СтрокаКоличество);
				СтрокаСписка.Данные["Сопоставлено"] = Лев(Выборка.НоменклатураНаименование, ДлинаНаименования) + "... " + СтрокаКоличество;
			Иначе
				СтрокаСписка.Данные["Сопоставлено"] = СтрШаблон(НСтр("ru = '%1 ( + еще %2...)'"), Выборка.НоменклатураНаименование, Выборка.Количество - 1);
			КонецЕсли;
			СтрокаСписка.Оформление["Сопоставлено"].УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветГиперссылкиГИСМ);
		Иначе
			СтрокаСписка.Данные["Сопоставлено"] = НСтр("ru = '<Не сопоставлено>'");
			СтрокаСписка.Оформление["Сопоставлено"].УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЕГАИССтатусОбработкиОшибкаПередачи);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоискПоШтрихкодуВыполнить(Команда)
	
	ОчиститьСообщения();
	
	ШтрихкодированиеНоменклатурыЕГАИСКлиентПереопределяемый.ПоказатьВводШтрихкода(
		Новый ОписаниеОповещения("ОбработатьВводШтрихкода", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВводШтрихкода(ДанныеШтрихкода, ДополнительныеПараметры) Экспорт
	
	ПараметрыСканирования = АкцизныеМаркиКлиентСервер.ПараметрыСканированияАкцизныхМарок(ЭтотОбъект);
	ПараметрыСканирования.ЗапрашиватьНоменклатуру = Ложь;
	
	АкцизныеМаркиЕГАИСКлиент.ОбработатьДанныеШтрихкода(
		Новый ОписаниеОповещения("ПоискПоШтрихкодуЗавершение", ЭтотОбъект),
		ЭтотОбъект, ДанныеШтрихкода, ПараметрыСканирования);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкодуЗавершение(ДанныеШтрихкода, ДополнительныеПараметры) Экспорт
	
	Если ДанныеШтрихкода = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ДанныеШтрихкода.ТипШтрихкода = ПредопределенноеЗначение("Перечисление.ТипыШтрихкодов.PDF417") Тогда
		
		Если Не ЗначениеЗаполнено(ДанныеШтрихкода.АлкогольнаяПродукция)
			И ЗначениеЗаполнено(ДанныеШтрихкода.КодАлкогольнойПродукции) Тогда
			
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("Операция",          ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросАлкогольнойПродукции"));
			ПараметрыФормы.Вставить("ИмяПараметра",      "КОД");
			ПараметрыФормы.Вставить("ЗначениеПараметра", ДанныеШтрихкода.КодАлкогольнойПродукции);
			
			ОткрытьФорму(
				"ОбщаяФорма.ФормированиеИсходящегоЗапросаЕГАИС",
				ПараметрыФормы,
				ЭтотОбъект,,,,,
				РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			
		ИначеЕсли ЗначениеЗаполнено(ДанныеШтрихкода.АлкогольнаяПродукция) Тогда
			
			Элементы.Список.ТекущаяСтрока = ДанныеШтрихкода.АлкогольнаяПродукция;
			
		Иначе
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтрШаблон(
					НСтр("ru = 'По коду акцизной марки %1 не удалось определить код алкогольной продукции'"),
					ДанныеШтрихкода.Штрихкод));
			
		КонецЕсли;
		
	ИначеЕсли ДанныеШтрихкода.ТипУпаковки = ПредопределенноеЗначение("Перечисление.ТипыУпаковок.МаркированныйТовар") Тогда
		
		Если ЗначениеЗаполнено(ДанныеШтрихкода.АлкогольнаяПродукция) Тогда
			
			Элементы.Список.ТекущаяСтрока = ДанныеШтрихкода.АлкогольнаяПродукция;
			
		Иначе
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтрШаблон(
					НСтр("ru = 'Марке по штрихкоду %1 не сопоставлена алкогольная продукция'"),
					ДанныеШтрихкода.Штрихкод));
			
		КонецЕсли;
		
	ИначеЕсли ДанныеШтрихкода.ТипШтрихкода = ПредопределенноеЗначение("Перечисление.ТипыШтрихкодов.DataMatrix") Тогда
		
		Если ЗначениеЗаполнено(ДанныеШтрихкода.АлкогольнаяПродукция) Тогда
			
			Элементы.Список.ТекущаяСтрока = ДанныеШтрихкода.АлкогольнаяПродукция;
			
		ИначеЕсли ДанныеШтрихкода.Справки2.Количество() > 0 Тогда
			
			СписокСсылок = Новый СписокЗначений;
			Для Каждого ДанныеСправки2 Из ДанныеШтрихкода.Справки2 Цикл
				СписокСсылок.Добавить(ДанныеСправки2.АлкогольнаяПродукция);
			КонецЦикла;
			
			ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список, "Ссылка");
			
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
				Список,
				"Ссылка",
				СписокСсылок,
				ВидСравненияКомпоновкиДанных.ВСписке,,
				Истина,
				РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ);
				
		Иначе
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтрШаблон(
					НСтр("ru = 'По штрихкоду %1 не удалось найти справку 2'"),
					ДанныеШтрихкода.Штрихкод));
			
		КонецЕсли;
		
	Иначе
		
		РезультатПоиска = ПолучитьДанныеПоШтрихкоду(ДанныеШтрихкода.Штрихкод);
		Если РезультатПоиска <> Неопределено Тогда
			Элементы.Список.ТекущаяСтрока = РезультатПоиска.АлкогольнаяПродукция;
		Иначе
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтрШаблон(
					НСтр("ru = 'По штрихкоду %1 не удалось найти алкогольную продукцию'"),
					ДанныеШтрихкода.Штрихкод));
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДанныеПоШтрихкоду(Штрихкод)
	
	Возврат ШтрихкодированиеНоменклатурыЕГАИСПереопределяемый.НайтиПоШтрихкоду(Штрихкод);
	
КонецФункции

#КонецОбласти