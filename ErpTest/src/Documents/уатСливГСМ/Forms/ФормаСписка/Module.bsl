
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//уатЗащищенныеФункцииСервер.уатДокументФормаСпискаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ДопПараметрыОткрытие);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ТекОрг = уатОбщегоНазначенияПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(ПользователиКлиентСервер.ТекущийПользователь(), "ОсновнаяОрганизация");
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ТекОрг", ТекОрг);
	
	// УправлениеПредприятием.СлужебныеПодсистемы
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	// Конец УправлениеПредприятием.СлужебныеПодсистемы
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	//уатЗащищенныеФункцииКлиент.уатДокументФормаСпискаПриОткрытии(Отказ, ДопПараметрыОткрытие);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_Список

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// УправлениеПредприятием.СлужебныеПодсистемы
&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
КонецПроцедуры
// Конец УправлениеПредприятием.СлужебныеПодсистемы

&НаКлиенте
Процедура ТиповыеДокументы(Команда)
	ТекСтрока = Элементы.Список.ТекущаяСтрока;
	Если ЗначениеЗаполнено(ТекСтрока) Тогда
		ВидОперации = уатОбщегоНазначенияТиповые.ПолучитьЗначениеРеквизита(ТекСтрока, "ВидОперации");
		Если ВидОперации = ПредопределенноеЗначение("Перечисление.уатВидыОперацийСливГСМ.НаАЗС")
			ИЛИ ВидОперации = ПредопределенноеЗначение("Перечисление.уатВидыОперацийСливГСМ.НаСклад") Тогда
			уатТиповыеДокументыКлиент.ВвестиТиповойДокумент(Новый ОписаниеОповещения("ТиповыеДокументыЗавершение", ЭтотОбъект), ТекСтрока);
		Иначе
			ПоказатьПредупреждение(, "Для данного вида операции ввод типовых документов не предусмотрен!", 30);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТиповыеДокументыЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    Элементы.Список.Обновить();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
