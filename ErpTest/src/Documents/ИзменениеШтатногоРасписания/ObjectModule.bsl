#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем СозданныеПозиции;

#КонецОбласти

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступом.ЗаполнитьНаборыЗначенийДоступа.
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	УправлениеШтатнымРасписанием.ЗаполнитьНаборыЗначенийДоступа(ЭтотОбъект, Таблица);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	УправлениеШтатнымРасписанием.ДокументыПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения, СозданныеПозиции, ДатаВступленияВСилу, "ДатаВступленияВСилу");
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	УправлениеШтатнымРасписанием.ДокументыОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения, СозданныеПозиции, ДатаВступленияВСилу);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ОрганизационнаяСтруктура") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ОрганизационнаяСтруктура");
		Модуль.ПриПроведенииДокументовИзмененияШтатногоРасписания(ЭтотОбъект);
	КонецЕсли;
		
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, ДатаВступленияВСилу, "Объект.ДатаВступленияВСилу", Отказ, НСтр("ru='Дата изменений'"), , , Ложь);
	
	УправлениеШтатнымРасписанием.ДокументыОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ДатаВступленияВСилу, "ДатаВступленияВСилу", Ложь);
	ОстаткиОтпусков.ОбработкаПроверкиЗаполненияЕжегодныхОтпусковПозицийВДокументе(Позиции, ЕжегодныеОтпуска, ПроверяемыеРеквизиты, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура АвтозаполнениеТекущимиДаннымиШР() Экспорт
	
	УправлениеШтатнымРасписанием.АвтозаполнениеТекущимиДаннымиШтатногоРасписания(ЭтотОбъект, ДатаВступленияВСилу);
	
КонецПроцедуры

Процедура ЗаполнитьДокументПоИзменениямТарифнойСетки(ТарифнаяСетка) Экспорт
	
	РезультатЗапроса = УправлениеШтатнымРасписанием.РезультатЗапросаПоИзменениямПозицийШтатногоРасписания(ТарифнаяСетка, Организация, ДатаВступленияВСилу);
	
	Если РезультатЗапроса <> Неопределено Тогда
		
		ТаблицаПозицийКИзменению = РезультатЗапроса.Выгрузить();
		
		УправлениеШтатнымРасписанием.ЗаполнитьОбъектИзменениямиПозицийШтатногоРасписания(ЭтотОбъект, ТаблицаПозицийКИзменению, ТарифнаяСетка);
			
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#КонецЕсли