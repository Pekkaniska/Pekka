#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ТрудовойДоговорМикропредприятий");
	НастройкиВарианта.Описание = НСтр("ru = 'Трудовой договор микропредприятий'");
	НастройкиВарианта.Включен = Ложь;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если ТипЗнч(МассивОбъектов[0]) = Тип("СправочникСсылка.Сотрудники") Тогда
		
		ПечатаемыеСсылки = Новый Массив;
		КадровыеДанные = КадровыйУчет.КадровыеДанныеСотрудников(Истина, МассивОбъектов, "ПриказОПриеме");
		Для Каждого Сотрудник Из МассивОбъектов Цикл
			
			СтрокаДанных = КадровыеДанные.Найти(Сотрудник, "Сотрудник");
			Если СтрокаДанных <> Неопределено И ЗначениеЗаполнено(СтрокаДанных.ПриказОПриеме) Тогда
				ПечатаемыеСсылки.Добавить(СтрокаДанных.ПриказОПриеме);
			Иначе
				ПечатаемыеСсылки.Добавить(Сотрудник);
			КонецЕсли;
			
		КонецЦикла;
		
		СписокОтборов = Новый Массив;
		
		ЗарплатаКадрыОбщиеНаборыДанных.ДобавитьВКоллекциюОтбор(
			СписокОтборов, "СсылкаНаСотрудника", ВидСравненияКомпоновкиДанных.ВСписке, ОбщегоНазначенияКлиентСервер.СкопироватьМассив(МассивОбъектов));
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("Отбор", СписокОтборов);
		
	Иначе
		
		ПечатаемыеСсылки = МассивОбъектов;
		ДополнительныеПараметры = Неопределено;
		
	КонецЕсли;
	
	ЗарплатаКадрыОтчетыРасширенный.ВывестиВКоллекциюПечатнуюФорму("Отчет.ПечатнаяФормаТрудовойДоговорМикропредприятий",
		ПечатаемыеСсылки, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода, ВнешниеНаборыДанных(), ДополнительныеПараметры);
	
КонецПроцедуры

Процедура Сформировать(ДокументРезультат, РезультатКомпоновки, ОбъектыПечати = Неопределено) Экспорт
	
	ДокументРезультат.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ДокументРезультат.АвтоМасштаб = Истина;
	ДокументРезультат.КлючПараметровПечати = "ПараметрыПечати_ТрудовойДоговорМикропредприятий";
	
	Для Каждого ДанныеСсылок Из РезультатКомпоновки.ДанныеОтчета.Строки Цикл
		
		ПерваяСтрокаПечатнойФормы = ДокументРезультат.ВысотаТаблицы + 1;
		
		Для Каждого ДанныеДетальныхЗаписей Из ДанныеСсылок.Строки Цикл
			
			Если ДокументРезультат.ВысотаТаблицы > 0 Тогда
				ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
			КонецЕсли;
			
			Если ДанныеДетальныхЗаписей.Строки.Количество() > 0 Тогда
				ДанныеЗаписей = ДанныеДетальныхЗаписей.Строки[0];
			КонецЕсли;
			
			ДанныеПользовательскихПолей = ЗарплатаКадрыОтчеты.ЗначенияЗаполненияПользовательскихПолей(РезультатКомпоновки.ИдентификаторыМакета, ДанныеЗаписей);
			
			ПараметрыНумерации = Новый Структура;
			УстановитьНомерРазделаВПараметрахНумерации(ПараметрыНумерации, 1);
			УстановитьНомерПунктаВПараметрахНумерации(ПараметрыНумерации, 1);
			
			ДанныеПараметров = Новый Структура;
			ДанныеПараметров.Вставить("ПараметрыНумерации", ПараметрыНумерации);
			ДанныеПараметров.Вставить("ДанныеСсылок", ДанныеЗаписей);
			ДанныеПараметров.Вставить("ДанныеДетальныхЗаписей", ДанныеДетальныхЗаписей);
			ДанныеПараметров.Вставить("ДанныеПользовательскихПолей", ДанныеПользовательскихПолей);
			
			ТрудовойДоговорВывестиРаздел("Шапка", ДокументРезультат, РезультатКомпоновки.МакетПечатнойФормы, ДанныеПараметров);
			ТрудовойДоговорВывестиРаздел("Раздел_ОбщиеПоложения", ДокументРезультат, РезультатКомпоновки.МакетПечатнойФормы, ДанныеПараметров);
			ТрудовойДоговорВывестиРаздел("Раздел_ПраваИОбязанностиРаботника", ДокументРезультат, РезультатКомпоновки.МакетПечатнойФормы, ДанныеПараметров);
			ТрудовойДоговорВывестиРаздел("Раздел_ПраваИОбязанностиРаботодателя", ДокументРезультат, РезультатКомпоновки.МакетПечатнойФормы, ДанныеПараметров);
			ТрудовойДоговорВывестиРаздел("Раздел_ОплатаТрудаРаботника", ДокументРезультат, РезультатКомпоновки.МакетПечатнойФормы, ДанныеПараметров);
			ТрудовойДоговорВывестиРаздел("Раздел_РабочееВремяИВремяОтдыхаРаботника", ДокументРезультат, РезультатКомпоновки.МакетПечатнойФормы, ДанныеПараметров);
			ТрудовойДоговорВывестиРаздел("Раздел_ОхранаТруда", ДокументРезультат, РезультатКомпоновки.МакетПечатнойФормы, ДанныеПараметров);
			ТрудовойДоговорВывестиРаздел("Раздел_СоциальноеСтрахованиеИИныеГарантии", ДокументРезультат, РезультатКомпоновки.МакетПечатнойФормы, ДанныеПараметров);
			ТрудовойДоговорВывестиРаздел("Раздел_ИныеУсловияТрудовогоДоговора", ДокументРезультат, РезультатКомпоновки.МакетПечатнойФормы, ДанныеПараметров);
			ТрудовойДоговорВывестиРаздел("Раздел_ИзменениеУсловийТрудовогоДоговора", ДокументРезультат, РезультатКомпоновки.МакетПечатнойФормы, ДанныеПараметров);
			ТрудовойДоговорВывестиРаздел("Раздел_ОтветственностьСторонТрудовогоДоговора", ДокументРезультат, РезультатКомпоновки.МакетПечатнойФормы, ДанныеПараметров);
			ТрудовойДоговорВывестиРаздел("Раздел_ЗаключительныеПоложения", ДокументРезультат, РезультатКомпоновки.МакетПечатнойФормы, ДанныеПараметров);
			ТрудовойДоговорВывестиРаздел("Подвал", ДокументРезультат, РезультатКомпоновки.МакетПечатнойФормы, ДанныеПараметров);
			
		КонецЦикла;
		
		Если ОбъектыПечати <> Неопределено Тогда
			УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ДокументРезультат, ПерваяСтрокаПечатнойФормы, ОбъектыПечати, ДанныеСсылок.СсылкаНаОбъект);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ТрудовойДоговорВывестиРаздел(ИмяОбласти, ДокументРезультат, Макет, ДанныеПараметров)
	
	ОбластьНачалаРаздела = Новый ТабличныйДокумент;
	НомерОбласти = 1;
	
	ОбластьРаздела = Макет.ПолучитьОбласть(ИмяОбласти);
	Для каждого ВложеннаяОбласть Из ОбластьРаздела.Области Цикл
		
		Если ОбластьРаздела.Области.Количество() > 1 И ВложеннаяОбласть.Имя = ИмяОбласти Тогда
			Продолжить;
		КонецЕсли;
		
		ВыводимаяОбласть = ОбластьРаздела.ПолучитьОбласть(ВложеннаяОбласть.Имя);
		
		ЗарплатаКадрыОтчеты.ЗаполнитьПараметрыОбластиМакета(ВыводимаяОбласть,
			ДанныеПараметров.ПараметрыНумерации, ДанныеПараметров.ДанныеСсылок, ДанныеПараметров.ДанныеПользовательскихПолей);
		
		Если ВложеннаяОбласть.Имя = "Пункт_14_а" Тогда
			
			СтрокаТарифнойСтавки = Неопределено;
			СтрокаСдельнойОплатыТруда = Неопределено;
			
			Если ПолучитьФункциональнуюОпцию("ИспользоватьРасчетЗарплатыРасширенная")
				И ПравоДоступа("Просмотр", Метаданные.РегистрыСведений.ПлановыеНачисления) Тогда
				
				КатегорииСдельнойОплатыТруда = РасчетЗарплаты.КатегорииСдельнойОплатыТруда();
				Для Каждого СтрокаНачислений Из ДанныеПараметров.ДанныеДетальныхЗаписей.Строки Цикл
					
					Если СтрокаНачислений.РаботаОплатаТрудаНачислениеТарифнойСтавки = Истина Тогда
						СтрокаТарифнойСтавки = СтрокаНачислений;
					КонецЕсли;
					
					Если КатегорииСдельнойОплатыТруда.Найти(СтрокаНачислений.РаботаОплатаТрудаНачислениеКатегорияНачисленияИлиНеоплаченногоВремени) <> Неопределено Тогда
						СтрокаСдельнойОплатыТруда = СтрокаНачислений;
					КонецЕсли;
					
					Если СтрокаТарифнойСтавки <> Неопределено
						И СтрокаСдельнойОплатыТруда <> Неопределено Тогда
						
						Прервать;
						
					КонецЕсли;
					
				КонецЦикла;
				
			КонецЕсли;
			
			Если СтрокаТарифнойСтавки <> Неопределено
				Или СтрокаСдельнойОплатыТруда <> Неопределено Тогда
				
				ДанныеОплатыТруда = Новый Структура("ТарифнаяСтавка,СдельнаяОплатаТруда");
				Если СтрокаСдельнойОплатыТруда <> Неопределено Тогда
					ДанныеОплатыТруда.СдельнаяОплатаТруда = Строка(СтрокаСдельнойОплатыТруда.РаботаОплатаТрудаНачисление) + " " + Формат(СтрокаСдельнойОплатыТруда.РаботаОплатаТрудаРазмер, "ЧДЦ=2")
				Иначе
					ДанныеОплатыТруда.ТарифнаяСтавка = ПредставлениеТарифнойСтавкиДоговоровМикропредприятий(СтрокаТарифнойСтавки);
				КонецЕсли;
				
				ВыводимаяОбласть.Параметры.Заполнить(ДанныеОплатыТруда);
				
			КонецЕсли;
			
		ИначеЕсли ВложеннаяОбласть.Имя = "Пункт_14_б_Начисление"
			Или ВложеннаяОбласть.Имя = "Пункт_14_в_Начисление" Тогда
			
			КоллекцияСтрок = Новый Массив;
			Если ПолучитьФункциональнуюОпцию("ИспользоватьРасчетЗарплатыРасширенная")
				И ПравоДоступа("Просмотр", Метаданные.РегистрыСведений.ПлановыеНачисления) Тогда
				
				Если ВложеннаяОбласть.Имя = "Пункт_14_б_Начисление" Тогда
					
					КатегорииСдельнойОплатыТруда = РасчетЗарплаты.КатегорииСдельнойОплатыТруда();
					КатегорииКомпенсаций = РасчетЗарплаты.КатегорииНачисленийКомпенсационныхВыплат();
					
					Для Каждого СтрокаНачислений Из ДанныеПараметров.ДанныеДетальныхЗаписей.Строки Цикл
						
						Если СтрокаНачислений.РаботаОплатаТрудаНачислениеТарифнойСтавки = Истина Тогда
							Продолжить;
						КонецЕсли;
						
						Если КатегорииСдельнойОплатыТруда.Найти(СтрокаНачислений.РаботаОплатаТрудаНачислениеКатегорияНачисленияИлиНеоплаченногоВремени) <> Неопределено Тогда
							Продолжить;
						КонецЕсли;
						
						Если КатегорииКомпенсаций.Найти(СтрокаНачислений.РаботаОплатаТрудаНачислениеКатегорияНачисленияИлиНеоплаченногоВремени) <> Неопределено Тогда
							КоллекцияСтрок.Добавить(СтрокаНачислений);
						КонецЕсли;
						
					КонецЦикла;
					
				ИначеЕсли ВложеннаяОбласть.Имя = "Пункт_14_в_Начисление" Тогда
					
					КатегорииСдельнойОплатыТруда = РасчетЗарплаты.КатегорииСдельнойОплатыТруда();
					КатегорииКомпенсаций = РасчетЗарплаты.КатегорииНачисленийКомпенсационныхВыплат();
					
					Для Каждого СтрокаНачислений Из ДанныеПараметров.ДанныеДетальныхЗаписей.Строки Цикл
						
						Если СтрокаНачислений.РаботаОплатаТрудаНачислениеТарифнойСтавки = Истина Тогда
							Продолжить;
						КонецЕсли;
						
						Если КатегорииСдельнойОплатыТруда.Найти(СтрокаНачислений.РаботаОплатаТрудаНачислениеКатегорияНачисленияИлиНеоплаченногоВремени) <> Неопределено Тогда
							Продолжить;
						КонецЕсли;
						
						Если КатегорииКомпенсаций.Найти(СтрокаНачислений.РаботаОплатаТрудаНачислениеКатегорияНачисленияИлиНеоплаченногоВремени) <> Неопределено Тогда
							Продолжить;
						КонецЕсли;
						
						КоллекцияСтрок.Добавить(СтрокаНачислений);
						
					КонецЦикла;
					
				КонецЕсли;
				
			КонецЕсли;
			
			Если КоллекцияСтрок.Количество() = 0 Тогда
				
				ВыводимаяОбласть.Параметры.РаботаОплатаТрудаНачисление =
					Символы.ПС
					+ Символы.ПС
					+ Символы.ПС
					+ Символы.ПС;
				
				ВыводимаяОбласть.Параметры.РаботаОплатаТрудаРазмер = 0;
				
			Иначе
				
				ОбластьТаблицы = Новый ТабличныйДокумент;
				Для каждого СтрокаКоллекции Из КоллекцияСтрок Цикл
					
					ЗарплатаКадрыОтчеты.ЗаполнитьПараметрыОбластиМакета(ВыводимаяОбласть,
						ДанныеПараметров.ПараметрыНумерации,
						ДанныеПараметров.ДанныеСсылок,
						ДанныеПараметров.ДанныеПользовательскихПолей,
						СтрокаКоллекции);
					
					ОбластьТаблицы.Вывести(ВыводимаяОбласть);
					
				КонецЦикла;
				
				ВыводимаяОбласть = ОбластьТаблицы;
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если НомерОбласти > 2 Тогда
			ДокументРезультат.Вывести(ВыводимаяОбласть);
		Иначе
			
			ОбластьНачалаРаздела.Вывести(ВыводимаяОбласть);
			Если НомерОбласти = 2 Тогда
				
				Если Не ДокументРезультат.ПроверитьВывод(ОбластьНачалаРаздела) Тогда
					ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
				КонецЕсли;
				
				ДокументРезультат.Вывести(ОбластьНачалаРаздела);
				ОбластьНачалаРаздела = Неопределено;
				
			КонецЕсли;
			
		КонецЕсли;
		
		НомерОбласти = НомерОбласти + 1;
		
		Если СтрДлина(ВложеннаяОбласть.Имя) = 8 И СтрНайти(ВложеннаяОбласть.Имя, "Пункт_") = 1 Тогда
			ДанныеПараметров.ПараметрыНумерации.НомерПункта = ДанныеПараметров.ПараметрыНумерации.НомерПункта + 1;
			УстановитьНомерПодпунктаВПараметрахНумерации(ДанныеПараметров.ПараметрыНумерации, 1);
		ИначеЕсли СтрЧислоВхождений(ВложеннаяОбласть.Имя, "_") = 2 Тогда
			УстановитьНомерПодпунктаВПараметрахНумерации(ДанныеПараметров.ПараметрыНумерации, ДанныеПараметров.ПараметрыНумерации.НомерПодпункта + 1);
		КонецЕсли;
		
	КонецЦикла;
	
	Если ОбластьНачалаРаздела <> Неопределено Тогда
		
		Если Не ДокументРезультат.ПроверитьВывод(ОбластьНачалаРаздела) Тогда
			ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ДокументРезультат.Вывести(ОбластьНачалаРаздела);
		
	КонецЕсли;
	
	Если СтрНайти(ИмяОбласти, "Раздел_") = 1 Тогда
		УстановитьНомерРазделаВПараметрахНумерации(ДанныеПараметров.ПараметрыНумерации, ДанныеПараметров.ПараметрыНумерации.НомерРаздела + 1);
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьНомерРазделаВПараметрахНумерации(ПараметрыНумерации, Знач НомерРаздела)
	
	ПараметрыНумерации.Вставить("НомерРаздела", НомерРаздела);
	ПараметрыНумерации.Вставить("НомерРазделаВРимскойНотации",
		СтроковыеФункцииКлиентСервер.ПреобразоватьЧислоВРимскуюНотацию(НомерРаздела, Ложь));
	
КонецПроцедуры

Процедура УстановитьНомерПунктаВПараметрахНумерации(ПараметрыНумерации, Знач НомерПункта)
	
	ПараметрыНумерации.Вставить("НомерПункта", НомерПункта);
	
КонецПроцедуры

Процедура УстановитьНомерПодпунктаВПараметрахНумерации(ПараметрыНумерации, Знач НомерПодпункта)
	
	ПараметрыНумерации.Вставить("НомерПодпункта", НомерПодпункта);
	ПараметрыНумерации.Вставить("НомерПодпунктаБуквой", Сред("абвгдежзиклмнопрстуфхцчшщ", НомерПодпункта, 1));
	
КонецПроцедуры

Функция ПредставлениеТарифнойСтавкиДоговоровМикропредприятий(СтрокаНачисления)
	
	ПредставлениеТарифнойСтавки = "";
	
	Если ЗначениеЗаполнено(СтрокаНачисления.РаботаОплатаТрудаЗначениеОсновногоПоказателя) Тогда
		
		Если ЗначениеЗаполнено(СтрокаНачисления.РаботаОплатаТрудаОсновнойПоказатель) Тогда
			
			ПредставлениеТарифнойСтавки = Строка(СтрокаНачисления.РаботаОплатаТрудаОсновнойПоказатель);
			
			Точность = СтрокаНачисления.РаботаОплатаТрудаОсновнойПоказательТочность;
			Денежный = (СтрокаНачисления.РаботаОплатаТрудаОсновнойПоказательТипПоказателя = Перечисления.ТипыПоказателейРасчетаЗарплаты.Денежный);
			ВидТарифнойСтавки = СтрокаНачисления.РаботаОплатаТрудаОсновнойПоказательВидТарифнойСтавки;
			
		Иначе
			
			ПредставлениеТарифнойСтавки = Строка(СтрокаНачисления.РаботаОплатаТрудаНачисление);
			
			Точность = 2;
			Денежный = Истина;
			ВидТарифнойСтавки = Перечисления.ВидыТарифныхСтавок.МесячнаяТарифнаяСтавка;
			
		КонецЕсли;
		
		ПредставлениеТарифнойСтавки =
			ПредставлениеТарифнойСтавки + ": " + Формат(СтрокаНачисления.РаботаОплатаТрудаЗначениеОсновногоПоказателя, "ЧДЦ=" + Точность + "; ЧГ=");
		
		Если Денежный Тогда
			
			ПредставлениеТарифнойСтавки = ПредставлениеТарифнойСтавки + " " + НСтр("ru='руб.'");
			
			Если ВидТарифнойСтавки = Перечисления.ВидыТарифныхСтавок.ЧасоваяТарифнаяСтавка Тогда
				ПредставлениеТарифнойСтавки = ПредставлениеТарифнойСтавки + " " + НСтр("ru='за час'");
			ИначеЕсли ВидТарифнойСтавки = Перечисления.ВидыТарифныхСтавок.ДневнаяТарифнаяСтавка Тогда
				ПредставлениеТарифнойСтавки = ПредставлениеТарифнойСтавки + " " + НСтр("ru='за день'");
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		ПредставлениеТарифнойСтавки = Строка(СтрокаНачисления.РаботаОплатаТрудаНачисление);
		Если ЗначениеЗаполнено(СтрокаНачисления.РаботаОплатаТрудаРазмер) Тогда
			ПредставлениеТарифнойСтавки = ПредставлениеТарифнойСтавки + " " + Формат(СтрокаНачисления.РаботаОплатаТрудаРазмер, "ЧДЦ=2");
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ПредставлениеТарифнойСтавки;
	
КонецФункции

Функция ВнешниеНаборыДанных() Экспорт
	
	ВнешниеНаборы = Новый Структура;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ВнешниеНаборы.Вставить("ДанныеОрганизаций", ДанныеОрганизаций());
	ВнешниеНаборы.Вставить("ДанныеГрафиков", ДанныеГрафиков());
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ВнешниеНаборы;
	
КонецФункции

Функция ДанныеОрганизаций()
	
	ТаблицаДанныхОрганизаций = Новый ТаблицаЗначений;
	
	ТаблицаДанныхОрганизаций.Колонки.Добавить("Организация", Новый ОписаниеТипов("СправочникСсылка.Организации"));
	ТаблицаДанныхОрганизаций.Колонки.Добавить("КПП", Новый ОписаниеТипов("Строка"));
	ТаблицаДанныхОрганизаций.Колонки.Добавить("Телефон", Новый ОписаниеТипов("Строка"));
	ТаблицаДанныхОрганизаций.Колонки.Добавить("Факс", Новый ОписаниеТипов("Строка"));
	ТаблицаДанныхОрганизаций.Колонки.Добавить("ЮрАдрес", Новый ОписаниеТипов("Строка"));
	ТаблицаДанныхОрганизаций.Колонки.Добавить("ФактАдрес", Новый ОписаниеТипов("Строка"));
	ТаблицаДанныхОрганизаций.Колонки.Добавить("ГородФактическогоАдреса", Новый ОписаниеТипов("Строка"));
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Организации.Ссылка КАК Организация
		|ИЗ
		|	Справочник.Организации КАК Организации";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	АдресаОрганизаций = УправлениеКонтактнойИнформациейЗарплатаКадры.АдресаОрганизаций(РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Организация"));
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрокаСведенияОбОрганизациях = ТаблицаДанныхОрганизаций.Добавить();
		НоваяСтрокаСведенияОбОрганизациях.Организация = Выборка.Организация;
		
		Сведения = Новый СписокЗначений;
		Сведения.Добавить("", "КППЮЛ");
		Сведения.Добавить("", "ТелОрганизации");
		Сведения.Добавить("", "ФаксОрганизации");
		
		ОргСведения = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Выборка.Организация, ТекущаяДатаСеанса(), Сведения);
		
		Если ОргСведения.Свойство("КППЮЛ") Тогда
			НоваяСтрокаСведенияОбОрганизациях.КПП = ОргСведения.КППЮЛ;
		КонецЕсли;
		
		Если ОргСведения.Свойство("ТелОрганизации") Тогда
			НоваяСтрокаСведенияОбОрганизациях.Телефон = ОргСведения.ТелОрганизации;
		КонецЕсли;
		
		Если ОргСведения.Свойство("ФаксОрганизации") Тогда
			НоваяСтрокаСведенияОбОрганизациях.Факс = ОргСведения.ФаксОрганизации;
		КонецЕсли;
		
		ОписаниеЮридическогоАдреса = УправлениеКонтактнойИнформациейЗарплатаКадры.АдресОрганизации(
			АдресаОрганизаций,
			Выборка.Организация,
			Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации);
		
		НоваяСтрокаСведенияОбОрганизациях.ЮрАдрес = ОписаниеЮридическогоАдреса.Представление;
		
		ОписаниеФактическогоАдреса = УправлениеКонтактнойИнформациейЗарплатаКадры.АдресОрганизации(
			АдресаОрганизаций,
			Выборка.Организация,
			Справочники.ВидыКонтактнойИнформации.ФактАдресОрганизации);
			
		НоваяСтрокаСведенияОбОрганизациях.ФактАдрес = ОписаниеФактическогоАдреса.Представление;
		
		НоваяСтрокаСведенияОбОрганизациях.ГородФактическогоАдреса = ОписаниеФактическогоАдреса.Город;
		
	КонецЦикла;
	
	Возврат ТаблицаДанныхОрганизаций;
	
КонецФункции

Функция ДанныеГрафиков()
	
	Запрос = Новый Запрос;
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ГрафикиРаботыСотрудниковДанныеОРабочихЧасах.Ссылка КАК Ссылка,
		|	СУММА(ГрафикиРаботыСотрудниковДанныеОРабочихЧасах.Часов) КАК Часов
		|ПОМЕСТИТЬ ВТДанныеОРабочихЧасах
		|ИЗ
		|	Справочник.ГрафикиРаботыСотрудников.ДанныеОРабочихЧасах КАК ГрафикиРаботыСотрудниковДанныеОРабочихЧасах
		|ГДЕ
		|	ГрафикиРаботыСотрудниковДанныеОРабочихЧасах.ВидВремени.РабочееВремя
		|
		|СГРУППИРОВАТЬ ПО
		|	ГрафикиРаботыСотрудниковДанныеОРабочихЧасах.Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ГрафикиРаботыСотрудников.Ссылка КАК ГрафикРаботы,
		|	ГрафикиРаботыСотрудников.Ссылка.ДлительностьРабочейНедели КАК ДлительностьРабочейНедели,
		|	ГрафикиРаботыСотрудников.Ссылка.СокращеннаяРабочаяНеделя КАК СокращеннаяРабочаяНеделя,
		|	ГрафикиРаботыСотрудников.Ссылка.НеполноеРабочееВремя КАК НеполноеРабочееВремя,
		|	СУММА(ВЫБОР
		|			КОГДА ГрафикиРаботыСотрудников.ДеньВключенВГрафик
		|				ТОГДА 1
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК ОписаниеДлительностиРабочейНеделиВДнях,
		|	МАКСИМУМ(ДанныеОРабочихЧасах.Часов) КАК ПродолжительностьРабочегоДня
		|ИЗ
		|	Справочник.ГрафикиРаботыСотрудников.ШаблонЗаполнения КАК ГрафикиРаботыСотрудников
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТДанныеОРабочихЧасах КАК ДанныеОРабочихЧасах
		|		ПО ГрафикиРаботыСотрудников.Ссылка = ДанныеОРабочихЧасах.Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	ГрафикиРаботыСотрудников.Ссылка,
		|	ГрафикиРаботыСотрудников.Ссылка.ДлительностьРабочейНедели,
		|	ГрафикиРаботыСотрудников.Ссылка.СокращеннаяРабочаяНеделя,
		|	ГрафикиРаботыСотрудников.Ссылка.НеполноеРабочееВремя";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

#КонецОбласти

#КонецЕсли