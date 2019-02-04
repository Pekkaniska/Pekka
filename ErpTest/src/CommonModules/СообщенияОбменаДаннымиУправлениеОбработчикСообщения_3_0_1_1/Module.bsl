////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИК КАНАЛОВ СООБЩЕНИЙ ДЛЯ ВЕРСИИ 3.0.1.1 ИНТЕРФЕЙСА СООБЩЕНИЙ
//  УПРАВЛЕНИЯ ОБМЕНА ДАННЫМИ
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает пространство имен версии интерфейса сообщений.
//
Функция Пакет() Экспорт
	
	Возврат "http://www.1c.ru/SaaS/Exchange/Manage/3.0.1.1";
	
КонецФункции

// Возвращает версию интерфейса сообщений, обслуживаемую обработчиком.
//
Функция Версия() Экспорт
	
	Возврат "3.0.1.1";
	
КонецФункции

// Возвращает базовый тип для сообщений версии.
//
Функция БазовыйТип() Экспорт
	
	Возврат СообщенияВМоделиСервисаПовтИсп.ТипТело();
	
КонецФункции

// Выполняет обработку входящих сообщений модели сервиса
//
// Параметры:
//  Сообщение - ОбъектXDTO, входящее сообщение,
//  Отправитель - ПланОбменаСсылка.ОбменСообщениями, узел плана обмена, соответствующий отправителю сообщения
//  СообщениеОбработано - булево, флаг успешной обработки сообщения. Значение данного параметра необходимо
//    установить равным Истина в том случае, если сообщение было успешно прочитано в данном обработчике.
//
Процедура ОбработатьСообщениеМоделиСервиса(Знач Сообщение, Знач Отправитель, СообщениеОбработано) Экспорт
	
	СообщениеОбработано = Истина;
	
	Словарь = СообщенияОбменаДаннымиУправлениеИнтерфейс;
	ТипСообщения = Сообщение.Body.Тип();
	
	Если ТипСообщения = Словарь.СообщениеНастроитьОбменШаг1(Пакет()) Тогда
		
		НастроитьОбменШаг1(Сообщение, Отправитель);
		
	ИначеЕсли ТипСообщения = Словарь.СообщениеЗагрузитьСообщениеОбмена(Пакет()) Тогда
		
		ЗагрузитьСообщениеОбмена(Сообщение, Отправитель);
		
	ИначеЕсли ТипСообщения = Словарь.СообщениеПолучитьДанныеКорреспондента(Пакет()) Тогда
		
		ПолучитьДанныеКорреспондента(Сообщение, Отправитель);
		
	ИначеЕсли ТипСообщения = Словарь.СообщениеПолучитьОбщиеДанныеУзловКорреспондента(Пакет()) Тогда
		
		ПолучитьОбщиеДанныеУзловКорреспондента(Сообщение, Отправитель);
		
	ИначеЕсли ТипСообщения = Словарь.СообщениеПолучитьПараметрыУчетаКорреспондента(Пакет()) Тогда
		
		ПолучитьПараметрыУчетаКорреспондента(Сообщение, Отправитель);
		
	Иначе
		
		СообщениеОбработано = Ложь;
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура НастроитьОбменШаг1(Сообщение, Отправитель) Экспорт
	
	Тело = Сообщение.Body;
	
	КодЭтогоУзла = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПланыОбмена[Тело.ExchangePlan].ЭтотУзел(), "Код");
	ПсевдонимЭтогоУзла = "";
	
	Если Не ПустаяСтрока(КодЭтогоУзла) И КодЭтогоУзла <> Тело.Code Тогда
		ПсевдонимЭтогоУзла = ОбменДаннымиВМоделиСервиса.КодУзлаПланаОбменаВСервисе(РаботаВМоделиСервиса.ЗначениеРазделителяСеанса());
	
		Если ПсевдонимЭтогоУзла <> Тело.Code Тогда
			СтрокаСообщения = НСтр("ru = 'Ожидаемый код предопределенного узла в этом приложении ""%1"" не соответствует фактическому ""%2"" или псевдониму ""%3"". План обмена: %4'");
			СтрокаСообщения = СтрШаблон(СтрокаСообщения, Тело.Code, КодЭтогоУзла, ПсевдонимЭтогоУзла, Тело.ExchangePlan);
			ВызватьИсключение СтрокаСообщения;
		КонецЕсли;
	КонецЕсли;
	
	КонечнаяТочкаКорреспондента = ПланыОбмена.ОбменСообщениями.НайтиПоКоду(Тело.EndPoint);
	
	Если КонечнаяТочкаКорреспондента.Пустая() Тогда
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Не найдена конечная точка корреспондента с кодом ""%1"".'"),
			Тело.EndPoint);
	КонецЕсли;
	
	Префикс = "";
	ПрефиксКорреспондента = "";
	ИдентификаторНастройки = "";
	
	Если Сообщение.Установлено("AdditionalInfo") Тогда
		ДополнительныеСвойства = СериализаторXDTO.ПрочитатьXDTO(Сообщение.AdditionalInfo);
		Если ДополнительныеСвойства.Свойство("Префикс") Тогда
			Префикс = ДополнительныеСвойства.Префикс;
		КонецЕсли;
		Если ДополнительныеСвойства.Свойство("ПрефиксКорреспондента") Тогда
			ПрефиксКорреспондента = ДополнительныеСвойства.ПрефиксКорреспондента;
		КонецЕсли;
		Если ДополнительныеСвойства.Свойство("ИдентификаторНастройки") Тогда
			ИдентификаторНастройки = ДополнительныеСвойства.ИдентификаторНастройки;
		КонецЕсли;
	КонецЕсли;
	
	НастройкиXDTOКорреспондента = Новый Структура;
	
	НастройкиОтбора = СериализаторXDTO.ПрочитатьXDTO(Тело.FilterSettings);
	Если НастройкиОтбора.Свойство("НастройкиXDTOКорреспондента") Тогда
		НастройкиXDTOКорреспондента = НастройкиОтбора.НастройкиXDTOКорреспондента;
	КонецЕсли;
	
	// Создаем настройку обмена.
	НастройкиПодключения = Новый Структура;
	НастройкиПодключения.Вставить("ИмяПланаОбмена", Тело.ExchangePlan);
	НастройкиПодключения.Вставить("ИдентификаторНастройки", ИдентификаторНастройки);
	
	НастройкиПодключения.Вставить("Наименование", ""); // не требуется
	НастройкиПодключения.Вставить("НаименованиеКорреспондента", Тело.CorrespondentName);
	
	НастройкиПодключения.Вставить("Префикс",               Префикс);
	НастройкиПодключения.Вставить("ПрефиксКорреспондента", ПрефиксКорреспондента);
	
	НастройкиПодключения.Вставить("ИдентификаторИнформационнойБазыИсточника", КодЭтогоУзла);
	НастройкиПодключения.Вставить("ИдентификаторИнформационнойБазыПриемника", Тело.CorrespondentCode);
	
	НастройкиПодключения.Вставить("КонечнаяТочкаКорреспондента", КонечнаяТочкаКорреспондента);
	
	НастройкиПодключения.Вставить("НастройкиXDTOКорреспондента", НастройкиXDTOКорреспондента);

	НастройкиПодключения.Вставить("Корреспондент"); // выходной параметр
	
	НастройкиПодключения.Вставить("ОбластьДанныхКорреспондента", Тело.CorrespondentZone);
	
	НачатьТранзакцию();
	Попытка
		ОбменДаннымиВМоделиСервиса.СоздатьНастройкуОбмена_3_0_1_1(НастройкиПодключения,
			Истина, , ПсевдонимЭтогоУзла);
			
		// Отправляем ответное сообщение об успешной операции.
		ОтветноеСообщение = СообщенияВМоделиСервиса.НовоеСообщение(
			СообщенияОбменаДаннымиКонтрольИнтерфейс.СообщениеНастройкаОбменаШаг1УспешноЗавершена());
			
		ОтветноеСообщение.Body.Zone = ОбщегоНазначения.ЗначениеРазделителяСеанса();
		ОтветноеСообщение.Body.SessionId = Тело.SessionId;
		
		ОтветноеСообщение.Body.CorrespondentZone = Тело.CorrespondentZone;
		
		СообщенияВМоделиСервиса.ОтправитьСообщение(ОтветноеСообщение, Отправитель, Истина);
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		
		ПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ЗаписьЖурналаРегистрации(ОбменДаннымиВМоделиСервиса.СобытиеЖурналаРегистрацииНастройкаСинхронизацииДанных(),
			УровеньЖурналаРегистрации.Ошибка, , , ПредставлениеОшибки);
		
		УдалитьНастройкуСинхронизации(НастройкиПодключения.Корреспондент);
		
		// Отправляем ответное сообщение об ошибке.
		НачатьТранзакцию();
		ОтветноеСообщение = СообщенияВМоделиСервиса.НовоеСообщение(
			СообщенияОбменаДаннымиКонтрольИнтерфейс.СообщениеОшибкаНастройкиОбменаШаг1());
			
		ОтветноеСообщение.Body.Zone = ОбщегоНазначения.ЗначениеРазделителяСеанса();
		ОтветноеСообщение.Body.SessionId = Тело.SessionId;		
		
		ОтветноеСообщение.Body.CorrespondentZone = Тело.CorrespondentZone;
		ОтветноеСообщение.Body.ErrorDescription = ПредставлениеОшибки;
		
		СообщенияВМоделиСервиса.ОтправитьСообщение(ОтветноеСообщение, Отправитель, Истина);
		ЗафиксироватьТранзакцию();
	КонецПопытки;
	
	СообщенияВМоделиСервиса.ДоставитьБыстрыеСообщения();
	
КонецПроцедуры

Процедура ЗагрузитьСообщениеОбмена(Сообщение, Отправитель) Экспорт
	
	СообщениеДляСопоставленияДанных = Ложь;
	
	Если Сообщение.Установлено("AdditionalInfo") Тогда
		ДополнительныеСвойства = СериализаторXDTO.ПрочитатьXDTO(Сообщение.AdditionalInfo);
		Если ДополнительныеСвойства.Свойство("СообщениеДляСопоставленияДанных") Тогда
			СообщениеДляСопоставленияДанных = ДополнительныеСвойства.СообщениеДляСопоставленияДанных;
		КонецЕсли;
	КонецЕсли;
	
	Тело = Сообщение.Body;
	
	Если Тело.Свойства().Получить("MessageForDataMatching") <> Неопределено 
		И Тело.Установлено("MessageForDataMatching") Тогда
		СообщениеДляСопоставленияДанных = Тело.MessageForDataMatching; 
	КонецЕсли;
	
	НачатьТранзакцию();
	Попытка
		Корреспондент = КорреспондентОбмена(Тело.ExchangePlan, Тело.CorrespondentCode);
		
		// Загружаем сообщение обмена
		Отказ = Ложь;
		ОбменДаннымиВМоделиСервиса.ВыполнитьЗагрузкуДанных(Отказ, Корреспондент, СообщениеДляСопоставленияДанных);
		Если Отказ Тогда
			ВызватьИсключение СтрШаблон(НСтр("ru = 'Возникли ошибки в процессе загрузки справочников от корреспондента %1.'"),
				Строка(Корреспондент));
		КонецЕсли;
		
		// Отправляем ответное сообщение об успешной операции.
		ОтветноеСообщение = СообщенияВМоделиСервиса.НовоеСообщение(
			СообщенияОбменаДаннымиКонтрольИнтерфейс.СообщениеЗагрузкаСообщенияОбменаУспешноЗавершена());
		ОтветноеСообщение.Body.Zone = ОбщегоНазначения.ЗначениеРазделителяСеанса();
		ОтветноеСообщение.Body.CorrespondentZone = Тело.CorrespondentZone;
		ОтветноеСообщение.Body.SessionId = Тело.SessionId;
		
		СообщенияВМоделиСервиса.ОтправитьСообщение(ОтветноеСообщение, Отправитель, Истина);
		ЗафиксироватьТранзакцию();
	Исключение
		
		ПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ЗаписьЖурналаРегистрации(ОбменДаннымиВМоделиСервиса.СобытиеЖурналаРегистрацииНастройкаСинхронизацииДанных(),
			УровеньЖурналаРегистрации.Ошибка,,, ПредставлениеОшибки);
		
		// Отправляем ответное сообщение об ошибке.
		ОтветноеСообщение = СообщенияВМоделиСервиса.НовоеСообщение(
			СообщенияОбменаДаннымиКонтрольИнтерфейс.СообщениеОшибкаЗагрузкиСообщенияОбмена());
		ОтветноеСообщение.Body.Zone = ОбщегоНазначения.ЗначениеРазделителяСеанса();
		ОтветноеСообщение.Body.CorrespondentZone = Тело.CorrespondentZone;
		ОтветноеСообщение.Body.SessionId = Тело.SessionId;
		
		ОтветноеСообщение.Body.ErrorDescription = ПредставлениеОшибки;
		
		НачатьТранзакцию();
		СообщенияВМоделиСервиса.ОтправитьСообщение(ОтветноеСообщение, Отправитель, Истина);
		ЗафиксироватьТранзакцию();
		
	КонецПопытки;
	
	СообщенияВМоделиСервиса.ДоставитьБыстрыеСообщения();
	
КонецПроцедуры

Процедура ПолучитьДанныеКорреспондента(Сообщение, Отправитель)
	
	Тело = Сообщение.Body;
	
	НачатьТранзакцию();
	Попытка
		
		ДанныеКорреспондента = ОбменДаннымиСервер.ДанныеТаблицКорреспондента(
			СериализаторXDTO.ПрочитатьXDTO(Тело.Tables), Тело.ExchangePlan);
		
		// Отправляем ответное сообщение об успешной операции
		ОтветноеСообщение = СообщенияВМоделиСервиса.НовоеСообщение(
			СообщенияОбменаДаннымиКонтрольИнтерфейс.СообщениеПолучениеДанныхКорреспондентаУспешноЗавершено());
		ОтветноеСообщение.Body.Zone = ОбщегоНазначения.ЗначениеРазделителяСеанса();
		ОтветноеСообщение.Body.CorrespondentZone = Тело.CorrespondentZone;
		ОтветноеСообщение.Body.SessionId = Тело.SessionId;
		
		ОтветноеСообщение.Body.Data = Новый ХранилищеЗначения(ДанныеКорреспондента);
		СообщенияВМоделиСервиса.ОтправитьСообщение(ОтветноеСообщение, Отправитель, Истина);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		
		ПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ЗаписьЖурналаРегистрации(ОбменДаннымиВМоделиСервиса.СобытиеЖурналаРегистрацииНастройкаСинхронизацииДанных(),
			УровеньЖурналаРегистрации.Ошибка,,, ПредставлениеОшибки);
		
		// Отправляем ответное сообщение об ошибке
		ОтветноеСообщение = СообщенияВМоделиСервиса.НовоеСообщение(
			СообщенияОбменаДаннымиКонтрольИнтерфейс.СообщениеОшибкаПолученияДанныхКорреспондента());
		ОтветноеСообщение.Body.Zone = ОбщегоНазначения.ЗначениеРазделителяСеанса();
		ОтветноеСообщение.Body.CorrespondentZone = Тело.CorrespondentZone;
		ОтветноеСообщение.Body.SessionId = Тело.SessionId;
		
		ОтветноеСообщение.Body.ErrorDescription = ПредставлениеОшибки;
		
		НачатьТранзакцию();
		СообщенияВМоделиСервиса.ОтправитьСообщение(ОтветноеСообщение, Отправитель, Истина);
		ЗафиксироватьТранзакцию();
	КонецПопытки;
	
	СообщенияВМоделиСервиса.ДоставитьБыстрыеСообщения();
	
КонецПроцедуры

Процедура ПолучитьОбщиеДанныеУзловКорреспондента(Сообщение, Отправитель) Экспорт
	
	Тело = Сообщение.Body;
	
	НачатьТранзакцию();
	Попытка
		
		ДанныеКорреспондента = ОбменДаннымиСервер.ДанныеДляТабличныхЧастейУзловЭтойИнформационнойБазы(Тело.ExchangePlan);
		
		// Отправляем ответное сообщение об успешной операции.
		ОтветноеСообщение = СообщенияВМоделиСервиса.НовоеСообщение(
			СообщенияОбменаДаннымиКонтрольИнтерфейс.СообщениеПолучениеОбщихДанныхУзловКорреспондентаУспешноЗавершено());
			
		ОтветноеСообщение.Body.Zone = ОбщегоНазначения.ЗначениеРазделителяСеанса();
		ОтветноеСообщение.Body.CorrespondentZone = Тело.CorrespondentZone;
		ОтветноеСообщение.Body.SessionId = Тело.SessionId;
		
		МодульОбменДаннымиСервер = ОбщегоНазначения.ОбщийМодуль("ОбменДаннымиСервер");
		
		ПредставлениеОшибки = "";
		ПараметрыИБ = МодульОбменДаннымиСервер.ПараметрыИнформационнойБазы(Тело.ExchangePlan, "", ПредставлениеОшибки);
		
		Результат = Новый Структура;
		Результат.Вставить("ОбщиеДанныеУзлов", ДанныеКорреспондента);
		Результат.Вставить("ПараметрыИнформационнойБазы", ПараметрыИБ);
		
		ОтветноеСообщение.Body.Data = Новый ХранилищеЗначения(Результат);
		
		СообщенияВМоделиСервиса.ОтправитьСообщение(ОтветноеСообщение, Отправитель, Истина);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		
		ПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ЗаписьЖурналаРегистрации(ОбменДаннымиВМоделиСервиса.СобытиеЖурналаРегистрацииНастройкаСинхронизацииДанных(),
			УровеньЖурналаРегистрации.Ошибка,,, ПредставлениеОшибки);
		
		// Отправляем ответное сообщение об ошибке
		ОтветноеСообщение = СообщенияВМоделиСервиса.НовоеСообщение(
			СообщенияОбменаДаннымиКонтрольИнтерфейс.СообщениеОшибкаПолученияОбщихДанныхУзловКорреспондента());
		ОтветноеСообщение.Body.Zone = ОбщегоНазначения.ЗначениеРазделителяСеанса();
		ОтветноеСообщение.Body.CorrespondentZone = Тело.CorrespondentZone;
		ОтветноеСообщение.Body.SessionId = Тело.SessionId;
		
		ОтветноеСообщение.Body.ErrorDescription = ПредставлениеОшибки;
		
		НачатьТранзакцию();
		СообщенияВМоделиСервиса.ОтправитьСообщение(ОтветноеСообщение, Отправитель, Истина);
		ЗафиксироватьТранзакцию();
	КонецПопытки;
	
	СообщенияВМоделиСервиса.ДоставитьБыстрыеСообщения();
	
КонецПроцедуры

Процедура ПолучитьПараметрыУчетаКорреспондента(Сообщение, Отправитель) Экспорт
	
	Тело = Сообщение.Body;
	
	НачатьТранзакцию();
	Попытка
		
		Корреспондент = КорреспондентОбмена(Тело.ExchangePlan, Тело.CorrespondentCode);
		
		Отказ = Ложь;
		ПредставлениеОшибки = "";
		
		МодульОбменДаннымиСервер = ОбщегоНазначения.ОбщийМодуль("ОбменДаннымиСервер");
		
		ДанныеКорреспондента = Новый Структура;
		
		ПараметрыИБ = МодульОбменДаннымиСервер.ПараметрыИнформационнойБазы(Тело.ExchangePlan, Тело.CorrespondentCode, ПредставлениеОшибки);
		Отказ = Не ПараметрыИБ.НастройкиПараметровУчетаЗаданы;
		
		ДанныеКорреспондента.Вставить("ПараметрыИнформационнойБазы", ПараметрыИБ);
		
		ДанныеКорреспондента.Вставить("ПараметрыУчетаЗаданы", Не Отказ);
		ДанныеКорреспондента.Вставить("ПредставлениеОшибки",  ПредставлениеОшибки);
		
		// Отправляем ответное сообщение об успешной операции
		ОтветноеСообщение = СообщенияВМоделиСервиса.НовоеСообщение(
			СообщенияОбменаДаннымиКонтрольИнтерфейс.СообщениеПолучениеПараметровУчетаКорреспондентаУспешноЗавершено());
			
		ОтветноеСообщение.Body.Zone = ОбщегоНазначения.ЗначениеРазделителяСеанса();
		ОтветноеСообщение.Body.SessionId = Тело.SessionId;
		
		ОтветноеСообщение.Body.CorrespondentZone = Тело.CorrespondentZone;
		ОтветноеСообщение.Body.Data = Новый ХранилищеЗначения(ДанныеКорреспондента);
		
		СообщенияВМоделиСервиса.ОтправитьСообщение(ОтветноеСообщение, Отправитель, Истина);
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		
		ПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ЗаписьЖурналаРегистрации(ОбменДаннымиВМоделиСервиса.СобытиеЖурналаРегистрацииНастройкаСинхронизацииДанных(),
			УровеньЖурналаРегистрации.Ошибка,,, ПредставлениеОшибки);
		
		// Отправляем ответное сообщение об ошибке
		ОтветноеСообщение = СообщенияВМоделиСервиса.НовоеСообщение(
			СообщенияОбменаДаннымиКонтрольИнтерфейс.СообщениеОшибкаПолученияПараметровУчетаКорреспондента());
			
		ОтветноеСообщение.Body.Zone = ОбщегоНазначения.ЗначениеРазделителяСеанса();
		ОтветноеСообщение.Body.SessionId = Тело.SessionId;
		
		ОтветноеСообщение.Body.CorrespondentZone = Тело.CorrespondentZone;
		ОтветноеСообщение.Body.ErrorDescription = ПредставлениеОшибки;
		
		НачатьТранзакцию();
		СообщенияВМоделиСервиса.ОтправитьСообщение(ОтветноеСообщение, Отправитель, Истина);
		ЗафиксироватьТранзакцию();
	КонецПопытки;
	
	СообщенияВМоделиСервиса.ДоставитьБыстрыеСообщения();
	
КонецПроцедуры

Функция КорреспондентОбмена(Знач ИмяПланаОбмена, Знач Код)
	
	Результат = ПланыОбмена[ИмяПланаОбмена].НайтиПоКоду(Код);
	
	Если Не ЗначениеЗаполнено(Результат) Тогда
		СтрокаСообщения = НСтр("ru = 'Не найден узел плана обмена; имя плана обмена %1; код узла %2'");
		СтрокаСообщения = СтрШаблон(СтрокаСообщения, ИмяПланаОбмена, Код);
		ВызватьИсключение СтрокаСообщения;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

Процедура УдалитьНастройкуСинхронизации(Знач Корреспондент)
	
	Если Корреспондент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Попытка
		КорреспондентОбъект = Корреспондент.ПолучитьОбъект();
		
		Если КорреспондентОбъект <> Неопределено Тогда
			КорреспондентОбъект.Удалить();
		КонецЕсли;
	Исключение
		ЗаписьЖурналаРегистрации(ОбменДаннымиВМоделиСервиса.СобытиеЖурналаРегистрацииНастройкаСинхронизацииДанных(),
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())
		);
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти
