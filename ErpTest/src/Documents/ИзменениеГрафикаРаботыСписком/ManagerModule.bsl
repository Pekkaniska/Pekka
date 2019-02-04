#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ДляВсехСтрок( ЗначениеРазрешено(ФизическиеЛица.ФизическоеЛицо, NULL КАК ИСТИНА)
	|	) И ЗначениеРазрешено(Организация)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает описание состава документа
//
// Возвращаемое значение:
//  Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаДокумента.
Функция ОписаниеСоставаДокумента() Экспорт
	
	МетаданныеДокумента = Метаданные.Документы.ИзменениеГрафикаРаботыСписком;
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаДокументаПоМетаданнымФизическиеЛицаВТабличныхЧастях(МетаданныеДокумента);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

Функция ДобавитьКомандыСозданияДокументов(КомандыСозданияДокументов, ДополнительныеПараметры) Экспорт
	
	ЗарплатаКадрыРасширенный.ДобавитьВКоллекциюКомандуСозданияДокументаПоМетаданнымДокумента(
		КомандыСозданияДокументов, Метаданные.Документы.ИзменениеГрафикаРаботыСписком);
	
КонецФункции

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Приказ об изменении графика работы.
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "ЗарплатаКадрыКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.МенеджерПечати = "Обработка.ПечатьКадровыхПриказовРасширенная";
	КомандаПечати.Идентификатор = "ПФ_MXL_ИзмененияГрафикаРаботыСписком";
	КомандаПечати.Представление = НСтр("ru = 'Приказ об изменении графика работы'");
	КомандаПечати.Порядок = 10;
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.ДополнитьКомплектВнешнимиПечатнымиФормами = Истина;
	
КонецПроцедуры

#Область ЗаполнениеДокумента

Процедура РассчитатьФОТ(Знач Ссылка, Знач Организация, Знач ДатаИзменения, Знач ГрафикРаботы, НачисленияСотрудников, ТарифныеСтавкиСотрудников) Экспорт
	СотрудникиДаты = Новый ТаблицаЗначений;
	СотрудникиДаты.Колонки.Добавить("Сотрудник", Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
	СотрудникиДаты.Колонки.Добавить("ДатаСобытия", Новый ОписаниеТипов("Дата"));
	
	ДатаСобытия = НачалоДня(ДатаИзменения);
	
	Для Каждого СтрокаНачисления Из НачисленияСотрудников Цикл
		НоваяСтрока = СотрудникиДаты.Добавить();
		НоваяСтрока.ДатаСобытия = ДатаСобытия;
		НоваяСтрока.Сотрудник = СтрокаНачисления.Сотрудник;
	КонецЦикла;
	
	ВремяРегистрацииДокумента = ЗарплатаКадрыРасширенный.ЗначенияВремениРегистрацииДокумента(Ссылка, СотрудникиДаты);
	ВремяРегистрацииСотрудников = ВремяРегистрацииДокумента.Получить(ДатаСобытия);
	
	ТаблицаНачислений = ПлановыеНачисленияСотрудников.ТаблицаНачисленийДляРасчетаВторичныхДанных();
	ТаблицаПоказателей = ПлановыеНачисленияСотрудников.ТаблицаИзвестныеПоказатели();
	КадровыеДанные = ПлановыеНачисленияСотрудников.СоздатьТаблицаКадровыхДанных();
	
	ГоловнаяОрганизация = ЗарплатаКадры.ГоловнаяОрганизация(Организация);
	
	Для Каждого СтрокаНачисления Из НачисленияСотрудников Цикл
		ВремяРегистрации = ВремяРегистрацииСотрудников.Получить(СтрокаНачисления.Сотрудник);
		
		СтрокаКадровыхДанных = КадровыеДанные.Добавить();
		СтрокаКадровыхДанных.Сотрудник = СтрокаНачисления.Сотрудник;
		СтрокаКадровыхДанных.Период = ВремяРегистрации;
		СтрокаКадровыхДанных.ГрафикРаботы = ГрафикРаботы;
		СтрокаКадровыхДанных.Организация = Организация;
				
		ДанныеНачисления = ТаблицаНачислений.Добавить();
		ДанныеНачисления.Сотрудник = СтрокаНачисления.Сотрудник;
		ДанныеНачисления.ГоловнаяОрганизация = ГоловнаяОрганизация;
		ДанныеНачисления.Период = ВремяРегистрации;
		ДанныеНачисления.Начисление = СтрокаНачисления.Начисление;
		ДанныеНачисления.ДокументОснование = СтрокаНачисления.ДокументОснование;
		ДанныеНачисления.Размер = СтрокаНачисления.Размер;
	КонецЦикла;
	
	РассчитанныеДанные = ПлановыеНачисленияСотрудников.РассчитатьВторичныеДанныеПлановыхНачислений(ТаблицаНачислений, , КадровыеДанные);
		
	Для Каждого НачислениеСотрудника Из НачисленияСотрудников Цикл
		
		Отбор = Новый Структура("Сотрудник, Начисление, ДокументОснование", НачислениеСотрудника.Сотрудник, НачислениеСотрудника.Начисление, НачислениеСотрудника.ДокументОснование);
		СтрокиНачисления = РассчитанныеДанные.ПлановыйФОТ.НайтиСтроки(Отбор);
		Если СтрокиНачисления.Количество() > 0 Тогда
			НачислениеСотрудника.Размер = СтрокиНачисления[0].ВкладВФОТ;
		КонецЕсли; 

	КонецЦикла;
	
	Для Каждого СтрокатарифнойСтавки Из РассчитанныеДанные.ТарифныеСтавки Цикл
		НайденныеСтроки = ТарифныеСтавкиСотрудников.НайтиСтроки(Новый Структура("Сотрудник", СтрокатарифнойСтавки.Сотрудник));
		
		Если НайденныеСтроки.Количество() > 0 Тогда
			НайденныеСтроки[0].ВидТарифнойСтавки = СтрокатарифнойСтавки.ВидТарифнойСтавки;
			НайденныеСтроки[0].СовокупнаяТарифнаяСтавка = СтрокатарифнойСтавки.СовокупнаяТарифнаяСтавка;
		Иначе
			СтрокаТаблицы = ТарифныеСтавкиСотрудников.Добавить();
			СтрокаТаблицы.Сотрудник = СтрокатарифнойСтавки.Сотрудник;
			СтрокаТаблицы.ВидТарифнойСтавки = СтрокатарифнойСтавки.ВидТарифнойСтавки;
			СтрокаТаблицы.СовокупнаяТарифнаяСтавка = СтрокатарифнойСтавки.СовокупнаяТарифнаяСтавка;
		КонецЕсли;
	КонецЦикла;		
КонецПроцедуры

Функция СотрудникиДляИзмененияГрафика(Организация, Подразделение, ГрафикРаботы, ДатаИзменения) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Параметры = КадровыйУчет.ПараметрыПолученияСотрудниковОрганизацийПоСпискуФизическихЛиц();
	
	Параметры.Организация = Организация;
	Если ЗначениеЗаполнено(Подразделение) Тогда
		Параметры.Подразделение = Подразделение;
	КонецЕсли;
	
	Параметры.НачалоПериода 	= ДатаИзменения;
	Параметры.ОкончаниеПериода 	= ДатаИзменения;
	
	Если ЗначениеЗаполнено(ГрафикРаботы) Тогда
		
		ЗарплатаКадрыОбщиеНаборыДанных.ДобавитьВКоллекциюОтбор(
			Параметры.Отборы, "ГрафикРаботы", "<>", ГрафикРаботы);
		
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ГосударственнаяСлужба");
		Модуль.ДобавитьОтборыПоВидуДоговора(Параметры.Отборы);
	КонецЕсли; 
	
	Возврат КадровыйУчет.СотрудникиОрганизации(Истина, Параметры).ВыгрузитьКолонку("Сотрудник");
	
КонецФункции

Функция НачисленияСотрудников(Ссылка, ДатаИзменения, СписокСотрудников) Экспорт
	
	СотрудникиДаты = Новый ТаблицаЗначений;
	СотрудникиДаты.Колонки.Добавить("Сотрудник", Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
	СотрудникиДаты.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата"));
	СотрудникиДаты.Колонки.Добавить("ДатаСобытия", Новый ОписаниеТипов("Дата"));
	
	ДатаСобытия = НачалоДня(ДатаИзменения);
	
	Для Каждого Сотрудник Из СписокСотрудников Цикл 
		НоваяСтрока = СотрудникиДаты.Добавить();
		НоваяСтрока.ДатаСобытия = ДатаСобытия;
		НоваяСтрока.Сотрудник = Сотрудник;
	КонецЦикла;
	
	ВремяРегистрацииДокумента = ЗарплатаКадрыРасширенный.ЗначенияВремениРегистрацииДокумента(Ссылка, СотрудникиДаты);
	ВремяРегистрацииСотрудников = ВремяРегистрацииДокумента.Получить(ДатаСобытия);
	
	Для Каждого СтрокаСотрудника Из СотрудникиДаты Цикл 
		СтрокаСотрудника.Период = ВремяРегистрацииСотрудников.Получить(СтрокаСотрудника.Сотрудник);
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("СотрудникиДаты", СотрудникиДаты);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СотрудникиДаты.Сотрудник КАК Сотрудник,
	|	СотрудникиДаты.Период КАК Период
	|ПОМЕСТИТЬ ВТИзмеренияДаты
	|ИЗ
	|	&СотрудникиДаты КАК СотрудникиДаты";
	
	Запрос.Выполнить();
	
	// Подготовка сведений о плановых начислениях сотрудников.
	ЗапросВТПлановыеНачисления = КадровыйУчетРасширенный.ЗапросВТПлановыеНачисленияСотрудников(Истина, "ВТПлановыеНачисленияСотрудников", "ВТИзмеренияДаты", "Сотрудник,Период");
	ЗапросВТПлановыеНачисления.МенеджерВременныхТаблиц = Запрос.МенеджерВременныхТаблиц;
	ЗапросВТПлановыеНачисления.Выполнить();
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПлановыеНачисления.Сотрудник,
	|	ПлановыеНачисления.Начисление,
	|	ПлановыеНачисления.ДокументОснование,
	|	ПлановыеНачисления.Размер,
	|	ВЫРАЗИТЬ(ПлановыеНачисления.Начисление КАК ПланВидовРасчета.Начисления).РеквизитДопУпорядочивания КАК Порядок,
	|	ЛОЖЬ КАК ФиксСтрока
	|ИЗ
	|	ВТПлановыеНачисленияСотрудников КАК ПлановыеНачисления
	|ГДЕ
	|	НЕ ВЫРАЗИТЬ(ПлановыеНачисления.Начисление КАК ПланВидовРасчета.Начисления).КатегорияНачисленияИлиНеоплаченногоВремени В (ЗНАЧЕНИЕ(Перечисление.КатегорииНачисленийИНеоплаченногоВремени.ПособиеПоУходуЗаРебенкомДоПолутораЛет), ЗНАЧЕНИЕ(Перечисление.КатегорииНачисленийИНеоплаченногоВремени.ПособиеПоУходуЗаРебенкомДоТрехЛет))
	|
	|УПОРЯДОЧИТЬ ПО
	|	Порядок";
	
	НачисленияСотрудников = Запрос.Выполнить().Выгрузить();
	НачисленияСотрудников.Индексы.Добавить("Сотрудник");
	
	Возврат НачисленияСотрудников;
	
КонецФункции

Функция ТекущиеЗначенияСовокупныхТарифныхСтавокСотрудников(Ссылка, ДатаИзменения, МассивСотрудников) Экспорт 
	
	СотрудникиДаты = Новый ТаблицаЗначений;
	СотрудникиДаты.Колонки.Добавить("Сотрудник", Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
	СотрудникиДаты.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата"));
	СотрудникиДаты.Колонки.Добавить("ДатаСобытия", Новый ОписаниеТипов("Дата"));
	
	ДатаСобытия = НачалоДня(ДатаИзменения);
	
	Для Каждого Сотрудник Из МассивСотрудников Цикл 
		НоваяСтрока = СотрудникиДаты.Добавить();
		НоваяСтрока.ДатаСобытия = ДатаСобытия;
		НоваяСтрока.Сотрудник = Сотрудник;
	КонецЦикла;
	
	ВремяРегистрацииДокумента = ЗарплатаКадрыРасширенный.ЗначенияВремениРегистрацииДокумента(Ссылка, СотрудникиДаты);
	ВремяРегистрацииСотрудников = ВремяРегистрацииДокумента.Получить(ДатаСобытия);
	
	Для Каждого СтрокаСотрудника Из СотрудникиДаты Цикл 
		СтрокаСотрудника.Период = ВремяРегистрацииСотрудников.Получить(СтрокаСотрудника.Сотрудник);
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("СотрудникиДаты", СотрудникиДаты);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СотрудникиДаты.Сотрудник КАК Сотрудник,
	|	СотрудникиДаты.Период КАК Период
	|ПОМЕСТИТЬ ВТИзмеренияДаты
	|ИЗ
	|	&СотрудникиДаты КАК СотрудникиДаты";
	
	Запрос.Выполнить();
	
	ПараметрыПостроения = ЗарплатаКадрыОбщиеНаборыДанных.ПараметрыПостроенияДляСоздатьВТИмяРегистраСрез();
	ПараметрыПостроения.ФормироватьСПериодичностьДень = Ложь;
	
	ЗарплатаКадрыОбщиеНаборыДанных.ДобавитьВКоллекциюОтбор(ПараметрыПостроения.Отборы, "РегистраторСобытия", "<>", Ссылка);
	
	ЗарплатаКадрыОбщиеНаборыДанных.СоздатьВТИмяРегистраСрезПоследних(
		"ПлановыйФОТИтоги",
		Запрос.МенеджерВременныхТаблиц,
		Истина,
		ЗарплатаКадрыОбщиеНаборыДанных.ОписаниеФильтраДляСоздатьВТИмяРегистра(
			"ВТИзмеренияДаты",
			"Сотрудник"),
		ПараметрыПостроения);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗначенияСовокупныхТарифныхСтавок.Сотрудник,
	|	ЗначенияСовокупныхТарифныхСтавок.СовокупнаяТарифнаяСтавка КАК СовокупнаяТарифнаяСтавка,
	|	ЗначенияСовокупныхТарифныхСтавок.ВидТарифнойСтавки
	|ИЗ
	|	ВТПлановыйФОТИтогиСрезПоследних КАК ЗначенияСовокупныхТарифныхСтавок
	|ГДЕ
	|	ЗначенияСовокупныхТарифныхСтавок.СовокупнаяТарифнаяСтавка <> 0";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

#КонецОбласти

Функция ДанныеДляРегистрацииВУчетаСтажаПФР(МассивСсылок) Экспорт
	
	ДанныеДляРегистрацииВУчете = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ИзменениеГрафикаРаботыСотрудники.Ссылка КАК Ссылка,
	|	ИзменениеГрафикаРаботыСотрудники.Сотрудник КАК Сотрудник,
	|	ИзменениеГрафикаРаботыСписком.ДатаИзменения КАК ДатаНачала,
	|	ИзменениеГрафикаРаботыСписком.ДатаОкончания КАК ДатаОкончания,
	|	ИзменениеГрафикаРаботыСписком.Организация КАК Организация,
	|	ИзменениеГрафикаРаботыСписком.ГрафикРаботы КАК ГрафикРаботы
	|ПОМЕСТИТЬ ВТДанныеДокументов
	|ИЗ
	|	Документ.ИзменениеГрафикаРаботыСписком.Сотрудники КАК ИзменениеГрафикаРаботыСотрудники
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ИзменениеГрафикаРаботыСписком КАК ИзменениеГрафикаРаботыСписком
	|		ПО ИзменениеГрафикаРаботыСотрудники.Ссылка = ИзменениеГрафикаРаботыСписком.Ссылка
	|ГДЕ
	|	ИзменениеГрафикаРаботыСотрудники.Ссылка В(&МассивСсылок)";
	
	Запрос.Выполнить();
	
	ОписательВременныхТаблиц = КадровыйУчет.ОписательВременныхТаблицДляСоздатьВТКадровыеДанныеСотрудников(
		Запрос.МенеджерВременныхТаблиц, "ВТДанныеДокументов", "Сотрудник,ДатаНачала");
	КадровыйУчет.СоздатьВТКадровыеДанныеСотрудников(ОписательВременныхТаблиц, Ложь, "ВидЗанятости");
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДокументов.Ссылка КАК Ссылка,
	|	ДанныеДокументов.Сотрудник КАК Сотрудник,
	|	ДанныеДокументов.ДатаНачала КАК ДатаНачала,
	|	ДанныеДокументов.ДатаОкончания КАК ДатаОкончания,
	|	ДанныеДокументов.Организация КАК Организация,
	|	ДанныеДокументов.ГрафикРаботы КАК ГрафикРаботы,
	|	КадровыеДанныеСотрудников.ВидЗанятости КАК ВидЗанятости
	|ИЗ
	|	ВТДанныеДокументов КАК ДанныеДокументов
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКадровыеДанныеСотрудников КАК КадровыеДанныеСотрудников
	|		ПО ДанныеДокументов.Сотрудник = КадровыеДанныеСотрудников.Сотрудник
	|			И ДанныеДокументов.ДатаНачала = КадровыеДанныеСотрудников.Период
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.СледующийПоЗначениюПоля("Ссылка") Цикл
		
		ДанныеДляРегистрацииВУчетеПоДокументу = УчетСтажаПФР.ДанныеДляРегистрацииВУчетеСтажаПФР();
		ДанныеДляРегистрацииВУчете.Вставить(Выборка.Ссылка, ДанныеДляРегистрацииВУчетеПоДокументу); 
		
		Пока Выборка.Следующий() Цикл
			
			ОписаниеПериода = УчетСтажаПФР.ОписаниеРегистрируемогоПериода();
			ОписаниеПериода.Сотрудник = Выборка.Сотрудник;
			ОписаниеПериода.ДатаНачалаПериода = Выборка.ДатаНачала;
			ОписаниеПериода.ДатаОкончанияПериода = Выборка.ДатаОкончания;
			ОписаниеПериода.Состояние = Перечисления.СостоянияСотрудника.Работа;
			ОписаниеПериода.ВидЗанятости = Выборка.ВидЗанятости;
			
			РегистрируемыйПериод = УчетСтажаПФР.ДобавитьЗаписьВДанныеДляРегистрацииВУчета(ДанныеДляРегистрацииВУчетеПоДокументу, ОписаниеПериода);
			
			УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "ГрафикРаботы", Выборка.ГрафикРаботы);
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат ДанныеДляРегистрацииВУчете;
	
КонецФункции

Функция ДанныеДляПроверкиОграниченийНаУровнеЗаписей(Объект) Экспорт 

	ФизическиеЛица = ?(Объект.ФизическиеЛица.Количество() > 0 , Объект.ФизическиеЛица.Выгрузить().ВыгрузитьКолонку("ФизическоеЛицо"), Справочники.ФизическиеЛица.ПустаяСсылка());
	
	ДанныеДляПроверкиОграничений = ЗарплатаКадрыРасширенный.ОписаниеСтруктурыДанныхДляПроверкиОграниченийНаУровнеЗаписей();
	
	ДанныеДляПроверкиОграничений.Организация = Объект.Организация;
	ДанныеДляПроверкиОграничений.МассивФизическихЛиц = ФизическиеЛица;
	ДанныеДляПроверкиОграничений.Подразделение = Объект.Подразделение;
	
	Возврат ДанныеДляПроверкиОграничений;
	
КонецФункции

Функция ПолныеПраваНаДокумент() Экспорт 
	
	Возврат Пользователи.РолиДоступны("ДобавлениеИзменениеДанныхДляНачисленияЗарплатыРасширенная, ЧтениеДанныхДляНачисленияЗарплатыРасширенная", , Ложь);
	
КонецФункции

Процедура ЗаполнитьДатуЗапретаРедактирования(ОбъектДокумента) Экспорт
	
	ЗарплатаКадры.ЗаполнитьДатуЗапретаРедактирования(ОбъектДокумента, "ДатаИзменения");
	
КонецПроцедуры

Процедура ЗаполнитьДатыЗапрета(ПараметрыОбновления) Экспорт
	
	ОбновлениеВыполнено = Истина;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 100
		|	ИзменениеГрафикаРаботыСписком.Ссылка КАК Ссылка,
		|	ИзменениеГрафикаРаботыСписком.Дата КАК Дата
		|ИЗ
		|	Документ.ИзменениеГрафикаРаботыСписком КАК ИзменениеГрафикаРаботыСписком
		|ГДЕ
		|	ИзменениеГрафикаРаботыСписком.ДатаЗапрета = ДАТАВРЕМЯ(1, 1, 1)
		|
		|УПОРЯДОЧИТЬ ПО
		|	ИзменениеГрафикаРаботыСписком.Дата УБЫВ";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		
		ОбновлениеВыполнено = Ложь;
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			Если Не ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ПодготовитьОбновлениеДанных(
				ПараметрыОбновления, Выборка.Ссылка.Метаданные().ПолноеИмя(), "Ссылка", Выборка.Ссылка) Тогда
				
				Продолжить;
				
			КонецЕсли;
			
			ОбъектДокумента = Выборка.Ссылка.ПолучитьОбъект();
			
			МенеджерДокумента = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Выборка.Ссылка);
			МенеджерДокумента.ЗаполнитьДатуЗапретаРедактирования(ОбъектДокумента);
			
			ОбъектДокумента.ДополнительныеСвойства.Вставить("ОтключитьПроверкуДатыЗапретаИзменения", Истина);
			
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ОбъектДокумента);
			ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ЗавершитьОбновлениеДанных(ПараметрыОбновления);
			
		КонецЦикла;
		
	КонецЕсли;
	
	ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", ОбновлениеВыполнено);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли