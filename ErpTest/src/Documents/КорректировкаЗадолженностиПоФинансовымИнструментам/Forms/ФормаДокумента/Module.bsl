
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	// Обработчик механизма "ВерсионированиеОбъектов"
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриСозданииЧтенииНаСервере();
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_КорректировкаЗадолженностиПоФинансовымИнструментам", ПараметрыЗаписи, Объект.Ссылка);
	
	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ПриСозданииЧтенииНаСервере();
	
	// Обработчик механизма "ДатыЗапретаИзменения"
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	СобытияФорм.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормКлиент.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	СобытияФормКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ХозяйственнаяОперацияПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(Объект.ХозяйственнаяОперация) Тогда
		Возврат;
	КонецЕсли;
	
	ОчиститьТабличнуюЧасть();
	
	СтруктураДокумента = Новый Структура("СтатьяРасходов, АналитикаРасходов, СтатьяДоходов, АналитикаДоходов,
		//++ НЕ УТ
		|СчетУчета, Субконто1, Субконто2, Субконто3,
		//-- НЕ УТ
		|АналитикаАктивовПассивов");
	ЗаполнитьЗначенияСвойств(Объект, СтруктураДокумента);
	
	АналитикаДоходовОбязательна = Ложь;
	АналитикаРасходовОбязательна = Ложь;
	
	ХозяйственнаяОперацияПриИзмененииСервер();
	
КонецПроцедуры

&НаСервере
Процедура ХозяйственнаяОперацияПриИзмененииСервер()
	
	ЗаполнитьРеквизитыПоСтатистике();
	ОпределитьТипСтатьи();
	УправлениеЭлементамиФормы();
	НастроитьЗависимыеЭлементыФормыНаСервере("ХозяйственнаяОперация, ТипСтатьи");
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОчиститьТабличнуюЧасть();
	
КонецПроцедуры

&НаКлиенте
Процедура ХарактерДоговораПриИзменении(Элемент)
	
	ОчиститьТабличнуюЧасть();
	
	Если Не ЗначениеЗаполнено(Объект.ХарактерДоговора) Тогда
		Объект.ХарактерДоговора = Элементы.ХарактерДоговора.СписокВыбора.Получить(0).Значение;
	КонецЕсли;
	
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ХарактерДоговораОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПартнерПриИзменении(Элемент)
	
	ОчиститьТабличнуюЧасть();
	ПартнерПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПартнерПриИзмененииНаСервере()
	
	ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Объект.Партнер, Объект.Контрагент);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	ОчиститьТабличнуюЧасть();
	
КонецПроцедуры

&НаКлиенте
Процедура ДоговорПриИзменении(Элемент)
	
	ОчиститьТабличнуюЧасть();
	ДоговорПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ДоговорПриИзмененииНаСервере()
	
	Объект.ВалютаВзаиморасчетов = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Договор, "ВалютаВзаиморасчетов");
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяДоходовПриИзменении(Элемент)
	
	СтатьяДоходовПриИзмененииСервер();
	
КонецПроцедуры

&НаСервере
Процедура СтатьяДоходовПриИзмененииСервер()
	
	Если ТипЗнч(Объект.СтатьяДоходов) = Тип("ПланВидовХарактеристикСсылка.СтатьиАктивовПассивов") Тогда
		Если ЗначениеЗаполнено(Объект.СтатьяДоходов) Тогда
			ДоходыИРасходыСервер.СтатьяАктивовПассивовПриИзменении(Объект, Объект.СтатьяДоходов, Объект.АналитикаАктивовПассивов);
		КонецЕсли;
		Объект.АналитикаДоходов = Неопределено;
		АналитикаДоходовОбязательна = Ложь;
	Иначе
		Если ЗначениеЗаполнено(Объект.СтатьяДоходов) Тогда
			ДоходыИРасходыСервер.СтатьяДоходовПриИзменении(Объект, Объект.СтатьяДоходов, Объект.Подразделение, Объект.АналитикаДоходов);
		КонецЕсли;
		АналитикаДоходовОбязательна = ЗначениеЗаполнено(Объект.СтатьяДоходов)
			И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.СтатьяДоходов, "КонтролироватьЗаполнениеАналитики");
		Объект.АналитикаАктивовПассивов = Неопределено;
	КонецЕсли;
	
	ОпределитьТипСтатьи();
	НастроитьЗависимыеЭлементыФормыНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяРасходовПриИзменении(Элемент)
	
	СтатьяРасходовПриИзмененииСервер();
	
КонецПроцедуры

&НаСервере
Процедура СтатьяРасходовПриИзмененииСервер()
	
	Если ТипЗнч(Объект.СтатьяРасходов) = Тип("ПланВидовХарактеристикСсылка.СтатьиАктивовПассивов") Тогда
		Если ЗначениеЗаполнено(Объект.СтатьяРасходов) Тогда
			ДоходыИРасходыСервер.СтатьяАктивовПассивовПриИзменении(Объект, Объект.СтатьяРасходов, Объект.АналитикаАктивовПассивов);
		КонецЕсли;
		Объект.АналитикаРасходов = Неопределено;
		АналитикаРасходовОбязательна = Ложь;
	Иначе
		Если ЗначениеЗаполнено(Объект.СтатьяРасходов) Тогда
			ДоходыИРасходыСервер.СтатьяРасходовПриИзменении(Объект, Объект.СтатьяРасходов, Объект.АналитикаРасходов);
		КонецЕсли;
		АналитикаРасходовОбязательна = ЗначениеЗаполнено(Объект.СтатьяРасходов)
			И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.СтатьяРасходов, "КонтролироватьЗаполнениеАналитики");
		Объект.АналитикаАктивовПассивов = Неопределено;
	КонецЕсли;
	
	ОпределитьТипСтатьи();
	НастроитьЗависимыеЭлементыФормыНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяДоходовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("СтатьяВыборЗавершение", ЭтотОбъект, Новый Структура("ТипСтатьи", 2));
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Статья", Объект.СтатьяДоходов);
	ПараметрыФормы.Вставить("ПараметрыВыбора", Элемент.ПараметрыВыбора);
	
	ОткрытьФорму("ОбщаяФорма.ФормаВыбораСтатьи", ПараметрыФормы, ЭтаФорма, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяРасходовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("СтатьяВыборЗавершение", ЭтотОбъект, Новый Структура("ТипСтатьи", 1));
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Статья", Объект.СтатьяРасходов);
	ПараметрыФормы.Вставить("ПараметрыВыбора", Элемент.ПараметрыВыбора);
	
	ОткрытьФорму("ОбщаяФорма.ФормаВыбораСтатьи", ПараметрыФормы, ЭтаФорма,,,, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяВыборЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеПараметры.ТипСтатьи = 1 Тогда
		Объект.СтатьяРасходов = Результат;
		Объект.АналитикаРасходов = Неопределено;
		СтатьяРасходовПриИзмененииСервер();
	ИначеЕсли ДополнительныеПараметры.ТипСтатьи = 2 Тогда
		Объект.СтатьяДоходов = Результат;
		Объект.АналитикаДоходов = Неопределено;
		СтатьяДоходовПриИзмененииСервер();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура АвтоТест_ЗаполнитьПоОстаткам(Команда) Экспорт
	
	СтруктураРеквизитов = Новый Структура;
	СтруктураРеквизитов.Вставить("Организация");
	СтруктураРеквизитов.Вставить("Контрагент");
	СтруктураРеквизитов.Вставить("ХозяйственнаяОперация", НСтр("ru = 'Списание'"));
	
	Оповещение = Новый ОписаниеОповещения("АвтоТест_ЗаполнитьПоОстаткамЗавершение", ЭтотОбъект);
	ОбщегоНазначенияУТКлиент.ПроверитьВозможностьЗаполненияТабличнойЧасти(
		Оповещение,
		ЭтаФорма,
		Объект.Задолженность,
		СтруктураРеквизитов);
	
КонецПроцедуры

&НаКлиенте
Процедура АвтоТест_ЗаполнитьПоОстаткамЗавершение(Результат, ДополнительныеПараметры) Экспорт 
	
	ЗаполнитьЗадолженностьПоОстаткамСервер();
	
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

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
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

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	ПланыВидовХарактеристик.СтатьиРасходов.УстановитьУсловноеОформлениеАналитик(УсловноеОформление);
	ПланыВидовХарактеристик.СтатьиДоходов.УстановитьУсловноеОформлениеАналитик(УсловноеОформление);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	НастройкиПолейФормы = Документы.КорректировкаЗадолженностиПоФинансовымИнструментам.НастройкиПолейФормы();
	ЗначениеВРеквизитФормы(НастройкиПолейФормы, "НастройкиПолей");
	ЗависимостиПолейФормы = ДенежныеСредстваСервер.ЗависимостиПолейФормы(НастройкиПолейФормы);
	ЗначениеВРеквизитФормы(ЗависимостиПолейФормы, "ЗависимостиПолей");
	
	ИспользуетсяРеглУчет = ПолучитьФункциональнуюОпцию("ИспользоватьРеглУчет");
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьУчетПрочихАктивовПассивов") Тогда
		Элементы.СтраницаРасходы.Заголовок = НСтр("ru = 'Расходы'");
		Элементы.СтраницаДоходы.Заголовок = НСтр("ru = 'Доходы'");
	КонецЕсли;
	
	СписокВыбораИнструмента = Элементы.ХарактерДоговора.СписокВыбора;
	СписокВыбораИнструмента.Очистить();
	Если ПолучитьФункциональнуюОпцию("ИспользоватьДоговорыКредитовИДепозитов") Тогда
		СписокВыбораИнструмента.Добавить(Перечисления.ХарактерыДоговоровФинансовыхИнструментов.КредитИлиЗайм);
		СписокВыбораИнструмента.Добавить(Перечисления.ХарактерыДоговоровФинансовыхИнструментов.Депозит);
		СписокВыбораИнструмента.Добавить(Перечисления.ХарактерыДоговоровФинансовыхИнструментов.ЗаймВыданный);
	КонецЕсли;
	//++ НЕ УТ
	Если ПолучитьФункциональнуюОпцию("ИспользоватьЛизинг") Тогда
		СписокВыбораИнструмента.Добавить(Перечисления.ХарактерыДоговоровФинансовыхИнструментов.Лизинг);
	КонецЕсли;
	//-- НЕ УТ
	
	ОпределитьТипСтатьи();
	
	УправлениеЭлементамиФормы();
	НастроитьЗависимыеЭлементыФормыНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура УправлениеЭлементамиФормы()
	
	Если Объект.ХарактерДоговора = Перечисления.ХарактерыДоговоровФинансовыхИнструментов.КредитИлиЗайм
		Или Объект.ХарактерДоговора = Перечисления.ХарактерыДоговоровФинансовыхИнструментов.Депозит
		Или Объект.ХарактерДоговора = Перечисления.ХарактерыДоговоровФинансовыхИнструментов.ЗаймВыданный Тогда
		
		Элементы.Договор.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.ДоговорыКредитовИДепозитов");
		Элементы.ЗадолженностьТипСуммы.ОграничениеТипа = Новый ОписаниеТипов("ПеречислениеСсылка.ТипыСуммГрафикаКредитовИДепозитов");
	//++ НЕ УТ
	ИначеЕсли Объект.ХарактерДоговора = Перечисления.ХарактерыДоговоровФинансовыхИнструментов.Лизинг Тогда
		Элементы.Договор.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.ДоговорыЛизинга");
		Элементы.ЗадолженностьТипСуммы.ОграничениеТипа = Новый ОписаниеТипов("ПеречислениеСсылка.ТипыПлатежейПоЛизингу");
	//-- НЕ УТ
	КонецЕсли;
	
	ПараметрыВыбораТипаСуммы = Новый Массив;
	ПараметрыВыбораТипаСуммы.Добавить(Новый ПараметрВыбора("Отбор.Договор", Объект.Договор));
	ПараметрыВыбораТипаСуммы.Добавить(Новый ПараметрВыбора("КорректировкаЗадолженности", Истина));
	Элементы.ЗадолженностьТипСуммы.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбораТипаСуммы);
	
	АналитикаДоходовОбязательна      = Ложь;
	АналитикаРасходовОбязательна     = Ложь;
	
	Если ЗначениеЗаполнено(Объект.СтатьяРасходов)
		И ТипЗнч(Объект.СтатьяРасходов) = Тип("ПланВидовХарактеристикСсылка.СтатьиРасходов") Тогда
		АналитикаДоходовОбязательна = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.СтатьяРасходов, "КонтролироватьЗаполнениеАналитики");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.СтатьяДоходов) 
		И ТипЗнч(Объект.СтатьяДоходов) = Тип("ПланВидовХарактеристикСсылка.СтатьиДоходов") Тогда
		АналитикаДоходовОбязательна = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.СтатьяДоходов, "КонтролироватьЗаполнениеАналитики");
	КонецЕсли;
	
	//++ НЕ УТ
	Элементы.РасходыНастроитьОтражениеВРеглУчете.Заголовок = РеглУчетВызовСервера.ПредставлениеОтраженияВРеглУчете(Объект);
	Элементы.ДоходыНастроитьОтражениеВРеглУчете.Заголовок = РеглУчетВызовСервера.ПредставлениеОтраженияВРеглУчете(Объект);
	//-- НЕ УТ
	
	Элементы.ЗадолженностьСумма.Заголовок = НСтр("ru='Сумма'") + " (" + Строка(Объект.ВалютаВзаиморасчетов) + ")";
	
КонецПроцедуры

&НаСервере
Процедура ОпределитьТипСтатьи()
	
	Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.СписаниеДебиторскойЗадолженности Тогда
		Если ТипЗнч(Объект.СтатьяРасходов) = Тип("ПланВидовХарактеристикСсылка.СтатьиАктивовПассивов") Тогда
			ТипСтатьи = 3;
		Иначе
			ТипСтатьи = 1;
		КонецЕсли;
	Иначе
		Если ТипЗнч(Объект.СтатьяДоходов) = Тип("ПланВидовХарактеристикСсылка.СтатьиАктивовПассивов") Тогда
			ТипСтатьи = 3;
		Иначе
			ТипСтатьи = 2;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьТабличнуюЧасть()
	
	Если Объект.Задолженность.Количество() Тогда
		ТекстВопроса = НСтр("ru='Суммы корректировки задолженности могут стать неактуальными.
			|Очистить список задолженности?'");
		ПоказатьВопрос(
			Новый ОписаниеОповещения("ОчиститьТабличнуюЧастьЗавершение", ЭтотОбъект),
			ТекстВопроса,
			РежимДиалогаВопрос.ДаНет);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьТабличнуюЧастьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Объект.Задолженность.Очистить();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЗадолженностьПоОстаткамСервер()
	
	Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.СписаниеКредиторскойЗадолженности Тогда
		ТипЗадолженности = Перечисления.ТипыЗадолженности.Кредиторская;
	Иначе
		ТипЗадолженности = Перечисления.ТипыЗадолженности.Дебиторская;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	Расчеты.ТипСуммы КАК ТипСуммы,
	|	-Расчеты.СуммаОстаток КАК Сумма
	|ИЗ
	|	РегистрНакопления.РасчетыПоФинансовымИнструментам.Остатки(, Договор = &Договор) КАК Расчеты
	|ГДЕ
	|	Расчеты.СуммаОстаток < 0
	|	И &ТипЗадолженности = ЗНАЧЕНИЕ(Перечисление.ТипыЗадолженности.Кредиторская)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Расчеты.ТипСуммы,
	|	Расчеты.СуммаОстаток
	|ИЗ
	|	РегистрНакопления.РасчетыПоФинансовымИнструментам.Остатки(, Договор = &Договор) КАК Расчеты
	|ГДЕ
	|	Расчеты.СуммаОстаток > 0
	|	И &ТипЗадолженности = ЗНАЧЕНИЕ(Перечисление.ТипыЗадолженности.Дебиторская)
	|";
	
	Запрос.УстановитьПараметр("Договор", Объект.Договор);
	Запрос.УстановитьПараметр("ТипЗадолженности", ТипЗадолженности);
	
	Объект.Задолженность.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьОтражениеВРеглУчете(Команда)
	
	//++ НЕ УТ
	ИмяЭлементаКоманды = ?(Элементы.СтраницаРасходы.Видимость, "РасходыНастроитьОтражениеВРеглУчете", "ДоходыНастроитьОтражениеВРеглУчете");
	ДопПараметры = Новый Структура("ИмяЭлементаКоманды", ИмяЭлементаКоманды);
	РеглУчетКлиент.ОткрытьНастройкуОтраженияВРеглУчетеАктиваПассива(ЭтаФорма,,, ДопПараметры);
	//-- НЕ УТ
	Возврат;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыПоСтатистике()
	
	Если Не ЗначениеЗаполнено(Объект.Организация)
		Или Не ЗначениеЗаполнено(Объект.Контрагент)
		Или Не ЗначениеЗаполнено(Объект.ХозяйственнаяОперация) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ДанныеДокумента.АналитикаАктивовПассивов,
	//++ НЕ УТ
	|	ДанныеДокумента.СчетУчета,
	|	ДанныеДокумента.Субконто1,
	|	ДанныеДокумента.Субконто2,
	|	ДанныеДокумента.Субконто3,
	//-- НЕ УТ
	|	ДанныеДокумента.СтатьяРасходов,
	|	ДанныеДокумента.АналитикаРасходов,
	|	ДанныеДокумента.СтатьяДоходов,
	|	ДанныеДокумента.АналитикаДоходов,
	|	ДанныеДокумента.Подразделение
	|ИЗ
	|	Документ.КорректировкаЗадолженностиПоФинансовымИнструментам КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Проведен
	|	И ДанныеДокумента.Организация = &Организация
	|	И ДанныеДокумента.ХозяйственнаяОперация = &ХозяйственнаяОперация
	|	И ДанныеДокумента.Контрагент = &Контрагент
	|	И ДанныеДокумента.Дата <= &Дата
	|	И ДанныеДокумента.Ссылка <> &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата УБЫВ
	|";
	
	Запрос.УстановитьПараметр("Ссылка",                    Объект.Ссылка);
	Запрос.УстановитьПараметр("Дата",                      КонецДня(Объект.Дата));
	Запрос.УстановитьПараметр("Контрагент",                Объект.Контрагент);
	Запрос.УстановитьПараметр("Организация",               Объект.Организация);
	Запрос.УстановитьПараметр("ХозяйственнаяОперация",     Объект.ХозяйственнаяОперация);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(Объект, Выборка);
		НастроитьЗависимыеЭлементыФормыНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьЗависимыеЭлементыФормыНаСервере(ИзмененныйРеквизит = "")
	
	ДенежныеСредстваКлиентСервер.НастроитьЭлементыФормы(ЭтаФорма, ИзмененныйРеквизит, РеквизитыФормы(ЭтаФорма));
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция РеквизитыФормы(Форма)
	
	РеквизитыФормы = Новый Структура;
	РеквизитыФормы.Вставить("ТипСтатьи");
	РеквизитыФормы.Вставить("ИспользуетсяРеглУчет");
	
	ЗаполнитьЗначенияСвойств(РеквизитыФормы, Форма);
	
	Возврат РеквизитыФормы;
	
КонецФункции

#КонецОбласти
