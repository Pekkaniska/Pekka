
#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
    ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
    ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

#КонецОбласти

&НаКлиенте
Процедура ВидОперацииВТабличнойЧастиПриИзменении(Элемент)
	
	НастроитьВидимостьПоВидуОперацииВТЧ();
	
КонецПроцедуры

&НаСервере
Процедура НастроитьВидимостьПоВидуОперацииВТЧ()
	
	Если Объект.ВидОперацииВТабличнойЧасти Тогда
		Элементы.ВидОперации.Видимость = Ложь;
		Элементы.ДанныеПоПультамВидОперации.Видимость = Истина;
		Если ЗначениеЗаполнено(Объект.ВидОперации) Тогда
			Для Каждого ТекСтрока Из Объект.ДанныеПоПультам Цикл
				Если Не ЗначениеЗаполнено(ТекСтрока.ВидОперации) Тогда
					ТекСтрока.ВидОперации = Объект.ВидОперации;
				КонецЕсли;
			КонецЦикла;	
		КонецЕсли;
		Элементы.ДанныеПоПультамКонтрагент.Видимость = Истина;
		
		Элементы.ДанныеПоПультамОбъектЭксплуатацииВозврат.Видимость = Истина;
		Элементы.ДанныеПоПультамОбъектЭксплуатацииВозврат.Заголовок = "Возврат Техника";
		Элементы.ДанныеПоПультамОбъектСтроительстваВозврат.Видимость = Истина;
		Элементы.ДанныеПоПультамОбъектСтроительстваВозврат.Заголовок = "Возврат объект строительства";
		Элементы.ДанныеПоПультамКонтрагент.Видимость = Истина;
		Элементы.ДанныеПоПультамКонтрагент.Заголовок = "Контрагент";
		Элементы.ДанныеПоПультамСклад.Видимость = Истина;
		Элементы.ДанныеПоПультамСклад.Заголовок = "Склад / Техника";
		Элементы.ДанныеПоПультамЯчейка.Видимость = Истина;
		Элементы.ДанныеПоПультамЯчейка.Заголовок = "Ячейка / Объект строительства";
		
		Элементы.Переместить(Элементы.ДанныеПоПультамКонтрагент, Элементы.Группа1);
		Элементы.Переместить(Элементы.ДанныеПоПультамЯчейка, Элементы.Группа1);
		
		Элементы.Переместить(Элементы.ДанныеПоПультамОбъектЭксплуатацииВозврат, Элементы.Группа2);
		Элементы.Переместить(Элементы.ДанныеПоПультамОбъектСтроительстваВозврат, Элементы.Группа2);
		
		Элементы.Переместить(Элементы.ДанныеПоПультамТекСклад, Элементы.Группа3);
		Элементы.Переместить(Элементы.ДанныеПоПультамТекЯчейка, Элементы.Группа3);
		
	Иначе
		Элементы.ВидОперации.Видимость = Истина;
		Элементы.ДанныеПоПультамВидОперации.Видимость = Ложь;
		Если Не ЗначениеЗаполнено(Объект.ВидОперации) Тогда
			ТекВидОперации = Неопределено;
			Для Каждого ТекСтрока Из Объект.ДанныеПоПультам Цикл
				ТекВидОперации = ТекСтрока.ВидОперации;
				Прервать;
			КонецЦикла;	
			Если ТекВидОперации <> Неопределено Тогда
				Объект.ВидОперации = ТекВидОперации;
			КонецЕсли;	
		КонецЕсли;
		
		Элементы.ДанныеПоПультамОбъектЭксплуатацииВозврат.Видимость = Ложь;
		Элементы.ДанныеПоПультамОбъектЭксплуатацииВозврат.Заголовок = "Возврат Техника";
		Элементы.ДанныеПоПультамОбъектСтроительстваВозврат.Видимость = Ложь;
		Элементы.ДанныеПоПультамОбъектСтроительстваВозврат.Заголовок = "Возврат объект строительства";
		
		Если Объект.ВидОперации = Перечисления.пкВидыОперацийСПультами.Списание Тогда
			Элементы.ДанныеПоПультамКонтрагент.Видимость = Ложь;
			Элементы.ДанныеПоПультамСклад.Видимость = Ложь;
			Элементы.ДанныеПоПультамСклад.Заголовок = "Склад";
			Элементы.ДанныеПоПультамЯчейка.Видимость = Ложь;
			Элементы.ДанныеПоПультамЯчейка.Заголовок = "Ячейка";
			
			Элементы.Переместить(Элементы.Группа3, Элементы.ДанныеПоПультам, Элементы.Группа2);
			Элементы.Переместить(Элементы.Группа2, Элементы.ДанныеПоПультам, Элементы.Группа1);
			Элементы.Переместить(Элементы.Группа1, Элементы.ДанныеПоПультам, Элементы.ДанныеПоПультамОбъектСтроительстваВозврат);
			
			Элементы.Переместить(Элементы.ДанныеПоПультамОбъектСтроительстваВозврат, Элементы.ДанныеПоПультам, Элементы.ДанныеПоПультамОбъектЭксплуатацииВозврат);
			Элементы.Переместить(Элементы.ДанныеПоПультамЯчейка, Элементы.ДанныеПоПультам, Элементы.ДанныеПоПультамСклад);
			Элементы.Переместить(Элементы.ДанныеПоПультамОбъектЭксплуатацииВозврат, Элементы.ДанныеПоПультам, Элементы.ДанныеПоПультамЯчейка);
			Элементы.Переместить(Элементы.ДанныеПоПультамСклад, Элементы.ДанныеПоПультам, Элементы.ДанныеПоПультамКонтрагент);
			Элементы.Переместить(Элементы.ДанныеПоПультамКонтрагент, Элементы.ДанныеПоПультам, Элементы.ДанныеПоПультамПульт);
			Элементы.Переместить(Элементы.ДанныеПоПультамПульт, Элементы.ДанныеПоПультам, Элементы.ДанныеПоПультамВидОперации);
			Элементы.Переместить(Элементы.ДанныеПоПультамВидОперации, Элементы.ДанныеПоПультам, Элементы.ДанныеПоПультамНомерСтроки);
			Элементы.Переместить(Элементы.ДанныеПоПультамНомерСтроки, Элементы.ДанныеПоПультам, Элементы.ДанныеПоПультамВидОперации);
			
			Элементы.Переместить(Элементы.ДанныеПоПультамТекСклад, Элементы.Группа3);
			Элементы.Переместить(Элементы.ДанныеПоПультамТекЯчейка, Элементы.Группа3);
			
		ИначеЕсли Объект.ВидОперации = Перечисления.пкВидыОперацийСПультами.Поступление Тогда
			Элементы.ДанныеПоПультамКонтрагент.Видимость = Ложь;
			Элементы.ДанныеПоПультамКонтрагент.Заголовок = "Поставщик";
			Элементы.ДанныеПоПультамСклад.Видимость = Истина;
			Элементы.ДанныеПоПультамСклад.Заголовок = "Склад";
			Элементы.ДанныеПоПультамЯчейка.Видимость = Истина;
			Элементы.ДанныеПоПультамЯчейка.Заголовок = "Ячейка";
			
			//Элементы.Переместить(Элементы.Группа3, Элементы.ДанныеПоПультам, Элементы.Группа2);
			Элементы.Переместить(Элементы.Группа2, Элементы.ДанныеПоПультам, Элементы.Группа3);
			Элементы.Переместить(Элементы.Группа1, Элементы.ДанныеПоПультам, Элементы.Группа2);
			
			Элементы.Переместить(Элементы.ДанныеПоПультамОбъектСтроительстваВозврат, Элементы.ДанныеПоПультам, Элементы.Группа1);
			Элементы.Переместить(Элементы.ДанныеПоПультамОбъектЭксплуатацииВозврат, Элементы.ДанныеПоПультам, Элементы.ДанныеПоПультамОбъектСтроительстваВозврат);
			Элементы.Переместить(Элементы.ДанныеПоПультамЯчейка, Элементы.ДанныеПоПультам, Элементы.ДанныеПоПультамОбъектЭксплуатацииВозврат);
			Элементы.Переместить(Элементы.ДанныеПоПультамКонтрагент, Элементы.ДанныеПоПультам, Элементы.ДанныеПоПультамСклад);
			Элементы.Переместить(Элементы.ДанныеПоПультамСклад, Элементы.ДанныеПоПультам, Элементы.ДанныеПоПультамЯчейка);
			Элементы.Переместить(Элементы.ДанныеПоПультамПульт, Элементы.ДанныеПоПультам, Элементы.ДанныеПоПультамКонтрагент);
			Элементы.Переместить(Элементы.ДанныеПоПультамВидОперации, Элементы.ДанныеПоПультам, Элементы.ДанныеПоПультамПульт);
			Элементы.Переместить(Элементы.ДанныеПоПультамНомерСтроки, Элементы.ДанныеПоПультам, Элементы.ДанныеПоПультамВидОперации);
			
			Элементы.Переместить(Элементы.ДанныеПоПультамСклад, Элементы.Группа1);
			Элементы.Переместить(Элементы.ДанныеПоПультамЯчейка, Элементы.Группа1);
			
			Элементы.Переместить(Элементы.ДанныеПоПультамТекСклад, Элементы.Группа3);
			Элементы.Переместить(Элементы.ДанныеПоПультамТекЯчейка, Элементы.Группа3);
			
		ИначеЕсли Объект.ВидОперации = Перечисления.пкВидыОперацийСПультами.ВнутреннееПеремещение Тогда
			Элементы.ДанныеПоПультамКонтрагент.Видимость = Ложь;
			Элементы.ДанныеПоПультамКонтрагент.Заголовок = "Поставщик";
			Элементы.ДанныеПоПультамСклад.Видимость = Истина;
			Элементы.ДанныеПоПультамСклад.Заголовок = "Склад";
			Элементы.ДанныеПоПультамЯчейка.Видимость = Истина;
			Элементы.ДанныеПоПультамЯчейка.Заголовок = "Ячейка";
			
			Элементы.Переместить(Элементы.Группа2, Элементы.ДанныеПоПультам, Элементы.Группа3);
			Элементы.Переместить(Элементы.Группа1, Элементы.ДанныеПоПультам, Элементы.Группа2);
			
			Элементы.Переместить(Элементы.ДанныеПоПультамОбъектСтроительстваВозврат, Элементы.ДанныеПоПультам, Элементы.Группа1);
			Элементы.Переместить(Элементы.ДанныеПоПультамОбъектЭксплуатацииВозврат, Элементы.ДанныеПоПультам, Элементы.ДанныеПоПультамОбъектСтроительстваВозврат);
			Элементы.Переместить(Элементы.ДанныеПоПультамЯчейка, Элементы.ДанныеПоПультам, Элементы.ДанныеПоПультамОбъектЭксплуатацииВозврат);
			Элементы.Переместить(Элементы.ДанныеПоПультамСклад, Элементы.ДанныеПоПультам, Элементы.ДанныеПоПультамЯчейка);
			Элементы.Переместить(Элементы.ДанныеПоПультамКонтрагент, Элементы.ДанныеПоПультам, Элементы.ДанныеПоПультамСклад);
			Элементы.Переместить(Элементы.ДанныеПоПультамПульт, Элементы.ДанныеПоПультам, Элементы.ДанныеПоПультамКонтрагент);
			Элементы.Переместить(Элементы.ДанныеПоПультамВидОперации, Элементы.ДанныеПоПультам, Элементы.ДанныеПоПультамПульт);
			Элементы.Переместить(Элементы.ДанныеПоПультамНомерСтроки, Элементы.ДанныеПоПультам, Элементы.ДанныеПоПультамВидОперации);
			
			Элементы.Переместить(Элементы.ДанныеПоПультамСклад, Элементы.Группа1);
			Элементы.Переместить(Элементы.ДанныеПоПультамЯчейка, Элементы.Группа1);
		
			Элементы.Переместить(Элементы.ДанныеПоПультамТекСклад, Элементы.Группа3);
			Элементы.Переместить(Элементы.ДанныеПоПультамТекЯчейка, Элементы.Группа3);
			
		ИначеЕсли Объект.ВидОперации = Перечисления.пкВидыОперацийСПультами.ВозвратОтКонтрагента Тогда
			Элементы.ДанныеПоПультамКонтрагент.Видимость = Истина;
			Элементы.ДанныеПоПультамКонтрагент.Заголовок = "Возврат Контрагент";
			Элементы.ДанныеПоПультамСклад.Видимость = Истина;
			Элементы.ДанныеПоПультамСклад.Заголовок = "Склад";
			Элементы.ДанныеПоПультамЯчейка.Видимость = Истина;
			Элементы.ДанныеПоПультамЯчейка.Заголовок = "Ячейка";
			
			Элементы.ДанныеПоПультамОбъектЭксплуатацииВозврат.Видимость = Истина;
			Элементы.ДанныеПоПультамОбъектСтроительстваВозврат.Видимость = Истина;
			
			Элементы.Переместить(Элементы.Группа2, Элементы.ДанныеПоПультам, Элементы.Группа3);
			Элементы.Переместить(Элементы.Группа1, Элементы.ДанныеПоПультам, Элементы.Группа2);
			
			Элементы.Переместить(Элементы.ДанныеПоПультамОбъектСтроительстваВозврат, Элементы.ДанныеПоПультам, Элементы.Группа1);
			Элементы.Переместить(Элементы.ДанныеПоПультамОбъектЭксплуатацииВозврат, Элементы.ДанныеПоПультам, Элементы.ДанныеПоПультамОбъектСтроительстваВозврат);
			Элементы.Переместить(Элементы.ДанныеПоПультамЯчейка, Элементы.ДанныеПоПультам, Элементы.ДанныеПоПультамОбъектЭксплуатацииВозврат);
			Элементы.Переместить(Элементы.ДанныеПоПультамПульт, Элементы.ДанныеПоПультам, Элементы.ДанныеПоПультамЯчейка);
			Элементы.Переместить(Элементы.ДанныеПоПультамСклад, Элементы.ДанныеПоПультам, Элементы.ДанныеПоПультамПульт);
			Элементы.Переместить(Элементы.ДанныеПоПультамОбъектЭксплуатацииВозврат, Элементы.ДанныеПоПультам, Элементы.ДанныеПоПультамСклад);
			Элементы.Переместить(Элементы.ДанныеПоПультамВидОперации, Элементы.ДанныеПоПультам, Элементы.ДанныеПоПультамОбъектЭксплуатацииВозврат);
			Элементы.Переместить(Элементы.ДанныеПоПультамНомерСтроки, Элементы.ДанныеПоПультам, Элементы.ДанныеПоПультамВидОперации);
			
			Элементы.Переместить(Элементы.ДанныеПоПультамСклад, Элементы.Группа1);
			Элементы.Переместить(Элементы.ДанныеПоПультамЯчейка, Элементы.Группа1);
		
			Элементы.Переместить(Элементы.ДанныеПоПультамКонтрагент, Элементы.Группа2);
			Элементы.Переместить(Элементы.ДанныеПоПультамОбъектСтроительстваВозврат, Элементы.Группа2);
		
			Элементы.Переместить(Элементы.ДанныеПоПультамТекСклад, Элементы.Группа3);
			Элементы.Переместить(Элементы.ДанныеПоПультамТекЯчейка, Элементы.Группа3);
			
		ИначеЕсли Объект.ВидОперации = Перечисления.пкВидыОперацийСПультами.ПередачаКонтрагенту Тогда
			Элементы.ДанныеПоПультамКонтрагент.Видимость = Истина;
			Элементы.ДанныеПоПультамКонтрагент.Заголовок = "Контрагент";
			Элементы.ДанныеПоПультамСклад.Видимость = Истина;
			Элементы.ДанныеПоПультамСклад.Заголовок = "Техника";
			Элементы.ДанныеПоПультамЯчейка.Видимость = Истина;
			Элементы.ДанныеПоПультамЯчейка.Заголовок = "Объект строительства";
			
			Элементы.Переместить(Элементы.Группа2, Элементы.ДанныеПоПультам, Элементы.Группа3);
			Элементы.Переместить(Элементы.Группа1, Элементы.ДанныеПоПультам, Элементы.Группа2);
			
			Элементы.Переместить(Элементы.ДанныеПоПультамОбъектСтроительстваВозврат, Элементы.ДанныеПоПультам, Элементы.Группа1);
			Элементы.Переместить(Элементы.ДанныеПоПультамОбъектЭксплуатацииВозврат, Элементы.ДанныеПоПультам, Элементы.ДанныеПоПультамОбъектСтроительстваВозврат);
			Элементы.Переместить(Элементы.ДанныеПоПультамЯчейка, Элементы.ДанныеПоПультам, Элементы.ДанныеПоПультамОбъектЭксплуатацииВозврат);
			Элементы.Переместить(Элементы.ДанныеПоПультамКонтрагент, Элементы.ДанныеПоПультам, Элементы.ДанныеПоПультамЯчейка);
			Элементы.Переместить(Элементы.ДанныеПоПультамПульт, Элементы.ДанныеПоПультам, Элементы.ДанныеПоПультамКонтрагент);
			Элементы.Переместить(Элементы.ДанныеПоПультамСклад, Элементы.ДанныеПоПультам, Элементы.ДанныеПоПультамПульт);
			Элементы.Переместить(Элементы.ДанныеПоПультамВидОперации, Элементы.ДанныеПоПультам, Элементы.ДанныеПоПультамСклад);
			Элементы.Переместить(Элементы.ДанныеПоПультамНомерСтроки, Элементы.ДанныеПоПультам, Элементы.ДанныеПоПультамВидОперации);
			
			//Элементы.Переместить(Элементы.ДанныеПоПультамСклад, Элементы.Группа1);
			//Элементы.Переместить(Элементы.ДанныеПоПультамЯчейка, Элементы.Группа1);
			
			Элементы.Переместить(Элементы.ДанныеПоПультамКонтрагент, Элементы.Группа1);
			Элементы.Переместить(Элементы.ДанныеПоПультамЯчейка, Элементы.Группа1);
		
			Элементы.Переместить(Элементы.ДанныеПоПультамТекСклад, Элементы.Группа3);
			Элементы.Переместить(Элементы.ДанныеПоПультамТекЯчейка, Элементы.Группа3);
			
		КонецЕсли;	
		
	КонецЕсли;	
	
КонецПроцедуры	

&НаКлиенте
Процедура НастроитьВидимостьПоВидуОперации()
	
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеПоПультамВидОперацииПриИзменении(Элемент)
	
	ТекСтрока = Элементы.ДанныеПоПультам.ТекущиеДанные;
	
	Если ТекСтрока.ВидОперации = ПредопределенноеЗначение("Перечисление.пкВидыОперацийСПультами.ВнутреннееПеремещение")
		ИЛИ ТекСтрока.ВидОперации = ПредопределенноеЗначение("Перечисление.пкВидыОперацийСПультами.ВозвратОтКонтрагента")
		ИЛИ ТекСтрока.ВидОперации = ПредопределенноеЗначение("Перечисление.пкВидыОперацийСПультами.Поступление") Тогда
		Если ТипЗнч(ТекСтрока.Склад) <> Тип("СправочникСсылка.Склады") Тогда
			ТекСтрока.Склад = ПредопределенноеЗначение("Справочник.Склады.ПустаяСсылка");
			ТекСтрока.Ячейка = ПредопределенноеЗначение("Справочник.СкладскиеЯчейки.ПустаяСсылка");
		КонецЕсли;	
	ИначеЕсли ТекСтрока.ВидОперации = ПредопределенноеЗначение("Перечисление.пкВидыОперацийСПультами.ПередачаКонтрагенту") Тогда
		Если ТипЗнч(ТекСтрока.Склад) <> Тип("СправочникСсылка.Контрагенты") Тогда
			ТекСтрока.Склад = ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка");
			ТекСтрока.Ячейка = ПредопределенноеЗначение("Справочник.СМ_ОбъектыСтроительства.ПустаяСсылка");
		КонецЕсли;	
	Иначе
		ТекСтрока.Склад = Неопределено;
		ТекСтрока.Ячейка = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	///////////////	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	// Обработчик механизма "ВерсионированиеОбъектов"
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	
	// Обработчик подсистемы "Внешние обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	    ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	 // Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	///////////////	
	
//rarus+ saveld 07.12.2016	
	//Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) И НЕ ЗначениеЗаполнено(Объект.ДокументОснование) Тогда
//rarus- saveld 07.12.2016	
		Объект.ВидОперации = Перечисления.пкВидыОперацийСПультами.ПередачаКонтрагенту;
	КонецЕсли;	
	НастроитьВидимостьПоВидуОперацииВТЧ();
	
	Если Не ЗначениеЗаполнено(Объект.Ответственный) Тогда
		Объект.Ответственный = Пользователи.ТекущийПользователь();
//rarus+ saveld 07.12.2016	
		Объект.Подразделение = ЗначениеНастроекПовтИсп.ПодразделениеПользователя(Объект.Ответственный);		
//rarus- saveld 07.12.2016	
	КонецЕсли;
	ПолучитьТекущееМестоположение();
	
КонецПроцедуры

&НаКлиенте
Процедура ВидОперацииПриИзменении(Элемент)
	
	ТекСтрока = Элементы.ДанныеПоПультам.ТекущиеДанные;
	
	ВидОперацииДляСклада = Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.пкВидыОперацийСПультами.ВнутреннееПеремещение")
	ИЛИ Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.пкВидыОперацийСПультами.ВозвратОтКонтрагента")
	ИЛИ Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.пкВидыОперацийСПультами.Поступление");
	
	НастроитьВидимостьПоВидуОперацииВТЧ();
	
	ВидОперацииДляКонтрагента = Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.пкВидыОперацийСПультами.ПередачаКонтрагенту");	
	
	Для Каждого ТекСтрока Из Объект.ДанныеПоПультам Цикл
		
		Если ВидОперацииДляСклада Тогда
			Если ТипЗнч(ТекСтрока.Склад) <> Тип("СправочникСсылка.Склады") Тогда
				ТекСтрока.Склад = ПредопределенноеЗначение("Справочник.Склады.ПустаяСсылка");
				ТекСтрока.Ячейка = ПредопределенноеЗначение("Справочник.СкладскиеЯчейки.ПустаяСсылка");
			КонецЕсли;	
		ИначеЕсли ВидОперацииДляКонтрагента Тогда
			Если ТипЗнч(ТекСтрока.Склад) <> Тип("СправочникСсылка.ОбъектыЭксплуатации") Тогда
				ТекСтрока.Склад = ПредопределенноеЗначение("Справочник.ОбъектыЭксплуатации.ПустаяСсылка");
				ТекСтрока.Ячейка = ПредопределенноеЗначение("Справочник.СМ_ОбъектыСтроительства.ПустаяСсылка");
			КонецЕсли;	
		Иначе
			ТекСтрока.Склад = Неопределено;
			ТекСтрока.Ячейка = Неопределено;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеПоПультамСкладНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекСтрока = Элементы.ДанныеПоПультам.ТекущиеДанные;
	
	Если Объект.ВидОперацииВТабличнойЧасти Тогда
		ВидОперации = ТекСтрока.ВидОперации;
	Иначе
		ВидОперации = Объект.ВидОперации;
	КонецЕсли;	
	
	ВидОперацииДляСклада = ВидОперации = ПредопределенноеЗначение("Перечисление.пкВидыОперацийСПультами.ВнутреннееПеремещение")
	ИЛИ ВидОперации = ПредопределенноеЗначение("Перечисление.пкВидыОперацийСПультами.ВозвратОтКонтрагента")
	ИЛИ ВидОперации = ПредопределенноеЗначение("Перечисление.пкВидыОперацийСПультами.Поступление");
	
	//ВидОперацииДляКонтрагента = ВидОперации = ПредопределенноеЗначение("Перечисление.пкВидыОперацийСПультами.ПередачаКонтрагенту");	
	
	ПараметрыФормы = Новый Структура;
	Если ВидОперацииДляСклада Тогда
		ОткрытьФорму("Справочник.Склады.ФормаВыбора", ПараметрыФормы, Элемент);
	Иначе
		
		ПараметрыФормы = Новый Структура;
		ФН = Новый НастройкиКомпоновкиДанных;
		Если ЗначениеЗаполнено(Объект.ДокументОснование) Тогда
			СписокСсылок = ПолучитьСписокОбъектовЭксплуатацииПоДоставке(Объект.ДокументОснование);
			Эл = ФН.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			Эл.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Ссылка");
			Эл.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
			Эл.ПравоеЗначение = СписокСсылок;
			Эл.Использование = Истина;
			Эл.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		КонецЕсли;	
		Эл = ФН.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Эл.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("пкЭтоТехника");
		Эл.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		Эл.ПравоеЗначение = Истина;
		Эл.Использование = Истина;
		Эл.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		ПараметрыФормы.Вставить("ФиксированныеНастройки", ФН);
		
		ОткрытьФорму("Справочник.ОбъектыЭксплуатации.ФормаВыбора", ПараметрыФормы, Элемент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеПоПультамЯчейкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекСтрока = Элементы.ДанныеПоПультам.ТекущиеДанные;
	
	Если Объект.ВидОперацииВТабличнойЧасти Тогда
		ВидОперации = ТекСтрока.ВидОперации;
	Иначе
		ВидОперации = Объект.ВидОперации;
	КонецЕсли;	
	
	ВидОперацииДляСклада = ВидОперации = ПредопределенноеЗначение("Перечисление.пкВидыОперацийСПультами.ВнутреннееПеремещение")
	ИЛИ ВидОперации = ПредопределенноеЗначение("Перечисление.пкВидыОперацийСПультами.ВозвратОтКонтрагента")
	ИЛИ ВидОперации = ПредопределенноеЗначение("Перечисление.пкВидыОперацийСПультами.Поступление");
	
	//ВидОперацииДляКонтрагента = ВидОперации = ПредопределенноеЗначение("Перечисление.пкВидыОперацийСПультами.ПередачаКонтрагенту");	
	
	Если ВидОперацииДляСклада Тогда
		
		ПараметрыФормы = Новый Структура;
		ФН = Новый НастройкиКомпоновкиДанных;
		Эл = ФН.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Эл.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Владелец");
		Эл.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		Эл.ПравоеЗначение = ТекСтрока.Склад;
		Эл.Использование = Истина;
		Эл.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		
		ПараметрыФормы.Вставить("ФиксированныеНастройки", ФН);
		
		ОткрытьФорму("Справочник.СкладскиеЯчейки.Форма.ФормаВыбора", ПараметрыФормы, Элемент);
	Иначе
		ОткрытьФорму("Справочник.СМ_ОбъектыСтроительства.Форма.ФормаВыбора", ПараметрыФормы, Элемент);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьТекущееМестоположение()
	
	Для Каждого ТекСтрока Из Объект.ДанныеПоПультам Цикл
		ПолучитьТекущееМестоположениеДляСтроки(ТекСтрока.Пульт, ТекСтрока.ТекСклад, ТекСтрока.ТекЯчейка, ТекСтрока.ТекСтатус);
	КонецЦикла;
	
КонецПроцедуры	

&НаСервере
Процедура ПолучитьТекущееМестоположениеДляСтроки(Пульт, Склад, Ячейка, Статус)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	пкМестонахожденияПультовДляПодъемниковСрезПоследних.Статус КАК ТекСтатус,
	|	пкМестонахожденияПультовДляПодъемниковСрезПоследних.Местонахождение КАК ТекСклад,
	|	пкМестонахожденияПультовДляПодъемниковСрезПоследних.Ячейка КАК ТекЯчейка
	|ИЗ
	|	РегистрСведений.пкМестонахожденияПультовДляПодъемников.СрезПоследних(&Дата, Пульт = &Пульт) КАК пкМестонахожденияПультовДляПодъемниковСрезПоследних";
	
	Запрос.УстановитьПараметр("Дата", ?(ЗначениеЗаполнено(Объект.Ссылка),Объект.Дата - 1,ТекущаяДата()));
	Запрос.УстановитьПараметр("Пульт", Пульт);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Склад = ВыборкаДетальныеЗаписи.ТекСклад;
		Ячейка = ВыборкаДетальныеЗаписи.ТекЯчейка;
		Статус = ВыборкаДетальныеЗаписи.ТекСтатус;
	Иначе
		Склад = Неопределено;
		Ячейка = Неопределено;
		Статус = Перечисления.пкСтатусСостоянияПульта.ПустаяСсылка();
	КонецЕсли;	
	
КонецПроцедуры	

&НаКлиенте
Процедура ДанныеПоПультамПультПриИзменении(Элемент)
	
	ТекСтрока = Элементы.ДанныеПоПультам.ТекущиеДанные;
	ПолучитьТекущееМестоположениеДляСтроки(ТекСтрока.Пульт, ТекСтрока.ТекСклад, ТекСтрока.ТекЯчейка, ТекСтрока.ТекСтатус);
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеПоПультамСкладПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.ДокументОснование) Тогда
		ТекСтрока = Элементы.ДанныеПоПультам.ТекущиеДанные;
		Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.пкВидыОперацийСПультами.ПередачаКонтрагенту") Тогда
			ДанныеПоПультамСкладПриИзмененииНаСервере(Объект.ДокументОснование,ТекСтрока.Склад, ТекСтрока.Ячейка, ТекСтрока.Партнер);
		ИначеЕсли Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.пкВидыОперацийСПультами.ВозвратОтКонтрагента") Тогда
			ДанныеПоПультамСкладПриИзмененииНаСервере(Объект.ДокументОснование,ТекСтрока.ОбъектЭксплуатацииВозврат, ТекСтрока.ОбъектСтроительстваВозврат, ТекСтрока.Партнер);
		КонецЕсли;	
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ДанныеПоПультамСкладПриИзмененииНаСервере(ДокументОснование, ОбъектЭксплуатации, ОбъектСтроительства, Контрагент)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	пкДоставкаЗаданияНаПеревозку.ЗаданиеНаПеревозку.ЗаявкаНаАрендуТехники.Партнер КАК Контрагент,
		|	пкДоставкаЗаданияНаПеревозку.ЗаданиеНаПеревозку.ЗаявкаНаАрендуТехники.ОбъектСтроительства КАК ОбъектСтроительства
		|ИЗ
		|	Документ.пкДоставка.ЗаданияНаПеревозку КАК пкДоставкаЗаданияНаПеревозку
		|ГДЕ
		|	пкДоставкаЗаданияНаПеревозку.Ссылка = &Ссылка И пкДоставкаЗаданияНаПеревозку.ЗаданиеНаПеревозку.Техника = &Техника";
	
	Запрос.УстановитьПараметр("Ссылка", ДокументОснование);
	Запрос.УстановитьПараметр("Техника", ОбъектЭксплуатации);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Контрагент = ВыборкаДетальныеЗаписи.Контрагент;
		ОбъектСтроительства = ВыборкаДетальныеЗаписи.ОбъектСтроительства;
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСписокОбъектовЭксплуатацииПоДоставке(ДокументОснование)

	Результат = Новый СписокЗначений;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	пкДоставкаЗаданияНаПеревозку.ЗаданиеНаПеревозку.Техника КАК Техника
		|ИЗ
		|	Документ.пкДоставка.ЗаданияНаПеревозку КАК пкДоставкаЗаданияНаПеревозку
		|ГДЕ
		|	пкДоставкаЗаданияНаПеревозку.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", ДокументОснование);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
	ПерваяСтрока = Истина;
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Результат.Добавить(ВыборкаДетальныеЗаписи.Техника); 
	КонецЦикла;	
		
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ДанныеПоПультамПультНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекСтрока = Элементы.ДанныеПоПультам.ТекущиеДанные;
	
	ОбъектЭксплуатации = Неопределено;
	ДоступныеПодъемники = Неопределено;
	
	Если ТипЗнч(ТекСтрока.Склад) = Тип("СправочникСсылка.ОбъектыЭксплуатации") И ЗначениеЗаполнено(ТекСтрока.Склад) Тогда
		ОбъектЭксплуатации = ТекСтрока.Склад;
	ИначеЕсли ЗначениеЗаполнено(ТекСтрока.ОбъектЭксплуатацииВозврат) Тогда
		ОбъектЭксплуатации = ТекСтрока.ОбъектЭксплуатацииВозврат;
	//Иначе
	//	СтандартнаяОбработка = Истина;
	//	Возврат;
	КонецЕсли;	
	
	Если Объект.ВидОперацииВТабличнойЧасти = Ложь Тогда
		ВО = Объект.ВидОперации;
	Иначе
		ТекДанные = Элементы.ДанныеПоПультам.ТекущиеДанные;
		Если ТекДанные <> Неопределено Тогда
			ВО = ТекДанные.ВидОперации;
		КонецЕсли;	
	КонецЕсли;	
	
	ДоступныеПодъемники = ПолучитьСписокДоступныхПодъемников(ВО, Объект.Дата);
	
	Если ОбъектЭксплуатации = Неопределено И ДоступныеПодъемники = Неопределено Тогда
		СтандартнаяОбработка = Истина;
		Возврат;
	КонецЕсли;	
	
	ПараметрыФормы = Новый Структура;
	ФН = Новый НастройкиКомпоновкиДанных;
	
	Если ОбъектЭксплуатации <> Неопределено Тогда
		Эл = ФН.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Эл.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТипПульта");
		Эл.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		Эл.ПравоеЗначение = ПолучитТипПультаДляОбъектаЭксплуатации(ОбъектЭксплуатации);
		Эл.Использование = Истина;
		Эл.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	КонецЕсли;
	
	Если ДоступныеПодъемники <> Неопределено Тогда
		Эл = ФН.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Эл.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Ссылка");
		Эл.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
		Эл.ПравоеЗначение = ДоступныеПодъемники;
		Эл.Использование = Истина;
		Эл.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	КонецЕсли;
	ПараметрыФормы.Вставить("ФиксированныеНастройки", ФН);
	
	ОткрытьФорму("Справочник.пкПультыДляПодъемников.ФормаВыбора", ПараметрыФормы, Элемент);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСписокДоступныхПодъемников(ВидОперации, Дата)
	
	СписокПультов = Новый СписокЗначений;
	
	Если ВидОперации = Перечисления.пкВидыОперацийСПультами.Поступление Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	пкМестонахожденияПультовДляПодъемниковСрезПоследних.Пульт
			|ПОМЕСТИТЬ ВТ_ПультыСоСтатусом
			|ИЗ
			|	РегистрСведений.пкМестонахожденияПультовДляПодъемников.СрезПоследних(&Дата, ) КАК пкМестонахожденияПультовДляПодъемниковСрезПоследних
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	пкПультыДляПодъемников.Ссылка КАК Пульт
			|ИЗ
			|	Справочник.пкПультыДляПодъемников КАК пкПультыДляПодъемников
			|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ПультыСоСтатусом КАК ВТ_ПультыСоСтатусом
			|		ПО ВТ_ПультыСоСтатусом.Пульт = пкПультыДляПодъемников.Ссылка
			|ГДЕ
			|	ВТ_ПультыСоСтатусом.Пульт ЕСТЬ NULL ";
	
		Запрос.УстановитьПараметр("Дата", Дата);
		
	Иначе	
	
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	пкМестонахожденияПультовДляПодъемниковСрезПоследних.Пульт
			|ИЗ
			|	РегистрСведений.пкМестонахожденияПультовДляПодъемников.СрезПоследних(&Дата, ) КАК пкМестонахожденияПультовДляПодъемниковСрезПоследних
			|ГДЕ
			|	пкМестонахожденияПультовДляПодъемниковСрезПоследних.Статус = &Статус";
	
		Запрос.УстановитьПараметр("Дата", Дата);
		Если ВидОперации = Перечисления.пкВидыОперацийСПультами.Списание ИЛИ ВидОперации = Перечисления.пкВидыОперацийСПультами.ВнутреннееПеремещение ИЛИ
			ВидОперации = Перечисления.пкВидыОперацийСПультами.ПередачаКонтрагенту Тогда
			Запрос.УстановитьПараметр("Статус", Перечисления.пкСтатусСостоянияПульта.НаСкладе);
		ИначеЕсли ВидОперации = Перечисления.пкВидыОперацийСПультами.ВозвратОтКонтрагента Тогда
			Запрос.УстановитьПараметр("Статус", Перечисления.пкСтатусСостоянияПульта.ВАренде);
		КонецЕсли;	
	
	КонецЕсли;	
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		СписокПультов.Добавить(ВыборкаДетальныеЗаписи.Пульт); 
	КонецЦикла;
	Возврат СписокПультов;	
КонецФункции

&НаСервере
Функция ПолучитТипПультаДляОбъектаЭксплуатации(ОбъектЭксплуатации)
	
	Возврат ОбъектЭксплуатации.пкМодель.пкТипПульта;
	
КонецФункции


&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПолучитьТекущееМестоположение();
	
КонецПроцедуры


&НаКлиенте
Процедура ДанныеПоПультамСкладНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
КонецПроцедуры


&НаКлиенте
Процедура ДанныеПоПультамСкладАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
КонецПроцедуры


//rarus+ saveld 07.12.2016	
&НаКлиенте
Процедура ОтветственныйПриИзменении(Элемент)
	ОтветственныйПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОтветственныйПриИзмененииНаСервере()
		Объект.Подразделение = ЗначениеНастроекПовтИсп.ПодразделениеПользователя(Объект.Ответственный);		
КонецПроцедуры
//rarus- saveld 07.12.2016	

