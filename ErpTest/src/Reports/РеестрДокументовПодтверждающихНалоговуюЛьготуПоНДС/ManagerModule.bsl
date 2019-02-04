
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Процедура СформироватьОтчет(Знач ПараметрыОтчета, АдресХранилища) Экспорт
	
	ДокументРезультат = Новый ТабличныйДокумент;
	
	ДокументРезультат.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	ДокументРезультат.АвтоМасштаб        = Истина;
	
	Макет = Отчеты.РеестрДокументовПодтверждающихНалоговуюЛьготуПоНДС.ПолучитьМакет("РеестрПодтверждающихДокументов");
	
	СтандартнаяФорма = УчетНДСПереопределяемый.ПериодОтчетаСоответствуетНалоговому(
		ПараметрыОтчета.Организация, ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода);
	
	ПараметрыОтчета.Вставить("СформироватьОтчетПоСтандартнойФорме", СтандартнаяФорма);
	
	ВывестиШапкуРеестра(ПараметрыОтчета, ДокументРезультат, Макет);
	
	ВывестиДанныеРеестраПодтверждающихДокументов(ПараметрыОтчета, ДокументРезультат, Макет);
	
	ВывестиПодвалРеестра(ПараметрыОтчета, ДокументРезультат, Макет);
	
	ПоместитьВоВременноеХранилище(ДокументРезультат, АдресХранилища);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ВывестиШапкуРеестра(ПараметрыОтчета, ДокументРезультат, Макет)
	
	СведенияОрганизации = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(
		ПараметрыОтчета.Организация, ПараметрыОтчета.КонецПериода);
	НаименованиеОрганизацииДляПечатныхФорм = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(
		СведенияОрганизации, "НаименованиеДляПечатныхФорм,");
		
	ОбластьШапка  = Макет.ПолучитьОбласть("Шапка");
	ОбластьШапка.Параметры.Организация       = НаименованиеОрганизацииДляПечатныхФорм;
	ОбластьШапка.Параметры.СоставРеквизитов  = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'ИНН%1'") + ":",
			?(НЕ ЗначениеЗаполнено(СведенияОрганизации.КПП), "", "/КПП"));
	ОбластьШапка.Параметры.ИННКППОрганизации = "" + СведенияОрганизации.ИНН 
			+ ?(НЕ ЗначениеЗаполнено(СведенияОрганизации.КПП), "", ("/" + СведенияОрганизации.КПП));
			
	Если ПараметрыОтчета.СформироватьОтчетПоСтандартнойФорме Тогда 
		
		ОбластьШапкаИнформация  = Макет.ПолучитьОбласть("ШапкаИнформация");
		ДокументРезультат.Вывести(ОбластьШапкаИнформация);
		
		ОбластьШапка.Параметры.ТекстКДекларации = НСтр("ru = ', к декларации по налогу на добавленную стоимость'");
		Квартал = Формат(ПараметрыОтчета.КонецПериода, "ДФ = к");
		Год = Формат(ПараметрыОтчета.КонецПериода, "ДФ = гггг");
		ОбластьШапка.Параметры.ПериодОтчета = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'за %1 квартал %2 года'"),
			Квартал, 
			Год);
		
	Иначе
		
		ОбластьШапка.Параметры.ТекстКДекларации = "";
		ОбластьШапка.Параметры.ПериодОтчета = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'за период с %1 по %2'"),
			Формат(ПараметрыОтчета.НачалоПериода, "ДФ=dd.MM.yyyy"), 
			Формат(ПараметрыОтчета.КонецПериода, "ДФ=dd.MM.yyyy"));
		
	КонецЕсли;
	
	ДокументРезультат.Вывести(ОбластьШапка);
	
КонецФункции

Функция ВывестиДанныеРеестраПодтверждающихДокументов(ПараметрыОтчета, ДокументРезультат, Макет)
	
	Запрос = Новый Запрос;
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Организация",   СписокОрганизацийОтчета(ПараметрыОтчета));
	Запрос.УстановитьПараметр("НачалоПериода", ПараметрыОтчета.НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода",  КонецДня(ПараметрыОтчета.КонецПериода));
	Запрос.УстановитьПараметр("ТекстРозничнаяПродажа", НСтр("ru = 'Розничная продажа'"));
	
	ОбластьСтрока      = Макет.ПолучитьОбласть("Строка");
	ОбластьЗапись      = ОбластьСтрока.Область("ОбластьЗапись");
	ОбластьВидОперации = ОбластьСтрока.Область("ОбластьВидОперации");
	ОбластьОперация    = ОбластьСтрока.Область("ОбластьОперация");
	ОбластьДокумент    = ОбластьСтрока.Область("ОбластьДокумент");
	
	// Реквизиты контрагентов получим на большую дату подтверждающего документа
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.Контрагент КАК Ссылка,
	|	МАКСИМУМ(ЕСТЬNULL(ФормированиеЗаписейРаздела7ДекларацииНДСПодтверждающиеДокументы.ДатаДокумента, ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.Ссылка.Дата)) КАК ДатаСведений,
	|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.КлючСтроки,
	|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.Ссылка КАК ДокументСсылка
	|ПОМЕСТИТЬ СсылкиНаДаты
	|ИЗ
	|	Документ.ФормированиеЗаписейРаздела7ДекларацииНДС.НеоблагаемыеНДСОперации КАК ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ФормированиеЗаписейРаздела7ДекларацииНДС.ПодтверждающиеДокументы КАК ФормированиеЗаписейРаздела7ДекларацииНДСПодтверждающиеДокументы
	|		ПО ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.Ссылка = ФормированиеЗаписейРаздела7ДекларацииНДСПодтверждающиеДокументы.Ссылка
	|			И ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.КлючСтроки = ФормированиеЗаписейРаздела7ДекларацииНДСПодтверждающиеДокументы.КлючСтроки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КодыОперацийРаздела7ДекларацииПоНДС КАК КодыОперацийРаздела7ДекларацииПоНДС
	|		ПО ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.КодОперации = КодыОперацийРаздела7ДекларацииПоНДС.Ссылка
	|ГДЕ
	|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.Ссылка.Организация В(&Организация)
	|	И КодыОперацийРаздела7ДекларацииПоНДС.ВключаетсяВРеестрПодтверждающихДокументов
	|	И ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.СуммаРеализации <> 0
	|	И ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.Ссылка.Проведен
	|	И ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.Ссылка.Дата МЕЖДУ &НачалоПериода И &КонецПериода
	|
	|СГРУППИРОВАТЬ ПО
	|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.Контрагент,
	|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.КлючСтроки,
	|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.Ссылка";
	
	Запрос.Выполнить();
	
	УчетНДСПереопределяемый.РегистрационныеСведенияНаДаты(МенеджерВременныхТаблиц);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КодыОперацийРаздела7ДекларацииПоНДС.Код КАК Код,
	|	СУММА(ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.СуммаРеализации) КАК СуммаРеализации
	|ПОМЕСТИТЬ СуммыПоКоду
	|ИЗ
	|	Документ.ФормированиеЗаписейРаздела7ДекларацииНДС.НеоблагаемыеНДСОперации КАК ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КодыОперацийРаздела7ДекларацииПоНДС КАК КодыОперацийРаздела7ДекларацииПоНДС
	|		ПО ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.КодОперации = КодыОперацийРаздела7ДекларацииПоНДС.Ссылка
	|ГДЕ
	|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.Ссылка.Организация В(&Организация)
	|	И КодыОперацийРаздела7ДекларацииПоНДС.ВключаетсяВРеестрПодтверждающихДокументов
	|	И ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.СуммаРеализации <> 0
	|	И ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.Ссылка.Проведен
	|	И ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.Ссылка.Дата МЕЖДУ &НачалоПериода И &КонецПериода
	|
	|СГРУППИРОВАТЬ ПО
	|	КодыОперацийРаздела7ДекларацииПоНДС.Код
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Код
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.КодОперации КАК КодОперацииСсылка,
	|	СУММА(ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.СуммаРеализации) КАК СуммаРеализации
	|ПОМЕСТИТЬ СуммыПоВиду
	|ИЗ
	|	Документ.ФормированиеЗаписейРаздела7ДекларацииНДС.НеоблагаемыеНДСОперации КАК ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КодыОперацийРаздела7ДекларацииПоНДС КАК КодыОперацийРаздела7ДекларацииПоНДС
	|		ПО ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.КодОперации = КодыОперацийРаздела7ДекларацииПоНДС.Ссылка
	|ГДЕ
	|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.Ссылка.Организация В(&Организация)
	|	И КодыОперацийРаздела7ДекларацииПоНДС.ВключаетсяВРеестрПодтверждающихДокументов
	|	И ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.СуммаРеализации <> 0
	|	И ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.Ссылка.Проведен
	|	И ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.Ссылка.Дата МЕЖДУ &НачалоПериода И &КонецПериода
	|
	|СГРУППИРОВАТЬ ПО
	|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.КодОперации
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	КодОперацииСсылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СсылкиНаДаты.Ссылка КАК Ссылка,
	|	СсылкиНаДаты.КлючСтроки КАК КлючСтроки,
	|	СведенияОСсылкахНаДаты.Наименование КАК Наименование,
	|	СведенияОСсылкахНаДаты.ИНН КАК ИНН,
	|	СведенияОСсылкахНаДаты.КПП КАК КПП,
	|	СсылкиНаДаты.ДокументСсылка КАК ДокументСсылка
	|ПОМЕСТИТЬ СведенияОКонтрагентах
	|ИЗ
	|	СсылкиНаДаты КАК СсылкиНаДаты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ СведенияОСсылкахНаДаты КАК СведенияОСсылкахНаДаты
	|		ПО СсылкиНаДаты.Ссылка = СведенияОСсылкахНаДаты.Ссылка
	|			И СсылкиНаДаты.ДатаСведений = СведенияОСсылкахНаДаты.ДатаСведений
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка,
	|	КлючСтроки,
	|	СсылкиНаДаты.ДокументСсылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.Контрагент КАК Контрагент,
	|	СУММА(ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.СуммаРеализации) КАК СуммаОперации,
	|	МАКСИМУМ(СуммыПоКоду.СуммаРеализации) КАК ИтогПоКоду,
	|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.КлючСтроки КАК Операция,
	|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.Ссылка КАК Ссылка,
	|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.КодОперации КАК КодОперации,
	|	МАКСИМУМ(СуммыПоВиду.СуммаРеализации) КАК ИтогПоВиду,
	|	ВЫБОР
	|		КОГДА ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.ДокументРеализации ССЫЛКА Документ.ОтчетОРозничныхПродажах
	|			ТОГДА &ТекстРозничнаяПродажа
	|		ИНАЧЕ ЕСТЬNULL(СведенияОКонтрагентах.Наименование, """")
	|	КОНЕЦ КАК НаименованиеКонтрагента,
	|	ЕСТЬNULL(СведенияОКонтрагентах.ИНН, """") КАК ИННКонтрагента,
	|	ЕСТЬNULL(СведенияОКонтрагентах.КПП, """") КАК КППКонтрагента
	|ПОМЕСТИТЬ ЗаписиРеестраПредварительная
	|ИЗ
	|	Документ.ФормированиеЗаписейРаздела7ДекларацииНДС.НеоблагаемыеНДСОперации КАК ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КодыОперацийРаздела7ДекларацииПоНДС КАК КодыОперацийРаздела7ДекларацииПоНДС
	|		ПО ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.КодОперации = КодыОперацийРаздела7ДекларацииПоНДС.Ссылка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ СуммыПоКоду КАК СуммыПоКоду
	|		ПО КодыОперацийРаздела7ДекларацииПоНДС.Код = СуммыПоКоду.Код
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ СуммыПоВиду КАК СуммыПоВиду
	|		ПО КодыОперацийРаздела7ДекларацииПоНДС.Ссылка = СуммыПоВиду.КодОперацииСсылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ СведенияОКонтрагентах КАК СведенияОКонтрагентах
	|		ПО ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.Контрагент = СведенияОКонтрагентах.Ссылка
	|			И ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.КлючСтроки = СведенияОКонтрагентах.КлючСтроки
	|			И ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.Ссылка = СведенияОКонтрагентах.ДокументСсылка
	|ГДЕ
	|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.Ссылка.Организация В(&Организация)
	|	И ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.Ссылка.Проведен
	|	И ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.Ссылка.Дата МЕЖДУ &НачалоПериода И &КонецПериода
	|	И КодыОперацийРаздела7ДекларацииПоНДС.ВключаетсяВРеестрПодтверждающихДокументов
	|	И ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.СуммаРеализации <> 0
	|
	|СГРУППИРОВАТЬ ПО
	|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.Контрагент,
	|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.КлючСтроки,
	|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.Ссылка,
	|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.КодОперации,
	|	ЕСТЬNULL(СведенияОКонтрагентах.ИНН, """"),
	|	ЕСТЬNULL(СведенияОКонтрагентах.КПП, """"),
	|	ВЫБОР
	|		КОГДА ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.ДокументРеализации ССЫЛКА Документ.ОтчетОРозничныхПродажах
	|			ТОГДА &ТекстРозничнаяПродажа
	|		ИНАЧЕ ЕСТЬNULL(СведенияОКонтрагентах.Наименование, """")
	|	КОНЕЦ
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Операция,
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КодыОперацийРаздела7ДекларацииПоНДС.Код КАК Код,
	|	КодыОперацийРаздела7ДекларацииПоНДС.Наименование КАК Наименование,
	|	КодыОперацийРаздела7ДекларацииПоНДС.ВидНеоблагаемойОперации КАК ВидНеоблагаемойОперации,
	|	ФормированиеЗаписейРаздела7ДекларацииНДСПодтверждающиеДокументы.ТипДокумента.ПолноеНаименование КАК ТипДокумента,
	|	ФормированиеЗаписейРаздела7ДекларацииНДСПодтверждающиеДокументы.НомерДокумента КАК НомерДокумента,
	|	ФормированиеЗаписейРаздела7ДекларацииНДСПодтверждающиеДокументы.ДатаДокумента КАК ДатаДокумента,
	|	ЗаписиРеестраПредварительная.СуммаОперации КАК СуммаОперации,
	|	ЗаписиРеестраПредварительная.ИтогПоКоду КАК ИтогПоКоду,
	|	ЗаписиРеестраПредварительная.Операция КАК Операция,
	|	ЗаписиРеестраПредварительная.ИтогПоВиду КАК ИтогПоВиду,
	|	ЗаписиРеестраПредварительная.НаименованиеКонтрагента КАК НаименованиеКонтрагента,
	|	ЗаписиРеестраПредварительная.ИННКонтрагента КАК ИННКонтрагента,
	|	ЗаписиРеестраПредварительная.КППКонтрагента КАК КППКонтрагента,
	|	ЗаписиРеестраПредварительная.Контрагент КАК КонтрагентРасшифровка,
	|	ЗаписиРеестраПредварительная.Ссылка КАК Ссылка
	|ИЗ
	|	ЗаписиРеестраПредварительная КАК ЗаписиРеестраПредварительная
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ФормированиеЗаписейРаздела7ДекларацииНДС.ПодтверждающиеДокументы КАК ФормированиеЗаписейРаздела7ДекларацииНДСПодтверждающиеДокументы
	|		ПО ЗаписиРеестраПредварительная.Ссылка = ФормированиеЗаписейРаздела7ДекларацииНДСПодтверждающиеДокументы.Ссылка
	|			И ЗаписиРеестраПредварительная.Операция = ФормированиеЗаписейРаздела7ДекларацииНДСПодтверждающиеДокументы.КлючСтроки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КодыОперацийРаздела7ДекларацииПоНДС КАК КодыОперацийРаздела7ДекларацииПоНДС
	|		ПО ЗаписиРеестраПредварительная.КодОперации = КодыОперацийРаздела7ДекларацииПоНДС.Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	Код,
	|	ВидНеоблагаемойОперации,
	|	ДатаДокумента
	|ИТОГИ
	|	МАКСИМУМ(Наименование),
	|	МАКСИМУМ(СуммаОперации),
	|	МАКСИМУМ(ИтогПоКоду),
	|	МАКСИМУМ(ИтогПоВиду)
	|ПО
	|	Код,
	|	ВидНеоблагаемойОперации,
	|	Ссылка,
	|	Операция";
	
	Результат = Запрос.Выполнить();
	
	КоличествоКодов = 0;
	КоличествоВидов = 0;
	КоличествоДокументов = 0;
	КоличествоОпераций = 0;
	КоличествоЗаписей = 0;
	
	ПорядокКода = 0;
	ПорядокВида = 0;
	ПорядокДокумента = 0;
	ПорядокОперации = 0;
	ПорядокЗаписи = 0;
	
	ИтогПоКоду = 0;
	ИтогПоВиду = 0;
	
	ВыборкаПоКодам = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	КоличествоКодов = ВыборкаПоКодам.Количество();
	Пока ВыборкаПоКодам.Следующий() Цикл
		ИтогПоКоду = ВыборкаПоКодам.ИтогПоКоду;
		ПорядокКода = ПорядокКода + 1;
		ПорядокВида = 0;
		ВыборкаПоВидам = ВыборкаПоКодам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		КоличествоВидов = ВыборкаПоВидам.Количество();
		Пока ВыборкаПоВидам.Следующий() Цикл
			ИтогПоВиду = ВыборкаПоВидам.ИтогПоВиду;
			ПорядокВида = ПорядокВида + 1;
			ПорядокДокумента = 0;
			// Для первого вида по коду заполняем код операции.
			Если ПорядокВида = 1 Тогда 
				ШаблонПредставленияКода = "%1
					|(%2)";
				ОбластьСтрока.Параметры.КодОперации   = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонПредставленияКода, 
					ВыборкаПоВидам.Код, 
					ВыборкаПоВидам.Наименование);
			Иначе
				ОбластьСтрока.Параметры.КодОперации   = "";
			КонецЕсли;
			
			ВыборкаПоДокументам = ВыборкаПоВидам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			КоличествоДокументов = ВыборкаПоДокументам.Количество();
			Пока ВыборкаПоДокументам.Следующий() Цикл
				ПорядокОперации = 0;
				ПорядокДокумента = ПорядокДокумента + 1;
				ВыборкаПоОперациям = ВыборкаПоДокументам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				КоличествоОпераций = ВыборкаПоОперациям.Количество();
				Пока ВыборкаПоОперациям.Следующий() Цикл
					ПорядокОперации = ПорядокОперации + 1;
					ПорядокЗаписи = 0;
					// Для первой операции по виду заполняем вид операции и итог по виду.
					Если ПорядокОперации = 1
						И ПорядокДокумента = 1 Тогда 
						ОбластьСтрока.Параметры.ВидОперации   = ВыборкаПоОперациям.ВидНеоблагаемойОперации;
						ОбластьСтрока.Параметры.СуммаПоВиду   = ИтогПоВиду;
					Иначе
						ОбластьСтрока.Параметры.КодОперации   = "";
						ОбластьСтрока.Параметры.ВидОперации   = "";
						ОбластьСтрока.Параметры.СуммаПоВиду   = "";
					КонецЕсли;
					
					ВыборкаЗаписи = ВыборкаПоОперациям.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
					КоличествоЗаписей = ВыборкаЗаписи.Количество();
					
					Пока ВыборкаЗаписи.Следующий() Цикл
						ПорядокЗаписи = ПорядокЗаписи + 1;
						// Уберем нижнюю границу, определим область подчеркивания ниже
						ОбластьЗапись.ГраницаСнизу = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.НетЛинии);
						// Для первой записи документа по операции заполним контрагента с реквизитами и сумму операции
						Если ПорядокЗаписи = 1 Тогда 
							ОбластьСтрока.Параметры.Контрагент            = ВыборкаЗаписи.НаименованиеКонтрагента;
							ОбластьСтрока.Параметры.КонтрагентРасшифровка = ВыборкаЗаписи.КонтрагентРасшифровка;
							ОбластьСтрока.Параметры.КонтрагентИНН = ВыборкаЗаписи.ИННКонтрагента;
							ОбластьСтрока.Параметры.КонтрагентКПП = ВыборкаЗаписи.КППКонтрагента;
							ОбластьСтрока.Параметры.СуммаОперации = ВыборкаЗаписи.СуммаОперации;
						Иначе
							ОбластьСтрока.Параметры.Контрагент    = "";
							ОбластьСтрока.Параметры.СуммаОперации = "";
							// Все прочие параметры должны быть пустые
							ОбластьСтрока.Параметры.КодОперации   = "";
							ОбластьСтрока.Параметры.ВидОперации   = "";
							ОбластьСтрока.Параметры.СуммаПоВиду   = "";
							ОбластьСтрока.Параметры.КонтрагентИНН = "";
							ОбластьСтрока.Параметры.КонтрагентКПП = "";
						КонецЕсли;
						ОбластьСтрока.Параметры.ТипДокумента   = ВыборкаЗаписи.ТипДокумента;
						ОбластьСтрока.Параметры.НомерДокумента = ВыборкаЗаписи.НомерДокумента;
						ОбластьСтрока.Параметры.ДатаДокумента  = Формат(ВыборкаЗаписи.ДатаДокумента,"ДЛФ=D");
						// Определим область подчеркивания
						Если ПорядокЗаписи = КоличествоЗаписей Тогда 
							Если ПорядокОперации = КоличествоОпераций 
								И ПорядокВида = КоличествоВидов 
								И ПорядокДокумента = КоличествоДокументов Тогда // значит последний вид по коду и последняя операция
								ДокументРезультат.Вывести(ОбластьСтрока);
								ОбластьИтог = Макет.ПолучитьОбласть("ИтогиПоКоду");
								ОбластьИтог.Параметры.ИтогПоВидам = ИтогПоКоду;
								ОбластьИтог.Параметры.ИтогПоОперациям = ИтогПоКоду;
								ДокументРезультат.Вывести(ОбластьИтог);
								Продолжить;
							ИначеЕсли ПорядокОперации = КоличествоОпераций
								И ПорядокДокумента = КоличествоДокументов Тогда // значит последняя операция по виду
								ОбластьВидОперации.ГраницаСнизу = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1);
							Иначе // последний документ по операции
								ОбластьОперация.ГраницаСнизу = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1);
							КонецЕсли;
						Иначе
							ОбластьДокумент.ГраницаСнизу = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1);
						КонецЕсли;
						ДокументРезультат.Вывести(ОбластьСтрока);
					КонецЦикла;
				КонецЦикла;
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецФункции

Функция ВывестиПодвалРеестра(ПараметрыОтчета, ДокументРезультат, Макет)
	
	ОтветственныеЛица = ОтветственныеЛицаБП.ОтветственныеЛица(ПараметрыОтчета.Организация, ПараметрыОтчета.КонецПериода);
	Если ОбщегоНазначенияБПВызовСервераПовтИсп.ЭтоЮрЛицо(ПараметрыОтчета.Организация) Тогда
		ИмяРук = ОтветственныеЛица.РуководительПредставление;
		ИмяОрг = "";
		Свидетельство = "";
	Иначе
		ИмяРук = "";
		ИмяОрг = ОтветственныеЛица.РуководительПредставление;
		СведенияОЮрФизЛице = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(
			ПараметрыОтчета.Организация, ПараметрыОтчета.КонецПериода);
		Свидетельство = СведенияОЮрФизЛице.Свидетельство;
	КонецЕсли;
	
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	ОбластьПодвал.Параметры.ИмяРук        = ИмяРук;
	ОбластьПодвал.Параметры.ИмяОрг        = ИмяОрг;
	ОбластьПодвал.Параметры.Свидетельство = Свидетельство;
	
	ДокументРезультат.Вывести(ОбластьПодвал);
	
КонецФункции

Функция СписокОрганизацийОтчета(ПараметрыОтчета)
	
	СписокОрганизаций = Новый СписокЗначений;
	
	СписокОрганизацийОтбора = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьСписокОбособленныхПодразделений(
			ПараметрыОтчета.Организация);
	СписокДоступныхОрганизаций = ОбщегоНазначенияБПВызовСервераПовтИсп.ВсеОрганизацииДанныеКоторыхДоступныПоRLS(ложь);
	Для Каждого ОрганизацияСписка Из СписокОрганизацийОтбора Цикл
		Если СписокДоступныхОрганизаций.Найти(ОрганизацияСписка.Значение) <> Неопределено Тогда 
			СписокОрганизаций.Добавить(ОрганизацияСписка.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Возврат СписокОрганизаций;
	
КонецФункции

#КонецОбласти

#КонецЕсли



