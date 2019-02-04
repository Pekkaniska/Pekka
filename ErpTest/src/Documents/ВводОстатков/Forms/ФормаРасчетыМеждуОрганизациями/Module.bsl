
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	ВалютаУправленческогоУчета = Константы.ВалютаУправленческогоУчета.Получить();
	ИспользоватьНесколькоВалют = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВалют");
	Элементы.ГруппаПрефикс.Видимость = 
		(Объект.ТипОперации <> Перечисления.ТипыОперацийВводаОстатков.ОстаткиРасчетовМеждуОрганизациямиПоАвансам);
		
	Элементы.ГруппаВводОстатковПо.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьРеглУчет");
	
	ЗаполнитьСпискиВыбораТипаРасчетов();
	
	УстановитьЗаголовок();
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда 
		ПриСозданииЧтенииНаСервере();
	КонецЕсли;

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

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
	
	ПриСозданииЧтенииНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ЗаполнитьТипОбъектаРасчетов();
	УстановитьЗаголовок();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПараметрыЗаписи.Вставить("ТипОперации", Объект.ТипОперации);
	Оповестить("Запись_ВводОстатков", ПараметрыЗаписи, Объект.Ссылка);
	
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
Процедура ДополнятьНомераПриИзменении(Элемент)
	
	Элементы.Префикс.Доступность = Объект.ДополнятьНомера;
	Если НЕ ЗначениеЗаполнено(Объект.Префикс) И Объект.ДополнятьНомера Тогда
		Объект.Префикс = СформироватьПрефикс(Объект.Организация);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПродавецПриИзменении(Элемент)

	Объект.Префикс = СформироватьПрефикс(Объект.Организация);
	МассивПараметров = ПолучитьПараметрыВыбораОрганизацииПолучателя(Объект.ОрганизацияПолучатель);
	Элементы.Покупатель.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
	ПроверитьИОчиститьОрганизациюПолучатель(Объект.Организация, Объект.ОрганизацияПолучатель);

КонецПроцедуры

&НаКлиенте
Процедура ОтражатьВОперативномУчетеПриИзменении(Элемент)
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура ОтражатьВБУиНУПриИзменении(Элемент)
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура ОтражатьВУУПриИзменении(Элемент)
	УстановитьВидимость();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовПодвалаФормы

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования, 
		ЭтотОбъект, 
		"Объект.Комментарий");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыРасчетыПоРеализациям

&НаКлиенте
Процедура РасчетыПоРеализацииТипРасчетовОткрытие(Элемент, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элементы.РасчетыПоРеализации.ТекущиеДанные;
	
	Если ЗначениеЗаполнено(ТекущиеДанные.ОбъектРасчетов) Тогда
		ПоказатьЗначение(Неопределено, ТекущиеДанные.ОбъектРасчетов);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РасчетыПоРеализацииТипРасчетовОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтрокаТаблицы = Элементы.РасчетыПоРеализации.ТекущиеДанные;
	СтандартнаяОбработка = Ложь;
	ТипРасчетовОбработкаВыбора(Элемент, СтрокаТаблицы, ВыбранноеЗначение);
	
КонецПроцедуры

&НаКлиенте
Процедура РасчетыПоРеализацииНомерРасчетногоДокументаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.РасчетыПоРеализации.ТекущиеДанные;
	НомерДатаПриИзменении(ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура РасчетыПоРеализацииДатаРасчетногоДокументаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.РасчетыПоРеализации.ТекущиеДанные;
	НомерДатаПриИзменении(ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура РасчетыПоРеализацииСуммаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.РасчетыПоРеализации.ТекущиеДанные;
	СуммаПриИзменении(ТекущиеДанные);

КонецПроцедуры

&НаКлиенте
Процедура РасчетыПоРеализацииВалютаВзаиморасчетовПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.РасчетыПоРеализации.ТекущиеДанные;
	ВалютаВзаиморасчетовПриИзменении(ТекущиеДанные);

КонецПроцедуры

&НаКлиенте
Процедура РасчетыПоРеализацииПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ЗаполнитьВалютуВзаиморасчетовВСтроке(Элементы.РасчетыПоРеализации.ТекущиеДанные);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыРасчетыПоАвансам

&НаКлиенте
Процедура РасчетыПоАвансамТипРасчетовОткрытие(Элемент, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элементы.РасчетыПоАвансам.ТекущиеДанные;
	
	Если ЗначениеЗаполнено(ТекущиеДанные.ОбъектРасчетов) Тогда
		ПоказатьЗначение(Неопределено, ТекущиеДанные.ОбъектРасчетов);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РасчетыПоАвансамТипРасчетовОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтрокаТаблицы = Элементы.РасчетыПоАвансам.ТекущиеДанные;
	СтандартнаяОбработка = Ложь;
	ТипРасчетовОбработкаВыбора(Элемент, СтрокаТаблицы, ВыбранноеЗначение);
	
КонецПроцедуры

&НаКлиенте
Процедура РасчетыПоАвансамНомерРасчетногоДокументаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.РасчетыПоАвансам.ТекущиеДанные;
	НомерДатаПриИзменении(ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура РасчетыПоАвансамДатаРасчетногоДокументаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.РасчетыПоАвансам.ТекущиеДанные;
	НомерДатаПриИзменении(ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура РасчетыПоАвансамСуммаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.РасчетыПоАвансам.ТекущиеДанные;
	СуммаПриИзменении(ТекущиеДанные);

КонецПроцедуры

&НаКлиенте
Процедура РасчетыПоАвансамВалютаВзаиморасчетовПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.РасчетыПоАвансам.ТекущиеДанные;
	ВалютаВзаиморасчетовПриИзменении(ТекущиеДанные);

КонецПроцедуры

&НаКлиенте
Процедура РасчетыПоАвансамПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ЗаполнитьВалютуВзаиморасчетовВСтроке(Элементы.РасчетыПоАвансам.ТекущиеДанные);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

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
Процедура ЗаполнитьПоОстаткам(Команда)
	//++ НЕ УТ
	Если Объект.РасчетыМеждуОрганизациями.Количество() Тогда
		ОповещениеВопросЗаполнитьПоОстаткам = Новый ОписаниеОповещения("ОбработчикОповещенияВопросЗаполнитьПоОстаткам", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'При заполнении текущие данные табличной части будут очищены. Продолжить?'");
		ПоказатьВопрос(ОповещениеВопросЗаполнитьПоОстаткам, ТекстВопроса, РежимДиалогаВопрос.ДаНет,,,  НСтр("ru = 'Ввод остатков регл. учета по данным оперативного'"));
	Иначе
		ЗаполнитьПоОстаткамНаСервере();
	КонецЕсли;
	//-- НЕ УТ
	Возврат;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();
	
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(Элемент.Поля, Элементы["РасчетыПоРеализацииНомерРасчетногоДокумента"].Имя);
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(Элемент.Поля, Элементы["РасчетыПоРеализацииДатаРасчетногоДокумента"].Имя);
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(Элемент.Поля, Элементы["РасчетыПоАвансамНомерРасчетногоДокумента"].Имя);
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(Элемент.Поля, Элементы["РасчетыПоАвансамДатаРасчетногоДокумента"].Имя);
	
	ГруппаОтбора = КомпоновкаДанныхКлиентСервер.ДобавитьГруппуОтбора(Элемент.Отбор.Элементы, ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли);
	КомпоновкаДанныхКлиентСервер.ДобавитьОтбор(ГруппаОтбора, "Объект.РасчетыМеждуОрганизациями.ОбъектРасчетов", Неопределено);
	КомпоновкаДанныхКлиентСервер.ДобавитьОтбор(ГруппаОтбора, "Объект.РасчетыМеждуОрганизациями.ТипРасчетов", НСтр("ru = 'Договор с контрагентом'"));
	//++ НЕ УТ
	КомпоновкаДанныхКлиентСервер.ДобавитьОтбор(ГруппаОтбора, "Объект.ОтражатьВОперативномУчете", Ложь);
	//-- НЕ УТ
		
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();
	
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(Элемент.Поля, Элементы["РасчетыПоРеализацииТипРасчетов"].Имя);
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(Элемент.Поля, Элементы["РасчетыПоАвансамТипРасчетов"].Имя);
	
	КомпоновкаДанныхКлиентСервер.ДобавитьОтбор(Элемент.Отбор, "Объект.РасчетыМеждуОрганизациями.ОбъектРасчетов", Неопределено);

	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Не указан'"));

	//++ НЕ УТ
	// Снятие отметки незаполненного при разделе учета "Регламентированный"
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(Элемент.Поля, Элементы["РасчетыПоРеализацииДатаПлатежа"].Имя);
	
	КомпоновкаДанныхКлиентСервер.ДобавитьОтбор(ГруппаОтбора, "Объект.ОтражатьВОперативномУчете", Ложь);
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	//-- НЕ УТ
	
КонецПроцедуры

#Область ОбщиеОбработчикиСобытийТабличныхЧастейРасчетыПоРеализациямИРасчетыПоАвансам

&НаКлиенте
Процедура ТипРасчетовОбработкаВыбора(Элемент, СтрокаТаблицы, ВыбранноеЗначение)
	
	СтандартнаяОбработка = Ложь;
	
	Если ВыбранноеЗначение = "Выбор" Тогда
		
		ЗначенияОтбора = Новый Структура;
		ЗначенияОтбора.Вставить("Организация", Объект.Организация);
		ЗначенияОтбора.Вставить("Контрагент",  Объект.ОрганизацияПолучатель);
		ЗначенияОтбора.Вставить("ЭтоИнтеркампани",  Истина);
		
		НастройкиВыбора = ФинансыКлиент.ПараметрыВыбораДокументаРасчетов();
		НастройкиВыбора.РедактируемыйДокумент = Объект.Ссылка;
		НастройкиВыбора.ЭтоРасчетыСКлиентами  = Истина;
		
		ФинансыКлиент.ДокументРасчетовНачалоВыбора(ЗначенияОтбора, НастройкиВыбора, Элемент, СтандартнаяОбработка);
		
	ИначеЕсли ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		
		СтрокаТаблицы.ТипРасчетов = Строка(ТипЗнч(ВыбранноеЗначение.Заказ));
		СтрокаТаблицы.ДатаРасчетногоДокумента = ВыбранноеЗначение.Дата;
		СтрокаТаблицы.НомерРасчетногоДокумента = ВыбранноеЗначение.Номер;
		СтрокаТаблицы.ОбъектРасчетов = ВыбранноеЗначение.Заказ;
		СтрокаТаблицы.ВалютаВзаиморасчетов = ВыбранноеЗначение.ВалютаВзаиморасчетов;
		
	Иначе

		Если ТипЗнч(СтрокаТаблицы.ОбъектРасчетов) <> ТипЗнч(ВыбранноеЗначение) Тогда
			Если ВыбранноеЗначение = НСтр("ru = 'Не указан'") Тогда
				СтрокаТаблицы.ОбъектРасчетов = Неопределено;;
				СтрокаТаблицы.ТипРасчетов = ВыбранноеЗначение;
				СтрокаТаблицы.ДатаРасчетногоДокумента = Дата(1,1,1);
				СтрокаТаблицы.НомерРасчетногоДокумента = "";
			Иначе
				СтрокаТаблицы.ОбъектРасчетов = ВыбранноеЗначение;
				Если ВыбранноеЗначение = ПредопределенноеЗначение("Перечисление.ТипыДоговоровМеждуОрганизациями.КупляПродажа") Тогда
					СтрокаТаблицы.ТипРасчетов = НСтр("ru = 'Договор купли-продажи'");
				ИначеЕсли ВыбранноеЗначение = ПредопределенноеЗначение("Перечисление.ТипыДоговоровМеждуОрганизациями.Комиссионный") Тогда
					СтрокаТаблицы.ТипРасчетов = НСтр("ru = 'Договор комиссии'");
				Иначе
					СтрокаТаблицы.ТипРасчетов = Строка(ТипЗнч(ВыбранноеЗначение));
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НомерДатаПриИзменении(ТекущиеДанные)
	
	ДополнитьНомер(ТекущиеДанные.НомерРасчетногоДокумента);
	Если Не (ЗначениеЗаполнено(ТекущиеДанные.НомерРасчетногоДокумента)
		И ЗначениеЗаполнено(ТекущиеДанные.ДатаРасчетногоДокумента)) Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяСтрокаИдентификатор = ТекущиеДанные.ПолучитьИдентификатор();
	
	ПодобратьДокументРасчетовСервер(ТекущаяСтрокаИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаПриИзменении(СтрокаТаблицы)
	
	Суммы = РассчитатьСуммы(
		СтрокаТаблицы.Сумма,
		СтрокаТаблицы.ВалютаВзаиморасчетов,
		ВалютаРегламентированногоУчета,
		ВалютаУправленческогоУчета,
		Объект.Дата);
	
	ЗаполнитьЗначенияСвойств(СтрокаТаблицы, Суммы, "СуммаРегл, СуммаУпр");
	
КонецПроцедуры

&НаКлиенте
Процедура ВалютаВзаиморасчетовПриИзменении(СтрокаТаблицы)
	
	Если СтрокаТаблицы.Сумма <> 0 Тогда
		СуммаПриИзменении(СтрокаТаблицы);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	УстановитьВидимость();
	
	МассивПараметров = Новый Массив;
	Если ЗначениеЗаполнено(Объект.ОрганизацияПолучатель)
		И ФОИспользоватьОбособленныеПодразделенияВыделенныеНаБаланс Тогда
		МассивПараметров.Добавить(Новый ПараметрВыбора("РежимВыбораВзаимосвязанныхОрганизаций", "ТолькоНеВзаимосвязанные"));
	КонецЕсли;
	Элементы.Покупатель.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
	
	Элементы.Префикс.Доступность = Объект.ДополнятьНомера;
	ЗаполнитьТипОбъектаРасчетов();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимость()
	
	Элементы.ГруппаРасчетыПоРеализации.Видимость = Объект.ТипОперации = Перечисления.ТипыОперацийВводаОстатков.ОстаткиРасчетовМеждуОрганизациямиПоРеализациям;
	Элементы.ГруппаРасчетыПоАвансам.Видимость = Объект.ТипОперации = Перечисления.ТипыОперацийВводаОстатков.ОстаткиРасчетовМеждуОрганизациямиПоАвансам;
	
	ЗаполнениеПоОстаткам = НЕ Объект.ОтражатьВОперативномУчете И (Объект.ОтражатьВБУиНУ ИЛИ Объект.ОтражатьВУУ);
	Элементы.РасчетыПоРеализацииЗаполнитьПоОстаткам.Видимость = ЗаполнениеПоОстаткам;
	Элементы.РасчетыПоАвансамЗаполнитьПоОстаткам.Видимость = ЗаполнениеПоОстаткам;
	
	Элементы.РасчетыПоРеализацииСуммаРегл.Видимость = Объект.ОтражатьВОперативномУчете ИЛИ Объект.ОтражатьВБУиНУ;
	Элементы.РасчетыПоРеализацииСуммаУпр.Видимость = Объект.ОтражатьВОперативномУчете ИЛИ Объект.ОтражатьВУУ;
	
	Элементы.РасчетыПоАвансамСуммаРегл.Видимость = Объект.ОтражатьВОперативномУчете ИЛИ Объект.ОтражатьВБУиНУ;
	Элементы.РасчетыПоАвансамСуммаУпр.Видимость = Объект.ОтражатьВОперативномУчете ИЛИ Объект.ОтражатьВУУ;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовок()
	
	АвтоЗаголовок = Ложь;
	Заголовок = Документы.ВводОстатков.ЗаголовокДокументаПоТипуОперации(Объект.Ссылка,
																						  Объект.Номер,
																						  Объект.Дата,
																						  Объект.ТипОперации);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СформироватьПрефикс(Организация)
	
	Возврат Документы.ВводОстатков.УстановитьПрефикс(Организация);
	
КонецФункции

&НаКлиенте
Процедура ДополнитьНомер(Номер)
		
	Если Не Объект.ДополнятьНомера
		Или Не ЗначениеЗаполнено(Номер) Тогда
		Возврат;
	КонецЕсли;
	
	Результат = СокрЛП(Номер);
	
	Разделитель = ?(ПустаяСтрока(Объект.Префикс), "", "-");
	
	Начало = СокрЛП(Объект.Префикс) + Разделитель;
	
	Пока СтрДлина(Результат) < 11 - СтрДлина(Начало) Цикл
		Результат = "0" + Результат;
	КонецЦикла;
	
	Если СтрДлина(Результат) <= 11 - СтрДлина(Начало) Тогда
		Результат = Начало + Результат;
	КонецЕсли;
	
	Номер = Результат;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСпискиВыбораТипаРасчетов()
	
	Если Объект.ТипОперации = Перечисления.ТипыОперацийВводаОстатков.ОстаткиРасчетовМеждуОрганизациямиПоРеализациям Тогда
		СписокВыбора = Элементы.РасчетыПоРеализацииТипРасчетов.СписокВыбора;
		СписокВыбора.Очистить();
		СписокВыбора.Добавить("Не указан", НСтр("ru = 'Не указан'"));
		СписокВыбора.Добавить("Выбор", НСтр("ru = 'Выбрать объект расчетов'"));
		СписокВыбора.Добавить(Документы.ПередачаТоваровМеждуОрганизациями.ПустаяСсылка(), НСтр("ru = 'Передача товаров'"));
		СписокВыбора.Добавить(Документы.ОтчетПоКомиссииМеждуОрганизациями.ПустаяСсылка(), НСтр("ru = 'Отчет по комиссии между организациями'"));
	ИначеЕсли Объект.ТипОперации = Перечисления.ТипыОперацийВводаОстатков.ОстаткиРасчетовМеждуОрганизациямиПоАвансам Тогда
		СписокВыбора = Элементы.РасчетыПоАвансамТипРасчетов.СписокВыбора;
		СписокВыбора.Очистить();
		СписокВыбора.Добавить("Не указан", НСтр("ru = 'Не указан'"));
		СписокВыбора.Добавить("Выбор", НСтр("ru = 'Выбрать объект расчетов'"));
	КонецЕсли;
	Если ПолучитьФункциональнуюОпцию("ИспользоватьДоговорыМеждуОрганизациями") Тогда
		СписокВыбора.Добавить(Перечисления.ТипыДоговоровМеждуОрганизациями.КупляПродажа, НСтр("ru = 'Договор купли-продажи'"));
		СписокВыбора.Добавить(Перечисления.ТипыДоговоровМеждуОрганизациями.Комиссионный, НСтр("ru = 'Договор комиссии'"));
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТипОбъектаРасчетов()
	
	Для Каждого СтрокаТаблицы Из Объект.РасчетыМеждуОрганизациями Цикл
		СтрокаТаблицы.ТипРасчетов = Строка(ТипЗнч(СтрокаТаблицы.ОбъектРасчетов));
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьПараметрыВыбораОрганизацииПолучателя(ОрганизацияПокупатель)
	
	МассивПараметров = Новый Массив;
	Если ЗначениеЗаполнено(ОрганизацияПокупатель)
		И ФОИспользоватьОбособленныеПодразделенияВыделенныеНаБаланс Тогда
		МассивПараметров.Добавить(Новый ПараметрВыбора("РежимВыбораВзаимосвязанныхОрганизаций", "ТолькоНеВзаимосвязанные"));
	КонецЕсли;
	Возврат МассивПараметров;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ПроверитьИОчиститьОрганизациюПолучатель(Организация, ОрганизацияПолучатель)
	
	Если ЗначениеЗаполнено(Организация)
		И ЗначениеЗаполнено(ОрганизацияПолучатель)
		И ПолучитьФункциональнуюОпцию("ИспользоватьОбособленныеПодразделенияВыделенныеНаБаланс")
		И Справочники.Организации.ОрганизацииВзаимосвязаныПоОрганизационнойСтруктуре(Организация, ОрганизацияПолучатель) Тогда
		ОрганизацияПолучатель = Неопределено;
	КонецЕсли
	
КонецПроцедуры

&НаСервере
Процедура ПодобратьДокументРасчетовСервер(ТекущаяСтрокаИдентификатор)
	
	ИмяТЧ = Документы.ВводОстатков.ИмяТабличнойЧастиРасчетовПоТипуОперации(Объект.ТипОперации);
	ТекущиеДанные = Объект[ИмяТЧ].НайтиПоИдентификатору(ТекущаяСтрокаИдентификатор);
	Документы.ВводОстатков.ПодобратьДокументРасчетов(Объект, ТекущиеДанные);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция РассчитатьСуммы(Сумма, Валюта, ВалютаРегл, ВалютаУпр, ДатаДокумента)
	
	Если Валюта = ВалютаРегл Тогда
		СуммаРегл = Сумма;
	Иначе
		КоэффициентПересчета = РаботаСКурсамиВалютУТ.ПолучитьКоэффициентПересчетаИзВалютыВВалюту(Валюта, ВалютаРегл, ДатаДокумента);
		СуммаРегл = Окр(Сумма * КоэффициентПересчета, 2, 1);
	КонецЕсли;
	
	Если Валюта = ВалютаУпр Тогда
		СуммаУпр = Сумма;
	Иначе
		КоэффициентПересчета = РаботаСКурсамиВалютУТ.ПолучитьКоэффициентПересчетаИзВалютыВВалюту(Валюта, ВалютаУпр, ДатаДокумента);
		СуммаУпр = Окр(Сумма * КоэффициентПересчета, 2, 1);
	КонецЕсли;
	
	Возврат Новый Структура("СуммаРегл, СуммаУпр", СуммаРегл, СуммаУпр);
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьВалютуВзаиморасчетовВСтроке(Строка)
	
	Если НЕ ЗначениеЗаполнено(Строка.ВалютаВзаиморасчетов) И Не ИспользоватьНесколькоВалют Тогда
		Строка.ВалютаВзаиморасчетов = ВалютаРегламентированногоУчета;
	КонецЕсли;
	
КонецПроцедуры

//++ НЕ УТ
&НаСервере
Процедура ЗаполнитьПоОстаткамНаСервере()
	
	КлючевыеПоля = Документы.ВводОстатков.КлючевыеПоляРеглУчетаПоТипуОперации(Объект.ТипОперации);
	Отбор = Новый Структура;
	Для каждого КлючевоеПоле Из КлючевыеПоля Цикл
		Если Не КлючевоеПоле = "Организация" И ЗначениеЗаполнено(Объект[КлючевоеПоле]) Тогда
			Отбор.Вставить(КлючевоеПоле, Объект[КлючевоеПоле]);
		КонецЕсли;
	КонецЦикла;
	
	Остатки = Документы.ВводОстатков.ОстаткиПоТипуОперации(Объект.Дата, Объект.ТипОперации, Объект.Организация, Отбор);
	
	Выборка = Остатки.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Стр = Объект.РасчетыМеждуОрганизациями.Добавить();
		ЗаполнитьЗначенияСвойств(Стр, Выборка);
	КонецЦикла;
	
	ЗаполнитьТипОбъектаРасчетов(); 
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОповещенияВопросЗаполнитьПоОстаткам(РезультатВопроса, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ЗаполнитьПоОстаткамНаСервере();		
	КонецЕсли;
	
КонецПроцедуры

//-- НЕ УТ

#КонецОбласти

#КонецОбласти
