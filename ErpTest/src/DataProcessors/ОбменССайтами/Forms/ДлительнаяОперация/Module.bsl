
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	СписокДействий = Новый СписокЗначений;
	// Здесь можно составить список подсказок пользователю
	СписокДействий.Добавить(НСтр("ru = 'Пожалуйста, подождите...'"));
	
	СопровождающийТекст = СписокДействий[0];
	НомерДействия = 1;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Выполнено Тогда 
		Отказ = Истина;
	Иначе
		ИнтервалПроверки = 7;
		ПодключитьОбработчикОжидания("ПроверитьВыполнение", ИнтервалПроверки, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Отменить(Команда)
	
	ТекстВопроса = НСтр("ru = 'Создание сайта еще не завершено.'");
	
	Кнопки = Новый СписокЗначений;
	Кнопки.Добавить(1, НСтр("ru = 'Подождать еще'"));
	Кнопки.Добавить(КодВозвратаДиалога.Прервать);
	
	ОтключитьОбработчикОжидания("ПроверитьВыполнение");
	
	Обработчик = Новый ОписаниеОповещения("ОтменитьЗавершение", ЭтотОбъект);
	ПоказатьВопрос(Обработчик, ТекстВопроса, Кнопки, 60,1);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПроверитьВыполнение()
	
	Если НомерДействия = (СписокДействий.Количество()) Тогда
		НомерДействия = 1;
	Иначе
		НомерДействия = НомерДействия + 1;
	КонецЕсли;
	
	СопровождающийТекст = СписокДействий[НомерДействия-1];
	
	ПодключитьОбработчикОжидания("ПроверитьВыполнение", ИнтервалПроверки, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	
	ПрерватьЕслиНеВыполнено = (Ответ = КодВозвратаДиалога.Прервать);
	Если ПрерватьЕслиНеВыполнено Тогда
		ЗакрытиеПодтверждено = Истина;
		Закрыть();
	КонецЕсли;

	ПодключитьОбработчикОжидания("ПроверитьВыполнение", ИнтервалПроверки, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Создание сайта прервано'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		ЗакрытиеПодтверждено = Истина;
	КонецЕсли;
	
	Если НЕ ЗакрытиеПодтверждено Тогда

		Если НЕ Выполнено Тогда
			СтандартнаяОбработка = Ложь;
			Отказ = Истина;
			Отменить(Неопределено);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия="ЗакрытьФормуДлительнойОперации" Тогда
		ЗакрытиеПодтверждено = Истина;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
