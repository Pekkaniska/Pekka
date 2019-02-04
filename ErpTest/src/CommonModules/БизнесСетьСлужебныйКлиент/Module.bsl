////////////////////////////////////////////////////////////////////////////////
// Подсистема "Бизнес-сеть".
// ОбщийМодуль.БизнесСетьСлужебныйКлиент.
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Команда открытия формы отправки документа через 1С:Бизнес-сеть.
Процедура ОтправитьЧерезБизнесСеть(ПараметрКоманды, ПараметрыВыполненияКоманды) Экспорт
	
	Если ПараметрКоманды.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Команда не может быть выполнена для указанного объекта.'")
	КонецЕсли;
	
	Организация = Неопределено;
	Отказ = Ложь;
	ТекстОшибки = "";
	ВозможнаОтправка = БизнесСетьВызовСервера.ВозможнаОтправкаДокумента(ПараметрКоманды, Организация, ТекстОшибки, Отказ);
	Если Отказ Тогда
		ПоказатьПредупреждение(, ТекстОшибки);
		Возврат;
	ИначеЕсли ВозможнаОтправка = Ложь Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура("МассивСсылокНаОбъект", ПараметрКоманды);
	ОчиститьСообщения();
	ОткрытьФорму("Обработка.БизнесСеть.Форма.ОтправкаДокумента", ПараметрыОткрытия, ЭтотОбъект);
	
КонецПроцедуры

// Команда загрузки документа через сервис Бизнес-сеть.
//
Процедура ЗагрузитьЧерезБизнесСеть(ПараметрКоманды, ПараметрыВыполненияКоманды) Экспорт
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("РежимЗагрузкиДокументов", Истина);
	ОчиститьСообщения();
	ОткрытьФорму("Обработка.БизнесСеть.Форма.ДокументыОбмена", ПараметрыОткрытия, ЭтотОбъект);
	
КонецПроцедуры

// Открытие формы профиля участника 1С:Бизнес-сеть.
//
// Параметры:
//   ПараметрыОткрытия - СправочникСсылка, Структура - ссылка на организацию или контрагента
//     или параметры структуры открытия, см. БизнесСетьКлиентСервер.ОписаниеИдентификацииОрганизацииКонтрагентов:
//     * Ссылка - СправочникСсылка - ссылка на организацию или контрагента.
//     * ИНН - Строка - ИНН.
//     * КПП - Строка - КПП.
//     * ЭтоОрганизация - Булево - признак, что участник является организацией.
//     * ЭтоКонтрагент - Булево - признак, что участник является контрагентом.
//
Процедура ОткрытьПрофильУчастника(Знач ПараметрыОткрытия) Экспорт
	
	Отказ = Ложь;
	
	Если ТипЗнч(ПараметрыОткрытия) <> Тип("Структура") Тогда
		// Если открываем по ссылке, преобразуем в структуру.
		Ссылка = ПараметрыОткрытия;
		ПараметрыОткрытия = БизнесСетьКлиентСервер.ОписаниеИдентификацииОрганизацииКонтрагентов();
		ПараметрыОткрытия.Ссылка = Ссылка;
	КонецЕсли;
	
	// Проверка регистрации участника.
	Результат = БизнесСетьВызовСервера.ПолучитьРеквизитыУчастника(ПараметрыОткрытия, Отказ, Истина);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Результат) Тогда
		Если ЗначениеЗаполнено(ПараметрыОткрытия.Ссылка) Тогда
			Если ПараметрыОткрытия.ЭтоОрганизация Тогда
				ТекстВопроса = НСтр("ru='Организация ""%1"" не зарегистрирована в сервисе 1С:Бизнес-сеть. Зарегистрировать сейчас?'");
				ТекстВопроса = СтрШаблон(ТекстВопроса, ПараметрыОткрытия.Ссылка);
				ОписаниеОповещения = Новый ОписаниеОповещения("ЗарегистрироватьОрганизациюПослеВопроса", ЭтотОбъект, ПараметрыОткрытия.Ссылка);
				ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
			ИначеЕсли ПараметрыОткрытия.ЭтоКонтрагент Тогда
				ТекстВопроса = НСтр("ru='Контрагент ""%1"" не зарегистрирован в сервисе 1С:Бизнес-сеть.
					|Направить приглашение для регистрации?'");
				ТекстВопроса = СтрШаблон(ТекстВопроса, ПараметрыОткрытия.Ссылка);
				ПараметрыОповещения = Новый Структура("Контрагент", ПараметрыОткрытия.Ссылка);
				ОписаниеОповещения = Новый ОписаниеОповещения("ПодключитьКонтрагентаПослеВопроса", ЭтотОбъект, ПараметрыОповещения);
				ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
			КонецЕсли;
		Иначе
			ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Участник не зарегистрирован в сервисе 1С:Бизнес-сеть.'"));
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	// Открытие профиля участника, если уже получены реквизиты.
	ПараметрыОткрытия.Вставить("Реквизиты", Результат);
	ОткрытьФорму("Обработка.БизнесСеть.Форма.ПрофильУчастника", ПараметрыОткрытия, ЭтотОбъект);
	
КонецПроцедуры

// Асинхронная процедура.
Процедура ПодключитьКонтрагентаПослеВопроса(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	ОчиститьСообщения();
	ОткрытьФорму("Обработка.БизнесСеть.Форма.ОтправкаПриглашения", Параметры,,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

// Асинхронная процедура.
Процедура ЗарегистрироватьОрганизациюПослеВопроса(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура("Ссылка", Параметры);
	ОчиститьСообщения();
	ОткрытьФорму("Обработка.БизнесСеть.Форма.РегистрацияОрганизаций", ПараметрыОткрытия);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Загрузка электронного документа в информационную базу.
//
Процедура ЗагрузитьДокументВИБ(Контекст, Отказ, ОбновитьСтруктуруРазбора = Ложь) Экспорт
	
	ТекстСообщения = "";
	Если Контекст.Свойство("ДокументИБ") Тогда
		ДокументСсылка = Контекст.ДокументИБ;
	Иначе
		ДокументСсылка = Неопределено;
	КонецЕсли;
	
	БизнесСетьВызовСервера.СформироватьДокументИБ(Контекст, ДокументСсылка, ТекстСообщения, Истина, ОбновитьСтруктуруРазбора, Отказ);
	
	Если Отказ ИЛИ Не ЗначениеЗаполнено(ДокументСсылка) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
		
	ТекстОповещения	= НСтр("ru = 'Загрузка выполнена.'");
	ТекстПояснения	= НСтр("ru = 'Загружен документ через сервис 1С:Бизнес-сеть.'");
	ПоказатьОповещениеПользователя(ТекстОповещения, ПолучитьНавигационнуюСсылку(ДокументСсылка), ТекстПояснения, БиблиотекаКартинок.БизнесСеть);
	
	МассивОповещения = Новый Массив;
	МассивОповещения.Добавить(ДокументСсылка);
	Оповестить("ОбновитьДокументИБПослеЗаполнения", МассивОповещения);
	
	// Открыть форму документ из формы просмотра, если он новый.
	Если НЕ ЗначениеЗаполнено(Контекст.ДокументИБ) Тогда
		ПоказатьЗначение(Неопределено, ДокументСсылка);
	КонецЕсли;
	
	Контекст.ДокументИБ = ДокументСсылка;
	ОповеститьОбИзменении(ДокументСсылка);
	Оповестить("ОбновитьСписокВходящихДокументов1СБизнесСеть");
	
КонецПроцедуры

#КонецОбласти
