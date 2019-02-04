
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	уатЗащищенныеФункцииСервер.уатРегистрФормаСпискаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ДопПараметрыОткрытие);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("ТипАгрегата") Тогда 
		УстановитьОтборПоТипуАгрегата(Параметры.ТипАгрегата);
	КонецЕсли;
	
	Если Параметры.Свойство("РежимВыбора") Тогда 
		Элементы.Список.РежимВыбора = Параметры.РежимВыбора;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	//уатЗащищенныеФункцииКлиент.уатРегистрФормаСпискаПриОткрытии(Отказ, ДопПараметрыОткрытие);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастройкаФормированияНаименованияАгрегатов(Команда)
	
	ПараметрыФормы = Новый Структура();
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если Не ТекущиеДанные = Неопределено Тогда 
		ПараметрыФормы.Вставить("ТипАгрегата", ТекущиеДанные.ТипАгрегата);
	КонецЕсли;
	
	ОткрытьФорму("ОбщаяФорма.уатНастройкаФормированияНаименованияАгрегатов", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьОтборПоТипуАгрегата(ИмяТипа)
	
	Если ИмяТипа = "Аккумулятор" Тогда 
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("ТипАгрегата");
		ЭлементОтбора.ВидСравнения     = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.ПравоеЗначение   = Справочники.уатТипыАгрегатов.Аккумулятор;
		ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		ЭлементОтбора.Использование    = Истина;
		
	ИначеЕсли ИмяТипа = "Шина" Тогда 
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("ТипАгрегата");
		ЭлементОтбора.ВидСравнения     = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.ПравоеЗначение   = Справочники.уатТипыАгрегатов.Шина;
		ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		ЭлементОтбора.Использование    = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
