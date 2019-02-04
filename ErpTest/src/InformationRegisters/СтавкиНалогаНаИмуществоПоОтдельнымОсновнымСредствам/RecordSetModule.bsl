#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

	Если Не ДополнительныеСвойства.Свойство("ДляПроведения") Тогда
		Возврат;
	КонецЕсли;

	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ТаблицаПередЗаписью.Период,
	|	ТаблицаПередЗаписью.Организация,
	|	ТаблицаПередЗаписью.ОсновноеСредство,
	|	ТаблицаПередЗаписью.НалоговыйОрган,
	|	ТаблицаПередЗаписью.ПорядокНалогообложения,
	|	ТаблицаПередЗаписью.НалоговаяСтавка,
	|	ТаблицаПередЗаписью.СниженнаяНалоговаяСтавка,
	|	ТаблицаПередЗаписью.ДоляСтоимостиЧислитель,
	|	ТаблицаПередЗаписью.ДоляСтоимостиЗнаменатель,
	|	ТаблицаПередЗаписью.НалоговаяБаза,
	|	ТаблицаПередЗаписью.КадастроваяСтоимость,
	|	ТаблицаПередЗаписью.НеоблагаемаяКадастроваяСтоимость,
	|	ТаблицаПередЗаписью.ДатаРегистрацииПраваСобственности,
	|	ТаблицаПередЗаписью.ДатаПрекращенияПраваСобственности,
	|	ТаблицаПередЗаписью.ИспользуетсяТолькоВДеятельностиОблагаемойЕНВД,
	|	ТаблицаПередЗаписью.ДвижимоеИмуществоПодлежащееНалогообложению,
	|	ТаблицаПередЗаписью.КодВидаИмущества,
	|	ТаблицаПередЗаписью.ДоляВПравеОбщейСобственностиЧислитель,
	|	ТаблицаПередЗаписью.ДоляВПравеОбщейСобственностиЗнаменатель,
	|	ТаблицаПередЗаписью.УсловныйНомер,
	|	ТаблицаПередЗаписью.КБК,
	|	ТаблицаПередЗаписью.ДоляПлощадиЧислитель,
	|	ТаблицаПередЗаписью.ДоляПлощадиЗнаменатель
	|ПОМЕСТИТЬ СтавкиНалогаНаИмуществоПоОтдельнымОсновнымСредствамПередЗаписью
	|ИЗ
	|	РегистрСведений.СтавкиНалогаНаИмуществоПоОтдельнымОсновнымСредствам КАК ТаблицаПередЗаписью
	|ГДЕ
	|	ТаблицаПередЗаписью.Регистратор = &Регистратор";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.Выполнить();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Или Не ДополнительныеСвойства.Свойство("ДляПроведения") Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Таблица.Период           КАК Период,
	|	Таблица.Организация      КАК Организация,
	|	Таблица.ОсновноеСредство КАК ОсновноеСредство,
	|	ИСТИНА                   КАК ОтражатьВРеглУчете,
	|	ЛОЖЬ                     КАК ОтражатьВУпрУчете,
	|	&Регистратор             КАК Документ
	|ПОМЕСТИТЬ СтавкиНалогаНаИмуществоПоОтдельнымОсновнымСредствамИзменение
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТаблицаПередЗаписью.Период            КАК Период,
	|		ТаблицаПередЗаписью.Организация       КАК Организация,
	|		ТаблицаПередЗаписью.ОсновноеСредство  КАК ОсновноеСредство
	|	ИЗ
	|		СтавкиНалогаНаИмуществоПоОтдельнымОсновнымСредствамПередЗаписью КАК ТаблицаПередЗаписью
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтавкиНалогаНаИмуществоПоОтдельнымОсновнымСредствам КАК ТаблицаПриЗаписи
	|			ПО ТаблицаПриЗаписи.Организация = ТаблицаПередЗаписью.Организация
	|				И ТаблицаПриЗаписи.ОсновноеСредство = ТаблицаПередЗаписью.ОсновноеСредство
	|				И ТаблицаПриЗаписи.Регистратор = &Регистратор
	|		ГДЕ
	|			(НАЧАЛОПЕРИОДА(ТаблицаПриЗаписи.Период, МЕСЯЦ) <> НАЧАЛОПЕРИОДА(ТаблицаПередЗаписью.Период, МЕСЯЦ)
	|				ИЛИ ТаблицаПриЗаписи.НалоговыйОрган <> ТаблицаПередЗаписью.НалоговыйОрган
	|				ИЛИ ТаблицаПриЗаписи.ПорядокНалогообложения <> ТаблицаПередЗаписью.ПорядокНалогообложения
	|				ИЛИ ТаблицаПриЗаписи.НалоговаяСтавка <> ТаблицаПередЗаписью.НалоговаяСтавка
	|				ИЛИ ТаблицаПриЗаписи.СниженнаяНалоговаяСтавка <> ТаблицаПередЗаписью.СниженнаяНалоговаяСтавка
	|				ИЛИ ТаблицаПриЗаписи.ДоляСтоимостиЧислитель <> ТаблицаПередЗаписью.ДоляСтоимостиЧислитель
	|				ИЛИ ТаблицаПриЗаписи.ДоляСтоимостиЗнаменатель <> ТаблицаПередЗаписью.ДоляСтоимостиЗнаменатель
	|				ИЛИ ТаблицаПриЗаписи.НалоговаяБаза <> ТаблицаПередЗаписью.НалоговаяБаза
	|				ИЛИ ТаблицаПриЗаписи.КадастроваяСтоимость <> ТаблицаПередЗаписью.КадастроваяСтоимость
	|				ИЛИ ТаблицаПриЗаписи.НеоблагаемаяКадастроваяСтоимость <> ТаблицаПередЗаписью.НеоблагаемаяКадастроваяСтоимость
	|				ИЛИ ТаблицаПриЗаписи.ДатаРегистрацииПраваСобственности <> ТаблицаПередЗаписью.ДатаРегистрацииПраваСобственности
	|				ИЛИ ТаблицаПриЗаписи.ДатаРегистрацииПраваСобственности <> ТаблицаПередЗаписью.ДатаРегистрацииПраваСобственности
	|				ИЛИ ТаблицаПриЗаписи.ДатаПрекращенияПраваСобственности <> ТаблицаПередЗаписью.ДатаПрекращенияПраваСобственности
	|				ИЛИ ТаблицаПриЗаписи.ИспользуетсяТолькоВДеятельностиОблагаемойЕНВД <> ТаблицаПередЗаписью.ИспользуетсяТолькоВДеятельностиОблагаемойЕНВД
	|				ИЛИ ТаблицаПриЗаписи.ДвижимоеИмуществоПодлежащееНалогообложению <> ТаблицаПередЗаписью.ДвижимоеИмуществоПодлежащееНалогообложению
	|				ИЛИ ТаблицаПриЗаписи.КодВидаИмущества <> ТаблицаПередЗаписью.КодВидаИмущества
	|				ИЛИ ТаблицаПриЗаписи.ДоляВПравеОбщейСобственностиЧислитель <> ТаблицаПередЗаписью.ДоляВПравеОбщейСобственностиЧислитель
	|				ИЛИ ТаблицаПриЗаписи.ДоляВПравеОбщейСобственностиЗнаменатель <> ТаблицаПередЗаписью.ДоляВПравеОбщейСобственностиЗнаменатель
	|				ИЛИ ТаблицаПриЗаписи.УсловныйНомер <> ТаблицаПередЗаписью.УсловныйНомер
	|				ИЛИ ТаблицаПриЗаписи.ДоляПлощадиЧислитель <> ТаблицаПередЗаписью.ДоляПлощадиЧислитель
	|				ИЛИ ТаблицаПриЗаписи.ДоляПлощадиЗнаменатель <> ТаблицаПередЗаписью.ДоляПлощадиЗнаменатель
	|				ИЛИ ТаблицаПриЗаписи.Организация ЕСТЬ NULL)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТаблицаПриЗаписи.Период,
	|		ТаблицаПриЗаписи.Организация,
	|		ТаблицаПриЗаписи.ОсновноеСредство
	|	ИЗ
	|		РегистрСведений.СтавкиНалогаНаИмуществоПоОтдельнымОсновнымСредствам КАК ТаблицаПриЗаписи
	|			ЛЕВОЕ СОЕДИНЕНИЕ СтавкиНалогаНаИмуществоПоОтдельнымОсновнымСредствамПередЗаписью КАК ТаблицаПередЗаписью
	|			ПО ТаблицаПриЗаписи.Организация = ТаблицаПередЗаписью.Организация
	|				И ТаблицаПриЗаписи.ОсновноеСредство = ТаблицаПередЗаписью.ОсновноеСредство
	|		ГДЕ
	|			(НАЧАЛОПЕРИОДА(ТаблицаПриЗаписи.Период, МЕСЯЦ) <> НАЧАЛОПЕРИОДА(ТаблицаПередЗаписью.Период, МЕСЯЦ)
	|				ИЛИ ТаблицаПриЗаписи.НалоговыйОрган <> ТаблицаПередЗаписью.НалоговыйОрган
	|				ИЛИ ТаблицаПриЗаписи.ПорядокНалогообложения <> ТаблицаПередЗаписью.ПорядокНалогообложения
	|				ИЛИ ТаблицаПриЗаписи.НалоговаяСтавка <> ТаблицаПередЗаписью.НалоговаяСтавка
	|				ИЛИ ТаблицаПриЗаписи.СниженнаяНалоговаяСтавка <> ТаблицаПередЗаписью.СниженнаяНалоговаяСтавка
	|				ИЛИ ТаблицаПриЗаписи.ДоляСтоимостиЧислитель <> ТаблицаПередЗаписью.ДоляСтоимостиЧислитель
	|				ИЛИ ТаблицаПриЗаписи.ДоляСтоимостиЗнаменатель <> ТаблицаПередЗаписью.ДоляСтоимостиЗнаменатель
	|				ИЛИ ТаблицаПриЗаписи.НалоговаяБаза <> ТаблицаПередЗаписью.НалоговаяБаза
	|				ИЛИ ТаблицаПриЗаписи.КадастроваяСтоимость <> ТаблицаПередЗаписью.КадастроваяСтоимость
	|				ИЛИ ТаблицаПриЗаписи.НеоблагаемаяКадастроваяСтоимость <> ТаблицаПередЗаписью.НеоблагаемаяКадастроваяСтоимость
	|				ИЛИ ТаблицаПриЗаписи.ДатаРегистрацииПраваСобственности <> ТаблицаПередЗаписью.ДатаРегистрацииПраваСобственности
	|				ИЛИ ТаблицаПриЗаписи.ДатаРегистрацииПраваСобственности <> ТаблицаПередЗаписью.ДатаРегистрацииПраваСобственности
	|				ИЛИ ТаблицаПриЗаписи.ДатаПрекращенияПраваСобственности <> ТаблицаПередЗаписью.ДатаПрекращенияПраваСобственности
	|				ИЛИ ТаблицаПриЗаписи.ИспользуетсяТолькоВДеятельностиОблагаемойЕНВД <> ТаблицаПередЗаписью.ИспользуетсяТолькоВДеятельностиОблагаемойЕНВД
	|				ИЛИ ТаблицаПриЗаписи.ДвижимоеИмуществоПодлежащееНалогообложению <> ТаблицаПередЗаписью.ДвижимоеИмуществоПодлежащееНалогообложению
	|				ИЛИ ТаблицаПриЗаписи.КодВидаИмущества <> ТаблицаПередЗаписью.КодВидаИмущества
	|				ИЛИ ТаблицаПриЗаписи.ДоляВПравеОбщейСобственностиЧислитель <> ТаблицаПередЗаписью.ДоляВПравеОбщейСобственностиЧислитель
	|				ИЛИ ТаблицаПриЗаписи.ДоляВПравеОбщейСобственностиЗнаменатель <> ТаблицаПередЗаписью.ДоляВПравеОбщейСобственностиЗнаменатель
	|				ИЛИ ТаблицаПриЗаписи.УсловныйНомер <> ТаблицаПередЗаписью.УсловныйНомер
	|				ИЛИ ТаблицаПриЗаписи.КБК <> ТаблицаПередЗаписью.КБК
	|				ИЛИ ТаблицаПриЗаписи.ДоляПлощадиЧислитель <> ТаблицаПередЗаписью.ДоляПлощадиЧислитель
	|				ИЛИ ТаблицаПриЗаписи.ДоляПлощадиЗнаменатель <> ТаблицаПередЗаписью.ДоляПлощадиЗнаменатель
	|				ИЛИ ТаблицаПередЗаписью.Организация ЕСТЬ NULL)
	|			И ТаблицаПриЗаписи.Регистратор = &Регистратор
	|
	|	) КАК Таблица
	|
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ СтавкиНалогаНаИмуществоПоОтдельнымОсновнымСредствамПередЗаписью";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Выборка = Запрос.ВыполнитьПакет()[0].Выбрать();
	Выборка.Следующий();
	
	СтруктураВременныеТаблицы.Вставить("СтавкиНалогаНаИмуществоПоОтдельнымОсновнымСредствамИзменение", Выборка.Количество > 0);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
