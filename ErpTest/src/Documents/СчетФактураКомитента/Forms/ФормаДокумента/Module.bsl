#Область ОписаниеПеременных

// СтандартныеПодсистемы.РаботаСКонтрагентами
&НаКлиенте
Перем ПроверкаКонтрагентовПараметрыОбработчикаОжидания Экспорт;

&НаКлиенте
Перем ФормаДлительнойОперации Экспорт;
// Конец СтандартныеПодсистемы.РаботаСКонтрагентами

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ПараметрыЭДОПриСоздании = ОбменСКонтрагентами.ПараметрыПриСозданииНаСервере_ФормаДокумента();
	ПараметрыЭДОПриСоздании.Форма = ЭтотОбъект;
	ПараметрыЭДОПриСоздании.ДокументССылка = Объект.Ссылка;
	ПараметрыЭДОПриСоздании.ДекорацияСостояниеЭДО = Элементы.ДекорацияСостояниеЭДО;
	ПараметрыЭДОПриСоздании.ГруппаСостояниеЭДО = Элементы.ГруппаСостояниеЭДО;
	ПараметрыЭДОПриСоздании.МестоРазмещенияКоманд = Элементы.ПодменюЭДО;
	
	ОбменСКонтрагентами.ПриСозданииНаСервере_ФормаДокумента(ПараметрыЭДОПриСоздании);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПриСозданииНаСервереДокумент(ЭтотОбъект, Параметры);
	ПроверкаКонтрагентовВызовСервераПереопределяемыйУТ.ФормаДокументаПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
	УчетНДСУПСлужебный.НастроитьСовместныйВыборКонтрагентовОрганизаций(Элементы.ПокупателиПокупатель);
	УчетНДСУПСлужебный.НастроитьСовместныйВыборКонтрагентовОрганизаций(Элементы.ПокупателиСубкомиссионер);
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// Обработчик механизма "ДатыЗапретаИзменения"
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	ПриЧтенииСозданииНаСервере();
	
	СобытияФорм.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПриЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ПараметрыПослеЗаписи = ОбменСКонтрагентами.ПараметрыПослеЗаписиНаСервере();
	ПараметрыПослеЗаписи.Форма = ЭтотОбъект;
	ПараметрыПослеЗаписи.ДокументСсылка = Объект.Ссылка;
	ПараметрыПослеЗаписи.ДекорацияСостояниеЭДО = Элементы.ДекорацияСостояниеЭДО;
	ПараметрыПослеЗаписи.ГруппаСостояниеЭДО = Элементы.ГруппаСостояниеЭДО;

	ОбменСКонтрагентами.ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи, ПараметрыПослеЗаписи);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
	ЗаполнитьСлужебныеРеквизитыСубкомиссионеров();
	УправлениеЭлементамиФормы(ЭтотОбъект);
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ПараметрыОповещения = ОбменСКонтрагентамиКлиент.ПараметрыОповещенияЭДО_ФормаДокумента();
	ПараметрыОповещения.Форма = ЭтотОбъект;
	ПараметрыОповещения.ДокументСсылка = Объект.Ссылка;
	ПараметрыОповещения.ДекорацияСостояниеЭДО = Элементы.ДекорацияСостояниеЭДО;
	ПараметрыОповещения.ГруппаСостояниеЭДО = Элементы.ГруппаСостояниеЭДО;
	
	ОбменСКонтрагентамиКлиент.ОбработкаОповещения_ФормаДокумента(ИмяСобытия, Параметр, Источник, ПараметрыОповещения);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
	Если ИмяСобытия = "ОбновитьДокументИБПослеЗаполнения"  И Параметр.Найти(Объект.Ссылка) <> Неопределено Тогда
		ЭтаФорма.Прочитать();
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_Контрагенты" Тогда
		ЗаполнитьСлужебныеРеквизитыСубкомиссионеров(Источник);
		УправлениеЭлементамиФормы(ЭтотОбъект);
	КонецЕсли;
	
	СобытияФормКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_СчетФактураКомитента", ПараметрыЗаписи, Объект.Ссылка);
	
	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПередЗаписьюНаСервереДокумент(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ПриОткрытииДокумент(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ОбменСКонтрагентамиКлиент.ПриОткрытии(ЭтотОбъект);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормКлиент.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура КодВидаОперацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	СписокКодовВидовОпераций.ПоказатьВыборЭлемента(Новый ОписаниеОповещения("КодВидаОперацииНачалоВыбораЗавершение", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура КодВидаОперацииПриИзменении(Элемент)
	
	ОбновитьПредставлениеВидаОперации(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования, 
		ЭтотОбъект, 
		"Объект.Комментарий");
	
КонецПроцедуры

&НаКлиенте
Процедура ПокупателиСчетФактураВыданныйНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущаяСтрока = Элементы.Покупатели.ТекущиеДанные;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Организация", Объект.Организация);
	ПараметрыФормы.Вставить("Дата",        Объект.ДатаСоставления);
	ПараметрыФормы.Вставить("Покупатель",  ТекущаяСтрока.Покупатель);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИдентификаторСтроки", Элементы.Покупатели.ТекущаяСтрока);
	ОписаниеОповещения = Новый ОписаниеОповещения("СчетФактураВыставленныйОбработкаВыбора", ЭтотОбъект, ДополнительныеПараметры);
	
	ОткрытьФорму("ОбщаяФорма.ВыборСчетаФактурыВыданногоПокупателюКомиссионногоТовара", 
		ПараметрыФормы, ЭтаФорма, , , , ОписаниеОповещения) 
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаСоставленияПриИзменении(Элемент)
	
	ДатаСоставленияПриИзмененииСервер();
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентовВДокументе(ЭтотОбъект, Элемент);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура КомитентПриИзменении(Элемент)
	
	ЗаполнитьЗависимыеОтКомитентаРеквизитыФормы(Истина);
	УправлениеЭлементамиФормы(ЭтотОбъект);
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентовВДокументе(ЭтотОбъект, Элемент);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура ИсправлениеПриИзменении(Элемент)
	
	УправлениеЭлементамиФормы(ЭтаФорма);
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентовВДокументе(ЭтотОбъект, Элемент);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами

	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияЭДОНажатие(Элемент, СтандартнаяОбработка)
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ОбменСКонтрагентамиКлиент.ДекорацияСостояниеЭДОНажатие(ЭтотОбъект, СтандартнаяОбработка);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаИсправленияПриИзменении(Элемент)
	
	ДатаИсправленияПриИзмененииСервер();
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентовВДокументе(ЭтотОбъект, Объект.ДатаИсправления);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентам
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	ЗаполнитьСписокКодовВидовОпераций();
	
КонецПроцедуры

&НаКлиенте
Процедура ПокупателиСубкомиссионерПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Покупатели.ТекущиеДанные;
	ЗаполнитьСлужебныеРеквизитыСубкомиссионеров(ТекущаяСтрока.Субкомиссионер, Истина);
	УправлениеЭлементамиФормы(ЭтотОбъект);
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентовВДокументе(ЭтотОбъект, Элементы.Покупатели);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура ПокупателиИННСубкомиссионераПриИзменении(Элемент)
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентовВДокументе(ЭтотОбъект, Элементы.Покупатели);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура ПокупателиКППСубкомиссионераПриИзменении(Элемент)
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентовВДокументе(ЭтотОбъект, Элементы.Покупатели);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура ПокупателиКППСубкомиссионераНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущаяСтрока = Элементы.Покупатели.ТекущиеДанные;
	Если ЗначениеЗаполнено(ТекущаяСтрока.Субкомиссионер) Тогда
		ЗаполнитьСписокВыбораКПП(СписокВыбораКПП, ТекущаяСтрока.Субкомиссионер, ДатаСведений(Объект));
	КонецЕсли;
	
	ДанныеВыбора = СписокВыбораКПП;
	
КонецПроцедуры

&НаКлиенте
Процедура КППКомитентаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если СписокВыбораКПП.Количество() = 0 Тогда
		
		Если ЗначениеЗаполнено(Объект.Комитент) Тогда
			ЗаполнитьСписокВыбораКПП(СписокВыбораКПП, Объект.Комитент, ДатаСведений(Объект));
		КонецЕсли;
		
	КонецЕсли;
	
	ДанныеВыбора = СписокВыбораКПП;
	
КонецПроцедуры

&НаКлиенте
Процедура КППКомитентаПриИзменении(Элемент)
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентовВДокументе(ЭтотОбъект, Элемент);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура ИННКомитентаПриИзменении(Элемент)
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентовВДокументе(ЭтотОбъект, Элемент);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
	
КонецПроцедуры

// ЭлектронноеВзаимодействие.ОбменСКонтрагентами

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуЭДО(Команда)
	
	ЭлектронноеВзаимодействиеКлиент.ВыполнитьПодключаемуюКомандуЭДО(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработчикОжиданияЭДО()
	
	ОбменСКонтрагентамиКлиент.ОбработчикОжиданияЭДО(ЭтотОбъект);
	
КонецПроцедуры

// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьПокупателей(Команда)
	
	СтруктураРеквизитов = Новый Структура;
	СтруктураРеквизитов.Вставить("Организация");
	СтруктураРеквизитов.Вставить("Комитент");
	СтруктураРеквизитов.Вставить("Дата",);
	СтруктураРеквизитов.Вставить("Валюта");
	
	Оповещение = Новый ОписаниеОповещения("ПроверитьВозможностьПодбораПокупателейЗавершение", ЭтотОбъект);
	ОбщегоНазначенияУТКлиент.ПроверитьВозможностьЗаполненияТабличнойЧасти(
		Оповещение, 
		ЭтаФорма, 
		Неопределено, 
		СтруктураРеквизитов,
		Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область РаботаСКонтрагентами

&НаКлиенте
Процедура Подключаемый_ПоказатьПредложениеИспользоватьПроверкуКонтрагентов()
	ПроверкаКонтрагентовКлиент.ПредложитьВключитьПроверкуКонтрагентов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработатьРезультатПроверкиКонтрагентов()
	ПроверкаКонтрагентовКлиент.ОбработатьРезультатПроверкиКонтрагентовВДокументе(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ОтобразитьРезультатПроверкиКонтрагента() Экспорт
	ПроверкаКонтрагентов.ОтобразитьРезультатПроверкиКонтрагентаВДокументе(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ПроверитьКонтрагентовФоновоеЗадание(ПараметрыФоновогоЗадания) Экспорт	
	ПроверкаКонтрагентов.ПроверитьКонтрагентовВДокументеФоновоеЗадание(ЭтотОбъект, ПараметрыФоновогоЗадания);
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьКонтрагентов(Команда)
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ПроверитьКонтрагентовВДокументеПоКнопке(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ЗаполнитьЗависимыеОтКомитентаРеквизитыФормы();
	ЗаполнитьСлужебныеРеквизитыСубкомиссионеров();
	УправлениеЭлементамиФормы(ЭтаФорма);
	
	ЗаполнитьСписокКодовВидовОпераций();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеЭлементамиФормы(Форма)
	
	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;
	
	Элементы.ГруппаНомерДатаИсправления.Доступность = Объект.Исправление;
	Элементы.ИННКомитента.Доступность               = ЗначениеЗаполнено(Объект.Комитент);
	Элементы.КППКомитента.Доступность               = ЗначениеЗаполнено(Объект.Комитент) И Форма.КомитентЮрЛицо;
	
	Для Каждого Строка Из Форма.Объект.Покупатели Цикл
	
		Строка.ТолькоПросмотрИННСубкомиссионера = Не ЗначениеЗаполнено(Строка.Субкомиссионер)
		                                          Или ТипЗнч(Строка.Субкомиссионер) <> Тип("СправочникСсылка.Контрагенты");
		
		Строка.ТолькоПросмотрКППСубкомиссионера = Не ЗначениеЗаполнено(Строка.Субкомиссионер)
		                                          Или ТипЗнч(Строка.Субкомиссионер) <> Тип("СправочникСсылка.Контрагенты")
		                                          Или НЕ Строка.ЮрЛицо;
		
		Строка.КППНеТребуется                   = ЗначениеЗаполнено(Строка.Субкомиссионер)
		                                          И ТипЗнч(Строка.Субкомиссионер) = Тип("СправочникСсылка.Контрагенты")
		                                          И НЕ Строка.ЮрЛицо;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура КодВидаОперацииНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		Объект.КодВидаОперации = Результат.Значение;
		ОбновитьПредставлениеВидаОперации(ЭтаФорма);
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПараметрыПодбораПокупателей()
	
	АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(Объект.Покупатели.Выгрузить(), УникальныйИдентификатор);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Организация",               Объект.Организация);
	ПараметрыФормы.Вставить("Комитент",                  Объект.Комитент);
	ПараметрыФормы.Вставить("Дата",                      Объект.ДатаСоставления);
	ПараметрыФормы.Вставить("Валюта",                    Объект.Валюта);
	ПараметрыФормы.Вставить("АдресВоВременномХранилище", АдресВоВременномХранилище);
	
	Возврат ПараметрыФормы;
	
КонецФункции

&НаКлиенте
Процедура ПодборПокупателейЗавершение(АдресВоВременномХранилище, ДополнительныеПараметры) Экспорт
	
	Если АдресВоВременномХранилище = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПодборПокупателейЗавершениеНаСервере(АдресВоВременномХранилище);
	
КонецПроцедуры

&НаСервере
Процедура ПодборПокупателейЗавершениеНаСервере(АдресВоВременномХранилище)
	
	РезультатПодбора = ПолучитьИзВременногоХранилища(АдресВоВременномХранилище);
	
	Отбор = Новый Структура;
	Отбор.Вставить("Покупатель");
	Отбор.Вставить("СчетФактураВыданный");
	Отбор.Вставить("Субкомиссионер");
	
	Для каждого СтрокаРезультатаПодбора Из РезультатПодбора Цикл
		
		ЗаполнитьЗначенияСвойств(Отбор, СтрокаРезультатаПодбора);
		РезультатПоиска = Объект.Покупатели.НайтиСтроки(Отбор);
		
		Если РезультатПоиска.Количество() = 0 Тогда
			Строка = Объект.Покупатели.Добавить();
		ИначеЕсли РезультатПоиска.Количество() = 1 Тогда 
			Строка = РезультатПоиска[0];
		Иначе
			Для Каждого СтрокаКУдалению Из РезультатПоиска Цикл
				Объект.Покупатели.Удалить(СтрокаКУдалению);
			КонецЦикла;
			Строка = Объект.Покупатели.Добавить();
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(Строка, СтрокаРезультатаПодбора);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьПредставлениеВидаОперации(Форма)
	
	ТекущийКод = Форма.СписокКодовВидовОпераций.НайтиПоЗначению(Форма.Объект.КодВидаОперации);
	Если ТекущийКод <> Неопределено Тогда
		Форма.ПредставлениеВидаОперации = Сред(ТекущийКод.Представление, 4);
	Иначе
		Форма.ПредставлениеВидаОперации = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СчетФактураВыставленныйОбработкаВыбора(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Строка = Объект.Покупатели.НайтиПоИдентификатору(ДополнительныеПараметры.ИдентификаторСтроки);
	Строка.СчетФактураВыданный = Результат;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДатуПолучения()
	
	Если ЗначениеЗаполнено(Объект.Дата) Тогда
		Возврат;
	КонецЕсли;

	Если Объект.Исправление И ЗначениеЗаполнено(Объект.ДатаИсправления) Тогда
		Объект.Дата = Объект.ДатаИсправления;
	ИначеЕсли ЗначениеЗаполнено(Объект.ДатаСоставления) Тогда
		Объект.Дата = Объект.ДатаСоставления;
	КонецЕсли;
	
	ЗаполнитьСписокКодовВидовОпераций();
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВозможностьПодбораПокупателейЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ПараметрыФормы = ПараметрыПодбораПокупателей();
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПодборПокупателейЗавершение", ЭтотОбъект);
	ОткрытьФорму("Документ.СчетФактураКомитента.Форма.ФормаПодбораПокупателей", 
		ПараметрыФормы, ЭтаФорма, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаСервере
Процедура ДатаСоставленияПриИзмененииСервер()
	
	Если Не Объект.Исправление Тогда
		ЗаполнитьЗависимыеОтКомитентаРеквизитыФормы(Истина);
		ЗаполнитьСлужебныеРеквизитыСубкомиссионеров(,Истина);
	КонецЕсли;
	
	ЗаполнитьДатуПолучения();
	УправлениеЭлементамиФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокКодовВидовОпераций()
	
	УчетНДС.ЗаполнитьСписокКодовВидовОпераций(
		Перечисления.ЧастиЖурналаУчетаСчетовФактур.ПолученныеСчетаФактуры,
		СписокКодовВидовОпераций,
		?(ЗначениеЗаполнено(Объект.Дата), Объект.Дата, ТекущаяДатаСеанса()));
		
	ОбновитьПредставлениеВидаОперации(ЭтаФорма);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаполнитьСписокВыбораКПП(СписокВыбора, Контрагент, ДатаСведений)
	
	УчетНДСУПСлужебный.ЗаполнитьСписокВыбораКППСчетФактурыПолученные(СписокВыбора, Контрагент, ДатаСведений);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЗависимыеОтКомитентаРеквизитыФормы(ИзменятьИННКПП = Ложь) Экспорт
	
	КомитентЮрЛицо                            = Ложь;
	
	СписокВыбораКПП.Очистить();
	
	Если ЗначениеЗаполнено(Объект.Комитент) И ТипЗнч(Объект.Комитент) = Тип("СправочникСсылка.Контрагенты") Тогда
		
		РеквизитыКомитента = Справочники.Контрагенты.РеквизитыКонтрагента(Объект.Комитент, ДатаСведений(Объект));
		
		КомитентЮрЛицо = (РеквизитыКомитента.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицо);
		
		Если ИзменятьИННКПП Тогда
			Объект.КППКомитента = РеквизитыКомитента.КПП;
			Объект.ИННКомитента = РеквизитыКомитента.ИНН;
		КонецЕсли;
		
	Иначе
		
		Объект.ИННКомитента = "";
		Объект.ИННКомитента = "";
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДатаИсправленияПриИзмененииСервер()
	
	ЗаполнитьДатуПолучения();
	
	Если Объект.Исправление Тогда
		ЗаполнитьЗависимыеОтКомитентаРеквизитыФормы(Истина);
		ЗаполнитьСлужебныеРеквизитыСубкомиссионеров(,Истина);
	КонецЕсли;
	
	УправлениеЭлементамиФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ДатаСведений(Объект)
	
	Возврат ?(Объект.Исправление, Объект.ДатаИсправления, Объект.ДатаСоставления);
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСлужебныеРеквизитыСубкомиссионеров(Контрагенты = Неопределено, ЗаполнятьИННКПП = Ложь)
	
	Если Контрагенты = Неопределено Тогда
		Контрагенты = Новый Массив;
		Для каждого Строка Из Объект.Покупатели Цикл
			Если ЗначениеЗаполнено(Строка.Субкомиссионер) Тогда
				Контрагенты.Добавить(Строка.Субкомиссионер);
			КонецЕсли;
		КонецЦикла
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	МАКСИМУМ(ИсторияКППКонтрагентов.Период) КАК Период,
	|	ИсторияКППКонтрагентов.Ссылка           КАК Ссылка
	|ПОМЕСТИТЬ ЗначенияКПП
	|ИЗ
	|	Справочник.Контрагенты.ИсторияКПП КАК ИсторияКППКонтрагентов
	|ГДЕ
	|	ИсторияКППКонтрагентов.Ссылка  В (&Контрагенты)
	|	И ИсторияКППКонтрагентов.Период <= &ДатаСведений
	|
	|СГРУППИРОВАТЬ ПО
	|	ИсторияКППКонтрагентов.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|
	|ВЫБРАТЬ
	|	ИсторияКППКонтрагентов.КПП    КАК КПП,
	|	ИсторияКППКонтрагентов.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ ИсторическоеЗначениеКПП
	|ИЗ
	|	ЗначенияКПП КАК ЗначенияКПП
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Контрагенты.ИсторияКПП КАК ИсторияКППКонтрагентов
	|		ПО ЗначенияКПП.Ссылка = ИсторияКППКонтрагентов.Ссылка
	|			И ЗначенияКПП.Период = ИсторияКППКонтрагентов.Период
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|
	|ВЫБРАТЬ
	|	Контрагенты.Ссылка                                     КАК Ссылка,
	|	ЕСТЬNULL(ИсторическоеЗначениеКПП.КПП, Контрагенты.КПП) КАК КППСубкомиссионера,
	|	Контрагенты.ИНН                                        КАК ИННСубкомиссионера,
	|	ВЫБОР
	|		КОГДА Контрагенты.ЮрФизЛицо = &ЮрЛицо
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ                                                 КАК ЮрЛицо
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|	ЛЕВОЕ СОЕДИНЕНИЕ ИсторическоеЗначениеКПП КАК ИсторическоеЗначениеКПП
	|		ПО ИсторическоеЗначениеКПП.Ссылка = Контрагенты.Ссылка
	|ГДЕ
	|	Контрагенты.Ссылка В (&Контрагенты)
	|";
	
	Запрос.УстановитьПараметр("Контрагенты",      Контрагенты);
	Запрос.УстановитьПараметр("ПустойКонтрагент", Справочники.Контрагенты.ПустаяСсылка());
	Запрос.УстановитьПараметр("ЮрЛицо",           Перечисления.ЮрФизЛицо.ЮрЛицо);
	Запрос.УстановитьПараметр("ДатаСведений",     ДатаСведений(Объект));
	
	Выборка = Запрос.Выполнить().Выбрать();
	Отбор = Новый Структура("Субкомиссионер");
	
	СтрокаИсключений = ?(ЗаполнятьИННКПП, "", "ИННСубкомиссионера, КППСубкомиссионера");
	
	Пока Выборка.Следующий() Цикл
		
		Отбор.Субкомиссионер = Выборка.Ссылка;
		Строки = Объект.Покупатели.НайтиСтроки(Отбор);
		Для каждого Строка Из Строки Цикл
			ЗаполнитьЗначенияСвойств(Строка, Выборка, , СтрокаИсключений);
		КонецЦикла;
		
	КонецЦикла;
	
	Для каждого Строка Из Объект.Покупатели Цикл
		
		
		Если Не ЗначениеЗаполнено(Строка.Субкомиссионер)
			Или ТипЗнч(Строка.Покупатель) = Тип("СправочникСсылка.Организации") Тогда
			
			Строка.ИННСубкомиссионера = "";
			Строка.КППСубкомиссионера = "";
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
#Область ТолькоПросмотрИННПСубкомиссионера

	Элемент = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПокупателиИННСубкомиссионера.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Объект.Покупатели.ТолькоПросмотрИННСубкомиссионера");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
#КонецОбласти
	
#Область ТолькоПросмотрКППСубкомиссионера

	Элемент = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПокупателиКППСубкомиссионера.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Объект.Покупатели.ТолькоПросмотрКППСубкомиссионера");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
#КонецОбласти
	
#Область СубкомиссионерНеЮрлицоКППНеТребуется

	Элемент = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПокупателиКППСубкомиссионера.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Объект.Покупатели.КППНеТребуется");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста",     ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст",          НСтр("ru = '<не требуется>'"));
	
#КонецОбласти
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
