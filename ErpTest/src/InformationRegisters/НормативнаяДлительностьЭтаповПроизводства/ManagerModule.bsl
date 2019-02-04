#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Рассчитывает нормативную длительность этапов производства
//
// Параметры:
//  Спецификация - СправочникСсылка.РесурсныеСпецификация - объект расчета.
// 
// Возвращаемое значение:
//  Булево - результат расчета (Истина, если расчет выполнен успешно).
//
Функция Рассчитать(Спецификация) Экспорт
	
	ЕстьОшибки = Ложь;
	НачатьТранзакцию();
	Попытка
		
		Блокировка = Новый БлокировкаДанных;
		
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.НормативнаяДлительностьЭтаповПроизводства");
		ЭлементБлокировки.УстановитьЗначение("Спецификация", Спецификация);
		
		Блокировка.Заблокировать();
		
		РезультатРасчета = РассчитатьПоСпецификации(Спецификация);
		ЗаписатьРезультатРасчета(Спецификация, РезультатРасчета);
	
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		
		СобытиеЖурналаРегистрации = ПроизводствоСервер.СобытиеРасчетНормативнойДлительности();
		
		ТекстСообщения = СтрШаблон(НСтр("ru = 'Не удалось рассчитать длительность этапов производства по спецификации: %1 по причине: %2'"),
							Спецификация,
							ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрации, УровеньЖурналаРегистрации.Ошибка, Спецификация.Метаданные(), Спецификация, ТекстСообщения);
		
		ЕстьОшибки = Истина;
		
	КонецПопытки;
	
	Возврат Не ЕстьОшибки;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область РасчетДлительности

Функция РассчитатьПоСпецификации(Спецификация)
	
	ДанныеДляРасчета = ДанныеДляРасчета(Спецификация);
	
	СписокЭтапов = ДанныеДляРасчета.СписокЭтапов;
	СрокиРемонтов = ДанныеДляРасчета.СрокиРемонтов;
	
	НормыЧасов = Новый Соответствие;
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	ПроизводствоСервер.СоздатьВТГрафикиРаботыПодразделений(
		СписокЭтапов.ВыгрузитьКолонку("Подразделение"), МенеджерВременныхТаблиц, "ВТГрафикиРаботы");
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ВТГрафикиРаботы.Ссылка КАК Подразделение,
		|	ВТГрафикиРаботы.ГрафикРаботы КАК ГрафикРаботы
		|ИЗ
		|	ВТГрафикиРаботы КАК ВТГрафикиРаботы
		|ИТОГИ ПО
		|	Подразделение");
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	ВыборкаИтоги = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаИтоги.Следующий() Цикл
		
		МассивСсылок = Новый Массив;
		Выборка = ВыборкаИтоги.Выбрать();
		Пока Выборка.Следующий() Цикл
			МассивСсылок.Добавить(Выборка.ГрафикРаботы);
		КонецЦикла;
		
		НормыЧасов.Вставить(
			ВыборкаИтоги.Подразделение,
			УправлениеДаннымиОбИзделиях.СвернутаяСредняяНормаЧасовПоГрафикамРаботы(МассивСсылок));
			
	КонецЦикла;
	
	РассчитатьДлительность(СписокЭтапов, НормыЧасов);
	РассчитатьДнейДоОкончания(СписокЭтапов, СрокиРемонтов, НормыЧасов);
	РассчитатьДнейОтНачала(СписокЭтапов, СрокиРемонтов, НормыЧасов);
	
	Возврат СписокЭтапов;
	
КонецФункции

Функция ЗаписатьРезультатРасчета(Спецификация, РезультатРасчета, ВызовИзОбработчикаОбновления = Ложь)
	
	Набор = РегистрыСведений.НормативнаяДлительностьЭтаповПроизводства.СоздатьНаборЗаписей();
	
	Набор.Отбор.Спецификация.Установить(Спецификация);
	
	Набор.Загрузить(РезультатРасчета);
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ВызовИзОбработчикаОбновления Тогда
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(Набор);
	Иначе
		Набор.Записать(Истина);
	КонецЕсли;
	
КонецФункции

Функция ДанныеДляРасчета(Спецификация)
	
	//СписокЭтапов
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	Таблица.Ссылка КАК Этап,
		|	Таблица.Владелец КАК Спецификация,
		|	Таблица.НомерЭтапа КАК НомерЭтапа,
		|	Таблица.НомерСледующегоЭтапа КАК НомерСледующегоЭтапа,
		|	ВЫБОР
		|		КОГДА Таблица.Подразделение.ГрафикРаботы = ЗНАЧЕНИЕ(Справочник.Календари.ПустаяСсылка)
		|			ТОГДА ОсновнойКалендарьПредприятия.Значение
		|		ИНАЧЕ Таблица.Подразделение.ГрафикРаботы
		|	КОНЕЦ КАК ГрафикРаботы,
		|	Таблица.Подразделение КАК Подразделение,
		|	Таблица.ДлительностьЭтапа КАК Длительность,
		|	Таблица.ЕдиницаИзмеренияДлительностиЭтапа КАК ЕдиницаИзмерения
		|ИЗ
		|	Справочник.ЭтапыПроизводства КАК Таблица
		|		ЛЕВОЕ СОЕДИНЕНИЕ Константа.ОсновнойКалендарьПредприятия КАК ОсновнойКалендарьПредприятия
		|		ПО (ИСТИНА)
		|ГДЕ
		|	Таблица.Владелец = &Спецификация
		|	И НЕ Таблица.ПометкаУдаления
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Таблица.ИсточникПолученияПолуфабриката КАК Этап,
		|	Таблица.Этап КАК ЭтапПолучатель,
		|	МАКСИМУМ(ВЫБОР
		|			КОГДА Таблица.Альтернативный
		|				ТОГДА 0
		|			ИНАЧЕ ЕСТЬNULL(Нормативы.ПлановаяДлительность, 0)
		|		КОНЕЦ) КАК Длительность,
		|	МАКСИМУМ(ЕСТЬNULL(Нормативы.МаксимальнаяДлительность, 0)) КАК ДлительностьМакс
		|ИЗ
		|	Справочник.РесурсныеСпецификации.МатериалыИУслуги КАК Таблица
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НормативнаяДлительностьПроизводства КАК Нормативы
		|		ПО Таблица.СпецификацияРемонта = Нормативы.Спецификация
		|ГДЕ
		|	Таблица.Ссылка = &Спецификация
		|	И Таблица.ПроизводитсяВПроцессе
		|	И Таблица.СпецификацияРемонта <> ЗНАЧЕНИЕ(Справочник.РесурсныеСпецификации.ПустаяСсылка)
		|
		|СГРУППИРОВАТЬ ПО
		|	Таблица.ИсточникПолученияПолуфабриката,
		|	Таблица.Этап");
	Запрос.УстановитьПараметр("Спецификация", Спецификация);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	СписокЭтапов = МассивРезультатов[0].Выгрузить();
	
	ОписаниеТипа = Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(10, 0, ДопустимыйЗнак.Неотрицательный));
	СписокЭтапов.Колонки.Добавить("ДлительностьВДнях", ОписаниеТипа);
	СписокЭтапов.Колонки.Добавить("ДнейДоОкончания", ОписаниеТипа);
	СписокЭтапов.Колонки.Добавить("ДнейДоОкончанияМакс", ОписаниеТипа);
	СписокЭтапов.Колонки.Добавить("ДнейОтНачала", ОписаниеТипа);
	СписокЭтапов.Колонки.Добавить("ДнейОтНачалаМакс", ОписаниеТипа);
	СписокЭтапов.Колонки.Добавить("Окончание", ОписаниеТипа);
	СписокЭтапов.Колонки.Добавить("ОкончаниеМакс", ОписаниеТипа);
	
	ОписаниеТипа = Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(10, 3, ДопустимыйЗнак.Неотрицательный));
	СписокЭтапов.Колонки.Добавить("ДлительностьВЧасах", ОписаниеТипа);
	СписокЭтапов.Колонки.Добавить("ОстатокВЧасах", ОписаниеТипа); // переходящий остаток (в часах)
	СписокЭтапов.Колонки.Добавить("ОстатокВЧасахМакс", ОписаниеТипа); // переходящий остаток (в часах)
	
	СписокЭтапов.Индексы.Добавить("Этап");
	СписокЭтапов.Индексы.Добавить("НомерЭтапа");
	СписокЭтапов.Индексы.Добавить("НомерСледующегоЭтапа");
	
	СрокиРемонтов = ?(МассивРезультатов[1].Пустой(), Неопределено, МассивРезультатов[1].Выгрузить());
	
	Возврат Новый Структура("СписокЭтапов, СрокиРемонтов", СписокЭтапов, СрокиРемонтов);
	
КонецФункции

Процедура РассчитатьДлительность(СписокЭтапов, НормыЧасов)
	
	Для каждого ОбъектРасчета Из СписокЭтапов Цикл
		
		Если ОбъектРасчета.Длительность = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		ДлительностьВДнях = 0;
		ДлительностьВЧасах = 0;
		
		Если ОбъектРасчета.ЕдиницаИзмерения <> Перечисления.ЕдиницыИзмеренияВремени.День Тогда
		
			Если ( ОбъектРасчета.ЕдиницаИзмерения = Перечисления.ЕдиницыИзмеренияВремени.Час
					ИЛИ ОбъектРасчета.ЕдиницаИзмерения = Перечисления.ЕдиницыИзмеренияВремени.Минута
					ИЛИ ОбъектРасчета.ЕдиницаИзмерения = Перечисления.ЕдиницыИзмеренияВремени.Секунда
				) Тогда
				
				ДлительностьВЧасах = ПланированиеПроизводстваКлиентСервер.ПолучитьВремяВСекундах(
					ОбъектРасчета.Длительность,
					ОбъектРасчета.ЕдиницаИзмерения) / 3600;
				НормаЧасов = НормыЧасов[ОбъектРасчета.Подразделение];
				
				ДлительностьВДнях = Цел(ДлительностьВЧасах/НормаЧасов) + ?(ДлительностьВЧасах % НормаЧасов > 0,1,0);
				
			Иначе
				
				ДлительностьВДнях = ПланированиеПроизводстваКлиентСервер.ПолучитьВремяВЕдиницеИзмерения(
					ПланированиеПроизводстваКлиентСервер.ПолучитьВремяВСекундах(
						ОбъектРасчета.Длительность,
						ОбъектРасчета.ЕдиницаИзмерения),
					Перечисления.ЕдиницыИзмеренияВремени.День);
			КонецЕсли;
			
		Иначе
			
			ДлительностьВДнях = ОбъектРасчета.Длительность;
			
		КонецЕсли;
		
		ОбъектРасчета.ДлительностьВДнях = ДлительностьВДнях;
		ОбъектРасчета.ДлительностьВЧасах = ДлительностьВЧасах;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура РассчитатьДнейДоОкончания(СписокЭтапов, СрокиРемонтов, НормыЧасов)
	
	СписокЭтапов.ЗаполнитьЗначения(0, "ОстатокВЧасах");
	СписокЭтапов.ЗаполнитьЗначения(0, "ОстатокВЧасахМакс");
	
	Отбор = Новый Структура("НомерСледующегоЭтапа", 0);
	Очередь = СписокЭтапов.НайтиСтроки(Отбор);
	
	Пока Очередь.Количество() > 0 Цикл
		
		Вершина = Очередь[0];
		
		Если Вершина.НомерСледующегоЭтапа = 0 Тогда
			
			РассчитатьРесурсыДнейДоОкончания(
				Вершина,
				НормыЧасов[Вершина.Подразделение]);
			
			Вершина.ДнейДоОкончанияМакс = Вершина.ДнейДоОкончания;
			Вершина.ОстатокВЧасахМакс   = Вершина.ОстатокВЧасах;
			
		КонецЕсли;
		
		Отбор = Новый Структура("НомерСледующегоЭтапа", Вершина.НомерЭтапа);
		
		Для каждого Узел Из СписокЭтапов.НайтиСтроки(Отбор) Цикл
			
			Сроки = СрокиРемонтаДоОкончания(СписокЭтапов, СрокиРемонтов, Узел, Вершина);
			
			РассчитатьРесурсыДнейДоОкончания(
				Узел,
				НормыЧасов[Узел.Подразделение],
				Вершина,
				Сроки.Длительность,
				"");
			
			Если Сроки.Длительность = Сроки.ДлительностьМакс Тогда
				
				Узел.ДнейДоОкончанияМакс = Узел.ДнейДоОкончания;
				Узел.ОстатокВЧасахМакс = Узел.ОстатокВЧасах;
				
			Иначе
				
				РассчитатьРесурсыДнейДоОкончания(
					Узел,
					НормыЧасов[Узел.Подразделение],
					Вершина,
					Сроки.ДлительностьМакс,
					"Макс");
				
			КонецЕсли;
			
			Очередь.Добавить(Узел);
			
		КонецЦикла;
		
		Очередь.Удалить(0);
		
	КонецЦикла;
	
КонецПроцедуры

Функция СрокиРемонтаДоОкончания(СписокЭтапов, СрокиРемонтов, Этап, СледующийЭтап)
	
	Результат = Новый Структура("Длительность, ДлительностьМакс", 0, 0);
	
	Если СрокиРемонтов = Неопределено Тогда
		Возврат Результат;
	КонецЕсли;
	
	РемонтыЭтапа = СрокиРемонтов.НайтиСтроки(Новый Структура("Этап", Этап.Этап));
	Для каждого СтрокаРемонт Из РемонтыЭтапа Цикл
		
		ЭтапПолучатель = СписокЭтапов.Найти(СтрокаРемонт.ЭтапПолучатель, "Этап");
		
		СрокРемонта = ЭтапПолучатель.ДнейДоОкончания + СтрокаРемонт.Длительность;
		Если СрокРемонта > СледующийЭтап.ДнейДоОкончания Тогда
			Результат.Длительность = Макс(Результат.Длительность,
				(СрокРемонта - СледующийЭтап.ДнейДоОкончания));
		КонецЕсли;
		
		СрокРемонта = ЭтапПолучатель.ДнейДоОкончанияМакс + СтрокаРемонт.ДлительностьМакс;
		Если СрокРемонта > СледующийЭтап.ДнейДоОкончанияМакс Тогда
			Результат.ДлительностьМакс = Макс(Результат.ДлительностьМакс,
				(СрокРемонта - СледующийЭтап.ДнейДоОкончанияМакс));
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Процедура РассчитатьРесурсыДнейДоОкончания(ОбъектРасчета, НормаЧасов, Последователь = Неопределено, ЗадержкаВДнях = 0, Постфикс = "")
	
	ДнейДоОкончания = 0;
	Если Последователь <> Неопределено Тогда
		Если (Последователь <> Неопределено
				И Последователь.ОстатокВЧасах > 0
				И ОбъектРасчета.ДлительностьВЧасах > 0
				И ОбъектРасчета.Подразделение = Последователь.Подразделение
				И ЗадержкаВДнях = 0) Тогда
			СуммарнаяДлительностьВЧасах = Макс(ОбъектРасчета.ДлительностьВЧасах - Последователь.ОстатокВЧасах, 0);
			СуммарнаяДлительностьВДнях = Цел(СуммарнаяДлительностьВЧасах/НормаЧасов) + ?(СуммарнаяДлительностьВЧасах % НормаЧасов > 0,1,0);
		Иначе
			СуммарнаяДлительностьВДнях = ОбъектРасчета.ДлительностьВДнях;
		КонецЕсли;
		ДнейДоОкончания = Макс(ОбъектРасчета["ДнейДоОкончания" + Постфикс],
			СуммарнаяДлительностьВДнях + Последователь["ДнейДоОкончания" + Постфикс] + ЗадержкаВДнях);
	Иначе
		ДнейДоОкончания = ОбъектРасчета.ДлительностьВДнях;
	КонецЕсли;
	ОбъектРасчета["ДнейДоОкончания" + Постфикс] = ДнейДоОкончания;
	
	ОстатокВЧасах = 0;
	Если ОбъектРасчета.ДлительностьВЧасах > 0 Тогда
		Если (Последователь <> Неопределено
				И Последователь["ОстатокВЧасах" + Постфикс] > 0
				И ОбъектРасчета.ДлительностьВЧасах > 0
				И ОбъектРасчета.Подразделение = Последователь.Подразделение
				И ЗадержкаВДнях = 0) Тогда
			
			Если ОбъектРасчета.ДлительностьВЧасах > Последователь["ОстатокВЧасах" + Постфикс] Тогда
				ОстатокВЧасах = (ОбъектРасчета["ДнейДоОкончания" + Постфикс] - Последователь["ДнейДоОкончания" + Постфикс])
					* НормаЧасов - (ОбъектРасчета.ДлительностьВЧасах - Последователь["ОстатокВЧасах" + Постфикс]);
			Иначе
				ОстатокВЧасах = Последователь["ОстатокВЧасах" + Постфикс] - ОбъектРасчета.ДлительностьВЧасах;
			КонецЕсли;
			
		Иначе
			ОстатокВЧасах = (ОбъектРасчета.ДлительностьВДнях * НормаЧасов) - ОбъектРасчета.ДлительностьВЧасах;
		КонецЕсли;
	КонецЕсли;
	ОбъектРасчета["ОстатокВЧасах" + Постфикс] = ОстатокВЧасах;
	
КонецПроцедуры

Процедура РассчитатьДнейОтНачала(СписокЭтапов, СрокиРемонтов, НормыЧасов)
	
	СписокЭтапов.ЗаполнитьЗначения(0, "ОстатокВЧасах");
	СписокЭтапов.ЗаполнитьЗначения(0, "ОстатокВЧасахМакс");
	
	Очередь = Новый Массив;
	
	Для каждого Этап Из СписокЭтапов Цикл
		
		НайденнаяСтрока = СписокЭтапов.Найти(Этап.НомерЭтапа, "НомерСледующегоЭтапа");
		Если НайденнаяСтрока = Неопределено Тогда
			
			РассчитатьРесурсыДнейОтНачала(
				Этап,
				НормыЧасов[Этап.Подразделение]);
			
			Этап.ОкончаниеМакс = Этап.Окончание;
			Этап.ОстатокВЧасахМакс = Этап.ОстатокВЧасах;
			
			Очередь.Добавить(Этап);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Пока Очередь.Количество() > 0 Цикл
		
		Вершина = Очередь[0];
		
		Отбор = Новый Структура("НомерЭтапа", Вершина.НомерСледующегоЭтапа);
		
		Для каждого Узел Из СписокЭтапов.НайтиСтроки(Отбор) Цикл
			
			Сроки = СрокиРемонтаОтНачала(СписокЭтапов, СрокиРемонтов, Вершина, Узел);
			
			РассчитатьРесурсыДнейОтНачала(
				Узел,
				НормыЧасов[Узел.Подразделение],
				Вершина,
				Сроки.Длительность,
				"");
				
			Если Сроки.Длительность = Сроки.ДлительностьМакс Тогда
				
				Узел.ДнейОтНачалаМакс = Узел.ДнейОтНачала;
				Узел.ОкончаниеМакс = Узел.Окончание;
				Узел.ОстатокВЧасахМакс = Узел.ОстатокВЧасах;
				
			Иначе
				
				РассчитатьРесурсыДнейОтНачала(
					Узел,
					НормыЧасов[Узел.Подразделение],
					Вершина,
					Сроки.ДлительностьМакс,
					"Макс");
				
			КонецЕсли;
			
			Очередь.Добавить(Узел);
			
		КонецЦикла;
		
		Очередь.Удалить(0);
		
	КонецЦикла;
	
КонецПроцедуры

Функция СрокиРемонтаОтНачала(СписокЭтапов, СрокиРемонтов, Этап, СледующийЭтап)
	
	Результат = Новый Структура("Длительность, ДлительностьМакс", 0, 0);
	
	Если СрокиРемонтов = Неопределено Тогда
		Возврат Результат;
	КонецЕсли;
	
	РемонтыЭтапа = СрокиРемонтов.НайтиСтроки(Новый Структура("ЭтапПолучатель", СледующийЭтап.Этап));
	Для каждого СтрокаРемонт Из РемонтыЭтапа Цикл
		
		ЭтапОтправитель = СписокЭтапов.Найти(СтрокаРемонт.Этап, "Этап");
		
		СрокРемонта = ЭтапОтправитель.Окончание + СтрокаРемонт.Длительность;
		Если СрокРемонта > Этап.Окончание Тогда
			Результат.Длительность = Макс(Результат.Длительность,
				(СрокРемонта - Этап.Окончание));
		КонецЕсли;
		
		СрокРемонта = ЭтапОтправитель.ОкончаниеМакс + СтрокаРемонт.ДлительностьМакс;
		Если СрокРемонта > Этап.ОкончаниеМакс Тогда
			Результат.ДлительностьМакс = Макс(Результат.ДлительностьМакс,
				(СрокРемонта - Этап.ОкончаниеМакс));
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Процедура РассчитатьРесурсыДнейОтНачала(ОбъектРасчета, НормаЧасов, Предшественник = Неопределено, ЗадержкаВДнях = 0, Постфикс = "")
	
	ЗачетЧасовПредшественника = Предшественник <> Неопределено
		И Предшественник["ОстатокВЧасах" + Постфикс] > 0
		И ОбъектРасчета.ДлительностьВЧасах > 0
		И ОбъектРасчета.Подразделение = Предшественник.Подразделение
		И ЗадержкаВДнях = 0;
	
	ДнейОтНачала = 0;
	Если Предшественник <> Неопределено Тогда
		
		Если ЗачетЧасовПредшественника Тогда
			Начало = Предшественник["Окончание" + Постфикс] - 1;
		Иначе
			Начало = Предшественник["Окончание" + Постфикс] + ЗадержкаВДнях;
		КонецЕсли;
		
		ДнейОтНачала = Макс(ОбъектРасчета["ДнейОтНачала" + Постфикс], Начало);
		
	КонецЕсли;
	ОбъектРасчета["ДнейОтНачала" + Постфикс] = ДнейОтНачала;
	
	Окончание = ОбъектРасчета["ДнейОтНачала" + Постфикс] + ОбъектРасчета.ДлительностьВДнях;
	Если ЗачетЧасовПредшественника И ОбъектРасчета.ДлительностьВЧасах > Предшественник["ОстатокВЧасах" + Постфикс] Тогда
		Окончание = Окончание + 1;
	КонецЕсли;
	ОбъектРасчета["Окончание" + Постфикс] = Окончание;
	
	ОстатокВЧасах = 0;
	Если ОбъектРасчета.ДлительностьВЧасах > 0 Тогда
		
		Если ЗачетЧасовПредшественника Тогда
			
			Если ОбъектРасчета.ДлительностьВЧасах > Предшественник["ОстатокВЧасах" + Постфикс] Тогда
				ОстатокВЧасах = (ОбъектРасчета["Окончание" + Постфикс] - Предшественник["ДнейОтНачала" + Постфикс] - 1)
					* НормаЧасов - (ОбъектРасчета.ДлительностьВЧасах - Предшественник["ОстатокВЧасах" + Постфикс]);
			Иначе
				ОстатокВЧасах = Предшественник["ОстатокВЧасах" + Постфикс] - ОбъектРасчета.ДлительностьВЧасах;
			КонецЕсли;
			
		Иначе
			ОстатокВЧасах = (ОбъектРасчета.ДлительностьВДнях * НормаЧасов) - ОбъектРасчета.ДлительностьВЧасах;
		КонецЕсли;
		
	КонецЕсли;
	ОбъектРасчета["ОстатокВЧасах" + Постфикс] = ОстатокВЧасах;
	
КонецПроцедуры

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяРегистра = Метаданные.РегистрыСведений.НормативнаяДлительностьЭтаповПроизводства.ПолноеИмя();
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Таблица.Спецификация КАК Спецификация
		|ИЗ
		|	РегистрСведений.НормативнаяДлительностьЭтаповПроизводства КАК Таблица
		|ГДЕ
		|	Таблица.ДнейДоОкончания <> 0
		|	И Таблица.ДнейДоОкончания > Таблица.ДнейДоОкончанияМакс
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Таблица.Спецификация
		|ИЗ
		|	РегистрСведений.НормативнаяДлительностьЭтаповПроизводства КАК Таблица
		|ГДЕ
		|	Таблица.ДнейОтНачала <> 0
		|	И Таблица.ДнейОтНачала > Таблица.ДнейОтНачалаМакс");
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.Вставить("ЭтоНезависимыйРегистрСведений", Истина);
	ДополнительныеПараметры.Вставить("ПолноеИмяРегистра", ПолноеИмяРегистра);
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Запрос.Выполнить().Выгрузить(), ДополнительныеПараметры);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяРегистра = Метаданные.РегистрыСведений.НормативнаяДлительностьЭтаповПроизводства.ПолноеИмя();
	
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьИзмеренияНезависимогоРегистраСведенийДляОбработки(
		Параметры.Очередь,
		ПолноеИмяРегистра);
	
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяРегистра);
			ЭлементБлокировки.УстановитьЗначение("Спецификация", Выборка.Спецификация);
			Блокировка.Заблокировать();
			
			Набор = РегистрыСведений.НормативнаяДлительностьЭтаповПроизводства.СоздатьНаборЗаписей();
			Набор.Отбор.Спецификация.Установить(Выборка.Спецификация);
			Набор.Прочитать();
			
			НаборИзменен = Ложь;
			
			Для каждого Запись Из Набор Цикл
				
				Если Запись.ДнейДоОкончания <> 0 И Запись.ДнейДоОкончания > Запись.ДнейДоОкончанияМакс Тогда
					
					Запись.ДнейДоОкончанияМакс = Запись.ДнейДоОкончания;
					НаборИзменен = Истина;
					
				КонецЕсли;
				
				Если Запись.ДнейОтНачала <> 0 И Запись.ДнейОтНачала > Запись.ДнейОтНачалаМакс Тогда
					
					Запись.ДнейОтНачалаМакс = Запись.ДнейОтНачала;
					НаборИзменен = Истина;
					
				КонецЕсли;
				
			КонецЦикла;
			
			Если НаборИзменен Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(Набор);
			Иначе
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Набор);
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			ОбновлениеИнформационнойБазыУТ.СообщитьОНеудачнойОбработке(ИнформацияОбОшибке(), Выборка.Спецификация);
			
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = Не ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяРегистра);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли