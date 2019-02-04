#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет список команд создания на основании.
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	СозданиеНаОснованииПереопределяемый.ДобавитьКомандуСоздатьНаОснованииБизнесПроцессЗадание(КомандыСозданияНаОсновании);
	
	ВыкупВозвратнойТарыУПоставщикаЛокализация.ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры);

КонецПроцедуры

// Добавляет команду создания документа "Выкуп возвратной тары у поставщика".
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	Если ПравоДоступа("Добавление", Метаданные.Документы.ВыкупВозвратнойТарыУПоставщика) Тогда
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.ВыкупВозвратнойТарыУПоставщика.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(Метаданные.Документы.ВыкупВозвратнойТарыУПоставщика);
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		КомандаСоздатьНаОсновании.ФункциональныеОпции = "ИспользоватьМногооборотнуюТару";
	

		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;

	Возврат Неопределено;
КонецФункции

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица с командами отчетов. Для изменения.
//       См. описание 1 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуСтруктураПодчиненности(КомандыОтчетов);
	
	
	
	Отчеты.КарточкаРасчетовПоПринятойВозвратнойТаре.ДобавитьКомандуОтчета(КомандыОтчетов);
	
	Отчеты.КарточкаРасчетовСПоставщиками.ДобавитьКомандуКарточкаРасчетовСПоставщикомПоДокументам(КомандыОтчетов);
	
	Отчеты.СостояниеРасчетовСПоставщиками.ДобавитьКомандуОтчетаПоДокументам(КомандыОтчетов);
	
	ВыкупВозвратнойТарыУПоставщикаЛокализация.ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры);

КонецПроцедуры

// Функция определяет реквизиты выбранного документа.
//
// Параметры:
//  ДокументСсылка - Ссылка на документа.
//
// Возвращаемое значение:
//	Структура - реквизиты выбранного документа.
//
Функция РеквизитыДокумента(ДокументСсылка) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ДанныеДокумента.Дата КАК Дата,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.Партнер КАК Партнер,
	|	ДанныеДокумента.Контрагент КАК Контрагент,
	|	ДанныеДокумента.Валюта КАК Валюта,
	|	ДанныеДокумента.ВалютаВзаиморасчетов КАК ВалютаВзаиморасчетов,
	|	ДанныеДокумента.СуммаДокумента КАК СуммаДокумента,
	|	ДанныеДокумента.СуммаВзаиморасчетов КАК СуммаВзаиморасчетов,
	|	ДанныеДокумента.Проведен КАК Проведен,
	|	ДанныеДокумента.Договор КАК Договор,
	|	ДанныеДокумента.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	ДанныеДокумента.ПорядокРасчетов КАК ПорядокРасчетов,
	|	ДанныеДокумента.Курс КАК Курс,
	|	ДанныеДокумента.Кратность КАК Кратность
	|
	|ИЗ
	|	Документ.ВыкупВозвратнойТарыУПоставщика КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &ДокументСсылка
	|");
	
	Запрос.УстановитьПараметр("ДокументСсылка", ДокументСсылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Дата = Выборка.Дата;
		Организация = Выборка.Организация;
		Партнер = Выборка.Партнер;
		Контрагент = Выборка.Контрагент;
		Договор = Выборка.Договор;
		НаправлениеДеятельности = Выборка.НаправлениеДеятельности;
		ПорядокРасчетов = Выборка.ПорядокРасчетов;
		Валюта = Выборка.Валюта;
		ВалютаВзаиморасчетов = Выборка.ВалютаВзаиморасчетов;
		ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщика;
		СуммаДокумента = Выборка.СуммаДокумента;
		СуммаВзаиморасчетов = ?(Выборка.Проведен, Выборка.СуммаВзаиморасчетов, 0);
		Кратность = Выборка.Кратность;
		Курс = Выборка.Курс;
	Иначе
		Дата = Дата(1,1,1);
		Организация = Справочники.Организации.ПустаяСсылка();
		Партнер = Справочники.Партнеры.ПустаяСсылка();
		Контрагент = Справочники.Контрагенты.ПустаяСсылка();
		Договор = Справочники.ДоговорыКонтрагентов.ПустаяСсылка();
		НаправлениеДеятельности = Справочники.НаправленияДеятельности.ПустаяСсылка();
		ПорядокРасчетов = Перечисления.ПорядокРасчетов.ПустаяСсылка();
		Валюта = Справочники.Валюты.ПустаяСсылка();
		ВалютаВзаиморасчетов = Справочники.Валюты.ПустаяСсылка();
		ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщика;
		СуммаДокумента = 0;
		СуммаВзаиморасчетов = 0;
		Кратность = 1;
		Курс = 1;
	КонецЕсли;
	
	СтруктураРеквизитов = Новый Структура;
	СтруктураРеквизитов.Вставить("Дата", Дата);
	СтруктураРеквизитов.Вставить("Организация", Организация);
	СтруктураРеквизитов.Вставить("Партнер", Партнер);
	СтруктураРеквизитов.Вставить("Контрагент", Контрагент);
	СтруктураРеквизитов.Вставить("Договор", Договор);
	СтруктураРеквизитов.Вставить("ПорядокРасчетов", ПорядокРасчетов);
	СтруктураРеквизитов.Вставить("Валюта", Валюта);
	СтруктураРеквизитов.Вставить("ВалютаВзаиморасчетов", ВалютаВзаиморасчетов);
	СтруктураРеквизитов.Вставить("ХозяйственнаяОперация", ХозяйственнаяОперация);
	СтруктураРеквизитов.Вставить("СуммаДокумента", СуммаДокумента);
	СтруктураРеквизитов.Вставить("СуммаВзаиморасчетов", СуммаВзаиморасчетов);
	СтруктураРеквизитов.Вставить("Курс", Курс);
	СтруктураРеквизитов.Вставить("Кратность", Кратность);
	СтруктураРеквизитов.Вставить("НаправлениеДеятельности", НаправлениеДеятельности);
	
	Возврат СтруктураРеквизитов;

КонецФункции

// Возвращает структуру параметров для заполнения налогообложения НДС закупки.
//
// Параметры:
//  Объект - ДокументОбъект.ВыкупВозвратнойТарыУПоставщика - документ, по которому необходимо сформировать параметры.
//
// Возвращаемое значение:
//  Структура - Параметры заполнения, описание параметров см. УчетНДСУПКлиентСервер.ПараметрыЗаполненияНалогообложенияНДСЗакупки();
//
Функция ПараметрыЗаполненияНалогообложенияНДСЗакупки(Объект) Экспорт

	ПараметрыЗаполнения = УчетНДСУПКлиентСервер.ПараметрыЗаполненияНалогообложенияНДСЗакупки();
	
	ПараметрыЗаполнения.Контрагент = Объект.Контрагент;
	ПараметрыЗаполнения.Договор = Объект.Договор;

	ПараметрыЗаполнения.ВыкупВозвратнойТарыУПоставщика = Истина;
	
	Возврат ПараметрыЗаполнения;
	
КонецФункции

//++ НЕ УТ
#Область ПроводкиРеглУчета

// Функция возвращает текст запроса для отражения документа в регламентированном учете.
//
// Возвращаемое значение:
//	Строка - Текст запроса
//
Функция ТекстОтраженияВРеглУчете() Экспорт

	Возврат ВыкупВозвратнойТарыУПоставщикаЛокализация.ТекстОтраженияВРеглУчете();

КонецФункции

// Функция возвращает текст запроса дополнительных временных таблиц,
// необходимых для отражения в регламентированном учете.
//
// Возвращаемое значение:
//	Строка - текст запроса
//
Функция ТекстЗапросаВТОтраженияВРеглУчете() Экспорт

	Возврат ВыкупВозвратнойТарыУПоставщикаЛокализация.ТекстЗапросаВТОтраженияВРеглУчете();

КонецФункции

#КонецОбласти
//-- НЕ УТ

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(Партнер)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#Область УчетНДС

// Инициализирует параметры регистрации счетов-фактур (полученных)
//
// Параметры:
//  Объект		- ДокументОбъект.ВыкупВозвратнойТарыУПоставщика, ДанныеФормыСтруктура	- документ, для которого необходимо получить параметры.
//
// Возвращаемое значение:
//  Структура - структура параметров, см. УчетНДСУПКлиентСервер.ПараметрыРегистрацииСчетовФактурПолученных().
//
Функция ПараметрыРегистрацииСчетовФактурПолученных(Объект) Экспорт
	
	ПараметрыРегистрации = УчетНДСУПКлиентСервер.ПараметрыРегистрацииСчетовФактурПолученных();
	
	ПараметрыРегистрации.Ссылка				= Объект.Ссылка;
	ПараметрыРегистрации.Дата				= Объект.Дата;
	ПараметрыРегистрации.Организация		= Объект.Организация;
	ПараметрыРегистрации.Контрагент			= Объект.Контрагент;
	ПараметрыРегистрации.НалогообложениеНДС	= Объект.НалогообложениеНДС;
			
	ПараметрыРегистрации.ПриобретениеТоваровРаботУслуг  = Истина;
	
	Возврат ПараметрыРегистрации;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает значение реквизита, прочитанного из информационной базы по ссылке на объект
// см. ОбщегоНазначения.ЗначениеРеквизитаОбъекта()
// Если полученное значение не имеет тип булево, возвращается значение Ложь.
//
Функция ЗначениеРеквизитаОбъектаТипаБулево(Ссылка, ИмяРеквизита) Экспорт
	УстановитьПривилегированныйРежим(Истина);
	Результат = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, ИмяРеквизита);
	Если ТипЗнч(Результат) <> Тип("Булево") Тогда
		Результат = Ложь;
	КонецЕсли;
	УстановитьПривилегированныйРежим(Ложь);	
	Возврат Результат
КонецФункции

#Область Проведение

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт

	ИсточникиДанных = Новый Соответствие;

	Возврат ИсточникиДанных; 

КонецФункции

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка, СтруктураДополнительныеСвойства)
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДанныеДокумента.Дата КАК Период,
	|	ДанныеДокумента.Номер КАК Номер,
	|	ДанныеДокумента.Валюта КАК Валюта,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.Партнер КАК Партнер,
	|	ДанныеДокумента.Контрагент КАК Контрагент,
	|	ДанныеДокумента.ПредусмотренЗалогЗаТару КАК ПредусмотренЗалогЗаТару,
	|	ДанныеДокумента.ДатаПлатежа КАК ДатаПлатежа,
	|	ДанныеДокумента.ВалютаВзаиморасчетов КАК ВалютаВзаиморасчетов,
	|	ДанныеДокумента.ФормаОплаты КАК ФормаОплаты,
	|	ДанныеДокумента.Договор КАК Договор,
	|	ВЫБОР КОГДА ДанныеДокумента.ПорядокРасчетов = ЗНАЧЕНИЕ(Перечисление.ПорядокРасчетов.ПоДоговорамКонтрагентов) ТОГДА
	|		ИСТИНА
	|	ИНАЧЕ
	|		ЛОЖЬ
	|	КОНЕЦ КАК РасчетыПоДоговорам,
	|	ДанныеДокумента.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	ВЫБОР КОГДА ДанныеДокумента.ПорядокРасчетов = ЗНАЧЕНИЕ(Перечисление.ПорядокРасчетов.ПоДоговорамКонтрагентов)
	|		И ЕСТЬNULL(ДанныеДокумента.Договор.ЗаданГрафикИсполнения, ЛОЖЬ) ТОГДА
	|		ИСТИНА
	|	ИНАЧЕ
	|		ЛОЖЬ
	|	КОНЕЦ КАК ГрафикИсполненияВДоговоре
	|
	|ИЗ
	|	Документ.ВыкупВозвратнойТарыУПоставщика КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка";
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	Запрос.УстановитьПараметр("Период",                                        Реквизиты.Период);
	Запрос.УстановитьПараметр("Номер",                                         Реквизиты.Номер);
	Запрос.УстановитьПараметр("Партнер",                                       Реквизиты.Партнер);
	Запрос.УстановитьПараметр("Организация",                                   Реквизиты.Организация);
	Запрос.УстановитьПараметр("Валюта",                                        Реквизиты.Валюта);
	Запрос.УстановитьПараметр("ПредусмотренЗалогЗаТару",                       Реквизиты.ПредусмотренЗалогЗаТару);
	Запрос.УстановитьПараметр("ВалютаРегламентированногоУчета",                Константы.ВалютаРегламентированногоУчета.Получить());
	Запрос.УстановитьПараметр("ВалютаУправленческогоУчета",                    Константы.ВалютаУправленческогоУчета.Получить());
	Запрос.УстановитьПараметр("ДатаПлатежа",                                   Реквизиты.ДатаПлатежа);
	Запрос.УстановитьПараметр("ФормаОплаты",                                   Реквизиты.ФормаОплаты);
	Запрос.УстановитьПараметр("ВалютаВзаиморасчетов",                          Реквизиты.ВалютаВзаиморасчетов);
	Запрос.УстановитьПараметр("Договор",                                       Реквизиты.Договор);
	Запрос.УстановитьПараметр("РасчетыПоДоговорам",                            Реквизиты.РасчетыПоДоговорам);
	Запрос.УстановитьПараметр("АналитикаУчетаПоПартнерам",                     РегистрыСведений.АналитикаУчетаПоПартнерам.ЗначениеКлючаАналитики(Реквизиты));
	Запрос.УстановитьПараметр("ГрафикИсполненияВДоговоре",                     Реквизиты.ГрафикИсполненияВДоговоре);
	
	УстановитьПараметрыЗапросаКоэффициентыВалют(Запрос);
	
КонецПроцедуры

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт

	////////////////////////////////////////////////////////////////////////////
	// Создадим запрос инициализации движений
	
	Запрос = Новый Запрос;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка, ДополнительныеСвойства);
	
	////////////////////////////////////////////////////////////////////////////
	// Сформируем текст запроса
	
	ТекстыЗапроса = Новый СписокЗначений;
	ТекстЗапросаТаблицаПринятаяВозвратнаяТара(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаСуммыДокументовВВалютеРегл(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаРасчетыСПоставщиками(Запрос, ТекстыЗапроса, Регистры);
	
	ОтразитьВУчетеНДС(Запрос, ТекстыЗапроса, Регистры);
	
	ВыкупВозвратнойТарыУПоставщикаЛокализация.ДополнитьТекстыЗапросовПроведения(Запрос, ТекстыЗапроса, Регистры);
	
	ПроведениеСерверУТ.ИнициализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Истина);
	
КонецПроцедуры

Процедура ИнициализироватьВтСуммыДокументовВВалютахУчета(Запрос, ТекстыЗапроса) Экспорт
	
	ТекстДанныеДокумента = 
	"ВЫБРАТЬ
	|	Товары.Ссылка КАК Ссылка,
	|	Товары.Ссылка.Дата КАК Дата,
	|	Товары.Ссылка.Валюта КАК ВалютаДокумента,
	|	Товары.Ссылка.ВалютаВзаиморасчетов КАК ВалютаВзаиморасчетов,
	|	Товары.ИдентификаторСтроки КАК ИдентификаторСтроки,
	|	Товары.СтавкаНДС КАК СтавкаНДС,
	|	Товары.СуммаСНДС КАК СуммаСНДС,
	|	Товары.СуммаНДС КАК СуммаНДС,
	|	(Товары.СуммаСНДС - Товары.СуммаНДС) КАК СуммаБезНДС,
	|	Товары.СуммаВзаиморасчетов КАК СуммаВзаиморасчетов,
	|	Товары.СуммаНДСВзаиморасчетов КАК СуммаНДСВзаиморасчетов
	|ИЗ
	|	Документ.ВыкупВозвратнойТарыУПоставщика.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка В (&Ссылка)
	|";
	ПроведениеСерверУТ.ИнициализироватьВтСуммыДокументовВВалютахУчета(Запрос, ТекстыЗапроса, ТекстДанныеДокумента);

КонецПроцедуры

Функция ТекстЗапросаТаблицаПринятаяВозвратнаяТара(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПринятаяВозвратнаяТара";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;

	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ТаблицаТовары.НомерСтроки              КАК НомерСтроки,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	&Период                                КАК Период,
	|	ТаблицаТовары.Номенклатура             КАК Номенклатура,
	|	ТаблицаТовары.Характеристика           КАК Характеристика,
	|	ТаблицаТовары.Количество               КАК Количество,
	|	ТаблицаТовары.СуммаСНДС                КАК Сумма,
	|	&Партнер                               КАК Партнер,
	|	ТаблицаТовары.ДокументПоступления      КАК ДокументПоступления,
	|	ИСТИНА                                 КАК Выкуп,
	|	&ПредусмотренЗалогЗаТару               КАК ПредусмотренЗалог
	|ИЗ
	|	Документ.ВыкупВозвратнойТарыУПоставщика.Товары КАК ТаблицаТовары
	|ГДЕ
	|	ТаблицаТовары.Ссылка = &Ссылка
	|	И ТаблицаТовары.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаСуммыДокументовВВалютеРегл(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "СуммыДокументовВВалютеРегл";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ТаблицаТовары.НомерСтроки КАК НомерСтроки,
	|	&Период КАК Период,
	|	&Валюта КАК Валюта,
	|	ТаблицаТовары.ИдентификаторСтроки КАК ИдентификаторСтроки,
	|	ТаблицаТовары.СуммаСНДС - ТаблицаТовары.СуммаНДС КАК СуммаБезНДС,
	|	ТаблицаТовары.СтавкаНДС КАК СтавкаНДС,
	|	ТаблицаТовары.СуммаНДС КАК СуммаНДС,
	|	ВЫБОР 
	|	КОГДА &Валюта = &ВалютаРегламентированногоУчета ТОГДА ТаблицаТовары.СуммаСНДС - ТаблицаТовары.СуммаНДС
	|	КОГДА ТаблицаТовары.СуммаСНДС - ТаблицаТовары.СуммаНДС = ЕСТЬNULL(ДанныеРегистра.СуммаБезНДС, 0) ТОГДА
	|		ЕСТЬNULL(ДанныеРегистра.СуммаБезНДСРегл, 0)
	|	ИНАЧЕ
	|		0
	|	КОНЕЦ КАК СуммаБезНДСРегл,
	|	ВЫБОР 
	|	КОГДА &Валюта = &ВалютаРегламентированногоУчета ТОГДА ТаблицаТовары.СуммаНДС
	|	КОГДА ТаблицаТовары.СуммаНДС = ЕСТЬNULL(ДанныеРегистра.СуммаНДС, 0) ТОГДА
	|		ЕСТЬNULL(ДанныеРегистра.СуммаНДСРегл, 0)
	|	ИНАЧЕ
	|		0
	|	КОНЕЦ КАК СуммаНДСРегл,
	|	ВЫБОР 
	|	КОГДА &Валюта = &ВалютаРегламентированногоУчета ТОГДА ТаблицаТовары.СуммаСНДС - ТаблицаТовары.СуммаНДС
	|	КОГДА ТаблицаТовары.СуммаСНДС - ТаблицаТовары.СуммаНДС = ЕСТЬNULL(ДанныеРегистра.СуммаБезНДС, 0) ТОГДА
	|		ВЫБОР
	|			КОГДА ЕСТЬNULL(ДанныеРегистра.БазаНДСРегл, 0) = 0
	|				ТОГДА ЕСТЬNULL(ДанныеРегистра.СуммаБезНДСРегл, 0)
	|			ИНАЧЕ ЕСТЬNULL(ДанныеРегистра.БазаНДСРегл, 0)
	|		КОНЕЦ
	|	ИНАЧЕ
	|		0
	|	КОНЕЦ КАК БазаНДСРегл,
	|	ВЫБОР 
	|	КОГДА &Валюта = &ВалютаРегламентированногоУчета ТОГДА ТаблицаТовары.СуммаСНДС - ТаблицаТовары.СуммаНДС
	|	КОГДА ТаблицаТовары.СуммаСНДС - ТаблицаТовары.СуммаНДС = ЕСТЬNULL(ДанныеРегистра.СуммаБезНДС, 0) ТОГДА
	|		ВЫБОР
	|			КОГДА ЕСТЬNULL(ДанныеРегистра.БазаНДСУпр, 0) = 0
	|				ТОГДА ЕСТЬNULL(ДанныеРегистра.СуммаБезНДСУпр, 0)
	|			ИНАЧЕ ЕСТЬNULL(ДанныеРегистра.БазаНДСУпр, 0)
	|		КОНЕЦ
	|	ИНАЧЕ
	|		0
	|	КОНЕЦ КАК БазаНДСУпр,
	|
	|	ВЫБОР 
	|	КОГДА &Валюта = &ВалютаУправленческогоУчета ТОГДА ТаблицаТовары.СуммаСНДС - ТаблицаТовары.СуммаНДС
	|	КОГДА ТаблицаТовары.СуммаСНДС - ТаблицаТовары.СуммаНДС = ЕСТЬNULL(ДанныеРегистра.СуммаБезНДС, 0) ТОГДА
	|		ЕСТЬNULL(ДанныеРегистра.СуммаБезНДСУпр, 0)
	|	ИНАЧЕ
	|		0
	|	КОНЕЦ КАК СуммаБезНДСУпр,
	|	ВЫБОР 
	|	КОГДА &Валюта = &ВалютаУправленческогоУчета ТОГДА ТаблицаТовары.СуммаНДС
	|	КОГДА ТаблицаТовары.СуммаНДС = ЕСТЬNULL(ДанныеРегистра.СуммаНДС, 0) ТОГДА
	|		ЕСТЬNULL(ДанныеРегистра.СуммаНДСУпр, 0)
	|	ИНАЧЕ
	|		0
	|	КОНЕЦ КАК СуммаНДСУпр,
	|
	|	ЗНАЧЕНИЕ(Перечисление.ТипыРасчетовСПартнерами.РасчетыСПоставщиком) КАК ТипРасчетов,
	|	
	|	ТаблицаТовары.СуммаВзаиморасчетов КАК СуммаВзаиморасчетов,
	|	&ВалютаВзаиморасчетов КАК ВалютаВзаиморасчетов
	|
	|ИЗ
	|	Документ.ВыкупВозвратнойТарыУПоставщика.Товары КАК ТаблицаТовары
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.СуммыДокументовВВалютеРегл КАК ДанныеРегистра
	|	ПО
	|		ДанныеРегистра.Регистратор = &Ссылка
	|		И ТаблицаТовары.ИдентификаторСтроки = ДанныеРегистра.ИдентификаторСтроки
	|
	|ГДЕ
	|	ТаблицаТовары.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаРасчетыСПоставщиками(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "РасчетыСПоставщиками";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	УстановитьПараметрыЗапросаКоэффициентыВалют(Запрос);
	
	//Порядок и состав полей запроса проведения
	ШаблонПолей = "
	|ВЫБРАТЬ
	|	Шаблон.Период                                                   КАК Период,
	|	Шаблон.ДатаРегистратора                                         КАК ДатаРегистратора,
	|	Шаблон.НомерРегистратора                                        КАК НомерРегистратора,
	|	Шаблон.ДатаПлатежа                                              КАК ДатаПлатежа,
	|	Шаблон.ВидДвижения                                              КАК ВидДвижения,
	|	Шаблон.АналитикаУчетаПоПартнерам                                КАК АналитикаУчетаПоПартнерам,
	|	Шаблон.Валюта                                                   КАК Валюта,
	|	Шаблон.ЗаказПоставщику                                          КАК ЗаказПоставщику,
	|	Шаблон.ЗакупкаПоЗаказу                                          КАК ЗакупкаПоЗаказу,
	|	Шаблон.ХозяйственнаяОперация                                    КАК ХозяйственнаяОперация,
	|	Шаблон.ФормаОплаты                                              КАК ФормаОплаты,
	|	Шаблон.Сумма                                                    КАК Сумма,
	|	Шаблон.КОплате                                                  КАК КОплате,
	|	Шаблон.КПоступлению                                             КАК КПоступлению,
	|	Шаблон.СуммаРегл                                                КАК СуммаРегл,
	|	Шаблон.СуммаУпр                                                 КАК СуммаУпр,
	|	Шаблон.ЗалогЗаТару                                              КАК ЗалогЗаТару,
	|	Шаблон.Организация                                              КАК Организация,
	|	Шаблон.ВалютаДокумента                                          КАК ВалютаДокумента,
	|	Шаблон.КорОбъектРасчетов                                        КАК КорОбъектРасчетов
	|ИЗ
	|	#Шаблон КАК Шаблон
	|ГДЕ
	|	&ОтборШаблон
	|";
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	&Период КАК Период,
	|	&Период КАК ДатаРегистратора,
	|	&Номер КАК НомерРегистратора,
	|	&ДатаПлатежа КАК ДатаПлатежа,
	|
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	&АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам,
	|	&ВалютаВзаиморасчетов КАК Валюта,
	|	ВЫБОР КОГДА &РасчетыПоДоговорам ТОГДА
	|		&Договор
	|	ИНАЧЕ
	|		&Ссылка
	|	КОНЕЦ КАК ЗаказПоставщику,
	|
	|	Неопределено КАК ЗакупкаПоЗаказу,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ЗакупкаУПоставщика) КАК ХозяйственнаяОперация,
	|	Неопределено КАК ФормаОплаты,
	|	ДанныеДокумента.СуммаВзаиморасчетов КАК Сумма,
	|	0 КАК КОплате,
	|	0 КАК КОтгрузке,
	|	ВЫБОР 
	|		КОГДА ДанныеДокумента.ВалютаВзаиморасчетов = &ВалютаРегламентированногоУчета 
	|			ТОГДА ДанныеДокумента.СуммаВзаиморасчетов
	|		ИНАЧЕ ВЫРАЗИТЬ(ДанныеДокумента.СуммаДокумента * &КоэффициентПересчетаВВалютуРегл КАК ЧИСЛО(31,2))
	|	КОНЕЦ КАК СуммаРегл,
	|	ВЫБОР 
	|		КОГДА ДанныеДокумента.ВалютаВзаиморасчетов = &ВалютаУправленческогоУчета 
	|			ТОГДА ДанныеДокумента.СуммаВзаиморасчетов
	|		ИНАЧЕ ВЫРАЗИТЬ(ДанныеДокумента.СуммаДокумента * &КоэффициентПересчетаВВалютуУПР КАК ЧИСЛО(31,2))
	|	КОНЕЦ КАК СуммаУпр,
	|	0 КАК ЗалогЗаТару,
	|	&Организация КАК Организация,
	|	&Валюта КАК ВалютаДокумента,
	|	Неопределено  КАК КорОбъектРасчетов
	|ИЗ
	|	Документ.ВыкупВозвратнойТарыУПоставщика КАК ДанныеДокумента
	|
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|	И НЕ &ПредусмотренЗалогЗаТару
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	КОНЕЦПЕРИОДА(&ДатаПлатежа, День) КАК Период,
	|	&Период КАК ДатаРегистратора,
	|	&Номер КАК НомерРегистратора,
	|	&ДатаПлатежа КАК ДатаПлатежа,
	|
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	&АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам,
	|	&ВалютаВзаиморасчетов КАК Валюта,
	|	ВЫБОР КОГДА &РасчетыПоДоговорам ТОГДА
	|		&Договор
	|	ИНАЧЕ
	|		&Ссылка
	|	КОНЕЦ КАК ЗаказПоставщику,
	|
	|	Неопределено КАК ЗакупкаПоЗаказу,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ЗакупкаУПоставщика) КАК ХозяйственнаяОперация,
	|	&ФормаОплаты КАК ФормаОплаты,
	|	0 КАК Сумма,
	|	ДанныеДокумента.СуммаВзаиморасчетов КАК КОплате,
	|	0 КАК КОтгрузке,
	|	0 КАК СуммаРегл,
	|	0 КАК СуммаУпр,
	|	0 КАК ЗалогЗаТару,
	|	&Организация КАК Организация,
	|	&Валюта КАК ВалютаДокумента,
	|	Неопределено  КАК КорОбъектРасчетов
	|ИЗ
	|	Документ.ВыкупВозвратнойТарыУПоставщика КАК ДанныеДокумента
	|
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|	И НЕ &ПредусмотренЗалогЗаТару
	|	И НЕ &ГрафикИсполненияВДоговоре
	|
	|//ЗачетАвансовПоставщикуПоНакладной
	|
	|";
	
	ТекстЗапроса=СтрЗаменить(ТекстЗапроса,"//ЗачетАвансовПоставщикуПоНакладной",
		ВзаиморасчетыСервер.ТекстПроведенияЗачетАвансовПоставщикуПоНакладной("ВыкупВозвратнойТарыУПоставщика", ШаблонПолей));
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Процедура УстановитьПараметрыЗапросаКоэффициентыВалют(Запрос)
	
	Если Запрос.Параметры.Свойство("КоэффициентПересчетаВВалютуУпр")
		И Запрос.Параметры.Свойство("КоэффициентПересчетаВВалютуРегл") Тогда
		Возврат;
	КонецЕсли;
	
	Коэффициенты = РаботаСКурсамивалютУТ.ПолучитьКоэффициентыПересчетаВалюты(
		Запрос.Параметры.Валюта, 
		Запрос.Параметры.ВалютаВзаиморасчетов,
		Запрос.Параметры.Период);
	
	Запрос.УстановитьПараметр("КоэффициентПересчетаВВалютуУпр",           Коэффициенты.КоэффициентПересчетаВВалютуУПР);
	Запрос.УстановитьПараметр("КоэффициентПересчетаВВалютуРегл",          Коэффициенты.КоэффициентПересчетаВВалютуРегл);
	
КонецПроцедуры

Процедура ОтразитьВУчетеНДС(Запрос, ТекстыЗапроса, Регистры)
	
	ТекстЦенности =
	"ВЫБРАТЬ
	|	Товары.Ссылка.Дата КАК Период,
	|	Товары.Ссылка КАК Ссылка,
	|	Товары.Ссылка.Организация КАК Организация,
	|	Товары.Ссылка.Подразделение КАК Подразделение,
	|	Товары.Ссылка.Контрагент КАК Контрагент,
	|	НЕОПРЕДЕЛЕНО КАК Договор,
	|	НЕОПРЕДЕЛЕНО КАК Грузоотправитель,
	|	Товары.Ссылка КАК ДокументПриобретения,
	|	ЛОЖЬ КАК ИсправлениеОшибок,
	|	ЛОЖЬ КАК КорректировкаПоСогласованиюСторон,
	|	НЕОПРЕДЕЛЕНО КАК ДокументКорректировкиПриобретения,
	|	Товары.Ссылка.НалогообложениеНДС КАК НалогообложениеНДС,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаНеОблагаетсяНДС) КАК ВидДеятельностиНДС,
	|	Товары.СтавкаНДС КАК СтавкаНДС,
	|	Товары.Номенклатура КАК Номенклатура,
	|	НЕОПРЕДЕЛЕНО КАК ВидЗапасов,
	|	НЕОПРЕДЕЛЕНО КАК НомерГТД,
	|	НЕОПРЕДЕЛЕНО КАК ПодразделениеУчета,
	|	НЕОПРЕДЕЛЕНО КАК НаправлениеДеятельности,
	|	НЕОПРЕДЕЛЕНО КАК СтатьяРасходов,
	|	НЕОПРЕДЕЛЕНО КАК АналитикаРасходов,
	|	НЕОПРЕДЕЛЕНО КАК СтатьяПрочихАктивов,
	|	НЕОПРЕДЕЛЕНО КАК АналитикаПрочихАктивов,
	|	НЕОПРЕДЕЛЕНО КАК Назначение,
	|	Товары.ИдентификаторСтроки КАК ИдентификаторСтроки,
	|	НЕОПРЕДЕЛЕНО КАК АналитикаУчетаНоменклатуры,
	|	НЕОПРЕДЕЛЕНО КАК АналитикаУчетаПартий
	|ИЗ
	|	Документ.ВыкупВозвратнойТарыУПоставщика.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка В (&Ссылка)
	|";
	УчетНДСУП.ОтразитьПриобретениеУПоставщика(Запрос, ТекстыЗапроса, Регистры, ТекстЦенности);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
