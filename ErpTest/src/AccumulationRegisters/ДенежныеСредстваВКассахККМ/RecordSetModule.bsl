#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если Не ДополнительныеСвойства.Свойство("ДляПроведения")
		Или ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	БлокироватьДляИзменения = Истина;
	ДополнительныеСвойства.ДляПроведения.Вставить("ВалютаУпр", Константы.ВалютаУправленческогоУчета.Получить());
	ДополнительныеСвойства.ДляПроведения.Вставить("ВалютаРегл", Константы.ВалютаРегламентированногоУчета.Получить());
	
	// Текущее состояние набора помещается во временную таблицу,
	// чтобы при записи получить изменение нового набора относительно текущего.
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Записи.Период                        КАК Период,
	|	Записи.Регистратор                   КАК Регистратор,
	|	Записи.Организация                   КАК Организация,
	|	Записи.КассаККМ                      КАК Касса,
	|
	|	Записи.Сумма                         КАК Сумма,
	|	Записи.СуммаУпр                      КАК СуммаУпр,
	|	Записи.СуммаРегл                     КАК СуммаРегл
	|
	|ПОМЕСТИТЬ ДенежныеСредстваВКассахККМПередЗаписью
	|ИЗ
	|	РегистрНакопления.ДенежныеСредстваВКассахККМ КАК Записи
	|ГДЕ
	|	Записи.Регистратор = &Регистратор
	|	И (ТипЗначения(Записи.Регистратор) = ТИП(Документ.РасчетКурсовыхРазниц)
	|		ИЛИ Записи.КассаККМ.ВалютаДенежныхСредств <> &ВалютаУпр
	|		ИЛИ Записи.КассаККМ.ВалютаДенежныхСредств <> &ВалютаРегл
	|	)
	|");
	
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.УстановитьПараметр("ВалютаУпр", ДополнительныеСвойства.ДляПроведения.ВалютаУпр);
	Запрос.УстановитьПараметр("ВалютаРегл", ДополнительныеСвойства.ДляПроведения.ВалютаРегл);
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	// Вместо ОбменДанными.Загрузка используется ДополнительныеСвойства.Свойство("ДляПроведения").
	// Данное свойство устанавливается в модуле ПроведениеСервер при интерактивном проведении документа.
	Если НЕ ДополнительныеСвойства.Свойство("ДляПроведения") ИЛИ ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// Рассчитывается изменение нового набора относительно текущего с учетом накопленных изменений
	// и помещается во временную таблицу.
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НАЧАЛОПЕРИОДА(Таблица.Период, МЕСЯЦ) КАК МЕСЯЦ,
	|	Таблица.Организация                  КАК Организация,
	|	&Операция                            КАК Операция,
	|	Таблица.Регистратор                  КАК Документ
	|ПОМЕСТИТЬ ДенежныеСредстваВКассахККМЗаданияКЗакрытиюМесяца
	|ИЗ
	|	(ВЫБРАТЬ
	|		Записи.Период                        КАК Период,
	|		Записи.Регистратор                   КАК Регистратор,
	|		Записи.Организация                   КАК Организация,
	|		Записи.Касса                         КАК Касса,
	|
	|		Записи.Сумма                         КАК Сумма,
	|		Записи.СуммаУпр                      КАК СуммаУпр,
	|		Записи.СуммаРегл                     КАК СуммаРегл
	|	ИЗ
	|		ДенежныеСредстваВКассахККМПередЗаписью КАК Записи
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ
	|		Записи.Период                         КАК Период,
	|		Записи.Регистратор                    КАК Регистратор,
	|		Записи.Организация                    КАК Организация,
	|		Записи.КассаККМ                       КАК Касса,
	|
	|		-Записи.Сумма                         КАК Сумма,
	|		-Записи.СуммаУпр                      КАК СуммаУпр,
	|		-Записи.СуммаРегл                     КАК СуммаРегл
	|	ИЗ
	|		РегистрНакопления.ДенежныеСредстваВКассахККМ КАК Записи
	|	ГДЕ
	|		Записи.Регистратор = &Регистратор
	|		И (ТипЗначения(Записи.Регистратор) = ТИП(Документ.РасчетКурсовыхРазниц)
	|			ИЛИ Записи.КассаККМ.ВалютаДенежныхСредств <> &ВалютаУпр
	|			ИЛИ Записи.КассаККМ.ВалютаДенежныхСредств <> &ВалютаРегл)
	|	) КАК Таблица
	|
	|СГРУППИРОВАТЬ ПО
	|	НАЧАЛОПЕРИОДА(Таблица.Период, МЕСЯЦ),
	|	Таблица.Период,
	|	Таблица.Регистратор,
	|	Таблица.Организация,
	|	Таблица.Касса
	|ИМЕЮЩИЕ
	|	СУММА(Таблица.Сумма) <> 0
	|	ИЛИ СУММА(Таблица.СуммаУпр) <> 0
	|	ИЛИ СУММА(Таблица.СуммаРегл) <> 0
	|");
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.УстановитьПараметр("Операция", Перечисления.ОперацииЗакрытияМесяца.ПереоценкаДенежныхСредствИФинансовыхИнструментов);
	Запрос.УстановитьПараметр("ВалютаУпр", ДополнительныеСвойства.ДляПроведения.ВалютаУпр);
	Запрос.УстановитьПараметр("ВалютаРегл", ДополнительныеСвойства.ДляПроведения.ВалютаРегл);
	
	Запрос.Выполнить();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли