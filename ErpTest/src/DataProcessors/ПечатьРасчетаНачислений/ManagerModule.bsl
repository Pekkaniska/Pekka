#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда	

#Область СлужебныеПроцедурыИФункции

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если МассивОбъектов.Количество() < 1 Тогда
		Возврат;
	КонецЕсли;
	
	// Устанавливаем признак доступности печати покомплектно.
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	// Проверяем, нужно ли для макета ПодробныйРасчетНачислений формировать табличный документ.
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПодробныйРасчетНачислений") Тогда
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		ТабличныйДокумент = ТабличныйДокументПодробногоРасчетаНачислений(МассивОбъектов, ОбъектыПечати, "ПодробныйРасчетНачислений");
		Если НЕ ТабличныйДокумент = Неопределено Тогда
			УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ПодробныйРасчетНачислений", НСтр("ru = 'Подробный расчет начислений'"), ТабличныйДокумент);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПодробныйРасчетНачислений

// Функция возвращает табличный документ - печатную форму расчета среднего заработка.
Функция ТабличныйДокументПодробногоРасчетаНачислений(МассивСсылок, ОбъектыПечати, ИмяМакета)	
	
	// Разделим массив ссылок по типам: создадим соответствие менеджеров объектов и ссылок относящихся к ним.
	// Также в соответствие поместим описание документа рассчитывающего средний заработок.
	МенеджерыДанныхПодробногоРасчетаНачислений = МенеджерыДанныхПодробногоРасчетаНачислений(МассивСсылок, ИмяМакета);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПодробныйРасчетНачислений";
	
	ПолныйМассивСотрудников = Новый Массив;
	
	МассивОписанийМенеджеров = Новый Массив;
	
	Для каждого ОписаниеМенеджера Из МенеджерыДанныхПодробногоРасчетаНачислений Цикл
		// Получим данные для всех документов относящихся к текущему менеджеру.
		ДанныеДокументов = ДанныеДокументовДляПодробногоРасчетаНачислений(ОписаниеМенеджера.Значение.Менеджер, ОписаниеМенеджера.Значение.МассивСсылок);
		ОписаниеМенеджера.Значение.Вставить("ДанныеДокументов", ДанныеДокументов);
				
		// Для получения кадровых данных одним запросом по всем сотрудникам - соберем их в отдельный массив.
		Для каждого ДанныеДокумента Из ДанныеДокументов Цикл
			ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ПолныйМассивСотрудников, ДанныеДокумента.МассивСотрудников);
		КонецЦикла;
		
		МассивОписанийМенеджеров.Добавить(ОписаниеМенеджера.Значение);
	КонецЦикла;

	КадровыеДанныеСотрудников = КадровыйУчет.КадровыеДанныеСотрудников(Истина, ПолныйМассивСотрудников, "ФизическоеЛицо,ФИОПолные,ТабельныйНомер,Подразделение,Должность,ВидЗанятости", '00010101000000');
	
	ПервыйДокумент = Истина;
	Для каждого ОписаниеМенеджера Из МассивОписанийМенеджеров Цикл
		
		Если ОписаниеМенеджера.ОписаниеДокумента.ЕстьРасчетСреднегоЗаработка Тогда
			Если ОписаниеМенеджера.ОписаниеДокумента.СреднийЗаработокОбщий Тогда
				ДанныеДокументов = ОписаниеМенеджера.Менеджер.ДанныеДокументовДляПечатиРасчетаСреднегоЗаработка(ОписаниеМенеджера.МассивСсылок);
				ОбластиСреднегоЗаработкаДляВстраивания = Обработки.ПечатьРасчетаСреднегоЗаработка.ОбластиДляВстраивания(ДанныеДокументов, "РасчетСреднегоЗаработкаКомпактный");
			Иначе 
				ДанныеДокументов = ОписаниеМенеджера.Менеджер.ДанныеДокументовДляПечатиРасчетаСреднегоЗаработкаФСС(ОписаниеМенеджера.МассивСсылок);
				ОбластиСреднегоЗаработкаДляВстраивания = Обработки.ПечатьРасчетаСреднегоЗаработкаФСС.ОбластиДляВстраивания(ДанныеДокументов, Ложь, Истина);
			КонецЕсли;
		КонецЕсли;
		
		Если ОписаниеМенеджера.ОписаниеДокумента.ЕстьРасчетСпециализированныхНачислений
			Или ОписаниеМенеджера.ОписаниеДокумента.ЕстьРасчетЗарплаты Тогда	
			НачисленияПоказатели = ОписаниеМенеджера.Менеджер.НачисленияПоказателиДокументов(ОписаниеМенеджера.МассивСсылок);
			ОтборПоСсылке = Новый Структура("Ссылка");
		КонецЕсли;
		
		Для каждого Ссылка Из ОписаниеМенеджера.МассивСсылок Цикл
			
			НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
			
			Если Не ПервыйДокумент Тогда
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			Иначе
				ПервыйДокумент = Ложь;
			КонецЕсли;
			
			СтрокиДанныхДокументов = ОписаниеМенеджера.ДанныеДокументов.НайтиСтроки(Новый Структура("Ссылка", Ссылка));
			Для каждого ДанныеДокумента Из СтрокиДанныхДокументов Цикл
				
				ДанныеДляПечати = Новый Структура;
				ДанныеДляПечати.Вставить("ДанныеДокумента", 	ДанныеДокумента);						
				ДанныеДляПечати.Вставить("ДанныеСотрудников", 	КадровыеДанныеСотрудников);
				ДанныеДляПечати.Вставить("Ссылка", 				Ссылка);
				ДанныеДляПечати.Вставить("СинонимДокумента", 	ОписаниеМенеджера.ОписаниеДокумента.СинонимДокумента);
				ДанныеДляПечати.Вставить("ЕстьРасчетСреднегоЗаработка", 	ОписаниеМенеджера.ОписаниеДокумента.ЕстьРасчетСреднегоЗаработка);
				ДанныеДляПечати.Вставить("ЕстьРасчетСпециализированныхНачислений", 	ОписаниеМенеджера.ОписаниеДокумента.ЕстьРасчетСпециализированныхНачислений);
				ДанныеДляПечати.Вставить("ЕстьРасчетЗарплаты", 	ОписаниеМенеджера.ОписаниеДокумента.ЕстьРасчетЗарплаты);
				
				Если ОписаниеМенеджера.ОписаниеДокумента.ЕстьРасчетСреднегоЗаработка Тогда
					ДанныеДляПечати.Вставить("ОбластиСреднегоЗаработкаДляВстраивания", 	ОбластиСреднегоЗаработкаДляВстраивания);
				КонецЕсли; 
				
				Если ОписаниеМенеджера.ОписаниеДокумента.ЕстьРасчетСпециализированныхНачислений
					Или ОписаниеМенеджера.ОписаниеДокумента.ЕстьРасчетЗарплаты Тогда
					ОтборПоСсылке.Вставить("Ссылка", Ссылка);
					ДанныеДляПечати.Вставить("Начисления", НачисленияПоказатели.Начисления.Скопировать(НачисленияПоказатели.Начисления.НайтиСтроки(ОтборПоСсылке)));
					ДанныеДляПечати.Вставить("Показатели", НачисленияПоказатели.Показатели.Скопировать(НачисленияПоказатели.Показатели.НайтиСтроки(ОтборПоСсылке)));
				КонецЕсли;
				
				Если ОписаниеМенеджера.ОписаниеДокумента.ЕстьРасчетСпециализированныхНачислений Тогда
					ДанныеДляПечати.Вставить("НазваниеСпециализированногоНачисления", 	ОписаниеМенеджера.ОписаниеДокумента.НазваниеСпециализированногоНачисления);
					ДанныеДляПечати.Вставить("КатегорииСпециализированногоНачисления", 	ОписаниеМенеджера.ОписаниеДокумента.КатегорииСпециализированногоНачисления);
				КонецЕсли;
				
				ЗаполнитьТабличныйДокументПодробногоРасчетаНачислений(ДанныеДляПечати, ОбъектыПечати, ИмяМакета, ТабличныйДокумент);			
				
				Если ДанныеДляПечати.ДанныеДокумента.МассивСотрудников.Количество() = 1 Тогда
					УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Ссылка);
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

// Функция возвращает табличный документ - печатную форму расчета среднего заработка, 
// для документов использующих расчет среднего заработка по общим правилам.
Процедура ЗаполнитьТабличныйДокументПодробногоРасчетаНачислений(ДанныеДляПечати, ОбъектыПечати, ИмяМакета, ТабличныйДокумент)
	
	ДанныеДокумента 	= ДанныеДляПечати.ДанныеДокумента;
	ДанныеСотрудников 	= ДанныеДляПечати.ДанныеСотрудников;
	
	ПервыйПриказ = Истина;
	ИспользоватьГруппировкуПоСотрудникам = ДанныеДокумента.МассивСотрудников.Количество() > 1;	
	
	ЗначенияПараметров = Новый Структура;
	ОтборСотрудник = Новый Структура("Сотрудник");
	ОтборПоказателей = Новый Структура("ИдентификаторСтрокиВидаРасчета");
	Для Каждого Сотрудник Из ДанныеДокумента.МассивСотрудников Цикл
		
		ДанныеСотрудника 	= ДанныеСотрудников.Найти(Сотрудник, "Сотрудник"); 
		ОтборСотрудник.Вставить("Сотрудник", Сотрудник);
		
		// Подготовим макеты для формирования табличного документа.
		ОбластиМакета = ОбластиМакетаПодробногоРасчетаНачислений();
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		Если Не ПервыйПриказ Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		Иначе
			ПервыйПриказ = Ложь;
		КонецЕсли;
		
		// Заполним шапку документа
		ЗначенияПараметров.Очистить();
		ЗначенияПараметров.Вставить("СинонимДокумента", 				ДанныеДляПечати.СинонимДокумента);
		ЗначенияПараметров.Вставить("НомерДокумента", 					ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(СокрЛП(ДанныеДокумента.НомерДокумента), Истина, Истина));
		ЗначенияПараметров.Вставить("ДатаДокумента", 					Формат(ДанныеДокумента.ДатаДокумента, "ДЛФ=DD"));
		ЗначенияПараметров.Вставить("Ссылка", 							ДанныеДляПечати.Ссылка);                                                                                                                         
		ЗначенияПараметров.Вставить("НаименованиеОрганизации", 			ДанныеДокумента.НаименованиеОрганизации);
		ЗначенияПараметров.Вставить("Организация", 						ДанныеДокумента.Организация);
		ЗначенияПараметров.Вставить("ФИОРаботника", 					ДанныеСотрудника.ФИОПолные);
		ЗначенияПараметров.Вставить("ТабельныйНомер", 					ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ДанныеСотрудника.ТабельныйНомер, Истина, Истина));
		ЗначенияПараметров.Вставить("Сотрудник", 						Сотрудник);
		
		ЗначенияПараметров.Вставить("ВидЗанятости", 					ДанныеСотрудника.ВидЗанятости);
		ЗначенияПараметров.Вставить("Подразделение", 					ДанныеСотрудника.Подразделение);
		ЗначенияПараметров.Вставить("Должность", 						ДанныеСотрудника.Должность);		
		
		ЗаполнитьЗначенияСвойств(ОбластиМакета.СекцияШапка.Параметры, ЗначенияПараметров);
		ТабличныйДокумент.Вывести(ОбластиМакета.СекцияШапка);
		
		НомерРаздела = 1;
		
		// Выведем секцию расчета среднего заработка.
		
		Если ДанныеДляПечати.ЕстьРасчетСреднегоЗаработка Тогда
			
			ОбластиДляВстраиванияСреднегоЗаработка = ДанныеДляПечати.ОбластиСреднегоЗаработкаДляВстраивания;
			
			ИмяОбластиСреднегоЗаработка = Обработки.ПечатьРасчетаСреднегоЗаработка.ИмяВстраиваемойОбласти(ОбластиДляВстраиванияСреднегоЗаработка.ОбъектыПечати, ДанныеДляПечати.Ссылка, Сотрудник);
			
			Если НЕ ИмяОбластиСреднегоЗаработка = Неопределено Тогда
				
				ВывестиСекциюСреднийЗаработокШапка(ТабличныйДокумент, ОбластиМакета.СекцияСреднийЗаработокШапка, НомерРаздела, ДанныеДокумента);
				
				ОбластьРасчетаСреднего = ОбластиДляВстраиванияСреднегоЗаработка.ТабличныйДокумент.Область(ИмяОбластиСреднегоЗаработка);
				ВысотаОбластиСреднегоЗаработка 	= ОбластьРасчетаСреднего.Низ - ОбластьРасчетаСреднего.Верх;		
				ШиринаОбластиСреднегоЗаработка 	= ОбластиДляВстраиванияСреднегоЗаработка.ТабличныйДокумент.ШиринаТаблицы;					
				НачалоНовогоФорматаСтрок = ТабличныйДокумент.ВысотаТаблицы + 1;
				
				ОбластьПриемник = ТабличныйДокумент.Область(НачалоНовогоФорматаСтрок, , НачалоНовогоФорматаСтрок + ВысотаОбластиСреднегоЗаработка, );		
				ТабличныйДокумент.ВставитьОбласть(ОбластьРасчетаСреднего, ОбластьПриемник);
				ТабличныйДокумент.Область(НачалоНовогоФорматаСтрок, , НачалоНовогоФорматаСтрок + (ОбластьРасчетаСреднего.Низ - ОбластьРасчетаСреднего.Верх), ).Имя = "";
				
				ОбластьПриемник.СоздатьФорматСтрок();
				
				// Назначим ширину колонок у новой области формата строк.
				Для Счетчик = 1 По ШиринаОбластиСреднегоЗаработка Цикл
					НастраиваемаяОбласть = ТабличныйДокумент.Область(НачалоНовогоФорматаСтрок, Счетчик, НачалоНовогоФорматаСтрок + ВысотаОбластиСреднегоЗаработка, Счетчик);
					НастраиваемаяОбласть.ШиринаКолонки = ОбластиДляВстраиванияСреднегоЗаработка.ТабличныйДокумент.Область(ОбластьРасчетаСреднего.Верх, Счетчик).ШиринаКолонки;
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЕсли;
		
		НачисленияПоСотруднику = ДанныеДляПечати.Начисления.НайтиСтроки(ОтборСотрудник);
		
		Если НачисленияПоСотруднику.Количество() > 0 Тогда
			
			НачисленияСекцииПоСотруднику = Новый Массив;
			
			// Выведем секцию специализированных начислений - оплата отпуска, командировки и т.п.
			
			Если ДанныеДляПечати.ЕстьРасчетСпециализированныхНачислений Тогда
				
				НачисленияСекцииПоСотруднику.Очистить();
				
				Для каждого СтрокаНачисления Из НачисленияПоСотруднику Цикл
					Если НЕ ДанныеДляПечати.КатегорииСпециализированногоНачисления.Найти(СтрокаНачисления.Категория) = Неопределено Тогда
						НачисленияСекцииПоСотруднику.Добавить(СтрокаНачисления);
					КонецЕсли;
				КонецЦикла;
				
				Если НачисленияСекцииПоСотруднику.Количество() > 0 Тогда
					НазваниеСекции = ДанныеДляПечати.НазваниеСпециализированногоНачисления;
					ВывестиСекциюНачислений(ТабличныйДокумент, ОбластиМакета, НомерРаздела, НачисленияСекцииПоСотруднику, ДанныеДляПечати.Показатели, НазваниеСекции);
				КонецЕсли;
			КонецЕсли;
			
			// Выведем секцию оплаты труда.
			
			Если ДанныеДляПечати.ЕстьРасчетЗарплаты Тогда
				
				НачисленияСекцииПоСотруднику.Очистить();
				
				Для каждого СтрокаНачисления Из НачисленияПоСотруднику Цикл
					Если ДанныеДляПечати.КатегорииСпециализированногоНачисления.Найти(СтрокаНачисления.Категория) = Неопределено Тогда
						НачисленияСекцииПоСотруднику.Добавить(СтрокаНачисления);
					КонецЕсли;
				КонецЦикла;
				
				Если НачисленияСекцииПоСотруднику.Количество() > 0 Тогда
					НазваниеСекции = НСтр("ru = 'Расчет оплаты труда'");
					ВывестиСекциюНачислений(ТабличныйДокумент, ОбластиМакета, НомерРаздела, НачисленияСекцииПоСотруднику, ДанныеДляПечати.Показатели, НазваниеСекции);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		Если ИспользоватьГруппировкуПоСотрудникам Тогда
			УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Сотрудник);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры 

// Функция возвращает соответствие менеджеров объектов и относящихся к ним ссылок.
// Также в итоговом соответствии заполняются описания документов рассчитывающих средний заработок.
//
Функция МенеджерыДанныхПодробногоРасчетаНачислений(МассивСсылок, ИмяМакета)
	
	МенеджерыДанныхПодробногоРасчетаНачислений = Новый Соответствие;
	
	Для каждого Ссылка Из МассивСсылок Цикл
		
		Менеджер = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Ссылка);
		
		ОписаниеМенеджера = МенеджерыДанныхПодробногоРасчетаНачислений.Получить(Менеджер);
		
		Если ОписаниеМенеджера = Неопределено Тогда
			ОписаниеДокумента = ОписаниеДокументаРасчетаНачислений(Менеджер);
			МенеджерыДанныхПодробногоРасчетаНачислений.Вставить(Менеджер, Новый Структура("Менеджер,ОписаниеДокумента,МассивСсылок", Менеджер, ОписаниеДокумента, Новый Массив));
			ОписаниеМенеджера = МенеджерыДанныхПодробногоРасчетаНачислений.Получить(Менеджер);
		КонецЕсли;
		
		ОписаниеМенеджера.МассивСсылок.Добавить(Ссылка);
		
	КонецЦикла;
	
	Возврат МенеджерыДанныхПодробногоРасчетаНачислений;
	
КонецФункции

// Функция возвращает структуру - описание документа для формирования печатной формы расчета среднего заработка.
// Структура возвращается заполненной по данным менеджера.
//
Функция ОписаниеДокументаРасчетаНачислений(Менеджер)
	ОписаниеДокумента = Новый Структура;
	ОписаниеДокумента.Вставить("Менеджер", 									Менеджер);
	ОписаниеДокумента.Вставить("ИмяДокумента", 								"");
	ОписаниеДокумента.Вставить("СинонимДокумента", 							"");
	ОписаниеДокумента.Вставить("ЕстьРасчетСреднегоЗаработка", 				Ложь);
	ОписаниеДокумента.Вставить("СреднийЗаработокОбщий",		 				Истина);
	ОписаниеДокумента.Вставить("ЕстьРасчетСпециализированныхНачислений", 	Ложь);
	ОписаниеДокумента.Вставить("ЕстьРасчетЗарплаты", 						Ложь);
	ОписаниеДокумента.Вставить("НазваниеСпециализированногоНачисления", 	"");
	ОписаниеДокумента.Вставить("КатегорииСпециализированногоНачисления", 	Новый Массив);

	Менеджер.ЗаполнитьОписаниеДокументаРасчетаНачислений(ОписаниеДокумента);
	
	Возврат ОписаниеДокумента;
КонецФункции

Функция ДанныеДокументовДляПодробногоРасчетаНачислений(Менеджер, МассивСсылок)
	
	ДанныеДокументов = Новый ТаблицаЗначений;
	ДанныеДокументов.Колонки.Добавить("Ссылка");
	ДанныеДокументов.Колонки.Добавить("Организация");
	ДанныеДокументов.Колонки.Добавить("НаименованиеОрганизации");
	ДанныеДокументов.Колонки.Добавить("НомерДокумента");
	ДанныеДокументов.Колонки.Добавить("ДатаДокумента");
	ДанныеДокументов.Колонки.Добавить("МассивСотрудников");
	
	ДанныеДокументов.Колонки.Добавить("РасчетДенежногоСодержания", Новый ОписаниеТипов("Булево"));
	ДанныеДокументов.Колонки.Добавить("СохраняемоеДенежноеСодержание", Новый ОписаниеТипов("Число"));
	
	Менеджер.ЗаполнитьДанныеДокументовДляПодробногоРасчетаНачислений(МассивСсылок, ДанныеДокументов);
	
	РеквизитыОрганизаций = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(ДанныеДокументов.ВыгрузитьКолонку("Организация"), "НаименованиеПолное,Наименование");
	Для каждого ДанныеДокумента Из ДанныеДокументов Цикл
		РеквизитыОрганизации = РеквизитыОрганизаций.Получить(ДанныеДокумента.Организация);
		
		Если ЗначениеЗаполнено(РеквизитыОрганизации.НаименованиеПолное) Тогда              
			ДанныеДокумента.НаименованиеОрганизации = РеквизитыОрганизации.НаименованиеПолное;
		Иначе
			ДанныеДокумента.НаименованиеОрганизации = РеквизитыОрганизации.Наименование;
		КонецЕсли;
	КонецЦикла;	
	
	Возврат ДанныеДокументов;

КонецФункции

Процедура ВывестиСекциюНачислений(ТабличныйДокумент, ОбластиМакета, НомерРаздела, НачисленияСекции, Показатели, НазваниеСекции)
	
	ЗначенияПараметров = Новый Структура;
	
	УстановитьНомерРазделаВОбласти(НомерРаздела, ОбластиМакета.СекцияОплатаДокументаШапка, ЗначенияПараметров);
	ЗначенияПараметров.Очистить();
	ЗначенияПараметров.Вставить("НазваниеСекции", НазваниеСекции);
	
	ЗаполнитьЗначенияСвойств(ОбластиМакета.СекцияОплатаДокументаШапка.Параметры, ЗначенияПараметров);
	
	ТабличныйДокумент.Вывести(ОбластиМакета.СекцияОплатаДокументаШапка);
	
	РезультатВсего = 0;
	
	Для каждого СтрокаНачисления Из НачисленияСекции Цикл
		ЗаполнитьЗначенияСвойств(ОбластиМакета.СекцияОплатаДокументаСтрока.Параметры, СтрокаНачисления);
		ТабличныйДокумент.Вывести(ОбластиМакета.СекцияОплатаДокументаСтрока);
		РезультатВсего = РезультатВсего + СтрокаНачисления.Результат;
	КонецЦикла;
	
	ЗначенияПараметров.Очистить();
	ЗначенияПараметров.Вставить("Результат", РезультатВсего);
	ЗаполнитьЗначенияСвойств(ОбластиМакета.СекцияОплатаДокументаПодвал.Параметры, ЗначенияПараметров);
	ТабличныйДокумент.Вывести(ОбластиМакета.СекцияОплатаДокументаПодвал);
	
КонецПроцедуры

Функция ОбластиМакетаПодробногоРасчетаНачислений()
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьРасчетаНачислений.ПФ_MXL_ПодробныйРасчетНачислений");
	
	ОбластиМакета = Новый Структура;
	
	ОбластиМакета.Вставить("СекцияШапка", 					Макет.ПолучитьОбласть("Шапка"));
	ОбластиМакета.Вставить("СекцияСреднийЗаработокШапка",  	Макет.ПолучитьОбласть("СреднийЗаработокШапка"));
	ОбластиМакета.Вставить("СекцияОплатаДокументаШапка",  	Макет.ПолучитьОбласть("ОплатаДокументаШапка"));
	ОбластиМакета.Вставить("СекцияОплатаДокументаСтрока",  	Макет.ПолучитьОбласть("ОплатаДокументаСтрока"));
	ОбластиМакета.Вставить("СекцияОплатаДокументаПодвал",  	Макет.ПолучитьОбласть("ОплатаДокументаПодвал"));
	ОбластиМакета.Вставить("СекцияПоказатель",  			Макет.ПолучитьОбласть("Показатель"));
	
	Возврат ОбластиМакета;	
	
КонецФункции 

#КонецОбласти

#Область ВспомогательныеПроцедурыИФункции

Процедура УстановитьНомерРазделаВОбласти(НомерРаздела, Область, ЗначенияПараметров)
	ЗначенияПараметров.Очистить();
	ЗначенияПараметров.Вставить("НомерРаздела", НомерРаздела);
	ЗаполнитьЗначенияСвойств(Область.Параметры, ЗначенияПараметров);
	НомерРаздела = НомерРаздела + 1;
КонецПроцедуры

Процедура ВывестиСекциюСреднийЗаработокШапка(ТабличныйДокумент, СекцияСреднийЗаработокШапка, НомерРаздела, ДанныеДокумента)
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба")
		И ДанныеДокумента.РасчетДенежногоСодержания Тогда
		
		ТекстОбласти = Строка(НомерРаздела) + ". " + НСтр("ru='Сохраняемое денежное содержание'")
			+ Символы.ПС
			+ Формат(ДанныеДокумента.СохраняемоеДенежноеСодержание, "ЧДЦ=2");
			
	Иначе
		ТекстОбласти = Строка(НомерРаздела) + ". " + НСтр("ru='Расчет среднего заработка'");
	КонецЕсли;
	
	НомерРаздела = НомерРаздела + 1;
	
	СекцияСреднийЗаработокШапка.Параметры.ТекстОбласти = ТекстОбласти;
	
	ТабличныйДокумент.Вывести(СекцияСреднийЗаработокШапка);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли