#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.Организация.Видимость = НЕ Параметры.Отбор.Свойство("Организация");
	
КонецПроцедуры

#КонецОбласти