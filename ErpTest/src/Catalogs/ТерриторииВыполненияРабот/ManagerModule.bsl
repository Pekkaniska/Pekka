
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Владелец)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Представление = "";
	
	Если Не ПустаяСтрока(Данные.Код) Тогда
		Представление = СокрЛП(Данные.Код);
	КонецЕсли; 
	
	Если Не ПустаяСтрока(Данные.Наименование) Тогда
		
		Если Не ПустаяСтрока(Представление) Тогда
			Представление = Представление + " ";
		КонецЕсли; 
		
		Представление = Представление + "(" + СокрЛП(Данные.Наименование) + ")";
		
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Поля.Добавить("Код");
	Поля.Добавить("Наименование");
	
КонецПроцедуры

#КонецОбласти
