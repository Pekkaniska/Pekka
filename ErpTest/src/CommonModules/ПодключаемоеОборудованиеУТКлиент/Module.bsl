
#Область ПрограммныйИнтерфейс

// Открыть форму предварительного просмотра чека ККМ.
//
// Параметры:
//  Форма - УправляемаяФорма - Форма.
//  ПараметрыОперации - Структура - Структура со свойствами:
//   * ДокументСсылка;
//   * Организация;
//   * ТорговыйОбъект;
//   * ПодключенноеОборудование;
//   * Сумма;
//   * ВыемкаДенежныхСредствИзКассыККМ
//   * ВнесениеДенежныхСредствВКассуККМ
//  РежимЗаписи - РежимЗаписиДокумента - Режим записи.
//  ОповещениеПриЗавершении - ОписаниеОповещения - Описание оповещения.
//
Процедура ПробитьЧек(Форма, ПараметрыОперации, РежимЗаписи, ОповещениеПриЗавершении = Неопределено) Экспорт
	
	ОчиститьСообщения();
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма",                   Форма);
	ДополнительныеПараметры.Вставить("ПараметрыОперации",       ПараметрыОперации);
	ДополнительныеПараметры.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	ДополнительныеПараметры.Вставить("РежимЗаписиДокумента",    РежимЗаписи);
	ДополнительныеПараметры.Вставить("ИмяПроцедуры",            "ПробитиеЧекаПослеЗаписиДокумента");
	
	ОбработатьРежимЗаписи(Истина, ДополнительныеПараметры);
	
КонецПроцедуры

// Пробить чек выемки денежных средств.
//
// Параметры:
//  Форма - УправляемаяФорма - Форма.
//  ПараметрыОперации - Структура - Структура со свойствами:
//   * ДокументСсылка;
//   * Организация;
//   * ТорговыйОбъект;
//   * ПодключенноеОборудование;
//   * Сумма;
//   * ВыемкаДенежныхСредствИзКассыККМ
//   * ВнесениеДенежныхСредствВКассуККМ
//  РежимЗаписи - РежимЗаписиДокумента - Режим записи.
//  ОповещениеПриЗавершении - ОписаниеОповещения - Описание оповещения.
//
Процедура ПробитьЧекВыемкаДенежныхСредств(Форма, ПараметрыОперации, РежимЗаписи, ОповещениеПриЗавершении) Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма",                   Форма);
	ДополнительныеПараметры.Вставить("ПараметрыОперации",       ПараметрыОперации);
	ДополнительныеПараметры.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	ДополнительныеПараметры.Вставить("РежимЗаписиДокумента",    РежимЗаписи);
	ДополнительныеПараметры.Вставить("ИмяПроцедуры",            "ПробитиеЧекаВыемкаДенежныхСредствПослеЗаписиДокумента");
	
	РозничныеПродажиКлиент.ОбработатьСостояниеСмены(
		Форма,
		Новый ОписаниеОповещения("ОбработатьРежимЗаписи", ЭтотОбъект, ДополнительныеПараметры));
	
КонецПроцедуры

// Пробить чек внесения денежных средств.
//
// Параметры:
//  Форма - УправляемаяФорма - Форма.
//  ПараметрыОперации - Структура - Структура со свойствами:
//   * ДокументСсылка;
//   * Организация;
//   * ТорговыйОбъект;
//   * ПодключенноеОборудование;
//   * Сумма;
//   * ВыемкаДенежныхСредствИзКассыККМ
//   * ВнесениеДенежныхСредствВКассуККМ
//  РежимЗаписи - РежимЗаписиДокумента - Режим записи.
//  ОповещениеПриЗавершении - ОписаниеОповещения - Описание оповещения.
//
Процедура ПробитьЧекВнесениеДенежныхСредств(Форма, ПараметрыОперации, РежимЗаписи, ОповещениеПриЗавершении) Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма",                   Форма);
	ДополнительныеПараметры.Вставить("ПараметрыОперации",       ПараметрыОперации);
	ДополнительныеПараметры.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	ДополнительныеПараметры.Вставить("РежимЗаписиДокумента",    РежимЗаписи);
	ДополнительныеПараметры.Вставить("ИмяПроцедуры",            "ПробитиеЧекаВнесениеДенежныхСредствПослеЗаписиДокумента");
	
	РозничныеПродажиКлиент.ОбработатьСостояниеСмены(
		Форма,
		Новый ОписаниеОповещения("ОбработатьРежимЗаписи", ЭтотОбъект, ДополнительныеПараметры));
	
КонецПроцедуры

// Открыть форму записи журнала фискальных операций.
//
// Параметры:
//  Форма - УправляемаяФорма - Форма.
//  ДанныеЖурналаФискальныхОпераций - Структура со свойствами:
//   * ИдентификаторЗаписи - Строка - Идентификатор записи.
//   * ДокументОснование - ДокументСсылка - Ссылка на документ-основание.
//
Процедура ОткрытьЗаписьЖурналаФискальныхОпераций(Форма, ДанныеЖурналаФискальныхОпераций) Экспорт
	
	ПараметрыЗаписи = Новый Структура();
	ПараметрыЗаписи.Вставить("ИдентификаторЗаписи", ДанныеЖурналаФискальныхОпераций.ИдентификаторЗаписи);
	ПараметрыЗаписи.Вставить("ДокументОснование",   ДанныеЖурналаФискальныхОпераций.ДокументОснование);
	
	ЗначениеКлюча = Новый Массив;
	ЗначениеКлюча.Добавить(ПараметрыЗаписи);
	
	КлючЗаписи = Новый("РегистрСведенийКлючЗаписи.ЖурналФискальныхОпераций", ЗначениеКлюча);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ", КлючЗаписи);
	
	ОткрытьФорму("РегистрСведений.ЖурналФискальныхОпераций.Форма.ФискальнаяОперация", ПараметрыФормы, Форма);
	
КонецПроцедуры

// Получить структуру реквизитов фискальной операции кассового узла.
// 
// Возвращаемое значение:
//  Структура - Структура со свойствами:
//   * Дата - Дата - Дата операции.
//   * ДокументОснование - ДокументСсылка - Ссылка на документ-основание.
//   * Организация - ОпределяемыйТип.ОрганизацияБПО - Организация.
//   * ТорговыйОбъект - ОпределяемыйТип.ТорговыйОбъектБПО - Торговый объект.
//   * Устройство - СправочникСсылка.ПодключаемоеОборудование - Устройство.
//   * ТипОперации - ПеречислениеСсылка.ТипыОперацииКассовогоУзла - Тип операции.
//   * ТипРасчета - ПеречислениеСсылка.ТипыРассылкиЭлектронныхЧеков - Тип расчета.
//   * НомерЧекаККМ - Число - Номер чека ККМ.
//   * НомерСмены - Число - Номер смены ККМ.
//   * ВариантОтправкиЭлектронногоЧека - ПеречислениеСсылка.ВариантыОтправкиЭлектронногоЧека.
//   * КонтактныеДанныеЭлектронногоЧека - Строка - Контактные данные.
//   * Сумма - Число - Сумма.
//   * СуммаОплатыНаличные - Число - Сумма.
//   * СуммаОплатыПлатежнаяКарта - Число - Сумма.
//   * СуммаКредит - Число - Сумма.
//   * СуммаПредоплаты - Число - Сумма.
//   * СуммаВзаимозачет - Число - Сумма.
//   * Данные - Строка - XML фискальной операции.
//   * ДополнительныеПараметры - Структура - Дополнительные параметры.
//
Функция СтруктураРеквизитыФискальнойОперацииКассовогоУзла() Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	
	Реквизиты = Новый Структура;
	
	Реквизиты.Вставить("Дата");
	Реквизиты.Вставить("ДокументОснование");
	Реквизиты.Вставить("Организация");
	Реквизиты.Вставить("ТорговыйОбъект");
	Реквизиты.Вставить("Устройство");
	
	Реквизиты.Вставить("ТипОперации");
	Реквизиты.Вставить("ТипРасчета");
	
	Реквизиты.Вставить("НомерЧекаККМ");
	Реквизиты.Вставить("НомерСмены");
	Реквизиты.Вставить("ВариантОтправкиЭлектронногоЧека");
	Реквизиты.Вставить("КонтактныеДанныеЭлектронногоЧека");
	
	Реквизиты.Вставить("Сумма");
	Реквизиты.Вставить("СуммаОплатыНаличные");
	Реквизиты.Вставить("СуммаОплатыПлатежнаяКарта");
	Реквизиты.Вставить("СуммаКредит");
	Реквизиты.Вставить("СуммаПредоплаты");
	Реквизиты.Вставить("СуммаВзаимозачет");
	
	Реквизиты.Вставить("Данные");
	
	Реквизиты.Вставить("ДополнительныеПараметры", ДополнительныеПараметры);
	
	Возврат Реквизиты;
	
КонецФункции

// Получить структуру реквизитов операции инкассации кассового узла.
// 
// Возвращаемое значение:
//  Структура - Структура со свойствами:
//   * Дата - Дата - Дата операции.
//   * ДокументОснование - ДокументСсылка - Ссылка на документ-основание.
//   * Организация - ОпределяемыйТип.ОрганизацияБПО - Организация.
//   * ТорговыйОбъект - ОпределяемыйТип.ТорговыйОбъектБПО - Торговый объект.
//   * Устройство - СправочникСсылка.ПодключаемоеОборудование - Устройство.
//   * ТипОперации - ПеречислениеСсылка.ТипыОперацииКассовогоУзла - Тип операции.
//   * Сумма - Число - Сумма.
//   * ДополнительныеПараметры - Структура - Дополнительные параметры.
//
Функция СтруктураРеквизитыОперацииИнкассацииКассовогоУзла() Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	
	Реквизиты = Новый Структура;
	
	Реквизиты.Вставить("Дата");
	Реквизиты.Вставить("ДокументОснование");
	Реквизиты.Вставить("Организация");
	Реквизиты.Вставить("ТорговыйОбъект");
	Реквизиты.Вставить("Устройство");
	
	Реквизиты.Вставить("ТипОперации");
	Реквизиты.Вставить("Сумма");
	
	Реквизиты.Вставить("ДополнительныеПараметры", ДополнительныеПараметры);
	
	Возврат Реквизиты;
	
КонецФункции

// Записать объект.
//
// Параметры:
//  Форма - УправляемаяФорма - Форма.
//  РежимЗаписиДокумента - РежимЗаписиДокумента - Режим записи.
//  ОповещениеПриЗавершении - ОписаниеОповещения - Описание оповещения.
//
Процедура ЗаписатьОбъект(Форма, РежимЗаписиДокумента, ОписаниеОповещения) Экспорт
	
	ОтветЧерезОписаниеОповещения = ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(Форма, "НеВыполнятьПроверкуПередЗаписью");
	
	Проведен = Ложь;
	Попытка
		
		Если ОтветЧерезОписаниеОповещения Тогда
			
			Форма.Записать(
				Новый Структура(
					"РежимЗаписи, ДействиеПослеЗаписи",
					РежимЗаписиДокумента,
					ОписаниеОповещения));
			
		Иначе
			
			Проведен = Форма.Записать(
				Новый Структура(
					"РежимЗаписи",
					РежимЗаписиДокумента));
			
		КонецЕсли;
		
	Исключение
		
		Проведен = Ложь;
		
	КонецПопытки;
	
	Если Не ОтветЧерезОписаниеОповещения Тогда
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, Проведен);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПослеОтветаНаВопросОЗаписиДокумента(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		
		Если ДополнительныеПараметры.ОповещениеПриЗавершении <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, Ложь);
		КонецЕсли;
		
	Иначе
		
		ЗаписатьОбъект(
			ДополнительныеПараметры.Форма,
			ДополнительныеПараметры.РежимЗаписиДокумента,
			Новый ОписаниеОповещения(ДополнительныеПараметры.ИмяПроцедуры, ЭтотОбъект, ДополнительныеПараметры));
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПробитиеЧекаПослеЗаписиДокумента(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено
		Или Не Результат Тогда
		
		Если ДополнительныеПараметры.РежимЗаписиДокумента = РежимЗаписиДокумента.Запись Тогда
			ПоказатьПредупреждение(
				Неопределено,
				НСтр("ru = 'Не удалось записать документ'"));
		Иначе
			ПоказатьПредупреждение(
				Неопределено,
				НСтр("ru = 'Не удалось провести документ'"));
		КонецЕсли;
		
		Если ДополнительныеПараметры.ОповещениеПриЗавершении <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, Ложь);
		КонецЕсли;
		
	Иначе
		
		Если ДополнительныеПараметры.ПараметрыОперации.ДокументСсылка <> Неопределено
			И Не ЗначениеЗаполнено(ДополнительныеПараметры.ПараметрыОперации.ДокументСсылка) Тогда
			ДополнительныеПараметры.ПараметрыОперации.ДокументСсылка = ДополнительныеПараметры.Форма.Объект.Ссылка;
		КонецЕсли;
		
		ОткрытьФорму(
			"Обработка.ПредпросмотрЧека.Форма",
			ДополнительныеПараметры.ПараметрыОперации,
			ДополнительныеПараметры.Форма,,,,
			ДополнительныеПараметры.ОповещениеПриЗавершении);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПробитиеЧекаВыемкаДенежныхСредствПослеЗаписиДокумента(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено
		Или Не Результат Тогда
		
		Если ДополнительныеПараметры.РежимЗаписиДокумента = РежимЗаписиДокумента.Запись Тогда
			ПоказатьПредупреждение(
				Неопределено,
				НСтр("ru = 'Не удалось записать документ'"));
		Иначе
			ПоказатьПредупреждение(
				Неопределено,
				НСтр("ru = 'Не удалось провести документ'"));
		КонецЕсли;
		
		Если ДополнительныеПараметры.ОповещениеПриЗавершении <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, Ложь);
		КонецЕсли;
		
	Иначе
		
		Если ДополнительныеПараметры.ПараметрыОперации.ДокументСсылка <> Неопределено
			И Не ЗначениеЗаполнено(ДополнительныеПараметры.ПараметрыОперации.ДокументСсылка) Тогда
			ДополнительныеПараметры.ПараметрыОперации.ДокументСсылка = ДополнительныеПараметры.Форма.Объект.Ссылка;
		КонецЕсли;
		
		ПараметрыОперации = Новый Структура;
		ПараметрыОперации.Вставить("ТипИнкассации", 0);
		ПараметрыОперации.Вставить("Сумма",         ДополнительныеПараметры.ПараметрыОперации.Сумма);
		
		МенеджерОборудованияКлиент.НачатьИнкассациюНаФискальномУстройстве(
			Новый ОписаниеОповещения("ЗаписатьВЖурналВыемкуДенежныхСредствВКассуККМ", ЭтотОбъект, ДополнительныеПараметры),
			ДополнительныеПараметры.Форма.УникальныйИдентификатор,
			ПараметрыОперации,
			ДополнительныеПараметры.ПараметрыОперации.ПодключенноеОборудование);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПробитиеЧекаВнесениеДенежныхСредствПослеЗаписиДокумента(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено
		Или Не Результат Тогда
		
		Если ДополнительныеПараметры.РежимЗаписиДокумента = РежимЗаписиДокумента.Запись Тогда
			ПоказатьПредупреждение(
				Неопределено,
				НСтр("ru = 'Не удалось записать документ'"));
		Иначе
			ПоказатьПредупреждение(
				Неопределено,
				НСтр("ru = 'Не удалось провести документ'"));
		КонецЕсли;
		
		Если ДополнительныеПараметры.ОповещениеПриЗавершении <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, Ложь);
		КонецЕсли;
		
	Иначе
		
		Если ДополнительныеПараметры.ПараметрыОперации.ДокументСсылка <> Неопределено
			И Не ЗначениеЗаполнено(ДополнительныеПараметры.ПараметрыОперации.ДокументСсылка) Тогда
			ДополнительныеПараметры.ПараметрыОперации.ДокументСсылка = ДополнительныеПараметры.Форма.Объект.Ссылка;
		КонецЕсли;
		
		ПараметрыОперации = Новый Структура;
		ПараметрыОперации.Вставить("ТипИнкассации", 1);
		ПараметрыОперации.Вставить("Сумма",         ДополнительныеПараметры.ПараметрыОперации.Сумма);
		
		МенеджерОборудованияКлиент.НачатьИнкассациюНаФискальномУстройстве(
			Новый ОписаниеОповещения("ЗаписатьВЖурналВнесениеДенежныхСредствВКассуККМ", ЭтотОбъект, ДополнительныеПараметры),
			ДополнительныеПараметры.Форма.УникальныйИдентификатор,
			ПараметрыОперации,
			ДополнительныеПараметры.ПараметрыОперации.ПодключенноеОборудование);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаписатьВЖурналВнесениеДенежныхСредствВКассуККМ(РезультатВыполнения, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыполнения.Результат Тогда
		
		Форма = ДополнительныеПараметры.Форма;
		
		ФискальнаяОперацияРеквизиты = ПодключаемоеОборудованиеУТКлиент.СтруктураРеквизитыОперацииИнкассацииКассовогоУзла();
		ФискальнаяОперацияРеквизиты.Дата              = ОбщегоНазначенияКлиент.ДатаСеанса();
		ФискальнаяОперацияРеквизиты.ДокументОснование = ДополнительныеПараметры.ПараметрыОперации.ДокументСсылка;
		ФискальнаяОперацияРеквизиты.Организация       = ДополнительныеПараметры.ПараметрыОперации.Организация;
		ФискальнаяОперацияРеквизиты.ТорговыйОбъект    = ДополнительныеПараметры.ПараметрыОперации.ТорговыйОбъект;
		ФискальнаяОперацияРеквизиты.Устройство        = ДополнительныеПараметры.ПараметрыОперации.ПодключенноеОборудование;
		
		ФискальнаяОперацияРеквизиты.ТипОперации       = ПредопределенноеЗначение("Перечисление.ТипыОперацииКассовогоУзла.ВнесениеДенежныхСредств");
		ФискальнаяОперацияРеквизиты.Сумма             = ДополнительныеПараметры.ПараметрыОперации.Сумма;
		
		ФискальнаяОперацияРеквизиты.ДополнительныеПараметры.Вставить(
			"ВнесениеДенежныхСредствВКассуККМ",
			ДополнительныеПараметры.ПараметрыОперации.ВнесениеДенежныхСредствВКассуККМ);
		
		ПараметрыЗавершения = Новый Структура;
		ПараметрыЗавершения.Вставить("ЗакрытьФорму",                Ложь);
		ПараметрыЗавершения.Вставить("Форма",                       Форма);
		ПараметрыЗавершения.Вставить("ОповещениеПриЗавершении",     ДополнительныеПараметры.ОповещениеПриЗавершении);
		ПараметрыЗавершения.Вставить("ФискальнаяОперацияРеквизиты", ФискальнаяОперацияРеквизиты);
		
		ВыполнитьДействиеПослеЗаписиФискальнойОперацииВЖурнал(
			Форма,
			Новый ОписаниеОповещения("ФискальнаяОперацияЗаписанаВЖурнал", ЭтотОбъект, ПараметрыЗавершения),
			НСтр("ru = 'Не удалось записать данные в журнал фискальных операций.'"));
		
	Иначе
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(РезультатВыполнения.ОписаниеОшибки);
		
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаписатьВЖурналВыемкуДенежныхСредствВКассуККМ(РезультатВыполнения, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыполнения.Результат Тогда
		
		Форма = ДополнительныеПараметры.Форма;
		
		ФискальнаяОперацияРеквизиты = ПодключаемоеОборудованиеУТКлиент.СтруктураРеквизитыОперацииИнкассацииКассовогоУзла();
		ФискальнаяОперацияРеквизиты.Дата              = ОбщегоНазначенияКлиент.ДатаСеанса();
		ФискальнаяОперацияРеквизиты.ДокументОснование = ДополнительныеПараметры.ПараметрыОперации.ДокументСсылка;
		ФискальнаяОперацияРеквизиты.Организация       = ДополнительныеПараметры.ПараметрыОперации.Организация;
		ФискальнаяОперацияРеквизиты.ТорговыйОбъект    = ДополнительныеПараметры.ПараметрыОперации.ТорговыйОбъект;
		ФискальнаяОперацияРеквизиты.Устройство        = ДополнительныеПараметры.ПараметрыОперации.ПодключенноеОборудование;
		
		ФискальнаяОперацияРеквизиты.ТипОперации       = ПредопределенноеЗначение("Перечисление.ТипыОперацииКассовогоУзла.ВыемкаДенежныхСредств");
		ФискальнаяОперацияРеквизиты.Сумма             = ДополнительныеПараметры.ПараметрыОперации.Сумма;
		
		ФискальнаяОперацияРеквизиты.ДополнительныеПараметры.Вставить(
			"ВыемкаДенежныхСредствИзКассыККМ",
			ДополнительныеПараметры.ПараметрыОперации.ВыемкаДенежныхСредствИзКассыККМ);
		
		ПараметрыЗавершения = Новый Структура;
		ПараметрыЗавершения.Вставить("ЗакрытьФорму",                Ложь);
		ПараметрыЗавершения.Вставить("Форма",                       Форма);
		ПараметрыЗавершения.Вставить("ОповещениеПриЗавершении",     ДополнительныеПараметры.ОповещениеПриЗавершении);
		ПараметрыЗавершения.Вставить("ФискальнаяОперацияРеквизиты", ФискальнаяОперацияРеквизиты);
		
		ВыполнитьДействиеПослеЗаписиФискальнойОперацииВЖурнал(
			Форма,
			Новый ОписаниеОповещения("ФискальнаяОперацияЗаписанаВЖурнал", ЭтотОбъект, ПараметрыЗавершения),
			НСтр("ru = 'Не удалось записать данные в журнал фискальных операций.'"));
		
	Иначе
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(РезультатВыполнения.ОписаниеОшибки);
		
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ФискальнаяОперацияЗаписанаВЖурнал(Результат, ДополнительныеПараметры) Экспорт
	
	ФискальнаяОперацияРеквизиты = ДополнительныеПараметры.ФискальнаяОперацияРеквизиты;
	
	Если Результат.ВыполненаОперацияНаУстройстве
		И Результат.ИзмененныеДанныеЗаписаны Тогда
		
		ПараметрыОповещения = Новый Структура;
		ПараметрыОповещения.Вставить("ДокументСсылка", ФискальнаяОперацияРеквизиты.ДокументОснование);
		
		Оповестить("ОбновитьСтатусФискальныхОпераций", ПараметрыОповещения, ДополнительныеПараметры.Форма);
		
		Если ДополнительныеПараметры.ЗакрытьФорму Тогда
			ДополнительныеПараметры.Форма.Закрыть(ФискальнаяОперацияРеквизиты);
		Иначе
			ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении);
		КонецЕсли;
		
	Иначе
		
		Если Результат.ВыполненаОперацияНаУстройстве И Не Результат.ИзмененныеДанныеЗаписаны Тогда
			
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("Данные", ФискальнаяОперацияРеквизиты.ДокументОснование);
			ПараметрыФормы.Вставить("ДанныеДляЖурналаРегистрации", ФискальнаяОперацияРеквизиты);
			ПараметрыФормы.Вставить("ТекстСообщения",
				НСтр("ru = 'ВНИМАНИЕ! Произошла исключительная ситуация:
				           |Чек ККМ пробит, но не зафиксирован в системе.'"));
			
			ОткрытьФорму("Документ.ЧекККМ.Форма.ОшибкаЗаписи", ПараметрыФормы, ЭтотОбъект);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработатьРежимЗаписи(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено
		Или Не Результат Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, Ложь);
	КонецЕсли;
	
	Если ДополнительныеПараметры.РежимЗаписиДокумента = РежимЗаписиДокумента.Запись
		И (Не ЗначениеЗаполнено(ДополнительныеПараметры.Форма.Объект.Ссылка) Или ДополнительныеПараметры.Форма.Модифицированность) Тогда
		
		ПоказатьВопрос(
			Новый ОписаниеОповещения("ПослеОтветаНаВопросОЗаписиДокумента", ЭтотОбъект, ДополнительныеПараметры),
			НСтр("ru = 'Операция возможна только после записи документа, записать документ?'"),
			РежимДиалогаВопрос.ДаНет);
		
	ИначеЕсли ДополнительныеПараметры.РежимЗаписиДокумента = РежимЗаписиДокумента.Проведение
		И (Не ДополнительныеПараметры.Форма.Объект.Проведен Или ДополнительныеПараметры.Форма.Модифицированность) Тогда
		
		ПоказатьВопрос(
			Новый ОписаниеОповещения("ПослеОтветаНаВопросОЗаписиДокумента", ЭтотОбъект, ДополнительныеПараметры),
			НСтр("ru = 'Операция возможна только после проведения документа, провести документ?'"),
			РежимДиалогаВопрос.ДаНет);
		
	Иначе
		ОписаниеОповещения = Новый ОписаниеОповещения(ДополнительныеПараметры.ИмяПроцедуры, ЭтотОбъект, ДополнительныеПараметры);
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, Истина);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОшибкаПриПроведенииЧекаВопросЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Отмена Тогда
		
		ТребуетсяПовторнаяПопыткаЗаписи = Ложь;
		Если ДополнительныеПараметры.ИмяПроцедуры = "ЗаписатьВЖурналФискальныхОпераций" Тогда
			РезультатОперации = ПодключаемоеОборудованиеУТВызовСервера.ЗаписатьВЖурналФискальныхОпераций(
				ТребуетсяПовторнаяПопыткаЗаписи,
				ДополнительныеПараметры.ОписаниеОповещения.ДополнительныеПараметры.ФискальнаяОперацияРеквизиты);
		КонецЕсли;
		
		Если (ТипЗнч(РезультатОперации) = Тип("Булево") И РезультатОперации) Тогда
			
			ВыполнитьОбработкуОповещения(
				ДополнительныеПараметры.ОписаниеОповещения,
				?(ДополнительныеПараметры.ВозвращатьРезультатФункции, РезультатОперации, ДополнительныеПараметры.РезультатПриУспешномПроведении));
			
		Иначе
			
			ПоказатьВопрос(
				Новый ОписаниеОповещения("ОшибкаПриПроведенииЧекаВопросЗавершение", ЭтотОбъект, ДополнительныеПараметры),
				ДополнительныеПараметры.ТекстСообщения,
				РежимДиалогаВопрос.ПовторитьОтмена, 10, КодВозвратаДиалога.Повторить,,КодВозвратаДиалога.Повторить);
			
		КонецЕсли;
		
	Иначе
		
		ВыполнитьОбработкуОповещения(
			ДополнительныеПараметры.ОписаниеОповещения,
			?(ДополнительныеПараметры.ВозвращатьРезультатФункции, ДополнительныеПараметры.РезультатОперации, ДополнительныеПараметры.РезультатПриОтмене));
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьДействиеПослеЗаписиФискальнойОперацииВЖурнал(Форма, ОповещениеПриЗавершении, ТекстСообщения) Экспорт
	
	ТребуетсяПовторнаяПопыткаЗаписи = Ложь;
	ИзмененныеДанныеЗаписаны = ПодключаемоеОборудованиеУТВызовСервера.ЗаписатьВЖурналФискальныхОпераций(
		ТребуетсяПовторнаяПопыткаЗаписи,
		ОповещениеПриЗавершении.ДополнительныеПараметры.ФискальнаяОперацияРеквизиты);
	
	Если Не ИзмененныеДанныеЗаписаны Тогда
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("Форма", Форма);
		ДополнительныеПараметры.Вставить("ОписаниеОповещения", ОповещениеПриЗавершении);
		ДополнительныеПараметры.Вставить("ТекстСообщения", ТекстСообщения);
		ДополнительныеПараметры.Вставить("ВозвращатьРезультатФункции", Ложь);
		ДополнительныеПараметры.Вставить("РезультатПриУспешномПроведении", Новый Структура("ВыполненаОперацияНаУстройстве, ИзмененныеДанныеЗаписаны", Истина, Истина));
		ДополнительныеПараметры.Вставить("РезультатПриОтмене", Новый Структура("ВыполненаОперацияНаУстройстве, ИзмененныеДанныеЗаписаны", Истина, Ложь));
		ДополнительныеПараметры.Вставить("ИмяПроцедуры", "ЗаписатьВЖурналФискальныхОпераций");
		ДополнительныеПараметры.Вставить("РезультатОперации", ИзмененныеДанныеЗаписаны);
		
		Если Не ТребуетсяПовторнаяПопыткаЗаписи Тогда
			ОшибкаПриПроведенииЧекаВопросЗавершение(КодВозвратаДиалога.Отмена, ДополнительныеПараметры);
			Возврат;
		КонецЕсли;
		
		ПоказатьВопрос(
			Новый ОписаниеОповещения("ОшибкаПриПроведенииЧекаВопросЗавершение", ЭтотОбъект, ДополнительныеПараметры),
			ДополнительныеПараметры.ТекстСообщения,
			РежимДиалогаВопрос.ПовторитьОтмена, 10, КодВозвратаДиалога.Повторить,,КодВозвратаДиалога.Повторить);
		Возврат;
		
	Иначе
		
		ВыполнитьОбработкуОповещения(
			ОповещениеПриЗавершении,
			Новый Структура("ВыполненаОперацияНаУстройстве, ИзмененныеДанныеЗаписаны",
				Истина, Истина));
		
	КонецЕсли;
	
КонецПроцедуры

#Область РаботаСоСканеромШтрихкода

Функция ПреобразоватьДанныеСоСканераВМассив(Параметр) Экспорт
	
	МенеджерОборудованияУТКлиент.ОбработатьСобытие();
	
	Данные = Новый Массив;
	Данные.Добавить(ПреобразоватьДанныеСоСканераВСтруктуру(Параметр));
	
	Возврат Данные;
	
КонецФункции

Функция ПреобразоватьДанныеСоСканераВСтруктуру(Параметр) Экспорт
	
	МенеджерОборудованияУТКлиент.ОбработатьСобытие();
	
	Если Параметр[1] = Неопределено Тогда
		Данные = Новый Структура("Штрихкод, Количество", Параметр[0], 1); 	 // Достаем штрихкод из основных данных
	Иначе
		Данные = Новый Структура("Штрихкод, Количество", Параметр[1][1], 1); // Достаем штрихкод из дополнительных данных
	КонецЕсли;
	
	Возврат Данные;
	
КонецФункции

#КонецОбласти

#КонецОбласти
