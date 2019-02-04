#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Получает оформленное накладными по заказам количество.
//
// Параметры:
//  ТаблицаОтбора		 - ТаблицаЗначений - Таблица с полями "Ссылка" и "КодСтроки", строки должны быть уникальными.
//  ИсключитьЗаказ		 - Булево - Признак исключающий заказ из списка оформленных накладных.
//  ОтборПоИзмерениям	 - Структура - ключ структуры определяет имя измерения, по которому будет накладываться отбор,
//  									а значение структуры - искомое значение.
//
// Возвращаемое значение:
//  ТаблицаЗначений - Таблица с полями "Ссылка", "КодСтроки", "Количество". Для каждой пары Заказ-КодСтроки содержит
//                    оформленное накладными количество.
//
Функция ТаблицаОформлено(ТаблицаОтбора, ОтборПоИзмерениям = Неопределено, ИсключитьЗаказ = Ложь) Экспорт

	ТекстЗапроса =
		"ВЫБРАТЬ
		|	Таблица.Ссылка    КАК Ссылка,
		|	Таблица.КодСтроки КАК КодСтроки
		|ПОМЕСТИТЬ ВтОтбор
		|ИЗ
		|	&ТаблицаОтбора КАК Таблица
		|ГДЕ
		|	Таблица.КодСтроки > 0
		|;
		|
		|////////////////////////////////////////
		|ВЫБРАТЬ
		|	Отбор.КодСтроки КАК КодСтроки,
		|	Отбор.Ссылка    КАК Ссылка,
		|	МАКСИМУМ(РегистрЗаказы.Номенклатура)   КАК Номенклатура,
		|	МАКСИМУМ(РегистрЗаказы.Характеристика) КАК Характеристика,
		|	МАКСИМУМ(РегистрЗаказы.Получатель)     КАК Склад,
		|	МАКСИМУМ(РегистрЗаказы.Серия)          КАК Серия,
		|	СУММА(РегистрЗаказы.Количество)        КАК Количество
		|ИЗ
		|	ВтОтбор КАК Отбор
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.РаспоряженияНаПередачуИзПроизводства КАК РегистрЗаказы
		|		ПО РегистрЗаказы.Распоряжение = Отбор.Ссылка
		|		 И РегистрЗаказы.КодСтроки = Отбор.КодСтроки
		|		 И РегистрЗаказы.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
		|		 И РегистрЗаказы.Количество <> 0
		|		 И РегистрЗаказы.Активность
		|		 //&Отбор
		|СГРУППИРОВАТЬ ПО
		|	Отбор.Ссылка, Отбор.КодСтроки";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ТаблицаОтбора", ТаблицаОтбора);
	
	Отбор = Новый Массив;
	Если ИсключитьЗаказ Тогда
		Отбор.Добавить("РегистрЗаказы.Распоряжение <> РегистрЗаказы.Регистратор");
	КонецЕсли;
	Если ЗначениеЗаполнено(ОтборПоИзмерениям) Тогда
		Для Каждого КлючЗначение Из ОтборПоИзмерениям Цикл
			Запрос.УстановитьПараметр(КлючЗначение.Ключ, КлючЗначение.Значение);
			Отбор.Добавить("РегистрЗаказы." + КлючЗначение.Ключ + " В(&" + КлючЗначение.Ключ + ")");
		КонецЦикла;
	КонецЕсли;
	Если ЗначениеЗаполнено(Отбор) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "//&Отбор", "И " + СтрСоединить(Отбор, " И "));
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	Таблица = Запрос.Выполнить().Выгрузить();
	УстановитьПривилегированныйРежим(Ложь);
	Таблица.Индексы.Добавить("Ссылка, КодСтроки");
	
	Возврат Таблица;
	
КонецФункции

// Текст запроса получает остаток по ресурсам КОформлению и Заказано
// Остаток дополняется движениями, сделанными накладной заданной в параметре Регистратор.
//
// Параметры:
//  ИмяВременнойТаблицы	 - Строка - Поместить результат во временную таблицу с заданным именем. 
//  Измерения			 - Структура - Ключ - имя измерения, Значение - имя параметра в запросе, например:
//  									Новый Структура("Номенклатура", "Товар") будет преобразовано в тексте запроса в:
//  									Номенклатура В(&Товар)
//  Ресурсы				 - Строка - Условие для секции ИМЕЮЩИЕ по ресурсам.
//  								Например, строка вида "КОформлению <> 0" будет преобразована в тексте запроса в:
//  								СУММА(Набор.КОформлению) <> 0
// 
// Возвращаемое значение:
//  Строка - Текст запроса
//
Функция ТекстЗапросаОстатки(ИмяВременнойТаблицы = "", Измерения = Неопределено, Ресурсы = "") Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Набор.Распоряжение          КАК Распоряжение,
	|	Набор.Номенклатура          КАК Номенклатура,
	|	Набор.Характеристика        КАК Характеристика,
	|	Набор.КодСтроки             КАК КодСтроки,
	|	Набор.Назначение            КАК Назначение,
	|	Набор.НазначениеОтправителя КАК НазначениеОтправителя,
	|	Набор.Серия                 КАК Серия,
	|	Набор.Отправитель           КАК Отправитель,
	|	Набор.Получатель            КАК Получатель,
	|	СУММА(Набор.Количество)     КАК КОформлению,
	|	0                           КАК Заказано
	|//&ПОМЕСТИТЬ
	|ИЗ(
	|	ВЫБРАТЬ
	|		Таблица.Распоряжение          КАК Распоряжение,
	|		Таблица.Номенклатура          КАК Номенклатура,
	|		Таблица.Характеристика        КАК Характеристика,
	|		Таблица.КодСтроки             КАК КодСтроки,
	|		Таблица.Назначение            КАК Назначение,
	|		Таблица.НазначениеОтправителя КАК НазначениеОтправителя,
	|		Таблица.Серия                 КАК Серия,
	|		Таблица.Отправитель           КАК Отправитель,
	|		Таблица.Получатель            КАК Получатель,
	|		Таблица.КоличествоОстаток     КАК Количество
	|	ИЗ
	|		РегистрНакопления.РаспоряженияНаПередачуИзПроизводства.Остатки(, 
	|//&ОтборПоИзмерениямРегистр
	|			) КАК Таблица
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ
	|		Таблица.Распоряжение          КАК Распоряжение,
	|		Таблица.Номенклатура          КАК Номенклатура,
	|		Таблица.Характеристика        КАК Характеристика,
	|		Таблица.КодСтроки             КАК КодСтроки,
	|		Таблица.Назначение            КАК Назначение,
	|		Таблица.НазначениеОтправителя КАК НазначениеОтправителя,
	|		Таблица.Серия                 КАК Серия,
	|		Таблица.Получатель            КАК Получатель,
	|		Таблица.Отправитель           КАК Отправитель,
	|		Таблица.Количество            КАК Количество
	|	ИЗ
	|		РегистрНакопления.РаспоряженияНаПередачуИзПроизводства КАК Таблица
	|	ГДЕ
	|		Активность
	|		И Регистратор = &Регистратор
	|		И ВидДвижения = ЗНАЧЕНИЕ(ВидДВиженияНакопления.Расход)
	|//&ОтборПоИзмерениямСторно
	|	) КАК Набор
	|
	|СГРУППИРОВАТЬ ПО
	|	Распоряжение,
	|	Номенклатура,
	|	Характеристика,
	|	КодСтроки,
	|	Назначение,
	|	НазначениеОтправителя,
	|	Серия,
	|	Отправитель,
	|	Получатель
	|
	|//&ИМЕЮЩИЕ
	|";
	
	Если Не ПустаяСтрока(ИмяВременнойТаблицы) Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//&ПОМЕСТИТЬ", "ПОМЕСТИТЬ " + ИмяВременнойТаблицы);
		ТекстЗапроса = ТекстЗапроса + 
		"
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Распоряжение,
		|	КодСтроки,
		|	Номенклатура,
		|	Характеристика,
		|	Серия";
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Измерения) Тогда
		
		ТекстОтбораПоИзмерениям = "";
		
		Для Каждого КлючЗначение Из Измерения Цикл
			
			ТекстОтбораПоИзмерениям = 
				ТекстОтбораПоИзмерениям
				+ ?(ПустаяСтрока(ТекстОтбораПоИзмерениям), "", " И ")
				+ КлючЗначение.Ключ
				+ " В(&"
				+ КлючЗначение.Значение
				+ ")";
			
		КонецЦикла;
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//&ОтборПоИзмерениямРегистр", ТекстОтбораПоИзмерениям);
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//&ОтборПоИзмерениямСторно", Символы.ПС + "И " + ТекстОтбораПоИзмерениям);
		
	КонецЕсли;
	
	Если Не ПустаяСтрока(Ресурсы) Тогда
		
		Если СтрНайти(Ресурсы, "Количество") <> 0 Тогда
			Ресурсы = СтрЗаменить(Ресурсы, "Количество", "СУММА(Набор.Количество)");
		КонецЕсли;
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//&ИМЕЮЩИЕ", "ИМЕЮЩИЕ " + Ресурсы);
		
	КонецЕсли;
	
	Возврат ТекстЗапроса;
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Отправитель)
	|	ИЛИ ЗначениеРазрешено(Получатель)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#КонецЕсли