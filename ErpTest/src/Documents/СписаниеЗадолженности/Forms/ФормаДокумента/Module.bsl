
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
	
	
	ТипРасчетовРасчетыСКлиентом = Перечисления.ТипыРасчетовСПартнерами.РасчетыСКлиентом;
	ТипСсылкаКонтрагенты = Новый ОписаниеТипов("СправочникСсылка.Контрагенты");
	ТипСсылкаОрганизации = Новый ОписаниеТипов("СправочникСсылка.Организации");
	
	УстановитьВидимостьПолей();
	УстановитьТипКонтрагента();
	УстановитьВидимостьСтраницПодвала();
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриСозданииЧтенииНаСервере();
		Если Объект.СтатьяРасходов = Неопределено Тогда
			Объект.СтатьяРасходов = ПланыВидовХарактеристик.СтатьиРасходов.ПустаяСсылка();
		КонецЕсли;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
//+++rarus-spb_pavelk
	Если НЕ ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(ЭтаФорма, "НеВыполнятьПроверкуПередЗаписью") Тогда
		НовыйРеквизит = Новый РеквизитФормы("НеВыполнятьПроверкуПередЗаписью", Новый ОписаниеТипов("Булево"));
		ДобавляемыеРеквизиты	= Новый Массив;
		ДобавляемыеРеквизиты.Добавить(НовыйРеквизит);
		ИзменитьРеквизиты(ДобавляемыеРеквизиты);
	КонецЕсли;	
//---rarus-spb_pavelk	

КонецПроцедуры

&НаКлиенте
Процедура  ПослеЗаписи(ПараметрыЗаписи)

	Оповестить("Запись_СписаниеЗадолженности", ПараметрыЗаписи, Объект.Ссылка);

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
	//+++rarus-spb_pavelk
	ПроверитьДокументОперация(ЭтотОбъект, Отказ, ПараметрыЗаписи);
	//---rarus-spb_pavelk

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
Процедура РасчетыМеждуОрганизациямиПриИзменении(Элемент)
	РасчетыМеждуОрганизациямиПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	ЕстьСтроки = Объект.Задолженность.Количество()>0;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ЕстьСтроки", ЕстьСтроки);
	
	НужноОчищатьТЧ(
		Новый ОписаниеОповещения("КонтрагентПриИзмененииНужноТЧОчищатьВопросЗавершение", ЭтотОбъект, ДополнительныеПараметры),
		ЕстьСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзмененииНужноТЧОчищатьВопросЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	
	ЗаполнитьПартнера(ДополнительныеПараметры.ЕстьСтроки, Ответ = КодВозвратаДиалога.Да);
	
КонецПроцедуры

&НаКлиенте
Процедура ХозяйственнаяОперацияПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(Объект.ХозяйственнаяОперация) Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураДокумента = Новый Структура("СтатьяРасходов, АналитикаРасходов, СтатьяДоходов, АналитикаДоходов,
		|АналитикаАктивовПассивов, АналитикаДоходовОбязательна, АналитикаРасходовОбязательна, АналитикаРасходовЗаказРеализация");
	ЗаполнитьЗначенияСвойств(Объект, СтруктураДокумента);
	
	ХозяйственнаяОперацияПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяДоходовПриИзменении(Элемент)
	
	ФинансыКлиент.СтатьяДоходовПриИзменении(Объект, Элементы);
	СтатьяДоходовПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяРасходовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДополнительныеПараметры = Новый Структура;
	ОписаниеОповещения = Новый ОписаниеОповещения("СтатьяВыборЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Статья", Объект.СтатьяРасходов);
	ПараметрыФормы.Вставить("ПараметрыВыбора", Элемент.ПараметрыВыбора);
	
	ОткрытьФорму("ОбщаяФорма.ФормаВыбораСтатьи", ПараметрыФормы, ЭтаФорма, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяРасходовПриИзменении(Элемент)
	
	СтатьяРасходовПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяДоходовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДополнительныеПараметры = Новый Структура;
	ОписаниеОповещения = Новый ОписаниеОповещения("СтатьяВыборЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Статья", Объект.СтатьяДоходов);
	ПараметрыФормы.Вставить("ПараметрыВыбора", Элемент.ПараметрыВыбора);
	
	ОткрытьФорму("ОбщаяФорма.ФормаВыбораСтатьи", ПараметрыФормы, ЭтаФорма, , , , ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЗадолженность

&НаКлиенте
Процедура ЗадолженностьПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	СтрокаТаблицы = Элементы.Задолженность.ТекущиеДанные;
	
	Если НоваяСтрока И Не Копирование Тогда
		
		Если Не ЗначениеЗаполнено(Партнер) Тогда
			ЗаполнитьПартнера();
		КонецЕсли;
		
		СтрокаТаблицы.Партнер = Партнер;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадолженностьТипРасчетовПриИзменении(Элемент)
	СтрокаТаблицы = Элементы.Задолженность.ТекущиеДанные;
	СтрокаТаблицы.Заказ = Неопределено;
КонецПроцедуры

&НаКлиенте
Процедура ЗадолженностьЗаказНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтрокаТаблицы = Элементы.Задолженность.ТекущиеДанные;
	
	ЗначенияОтбора = Новый Структура;
	ЗначенияОтбора.Вставить("Организация", Объект.Организация);
	ЗначенияОтбора.Вставить("Контрагент",  Объект.Контрагент);
	Если ТипЗнч(Объект.Контрагент) = Тип("СправочникСсылка.Организации") Тогда
		ЗначенияОтбора.Вставить("ЭтоИнтеркампани", Истина);
	Иначе
		ЗначенияОтбора.Вставить("Партнер", СтрокаТаблицы.Партнер);
	КонецЕсли;
	
	НастройкиВыбора = ФинансыКлиент.ПараметрыВыбораДокументаРасчетов();
	НастройкиВыбора.РедактируемыйДокумент = Объект.Ссылка;
	НастройкиВыбора.ЭтоРасчетыСКлиентами = (СтрокаТаблицы.ТипРасчетов = ТипРасчетовРасчетыСКлиентом);
	
	ФинансыКлиент.ДокументРасчетовНачалоВыбора(ЗначенияОтбора, НастройкиВыбора, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадолженностьЗаказОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СтрокаТаблицы = Элементы.Задолженность.ТекущиеДанные;	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(СтрокаТаблицы, ВыбранноеЗначение);
		Модифицированность = Истина;
		УстановитьВидимостьСтраницПодвала();
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Функция используется в автотесте процесса продаж.
//
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
	
	ИспользуетсяРеглУчет = ПолучитьФункциональнуюОпцию("ИспользоватьРеглУчет");
	
	АналитикаРасходовОбязательна = Ложь;
	АналитикаРасходовЗаказРеализация = Ложь;
	АналитикаДоходовОбязательна = Ложь;
	
	Если ЗначениеЗаполнено(Объект.СтатьяРасходов) 
		 И ТипЗнч(Объект.СтатьяРасходов) = Тип("ПланВидовХарактеристикСсылка.СтатьиРасходов") Тогда
		 
		Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.СтатьяРасходов, "КонтролироватьЗаполнениеАналитики, АналитикаРасходовЗаказРеализация"); 
		АналитикаРасходовОбязательна = Реквизиты.КонтролироватьЗаполнениеАналитики;
		АналитикаРасходовЗаказРеализация = Реквизиты.АналитикаРасходовЗаказРеализация;
		
	КонецЕсли;
		
	Если ЗначениеЗаполнено(Объект.СтатьяДоходов) 
		И ТипЗнч(Объект.СтатьяДоходов) = Тип("ПланВидовХарактеристикСсылка.СтатьиДоходов") Тогда
		АналитикаДоходовОбязательна = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.СтатьяДоходов, "КонтролироватьЗаполнениеАналитики");
	КонецЕсли;
	
	УстановитьВидимостьПолей();
	УстановитьТипКонтрагента();
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьУчетПрочихАктивовПассивов") Тогда
		Элементы.СтраницаРасходы.Заголовок = НСтр("ru = 'Расходы'");
		Элементы.СтраницаДоходы.Заголовок = НСтр("ru = 'Доходы'");
	КонецЕсли;
	
	//++ НЕ УТ
	Элементы.РасходыНастроитьОтражениеВРеглУчете.Заголовок = РеглУчетВызовСервера.ПредставлениеОтраженияВРеглУчете(Объект);
	Элементы.ДоходыНастроитьОтражениеВРеглУчете.Заголовок = РеглУчетВызовСервера.ПредставлениеОтраженияВРеглУчете(Объект);
	//-- НЕ УТ
	
КонецПроцедуры

#Область ПриИзмененииРеквизитов

&НаСервере
Процедура ХозяйственнаяОперацияПриИзмененииСервер()
	
	ЗаполнитьРеквизитыПоСтатистике();
	
	УстановитьВидимостьПолей();
	
КонецПроцедуры

&НаСервере
Процедура РасчетыМеждуОрганизациямиПриИзмененииНаСервере()
	
	УстановитьТипКонтрагента();
	ЗаполнитьРеквизитыПоСтатистике();
	
КонецПроцедуры

&НаСервере
Процедура СтатьяДоходовПриИзмененииСервер()
	
	Если ТипЗнч(Объект.СтатьяДоходов) = Тип("ПланВидовХарактеристикСсылка.СтатьиАктивовПассивов") Тогда
		
		ДоходыИРасходыСервер.СтатьяАктивовПассивовПриИзменении(
			Объект,
			Объект.СтатьяДоходов,
			Объект.АналитикаАктивовПассивов);
			
		Объект.АналитикаДоходов = Неопределено;
		АналитикаДоходовОбязательна = Ложь;
		
	Иначе
	
		Если Не ЗначениеЗаполнено(Объект.АналитикаДоходов) Тогда
			Объект.АналитикаДоходов = ПланыВидовХарактеристик.СтатьиДоходов.ПолучитьАналитикуДоходовПоУмолчанию(
				Объект.СтатьяДоходов,
				Объект,
				Объект.Подразделение);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Объект.СтатьяДоходов) Тогда
			АналитикаДоходовОбязательна = 
				ЗначениеЗаполнено(Объект.СтатьяДоходов)
				И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.СтатьяДоходов, "КонтролироватьЗаполнениеАналитики");
		Иначе
			АналитикаДоходовОбязательна = Ложь;
		КонецЕсли;
		
		Объект.АналитикаАктивовПассивов = Неопределено;
		
	КонецЕсли;
	
	УстановитьВидимостьПолей();
	
КонецПроцедуры

&НаСервере
Процедура СтатьяРасходовПриИзмененииСервер()
	
	Если ТипЗнч(Объект.СтатьяРасходов) = Тип("ПланВидовХарактеристикСсылка.СтатьиАктивовПассивов") Тогда
		
		ДоходыИРасходыСервер.СтатьяАктивовПассивовПриИзменении(
			Объект,
			Объект.СтатьяРасходов,
			Объект.АналитикаАктивовПассивов);
			
		Объект.АналитикаРасходов = Неопределено;
		АналитикаРасходовОбязательна = Ложь;
		АналитикаРасходовЗаказРеализация = Ложь;
		
	Иначе
		
		ДоходыИРасходыСервер.СтатьяРасходовПриИзменении(
			Объект,
			Объект.СтатьяРасходов,
			Объект.АналитикаРасходов);
		
		АналитикаРасходовОбязательна = 
			ЗначениеЗаполнено(Объект.СтатьяРасходов)
			И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.СтатьяРасходов, "КонтролироватьЗаполнениеАналитики");
		
		АналитикаРасходовЗаказРеализация = 
			ЗначениеЗаполнено(Объект.СтатьяРасходов)
			И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.СтатьяРасходов, "АналитикаРасходовЗаказРеализация");
		
		Объект.АналитикаАктивовПассивов = Неопределено;
		
	КонецЕсли;
	
	УстановитьВидимостьПолей();
	
КонецПроцедуры

#КонецОбласти

#Область Заполнение

&НаСервере
Процедура ЗаполнитьПартнера(ЗаполнятьТЧ = Ложь, ОчиститьТЧ = Ложь)

	Если ЗначениеЗаполнено(Объект.Контрагент) Тогда
		Партнер = ДенежныеСредстваСервер.ПолучитьПартнераПоКонтрагенту(Объект.Контрагент);
	КонецЕсли;
	Если ЗаполнятьТЧ Тогда
		Если ОчиститьТЧ Тогда
			Объект.Задолженность.Очистить();
		Иначе
			ЗаполнитьПартнераВТабличнойЧасти(Объект.Задолженность, Партнер, Объект.РасчетыМеждуОрганизациями);
		КонецЕсли;
	КонецЕсли;
	
	ЗаполнитьРеквизитыПоСтатистике();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПартнераВТабличнойЧасти(ОбъектТабличнаяЧасть, ПартнерСсылка, РасчетыМеждуОрганизациями)
	Для Каждого СтрокаТаблицы Из ОбъектТабличнаяЧасть Цикл
		Если РасчетыМеждуОрганизациями Тогда
			СтрокаТаблицы.Партнер = Неопределено;
		ИначеЕсли Не ЗначениеЗаполнено(СтрокаТаблицы.Партнер) Тогда
			СтрокаТаблицы.Партнер = ПартнерСсылка;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЗадолженностьПоОстаткамСервер()
	
	Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.СписаниеКредиторскойЗадолженности Тогда
		ТипЗадолженности = Перечисления.ТипыЗадолженности.Кредиторская;
	Иначе
		ТипЗадолженности = Перечисления.ТипыЗадолженности.Дебиторская;
	КонецЕсли;
	
	ВзаиморасчетыСервер.ЗаполнитьЗадолженностьПоОстаткам(
		Объект.Организация, 
		Объект.Контрагент,
		ТипЗадолженности, 
		Неопределено, //ТипРасчетов
		Объект.Дата,
		Неопределено, // Валюта,
		Объект.Задолженность);
	
КонецПроцедуры

#КонецОбласти

#Область УправлениеЭлементамиФормы

&НаСервере
Процедура УстановитьТипКонтрагента()
	Элементы.Контрагент.ОграничениеТипа = ?(Объект.РасчетыМеждуОрганизациями,ТипСсылкаОрганизации,ТипСсылкаКонтрагенты);
	Элементы.ЗадолженностьПартнер.Видимость = Не Объект.РасчетыМеждуОрганизациями;
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьПолей()
	
	Элементы.СтраницаРасходы.Видимость = Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.СписаниеДебиторскойЗадолженности;
	Элементы.СтраницаДоходы.Видимость = Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.СписаниеКредиторскойЗадолженности;
	
	НаСтатьиАктивовПассивов = (ТипЗнч(Объект.СтатьяРасходов) = Тип("ПланВидовХарактеристикСсылка.СтатьиАктивовПассивов")
		ИЛИ ТипЗнч(Объект.СтатьяДоходов) = Тип("ПланВидовХарактеристикСсылка.СтатьиАктивовПассивов"));
	Элементы.АналитикаРасходов.Видимость = НЕ НаСтатьиАктивовПассивов;
	Элементы.АналитикаДоходов.Видимость	 = НЕ НаСтатьиАктивовПассивов;
	Элементы.РасходыАналитикаАктивовПассивов.Видимость  = НаСтатьиАктивовПассивов;
	Элементы.ДоходыАналитикаАктивовПассивов.Видимость	= НаСтатьиАктивовПассивов;
	ПравоНаНастройку = Ложь;
	//++ НЕ УТ
	ПравоНаНастройку = ПравоДоступа("Просмотр", Метаданные.ОбщиеФормы.НастройкаОтраженияВРеглУчетеПрочегоАктиваПассива);
	//-- НЕ УТ
	Элементы.ГруппаРасходыОтражениеВРеглУчете.Видимость = ИспользуетсяРеглУчет И НаСтатьиАктивовПассивов И ПравоНаНастройку;
	Элементы.ГруппаДоходыОтражениеВРеглУчете.Видимость 	= ИспользуетсяРеглУчет И НаСтатьиАктивовПассивов И ПравоНаНастройку;
	
	Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.СписаниеКредиторскойЗадолженности Тогда
		Элементы.ЗаголовокКонтрагент.Заголовок = НСтр("ru = 'Кредитор:'");
	Иначе
		Элементы.ЗаголовокКонтрагент.Заголовок = НСтр("ru = 'Дебитор:'");
	КонецЕсли;
	
	Элементы.АналитикаРасходов.Доступность = ЗначениеЗаполнено(Объект.СтатьяРасходов);
	Элементы.РасходыАналитикаАктивовПассивов.Доступность = ЗначениеЗаполнено(Объект.СтатьяРасходов)
		 И Не ТипЗнч(Объект.АналитикаАктивовПассивов) = Тип("ПеречислениеСсылка.СтатьиБезАналитики");
	Элементы.АналитикаДоходов.Доступность = ЗначениеЗаполнено(Объект.СтатьяДоходов);
	Элементы.ДоходыАналитикаАктивовПассивов.Доступность = ЗначениеЗаполнено(Объект.СтатьяДоходов)
		 И Не ТипЗнч(Объект.АналитикаАктивовПассивов) = Тип("ПеречислениеСсылка.СтатьиБезАналитики");
	Элементы.АналитикаРасходов.ОграничениеТипа = Новый ОписаниеТипов(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ТипЗнч(Объект.АналитикаРасходов)));
	Элементы.РасходыАналитикаАктивовПассивов.ОграничениеТипа = Новый ОписаниеТипов(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ТипЗнч(Объект.АналитикаАктивовПассивов)));
	Элементы.АналитикаДоходов.ОграничениеТипа = Новый ОписаниеТипов(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ТипЗнч(Объект.АналитикаДоходов)));
	Элементы.ДоходыАналитикаАктивовПассивов.ОграничениеТипа = Новый ОписаниеТипов(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ТипЗнч(Объект.АналитикаАктивовПассивов)));
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаКлиенте
Процедура НужноОчищатьТЧ(ОписаниеОповещения, ЕстьСтроки)
	
	Если ЕстьСтроки Тогда
		
		ТекстВопроса = НСтр("ru='Суммы списания задолженности могут стать неактуальным.
		                        |Очистить список задолженности?'");
		ПоказатьВопрос(
			ОписаниеОповещения,
			ТекстВопроса,
			РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, КодВозвратаДиалога.Нет);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура НастроитьОтражениеВРеглУчете(Команда)
	
	//++ НЕ УТ
	ИмяЭлементаКоманды = ?(Элементы.СтраницаРасходы.Видимость, "РасходыНастроитьОтражениеВРеглУчете", "ДоходыНастроитьОтражениеВРеглУчете");
	ДопПараметры = Новый Структура("ИмяЭлементаКоманды", ИмяЭлементаКоманды);
	РеглУчетКлиент.ОткрытьНастройкуОтраженияВРеглУчетеАктиваПассива(ЭтаФорма,,, ДопПараметры);
	//-- НЕ УТ
	Возврат;
	
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если АналитикаРасходовЗаказРеализация Тогда
		ПродажиКлиент.НачалоВыбораАналитикиРасходов(Элемент, СтандартнаяОбработка);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		Объект.АналитикаРасходов = ВыбранноеЗначение.АналитикаРасходов;
		СтандартнаяОбработка = Ложь;
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		АналитикаРасходовПолучениеДанныхВыбора(ДанныеВыбора, Текст);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		АналитикаРасходовПолучениеДанныхВыбора(ДанныеВыбора, Текст);
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Процедура АналитикаРасходовПолучениеДанныхВыбора(ДанныеВыбора, Текст)
	
	ДанныеВыбора = Новый СписокЗначений;
	ПродажиСервер.ЗаполнитьДанныеВыбораАналитикиРасходов(ДанныеВыбора, Текст);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыПоСтатистике()
	
	Если Не ЗначениеЗаполнено(Объект.Организация)
		Или Не ЗначениеЗаполнено(Объект.Контрагент)
		Или Не ЗначениеЗаполнено(Объект.ХозяйственнаяОперация) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	СписаниеЗадолженности.Дата КАК Дата,
	|	СписаниеЗадолженности.АналитикаАктивовПассивов,
	|	СписаниеЗадолженности.СчетУчета,
	|	СписаниеЗадолженности.Субконто1,
	|	СписаниеЗадолженности.Субконто2,
	|	СписаниеЗадолженности.Субконто3,
	|	СписаниеЗадолженности.СтатьяРасходов,
	|	СписаниеЗадолженности.АналитикаРасходов,
	|	СписаниеЗадолженности.СтатьяДоходов,
	|	СписаниеЗадолженности.АналитикаДоходов,
	|	СписаниеЗадолженности.Подразделение
	|ИЗ
	|	Документ.СписаниеЗадолженности КАК СписаниеЗадолженности
	|ГДЕ
	|	СписаниеЗадолженности.Проведен
	|	И СписаниеЗадолженности.Организация = &Организация
	|	И СписаниеЗадолженности.ХозяйственнаяОперация = &ХозяйственнаяОперация
	|	И СписаниеЗадолженности.РасчетыМеждуОрганизациями = &РасчетыМеждуОрганизациями
	|	И СписаниеЗадолженности.Контрагент = &Контрагент
	|	И СписаниеЗадолженности.Дата <= &Дата
	|	И СписаниеЗадолженности.Ссылка <> &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата УБЫВ";
	
	Запрос.УстановитьПараметр("Ссылка",                    Объект.Ссылка);
	Запрос.УстановитьПараметр("Дата",                      КонецДня(Объект.Дата));
	Запрос.УстановитьПараметр("Контрагент",                Объект.Контрагент);
	Запрос.УстановитьПараметр("Организация",               Объект.Организация);
	Запрос.УстановитьПараметр("РасчетыМеждуОрганизациями", Объект.РасчетыМеждуОрганизациями);
	Запрос.УстановитьПараметр("ХозяйственнаяОперация",     Объект.ХозяйственнаяОперация);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(Объект, Выборка, "СтатьяРасходов, АналитикаРасходов, СтатьяДоходов,
			|АналитикаДоходов, АналитикаАктивовПассивов, СчетУчета, Субконто1, Субконто2, Субконто3");
		УстановитьВидимостьПолей();
	КонецЕсли;;
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяВыборЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Элементы.СтраницаРасходы.Видимость Тогда
		Объект.СтатьяРасходов = Результат;
		Объект.АналитикаРасходов = Неопределено;
		СтатьяРасходовПриИзмененииСервер();
	ИначеЕсли Элементы.СтраницаДоходы.Видимость Тогда
		Объект.СтатьяДоходов = Результат;
		Объект.АналитикаДоходов = Неопределено;
		СтатьяДоходовПриИзмененииСервер();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьСтраницПодвала()
	
	ВалютаВзаиморасчетов = Неопределено;
	Мультивалютный = Ложь;
	
	Для Каждого Стр Из Объект.Задолженность Цикл
		
		Если ВалютаВзаиморасчетов <> Неопределено И ВалютаВзаиморасчетов <> Стр.ВалютаВзаиморасчетов Тогда
			Мультивалютный = Истина;
			Прервать;
		КонецЕсли;
		ВалютаВзаиморасчетов = Стр.ВалютаВзаиморасчетов;
		
	КонецЦикла;
	
	Если Мультивалютный Тогда
		Элементы.ГруппаПодвал.ТекущаяСтраница = Элементы.ГруппаМультивалютное;
	Иначе
		Элементы.ГруппаПодвал.ТекущаяСтраница = Элементы.ГруппаПоДокументу;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадолженностьПослеУдаления(Элемент)
	УстановитьВидимостьСтраницПодвала();
КонецПроцедуры

&НаКлиенте
Процедура ЗадолженностьВалютаВзаиморасчетовПриИзменении(Элемент)
	УстановитьВидимостьСтраницПодвала();
КонецПроцедуры

#КонецОбласти

//+++rarus-spb_pavelk
&НаКлиенте
Процедура ПроверитьДокументОперация(Форма, Отказ, ПараметрыЗаписи)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если ПараметрыЗаписи.РежимЗаписи <> РежимЗаписиДокумента.ОтменаПроведения Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(Форма, "НеВыполнятьПроверкуПередЗаписью")
		И Форма.НеВыполнятьПроверкуПередЗаписью Тогда
		Форма.НеВыполнятьПроверкуПередЗаписью = Ложь;
		Возврат;
	КонецЕсли;
	
	Если СформированаРучнаяОперация(Объект.Ссылка) Тогда
	
		Отказ = Истина;
		
		ДополнительныеПараметрыОповещения = Новый Структура("Форма, ПараметрыЗаписи", Форма, ПараметрыЗаписи);
		ОписаниеОповещения = Новый ОписаниеОповещения("ОбработчикОповещенияВопросПередУдалением", ЭтотОбъект, ДополнительныеПараметрыОповещения);
		ТекстВопроса = НСтр("ru = 'По документу списания сформмирована ручная операция. Продолжить?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
			
	КонецЕсли;
		
КонецПроцедуры

&НаСервереБезКонтекста
Функция СформированаРучнаяОперация(Ссылка)
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	ОперацияБухЗаполнениеДвижений.Ссылка
	|ИЗ
	|	Документ.ОперацияБух.ЗаполнениеДвижений КАК ОперацияБухЗаполнениеДвижений
	|ГДЕ
	|	ОперацияБухЗаполнениеДвижений.Документ = &Документ");
	Запрос.УстановитьПараметр("Документ",Ссылка);
	Результат = Запрос.Выполнить();
	
	Возврат НЕ Результат.Пустой();
	
КонецФункции	
//---rarus-spb_pavelk
