#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Уведомление") Тогда
		СвойстваУведомления = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Параметры.Уведомление, "ГруппироватьСделкиСОдинаковойЦеной, КодМестаПредставления");
		ГруппироватьСделкиСОдинаковойЦеной = УстановитьЗначенияГруппировкиСделок(СвойстваУведомления.ГруппироватьСделкиСОдинаковойЦеной = Истина);
		КодМестаПредставления = СвойстваУведомления.КодМестаПредставления;
		Уведомление = Параметры.Уведомление; 
	Иначе
		ГруппироватьСделкиСОдинаковойЦеной = УстановитьЗначенияГруппировкиСделок(
				Параметры.Свойство("ГруппироватьСделкиСОдинаковойЦеной") И Параметры.ГруппироватьСделкиСОдинаковойЦеной = Истина);
		
		Если Параметры.Свойство("КодМестаПредставления") Тогда
			КодМестаПредставления = Параметры.КодМестаПредставления;
		КонецЕсли;
	КонецЕсли;
	
	СписокКодов = КонтролируемыеСделкиПовтИсп.ПолучитьКодыКатегорийНалогоплательщика();
	Элементы.КодМестаПредставления.СписокВыбора.Очистить();
	Для Каждого Код Из СписокКодов Цикл
		НовыйКод = Элементы.КодМестаПредставления.СписокВыбора.Добавить();
		ЗаполнитьЗначенияСвойств(НовыйКод, Код);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Если ПроверитьЗаполнение() Тогда
	
		ЗаписатьСвойстваУведомления();
		Оповестить("Запись_УведомлениеОКонтролируемыхСделках", Неопределено, Уведомление);
		
		НастройкиУведомления = Новый Структура();
		НастройкиУведомления.Вставить("ГруппироватьСделкиСОдинаковойЦеной", ?(ГруппироватьСделкиСОдинаковойЦеной = "ГруппироватьСделки", Истина, Ложь));
		НастройкиУведомления.Вставить("КодМестаПредставления", КодМестаПредставления);
		ОповеститьОВыборе(НастройкиУведомления);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Функция УстановитьЗначенияГруппировкиСделок(ГруппироватьСделки)
	
	Если ГруппироватьСделки = Истина Тогда
		Возврат "ГруппироватьСделки";
	Иначе
		Возврат "НеГруппироватьСделки";
	КонецЕсли;
КонецФункции

&НаСервере
Процедура ЗаписатьСвойстваУведомления()
	
	Если ЗначениеЗаполнено(Уведомление) Тогда
		УведомлениеОбъект = Уведомление.ПолучитьОбъект();
		УведомлениеОбъект.ГруппироватьСделкиСОдинаковойЦеной = ?(ГруппироватьСделкиСОдинаковойЦеной = "ГруппироватьСделки", Истина, Ложь);
		УведомлениеОбъект.КодМестаПредставления = КодМестаПредставления;
		УведомлениеОбъект.Записать(РежимЗаписиДокумента.Запись);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти