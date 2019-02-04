
///////////////////////////////////////////////////////////////////////
&НаСервере
Функция ПолучитьЗначениеРеквизитаНаСервере(тОбъект, ИмяРевизита)
	
	Возврат тОбъект[ИмяРевизита];
	
КонецФункции

///////////////////////////////////////////////////////////////////////
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ТипЗнч(ПараметрКоманды) = Тип("ДокументСсылка.пкЗаявкаНаАрендуТехники") Тогда
		Если (Не ПолучитьЗначениеРеквизитаНаСервере(ПараметрКоманды,"Проведен"))
			ИЛИ (Не ПолучитьЗначениеРеквизитаНаСервере(ПараметрКоманды,"Подтверждена"))
		Тогда
			ПоказатьПредупреждение(, НСтр("ru='Для формирования доставки Заявка должна быть подтверждена и проведена.'"));
			Возврат;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ПолучитьЗначениеРеквизитаНаСервере(ПараметрКоманды,"Подразделение")) Тогда
			ПоказатьПредупреждение(, НСтр("ru='В Заявке не указано Подразделение! Формирование упрощенной доставки не возможно.'"));
			Возврат;
		КонецЕсли;
		
		Если Не ПолучитьЗначениеРеквизитаНаСервере(ПолучитьЗначениеРеквизитаНаСервере(ПараметрКоманды,
//++ Рарус Лимаренко 19.12.2017
			//"Подразделение"
			"ПодразделениеОтгрузки"
//-- Рарус Лимаренко 19.12.2017
			), "пкУпрощеннаяДоставка") Тогда
			ПоказатьПредупреждение(, НСтр("ru='В указаном регионе формирование упрощенной доставки не предусмотренно.'"));
			Возврат;
		КонецЕсли;
		
		ОткрытьФорму("Документ.пкДоставка.Форма.ФормаУпрощеннаяДоставка", Новый Структура("Ссылка", ПараметрКоманды));
		
	КонецЕсли;
	
КонецПроцедуры
