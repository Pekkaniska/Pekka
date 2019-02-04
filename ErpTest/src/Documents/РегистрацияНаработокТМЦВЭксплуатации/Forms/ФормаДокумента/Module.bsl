
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("Автотест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриСозданииЧтенииНаСервере();
	КонецЕсли;
	
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
	
	ПриСозданииЧтенииНаСервере();
	
	// Обработчик механизма "ДатыЗапретаИзменения"
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	ЗаполнитьДанныеПредыдущейРегистрации();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормКлиент.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ЗаполнитьДанныеПредыдущейРегистрации();
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОбщегоНазначенияУТКлиент.ВыполнитьДействияПослеЗаписи(ЭтаФорма, Объект, ПараметрыЗаписи);
	
	Оповестить("Запись_РегистрацияНаработокТМЦВЭксплуатации", ПараметрыЗаписи, Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Справочник.ПартииТМЦВЭксплуатации.Форма.ФормаПодбора" Тогда
		ОбработатьПодборПартий(ВыбранноеЗначение);
	КонецЕсли;
	
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
Процедура ДатаПриИзменении(Элемент)
	
	ЗаполнитьДанныеПредыдущейРегистрации();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТабличнойЧастиНаработки

&НаКлиенте
Процедура НаработкиИнвентарныйНомерПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Наработки.ТекущиеДанные;
	Если ЗначениеЗаполнено(ТекущиеДанные.ПартияТМЦВЭксплуатации) Тогда
		
		СтруктураЗначений = ДанныеПредыдущейРегистрации(Объект.Дата, ТекущиеДанные.ПартияТМЦВЭксплуатации);
		ЗаполнитьЗначенияСвойств(ТекущиеДанные, СтруктураЗначений);
		Если ТекущиеДанные.ТекущееЗначение < СтруктураЗначений.ПредыдущаяРегистрацияЗначение Тогда
			ТекущиеДанные.ТекущееЗначение = СтруктураЗначений.ПредыдущаяРегистрацияЗначение;
			ТекущиеДанные.ОтносительноеЗначение = 0;
		Иначе
			ТекущиеДанные.ОтносительноеЗначение = ТекущиеДанные.ТекущееЗначение - СтруктураЗначений.ПредыдущаяРегистрацияЗначение;
		КонецЕсли;
		Если ТекущиеДанные.ПредельныйОбъем < СтруктураЗначений.ПредыдущаяРегистрацияПредельныйОбъем Тогда
			ТекущиеДанные.ПредельныйОбъем = СтруктураЗначений.ПредыдущаяРегистрацияПредельныйОбъем;
		КонецЕсли;
		
	Иначе
		ТекущиеДанные.ПредыдущаяРегистрацияДата = 0;
		ТекущиеДанные.ПредыдущаяРегистрацияЗначение = 0;
		ТекущиеДанные.ПредыдущаяРегистрацияПредельныйОбъем = 0;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаработкиОтносительноеЗначениеПриИзменении(Элемент)
	ТекущиеДанные = Элементы.Наработки.ТекущиеДанные;
	ТекущиеДанные.ТекущееЗначение = ТекущиеДанные.ПредыдущаяРегистрацияЗначение + ТекущиеДанные.ОтносительноеЗначение;
	
КонецПроцедуры

&НаКлиенте
Процедура НаработкиТекущееЗначениеПриИзменении(Элемент)
	ТекущиеДанные = Элементы.Наработки.ТекущиеДанные;
	ТекущиеДанные.ОтносительноеЗначение = ТекущиеДанные.ТекущееЗначение - ТекущиеДанные.ПредыдущаяРегистрацияЗначение;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Подбор(Команда)
	
	ОтборФормы = Новый Структура;
	ОтборФормы.Вставить("ИнвентарныйУчет", Истина);
	ОтборФормы.Вставить("ПометкаУдаления", Ложь);
	ОтборФормы.Вставить("СпособПогашенияСтоимостиБУ", ПредопределенноеЗначение("Перечисление.СпособыПогашенияСтоимостиТМЦ.ПоНаработке"));
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Ложь);
	ПараметрыФормы.Вставить("Дата", Объект.Дата);
	ПараметрыФормы.Вставить("Организация", Объект.Организация);
	ПараметрыФормы.Вставить("Подразделение", Объект.Подразделение);
	ПараметрыФормы.Вставить("ТекущийРегистратор", Объект.Ссылка);
	ПараметрыФормы.Вставить("Отбор", ОтборФормы);
	
	ОткрытьФорму("Справочник.ПартииТМЦВЭксплуатации.Форма.ФормаПодбора", ПараметрыФормы, ЭтаФорма);
	
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

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеПредыдущейРегистрации(Знач СтрокиТаблицы = Неопределено, Знач ЗаполнятьТекущиеДанные = Ложь)
	
	МассивСтрок = Неопределено;
	
	Если СтрокиТаблицы <> Неопределено Тогда
		МассивСтрок = Новый Массив;
		Для Каждого Идентификатор Из СтрокиТаблицы Цикл
			МассивСтрок.Добавить(Объект.Наработки.НайтиПоИдентификатору(Идентификатор));
		КонецЦикла;
	КонецЕсли;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	(ВЫРАЗИТЬ(Таблица.НомерСтроки КАК ЧИСЛО)) - 1 КАК ИндексСтроки,
		|	ВЫРАЗИТЬ(Таблица.ПартияТМЦВЭксплуатации КАК Справочник.ПартииТМЦВЭксплуатации) КАК ПартияТМЦВЭксплуатации,
		|	(ВЫРАЗИТЬ(Таблица.ТекущееЗначение КАК ЧИСЛО)) КАК ТекущееЗначение
		|ПОМЕСТИТЬ Таблица
		|ИЗ
		|	&Таблица КАК Таблица
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Таблица.ИндексСтроки КАК ИндексСтроки,
		|	ЕСТЬNULL(НаработкиТМЦВЭксплуатацииСрезПоследних.Значение, 0) КАК ПредыдущаяРегистрацияЗначение,
		|	ЕСТЬNULL(НаработкиТМЦВЭксплуатацииСрезПоследних.Период, 0) КАК ПредыдущаяРегистрацияДата,
		|	ЕСТЬNULL(НаработкиТМЦВЭксплуатацииСрезПоследних.ПредельныйОбъем, Таблица.ПартияТМЦВЭксплуатации.ОбъемНаработки) КАК ПредыдущаяРегистрацияПредельныйОбъем,
		|	Таблица.ТекущееЗначение - ЕСТЬNULL(НаработкиТМЦВЭксплуатацииСрезПоследних.Значение, 0) КАК ОтносительноеЗначение
		|ИЗ
		|	Таблица КАК Таблица
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НаработкиТМЦВЭксплуатации.СрезПоследних(
		|				&Дата,
		|				Регистратор <> &ТекущийРегистратор
		|					И ИнвентарныйНомер В
		|						(ВЫБРАТЬ
		|							Таблица.ПартияТМЦВЭксплуатации.ИнвентарныйНомер
		|						ИЗ
		|							Таблица КАК Таблица)) КАК НаработкиТМЦВЭксплуатацииСрезПоследних
		|		ПО Таблица.ПартияТМЦВЭксплуатации.ИнвентарныйНомер = НаработкиТМЦВЭксплуатацииСрезПоследних.ИнвентарныйНомер");
	Запрос.УстановитьПараметр("Таблица", Объект.Наработки.Выгрузить(МассивСтрок, "НомерСтроки, ПартияТМЦВЭксплуатации, ТекущееЗначение"));
	Запрос.УстановитьПараметр("Дата", ?(ЗначениеЗаполнено(Объект.Дата), Объект.Дата, ТекущаяДатаСеанса()));
	Запрос.УстановитьПараметр("ТекущийРегистратор", Объект.Ссылка);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		ТекущиеДанные = Объект.Наработки[Выборка.ИндексСтроки];
		ЗаполнитьЗначенияСвойств(ТекущиеДанные, Выборка);
		
		Если ЗаполнятьТекущиеДанные Тогда
			Если ТекущиеДанные.ТекущееЗначение < Выборка.ПредыдущаяРегистрацияЗначение Тогда
				ТекущиеДанные.ТекущееЗначение = Выборка.ПредыдущаяРегистрацияЗначение;
				ТекущиеДанные.ОтносительноеЗначение = 0;
			Иначе
				ТекущиеДанные.ОтносительноеЗначение = ТекущиеДанные.ТекущееЗначение - Выборка.ПредыдущаяРегистрацияЗначение;
			КонецЕсли;
			Если ТекущиеДанные.ПредельныйОбъем < Выборка.ПредыдущаяРегистрацияПредельныйОбъем Тогда
				ТекущиеДанные.ПредельныйОбъем = Выборка.ПредыдущаяРегистрацияПредельныйОбъем;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДанныеПредыдущейРегистрации(Знач Дата, Знач Партия)
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ЕСТЬNULL(НаработкиТМЦВЭксплуатацииСрезПоследних.Значение, 0) КАК ПредыдущаяРегистрацияЗначение,
		|	ЕСТЬNULL(НаработкиТМЦВЭксплуатацииСрезПоследних.Период, ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)) КАК ПредыдущаяРегистрацияДата,
		|	ЕСТЬNULL(НаработкиТМЦВЭксплуатацииСрезПоследних.ПредельныйОбъем, ПартииТМЦВЭксплуатации.ОбъемНаработки) КАК ПредыдущаяРегистрацияПредельныйОбъем
		|ИЗ
		|	Справочник.ПартииТМЦВЭксплуатации КАК ПартииТМЦВЭксплуатации
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НаработкиТМЦВЭксплуатации.СрезПоследних(
		|				&Дата,
		|				ИнвентарныйНомер В
		|					(ВЫБРАТЬ
		|						ПартииТМЦВЭксплуатации.ИнвентарныйНомер
		|					ИЗ
		|						Справочник.ПартииТМЦВЭксплуатации КАК ПартииТМЦВЭксплуатации
		|					ГДЕ
		|						ПартииТМЦВЭксплуатации.Ссылка = &Партия)) КАК НаработкиТМЦВЭксплуатацииСрезПоследних
		|		ПО (ИСТИНА)
		|ГДЕ
		|	ПартииТМЦВЭксплуатации.Ссылка = &Партия");
	Запрос.УстановитьПараметр("Партия", Партия);
	Запрос.УстановитьПараметр("Дата", ?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса()));
	
	СтруктураЗначений = Новый Структура(
		"ПредыдущаяРегистрацияДата, ПредыдущаяРегистрацияЗначение, ПредыдущаяРегистрацияПредельныйОбъем",
		Дата(1, 1, 1), 0, 0);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат СтруктураЗначений;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	ЗаполнитьЗначенияСвойств(СтруктураЗначений, Выборка);
	
	Возврат СтруктураЗначений;
	
КонецФункции

&НаСервере
Процедура ОбработатьПодборПартий(Знач СписокПартий)

	Если СписокПартий.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	МассивСтрок = Новый Массив;
	
	Для Каждого ЭлементМассива Из СписокПартий Цикл
		
		НоваяСтрока = Неопределено;
		
		Если Тип("Структура") = ТипЗнч(ЭлементМассива) Тогда
			
			СтруктураПоиска = Новый Структура("ПартияТМЦВЭксплуатации", ЭлементМассива.ПартияТМЦВЭксплуатации);
			СписокСтрок = Объект.Наработки.НайтиСтроки(СтруктураПоиска);
			Если СписокСтрок.Количество() = 0 Тогда
				НоваяСтрока = Объект.Наработки.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, ЭлементМассива);
			КонецЕсли; 
			
		Иначе
			
			СтруктураПоиска = Новый Структура("ПартияТМЦВЭксплуатации", ЭлементМассива);
			СписокСтрок = Объект.Наработки.НайтиСтроки(СтруктураПоиска);
			Если СписокСтрок.Количество() = 0 Тогда
				НоваяСтрока = Объект.Наработки.Добавить();
				НоваяСтрока.ПартияТМЦВЭксплуатации = ЭлементМассива;
			КонецЕсли; 
			
		КонецЕсли;
		
		Если НоваяСтрока <> Неопределено Тогда
			МассивСтрок.Добавить(НоваяСтрока.ПолучитьИдентификатор());
		КонецЕсли;
		
	КонецЦикла;
	
	ЗаполнитьДанныеПредыдущейРегистрации(МассивСтрок, Истина);

КонецПроцедуры
 
#КонецОбласти

