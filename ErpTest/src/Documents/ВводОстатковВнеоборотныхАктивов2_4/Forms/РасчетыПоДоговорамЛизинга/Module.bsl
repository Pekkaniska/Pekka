
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОФормление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ПриЧтенииСозданииНаСервере();
		
	КонецЕсли;
	
	#Область УниверсальныеМеханизмы
	
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

	#КонецОбласти
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
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
	
	ПриЧтенииСозданииНаСервере();

	СобытияФорм.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормКлиент.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ВводОстатковВнеоборотныхАктивов2_4", ПараметрыЗаписи, Объект.Ссылка);
	
	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ЗаполнитьСлужебныеРеквизитыТаблицы();
	
	ОбновитьЗаголовокФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	СобытияФормКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПартнерПриИзменении(Элемент)
	
	ПартнерПриИзмененииНаСервере();
	
	Если ПартнерДоИзменения <> Объект.Партнер
		Или КонтрагентДоИзменения <> Объект.Контрагент Тогда
		Если Объект.РасчетыПоДоговорамЛизинга.Количество() <> 0 Тогда
			ТекстВопроса = НСтр("ru = 'При изменении партнера/контрагента будут удалены расчеты. Продолжить?'");
			ОписаниеОповещения = Новый ОписаниеОповещения("КонтрагентПриИзмененииЗавершение", ЭтотОбъект);
			ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Иначе
			КонтрагентПриИзмененииЗавершение(КодВозвратаДиалога.Да, Неопределено);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПартнерПриИзмененииНаСервере()
	
	ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Объект.Партнер, Объект.Контрагент);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	Если КонтрагентДоИзменения = Объект.Контрагент Тогда
		Возврат;
	КонецЕсли;
	
	Если Объект.РасчетыПоДоговорамЛизинга.Количество() <> 0 Тогда
		ТекстВопроса = НСтр("ru = 'При изменении контрагента будут удалены расчеты. Продолжить?'");
		ОписаниеОповещения = Новый ОписаниеОповещения("КонтрагентПриИзмененииЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Иначе
		КонтрагентПриИзмененииЗавершение(КодВозвратаДиалога.Да, Неопределено);
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура РасчетыПоДоговорамЛизингаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("Организация", Объект.Организация);
	СтруктураОтбора.Вставить("Партнер", Объект.Партнер);
	СтруктураОтбора.Вставить("Контрагент", Объект.Контрагент);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаВыбораДоговора", ЭтаФорма);
	ПараметрыФормыВыбора = Новый Структура;
	ПараметрыФормыВыбора.Вставить("Отбор", СтруктураОтбора);
	
	ОткрытьФорму("Справочник.ДоговорыЛизинга.ФормаВыбора", ПараметрыФормыВыбора, ЭтаФорма,,,, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура РасчетыПоДоговорамЛизингаДоговорЛизингаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.РасчетыПоДоговорамЛизинга.ТекущиеДанные;
	Если ЗначениеЗаполнено(ТекущиеДанные.ДоговорЛизинга) Тогда
		ЗаполнитьСлужебныеРеквизитыТаблицы(Элементы.РасчетыПоДоговорамЛизинга.ТекущаяСтрока);
	Иначе
		ТекущиеДанные.ДоговорВВалютеРегл = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РасчетыПоДоговорамЛизингаТипЗадолженностиПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.РасчетыПоДоговорамЛизинга.ТекущиеДанные;
	Если ЗначениеЗаполнено(ТекущиеДанные.ТипЗадолженности) Тогда
		ЗаполнитьСлужебныеРеквизитыТаблицы(Элементы.РасчетыПоДоговорамЛизинга.ТекущаяСтрока);
	Иначе
		ТекущиеДанные.ДоговорВВалютеРегл = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

#Область ПодключаемыеКоманды

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)

	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
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

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОФормление()
	
	УсловноеОформление.Элементы.Очистить();
	
	#Область СуммаРегл
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.РасчетыПоДоговорамЛизингаСуммаРегл.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.РасчетыПоДоговорамЛизинга.ДоговорВВалютеРегл");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='<не требуется>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	
	#КонецОбласти
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()

	ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	
	КонтрагентДоИзменения = Объект.Контрагент;
	ПартнерДоИзменения = Объект.Партнер;
	
	Элементы.Контрагент.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.Контрагенты");
	
	ЗаполнитьСлужебныеРеквизитыТаблицы();
	
	ОбновитьЗаголовокФормы();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЗаголовокФормы()
	
	Заголовок = ВнеоборотныеАктивыВызовСервера.ПредставлениеВводаОстатков(Объект);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСлужебныеРеквизитыТаблицы(ИдентификаторСтроки = Неопределено)
	
	МассивВыделенныхСтрок = Неопределено;
	Если ЗначениеЗаполнено(ИдентификаторСтроки) Тогда
		ДанныеСтроки = Объект.РасчетыПоДоговорамЛизинга.НайтиПоИдентификатору(ИдентификаторСтроки);
		Если ЗначениеЗаполнено(ДанныеСтроки.ДоговорЛизинга) Тогда
			ВалютаВзаиморасчетов = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеСтроки.ДоговорЛизинга, "ВалютаВзаиморасчетов");
			ДанныеСтроки.ДоговорВВалютеРегл = (ВалютаВзаиморасчетов = ВалютаРегламентированногоУчета);
		Иначе
			ДанныеСтроки.ДоговорВВалютеРегл = Ложь;
		КонецЕсли;
	Иначе
		СписокДоговоров = Объект.РасчетыПоДоговорамЛизинга.Выгрузить(, "ДоговорЛизинга").ВыгрузитьКолонку("ДоговорЛизинга");
		ОбщегоНазначенияКлиентСервер.УдалитьВсеВхожденияЗначенияИзМассива(СписокДоговоров, Справочники.ДоговорыЛизинга.ПустаяСсылка());
		ЗначенияРеквизита = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(СписокДоговоров, "ВалютаВзаиморасчетов");
		Для каждого ДанныеСтроки Из Объект.РасчетыПоДоговорамЛизинга Цикл
			ВалютаВзаиморасчетов = ЗначенияРеквизита.Получить(ДанныеСтроки.ДоговорЛизинга);
			ДанныеСтроки.ДоговорВВалютеРегл = (ВалютаВзаиморасчетов = ВалютаРегламентированногоУчета);
		КонецЦикла; 
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбораДоговора(Результат, ДополнительныеПараметры) Экспорт
	
	ОбработкаВыбораДоговораНаСервере(Результат);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаВыбораДоговораНаСервере(ВыбранноеЗначение)
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ЕСТЬNULL(ПорядокОтражения.СчетУчетаРасчетовСЛизингодателемВыкупПредметаЛизинга, ДоговорыЛизинга.ГруппаФинансовогоУчета.СчетУчетаРасчетовСЛизингодателемВыкупПредметаЛизинга) КАК СчетУчетаВыкупПредметаЛизинга,
	|	ЕСТЬNULL(ПорядокОтражения.СчетУчетаРасчетовСЛизингодателемАрендныеОбязательства, ДоговорыЛизинга.ГруппаФинансовогоУчета.СчетУчетаРасчетовСЛизингодателемАрендныеОбязательства) КАК СчетУчетаАрендныеОбязательства,
	|	ЕСТЬNULL(ПорядокОтражения.СчетУчетаРасчетовСЛизингодателемОбеспечительныйПлатеж, ДоговорыЛизинга.ГруппаФинансовогоУчета.СчетУчетаРасчетовСЛизингодателемОбеспечительныйПлатеж) КАК СчетУчетаОбеспечительныйПлатеж,
	|	ЕСТЬNULL(ПорядокОтражения.СчетУчетаРасчетовСЛизингодателемЛизинговыеУслуги, ДоговорыЛизинга.ГруппаФинансовогоУчета.СчетУчетаРасчетовСЛизингодателемЛизинговыеУслуги) КАК СчетУчетаУслугиПоЛизингу,
	|	ДоговорыЛизинга.ВалютаВзаиморасчетов,
	|	ДоговорыЛизинга.ЕстьВыкупПредметаЛизинга,
	|	ДоговорыЛизинга.ЕстьОбеспечительныйПлатеж,
	|	ДоговорыЛизинга.ВариантУчетаИмущества
	|ИЗ
	|	Справочник.ДоговорыЛизинга КАК ДоговорыЛизинга
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.ПорядокОтраженияРасчетовСПартнерами КАК ПорядокОтражения
	|	ПО
	|		ПорядокОтражения.Организация = ДоговорыЛизинга.Организация
	|		И ПорядокОтражения.ГруппаФинансовогоУчета = ДоговорыЛизинга.ГруппаФинансовогоУчета
	|ГДЕ
	|	ДоговорыЛизинга.Ссылка = &Договор";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Договор", ВыбранноеЗначение);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		
		НоваяСтрока = Объект.РасчетыПоДоговорамЛизинга.Добавить();
		НоваяСтрока.ДоговорЛизинга = ВыбранноеЗначение;
		НоваяСтрока.ТипЗадолженности = Перечисления.ТипыПлатежейПоЛизингу.ЛизинговыйПлатеж;
		НоваяСтрока.СчетУчета = Выборка.СчетУчетаУслугиПоЛизингу;
		НоваяСтрока.СальдоДебетовое = Ложь;
		НоваяСтрока.ДоговорВВалютеРегл = Выборка.ВалютаВзаиморасчетов = ВалютаРегламентированногоУчета;
		
		Если Выборка.ЕстьВыкупПредметаЛизинга Тогда
			НоваяСтрока = Объект.РасчетыПоДоговорамЛизинга.Добавить();
			НоваяСтрока.ДоговорЛизинга = ВыбранноеЗначение;
			НоваяСтрока.ТипЗадолженности = Перечисления.ТипыПлатежейПоЛизингу.ВыкупПредметаЛизинга;
			НоваяСтрока.СчетУчета = Выборка.СчетУчетаВыкупПредметаЛизинга;
			НоваяСтрока.СальдоДебетовое = Ложь;
			НоваяСтрока.ДоговорВВалютеРегл = Выборка.ВалютаВзаиморасчетов = ВалютаРегламентированногоУчета;
		КонецЕсли; 
		
		Если Выборка.ЕстьОбеспечительныйПлатеж Тогда
			НоваяСтрока = Объект.РасчетыПоДоговорамЛизинга.Добавить();
			НоваяСтрока.ДоговорЛизинга = ВыбранноеЗначение;
			НоваяСтрока.ТипЗадолженности = Перечисления.ТипыПлатежейПоЛизингу.ОбеспечительныйПлатеж;
			НоваяСтрока.СчетУчета = Выборка.СчетУчетаОбеспечительныйПлатеж;
			НоваяСтрока.СальдоДебетовое = Истина;
			НоваяСтрока.ДоговорВВалютеРегл = Выборка.ВалютаВзаиморасчетов = ВалютаРегламентированногоУчета;
		КонецЕсли; 
		
		Если Выборка.ВариантУчетаИмущества = Перечисления.ВариантыУчетаИмуществаПриЛизинге.НаБалансе Тогда
			НоваяСтрока = Объект.РасчетыПоДоговорамЛизинга.Добавить();
			НоваяСтрока.ДоговорЛизинга = ВыбранноеЗначение;
			НоваяСтрока.ТипЗадолженности = Перечисления.ТипыПлатежейПоЛизингу.АрендныеОбязательства;
			НоваяСтрока.СчетУчета = Выборка.СчетУчетаАрендныеОбязательства;
			НоваяСтрока.СальдоДебетовое = Ложь;
			НоваяСтрока.ДоговорВВалютеРегл = Выборка.ВалютаВзаиморасчетов = ВалютаРегламентированногоУчета;
		КонецЕсли; 
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзмененииЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Объект.РасчетыПоДоговорамЛизинга.Очистить();
	Иначе
		Объект.Контрагент = КонтрагентДоИзменения;
		Объект.Партнер = ПартнерДоИзменения;
	КонецЕсли;
	
	КонтрагентДоИзменения = Объект.Контрагент;
	ПартнерДоИзменения = Объект.Партнер;
	
КонецПроцедуры

#КонецОбласти
