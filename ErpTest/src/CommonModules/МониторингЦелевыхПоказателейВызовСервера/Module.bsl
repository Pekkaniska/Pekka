///////////////////////////////////////////////////////////////////////////////
// Модуль содержит методы формирования управленческой отчетности
///////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ФормированиеНастроекВариантовОтчетов

// Функция заполняет переданными параметрами и возвращает пользовательские настройки варианта
// Этапы получения пользовательских настроек:
//		1. Получение пользовательских настроек для пользовательских вариантов отчетов (настройки сохранялись/несохранялись)
//		2. Получение пользовательских настроек для предопределенных вариантов отчетов (настройки сохранялись)
//		3. Получение пользовательских настроек для предопределенных вариантов отчетов (настройки не сохранялись, первый запуск).
//
// Параметры:
//	СвойстваВариантаАнализа - Структура
//		* Ссылка        - СправочникСсылка.ВариантыАнализаЦелевыхПоказателей - вариант анализа, настройки которого будут применены к отчету
//		* ПериодАнализа - ХранилищеЗначений - содержит упакованный СтандартныйПериод, описывающий период выборки данных
//	СвойстваВариантаОтчета  - СправочникСсылка.ВариантыОтчетов - вариант отчета, настройки которого будут установлены.
//
// Возвращаемое значение:
//	ПользовательскиеНастройкиКомпоновкиДанных
//
Функция СформироватьНастройкиВариантаОтчета(СвойстваВариантаАнализа, СвойстваВариантаОтчета) Экспорт
	
	СтруктураНастроек = Новый Структура("ПользовательскиеНастройки, ФиксированныеНастройки");
	НастройкиВарианта = Неопределено;
	ОписаниеВарианта = ХранилищеВариантовОтчетов.ПолучитьОписание(СвойстваВариантаОтчета.КлючОбъекта, СвойстваВариантаОтчета.КлючВарианта);
	
	// Передадим в отчет пользовательские настройки варианта анализа
	ФиксированныеНастройкиВариантаОтчета = УстановитьКоллекциюОтборовВФиксированныеНастройки(СвойстваВариантаОтчета, СвойстваВариантаАнализа, ОписаниеВарианта);
	
	Если ФиксированныеНастройкиВариантаОтчета = Неопределено Тогда
		СКДОтчета = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(СвойстваВариантаОтчета.КлючОбъекта).ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
		ФиксированныеНастройкиВариантаОтчета = СКДОтчета.ВариантыНастроек[СвойстваВариантаОтчета.КлючВарианта].Настройки;
	КонецЕсли;
	
	// Установим параметры варианта отчета
	УстанавливаемыеПараметры = СформироватьКоллекциюПараметровПериодов(СвойстваВариантаАнализа.ПериодАнализа);
	
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроек.ЗагрузитьФиксированныеНастройки(ФиксированныеНастройкиВариантаОтчета);
	
	Если ПравоДоступа("СохранениеДанныхПользователя", Метаданные) И ОписаниеВарианта.ДополнительныеСвойства.Пользовательский Тогда
		НастройкиВарианта = ХранилищеВариантовОтчетов.Загрузить(СвойстваВариантаОтчета.КлючОбъекта, СвойстваВариантаОтчета.КлючВарианта, ОписаниеВарианта);
	КонецЕсли;
	
	Если НастройкиВарианта = Неопределено Тогда
		СКДОтчета = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(СвойстваВариантаОтчета.КлючОбъекта).ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
		НастройкиВарианта = СКДОтчета.ВариантыНастроек[СвойстваВариантаОтчета.КлючВарианта].Настройки;
	КонецЕсли;
	
	КомпоновщикНастроек.ЗагрузитьНастройки(НастройкиВарианта);
	
	ПользовательскиеНастройкиВарианта = КомпоновщикНастроек.ПользовательскиеНастройки;
	
	КомпоновкаДанныхКлиентСервер.УстановитьКоллекциюПараметров(ПользовательскиеНастройкиВарианта, УстанавливаемыеПараметры);
	
	СтруктураНастроек.Вставить("ФиксированныеНастройки", ФиксированныеНастройкиВариантаОтчета);
	СтруктураНастроек.Вставить("ПользовательскиеНастройки", ПользовательскиеНастройкиВарианта);
	
	Возврат СтруктураНастроек;
	
КонецФункции

#КонецОбласти

#Область ПолучениеСвойствВариантаАнализаИСсылокНаОбъекты

// Функция возвращает свойства варианта анализа по идентификатору варианта
// Параметры:
//	Идентификатор - Строка - строковое представление идентификатора варианта анализа
// Возвращаемое значение;
//	Структура - структура свойств варианта анализа целевых показателей.
//
Функция ПолучитьСвойстваВариантаАнализаПоИдентификатору(Идентификатор) Экспорт
	
	ВариантАнализа = ПолучитьСсылкуСправочникаПоИдентификатору("ВариантыАнализаЦелевыхПоказателей", Идентификатор);
	
	СтруктураПоказателя = Новый Структура("Ссылка, ПериодАнализа", ВариантАнализа, ВариантАнализа.ПериодАнализа.Получить());
	
	Возврат СтруктураПоказателя;
	
КонецФункции

// Функция возвращает ссылку справочника по идентификатору ссылки
// Параметры:
//	ИмяОбъекта    - Строка - имя справочника
//	Идентификатор - Строка - идентификатор элемента справочника
// Возвращаемое значение;
//	СправочникСсылка - ссылка на объект метаданных.
//
Функция ПолучитьСсылкуСправочникаПоИдентификатору(ИмяОбъекта, Идентификатор) Экспорт
		
	УникальныйИдентификаторПоказателя = Новый УникальныйИдентификатор(СтрЗаменить(Идентификатор, "_", "-"));
	ИскомаяСсылка = Справочники[ИмяОбъекта].ПолучитьСсылку(УникальныйИдентификаторПоказателя);
	
	Возврат ИскомаяСсылка;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ФормированиеНастроекВариантовОтчетов

Процедура СкопироватьЭлементыОтборовВСоответствия(КоллекцияЭлементов, СоответствиеВключенные, СоответствиеНеВключенные, ВключатьВложенные = Ложь)
	
	Для Каждого ЭлементКоллекции Из КоллекцияЭлементов Цикл 
		Если НЕ ПустаяСтрока(ЭлементКоллекции.ИдентификаторПользовательскойНастройки) Тогда
			Если ТипЗнч(ЭлементКоллекции) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
				СоответствиеВключенные.Вставить(ЭлементКоллекции.ИдентификаторПользовательскойНастройки, ЭлементКоллекции);
				
			Иначе
				СоответствиеВключенные.Вставить(ЭлементКоллекции.ИдентификаторПользовательскойНастройки, ЭлементКоллекции);
				
				Если ВключатьВложенные Тогда
					СкопироватьЭлементыОтборовВСоответствия(ЭлементКоллекции.Элементы, СоответствиеВключенные, СоответствиеНеВключенные);
					
				КонецЕсли;
				
			КонецЕсли;
		Иначе
			СоответствиеНеВключенные.Вставить(ЭлементКоллекции, ЭлементКоллекции);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция УстановитьКоллекциюОтборовВФиксированныеНастройки(СвойстваВариантОтчета, СвойстваВариантаАнализа, ОписаниеВарианта)
	
	НастройкиВарианта = Неопределено;
	
	// Получим сохраненные настройки варианта отчета
	Если ПравоДоступа("СохранениеДанныхПользователя", Метаданные) И ОписаниеВарианта.ДополнительныеСвойства.Пользовательский Тогда
		НастройкиВарианта = ХранилищеВариантовОтчетов.Загрузить(СвойстваВариантОтчета.КлючОбъекта, СвойстваВариантОтчета.КлючВарианта, ОписаниеВарианта);
	КонецЕсли;

	Если НастройкиВарианта = Неопределено Тогда
		СКДОтчета = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(СвойстваВариантОтчета.КлючОбъекта).ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
		
		ИскомыйВариантОтчета = СКДОтчета.ВариантыНастроек.Найти(СвойстваВариантОтчета.КлючВарианта);
		Если Не ИскомыйВариантОтчета = Неопределено Тогда
			НастройкиВарианта = СКДОтчета.ВариантыНастроек[СвойстваВариантОтчета.КлючВарианта].Настройки;
		Иначе
			Возврат Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроек.ЗагрузитьНастройки(НастройкиВарианта);
	
	// Получим настройки варианта анализа
	Если ЗначениеЗаполнено(СвойстваВариантаАнализа.Ссылка.Владелец.СхемаКомпоновкиДанных) ИЛИ СвойстваВариантаАнализа.Ссылка.Владелец.ХранилищеСхемыКомпоновкиДанных.Получить() = Неопределено Тогда
		СхемаИНастройки = Справочники.СтруктураЦелей.ОписаниеИСхемаКомпоновкиДанныхЦелиПоИмениМакета(СвойстваВариантаАнализа.Ссылка.Владелец, СвойстваВариантаАнализа.Ссылка.Владелец.СхемаКомпоновкиДанных);
		СхемаКомпоновкиДанных = СхемаИНастройки.СхемаКомпоновкиДанных;
	Иначе
		СхемаКомпоновкиДанных = СвойстваВариантаАнализа.Ссылка.Владелец.ХранилищеСхемыКомпоновкиДанных.Получить();
	КонецЕсли;
	
	АдресСКД = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, Новый УникальныйИдентификатор());
	ИсточникДоступныхНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСКД);
	
	КомпоновщикНастроекВариантаАнализа = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроекВариантаАнализа.Инициализировать(ИсточникДоступныхНастроек);
	
	Настройки = СвойстваВариантаАнализа.Ссылка.Владелец.ХранилищеНастроекКомпоновкиДанных.Получить();
	
	Если НЕ Настройки = Неопределено Тогда
		КомпоновщикНастроекВариантаАнализа.ЗагрузитьНастройки(Настройки);
		
	Иначе
		КомпоновщикНастроекВариантаАнализа.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
		
	КонецЕсли;
	
	ПользовательскиеНастройкиВариантаАнализа = СвойстваВариантаАнализа.Ссылка.ХранилищеПользовательскихНастроекКомпоновкиДанных.Получить();
	
	Если НЕ ПользовательскиеНастройкиВариантаАнализа = Неопределено Тогда
		КомпоновщикНастроекВариантаАнализа.ЗагрузитьПользовательскиеНастройки(ПользовательскиеНастройкиВариантаАнализа);
	Иначе 
		КомпоновщикНастроекВариантаАнализа.Восстановить();
		
	КонецЕсли;
	
	// Получим отборы, которые нужно передать в отчет
	ПользовательскиеОтборы = КомпоновщикНастроекВариантаАнализа.ПользовательскиеНастройки.Элементы;
	
	УстанавливаемыеОтборыВключенныеВПользовательскиеОтборы = Новый Соответствие;
	УстанавливаемыеОтборыНеВключенныеВПользовательскиеОтборы = Новый Соответствие;
	УстанавливаемыеПользовательскиеОтборы = Новый Соответствие;
	
	Для Каждого ПользовательскийОтбор Из ПользовательскиеОтборы Цикл 
		Если ТипЗнч(ПользовательскийОтбор) = Тип("ЭлементОтбораКомпоновкиДанных")
			ИЛИ ТипЗнч(ПользовательскийОтбор) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			
			УстанавливаемыеПользовательскиеОтборы.Вставить(ПользовательскийОтбор.ИдентификаторПользовательскойНастройки, ПользовательскийОтбор);
			
		КонецЕсли;
		
	КонецЦикла;
	
	ОтборыВариантаАнализа = КомпоновщикНастроекВариантаАнализа.Настройки.Отбор.Элементы;
	
	СкопироватьЭлементыОтборовВСоответствия(ОтборыВариантаАнализа, УстанавливаемыеОтборыВключенныеВПользовательскиеОтборы, УстанавливаемыеОтборыНеВключенныеВПользовательскиеОтборы);
	
	// Заполним отборы фиксированных настроек
	ОтборыФиксированныхНастроек = КомпоновщикНастроек.ФиксированныеНастройки.Отбор.Элементы;
	
	Для Каждого УстанавливаемыйОтбор Из УстанавливаемыеОтборыНеВключенныеВПользовательскиеОтборы Цикл 
		Если ТипЗнч(УстанавливаемыйОтбор.Значение) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			НовыйОтбор = ОтборыФиксированныхНастроек.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ЗаполнитьЗначенияСвойств(НовыйОтбор, УстанавливаемыйОтбор.Значение);
			
		Иначе
			НовыйОтбор = ОтборыФиксированныхНастроек.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
			ЗаполнитьЗначенияСвойств(НовыйОтбор, УстанавливаемыйОтбор.Значение);
			КомпоновкаДанныхКлиентСервер.СкопироватьЭлементы(НовыйОтбор, УстанавливаемыйОтбор.Значение);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого УстанавливаемыйОтбор Из УстанавливаемыеОтборыВключенныеВПользовательскиеОтборы Цикл
		Если ТипЗнч(УстанавливаемыйОтбор.Значение) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			НовыйОтбор = ОтборыФиксированныхНастроек.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ЗаполнитьЗначенияСвойств(НовыйОтбор, УстанавливаемыйОтбор.Значение);
			ЗаполнитьЗначенияСвойств(НовыйОтбор, УстанавливаемыеПользовательскиеОтборы.Получить(УстанавливаемыйОтбор.Ключ),,"ЛевоеЗначение");
			
		Иначе
			НовыйОтбор = ОтборыФиксированныхНастроек.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
			ЗаполнитьЗначенияСвойств(НовыйОтбор, УстанавливаемыйОтбор.Значение);
			ЗаполнитьЗначенияСвойств(НовыйОтбор, УстанавливаемыеПользовательскиеОтборы.Получить(УстанавливаемыйОтбор.Ключ),,"Представление");
			КомпоновкаДанныхКлиентСервер.СкопироватьЭлементы(НовыйОтбор, УстанавливаемыйОтбор.Значение);
			
		КонецЕсли;
	КонецЦикла;
	
	Возврат КомпоновщикНастроек.ФиксированныеНастройки;
	
КонецФункции

#КонецОбласти

#Область Прочее

// Возвращает коллекцию параметров с типом дата или стандартный период
// В коллекцию добавляются используемые на данный момент параметры периодов
// в схемах компоновки данных отчетов.
//  
//Параметры
//	Период - СтандартныйПериод
//
Функция СформироватьКоллекциюПараметровПериодов(Период)
	
	КоллекцияПараметровПериода = Новый Соответствие;
	
	// Добавим стандартные периоды
	КоллекцияПараметровПериода.Вставить("Период", Период);
	КоллекцияПараметровПериода.Вставить("ПериодОтчета", Период);
	КоллекцияПараметровПериода.Вставить("СтандартныйПериод", Период);
	
	// Добавим даты начала периодов
	КоллекцияПараметровПериода.Вставить("НачалоПериода", Период.ДатаНачала);
	КоллекцияПараметровПериода.Вставить("ПериодНачало", Период.ДатаНачала);
	КоллекцияПараметровПериода.Вставить("ДатаНачала", Период.ДатаНачала);
	
	// Добавим даты окончания периодов
	КоллекцияПараметровПериода.Вставить("ОкончаниеПериода", Период.ДатаОкончания);
	КоллекцияПараметровПериода.Вставить("КонецПериода", Период.ДатаОкончания);
	КоллекцияПараметровПериода.Вставить("ПериодКонец", Период.ДатаОкончания);
	КоллекцияПараметровПериода.Вставить("ПериодОкончание", Период.ДатаОкончания);
	КоллекцияПараметровПериода.Вставить("ДатаОтчета", Период.ДатаОкончания);
	КоллекцияПараметровПериода.Вставить("ДатаОкончания", Период.ДатаОкончания);
	КоллекцияПараметровПериода.Вставить("НаДату", Период.ДатаОкончания);
	
	Возврат КоллекцияПараметровПериода;
	
КонецФункции

#КонецОбласти

#КонецОбласти
