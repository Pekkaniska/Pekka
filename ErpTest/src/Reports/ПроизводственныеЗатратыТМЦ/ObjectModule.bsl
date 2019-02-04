
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.События.ПередЗагрузкойНастроекВКомпоновщик = Истина;
КонецПроцедуры

// Вызывается перед загрузкой новых настроек. Используется для изменения схемы компоновки.
//   Например, если схема отчета зависит от ключа варианта или параметров отчета.
//   Чтобы изменения схемы вступили в силу следует вызывать метод ОтчетыСервер.ПодключитьСхему().
//
// Параметры:
//   Контекст - Произвольный - 
//       Параметры контекста, в котором используется отчет.
//       Используется для передачи в параметрах метода ОтчетыСервер.ПодключитьСхему().
//   КлючСхемы - Строка -
//       Идентификатор текущей схемы компоновщика настроек.
//       По умолчанию не заполнен (это означает что компоновщик инициализирован на основании основной схемы).
//       Используется для оптимизации, чтобы переинициализировать компоновщик как можно реже).
//       Может не использоваться если переинициализация выполняется безусловно.
//   КлючВарианта - Строка, Неопределено -
//       Имя предопределенного или уникальный идентификатор пользовательского варианта отчета.
//       Неопределено когда вызов для варианта расшифровки или без контекста.
//   НовыеНастройкиКД - НастройкиКомпоновкиДанных, Неопределено -
//       Настройки варианта отчета, которые будут загружены в компоновщик настроек после его инициализации.
//       Неопределено когда настройки варианта не надо загружать (уже загружены ранее).
//   НовыеПользовательскиеНастройкиКД - ПользовательскиеНастройкиКомпоновкиДанных, Неопределено -
//       Пользовательские настройки, которые будут загружены в компоновщик настроек после его инициализации.
//       Неопределено когда пользовательские настройки не надо загружать (уже загружены ранее).
//
// Примеры:
// 1. Компоновщик отчета инициализируется на основании схемы из общих макетов:
//	Если КлючСхемы <> "1" Тогда
//		КлючСхемы = "1";
//		СхемаКД = ПолучитьОбщийМакет("МояОбщаяСхемаКомпоновки");
//		ОтчетыСервер.ПодключитьСхему(ЭтотОбъект, Контекст, СхемаКД, КлючСхемы);
//	КонецЕсли;
//
// 2. Схема зависит от значения параметра, выведенного в пользовательские настройки отчета:
//	Если ТипЗнч(НовыеПользовательскиеНастройкиКД) = Тип("ПользовательскиеНастройкиКомпоновкиДанных") Тогда
//		ПолноеИмяОбъектаМетаданных = "";
//		Для Каждого ЭлементКД Из НовыеПользовательскиеНастройкиКД.Элементы Цикл
//			Если ТипЗнч(ЭлементКД) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Тогда
//				ИмяПараметра = Строка(ЭлементКД.Параметр);
//				Если ИмяПараметра = "ОбъектМетаданных" Тогда
//					ПолноеИмяОбъектаМетаданных = ЭлементКД.Значение;
//				КонецЕсли;
//			КонецЕсли;
//		КонецЦикла;
//		Если КлючСхемы <> ПолноеИмяОбъектаМетаданных Тогда
//			КлючСхемы = ПолноеИмяОбъектаМетаданных;
//			СхемаКД = Новый СхемаКомпоновкиДанных;
//			// Наполнение схемы...
//			ОтчетыСервер.ПодключитьСхему(ЭтотОбъект, Контекст, СхемаКД, КлючСхемы);
//		КонецЕсли;
//	КонецЕсли;
//
Процедура ПередЗагрузкойНастроекВКомпоновщик(Контекст, КлючСхемы, КлючВарианта, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД) Экспорт
	
	Если ТипЗнч(Контекст) = Тип("УправляемаяФорма") Тогда
		
		Если НовыеПользовательскиеНастройкиКД = Неопределено Тогда
			НастроитьПараметрыОтчетаПоВариантуОтчета(Контекст.НастройкиОтчета, НовыеНастройкиКД, Контекст.Отчет.КомпоновщикНастроек.ПользовательскиеНастройки);
		Иначе
			НастроитьПараметрыОтчетаПоВариантуОтчета(Контекст.НастройкиОтчета, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД);
		КонецЕсли;
		
		НастроитьПараметрыОтборыПоФункциональнымОпциям(НовыеНастройкиКД);
		
		ОтчетыСервер.ПодключитьСхему(ЭтотОбъект, Контекст, СхемаКомпоновкиДанных, КлючСхемы);
		
		КомпоновщикНастроекФормы = Контекст.Отчет.КомпоновщикНастроек;
		Параметры = Контекст.Параметры;
		
		ОбновитьПользовательскиеНастройки = Ложь;
		Если Параметры.Свойство("НастройкиИсточник") Тогда
			КомпоновкаДанныхКлиентСервер.ДобавитьОтборыВПользовательскиеНастройки(КомпоновщикНастроекФормы, Параметры.НастройкиИсточник.Отбор.Элементы);
			ОбновитьПользовательскиеНастройки = Истина;
		КонецЕсли;
		
		Если Параметры.Свойство("ПользовательскиеПараметры") Тогда
			КомпоновкаДанныхКлиентСервер.ДобавитьПараметрыВПользовательскиеНастройки(КомпоновщикНастроекФормы, Параметры.ПользовательскиеПараметры);
			ОбновитьПользовательскиеНастройки = Истина;
		КонецЕсли;
		
		Если ОбновитьПользовательскиеНастройки Тогда
			НовыеПользовательскиеНастройкиКД = КомпоновщикНастроекФормы.ПользовательскиеНастройки;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	
	ПараметрПериодОтчета = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(НастройкиОтчета, "Период");
	БезОтбораПоПериоду = Не ПараметрПериодОтчета.Использование;
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(НастройкиОтчета, "БезОтбораПоПериоду", БезОтбораПоПериоду);
	
	ТекстЗапроса = ЗатратыСервер.ТекстЗапросаПроизводственныеЗатратыТМЦ();
	
	СхемаКомпоновкиДанных.НаборыДанных.Основной.Запрос = ТекстЗапроса.ТекстЗапроса;
	
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);
	
	ЗатратыСервер.ДобавитьОтборПоВыбраннымРесурсам(ТекстЗапроса.Ресурсы, МакетКомпоновки.НаборыДанных.Основной);
	
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	ТабличныйДокумент = ПроцессорВывода.ЗакончитьВывод();
	
	// удалим служебные тексты
	
	МассивТекстов = Новый Массив;
	МассивТекстов.Добавить("%СлужебныйОтбор% И
	|Таблица Равно ""Продукция"" И
	|");
	МассивТекстов.Добавить("%СлужебныйОтбор% И
	|Таблица Равно ""Продукция""");
	МассивТекстов.Добавить("%СлужебныйОтбор% И
	|Таблица Равно ""Материалы"" И
	|");
	МассивТекстов.Добавить("%СлужебныйОтбор% И
	|Таблица Равно ""Материалы""");
	МассивТекстов.Добавить("Таблица Равно ""Материалы"" И
	|");
	МассивТекстов.Добавить("Таблица Равно ""Материалы""");
	МассивТекстов.Добавить("Таблица Равно ""Продукция"" И
	|");
	МассивТекстов.Добавить("Таблица Равно ""Продукция""");
	
	Для Каждого Текст Из МассивТекстов Цикл
		Область = ТабличныйДокумент.НайтиТекст(Текст);
		Если Область <> Неопределено Тогда
			Область.Текст = СтрЗаменить(Область.Текст, Текст, "");
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура НастроитьПараметрыОтчетаПоВариантуОтчета(НастройкиОтчета, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД)
	
	КлючиВриантов = КлючиПредопределенныхВариантов();
	ПредопределенныйВариант = ПолучитьПредопределенныйВариант(НастройкиОтчета.ВариантСсылка);
	КлючПредопределенногоВарианта = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПредопределенныйВариант, "КлючВарианта");
	Если Не ЗначениеЗаполнено(ПредопределенныйВариант) 
		Или КлючиВриантов.Найти(КлючПредопределенногоВарианта) = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрДанныеОтчета = СхемаКомпоновкиДанных.Параметры.Найти("ДанныеПоСебестоимости");
	ПараметрПоПредприятию = СхемаКомпоновкиДанных.Параметры.Найти("ПоПредприятию");
	
	СписокВыбора = Новый СписокЗначений;
	
	Если КлючПредопределенногоВарианта = "ДвижениеМатериаловПродукцииРаботПоПредприятию" Тогда
		
		СписокВыбора.Добавить(1, НСтр("ru = 'В валюте упр. учета с НДС'"));
		СписокВыбора.Добавить(2, НСтр("ru = 'В валюте упр. учета без НДС'"));
		ПараметрПоПредприятию.Значение = Истина;
		
	Иначе
		
		Если ПолучитьФункциональнуюОпцию("ВестиУправленческийУчетОрганизаций") Тогда
			СписокВыбора.Добавить(3, НСтр("ru = 'В валюте упр. учета'"));
		КонецЕсли;
		СписокВыбора.Добавить(4, НСтр("ru = 'В валюте регл. учета'"));
		ПараметрПоПредприятию.Значение = Ложь;
		
	КонецЕсли;
	
	ПараметрДанныеОтчета.УстановитьДоступныеЗначения(СписокВыбора);
	
	Если НовыеНастройкиКД = Неопределено
		Или НовыеПользовательскиеНастройкиКД = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗначениеПараметраДанныеОтчета = НовыеНастройкиКД.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ДанныеПоСебестоимости"));
	НастройкаДанныеОтчета = НовыеПользовательскиеНастройкиКД.Элементы.Найти(ЗначениеПараметраДанныеОтчета.ИдентификаторПользовательскойНастройки);
	
	Если Не НастройкаДанныеОтчета = Неопределено
		И СписокВыбора.НайтиПоЗначению(НастройкаДанныеОтчета.Значение) = Неопределено Тогда
		НастройкаДанныеОтчета.Значение = СписокВыбора[0].Значение;
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьПредопределенныйВариант(Знач Вариант)
	
	КлючиВариантов = КлючиПредопределенныхВариантов();
	
	Пока КлючиВариантов.Найти(Вариант.КлючВарианта) = Неопределено
		И ЗначениеЗаполнено(Вариант.Родитель) Цикл
		Вариант = Вариант.Родитель;
	КонецЦикла;
	
	Возврат Вариант;
	
КонецФункции

Функция КлючиПредопределенныхВариантов()
	
	КлючиВариантов = Новый Массив;
	КлючиВариантов.Добавить("ДвижениеМатериаловПродукцииРабот");
	КлючиВариантов.Добавить("ДвижениеМатериаловПродукцииРаботПоПредприятию");
	
	Возврат КлючиВариантов;
	
КонецФункции

Процедура НастроитьПараметрыОтборыПоФункциональнымОпциям(КомпоновщикНастроекФормы)
	
	Если ПолучитьФункциональнуюОпцию("КомплекснаяАвтоматизация") Тогда
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(КомпоновщикНастроекФормы, "ЗаказНаПроизводство");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли