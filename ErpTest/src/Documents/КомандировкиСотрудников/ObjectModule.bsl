#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Действие") И ДанныеЗаполнения.Действие = "ЗаполнитьИзОбучения" Тогда
			Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ОбучениеРазвитие") Тогда 
				МодульОбучениеРазвитие = ОбщегоНазначения.ОбщийМодуль("ОбучениеРазвитие");
				МодульОбучениеРазвитие.ЗаполнитьКомандировкиСотрудниковИзДокументаОбучения(ЭтотОбъект, ДанныеЗаполнения);
			КонецЕсли;
		КонецЕсли;
		Если ДанныеЗаполнения.Свойство("ЗаполнитьПоПараметрамЗаполнения") И ДанныеЗаполнения.ЗаполнитьПоПараметрамЗаполнения Тогда
			ЗаполнитьПоПараметрамЗаполнения(ДанныеЗаполнения);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	 Для каждого Строка Из Сотрудники Цикл
		Если ЗначениеЗаполнено(Строка.ДатаНачала)
			И ЗначениеЗаполнено(Строка.ДатаОкончания)
			И Строка.ДатаОкончания < Строка.ДатаНачала Тогда
			НомерТекущейСтроки = Строка.НомерСтроки - 1;
	        ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Дата начала командировки не может быть меньше даты окончания.'"),,"Объект.Сотрудники[" + НомерТекущейСтроки + "].ДатаОкончания",, Отказ);
		КонецЕсли;
	 КонецЦикла;
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ДатаСобытия = Дата;
	Документы.КомандировкиСотрудников.ЗаполнитьДатуЗапретаРедактирования(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ОбновитьСвязанныеКомандировки(Отказ);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОбновитьСвязанныеКомандировки(Отказ)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КомандировкиСотрудниковСотрудники.НомерСтроки
	|ИЗ
	|	Документ.КомандировкиСотрудников.Сотрудники КАК КомандировкиСотрудниковСотрудники
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.Командировка КАК КомандировкаДокументы
	|		ПО КомандировкиСотрудниковСотрудники.Командировка = КомандировкаДокументы.Ссылка
	|			И (КомандировкиСотрудниковСотрудники.Сотрудник <> КомандировкаДокументы.Сотрудник
	|				ИЛИ КомандировкиСотрудниковСотрудники.ФизическоеЛицо <> КомандировкаДокументы.ФизическоеЛицо
	|				ИЛИ КомандировкиСотрудниковСотрудники.ДатаНачала <> КомандировкаДокументы.ДатаНачала
	|				ИЛИ КомандировкиСотрудниковСотрудники.ДатаОкончания <> КомандировкаДокументы.ДатаОкончания
	|				ИЛИ КомандировкиСотрудниковСотрудники.ДнейВПути <> КомандировкаДокументы.ДнейВПути
	|				ИЛИ КомандировкиСотрудниковСотрудники.ДатаНачала <> КомандировкаДокументы.ДатаНачалаСобытия
	|				ИЛИ (ВЫРАЗИТЬ(КомандировкиСотрудниковСотрудники.МестоНазначения КАК СТРОКА(100))) <> (ВЫРАЗИТЬ(КомандировкаДокументы.МестоНазначения КАК СТРОКА(100)))
	|				ИЛИ (ВЫРАЗИТЬ(КомандировкиСотрудниковСотрудники.ОрганизацияНазначения КАК СТРОКА(100))) <> (ВЫРАЗИТЬ(КомандировкаДокументы.ОрганизацияНазначения КАК СТРОКА(100)))
	|				ИЛИ (ВЫРАЗИТЬ(КомандировкиСотрудниковСотрудники.Цель КАК СТРОКА(100))) <> (ВЫРАЗИТЬ(КомандировкаДокументы.Цель КАК СТРОКА(100)))
	|				ИЛИ (ВЫРАЗИТЬ(КомандировкиСотрудниковСотрудники.КомандировкаЗаСчетСредств КАК СТРОКА(100))) <> (ВЫРАЗИТЬ(КомандировкаДокументы.КомандировкаЗаСчетСредств КАК СТРОКА(100)))
	|				ИЛИ (ВЫРАЗИТЬ(КомандировкиСотрудниковСотрудники.Ссылка.Основание КАК СТРОКА(100))) <> (ВЫРАЗИТЬ(КомандировкаДокументы.Основание КАК СТРОКА(100))))
	|ГДЕ
	|	КомандировкиСотрудниковСотрудники.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			ОбновитьСвязаннуюКомандировку(Сотрудники[Выборка.НомерСтроки -1], Отказ);
		КонецЦикла;	
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьСвязаннуюКомандировку(Строка, Отказ)
	
	Если Не ЗначениеЗаполнено(Строка) 
		Или Не ЗначениеЗаполнено(Строка.Командировка) Тогда
		Возврат;
	КонецЕсли;
	
	Попытка
		ДокументОбъект = Строка.Командировка.ПолучитьОбъект();
		Если НЕ (ДокументОбъект.Проведен И ДокументОбъект.ДокументРассчитан) Тогда
			ДокументОбъект.Сотрудник = Строка.Сотрудник;
			ДокументОбъект.ФизическоеЛицо = Строка.ФизическоеЛицо;
			ДокументОбъект.ДатаНачала = Строка.ДатаНачала;
			ДокументОбъект.ДатаОкончания = Строка.ДатаОкончания;
			ДокументОбъект.ДнейВПути = Строка.ДнейВПути;
			ДокументОбъект.ДатаНачалаСобытия = Строка.ДатаНачала;
		КонецЕсли;
		
		ДокументОбъект.МестоНазначения = Строка.МестоНазначения;
		ДокументОбъект.ОрганизацияНазначения = Строка.ОрганизацияНазначения;
		ДокументОбъект.Цель = Строка.Цель;
		ДокументОбъект.КомандировкаЗаСчетСредств = Строка.КомандировкаЗаСчетСредств;
		ДокументОбъект.Основание = Основание;
		ДокументОбъект.Записать(РежимЗаписиДокумента.Запись);
	Исключение
		НомерТекущейСтроки = Строка.НомерСтроки - 1;
		ТекстСообщения = НСтр("ru = 'Не удалось обновить командировку %1.'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Строка.Командировка);
	    ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.Сотрудники[" + НомерТекущейСтроки + "].Командировка" , , Отказ);
	КонецПопытки;
КонецПроцедуры

Процедура ЗаполнитьПоПараметрамЗаполнения(ДанныеЗаполнения)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	
	ЗаполняемыеЗначения = Новый Структура(
		"Организация,
		|Руководитель,
		|ДолжностьРуководителя, 
		|Ответственный");
	ЗаполнитьЗначенияСвойств(ЗаполняемыеЗначения, ЭтотОбъект);
	ЗарплатаКадры.ПолучитьЗначенияПоУмолчанию(ЗаполняемыеЗначения, ТекущаяДатаСеанса());
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЗаполняемыеЗначения, , "Организация");
	
	ДатаСобытия = ДанныеЗаполнения.ДатаНачала;
	
	Если Не ДанныеЗаполнения.Свойство("Сотрудники") Тогда
		Возврат;
	КонецЕсли;
	
	// Добавляем отсутствующих, если пересекается период.
	ОбработанныеСтроки = Новый Соответствие;
	ОтборСтрок = Новый Структура("Сотрудник");
	Для Каждого СтрокаСотрудника Из ДанныеЗаполнения.Сотрудники Цикл
		Сотрудник = СтрокаСотрудника.Сотрудник;
		Командировка = СтрокаСотрудника.Командировка;
		НоваяСтрока = Неопределено;
		ОтборСтрок.Сотрудник = Сотрудник;
		НайденныеСтроки = Сотрудники.НайтиСтроки(ОтборСтрок);
		Если НайденныеСтроки.Количество() > 0 Тогда
			Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
				Если ДанныеЗаполнения.ДатаНачала < НайденнаяСтрока.ДатаОкончания И ДанныеЗаполнения.ДатаОкончания > НайденнаяСтрока.ДатаНачала Тогда
					НоваяСтрока = НайденнаяСтрока;
					ОбработанныеСтроки.Вставить(НоваяСтрока, Истина);
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		Если НоваяСтрока = Неопределено Тогда
			НоваяСтрока = Сотрудники.Добавить();
			НоваяСтрока.Сотрудник = Сотрудник;
			НоваяСтрока.Командировка = Командировка;
			ОбработанныеСтроки.Вставить(НоваяСтрока, Истина);
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ДанныеЗаполнения);
		// Готовим параметры заполнения командировки сотрудника.
		ПараметрыЗаполнения = Документы.Командировка.ПараметрыЗаполнения();
		ЗаполнитьЗначенияСвойств(ПараметрыЗаполнения, ДанныеЗаполнения);
		ПараметрыЗаполнения.Сотрудник = Сотрудник;
		// Создаем (или изменяем существующую) и заполняем командировку сотрудника.
		Если Не ЗначениеЗаполнено(НоваяСтрока.Командировка) Тогда
			КомандировкаОбъект = Документы.Командировка.СоздатьДокумент();
		Иначе
			КомандировкаОбъект = НоваяСтрока.Командировка.ПолучитьОбъект();
		КонецЕсли;
		КомандировкаОбъект.Заполнить(ПараметрыЗаполнения);
		КомандировкаОбъект.Записать(РежимЗаписиДокумента.Проведение);
		НоваяСтрока.Командировка = КомандировкаОбъект.Ссылка;
	КонецЦикла;
	
	// Удаляем лишних.
	УдаляемыеСтроки = Новый Массив;
	Для Каждого СтрокаТаблицы Из Сотрудники Цикл
		Если ОбработанныеСтроки[СтрокаТаблицы] = Неопределено Тогда
			УдаляемыеСтроки.Добавить(СтрокаТаблицы);
		КонецЕсли;
	КонецЦикла;
	Для Каждого СтрокаТаблицы Из УдаляемыеСтроки Цикл
		КомандировкаОбъект = СтрокаТаблицы.Командировка.ПолучитьОбъект();
		КомандировкаОбъект.УстановитьПометкуУдаления(Истина);
		Сотрудники.Удалить(СтрокаТаблицы);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли