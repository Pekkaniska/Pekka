
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	МодификацияКонфигурацииПереопределяемый.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриСозданииЧтенииНаСервере();
	КонецЕсли;
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	ПриСозданииЧтенииНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура НематериальныйАктивПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.НематериальныйАктив) Тогда
		НематериальныйАктивПриИзмененииНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НематериальныйАктивПриИзмененииНаСервере()
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	НематериальныеАктивы.ГруппаНМАМеждународныйУчет.ПорядокУчета КАК ПорядокУчета
		|ИЗ
		|	Справочник.НематериальныеАктивы КАК НематериальныеАктивы
		|ГДЕ
		|	НематериальныеАктивы.Ссылка = &Ссылка"
	);
	
	Запрос.УстановитьПараметр("Ссылка", Объект.НематериальныйАктив);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		Объект.ПорядокУчета = Выборка.ПорядокУчета;
		ОбновитьДоступностьЭлементовФормы("ПорядокУчета");
		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПорядокУчетаПриИзменении(Элемент)
	
	ОбновитьДоступностьЭлементовФормы("ПорядокУчета");
	
КонецПроцедуры

&НаКлиенте
Процедура МетодНачисленияАмортизацииПриИзменении(Элемент)
	ОбновитьДоступностьЭлементовФормы("МетодНачисленияАмортизации");
КонецПроцедуры

&НаКлиенте
Процедура ПервоначальнаяСтоимостьПриИзменении(Элемент)
	
	Объект.ПервоначальнаяСтоимостьПредставления = Объект.ПервоначальнаяСтоимость * КоэффициентПересчетаВВалютуПредставления;
	
КонецПроцедуры

&НаКлиенте
Процедура ЛиквидационнаяСтоимостьПриИзменении(Элемент)
	
	Объект.ЛиквидационнаяСтоимостьПредставления = Объект.ЛиквидационнаяСтоимость * КоэффициентПересчетаВВалютуПредставления;
	
КонецПроцедуры

&НаКлиенте
Процедура НакопленнаяАмортиазцияПриИзменении(Элемент)
	
	Объект.НакопленнаяАмортизацияПредставления = Объект.НакопленнаяАмортизация * КоэффициентПересчетаВВалютуПредставления;
	
	ОбновитьДоступностьЭлементовФормы("НакопленнаяАмортиазция");
	
КонецПроцедуры

&НаКлиенте
Процедура НакопленнаяАмортизацияПредставленияПриИзменении(Элемент)
	
	ОбновитьДоступностьЭлементовФормы("НакопленнаяАмортиазция");
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяРасходовПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.СтатьяРасходов) Тогда
		СтатьяРасходовПриИзмененииНаСервере();
	Иначе
		АналитикаРасходовОбязательна = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СтатьяРасходовПриИзмененииНаСервере()
	
	АналитикаРасходовОбязательна = 
		ЗначениеЗаполнено(Объект.СтатьяРасходов)
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.СтатьяРасходов, "КонтролироватьЗаполнениеАналитики");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

#Область СтандартныеПодсистемы

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

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	ПланыВидовХарактеристик.СтатьиРасходов.УстановитьУсловноеОформлениеАналитик(УсловноеОформление);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	ВалютаФункциональная = Константы.ВалютаФункциональная.Получить();
	ВалютаПредставления = Константы.ВалютаПредставления.Получить();
	
	ШаблонДекорацииВалюты = НСтр("ru='(%Валюта%)'");
	ДекорацияВалютаФункциональная = СтрЗаменить(ШаблонДекорацииВалюты, "%Валюта%", ВалютаФункциональная);
	ДекорацияВалютаПредставления = СтрЗаменить(ШаблонДекорацииВалюты, "%Валюта%", ВалютаПредставления);
	
	КоэффициентПересчетаВВалютуПредставления = РаботаСКурсамивалютУТ.ПолучитьКоэффициентПересчетаИзВалютыВВалюту(
		ВалютаФункциональная,
		ВалютаПредставления,
		?(ЗначениеЗаполнено(Объект.Дата), Объект.Дата, ТекущаяДатаСеанса()));
	
	ОбновитьДоступностьЭлементовФормы();
	
	АналитикаРасходовОбязательна = 
		ЗначениеЗаполнено(Объект.СтатьяРасходов)
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.СтатьяРасходов, "КонтролироватьЗаполнениеАналитики");
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДоступностьЭлементовФормы(ИзмененныеРеквизиты=Неопределено)
	
	ОбновитьВсе = (ИзмененныеРеквизиты=Неопределено);
	Реквизиты = Новый Структура(ИзмененныеРеквизиты);
	
	Если ОбновитьВсе Или Реквизиты.Свойство("ПорядокУчета") Тогда
		
		НачислятьАмортизацию = (Объект.ПорядокУчета=Перечисления.ПорядокУчетаСтоимостиВнеоборотныхАктивов.НачислятьАмортизацию);
		Элементы.СтраницаАмортизация.Видимость = НачислятьАмортизацию;
		
	КонецЕсли;
	
	Если ОбновитьВсе Или Реквизиты.Свойство("ПорядокУчета") Или Реквизиты.Свойство("НакопленнаяАмортиазция") Тогда
		
		ТребуетсяУказатьСчетАмортизации = (
			Объект.ПорядокУчета = Перечисления.ПорядокУчетаСтоимостиВнеоборотныхАктивов.НачислятьАмортизацию
			Или Объект.НакопленнаяАмортизация <> 0
			Или Объект.НакопленнаяАмортизацияПредставления <> 0);
		
		Элементы.СчетАмортизации.АвтоОтметкаНезаполненного = ТребуетсяУказатьСчетАмортизации;
		Элементы.СчетАмортизации.ОтметкаНезаполненного = Не ЗначениеЗаполнено(Объект.СчетАмортизации) И ТребуетсяУказатьСчетАмортизации;
		
	КонецЕсли;
	
	Если ОбновитьВсе Или Реквизиты.Свойство("МетодНачисленияАмортизации") Тогда
		
		АмортизацияПоОбъемуПродукции = (Объект.МетодНачисленияАмортизации=Перечисления.СпособыНачисленияАмортизацииНМА.ПропорциональноОбъемуПродукции);
		Элементы.СрокИспользования.АвтоОтметкаНезаполненного = Не АмортизацияПоОбъемуПродукции;
		Элементы.СрокИспользования.ОтметкаНезаполненного = Не АмортизацияПоОбъемуПродукции;
		Элементы.ОбъемНаработки.Видимость = АмортизацияПоОбъемуПродукции;
		Элементы.КоэффициентУскорения.Видимость = (Объект.МетодНачисленияАмортизации=Перечисления.СпособыНачисленияАмортизацииНМА.УменьшаемогоОстатка)
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
