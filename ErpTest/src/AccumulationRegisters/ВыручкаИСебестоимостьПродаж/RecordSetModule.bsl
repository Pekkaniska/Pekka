#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка
	 ИЛИ УниверсальныеМеханизмыПартийИСебестоимости.ДвиженияЗаписываютсяРасчетомПартийИСебестоимости(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	// Сохраним неизмененные первичные движения.
	СохранитьНеИзмененныеПервичныеДвижения();
	
	// Сохраним расчетные движения за периоды, в которых есть первичные движения.
	УниверсальныеМеханизмыПартийИСебестоимости.СохранитьДвиженияСформированныеРасчетомПартийИСебестоимости(ЭтотОбъект, Замещение);
	
	Если ПланыОбмена.ГлавныйУзел() <> Неопределено
	 ИЛИ НЕ ДополнительныеСвойства.Свойство("ДляПроведения") Тогда
		Возврат;
	КонецЕсли;
	
	// Текущее состояние набора помещается во временную таблицу,
	// чтобы при записи получить изменение нового набора относительно текущего.
	
	ТекстыЗапросовДляПолученияТаблицыИзменений = 
		ЗакрытиеМесяцаСервер.ТекстыЗапросовДляПолученияТаблицыИзмененийРегистра(ЭтотОбъект.Метаданные(), ЭтотОбъект.Отбор);
	
	Запрос = Новый Запрос;
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст = ТекстыЗапросовДляПолученияТаблицыИзменений.ТекстВыборкиНачальныхДанных;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	
	Запрос.Выполнить();
	
	ДополнительныеСвойства.Вставить("МенеджерВременныхТаблиц", Запрос.МенеджерВременныхТаблиц);
	ДополнительныеСвойства.Вставить("ТекстВыборкиТаблицыИзменений", ТекстыЗапросовДляПолученияТаблицыИзменений.ТекстВыборкиТаблицыИзменений);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
		
	Если ОбменДанными.Загрузка
	 ИЛИ НЕ ДополнительныеСвойства.Свойство("ДляПроведения")
	 ИЛИ ПланыОбмена.ГлавныйУзел() <> Неопределено
	 ИЛИ УниверсальныеМеханизмыПартийИСебестоимости.ДвиженияЗаписываютсяРасчетомПартийИСебестоимости(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	// Рассчитывается изменение нового набора относительно текущего с учетом накопленных изменений
	// и помещается во временную таблицу для последующей записи в регистрах заданий.
	Запрос = Новый Запрос;
	МассивТекстовЗапроса = Новый Массив;
	Запрос.Текст = ДополнительныеСвойства.ТекстВыборкиТаблицыИзменений;
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	
	МассивТекстовЗапроса.Добавить(ДополнительныеСвойства.ТекстВыборкиТаблицыИзменений);

	ТекстАктуализацииЗаданийКРасчетуСебестоимости =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НАЧАЛОПЕРИОДА(ТаблицаИзменений.Период, МЕСЯЦ) КАК Месяц,
	|	ТаблицаИзменений.Регистратор КАК Документ,
	|	КлючиАналитикаУчетаПоПартнерам.Организация,
	|	ЛОЖЬ КАК ИзмененыДанныеДляПартионногоУчетаВерсии21
	|ПОМЕСТИТЬ ВыручкаИСебестоимостьПродажЗаданияКРасчетуСебестоимости
	|ИЗ
	|	ТаблицаИзмененийВыручкаИСебестоимостьПродаж КАК ТаблицаИзменений
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		РегистрСведений.АналитикаУчетаПоПартнерам КАК КлючиАналитикаУчетаПоПартнерам
	|	ПО
	|		ТаблицаИзменений.АналитикаУчетаПоПартнерам = КлючиАналитикаУчетаПоПартнерам.КлючАналитики";
	МассивТекстовЗапроса.Добавить(ТекстАктуализацииЗаданийКРасчетуСебестоимости);
	
	ТекстИзмененийСуммыВыручкиРегл =
	"ВЫБРАТЬ
	|	ТаблицаИзменений.Период КАК Период,
	|	КлючиАналитикаУчетаПоПартнерам.Организация КАК Организация,
	|	ТаблицаИзменений.Регистратор КАК Регистратор,
	|	ТаблицаИзменений.СуммаВыручкиРегл
	|ПОМЕСТИТЬ втИзменениеСуммыВыручкиРегл
	|ИЗ
	|	ТаблицаИзмененийВыручкаИСебестоимостьПродаж КАК ТаблицаИзменений
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		РегистрСведений.АналитикаУчетаПоПартнерам КАК КлючиАналитикаУчетаПоПартнерам
	|	ПО
	|		ТаблицаИзменений.АналитикаУчетаПоПартнерам = КлючиАналитикаУчетаПоПартнерам.КлючАналитики
	|";
	МассивТекстовЗапроса.Добавить(ТекстИзмененийСуммыВыручкиРегл);
	
	//++ НЕ УТ
	ТекстОрганизацийНаУСН =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ОрганизацииНаУСН.Организация КАК Организация,
	|	ОрганизацииНаУСН.Период КАК НачалоПериода,
	|	ОрганизацииНаУСН.ПлательщикЕНВД КАК ПлательщикЕНВД,
	|	МИНИМУМ(ЕСТЬNULL(ОстальныеОрганизации.Период, ДАТАВРЕМЯ(2120,1,1))) КАК КонецПериода
	|ПОМЕСТИТЬ ДанныеПоОрганизациямНаУСН
	|ИЗ
	|	РегистрСведений.УчетнаяПолитикаОрганизаций КАК ОрганизацииНаУСН
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.УчетнаяПолитикаОрганизаций КАК ОстальныеОрганизации
	|		ПО (ОрганизацииНаУСН.Организация = ОстальныеОрганизации.Организация)
	|			И (ОрганизацииНаУСН.Период < ОстальныеОрганизации.Период)
	|			И (ОстальныеОрганизации.УчетнаяПолитика <> ОрганизацииНаУСН.УчетнаяПолитика)
	|ГДЕ
	|	ОрганизацииНаУСН.ПрименяетсяУСН
	|
	|СГРУППИРОВАТЬ ПО
	|	ОрганизацииНаУСН.Организация,
	|	ОрганизацииНаУСН.Период,
	|	ОрганизацииНаУСН.ПлательщикЕНВД";
	МассивТекстовЗапроса.Добавить(ТекстОрганизацийНаУСН);
	//-- НЕ УТ
	
	МассивЗапросовЗаданийПоОперациям = Новый Массив;
	МассивЗапросовЗаданийПоОперациям.Добавить(
		УчетНДСУП.ТекстЗапросаФормированияЗаданийПриИзмененииВыручки("втИзменениеСуммыВыручкиРегл"));

	//++ НЕ УТ
	ТекстАктуализацииКУДиР = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НАЧАЛОПЕРИОДА(ТаблицаИзменений.Период, МЕСЯЦ)                    КАК Месяц,
	|	ЗНАЧЕНИЕ(Перечисление.ОперацииЗакрытияМесяца.СторноДоходовКУДиР) КАК Операция,
	|	КлючиАналитикаУчетаПоПартнерам.Организация                       КАК Организация,
	|	ТаблицаИзменений.Регистратор                                     КАК Документ
	|ИЗ
	|	ТаблицаИзмененийВыручкаИСебестоимостьПродаж КАК ТаблицаИзменений
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК КлючиАналитикаУчетаПоПартнерам
	|		ПО  ТаблицаИзменений.АналитикаУчетаПоПартнерам = КлючиАналитикаУчетаПоПартнерам.КлючАналитики
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Константы КАК Константы
	|		ПО Константы.ИспользоватьРеглУчет
	|			И НАЧАЛОПЕРИОДА(ТаблицаИзменений.Период, МЕСЯЦ) >= Константы.ДатаНачалаВеденияРеглУчета
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ДанныеПоОрганизациямНаУСН КАК ОрганизацииНаУСН
	|		ПО (ОрганизацииНаУСН.Организация = КлючиАналитикаУчетаПоПартнерам.Организация)
	|			И (ТаблицаИзменений.Период >= ОрганизацииНаУСН.НачалоПериода)
	|			И (ТаблицаИзменений.Период < ОрганизацииНаУСН.КонецПериода)
	|ГДЕ
	|	(ТаблицаИзменений.РазделУчета = ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыПринятыеНаКомиссию)
	|	ИЛИ ТаблицаИзменений.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.АгентскаяУслуга))
	|	И ТаблицаИзменений.СуммаВыручкиСНДСРегл + ТаблицаИзменений.СуммаВыручкиРегл <> 0
	|
	|ОБЪЕДИНИТЬ 
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НАЧАЛОПЕРИОДА(ТаблицаИзменений.Период, МЕСЯЦ)                    КАК Месяц,
	|	ЗНАЧЕНИЕ(Перечисление.ОперацииЗакрытияМесяца.СторноДоходовКУДиР) КАК Операция,
	|	КлючиАналитикаУчетаПоПартнерам.Организация                       КАК Организация,
	|	ТаблицаИзменений.Регистратор                                     КАК Документ
	|ИЗ
	|	ТаблицаИзмененийВыручкаИСебестоимостьПродаж КАК ТаблицаИзменений
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК КлючиАналитикаУчетаПоПартнерам
	|		ПО ТаблицаИзменений.АналитикаУчетаПоПартнерам = КлючиАналитикаУчетаПоПартнерам.КлючАналитики
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Константы КАК Константы
	|		ПО Константы.ИспользоватьРеглУчет
	|			И НАЧАЛОПЕРИОДА(ТаблицаИзменений.Период, МЕСЯЦ) >= Константы.ДатаНачалаВеденияРеглУчета
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ДанныеПоОрганизациямНаУСН КАК ОрганизацииНаУСН
	|		ПО (ОрганизацииНаУСН.Организация = КлючиАналитикаУчетаПоПартнерам.Организация)
	|			И (ТаблицаИзменений.Период >= ОрганизацииНаУСН.НачалоПериода)
	|			И (ТаблицаИзменений.Период < ОрганизацииНаУСН.КонецПериода)
	|			И (ОрганизацииНаУСН.ПлательщикЕНВД)
	|ГДЕ
	|	ТаблицаИзменений.НалогообложениеНДС = ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаОблагаетсяЕНВД)
	|	И ТаблицаИзменений.СуммаВыручкиСНДСРегл + ТаблицаИзменений.СуммаВыручкиРегл <> 0";
	МассивЗапросовЗаданийПоОперациям.Добавить(ТекстАктуализацииКУДиР);
	//-- НЕ УТ
	ТекстЗапросаЗаданийКЗакрытиюМесяца = ЗакрытиеМесяцаСервер.ТекстЗапросЗаданийКЗакрытиюМесяца(
	                                         "ВыручкаИСебестоимостьПродаж", МассивЗапросовЗаданийПоОперациям);
	МассивТекстовЗапроса.Добавить(ТекстЗапросаЗаданийКЗакрытиюМесяца);
	
	// Уничтожаем таблицу изменений регистра:
	МассивТекстовЗапроса.Добавить("УНИЧТОЖИТЬ ТаблицаИзмененийВыручкаИСебестоимостьПродаж");
	МассивТекстовЗапроса.Добавить("УНИЧТОЖИТЬ втИзменениеСуммыВыручкиРегл");
	//++ НЕ УТ
	МассивТекстовЗапроса.Добавить("УНИЧТОЖИТЬ ДанныеПоОрганизациямНаУСН");
	//-- НЕ УТ
	
	Запрос.Текст = СтрСоединить(МассивТекстовЗапроса, ОбщегоНазначенияУТ.РазделительЗапросовВПакете());
	
	Запрос.Выполнить();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СохранитьНеИзмененныеПервичныеДвижения()
	
	Если УниверсальныеМеханизмыПартийИСебестоимостиПовтИсп.ЗначенияТехнологическихПараметров().НеСохранятьРасчетныеДвижения
	 ИЛИ ДополнительныеСвойства.Свойство("НеСохранятьРасчетныеДвижения") Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Отбор.Регистратор.Значение) = Тип("ДокументСсылка.ВводОстатков") Тогда
		Возврат; // его движения не корректируются партионным учетом
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ДатаРегистратора") Тогда
		ДатаРегистратора = ДополнительныеСвойства.ДатаРегистратора;
	Иначе
		ДатаРегистратора = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Отбор.Регистратор.Значение, "Дата");
	КонецЕсли;
	
	Если НЕ УниверсальныеМеханизмыПартийИСебестоимостиПовтИсп.ПартионныйУчетВерсии22(НачалоМесяца(ДатаРегистратора)) Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаЗаписей = ЭтотОбъект.Выгрузить();
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Регистратор", 				Отбор.Регистратор.Значение);
	Запрос.УстановитьПараметр("НаборЗаписей", 				ТаблицаЗаписей);
	
	#Область ШаблоныТекстаЗапроса
	
	// Подготовим шаблоны для формирования текстов запросов.
	ПоляИсключения = Новый Структура("НомерСтроки, Активность, Регистратор, МоментВремени");
	ПоляПартий     = Новый Структура("Партия, АналитикаУчетаПартий, АналитикаФинансовогоУчета, ВидДеятельностиНДС, РасчетНеЗавершен");
	
	ТекстПоляРегистра = "";
	ТекстПоляРегистраСМинусом = "";
	ТекстПоляРегистраБезПартий = "";
	ТекстПоляГруппировкиБезПартий = "";
	ТекстПоляСуммирования = "";
	ТекстПоляУсловия = "";
	
	Для Каждого ТекущаяКолонка Из ТаблицаЗаписей.Колонки Цикл
		
		Если ПоляИсключения.Свойство(ТекущаяКолонка.Имя) Тогда
			Продолжить;
		КонецЕсли;
		
		ЭтоСуммируемоеПоле = Метаданные().Ресурсы.Найти(ТекущаяКолонка.Имя) <> Неопределено
			ИЛИ (Метаданные().Реквизиты.Найти(ТекущаяКолонка.Имя) <> Неопределено
				И ТекущаяКолонка.ТипЗначения.СодержитТип(Тип("Число")));
		 
		ТекстПоляРегистра = ТекстПоляРегистра + ?(ТекстПоляРегистра = "", "", ",
			|	") + "Т." + ТекущаяКолонка.Имя;
		ТекстПоляРегистраСМинусом = ТекстПоляРегистраСМинусом + ?(ТекстПоляРегистраСМинусом = "", "", ",
			|	") + ?(ЭтоСуммируемоеПоле, "-", "") + "Т." + ТекущаяКолонка.Имя;
			
		Если ЭтоСуммируемоеПоле Тогда
			
			ТекстПоляСуммирования = ТекстПоляСуммирования + ?(ТекстПоляСуммирования = "", "", ",
				|	") + "СУММА(Т." + ТекущаяКолонка.Имя + ") КАК " + ТекущаяКолонка.Имя;
			ТекстПоляУсловия = ТекстПоляУсловия + ?(ТекстПоляУсловия = "", "", "
				|	ИЛИ ") + "СУММА(Т." + ТекущаяКолонка.Имя + ") <> 0";
			
		Иначе
			
			Если НЕ ПоляПартий.Свойство(ТекущаяКолонка.Имя) Тогда
				
				ТекстПоляРегистраБезПартий = ТекстПоляРегистраБезПартий + ?(ТекстПоляРегистраБезПартий = "", "", ",
					|	") + "Т." + ТекущаяКолонка.Имя;
				ТекстПоляГруппировкиБезПартий = ТекстПоляГруппировкиБезПартий + ?(ТекстПоляГруппировкиБезПартий = "", "", ",
					|	") + "Т." + ТекущаяКолонка.Имя;
					
			Иначе
				
				ТекстПоляРегистраБезПартий = ТекстПоляРегистраБезПартий + ?(ТекстПоляРегистраБезПартий = "", "", ",
					|	") + "ВЫБОР КОГДА Т.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Услуга)
					|		ТОГДА Т." + ТекущаяКолонка.Имя
					+ " ИНАЧЕ НЕОПРЕДЕЛЕНО КОНЕЦ КАК " + ТекущаяКолонка.Имя;
				ТекстПоляГруппировкиБезПартий = ТекстПоляГруппировкиБезПартий + ?(ТекстПоляГруппировкиБезПартий = "", "", ",
					|	") + "ВЫБОР КОГДА Т.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Услуга)
					|		ТОГДА Т." + ТекущаяКолонка.Имя
					+ " ИНАЧЕ НЕОПРЕДЕЛЕНО КОНЕЦ";
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	#КонецОбласти
	
	#Область СозданиеВременныхТаблиц
	
	// Проанализируем наличие измененных первичных движений в разрезе периодов (месяцев).
	ШаблонТекстаЗапроса =
	"ВЫБРАТЬ
	|	%1
	|ПОМЕСТИТЬ ВТНаборЗаписей
	|ИЗ
	|	&НаборЗаписей КАК Т
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|
	|ВЫБРАТЬ
	|	%3,
	|	%4
	|ПОМЕСТИТЬ ВТИзмененныеДвижения
	|ИЗ
	|
	|(ВЫБРАТЬ
	|	СпрНоменклатура.ТипНоменклатуры,
	|	%1
	|ИЗ
	|	РегистрНакопления.ВыручкаИСебестоимостьПродаж КАК Т
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаНоменклатуры КАК АналитикиНоменклатуры
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СпрНоменклатура
	|				ПО АналитикиНоменклатуры.Номенклатура = СпрНоменклатура.Ссылка
	|		ПО Т.АналитикаУчетаНоменклатуры = АналитикиНоменклатуры.Ссылка
	|ГДЕ
	|	Т.Регистратор = &Регистратор
	|	И НЕ Т.РасчетПартий
	|	И НЕ Т.РасчетСебестоимости
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СпрНоменклатура.ТипНоменклатуры,
	|	%2
	|ИЗ
	|	ВТНаборЗаписей КАК Т
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаНоменклатуры КАК АналитикиНоменклатуры
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СпрНоменклатура
	|				ПО АналитикиНоменклатуры.Номенклатура = СпрНоменклатура.Ссылка
	|		ПО Т.АналитикаУчетаНоменклатуры = АналитикиНоменклатуры.Ссылка
	|ГДЕ
	|	НЕ Т.РасчетПартий
	|	И НЕ Т.РасчетСебестоимости
	|) КАК Т
	|
	|СГРУППИРОВАТЬ ПО
	|	%5
	|ИМЕЮЩИЕ
	|	%6
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|
	|ВЫБРАТЬ
	|	Т.Период КАК Период,
	|	МАКСИМУМ(Т.ЕстьИзмененныеДвижения) КАК ЕстьИзмененныеДвижения
	|ПОМЕСТИТЬ ВТПериодыДвижений
	|ИЗ
	|	(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		НАЧАЛОПЕРИОДА(Т.Период, МЕСЯЦ) КАК Период,
	|		ЛОЖЬ КАК ЕстьИзмененныеДвижения
	|	ИЗ
	|		ВТНаборЗаписей КАК Т
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		НАЧАЛОПЕРИОДА(Т.Период, МЕСЯЦ) КАК Период,
	|		ИСТИНА КАК ЕстьИзмененныеДвижения
	|	ИЗ
	|		ВТИзмененныеДвижения КАК Т
	|	) КАК Т
	|
	|СГРУППИРОВАТЬ ПО
	|	Т.Период
	|;
	|";
	
	Запрос.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ШаблонТекстаЗапроса,
		ТекстПоляРегистра,
		ТекстПоляРегистраСМинусом,
		ТекстПоляРегистраБезПартий,
		ТекстПоляСуммирования,
		ТекстПоляГруппировкиБезПартий,
		ТекстПоляУсловия);
		
	Запрос.Выполнить(); // сформируем временные таблицы с описанием движений
	
	#КонецОбласти
	
	#Область ЗаполнениеНабораЗаписей
	
	// Движения не измененных периодов возьмем из ИБ,
	// а движения измененных периодов и расчетные движения - из набора записей.
	ШаблонТекстаЗапроса =
	"ВЫБРАТЬ
	|	&Регистратор КАК Регистратор,
	|	%1
	|ИЗ
	|	РегистрНакопления.ВыручкаИСебестоимостьПродаж КАК Т
	|ГДЕ
	|	Т.Регистратор = &Регистратор
	|	И НЕ Т.РасчетПартий
	|	И НЕ Т.РасчетСебестоимости
	|	И НАЧАЛОПЕРИОДА(Т.Период, МЕСЯЦ) В
	|		(ВЫБРАТЬ Т.Период
	|		 ИЗ ВТПериодыДвижений КАК Т
	|		 ГДЕ НЕ Т.ЕстьИзмененныеДвижения)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	&Регистратор КАК Регистратор,
	|	%1
	|ИЗ
	|	ВТНаборЗаписей КАК Т
	|ГДЕ
	|	НЕ Т.РасчетПартий
	|	И НЕ Т.РасчетСебестоимости
	|	И НАЧАЛОПЕРИОДА(Т.Период, МЕСЯЦ) В
	|		(ВЫБРАТЬ Т.Период
	|		 ИЗ ВТПериодыДвижений КАК Т
	|		 ГДЕ Т.ЕстьИзмененныеДвижения)
	|";
	
	Запрос.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ШаблонТекстаЗапроса,
		ТекстПоляРегистра);
	
	ТаблицаЗаписей = Запрос.Выполнить().Выгрузить();
	
	ЭтотОбъект.Загрузить(ТаблицаЗаписей);
	
	#КонецОбласти
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
