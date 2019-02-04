
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	об = РеквизитФормыВЗначение("Объект");
	//уатЗащищенныеФункцииСервер.уатСправочникФормаЭлементаПриСозданииНаСервере(Об, Отказ, СтандартнаяОбработка, ЭтаФорма, ДопПараметрыОткрытие);
	ЗначениеВРеквизитФормы(Об,"Объект");
	Если Отказ тогда
		Возврат;
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
	
	УстановитьВидимость();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидСостоянияПриИзменении(Элемент)
	Если Объект.ВидСостояния <> ПредопределенноеЗначение("Перечисление.уатВидыСостоянийТС.ВПростое") тогда
		Объект.ОплатаВодителю = Ложь;
		Объект.ОплатаКлиента  = Ложь;
	КонецЕсли;
	
	УстановитьВидимость();
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
Процедура УстановитьВидимость()
	Элементы.ОплатаВодителю.Доступность = (Объект.ВидСостояния = ПредопределенноеЗначение("Перечисление.уатВидыСостоянийТС.ВПростое"));
	Элементы.ОплатаКлиента.Доступность	= (Объект.ВидСостояния = ПредопределенноеЗначение("Перечисление.уатВидыСостоянийТС.ВПростое"));	
КонецПроцедуры

#КонецОбласти
