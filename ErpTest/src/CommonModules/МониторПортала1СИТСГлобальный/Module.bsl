
#Область СлужебныеПроцедурыИФункции

Процедура Подключаемый_ПроверитьНаличиеНовойИнформацииВМонитореПортала1СИТС() Экспорт
	
	МониторПортала1СИТСКлиент.ПроверитьНаличиеНовойИнформацииВМонитореПортала1СИТС();
	
КонецПроцедуры

Процедура Подключаемый_ОткрытьМониторПортала1СИТССПодключениемИнтернетПоддержки() Экспорт
	
	ИнтернетПоддержкаПользователейКлиент.ПодключитьИнтернетПоддержкуПользователей(
		Новый ОписаниеОповещения("ПодключениеИнтернетПоддержкиПриНачалеРаботыЗавершение",
		МониторПортала1СИТСКлиент));
	
КонецПроцедуры

#КонецОбласти
