
#Область ПрограммныйИнтерфейс

#Область ПоискНаФормахПодборов

// Процедура выполняет обновление индекса полнотекстового поиска в привилегированном режиме.
//
Процедура ОбновитьИндексПолнотекстовогоПоиска() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	ПолнотекстовыйПоиск.ОбновитьИндекс();
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыИФункцииОбщегоНазначения

// Функция возвращает упаковку хранения номенклатуры, т.е. упаковку с коэффициентом 1 и
// единицей хранения соответствующей единице хранения номенклатуры.
//
// Параметры:
//	Номенклатура (СправочникСсылка.Номенклатура) - номенклатура
//
// Возвращаемое значение:
//	СправочникСсылка.УпаковкиЕдиницыИзмерения
//
Функция ПолучитьУпаковкуХранения(Номенклатура) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СпрНоменклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ПРЕДСТАВЛЕНИЕ(СпрНоменклатура.ЕдиницаИзмерения) КАК ЕдиницаИзмеренияПредставление,
	|	ЕСТЬNULL(СпрУпаковки.Ссылка, НЕОПРЕДЕЛЕНО) КАК Упаковка,
	|	ПРЕДСТАВЛЕНИЕ(СпрУпаковки.Ссылка) КАК УпаковкаПредставление,
	|	ЕСТЬNULL(СпрУпаковки.ЕдиницаИзмерения, НЕОПРЕДЕЛЕНО) КАК ЕдиницаИзмеренияУпаковки,
	|	ЕСТЬNULL(СпрУпаковки.ЕдиницаИзмерения.Представление, """") КАК ЕдиницаИзмеренияУпаковкиПредставление,
	|	ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки, 0) КАК Коэффициент
	|ИЗ
	|	Справочник.Номенклатура КАК СпрНоменклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.УпаковкиЕдиницыИзмерения КАК СпрУпаковки
	|		ПО (СпрУпаковки.Владелец = ВЫБОР
	|				КОГДА СпрНоменклатура.НаборУпаковок = ЗНАЧЕНИЕ(Справочник.НаборыУпаковок.ИндивидуальныйДляНоменклатуры)
	|					ТОГДА СпрНоменклатура.Ссылка
	|				КОГДА СпрНоменклатура.НаборУпаковок <> ЗНАЧЕНИЕ(Справочник.НаборыУпаковок.ПустаяСсылка)
	|					ТОГДА СпрНоменклатура.НаборУпаковок
	|				ИНАЧЕ ЛОЖЬ
	|			КОНЕЦ)
	|			И (НЕ СпрУпаковки.ПометкаУдаления)
	|ГДЕ
	|	СпрНоменклатура.Ссылка = &Номенклатура
	|	И ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки, 0) = 1
	|	И ЕСТЬNULL(СпрУпаковки.ЕдиницаИзмерения, НЕОПРЕДЕЛЕНО) = СпрНоменклатура.ЕдиницаИзмерения
	|
	|УПОРЯДОЧИТЬ ПО
	|	Коэффициент,
	|	ЕдиницаИзмеренияУпаковкиПредставление";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст,
		"&ТекстЗапросаКоэффициентУпаковки",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
		"СпрУпаковки", Неопределено));
		
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		
		Возврат Справочники.УпаковкиЕдиницыИзмерения.ПустаяСсылка();
		
	КонецЕсли;
		
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.Упаковка;
	
КонецФункции

#КонецОбласти

#Область ОтборыВспомогательные

// Функция возвращает список строковых значений реквизита номенклатуры или
// доп.реквизитов номенклатуры. Используется при навигации по виду номенклатуры
// и дереву свойств вида номенклатуры.
//
// Параметры:
//	ВидНоменклатуры (СправочникСсылка.ВидыНоменклатуры) - вид номенклатуры,
//	ИмяРеквизита (Строка) - имя реквизита,
//	ЭтоДопРеквизит (Булево) - признак доп.реквизита,
//	ОтборПоНоменклатуре (Булево) - признак отбора по номенклатуре.
//
// Возвращаемое значение:
//	СписокЗначений. Список строковых значений реквизита или доп.реквизита.
//
Функция СписокЗначенийРеквизита(ВидНоменклатуры, ИмяРеквизита, ЭтоДопРеквизит, ОтборПоНоменклатуре) Экспорт
	
	ЗначенияРеквизита = Новый СписокЗначений;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ВидНоменклатуры", ВидНоменклатуры);
	
	Если Не ЭтоДопРеквизит Тогда
		
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 50
		|	Номенклатура." + ИмяРеквизита + " КАК ЗначениеРеквизита
		|ИЗ
		|	Справочник.Номенклатура КАК Номенклатура
		|ГДЕ
		|	Номенклатура.ВидНоменклатуры = &ВидНоменклатуры
		|	И Номенклатура." + ИмяРеквизита + " <> """"
		|	";
		
	ИначеЕсли ОтборПоНоменклатуре Тогда
		
		Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 50
		|	ДополнительныеРеквизиты.Значение КАК ЗначениеРеквизита
		|ИЗ
		|	Справочник.Номенклатура.ДополнительныеРеквизиты КАК ДополнительныеРеквизиты
		|ГДЕ
		|	ДополнительныеРеквизиты.Свойство.Наименование = &Свойство
		|	И ДополнительныеРеквизиты.Ссылка.ВидНоменклатуры = &ВидНоменклатуры";
		
		Запрос.УстановитьПараметр("Свойство", ИмяРеквизита);
		
	ИначеЕсли Не ОтборПоНоменклатуре Тогда
		
		Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ХарактеристикиДополнительныеРеквизиты.Значение КАК ЗначениеРеквизита
		|ИЗ
		|	Справочник.ХарактеристикиНоменклатуры.ДополнительныеРеквизиты КАК ХарактеристикиДополнительныеРеквизиты
		|ГДЕ
		|	ХарактеристикиДополнительныеРеквизиты.Свойство.Наименование = &Свойство
		|	И ВЫБОР
		|			КОГДА ТИПЗНАЧЕНИЯ(ХарактеристикиДополнительныеРеквизиты.Ссылка.Владелец) = ТИП(Справочник.ВидыНоменклатуры)
		|				ТОГДА ХарактеристикиДополнительныеРеквизиты.Ссылка.Владелец = &ВидНоменклатуры
		|			ИНАЧЕ ХарактеристикиДополнительныеРеквизиты.Ссылка.Владелец.ВидНоменклатуры = &ВидНоменклатуры
		|		КОНЕЦ";
		
		Запрос.УстановитьПараметр("Свойство", ИмяРеквизита);
		
	КонецЕсли;

	МассивЗначений = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ЗначениеРеквизита");
	ЗначенияРеквизита.ЗагрузитьЗначения(МассивЗначений);
	
	Возврат ЗначенияРеквизита;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти
