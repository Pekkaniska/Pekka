#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступом.ЗаполнитьНаборыЗначенийДоступа.
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	ЗарплатаКадры.ЗаполнитьНаборыПоОрганизацииИСотрудникам(ЭтотОбъект, Таблица, "Организация", "Сотрудник");
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

// В качестве данных заполнения может принимать структуру с полями.
//		Ссылка
//		Действие
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Сотрудники") Тогда
		ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ДанныеЗаполнения);
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Действие")Тогда 
			Если ДанныеЗаполнения.Действие = "Исправить" Тогда
				
				ИсправлениеДокументовЗарплатаКадры.СкопироватьДокумент(ЭтотОбъект, 
						ДанныеЗаполнения.Ссылка, 
						"ПерерасчетВыполнен,ДокументЗаполнения", 
						"Начисления,НачисленияПерерасчет,НачисленияПерерасчетНулевыеСторно,
						|Показатели,РаспределениеРезультатовНачислений",
						ДанныеЗаполнения);
				
				ИсправленныйДокумент = ДанныеЗаполнения.Ссылка;
				ЗарплатаКадрыРасширенный.ПриКопированииМногофункциональногоДокумента(ЭтотОбъект);
			ИначеЕсли ДанныеЗаполнения.Действие = "Заполнить" Тогда
				ЗаполнитьПоДаннымЗаполнения(ДанныеЗаполнения);
				РассчитатьПослеЗаполнения();
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	ЗарплатаКадрыРасширенный.ОбработкаЗаполненияМногофункциональногоДокумента(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Документы.ОтпускБезСохраненияОплаты.ПровестиПоУчетам(Ссылка, РежимПроведения, Отказ, Неопределено, Движения, ЭтотОбъект, ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Документы.ОтпускБезСохраненияОплаты.ПроверитьРаботающих(ЭтотОбъект, Отказ);
	
	Если ОтсутствиеВТечениеЧастиСмены Тогда
		
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ДатаНачала");
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ДатаОкончания");
		
		ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, ДатаОтсутствия, "Объект.ДатаОтсутствия", Отказ, НСтр("ru='Дата отсутствия'"), , , Ложь);
		
	Иначе
		
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ЧасовОтпуска");
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ДатаОтсутствия");
		
		ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, ДатаНачала, "Объект.ДатаНачала", Отказ, НСтр("ru='Начало отсутствия'"), , , Ложь);
		
	КонецЕсли;
	
	ПраваНаДокумент = ЗарплатаКадрыРасширенный.ПраваНаМногофункциональныйДокумент(ЭтотОбъект);
	
	Если ПраваНаДокумент.ОграниченияНаУровнеЗаписей.ИзменениеБезОграничений Тогда
		
		Если ОтсутствиеВТечениеЧастиСмены Тогда
			
			ДанныеОВремениДляПроверки = Документы.ОтпускБезСохраненияОплаты.ДанныеОВремени(ЭтотОбъект);
			ОшибкиВводаВремени = УчетРабочегоВремениРасширенный.ПроверитьРегистрациюВнутрисменногоВремени(Ссылка, ДанныеОВремениДляПроверки, ПериодРегистрации);
			
			Ошибки = Новый Соответствие;
			Для Каждого ОписаниеОшибки Из ОшибкиВводаВремени Цикл
				
				УчетРабочегоВремениРасширенный.ДобавитьОшибкуПоСотруднику(Ошибки, ОписаниеОшибки.Сотрудник, ОписаниеОшибки.ТекстОшибки, "", ОписаниеОшибки.Документ);		
				
			КонецЦикла;
			
			УчетРабочегоВремениРасширенный.ВывестиОшибкиПоСотрудникам(Ошибки, Отказ);
		КонецЕсли;
		
	КонецЕсли; 
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьРасчетЗарплатыРасширенная") Тогда
		
		ИсправлениеДокументовЗарплатаКадры.ПроверитьЗаполнение(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ);
		
		ЗарплатаКадрыРасширенный.ПроверитьУтверждениеДокумента(ЭтотОбъект, Отказ);
		
		Если Не ЗначениеЗаполнено(ВидРасчета) 
			И Не ПолучитьФункциональнуюОпцию("ВыбиратьВидНачисленияОтпускБезОплаты") Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			Документы.ОтпускБезСохраненияОплаты.ТекстСообщенияНеЗаполненВидРасчета(ВидОтпуска, ОтсутствиеВТечениеЧастиСмены),
			Ссылка,
			,
			,
			Отказ);
		КонецЕсли;
		
		Если ПерерасчетВыполнен Тогда 
			
			// Проверка корректности распределения по источникам финансирования
			ИменаТаблицРаспределяемыхПоСтатьямФинансирования = "Начисления,НачисленияПерерасчет";
			
			ОтражениеЗарплатыВБухучетеРасширенный.ПроверитьРезультатыРаспределенияНачисленийУдержанийОбъекта(
				ЭтотОбъект, ИменаТаблицРаспределяемыхПоСтатьямФинансирования, Отказ);
			
			// Проверка корректности распределения по территориям и условиям труда
			ИменаТаблицРаспределенияПоТерриториямУсловиямТруда = "Начисления,НачисленияПерерасчет";
			
			РасчетЗарплатыРасширенный.ПроверитьРаспределениеПоТерриториямУсловиямТрудаДокумента(
				ЭтотОбъект, ИменаТаблицРаспределенияПоТерриториямУсловиямТруда, Отказ);
			
			ПроверитьПериодДействияНачислений(Отказ);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ПредставлениеПериода = ЗарплатаКадрыРасширенный.ПредставлениеПериодаРасчетногоДокумента(ДатаНачала, ДатаОкончания);
	
	ЗарплатаКадрыРасширенный.ПередЗаписьюМногофункциональногоДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ЗарплатаКадрыРасширенный.ПриКопированииМногофункциональногоДокумента(ЭтотОбъект);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьПоДаннымЗаполнения(ДанныеЗаполнения)
	
	Если ЭтоНовый() Тогда
		
		Организация = ДанныеЗаполнения.Организация;
		Сотрудник = ДанныеЗаполнения.Сотрудник;
		
		ДанныеЗаполнения.Свойство("Ссылка", ДокументЗаполнения);
		ДанныеЗаполнения.Свойство("ОтсутствиеВТечениеЧастиСмены", ОтсутствиеВТечениеЧастиСмены);
		ДанныеЗаполнения.Свойство("ДатаОтсутствия", ДатаОтсутствия);
		ДанныеЗаполнения.Свойство("ЧасовОтпуска", ЧасовОтпуска);
		ДанныеЗаполнения.Свойство("Руководитель", Руководитель);
		ДанныеЗаполнения.Свойство("ДолжностьРуководителя", ДолжностьРуководителя);
		
	КонецЕсли;
	
	Если ДанныеЗаполнения.Свойство("ДанныеОтпусков") Тогда
		ДанныеОтпуска = ДанныеЗаполнения.ДанныеОтпусков[0];
	Иначе
		ДанныеОтпуска = ДанныеЗаполнения;
	КонецЕсли;
	
	ДатаНачала = ДанныеОтпуска.ДатаНачала;
	ДатаОкончания = ДанныеОтпуска.ДатаОкончания;
	
	ДанныеОтпуска.Свойство("ВидОтпуска", ВидОтпуска);
	ДанныеОтпуска.Свойство("Основание", Основание);
	
	ПланыВидовРасчета.Начисления.УстановитьНачислениеПоУмолчаниюВОбъекте(ЭтотОбъект, "ВидРасчета");
	
	Если ЭтоНовый() Тогда
		
		Если ЗначениеЗаполнено(ДатаНачала) И ДатаНачала < ТекущаяДатаСеанса() Тогда
			Дата = ДатаНачала;
		Иначе
			Дата = ТекущаяДатаСеанса();
		КонецЕсли;
		
		ПериодРегистрации = НачалоМесяца(Дата);
		
		ЗапрашиваемыеЗначения = Новый Структура;
		ЗапрашиваемыеЗначения.Вставить("Ответственный", "Ответственный");
		
		ФиксированныеЗначения = Новый Массив;
		
		Если ЗначениеЗаполнено(Организация) Тогда
			
			ЗапрашиваемыеЗначения.Вставить("Организация", "Организация");
			
			Если НЕ ЗначениеЗаполнено(Руководитель) Тогда
				ЗапрашиваемыеЗначения.Вставить("Руководитель", "Руководитель");
			КонецЕсли;
			
			Если НЕ ЗначениеЗаполнено(ДолжностьРуководителя) Тогда
				ЗапрашиваемыеЗначения.Вставить("ДолжностьРуководителя", "ДолжностьРуководителя");
			КонецЕсли;
			
			ФиксированныеЗначения.Добавить("Организация");
			
		КонецЕсли;
		
		ЗарплатаКадры.ЗаполнитьЗначенияВФорме(ЭтотОбъект, ЗапрашиваемыеЗначения, ФиксированныеЗначения);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура РассчитатьПослеЗаполнения()
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьРасчетЗарплатыРасширенная") Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерРасчета = РасчетЗарплатыРасширенный.СоздатьМенеджерРасчета(ПериодРегистрации, Организация);
	
	МенеджерДокумента = Документы.ОтпускБезСохраненияОплаты;
	МенеджерДокумента.ЗаполнитьНастройкиМенеджераРасчета(МенеджерРасчета, Ссылка, ИсправленныйДокумент);
	
	ТаблицаНачислений = МенеджерРасчета.ТаблицаИсходныеДанныеНачисленияЗарплатыПоНачислениям();
	НоваяСтрока = ТаблицаНачислений.Добавить();
	НоваяСтрока.Сотрудник = Сотрудник;
	НоваяСтрока.Начисление = ВидРасчета;
	НоваяСтрока.ДатаНачала = ДатаНачала;
	НоваяСтрока.ДатаОкончания = ДатаОкончания;
	
	МенеджерРасчета.ЗаполнитьНачисленияСотрудникаЗаПериод(Сотрудник, ТаблицаНачислений);
	МенеджерРасчета.РассчитатьЗарплату();
	
	МенеджерДокумента.РасчетЗарплатыВДанные(ЭтотОбъект, МенеджерРасчета.Зарплата);
	
КонецПроцедуры

Процедура ПроверитьПериодДействияНачислений(Отказ)
	ПараметрыПроверкиПериодаДействия = РасчетЗарплатыРасширенный.ПараметрыПроверкиПериодаДействия();
	ПараметрыПроверкиПериодаДействия.Ссылка = ЭтотОбъект.Ссылка;
	ПроверяемыеКоллекции = Новый Массив;
	ПроверяемыеКоллекции.Добавить(РасчетЗарплатыРасширенный.ОписаниеКоллекцииДляПроверкиПериодаДействия("НачисленияПерерасчет", НСтр("ru='Перерасчет прошлого периода'")));
	РасчетЗарплатыРасширенный.ПроверитьПериодДействияВКоллекцияхНачислений(ЭтотОбъект, ПараметрыПроверкиПериодаДействия, ПроверяемыеКоллекции, Отказ);
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ЦепочкиДокументов") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ЦепочкиДокументов");
		Модуль.УстановитьВторичныеРеквизитыДокументаЗамещения(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
