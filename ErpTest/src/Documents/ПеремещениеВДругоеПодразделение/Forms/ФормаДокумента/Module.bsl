
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
	
	// ЗарплатаКадрыПодсистемы.ПодписиДокументов
	ПодписиДокументов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов
	
	КадровыйУчетФормы.ФормаКадровогоДокументаПриСозданииНаСервере(ЭтаФорма);
	
	Если Параметры.Ключ.Пустая() Тогда
		
		Если НЕ ЗначениеЗаполнено(Объект.ДатаПеремещения) Тогда
			Объект.ДатаПеремещения = ТекущаяДатаСеанса();
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Объект.Организация) Тогда
			ОрганизацияПриИзмененииНаСервере();
		КонецЕсли;
		
		ЗаполнитьДанныеФормыПоОрганизации();
		ПриПолученииДанныхНаСервере();
		
	КонецЕсли;
	
	КадровыйУчетФормыРасширенный.РазместитьКомандуПроверкиШтатномуРасписанию(ЭтаФорма);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ГосударственнаяСлужбаФормы");
		Модуль.УстановитьПараметрыВыбораСотрудников(ЭтаФорма, "СотрудникиСотрудник");
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
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ЗаписатьИЗакрытьНаКлиенте", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)

	Если ПараметрыЗаписи.РежимЗаписи <> РежимЗаписиДокумента.ОтменаПроведения
		И Не ПараметрыЗаписи.Свойство("ПроверкаПередЗаписьюВыполнена") Тогда
		
		Отказ = Истина;
		ЗаписатьНаКлиенте(Ложь, ПараметрыЗаписи);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ПеремещениеВДругоеПодразделение", ПараметрыЗаписи, Объект.Ссылка);
	ИсправлениеДокументовЗарплатаКадрыКлиент.ОповеститьОбИсправленииДокумента(Объект.Ссылка, Объект.ИсправленныйДокумент, ПараметрыЗаписи.РежимЗаписи, "ПериодическиеСведения");
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	КадровыйУчетФормыРасширенный.ЗапуститьОтложеннуюОбработкуДанных(
		ТекущийОбъект, Метаданные.Документы.НачальнаяШтатнаяРасстановка.ТабличныеЧасти.Сотрудники.Реквизиты.Сотрудник);
	
	ДанныеВРеквизиты();
	ПерерасчетЗарплаты.РегистрацияПерерасчетовПоПредварительнымДаннымВФоне(ТекущийОбъект.Ссылка);
	
	// ЗарплатаКадрыПодсистемы.ПодписиДокументов
	ПодписиДокументов.ПослеЗаписиНаСервере(ЭтотОбъект);
	// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
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
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииНаСервере();
	ЗарплатаКадрыКлиент.КлючевыеРеквизитыЗаполненияФормыОчиститьТаблицы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПрежнееПриИзменении(Элемент)
	
	ЗарплатаКадрыКлиент.КлючевыеРеквизитыЗаполненияФормыОчиститьТаблицы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияНоваяПриИзменении(Элемент)
	
	УстановитьДоступностьНовогоПодразделения(ЭтаФорма);
	
КонецПроцедуры

// Обработчик подсистемы "ПодписиДокументов".
&НаКлиенте
Процедура Подключаемый_ПодписиДокументовЭлементПриИзменении(Элемент) 
	ПодписиДокументовКлиент.ПриИзмененииПодписывающегоЛица(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПодписиДокументовЭлементНажатие(Элемент) 
	ПодписиДокументовКлиент.РасширеннаяПодсказкаНажатие(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры
// Конец Обработчик подсистемы "ПодписиДокументов".

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыСотрудники

&НаКлиенте
Процедура СотрудникиПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СотрудникиОбработкаВыбораНаСервере(ВыбранноеЗначение);
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиПослеУдаления(Элемент)
	
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиСотрудникПриИзменении(Элемент)
	
	СотрудникиСотрудникПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиДолжностьПоШтатномуРасписаниюПриИзменении(Элемент)
	
	Если Элементы.Сотрудники.ТекущаяСтрока <> Неопределено
		И ЗначениеЗаполнено(Элементы.Сотрудники.ТекущиеДанные.ДолжностьПоШтатномуРасписанию) Тогда
		
		СотрудникиДолжностьПоШтатномуРасписаниюПриИзмененииНаСервере(Элементы.Сотрудники.ТекущаяСтрока);
		
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

// ИсправлениеДокументов
&НаКлиенте
Процедура Подключаемый_Исправить(Команда)
	ИсправлениеДокументовЗарплатаКадрыКлиент.Исправить(Объект.Ссылка, "ПеремещениеВДругоеПодразделение");
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПерейтиКИсправлению(Команда)
	ИсправлениеДокументовЗарплатаКадрыКлиент.ПерейтиКИсправлению(ЭтаФорма.ДокументИсправление, "ПеремещениеВДругоеПодразделение");
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПерейтиКИсправленному(Команда)
	ИсправлениеДокументовЗарплатаКадрыКлиент.ПерейтиКИсправленному(Объект.ИсправленныйДокумент, "ПеремещениеВДругоеПодразделение");
КонецПроцедуры
// Конец ИсправлениеДокументов

&НаКлиенте
Процедура Подбор(Команда)
	
	ПараметрыОткрытия = Неопределено;
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль("ГосударственнаяСлужбаКлиент");
		Модуль.УточнитьПараметрыОткрытияФормыВыбораСотрудников(ПараметрыОткрытия);
	КонецЕсли; 
		
	КадровыйУчетКлиент.ВыбратьСотрудниковРаботающихНаДатуПоПараметрамОткрытияФормыСписка(
		Элементы.Сотрудники, 
		Объект.Организация,
		Объект.ПодразделениеПрежнее,
		Объект.ДатаПеремещения,
		,
		АдресСпискаПодобранныхСотрудников(),
		ПараметрыОткрытия);
		
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьНаСоответствиеШтатномуРасписанию(Команда)
	
	КадровыйУчетРасширенныйКлиент.ПроверитьНаСоответствиеШтатномуРасписанию(ЭтаФорма, Объект);	
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСотрудникамиПодразделения(Команда) Экспорт
	ЗаполнитьСотрудникамиПодразделенияНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура КомандаПровестиИЗакрыть(Команда) Экспорт
	
	ПараметрыЗаписи = Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение);
	ЗаписатьНаКлиенте(Истина, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПровести(Команда)
	
	ПараметрыЗаписи = Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение);
	ЗаписатьНаКлиенте(Ложь, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаписать(Команда)
	
	ПараметрыЗаписи = Новый Структура("РежимЗаписи", ?(Объект.Проведен, РежимЗаписиДокумента.Проведение, РежимЗаписиДокумента.Запись));
	ЗаписатьНаКлиенте(Ложь, ПараметрыЗаписи);
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

#Область КлючевыеРеквизитыЗаполненияФормы

&НаСервере
// Функция возвращает описание таблиц формы подключенных к механизму ключевых реквизитов формы.
Функция КлючевыеРеквизитыЗаполненияФормыТаблицыОчищаемыеПриИзменении() Экспорт
	
	Массив = Новый Массив;
	Массив.Добавить("Объект.Сотрудники");
	Массив.Добавить("Объект.ФизическиеЛица");
	
	Возврат Массив;
	
КонецФункции

&НаСервере
// Функция возвращает массив реквизитов формы подключенных к механизму ключевых реквизитов формы.
Функция КлючевыеРеквизитыЗаполненияФормыОписаниеКлючевыхРеквизитов() Экспорт
	
	Массив = Новый Массив;
	Массив.Добавить(Новый Структура("ЭлементФормы, Представление", "Организация", Нстр("ru = 'организации'")));
	Массив.Добавить(Новый Структура("ЭлементФормы, Представление", "ПодразделениеПрежнее", Нстр("ru = 'подразделения'")));
	
	Возврат Массив;
	
КонецФункции

#КонецОбласти


&НаСервере
Процедура СотрудникиСотрудникПриИзмененииНаСервере()
	
	СтрокаСотрудник = Объект.Сотрудники.НайтиПоИдентификатору(Элементы.Сотрудники.ТекущаяСтрока);
	
	ПозицииШтатногоРасписания = СотрудникиСПодходящимиПозициямиШтатногоРасписания(Объект.Дата, СтрокаСотрудник.Сотрудник, Объект.ПодразделениеНовое);
	Если ПозицииШтатногоРасписания.Количество() > 0 Тогда
		
		ДанныеПозиции = ПозицииШтатногоРасписания[0];
		Если ПолучитьФункциональнуюОпциюФормы("ИспользоватьШтатноеРасписание") Тогда
			СтрокаСотрудник.ДолжностьПоШтатномуРасписанию = ДанныеПозиции.Должность;
		Иначе
			СтрокаСотрудник.Должность = ДанныеПозиции.Должность;
		КонецЕсли;
		
		Если ДанныеПозиции.Свойство("СпособОтраженияЗарплатыВБухучете") Тогда
			СтрокаСотрудник.СпособОтраженияЗарплатыВБухучете = ДанныеПозиции.СпособОтраженияЗарплатыВБухучете;
		КонецЕсли; 
		
		Если ДанныеПозиции.Свойство("ОтношениеКЕНВД") Тогда
			СтрокаСотрудник.ОтношениеКЕНВД 			= ДанныеПозиции.ОтношениеКЕНВД;
		КонецЕсли; 
		
		Если ДанныеПозиции.Свойство("СтатьяФинансирования") Тогда
			СтрокаСотрудник.СтатьяФинансирования 	= ДанныеПозиции.СтатьяФинансирования;
		КонецЕсли; 
			
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриПолученииДанныхНаСервере()
	
	ДополнитьФорму();
	ДанныеВРеквизиты();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СотрудникиСПодходящимиПозициямиШтатногоРасписания(ДатаПолученияДанных, Сотрудники, Подразделение)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	
	СотрудникиДаты = Новый ТаблицаЗначений;
	СотрудникиДаты.Колонки.Добавить("Сотрудник", Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
	СотрудникиДаты.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата"));
		
	Если ТипЗнч(Сотрудники) = Тип("СправочникСсылка.Сотрудники") Тогда
		СтрокаСотрудникиДаты = СотрудникиДаты.Добавить();
		СтрокаСотрудникиДаты.Сотрудник = Сотрудники;
		СтрокаСотрудникиДаты.Период = ДатаПолученияДанных;
	Иначе
		Для Каждого Сотрудник Из Сотрудники Цикл
			СтрокаСотрудникиДаты = СотрудникиДаты.Добавить();
			СтрокаСотрудникиДаты.Сотрудник = Сотрудник;
			СтрокаСотрудникиДаты.Период = ДатаПолученияДанных;
		КонецЦикла;
	КонецЕсли;
		
	Если ПолучитьФункциональнуюОпцию("ИспользоватьШтатноеРасписание") Тогда
		
		ПараметрыПостроения = ЗарплатаКадрыОбщиеНаборыДанных.ПараметрыПостроенияДляСоздатьВТИмяРегистраСрез();
		ПараметрыПостроения.ВсеЗаписи = Истина;
		
		ЗарплатаКадрыОбщиеНаборыДанных.СоздатьВТИмяРегистраСрезПоследних(
			"КадроваяИсторияСотрудников",
			Запрос.МенеджерВременныхТаблиц,
			Истина,
			ЗарплатаКадрыОбщиеНаборыДанных.ОписаниеФильтраДляСоздатьВТИмяРегистра(СотрудникиДаты),
			ПараметрыПостроения);
		
		Запрос.Текст =
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	КадроваяИсторияСотрудниковСрезПоследних.Сотрудник КАК Сотрудник,
			|	МАКСИМУМ(ЕСТЬNULL(ШтатноеРасписание.Ссылка, ЗНАЧЕНИЕ(Справочник.ШтатноеРасписание.ПустаяСсылка))) КАК Должность
			|ИЗ
			|	ВТКадроваяИсторияСотрудниковСрезПоследних КАК КадроваяИсторияСотрудниковСрезПоследних
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ШтатноеРасписание КАК ШтатноеРасписание
			|		ПО (ШтатноеРасписание.Подразделение = &Подразделение)
			|			И (НЕ ШтатноеРасписание.Закрыта)
			|			И КадроваяИсторияСотрудниковСрезПоследних.Должность = ШтатноеРасписание.Должность
			|
			|СГРУППИРОВАТЬ ПО
			|	КадроваяИсторияСотрудниковСрезПоследних.Сотрудник";
		
		ДанныеСотрудников = Запрос.Выполнить().Выгрузить();
		ДанныеСотрудников.Колонки.Добавить("СпособОтраженияЗарплатыВБухучете");
		ДанныеСотрудников.Колонки.Добавить("ОтношениеКЕНВД");
		ДанныеСотрудников.Колонки.Добавить("СтатьяФинансирования");
		
		Если ПолучитьФункциональнуюОпцию("РаботаВБюджетномУчреждении") Тогда
			
			СписокПозиций = ДанныеСотрудников.ВыгрузитьКолонку("Должность");
			ОбщегоНазначенияКлиентСервер.УдалитьВсеВхожденияЗначенияИзМассива(СписокПозиций, Справочники.ШтатноеРасписание.ПустаяСсылка());
			
			Если СписокПозиций.Количество() > 0 Тогда
				
				УстановитьПривилегированныйРежим(Истина);
				ДанныеПозиций = УправлениеШтатнымРасписанием.ДанныеПозицийШтатногоРасписания(Истина, СписокПозиций, ДатаПолученияДанных);
				УстановитьПривилегированныйРежим(Ложь);
				
				Для каждого СтрокаДанныхСотрудника Из ДанныеСотрудников Цикл
					
					ОписаниеПозиции = ДанныеПозиций.Получить(СтрокаДанныхСотрудника.Должность);
					Если ОписаниеПозиции <> Неопределено Тогда
						СтрокаДанныхСотрудника.СпособОтраженияЗарплатыВБухучете = ОписаниеПозиции.СпособОтраженияЗарплатыВБухучете;
						СтрокаДанныхСотрудника.ОтношениеКЕНВД = ОписаниеПозиции.ОтношениеКЕНВД;
						СтрокаДанныхСотрудника.СтатьяФинансирования = ОписаниеПозиции.СтатьяФинансирования;
					КонецЕсли; 
					
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		Если ПолучитьФункциональнуюОпцию("РаботаВБюджетномУчреждении") Тогда
			КадровыеДанные = "Должность,СпособОтраженияЗарплатыВБухучете,ОтношениеКЕНВД,СтатьяФинансирования";
		Иначе
			КадровыеДанные = "Должность";
		КонецЕсли;
		
		УстановитьПривилегированныйРежим(Истина);
		ДанныеСотрудников = КадровыйУчет.КадровыеДанныеСотрудников(Истина, Сотрудники, КадровыеДанные, ДатаПолученияДанных);
		УстановитьПривилегированныйРежим(Ложь);
		
	КонецЕсли;
	
	Возврат ОбщегоНазначения.ТаблицаЗначенийВМассив(ДанныеСотрудников);
	
КонецФункции

&НаСервере
Функция ПроверкаПередЗаписьюНаСервере(РезультатыПроверки, ДанныеОЗанятыхПозициях)Экспорт 
	
	Возврат КадровыйУчетРасширенный.ПроверкаСоответствияШтатномуРасписанию(ДанныеОЗанятыхПозициях, Объект.Ссылка, Истина, РезультатыПроверки);
	
КонецФункции

&НаКлиенте
Функция ПолучитьДанныеОЗанятыхПозициях()Экспорт
	
	Возврат ПоместитьДанныеОЗанятыхПозицияхВоВременноеХранилище();
	
КонецФункции

&НаСервере
Функция ПоместитьДанныеОЗанятыхПозицияхВоВременноеХранилище()
	
	ИспользуетсяШтатноеРасписание = ПолучитьФункциональнуюОпцию("ИспользоватьШтатноеРасписание");
	
	СписокСотрудников = ОбщегоНазначения.ВыгрузитьКолонку(Объект.Сотрудники, "Сотрудник", Истина);
	ВремяРегистрацииСотрудников = ЗарплатаКадрыРасширенный.ВремяРегистрацииСотрудниковДокумента(Объект.Ссылка, СписокСотрудников, Объект.ДатаПеремещения);
	
	СоответствиеСотрудников = Новый Соответствие;
	Для Каждого СтрокаСотрудники Из Объект.Сотрудники Цикл
		СоответствиеСотрудников.Вставить(СтрокаСотрудники.Сотрудник, Новый Структура("Период,ДолжностьПоШтатномуРасписанию", 
			ВремяРегистрацииСотрудников[СтрокаСотрудники.Сотрудник], ?(ИспользуетсяШтатноеРасписание, СтрокаСотрудники.ДолжностьПоШтатномуРасписанию, СтрокаСотрудники.Должность)));
	КонецЦикла;
	
	Возврат КадровыйУчетРасширенныйВызовСервера.АдресДанныхОЗанятыхПозицияхСотрудниковПриПеремещенииВДругоеПодразделение(СоответствиеСотрудников);
	
КонецФункции	

&НаСервере
Процедура ДополнитьФорму()
	
	УправлениеШтатнымРасписаниемФормы.ПроверкаШтатногоРасписанияПодготовитьТаблицуФормы(ЭтаФорма, РеквизитыПроверяемыеНаСоответствие());
	ИсправлениеДокументовЗарплатаКадры.ГруппаИсправлениеДополнитьФорму(ЭтаФорма, Истина, Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ДанныеВРеквизиты()
	
	// заполним предупреждения 
	ЗарплатаКадры.КлючевыеРеквизитыЗаполненияФормыЗаполнитьПредупреждения(ЭтаФорма);
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтаФорма);
	
	УстановитьФункциональныеОпцииФормы();
	
	ИсправлениеДокументовЗарплатаКадры.ПрочитатьРеквизитыИсправления(ЭтаФорма, "ПериодическиеСведения");
	ИсправлениеДокументовЗарплатаКадрыКлиентСервер.УстановитьПоляИсправления(ЭтаФорма, "ПериодическиеСведения");
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция РеквизитыПроверяемыеНаСоответствие()
	
	РеквизитыПроверяемыеНаСоответствие = Новый Структура("РеквизитыШапки,ТабличныеЧасти", Новый Соответствие, Новый Соответствие);
	
	СтруктураОписанияТЧСотрудники = УправлениеШтатнымРасписаниемКлиентСервер.ОписаниеРеквизитовПроверяемыхНаСоответствие();
	СтруктураОписанияТЧСотрудники.СтруктураПоиска = Новый Структура("Сотрудник,ДолжностьПоШтатномуРасписанию");
	РеквизитНесоответствияСтроки = Новый Структура("ИмяРеквизита,ИмяРеквизитаНесоответствия", "ДолжностьПоШтатномуРасписанию", "ДолжностьПоШтатномуРасписаниюНеСоответствуетПозиции");
	СтруктураОписанияТЧСотрудники.РасшифровкаНачислений = Ложь;
	СтруктураОписанияТЧСотрудники.РеквизитНесоответствияСтроки = РеквизитНесоответствияСтроки;
	
	РеквизитыПроверяемыеНаСоответствие.ТабличныеЧасти.Вставить("Сотрудники", СтруктураОписанияТЧСотрудники);
	
	Возврат РеквизитыПроверяемыеНаСоответствие;
	
КонецФункции

&НаКлиенте
Функция РеквизитыПроверяемыеНаСоответствиеНаКлиенте() Экспорт
	
	Возврат РеквизитыПроверяемыеНаСоответствие();
	
КонецФункции

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	Объект.ОрганизацияНовая = Объект.Организация;
	
	Если ЗначениеЗаполнено(Объект.ПодразделениеНовое) Тогда
		Если Объект.ОрганизацияНовая <> ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.ПодразделениеНовое, "Владелец") Тогда
			Объект.ПодразделениеНовое = Справочники.ПодразделенияОрганизаций.ПустаяСсылка();
		КонецЕсли;
	КонецЕсли;
	
	ЗаполнитьДанныеФормыПоОрганизации();
	
	УстановитьДоступностьНовогоПодразделения(ЭтаФорма);
	УстановитьФункциональныеОпцииФормы();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьНовогоПодразделения(Форма)
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"ПодразделениеНовое",
		"Доступность",
		ЗначениеЗаполнено(Форма.Объект.ОрганизацияНовая));
	
КонецПроцедуры

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()
	
	ГоловнаяОрганизация = ЗарплатаКадры.ГоловнаяОрганизация(Объект.Организация);
	
	ПараметрыФО = Новый Структура("Организация", ГоловнаяОрганизация);
	УстановитьПараметрыФункциональныхОпцийФормы(ПараметрыФО);
	
КонецПроцедуры

&НаСервере
Процедура СотрудникиОбработкаВыбораНаСервере(ВыбранноеЗначение)
	
	СотрудникиСПодходящимиПозициямиШтатногоРасписания = СотрудникиСПодходящимиПозициямиШтатногоРасписания(Объект.Дата, ВыбранноеЗначение, Объект.ПодразделениеНовое);
	ЗаполнитьДокументПОСпискуСотрудников(СотрудникиСПодходящимиПозициямиШтатногоРасписания);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСотрудникамиПодразделенияНаСервере()
	
	Если Не ЗначениеЗаполнено(Объект.ПодразделениеПрежнее)
		Или Не ЗначениеЗаполнено(Объект.ПодразделениеНовое) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПолученияСотрудников = КадровыйУчет.ПараметрыПолученияСотрудниковОрганизацийПоСпискуФизическихЛиц();
	ПараметрыПолученияСотрудников.Организация = Объект.Организация;
	ПараметрыПолученияСотрудников.Подразделение = Объект.ПодразделениеПрежнее;
	ПараметрыПолученияСотрудников.НачалоПериода = Объект.ДатаПеремещения;
	ПараметрыПолученияСотрудников.ОкончаниеПериода = Объект.ДатаПеремещения;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ГосударственнаяСлужба");
		Модуль.ДобавитьОтборыПоВидуДоговора(ПараметрыПолученияСотрудников.Отборы);
	КонецЕсли; 
	
	Сотрудники = КадровыйУчет.СотрудникиОрганизации(Истина, ПараметрыПолученияСотрудников).ВыгрузитьКолонку("Сотрудник");
	
	СотрудникиСПодходящимиДолжностями = СотрудникиСПодходящимиПозициямиШтатногоРасписания(Объект.Дата, Сотрудники, Объект.ПодразделениеНовое);
	
	ЗаполнитьДокументПОСпискуСотрудников(СотрудникиСПодходящимиДолжностями);
	
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДокументПОСпискуСотрудников(СотрудникиСПодходящимиДолжностями)
	
	Для Каждого ВыбранныйСотрудник Из СотрудникиСПодходящимиДолжностями Цикл
		
		СтруктураПоиска = Новый Структура("Сотрудник", ВыбранныйСотрудник.Сотрудник);
		Если Объект.Сотрудники.НайтиСтроки(СтруктураПоиска).Количество() = 0 Тогда
			НоваяСтрока = Объект.Сотрудники.Добавить();
			НоваяСтрока.Сотрудник = ВыбранныйСотрудник.Сотрудник;
			
			Если ПолучитьФункциональнуюОпциюФормы("ИспользоватьШтатноеРасписание") Тогда
				НоваяСтрока.ДолжностьПоШтатномуРасписанию = ВыбранныйСотрудник.Должность;
			Иначе
				НоваяСтрока.Должность = ВыбранныйСотрудник.Должность;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция АдресСпискаПодобранныхСотрудников()
	
	Возврат ПоместитьВоВременноеХранилище(Объект.Сотрудники.Выгрузить(,"Сотрудник").ВыгрузитьКолонку("Сотрудник"), УникальныйИдентификатор);
	
КонецФункции

#Область ЗаписьДокумента

&НаКлиенте
Процедура ЗаписатьИЗакрытьНаКлиенте(Результат, ДополнительныеПараметры) Экспорт 
	
	ПараметрыЗаписи = Новый Структура("РежимЗаписи", ?(Объект.Проведен, РежимЗаписиДокумента.Проведение, РежимЗаписиДокумента.Запись));
	ЗаписатьНаКлиенте(Истина, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьНаКлиенте(ЗакрытьПослеЗаписи, ПараметрыЗаписи, ОповещениеЗавершения = Неопределено)

	КадровыйУчетРасширенныйКлиент.ПередЗаписьюКадровогоДокументаВФорме(ЭтаФорма, Объект, ПараметрыЗаписи, ОповещениеЗавершения, ЗакрытьПослеЗаписи);  
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура СотрудникиДолжностьПоШтатномуРасписаниюПриИзмененииНаСервере(ИдентификаторСтроки)
	
	ТекущиеДанные = Объект.Сотрудники.НайтиПоИдентификатору(ИдентификаторСтроки);
	Если ТекущиеДанные <> Неопределено Тогда
		
		ДанныеПозиции = УправлениеШтатнымРасписанием.ДанныеПозицииШтатногоРасписания(
			ТекущиеДанные.ДолжностьПоШтатномуРасписанию, Объект.ДатаПеремещения, Ложь);
			
		Если ДанныеПозиции.Свойство("СпособОтраженияЗарплатыВБухучете") Тогда
			ТекущиеДанные.СпособОтраженияЗарплатыВБухучете = ДанныеПозиции.СпособОтраженияЗарплатыВБухучете;
		КонецЕсли; 
		
		Если ДанныеПозиции.Свойство("ОтношениеКЕНВД") Тогда
			ТекущиеДанные.ОтношениеКЕНВД = ДанныеПозиции.ОтношениеКЕНВД;
		КонецЕсли; 
		
		Если ДанныеПозиции.Свойство("СтатьяФинансирования") Тогда
			ТекущиеДанные.СтатьяФинансирования = ДанныеПозиции.СтатьяФинансирования;
		КонецЕсли; 
		
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеФормыПоОрганизации()
	
	// ЗарплатаКадрыПодсистемы.ПодписиДокументов
	ПодписиДокументов.ЗаполнитьПодписиПоОрганизации(ЭтотОбъект);
	// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов
	
КонецПроцедуры

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

#КонецОбласти
