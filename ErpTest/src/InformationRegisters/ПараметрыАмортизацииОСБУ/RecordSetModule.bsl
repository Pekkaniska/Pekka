#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

	ПодготовитьДанныеДляФормированияЗаданийПередЗаписью();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПодготовитьДанныеДляФормированияЗаданийПриЗаписи();
	
	ЗаписатьИзмененияВРегистры2_2();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПодготовитьДанныеДляФормированияЗаданийПередЗаписью()

	Если НЕ ДополнительныеСвойства.Свойство("ДляПроведения") Тогда
		Возврат;
	КонецЕсли; 
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ТаблицаПередЗаписью.Период КАК Период,
	|	ТаблицаПередЗаписью.Организация КАК Организация,
	|	ТаблицаПередЗаписью.ОсновноеСредство КАК ОсновноеСредство,
	|	ТаблицаПередЗаписью.КоэффициентАмортизацииБУ КАК КоэффициентАмортизацииБУ,
	|	ТаблицаПередЗаписью.КоэффициентУскорения КАК КоэффициентУскорения,
	|	ТаблицаПередЗаписью.ОбъемПродукцииРаботДляВычисленияАмортизации КАК ОбъемПродукцииРаботДляВычисленияАмортизации,
	|	ТаблицаПередЗаписью.ПРДляВычисленияАмортизации КАК ПРДляВычисленияАмортизации,
	|	ТаблицаПередЗаписью.СрокИспользованияДляВычисленияАмортизации КАК СрокИспользованияДляВычисленияАмортизации,
	|	ТаблицаПередЗаписью.СтоимостьДляВычисленияАмортизации КАК СтоимостьДляВычисленияАмортизации,
	|	ТаблицаПередЗаписью.ДатаПоследнегоИзменения КАК ДатаПоследнегоИзменения
	|ПОМЕСТИТЬ ПараметрыАмортизацииОСБУПередЗаписью
	|ИЗ
	|	РегистрСведений.ПараметрыАмортизацииОСБУ КАК ТаблицаПередЗаписью
	|ГДЕ
	|	ТаблицаПередЗаписью.Регистратор = &Регистратор";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	
	Запрос.Выполнить();
	
КонецПроцедуры

Процедура ПодготовитьДанныеДляФормированияЗаданийПриЗаписи()

	Если Не ДополнительныеСвойства.Свойство("ДляПроведения") Тогда
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
	|ПОМЕСТИТЬ ПараметрыАмортизацииОСБУИзменение
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТаблицаПередЗаписью.Период            КАК Период,
	|		ТаблицаПередЗаписью.Организация       КАК Организация,
	|		ТаблицаПередЗаписью.ОсновноеСредство  КАК ОсновноеСредство
	|	ИЗ
	|		ПараметрыАмортизацииОСБУПередЗаписью КАК ТаблицаПередЗаписью
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыАмортизацииОСБУ КАК ТаблицаПриЗаписи
	|			ПО ТаблицаПриЗаписи.ОсновноеСредство = ТаблицаПередЗаписью.ОсновноеСредство
	|				И ТаблицаПриЗаписи.Организация = ТаблицаПередЗаписью.Организация
	|				И ТаблицаПриЗаписи.Регистратор = &Регистратор
	|		ГДЕ
	|			(ТаблицаПриЗаписи.Период ЕСТЬ NULL
	|				ИЛИ ТаблицаПриЗаписи.КоэффициентАмортизацииБУ <> ТаблицаПередЗаписью.КоэффициентАмортизацииБУ
	|				ИЛИ ТаблицаПриЗаписи.КоэффициентУскорения <> ТаблицаПередЗаписью.КоэффициентУскорения
	|				ИЛИ ТаблицаПриЗаписи.ОбъемПродукцииРаботДляВычисленияАмортизации <> ТаблицаПередЗаписью.ОбъемПродукцииРаботДляВычисленияАмортизации
	|				ИЛИ ТаблицаПриЗаписи.ПРДляВычисленияАмортизации <> ТаблицаПередЗаписью.ПРДляВычисленияАмортизации
	|				ИЛИ ТаблицаПриЗаписи.СрокИспользованияДляВычисленияАмортизации <> ТаблицаПередЗаписью.СрокИспользованияДляВычисленияАмортизации
	|				ИЛИ ТаблицаПриЗаписи.СтоимостьДляВычисленияАмортизации <> ТаблицаПередЗаписью.СтоимостьДляВычисленияАмортизации
	|				ИЛИ ТаблицаПриЗаписи.ДатаПоследнегоИзменения <> ТаблицаПередЗаписью.ДатаПоследнегоИзменения
	|				ИЛИ НАЧАЛОПЕРИОДА(ТаблицаПриЗаписи.Период, МЕСЯЦ) <> НАЧАЛОПЕРИОДА(ТаблицаПередЗаписью.Период, МЕСЯЦ))
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТаблицаПриЗаписи.Период,
	|		ТаблицаПриЗаписи.Организация,
	|		ТаблицаПриЗаписи.ОсновноеСредство
	|	ИЗ
	|		РегистрСведений.ПараметрыАмортизацииОСБУ КАК ТаблицаПриЗаписи
	|			ЛЕВОЕ СОЕДИНЕНИЕ ПараметрыАмортизацииОСБУПередЗаписью КАК ТаблицаПередЗаписью
	|			ПО ТаблицаПриЗаписи.ОсновноеСредство = ТаблицаПередЗаписью.ОсновноеСредство
	|				И ТаблицаПриЗаписи.Организация = ТаблицаПередЗаписью.Организация
	|		ГДЕ
	|			(ТаблицаПередЗаписью.Период ЕСТЬ NULL
	|				ИЛИ ТаблицаПриЗаписи.КоэффициентАмортизацииБУ <> ТаблицаПередЗаписью.КоэффициентАмортизацииБУ
	|				ИЛИ ТаблицаПриЗаписи.КоэффициентУскорения <> ТаблицаПередЗаписью.КоэффициентУскорения
	|				ИЛИ ТаблицаПриЗаписи.ОбъемПродукцииРаботДляВычисленияАмортизации <> ТаблицаПередЗаписью.ОбъемПродукцииРаботДляВычисленияАмортизации
	|				ИЛИ ТаблицаПриЗаписи.ПРДляВычисленияАмортизации <> ТаблицаПередЗаписью.ПРДляВычисленияАмортизации
	|				ИЛИ ТаблицаПриЗаписи.СрокИспользованияДляВычисленияАмортизации <> ТаблицаПередЗаписью.СрокИспользованияДляВычисленияАмортизации
	|				ИЛИ ТаблицаПриЗаписи.СтоимостьДляВычисленияАмортизации <> ТаблицаПередЗаписью.СтоимостьДляВычисленияАмортизации
	|				ИЛИ ТаблицаПриЗаписи.ДатаПоследнегоИзменения <> ТаблицаПередЗаписью.ДатаПоследнегоИзменения
	|				ИЛИ НАЧАЛОПЕРИОДА(ТаблицаПриЗаписи.Период, МЕСЯЦ) <> НАЧАЛОПЕРИОДА(ТаблицаПередЗаписью.Период, МЕСЯЦ))
	|			И ТаблицаПриЗаписи.Регистратор = &Регистратор
	|
	|	) КАК Таблица
	|
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ПараметрыАмортизацииОСБУПередЗаписью";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Выборка = Запрос.ВыполнитьПакет()[0].Выбрать();
	Выборка.Следующий();
	
	СтруктураВременныеТаблицы.Вставить("ПараметрыАмортизацииОСБУИзменение", Выборка.Количество > 0);
	
	
КонецПроцедуры

Процедура ЗаписатьИзмененияВРегистры2_2()

	Если НЕ ЗначениеЗаполнено(Отбор.Регистратор.Значение)
		ИЛИ ТипЗнч(Отбор.Регистратор.Значение) = Тип("ДокументСсылка.ВводОстатковВнеоборотныхАктивов2_4")
		ИЛИ ТипЗнч(Отбор.Регистратор.Значение) = Тип("ДокументСсылка.КорректировкаРегистров") Тогда
		Возврат;
	КонецЕсли;
	
	НаборЗаписейНУ = Неопределено;
	
	НаборЗаписейБУ = РегистрыСведений.ПараметрыАмортизацииОСБухгалтерскийУчет.СоздатьНаборЗаписей();
	НаборЗаписейБУ.Отбор.Регистратор.Установить(Отбор.Регистратор.Значение);
	
	Если ТипЗнч(Отбор.Регистратор.Значение) <> Тип("ДокументСсылка.СписаниеОС2_4") Тогда
		НаборЗаписейНУ = РегистрыСведений.ПараметрыАмортизацииОСНалоговыйУчет.СоздатьНаборЗаписей();
		НаборЗаписейНУ.Отбор.Регистратор.Установить(Отбор.Регистратор.Значение);
	КонецЕсли; 
	
	Для каждого ДанныеСтроки Из ЭтотОбъект Цикл
		
		НоваяЗапись = НаборЗаписейБУ.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяЗапись, ДанныеСтроки);
		НоваяЗапись.СрокПолезногоИспользования = ДанныеСтроки.СрокПолезногоИспользованияБУ;
		НоваяЗапись.КоэффициентАмортизации = ДанныеСтроки.КоэффициентАмортизацииБУ;
		
		Если НаборЗаписейНУ <> Неопределено Тогда
			НоваяЗапись = НаборЗаписейНУ.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяЗапись, ДанныеСтроки);
			НоваяЗапись.СрокПолезногоИспользования = ДанныеСтроки.СрокПолезногоИспользованияНУ;
			НоваяЗапись.КоэффициентАмортизации = ДанныеСтроки.КоэффициентАмортизацииБУ;
		КонецЕсли; 
		
	КонецЦикла; 
	
	НаборЗаписейБУ.Записать();
	
	Если НаборЗаписейНУ <> Неопределено Тогда
		НаборЗаписейНУ.Записать();
	КонецЕсли; 
	
КонецПроцедуры
 
#КонецОбласти

#КонецЕсли

