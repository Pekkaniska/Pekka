#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем ДатаОтчета, ДатаОстатков, Валюта, ДанныеОтчета, ИспользуетсяОтборПоСегментуПартнеров, Календарь, СтрокаСостояниеВзаиморасчетов, СтрокаДолгНеПросрочен, ВариантКлассификацииЗадолженности;

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.События.ПередЗагрузкойВариантаНаСервере = Истина;
КонецПроцедуры

// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// Подробнее - см. ОтчетыПереопределяемый.ПередЗагрузкойВариантаНаСервере
//
Процедура ПередЗагрузкойВариантаНаСервере(ЭтаФорма, НовыеНастройкиКД) Экспорт
	Отчет = ЭтаФорма.Отчет;
	КомпоновщикНастроекФормы = Отчет.КомпоновщикНастроек;
	
	// Изменение настроек по функциональным опциям
	НастроитьПараметрыОтборыПоФункциональнымОпциям(КомпоновщикНастроекФормы);
	
	// Установка значений по умолчанию
	УстановитьОбязательныеНастройки(КомпоновщикНастроекФормы, Истина);
	
	НовыеНастройкиКД = КомпоновщикНастроекФормы.Настройки;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ПользовательскиеНастройкиМодифицированы = Ложь;
	
	УстановитьОбязательныеНастройки(КомпоновщикНастроек, ПользовательскиеНастройкиМодифицированы);
	
	#Область АктуализацияВзаиморасчетов
	УстановитьПривилегированныйРежим(Истина);
	ПоляОтбора = РаспределениеВзаиморасчетовВызовСервера.ПоляОтбораПоУмолчанию();
	ПоляОтбора.Период = "ДатаОтчета";
	ДопСвойства = КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства;
	ИмяЗадания = РаспределениеВзаиморасчетовВызовСервера.ИмяФоновогоЗаданияРасчетовСКлиентами();
	РаспределениеВзаиморасчетовВызовСервера.ВосстановитьРасчетыПоОтборам(КомпоновщикНастроек, ПоляОтбора, ДопСвойства, ИмяЗадания);
	УстановитьПривилегированныйРежим(Ложь);
	#КонецОбласти
	
	// Подготовим и выведем отчет.
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	НастройкиКомпоновкиДанных = КомпоновщикНастроек.ПолучитьНастройки();
		
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиКомпоновкиДанных, ДанныеРасшифровки);
		
	КомпоновкаДанныхСервер.УстановитьЗаголовкиМакетаКомпоновки(СтруктураЗаголовковПолей(), МакетКомпоновки);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	
	ПериодОтчета = ОтчетыУТКлиентСервер.ГраницаРасчета(КомпоновщикНастроек, ПоляОтбора.Период);
	ТаблицаПлатежей = Платежи();
	
	ВнешниеНаборыДанных = Новый Структура("ТаблицаПлатежей", ТаблицаПлатежей);
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки, Истина);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	
	#Область ПроверкаВзаиморасчетов
	РегистрыСведений.ЗаданияКРаспределениюРасчетовСКлиентами.ВывестиАктуальностьРасчета(ДокументРезультат, ДопСвойства);
	#КонецОбласти
	
	ПроцессорВывода.НачатьВывод();
	ПроцессорВывода.Вывести(ПроцессорКомпоновки, Истина);
	ПроцессорВывода.ЗакончитьВывод();
	
	// Сообщим форме отчета, что настройки модифицированы
	Если ПользовательскиеНастройкиМодифицированы Тогда
		КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ПользовательскиеНастройкиМодифицированы", Истина);
	КонецЕсли;
	
	ОтчетПустой = ВзаиморасчетыСервер.ОтчетПустой(ПроцессорКомпоновки);
	КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ОтчетПустой", ОтчетПустой);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СтруктураЗаголовковПолей()
	СтруктураЗаголовковПолей = Новый Структура;
	
	СтруктураЗаголовковВалют = КомпоновкаДанныхСервер.СтруктураЗаголовковВалют(КомпоновщикНастроек);
	ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(СтруктураЗаголовковПолей, СтруктураЗаголовковВалют, Ложь);
	
	Возврат СтруктураЗаголовковПолей;
КонецФункции

Процедура УстановитьОбязательныеНастройки(КомпоновщикНастроек, ПользовательскиеНастройкиМодифицированы)
	КомпоновкаДанныхСервер.УстановитьПараметрыВалютыОтчета(КомпоновщикНастроек, ПользовательскиеНастройкиМодифицированы);
	
	УстановитьДатуОтчета(КомпоновщикНастроек, ПользовательскиеНастройкиМодифицированы);
	УстановитьВариантКлассификацииЗадолженности(КомпоновщикНастроек, ПользовательскиеНастройкиМодифицированы);
	УстановитьКалендарь(КомпоновщикНастроек, ПользовательскиеНастройкиМодифицированы);
	
	СегментыСервер.ВключитьОтборПоСегментуПартнеровВСКД(КомпоновщикНастроек);
	
	ТекущаяДата = ТекущаяДатаСеанса();
	ДатаОстатковНачалоДня = НачалоДня(ТекущаяДата);
	ДатаОстатковКонецДня = КонецДня(ТекущаяДата);
	
	ПараметрДатаОтчета = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ДатаОтчета");
	Если ПараметрДатаОтчета <> Неопределено Тогда
		Если Не ЗначениеЗаполнено(ПараметрДатаОтчета.Значение) Тогда
			ДатаОтчета = ТекущаяДата;
		Иначе
			Если ТипЗнч(ПараметрДатаОтчета.Значение) = Тип("Дата") Тогда
				ДатаОтчета = ПараметрДатаОтчета.Значение;
			Иначе
				ДатаОтчета = ПараметрДатаОтчета.Значение.Дата;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	ПараметрДатаОстатков = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ДатаОстатков");
	Если ПараметрДатаОстатков <> Неопределено Тогда
		Если Не ЗначениеЗаполнено(ПараметрДатаОстатков.Значение) Тогда
			ДатаОстатков = ДатаОстатковНачалоДня;
		Иначе
			Если ТипЗнч(ПараметрДатаОстатков.Значение) = Тип("Дата")
				ИЛИ ТипЗнч(ПараметрДатаОстатков.Значение) = Тип("Граница") Тогда
				ДатаОстатков = ПараметрДатаОстатков.Значение;
			Иначе
				ДатаОстатков = ПараметрДатаОстатков.Значение.Дата;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	ПараметрВалюта = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "Валюта");
	Если ПараметрВалюта <> Неопределено Тогда
		Валюта = ПараметрВалюта.Значение;
	КонецЕсли;
	
	ПараметрДанныеОтчета = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ДанныеОтчета");
	Если ПараметрДанныеОтчета <> Неопределено Тогда
		Если ПараметрДанныеОтчета.Использование Тогда
			ДанныеОтчета = ПараметрДанныеОтчета.Значение;
		Иначе
			ДанныеОтчета = 1;
		КонецЕсли;
	КонецЕсли;
	
	ПараметрИспользуетсяОтборПоСегментуПартнеров = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ИспользуетсяОтборПоСегментуПартнеров");
	Если ПараметрИспользуетсяОтборПоСегментуПартнеров <> Неопределено Тогда
		Если ПараметрИспользуетсяОтборПоСегментуПартнеров.Использование Тогда
			ИспользуетсяОтборПоСегментуПартнеров = ПараметрИспользуетсяОтборПоСегментуПартнеров.Значение;
		Иначе
			ИспользуетсяОтборПоСегментуПартнеров = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	ПараметрКалендарь = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "Календарь");
	Если ПараметрКалендарь <> Неопределено Тогда
		Если ПараметрКалендарь.Использование Тогда
			Календарь = ПараметрКалендарь.Значение;
		Иначе
			Календарь = Константы.ОсновнойКалендарьПредприятия.Получить();
		КонецЕсли;
	КонецЕсли;
	
	СтрокаСостояниеВзаиморасчетов = НСтр("ru='Состояние взаиморасчетов'");
	СтрокаДолгНеПросрочен = НСтр("ru='Не просрочено'");
	
	ПараметрВариантКлассификацииЗадолженности = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ВариантКлассификацииЗадолженности");
	Если ПараметрВариантКлассификацииЗадолженности <> Неопределено Тогда
		Если ПараметрВариантКлассификацииЗадолженности.Использование Тогда
			ВариантКлассификацииЗадолженности = ПараметрВариантКлассификацииЗадолженности.Значение;
		Иначе
			ВариантКлассификацииЗадолженности = ОбщегоНазначенияУТВызовСервера.ВариантКлассификацииЗадолженностиПоУмолчанию();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура УстановитьВариантКлассификацииЗадолженности(КомпоновщикНастроек, ПользовательскиеНастройкиМодифицированы)
	ПараметрВариантКлассификацииЗадолженности = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ВариантКлассификацииЗадолженности");
	
	Если НЕ ЗначениеЗаполнено(ПараметрВариантКлассификацииЗадолженности.Значение) Тогда
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ВариантКлассификацииЗадолженности", ОбщегоНазначенияУТВызовСервера.ВариантКлассификацииЗадолженностиПоУмолчанию());
		
		ПользовательскиеНастройкиМодифицированы = Истина;
	КонецЕсли;
КонецПроцедуры

Процедура УстановитьДатуОтчета(КомпоновщикНастроек, ПользовательскиеНастройкиМодифицированы)
	ПараметрДатаОтчета = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ДатаОтчета");
	ПараметрДатаОтчета.Использование = Истина;
	
	ПараметрДатаОстатков = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ДатаОстатков");
	ПараметрДатаОстатков.Использование = Истина;
	
	Если ТипЗнч(ПараметрДатаОтчета.Значение) = Тип("СтандартнаяДатаНачала") Тогда
		Если НЕ ЗначениеЗаполнено(ПараметрДатаОтчета.Значение.Дата) Тогда
			ПараметрДатаОтчета.Значение.Дата = КонецДня(ТекущаяДатаСеанса());
			ПользовательскиеНастройкиМодифицированы = Истина;
		КонецЕсли;
		ПараметрДатаОстатков.Значение = Новый Граница(КонецДня(ПараметрДатаОтчета.Значение.Дата), ВидГраницы.Включая);
	Иначе
		Если НЕ ЗначениеЗаполнено(ПараметрДатаОтчета.Значение) Тогда
			ПараметрДатаОтчета.Значение = КонецДня(ТекущаяДатаСеанса());
			ПользовательскиеНастройкиМодифицированы = Истина;
		КонецЕсли;
		ПараметрДатаОстатков.Значение = Новый Граница(КонецДня(ПараметрДатаОтчета.Значение), ВидГраницы.Включая);
	КонецЕсли;
КонецПроцедуры

Процедура УстановитьКалендарь(КомпоновщикНастроек, ПользовательскиеНастройкиМодифицированы)
	ПараметрВариантКлассификацииЗадолженности = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ВариантКлассификацииЗадолженности");
	ПараметрКалендарь = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "Календарь");
	
	Если ПараметрВариантКлассификацииЗадолженности.Значение.Календарь.Пустая() Тогда
		ОсновнойКалендарьПредприятия = Константы.ОсновнойКалендарьПредприятия.Получить();
		Если Не ОсновнойКалендарьПредприятия.Пустая() Тогда
			КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Календарь", ОсновнойКалендарьПредприятия);
		
			ПользовательскиеНастройкиМодифицированы = Истина;
		КонецЕсли;
	Иначе
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Календарь", ПараметрВариантКлассификацииЗадолженности.Значение.Календарь);
		
		ПользовательскиеНастройкиМодифицированы = Истина;
	КонецЕсли;
КонецПроцедуры

Процедура НастроитьПараметрыОтборыПоФункциональнымОпциям(КомпоновщикНастроекФормы)
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов") Тогда
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(КомпоновщикНастроекФормы, "Контрагент");
	КонецЕсли;
	
	Если НЕ Константы.ИспользоватьНесколькоКлассификацийЗадолженности.Получить() Тогда
		КомпоновкаДанныхСервер.УдалитьПараметрИзПользовательскихНастроекОтчета(КомпоновщикНастроекФормы, "ВариантКлассификацииЗадолженности");
	КонецЕсли;
КонецПроцедуры

Функция Платежи()
	
	ВременныеТаблицы = Новый МенеджерВременныхТаблиц;
	ВзаиморасчетыСервер.РассчитатьДатыПлатежаКлиента(ВременныеТаблицы, ДатаОтчета);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	Сегменты.Партнер КАК Партнер,
	|	Сегменты.Сегмент КАК СегментПартнеров,
	|	ИСТИНА КАК ИспользуетсяОтборПоСегментуПартнеров
	|ПОМЕСТИТЬ ОтборПоСегментуПартнеров
	|ИЗ
	|	РегистрСведений.ПартнерыСегмента КАК Сегменты
	|{ГДЕ
	|	Сегменты.Сегмент.* КАК СегментПартнеров,
	|	Сегменты.Партнер.* КАК Партнер}
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Партнер,
	|	ИспользуетсяОтборПоСегментуПартнеров
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КурсВалюты.Валюта КАК Валюта,
	|	КурсВалюты.Курс * КурсВалютыОтчета.Кратность / (КурсВалюты.Кратность * КурсВалютыОтчета.Курс) КАК КоэффициентПересчета
	|ПОМЕСТИТЬ КурсыВалют
	|ИЗ
	|	РегистрСведений.КурсыВалют.СрезПоследних(&ДатаОстатков, ) КАК КурсВалюты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&ДатаОстатков, Валюта = &Валюта) КАК КурсВалютыОтчета
	|		ПО (ИСТИНА)
	|ГДЕ
	|	КурсВалюты.Кратность <> 0
	|	И КурсВалютыОтчета.Курс <> 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ РАЗРЕШЕННЫЕ
	|	Расчеты.АналитикаУчетаПоПартнерам,
	|	Расчеты.ЗаказКлиента,
	|	Расчеты.ЗаказКлиента.ГруппаФинансовогоУчета КАК ГруппаФинансовогоУчета,
	|	Расчеты.Валюта,
	|	Расчеты.РасчетныйДокумент,
	|	Остатки.ДатаПлатежа КАК ДатаПлатежа,
	|	-(Расчеты.КВозвратуОстаток + Расчеты.ПредоплатаОстаток) КАК НашДолг,
	|	ВЫБОР
	|		КОГДА &ДанныеОтчета = 1
	|			ТОГДА ВЫБОР
	|					КОГДА Расчеты.ДолгУпрОстаток + Расчеты.ПредоплатаУпрОстаток < 0
	|						ТОГДА -(Расчеты.ДолгУпрОстаток + Расчеты.ПредоплатаУпрОстаток)
	|					ИНАЧЕ 0
	|				КОНЕЦ
	|		КОГДА &ДанныеОтчета = 3
	|			ТОГДА ВЫБОР
	|					КОГДА Расчеты.ДолгРеглОстаток + Расчеты.ПредоплатаРеглОстаток < 0
	|						ТОГДА -(Расчеты.ДолгРеглОстаток + Расчеты.ПредоплатаРеглОстаток)
	|					ИНАЧЕ 0
	|				КОНЕЦ
	|	КОНЕЦ КАК НашДолгВВалютеОтчета,
	|
	|	ВЫБОР КОГДА Расчеты.ДолгОстаток > ЕСТЬNULL(Остатки.КОплате, Расчеты.ДолгОстаток)
	|		ТОГДА Остатки.КОплате
	|		ИНАЧЕ Расчеты.ДолгОстаток
	|	КОНЕЦ КАК ДолгКлиента,
	|	
	|	ВЫБОР
	|		КОГДА &ДанныеОтчета = 1
	|			ТОГДА ВЫБОР КОГДА Расчеты.ДолгОстаток > ЕСТЬNULL(Остатки.КОплате, Расчеты.ДолгОстаток)
	|				ТОГДА ВЫРАЗИТЬ((Расчеты.ДолгУпрОстаток / Расчеты.ДолгОстаток * Остатки.КОплате) КАК ЧИСЛО(31,2))
	|				ИНАЧЕ Расчеты.ДолгУпрОстаток
	|			КОНЕЦ
	|		КОГДА &ДанныеОтчета = 3
	|			ТОГДА ВЫБОР КОГДА Расчеты.ДолгОстаток > ЕСТЬNULL(Остатки.КОплате, Расчеты.ДолгОстаток)
	|				ТОГДА ВЫРАЗИТЬ((Расчеты.ДолгРеглОстаток / Расчеты.ДолгОстаток * Остатки.КОплате) КАК ЧИСЛО(31,2))
	|				ИНАЧЕ Расчеты.ДолгРеглОстаток
	|			КОНЕЦ
	|	КОНЕЦ КАК ДолгКлиентаВВалютеОтчета,
	|	0 КАК КОтгрузке,
	|	0 КАК КОтгрузкеВВалютеОтчета,
	|	АналитикаУчета.Партнер,
	|	АналитикаУчета.Организация,
	|	АналитикаУчета.Контрагент,
	|	АналитикаУчета.Договор,
	|	АналитикаУчета.НаправлениеДеятельности,
	|	ОтборПоСегментуПартнеров.СегментПартнеров КАК СегментПартнеров
	|ПОМЕСТИТЬ ТаблицаЗадолженностейПросроченная
	|ИЗ
	|	РегистрНакопления.РасчетыСКлиентамиПоДокументам.Остатки(&ДатаОстатков, ) КАК Расчеты
	|		
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК АналитикаУчета
	|	ПО Расчеты.АналитикаУчетаПоПартнерам = АналитикаУчета.КлючАналитики
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ КурсыВалют КАК КурсыВалют
	|	ПО Расчеты.Валюта = КурсыВалют.Валюта
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаОстатковКлиентов КАК Остатки
	|	ПО Расчеты.АналитикаУчетаПоПартнерам = Остатки.АналитикаУчетаПоПартнерам
	|		И Расчеты.ЗаказКлиента = Остатки.ЗаказКлиента
	|		И Расчеты.РасчетныйДокумент = Остатки.РасчетныйДокумент
	|		И Расчеты.Валюта = Остатки.Валюта
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ ОтборПоСегментуПартнеров КАК ОтборПоСегментуПартнеров
	|	ПО АналитикаУчета.Партнер = ОтборПоСегментуПартнеров.Партнер
	|		И ОтборПоСегментуПартнеров.ИспользуетсяОтборПоСегментуПартнеров = &ИспользуетсяОтборПоСегментуПартнеров 
	|ГДЕ
	|	АналитикаУчета.Партнер <> ЗНАЧЕНИЕ(Справочник.Партнеры.НашеПредприятие)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Расчеты.АналитикаУчетаПоПартнерам,
	|	Расчеты.ЗаказКлиента,
	|	Расчеты.ЗаказКлиента.ГруппаФинансовогоУчета КАК ГруппаФинансовогоУчета,
	|	Расчеты.Валюта,
	|	NULL КАК РасчетныйДокумент,
	|	ДАТАВРЕМЯ(1,1,1) КАК ДатаПлатежа,
	|	0 КАК НашДолг,
	|	0 КАК НашДолгВВалютеОтчета,
	|	0 КАК ДолгКлиента,
	|	0 КАК ДолгКлиентаВВалютеОтчета,
	|	ВЫБОР
	|		КОГДА Расчеты.КОтгрузкеОстаток < 0
	|			ТОГДА -Расчеты.КОтгрузкеОстаток
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК КОтгрузке,
	|	ВЫБОР
	|		КОГДА Расчеты.КОтгрузкеОстаток < 0
	|			ТОГДА -Расчеты.КОтгрузкеОстаток
	|		ИНАЧЕ 0
	|	КОНЕЦ * ЕСТЬNULL(КурсыВалют.КоэффициентПересчета, 1) КАК КОтгрузкеВВалютеОтчета,
	|	АналитикаУчета.Партнер,
	|	АналитикаУчета.Организация,
	|	АналитикаУчета.Контрагент,
	|	АналитикаУчета.Договор,
	|	АналитикаУчета.НаправлениеДеятельности,
	|	ОтборПоСегментуПартнеров.СегментПартнеров КАК СегментПартнеров
	|ИЗ
	|	РегистрНакопления.РасчетыСКлиентами.Остатки(&ДатаОстатков, ) КАК Расчеты
	|		
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК АналитикаУчета
	|	ПО Расчеты.АналитикаУчетаПоПартнерам = АналитикаУчета.КлючАналитики
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ КурсыВалют КАК КурсыВалют
	|	ПО Расчеты.Валюта = КурсыВалют.Валюта
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ ОтборПоСегментуПартнеров КАК ОтборПоСегментуПартнеров
	|	ПО АналитикаУчета.Партнер = ОтборПоСегментуПартнеров.Партнер
	|		И ОтборПоСегментуПартнеров.ИспользуетсяОтборПоСегментуПартнеров = &ИспользуетсяОтборПоСегментуПартнеров 
	|ГДЕ
	|	АналитикаУчета.Партнер <> ЗНАЧЕНИЕ(Справочник.Партнеры.НашеПредприятие)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Таблица.АналитикаУчетаПоПартнерам,
	|	Таблица.ЗаказКлиента,
	|	Таблица.РасчетныйДокумент,
	|	Таблица.Валюта,
	|	Таблица.СегментПартнеров,
	|	СУММА(Таблица.ДолгКлиента) КАК ДолгКлиента,
	|	СУММА(Таблица.ДолгКлиентаВВалютеОтчета) КАК ДолгКлиентаВВалютеОтчета
	|ПОМЕСТИТЬ ВсегоПросрочено
	|ИЗ ТаблицаЗадолженностейПросроченная КАК Таблица
	|СГРУППИРОВАТЬ ПО
	|	АналитикаУчетаПоПартнерам,
	|	ЗаказКлиента,
	|	РасчетныйДокумент,
	|	Валюта,
	|	СегментПартнеров
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ РАЗРЕШЕННЫЕ
	|	Расчеты.АналитикаУчетаПоПартнерам,
	|	Расчеты.ЗаказКлиента,
	|	Расчеты.ЗаказКлиента.ГруппаФинансовогоУчета КАК ГруппаФинансовогоУчета,
	|	Расчеты.Валюта,
	|	Расчеты.РасчетныйДокумент,
	|	&ДатаОтчета КАК ДатаПлатежа,
	|	-(Расчеты.КВозвратуОстаток + Расчеты.ПредоплатаОстаток) КАК НашДолг,
	|	ВЫБОР
	|		КОГДА &ДанныеОтчета = 1
	|			ТОГДА ВЫБОР
	|					КОГДА Расчеты.ДолгУпрОстаток + Расчеты.ПредоплатаУпрОстаток < 0
	|						ТОГДА -(Расчеты.ДолгУпрОстаток + Расчеты.ПредоплатаУпрОстаток)
	|					ИНАЧЕ 0
	|				КОНЕЦ
	|		КОГДА &ДанныеОтчета = 3
	|			ТОГДА ВЫБОР
	|					КОГДА Расчеты.ДолгРеглОстаток + Расчеты.ПредоплатаРеглОстаток < 0
	|						ТОГДА -(Расчеты.ДолгРеглОстаток + Расчеты.ПредоплатаРеглОстаток)
	|					ИНАЧЕ 0
	|				КОНЕЦ
	|	КОНЕЦ КАК НашДолгВВалютеОтчета,
	|
	|	(Расчеты.ДолгОстаток - ЕСТЬNULL(Остатки.ДолгКлиента, Расчеты.ДолгОстаток)) КАК ДолгКлиента,
	|	
	|	ВЫБОР
	|		КОГДА &ДанныеОтчета = 1
	|			ТОГДА (Расчеты.ДолгУпрОстаток - Остатки.ДолгКлиентаВВалютеОтчета)
	|		КОГДА &ДанныеОтчета = 3
	|			ТОГДА (Расчеты.ДолгРеглОстаток - Остатки.ДолгКлиентаВВалютеОтчета)
	|	КОНЕЦ КАК ДолгКлиентаВВалютеОтчета,
	|	0 КАК КОтгрузке,
	|	0 КАК КОтгрузкеВВалютеОтчета,
	|	АналитикаУчета.Партнер,
	|	АналитикаУчета.Организация,
	|	АналитикаУчета.Контрагент,
	|	АналитикаУчета.Договор,
	|	АналитикаУчета.НаправлениеДеятельности,
	|	ОтборПоСегментуПартнеров.СегментПартнеров КАК СегментПартнеров
	|ПОМЕСТИТЬ ТаблицаЗадолженностей
	|ИЗ
	|	РегистрНакопления.РасчетыСКлиентамиПоДокументам.Остатки(&ДатаОстатков, ) КАК Расчеты
	|		
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК АналитикаУчета
	|	ПО Расчеты.АналитикаУчетаПоПартнерам = АналитикаУчета.КлючАналитики
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ КурсыВалют КАК КурсыВалют
	|	ПО Расчеты.Валюта = КурсыВалют.Валюта
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ ОтборПоСегментуПартнеров КАК ОтборПоСегментуПартнеров
	|	ПО АналитикаУчета.Партнер = ОтборПоСегментуПартнеров.Партнер
	|		И ОтборПоСегментуПартнеров.ИспользуетсяОтборПоСегментуПартнеров = &ИспользуетсяОтборПоСегментуПартнеров
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ ВсегоПросрочено КАК Остатки
	|	ПО Расчеты.АналитикаУчетаПоПартнерам = Остатки.АналитикаУчетаПоПартнерам
	|		И Расчеты.ЗаказКлиента = Остатки.ЗаказКлиента
	|		И Расчеты.РасчетныйДокумент = Остатки.РасчетныйДокумент
	|		И Расчеты.Валюта = Остатки.Валюта
	|		И ВЫБОР КОГДА &ИспользуетсяОтборПоСегментуПартнеров ТОГДА ОтборПоСегментуПартнеров.СегментПартнеров = Остатки.СегментПартнеров ИНАЧЕ ИСТИНА КОНЕЦ
	|ГДЕ
	|	АналитикаУчета.Партнер <> ЗНАЧЕНИЕ(Справочник.Партнеры.НашеПредприятие)
	|	И (Расчеты.ДолгОстаток - ЕСТЬNULL(Остатки.ДолгКлиента, Расчеты.ДолгОстаток)) <> 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ 
	|	Расчеты.АналитикаУчетаПоПартнерам,
	|	Расчеты.ЗаказКлиента,
	|	Расчеты.ГруппаФинансовогоУчета,
	|	Расчеты.Валюта,
	|	Расчеты.РасчетныйДокумент,
	|	Расчеты.ДатаПлатежа,
	|	Расчеты.НашДолг,
	|	Расчеты.НашДолгВВалютеОтчета,
	|
	|	Расчеты.ДолгКлиента,
	|	
	|	Расчеты.ДолгКлиентаВВалютеОтчета,
	|	Расчеты.КОтгрузке,
	|	Расчеты.КОтгрузкеВВалютеОтчета,
	|	Расчеты.Партнер,
	|	Расчеты.Организация,
	|	Расчеты.Контрагент,
	|	Расчеты.Договор,
	|	Расчеты.НаправлениеДеятельности,
	|	Расчеты.СегментПартнеров
	|ИЗ
	|	ТаблицаЗадолженностейПросроченная КАК Расчеты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ТаблицаЗадолженностей.ДатаПлатежа КАК ДатаНачала,
	|	ГрафикиРаботы.Дата КАК ДатаОкончания,
	|	ВЫБОР
	|		КОГДА ГрафикиРаботы.ВидДня = ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Рабочий)
	|				ИЛИ ГрафикиРаботы.ВидДня = ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Предпраздничный)
	|			ТОГДА 1
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК РабочийДень
	|ПОМЕСТИТЬ Графики
	|ИЗ
	|	ТаблицаЗадолженностей КАК ТаблицаЗадолженностей
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеПроизводственногоКалендаря КАК ГрафикиРаботы
	|		ПО (ГрафикиРаботы.ПроизводственныйКалендарь = &Календарь)
	|ГДЕ
	|	ГрафикиРаботы.Дата МЕЖДУ ТаблицаЗадолженностей.ДатаПлатежа И &ДатаОтчета
	|	И ТаблицаЗадолженностей.ДатаПлатежа <> ДАТАВРЕМЯ(1, 1, 1)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВложенныйЗапрос.ДатаНачала КАК ДатаНачала,
	|	ВложенныйЗапрос.ДатаОкончания КАК ДатаОкончания,
	|	ЕСТЬNULL(СУММА(Графики.РабочийДень), 0) КАК КоличествоДней
	|ПОМЕСТИТЬ РазностиДат
	|ИЗ
	|	Графики КАК ВложенныйЗапрос
	|		ЛЕВОЕ СОЕДИНЕНИЕ Графики КАК Графики
	|		ПО ВложенныйЗапрос.ДатаНачала = Графики.ДатаНачала
	|			И ВложенныйЗапрос.ДатаОкончания > Графики.ДатаОкончания
	|ГДЕ
	|	ВложенныйЗапрос.ДатаОкончания = НАЧАЛОПЕРИОДА(&ДатаОтчета, ДЕНЬ)
	|
	|СГРУППИРОВАТЬ ПО
	|	ВложенныйЗапрос.ДатаНачала,
	|	ВложенныйЗапрос.ДатаОкончания
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	&СтрокаСостояниеВзаиморасчетов КАК ГруппировкаВсего,
	|	ТаблицаЗадолженностей.АналитикаУчетаПоПартнерам,
	|	ТаблицаЗадолженностей.ЗаказКлиента,
	|	ТаблицаЗадолженностей.Договор КАК Договор,
	|	ТаблицаЗадолженностей.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	ТаблицаЗадолженностей.ГруппаФинансовогоУчета КАК ГруппаФинансовогоУчета,
	|	ТаблицаЗадолженностей.Валюта,
	|	ТаблицаЗадолженностей.РасчетныйДокумент КАК РасчетныйДокумент,
	|	ТаблицаЗадолженностей.ДатаПлатежа КАК ДатаПлатежа,
	|	ТаблицаЗадолженностей.Партнер,
	|	ТаблицаЗадолженностей.Организация,
	|	ТаблицаЗадолженностей.Контрагент,
	|	ТаблицаЗадолженностей.НашДолг,
	|	ТаблицаЗадолженностей.ДолгКлиента,
	|	ТаблицаЗадолженностей.КОтгрузке,
	|	ТаблицаЗадолженностей.НашДолгВВалютеОтчета,
	|	ТаблицаЗадолженностей.ДолгКлиентаВВалютеОтчета,
	|	ТаблицаЗадолженностей.КОтгрузкеВВалютеОтчета,
	|	ВЫБОР
	|		КОГДА НЕ РазностиДат.КоличествоДней ЕСТЬ NULL 
	|			ТОГДА ВЫБОР
	|					КОГДА РазностиДат.КоличествоДней > 0
	|						ТОГДА РазностиДат.КоличествоДней
	|					ИНАЧЕ 0
	|				КОНЕЦ
	|		ИНАЧЕ ВЫБОР
	|				КОГДА ТаблицаЗадолженностей.ДатаПлатежа = ДАТАВРЕМЯ(1, 1, 1)
	|					ТОГДА 0
	|				ИНАЧЕ ВЫБОР
	|						КОГДА РАЗНОСТЬДАТ(ТаблицаЗадолженностей.ДатаПлатежа, &ДатаОтчета, ДЕНЬ) > 0
	|							ТОГДА РАЗНОСТЬДАТ(ТаблицаЗадолженностей.ДатаПлатежа, &ДатаОтчета, ДЕНЬ)
	|						ИНАЧЕ 0
	|					КОНЕЦ
	|			КОНЕЦ
	|	КОНЕЦ КАК КоличествоДней,
	|	ВЫБОР
	|		КОГДА ВЫБОР
	|				КОГДА НЕ РазностиДат.КоличествоДней ЕСТЬ NULL 
	|					ТОГДА ВЫБОР
	|							КОГДА РазностиДат.КоличествоДней > 0
	|								ТОГДА РазностиДат.КоличествоДней
	|							ИНАЧЕ 0
	|						КОНЕЦ
	|				ИНАЧЕ ВЫБОР
	|						КОГДА ТаблицаЗадолженностей.ДатаПлатежа = ДАТАВРЕМЯ(1, 1, 1)
	|							ТОГДА 0
	|						ИНАЧЕ ВЫБОР
	|								КОГДА РАЗНОСТЬДАТ(ТаблицаЗадолженностей.ДатаПлатежа, &ДатаОтчета, ДЕНЬ) > 0
	|									ТОГДА РАЗНОСТЬДАТ(ТаблицаЗадолженностей.ДатаПлатежа, &ДатаОтчета, ДЕНЬ)
	|								ИНАЧЕ 0
	|							КОНЕЦ
	|					КОНЕЦ
	|			КОНЕЦ = 0
	|			ТОГДА 0
	|		ИНАЧЕ ТаблицаЗадолженностей.ДолгКлиента
	|	КОНЕЦ КАК ДолгКлиентаПросрочено,
	|	ВЫБОР
	|		КОГДА ВЫБОР
	|				КОГДА НЕ РазностиДат.КоличествоДней ЕСТЬ NULL 
	|					ТОГДА ВЫБОР
	|							КОГДА РазностиДат.КоличествоДней > 0
	|								ТОГДА РазностиДат.КоличествоДней
	|							ИНАЧЕ 0
	|						КОНЕЦ
	|				ИНАЧЕ ВЫБОР
	|						КОГДА ТаблицаЗадолженностей.ДатаПлатежа = ДАТАВРЕМЯ(1, 1, 1)
	|							ТОГДА 0
	|						ИНАЧЕ ВЫБОР
	|								КОГДА РАЗНОСТЬДАТ(ТаблицаЗадолженностей.ДатаПлатежа, &ДатаОтчета, ДЕНЬ) > 0
	|									ТОГДА РАЗНОСТЬДАТ(ТаблицаЗадолженностей.ДатаПлатежа, &ДатаОтчета, ДЕНЬ)
	|								ИНАЧЕ 0
	|							КОНЕЦ
	|					КОНЕЦ
	|			КОНЕЦ = 0
	|			ТОГДА 0
	|		ИНАЧЕ ТаблицаЗадолженностей.ДолгКлиентаВВалютеОтчета
	|	КОНЕЦ КАК ДолгКлиентаПросроченоВВалютеОтчета,
	|	ЕСТЬNULL(Интервалы.НаименованиеИнтервала, &СтрокаДолгНеПросрочен) КАК НаименованиеИнтервала,
	|	ЕСТЬNULL(Интервалы.НомерСтроки, 0) КАК НомерИнтервала,
	|	ЕСТЬNULL(Интервалы.НижняяГраницаИнтервала, 0) КАК НижняяГраницаИнтервала,
	|	ТаблицаЗадолженностей.СегментПартнеров КАК СегментПартнеров
	|ИЗ
	|	ТаблицаЗадолженностей КАК ТаблицаЗадолженностей
	|		{ЛЕВОЕ СОЕДИНЕНИЕ РазностиДат КАК РазностиДат
	|		ПО (РазностиДат.ДатаНачала = ТаблицаЗадолженностей.ДатаПлатежа)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВариантыКлассификацииЗадолженности.Интервалы КАК Интервалы
	|		ПО (Интервалы.Ссылка = &ВариантКлассификацииЗадолженности)
	|			И (ВЫБОР
	|				КОГДА НЕ РазностиДат.КоличествоДней ЕСТЬ NULL 
	|					ТОГДА ВЫБОР
	|							КОГДА РазностиДат.КоличествоДней > 0
	|								ТОГДА РазностиДат.КоличествоДней
	|							ИНАЧЕ 0
	|						КОНЕЦ
	|				ИНАЧЕ ВЫБОР
	|						КОГДА ТаблицаЗадолженностей.ДатаПлатежа = ДАТАВРЕМЯ(1, 1, 1)
	|							ТОГДА 0
	|						ИНАЧЕ ВЫБОР
	|								КОГДА РАЗНОСТЬДАТ(ТаблицаЗадолженностей.ДатаПлатежа, &ДатаОтчета, ДЕНЬ) > 0
	|									ТОГДА РАЗНОСТЬДАТ(ТаблицаЗадолженностей.ДатаПлатежа, &ДатаОтчета, ДЕНЬ)
	|								ИНАЧЕ 0
	|							КОНЕЦ
	|					КОНЕЦ
	|			КОНЕЦ МЕЖДУ Интервалы.НижняяГраницаИнтервала И Интервалы.ВерхняяГраницаИнтервала)}";
	
	Запрос.МенеджерВременныхТаблиц = ВременныеТаблицы;
	Запрос.УстановитьПараметр("ДатаОтчета", ДатаОтчета);
	Запрос.УстановитьПараметр("ДатаОстатков", ДатаОстатков);
	Запрос.УстановитьПараметр("Валюта", Валюта);
	Запрос.УстановитьПараметр("ДанныеОтчета", ДанныеОтчета);
	Запрос.УстановитьПараметр("ИспользуетсяОтборПоСегментуПартнеров", ИспользуетсяОтборПоСегментуПартнеров);
	Запрос.УстановитьПараметр("Календарь", Календарь);
	Запрос.УстановитьПараметр("СтрокаСостояниеВзаиморасчетов", СтрокаСостояниеВзаиморасчетов);
	Запрос.УстановитьПараметр("СтрокаДолгНеПросрочен", СтрокаДолгНеПросрочен);
	Запрос.УстановитьПараметр("ВариантКлассификацииЗадолженности", ВариантКлассификацииЗадолженности);
	
	Возврат Запрос.Выполнить().Выгрузить();
КонецФункции

#КонецОбласти

#КонецЕсли