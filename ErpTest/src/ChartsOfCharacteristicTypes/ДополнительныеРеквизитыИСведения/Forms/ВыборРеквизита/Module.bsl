#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаРеквизитов = ПолучитьИзВременногоХранилища(Параметры.РеквизитыОбъекта);
	ЗначениеВРеквизитФормы(ТаблицаРеквизитов, "РеквизитыОбъекта");
	
	Если ОбщегоНазначенияКлиентСервер.ЭтоМобильныйКлиент() Тогда
		
		ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиФормы.Авто;
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаКомандаОтмена", "Видимость", Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаВыбрать(Команда)
	ВыбратьЭлементИЗакрыть();
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура РеквизитыОбъектаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ВыбратьЭлементИЗакрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыбратьЭлементИЗакрыть()
	ВыбраннаяСтрока = Элементы.РеквизитыОбъекта.ТекущиеДанные;
	ПараметрыВыбора = Новый Структура;
	ПараметрыВыбора.Вставить("Реквизит", ВыбраннаяСтрока.Реквизит);
	ПараметрыВыбора.Вставить("Представление", ВыбраннаяСтрока.Представление);
	ПараметрыВыбора.Вставить("ТипЗначения", ВыбраннаяСтрока.ТипЗначения);
	ПараметрыВыбора.Вставить("РежимВыбора", ВыбраннаяСтрока.РежимВыбора);
	
	Оповестить("Свойства_ВыборРеквизитаОбъекта", ПараметрыВыбора);
	
	Закрыть();
КонецПроцедуры

#КонецОбласти