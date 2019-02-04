////////////////////////////////////////////////////////////////////////////////
// Содержит процедуры для работы с документами подсистемы ВЕТИС.
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Формирует параметры, которые используются в функции ЗаполнитьЗаписиСкладскогоЖурнала.
// 
// Возвращаемое значение:
//  Структура - Содержит параметры.
//
Функция ПараметрыЗаполненияЗаписейСкладскогоЖурнала() Экспорт

	ПараметрыЗаполнения = Новый Структура;
	ПараметрыЗаполнения.Вставить("ИмяПоляИдентификаторСтроки", "ИдентификаторСтроки");
	ПараметрыЗаполнения.Вставить("ИмяПоляКоличество", "Количество");
	ПараметрыЗаполнения.Вставить("ИмяПоляКоличествоВЕТИС", "КоличествоВЕТИС");
	ПараметрыЗаполнения.Вставить("ЭтоИнвентаризация", Ложь);

	Возврат ПараметрыЗаполнения;
	
КонецФункции
 
// Заполняет реквизит ЗаписьСкладскогоЖурнала в табличной части документа на основании остатков продукции.
//
// Параметры:
//  Товары				 - ТабличнаяЧасть, ДанныеФормыКоллекция			 - Табличная часть документа.
//  ХозяйствующийСубъект - СправочникСсылка.ХозяйствующиеСубъектыВЕТИС	 - Хозяйствующий субъект.
//  Предприятие			 - СправочникСсылка.ПредприятияВЕТИС			 - Предприятие.
//  СписокСтрок			 - Массив										 - Строки, в которых надо заполнить реквизиты.
//  ПараметрыЗаполнения	 - Структура									 - см. функцию ПараметрыЗаполненияЗаписейСкладскогоЖурнала()
// 
// Возвращаемое значение:
//  Структура - Содержит свойства:
//  * СообщениеПользователю  - Содержит сообщение о результатах заполнения.
//  * ИзмененныеСтроки  - Массив, в которых не удалось заполнить реквизит.
//
Функция ЗаполнитьЗаписиСкладскогоЖурнала(Товары, ХозяйствующийСубъект, Предприятие, СписокСтрок, ПараметрыЗаполнения) Экспорт

	РезультатЗаполнения = Новый Структура;
	РезультатЗаполнения.Вставить("ВсегоСтрок", 0);
	РезультатЗаполнения.Вставить("ЗаполненоСтрок", 0);
	РезультатЗаполнения.Вставить("ПроблемныхСтрок", 0);
	РезультатЗаполнения.Вставить("ИзмененныеСтроки", Новый Массив);
	
	ВсеСтроки = Новый Массив;
	СтрокиССериями = Новый Массив;
	СтрокиБезСерий = Новый Массив;
	
	Для каждого СтрокаДокумента Из Товары Цикл
		
		Если ЗначениеЗаполнено(СтрокаДокумента.ЗаписьСкладскогоЖурнала) 
			ИЛИ ПараметрыЗаполнения.ЭтоИнвентаризация
				И СтрокаДокумента.Операция = Перечисления.ОперацииИнвентаризацииПродукцииВЕТИС.Добавление Тогда
			Продолжить;
		КонецЕсли; 
		
		ВсеСтроки.Добавить(СтрокаДокумента);
		
		Если НЕ ЗначениеЗаполнено(СтрокаДокумента.Номенклатура) Тогда
			
			РезультатЗаполнения.ПроблемныхСтрок = РезультатЗаполнения.ПроблемныхСтрок + 1;
			
		ИначеЕсли НЕ ЗначениеЗаполнено(СтрокаДокумента[ПараметрыЗаполнения.ИмяПоляКоличество])
			И НЕ ПараметрыЗаполнения.ЭтоИнвентаризация Тогда
			
			РезультатЗаполнения.ПроблемныхСтрок = РезультатЗаполнения.ПроблемныхСтрок + 1;
			
		Иначе
		
			Если ЗначениеЗаполнено(СтрокаДокумента.Серия) Тогда
				СтрокиССериями.Добавить(СтрокаДокумента);
			Иначе
				СтрокиБезСерий.Добавить(СтрокаДокумента);
			КонецЕсли; 
		
		КонецЕсли;
		
	КонецЦикла; 
	
	РезультатЗаполнения.ВсегоСтрок = СтрокиССериями.Количество() + СтрокиБезСерий.Количество() + РезультатЗаполнения.ПроблемныхСтрок;
	
	ПодготовитьСообщениеОЗавершенииЗаполненияЗаписейСкладскогоЖурнала(РезультатЗаполнения);
	
	Если (РезультатЗаполнения.ВсегоСтрок - РезультатЗаполнения.ПроблемныхСтрок) = 0 Тогда
		Возврат РезультатЗаполнения;
	КонецЕсли; 
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ТаблицаТовары.Номенклатура КАК Номенклатура,
	|	ТаблицаТовары.Характеристика КАК Характеристика,
	|	ТаблицаТовары.Продукция КАК Продукция,
	|	ТаблицаТовары.Серия КАК Серия,
	|	ТаблицаТовары.ЗаписьСкладскогоЖурнала КАК ЗаписьСкладскогоЖурнала,
	|	ВЫРАЗИТЬ(ТаблицаТовары.ЕдиницаИзмеренияВЕТИС КАК Справочник.ЕдиницыИзмеренияВЕТИС) КАК ЕдиницаИзмеренияВЕТИС,
	|	ТаблицаТовары.КоличествоВЕТИС КАК КоличествоВЕТИС
	|ПОМЕСТИТЬ ТаблицаТовары
	|ИЗ
	|	&Товары КАК ТаблицаТовары
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура,
	|	Характеристика,
	|	Продукция
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаТовары.Номенклатура КАК Номенклатура,
	|	ТаблицаТовары.Характеристика КАК Характеристика,
	|	ТаблицаТовары.Серия КАК Серия,
	|	ТаблицаТовары.Продукция КАК Продукция
	|ПОМЕСТИТЬ ТаблицаТоварыСПродукцией
	|ИЗ
	|	ТаблицаТовары КАК ТаблицаТовары
	|ГДЕ
	|	ТаблицаТовары.Продукция <> ЗНАЧЕНИЕ(Справочник.ПродукцияВЕТИС.ПустаяСсылка)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура,
	|	Характеристика,
	|	Продукция
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаТовары.Номенклатура КАК Номенклатура,
	|	ТаблицаТовары.Характеристика КАК Характеристика,
	|	ТаблицаТовары.Серия КАК Серия
	|ПОМЕСТИТЬ ТаблицаТоварыБезПродукции
	|ИЗ
	|	ТаблицаТовары КАК ТаблицаТовары
	|ГДЕ
	|	ТаблицаТовары.Продукция = ЗНАЧЕНИЕ(Справочник.ПродукцияВЕТИС.ПустаяСсылка)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура,
	|	Характеристика
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТовары.ЗаписьСкладскогоЖурнала КАК ЗаписьСкладскогоЖурнала,
	|	СУММА(ТаблицаТовары.КоличествоВЕТИС * ЕСТЬNULL(ТаблицаТовары.ЕдиницаИзмеренияВЕТИС.Коэффициент, 0)) КАК КоличествоВЕТИС
	|ПОМЕСТИТЬ ЗаписиСкладскогоЖурналаВДокументе
	|ИЗ
	|	ТаблицаТовары КАК ТаблицаТовары
	|ГДЕ
	|	ТаблицаТовары.ЗаписьСкладскогоЖурнала <> &ПустаяЗаписьСкладскогоЖурнала
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаТовары.ЗаписьСкладскогоЖурнала
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ЗаписьСкладскогоЖурнала
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаСоответствия.Номенклатура КАК Номенклатура,
	|	ТаблицаСоответствия.Характеристика КАК Характеристика,
	|	ТаблицаСоответствия.Продукция КАК Продукция,
	|	ТаблицаСоответствия.Серия КАК Серия,
	|	ТаблицаСоответствия.ЗаписьСкладскогоЖурнала КАК ЗаписьСкладскогоЖурнала
	|ПОМЕСТИТЬ ТаблицаСоответствия
	|ИЗ
	|	РегистрСведений.СоответствиеНоменклатурыВЕТИС КАК ТаблицаСоответствия
	|ГДЕ
	|	(ТаблицаСоответствия.Номенклатура, ТаблицаСоответствия.Характеристика, ТаблицаСоответствия.Продукция) В
	|			(ВЫБРАТЬ
	|				ТаблицаТоварыСПродукцией.Номенклатура,
	|				ТаблицаТоварыСПродукцией.Характеристика,
	|				ТаблицаТоварыСПродукцией.Продукция
	|			ИЗ
	|				ТаблицаТоварыСПродукцией КАК ТаблицаТоварыСПродукцией)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТаблицаСоответствия.Номенклатура,
	|	ТаблицаСоответствия.Характеристика,
	|	ТаблицаСоответствия.Продукция,
	|	ТаблицаСоответствия.Серия,
	|	ТаблицаСоответствия.ЗаписьСкладскогоЖурнала
	|ИЗ
	|	РегистрСведений.СоответствиеНоменклатурыВЕТИС КАК ТаблицаСоответствия
	|ГДЕ
	|	(ТаблицаСоответствия.Номенклатура, ТаблицаСоответствия.Характеристика) В
	|			(ВЫБРАТЬ
	|				ТаблицаТоварыБезПродукции.Номенклатура,
	|				ТаблицаТоварыБезПродукции.Характеристика
	|			ИЗ
	|				ТаблицаТоварыБезПродукции КАК ТаблицаТоварыБезПродукции)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ЗаписьСкладскогоЖурнала
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаТовары.Продукция КАК Продукция
	|ПОМЕСТИТЬ СписокПродукции
	|ИЗ
	|	ТаблицаТовары КАК ТаблицаТовары
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаСоответствия.Продукция КАК Продукция
	|ИЗ
	|	ТаблицаСоответствия КАК ТаблицаСоответствия
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Продукция
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаОстатков.Продукция КАК Продукция,
	|	ТаблицаОстатков.ЗаписьСкладскогоЖурнала КАК ЗаписьСкладскогоЖурнала,
	|	ТаблицаОстатков.КоличествоВЕТИС КАК КоличествоВЕТИС,
	|	ТаблицаОстатков.ЕдиницаИзмеренияВЕТИС КАК ЕдиницаИзмеренияВЕТИС,
	
	// Для упорядочивания записей
	|	ТаблицаОстатков.ЗаписьСкладскогоЖурнала.НомерЗаписи КАК НомерЗаписи,
	|	ТаблицаОстатков.ЗаписьСкладскогоЖурнала.СкоропортящаясяПродукция КАК СкоропортящаясяПродукция,
	|	ТаблицаОстатков.ЗаписьСкладскогоЖурнала.ДатаПроизводстваНачалоПериода КАК ДатаПроизводстваНачалоПериода,
	|	ТаблицаОстатков.ЗаписьСкладскогоЖурнала.СрокГодностиКонецПериода КАК СрокГодностиКонецПериода,
	|	ТаблицаОстатков.ЗаписьСкладскогоЖурнала.СтранаПроизводства КАК СтранаПроизводства
	|ПОМЕСТИТЬ ТаблицаОстатков
	|ИЗ
	|	РегистрСведений.ОстаткиПродукцииВЕТИС КАК ТаблицаОстатков
	|ГДЕ
	|	ТаблицаОстатков.ХозяйствующийСубъект = &ХозяйствующийСубъект
	|	И ТаблицаОстатков.Предприятие = &Предприятие
	|	И ТаблицаОстатков.КоличествоВЕТИС > 0
	|	И ТаблицаОстатков.Продукция В (
	|		ВЫБРАТЬ
	|			СписокПродукции.Продукция
	|		ИЗ
	|			СписокПродукции КАК СписокПродукции)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ЗаписьСкладскогоЖурнала
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаРезервы.ЗаписьСкладскогоЖурнала КАК ЗаписьСкладскогоЖурнала,
	|	СУММА(ТаблицаРезервы.КоличествоВЕТИС * ЕСТЬNULL(ТаблицаРезервы.ЕдиницаИзмеренияВЕТИС.Коэффициент, 0)) КАК КоличествоВЕТИС
	|ПОМЕСТИТЬ ТаблицаРезервы
	|ИЗ
	|	РегистрСведений.ЗаписиСкладскогоЖурналаВРезервеВЕТИС КАК ТаблицаРезервы
	|ГДЕ
	|	ТаблицаРезервы.ХозяйствующийСубъект = &ХозяйствующийСубъект
	|	И ТаблицаРезервы.Предприятие = &Предприятие
	|	И ТаблицаРезервы.ЗаписьСкладскогоЖурнала В
	|			(ВЫБРАТЬ
	|				ТаблицаОстатков.ЗаписьСкладскогоЖурнала
	|			ИЗ
	|				ТаблицаОстатков)
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаРезервы.ЗаписьСкладскогоЖурнала
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ЗаписьСкладскогоЖурнала
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаОстатков.Продукция КАК Продукция,
	|	ТаблицаОстатков.ЗаписьСкладскогоЖурнала КАК ЗаписьСкладскогоЖурнала,
	|	ВЫБОР
	|		КОГДА &ЭтоИнвентаризация
	|			ТОГДА ТаблицаОстатков.КоличествоВЕТИС - ВЫБОР
	|					КОГДА ЕСТЬNULL(ТаблицаРезервы.КоличествоВЕТИС, 0) <> 0
	|							И ЕСТЬNULL(ТаблицаОстатков.ЕдиницаИзмеренияВЕТИС.Коэффициент, 0) <> 0
	|						ТОГДА ЕСТЬNULL(ТаблицаРезервы.КоличествоВЕТИС, 0) / ЕСТЬNULL(ТаблицаОстатков.ЕдиницаИзмеренияВЕТИС.Коэффициент, 0)
	|					ИНАЧЕ 0
	|				КОНЕЦ
	|		ИНАЧЕ ТаблицаОстатков.КоличествоВЕТИС - ВЫБОР
	|				КОГДА ЕСТЬNULL(ТаблицаРезервы.КоличествоВЕТИС, 0) <> 0
	|						И ЕСТЬNULL(ТаблицаОстатков.ЕдиницаИзмеренияВЕТИС.Коэффициент, 0) <> 0
	|					ТОГДА ЕСТЬNULL(ТаблицаРезервы.КоличествоВЕТИС, 0) / ЕСТЬNULL(ТаблицаОстатков.ЕдиницаИзмеренияВЕТИС.Коэффициент, 0)
	|				ИНАЧЕ 0
	|			КОНЕЦ - ВЫБОР
	|				КОГДА ЕСТЬNULL(ТаблицаЗаписиВДокументе.КоличествоВЕТИС, 0) <> 0
	|						И ЕСТЬNULL(ТаблицаОстатков.ЕдиницаИзмеренияВЕТИС.Коэффициент, 0) <> 0
	|					ТОГДА ЕСТЬNULL(ТаблицаЗаписиВДокументе.КоличествоВЕТИС, 0) / ЕСТЬNULL(ТаблицаОстатков.ЕдиницаИзмеренияВЕТИС.Коэффициент, 0)
	|				ИНАЧЕ 0
	|			КОНЕЦ
	|	КОНЕЦ КАК Количество,
	|	ТаблицаОстатков.ЕдиницаИзмеренияВЕТИС КАК ЕдиницаИзмерения,
	|	ТаблицаОстатков.ЗаписьСкладскогоЖурнала В
	|		(ВЫБРАТЬ
	|			ТаблицаСоответствия.ЗаписьСкладскогоЖурнала
	|		ИЗ
	|			ТаблицаСоответствия КАК ТаблицаСоответствия) КАК ЕстьСоответствие
	|ИЗ
	|	ТаблицаОстатков КАК ТаблицаОстатков
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаРезервы КАК ТаблицаРезервы
	|		ПО (ТаблицаРезервы.ЗаписьСкладскогоЖурнала = ТаблицаОстатков.ЗаписьСкладскогоЖурнала)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ЗаписиСкладскогоЖурналаВДокументе КАК ТаблицаЗаписиВДокументе
	|		ПО (ТаблицаЗаписиВДокументе.ЗаписьСкладскогоЖурнала = ТаблицаОстатков.ЗаписьСкладскогоЖурнала)
	|ГДЕ
	|	ВЫБОР
	|			КОГДА &ЭтоИнвентаризация
	|				ТОГДА ТаблицаОстатков.КоличествоВЕТИС - ВЫБОР
	|							КОГДА ЕСТЬNULL(ТаблицаРезервы.КоличествоВЕТИС, 0) <> 0
	|									И ЕСТЬNULL(ТаблицаОстатков.ЕдиницаИзмеренияВЕТИС.Коэффициент, 0) <> 0
	|								ТОГДА ЕСТЬNULL(ТаблицаРезервы.КоличествоВЕТИС, 0) / ЕСТЬNULL(ТаблицаОстатков.ЕдиницаИзмеренияВЕТИС.Коэффициент, 0)
	|							ИНАЧЕ 0
	|						КОНЕЦ > 0
	|						И ТаблицаЗаписиВДокументе.ЗаписьСкладскогоЖурнала ЕСТЬ NULL
	|			ИНАЧЕ ТаблицаОстатков.КоличествоВЕТИС - ВЫБОР
	|					КОГДА ЕСТЬNULL(ТаблицаРезервы.КоличествоВЕТИС, 0) <> 0
	|							И ЕСТЬNULL(ТаблицаОстатков.ЕдиницаИзмеренияВЕТИС.Коэффициент, 0) <> 0
	|						ТОГДА ЕСТЬNULL(ТаблицаРезервы.КоличествоВЕТИС, 0) / ЕСТЬNULL(ТаблицаОстатков.ЕдиницаИзмеренияВЕТИС.Коэффициент, 0)
	|					ИНАЧЕ 0
	|				КОНЕЦ - ВЫБОР
	|					КОГДА ЕСТЬNULL(ТаблицаЗаписиВДокументе.КоличествоВЕТИС, 0) <> 0
	|							И ЕСТЬNULL(ТаблицаОстатков.ЕдиницаИзмеренияВЕТИС.Коэффициент, 0) <> 0
	|						ТОГДА ЕСТЬNULL(ТаблицаЗаписиВДокументе.КоличествоВЕТИС, 0) / ЕСТЬNULL(ТаблицаОстатков.ЕдиницаИзмеренияВЕТИС.Коэффициент, 0)
	|					ИНАЧЕ 0
	|				КОНЕЦ > 0
	|		КОНЕЦ
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТаблицаОстатков.Продукция,
	|	ТаблицаОстатков.СкоропортящаясяПродукция УБЫВ,
	|	ТаблицаОстатков.СрокГодностиКонецПериода,
	|	ТаблицаОстатков.ДатаПроизводстваНачалоПериода,
	|	ТаблицаОстатков.СтранаПроизводства,
	|	ТаблицаОстатков.НомерЗаписи
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаСоответствия.Номенклатура КАК Номенклатура,
	|	ТаблицаСоответствия.Характеристика КАК Характеристика,
	|	ТаблицаСоответствия.Продукция КАК Продукция,
	|	ТаблицаСоответствия.Серия КАК Серия,
	|	ТаблицаСоответствия.ЗаписьСкладскогоЖурнала КАК ЗаписьСкладскогоЖурнала
	|ИЗ
	|	ТаблицаСоответствия КАК ТаблицаСоответствия";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Предприятие", Предприятие);
	Запрос.УстановитьПараметр("ХозяйствующийСубъект", ХозяйствующийСубъект);
	Запрос.УстановитьПараметр("ПустаяЗаписьСкладскогоЖурнала", Справочники.ЗаписиСкладскогоЖурналаВЕТИС.ПустаяСсылка());
	Запрос.УстановитьПараметр("ЭтоИнвентаризация", ПараметрыЗаполнения.ЭтоИнвентаризация);
	
	СписокКолонок = "Номенклатура,Характеристика,Продукция,Серия,ЗаписьСкладскогоЖурнала,ЕдиницаИзмеренияВЕТИС,КоличествоВЕТИС";
	Запрос.УстановитьПараметр("Товары", Товары.Выгрузить(СписокСтрок, СписокКолонок));
	
	Результат = Запрос.ВыполнитьПакет();
	
	ТаблицаОстатки = Результат[Результат.ВГраница()-1].Выгрузить();
	
	Если ТаблицаОстатки.Количество() = 0 Тогда
		Возврат РезультатЗаполнения;
	КонецЕсли; 
	
	ТаблицаСоответствия = Результат[Результат.ВГраница()].Выгрузить();
	ТаблицаСоответствия.Индексы.Добавить("Номенклатура,Характеристика,Продукция,Серия");
	ТаблицаСоответствия.Индексы.Добавить("Номенклатура,Характеристика,Продукция");
	
	ПараметрыЗаполненияСтрок = ОбщегоНазначенияКлиентСервер.СкопироватьСтруктуру(ПараметрыЗаполнения);
	ПараметрыЗаполненияСтрок.Вставить("Товары", Товары);
	ПараметрыЗаполненияСтрок.Вставить("ТаблицаОстатки", ТаблицаОстатки);
	ПараметрыЗаполненияСтрок.Вставить("ТаблицаСоответствия", ТаблицаСоответствия);
	ПараметрыЗаполненияСтрок.Вставить("КэшированныеЗначения", ИнтеграцияВЕТИСКлиентСерверПереопределяемый.ПолучитьСтруктуруКэшируемыеЗначения());
	
	ЗаполнитьВСтрокахЗаписиСкладскогоЖурнала(СтрокиССериями, ПараметрыЗаполненияСтрок, РезультатЗаполнения);
	ЗаполнитьВСтрокахЗаписиСкладскогоЖурнала(СтрокиБезСерий, ПараметрыЗаполненияСтрок, РезультатЗаполнения);
	
	ПодготовитьСообщениеОЗавершенииЗаполненияЗаписейСкладскогоЖурнала(РезультатЗаполнения);
	
	Возврат РезультатЗаполнения;
	
КонецФункции

// Определеяет предполагаемый документ-основание, на основании данных по связанным документам.
//	Сопоставляет данные из ТЗ "СвязанныеДокументы" и ВТ "ДокументыИнформационнойБазы" (см.  ИнтеграцияВЕТИСПереопределяемый.ЗаполнитьВременнуюТаблицуСвязанныхДокументовИнформационнойБазы)
//	по номеру и дате, после чего возвращает первый найденный документ информационной базы, упорядочивая их по полю "ПоказательУпорядочивания"  ВТ "ДокументыИнформационнойБазы"
//	Параметры:
//		СвязанныеДокументы - ТаблицаЗначений - таблица с колонками:
//			* ТипДокумента - ПеречислениеСсылка.ТипыДокументовВЕТИС - тип документа ВЕТИС, служит для определения типа связи с документами ИБ;
//			* Дата - Дата - дата входящего документа, по которой будут сопоставляться данные документов ИБ и данные связанных документов;
//			* Номер - Строка - номер входящего документа, по которому будут сопоставляться данные документов ИБ и данные связанных документов;
//	ВозвращаемоеЗначение:
//		ДокументСсылка, Неопределено - возвращает значение неопределено, если по номеру и дате не найдено ни одного документа ИБ, в противном случае - ссылка на найденный документ.
//
Функция ДокументОснованиеПоДаннымСвязанныхДокументов(СвязанныеДокументы) Экспорт
	
	Запрос = Новый Запрос();
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	ИнтеграцияВЕТИСПереопределяемый.ЗаполнитьВременнуюТаблицуСвязанныхДокументовИнформационнойБазы(Запрос.МенеджерВременныхТаблиц);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СвязанныеДокументы.ТипДокумента КАК ТипДокумента,
	|	СвязанныеДокументы.Серия КАК Серия,
	|	СвязанныеДокументы.Номер КАК Номер,
	|	СвязанныеДокументы.Дата КАК Дата
	|ПОМЕСТИТЬ СвязанныеДокументы
	|ИЗ
	|	&ТаблицаСвязанныхДокументов КАК СвязанныеДокументы
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ТипДокумента,
	|	Дата,
	|	Номер
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ДокументыИнформационнойБазы.Документ КАК Документ
	|	
	|ИЗ
	|	ДокументыИнформационнойБазы КАК ДокументыИнформационнойБазы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ СвязанныеДокументы КАК СвязанныеДокументы
	|		ПО ДокументыИнформационнойБазы.ТипДокумента = СвязанныеДокументы.ТипДокумента
	|			И НАЧАЛОПЕРИОДА(ДокументыИнформационнойБазы.Дата, ДЕНЬ) = СвязанныеДокументы.Дата
	|			И ДокументыИнформационнойБазы.Номер = СвязанныеДокументы.Номер
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВходящаяТранспортнаяОперацияВЕТИС КАК ВходящаяТранспортнаяОперацияВЕТИС
	|		ПО ДокументыИнформационнойБазы.Документ = ВходящаяТранспортнаяОперацияВЕТИС.ДокументОснование
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ИсходящаяТранспортнаяОперацияВЕТИС КАК ИсходящаяТранспортнаяОперацияВЕТИС
	|		ПО ДокументыИнформационнойБазы.Документ = ИсходящаяТранспортнаяОперацияВЕТИС.ДокументОснование
	|ГДЕ
	|	ВходящаяТранспортнаяОперацияВЕТИС.Ссылка ЕСТЬ NULL
	|	И ИсходящаяТранспортнаяОперацияВЕТИС.Ссылка ЕСТЬ NULL
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДокументыИнформационнойБазы.ПоказательУпорядочивания";
	Запрос.УстановитьПараметр("ТаблицаСвязанныхДокументов", СвязанныеДокументы);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Документ;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ЗаполнениеЗаписейСкладскогоЖурнала

Процедура ЗаполнитьВСтрокахЗаписиСкладскогоЖурнала(СписокСтрокДокумента, ПараметрыЗаполнения, РезультатЗаполнения)

	Товары = ПараметрыЗаполнения.Товары;
	ТаблицаОстатки = ПараметрыЗаполнения.ТаблицаОстатки;
	ТаблицаСоответствия = ПараметрыЗаполнения.ТаблицаСоответствия;
	КэшированныеЗначения = ПараметрыЗаполнения.КэшированныеЗначения;
	
	Для каждого СтрокаДокумента Из СписокСтрокДокумента Цикл
		
		Если ПараметрыЗаполнения.ЭтоИнвентаризация Тогда
			ОсталосьЗаполнить = ?(СтрокаДокумента.Операция = Перечисления.ОперацииИнвентаризацииПродукцииВЕТИС.Удаление, 
									0, 
									СтрокаДокумента.КоличествоИзменение);
		Иначе
			ОсталосьЗаполнить = СтрокаДокумента.Количество;
		КонецЕсли; 
		
		Если ОсталосьЗаполнить = 0 
			И ЗначениеЗаполнено(СтрокаДокумента.ЗаписьСкладскогоЖурнала)
			И (НЕ ПараметрыЗаполнения.ЭтоИнвентаризация 
				ИЛИ СтрокаДокумента.Операция <> Перечисления.ОперацииИнвентаризацииПродукцииВЕТИС.Удаление) Тогда
			Продолжить;
		КонецЕсли;
		
		ПродукцияЗаполнена = ЗначениеЗаполнено(СтрокаДокумента.Продукция);
		
		КоличествоСтрок = РезультатЗаполнения.ИзмененныеСтроки.Количество();
		
		Если ЗначениеЗаполнено(СтрокаДокумента.Серия) Тогда
			
			// 1. Если серия указана, то подбирать остатки нужно строго по соответствию серии и записи журнала.
			
			СтруктураПоиска = Новый Структура;
			СтруктураПоиска.Вставить("Номенклатура", СтрокаДокумента.Номенклатура);
			СтруктураПоиска.Вставить("Характеристика", СтрокаДокумента.Характеристика);
			СтруктураПоиска.Вставить("Серия", СтрокаДокумента.Серия);
			Если ЗначениеЗаполнено(СтрокаДокумента.Продукция) Тогда
				СтруктураПоиска.Вставить("Продукция", СтрокаДокумента.Продукция);
			КонецЕсли; 
			СписокСтрокСоответствия = ТаблицаСоответствия.НайтиСтроки(СтруктураПоиска);

			ЗаполнитьЗаписиСкладскогоЖурналаПоСтрокеДокументаИСоответствию(
				СтрокаДокумента, 
				СписокСтрокСоответствия, 
				ПараметрыЗаполнения, 
				ОсталосьЗаполнить,
				РезультатЗаполнения);
			
		Иначе
			
			// 2. Если серия не указана, то сначала подбираются остатки по соответствию продукции и записи журнала.
			
			СтруктураПоиска = Новый Структура;
			СтруктураПоиска.Вставить("Номенклатура", СтрокаДокумента.Номенклатура);
			СтруктураПоиска.Вставить("Характеристика", СтрокаДокумента.Характеристика);
			Если ЗначениеЗаполнено(СтрокаДокумента.Продукция) Тогда
				СтруктураПоиска.Вставить("Продукция", СтрокаДокумента.Продукция);
			КонецЕсли;
			СписокСтрокСоответствия = ТаблицаСоответствия.НайтиСтроки(СтруктураПоиска);
			
			ЗаполнитьЗаписиСкладскогоЖурналаПоСтрокеДокументаИСоответствию(
				СтрокаДокумента, 
				СписокСтрокСоответствия, 
				ПараметрыЗаполнения, 
				ОсталосьЗаполнить,
				РезультатЗаполнения);
				
			// 3. Затем подбираются остатки, для которых нет соответствия.
			Если ЗначениеЗаполнено(СтрокаДокумента.Продукция)
				И (НЕ ПараметрыЗаполнения.ЭтоИнвентаризация 
						И ОсталосьЗаполнить > 0 
					
					ИЛИ ПараметрыЗаполнения.ЭтоИнвентаризация 
						И НЕ ЗначениеЗаполнено(СтрокаДокумента.ЗаписьСкладскогоЖурнала)) Тогда
				
				СтруктураПоиска = Новый Структура;
				СтруктураПоиска.Вставить("Продукция", СтрокаДокумента.Продукция);
				СтруктураПоиска.Вставить("ЕстьСоответствие", Ложь);
				
				ЗаполнитьЗаписиСкладскогоЖурналаПоСтрокеДокумента(
					СтрокаДокумента, 
					СтруктураПоиска,
					ПараметрыЗаполнения,
					ОсталосьЗаполнить,
					РезультатЗаполнения);
					
			КонецЕсли; 
			
		КонецЕсли; 
		
		Если ОсталосьЗаполнить = 0 Тогда
			РезультатЗаполнения.ЗаполненоСтрок = РезультатЗаполнения.ЗаполненоСтрок + 1;
		ИначеЕсли НЕ ЗначениеЗаполнено(СтрокаДокумента.Продукция) Тогда
			РезультатЗаполнения.ПроблемныхСтрок = РезультатЗаполнения.ПроблемныхСтрок + 1;
		КонецЕсли; 
		
		// Добавим строку с остатком, по которому не удалось заполнить запись журнала.
		Если ОсталосьЗаполнить <> 0 И ЗначениеЗаполнено(СтрокаДокумента.ЗаписьСкладскогоЖурнала) Тогда
			
			КоличествоНовыхСтрок = РезультатЗаполнения.ИзмененныеСтроки.Количество() - КоличествоСтрок;
			НоваяСтрока = Товары.Вставить(Товары.Индекс(СтрокаДокумента) + КоличествоНовыхСтрок);
			
			Если ПараметрыЗаполнения.ЭтоИнвентаризация Тогда
				
				ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаДокумента,, "ЗаписьСкладскогоЖурнала,ЕдиницаИзмеренияВЕТИС,КоличествоИзменение,КоличествоИзменениеВЕТИС");
				НоваяСтрока.КоличествоИзменение = ОсталосьЗаполнить;
				
			Иначе
				
				ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаДокумента,, "ЗаписьСкладскогоЖурнала,ЕдиницаИзмеренияВЕТИС,КоличествоВЕТИС");
				НоваяСтрока.Количество = ОсталосьЗаполнить;
				
			КонецЕсли;
			
			ОбработатьДобавлениеНовойСтроки(НоваяСтрока, СтрокаДокумента, ПараметрыЗаполнения);

			Если НЕ ПродукцияЗаполнена Тогда
				НоваяСтрока.Продукция = Справочники.ПродукцияВЕТИС.ПустаяСсылка();
			КонецЕсли;
			
		КонецЕсли; 
		
	КонецЦикла; 
	
КонецПроцедуры

Процедура ЗаполнитьЗаписиСкладскогоЖурналаПоСтрокеДокументаИСоответствию(СтрокаДокумента, СписокСтрокСоответствия, ПараметрыЗаполнения, ОсталосьЗаполнить, РезультатЗаполнения)
	
	Для каждого СтрокаСоответствие Из СписокСтрокСоответствия Цикл
		
		СтруктураПоиска = Новый Структура;
		СтруктураПоиска.Вставить("Продукция", СтрокаСоответствие.Продукция);
		СтруктураПоиска.Вставить("ЗаписьСкладскогоЖурнала", СтрокаСоответствие.ЗаписьСкладскогоЖурнала);
	
		ЗаполнитьЗаписиСкладскогоЖурналаПоСтрокеДокумента(
			СтрокаДокумента, 
			СтруктураПоиска, 
			ПараметрыЗаполнения,
			ОсталосьЗаполнить,
			РезультатЗаполнения);
			
		Если ОсталосьЗаполнить = 0 
			И ЗначениеЗаполнено(СтрокаДокумента.ЗаписьСкладскогоЖурнала)
			И (НЕ ПараметрыЗаполнения.ЭтоИнвентаризация 
				ИЛИ СтрокаДокумента.Операция <> Перечисления.ОперацииИнвентаризацииПродукцииВЕТИС.Удаление) Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьЗаписиСкладскогоЖурналаПоСтрокеДокумента(СтрокаДокумента, СтруктураПоиска, ПараметрыЗаполнения, ОсталосьЗаполнить, РезультатЗаполнения)

	Товары = ПараметрыЗаполнения.Товары;
	ТаблицаОстатки = ПараметрыЗаполнения.ТаблицаОстатки;
	КэшированныеЗначения = ПараметрыЗаполнения.КэшированныеЗначения;
	
	СписокОшибок = Новый Массив;
	ТекстОшибки = Неопределено;
	
	Для каждого СтрокаОстатки Из ТаблицаОстатки Цикл
		
		Если СтрокаОстатки.Количество <= 0 Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаПодходит = Истина;
		Для каждого КлючЗначение Из СтруктураПоиска Цикл
			Если КлючЗначение.Значение <> СтрокаОстатки[КлючЗначение.Ключ] Тогда
				СтрокаПодходит = Ложь;
				Прервать;
			КонецЕсли; 
		КонецЦикла; 
		
		Если НЕ СтрокаПодходит Тогда
			Продолжить;
		КонецЕсли;
		
		Если НЕ ПараметрыЗаполнения.ЭтоИнвентаризация
			ИЛИ СтрокаДокумента.Операция = Перечисления.ОперацииИнвентаризацииПродукцииВЕТИС.Изменение
				И СтрокаДокумента.КоличествоИзменение < 0 Тогда
		
			// 1. Подбор записи на указанное количество.
			
			ОсталосьЗаполнитьВЕТИС = ИнтеграцияВЕТИСКлиентСерверПереопределяемый.ПересчитатьКоличествоЕдиницВЕТИС(
												ОсталосьЗаполнить,
												СтрокаДокумента.Номенклатура,
												СтрокаОстатки.ЕдиницаИзмерения, 
												КэшированныеЗначения,
												ТекстОшибки);
													
			Если ОсталосьЗаполнитьВЕТИС = Неопределено Тогда
				Если ТекстОшибки <> Неопределено И СписокОшибок.Найти(ТекстОшибки) = Неопределено Тогда
					СписокОшибок.Добавить(ТекстОшибки);
				КонецЕсли;
				Продолжить;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(СтрокаДокумента.ЗаписьСкладскогоЖурнала) Тогда
				
				// Нужно добавить новую строку, т.к. в исходной строке уже заполнена запись журнала.
				НоваяСтрока = Товары.Вставить(Товары.Индекс(СтрокаДокумента) + 1);
				ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаДокумента);
				
				ОбработатьДобавлениеНовойСтроки(НоваяСтрока, СтрокаДокумента, ПараметрыЗаполнения);
				
				РезультатЗаполнения.ИзмененныеСтроки.Добавить(НоваяСтрока);
				
				ЗаполнитьКоличествоВСтрокеДокументаПоОстатку(
					НоваяСтрока, 
					СтрокаОстатки,
					ПараметрыЗаполнения, 
					ОсталосьЗаполнить, 
					ОсталосьЗаполнитьВЕТИС);
				
			Иначе
				
				// Заполняем запись журнала в исходной строке.
				РезультатЗаполнения.ИзмененныеСтроки.Добавить(СтрокаДокумента);
				
				ЗаполнитьКоличествоВСтрокеДокументаПоОстатку(
					СтрокаДокумента, 
					СтрокаОстатки,
					ПараметрыЗаполнения, 
					ОсталосьЗаполнить, 
					ОсталосьЗаполнитьВЕТИС);
				
			КонецЕсли;
			
		ИначеЕсли СтрокаДокумента.Операция = Перечисления.ОперацииИнвентаризацииПродукцииВЕТИС.Изменение
			И СтрокаДокумента.КоличествоИзменение > 0 Тогда
			
			// 2. Подбор первой подходящей записи
			
			СтрокаДокумента.ЗаписьСкладскогоЖурнала = СтрокаОстатки.ЗаписьСкладскогоЖурнала;
			СтрокаДокумента.ЕдиницаИзмеренияВЕТИС = СтрокаОстатки.ЕдиницаИзмерения; 
			СтрокаДокумента.Продукция = СтрокаОстатки.Продукция;
			
			СтрокаДокумента.КоличествоИзменениеВЕТИС = ИнтеграцияВЕТИСКлиентСерверПереопределяемый.ПересчитатьКоличествоЕдиницВЕТИС(
																	СтрокаДокумента.КоличествоИзменение,
																	СтрокаДокумента.Номенклатура,
																	СтрокаОстатки.ЕдиницаИзмерения, 
																	КэшированныеЗначения,
																	ТекстОшибки);
												
			РезультатЗаполнения.ИзмененныеСтроки.Добавить(СтрокаДокумента);
			
			СтрокаОстатки.Количество = 0; // Чтобы больше не использовать эту запись.
		
			ОсталосьЗаполнить = 0;
			
		ИначеЕсли СтрокаДокумента.Операция = Перечисления.ОперацииИнвентаризацииПродукцииВЕТИС.Удаление Тогда
			
			// 3. Подбор всех записей
			
			Если ЗначениеЗаполнено(СтрокаДокумента.ЗаписьСкладскогоЖурнала) Тогда
				
				// Нужно добавить новую строку, т.к. в исходной строке уже заполнена запись журнала.
				НоваяСтрока = Товары.Вставить(Товары.Индекс(СтрокаДокумента) + 1);
				ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаДокумента);
				НоваяСтрока.ЗаписьСкладскогоЖурнала = СтрокаОстатки.ЗаписьСкладскогоЖурнала;
				НоваяСтрока.ЕдиницаИзмеренияВЕТИС = СтрокаОстатки.ЕдиницаИзмерения; 
				НоваяСтрока.Продукция = СтрокаОстатки.Продукция;
				
				ОбработатьДобавлениеНовойСтроки(НоваяСтрока, СтрокаДокумента, ПараметрыЗаполнения);
				
				РезультатЗаполнения.ИзмененныеСтроки.Добавить(НоваяСтрока);
				
			Иначе
				
				СтрокаДокумента.ЗаписьСкладскогоЖурнала = СтрокаОстатки.ЗаписьСкладскогоЖурнала;
				СтрокаДокумента.ЕдиницаИзмеренияВЕТИС = СтрокаОстатки.ЕдиницаИзмерения; 
				СтрокаДокумента.Продукция = СтрокаОстатки.Продукция;
				
				РезультатЗаполнения.ИзмененныеСтроки.Добавить(СтрокаДокумента);
				
			КонецЕсли; 
			
			СтрокаОстатки.Количество = 0; // Чтобы больше не использовать эту запись.
			
		КонецЕсли; 
		
		Если ОсталосьЗаполнить = 0
			И ЗначениеЗаполнено(СтрокаДокумента.ЗаписьСкладскогоЖурнала)
			И (НЕ ПараметрыЗаполнения.ЭтоИнвентаризация 
				ИЛИ СтрокаДокумента.Операция <> Перечисления.ОперацииИнвентаризацииПродукцииВЕТИС.Удаление) Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла; 
	
	Если ОсталосьЗаполнить <> 0 Тогда
		Для каждого ТекстОшибки Из СписокОшибок Цикл
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		КонецЦикла; 
	КонецЕсли; 
	
КонецПроцедуры

Процедура ЗаполнитьКоличествоВСтрокеДокументаПоОстатку(СтрокаДокумента, СтрокаОстатки, ПараметрыЗаполнения, ОсталосьЗаполнить, ОсталосьЗаполнитьВЕТИС)
	
	СтрокаДокумента.ЗаписьСкладскогоЖурнала = СтрокаОстатки.ЗаписьСкладскогоЖурнала;
	СтрокаДокумента.ЕдиницаИзмеренияВЕТИС = СтрокаОстатки.ЕдиницаИзмерения; 
	СтрокаДокумента.Продукция = СтрокаОстатки.Продукция;
	
	Если НЕ ПараметрыЗаполнения.ЭтоИнвентаризация
			И СтрокаОстатки.Количество < ОсталосьЗаполнитьВЕТИС
		ИЛИ ПараметрыЗаполнения.ЭтоИнвентаризация
			И СтрокаОстатки.Количество < -ОсталосьЗаполнитьВЕТИС Тогда
		
		// Остаток меньше количества в документе.
		
		СтрокаДокумента[ПараметрыЗаполнения.ИмяПоляКоличествоВЕТИС] = 
			?(ПараметрыЗаполнения.ЭтоИнвентаризация, -СтрокаОстатки.Количество, СтрокаОстатки.Количество);
		
		СтрокаДокумента[ПараметрыЗаполнения.ИмяПоляКоличество] = 
			ИнтеграцияВЕТИСКлиентСерверПереопределяемый.ПересчитатьКоличествоЕдиниц(
										СтрокаДокумента[ПараметрыЗаполнения.ИмяПоляКоличествоВЕТИС],
										СтрокаДокумента.Номенклатура,
										СтрокаДокумента.ЕдиницаИзмеренияВЕТИС, 
										ПараметрыЗаполнения.КэшированныеЗначения);
		
	Иначе
		
		// Остаток больше количества в документе.
		
		СтрокаДокумента[ПараметрыЗаполнения.ИмяПоляКоличествоВЕТИС] = ОсталосьЗаполнитьВЕТИС;
		СтрокаДокумента[ПараметрыЗаполнения.ИмяПоляКоличество] = ОсталосьЗаполнить;
		
	КонецЕсли; 
	
	ОсталосьЗаполнить = ОсталосьЗаполнить - СтрокаДокумента[ПараметрыЗаполнения.ИмяПоляКоличество];
	
	Если ПараметрыЗаполнения.ЭтоИнвентаризация Тогда
		СтрокаОстатки.Количество = 0; // В инвентаризации нельзя одну запись использовать в разных строках.
	Иначе
		СтрокаОстатки.Количество = СтрокаОстатки.Количество - СтрокаДокумента.КоличествоВЕТИС;
	КонецЕсли; 

КонецПроцедуры

Процедура ПодготовитьСообщениеОЗавершенииЗаполненияЗаписейСкладскогоЖурнала(РезультатЗаполнения)

	Если РезультатЗаполнения = Неопределено Тогда
		
		ЗаголовокСообщения = НСтр("ru = 'Заполнение не выполнено'");
		ТекстСообщения = НСтр("ru = 'Требуется заполнить реквизиты Продукция и Номенклатура'");
		КартинкаСообщения = БиблиотекаКартинок.Предупреждение32;
		
	ИначеЕсли РезультатЗаполнения.ВсегоСтрок = 0 Тогда
		
		ЗаголовокСообщения = "";
		ТекстСообщения = НСтр("ru = 'Заполнение не требуется'");
		КартинкаСообщения = БиблиотекаКартинок.Информация32;
		
	ИначеЕсли РезультатЗаполнения.ВсегоСтрок = РезультатЗаполнения.ЗаполненоСтрок Тогда
		
		ЗаголовокСообщения = "";
		ТекстСообщения = НСтр("ru = 'Заполнение успешно завершено'");
		КартинкаСообщения = БиблиотекаКартинок.Успешно32;
		
	ИначеЕсли РезультатЗаполнения.ПроблемныхСтрок = РезультатЗаполнения.ВсегоСтрок Тогда
		
		ЗаголовокСообщения = НСтр("ru = 'Заполнение не выполнено'");
		ТекстСообщения = НСтр("ru = 'Требуется заполнить реквизиты Продукция и Номенклатура'");
		КартинкаСообщения = БиблиотекаКартинок.Предупреждение32;
		
	ИначеЕсли РезультатЗаполнения.ЗаполненоСтрок <> 0 Тогда
		
		ЗаголовокСообщения = НСтр("ru = 'Заполнение выполнено частично'");
		
		Если РезультатЗаполнения.ПроблемныхСтрок <> 0 Тогда
			ТекстСообщения = НСтр("ru = 'Недостаточно остатков продукции и не заполнены обязательные реквизиты'");
		Иначе
			ТекстСообщения = НСтр("ru = 'Недостаточно остатков продукции'");
		КонецЕсли; 
		КартинкаСообщения = БиблиотекаКартинок.Предупреждение32;
		
	Иначе
		
		ЗаголовокСообщения = НСтр("ru = 'Заполнение не выполнено'");
		ТекстСообщения = НСтр("ru = 'Нет остатков продукции'");
		КартинкаСообщения = БиблиотекаКартинок.Предупреждение32;
		
	КонецЕсли;
	
	СообщениеПользователю = Новый Структура;
	СообщениеПользователю.Вставить("ЗаголовокСообщения", ЗаголовокСообщения);
	СообщениеПользователю.Вставить("ТекстСообщения", ТекстСообщения);
	СообщениеПользователю.Вставить("КартинкаСообщения", КартинкаСообщения);
	
	РезультатЗаполнения.Вставить("СообщениеПользователю", СообщениеПользователю);
	
КонецПроцедуры

Процедура ОбработатьДобавлениеНовойСтроки(НоваяСтрока, ИсходнаяСтрока, ПараметрыЗаполнения)

	Если ПараметрыЗаполнения.ИмяПоляИдентификаторСтроки <> Неопределено Тогда
		НоваяСтрока[ПараметрыЗаполнения.ИмяПоляИдентификаторСтроки] = Новый УникальныйИдентификатор;
	КонецЕсли;
	
КонецПроцедуры
 
#КонецОбласти

#Область ПроверкаЗаполненияДокументов

Процедура ПроверитьЗаполнениеДатыПроизводстваСрокаГодности(ДокументОбъект, ИмяТЧ, Отказ) Экспорт
	
	ПредставлениеТЧ = ДокументОбъект.Метаданные().ТабличныеЧасти[ИмяТЧ].Синоним;
	
	ТипЖивыеЖивотные =
		ИнтеграцияВЕТИСВызовСервера.ПродукцияПринадлежитТипуЖивыеЖивотные(ДокументОбъект[ИмяТЧ].ВыгрузитьКолонку("Продукция"));
		
	ШаблонСообщенияСроки = НСтр("ru = 'Не заполнено поле ""%1"" для продукции ""%2"" в строке %3 списка ""%4""'");
	
	ШаблонСравнениеСроков = НСтр("ru = 'Для продукции ""%1"" в строке %2 списка ""%3"" срок годности меньше даты производства'");
	
	Для каждого ТекущаяСтрока Из ДокументОбъект[ИмяТЧ] Цикл
		
		Если НЕ ЗначениеЗаполнено(ТекущаяСтрока.Продукция) Тогда
			Продолжить;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(ТекущаяСтрока.ДатаПроизводстваНачалоПериода)
			И НЕ ЗначениеЗаполнено(ТекущаяСтрока.ДатаПроизводстваСтрока)
			И НЕ ИнтеграцияВЕТИСКлиентСервер.ТочностьЗаполненияБезДаты(ТекущаяСтрока.ДатаПроизводстваТочностьЗаполнения) Тогда
			
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(ИмяТЧ, ТекущаяСтрока.НомерСтроки, "Продукция");
			
			ТекстСообщения = СтрШаблон(
				ШаблонСообщенияСроки,
				ИнтеграцияВЕТИСКлиентСервер.ПредставлениеПоляДатаПроизводства(ТипЖивыеЖивотные[ТекущаяСтрока.Продукция]),
				ТекущаяСтрока.Продукция,
				ТекущаяСтрока.НомерСтроки,
				ПредставлениеТЧ);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ДокументОбъект, Поле,, Отказ);
			
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(ТекущаяСтрока.СрокГодностиНачалоПериода)
			И НЕ ЗначениеЗаполнено(ТекущаяСтрока.СрокГодностиСтрока)
			И НЕ ТипЖивыеЖивотные[ТекущаяСтрока.Продукция]
			И НЕ ИнтеграцияВЕТИСКлиентСервер.ТочностьЗаполненияБезДаты(ТекущаяСтрока.СрокГодностиТочностьЗаполнения) Тогда
			
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(ИмяТЧ, ТекущаяСтрока.НомерСтроки, "Продукция");
			
			ТекстСообщения = СтрШаблон(
				ШаблонСообщенияСроки,
				НСтр("ru = 'Срок годности'"),
				ТекущаяСтрока.Продукция,
				ТекущаяСтрока.НомерСтроки,
				ПредставлениеТЧ);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ДокументОбъект, Поле,, Отказ);
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ТекущаяСтрока.ДатаПроизводстваНачалоПериода)
			И ЗначениеЗаполнено(ТекущаяСтрока.СрокГодностиНачалоПериода)
			И ТекущаяСтрока.СрокГодностиНачалоПериода < ТекущаяСтрока.ДатаПроизводстваНачалоПериода Тогда
			
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(ИмяТЧ, ТекущаяСтрока.НомерСтроки, "Продукция");
			
			ТекстСообщения = СтрШаблон(
				ШаблонСравнениеСроков,
				ТекущаяСтрока.Продукция,
				ТекущаяСтрока.НомерСтроки,
				ПредставлениеТЧ);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ДокументОбъект, Поле,, Отказ);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
