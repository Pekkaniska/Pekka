#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица с командами отчетов. Для изменения.
//       См. описание 1 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	
	
КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(Подразделение)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт

	ИсточникиДанных = Новый Соответствие;

	Возврат ИсточникиДанных; 

КонецФункции
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт
	
	// Создание запроса инициализации движений и заполенение его параметров
	Запрос = Новый Запрос;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
	
	// Текст запроса, формирующего таблицы движений
	ТекстыЗапроса = Новый СписокЗначений;
	
	ТекстЗапросаЛимитыРасходаДенежныхСредств(Запрос, ТекстыЗапроса, Регистры);
	
	// Выполение запроса и выгрузка полученных таблиц для формирования движений
	ПроведениеСерверУТ.ИнициализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Истина);
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)

	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.УстановитьПараметр("ИспользоватьЛимитыРасходаПоОрганизациям",
		ПолучитьФункциональнуюОпцию("ИспользоватьЛимитыРасходаДенежныхСредствПоОрганизациям"));
	Запрос.УстановитьПараметр("ИспользоватьЛимитыРасходаПоПодразделениям", 
		ПолучитьФункциональнуюОпцию("ИспользоватьЛимитыРасходаДенежныхСредствПоПодразделениям"));
	
КонецПроцедуры

Функция ТекстЗапросаЛимитыРасходаДенежныхСредств(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ЛимитыРасходаДенежныхСредств";
	
	Если Не ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Лимиты.Ссылка.Период КАК Период,
	|	ВЫБОР
	|		КОГДА &ИспользоватьЛимитыРасходаПоОрганизациям
	|			ТОГДА Лимиты.Ссылка.Организация
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|	КОНЕЦ КАК Организация,
	|	ВЫБОР
	|		КОГДА &ИспользоватьЛимитыРасходаПоПодразделениям
	|			ТОГДА Лимиты.Ссылка.Подразделение 
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка)
	|	КОНЕЦ КАК Подразделение,
	|	Лимиты.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств,
	|	Лимиты.Сумма КАК Лимит
	|ИЗ
	|	Документ.ЛимитыРасходаДенежныхСредств.Лимиты КАК Лимиты
	|ГДЕ
	|	Лимиты.Ссылка = &Ссылка
	|	И Лимиты.ЕстьЛимит";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли