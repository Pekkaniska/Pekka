#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	// Ниже приведеный код, должен выполняться до проверки:
	// Если ОбменДанными.Загрузка Тогда
	//	Возврат
	// КонецЕсли;
	// т.к. существет проверка на доп. свойство ДляПроведения, и 
	// данный объект в РИБ при записи должен создавать запись р/с Задания к перерасчету взаиморасчетов.
	
	Если Не ДополнительныеСвойства.Свойство("ДляПроведения") Тогда
		Возврат;
	КонецЕсли;
	
	БлокироватьДляИзменения = Истина;
	
	// Текущее состояние набора помещается во временную таблицу,
	// чтобы при записи получить изменение нового набора относительно текущего.
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Таблица.Регистратор                  КАК Регистратор,
	|	Таблица.ЗаказПоставщику              КАК ЗаказПоставщику,
	|	Таблица.Валюта                       КАК Валюта,
	|	ВЫБОР КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) ТОГДА
	|			ВЫБОР КОГДА Таблица.Сумма < 0 ТОГДА
	|					0
	|				ИНАЧЕ -Таблица.Сумма
	|			КОНЕЦ
	|		ИНАЧЕ Таблица.Сумма
	|	КОНЕЦ                                КАК СуммаПередЗаписью
	|
	|ПОМЕСТИТЬ РасчетыСПоставщикамиПередЗаписью
	|ИЗ
	|	РегистрНакопления.РасчетыСПоставщиками КАК Таблица
	|ГДЕ
	|	Таблица.Регистратор = &Регистратор
	|	И НЕ &ЭтоНовый
	|	И Таблица.ЗаказПоставщику <> НЕОПРЕДЕЛЕНО
	|	И НЕ &ОбменДанными
	|;
	|/////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Расчеты.Период                        КАК Период,
	|	Расчеты.Регистратор                   КАК Регистратор,
	|	Расчеты.ВидДвижения                   КАК ВидДвижения,
	|	Расчеты.АналитикаУчетаПоПартнерам     КАК АналитикаУчетаПоПартнерам,
	|	Расчеты.ЗаказПоставщику               КАК ЗаказПоставщику,
	|	Расчеты.Валюта                        КАК Валюта,
	|	Расчеты.ХозяйственнаяОперация         КАК ХозяйственнаяОперация,
	|	Расчеты.Сумма                         КАК Сумма,
	|	Расчеты.Оплачивается                  КАК Оплачивается,
	|	Расчеты.СуммаРегл                     КАК СуммаРегл,
	|	Расчеты.СуммаУпр                      КАК СуммаУпр,
	|	Расчеты.КОплате                       КАК КОплате,
	|	Расчеты.КПоступлению                  КАК КПоступлению,
	|	Расчеты.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств,
	|	Расчеты.ПорядокОперации               КАК ПорядокОперации,
	|	Расчеты.ПорядокЗачетаПоДатеПлатежа    КАК ПорядокЗачетаПоДатеПлатежа,
	|	Расчеты.РасчетныйДокумент             КАК РасчетныйДокумент,
	|	Расчеты.КорОбъектРасчетов             КАК КорОбъектРасчетов,
	|	Расчеты.ВалютаДокумента               КАК ВалютаДокумента,
	|	Расчеты.ДатаПлатежа                   КАК ДатаПлатежа
	|ПОМЕСТИТЬ РасчетыСПоставщикамиИсходныеДвижения
	|ИЗ
	|	РегистрНакопления.РасчетыСПоставщиками КАК Расчеты
	|ГДЕ
	|	Расчеты.Регистратор = &Регистратор
	|	И Расчеты.Сумма <> 0
	|");
	
	Запрос.УстановитьПараметр("Регистратор",  Отбор.Регистратор.Значение);
	Запрос.УстановитьПараметр("ЭтоНовый",     ?(ДополнительныеСвойства.Свойство("ЭтоНовый"), ДополнительныеСвойства.ЭтоНовый, Ложь));
	Запрос.УстановитьПараметр("ОбменДанными", ОбменДанными.Загрузка);
	Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	СФормироватьТаблицуОбъектовОплаты();
	РегистрыСведений.ГрафикПлатежей.УстановитьБлокировкиДанныхДляРасчетаГрафика(
		ДополнительныеСвойства.ТаблицаОбъектовОплаты, "РегистрНакопления.РасчетыСПоставщиками", "ЗаказПоставщику");
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	// Проверка:
	// Если ОбменДанными.Загрузка Тогда
	//	Возврат
	// КонецЕсли;
	// Не требуется, т.к. существет проверка на доп. свойство ДляПроведения,
	// а данный объект в РИБ при записи должен создавать запись р/с Задания к перерасчету взаиморасчетов.
	
	Если НЕ ДополнительныеСвойства.Свойство("ДляПроведения") Тогда
		Возврат;
	КонецЕсли;

	Запрос = Новый Запрос;
	
	МассивТекстовЗапроса = Новый Массив;
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НАЧАЛОПЕРИОДА(Таблица.Период, МЕСЯЦ) КАК Месяц,
	|	Таблица.ПорядокОперации              КАК ПорядокОперации,
	|	Таблица.ПорядокЗачетаПоДатеПлатежа   КАК ПорядокЗачетаПоДатеПлатежа,
	|	Таблица.АналитикаУчетаПоПартнерам    КАК АналитикаУчетаПоПартнерам,
	|	Таблица.ЗаказПоставщику              КАК ОбъектРасчетов,
	|	Таблица.Валюта                       КАК ВалютаРасчетов,
	|	&Регистратор                         КАК Документ,
	|	СУММА(Таблица.Сумма)                 КАК Сумма,
	|	СУММА(Таблица.КОплате)               КАК КОплате,
	|	СУММА(Таблица.КПоступлению)          КАК КПоступлению,
	|	СУММА(Таблица.СуммаРегл)             КАК СуммаРегл,
	|	СУММА(Таблица.СуммаУпр)              КАК СуммаУпр,
	|	Ключи.Организация                    КАК Организация,
	|	Таблица.КорОбъектРасчетов            КАК КорОбъектРасчетов
	|ПОМЕСТИТЬ РасчетыСПоставщикамиИзменения
	|ИЗ
	|	(ВЫБРАТЬ
	|		Расчеты.Период                        КАК Период,
	|		Расчеты.АналитикаУчетаПоПартнерам     КАК АналитикаУчетаПоПартнерам,
	|		Расчеты.ЗаказПоставщику               КАК ЗаказПоставщику,
	|		Расчеты.Валюта                        КАК Валюта,
	|		Расчеты.Сумма                         КАК Сумма,
	|		Расчеты.Оплачивается                  КАК Оплачивается,
	|		Расчеты.ХозяйственнаяОперация         КАК ХозяйственнаяОперация,
	|		Расчеты.СуммаРегл                     КАК СуммаРегл,
	|		Расчеты.СуммаУпр                      КАК СуммаУпр,
	|		Расчеты.КОплате                       КАК КОплате,
	|		Расчеты.КПоступлению                  КАК КПоступлению,
	|		Расчеты.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств,
	|		Расчеты.ПорядокОперации               КАК ПорядокОперации,
	|		Расчеты.ПорядокЗачетаПоДатеПлатежа    КАК ПорядокЗачетаПоДатеПлатежа,
	|		Расчеты.РасчетныйДокумент             КАК РасчетныйДокумент,
	|		Расчеты.КорОбъектРасчетов             КАК КорОбъектРасчетов,
	|		Расчеты.ВалютаДокумента               КАК ВалютаДокумента,
	|		Расчеты.ДатаПлатежа                   КАК ДатаПлатежа,
	|		ВЫБОР КОГДА ТИПЗНАЧЕНИЯ(Расчеты.Регистратор) = ТИП(Документ.ВзаимозачетЗадолженности)
	|				И Расчеты.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) И Расчеты.Сумма > 0
	|			ТОГДА 0
	|			КОГДА ТИПЗНАЧЕНИЯ(Расчеты.Регистратор) = ТИП(Документ.ВзаимозачетЗадолженности)
	|				И Расчеты.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) И Расчеты.Сумма < 0
	|			ТОГДА -1
	|			ИНАЧЕ 1
	|		КОНЕЦ КАК ИндексДвиженияВзаимозачета
	|	ИЗ
	|		РасчетыСПоставщикамиИсходныеДвижения КАК Расчеты
	|		
	|	ОБЪЕДИНИТЬ ВСЕ
	|		
	|	ВЫБРАТЬ
	|		Расчеты.Период                        КАК Период,
	|		Расчеты.АналитикаУчетаПоПартнерам     КАК АналитикаУчетаПоПартнерам,
	|		Расчеты.ЗаказПоставщику               КАК ЗаказПоставщику,
	|		Расчеты.Валюта                        КАК Валюта,
	|		-Расчеты.Сумма                        КАК Сумма,
	|		-Расчеты.Оплачивается                 КАК Оплачивается,
	|		Расчеты.ХозяйственнаяОперация         КАК ХозяйственнаяОперация,
	|		-Расчеты.СуммаРегл                    КАК СуммаРегл,
	|		-Расчеты.СуммаУпр                     КАК СуммаУпр,
	|		-Расчеты.КОплате                      КАК КОплате,
	|		-Расчеты.КПоступлению                 КАК КПоступлению,
	|		Расчеты.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств,
	|		Расчеты.ПорядокОперации               КАК ПорядокОперации,
	|		Расчеты.ПорядокЗачетаПоДатеПлатежа    КАК ПорядокЗачетаПоДатеПлатежа,
	|		Расчеты.РасчетныйДокумент             КАК РасчетныйДокумент,
	|		Расчеты.КорОбъектРасчетов             КАК КорОбъектРасчетов,
	|		Расчеты.ВалютаДокумента               КАК ВалютаДокумента,
	|		Расчеты.ДатаПлатежа                   КАК ДатаПлатежа,
	|		ВЫБОР КОГДА ТИПЗНАЧЕНИЯ(Расчеты.Регистратор) = ТИП(Документ.ВзаимозачетЗадолженности)
	|				И Расчеты.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) И Расчеты.Сумма > 0
	|			ТОГДА 0
	|			КОГДА ТИПЗНАЧЕНИЯ(Расчеты.Регистратор) = ТИП(Документ.ВзаимозачетЗадолженности)
	|				И Расчеты.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) И Расчеты.Сумма < 0
	|			ТОГДА -1
	|			ИНАЧЕ 1
	|		КОНЕЦ КАК ИндексДвиженияВзаимозачета
	|	ИЗ РегистрНакопления.РасчетыСПоставщиками КАК Расчеты
	|	ГДЕ Расчеты.Регистратор = &Регистратор
	|) КАК Таблица
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаПоПартнерам КАК Ключи
	|	ПО Ключи.Ссылка = Таблица.АналитикаУчетаПоПартнерам
	|СГРУППИРОВАТЬ ПО
	|	Таблица.Период,
	|	Таблица.АналитикаУчетаПоПартнерам,
	|	Таблица.ЗаказПоставщику,
	|	Таблица.Валюта,
	|	Таблица.ХозяйственнаяОперация,
	|	Таблица.СтатьяДвиженияДенежныхСредств,
	|	Таблица.РасчетныйДокумент,
	|	Таблица.КорОбъектРасчетов,
	|	Таблица.ВалютаДокумента,
	|	Таблица.ДатаПлатежа,
	|	Таблица.ИндексДвиженияВзаимозачета,
	|	Ключи.Организация,
	|	Таблица.ПорядокОперации,
	|	Таблица.ПорядокЗачетаПоДатеПлатежа

	|ИМЕЮЩИЕ
	|	СУММА(Таблица.Сумма) <> 0
	|	ИЛИ СУММА(Таблица.СуммаРегл) <> 0
	|	ИЛИ СУММА(Таблица.СуммаУпр) <> 0
	|	ИЛИ СУММА(Таблица.КОплате) <> 0
	|	ИЛИ СУММА(Таблица.КПоступлению) <> 0";
	МассивТекстовЗапроса.Добавить(ТекстЗапроса);
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ТаблицаИзменений.ЗаказПоставщику        КАК ЗаказПоставщику,
	|	ТаблицаИзменений.Валюта                 КАК Валюта,
	|	СУММА(ТаблицаИзменений.СуммаКИзменению) КАК СуммаКИзменению
	|	
	|ПОМЕСТИТЬ ДвиженияРасчетыСПоставщикамиИзменениеАвансыПоНакладным
	|ИЗ
	|	(ВЫБРАТЬ
	|		Таблица.ЗаказПоставщику            КАК ЗаказПоставщику,
	|		Таблица.Валюта                     КАК Валюта,
	|		Таблица.СуммаПередЗаписью          КАК СуммаКИзменению
	|	ИЗ
	|		РасчетыСПоставщикамиПередЗаписью КАК Таблица
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Таблица.ЗаказПоставщику  КАК ЗаказПоставщику,
	|		Таблица.Валюта           КАК Валюта,
	|		-Таблица.Сумма           КАК СуммаКИзменению
	|	ИЗ
	|		РегистрНакопления.РасчетыСПоставщиками КАК Таблица
	|	ГДЕ
	|		Таблица.Регистратор = &Регистратор
	|		И ТИПЗНАЧЕНИЯ(Таблица.ЗаказПоставщику)В (ТИП(Документ.ПоступлениеБезналичныхДенежныхСредств),
	|													ТИП(Документ.СписаниеБезналичныхДенежныхСредств),
	|													ТИП(Документ.ПриходныйКассовыйОрдер),
	|													ТИП(Документ.РасходныйКассовыйОрдер),
	|													ТИП(Документ.ОперацияПоПлатежнойКарте))
	|		И (Таблица.ЗаказПоставщику <> ЗНАЧЕНИЕ(Документ.ПоступлениеБезналичныхДенежныхСредств.ПустаяСсылка)
	|			И Таблица.ЗаказПоставщику <> ЗНАЧЕНИЕ(Документ.СписаниеБезналичныхДенежныхСредств.ПустаяСсылка)
	|			И Таблица.ЗаказПоставщику <> ЗНАЧЕНИЕ(Документ.ПриходныйКассовыйОрдер.ПустаяСсылка)
	|			И Таблица.ЗаказПоставщику <> ЗНАЧЕНИЕ(Документ.РасходныйКассовыйОрдер.ПустаяСсылка)
	|			И Таблица.ЗаказПоставщику <> ЗНАЧЕНИЕ(Документ.ОперацияПоПлатежнойКарте.ПустаяСсылка)
	|			)
	|
	|) КАК ТаблицаИзменений
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаИзменений.ЗаказПоставщику,
	|	ТаблицаИзменений.Валюта
	|
	|ИМЕЮЩИЕ
	|	СУММА(ТаблицаИзменений.СуммаКИзменению) <> 0";
	МассивТекстовЗапроса.Добавить(ТекстЗапроса);
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Таблица.Месяц КАК Месяц,
	|	Таблица.АналитикаУчетаПоПартнерам    КАК АналитикаУчетаПоПартнерам,
	|	Таблица.ОбъектРасчетов               КАК ОбъектРасчетов,
	|	ВЫБОР КОГДА &НовыеРасчеты
	|		ТОГДА НЕОПРЕДЕЛЕНО
	|		ИНАЧЕ Таблица.Документ
	|	КОНЕЦ								 КАК Документ,
	|	Таблица.Организация КАК Организация,
	|	ЗНАЧЕНИЕ(Перечисление.ОперацииЗакрытияМесяца.ФормированиеДвиженийПоРасчетамСПартнерамиИПереоценкаРасчетов) КАК Операция
	|ПОМЕСТИТЬ РасчетыСПоставщикамиЗаданияКЗакрытиюМесяца
	|ИЗ РасчетыСПоставщикамиИзменения КАК Таблица
	|ГДЕ
	|	Таблица.Сумма <> 0 ИЛИ Таблица.СуммаРегл <> 0 ИЛИ Таблица.СуммаУпр <> 0
	//++ НЕ УТ
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Таблица.Месяц КАК Месяц,
	|	Таблица.АналитикаУчетаПоПартнерам    КАК АналитикаУчетаПоПартнерам,
	|	Таблица.ОбъектРасчетов               КАК ОбъектРасчетов,
	|	НЕОПРЕДЕЛЕНО						 КАК Документ,
	|	Таблица.Организация КАК Организация,
	|	ЗНАЧЕНИЕ(Перечисление.ОперацииЗакрытияМесяца.ПризнаниеРасходовПриУСН) КАК Операция
	|ИЗ РасчетыСПоставщикамиИзменения КАК Таблица
	|ГДЕ
	|	&НовыеРасчеты И (Таблица.Сумма <> 0 ИЛИ Таблица.СуммаРегл <> 0 ИЛИ Таблица.СуммаУпр <> 0)
	//-- НЕ УТ
	|";
	МассивТекстовЗапроса.Добавить(ТекстЗапроса);
	
	//++ НЕ УТ
	ВнеоборотныеАктивы.ДополнитьТекстыЗапросовПриЗаписиРегистраРасчетыСПоставщиками(Запрос, МассивТекстовЗапроса);
	//-- НЕ УТ
	
	МассивТекстовЗапроса.Добавить("УНИЧТОЖИТЬ РасчетыСПоставщикамиПередЗаписью");
	МассивТекстовЗапроса.Добавить("УНИЧТОЖИТЬ РасчетыСПоставщикамиИсходныеДвижения");
	
	Запрос.Текст = СтрСоединить(МассивТекстовЗапроса, ОбщегоНазначения.РазделительПакетаЗапросов());
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.УстановитьПараметр("НовыеРасчеты", ПолучитьФункциональнуюОпцию("НоваяАрхитектураВзаиморасчетов"));
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	ВыборкаИзменениеАвансыПоНакладным = МассивРезультатов[1].Выбрать();
	ВыборкаИзменениеАвансыПоНакладным.Следующий();
	СтруктураВременныеТаблицы.Вставить("ДвиженияРасчетыСПоставщикамиИзменениеАвансыПоНакладным", ВыборкаИзменениеАвансыПоНакладным.Количество > 0);
	
	//++ НЕ УТ
	ВнеоборотныеАктивы.СформироватьЗаданияПриЗаписиРегистраРасчетыСПоставщиками(
		МассивРезультатов, 3, СтруктураВременныеТаблицы);
	//-- НЕ УТ
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("НоваяАрхитектураВзаиморасчетов") Тогда
		ОперативныеВзаиморасчетыСервер.РассчитатьПоИзменениям(Запрос.МенеджерВременныхТаблиц, Ложь, Отбор.Регистратор.Значение, ДополнительныеСвойства);
	КонецЕсли;
	
	РегистрыСведений.ГрафикПлатежей.РассчитатьГрафикПлатежейПоРасчетамСПоставщиками(
		ДополнительныеСвойства.ТаблицаОбъектовОплаты.ВыгрузитьКолонку("ОбъектОплаты"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Формирует таблицу заказов, которые были раньше в движениях и которые сейчас будут записаны.
//
Процедура СФормироватьТаблицуОбъектовОплаты()

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Таблица.ЗаказПоставщику КАК ОбъектОплаты
	|ИЗ
	|	РегистрНакопления.РасчетыСПоставщиками КАК Таблица
	|ГДЕ
	|	Таблица.Регистратор = &Регистратор
	|	И Таблица.ЗаказПоставщику <> НЕОПРЕДЕЛЕНО
	|";
	
	ТаблицаОбъектовОплаты = Запрос.Выполнить().Выгрузить();
	
	ТаблицаНовыхОбъектовОплаты = Выгрузить(, "ЗаказПоставщику");
	ТаблицаНовыхОбъектовОплаты.Свернуть("ЗаказПоставщику");
	Для Каждого Запись Из ТаблицаНовыхОбъектовОплаты Цикл
		Если Не ЗначениеЗаполнено(Запись.ЗаказПоставщику) Тогда
			Продолжить;
		КонецЕсли;
		Если ТаблицаОбъектовОплаты.Найти(Запись.ЗаказПоставщику, "ОбъектОплаты") = Неопределено Тогда
			ТаблицаОбъектовОплаты.Добавить().ОбъектОплаты = Запись.ЗаказПоставщику;
		КонецЕсли;
	КонецЦикла;
	
	ДополнительныеСвойства.Вставить("ТаблицаОбъектовОплаты", ТаблицаОбъектовОплаты);
	
КонецПроцедуры

Процедура ЗагрузитьСОбработкой(ТаблицаРасчетов) Экспорт
	
	ВзаиморасчетыСервер.ДобавитьЗаполнитьПорядокРасчетовСПоставщиками(ТаблицаРасчетов, ТипЗнч(ЭтотОбъект.Отбор.Регистратор.Значение));
	ЭтотОбъект.Загрузить(ТаблицаРасчетов);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли