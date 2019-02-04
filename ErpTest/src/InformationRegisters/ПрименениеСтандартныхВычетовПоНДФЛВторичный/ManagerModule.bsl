#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(ФизическоеЛицо)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьВторичныеДанныеПрименениеСтандартныхВычетовПоНДФЛ(ПараметрыОбновления = Неопределено) Экспорт
	ЗаполнитьВторичныеДанные();
	ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", Истина);
КонецПроцедуры

Процедура ЗаполнитьВторичныеДанные(ФизическиеЛица = Неопределено) Экспорт
	
	Набор = РегистрыСведений.ПрименениеСтандартныхВычетовПоНДФЛВторичный.СоздатьНаборЗаписей();
	Набор.ОбменДанными.Загрузка = Истина;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПрименениеСтандартныхВычетовПоНДФЛ.Период КАК Период,
	|	ПрименениеСтандартныхВычетовПоНДФЛ.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ПрименениеСтандартныхВычетовПоНДФЛ.ГоловнаяОрганизация КАК ГоловнаяОрганизация
	|ИЗ
	|	РегистрСведений.ПрименениеСтандартныхВычетовПоНДФЛ КАК ПрименениеСтандартныхВычетовПоНДФЛ
	|ГДЕ
	|	ПрименениеСтандартныхВычетовПоНДФЛ.ФизическоеЛицо В(&ФизическоеЛицо)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ФизическоеЛицо,
	|	Период";
	
	Если ФизическиеЛица = Неопределено Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ПрименениеСтандартныхВычетовПоНДФЛ.ФизическоеЛицо В(&ФизическоеЛицо)", "(ИСТИНА)");
		// Очищаем набор перед заполнением
		Набор.Записать();
	ИначеЕсли ФизическиеЛица.Количество() = 1 Тогда
		Запрос.УстановитьПараметр("ФизическоеЛицо", ФизическиеЛица[0]);
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "В(&ФизическоеЛицо)", "= &ФизическоеЛицо");
	Иначе
		Запрос.УстановитьПараметр("ФизическоеЛицо", ФизическиеЛица);
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Количество() = 0 Тогда
		Если ФизическиеЛица <> Неопределено Тогда
			Для Каждого ФизическоеЛицо Из ФизическиеЛица Цикл
				Набор.Отбор.ФизическоеЛицо.Установить(ФизическоеЛицо);
				Набор.Записать();
			КонецЦикла;
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Пока Выборка.СледующийПоЗначениюПоля("ФизическоеЛицо") Цикл
		
		Набор.Отбор.ФизическоеЛицо.Установить(Выборка.ФизическоеЛицо);
		
		Пока Выборка.Следующий() Цикл
			Если Набор.Количество() > 0 Тогда
				Набор[Набор.Количество() - 1].ДатаОкончания = Выборка.Период - 1;
			КонецЕсли;
			
			Запись = Набор.Добавить();
			Запись.ДатаНачала = Выборка.Период;
			Запись.ФизическоеЛицо = Выборка.ФизическоеЛицо;
			Запись.ГоловнаяОрганизация = Выборка.ГоловнаяОрганизация;
			Запись.ПрименятьВычеты = Истина;
		КонецЦикла;
		
		Набор[Набор.Количество() - 1].ДатаОкончания = ЗарплатаКадрыПериодическиеРегистры.МаксимальнаяДата();
		Набор.Записать();
		Набор.Очистить();
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли