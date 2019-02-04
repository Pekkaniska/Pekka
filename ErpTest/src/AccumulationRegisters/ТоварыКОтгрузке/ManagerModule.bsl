#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Вычисляет отгруженное количество, согласно данных регистра накопления "Товары к отгрузке".
//
// Параметры:
//  Отбор - ТаблицаЗначений - таблица товаров по которым необходимо получить отгруженное количество
//  Корректировка - ТаблицаЗначений	 - таблица товаров сторно
//  ТолькоОрдерныеСклады - Булево - указывает на расчет отгруженного количества только на ордерных складах.
//
// Возвращаемое значение:
//	ТаблицаЗначений - таблица отгруженных товаров.
//
Функция ТаблицаОформлено(Отбор, Корректировка, ТолькоОрдерныеСклады = Ложь) Экспорт

	МетаданныеРегистра = Метаданные.РегистрыНакопления.ТоварыКОтгрузке;
	ТаблицаОтбора = Новый ТаблицаЗначений;
	ТаблицаОтбора.Колонки.Добавить("Номенклатура",   Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ТаблицаОтбора.Колонки.Добавить("Характеристика", Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	ТаблицаОтбора.Колонки.Добавить("Склад",          Новый ОписаниеТипов("СправочникСсылка.Склады"));
	ТаблицаОтбора.Колонки.Добавить("Назначение",     Новый ОписаниеТипов("СправочникСсылка.Назначения"));
	ТаблицаОтбора.Колонки.Добавить("Серия",          Новый ОписаниеТипов("СправочникСсылка.СерииНоменклатуры"));
	ТаблицаОтбора.Колонки.Добавить("Ссылка",         МетаданныеРегистра.Измерения.ДокументОтгрузки.Тип);
	ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(Отбор, ТаблицаОтбора);

	Запрос = Новый Запрос();

	// Запрос оформленного количества по заказу.
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Таблица.Номенклатура   КАК Номенклатура,
		|	Таблица.Характеристика КАК Характеристика,
		|	Таблица.Назначение     КАК Назначение,
		|	Таблица.Серия          КАК Серия,
		|	Таблица.Склад          КАК Склад,
		|	Таблица.Ссылка         КАК ДокументОтгрузки
		|ПОМЕСТИТЬ ВТОтбор
		|ИЗ
		|	&Отбор КАК Таблица
		|;
		|
		|///////////////////////////////////////////
		|ВЫБРАТЬ
		|	Таблица.Номенклатура     КАК Номенклатура,
		|	Таблица.Характеристика   КАК Характеристика,
		|	Таблица.Назначение       КАК Назначение,
		|	Таблица.Серия            КАК Серия,
		|	Таблица.Склад            КАК Склад,
		|	Таблица.КОтгрузке        КАК Количество
		|ПОМЕСТИТЬ ВТКорректировка
		|ИЗ
		|	&Корректировка КАК Таблица
		|ГДЕ
		|	Таблица.КОтгрузке <> 0
		|;
		|
		|///////////////////////////////////////////
		|ВЫБРАТЬ
		|	Набор.Номенклатура      КАК Номенклатура,
		|	Набор.ТипНоменклатуры   КАК ТипНоменклатуры,
		|	Набор.Характеристика    КАК Характеристика,
		|	Набор.Назначение        КАК Назначение,
		|	Набор.Серия             КАК Серия,
		|	Набор.Склад             КАК Склад,
		|	СУММА(Набор.Количество) КАК Количество
		|ИЗ
		|(ВЫБРАТЬ
		|	Таблица.Номенклатура     КАК Номенклатура,
		|	Таблица.Номенклатура.ТипНоменклатуры КАК ТипНоменклатуры,
		|	Таблица.Характеристика   КАК Характеристика,
		|	Таблица.Назначение       КАК Назначение,
		|	Таблица.Серия            КАК Серия,
		|	Таблица.Склад            КАК Склад,
		|
		|	ВЫБОР КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) ТОГДА
		|				Таблица.КОтгрузке
		|				- Таблица.Собирается - Таблица.Собрано
		|			ИНАЧЕ
		|				Таблица.Собирается + Таблица.Собрано
		|		КОНЕЦ                КАК Количество
		|ИЗ
		|	РегистрНакопления.ТоварыКОтгрузке КАК Таблица
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВтОтбор КАК Фильтр
		|		ПО Таблица.Номенклатура   = Фильтр.Номенклатура
		|		 И Таблица.Характеристика = Фильтр.Характеристика
		|		 И Таблица.Склад          = Фильтр.Склад
		|		 И Таблица.Назначение     = Фильтр.Назначение
		|		 И Таблица.Серия          = Фильтр.Серия
		|		 И Таблица.ДокументОтгрузки = Фильтр.ДокументОтгрузки
		|		 И Таблица.ДокументОтгрузки <> Таблица.Регистратор
		|ГДЕ
		|	Таблица.Активность
		|	И (Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
		|			И Таблица.КОтгрузке <> 0
		|		ИЛИ Таблица.Собирается <> 0
		|		ИЛИ Таблица.Собрано <> 0)
		|	И &ВсеСклады
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Таблица.Номенклатура     КАК Номенклатура,
		|	ВЫРАЗИТЬ(Таблица.Номенклатура КАК Справочник.Номенклатура).ТипНоменклатуры КАК ТипНоменклатуры,
		|	Таблица.Характеристика   КАК Характеристика,
		|	Таблица.Назначение       КАК Назначение,
		|	Таблица.Серия            КАК Серия,
		|	Таблица.Склад            КАК Склад,
		|	-Таблица.Количество      КАК Количество
		|
		|ИЗ
		|	ВтКорректировка КАК Таблица
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВтОтбор КАК Фильтр
		|		ПО Таблица.Номенклатура   = Фильтр.Номенклатура
		|		 И Таблица.Характеристика = Фильтр.Характеристика
		|		 И Таблица.Склад          = Фильтр.Склад
		|		 И Таблица.Назначение     = Фильтр.Назначение
		|		 И Таблица.Серия          = Фильтр.Серия) КАК Набор
		|
		|СГРУППИРОВАТЬ ПО
		|	Набор.Номенклатура, Набор.ТипНоменклатуры, Набор.Характеристика, Набор.Назначение, Набор.Склад, Набор.Серия
		|ИМЕЮЩИЕ
		|	СУММА(Набор.Количество) > 0
		|";
	
	Если ТолькоОрдерныеСклады Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ВсеСклады",
			"Таблица.Склад.ИспользоватьОрдернуюСхемуПриОтгрузке
			|И Таблица.Склад.ДатаНачалаОрдернойСхемыПриОтгрузке <= &ТекущаяДата");
		Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДатаСеанса());
	Иначе
		Запрос.УстановитьПараметр("ВсеСклады", Истина);
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Корректировка", Корректировка);
	Запрос.УстановитьПараметр("Отбор",         ТаблицаОтбора);
	
	УстановитьПривилегированныйРежим(Истина);
	Таблица = Запрос.Выполнить().Выгрузить();
	УстановитьПривилегированныйРежим(Ложь);
	Таблица.Индексы.Добавить("Номенклатура, Характеристика, Склад, Назначение");
	
	Возврат Таблица;
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Склад)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Текст запроса получает таблицу отгруженных ордерами, но не оформленных накладными товаров
// Таблица дополняется движениями, сделанными накладной заданной в параметре Регистратор.
//
// Параметры:
//  ОтборПоИзмерениям	 - Структура - Ключ - имя измерения, Значение - имя параметра в запросе, например:
//  									Новый Структура("Номенклатура", "Товар") будет преобразовано в тексте запроса в:
//  									Номенклатура В(&Товар).
// 
// Возвращаемое значение:
//   - Строка
//
Функция ТекстЗапросаОсталосьОформить(ОтборПоИзмерениям = Неопределено) Экспорт
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	Таблица.ДокументОтгрузки  КАК Распоряжение,
	|	Таблица.Номенклатура      КАК Номенклатура,
	|	Таблица.Характеристика    КАК Характеристика,
	|	Таблица.Назначение        КАК Назначение,
	|	Таблица.Склад             КАК Склад,
	|	Таблица.Серия             КАК Серия,
	|	Таблица.КОтгрузкеРасход   КАК КОтгрузке,
	|	Таблица.КОформлениюРасход КАК КОформлению,
	|	Таблица.СобраноПриход     КАК Собрано,
	|	Таблица.СобираетсяПриход  КАК Собирается
	|ПОМЕСТИТЬ ВтДанныеРегистра
	|ИЗ
	|	РегистрНакопления.ТоварыКОтгрузке.Обороты(, , , ДокументОтгрузки В (&Распоряжения)
	|//&Отбор
	|	)КАК Таблица
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Набор.Распоряжение         КАК Распоряжение,
	|	Набор.Номенклатура         КАК Номенклатура,
	|	Набор.Характеристика       КАК Характеристика,
	|	Набор.Назначение           КАК Назначение,
	|	Набор.Склад                КАК Склад,
	|	Набор.Серия                КАК Серия,
	|	СУММА(Набор.Количество)    КАК Количество,
	|	МАКСИМУМ(Набор.Собирается) КАК Собирается
	|ИЗ
	|	(
	|	ВЫБРАТЬ
	|		Таблица.Распоряжение         КАК Распоряжение,
	|		Таблица.Номенклатура         КАК Номенклатура,
	|		Таблица.Характеристика       КАК Характеристика,
	|		Таблица.Назначение           КАК Назначение,
	|		Таблица.Склад                КАК Склад,
	|		Таблица.Серия                КАК Серия,
	|		Таблица.КОтгрузке 
	|			+ Таблица.Собрано        КАК Количество,
	|		Таблица.Собирается           КАК Собирается
	|	ИЗ
	|		ВтДанныеРегистра КАК Таблица
	|	ГДЕ
	|		Таблица.КОтгрузке 
	|			+ Таблица.Собрано > 0
	|		
	|	ОБЪЕДИНИТЬ ВСЕ
	|		
	|	ВЫБРАТЬ
	|		Таблица.Распоряжение         КАК Распоряжение,
	|		Таблица.Номенклатура         КАК Номенклатура,
	|		Таблица.Характеристика       КАК Характеристика,
	|		Таблица.Назначение           КАК Назначение,
	|		Таблица.Склад                КАК Склад,
	|		Таблица.Серия                КАК Серия,
	|		-Таблица.КОформлению         КАК Количество,
	|		Таблица.Собирается           КАК Собирается
	|	ИЗ
	|		ВтДанныеРегистра КАК Таблица
	|	ГДЕ
	|		Таблица.КОформлению > 0
	|		
	|	ОБЪЕДИНИТЬ ВСЕ
	|		
	|	ВЫБРАТЬ
	|		Таблица.ДокументОтгрузки     КАК Распоряжение,
	|		Таблица.Номенклатура         КАК Номенклатура,
	|		Таблица.Характеристика       КАК Характеристика,
	|		Таблица.Назначение           КАК Назначение,
	|		Таблица.Склад                КАК Склад,
	|		Таблица.Серия                КАК Серия,
	|		СУММА(Таблица.КОформлению)   КАК Количество,
	|		МАКСИМУМ(Таблица.Собирается) КАК Собирается
	|	ИЗ
	|		РегистрНакопления.ТоварыКОтгрузке КАК Таблица
	|	ГДЕ
	|		Таблица.Регистратор = &Регистратор
	|		И Таблица.ДокументОтгрузки В(&Распоряжения)
	|		И Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|		И Таблица.КОформлению > 0
	|		И Таблица.Активность
	|		//&Отбор
	|
	|	СГРУППИРОВАТЬ ПО
	|		Таблица.ДокументОтгрузки,
	|		Таблица.Номенклатура,
	|		Таблица.Характеристика,
	|		Таблица.Назначение,
	|		Таблица.Серия,
	|		Таблица.Склад
	|	) КАК Набор
	|
	|СГРУППИРОВАТЬ ПО
	|	Распоряжение,
	|	Номенклатура,
	|	Характеристика,
	|	Назначение,
	|	Склад,
	|	Серия";
	
	Если ЗначениеЗаполнено(ОтборПоИзмерениям) Тогда
		
		ТекстОтбора = "";
		
		Для Каждого КлючЗначение Из ОтборПоИзмерениям Цикл
			
			Ключ = КлючЗначение.Ключ;
//Рарус Владимир Подрезов 04.07.2017
			Если Ключ = "Характеристика_НеПроводитьПоБУ" Тогда
				Ключ = "Характеристика.пкНеПроводитьПоБУ";
			КонецЕсли;
//Рарус Владимир Подрезов Конец

			ТекстОтбора = 
				ТекстОтбора
				+ " И "
				+ Ключ
				+ " В(&"
				+ КлючЗначение.Значение
				+ ")";
			
		КонецЦикла;
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//&Отбор", ТекстОтбора);
		
	КонецЕсли;
	
	Возврат ТекстЗапроса;
	
КонецФункции

#Область ОбновлениеИнформационнойБазы

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ИмяРегистра = "ТоварыКОтгрузке";
	ПолноеИмяРегистра = "РегистрНакопления.ТоварыКОтгрузке";
	
	СписокДокументов = Новый Массив;
	СписокДокументов.Добавить("Документ.АктОРасхожденияхПослеПеремещения");
	
	Для каждого ПолноеИмяДокумента Из СписокДокументов Цикл
		ИмяДокумента = СтрРазделить(ПолноеИмяДокумента, ".")[1];
		ТекстЗапросаМеханизмаПроведения = Документы[ИмяДокумента].АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра);
		Регистраторы = ОбновлениеИнформационнойБазыУТ.РегистраторыДляПерепроведения(
			ТекстЗапросаМеханизмаПроведения, ПолноеИмяРегистра, ПолноеИмяДокумента);
		
		ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра);
	КонецЦикла;
	
	//++ НЕ УТ
	Запрос = Новый Запрос(
		"
		//++ НЕ УТКА
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Таблица.Ссылка КАК Этап,
		|	Таблица.Номенклатура КАК Номенклатура,
		|	Таблица.Склад КАК Склад
		|ПОМЕСТИТЬ ВТЭтапы
		|ИЗ
		|	Документ.ЭтапПроизводства2_2.ОбеспечениеМатериаламиИРаботами КАК Таблица
		|ГДЕ
		|	Таблица.СтатусУказанияСерий В (10, 14)
		|	И Таблица.СтатусУказанияСерийОтправитель = 0
		|	И Таблица.СтатусУказанияСерийПолучатель = 0
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Этап,
		|	Номенклатура,
		|	Склад
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		//-- НЕ УТКА
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Таблица.Ссылка КАК Ссылка
		|ПОМЕСТИТЬ ПроизводствоБезЗаказа
		|ИЗ
		|	Документ.ПроизводствоБезЗаказа.МатериалыИРаботы КАК Таблица
		|ГДЕ
		|	Таблица.Ссылка.Проведен
		|	И НЕ Таблица.Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		// Отражение документов пр-ва без заказа, для которых движения не сформированы
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ПроизводствоБезЗаказа.Ссылка КАК Регистратор
		|ИЗ
		|	ПроизводствоБезЗаказа КАК ПроизводствоБезЗаказа
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыКОтгрузке.Обороты(, , Регистратор, ) КАК ТоварыКОтгрузкеОбороты
		|		ПО ПроизводствоБезЗаказа.Ссылка = ТоварыКОтгрузкеОбороты.Регистратор
		|ГДЕ
		|	ТоварыКОтгрузкеОбороты.Регистратор ЕСТЬ NULL
		//++ НЕ УТКА
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ТоварыКОтгрузкеОбороты.Регистратор КАК Регистратор
		|ИЗ
		|	ВТЭтапы КАК ВТЭтапы
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыКОтгрузке.Обороты(, , Регистратор, ) КАК ТоварыКОтгрузкеОбороты
		|		ПО ВТЭтапы.Этап = ТоварыКОтгрузкеОбороты.Регистратор
		|			И ВТЭтапы.Номенклатура = ТоварыКОтгрузкеОбороты.Номенклатура
		|			И ВТЭтапы.Склад = ТоварыКОтгрузкеОбороты.Склад
		|ГДЕ
		|	ТоварыКОтгрузкеОбороты.Серия = ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
		//-- НЕ УТКА
		|");
	
	Регистраторы = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Регистратор");
	
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра);
	//-- НЕ УТ
	
	Возврат;
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ОбработкаЗавершена = Истина;
	
	Регистраторы = Новый Массив;
	Регистраторы.Добавить("Документ.АктОРасхожденияхПослеПеремещения");
	//++ НЕ УТ
	Регистраторы.Добавить("Документ.ПроизводствоБезЗаказа");
	//-- НЕ УТ
	//++ НЕ УТКА
	Регистраторы.Добавить("Документ.ЭтапПроизводства2_2");
	//-- НЕ УТКА
	
	ОбработкаЗавершена = ОбновлениеИнформационнойБазыУТ.ПерезаписатьДвиженияИзОчереди(
		Регистраторы, "РегистрНакопления.ТоварыКОтгрузке", Параметры.Очередь);
	
	Параметры.ОбработкаЗавершена = ОбработкаЗавершена;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
