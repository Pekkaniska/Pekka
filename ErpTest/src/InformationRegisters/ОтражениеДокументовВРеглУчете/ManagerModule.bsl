#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура создает в указанном менеджере временных таблиц новую с именем "ТаблицаДокументов". При этом данные в
// таблицу попадают на основании
//	параметров, указанных при вызове процедуры.
//
//	Параметры:
//		ВременныеТаблицы - МенеджерВременныхТаблиц - менеджер ВТ, где необходимо создать новую временную таблицу "ТаблицаДокументов".
//		ОтборОрганизаций - Массив - СправочникСсылка.Организации - содержит отбор по организациям при подборе документов во временную таблицу.
//			если параметр не указан - не используется;
//		ОтборСтатусов - Массив - ПеречислениеСсылка.СтатусыОтраженияДокументовВРеглУчете - содержит отбор по статусам при подборе документов во временную таблицу.
//			если параметр не указан - не используется; 
//
Процедура ДобавитьВременнуюТаблицуДокументовСОтборомПоСтатусуОтражения(ВременныеТаблицы, ОтборОрганизаций = Неопределено, ОтборСтатусов = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = ВременныеТаблицы;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ОтражениеДокументовВРеглУчете.Регистратор КАК Документ,
	|	ОтражениеДокументовВРеглУчете.Организация КАК Организация
	|ПОМЕСТИТЬ ТаблицаДокументов
	|ИЗ
	|	РегистрСведений.ОтражениеДокументовВРеглУчете КАК ОтражениеДокументовВРеглУчете
	|ГДЕ
	|	&УсловиеОтбораПоСтатусам
	|	И &УсловиеОтбораПоОрганизации
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	Документ";
	
	Если ОтборОрганизаций = Неопределено Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеОтбораПоОрганизации", "ИСТИНА");
	Иначе
		Запрос.УстановитьПараметр("Организации", ОтборОрганизаций);
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеОтбораПоОрганизации", "ОтражениеДокументовВРеглУчете.Организация В (&Организации)");
	КонецЕсли;
	Если ОтборСтатусов = Неопределено Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеОтбораПоСтатусам", "ИСТИНА");
	Иначе
		Запрос.УстановитьПараметр("Статусы", ОтборСтатусов);
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеОтбораПоСтатусам", "ОтражениеДокументовВРеглУчете.Статус В (&Статусы)");
	КонецЕсли;
	
	Запрос.Выполнить();
	
КонецПроцедуры

// Процедура регистрируют к отражению все документы за указанный период
//
//	Параметры:
//		НачалоПериода - Дата - Дата, с которой документы будут регистрироваться к отражению;
//		КонецПериода - Дата - Дата, по которую документы будут регистрироваться к отражению;
//		Организация - СправочникСсылка.Организации, Массив с типом СправочникСсылка.Организации 
//						- Организации, для которых документы будут регистрироваться к отражению;
//		ТипыДокументов - Массив с элементами типа "Тип" - список типов документов, которые необходимо вернуть к отражению
//					- если не задано - будут возвращаться к отражению все документы.
//
Процедура ЗарегистрироватьДокументыКОтражению(НачалоПериода, КонецПериода, Организация = Неопределено, ТипыДокументов = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОтражениеДокументовВРеглУчете.Регистратор КАК Документ,
	|	ОтражениеДокументовВРеглУчете.Организация,
	|	ОтражениеДокументовВРеглУчете.ДатаОтражения
	|ПОМЕСТИТЬ ДокументыКОтражению
	|ИЗ
	|	РегистрСведений.ОтражениеДокументовВРеглУчете КАК ОтражениеДокументовВРеглУчете
	|ГДЕ
	|	ОтражениеДокументовВРеглУчете.ДатаОтражения МЕЖДУ &НачалоПериода И &КонецПериода
	|	И (&Организация = НЕОПРЕДЕЛЕНО
	|			ИЛИ ОтражениеДокументовВРеглУчете.Организация В (&Организация))
	|	И (&ВсеДокументы
	|			ИЛИ ТИПЗНАЧЕНИЯ(ОтражениеДокументовВРеглУчете.Регистратор) В (&ТипыДокументов))";
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", КонецПериода);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ТипыДокументов", ТипыДокументов);
	Запрос.УстановитьПараметр("ВсеДокументы", ТипыДокументов = Неопределено);
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	РеглУчетПроведениеСервер.ВернутьДокументыКОтражению(Запрос.МенеджерВременныхТаблиц);
	
КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#КонецЕсли