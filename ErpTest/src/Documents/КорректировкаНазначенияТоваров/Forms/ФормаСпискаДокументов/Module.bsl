

#Область ОбработкичиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ЗаполнитьДоступныеДействия();
	

	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.Дата", Элементы.Дата.Имя);

	
КонецПроцедуры

#КонецОбласти

#Область ОбработкичиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// МенюОтчеты


&НаКлиенте
Процедура СоздатьСнятиеРезерваПоНазначению(Команда)
	
	СоздатьКорректировку(ПредопределенноеЗначение("Перечисление.ВидыОперацийКорректировкиНазначения.СнятьРезерв"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьСнятиеРезерваМногихНазначений(Команда)
	
	СоздатьКорректировку(ПредопределенноеЗначение("Перечисление.ВидыОперацийКорректировкиНазначения.СнятьРезервПоМногимНазначениям"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьРезервированиеНаСкладахИПеремещениеРезервов(Команда)
	
	СоздатьКорректировку(ПредопределенноеЗначение("Перечисление.ВидыОперацийКорректировкиНазначения.РезервироватьИКорректировать"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьРезервированиеНаСкладах(Команда)
	
	СоздатьКорректировку(ПредопределенноеЗначение("Перечисление.ВидыОперацийКорректировкиНазначения.Резервировать"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьКорректировкуНазначения(Команда)
	
	СоздатьКорректировку(ПредопределенноеЗначение("Перечисление.ВидыОперацийКорректировкиНазначения.ПроизвольнаяКорректировкаНазначений"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьКорректировку(ВидОперации)
	
	СтруктураОснование = Новый Структура("ВидОперации", ВидОперации);
	СтруктураПараметры = Новый Структура("Основание", СтруктураОснование);
	
	ОткрытьФорму("Документ.КорректировкаНазначенияТоваров.ФормаОбъекта", СтруктураПараметры, Элементы.Список);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДоступныеДействия()
	
	ДоступныеДействия = Документы.КорректировкаНазначенияТоваров.ДоступныеДействия();
	
	Если ДоступныеДействия.Найти(Перечисления.ВидыОперацийКорректировкиНазначения.СнятьРезервПоМногимНазначениям) = Неопределено Тогда
		Элементы.ФормаСоздатьСнятиеМногихНазначений.Видимость = Ложь;
	КонецЕсли;
	
	Если ДоступныеДействия.Найти(Перечисления.ВидыОперацийКорректировкиНазначения.РезервироватьИКорректировать) = Неопределено Тогда
		Элементы.ФормаСоздатьРезервированиеНаСкладахИПеремещениеРезервов.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти
