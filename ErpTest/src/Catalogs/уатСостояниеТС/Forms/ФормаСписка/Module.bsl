
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//уатЗащищенныеФункцииСервер.уатСправочникФормаСпискаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	
	// УправлениеПредприятием.СлужебныеПодсистемы
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	// Конец УправлениеПредприятием.СлужебныеПодсистемы
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	//уатЗащищенныеФункцииКлиент.уатСправочникФормаСпискаПриОткрытии(Отказ, ДопПараметрыОткрытие);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ФильтрПриИзменении(Элемент)
	УстановитьФильтр();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_Список

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Если Не Копирование И НЕ Группа Тогда
		Отказ = Истина;
		
		СтруктураОтбора = Новый Структура;
		Если ЗначениеЗаполнено(Фильтр) Тогда		
			СтруктураОтбора.Вставить("ВидСостояния", Фильтр);
		КонецЕсли;
		ОткрытьФорму("Справочник.уатСостояниеТС.ФормаОбъекта", Новый Структура("ЗначенияЗаполнения", СтруктураОтбора));
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// УправлениеПредприятием.СлужебныеПодсистемы
&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
КонецПроцедуры
// Конец УправлениеПредприятием.СлужебныеПодсистемы

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьФильтр()
	Если ЗначениеЗаполнено(Фильтр) Тогда
		уатОбщегоНазначенияКлиент.УстановитьОтборУСписка(Список.Отбор, Новый ПолеКомпоновкиДанных("ВидСостояния"), 
			Фильтр, ВидСравненияКомпоновкиДанных.Равно);
	Иначе
		уатОбщегоНазначенияКлиент.УстановитьОтборУСписка(Список.Отбор, Новый ПолеКомпоновкиДанных("ВидСостояния"), 
			Фильтр, ВидСравненияКомпоновкиДанных.НеРавно);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
