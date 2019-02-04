
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если Параметры.Свойство("Отбор") Тогда
		
		Если Параметры.Отбор.Свойство("ХозяйственнаяОперация") Тогда
			Если Параметры.Отбор.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПриемНаКомиссию
			 ИЛИ Параметры.Отбор.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПередачаНаКомиссиюВДругуюОрганизацию Тогда
				Параметры.Отбор.Вставить("ТипЗапасов", Перечисления.ТипыЗапасов.КомиссионныйТовар);
			Иначе
				Параметры.Отбор.Вставить("ТипЗапасов", Перечисления.ТипыЗапасов.Товар);
			КонецЕсли;
		КонецЕсли;
		
		Если Параметры.Отбор.Свойство("ТипОперации") Тогда
			Если Параметры.Отбор.ТипОперации = Перечисления.ТипыОперацийВводаОстатков.ОстаткиТоваровПолученныхНаКомиссию Тогда
				Параметры.Отбор.Вставить("ТипЗапасов", Перечисления.ТипыЗапасов.КомиссионныйТовар);
			Иначе
				Параметры.Отбор.Вставить("ТипЗапасов", Перечисления.ТипыЗапасов.Товар);
			КонецЕсли;
		КонецЕсли;
		
		Если Параметры.Отбор.Свойство("Номенклатура") Тогда
			ГруппаФинансовогоУчета = Справочники.Номенклатура.ЗначенияРеквизитовНоменклатуры(Параметры.Отбор.Номенклатура).ГруппаФинансовогоУчета;
			МассивГрупп = Новый Массив;
			МассивГрупп.Добавить(ГруппаФинансовогоУчета);
			МассивГрупп.Добавить(Справочники.ГруппыФинансовогоУчетаНоменклатуры.ПустаяСсылка());
			Параметры.Отбор.Вставить("ГруппаФинансовогоУчета", МассивГрупп);
		КонецЕсли;
		
	КонецЕсли;

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

