#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	СтруктурнаяЕдиница = Неопределено;
	Если ЭтотОбъект.Отбор.СтруктурнаяЕдиница.Использование Тогда
		СтруктурнаяЕдиница = ЭтотОбъект.Отбор.СтруктурнаяЕдиница.Значение;
	КонецЕсли;
	
	РегистрыСведений.ИсторияРегистрацийВНалоговомОрганеВторичный.ЗаполнитьВторичныеДанные(СтруктурнаяЕдиница);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли