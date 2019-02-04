////////////////////////////////////////////////////////////////////////////////
// Отражение зарплаты в финансовом учете.
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Функция формирует структуру с данными отражения зарплаты для бухучета.
//
// Параметры:
//  ПериодРегистрации - дата, первое число месяца, данные отражения зарплаты 
//		за который будут получены.
//  Отказ - Булево
//  Организация - необязательный.
//
// Возвращаемое значение
// 		Структура ДанныеДляОтражения
//			Ключ - имя таблицы, соответствует разделам данных для отражения зарплаты.
//			Значение - таблица значений, данные соответствующего раздела.
//
Функция РезультатыОтраженияЗарплатыДляФинансовогоУчета(ПериодРегистрации, Отказ = Ложь, Организация = Неопределено) Экспорт

	ДанныеДляОтражения = ОтражениеЗарплатыВУчете.ДанныеДляОтраженияЗарплатыВУчете(ПериодРегистрации, Организация);
	
	НачисленнаяЗарплатаИВзносы = ДанныеДляОтражения.Начисления.Скопировать();
	ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(ДанныеДляОтражения.СтраховыеВзносы, НачисленнаяЗарплатаИВзносы);
	
	РезультатОтражения = Новый Структура;
	РезультатОтражения.Вставить("НачисленнаяЗарплатаИВзносы", НачисленнаяЗарплатаИВзносы);
	РезультатОтражения.Вставить("НачисленныйНДФЛ", ДанныеДляОтражения.НДФЛ);
	РезультатОтражения.Вставить("УдержаннаяЗарплата", ДанныеДляОтражения.Удержания);
	ДанныеДляОтражения = "";
	
	// Данные отражения в учете нужно дополнить данными структуры предприятия.
	// Если структура предприятия соответствует структуре юридических лиц, 
	// то подбираем значения структуры предприятия, соответствующие кадровой истории.
	// Если не соответствует, то пропорционально заполнению места сотрудника в структуре предприятия.
	
	ДобавитьПолеПодразделениеПредприятия(РезультатОтражения);
	
	РаспределитьСуммыНДФЛиУдержаний(РезультатОтражения);
	
	Если Константы.СтруктураПредприятияНеСоответствуетСтруктуреЮридическихЛиц.Получить() Тогда 
		ЗаполнитьПодразделениеПредприятиеПоМестамСотрудников(РезультатОтражения, ПериодРегистрации);
	Иначе
		ЗаполнитьПодразделениеПредприятиеПоСтруктуреЮридическихЛиц(РезультатОтражения);
	КонецЕсли;
	
	СвернутьТаблицыДанныхДляОтражения(РезультатОтражения);
	
	Возврат РезультатОтражения;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Метод предназначен для регистрации результатов отражения заработной платы 
// в финансовом учете.
//
// Параметры:
//  Движения - коллекция движения документа, выполняющего регистрацию результатов.
//  Отказ - булево, признак отказа от проведения документа.
//  Организация - Организация (необязательный)
//  ПериодРегистрации - дата, первое число месяца, отражение зарплаты 
//		за который будет выполнено.
//  ДанныеДляОтражения - структура, ключ - имя раздела данных, 
//		значение - таблица значений с соответствующими данными.
//
Процедура ЗарегистрироватьЗарплатуВФинансовомУчете(Движения, Отказ, ПериодРегистрации, ДанныеДляОтражения = Неопределено, Организация = Неопределено) Экспорт
	
	Если ДанныеДляОтражения = Неопределено Тогда
		// Получим структуру с результатами отражения зарплаты
		// структура РезультатОтраженияЗарплатыДляБухучета
		// ключ - имя таблицы, значение - таблица значений с полученными данными
		// в структуре присутствуют все таблицы, а заполнены только те, которые входят в СтрокаСписокТаблиц.
		ДанныеДляОтражения = РезультатыОтраженияЗарплатыДляФинансовогоУчета(ПериодРегистрации, Отказ, Организация);
	КонецЕсли;
	
	// формирование проводок
	ОтражениеЗарплатыВФинансовомУчетеПереопределяемый.ЗарегистрироватьЗарплатуВФинансовомУчете(
		Движения, Отказ, ПериодРегистрации, ДанныеДляОтражения, Организация);

КонецПроцедуры

// Функция определяет возможность выполнения операции отражения зарплаты в финансовом учете, 
// осуществляемой документом «Отражение зарплаты в финансовом учете», 
// одним экземпляром документа по всем организациям.
//
// Возвращаемое значение - булево, 
//	Истина, если операция одним документом по всем организациям доступна, 
//	Ложь - в противном случае.
//
Функция ОтражениеЗарплатыВФинансовомУчетеОднимДокументомПоВсемОрганизациямДоступно() Экспорт

	Возврат ОтражениеЗарплатыВФинансовомУчетеПереопределяемый.ОтражениеЗарплатыВФинансовомУчетеОднимДокументомПоВсемОрганизациямДоступно();
	
КонецФункции

#Область ЗащитаПерсональныхДанных

// Процедура обеспечивает сбор сведений о хранении данных, 
// относящихся к персональным.
//
// Параметры:
//		ТаблицаСведений - таблица значений с полями:
//			Объект 			- строка, содержащая полное имя объекта метаданных,
//			ПоляРегистрации - строка, в которой перечислены имена полей регистрации, 
//								отдельные поля регистрации отделяются запятой,
//								альтернативные - символом "|",
//			ПоляДоступа		- строка, в которой перечислены через запятую имена полей доступа.
//			ОбластьДанных	- строка с идентификатором области данных, необязательно для заполнения.
//
Процедура ЗаполнитьСведенияОПерсональныхДанных(ТаблицаСведений) Экспорт
	
	НовыеСведения = ТаблицаСведений.Добавить();
	НовыеСведения.Объект			= "Документ.ОтражениеЗарплатыВФинансовомУчете";
	НовыеСведения.ПоляРегистрации	= "НачисленнаяЗарплатаИВзносы.ФизическоеЛицо,НачисленныйНДФЛ.ФизическоеЛицо,УдержаннаяЗарплата.ФизическоеЛицо";
	НовыеСведения.ПоляДоступа		= "НачисленнаяЗарплатаИВзносы.Сумма,НачисленныйНДФЛ.Сумма,УдержаннаяЗарплата.Сумма";
	НовыеСведения.ОбластьДанных		= "Доходы";
	
КонецПроцедуры

#КонецОбласти

#Область ДатыЗапретаИзмененияДанных

// См. ДатыЗапретаИзмененияПереопределяемый.ПриЗаполненииРазделовДатЗапретаИзменения.
Процедура ПриЗаполненииРазделовДатЗапретаИзменения(Разделы) Экспорт
	
	Раздел = Разделы.Добавить();
	Раздел.Имя  = "ФинансовыйУчетЗарплаты";
	Раздел.Идентификатор = Новый УникальныйИдентификатор("715573d4-7d68-43dd-b74a-e978a1772df7");
	Раздел.Представление = НСтр("ru = 'Финансовый учет зарплаты'");
	Раздел.ТипыОбъектов.Добавить(Тип("СправочникСсылка.Организации"));
	
КонецПроцедуры

Процедура ЗаполнитьИсточникиДанныхДляПроверкиЗапретаИзменения(ИсточникиДанных) Экспорт
	
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ОтражениеЗарплатыВФинансовомУчете",	"ПериодРегистрации", "ФинансовыйУчетЗарплаты", "");
	
КонецПроцедуры

#КонецОбласти

#Область УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииСписковСОграничениемДоступа(Списки) Экспорт
	
	Списки.Вставить(Метаданные.Документы.ОтражениеЗарплатыВФинансовомУчете, Истина);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СвернутьТаблицыДанныхДляОтражения(ДанныеДляОтражения)
	
	КолонкиГруппировок = "Организация, ФизическоеЛицо, ПодразделениеПредприятия, ВидОперации";
	ДанныеДляОтражения["НачисленнаяЗарплатаИВзносы"].Свернуть(КолонкиГруппировок, "Сумма");
	
	КолонкиГруппировок = "Организация, ФизическоеЛицо, ПодразделениеПредприятия, ВидОперации";
	ДанныеДляОтражения["НачисленныйНДФЛ"].Свернуть(КолонкиГруппировок, "Сумма");
	
	КолонкиГруппировок = "Организация, ФизическоеЛицо, ПодразделениеПредприятия, ВидОперации, Контрагент";
	ДанныеДляОтражения["УдержаннаяЗарплата"].Свернуть(КолонкиГруппировок, "Сумма");
	
КонецПроцедуры

Процедура ДобавитьПолеПодразделениеПредприятия(ДанныеДляОтражения)
	
	ИменаТаблиц = Новый Массив;
	ИменаТаблиц.Добавить("НачисленнаяЗарплатаИВзносы");
	ИменаТаблиц.Добавить("НачисленныйНДФЛ");
	ИменаТаблиц.Добавить("УдержаннаяЗарплата");
	
	Для Каждого ИмяТаблицы Из ИменаТаблиц Цикл
		Если ДанныеДляОтражения[ИмяТаблицы].Колонки.Найти("ПодразделениеПредприятия") = Неопределено Тогда
			ДанныеДляОтражения[ИмяТаблицы].Колонки.Добавить(
				"ПодразделениеПредприятия", Новый ОписаниеТипов("СправочникСсылка.СтруктураПредприятия"));
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьПодразделениеПредприятиеПоСтруктуреЮридическихЛиц(ДанныеДляОтражения)
		
	// Если структура предприятия соответствует структуре юридических лиц, 
	// надо добавить колонку Подразделение (юр. лица) в таблицу НачисленныйНДФЛ 
	// заполнить эту колонку, распределяя НДФЛ пропорционально начисленной зарплате.

	// Для таблиц, в которых есть подразделение структуры юридических лиц 
	// определяем подразделение структуры предприятия.
	// Для остальных - распределяем пропорционально начислениям, взносам сотрудника.
	ПоляПодразделений = Новый Соответствие;
	ПоляПодразделений.Вставить("НачисленнаяЗарплатаИВзносы", "Подразделение");
	ПоляПодразделений.Вставить("НачисленныйНДФЛ", "Подразделение");
	ПоляПодразделений.Вставить("УдержаннаяЗарплата", "Подразделение");
	
	// Выбираем подразделения юридических лиц.
	ПодразделенияЮридическихЛиц = Новый Массив;
	Для Каждого КлючИЗначение Из ПоляПодразделений Цикл
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ПодразделенияЮридическихЛиц, 
			ОбщегоНазначения.ВыгрузитьКолонку(ДанныеДляОтражения[КлючИЗначение.Ключ], КлючИЗначение.Значение, Истина), 
			Истина);
	КонецЦикла;
	
	// Определяем соответствующие им подразделения предприятия.
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	СтруктураПредприятия.Ссылка КАК ПодразделениеПредприятия,
	|	СтруктураПредприятия.Источник КАК ПодразделениеОрганизации
	|ИЗ
	|	Справочник.СтруктураПредприятия КАК СтруктураПредприятия
	|ГДЕ
	|	СтруктураПредприятия.Источник В(&ПодразделенияЮридическихЛиц)";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ПодразделенияЮридическихЛиц", ПодразделенияЮридическихЛиц);
	
	ПодразделениеПредприятия = Новый Соответствие;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ПодразделениеПредприятия.Вставить(Выборка.ПодразделениеОрганизации, Выборка.ПодразделениеПредприятия);
	КонецЦикла;
	
	// Заполняем колонки ПодразделениеПредприятия.
	Для Каждого КлючИЗначение Из ПоляПодразделений Цикл
		Таблица = ДанныеДляОтражения[КлючИЗначение.Ключ];
		Для Каждого СтрокаТаблицы Из Таблица Цикл
			СтрокаТаблицы["ПодразделениеПредприятия"] = ПодразделениеПредприятия[СтрокаТаблицы[КлючИЗначение.Значение]];
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

Процедура РаспределитьСуммыНДФЛиУдержаний(ДанныеДляОтражения)
	
	ИменаТаблиц = Новый Массив;
	ИменаТаблиц.Добавить("НачисленныйНДФЛ");
	ИменаТаблиц.Добавить("УдержаннаяЗарплата");
	
	// Начисленный НДФЛ и удержания нужно распределить по всем строкам физического лица.
	ОтборСтрок = Новый Структура("ФизическоеЛицо, Организация");
	Для Каждого ИмяТаблицы Из ИменаТаблиц Цикл
		ВременнаяТаблица = ДанныеДляОтражения[ИмяТаблицы].Скопировать();
		ДанныеДляОтражения[ИмяТаблицы].Очистить();
		// Добавляем колонку Подразделение (юр. лица), т.к. не во всех таблицах она есть.
		Если ДанныеДляОтражения[ИмяТаблицы].Колонки.Найти("Подразделение") = Неопределено Тогда
			ДанныеДляОтражения[ИмяТаблицы].Колонки.Добавить(
				"Подразделение", Новый ОписаниеТипов("СправочникСсылка.ПодразделенияОрганизаций"));
		КонецЕсли;
		// Распределяем данные физических лиц пропорционально начисленной сотрудникам зарплате.
		Для Каждого СтрокаВременнойТаблицы Из ВременнаяТаблица Цикл
			ЗаполнитьЗначенияСвойств(ОтборСтрок, СтрокаВременнойТаблицы);
			СтрокиРаспределения = ДанныеДляОтражения["НачисленнаяЗарплатаИВзносы"].НайтиСтроки(ОтборСтрок);
			РаспределяемаяСумма = СтрокаВременнойТаблицы.Сумма;
			Если РаспределяемаяСумма = 0 
				Или СтрокиРаспределения.Количество() = 0 Тогда
				ЗаполнитьЗначенияСвойств(ДанныеДляОтражения[ИмяТаблицы].Добавить(), СтрокаВременнойТаблицы);
				Продолжить;
			КонецЕсли;
			МассивСумм = ОбщегоНазначения.ВыгрузитьКолонку(СтрокиРаспределения, "Сумма");
			РаспределенныеСуммы = ЗарплатаКадры.РаспределитьСуммуПропорциональноБазе(РаспределяемаяСумма, МассивСумм);
			Индекс = 0;
			Пока Индекс < СтрокиРаспределения.Количество() Цикл
				СтрокаРаспределения = СтрокиРаспределения[Индекс];
				НоваяСтрока = ДанныеДляОтражения[ИмяТаблицы].Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаВременнойТаблицы);
				НоваяСтрока.Сумма = РаспределенныеСуммы[Индекс];
				НоваяСтрока.ПодразделениеПредприятия = СтрокаРаспределения.ПодразделениеПредприятия;
				НоваяСтрока.Подразделение = СтрокаРаспределения.Подразделение;
				НоваяСтрока.Сотрудник = СтрокаРаспределения.Сотрудник;
				Индекс = Индекс + 1;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьПодразделениеПредприятиеПоМестамСотрудников(ДанныеДляОтражения, ПериодРегистрации)
	
	// Для каждого сотрудника необходимо определить подразделение структуры предприятия, 
	// распределить суммы расходов сотрудников пропорционально времени в разных подразделениях 
	// (если подразделение менялось в течение месяца).
	
	// Получаем сотрудников
	// Для каждого сотрудника определяем подразделение на начало периода, а также все изменения.
	// Составляем интервалы действия подразделений для сотрудника.
	// Для различных интервалов рассчитываем время по производственному календарю.
	
	Сотрудники = Новый Массив;
	
	// Заполняем массив сотрудников.
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(Сотрудники, 
		ОбщегоНазначения.ВыгрузитьКолонку(ДанныеДляОтражения["НачисленнаяЗарплатаИВзносы"], "Сотрудник", Истина), Истина);
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(Сотрудники, 
		ОбщегоНазначения.ВыгрузитьКолонку(ДанныеДляОтражения["НачисленныйНДФЛ"], "Сотрудник", Истина), Истина);
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(Сотрудники, 
		ОбщегоНазначения.ВыгрузитьКолонку(ДанныеДляОтражения["УдержаннаяЗарплата"], "Сотрудник", Истина), Истина);
		
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	Сотрудники.Ссылка КАК Сотрудник,
	|	&Период КАК Период,
	|	&ДатаНачала КАК ДатаНачала,
	|	&ДатаОкончания КАК ДатаОкончания
	|ПОМЕСТИТЬ ВТСотрудникиПериоды
	|ИЗ
	|	Справочник.Сотрудники КАК Сотрудники
	|ГДЕ
	|	Сотрудники.Ссылка В(&Сотрудники)";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Сотрудники", Сотрудники);
	Запрос.УстановитьПараметр("Период", НачалоМесяца(ПериодРегистрации));
	Запрос.УстановитьПараметр("ДатаНачала", НачалоМесяца(ПериодРегистрации) + 1);
	Запрос.УстановитьПараметр("ДатаОкончания", КонецМесяца(ПериодРегистрации));
	Запрос.Выполнить();
	
	ПараметрыПостроения = ЗарплатаКадрыОбщиеНаборыДанных.ПараметрыПостроенияДляСоздатьВТИмяРегистра();
	ПараметрыПостроения.ВключатьЗаписиНаНачалоПериода = Истина;
	
	ЗарплатаКадрыОбщиеНаборыДанных.СоздатьВТИмяРегистра(
		"КадроваяИсторияСотрудников",
		МенеджерВременныхТаблиц,
		Истина,
		ЗарплатаКадрыОбщиеНаборыДанных.ОписаниеФильтраДляСоздатьВТИмяРегистра(
			"ВТСотрудникиПериоды",
			"Сотрудник"),
		ПараметрыПостроения,
		"ВТКадроваяИсторияСрезИДвиженияПредварительно");
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	КадроваяИсторияСрезИДвижения.Период,
	|	КадроваяИсторияСрезИДвижения.Сотрудник,
	|	КадроваяИсторияСрезИДвижения.ДолжностьПоШтатномуРасписанию
	|ПОМЕСТИТЬ ВТКадроваяИсторияСрезИДвижения
	|ИЗ
	|	ВТКадроваяИсторияСрезИДвиженияПредварительно КАК КадроваяИсторияСрезИДвижения";
	
	Запрос.Текст = ТекстЗапроса;
	Запрос.Выполнить();
		
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	КадроваяИстория.Период,
	|	КадроваяИстория.Сотрудник,
	|	ЕСТЬNULL(МестоПозицииВСтруктуреПредприятия.Подразделение, ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка)) КАК Подразделение
	|ПОМЕСТИТЬ ВТМестаВСтруктуреСрезИДвижения
	|ИЗ
	|	ВТКадроваяИсторияСрезИДвижения КАК КадроваяИстория
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МестоПозицииШтатногоРасписанияВСтруктуреПредприятия КАК МестоПозицииВСтруктуреПредприятия
	|		ПО КадроваяИстория.ДолжностьПоШтатномуРасписанию = МестоПозицииВСтруктуреПредприятия.Позиция";
	
	Запрос.Текст = ТекстЗапроса;
	Запрос.Выполнить();
		
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	Периоды.Период,
	|	Периоды.Сотрудник
	|ПОМЕСТИТЬ ВТПериоды
	|ИЗ
	|	ВТМестаВСтруктуреСрезИДвижения КАК Периоды
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Периоды.Сотрудник,
	|	Периоды.Период КАК ДатаНачала,
	|	ВЫБОР
	|		КОГДА МИНИМУМ(ПериодыСлед.Период) ЕСТЬ NULL 
	|			ТОГДА &ДатаОкончания
	|		ИНАЧЕ МИНИМУМ(ДОБАВИТЬКДАТЕ(ПериодыСлед.Период, СЕКУНДА, -1))
	|	КОНЕЦ КАК ДатаОкончания
	|ПОМЕСТИТЬ ВТИнтервалы
	|ИЗ
	|	ВТПериоды КАК Периоды
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТПериоды КАК ПериодыСлед
	|		ПО Периоды.Период < ПериодыСлед.Период
	|			И Периоды.Сотрудник = ПериодыСлед.Сотрудник
	|
	|СГРУППИРОВАТЬ ПО
	|	Периоды.Сотрудник,
	|	Периоды.Период
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Интервалы.Сотрудник,
	|	Интервалы.ДатаНачала,
	|	Интервалы.ДатаОкончания
	|ПОМЕСТИТЬ ВТСотрудникиИнтервалы
	|ИЗ
	|	ВТИнтервалы КАК Интервалы";
	
	Запрос.Текст = ТекстЗапроса;
	Запрос.Выполнить();
	
	// Получаем данные о времени за интервалы для распределения сумм.
	УчетРабочегоВремениРасширенный.СоздатьВТРабочееСотрудниковВремяПоИнтервалам(МенеджерВременныхТаблиц, ПериодРегистрации);
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	Интервалы.Сотрудник,
	|	Интервалы.ДатаНачала,
	|	Интервалы.ДатаОкончания,
	|	МестаВСтруктуре.Подразделение,
	|	РабочееВремяПоИнтервалам.НормаДней,
	|	РабочееВремяПоИнтервалам.НормаЧасов
	|ИЗ
	|	ВТИнтервалы КАК Интервалы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТРабочееВремяПоИнтервалам КАК РабочееВремяПоИнтервалам
	|		ПО (РабочееВремяПоИнтервалам.Сотрудник = Интервалы.Сотрудник)
	|			И (РабочееВремяПоИнтервалам.ДатаНачала = Интервалы.ДатаНачала)
	|			И (РабочееВремяПоИнтервалам.ДатаОкончания = Интервалы.ДатаОкончания)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТМестаВСтруктуреСрезИДвижения КАК МестаВСтруктуре
	|		ПО (МестаВСтруктуре.Период = Интервалы.ДатаНачала)
	|			И (МестаВСтруктуре.Сотрудник = Интервалы.Сотрудник)";
	
	Запрос.Текст = ТекстЗапроса;
	
	МестаСотрудниковВСтруктуреПредприятия = Запрос.Выполнить().Выгрузить();
	
	ОтборСтрок = Новый Структура("Сотрудник");
	
	ИменаТаблиц = Новый Массив;
	ИменаТаблиц.Добавить("НачисленнаяЗарплатаИВзносы");
	ИменаТаблиц.Добавить("НачисленныйНДФЛ");
	ИменаТаблиц.Добавить("УдержаннаяЗарплата");
	
	Для Каждого ИмяТаблицы Из ИменаТаблиц Цикл
		ВременнаяТаблица = ДанныеДляОтражения[ИмяТаблицы].Скопировать();
		ДанныеДляОтражения[ИмяТаблицы].Очистить();
		Для Каждого СтрокаВременнойТаблицы Из ВременнаяТаблица Цикл
			РаспределяемаяСумма = СтрокаВременнойТаблицы.Сумма;
			Если РаспределяемаяСумма = 0 Тогда
				// Строка переносится "как есть".
				ЗаполнитьЗначенияСвойств(ДанныеДляОтражения[ИмяТаблицы].Добавить(), СтрокаВременнойТаблицы);
				Продолжить;
			КонецЕсли;
			ЗаполнитьЗначенияСвойств(ОтборСтрок, СтрокаВременнойТаблицы);
			СтрокиРаспределения = МестаСотрудниковВСтруктуреПредприятия.НайтиСтроки(ОтборСтрок);
			Если СтрокиРаспределения.Количество() = 0 Тогда
				// Нет данных для распределения - переносим "как есть".
				ЗаполнитьЗначенияСвойств(ДанныеДляОтражения[ИмяТаблицы].Добавить(), СтрокаВременнойТаблицы);
				Продолжить;
			КонецЕсли;
			МассивКоэффициентов = ОбщегоНазначения.ВыгрузитьКолонку(СтрокиРаспределения, "НормаЧасов");
			МассивСумм = ЗарплатаКадрыКлиентСервер.РаспределитьПропорциональноКоэффициентам(РаспределяемаяСумма, МассивКоэффициентов);
			Индекс = 0;
			Пока Индекс < СтрокиРаспределения.Количество() Цикл
				НоваяСтрока = ДанныеДляОтражения[ИмяТаблицы].Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаВременнойТаблицы);
				НоваяСтрока.Сумма = МассивСумм[Индекс];
				НоваяСтрока.ПодразделениеПредприятия = СтрокиРаспределения[Индекс].Подразделение;
				Индекс = Индекс + 1;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

// Определяет объекты, в которых есть процедура ДобавитьКомандыПечати().
// Подробнее см. УправлениеПечатьюПереопределяемый.
//
// Параметры:
//  СписокОбъектов - Массив - список менеджеров объектов.
//
Процедура ПриОпределенииОбъектовСКомандамиПечати(СписокОбъектов) Экспорт
	
	СписокОбъектов.Добавить(Документы.ОтражениеЗарплатыВФинансовомУчете); 
	
КонецПроцедуры

#КонецОбласти
