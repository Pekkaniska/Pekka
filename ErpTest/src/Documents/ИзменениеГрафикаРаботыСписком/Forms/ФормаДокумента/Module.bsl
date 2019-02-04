#Область ОписаниеПеременных

&НаКлиенте
Перем ИдентификаторЗамераПроведениеНеНужнаРегистрацияОшибки;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	// Конец Обработчик подсистемы "Печать".
	
	// ЗарплатаКадрыПодсистемы.ПодписиДокументов
	ПодписиДокументов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов
	
	КадровыйУчетФормы.ФормаКадровогоДокументаПриСозданииНаСервере(ЭтаФорма);
	РасчетЗарплатыРасширенныйФормы.ДокументыПриСозданииНаСервере(ЭтаФорма); 
	
	Если Параметры.Ключ.Пустая() Тогда
		
		ЗначенияДляЗаполнения = Новый Структура("Организация, Ответственный, ДатаСобытия",
			"Объект.Организация",
			"Объект.Ответственный",
			"Объект.ДатаИзменения");
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
		
		ПриПолученииДанныхНаСервере();
		
		Объект.Дата = ТекущаяДатаСеанса();
		УстановитьОтветственныхЛиц();
		
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ГосударственнаяСлужбаФормы");
		Модуль.УстановитьПараметрыВыбораСотрудников(ЭтаФорма, "ПоказателиСотрудниковСотрудник");
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПриПолученииДанныхНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)

	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ИдентификаторЗамераПроведениеНеНужнаРегистрацияОшибки = ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	РеквизитВДанные(ТекущийОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ОценкаПроизводительностиКлиент.УстановитьКлючевуюОперациюЗамера(ИдентификаторЗамераПроведениеНеНужнаРегистрацияОшибки, "ПроведениеДокументаИзменениеГрафикаРаботыСписком");
	КонецЕсли;
	
	ИсправлениеДокументовЗарплатаКадрыКлиент.ОповеститьОбИсправленииДокумента(Объект.Ссылка, Объект.ИсправленныйДокумент, ПараметрыЗаписи.РежимЗаписи, "ПериодическиеСведения");
	Оповестить("Запись_ИзменениеГрафикаРаботыСписком", ПараметрыЗаписи, Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ДанныеВРеквизит();
	ПерерасчетЗарплаты.РегистрацияПерерасчетовПоПредварительнымДаннымВФоне(ТекущийОбъект.Ссылка);
	
	// ЗарплатаКадрыПодсистемы.ПодписиДокументов
	ПодписиДокументов.ПослеЗаписиНаСервере(ЭтаФорма);
	// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ЗаписатьИЗакрытьНаКлиенте", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзмененыНачисления" И Источник = ЭтаФорма Тогда
		ЗаполнитьНачисленияИзВременногоХранилища(Параметр.АдресВХранилище);
	КонецЕсли;
	ИсправлениеДокументовЗарплатаКадрыКлиент.ОбработкаОповещенияИсправленногоДокумента(ЭтотОбъект, Объект.Ссылка, ИмяСобытия, Параметр, Источник);
	
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
Процедура Подключаемый_ОткрытьДокументыВведенныеПозже(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗарплатаКадрыРасширенныйКлиент.ОткрытьВведенныеНаДатуДокументы(ЭтотОбъект.ДокументыВведенныеПозже);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОткрытьРанееВведенныеДокументы(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗарплатаКадрыРасширенныйКлиент.ОткрытьВведенныеНаДатуДокументы(ЭтотОбъект.РанееВведенныеДокументы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.КлючевыеРеквизитыЗаполненияФормыОчиститьТаблицы(ЭтаФорма);
	ОрганизацияПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.КлючевыеРеквизитыЗаполненияФормыОчиститьТаблицы(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ГрафикРаботыПриИзменении(Элемент)
	ГрафикРаботыПриИзмененииНаСервере();
КонецПроцедуры

// Обработчик подсистемы "ПодписиДокументов".
&НаКлиенте
Процедура Подключаемый_ПодписиДокументовЭлементПриИзменении(Элемент) 
	ПодписиДокументовКлиент.ПриИзмененииПодписывающегоЛица(ЭтаФорма, Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПодписиДокументовЭлементНажатие(Элемент) 
	ПодписиДокументовКлиент.РасширеннаяПодсказкаНажатие(ЭтаФорма, Элемент.Имя);
КонецПроцедуры
// Конец Обработчик подсистемы "ПодписиДокументов".

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыПоказателиСотрудников

&НаКлиенте
Процедура СотрудникиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ЗначениеЗаполнено(ТекущиеДанные.Сотрудник) Тогда
		
		Если Поле.Имя = "ПоказателиСотрудниковФОТ" Тогда
			
			ПараметрыОткрытия = Новый Структура;
			ПараметрыОткрытия.Вставить("АдресВХранилище", АдресВХранилищеНачисленийИУдержаний(Элемент.ТекущаяСтрока));
			ПараметрыОткрытия.Вставить("ТолькоПросмотр", ТолькоПросмотр);
			
			ЗарплатаКадрыРасширенныйКлиент.ОткрытьФормуРедактированияСоставаНачисленийИУдержаний(ПараметрыОткрытия, ЭтаФорма);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказателиСотрудниковПриАктивизацииСтроки(Элемент)
	
	Если НЕ Элементы.ПоказателиСотрудников.ТекущиеДанные = Неопределено Тогда
		ТекущийСотрудник = Элементы.ПоказателиСотрудников.ТекущиеДанные.Сотрудник;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказателиСотрудниковОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ДополнитьПоказателиСотрудников(ВыбранноеЗначение);
КонецПроцедуры

&НаКлиенте
Процедура ПоказателиСотрудниковСотрудникПриИзменении(Элемент)
	ПоказателиСотрудниковСотрудникПриИзмененииНаСервере(Элементы.ПоказателиСотрудников.ТекущаяСтрока);
КонецПроцедуры

&НаКлиенте
Процедура ПоказателиСотрудниковПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если ОтменаРедактирования Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Элементы.ПоказателиСотрудников.ТекущиеДанные = Неопределено Тогда
		ТекущийСотрудник = Элементы.ПоказателиСотрудников.ТекущиеДанные.Сотрудник;
	КонецЕсли;
	
	КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказателиСотрудниковПередУдалением(Элемент, Отказ)
	
	ТекущиеДанные = ПоказателиСотрудников.НайтиПоИдентификатору(Элементы.ПоказателиСотрудников.ТекущаяСтрока);
	Если ТекущиеДанные.Сотрудник = ТекущийСотрудник Тогда
		УдалитьНачисленияСотрудников(ТекущийСотрудник);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыполнитьПодключаемуюКомандуПослеПодтвержденияЗаписи", ЭтотОбъект, Команда);
	ЗарплатаКадрыРасширенныйКлиент.ПоказатьДиалогЗаписиОбъектаДляВыполненияПодключаемойКоманды(ЭтотОбъект, Команда, ОписаниеОповещения);
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
Процедура ВыполнитьПодключаемуюКомандуПослеПодтвержденияЗаписи(РезультатВопроса, Команда) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.ОК Тогда
		ПараметрыЗаписи = Новый Структура("РежимЗаписи", ?(Объект.Проведен, РежимЗаписиДокумента.Проведение, РежимЗаписиДокумента.Запись));
		ЗаписатьНаКлиенте(Ложь, ПараметрыЗаписи);
		Если Объект.Ссылка.Пустая() Или Модифицированность Тогда
			Возврат; // Запись не удалась, сообщения о причинах выводит платформа.
		КонецЕсли;
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

// ИсправлениеДокументов
&НаКлиенте
Процедура Подключаемый_Исправить(Команда)
	ИсправлениеДокументовЗарплатаКадрыКлиент.Исправить(Объект.Ссылка, "ИзменениеГрафикаРаботыСписком");
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПерейтиКИсправлению(Команда)
	ИсправлениеДокументовЗарплатаКадрыКлиент.ПерейтиКИсправлению(ЭтаФорма.ДокументИсправление, "ИзменениеГрафикаРаботыСписком");
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПерейтиКИсправленному(Команда)
	ИсправлениеДокументовЗарплатаКадрыКлиент.ПерейтиКИсправленному(Объект.ИсправленныйДокумент, "ИзменениеГрафикаРаботыСписком");
КонецПроцедуры
// Конец ИсправлениеДокументов

&НаКлиенте
Процедура ЗаполнитьПодходящихСотрудников(Команда)
	
	Если ПоказателиСотрудников.Количество() > 0 Тогда
		Оповещение = Новый ОписаниеОповещения("ЗаполнитьПодходящихСотрудниковЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, НСтр("ru = 'Табличная часть будет очищена, продолжить?'"), РежимДиалогаВопрос.ДаНет);
	Иначе
		ЗаполнитьПодходящихСотрудниковЗавершение(КодВозвратаДиалога.Да, Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборСотрудников(Команда)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, "ПодборСотрудникаВФормеДокументаИзменениеГрафикаРаботыСписком");
	
	ПараметрыОткрытия = Неопределено;
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль("ГосударственнаяСлужбаКлиент");
		Модуль.УточнитьПараметрыОткрытияФормыВыбораСотрудников(ПараметрыОткрытия);
	КонецЕсли; 
		
	КадровыйУчетКлиент.ВыбратьСотрудниковРаботающихВПериодеПоПараметрамОткрытияФормыСписка(
		Элементы.ПоказателиСотрудников,
		Объект.Организация,
		Объект.Подразделение,
		Объект.ДатаИзменения,
		КонецМесяца(Объект.ДатаИзменения),
		,
		АдресСпискаПодобранныхСотрудников(),
		ПараметрыОткрытия);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриПолученииДанныхНаСервере()
	
	ЗарплатаКадрыРасширенный.ОформлениеНесколькихДокументовНаОднуДатуДополнитьФорму(ЭтотОбъект);
	ИсправлениеДокументовЗарплатаКадры.ГруппаИсправлениеДополнитьФорму(ЭтотОбъект, Истина, Ложь);
	
	ДанныеВРеквизит();
	
КонецПроцедуры

&НаСервере
Процедура ДанныеВРеквизит()
	
	ПрочитатьВремяРегистрации();
	
	МассивСотрудников = Объект.Сотрудники.Выгрузить(,"Сотрудник").ВыгрузитьКолонку("Сотрудник");
	
	ДополнитьФорму();
	ПоказателиСотрудников.Очистить();
	ПоказателиСотрудниковВРеквизитФормы(Объект.Сотрудники);
	ЗаполнитьФОТПоСотрудникам();
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТекущиеЗначенияСовокупныхТарифныхСтавок = Документы.ИзменениеГрафикаРаботыСписком.ТекущиеЗначенияСовокупныхТарифныхСтавокСотрудников(
		Объект.Ссылка, Объект.ДатаИзменения, МассивСотрудников);
	
	УстановитьПривилегированныйРежим(Ложь);
	
	ЗначенияСовокупныхТарифныхСтавокВРеквизитФормы(Объект.ПересчетТарифныхСтавок, ТекущиеЗначенияСовокупныхТарифныхСтавок);
	
	ЗарплатаКадры.КлючевыеРеквизитыЗаполненияФормыЗаполнитьПредупреждения(ЭтаФорма);
	КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения();
	
КонецПроцедуры

// Процедура заполняет таблицу формы в которой редактируются список сотрудников.
// Данные для заполнения берутся из Объект.Сотрудники.
&НаСервере
Процедура ПоказателиСотрудниковВРеквизитФормы(Сотрудники)
	
	СотрудникиДаты = Новый ТаблицаЗначений;
	СотрудникиДаты.Колонки.Добавить("Сотрудник", Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
	СотрудникиДаты.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата"));
	СотрудникиДаты.Колонки.Добавить("ДатаСобытия", Новый ОписаниеТипов("Дата"));
	
	ДатаСобытия = НачалоДня(Объект.ДатаИзменения);
	
	Для Каждого СтрокаСотрудника Из Сотрудники Цикл
		НоваяСтрока = СотрудникиДаты.Добавить();
		НоваяСтрока.ДатаСобытия = ДатаСобытия;
		НоваяСтрока.Сотрудник = СтрокаСотрудника.Сотрудник;
	КонецЦикла;
	
	ВремяРегистрацииДокумента = ЗарплатаКадрыРасширенный.ЗначенияВремениРегистрацииДокумента(Объект.Ссылка, СотрудникиДаты);
	ВремяРегистрацииСотрудников = ВремяРегистрацииДокумента.Получить(ДатаСобытия);
	
	СотрудникиДаты.Колонки.Удалить("ДатаСобытия");
	
	Для Каждого СтрокаСотрудника Из СотрудникиДаты Цикл 
		СтрокаСотрудника.Период = ВремяРегистрацииСотрудников.Получить(СтрокаСотрудника.Сотрудник);
	КонецЦикла;
	
	Запрос = Новый Запрос;
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("СотрудникиДаты", СотрудникиДаты);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	СотрудникиДаты.Период,
	               |	СотрудникиДаты.Сотрудник
	               |ПОМЕСТИТЬ ВТСотрудникиПериоды
	               |ИЗ
	               |	&СотрудникиДаты КАК СотрудникиДаты";
				   
	Запрос.Выполнить();			   
	
	ОписательВременныхТаблиц = КадровыйУчет.ОписательВременныхТаблицДляСоздатьВТКадровыеДанныеСотрудников(Запрос.МенеджерВременныхТаблиц, "ВТСотрудникиПериоды");
	КадровыеДанные = "ДолжностьПоШтатномуРасписанию";
	КадровыйУчет.СоздатьВТКадровыеДанныеСотрудников(ОписательВременныхТаблиц, Истина, КадровыеДанные);
																				   
	ПозицииШтатногоРасписания = Новый Соответствие;
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	КадровыеДанныеСотрудников.Сотрудник,
	               |	КадровыеДанныеСотрудников.ДолжностьПоШтатномуРасписанию
	               |ИЗ
	               |	ВТКадровыеДанныеСотрудников КАК КадровыеДанныеСотрудников";
				   
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл 
		ПозицииШтатногоРасписания.Вставить(Выборка.Сотрудник, Выборка.ДолжностьПоШтатномуРасписанию);
	КонецЦикла;
	
	Отбор = Новый Структура;
	
	Для Каждого СтрокаСотрудника Из Сотрудники Цикл
		
		Отбор.Очистить();
		Отбор.Вставить("Сотрудник", СтрокаСотрудника.Сотрудник);
		Строки = ЭтаФорма["ПоказателиСотрудников"].НайтиСтроки(Отбор);
		Если Строки.Количество() > 0 Тогда
			Строка = Строки[0];
		Иначе
			Строка = ЭтаФорма["ПоказателиСотрудников"].Добавить();
			Строка["Сотрудник"] = СтрокаСотрудника.Сотрудник;
			Строка["ФиксСтрока"] = СтрокаСотрудника.ФиксСтрока;
			Строка["ВремяРегистрации"] = ВремяРегистрацииСотрудников.Получить(СтрокаСотрудника.Сотрудник);
		КонецЕсли;
		
		Строка.ДолжностьПоШтатномуРасписанию = ПозицииШтатногоРасписания.Получить(СтрокаСотрудника.Сотрудник);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗначенияСовокупныхТарифныхСтавокВРеквизитФормы(ЗначенияСовокупныхТарифныхСтавок, ТекущиеЗначенияСовокупныхТарифныхСтавок);
	
	Отбор = Новый Структура;
	
	Для Каждого ДанныеСовокупныхТарифныхСтавок Из ЗначенияСовокупныхТарифныхСтавок Цикл 
		
		Отбор.Вставить("Сотрудник", ДанныеСовокупныхТарифныхСтавок.Сотрудник);
		ДанныеСотрудника = ЭтаФорма["ПоказателиСотрудников"].НайтиСтроки(Отбор);
		
		Если ДанныеСотрудника.Количество() > 0 Тогда 
			
			ДанныеСотрудника[0].СовокупнаяТарифнаяСтавка = ДанныеСовокупныхТарифныхСтавок.СовокупнаяТарифнаяСтавка;
			ДанныеСотрудника[0].ВидТарифнойСтавки = ДанныеСовокупныхТарифныхСтавок.ВидТарифнойСтавки;
			
			ТекущиеДанныеСовокупныхТарифныхСтавок = ТекущиеЗначенияСовокупныхТарифныхСтавок.НайтиСтроки(Отбор);
			
			Если ТекущиеДанныеСовокупныхТарифныхСтавок.Количество() > 0 Тогда 
				ДанныеСотрудника[0].СовокупнаяТарифнаяСтавкаТекущееЗначение = ТекущиеДанныеСовокупныхТарифныхСтавок[0].СовокупнаяТарифнаяСтавка;
				
				СуммаПодстановки = Строка(Формат(ТекущиеДанныеСовокупныхТарифныхСтавок[0].СовокупнаяТарифнаяСтавка, "ЧДЦ=2; ЧРГ="));
				СуммаПодстановки = СтроковыеФункцииКлиентСервер.ДополнитьСтроку(СуммаПодстановки, 10, " ");
				
				ПредставлениеТекущего = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'было: %1'"), СуммаПодстановки);
				ДанныеСотрудника[0].СовокупнаяТарифнаяСтавкаТекущееЗначениеПредставление = ПредставлениеТекущего;
			КонецЕсли;
		
		КонецЕсли;
		
	КонецЦикла;
	
	ЗначенияСовокупныхТарифныхСтавок.Очистить();
	
КонецПроцедуры

// Процедура переносит отредактированный пользователем список сотрудников в Объект.Сотрудники.
&НаСервере
Процедура РеквизитВДанные(ТекущийОбъект)
	
	ТекущийОбъект.Сотрудники.Очистить();
	ТекущийОбъект.ПересчетТарифныхСтавок.Очистить();
	
	Для каждого ПоказателиСотрудника Из ЭтаФорма["ПоказателиСотрудников"] Цикл
		Строка = ТекущийОбъект.Сотрудники.Добавить();
		Строка.Сотрудник = ПоказателиСотрудника.Сотрудник;
		Строка.ФиксСтрока = ПоказателиСотрудника.ФиксСтрока;
		
		// И значения совокупных тарифных ставок.
		Строка = ТекущийОбъект.ПересчетТарифныхСтавок.Добавить();
		Строка.Сотрудник = ПоказателиСотрудника.Сотрудник;
		Строка.СовокупнаяТарифнаяСтавка = ПоказателиСотрудника.СовокупнаяТарифнаяСтавка;
		Строка.ВидТарифнойСтавки = ПоказателиСотрудника.ВидТарифнойСтавки;
	КонецЦикла;
	
	СтрокиДляУдаления = Новый Массив;
	Для каждого СтрокаНачисленияСотрудника Из ТекущийОбъект.НачисленияСотрудников Цикл
		НайденныеСтроки = ТекущийОбъект.Сотрудники.НайтиСтроки(Новый Структура("Сотрудник", СтрокаНачисленияСотрудника.Сотрудник));
		Если НайденныеСтроки.Количество() = 0 Тогда
			СтрокиДляУдаления.Добавить(СтрокаНачисленияСотрудника);
		КонецЕсли;
	КонецЦикла;
	Для каждого СтрокаДляУдаления Из СтрокиДляУдаления Цикл
		ТекущийОбъект.НачисленияСотрудников.Удалить(СтрокаДляУдаления);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПодходящихСотрудниковЗавершение(Ответ, ДополнительныеПараметры) Экспорт 
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьПодходящихСотрудниковНаСервере();
	
КонецПроцедуры

// Процедура заполняет таблицы документа сотрудниками
// Также выполняются все сопутствующие действия: расчет ФОТ и т.п.
&НаСервере
Процедура ЗаполнитьПодходящихСотрудниковНаСервере(ВыводитьСообщения = Истина)
	
	Если НЕ ПроверитьЗаполнение() Тогда
		ПоказателиСотрудников.Очистить();
		ПолучитьСообщенияПользователю(?(ВыводитьСообщения, Ложь, Истина));
		Возврат;
	КонецЕсли;
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	ДокументОбъект.ЗаполнитьДокумент(Объект.ДатаИзменения);
	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
	
	ДанныеВРеквизит();
	
КонецПроцедуры

#Область ФОТ

&НаСервере
Процедура ЗаполнитьФОТПоСотрудникам()
	
	Для каждого СтрокаСотрудника Из ЭтаФорма["ПоказателиСотрудников"] Цикл
		СтрокаСотрудника.ФОТ = ФОТСотрудника(СтрокаСотрудника.Сотрудник);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ФОТСотрудника(Сотрудник)
	
	НачисленияСотрудника = Объект.НачисленияСотрудников.Выгрузить(Новый Структура("Сотрудник", Сотрудник));
	
	Возврат НачисленияСотрудника.Итог("Размер");
	
КонецФункции

&НаСервере
Процедура ПересчитатьФОТИСовокупныеТарифныеСтавки()
	
	Менеджер = Документы.ИзменениеГрафикаРаботыСписком;
	
	РеквизитВДанные(Объект);
	
	ПересчитываемыеНачисления = Объект.НачисленияСотрудников;
	
	Менеджер.РассчитатьФОТ(Объект.Ссылка, Объект.Организация, Объект.ДатаИзменения, Объект.ГрафикРаботы, ПересчитываемыеНачисления, ПоказателиСотрудников);
	
	ЗаполнитьФОТПоСотрудникам();
		
КонецПроцедуры

&НаСервере
Функция АдресВХранилищеНачисленийИУдержаний(ИдентификаторСтроки)
	
	СтрокаСотрудника = ПоказателиСотрудников.НайтиПоИдентификатору(ИдентификаторСтроки);
	
	ПараметрыОткрытия = ЗарплатаКадрыРасширенныйКлиентСервер.ПараметрыРедактированияСоставаНачисленийИУдержаний();
	
	ПараметрыОткрытия.ВладелецНачисленийИУдержаний = СтрокаСотрудника.Сотрудник;
	ПараметрыОткрытия.ДатаРедактирования = СтрокаСотрудника.ВремяРегистрации;
	ПараметрыОткрытия.Организация = Объект.Организация;
	ПараметрыОткрытия.ГрафикРаботы = Объект.ГрафикРаботы;
	ПараметрыОткрытия.РежимРаботы = 3;
	ПараметрыОткрытия.ДополнитьНедостающиеЗначенияПоказателей = Истина;
	
	МассивНачислений = Новый Массив;
	
	ТаблицаСотрудников = Новый ТаблицаЗначений;
	ТаблицаСотрудников.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата"));
	ТаблицаСотрудников.Колонки.Добавить("Организация", Новый ОписаниеТипов("СправочникСсылка.Организации"));
	ТаблицаСотрудников.Колонки.Добавить("Сотрудник", Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
	
	СтрокаТаблицыСотрудников = ТаблицаСотрудников.Добавить();
	СтрокаТаблицыСотрудников.Период = СтрокаСотрудника.ВремяРегистрации;
	СтрокаТаблицыСотрудников.Организация = Объект.Организация;
	СтрокаТаблицыСотрудников.Сотрудник = СтрокаСотрудника.Сотрудник;
	
	СтрокиНачислений = Объект.НачисленияСотрудников.НайтиСтроки(Новый Структура("Сотрудник", СтрокаСотрудника.Сотрудник));
	Для каждого СтрокаНачислений Из СтрокиНачислений Цикл
		
		СтруктураНачисления = Новый Структура("Начисление, ДокументОснование, Размер");
		ЗаполнитьЗначенияСвойств(СтруктураНачисления, СтрокаНачислений);
		МассивНачислений.Добавить(СтруктураНачисления);
		
	КонецЦикла;
	
	ПараметрыОткрытия.ОписаниеТаблицыНачислений.Используется = Истина;
	ПараметрыОткрытия.ОписаниеТаблицыНачислений.Таблица = МассивНачислений;
	ПараметрыОткрытия.ОписаниеТаблицыНачислений.ИзменятьСоставВидовРасчета = Ложь;
	ПараметрыОткрытия.ОписаниеТаблицыНачислений.ИзменятьЗначенияПоказателей = Ложь;
	ПараметрыОткрытия.ОписаниеТаблицыНачислений.НомерТаблицы = 1;
	ПараметрыОткрытия.ОписаниеТаблицыНачислений.ПоказатьФОТ = Истина;
	
	Возврат ПоместитьВоВременноеХранилище(ПараметрыОткрытия, УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Процедура ЗаполнитьНачисленияИзВременногоХранилища(АдресВХранилище);
	
	ДанныеИзХранилища = ПолучитьИзВременногоХранилища(АдресВХранилище);
	Сотрудник = ДанныеИзХранилища.ВладелецНачисленийИУдержаний;
	
	УдалитьНачисленияСотрудников(Сотрудник, Ложь, Ложь);
	ФОТИзменен = Ложь;
	НачисленияСотрудников = Новый Массив;
	Если ДанныеИзХранилища <> Неопределено Тогда
		Для каждого НачислениеСотрудника Из ДанныеИзХранилища.Начисления Цикл
			НоваяСтрокаНачислений = Объект.НачисленияСотрудников.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрокаНачислений, НачислениеСотрудника);
			НоваяСтрокаНачислений.Сотрудник = Сотрудник;
			НачисленияСотрудников.Добавить(НоваяСтрокаНачислений);
		КонецЦикла;
		ФОТИзменен = ДанныеИзХранилища.Модифицированность;
	КонецЕсли;
	
	НайденныеСтроки = ЭтаФорма["ПоказателиСотрудников"].НайтиСтроки(Новый Структура("Сотрудник", Сотрудник));
	Если НайденныеСтроки.Количество() > 0 Тогда
		НайденныеСтроки[0].ФОТ = ФОТСотрудника(Сотрудник);
		Если ФОТИзменен Тогда
			НайденныеСтроки[0].ФиксСтрока = Истина;
		КонецЕсли;
		КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения();
	КонецЕсли;
	
	Если НайденныеСтроки.Количество() > 0 Тогда
		НайденныеСтроки[0].СовокупнаяТарифнаяСтавка = ДанныеИзХранилища.СовокупнаяТарифнаяСтавка;
		НайденныеСтроки[0].ВидТарифнойСтавки = ДанныеИзХранилища.ВидТарифнойСтавки;
	КонецЕсли;
	
	Модифицированность = ДанныеИзХранилища.Модифицированность;
	
КонецПроцедуры

#КонецОбласти

#Область Отрисовка_формы

&НаСервере
Процедура ДополнитьФорму()
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьШтатноеРасписание") Тогда
		ГруппаСотрудник = ЭтаФорма.Элементы.Найти("ГруппаСотрудник");
		ГруппаСотрудник.Заголовок = НСтр("ru = 'Сотрудник / Должность'");
	КонецЕсли;
	
	ИсправлениеДокументовЗарплатаКадры.ПрочитатьРеквизитыИсправления(ЭтаФорма, "ПериодическиеСведения");
	ИсправлениеДокументовЗарплатаКадрыКлиентСервер.УстановитьПоляИсправления(ЭтаФорма, "ПериодическиеСведения");
	
КонецПроцедуры

#КонецОбласти

#Область Серверные_обработчики_событий_формы

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьОтветственныхЛиц();
	
	ЗаполнитьПодходящихСотрудниковНаСервере(Ложь);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтветственныхЛиц()
	
	// ЗарплатаКадрыПодсистемы.ПодписиДокументов
	ПодписиДокументов.ЗаполнитьПодписиПоОрганизации(ЭтаФорма);
	// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаПриИзменении()
	ДатаНачалаПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ДатаНачалаПриИзмененииНаСервере()
	
	ПрочитатьВремяРегистрации();
	УстановитьОтображениеНадписей();
	
КонецПроцедуры

&НаСервере
Процедура ГрафикРаботыПриИзмененииНаСервере()
	ПересчитатьФОТИСовокупныеТарифныеСтавки();
КонецПроцедуры

&НаСервере
Процедура УдалитьНачисленияСотрудников(Сотрудник, УдалитьСотрудников = Истина, УдалитьТарифныеСтавки = Истина)
	
	СтрокиНачислений = Объект.НачисленияСотрудников.НайтиСтроки(Новый Структура("Сотрудник", Сотрудник));
	Для каждого СтрокаНачислений Из СтрокиНачислений Цикл
		Объект.НачисленияСотрудников.Удалить(СтрокаНачислений);
	КонецЦикла;
	
	Если УдалитьСотрудников Тогда
		СтрокиНачислений = Объект.Сотрудники.НайтиСтроки(Новый Структура("Сотрудник", Сотрудник));
		Для каждого СтрокаНачислений Из СтрокиНачислений Цикл
			Объект.Сотрудники.Удалить(СтрокаНачислений);
		КонецЦикла;
	КонецЕсли;
	
	Если УдалитьТарифныеСтавки Тогда
		СтрокиПересчета = Объект.ПересчетТарифныхСтавок.НайтиСтроки(Новый Структура("Сотрудник", Сотрудник));
		Для каждого СтрокаПересчета Из СтрокиПересчета Цикл
			Объект.ПересчетТарифныхСтавок.Удалить(СтрокаПересчета);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПоказателиСотрудниковСотрудникПриИзмененииНаСервере(Идентификатор)
	
	ТекущиеДанные = ПоказателиСотрудников.НайтиПоИдентификатору(Идентификатор);
	НовыйСотрудник = ТекущиеДанные.Сотрудник;
	Если НовыйСотрудник <> ТекущийСотрудник Тогда
		УдалитьНачисленияСотрудников(ТекущийСотрудник);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(НовыйСотрудник) Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные.ВремяРегистрации = ЗарплатаКадрыРасширенный.ВремяРегистрацииСотрудникаДокумента(Объект.Ссылка, ТекущиеДанные.Сотрудник, Объект.ДатаИзменения);
	
	ДополнитьПоказателиСотрудников(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(НовыйСотрудник));
	
КонецПроцедуры

#КонецОбласти

#Область КлючевыеРеквизитыЗаполненияФормы

// Функция возвращает описание таблиц формы подключенных к механизму ключевых реквизитов формы.
&НаСервере
Функция КлючевыеРеквизитыЗаполненияФормыТаблицыОчищаемыеПриИзменении() Экспорт
	
	Массив = Новый Массив;
	Массив.Добавить("ПоказателиСотрудников");
	Массив.Добавить("Объект.Сотрудники");
	Массив.Добавить("Объект.ФизическиеЛица");
	Массив.Добавить("Объект.НачисленияСотрудников");
	Массив.Добавить("Объект.ПересчетТарифныхСтавок");
	
	Возврат Массив;
	
КонецФункции

// Функция возвращает массив реквизитов формы подключенных к механизму ключевых реквизитов формы.
&НаСервере
Функция КлючевыеРеквизитыЗаполненияФормыОписаниеКлючевыхРеквизитов() Экспорт
	
	Массив = Новый Массив;
	Массив.Добавить(Новый Структура("ЭлементФормы, Представление", "Организация",	НСтр("ru = 'организации'")));
	Массив.Добавить(Новый Структура("ЭлементФормы, Представление", "Подразделение",	НСтр("ru = 'подразделения'")));
	
	Возврат Массив;
	
КонецФункции

&НаСервере
Функция КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения()
	
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтотОбъект);
	УстановитьОтображениеНадписей();
	
КонецФункции

// Контролируемые поля
&НаСервере
Функция ПолучитьКонтролируемыеПоля() Экспорт
	
	СтруктураПоказателиСотрудников = Новый Структура("ФиксСтрока");
	КонтролируемыеПоля = Новый Структура("ПоказателиСотрудников", СтруктураПоказателиСотрудников);
	
	Возврат КонтролируемыеПоля;
	
КонецФункции

// Контролируемые поля
&НаСервере
Функция ОписаниеТаблицыПоказателиСотрудников() Экспорт
	
	ОписаниеТаблицыПоказателиСотрудников = Новый Структура;	
	ОписаниеТаблицыПоказателиСотрудников.Вставить("ИмяТаблицы", 	"ПоказателиСотрудников");
	ОписаниеТаблицыПоказателиСотрудников.Вставить("ПутьКДанным", 	"ПоказателиСотрудников");
	ОписаниеТаблицыПоказателиСотрудников.Вставить("ЭтоПерерасчеты", Ложь);
	
	Возврат ОписаниеТаблицыПоказателиСотрудников;
	
КонецФункции

#КонецОбласти

&НаСервере
Процедура ПрочитатьВремяРегистрации()
	
	СотрудникиДаты = Новый ТаблицаЗначений;
	СотрудникиДаты.Колонки.Добавить("Сотрудник", Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
	СотрудникиДаты.Колонки.Добавить("ДатаСобытия", Новый ОписаниеТипов("Дата"));
	
	Для Каждого СтрокаСотрудника Из ПоказателиСотрудников Цикл
		НоваяСтрока = СотрудникиДаты.Добавить();
		НоваяСтрока.ДатаСобытия = Объект.ДатаИзменения;
		НоваяСтрока.Сотрудник = СтрокаСотрудника.Сотрудник;
	КонецЦикла;
	
	ВремяРегистрацииДокумента = ЗарплатаКадрыРасширенный.ЗначенияВремениРегистрацииДокумента(Объект.Ссылка, СотрудникиДаты);
	ВремяРегистрацииСотрудников = ВремяРегистрацииДокумента.Получить(Объект.ДатаИзменения);
	
	Для Каждого СтрокаСотрудника Из ПоказателиСотрудников Цикл
		СтрокаСотрудника.ВремяРегистрации = ВремяРегистрацииСотрудников.Получить(СтрокаСотрудника.Сотрудник);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтображениеНадписей()
	
	УстановитьПривилегированныйРежим(Истина);
	СотрудникиДаты = ПоказателиСотрудников.Выгрузить(, "Сотрудник, ВремяРегистрации");							
	ЗарплатаКадрыРасширенный.УстановитьТекстНадписиОКонкурирующихДокументахПлановыхНачислений(ЭтотОбъект, СотрудникиДаты, Объект.Ссылка, , Объект.ИсправленныйДокумент);
	
КонецПроцедуры

#Область ЗаписьДокумента

&НаКлиенте
Процедура ЗаписатьИЗакрытьНаКлиенте(Результат, ДополнительныеПараметры) Экспорт 
	
	ПараметрыЗаписи = Новый Структура("РежимЗаписи", ?(Объект.Проведен, РежимЗаписиДокумента.Проведение, РежимЗаписиДокумента.Запись));
	ЗаписатьНаКлиенте(Истина, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьНаКлиенте(ЗакрытьПослеЗаписи, ПараметрыЗаписи, ОповещениеЗавершения = Неопределено) Экспорт
	
	ПараметрыЗаписи.Вставить("ПроверкаПередЗаписьюВыполнена", Истина);
	
	Если ОповещениеЗавершения <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ОповещениеЗавершения, ПараметрыЗаписи);
	ИначеЕсли Записать(ПараметрыЗаписи) И ЗакрытьПослеЗаписи Тогда 
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Функция АдресСпискаПодобранныхСотрудников()
	Возврат ПоместитьВоВременноеХранилище(ПоказателиСотрудников.Выгрузить(,"Сотрудник").ВыгрузитьКолонку("Сотрудник"), УникальныйИдентификатор);
КонецФункции

&НаСервере
Процедура ДополнитьПоказателиСотрудников(МассивСотрудников)
	
	ТаблицаНачисленийСотрудников = Документы.ИзменениеГрафикаРаботыСписком.НачисленияСотрудников(
		Объект.Ссылка, Объект.ДатаИзменения, МассивСотрудников);
		
	ТарифныеСтавки = ПоказателиСотрудников.Выгрузить();
	ТарифныеСтавки.Очистить();	
			
	Менеджер = Документы.ИзменениеГрафикаРаботыСписком;
	Менеджер.РассчитатьФОТ(Объект.Ссылка, Объект.Организация, Объект.ДатаИзменения, Объект.ГрафикРаботы, ТаблицаНачисленийСотрудников, ТарифныеСтавки);
	
	Для каждого СотрудникМассива Из МассивСотрудников Цикл
		НайденныеСтроки = Объект.НачисленияСотрудников.НайтиСтроки(Новый Структура("Сотрудник",СотрудникМассива));
		Для каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			Объект.НачисленияСотрудников.Удалить(НайденнаяСтрока);
		КонецЦикла;
	КонецЦикла;
	Для каждого СтрокаНачисленияСотрудников Из ТаблицаНачисленийСотрудников Цикл
		НоваяСтрока = Объект.НачисленияСотрудников.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаНачисленияСотрудников);
	КонецЦикла;
	
	ТаблицаНачисленийСотрудниковВрем = ТаблицаНачисленийСотрудников.Скопировать();
	ТаблицаНачисленийСотрудниковВрем.Свернуть("Сотрудник, ФиксСтрока");
	Для каждого СтрокаНачисленияСотрудников Из ТаблицаНачисленийСотрудниковВрем Цикл
		НоваяСтрока = Объект.Сотрудники.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаНачисленияСотрудников);
	КонецЦикла;
	
	ТекущиеЗначенияСовокупныхТарифныхСтавок = Документы.ИзменениеГрафикаРаботыСписком.ТекущиеЗначенияСовокупныхТарифныхСтавокСотрудников(
		Объект.Ссылка, Объект.ДатаИзменения, МассивСотрудников);
	
	ПоказателиСотрудниковВРеквизитФормы(ТаблицаНачисленийСотрудников);
	ЗаполнитьФОТПоСотрудникам();
	
	ЗначенияСовокупныхТарифныхСтавокВРеквизитФормы(ТарифныеСтавки, ТекущиеЗначенияСовокупныхТарифныхСтавок);
	
КонецПроцедуры

#КонецОбласти
