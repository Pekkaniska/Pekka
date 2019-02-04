
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	// Возврат при получении формы для анализа.
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазыУТ.ПроверитьВозможностьОткрытияФормы(
		Метаданные.РегистрыСведений.РеестрДокументов.ПолноеИмя());
	
	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(Параметры.КлючНазначенияИспользования) Тогда
		КлючНазначенияИспользования = КлючНазначенияФормыПоУмолчанию();
		КлючНастроек                = "";
	Иначе
		КлючНазначенияИспользования = Параметры.КлючНазначенияИспользования;
		КлючНастроек                = Параметры.КлючНазначенияИспользования;
	КонецЕсли;
	
	НавигационнаяСсылка = "e1cib/app/Обработка.ЖурналДокументовИнтеркампани";
	
	ИспользуетсяОграничениеПоОрганизации = УправлениеДоступомСлужебный.ЕстьОграничениеТаблицыПоВидуДоступа(
		"РегистрСведений.РеестрДокументов", "Организации", "ГруппыПартнеров,Организации,Подразделения,Склады");
	
	ВосстановитьНастройки(Параметры);
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПриСозданииНаСервереСписокДокументов(СписокОформлено);
	
	Если Не ПроверкаКонтрагентовВызовСервера.ИспользованиеПроверкиВозможно() Тогда
		Элементы.ЕстьОшибкиПроверкиКонтрагентов.Видимость = Ложь;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ПараметрыПриСозданииНаСервере = ОбменСКонтрагентами.ПараметрыПриСозданииНаСервере_ФормаСписка();
	ПараметрыПриСозданииНаСервере.Форма = ЭтотОбъект;
	ПараметрыПриСозданииНаСервере.МестоРазмещенияКоманд = Элементы.ПодменюЭДО;
	ОбменСКонтрагентами.ПриСозданииНаСервере_ФормаСписка(ПараметрыПриСозданииНаСервере);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаГлобальныеКоманды);
	// Конец ИнтеграцияС1СДокументооборотом
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	ЗаполнитьРеквизитыФормыПриСоздании();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	СписокТипов = Новый Массив;
	Для каждого ОписаниеОперации Из ХозяйственныеОперацииИДокументы Цикл
		СписокТипов.Добавить(Тип("ДокументСсылка." + СтрРазделить(ОписаниеОперации.ПолноеИмяДокумента, ".")[1]));
	КонецЦикла;
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.Источники = Новый ОписаниеТипов(СписокТипов);
	ПараметрыРазмещения.КоманднаяПанель = Элементы.СписокОформленоКоманднаяПанель;
	
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ОбменСКонтрагентамиКлиент.ПриОткрытии(ЭтотОбъект);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтаФорма, "СканерШтрихкода");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если Не ЗавершениеРаботы Тогда
		СохранитьНастройки();
	КонецЕсли;
	
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование"
		И ВводДоступен() Тогда
		
		Если ИмяСобытия = "ScanData"
			И МенеджерОборудованияУТКлиент.ЕстьНеобработанноеСобытие() Тогда
			
			ОбработатьШтрихкоды(МенеджерОборудованияУТКлиент.ПреобразоватьДанныеСоСканераВСтруктуру(Параметр));
			
		КонецЕсли;
		
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ПараметрыОповещенияЭДО = ОбменСКонтрагентамиКлиент.ПараметрыОповещенияЭДО_ФормаСписка();
	ПараметрыОповещенияЭДО.Форма = ЭтотОбъект;
	ПараметрыОповещенияЭДО.ИмяДинамическогоСписка = "СписокОформлено";
	ОбменСКонтрагентамиКлиент.ОбработкаОповещения_ФормаСписка(ИмяСобытия, Параметр, Источник, ПараметрыОповещенияЭДО);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
	Если ИмяСобытия = "Запись_ВозвратТоваровМеждуОрганизациями"
		Или ИмяСобытия = "Запись_ОтчетПоКомиссииМеждуОрганизациями"
		Или ИмяСобытия = "Запись_ОтчетПоКомиссииМеждуОрганизациямиОСписании"
		Или ИмяСобытия = "Запись_ПередачаТоваровМеждуОрганизациями" Тогда
		
		Элементы.СписокОформлено.Обновить();
		
		ОбновитьГиперссылкуКОформлению();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура СкладПриИзменении(Элемент)
	
	СкладПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ИнформационнаяНадписьОтборОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки,
		СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("КлючНастроек", КлючНазначенияИспользования);
	ПараметрыФормы.Вставить("КлючФормы",    КлючНазначенияФормыПоУмолчанию());
	ПараметрыФормы.Вставить("ДоступныеХозяйственныеОперацииИДокументы",
		ПоместитьВоВременноеХранилищеХозяйственныеОперацииИДокументы());
	
	ОповещениеФормы = Новый ОписаниеОповещения("УстановитьОтборыПоХозОперациямИДокументам", ЭтотОбъект);
	
	ОткрытьФорму("Справочник.НастройкиХозяйственныхОпераций.Форма.ФормаУстановкиОтбора", ПараметрыФормы, , , , ,
		ОповещениеФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборыПоХозОперациямИДокументам(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт
	
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Строка") Тогда
		СтандартнаяОбработка = Ложь;
		АдресДоступныхХозяйственныхОперацийИДокументов = ВыбранноеЗначение;
		
		ОтборОперацияТипОбработкаВыбораСервер(АдресДоступныхХозяйственныхОперацийИДокументов);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КОформлениюОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	ИмяКлючевойоперации = 
		"Обработка.ЖурналДокументовИнтеркампани.ФормаСписка.Команда.КОформлениюОбработкаНавигационнойСсылки."
		+ НавигационнаяСсылкаФорматированнойСтроки;
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, ИмяКлючевойоперации);
	
	СтандартнаяОбработка = Ложь;
	
	ПользовательскиеНастройки = Новый ПользовательскиеНастройкиКомпоновкиДанных;
	
	ОтборыФормыСписка = Новый Структура;
	ОтборыФормыСписка.Вставить("Организация", Организация);
	ОтборыФормыСписка.Вставить("Склад",       Склад);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("КлючНазначенияФормы", КлючНазначенияФормыПоУмолчанию());
	ПараметрыФормы.Вставить("ОтборыФормыСписка",   ОтборыФормыСписка);
	
	Если СтрНайти(НавигационнаяСсылкаФорматированнойСтроки, "РабочееМестоПередачиВыкуп") > 0 Тогда
		ПараметрУникальности = КлючНазначенияФормыПоУмолчанию();
	Иначе
		ПараметрУникальности = Ложь;
	КонецЕсли;
	
	ОткрытьФорму(НавигационнаяСсылкаФорматированнойСтроки, ПараметрыФормы, , ПараметрУникальности);
	
КонецПроцедуры

&НаКлиенте
Процедура СмТакжеВРаботеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОткрытьФорму(НавигационнаяСсылкаФорматированнойСтроки);
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиКомандФормы

#Область КнопкаСоздать

&НаКлиенте
Процедура Подключаемый_СоздатьДокумент(Команда)
	
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("Организация", Организация);
	СтруктураОтбора.Вставить("Склад",       Склад);
	
	ОбщегоНазначенияУТКлиент.СоздатьДокументЧерезКоманду(Команда.Имя, СтруктураОтбора);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СоздатьДокументЧерезФормуВыбора(Команда)
	
	КлючФормы = КлючНазначенияФормыПоУмолчанию();
	АдресХозяйственныеОперацииИДокументы = ПоместитьВоВременноеХранилищеХозяйственныеОперацииИДокументы();
	
	ОбщегоНазначенияУТКлиент.СоздатьДокументЧерезФормуВыбора(АдресХозяйственныеОперацииИДокументы, КлючФормы,
		КлючНазначенияИспользования, Склад);
	
КонецПроцедуры

#КонецОбласти

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.СписокОформлено);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.СписокОформлено, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.СписокОформлено);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// ЭлектронноеВзаимодействие.ОбменСКонтрагентами

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуЭДО(Команда)
	
	ЭлектронноеВзаимодействиеКлиент.ВыполнитьПодключаемуюКомандуЭДО(Команда, ЭтаФорма, Элементы.СписокОформлено);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработчикОжиданияЭДО()
	
	ОбменСКонтрагентамиКлиент.ОбработчикОжиданияЭДО(ЭтотОбъект);
	
КонецПроцедуры

// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами

&НаКлиенте
Процедура УстановитьИнтервал(Команда)
	
	Оповещение = Новый ОписаниеОповещения("УстановитьИнтервалЗавершение", ЭтотОбъект);
	
	ОбщегоНазначенияУтКлиент.РедактироватьПериод(Период, Неопределено, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИнтервалЗавершение(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт
	
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Период = ВыбранноеЗначение;
	
	УстановитьОтборПоПериоду();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокСкопировать(Команда)
	
	ОбщегоНазначенияУТКлиент.СкопироватьЭлемент(Элементы.СписокОформлено);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПровести(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиДокументы(Элементы.СписокОформлено, Заголовок);
	ОбновитьГиперссылкуКОформлению();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокОтменаПроведения(Команда)
	
	ОбщегоНазначенияУТКлиент.ОтменаПроведения(Элементы.СписокОформлено, Заголовок);
	ОбновитьГиперссылкуКОформлению();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокУстановитьСнятьПометкуУдаления(Команда)
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения("УстановитьПометкуУдаленияЗавершение", ЭтотОбъект);
	
	ОбщегоНазначенияУТКлиент.УстановитьПометкуУдаления(Элементы.СписокОформлено, Заголовок, ОповещениеОЗавершении);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПометкуУдаленияЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ОбновитьГиперссылкуКОформлению();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма,
		Элементы.СписокОформлено);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокОформлено

&НаКлиенте
Процедура СписокОформленоВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОбщегоНазначенияУТКлиент.ИзменитьЭлемент(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокОформленоПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
	Если Элементы.ГруппаСоздатьГенерируемая.ПодчиненныеЭлементы.Количество() <> 0 Тогда
		
		Если Копирование Тогда
			
			ОбщегоНазначенияУТКлиент.СкопироватьЭлемент(Элемент);
			
		ИначеЕсли ОтборТипыДокументов.Количество() = 1
			И ОтборХозяйственныеОперации.Количество() = 1 Тогда
			
			СтруктураКоманды = Новый Структура("Имя", Элементы.ГруппаСоздатьГенерируемая.ПодчиненныеЭлементы[0].Имя);
			Подключаемый_СоздатьДокумент(СтруктураКоманды);
			
		Иначе
			
			Подключаемый_СоздатьДокументЧерезФормуВыбора(Неопределено);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокОформленоПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	ОбщегоНазначенияУТКлиент.ИзменитьЭлемент(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокОформленоПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
	ОбщегоНазначенияУТКлиент.УстановитьПометкуУдаления(Элемент, Заголовок);
	ОбновитьГиперссылкуКОформлению();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокОформленоПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "СписокОформлено.Дата",
		"СписокОформленоДата");
	
	ОбщегоНазначенияУТ.УстановитьУсловноеОфорлениеПоляСКлючемРеестраДокументов(ЭтотОбъект,
		Элементы.СписокОформленоКонтрагент.Имя,
		"СписокОформлено.Контрагент");
		
	ОбщегоНазначенияУТ.УстановитьУсловноеОфорлениеПоляСКлючемРеестраДокументов(ЭтотОбъект,
		Элементы.СписокОформленоСклад.Имя,
		"СписокОформлено.Склад");
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция КлючНазначенияФормыПоУмолчанию()
	
	Возврат "ДокументыИнтеркампани";
	
КонецФункции

&НаСервере
Процедура ВосстановитьНастройки(Параметры)
	
	Если Параметры.Свойство("СтруктураБыстрогоОтбора") Тогда
		
		ФормаОткрытаПоГиперссылке = Истина;
		ОтборыФормыСписка = Параметры.СтруктураБыстрогоОтбора;
		
		Организация = ОтборыФормыСписка.Организация;
		Склад       = ОтборыФормыСписка.Склад;
		
	Иначе
		
		ФормаОткрытаПоГиперссылке = Ложь;
		
		КлючОбъекта = "Обработка.ЖурналДокументовИнтеркампани.Форма.ФормаСписка";
		Настройки   = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(КлючОбъекта, КлючНазначенияИспользования);
		
		Если Настройки <> Неопределено Тогда
			
			Организация = Настройки.Организация;
			Склад       = Настройки.Склад;
			Период      = Настройки.Период;
			
			ОтборТипыДокументов        = Настройки.ОтборТипыДокументов;
			ОтборХозяйственныеОперации = Настройки.ОтборХозяйственныеОперации;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыФормыПриСоздании()
	
	ТаблицаЗначенийДоступно = Обработки.ЖурналДокументовИнтеркампани.ИнициализироватьХозяйственныеОперацииИДокументы(ОтборХозяйственныеОперации,
		ОтборТипыДокументов, КлючНастроек);
	
	ХозяйственныеОперацииИДокументы.Загрузить(ТаблицаЗначенийДоступно);
	
	НастроитьФормуПоВыбраннымОперациямИДокументам(ТаблицаЗначенийДоступно);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьФормуПоВыбраннымОперациямИДокументам(ТЗХозяйственныеОперацииИДокументы)
	
	КлючНазначенияФормы = КлючНазначенияФормыПоУмолчанию();
	ЗаголовокФормы      = НСтр("ru = 'Документы между организациями (все)'");
	
	ДанныеРабочегоМеста = ОбщегоНазначенияУТ.ДанныеРабочегоМеста(ТЗХозяйственныеОперацииИДокументы, КлючНазначенияФормы,
		ЗаголовокФормы);
	
	Заголовок = ДанныеРабочегоМеста.ЗаголовокРабочегоМеста;
	
	УстановитьОтборыДинамическогоСписка();
	УстановитьВидимостьДоступность();
	
	ОбщегоНазначенияУТ.СформироватьНадписьОтбор(ИнформационнаяНадписьОтбор, ХозяйственныеОперацииИДокументы,
		ОтборТипыДокументов, ОтборХозяйственныеОперации);
	
	НастроитьКнопкиУправленияДокументами();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборыДинамическогоСписка()
	
	ОтборСклады = СкладыСервер.СписокПодчиненныхСкладов(Склад);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокОформлено, "ТипСсылки",
		ОтборТипыДокументов, ВидСравненияКомпоновкиДанных.ВСписке, Неопределено, Истина);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокОформлено, "ХозяйственнаяОперация",
		ОтборХозяйственныеОперации, ВидСравненияКомпоновкиДанных.ВСписке, Неопределено, Истина);
	
	УстановитьОтборПоОрганизации();
	УстановитьОтборПоСкладу();
	УстановитьОтборПоПериоду();
	
	ОбновитьГиперссылкуКОформлению();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоОрганизации()
	
	Если Не ИспользуетсяОграничениеПоОрганизации Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокОформлено, "ДополнительнаяЗапись",
			Ложь, ВидСравненияКомпоновкиДанных.Равно, Неопределено, Не ЗначениеЗаполнено(Организация));
	КонецЕсли;
	
	СписокОрганизаций = Новый СписокЗначений;
	СписокОрганизаций.Добавить(Организация);
	
	Если ЗначениеЗаполнено(Организация)
		И ПолучитьФункциональнуюОпцию("ИспользоватьОбособленныеПодразделенияВыделенныеНаБаланс") Тогда
		
		Запрос = Новый Запрос;
		запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Организации.Ссылка
		|ИЗ
		|	Справочник.Организации КАК Организации
		|ГДЕ
		|	Организации.ОбособленноеПодразделение
		|	И Организации.ГоловнаяОрганизация = &Организация
		|	И Организации.ДопускаютсяВзаиморасчетыЧерезГоловнуюОрганизацию";
		
		Запрос.УстановитьПараметр("Организация", Организация);
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
			СписокОрганизаций.Добавить(Выборка.Ссылка);
		КонецЦикла;
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокОформлено, "Организация",
		СписокОрганизаций, ВидСравненияКомпоновкиДанных.ВСписке, Неопределено, ЗначениеЗаполнено(Организация));
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоСкладу()
	
	ОтборСклады = СкладыСервер.СписокПодчиненныхСкладов(Склад);
	ОбщегоНазначенияУТ.УстановитьОтборИзмерениюСКлючами(СписокОформлено, "Склад", ОтборСклады);
		
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоПериоду()
	
	КонецПериода = ?(ЗначениеЗаполнено(Период.ДатаОкончания), Период.ДатаОкончания, Дата(2999, 12, 31));
	
	Если Период.ДатаНачала > КонецПериода Тогда
		ВызватьИсключение НСтр("ru = 'Дата начала периода не может быть больше даты окончания периода'");
	КонецЕсли;
	
	СписокОформлено.Параметры.УстановитьЗначениеПараметра("НачалоПериода", Период.ДатаНачала);
	СписокОформлено.Параметры.УстановитьЗначениеПараметра("КонецПериода",  Период.ДатаОкончания);
	
КонецПроцедуры

&НаСервере
Функция ОбновитьГиперссылкуКОформлению()
	
	ТЗХозяйственныеОперацииИДокументы = ХозяйственныеОперацииИДокументы.Выгрузить();
	
	ПараметрыФормирования = Новый Структура;
	ПараметрыФормирования.Вставить("Организация",          Организация);
	ПараметрыФормирования.Вставить("Склад",                Склад);
	ПараметрыФормирования.Вставить("ЭтоРасчетГиперссылки", Истина);                                    
	ПараметрыФормирования.Вставить("КлючНазначенияИспользования", КлючНазначенияФормыПоУмолчанию());
	
	КОформлению = ОбщегоНазначенияУТ.СформироватьГиперссылкуКОформлению(ТЗХозяйственныеОперацииИДокументы,
		ПараметрыФормирования);
	
	Элементы.КОформлению.Видимость = ЗначениеЗаполнено(КОформлению);
	
	МассивМенеджеровРасчетаСмТакжеВРаботе = Новый Массив();
	МассивМенеджеровРасчетаСмТакжеВРаботе.Добавить("Обработка.ФормированиеПередачТоваровМеждуОрганизациямиИВыкупов");
	
	СмТакжеВРаботе = ОбщегоНазначенияУТ.СформироватьГиперссылкуСмТакжеВРаботе(МассивМенеджеровРасчетаСмТакжеВРаботе, ПараметрыФормирования);
	Элементы.СмТакжеВРаботе.Видимость = ЗначениеЗаполнено(СмТакжеВРаботе);
	
КонецФункции

&НаСервере
Процедура ОрганизацияПриИзмененииСервер()
	
	УстановитьОтборПоОрганизации();
	ОбновитьГиперссылкуКОформлению();

КонецПроцедуры

&НаСервере
Процедура СкладПриИзмененииСервер()
	
	УстановитьОтборПоСкладу();
	ОбновитьГиперссылкуКОформлению();

КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьДоступность()
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") Тогда
		Элементы.Организация.Видимость                = Ложь;
		Элементы.СписокОформленоОрганизация.Видимость = Ложь;
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоСкладов") Тогда
		Элементы.Склад.Видимость = Ложь;
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВалют") Тогда
		Элементы.СписокОформленоВалюта.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.СписокОформленоДоговор.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьДоговорыМеждуОрганизациями");
	Элементы.СписокОформленоКонтрагент.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровИКонтрагентов");
	
КонецПроцедуры

&НаСервере
Процедура НастроитьКнопкиУправленияДокументами()
	
	СтруктураПараметров = ОбщегоНазначенияУТ.СтруктураПараметровНастройкиКнопокУправленияДокументами();
	СтруктураПараметров.Форма                                             = ЭтаФорма;
	СтруктураПараметров.ИмяКнопкиСкопировать                              = "СписокСкопировать";
	СтруктураПараметров.ИмяКнопкиСкопироватьКонтекстноеМеню               = "СписокСкопировать1";
	СтруктураПараметров.ИмяКнопкиИзменить                                 = "СписокИзменить";
	СтруктураПараметров.ИмяКнопкиИзменитьКонтекстноеМеню                  = "СписокИзменить1";
	СтруктураПараметров.ИмяКнопкиПровести                                 = "СписокПровести";
	СтруктураПараметров.ИмяКнопкиПровестиКонтекстноеМеню                  = "СписокПровести1";
	СтруктураПараметров.ИмяКнопкиОтменаПроведения                         = "СписокОтменаПроведения";
	СтруктураПараметров.ИмяКнопкиОтменаПроведенияКонтекстноеМеню          = "СписокОтменаПроведения1";
	СтруктураПараметров.ИмяКнопкиУстановитьПометкуУдаления                = "СписокУстановитьПометкуУдаления";
	СтруктураПараметров.ИмяКнопкиУстановитьПометкуУдаленияКонтекстноеМеню = "СписокУстановитьПометкуУдаления1";
	
	ОбщегоНазначенияУТ.НастроитьКнопкиУправленияДокументами(СтруктураПараметров);
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройки()
	
	Если ФормаОткрытаПоГиперссылке Тогда
		Возврат;
	КонецЕсли;
	
	КлючОбъекта = "Обработка.ЖурналДокументовИнтеркампани.Форма.ФормаСписка";
	ИменаСохраняемыхРеквизитов = "Организация,Склад,Период,ОтборХозяйственныеОперации,ОтборТипыДокументов";
	
	Настройки = Новый Структура(ИменаСохраняемыхРеквизитов);
	ЗаполнитьЗначенияСвойств(Настройки, ЭтаФорма);
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(КлючОбъекта, КлючНазначенияИспользования, Настройки);
	
КонецПроцедуры

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Процедура ОбработатьШтрихкоды(Данные)
	
	ТекстСостояния = НСтр("ru = 'Выполняется поиск документа по штрихкоду...'");
	Состояние(ТекстСостояния);
	
	ДанныеПоШтрихКоду = ДанныеПоШтрихКодуПечатнойФормы(Данные.Штрихкод);
	ОбщегоНазначенияУТКлиент.ОбработатьШтрихкоды(Данные.Штрихкод, ДанныеПоШтрихКоду, ЭтаФорма, "СписокОформлено");
	
КонецПроцедуры

&НаСервере
Функция ДанныеПоШтрихКодуПечатнойФормы(Штрихкод)
	
	ТЗХозяйственныеОперацииИДокументы = ХозяйственныеОперацииИДокументы.Выгрузить();
	ДанныеПоШтрихКоду = ОбщегоНазначенияУТ.ДанныеПоШтрихКодуПечатнойФормы(Штрихкод, ТЗХозяйственныеОперацииИДокументы);
	
	Возврат ДанныеПоШтрихКоду;
	
КонецФункции

#КонецОбласти

#Область РаботаСКешируемымиЗначениями

&НаСервере
Функция ПоместитьВоВременноеХранилищеХозяйственныеОперацииИДокументы()
	
	Возврат ПоместитьВоВременноеХранилище(ХозяйственныеОперацииИДокументы.Выгрузить(), УникальныйИдентификатор);
	
КонецФункции

#КонецОбласти

&НаСервере
Процедура ОтборОперацияТипОбработкаВыбораСервер(АдресДоступныхХозяйственныхОперацийИДокументов)
	
	ТЗХозяйственныеОперацииИДокументы = ПолучитьИзВременногоХранилища(АдресДоступныхХозяйственныхОперацийИДокументов);
	ХозяйственныеОперацииИДокументы.Загрузить(ТЗХозяйственныеОперацииИДокументы);
	
	ОбщегоНазначенияУТ.ЗаполнитьОтборыПоТаблицеХозОперацийИТиповДокументов(ТЗХозяйственныеОперацииИДокументы,
		ОтборХозяйственныеОперации, ОтборТипыДокументов);
	
	НастроитьФормуПоВыбраннымОперациямИДокументам(ТЗХозяйственныеОперацииИДокументы);
	
КонецПроцедуры
#КонецОбласти
