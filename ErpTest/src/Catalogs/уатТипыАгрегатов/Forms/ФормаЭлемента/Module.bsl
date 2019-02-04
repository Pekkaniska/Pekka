
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	об = РеквизитФормыВЗначение("Объект");
	//уатЗащищенныеФункцииСервер.уатСправочникФормаЭлементаПриСозданииНаСервере(Об, Отказ, СтандартнаяОбработка, ЭтаФорма, ДопПараметрыОткрытие);
	ЗначениеВРеквизитФормы(Об,"Объект");
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	Если Не Объект.Ссылка.Пустая() Тогда
		Если Объект.Ссылка = Справочники.уатТипыАгрегатов.Аккумулятор Или 
			Объект.Ссылка = Справочники.уатТипыАгрегатов.Аптечка Или 
			Объект.Ссылка = Справочники.уатТипыАгрегатов.Шина Тогда
			Элементы.ПараметрВыработки.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	// УправлениеПредприятием.СлужебныеПодсистемы
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	// Конец УправлениеПредприятием.СлужебныеПодсистемы
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	//уатЗащищенныеФункцииКлиент.уатСправочникФормаЭлементаПриОткрытии(Отказ, ДопПараметрыОткрытие);
	Если Отказ Тогда
		Возврат;
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
