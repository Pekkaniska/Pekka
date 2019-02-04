#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	МенеджерЗаписи = РегистрыСведений.НастройкиОбменаДаннымиXDTO.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Запись.ИсходныйКлючЗаписи);
	МенеджерЗаписи.Прочитать();
	
	НастройкиПоддерживаемыеОбъекты = РегистрыСведений.НастройкиОбменаДаннымиXDTO.ЗначениеНастройки(
		МенеджерЗаписи.УзелИнформационнойБазы, "ПоддерживаемыеОбъекты");
		
	Если Не НастройкиПоддерживаемыеОбъекты = Неопределено Тогда
		ПоддерживаемыеОбъекты.Загрузить(НастройкиПоддерживаемыеОбъекты);
	КонецЕсли;
	
	НастройкиКорреспондентаПоддерживаемыеОбъекты = РегистрыСведений.НастройкиОбменаДаннымиXDTO.ЗначениеНастройкиКорреспондента(
		МенеджерЗаписи.УзелИнформационнойБазы, "ПоддерживаемыеОбъекты");
	
	Если Не НастройкиКорреспондентаПоддерживаемыеОбъекты = Неопределено Тогда
		ПоддерживаемыеОбъектыКорреспондента.Загрузить(НастройкиКорреспондентаПоддерживаемыеОбъекты);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
