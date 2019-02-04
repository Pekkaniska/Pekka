#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НачальныйТекстЗапроса = Список.ТекстЗапроса;
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Элементы.ГруппаКомандПроверкаДокументов.Видимость = ПравоДоступа("Редактирование", Метаданные.РегистрыСведений.СтатусыПроверкиДокументов);
	
	ОбновитьДанныеФормы();
	
	#Область ПервоначальноеЗаполнениеПоПараметрам
	
	Если Параметры.Свойство("ЭтоДокументКорректировки") Тогда
		
		Для каждого ЭлементСпискаДокументов Из СписокТипыДокументов Цикл
			ЭлементСпискаДокументов.Пометка = ?(ЭлементСпискаДокументов.Значение = "Документ.ОперацияБух", 
				Параметры.ЭтоДокументКорректировки, Не Параметры.ЭтоДокументКорректировки);
		КонецЦикла;				
		
		УстановитьОтборПоТипуДокументов(Список, СписокТипыДокументов);
		ОбновитьПредставлениеТипДокументаОтбор(ТипДокументаОтбор, СписокТипыДокументов);
		
	КонецЕсли;
	
	УстановитьТекстЗапроса();
		
	Если Параметры.Свойство("ДатаОкончанияПериода") И Не Параметры.ДатаОкончанияПериода = '39991231' Тогда
		КонецПериода = Параметры.ДатаОкончанияПериода;
		УстановитьОтборПоПериоду(Список, НачалоПериода, КонецПериода);
	КонецЕсли;
	
	Параметры.Отбор.Свойство("Организация", Организация);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Организация", Организация, , , ЗначениеЗаполнено(Организация));
	Параметры.Отбор.Свойство("СтатусОтражения", СтатусОтражения);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "СтатусОтражения", СтатусОтражения, , , Не СтатусОтражения.Пустая());
	Параметры.Отбор.Свойство("СтатусПроверки", СтатусПроверки);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "СтатусПроверки", СтатусПроверки, , , Не СтатусПроверки.Пустая());
		
	#КонецОбласти
	
	#Область УстановкаДоступностиКомандНаОснованииПереданныхОтборов
	
	УстановитьДоступностьЭлементовПоСтатусуОтражения();
	
	Если Не Элементы.Найти("СписокПроверить") = Неопределено И Не Элементы.Найти("СписокОтменитьПроверку") = Неопределено Тогда
		Элементы.СписокПроверить.Доступность = Не ЗначениеЗаполнено(СтатусПроверки)
			ИЛИ Не СтатусПроверки = ПредопределенноеЗначение("Перечисление.ЭтапыПроверкиДокументаВРеглУчете.Проверен");
		Элементы.СписокОтменитьПроверку.Доступность = Не ЗначениеЗаполнено(СтатусПроверки)
			ИЛИ СтатусПроверки = ПредопределенноеЗначение("Перечисление.ЭтапыПроверкиДокументаВРеглУчете.Проверен");
	КонецЕсли;
		
	Если Параметры.Свойство("ЭтоДокументКорректировки") Тогда
		Элементы.СоздатьНаОсновании.Доступность = Не Параметры.ЭтоДокументКорректировки;
	КонецЕсли;
	
	#КонецОбласти
	
	Элементы.Организация.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	Элементы.СтатусПроверки.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьПроверкуДокументовПоРегламентированномуУчету");
	
	Элементы.ГруппаОтбораВерх.Объединенная = Не ПолучитьФункциональнуюОпцию("ИспользоватьПроверкуДокументовПоРегламентированномуУчету");
	Если ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") Тогда
		Элементы.СписокТипыДокументовПредставление.МаксимальнаяШирина =
			?(ПолучитьФункциональнуюОпцию("ИспользоватьПроверкуДокументовПоРегламентированномуУчету"), 77, 111);
	Иначе
		Элементы.СписокТипыДокументовПредставление.МаксимальнаяШирина =
			?(ПолучитьФункциональнуюОпцию("ИспользоватьПроверкуДокументовПоРегламентированномуУчету"), 27, 60);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ВыборОбъектовМетаданных" Тогда
		
		Если ТипЗнч(Параметр) = Тип("СписокЗначений") Тогда
			
			Для каждого ЭлементТипаДокумента Из СписокТипыДокументов Цикл
				
				ЭлементВыбранныхТиповВФормеВыбора = Параметр.НайтиПоЗначению(ЭлементТипаДокумента.Значение);
				
				ЭлементТипаДокумента.Пометка = Не ЭлементВыбранныхТиповВФормеВыбора = Неопределено;
				
			КонецЦикла;
			
			ОбновитьПредставлениеТипДокументаОтбор(ТипДокументаОтбор, СписокТипыДокументов);
			УстановитьОтборПоТипуДокументов(Список, СписокТипыДокументов);
			УстановитьТекстЗапроса();
			Элементы.Список.Обновить();
			Элементы.СоздатьНаОсновании.Доступность = Не (Параметр.Количество() = 1 И Параметр.Получить(0).Значение = "Документ.ОперацияБух");
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_ОтражениеДокументовВРегламентированномУчете"
		ИЛИ ИмяСобытия = "Запись_СтатусПроверкиДокумента" Тогда
		
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_НаборКонстант" Тогда
		Если Источник = "ИспользоватьПроверкуДокументовПоРегламентированномуУчету"
			ИЛИ Источник = "РазрешатьИзменятьПроверенныеДокументыПоРеглУчету"
			ИЛИ Источник = "ИспользоватьРучнуюКорректировкуПроводокПоРеглУчету" Тогда
			
			ОбновитьДанныеФормы();
			
		КонецЕсли;
	КонецЕсли;
		
	Если ИмяСобытия = "РасшифровкаПоДокументам_ИзмененийУсловийОтбора" Тогда
			
		ОбновитьСтруктуруОтбораФормы(Параметр);
		Активизировать();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если Не ЗавершениеРаботы Тогда
		Оповестить("ЗакрытаФормаСпискаДокументов");
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийШапкиФормы

&НаКлиенте
Процедура ВыбратьПериод(Команда)
	ПараметрыВыбора = Новый Структура("НачалоПериода, КонецПериода", НачалоПериода, КонецПериода);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериода", ПараметрыВыбора, Элементы.ВыбратьПериод, , , , ОписаниеОповещения);
КонецПроцедуры

&НаКлиенте
Процедура СписокТипыДокументовПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура("ФильтрПоОбъектамМетаданных, ВыбранныеОбъектыМетаданных, НачальноеЗначениеВыбора");
	
	СписокТиповДокументов = Новый СписокЗначений;
	Для каждого ЭлементСпискаТипаДокументов Из СписокТипыДокументов Цикл
		СписокТиповДокументов.Добавить(ЭлементСпискаТипаДокументов.Значение);
	КонецЦикла;
	ПараметрыФормы.ФильтрПоОбъектамМетаданных = СписокТиповДокументов;
	
	СписокВыбранныхТиповДокументов = Новый СписокЗначений;
	ЭлементБезПометки = Неопределено;
	Для каждого ЭлементСпискаТипаДокументов Из СписокТипыДокументов Цикл
		Если ЭлементСпискаТипаДокументов.Пометка Тогда
			СписокВыбранныхТиповДокументов.Добавить(ЭлементСпискаТипаДокументов.Значение);
		Иначе
			ЭлементБезПометки = ЭлементСпискаТипаДокументов;
		КонецЕсли;
	КонецЦикла;
	ПараметрыФормы.ВыбранныеОбъектыМетаданных = СписокВыбранныхТиповДокументов;
	
	Если СписокВыбранныхТиповДокументов.Количество() > 10 И ЭлементБезПометки <> Неопределено Тогда
		// Спозиционируем выбор на последнем элементе который не выбран.
		ПараметрыФормы.НачальноеЗначениеВыбора = ЭлементБезПометки.Значение;
	ИначеЕсли СписокВыбранныхТиповДокументов.Количество() = 0 Тогда
		// Выбранных элементов нет вообще, поэтому спозиционируем на первом элементе всего списка.
		ПараметрыФормы.НачальноеЗначениеВыбора = СписокТиповДокументов.Получить(0).Значение;
	Иначе
		// Выбранных элементов несколько, спозиционируем выбор на первом из них.
		ПараметрыФормы.НачальноеЗначениеВыбора = СписокВыбранныхТиповДокументов.Получить(0).Значение;
	КонецЕсли;
	
	ПараметрыФормы.Вставить("Заголовок", НСтр("ru = 'Отбор по типам документов'"));
		
	ОткрытьФорму("ОбщаяФорма.ВыборОбъектовМетаданных", ПараметрыФормы, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокТипыДокументовПредставлениеОчистка(Элемент, СтандартнаяОбработка)
	ОчиститьОтборПоТипуДокументов();
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияОтборПриИзменении(Элемент)
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Организация", Организация, , , ЗначениеЗаполнено(Организация));
КонецПроцедуры

&НаКлиенте
Процедура НачалоПериодаПриИзменении(Элемент)
	УстановитьОтборПоПериоду(Список, НачалоПериода, КонецПериода);
КонецПроцедуры

&НаКлиенте
Процедура КонецПериодаПриИзменении(Элемент)
	УстановитьОтборПоПериоду(Список, НачалоПериода, КонецПериода);
КонецПроцедуры

&НаКлиенте
Процедура СтатусОтраженияОтборПриИзменении(Элемент)
	
	ВидСравненияСтатусаОтражения = ?(ТипЗнч(СтатусОтражения) = Тип("СписокЗначений"),
		ВидСравненияКомпоновкиДанных.ВСписке, ВидСравненияКомпоновкиДанных.Равно);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "СтатусОтражения", СтатусОтражения,
		ВидСравненияСтатусаОтражения, , Не СтатусОтражения.Пустая());
		
	УстановитьДоступностьЭлементовПоСтатусуОтражения();
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусПроверкиОтборПриИзменении(Элемент)
	
	ВидСравненияСтатусаПроверки = ?(ТипЗнч(СтатусПроверки) = Тип("СписокЗначений"),
		ВидСравненияКомпоновкиДанных.ВСписке, ВидСравненияКомпоновкиДанных.Равно);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "СтатусПроверки", СтатусПроверки,
		ВидСравненияСтатусаПроверки, , Не СтатусПроверки.Пустая());
		
	Если Не Элементы.Найти("СписокПроверить") = Неопределено И Не Элементы.Найти("СписокОтменитьПроверку") = Неопределено Тогда
		Элементы.СписокПроверить.Доступность = Не ЗначениеЗаполнено(СтатусПроверки)
			ИЛИ Не СтатусПроверки = ПредопределенноеЗначение("Перечисление.ЭтапыПроверкиДокументаВРеглУчете.Проверен");
		Элементы.СписокОтменитьПроверку.Доступность = Не ЗначениеЗаполнено(СтатусПроверки)
			ИЛИ СтатусПроверки = ПредопределенноеЗначение("Перечисление.ЭтапыПроверкиДокументаВРеглУчете.Проверен");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийСписка

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	СтрокаСписка = Элементы.Список.ТекущиеДанные;
	ПоказатьЗначение(Неопределено, СтрокаСписка.Документ);
	
КонецПроцедуры // СписокВыбор()

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ПолучитьКомментарий", 0.2, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ТестироватьСозданиеПроводок(Команда)
	
	СтрокаСписка = Элементы.Список.ТекущиеДанные;
	Если СтрокаСписка <> Неопределено Тогда
		ПараметрыФормы = Новый Структура("ДокументСсылка", СтрокаСписка.Документ);
		ОткрытьФорму("Обработка.НастройкаОтраженияДокументовВРеглУчете.Форма.ТестированиеПроводок", ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтразитьВУчете(Команда)
	
	МассивДокументов = Новый Массив;
	Для каждого Стр Из Элементы.Список.ВыделенныеСтроки Цикл
		Данные = Элементы.Список.ДанныеСтроки(Стр);
		МассивДокументов.Добавить(Данные.Документ);
	КонецЦикла;
	
	ОтразитьДокументыВУчетеНаСервере(МассивДокументов);
	Оповестить("Запись_ОтражениеДокументовВРегламентированномУчете", МассивДокументов, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьПроверку(Команда)
	
	МассивДокументов = Новый Массив;
	Для каждого Стр Из Элементы.Список.ВыделенныеСтроки Цикл
		Данные = Элементы.Список.ДанныеСтроки(Стр);
		Если Не Данные.СтатусПроверки.Пустая() Тогда
			МассивДокументов.Добавить(Данные.Документ);
		КонецЕсли;
	КонецЦикла;
	
	СообщениеОбОшибках = УстановитьСтатусПроверкиНаСервереИВернутьОшибки(МассивДокументов, Ложь);
	
	Если МассивДокументов.Количество() > 0 Тогда
		Оповестить("Запись_СтатусПроверкиДокумента", МассивДокументов, ЭтотОбъект);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СообщениеОбОшибках) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибках);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьОтражениеВУчете(Команда)
	МассивДокументов = Новый Массив;
	Для каждого Стр Из Элементы.Список.ВыделенныеСтроки Цикл
		Данные = Элементы.Список.ДанныеСтроки(Стр);
		МассивДокументов.Добавить(Данные.Документ);
	КонецЦикла;
	ОтменитьОтражениеДокументовВУчетеНаСервере(МассивДокументов);
	Оповестить("Запись_ОтражениеДокументовВРегламентированномУчете", МассивДокументов, ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Проверить(Команда)
	
	МассивДокументов = Новый Массив;
	Для каждого Стр Из Элементы.Список.ВыделенныеСтроки Цикл
		Данные = Элементы.Список.ДанныеСтроки(Стр);
		Если ТипыПроверяемыхДокументов.СодержитТип(ТипЗнч(Данные.Документ)) Тогда
			МассивДокументов.Добавить(Данные.Документ);
		КонецЕсли;
	КонецЦикла;
	
	СообщениеОбОшибках = УстановитьСтатусПроверкиНаСервереИВернутьОшибки(МассивДокументов, Истина);
	
	Если МассивДокументов.Количество() > 0 Тогда
		Оповестить("Запись_СтатусПроверкиДокумента", МассивДокументов, ЭтотОбъект);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СообщениеОбОшибках) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибках);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНаОснованииКорректировку(Команда)
	
	МассивДокументов = Новый Массив;
	ТекущаяОрганизация = Организация;
	Для каждого Стр Из Элементы.Список.ВыделенныеСтроки Цикл
		ДанныеСтроки = Элементы.Список.ДанныеСтроки(Стр);
		Если Не ТипЗнч(ДанныеСтроки.Документ) = Тип("ДокументСсылка.ОперацияБух") Тогда
			МассивДокументов.Добавить(ДанныеСтроки.Документ);
		КонецЕсли;
		Если ТекущаяОрганизация.Пустая() Тогда
			ТекущаяОрганизация = ДанныеСтроки.Организация;
		ИначеЕсли Не ТекущаяОрганизация = ДанныеСтроки.Организация Тогда
			ТекстОшибки = НСтр("ru = 'Документ корректировки можно ввести только для документов по одной организации!'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
			Возврат;
		КонецЕсли;
	КонецЦикла;
	
	Если МассивДокументов.Количество() Тогда
		ПараметрыОперации = Новый Структура("Основание", МассивДокументов);
		ОткрытьФорму("Документ.ОперацияБух.ФормаОбъекта", ПараметрыОперации);
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Данную команду нельзя выполнить для операции регл. учета.'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроводкиРеглУчета(Команда)
	
	ТекущаяСтрока = Элементы.Список.ТекущиеДанные;
	
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Документ = ТекущаяСтрока.Документ;
	
	Если ТипЗнч(Документ) = Тип("ДокументСсылка.ОперацияБух") Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Данную команду нельзя выполнить для операции регл. учета.'"));
	Иначе
		Отбор = Новый Структура("Регистратор", Документ);
		ПараметрыФормы = Новый Структура("Отбор", Отбор);
		ОткрытьФорму("Обработка.ОтражениеДокументовВРеглУчете.Форма.ПроводкиРегламентированногоУчета",
			ПараметрыФормы,
			Команда,
			Документ);
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура НастроитьСчетаУчета(Команда)
	
	ТекущаяСтрока = Элементы.Список.ТекущиеДанные;
	
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураПараметры = Новый Структура;
	СтруктураПараметры.Вставить("Организация", ТекущаяСтрока.Организация);
	СтруктураПараметры.Вставить("ПоказыватьТолькоТребующиеНастройки", Истина);
	ОткрытьФорму("Обработка.НастройкаОтраженияДокументовВРеглУчете.Форма.ФормаНастройки", 
		СтруктураПараметры, 
		ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьДанныеФормы()
	
	ДокументыОтражаютсяВручную = ПолучитьФункциональнуюОпцию("ИспользоватьРучнуюКорректировкуПроводокПоРеглУчету");
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ДокументыОтражаютсяВручную", ДокументыОтражаютсяВручную);
	
	МассивТиповДокументов = Метаданные.РегистрыСведений.ОтражениеДокументовВРеглУчете.СтандартныеРеквизиты.Регистратор.Тип.Типы();
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПроверкуДокументовПоРегламентированномуУчету") Тогда
		
		ТипыПроверяемыхДокументов = Метаданные.РегистрыСведений["СтатусыПроверкиДокументов"].Измерения.Документ.Тип;
		
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "СписокПроверяемыхТипов", ПроверкаДокументовСервер.ПроверяемыеТипыДокументов());
		
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивТиповДокументов, ПроверкаДокументовСервер.ПроверяемыеТипыДокументов(), Истина);
		
		ЗаполнитьСписокВыбораСтатусаПроверки();
		
	Иначе
		
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "СписокПроверяемыхТипов", Новый Массив);
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ЕстьБлокировка", Ложь);
		
	КонецЕсли;
	
	Для каждого ТипДокумента Из МассивТиповДокументов Цикл
		
		МетаданныеДокумента = Метаданные.НайтиПоТипу(ТипДокумента);
		СписокТипыДокументов.Добавить(МетаданныеДокумента.ПолноеИмя(), МетаданныеДокумента.Представление());
		
	КонецЦикла;
	
	СписокТипыДокументов.СортироватьПоЗначению();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСтруктуруОтбораФормы(ПараметрыОтбора) Экспорт
	
	Если ПараметрыОтбора.Свойство("ДатаОкончанияПериода") Тогда
		КонецПериода = ?(ПараметрыОтбора.ДатаОкончанияПериода = '39991231', Дата(1,1,1), ПараметрыОтбора.ДатаОкончанияПериода);
		УстановитьОтборПоПериоду(Список, НачалоПериода, КонецПериода);
	КонецЕсли;
		
	Если ПараметрыОтбора.Свойство("ЭтоДокументКорректировки") Тогда
		
		Для каждого ЭлементСпискаДокументов Из СписокТипыДокументов Цикл
			ЭлементСпискаДокументов.Пометка = ?(ЭлементСпискаДокументов.Значение = "Документ.ОперацияБух", 
				ПараметрыОтбора.ЭтоДокументКорректировки, Не ПараметрыОтбора.ЭтоДокументКорректировки);
		КонецЦикла;				
		
		УстановитьОтборПоТипуДокументов(Список, СписокТипыДокументов);
		ОбновитьПредставлениеТипДокументаОтбор(ТипДокументаОтбор, СписокТипыДокументов);
		Элементы.СоздатьНаОсновании.Доступность = Не ПараметрыОтбора.ЭтоДокументКорректировки;
		
	Иначе
		
		ОчиститьОтборПоТипуДокументов();
		Элементы.СоздатьНаОсновании.Доступность = Истина;
		
	КонецЕсли;
	
	Если ПараметрыОтбора.Отбор.Свойство("Организация", Организация) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Организация",
			Организация, , , ЗначениеЗаполнено(Организация));
	КонецЕсли;
	
	ПараметрыОтбора.Отбор.Свойство("СтатусОтражения", СтатусОтражения);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "СтатусОтражения",
		СтатусОтражения, , , ЗначениеЗаполнено(СтатусОтражения));
	
	ПараметрыОтбора.Отбор.Свойство("СтатусПроверки", СтатусПроверки);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "СтатусПроверки",
		СтатусПроверки, , , ЗначениеЗаполнено(СтатусПроверки));
		
	УстановитьДоступностьЭлементовПоСтатусуОтражения();
		
	Если Не Элементы.Найти("СписокПроверить") = Неопределено И Не Элементы.Найти("СписокОтменитьПроверку") = Неопределено Тогда
		Элементы.СписокПроверить.Доступность = Не ЗначениеЗаполнено(СтатусПроверки) ИЛИ Не СтатусПроверки = ПредопределенноеЗначение("Перечисление.ЭтапыПроверкиДокументаВРеглУчете.Проверен");
		Элементы.СписокОтменитьПроверку.Доступность = Не ЗначениеЗаполнено(СтатусПроверки) ИЛИ СтатусПроверки = ПредопределенноеЗначение("Перечисление.ЭтапыПроверкиДокументаВРеглУчете.Проверен");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, РезультатВыбора, "НачалоПериода, КонецПериода");
	
	УстановитьОтборПоПериоду(Список, НачалоПериода, КонецПериода);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьПредставлениеТипДокументаОтбор(ТипДокументаОтбор, СписокТипыДокументов)
	
	ТипДокументаОтбор = "";
	
	Для каждого ЭлементСпискаТиповДокументов Из СписокТипыДокументов Цикл
		Если ЭлементСпискаТиповДокументов.Пометка Тогда
			ТипДокументаОтбор = ТипДокументаОтбор + 
				?(ЗначениеЗаполнено(ТипДокументаОтбор), ", ", "") + ЭлементСпискаТиповДокументов.Представление;
		КонецЕсли;
	КонецЦикла;			
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоТипуДокументов(Список, СписокТипыДокументов)
	
	СписокВыбранныхТиповДокументов = Новый СписокЗначений;
	
	Для каждого ЭлементСпискаДокументов Из СписокТипыДокументов Цикл
		Если ЭлементСпискаДокументов.Пометка Тогда
			ТипДокумента = Тип(СтрЗаменить(ЭлементСпискаДокументов.Значение, "Документ.", "ДокументСсылка."));
			СписокВыбранныхТиповДокументов.Добавить(ТипДокумента);
		КонецЕсли;
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ТипДокумента", СписокВыбранныхТиповДокументов,
		ВидСравненияКомпоновкиДанных.ВСписке, , СписокВыбранныхТиповДокументов.Количество() > 0);
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьОтборПоТипуДокументов()
	СписокТипыДокументов.ЗаполнитьПометки(Ложь);
	УстановитьОтборПоТипуДокументов(Список, СписокТипыДокументов);
	СписокТипыДокументовПредставление = "";
	ТипДокументаОтбор = "";
	УстановитьТекстЗапроса();
	Элементы.СоздатьНаОсновании.Доступность = Истина;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоПериоду(Список, НачалоПериода, КонецПериода)
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Список, "НачалоПериода", НачалоПериода, ЗначениеЗаполнено(НачалоПериода)); 
		             
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Список, "КонецПериода", КонецПериода, ЗначениеЗаполнено(КонецПериода)); 
		
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораСтатусаПроверки()
	
	СписокВыбора = Элементы.СтатусПроверкиОтбор.СписокВыбора;
	ЭтапыПроверки = Перечисления.ЭтапыПроверкиДокументаВРеглУчете;
	
	СписокВыбора.Очистить();
	                          
	СписокВыбора.Добавить(ЭтапыПроверки.Проверен, Строка(ЭтапыПроверки.Проверен));
	СписокВыбора.Добавить(ЭтапыПроверки.НеПроверен, Строка(ЭтапыПроверки.НеПроверен));
	
	РазрешатьИзменятьПроверенныеДокументыПоРеглУчету = ПолучитьФункциональнуюОпцию("РазрешатьИзменятьПроверенныеДокументыПоРеглУчету");
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ЕстьБлокировка", Не РазрешатьИзменятьПроверенныеДокументыПоРеглУчету);
	
	Если РазрешатьИзменятьПроверенныеДокументыПоРеглУчету Тогда
		
		СписокВыбора.Добавить(ЭтапыПроверки.КПовторнойПроверке, Строка(ЭтапыПроверки.КПовторнойПроверке));
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция УстановитьСтатусПроверкиНаСервереИВернутьОшибки(МассивДокументов, СтатусПроверки)
	
	СтрокаОшибок = "";
	ДанныеОбОшибках = Новый Соответствие;
	
	РегистрыСведений.СтатусыПроверкиДокументов.УстановитьСтатусПроверкиДокументов(МассивДокументов, ДанныеОбОшибках, СтатусПроверки);
	
	Если ДанныеОбОшибках.Количество() Тогда
		
		Для каждого Ошибка Из ДанныеОбОшибках Цикл
			СтрокаОшибок = СтрокаОшибок + Ошибка.Значение + ";" + Символы.ПС;
			ИндексОшибочногоДокументаВМассиве = МассивДокументов.Найти(Ошибка.Ключ);
			Если Не ИндексОшибочногоДокументаВМассиве = Неопределено Тогда
				МассивДокументов.Удалить(ИндексОшибочногоДокументаВМассиве);
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат СтрокаОшибок;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ОтразитьДокументыВУчетеНаСервере(МассивДокументов)
	
	РеглУчетПроведениеСервер.ОтразитьДокументыВРеглУчете(МассивДокументов, Истина);
	
	СтатусыОтражения = Перечисления.СтатусыОтраженияДокументовВРеглУчете;
	СтатусОтбора = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(СтатусыОтражения.КОтражениюВУчетеВручную);
	
	ЗаписатьНовыйСтатусОтражения(МассивДокументов, СтатусыОтражения.ОтраженоВУчетеВручную, СтатусОтбора);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОтменитьОтражениеДокументовВУчетеНаСервере(МассивДокументов)
	
	СписокТиповИсключений = ИсключенияДляПереотражения();
	
	МассивДокументовДляАвтоматическогоОтражения = Новый Массив;
	
	ТекстСообщения = "";
	
	Для каждого Документ Из МассивДокументов Цикл
		
		// Обработаем исключения документов, для которых нельзя откатить отражение в регл. учете:
		Если СписокТиповИсключений.Найти(ТипЗнч(Документ)) = Неопределено Тогда
			МассивДокументовДляАвтоматическогоОтражения.Добавить(Документ);
		Иначе
			ШаблонСообщения = НСтр("ru = 'Для документа ""%1"" невозможно отменить отражение в учете.'");
			ШаблонСообщения = СтрШаблон(ШаблонСообщения, Документ);
			ТекстСообщения = ТекстСообщения + ?(ЗначениеЗаполнено(ТекстСообщения), Символы.ПС, "") + ШаблонСообщения;
		КонецЕсли;		
		
	КонецЦикла;
	
	СтатусыОтражения = Перечисления.СтатусыОтраженияДокументовВРеглУчете;
	СтатусыОтбора = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(СтатусыОтражения.ОтраженоВРеглУчете);
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьРучнуюКорректировкуПроводокПоРеглУчету") Тогда
		// Возможна ситуация когда функциональная опция ручного отражения снята, но документы отраженные вручную есть - для
		// них тоже надо снимать отражение:
		СтатусыОтбора.Добавить(СтатусыОтражения.КОтражениюВУчетеВручную);
		СтатусыОтбора.Добавить(СтатусыОтражения.ОтраженоВУчетеВручную);
	КонецЕсли;
	
	ЗаписатьНовыйСтатусОтражения(МассивДокументовДляАвтоматическогоОтражения, СтатусыОтражения.КОтражениюВРеглУчете, СтатусыОтбора);
	
	Если ЗначениеЗаполнено(ТекстСообщения) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаписатьНовыйСтатусОтражения(МассивДокументов, НовыйСтатусОтражения, СтарыеСтатусыОтражения)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОтражениеДокументовВРеглУчете.Период,
	|	ОтражениеДокументовВРеглУчете.Регистратор,
	|	ОтражениеДокументовВРеглУчете.Организация,
	|	ОтражениеДокументовВРеглУчете.ДатаОтражения,
	|	ВЫБОР КОГДА ОтражениеДокументовВРеглУчете.Статус В (&СтарыеСтатусыОтражения) ТОГДА
	|		&НовыйСтатус 
	|	ИНАЧЕ
	|		ОтражениеДокументовВРеглУчете.Статус
	|	КОНЕЦ КАК Статус,
	|	ОтражениеДокументовВРеглУчете.Комментарий
	|ИЗ
	|	РегистрСведений.ОтражениеДокументовВРеглУчете КАК ОтражениеДокументовВРеглУчете
	|ГДЕ
	|	ОтражениеДокументовВРеглУчете.Регистратор В(&МассивДокументов)
	|ИТОГИ ПО
	|	Регистратор";
	Запрос.УстановитьПараметр("МассивДокументов", МассивДокументов);
	Запрос.УстановитьПараметр("НовыйСтатус", НовыйСтатусОтражения);
	Запрос.УстановитьПараметр("СтарыеСтатусыОтражения", СтарыеСтатусыОтражения);
	
	ВыборкаДокументов = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	НаборЗаписей = РегистрыСведений.ОтражениеДокументовВРеглУчете.СоздатьНаборЗаписей();
	ПараметрыБлокировки	= Новый Структура("ТипТаблицы, ИмяТаблицы", "РегистрСведений", "ОтражениеДокументовВРеглУчете.НаборЗаписей");
	
	Пока ВыборкаДокументов.Следующий() Цикл
		
		НачатьТранзакцию();

		Попытка
			
			ЗначенияБлокировки	= Новый Структура("Регистратор", ВыборкаДокументов.Регистратор);
			ОбщегоНазначенияБПВызовСервера.УстановитьУправляемуюБлокировку(ПараметрыБлокировки, ЗначенияБлокировки);
			
			НаборЗаписей.Очистить();
			НаборЗаписей.Отбор.Регистратор.Установить(ВыборкаДокументов.Регистратор);
			
			Выборка = ВыборкаДокументов.Выбрать();
			
			Пока Выборка.Следующий() Цикл
				
				ЗаписьОтражения = НаборЗаписей.Добавить();
			   	ЗаполнитьЗначенияСвойств(ЗаписьОтражения, Выборка);
			
			КонецЦикла;
			
			НаборЗаписей.Записать();
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			СообщениеОбОшибке = НСтр("ru = 'Для документа %Документ%, операция изменения статуса отражения не выполнена.'");
			СообщениеОбОшибке = СтрЗаменить(СообщениеОбОшибке, "%Документ%", ВыборкаДокументов.Регистратор);
			ЗаписьЖурналаРегистрации(НСТр("ru = 'Операция не выполнена'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка, ВыборкаДокументов.Регистратор.Метаданные(), ВыборкаДокументов.Регистратор, СообщениеОбОшибке);
			
			Продолжить;
			
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИсключенияДляПереотражения()
	
	СписокТиповИсключений = Новый Массив;
	СписокТиповИсключений.Добавить(Тип("ДокументСсылка.АмортизацияНМА"));
	СписокТиповИсключений.Добавить(Тип("ДокументСсылка.АмортизацияОС"));
	СписокТиповИсключений.Добавить(Тип("ДокументСсылка.ПередачаОСАрендатору"));
	СписокТиповИсключений.Добавить(Тип("ДокументСсылка.ВозвратОСОтАрендатора"));
	СписокТиповИсключений.Добавить(Тип("ДокументСсылка.ВыбытиеАрендованныхОС"));
	СписокТиповИсключений.Добавить(Тип("ДокументСсылка.ИзменениеПараметровОС"));
	СписокТиповИсключений.Добавить(Тип("ДокументСсылка.МодернизацияОС"));
	СписокТиповИсключений.Добавить(Тип("ДокументСсылка.ПеремещениеОС"));
	СписокТиповИсключений.Добавить(Тип("ДокументСсылка.ПереоценкаНМА"));
	СписокТиповИсключений.Добавить(Тип("ДокументСсылка.ПереоценкаОС"));
	СписокТиповИсключений.Добавить(Тип("ДокументСсылка.ПодготовкаКПередачеНМА"));
	СписокТиповИсключений.Добавить(Тип("ДокументСсылка.ПодготовкаКПередачеОС"));
	СписокТиповИсключений.Добавить(Тип("ДокументСсылка.ПринятиеКУчетуНМА"));
	СписокТиповИсключений.Добавить(Тип("ДокументСсылка.ПринятиеКУчетуОС"));
	СписокТиповИсключений.Добавить(Тип("ДокументСсылка.СписаниеНМА"));
	СписокТиповИсключений.Добавить(Тип("ДокументСсылка.СписаниеОС"));
	СписокТиповИсключений.Добавить(Тип("ДокументСсылка.ОперацияБух"));
	СписокТиповИсключений.Добавить(Тип("ДокументСсылка.РегламентнаяОперация"));
	СписокТиповИсключений.Добавить(Тип("ДокументСсылка.КорректировкаНалогообложенияНДСПартийТоваров"));
	
	Возврат СписокТиповИсключений;
	
КонецФункции

#Область ФормированиеЗапроса

&НаСервере
Процедура УстановитьТекстЗапроса()
	
	ТекстЗапроса = НачальныйТекстЗапроса;
	
	ТипыДополнительныхДанных = Новый Соответствие;
	ТипыДополнительныхДанных.Вставить("Автор", Тип("СправочникСсылка.Пользователи"));
	ТипыДополнительныхДанных.Вставить("Договор", Тип("СправочникСсылка.ДоговорыКонтрагентов"));
	ТипыДополнительныхДанных.Вставить("Касса", Тип("СправочникСсылка.Кассы"));
	ТипыДополнительныхДанных.Вставить("Контрагент", Тип("СправочникСсылка.Контрагенты"));
	ТипыДополнительныхДанных.Вставить("Партнер", Тип("СправочникСсылка.Партнеры"));
	ТипыДополнительныхДанных.Вставить("Склад", Тип("СправочникСсылка.Склады"));
	ТипыДополнительныхДанных.Вставить("ХозяйственнаяОперация", Тип("ПеречислениеСсылка.ХозяйственныеОперации"));
	ТипыДополнительныхДанных.Вставить("СуммаДокумента", Тип("Число"));
	ТипыДополнительныхДанных.Вставить("Валюта", Тип("СправочникСсылка.Валюты"));
	
	ДополнительныеДанные = Новый Соответствие;
	Для каждого ТипДополнительныхДанных Из ТипыДополнительныхДанных Цикл
		ДополнительныеДанные.Вставить(ТипДополнительныхДанных.Ключ, "");
	КонецЦикла;
			
	ТекстСвязки = "";
	ШаблонПоля = Символы.ПС + "КОГДА СгруппированныеДанные.Документ ССЫЛКА Документ.%1" + Символы.ПС + "ТОГДА %2";
	ШаблонСвязки = Символы.ПС + "{ЛЕВОЕ СОЕДИНЕНИЕ Документ.%1 КАК Таблица%1" + Символы.ПС + "ПО СгруппированныеДанные.Документ = Таблица%1.Ссылка" + Символы.ПС + "И (Таблица%1.Проведен)}";
	
	Для каждого ТипДокумента Из ЭтотОбъект.СписокТипыДокументов Цикл
		
		Если Не ТипДокумента.Пометка И Не ТипДокументаОтбор = "" Тогда
			Продолжить;
		КонецЕсли;
		
		МетаданныеДокумента = Метаданные.НайтиПоПолномуИмени(ТипДокумента.Значение);
		
		Если Не ПравоДоступа("Чтение", МетаданныеДокумента) Тогда
			Продолжить;
		КонецЕсли;
		
		Для каждого Поле Из ДополнительныеДанные Цикл
			
			ТекущаяСтрокаПоля = ПолучитьСтрокуПоля(Поле.Ключ, ТипыДополнительныхДанных.Получить(Поле.Ключ), МетаданныеДокумента);
			Если ЗначениеЗаполнено(ТекущаяСтрокаПоля) Тогда
				ТекущаяСтрокаПоля = СтрШаблон(ТекущаяСтрокаПоля, "Таблица"+МетаданныеДокумента.Имя);
				ДополнительныеДанные.Вставить(Поле.Ключ, Поле.Значение + СтрШаблон(ШаблонПоля, МетаданныеДокумента.Имя, ТекущаяСтрокаПоля));
			КонецЕсли;
			
		КонецЦикла;
		
		ТекстСвязки = ТекстСвязки + СтрШаблон(ШаблонСвязки, МетаданныеДокумента.Имя);
		
	КонецЦикла;
	
	Для каждого Поле Из ДополнительныеДанные Цикл
		
		ТипПоля = ТипыДополнительныхДанных.Получить(Поле.Ключ);
		Если ТипПоля = Тип("Строка") Тогда
			ПустоеЗначениеПоля = """""";
			ПриводимыйТип = "СТРОКА";
		ИначеЕсли ТипПоля = Тип("Число") Тогда
			ПустоеЗначениеПоля = "0";
			ПриводимыйТип = "ЧИСЛО";
		Иначе
			ПолноеИмя = Метаданные.НайтиПоТипу(ТипПоля).ПолноеИмя();
			ПустоеЗначениеПоля = "ЗНАЧЕНИЕ(" + ПолноеИмя + ".ПустаяСсылка)";
			ПриводимыйТип = ПолноеИмя;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Поле.Значение) Тогда
			СтрокаПоляВЗапросе = "ВЫБОР" + Поле.Значение + Символы.ПС + "ИНАЧЕ %1" + Символы.ПС + "КОНЕЦ";
			СтрокаПоляВЗапросе = СтрШаблон(СтрокаПоляВЗапросе, ПустоеЗначениеПоля);
		Иначе
			СтрокаПоляВЗапросе = ПустоеЗначениеПоля;
		КонецЕсли;
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&"+Поле.Ключ, СтрокаПоляВЗапросе);
		
	КонецЦикла;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//#Таблица", ТекстСвязки);
	
	СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
	ЗаполнитьЗначенияСвойств(СвойстваСписка, Список, "ОсновнаяТаблица, ДинамическоеСчитываниеДанных");
	СвойстваСписка.ТекстЗапроса = ТекстЗапроса;
	
	ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.Список, СвойстваСписка);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСтрокуПоля(ИмяПоля, Тип, МетаданныеДокумента)
	       
	Если ИмяПоля = "Автор" Тогда
		Реквизит = МетаданныеДокумента.Реквизиты.Найти("Автор");
		Если Не Реквизит = Неопределено И Реквизит.Тип.СодержитТип(Тип) Тогда
			Возврат "%1."+"Автор";
		КонецЕсли;
		Реквизит = МетаданныеДокумента.Реквизиты.Найти("Ответственный");
		Если Не Реквизит = Неопределено И Реквизит.Тип.СодержитТип(Тип) Тогда
			Возврат "%1."+"Ответственный";
		КонецЕсли;
	Иначе
		Реквизит = МетаданныеДокумента.Реквизиты.Найти(ИмяПоля);
		Если Не Реквизит = Неопределено И Реквизит.Тип.СодержитТип(Тип) Тогда
			Возврат "%1."+ИмяПоля;
		КонецЕсли;
	КонецЕсли;
	
	// Обработаем исключение:
	Если ИмяПоля = "Контрагент" И МетаданныеДокумента.Имя = "ВзаимозачетЗадолженности" Тогда
		Возврат "ВЫБОР КОГДА %1.КонтрагентДебитор ССЫЛКА Справочник.Контрагенты ТОГДА %1.КонтрагентДебитор ИНАЧЕ %1.КонтрагентКредитор КОНЕЦ";
	КонецЕсли;
	Если ИмяПоля = "Склад" И МетаданныеДокумента.Имя = "ПеремещениеТоваров" Тогда
		Возврат "%1.СкладОтправитель";
	КонецЕсли;
	
	МассивРеквизитов = Новый Массив;
	Для Каждого Реквизит Из МетаданныеДокумента.Реквизиты Цикл
		Если Реквизит.Тип.СодержитТип(Тип) Тогда
			МассивРеквизитов.Добавить(Реквизит.Имя);
		КонецЕсли;
	КонецЦикла;
	
	Если МассивРеквизитов.Количество() = 1 Тогда
		Возврат "%1."+МассивРеквизитов.Получить(0);
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура УстановитьДоступностьЭлементовПоСтатусуОтражения()
	
	Элементы.СписокОтразитьВУчете.Доступность = Не ЗначениеЗаполнено(СтатусОтражения)
		ИЛИ Не ПолучитьФункциональнуюОпцию("ИспользоватьРучнуюКорректировкуПроводокПоРеглУчету")
		ИЛИ Не СтатусОтражения = ПредопределенноеЗначение("Перечисление.СтатусыОтраженияДокументовВРеглУчете.ОтраженоВРеглУчете")
		И Не СтатусОтражения = ПредопределенноеЗначение("Перечисление.СтатусыОтраженияДокументовВРеглУчете.ОтраженоВУчетеВручную");
	Элементы.СписокСнятьОтражениеВУчете.Доступность = Не ЗначениеЗаполнено(СтатусОтражения)
		ИЛИ Не ПолучитьФункциональнуюОпцию("ИспользоватьРучнуюКорректировкуПроводокПоРеглУчету")
		ИЛИ СтатусОтражения = ПредопределенноеЗначение("Перечисление.СтатусыОтраженияДокументовВРеглУчете.ОтраженоВРеглУчете");
		
	Элементы.ГруппаКомментарий.Видимость = (СтатусОтражения = Перечисления.СтатусыОтраженияДокументовВРеглУчете.НеУказаныСчетаУчета);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьКомментарий()
	
	Если Не Элементы.ГруппаКомментарий.Видимость Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяСтрока = Элементы.Список.ТекущиеДанные;
	
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПолучитьКомментарийСервер(ТекущаяСтрока.Документ, ТекущаяСтрока.Организация);
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьКомментарийСервер(Документ, Организация)
	
	Комментарий = РеглУчетПроведениеСервер.СводныйКомментарийПоДокументу(Документ, Организация);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
