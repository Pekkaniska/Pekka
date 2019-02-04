#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	СтруктураЗаписи = Новый Структура("ГоловнаяОрганизация");
	
	Для Каждого Запись Из ЭтотОбъект Цикл
		
		ЗаполнитьЗначенияСвойств(СтруктураЗаписи, Запись);
				
		Если ЗначениеЗаполнено(Запись.ГоловнаяОрганизация) И ЗарплатаКадры.ГоловнаяОрганизация(Запись.ГоловнаяОрганизация) <> Запись.ГоловнаяОрганизация Тогда
			Отказ = Истина;
			ТекстОшибки = НСтр("ru = 'Учетная политика по НДФЛ определяется только для головных организаций.'");
			КлючЗаписи = РегистрыСведений.ДокументыФизическихЛиц.СоздатьКлючЗаписи(СтруктураЗаписи);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, КлючЗаписи, "Запись.ГоловнаяОрганизация");
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли