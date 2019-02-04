#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция СкопироватьОписьСВходящимиДокументами() Экспорт
	
	НоваяОпись = Скопировать();
	НоваяОпись.НомерПачки = ПерсонифицированныйУчет.ПолучитьСледующийНомерПачки(Организация, НоваяОпись.ОтчетныйПериод);
	НоваяОпись.Дата = ТекущаяДатаСеанса();
	НоваяОпись.УстановитьНовыйНомер();
	
	ТекущийНомерПачки = НоваяОпись.НомерПачки + 1;
	Для Каждого ОписаниеПачки Из ПачкиДокументов Цикл
		ПачкаСЗВОбъект = ОписаниеПачки.ПачкаДокументов.ПолучитьОбъект();
		
		НоваяПачкаСЗВ = ПачкаСЗВОбъект.Скопировать();
		
		НоваяПачкаСЗВ.НомерПачки = ТекущийНомерПачки;
		НоваяПачкаСЗВ.Дата = ТекущаяДатаСеанса();
		НоваяПачкаСЗВ.УстановитьНовыйНомер();
		
		НоваяПачкаСЗВ.Записать(РежимЗаписиДокумента.Запись);
		
		ТекущийНомерПачки = ТекущийНомерПачки + 1;
		
		ОписаниеПачкиОписи = НоваяОпись.ПачкиДокументов.Добавить();
		ОписаниеПачкиОписи.ПачкаДокументов = НоваяПачкаСЗВ.Ссылка;
	КонецЦикла;
	
	НоваяОпись.Записать(РежимЗаписиДокумента.Запись);
	
	Возврат НоваяОпись;
	
КонецФункции

Функция СформироватьЗапросПоПачкамДокументовДляПроверки()
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("ПачкиДокументов", ПачкиДокументов);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПачкиДокументов.ПачкаДокументов,
	|	ПачкиДокументов.НомерСтроки
	|ПОМЕСТИТЬ ВТПачкиДокументов
	|ИЗ
	|	&ПачкиДокументов КАК ПачкиДокументов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(ПачкиДокументов.ПачкаДокументов.ОтчетныйПериод, ДАТАВРЕМЯ(1,1,1)) КАК ОтчетныйПериод,
	|	ЕСТЬNULL(ПачкиДокументов.ПачкаДокументов.Организация, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)) КАК Организация,
	|	ЕСТЬNULL(ПачкиДокументов.ПачкаДокументов.НомерПачки, 0) КАК НомерПачки,
	|	ПачкиДокументов.ПачкаДокументов КАК Документ,
	|	ЕСТЬNULL(ПачкиДокументов.ПачкаДокументов.Проведен, ЛОЖЬ) КАК Проведен,
	|	ПачкиДокументов.ПачкаДокументов,
	|	ПачкиДокументов.НомерСтроки,
	|	ПачкиДокументовДубль.НомерСтроки КАК НомерСтрокиДубль
	|ИЗ
	|	ВТПачкиДокументов КАК ПачкиДокументов
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТПачкиДокументов КАК ПачкиДокументовДубль
	|		ПО ПачкиДокументов.ПачкаДокументов = ПачкиДокументовДубль.ПачкаДокументов
	|			И ПачкиДокументов.НомерСтроки > ПачкиДокументовДубль.НомерСтроки";
	
	Возврат Запрос.Выполнить();
	
КонецФункции

Процедура ПроверитьДанныеДокумента(Отказ = Ложь) Экспорт
	Ошибки = Новый Массив;
	
	Если Не ПроверитьЗаполнение() Тогда
		Отказ = Истина;
	КонецЕсли;	
	
	ТекстОшибки = НСтр("ru = 'Форма АДВ-6-2 подается за периоды до 2014 г.'");

	Если ОтчетныйПериод >= '20140101' Тогда
		ПерсонифицированныйУчетКлиентСервер.ДобавитьОшибкуЗаполненияЭлементаДокумента(Ошибки, Ссылка, ТекстОшибки, "ОтчетныйПериод", Отказ);
	КонецЕсли;
		
	Если Не ДополнительныеСвойства.Свойство("НеПроверятьДанныеОрганизации") Тогда
		ПерсонифицированныйУчет.ПроверитьДанныеОрганизации(ЭтотОбъект, Организация, Отказ);
	КонецЕсли;	

	ВыборкаДокументовДляПроверки = СформироватьЗапросПоПачкамДокументовДляПроверки().Выбрать();
	
	Пока ВыборкаДокументовДляПроверки.Следующий() Цикл
		
		Если ВыборкаДокументовДляПроверки.ОтчетныйПериод <> ОтчетныйПериод Тогда
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Отчетный период документа-пачки отличается от указанного.'"), ВыборкаДокументовДляПроверки.НомерСтроки);
			
			ПерсонифицированныйУчетКлиентСервер.ДобавитьОшибкуДанныхДокументаОписи(Ошибки, Ссылка, ВыборкаДокументовДляПроверки.ПачкаДокументов, ВыборкаДокументовДляПроверки.НомерСтроки, ТекстСообщения, "ОтчетныйПериод", Отказ);
		КонецЕсли;
		
		Если ВыборкаДокументовДляПроверки.Организация <> Организация Тогда
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Документ-пачка оформлен на другую организацию.'"), ВыборкаДокументовДляПроверки.НомерСтроки);
			
			ПерсонифицированныйУчетКлиентСервер.ДобавитьОшибкуДанныхДокументаОписи(Ошибки, Ссылка, ВыборкаДокументовДляПроверки.ПачкаДокументов, ВыборкаДокументовДляПроверки.НомерСтроки, ТекстСообщения, "Организация", Отказ);
		КонецЕсли;
		
		Если ВыборкаДокументовДляПроверки.НомерПачки = НомерПачки Тогда
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Документ-пачка имеет такой же номер как и документ описи, рекомендуется изменить номер пачки в документе описи.'"), ВыборкаДокументовДляПроверки.НомерСтроки);
			
			ПерсонифицированныйУчетКлиентСервер.ДобавитьОшибкуДанныхДокументаОписи(Ошибки, Ссылка, ВыборкаДокументовДляПроверки.ПачкаДокументов, ВыборкаДокументовДляПроверки.НомерСтроки, ТекстСообщения, "НомерПачки", Отказ);
		КонецЕсли;
		
		Если ВыборкаДокументовДляПроверки.НомерСтрокиДубль <> Null Тогда
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Документ-пачка указан дважды.'"), ВыборкаДокументовДляПроверки.НомерСтроки);
			
			ПерсонифицированныйУчетКлиентСервер.ДобавитьОшибкуДанныхДокументаОписи(Ошибки, Ссылка, ВыборкаДокументовДляПроверки.ПачкаДокументов, ВыборкаДокументовДляПроверки.НомерСтроки, ТекстСообщения, "ПачкаДокументов", Отказ);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ОкончаниеОтчетногоПериода() Экспорт
	
	Возврат ПерсонифицированныйУчетКлиентСервер.ОкончаниеОтчетногоПериодаПерсУчета(ОтчетныйПериод);
	
КонецФункции

#КонецОбласти

#КонецЕсли