#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если Не ДополнительныеСвойства.Свойство("ДляПроведения") Тогда
		Возврат;
	КонецЕсли;
	
	БлокироватьДляИзменения = Истина;
	
	// Текущее состояние набора помещается во временную таблицу,
	// чтобы при записи получить изменение нового набора относительно текущего.

	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Таблица.ЗаданиеНаПеревозку  КАК ЗаданиеНаПеревозку,
	|	Таблица.Техника             КАК Техника,
	|	ВЫБОР КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) ТОГДА
	|			-Таблица.Выгрузить
	|		ИНАЧЕ Таблица.Выгрузить
	|	КОНЕЦ                КАК ВыгрузитьПередЗаписью
	|
	|ПОМЕСТИТЬ ДвиженияпкТехникаКПеремещениюМеждуРегионамиПередЗаписью
	|ИЗ
	|	РегистрНакопления.пкТехникаКПеремещениюМеждуРегионами КАК Таблица
	|ГДЕ
	|	Таблица.Регистратор = &Регистратор
	|");
	
	Запрос.УстановитьПараметр("Регистратор",              Отбор.Регистратор.Значение);
	Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	Запрос.Выполнить();
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Если Не ДополнительныеСвойства.Свойство("ДляПроведения") Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	// Рассчитывается изменение нового набора относительно текущего с учетом накопленных изменений
	// и помещается во временную таблицу.
	Запрос = Новый Запрос;
	ОформлятьСначалаНакладные = Константы.ПорядокОформленияНакладныхРасходныхОрдеров.Получить() = Перечисления.ПорядокОформленияНакладныхРасходныхОрдеров.СначалаНакладные;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаИзменений.ЗаданиеНаПеревозку КАК ЗаданиеНаПеревозку,
	|	ТаблицаИзменений.Техника КАК Техника,
	|	СУММА(ТаблицаИзменений.ВыгрузитьИзменение) КАК ВыгрузитьИзменение
	|ПОМЕСТИТЬ ДвиженияпкТехникаКПеремещениюМеждуРегионамиИзменение
	|ИЗ
	|	(ВЫБРАТЬ
	|		Таблица.ЗаданиеНаПеревозку КАК ЗаданиеНаПеревозку,
	|		Таблица.Техника КАК Техника,
	|		Таблица.ВыгрузитьПередЗаписью КАК ВыгрузитьИзменение
	|	ИЗ
	|		ДвиженияпкТехникаКПеремещениюМеждуРегионамиПередЗаписью КАК Таблица
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Таблица.ЗаданиеНаПеревозку,
	|		Таблица.Техника,
	|		ВЫБОР
	|			КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -Таблица.Выгрузить
	|			ИНАЧЕ Таблица.Выгрузить
	|		КОНЕЦ
	|	ИЗ
	|		РегистрНакопления.пкТехникаКПеремещениюМеждуРегионами КАК Таблица
	|	ГДЕ
	|		Таблица.Регистратор = &Регистратор) КАК ТаблицаИзменений
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаИзменений.ЗаданиеНаПеревозку,
	|	ТаблицаИзменений.Техника
	|
	|ИМЕЮЩИЕ
	|	(СУММА(ТаблицаИзменений.ВыгрузитьИзменение) > 0)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ДвиженияпкТехникаКПеремещениюМеждуРегионамиПередЗаписью";
	
	ЗапросПакет = Запрос.ВыполнитьПакет();
	Выборка = ЗапросПакет[0].Выбрать();
	Выборка.Следующий();
	// Новые изменения были помещены во временную таблицу.
	// Добавляется информация о ее существовании и наличии в ней записей об изменении.
	СтруктураВременныеТаблицы.Вставить("ДвиженияпкТехникаКПеремещениюМеждуРегионамиИзменение", Выборка.Количество > 0);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
