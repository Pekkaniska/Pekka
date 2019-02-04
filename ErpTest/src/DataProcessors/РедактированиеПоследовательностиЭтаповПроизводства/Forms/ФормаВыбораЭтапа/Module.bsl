
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если Параметры.Свойство("АдресСписокЭтапов") Тогда 
		Таблица = ПолучитьИзВременногоХранилища(Параметры.АдресСписокЭтапов);
		Объект.Этапы.Загрузить(Таблица);
	КонецЕсли;
	
	Если Параметры.Свойство("Отбор") Тогда
		Элементы.СписокЭтапов.ОтборСтрок = Новый ФиксированнаяСтруктура(Параметры.Отбор);
	КонецЕсли;
	
	Элементы.СписокЭтаповПроизводствоНаСтороне.Формат = СтрШаблон("БЛ=; БИ='%1'", НСтр("ru = 'производство на стороне'"));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура СписокЭтаповВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОбработатьВыборЭтапа();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьЭтап(Команда)
	
	ОбработатьВыборЭтапа();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработатьВыборЭтапа()
	
	ТекущиеДанные = Элементы.СписокЭтапов.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Закрыть(ТекущиеДанные.Ссылка);

КонецПроцедуры

#КонецОбласти
