
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Выполняет обновление регистра распоряжений по формированию счетов-фактур.
// 
// Параметры:
// 	ДокументРегистратор - ДокументСсылка - Документ при записи которого инициируется обновление регистра распоряжений.
// 	ОснованияСчетаФактуры - Массив - Массив оснований счетов-фактур, для которых необходимо обновить регистр распоряжений.
// 	УдалениеПроведения - Булево - Признак того, выполняется отмена проведения документа-регистратора.
//
Процедура ОбновитьСостояние(ДокументРегистратор, ОснованияСчетаФактуры, УдалениеПроведения = Ложь) Экспорт
	
	// 1. Если это проведение/отмена проведения счета-фактуры проверяются документы:
	//		- основания счета-фактуры перед записью
	//		- основания счета-фактуры в записываемом объекте
	// 2. Если это проведение документа-основания, то проверяется сам документ
	// 3. Если это отмена проведения документа-основания, то документ автоматически удаляется из регистра.
	
	Если ТипЗнч(ДокументРегистратор) = Тип("ДокументСсылка.СчетФактураВыданный")
		ИЛИ ТипЗнч(ДокументРегистратор) = Тип("ДокументСсылка.СчетФактураПолученныйНалоговыйАгент") Тогда
		СнятьНеобходимостьНепосредственно = Ложь;
	Иначе
		СнятьНеобходимостьНепосредственно = УдалениеПроведения;
	КонецЕсли;
	
	Если СнятьНеобходимостьНепосредственно Тогда
		
		Для Каждого СтрокаСсылка Из ОснованияСчетаФактуры Цикл
			Набор = РегистрыСведений.ТребуетсяОформлениеСчетаФактуры.СоздатьНаборЗаписей();
			Набор.Отбор.Основание.Установить(СтрокаСсылка);
			Набор.Записать(Истина);
		КонецЦикла;
		
		Возврат;
		
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДанныеДокумента.Ссылка                 КАК СчетФактура,
	|	ДанныеДокумента.ДокументОснование      КАК Основание,
	|	ДанныеДокумента.Ссылка.Организация     КАК Организация,
	|	ДанныеДокумента.Ссылка.Контрагент      КАК Контрагент,
	|	&ТипСФВыданный                         КАК ТипСчетаФактуры
	|ПОМЕСТИТЬ ТаблицаСчетовФактуры
	|ИЗ
	|	Документ.СчетФактураВыданный.ДокументыОснования КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.ДокументОснование В(&МассивОснований)
	|	И ДанныеДокумента.Ссылка.Проведен
	|	//УсловиеИсключенияСчетаФактуры
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДанныеДокумента.Ссылка                 КАК СчетФактура,
	|	ДанныеДокумента.ДокументОснование      КАК Основание,
	|	ДанныеДокумента.Ссылка.Организация     КАК Организация,
	|	ДанныеДокумента.Ссылка.Контрагент      КАК Контрагент,
	|	&ТипСФПолученныйНалоговыйАгент         КАК ТипСчетаФактуры
	|ИЗ
	|	Документ.СчетФактураПолученныйНалоговыйАгент.ДокументыОснования КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.ДокументОснование В(&МассивОснований)
	|	И ДанныеДокумента.Ссылка.Проведен
	|	//УсловиеИсключенияСчетаФактуры
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;
	|///////////////////////////////////////////////////////////////////////////////
	|
	|ВЫБРАТЬ
	|	ДанныеПервичныхДокументов.ДатаРегистратора КАК Дата,
	|	ДанныеПервичныхДокументов.Организация КАК Организация,
	|	ДанныеПервичныхДокументов.Документ КАК Ссылка
	|ПОМЕСТИТЬ ДанныеПервичныхДокументов
	|ИЗ
	|	РегистрСведений.ДанныеПервичныхДокументов КАК ДанныеПервичныхДокументов
	|ГДЕ
	|	ДанныеПервичныхДокументов.Документ В (&МассивОснований)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;
	|
	|///////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеПервичныхДокументов.Организация       КАК Организация,
	|	ДанныеПервичныхДокументов.Ссылка            КАК Ссылка,
	|	МАКСИМУМ(УчетнаяПолитикаОрганизаций.Период) КАК Период
	|ПОМЕСТИТЬ ПериодыУчетныхПолитик
	|ИЗ
	|	ДанныеПервичныхДокументов КАК ДанныеПервичныхДокументов
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.УчетнаяПолитикаОрганизаций КАК УчетнаяПолитикаОрганизаций
	|	ПО
	|		ДанныеПервичныхДокументов.Дата >= УчетнаяПолитикаОрганизаций.Период
	|		И ДанныеПервичныхДокументов.Организация = УчетнаяПолитикаОрганизаций.Организация
	|	
	|СГРУППИРОВАТЬ ПО
	|	ДанныеПервичныхДокументов.Организация,
	|	ДанныеПервичныхДокументов.Ссылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;
	|
	|///////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПериодыУчетныхПолитик.Организация                     КАК Организация,
	|	ПериодыУчетныхПолитик.Ссылка                          КАК Ссылка,
	|	СпрУчетныеПолитики.ПрименяетсяОсвобождениеОтУплатыНДС КАК ПрименяетсяОсвобождениеОтУплатыНДС
	|ПОМЕСТИТЬ УчетнаяПолитика
	|ИЗ
	|	ПериодыУчетныхПолитик КАК ПериодыУчетныхПолитик
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.УчетнаяПолитикаОрганизаций КАК УчетнаяПолитикаОрганизаций
	|	ПО
	|		ПериодыУчетныхПолитик.Период = УчетнаяПолитикаОрганизаций.Период
	|		И ПериодыУчетныхПолитик.Организация = УчетнаяПолитикаОрганизаций.Организация
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Справочник.УчетныеПолитикиОрганизаций КАК СпрУчетныеПолитики
	|	ПО
	|		УчетнаяПолитикаОрганизаций.УчетнаяПолитика = СпрУчетныеПолитики.Ссылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;
	|
	|
	|///////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеОснованийСчетовФактур.Регистратор     КАК Основание,
	|	ДанныеОснованийСчетовФактур.ТипСчетаФактуры КАК ТипСчетаФактуры,
	|	ДанныеПервичныхДокументов.Дата              КАК ДатаДокумента,
	|	ДанныеОснованийСчетовФактур.Организация     КАК Организация,
	|	ДанныеОснованийСчетовФактур.Контрагент      КАК Контрагент,
	|	ДанныеОснованийСчетовФактур.Валюта          КАК Валюта,
	|	МАКСИМУМ(
	|		ВЫБОР
	|			КОГДА ТаблицаСчетовФактуры.СчетФактура ЕСТЬ NULL
	|				ТОГДА
	|					ВЫБОР
	|						КОГДА ДанныеОснованийСчетовФактур.НалогообложениеНДС В (
	|									ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаНеОблагаетсяНДС))
	|								И УчетнаяПолитика.ПрименяетсяОсвобождениеОтУплатыНДС
	|							ТОГДА ИСТИНА
	|						КОГДА ДанныеОснованийСчетовФактур.НалогообложениеНДС В (
	|									ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаНаЭкспорт),
	|									ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ЭкспортСырьевыхТоваровУслуг),
	|									ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ЭкспортНесырьевыхТоваров),
	|									ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаОблагаетсяНДС),
	|									ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПроизводствоСДЦ),
	|									ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ОблагаетсяНДСУПокупателя))
	|								И ДанныеОснованийСчетовФактур.СтавкаНДС <> ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.БезНДС)
	|							ТОГДА ИСТИНА
	|						ИНАЧЕ ЛОЖЬ
	|					КОНЕЦ
	|			ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ) КАК Требуется
	|ИЗ
	|	РегистрСведений.ДанныеОснованийСчетовФактур КАК ДанныеОснованийСчетовФактур
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ТаблицаСчетовФактуры КАК ТаблицаСчетовФактуры
	|	ПО 
	|		ДанныеОснованийСчетовФактур.Регистратор = ТаблицаСчетовФактуры.Основание
	|		И ДанныеОснованийСчетовФактур.Организация = ТаблицаСчетовФактуры.Организация
	|		И ДанныеОснованийСчетовФактур.Контрагент = ТаблицаСчетовФактуры.Контрагент
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		УчетнаяПолитика КАК УчетнаяПолитика
	|	ПО 
	|		ДанныеОснованийСчетовФактур.Регистратор = УчетнаяПолитика.Ссылка
	|		И ДанныеОснованийСчетовФактур.Организация = УчетнаяПолитика.Организация
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ 
	|		ДанныеПервичныхДокументов КАК ДанныеПервичныхДокументов
	|	ПО 
	|		ДанныеОснованийСчетовФактур.Регистратор = ДанныеПервичныхДокументов.Ссылка
	|ГДЕ
	|	ДанныеОснованийСчетовФактур.Регистратор В (&МассивОснований)
	|	И ДанныеОснованийСчетовФактур.ТипСчетаФактуры В (&ТипСФВыданный, &ТипСФПолученныйНалоговыйАгент)
	|
	|СГРУППИРОВАТЬ ПО
	|	ДанныеОснованийСчетовФактур.Регистратор,
	|	ДанныеОснованийСчетовФактур.ТипСчетаФактуры,
	|	ДанныеПервичныхДокументов.Дата,
	|	ДанныеОснованийСчетовФактур.Организация,
	|	ДанныеОснованийСчетовФактур.Контрагент,
	|	ДанныеОснованийСчетовФактур.Валюта
	|";
	
	Запрос = Новый Запрос;
	Если (ТипЗнч(ДокументРегистратор) = Тип("ДокументСсылка.СчетФактураВыданный")
		ИЛИ ТипЗнч(ДокументРегистратор) = Тип("ДокументСсылка.СчетФактураПолученныйНалоговыйАгент"))
		И УдалениеПроведения Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, 
			"//УсловиеИсключенияСчетаФактуры", 
			"И ДанныеДокумента.Ссылка <> &ТекушийСчетФактура");
		Запрос.УстановитьПараметр("ТекушийСчетФактура", ДокументРегистратор);
	КонецЕсли;
	
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("МассивОснований", ОснованияСчетаФактуры);
	Запрос.УстановитьПараметр("ТипСФВыданный", ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.СчетФактураВыданный"));
	Запрос.УстановитьПараметр("ТипСФПолученныйНалоговыйАгент", ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.СчетФактураПолученныйНалоговыйАгент"));
	
	ТаблицаЗапроса = Запрос.Выполнить().Выгрузить();
	Для каждого Основание Из ОснованияСчетаФактуры Цикл
		
		НаборЗаписей = РегистрыСведений.ТребуетсяОформлениеСчетаФактуры.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Основание.Установить(Основание);
		
		Строки = ТаблицаЗапроса.НайтиСтроки(Новый Структура("Основание", Основание));
		Для каждого Строка Из Строки Цикл
			Если Строка.Требуется Тогда
				Запись = НаборЗаписей.Добавить();
				ЗаполнитьЗначенияСвойств(Запись, Строка);
			КонецЕсли;
		КонецЦикла;
		
		НаборЗаписей.Записать(Истина);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область Обработчики_11_4_6

// Регистрирует данные для обработчика обновления УТ 11.4.6
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТребуетсяОформлениеСчетаФактуры.Основание КАК Основание,
	|	ТребуетсяОформлениеСчетаФактуры.Организация КАК Организация,
	|	ТребуетсяОформлениеСчетаФактуры.Контрагент КАК Контрагент
	|ИЗ
	|	РегистрСведений.ТребуетсяОформлениеСчетаФактуры КАК ТребуетсяОформлениеСчетаФактуры
	|ГДЕ
	|	ТребуетсяОформлениеСчетаФактуры.ТипСчетаФактуры = ЗНАЧЕНИЕ(Справочник.ИдентификаторыОбъектовМетаданных.ПустаяСсылка)";
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоНезависимыйРегистрСведений = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра = "РегистрСведений.ТребуетсяОформлениеСчетаФактуры";
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Запрос.Выполнить().Выгрузить(), ДополнительныеПараметры);
	
КонецПроцедуры

// Заполняет измерение ТипСчетаФактуры значением по умолчанию - СФ выданный
//
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяРегистра = "РегистрСведений.ТребуетсяОформлениеСчетаФактуры";
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоНезависимыйРегистрСведений = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра = ПолноеИмяРегистра;
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	ВыборкаДляОбработки = ОбновлениеИнформационнойБазы.ВыбратьИзмеренияНезависимогоРегистраСведенийДляОбработки(Параметры.Очередь,ПолноеИмяРегистра);
		
	Пока ВыборкаДляОбработки.Следующий() Цикл
		
		НачатьТранзакцию();
		
		Попытка
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяРегистра);
			ЭлементБлокировки.УстановитьЗначение("Основание", ВыборкаДляОбработки.Основание);
			ЭлементБлокировки.УстановитьЗначение("Организация", ВыборкаДляОбработки.Организация);
			ЭлементБлокировки.УстановитьЗначение("Контрагент", ВыборкаДляОбработки.Контрагент);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			Блокировка.Заблокировать();
		Исключение
			ОтменитьТранзакцию();
			ОбновлениеИнформационнойБазыУТ.СообщитьОНеудачнойБлокировке(ВыборкаДляОбработки.Основание);
			Продолжить;
		КонецПопытки;
	
		Набор = СоздатьНаборЗаписей();
		Набор.Отбор.Основание.Установить(ВыборкаДляОбработки.Основание);
		Набор.Отбор.Организация.Установить(ВыборкаДляОбработки.Организация);
		Набор.Отбор.Контрагент.Установить(ВыборкаДляОбработки.Контрагент);
		
		Набор.Прочитать();
		
		Для Каждого Запись Из Набор Цикл
			Если Запись.ТипСчетаФактуры.Пустая() Тогда
				Запись.ТипСчетаФактуры = ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.СчетФактураВыданный");
			КонецЕсли;
		КонецЦикла;
		
		Попытка
			ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(Набор);
			ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Набор.Выгрузить(,"Основание,Организация,Контрагент"),ДополнительныеПараметры,Параметры.Очередь);
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ОбновлениеИнформационнойБазыУТ.СообщитьОНеудачнойОбработке(ИнформацияОбОшибке(), ВыборкаДляОбработки.Основание);
			Продолжить;
		КонецПопытки;
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = Не ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяРегистра);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
