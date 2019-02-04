#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ИспользоватьВыходныеИзделия = Параметры.ИспользоватьВыходныеИзделия;
	ИспользоватьМатериалы = Параметры.ИспользоватьМатериалы;
	ИспользоватьОперации = Параметры.ИспользоватьОперации;
	ИспользоватьТрудозатраты = Параметры.ИспользоватьТрудозатраты;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ПоказатьПодтверждениеЗакрытияФормыЗавершение", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы,, ТекстПредупреждения);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ ИспользоватьВыходныеИзделия
		И НЕ ИспользоватьМатериалы
		И НЕ ИспользоватьОперации
		И НЕ ИспользоватьТрудозатраты Тогда
		
		ТекстСообщения = НСтр("ru = 'Необходимо использовать хотя бы одни данные.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,, Отказ);
		
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаЗавершитьРедактирование(Команда)
	
	ЗавершитьРедактирование();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьРедактирование(Команда)
	
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПоказатьПодтверждениеЗакрытияФормыЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ЗавершитьРедактирование();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьРедактирование()
	
	ОчиститьСообщения();
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Модифицированность = Ложь;
	
	РезультатЗакрытия = Новый Структура;
	РезультатЗакрытия.Вставить("ИспользоватьВыходныеИзделия", ИспользоватьВыходныеИзделия);
	РезультатЗакрытия.Вставить("ИспользоватьМатериалы", ИспользоватьМатериалы);
	РезультатЗакрытия.Вставить("ИспользоватьОперации", ИспользоватьОперации);
	РезультатЗакрытия.Вставить("ИспользоватьТрудозатраты", ИспользоватьТрудозатраты);
	
	Закрыть(РезультатЗакрытия);
	
КонецПроцедуры

#КонецОбласти
