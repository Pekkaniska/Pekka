#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Попытка
		
		РезультатКомпоновки = ЗарплатаКадрыОтчеты.РезультатКомпоновкиМакетаПечатнойФормы(ЭтотОбъект, ДанныеРасшифровки);
		Отчеты.ПечатнаяФормаТ8а.Сформировать(ДокументРезультат, РезультатКомпоновки);
		
	Исключение
		
		ИнформацияОшибки = ИнформацияОбОшибке();
		ВызватьИсключение НСтр("ru = 'В настройку формирования Т-8а внесены критичные изменения. Печатная форма не будет сформирована'") + ". " + КраткоеПредставлениеОшибки(ИнформацияОшибки);
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьОтчет() Экспорт
	
	ЗарплатаКадрыОбщиеНаборыДанных.ЗаполнитьОбщиеИсточникиДанныхОтчета(ЭтотОбъект,
		ЗарплатаКадрыОтчетыРасширенный.ПоляПредставленийКадровыхДанныхСотрудниковОтчетовПечатныхФорм());
	
КонецПроцедуры

// Для общей формы "Форма отчета" подсистемы "Варианты отчетов".
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.События.ПередЗагрузкойНастроекВКомпоновщик = Истина;
	
КонецПроцедуры

// Вызывается перед загрузкой новых настроек. Используется для изменения схемы компоновки.
//
Процедура ПередЗагрузкойНастроекВКомпоновщик(Контекст, КлючСхемы, КлючВарианта, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД) Экспорт
	
	ЗарплатаКадрыОтчеты.ИнициализироватьОтчетПечатнойФормы(Контекст, ЭтотОбъект, КлючСхемы, КлючВарианта, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли