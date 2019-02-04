#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура УстановкаПараметровСеанса(ИменаПараметровСеанса)
	
	// СтандартныеПодсистемы
	СтандартныеПодсистемыСервер.УстановкаПараметровСеанса(ИменаПараметровСеанса);
	// Конец СтандартныеПодсистемы
	
	//++ НЕ ГИСМ
	// ТехнологияСервиса
	ТехнологияСервиса.ВыполнитьДействияПриУстановкеПараметровСеанса(ИменаПараметровСеанса);
	// Конец ТехнологияСервиса 
	//-- НЕ ГИСМ
	
	// {УАТ}
	уатОбщегоНазначения.УстановкаПараметровСеансаУАТ(ИменаПараметровСеанса);
	слкМенеджерЗащитыСервер.УстановкаПараметровСеанса(ИменаПараметровСеанса);
	// {/УАТ}
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли