#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения;

&НаКлиенте
Перем ТекущиеДанныеИдентификатор; //используется для передачи текущей строки в обработчик ожидания

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
		НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(Объект,ПараметрыУказанияСерий);
	КонецЕсли;
	
	#Область СтандартныеМеханизмы
	УстановитьДоступностьКомандБуфераОбмена();
	
	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	ДополнительныеПараметры.Вставить("ОтложеннаяИнициализация", Истина);
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	// Обработчик механизма "Назначения"
	Справочники.Назначения.ФормаДокументаПриСозданииНаСервере(ЭтаФорма);
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	#КонецОбласти

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// Обработчик механизма "ДатыЗапретаИзменения"
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	ПриЧтенииСозданииНаСервере();
	
	СобытияФорм.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	Перем ВыполняемаяОперация;

	Если ИсточникВыбора.ИмяФормы = "Обработка.ПодборТоваровВДокументПродажи.Форма.Форма" Тогда

		ОбработкаВыбораПодборНаСервере(ВыбранноеЗначение);

	ИначеЕсли НоменклатураКлиент.ЭтоУказаниеСерий(ИсточникВыбора) Тогда
		
		НоменклатураКлиент.ОбработатьУказаниеСерии(ЭтаФорма, ПараметрыУказанияСерий, ВыбранноеЗначение);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект, "СканерШтрихкода");
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ЗаполнитьСлужебныеРеквизитыПоНоменклатуре();
	Элементы.СтраницаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияУТКлиент.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(МенеджерОборудованияУТКлиент.ПреобразоватьДанныеСоСканераВМассив(Параметр));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	// Неизвестные штрихкоды
	Если Источник = "ПодключаемоеОборудование"
		И ИмяСобытия = "НеизвестныеШтрихкоды"
		И Параметр.ФормаВладелец = УникальныйИдентификатор Тогда
		
		КэшированныеЗначения.Штрихкоды.Очистить();
		ДанныеШтрихкодов = Новый Массив;
		Для Каждого ПолученныйШтрихкод Из Параметр.ПолученыНовыеШтрихкоды Цикл
			ДанныеШтрихкодов.Добавить(ПолученныйШтрихкод);
		КонецЦикла;
		Для Каждого ПолученныйШтрихкод Из Параметр.ЗарегистрированныеШтрихкоды Цикл
			ДанныеШтрихкодов.Добавить(ПолученныйШтрихкод);
		КонецЦикла;
		
		ОбработатьШтрихкоды(ДанныеШтрихкодов);
		
	КонецЕсли;
	
	Если ИмяСобытия = "КопированиеСтрокВБуферОбмена" Тогда
		
		УстановитьДоступностьКомандБуфераОбменаНаКлиенте();
		
	КонецЕсли;
	
	СобытияФормКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	ОповеститьОПроведенииДокумента(ПараметрыЗаписи);
	
	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормКлиент.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	// СтандартныеПодсистемы.Свойства
	Если ЭтотОбъект.ПараметрыСвойств.Свойство(ТекущаяСтраница.Имя)
			И Не ЭтотОбъект.ПараметрыСвойств.ВыполненаОтложеннаяИнициализация Тогда
			
			СвойстваВыполнитьОтложеннуюИнициализацию();
			УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
		КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусПриИзменении(Элемент)
	
	СтатусПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеОтправительПриИзменении(Элемент)
	
	ПодразделениеОтправительПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПолучательПриИзменении(Элемент)
	
	ПодразделениеПолучательПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыМатериалыИРаботы

&НаКлиенте
Процедура МатериалыИРаботыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле = Элементы.МатериалыИРаботыСерия Тогда
		ОткрытьПодборСерий();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура МатериалыИРаботыУпаковкаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.МатериалыИРаботы.ТекущиеДанные;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц", ПараметрыПересчетаКоличестваЕдиниц());

	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура МатериалыИРаботыНоменклатураПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.МатериалыИРаботы.ТекущиеДанные;

	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", ТекущаяСтрока.Характеристика);
	СтруктураДействий.Вставить("ПроверитьЗаполнитьУпаковкуПоВладельцу", ТекущаяСтрока.Упаковка);
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц", ПараметрыПересчетаКоличестваЕдиниц());
	СтруктураДействий.Вставить("ЗаполнитьПризнакАртикул", Новый Структура("Номенклатура", "Артикул"));
	СтруктураДействий.Вставить("ЗаполнитьПризнакТипНоменклатуры", Новый Структура("Номенклатура", "ТипНоменклатуры"));
	
	ПараметрыПроверкиСерий = Новый Структура("Склад, ПараметрыУказанияСерий");
	ПараметрыПроверкиСерий.Склад = Новый Структура("Отправитель, Получатель", Объект.ПодразделениеОтправитель, Объект.ПодразделениеПолучатель);
	ПараметрыПроверкиСерий.ПараметрыУказанияСерий = ПараметрыУказанияСерий;
	СтруктураДействий.Вставить("ПроверитьСериюРассчитатьСтатус", ПараметрыПроверкиСерий);
	СтруктураДействий.Вставить("ПроверитьЗаполнитьНазначение");
	СтруктураДействий.Вставить("НоменклатураПриИзмененииПереопределяемый", Новый Структура("ИмяФормы, ИмяТабличнойЧасти",
		ЭтаФорма.ИмяФормы, "МатериалыИРаботы"));

	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура МатериалыИРаботыКоличествоУпаковокПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.МатериалыИРаботы.ТекущиеДанные;
	
	СтруктураДействий = Новый Структура;
	ДобавитьВСтруктуруДействияПриИзмененииКоличестваУпаковок(СтруктураДействий);

	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура МатериалыИРаботыСерияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьПодборСерий(Элемент.ТекстРедактирования);

КонецПроцедуры

&НаКлиенте
Процедура МатериалыИРаботыСерияПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.МатериалыИРаботы.ТекущиеДанные;
		
	ВыбранноеЗначение = НоменклатураКлиентСервер.ВыбраннаяСерия();
	
	ВыбранноеЗначение.Значение            		 = ТекущаяСтрока.Серия;
	ВыбранноеЗначение.ИдентификаторТекущейСтроки = ТекущаяСтрока.ПолучитьИдентификатор();
	
	НоменклатураКлиент.ОбработатьУказаниеСерии(ЭтаФорма, ПараметрыУказанияСерий, ВыбранноеЗначение);

КонецПроцедуры

&НаКлиенте
Процедура МатериалыИРаботыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	СкладыКлиент.ОбновитьКешированныеЗначения(Элемент, КэшированныеЗначения, ПараметрыУказанияСерий, Копирование);
	
КонецПроцедуры

&НаКлиенте
Процедура МатериалыИРаботыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если НоменклатураКлиент.НеобходимоОбновитьСтатусыСерий(Элемент,КэшированныеЗначения,ПараметрыУказанияСерий) Тогда
		
		ТекущиеДанные = Элементы.МатериалыИРаботы.ТекущиеДанные;
		ТекущаяСтрокаИдентификатор = ТекущиеДанные.ПолучитьИдентификатор();
		
		ЗаполнитьСтатусыУказанияСерийПриОкончанииРедактированияСтрокиТЧ(ТекущаяСтрокаИдентификатор, КэшированныеЗначения);	
		НоменклатураКлиент.ОбновитьКешированныеЗначенияДляУчетаСерий(Элемент,КэшированныеЗначения,ПараметрыУказанияСерий);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура МатериалыИРаботыПередУдалением(Элемент, Отказ)
	
	НоменклатураКлиент.ОбновитьКешированныеЗначенияДляУчетаСерий(Элемент,КэшированныеЗначения,ПараметрыУказанияСерий);
	
КонецПроцедуры

&НаКлиенте
Процедура МатериалыИРаботыПослеУдаления(Элемент)
	
	Если НоменклатураКлиент.НеобходимоОбновитьСтатусыСерий(Элемент,КэшированныеЗначения,ПараметрыУказанияСерий,Истина) Тогда
		
		ЗаполнитьСтатусыУказанияСерийПриОкончанииРедактированияСтрокиТЧ(Неопределено, КэшированныеЗначения);
		НоменклатураКлиент.ОбновитьКешированныеЗначенияДляУчетаСерий(Элемент,КэшированныеЗначения,ПараметрыУказанияСерий);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура МатериалыИРаботыНазначениеПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.МатериалыИРаботы.ТекущиеДанные;
	ТекущиеДанные.НазначениеОтправителя = ТекущиеДанные.Назначение;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УказатьСерии(Команда)
	
	ОткрытьПодборСерий();
	
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
Процедура РазбитьСтроку(Команда)
	
	ТаблицаФормы  = Элементы.МатериалыИРаботы;
	ДанныеТаблицы = Объект.МатериалыИРаботы;
	
	Оповещение = Новый ОписаниеОповещения("РазбитьСтрокуЗавершение", ЭтотОбъект);
	ОбщегоНазначенияУТКлиент.РазбитьСтрокуТЧ(ДанныеТаблицы, ТаблицаФормы, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура РазбитьСтрокуЗавершение(НоваяСтрока, ДополнительныеПараметры) Экспорт 
	
	ТекущаяСтрока = Элементы.МатериалыИРаботы.ТекущиеДанные;
	
	Если НоваяСтрока <> Неопределено Тогда
		
		СтруктураДействий = Новый Структура;
		ДобавитьВСтруктуруДействияПриИзмененииКоличестваУпаковок(СтруктураДействий);		
		
		ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
		ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(НоваяСтрока, СтруктураДействий, КэшированныеЗначения);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьМатериалыИРаботы(Команда)
	
	ОткрытьПодборТоваров();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкодуВыполнить(Команда)
	
	ОчиститьСообщения();
	Оповещение = Новый ОписаниеОповещения("ПоискПоШтрихкодуЗавершение", ЭтотОбъект);
	ШтрихкодированиеНоменклатурыКлиент.ПоказатьВводШтрихкода(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкодуЗавершение(ДанныхШтрихкода, ДополнительныеПараметры) Экспорт
	
	ОбработатьШтрихкоды(ДанныхШтрихкода);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьВес(Команда)
	
	ТекущаяСтрока = МенеджерОборудованияУТКлиент.ТекущаяСтрока(ЭтаФорма);
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	МенеджерОборудованияКлиент.НачатьПолученияВесаСЭлектронныхВесов(
		Новый ОписаниеОповещения("ПолучитьВесЗавершение", ЭтотОбъект, ТекущаяСтрока),
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьДанныеИзТСД(Команда)
	
	ОчиститьСообщения();
	
	МенеджерОборудованияКлиент.НачатьЗагрузкуДанныеИзТСД(
		Новый ОписаниеОповещения("ЗагрузитьИзТСДЗавершение", ЭтотОбъект),
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ВставитьСтроки(Команда)
	
	КоличествоТоваровДоВставки = Объект.МатериалыИРаботы.Количество();
	
	ПолучитьСтрокиИзБуфераОбмена();
	
	КоличествоВставленных = Объект.МатериалыИРаботы.Количество()-КоличествоТоваровДоВставки;
	КопированиеСтрокКлиент.ОповеститьПользователяОВставкеСтрок(КоличествоВставленных);
	
КонецПроцедуры

&НаКлиенте
Процедура СкопироватьСтроки(Команда)
	
	Если КопированиеСтрокКлиент.ВозможноКопированиеСтрок(Элементы.МатериалыИРаботы.ТекущаяСтрока) Тогда
		СкопироватьСтрокиНаСервере();
		КопированиеСтрокКлиент.ОповеститьПользователяОКопированииСтрок(Элементы.МатериалыИРаботы.ВыделенныеСтроки.Количество());
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСерииПоFEFO(Команда)
	
	Если ЕстьЗаполненныеСерииПоFEFO() Тогда
		
		НоменклатураКлиент.ЗадатьВопросОПерезаполненииСерийПоFEFO(
			Новый ОписаниеОповещения("ЗаполнитьСерииПоFEFOЗавершение", ЭтотОбъект));
		Возврат;
		
	КонецЕсли;
	
	Если Не ЗаполнитьСерииПоFEFOСервер() Тогда
		НоменклатураКлиент.ПредупредитьОбОтсутствииСтрокЗаполняемыхПоFEFO();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСерииПоFEFOЗавершение(Результат, ДополнительныеПараметры) Экспорт 
	
	Если НЕ Результат Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗаполнитьСерииПоFEFOСервер() Тогда
		НоменклатураКлиент.ПредупредитьОбОтсутствииСтрокЗаполняемыхПоFEFO();
	КонецЕсли;

КонецПроцедуры

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

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура СвойстваВыполнитьОтложеннуюИнициализацию()
	
	УправлениеСвойствами.ЗаполнитьДополнительныеРеквизитыВФорме(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

#Область Подбор

&НаКлиенте
Процедура ОткрытьПодборТоваров()

	МассивТиповНоменклатуры = Новый Массив;
	МассивТиповНоменклатуры.Добавить(ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Товар"));
	МассивТиповНоменклатуры.Добавить(ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Работа"));
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимПодбораБезСуммовыхПараметров",         Истина);
	ПараметрыФормы.Вставить("СкрыватьКолонкуВидЦены",                    Истина);
	ПараметрыФормы.Вставить("СкрыватьКомандуЦеныНоменклатуры",           Истина);
	ПараметрыФормы.Вставить("ОтборПоТипуНоменклатуры",                   Новый ФиксированныйМассив(МассивТиповНоменклатуры));
	ПараметрыФормы.Вставить("Заголовок",                                 НСтр("ru = 'Подбор материалов, работ'"));
	ПараметрыФормы.Вставить("Дата",                                      Объект.Дата);
	ПараметрыФормы.Вставить("Документ",                                  Объект.Ссылка);
	ПараметрыФормы.Вставить("СкрыватьКомандуОстаткиНаСкладах",           Истина);
	ПараметрыФормы.Вставить("ПараметрыУказанияСерий",                    ПараметрыУказанияСерий);
	
	ОткрытьФорму("Обработка.ПодборТоваровВДокументПродажи.Форма", ПараметрыФормы, ЭтаФорма, УникальныйИдентификатор);

КонецПроцедуры

&НаСервере
Процедура ОбработкаВыбораПодборНаСервере(ВыбранноеЗначение)

	ТаблицаТоваров = ПолучитьИзВременногоХранилища(ВыбранноеЗначение.АдресТоваровВХранилище);
	
	СтруктураДействий = Новый Структура;
	ДобавитьВСтруктуруДействияПриИзмененииКоличестваУпаковок(СтруктураДействий);
	СтруктураДействий.Вставить("ЗаполнитьПризнакАртикул", Новый Структура("Номенклатура", "Артикул"));
	СтруктураДействий.Вставить("ЗаполнитьПризнакТипНоменклатуры", Новый Структура("Номенклатура", "ТипНоменклатуры"));
	КэшированныеЗначения = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруКэшируемыеЗначения();
	
	Для Каждого СтрокаТовара Из ТаблицаТоваров Цикл
		
		ТекущаяСтрока = Объект.МатериалыИРаботы.Добавить();
		ЗаполнитьЗначенияСвойств(ТекущаяСтрока, СтрокаТовара, "Номенклатура, Характеристика, ХарактеристикиИспользуются, Упаковка, КоличествоУпаковок, Серия");

		ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
	КонецЦикла;
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(Объект,ПараметрыУказанияСерий);
	
КонецПроцедуры

#КонецОбласти

#Область Серии

&НаСервере
Функция ПараметрыФормыУказанияСерий(ТекущиеДанныеИдентификатор)
	
	Возврат НоменклатураСервер.ПараметрыФормыУказанияСерий(Объект, ПараметрыУказанияСерий, ТекущиеДанныеИдентификатор, ЭтаФорма);
	
КонецФункции

&НаСервере
Процедура ОбработатьУказаниеСерийСервер(ПараметрыФормыУказанияСерий)
		
	НоменклатураСервер.ОбработатьУказаниеСерий(Объект,ПараметрыУказанияСерий,ПараметрыФормыУказанияСерий);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтатусыУказанияСерийПриОкончанииРедактированияСтрокиТЧ(ТекущаяСтрокаИдентификатор, КэшированныеЗначения)
	
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерийПриОкончанииРедактированияСтрокиТЧ(Объект, 
				ПараметрыУказанияСерий, ТекущаяСтрокаИдентификатор, КэшированныеЗначения);
	
КонецПроцедуры

&НаСервере
Функция ЗаполнитьСерииПоFEFOСервер()
	Если НоменклатураСервер.ЕстьСтрокиСЗаполняемымиПоFEFOСериями(Объект.МатериалыИРаботы) Тогда
		НоменклатураСервер.ЗаполнитьСерииПоFEFO(Объект,ПараметрыУказанияСерий);	
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
КонецФункции

&НаСервере
Функция ЕстьЗаполненныеСерииПоFEFO()

	Возврат НоменклатураСервер.ЕстьСтрокиСЗаполненнымиПоFEFOСериями(Объект.МатериалыИРаботы);

КонецФункции

&НаКлиенте
Процедура ОткрытьПодборСерий(Текст = "", ТекущиеДанные = Неопределено)
	
	Если НЕ НоменклатураКлиент.ДляУказанияСерийНуженСерверныйВызов(ЭтаФорма, ПараметрыУказанияСерий, Текст, ТекущиеДанные) Тогда
		Возврат;
	КонецЕсли;
		
	Если ТекущиеДанные = Неопределено Тогда
		ТекущиеДанныеИдентификатор = Элементы.МатериалыИРаботы.ТекущиеДанные.ПолучитьИдентификатор();
	Иначе
		ТекущиеДанныеИдентификатор = ТекущиеДанные.ПолучитьИдентификатор();
	КонецЕсли;

	ПараметрыФормыУказанияСерий = ПараметрыФормыУказанияСерий(ТекущиеДанныеИдентификатор);
	ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьПодборСерийЗавершение", ЭтотОбъект, ПараметрыФормыУказанияСерий);
	ОткрытьФорму(ПараметрыФормыУказанияСерий.ИмяФормы, 
					ПараметрыФормыУказанияСерий, 
					ЭтаФорма,,,,
					ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПодборСерийПриСканированииШтрихкодаНоменклатуры()
	
	Если ТекущиеДанныеИдентификатор = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Объект.МатериалыИРаботы.НайтиПоИдентификатору(ТекущиеДанныеИдентификатор);
	ОткрытьПодборСерий(,ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПодборСерийЗавершение(РезультатЗакрытия, ПараметрыФормыУказанияСерий) Экспорт

	Если РезультатЗакрытия <> Неопределено Тогда
		ОбработатьУказаниеСерийСервер(ПараметрыФормыУказанияСерий);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтатусыУказанияСерийСервер(ОбновитьПараметрыУказанияСерий = Ложь)
	
	Если ОбновитьПараметрыУказанияСерий Тогда
		ПараметрыУказанияСерий = Новый ФиксированнаяСтруктура(НоменклатураСервер.ПараметрыУказанияСерий(
																		Объект, 
																		Документы.ПеремещениеМатериаловВПроизводстве));
	КонецЕсли;
	
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(Объект, ПараметрыУказанияСерий);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьЭлементовСерий()
	
	Элементы.МатериалыИРаботыСтатусУказанияСерий.Видимость  = ПараметрыУказанияСерий.ИспользоватьСерииНоменклатуры;
	Элементы.МатериалыИРаботыУказатьСерии.Видимость         = ПараметрыУказанияСерий.ИспользоватьСерииНоменклатуры;
	
	Элементы.МатериалыИРаботыЗаполнитьСерииПоFEFO.Видимость = 
		ПолучитьФункциональнуюОпцию("ИспользоватьСерииНоменклатурыПроизводство", Новый Структура("Подразделение", Объект.ПодразделениеОтправитель));
	
	Элементы.МатериалыИРаботыСерия.Видимость = ПараметрыУказанияСерий.УчитыватьСебестоимостьПоСериям;
	
КонецПроцедуры

#КонецОбласти

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Процедура ОбработатьШтрихкоды(ДанныеШтрихкодов)
	
	СтруктураДействийСДобавленнымиСтроками = Новый Структура;
	СтруктураДействийСДобавленнымиСтроками.Вставить("ЗаполнитьПризнакАртикул", Новый Структура("Номенклатура", "Артикул"));
	СтруктураДействийСДобавленнымиСтроками.Вставить("ЗаполнитьПризнакТипНоменклатуры", Новый Структура("Номенклатура", "ТипНоменклатуры"));
	ДобавитьВСтруктуруДействияПриИзмененииКоличестваУпаковок(СтруктураДействийСДобавленнымиСтроками);

	СтруктураДействийСИзмененнымиСтроками = Новый Структура;
	ДобавитьВСтруктуруДействияПриИзмененииКоличестваУпаковок(СтруктураДействийСИзмененнымиСтроками);

	СтруктураДействий = ШтрихкодированиеНоменклатурыКлиент.ПараметрыОбработкиШтрихкодов();

	СтруктураДействий.Штрихкоды                              = ДанныеШтрихкодов;
	СтруктураДействий.СтруктураДействийСДобавленнымиСтроками = СтруктураДействийСДобавленнымиСтроками;
	СтруктураДействий.СтруктураДействийСИзмененнымиСтроками  = СтруктураДействийСИзмененнымиСтроками;
	СтруктураДействий.ПараметрыУказанияСерий                 = ПараметрыУказанияСерий;
	СтруктураДействий.ИзменятьКоличество                     = Истина;
	СтруктураДействий.ТолькоТовары                           = Истина;
	СтруктураДействий.ИмяТЧ                                  = "МатериалыИРаботы";
	ОбработатьШтрихкодыСервер(СтруктураДействий,КэшированныеЗначения);
	
	ШтрихкодированиеНоменклатурыКлиент.ОбработатьНеизвестныеШтрихкоды(СтруктураДействий,КэшированныеЗначения,ЭтаФорма);
	
	Если ШтрихкодированиеНоменклатурыКлиент.НужноОткрытьФормуУказанияСерийПослеОбработкиШтрихкодов(СтруктураДействий) Тогда
		
		ТекущиеДанныеИдентификатор = СтруктураДействий.МассивСтрокССериями[0];
		
		ПодключитьОбработчикОжидания("ОткрытьПодборСерийПриСканированииШтрихкодаНоменклатуры",0.1,Истина);
			
	КонецЕсли;
	
	Если СтруктураДействий.ТекущаяСтрока <> Неопределено Тогда
		
		Элементы.МатериалыИРаботы.ТекущаяСтрока = СтруктураДействий.ТекущаяСтрока;	
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОбработатьШтрихкодыСервер(СтруктураПараметровДействия, КэшированныеЗначения)
	ШтрихкодированиеНоменклатурыСервер.ОбработатьШтрихкоды(ЭтаФорма,Объект,СтруктураПараметровДействия,КэшированныеЗначения);
КонецПроцедуры

#КонецОбласти

#Область РаботаСБуферомОбмена

&НаСервере
Процедура СкопироватьСтрокиНаСервере()
	
	КопированиеСтрокСервер.ПоместитьВыделенныеСтрокиВБуферОбмена(Элементы.МатериалыИРаботы.ВыделенныеСтроки, Объект.МатериалыИРаботы);
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьСтрокиИзБуфераОбмена()
	
	ПараметрыОтбора = Новый Структура();
	ПараметрыОтбора.Вставить("ОтборПоТипуНоменклатуры", НоменклатураКлиентСервер.ОтборПоТоваруМногооборотнойТаре(Ложь));
	
	ТаблицаТоваров = КопированиеСтрокСервер.ПолучитьСтрокиИзБуфераОбмена(ПараметрыОтбора);
	
	СтруктураДействий = Новый Структура;
	ДобавитьВСтруктуруДействияПриИзмененииКоличестваУпаковок(СтруктураДействий);
	КэшированныеЗначения = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруКэшируемыеЗначения();
	
	Для Каждого СтрокаТовара Из ТаблицаТоваров Цикл
		
		ТекущаяСтрока = Объект.МатериалыИРаботы.Добавить();
		ЗаполнитьЗначенияСвойств(ТекущаяСтрока, СтрокаТовара);

		ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
	КонецЦикла;
	
	ЗаполнитьСлужебныеРеквизитыПоНоменклатуре();
	
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(Объект,ПараметрыУказанияСерий);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьКомандБуфераОбмена()
	
	МассивЭлементов = Новый Массив();
	МассивЭлементов.Добавить("МатериалыИРаботыВставитьСтроки");
	МассивЭлементов.Добавить("МатериалыИРаботыКонтекстноеМенюВставитьСтроки");
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(
			Элементы, 
			МассивЭлементов, 
			"Доступность", 
			НЕ ОбщегоНазначения.ПустойБуферОбмена("Строки"));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьКомандБуфераОбменаНаКлиенте()
	
	МассивЭлементов = Новый Массив();
	МассивЭлементов.Добавить("МатериалыИРаботыВставитьСтроки");
	МассивЭлементов.Добавить("МатериалыИРаботыКонтекстноеМенюВставитьСтроки");
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы, МассивЭлементов, "Доступность", Истина);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ЗаполнитьСлужебныеРеквизитыПоНоменклатуре();
	
	ПараметрыУказанияСерий = Новый ФиксированнаяСтруктура(НоменклатураСервер.ПараметрыУказанияСерий(Объект, Документы.ПеремещениеМатериаловВПроизводстве));
	УстановитьВидимостьЭлементовСерий();
	
	Элементы.СтраницаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	// Стандартное оформление формы
	#Область СтандартноеОформление
	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтаФорма, "МатериалыИРаботыХарактеристика", "Объект.МатериалыИРаботы.ХарактеристикиИспользуются");
	НоменклатураСервер.УстановитьУсловноеОформлениеЕдиницИзмерения(ЭтаФорма, "МатериалыИРаботыНоменклатураЕдиницаИзмерения", "Объект.МатериалыИРаботы.Упаковка");
	НоменклатураСервер.УстановитьУсловноеОформлениеСтатусовУказанияСерий(ЭтаФорма, Ложь, "МатериалыИРаботыСтатусУказанияСерий", "Объект.МатериалыИРаботы.СтатусУказанияСерий");
	НоменклатураСервер.УстановитьУсловноеОформлениеСерийНоменклатуры(ЭтаФорма, Ложь, "МатериалыИРаботыСерия", "Объект.МатериалыИРаботы.СтатусУказанияСерий", "Объект.МатериалыИРаботы.ТипНоменклатуры");
	НоменклатураСервер.УстановитьУсловноеОформлениеНазначенияНоменклатуры(ЭтаФорма, "МатериалыИРаботыНазначение", "Объект.МатериалыИРаботы.ТипНоменклатуры", Ложь);
	#КонецОбласти
		
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСлужебныеРеквизитыПоНоменклатуре()
	
	ПараметрыЗаполненияРеквизитов = Новый Структура;
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются",
											Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакАртикул",
											Новый Структура("Номенклатура", "Артикул"));
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакТипНоменклатуры",
											Новый Структура("Номенклатура", "ТипНоменклатуры"));
											
	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(Объект.МатериалыИРаботы,ПараметрыЗаполненияРеквизитов);
	
КонецПроцедуры

&НаКлиенте
Процедура ОповеститьОПроведенииДокумента(ПараметрыЗаписи)

	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("РежимЗаписи", ПараметрыЗаписи.РежимЗаписи);

	Оповестить("Запись_ПеремещениеМатериаловВПроизводстве", ПараметрыОповещения, Объект.Ссылка);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ДобавитьВСтруктуруДействияПриИзмененииКоличестваУпаковок(СтруктураДействий)
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц", ПараметрыПересчетаКоличестваЕдиниц());
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПараметрыПересчетаКоличестваЕдиниц()

	ПараметрыПересчета = Новый Структура("НужноОкруглять", Ложь);
	Возврат ПараметрыПересчета;

КонецФункции

&НаСервере
Процедура ПодразделениеОтправительПриИзмененииНаСервере()

	ЗаполнитьСтатусыСерийИУстановитьВидимостьСерий();

КонецПроцедуры

&НаСервере
Процедура ПодразделениеПолучательПриИзмененииНаСервере()

	ЗаполнитьСтатусыСерийИУстановитьВидимостьСерий();

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтатусыСерийИУстановитьВидимостьСерий()
	
	ПараметрыУказанияСерий = Новый ФиксированнаяСтруктура(НоменклатураСервер.ПараметрыУказанияСерий(Объект, Документы.ПеремещениеМатериаловВПроизводстве));
	
	УстановитьВидимостьЭлементовСерий();
	ЗаполнитьСтатусыУказанияСерийСервер();
	
КонецПроцедуры

&НаСервере
Процедура СтатусПриИзмененииСервер()

	ЗаполнитьСтатусыУказанияСерийСервер(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьВесЗавершение(РезультатВыполнения, ТекущаяСтрока) Экспорт
	
	Если РезультатВыполнения.Результат Тогда
		ТекущаяСтрока.КоличествоУпаковок = РезультатВыполнения.Вес;
		
		СтруктураДействий = Новый Структура;
		ДобавитьВСтруктуруДействияПриИзмененииКоличестваУпаковок(СтруктураДействий);
		
		ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	Иначе
		МенеджерОборудованияУТКлиент.СообщитьОбОшибке(РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзТСДЗавершение(Результат, Параметры) Экспорт
	
	Если Результат.Результат Тогда
		ОбработатьШтрихкоды(Результат.ТаблицаТоваров);
	Иначе
		МенеджерОборудованияУТКлиент.СообщитьОбОшибке(Результат);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
