
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Если Параметры.Свойство("НаДату") Тогда
		НаДату = Параметры.НаДату;
	КонецЕсли;
	
	Если Параметры.Свойство("ПодразделенияДляКоторыхНеВведеноЗначениеПоказателя") Тогда
		СписокПодразделенийДляКоторыхНеВведеноЗначениеПоказателя.ЗагрузитьЗначения(Параметры.ПодразделенияДляКоторыхНеВведеноЗначениеПоказателя);
	КонецЕсли;
	
	Если Параметры.Свойство("БазаРаспределения") Тогда
		Объект.БазаРаспределения = Параметры.БазаРаспределения;
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("КомплекснаяАвтоматизация")
		И Объект.НазначениеПравила = Перечисления.НазначениеПравилРаспределенияРасходов.РаспределениеСтатейРасходовПоЭтапамПроизводства Тогда
		НазначениеПравила = НСтр("ru = 'Распределение статей расходов по выпускам продукции'");
	Иначе
		НазначениеПравила = СокрЛП(Объект.НазначениеПравила);
	КонецЕсли;
	
	НастроитьЭлементыФормыПоВерсииПартионногоУчета();
	
	ЗаполнитьСпискиОтбора();
	УстановитьВидимостьПоНазначениюНаПодразделения();
	УстановитьТекстИВидимостьОтбораНаправленияРаспределения();
	УстановитьБазуРаспределения();
	УстановитьТекстИДоступностьОтбораБазыРаспределения();
	УстановитьВидимостьОтбораПоГруппамПродукции();
	// подсистема запрета редактирования ключевых реквизитов объектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	
	УстановитьЗаголовокФормы();
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	УстановитьВидимостьПоОтборуПоГруппамПродукции();
	УстановитьТестНадписиОтбораПоГруппамПродукции();
	УстановитьВидимостьСтатьиКалькуляции();

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	УстановитьЗаголовокФормы();
	ЗаполнитьСпискиОтбора();
	УстановитьТекстИДоступностьОтбораБазыРаспределения();
	Оповестить("Запись_ПравилаРаспределенияРасходов");

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
// подсистема запрета редактирования ключевых реквизитов объектов	
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	ТекущийОбъект.ОтборПоГруппамПродукции.Очистить();
	Если ИспользоватьОтборПоГруппамПродукции 
		   И ТекущийОбъект.НазначениеПравила <> Перечисления.НазначениеПравилРаспределенияРасходов.РаспределениеСтатейРасходовПоПодразделениям Тогда
		Для Каждого Элемент Из ОтборПоГруппамПродукции Цикл 
			НоваяСтрока = ТекущийОбъект.ОтборПоГруппамПродукции.Добавить();
			НоваяСтрока.ГруппаПродукции = Элемент.Значение;
		КонецЦикла;
	КонецЕсли;
	ТекущийОбъект.ОтборПоМатериалам.Очистить();
	Если Объект.БазаРаспределения = Перечисления.ТипыБазыРаспределенияРасходов.КоличествоУказанныхМатериалов
		ИЛИ Объект.БазаРаспределения = Перечисления.ТипыБазыРаспределенияРасходов.ВесУказанныхМатериалов
		ИЛИ Объект.БазаРаспределения = Перечисления.ТипыБазыРаспределенияРасходов.ОбъемУказанныхМатериалов Тогда
		Для Каждого Элемент Из ОтборПоМатериалам Цикл 
			НоваяСтрока = ТекущийОбъект.ОтборПоМатериалам.Добавить();
			НоваяСтрока.Материал = Элемент.Значение;
		КонецЦикла;
	КонецЕсли;
	ТекущийОбъект.ОтборПоВидамРабот.Очистить();
	Если Объект.БазаРаспределения = Перечисления.ТипыБазыРаспределенияРасходов.КоличествоРаботУказанныхВидов Тогда
		Для Каждого Элемент Из ОтборПоВидамРабот Цикл 
			НоваяСтрока = ТекущийОбъект.ОтборПоВидамРабот.Добавить();
			НоваяСтрока.ВидРабот = Элемент.Значение;
		КонецЦикла;
	КонецЕсли;
	ТекущийОбъект.ОтборПоПодразделениям.Очистить();
	Если Объект.УдалитьНаправлениеРаспределения = Перечисления.СпособыРаспределенияСтатейРасходов.ПоПоказателюНаУказанныеПодразделения
		И Объект.НазначениеПравила = Перечисления.НазначениеПравилРаспределенияРасходов.РаспределениеСтатейРасходовПоПодразделениям Тогда
		Для Каждого Элемент Из ОтборПоПодразделениям Цикл 
			НоваяСтрока = ТекущийОбъект.ОтборПоПодразделениям.Добавить();
			НоваяСтрока.Подразделение = Элемент.Значение;
		КонецЦикла;
	КонецЕсли;

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если Объект.НазначениеПравила = Перечисления.НазначениеПравилРаспределенияРасходов.РаспределениеСтатейРасходовПоПодразделениям
		И Элементы.ПодразделенияВручную.СписокВыбора.НайтиПоЗначению(БазаРаспределения) = Неопределено
		И ((Объект.Устаревшее И Элементы.ПодразделенияАвтоматически.СписокВыбора.НайтиПоЗначению(БазаРаспределения) = Неопределено
			И Элементы.ПодразделенияМатериалыТруд.СписокВыбора.НайтиПоЗначению(БазаРаспределения) = Неопределено)
			Или Не Объект.Устаревшее) Тогда
		
		ТекстСообщения = НСтр("ru = 'Не указан тип показателя.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,
			, // Ключ данных
			"БазаРаспределения",
			, // Путь к данным
			Отказ);
			
	Иначе
		
		Если (Объект.НазначениеПравила = Перечисления.НазначениеПравилРаспределенияРасходов.РаспределениеСтатейРасходовПоЭтапамПроизводства
		И Элементы.ЭтапыМатериалыИТрудозатраты.СписокВыбора.НайтиПоЗначению(БазаРаспределения) = Неопределено
		И Элементы.ЭтапыМатериальныеЗатраты.СписокВыбора.НайтиПоЗначению(БазаРаспределения) = Неопределено
		И Элементы.ЭтапыТрудозатраты.СписокВыбора.НайтиПоЗначению(БазаРаспределения) = Неопределено
		И Элементы.ЭтапыПродукция.СписокВыбора.НайтиПоЗначению(БазаРаспределения) = Неопределено)
	
		ИЛИ
		(Объект.НазначениеПравила = Перечисления.НазначениеПравилРаспределенияРасходов.РаспределениеМатериаловИРабот
		И Элементы.МатериалыИРаботыМатериальныеЗатраты.СписокВыбора.НайтиПоЗначению(БазаРаспределения) = Неопределено
		И Элементы.МатериалыИРаботыПродукция.СписокВыбора.НайтиПоЗначению(БазаРаспределения) = Неопределено
		И Элементы.МатериалыИРаботыНормативРасходаДанногоМатериала.СписокВыбора.НайтиПоЗначению(БазаРаспределения) = Неопределено)
		Тогда
		
			ТекстСообщения = НСтр("ru = 'Не выбрано ни одной базы распределения'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстСообщения,
				, // Ключ данных
				"БазаРаспределения",
				, // Путь к данным
				Отказ);
			
		КонецЕсли;
			
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НадписьОтборПоГруппамПродукцииНажатие(Элемент)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыОтбора = Новый Структура();
	ПараметрыОтбора.Вставить("МассивГруппПродукции", ОтборПоГруппамПродукции.ВыгрузитьЗначения());
	РезультатОтбора = Неопределено;

	ОткрытьФорму("Справочник.ПравилаРаспределенияРасходов.Форма.ФормаОтбора",
			ПараметрыОтбора,
			ЭтаФорма,,,, 
			Новый ОписаниеОповещения("НадписьОтборНажатиеЗавершение", ЭтотОбъект, "ОтборПоГруппамПродукции"), 
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОтборПоГруппамПродукцииПриИзменении(Элемент)
	
	УстановитьВидимостьПоОтборуПоГруппамПродукции();
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьОтборБазыРаспределенияНажатие()
	
	СтандартнаяОбработка = Ложь;
	ПараметрыОтбора = Новый Структура();
	ДопПараметрОтбора = "";
	Если БазаРаспределения = "КоличествоУказанныхМатериалов"
		ИЛИ БазаРаспределения = "ВесУказанныхМатериалов"
		ИЛИ БазаРаспределения = "ОбъемУказанныхМатериалов" Тогда
		ПараметрыОтбора.Вставить("МассивМатериалов", ОтборПоМатериалам.ВыгрузитьЗначения());
		ДопПараметрОтбора = "ОтборПоМатериалам";
	ИначеЕсли БазаРаспределения = "КоличествоРаботУказанныхВидов" Тогда
		ПараметрыОтбора.Вставить("МассивВидовРабот", ОтборПоВидамРабот.ВыгрузитьЗначения());
		ДопПараметрОтбора = "ОтборПоВидамРабот";
	КонецЕсли;
	РезультатОтбора = Неопределено;

	ОткрытьФорму("Справочник.ПравилаРаспределенияРасходов.Форма.ФормаОтбора",
			ПараметрыОтбора,
			ЭтаФорма,,,, 
			Новый ОписаниеОповещения("НадписьОтборНажатиеЗавершение", ЭтотОбъект, ДопПараметрОтбора), 
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			
КонецПроцедуры

&НаКлиенте
Процедура НадписьОтборНаправлениеНажатие(Элемент)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыОтбора = Новый Структура();
	ПараметрыОтбора.Вставить("МассивПодразделений", ОтборПоПодразделениям.ВыгрузитьЗначения());
	ДопПараметрОтбора = "ОтборПоПодразделениям";
	РезультатОтбора = Неопределено;

	ОткрытьФорму("Справочник.ПравилаРаспределенияРасходов.Форма.ФормаОтбора",
			ПараметрыОтбора,
			ЭтаФорма,,,, 
			Новый ОписаниеОповещения("НадписьОтборНажатиеЗавершение", ЭтотОбъект, ДопПараметрОтбора), 
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыМатериалыИТрудозатратыПриИзменении(Элемент)
	
	УстановитьТекстИДоступностьОтбораБазыРаспределения();
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыМатериальныеЗатратыПриИзменении(Элемент)
	
	УстановитьТекстИДоступностьОтбораБазыРаспределения();
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыТрудозатратыПриИзменении(Элемент)
	
	УстановитьТекстИДоступностьОтбораБазыРаспределения();
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыПродукцияПриИзменении(Элемент)
	
	УстановитьТекстИДоступностьОтбораБазыРаспределения();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделенияВручнуюПриИзменении(Элемент)
	
	УстановитьТекстИДоступностьОтбораБазыРаспределения();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделенияАвтоматическиПриИзменении(Элемент)
	
	УстановитьТекстИДоступностьОтбораБазыРаспределения();
	
КонецПроцедуры

&НаКлиенте
Процедура МатериалыИРаботыМатериальныеЗатратыПриИзменении(Элемент)
	
	УстановитьТекстИДоступностьОтбораБазыРаспределения();
	
КонецПроцедуры

&НаКлиенте
Процедура МатериалыИРаботыПродукцияПриИзменении(Элемент)
	
	УстановитьТекстИДоступностьОтбораБазыРаспределения();
	
КонецПроцедуры

&НаКлиенте
Процедура МатериалыИРаботыНормативРасходаДанногоМатериалаПриИзменении(Элемент)
	
	УстановитьТекстИДоступностьОтбораБазыРаспределения();
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьЭтапыУказатьМатериалыНажатие(Элемент)
	
	НадписьОтборБазыРаспределенияНажатие();
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьЭтапыУказатьВидыРаботНажатие(Элемент)
	
	НадписьОтборБазыРаспределенияНажатие();
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьПодразделенияЗначенияНажатие(Элемент)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Показатель", Объект.Ссылка);
	ПараметрыФормы.Вставить("ТолькоЗначения");
	
	Если Не ОтборПоПодразделениям.Количество() = 0 Тогда
		ПараметрыФормы.Вставить("Подразделения",ОтборПоПодразделениям);
	КонецЕсли;
	
	ОткрытьФорму("Справочник.ПравилаРаспределенияРасходов.Форма.ФормаСпискаВручную",
						ПараметрыФормы,
						ЭтаФорма,
						,,,,
						РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьМатериалыИРаботыУказатьМатериалыНажатие(Элемент)
	
	НадписьОтборБазыРаспределенияНажатие();
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьМатериалыИРаботыУказатьВидыРаботНажатие(Элемент)
	
	НадписьОтборБазыРаспределенияНажатие();
	
КонецПроцедуры

&НаКлиенте
Процедура НаправлениеРаспределенияПриИзменении(Элемент)
	
	УстановитьТекстИВидимостьОтбораНаправленияРаспределения();
	
КонецПроцедуры

&НаКлиенте
Процедура НаправлениеРаспределенияОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	ОбщегоНазначенияУТКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьСпискиОтбора()
	
	ОтборПоГруппамПродукции.ЗагрузитьЗначения(Объект.ОтборПоГруппамПродукции.Выгрузить(, "ГруппаПродукции").ВыгрузитьКолонку("ГруппаПродукции"));
	ИспользоватьОтборПоГруппамПродукции = (ОтборПоГруппамПродукции.Количество() > 0);
	ОтборПоВидамРабот.ЗагрузитьЗначения(Объект.ОтборПоВидамРабот.Выгрузить(, "ВидРабот").ВыгрузитьКолонку("ВидРабот"));
	ОтборПоМатериалам.ЗагрузитьЗначения(Объект.ОтборПоМатериалам.Выгрузить(, "Материал").ВыгрузитьКолонку("Материал"));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимостьПоОтборуПоГруппамПродукции()
	
	Элементы.НадписьОтборПоГруппамПродукции.Видимость = ИспользоватьОтборПоГруппамПродукции;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимостьСтатьиКалькуляции()
	
	Элементы.СтатьяКалькуляции.Видимость = (Объект.НазначениеПравила = ПредопределенноеЗначение("Перечисление.НазначениеПравилРаспределенияРасходов.РаспределениеМатериаловИРабот")
							ИЛИ Объект.НазначениеПравила = ПредопределенноеЗначение("Перечисление.НазначениеПравилРаспределенияРасходов.РаспределениеСтатейРасходовПоЭтапамПроизводства"));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьТестНадписиОтбораПоГруппамПродукции()
	
	ТекстНадписи = "";
	Для Каждого Элемент Из ОтборПоГруппамПродукции Цикл 
		ТекстНадписи = ТекстНадписи + ?(ТекстНадписи = "", "", "; ") + СокрЛП(Элемент.Значение);
	КонецЦикла;
	Если ТекстНадписи = "" Тогда
		ТекстНадписи = НСтр("ru = 'Указать группы (виды) продукции'");
	КонецЕсли;
	Элементы.НадписьОтборПоГруппамПродукции.Заголовок = ТекстНадписи;
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьОтборНажатиеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	РезультатОтбора = Результат;
	Если ТипЗнч(РезультатОтбора) = Тип("Массив") Тогда
		Если ДополнительныеПараметры = "ОтборПоГруппамПродукции" Тогда
			ОтборПоГруппамПродукции.ЗагрузитьЗначения(РезультатОтбора);
			УстановитьТестНадписиОтбораПоГруппамПродукции();
			Модифицированность = Истина;
		ИначеЕсли ДополнительныеПараметры = "ОтборПоМатериалам" Тогда
			ОтборПоМатериалам.ЗагрузитьЗначения(РезультатОтбора);
			УстановитьТекстИДоступностьОтбораБазыРаспределения();
			Модифицированность = Истина;
		ИначеЕсли ДополнительныеПараметры = "ОтборПоВидамРабот" Тогда
			ОтборПоВидамРабот.ЗагрузитьЗначения(РезультатОтбора);
			УстановитьТекстИДоступностьОтбораБазыРаспределения();
			Модифицированность = Истина;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УстановитьТестНадписиОтбораПоМатериалам()
	
	ТекстНадписи = Справочники.ПравилаРаспределенияРасходов.ПредставлениеОтобранныхПозиций(ОтборПоМатериалам.ВыгрузитьЗначения());
	
	Если ТекстНадписи = "" Тогда
		ТекстНадписи = НСтр("ru = 'Указать материалы'");
	КонецЕсли;
	
	Элементы.НадписьЭтапыУказатьМатериалы.Заголовок = ТекстНадписи;
	Элементы.НадписьМатериалыИРаботыУказатьМатериалы.Заголовок = ТекстНадписи;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТестНадписиОтбораПоВидамРабот()
	
	ТекстНадписи = Справочники.ПравилаРаспределенияРасходов.ПредставлениеОтобранныхПозиций(ОтборПоВидамРабот.ВыгрузитьЗначения());
	
	Если ТекстНадписи = "" Тогда
		ТекстНадписи = НСтр("ru = 'Указать виды работ'");
	КонецЕсли;
	Элементы.НадписьЭтапыУказатьВидыРабот.Заголовок = ТекстНадписи;
	Элементы.НадписьМатериалыИРаботыУказатьВидыРабот.Заголовок = ТекстНадписи;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТекстИДоступностьОтбораБазыРаспределения()

	Элементы.ГруппаИнформация.Видимость = Ложь;
	
	Если БазаРаспределения = "КоличествоУказанныхМатериалов"
		ИЛИ БазаРаспределения = "ВесУказанныхМатериалов"
		ИЛИ БазаРаспределения = "ОбъемУказанныхМатериалов" Тогда
		Элементы.НадписьЭтапыУказатьМатериалы.Доступность = Истина;
		Элементы.НадписьМатериалыИРаботыУказатьМатериалы.Доступность = Истина;
		Элементы.НадписьЭтапыУказатьВидыРабот.Доступность = Ложь;
		Элементы.НадписьМатериалыИРаботыУказатьВидыРабот.Доступность = Ложь;
		Элементы.НадписьПодразделенияЗначения.Доступность = Ложь;
		
		Если ОтборПоМатериалам.Количество() > 0 Тогда
			
			ТекстПредупреждения = ПроверитьКорректностьУказанныхМатериалов();
			Элементы.ГруппаИнформация.Видимость = Не ПустаяСтрока(ТекстПредупреждения);
			
		КонецЕсли;
		
	ИначеЕсли БазаРаспределения = "КоличествоРаботУказанныхВидов" Тогда
		Элементы.НадписьЭтапыУказатьВидыРабот.Доступность = Истина;
		Элементы.НадписьМатериалыИРаботыУказатьВидыРабот.Доступность = Истина;
		Элементы.НадписьЭтапыУказатьМатериалы.Доступность = Ложь;
		Элементы.НадписьМатериалыИРаботыУказатьМатериалы.Доступность = Ложь;
		Элементы.НадписьПодразделенияЗначения.Доступность = Ложь;
	ИначеЕсли БазаРаспределения = "ВводитсяЕжемесячно" ИЛИ БазаРаспределения = "ВводитсяПриИзменении" Тогда
		Элементы.НадписьПодразделенияЗначения.Доступность = Истина;
		Элементы.НадписьЭтапыУказатьВидыРабот.Доступность = Ложь;
		Элементы.НадписьМатериалыИРаботыУказатьВидыРабот.Доступность = Ложь;
		Элементы.НадписьЭтапыУказатьМатериалы.Доступность = Ложь;
		Элементы.НадписьМатериалыИРаботыУказатьМатериалы.Доступность = Ложь;
	Иначе
		Элементы.НадписьЭтапыУказатьВидыРабот.Доступность = Ложь;
		Элементы.НадписьМатериалыИРаботыУказатьВидыРабот.Доступность = Ложь;
		Элементы.НадписьЭтапыУказатьМатериалы.Доступность = Ложь;
		Элементы.НадписьМатериалыИРаботыУказатьМатериалы.Доступность = Ложь;
		Элементы.НадписьПодразделенияЗначения.Доступность = Ложь;
	КонецЕсли;
	Если ЗначениеЗаполнено(БазаРаспределения) Тогда
		Объект.БазаРаспределения = Перечисления.ТипыБазыРаспределенияРасходов[БазаРаспределения];
	КонецЕсли;

	УстановитьТестНадписиОтбораПоМатериалам();
	УстановитьТестНадписиОтбораПоВидамРабот();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьОтбораПоГруппамПродукции()
	
	Элементы.ГруппаОтборПоВидамПродукции.Видимость = ПолучитьФункциональнуюОпцию("АналитическийУчетПоГруппамПродукции")
		И Объект.НазначениеПравила <> Перечисления.НазначениеПравилРаспределенияРасходов.РаспределениеСтатейРасходовПоПодразделениям;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьБазуРаспределения()
	
	Если Объект.НазначениеПравила = Перечисления.НазначениеПравилРаспределенияРасходов.РаспределениеСтатейРасходовПоПодразделениям Тогда
		Элементы.СтраницыБазаРаспределения.ТекущаяСтраница = Элементы.СтраницаПоПодразделениям;
		Если НЕ ЗначениеЗаполнено(Объект.Ссылка) И НЕ ЗначениеЗаполнено(Объект.БазаРаспределения) Тогда
			Объект.БазаРаспределения = Перечисления.ТипыБазыРаспределенияРасходов.СуммаМатериальныхИТрудозатрат;
		КонецЕсли;
	ИначеЕсли Объект.НазначениеПравила = Перечисления.НазначениеПравилРаспределенияРасходов.РаспределениеСтатейРасходовПоЭтапамПроизводства Тогда
		Элементы.СтраницыБазаРаспределения.ТекущаяСтраница = Элементы.СтраницаПоЭтапам;
		Если НЕ ЗначениеЗаполнено(Объект.Ссылка) И НЕ ЗначениеЗаполнено(Объект.БазаРаспределения) Тогда
			Объект.БазаРаспределения = Перечисления.ТипыБазыРаспределенияРасходов.КоличествоПродукции;
		КонецЕсли;
	Иначе
		Элементы.СтраницыБазаРаспределения.ТекущаяСтраница = Элементы.СтраницаМатериаловИРабот;
		Если НЕ ЗначениеЗаполнено(Объект.Ссылка) И НЕ ЗначениеЗаполнено(Объект.БазаРаспределения) Тогда
			Объект.БазаРаспределения = Перечисления.ТипыБазыРаспределенияРасходов.КоличествоПродукции;
		КонецЕсли;
	КонецЕсли;
	
	БазаРаспределения = XMLстрока(Объект.БазаРаспределения);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьЭлементыФормыПоВерсииПартионногоУчета()
	
	Если Не ПолучитьФункциональнуюОпцию("ПартионныйУчетВерсии22") Тогда
		Элементы.ГруппаПоПрямымЗатратам.Видимость = Ложь;
		Элементы.ПодразделенияМатериалыТруд.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПроверитьКорректностьУказанныхМатериалов()
	
	ТекстПредупреждения = "";
	Если БазаРаспределения = "КоличествоУказанныхМатериалов" Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	Номенклатура.ЕдиницаИзмерения.ТипИзмеряемойВеличины КАК ТипИзмеряемойВеличины,
			|	КОЛИЧЕСТВО(Номенклатура.Ссылка) КАК Количество
			|ИЗ
			|	Справочник.Номенклатура КАК Номенклатура
			|ГДЕ
			|	Номенклатура.Ссылка В(&МассивДанных)
			|
			|СГРУППИРОВАТЬ ПО
			|	Номенклатура.ЕдиницаИзмерения.ТипИзмеряемойВеличины";
		
		Запрос.УстановитьПараметр("МассивДанных", ОтборПоМатериалам.ВыгрузитьЗначения());
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		
		Если Выборка.Количество() > 1 Тогда
			
			ТекстПредупреждения = НСтр("ru = 'Возможно материалы указаны некорректно. Материалы хранятся в разных измеряемых величинах:'") + " ";
			
			Пока Выборка.Следующий() Цикл
				ТекстПредупреждения = ТекстПредупреждения + Выборка.ТипИзмеряемойВеличины + "(" + Формат(Выборка.Количество, "ЧГ=0") + "), ";
			КонецЦикла;
			
			ТекстПредупреждения = Лев(ТекстПредупреждения, СтрДлина(ТекстПредупреждения) - 2);
			
		КонецЕсли;
		
	Иначе
		
		ПредставлениеБазы = "";
		ТипИзмеряемойВеличины = Перечисления.ТипыИзмеряемыхВеличин.ПустаяСсылка();
		Если БазаРаспределения = "ОбъемУказанныхМатериалов" Тогда
			
			ТипИзмеряемойВеличины = Перечисления.ТипыИзмеряемыхВеличин.Объем;
			ПредставлениеБазы = НСтр("ru = 'объем'");
			
		ИначеЕсли БазаРаспределения = "ВесУказанныхМатериалов" Тогда
			
			ТипИзмеряемойВеличины = Перечисления.ТипыИзмеряемыхВеличин.Вес;
			ПредставлениеБазы = НСтр("ru = 'вес'");
			
		КонецЕсли;
		
		Запрос = Новый Запрос;
		Запрос.Текст =
			"ВЫБРАТЬ
			|	Количество(РАЗЛИЧНЫЕ ВсяНоменклатура.Ссылка) КАК КоличествоМатериалов
			|ИЗ
			|	Справочник.Номенклатура КАК ВсяНоменклатура
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК Номенклатура
			|		ПО (Номенклатура.ЕдиницаИзмерения.ТипИзмеряемойВеличины = &ТипИзмеряемойВеличины
			|				ИЛИ &Объем
			|					И Номенклатура.ОбъемИспользовать
			|				ИЛИ &Вес
			|					И Номенклатура.ВесИспользовать)
			|			И ВсяНоменклатура.Ссылка = Номенклатура.Ссылка
			|ГДЕ
			|	ВсяНоменклатура.Ссылка В(&МассивДанных)
			|	И Номенклатура.Ссылка ЕСТЬ NULL";
		
		Запрос.УстановитьПараметр("МассивДанных", ОтборПоМатериалам.ВыгрузитьЗначения());
		Запрос.УстановитьПараметр("ТипИзмеряемойВеличины", ТипИзмеряемойВеличины);
		Запрос.УстановитьПараметр("Объем", ТипИзмеряемойВеличины = Перечисления.ТипыИзмеряемыхВеличин.Объем);
		Запрос.УстановитьПараметр("Вес", ТипИзмеряемойВеличины = Перечисления.ТипыИзмеряемыхВеличин.Вес);
		
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		
		ШаблонПредупреждения = НСтр("ru = 'Невозможно получить коэффициент пересчета для материалов (1%) в 2%.'");
		
		Пока Выборка.Следующий() Цикл
			Если Выборка.КоличествоМатериалов > 0 Тогда
				ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонПредупреждения, 
					Формат(Выборка.КоличествоМатериалов, "ЧГ=0"),
					ПредставлениеБазы);
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат ТекстПредупреждения;
	
КонецФункции

&НаСервере
Процедура УстановитьЗаголовокФормы()
	
	Если Объект.НазначениеПравила = Перечисления.НазначениеПравилРаспределенияРасходов.РаспределениеСтатейРасходовПоПодразделениям Тогда
		
		АвтоЗаголовок = Ложь;
		Элементы.НазначениеПравила.Видимость = Ложь;
		
		ТекстЗаголовка = НСтр("ru = '%1 (%2)'");
		Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
			Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЗаголовка,
				Объект.Наименование,
				НСтр("ru = 'Показатель'"));
		Иначе
			Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЗаголовка,
				НСтр("ru = 'Показатель'"),
				НСтр("ru = 'создание'"));
		КонецЕсли;
			
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТестНадписиОтбораПоПодразделениям()
	
	ТекстНадписи = "";
	Для Каждого Элемент Из ОтборПоПодразделениям Цикл 
		ТекстНадписи = ТекстНадписи + ?(ТекстНадписи = "", "", "; ") + СокрЛП(Элемент.Значение);
	КонецЦикла;
	Если ТекстНадписи = "" Тогда
		ТекстНадписи = НСтр("ru = 'Указать подразделения'");
	КонецЕсли;
	Элементы.НадписьОтборНаправление.Заголовок = ТекстНадписи;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТекстИВидимостьОтбораНаправленияРаспределения()

	Элементы.НадписьОтборНаправление.Видимость = 
		(Объект.УдалитьНаправлениеРаспределения = Перечисления.СпособыРаспределенияСтатейРасходов.ПоПоказателюНаУказанныеПодразделения);
	УстановитьТестНадписиОтбораПоПодразделениям();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьПоНазначениюНаПодразделения()
	
	Элементы.ГруппаНаправление.Видимость = 
		Объект.НазначениеПравила = Перечисления.НазначениеПравилРаспределенияРасходов.РаспределениеСтатейРасходовПоПодразделениям
		И Объект.Устаревшее;
		
	Элементы.ПодразделенияКолонка2.Видимость = Объект.Устаревшее;
	
КонецПроцедуры

#КонецОбласти
