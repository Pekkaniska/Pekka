#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
#Область ОписаниеПеременных

Перем ОтчетИнициализирован;

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ИнициализироватьОтчет();
	
	КлючВарианта = ЗарплатаКадрыОтчеты.КлючВарианта(КомпоновщикНастроек);
	
	// Установка параметров настроек штатного расписания
	НастройкиШтатногоРасписания = УправлениеШтатнымРасписанием.НастройкиШтатногоРасписания();
	
	НастройкиОтчета = КомпоновщикНастроек.Настройки;
	
	ЗначениеПараметра = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ИспользоватьБронированиеПозиций"));
	ЗначениеПараметра.Значение = НастройкиШтатногоРасписания.ИспользоватьБронированиеПозиций;
	ЗначениеПараметра.Использование = Истина;
	
	ЗначениеПараметра = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ИспользоватьПодработки"));
	ЗначениеПараметра.Значение = Не КлючВарианта = "ШтатнаяРасстановка" И ПолучитьФункциональнуюОпцию("ИспользоватьПодработки");
	ЗначениеПараметра.Использование = Истина;
	
	ЗначениеПараметра = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ДнейСохраненияБрони"));
	ЗначениеПараметра.Значение = НастройкиШтатногоРасписания.ДнейСохраненияБрони;
	ЗначениеПараметра.Использование = Истина;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьРаботуНаНеполнуюСтавку") Тогда
		
		ФорматКоличестваСтавок = УправлениеШтатнымРасписанием.ФорматКоличестваСтавок();
		Для каждого ЭлементУсловноеОформления Из НастройкиОтчета.УсловноеОформление.Элементы Цикл
			Если ЭлементУсловноеОформления.Представление = НСтр("ru='Формат вывода количества ставок'") Тогда
				ЭлементУсловноеОформления.Оформление.УстановитьЗначениеПараметра("Формат", ФорматКоличестваСтавок);
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьОтчет() Экспорт
	
	Если Не ОтчетИнициализирован Тогда
		
		СоответсвиеДополнительныхПолейПредставлениям = УправлениеШтатнымРасписанием.ДополнительныеПоляОтчетаШтатноеРасписание();
		
		ЗарплатаКадрыОбщиеНаборыДанных.ЗаполнитьОбщиеИсточникиДанныхОтчета(ЭтотОбъект, СоответсвиеДополнительныхПолейПредставлениям);
		ЗарплатаКадрыОбщиеНаборыДанных.ЗаполнитьОбщиеИсточникиДанныхОтчета(ЭтотОбъект);
		
		ОтчетИнициализирован = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

// Для общей формы "Форма отчета" подсистемы "Варианты отчетов".
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.События.ПередЗагрузкойНастроекВКомпоновщик = Истина;
	
КонецПроцедуры

// Вызывается перед загрузкой новых настроек. Используется для изменения схемы компоновки.
//
Процедура ПередЗагрузкойНастроекВКомпоновщик(Контекст, КлючСхемы, КлючВарианта, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД) Экспорт
	
	Если КлючСхемы <> "СхемаИнициализирована" Тогда
		
		ИнициализироватьОтчет();
		ОтчетыСервер.ПодключитьСхему(ЭтотОбъект, Контекст, СхемаКомпоновкиДанных, КлючСхемы);
		КлючСхемы = "СхемаИнициализирована";
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Инициализация

ОтчетИнициализирован = Ложь;

#КонецОбласти

#КонецЕсли