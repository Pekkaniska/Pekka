#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры, "Заголовок,СотрудникСсылка,ФизическоеЛицоСсылка,ТекущаяОрганизация");
	
	ОстатокОтпуска = ОстаткиОтпусков.ОстатокОтпускаСотрудникаНаДату(СотрудникСсылка).Примечание;
	ЗарплатаКадры.ПриСозданииНаСервереФормыСДинамическимСписком(ЭтотОбъект, "Отсутствия", , , , "Организация, Ссылка", Ложь);
	
	УстановитьТипыОбъектовОповещения();
	УстановитьОтборы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	СотрудникиКлиент.ОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтсутствияПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Параметр = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗначенияЗаполнения = Новый Структура("Сотрудник", СотрудникСсылка);
	
	Если ЗначениеЗаполнено(ТекущаяОрганизация) Тогда
		ЗначенияЗаполнения.Вставить("Организация", ТекущаяОрганизация);
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	Отказ = Истина;
	ОткрытьФорму(ПолноеИмяОбъектаМетаданныхПоТипу(Параметр) + ".ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект, Настройки);
КонецПроцедуры

&НаСервере
Процедура СписокПриОбновленииСоставаПользовательскихНастроекНаСервере(СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект, , СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СправкаПоОтпускамСотрудника(Команда)
	
	МассивОбъектов = Новый Массив;
	МассивОбъектов.Добавить(СотрудникСсылка);
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Справочник.Сотрудники", "СправкаПоОтпускамСотрудника", 
		МассивОбъектов, ЭтаФорма);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолноеИмяОбъектаМетаданныхПоТипу(Тип)
	Возврат Метаданные.НайтиПоТипу(Тип).ПолноеИмя();
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьОтборы()
	
	Отсутствия.КомпоновщикНастроек.Настройки.Отбор.Элементы.Очистить();
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Отсутствия,
		"ФизическоеЛицо",
		ФизическоеЛицоСсылка,
		Истина);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Отсутствия,
		"Организация",
		ТекущаяОрганизация,
		ВидСравненияКомпоновкиДанных.Равно, , Истина);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТипыОбъектовОповещения()
	
	ДобавляемыеРеквизиты = Новый Массив;
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("ТипыОбъектовОповещения", Новый ОписаниеТипов("СписокЗначений")));
	
	МассивИменРеквизитовФормы = Новый Массив;
	
	ЗарплатаКадры.ЗаполнитьМассивИменРеквизитовФормы(ЭтотОбъект, МассивИменРеквизитовФормы);
	ЗарплатаКадры.ИзменитьРеквизитыФормы(ЭтотОбъект, ДобавляемыеРеквизиты, МассивИменРеквизитовФормы);
	
	ТипОбъекта = ТипЗнч(ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(Отсутствия.ОсновнаяТаблица));
	МетаданныеОбъекта = Метаданные.НайтиПоТипу(ТипОбъекта);
	
	Для Каждого РегистрируемыйДокумент Из МетаданныеОбъекта.РегистрируемыеДокументы Цикл
		ЭтотОбъект.ТипыОбъектовОповещения.Добавить(ТипЗнч(ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(РегистрируемыйДокумент.ПолноеИмя()).ПустаяСсылка()));
	КонецЦикла;
	
	ЭтотОбъект.ИспользоватьКритерийОтбора = Истина;
	
КонецПроцедуры

#КонецОбласти

