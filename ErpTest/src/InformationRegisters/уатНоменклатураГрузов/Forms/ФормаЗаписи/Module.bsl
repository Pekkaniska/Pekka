
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	уатЗащищенныеФункцииСервер.уатРегистрФормаСпискаПриСозданииНаСервере(Отказ, СтандартнаяОбработка);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.Номенклатура) Тогда
		Запись.Номенклатура = Параметры.Номенклатура;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КлассыОпасностиНажатие(Элемент)
	ТабДокумент = КлассыОпасностиНажатиеНаСервере();
	ТабДокумент.ОтображатьСетку     = Ложь;
	ТабДокумент.ОтображатьЗаголовки = Ложь;
	ТабДокумент.ТолькоПросмотр      = Истина;
	
	ТабДокумент.Показать("ГОСТ 19433-88 Грузы опасные. Классификация и маркировка");
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция КлассыОпасностиНажатиеНаСервере()
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "КлассификацияОпасныхГрузов";
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	
	Макет     = РегистрыСведений.уатНоменклатураГрузов.ПолучитьМакет("КлассификацияОпасныхГрузов");
	ОблШапка  = Макет.ПолучитьОбласть("Шапка");
	ТабличныйДокумент.Вывести(ОблШапка);
	ОблКлассы = Макет.ПолучитьОбласть("Классы");
	ТабличныйДокумент.Вывести(ОблКлассы);
	
	Возврат ТабличныйДокумент;
	
КонецФункции

#КонецОбласти