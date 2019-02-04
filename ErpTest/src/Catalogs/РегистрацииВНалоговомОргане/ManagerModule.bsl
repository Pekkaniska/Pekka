#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция формирует сведения по данным регистрации в налоговом органе.
//
// Параметры:
//	РегистрацияВНалоговомОргане - СправочникСсылка.РегистрацииВНалоговомОргане - регистрация в налоговом органе.
//
// Возвращаемое значение:
//	Структура - Организация, Представление, ПолноеНаименование, КодПоОКПО, ИНН, КПП, ЮридическийАдрес, ФактическийАдрес, НомерСчета, Банк, БИК, КоррСчет.
//
Функция СведенияОПодразделении(РегистрацияВНалоговомОргане, Дата = Неопределено) Экспорт
	
	Сведения = Новый Структура("Организация, Представление, ПолноеНаименование, КодПоОКПО, ИНН, КПП, ЮридическийАдрес, ФактическийАдрес, НомерСчета, Банк, БИК, КоррСчет");
	
	Если ЗначениеЗаполнено(РегистрацияВНалоговомОргане) Тогда
		
		ИменаРеквизитов = Новый Структура;
		ИменаРеквизитов.Вставить("Организация",        "Владелец");
		ИменаРеквизитов.Вставить("Представление",      "НаименованиеОбособленногоПодразделения");
		ИменаРеквизитов.Вставить("ПолноеНаименование", "НаименованиеОбособленногоПодразделения");
		ИменаРеквизитов.Вставить("КодПоОКПО",          "Владелец.КодПоОКПО");
		ИменаРеквизитов.Вставить("ИНН",                "Владелец.ИНН");
		ИменаРеквизитов.Вставить("КПП",                "КПП");
		
		ЗаполнитьЗначенияСвойств(
			Сведения,
			ОбщегоНазначения.ЗначенияРеквизитовОбъекта(РегистрацияВНалоговомОргане, ИменаРеквизитов));
		
		Сведения.Вставить("ЮридическийАдрес", 	ФормированиеПечатныхФорм.ПолучитьАдресИзКонтактнойИнформации(Сведения.Организация,        "Юридический", Дата));
		Сведения.Вставить("ФактическийАдрес", 	ФормированиеПечатныхФорм.ПолучитьАдресИзКонтактнойИнформации(РегистрацияВНалоговомОргане, "Фактический", Дата));
		
		РеквизитыСчета =
			Справочники.БанковскиеСчетаОрганизаций.ПолучитьРеквизитыБанковскогоСчетаОрганизации(
				Справочники.БанковскиеСчетаОрганизаций.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(Сведения.Организация));
		
		ЗаполнитьЗначенияСвойств(
			Сведения,
			РеквизитыСчета,
			"НомерСчета, Банк, БИК, КоррСчет");
		
	КонецЕсли;
	
	Возврат Сведения;
	
КонецФункции

// Функция возвращает значение типа Булево, которое определяет
// возможность ввода сведений о регистрации в налоговом органе
// для обособленных подразделений, выделенных на отдельный баланс.
//
// Возвращаемое значение:
//  Булево - признак возможности ввода сведений о регистрации в налоговом органе.
//
Функция ВозможнаРегистрацияДляОбособленныхПодразделений() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Возвращает ссылку на "Регистрацию в налоговом органе" по состоянию на некоторую ДатаАктуальности
// Параметры:
//	СтруктурнаяЕдиница - СправочникСсылка.Организации, СправочникСсылка.ПодразделенияОрганизаций - структурная единица.
//	ДатаАктуальности - Дата - дата, на которую требуется получить сведения.
//
// Возвращаемое значение:
//	СправочникСсылка.РегистрацииВНалоговомОргане - регистрация в налоговом органе.
//
Функция РегистрацияВНалоговомОргане(СтруктурнаяЕдиница, Знач ДатаАктуальности = Неопределено, РегистрацияВНалоговомОргане = Неопределено) Экспорт
	
	Если РегистрацияВНалоговомОргане <> Неопределено Тогда
		Возврат РегистрацияВНалоговомОргане;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СтруктурнаяЕдиница", СтруктурнаяЕдиница);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Регистрации.РегистрацияВНалоговомОргане КАК РегистрацияВНалоговомОргане
	|ИЗ
	|	РегистрСведений.РегистрацииВНалоговомОргане КАК Регистрации
	|ГДЕ
	|	Регистрации.Организация = &СтруктурнаяЕдиница
	|	И Регистрации.Подразделение = ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Организации.РегистрацияВНалоговомОргане
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	Организации.Ссылка = &СтруктурнаяЕдиница";
	
	//++ НЕ УТ
	Если Не ЗначениеЗаполнено(ДатаАктуальности) Тогда
		ДатаАктуальности = ТекущаяДатаСеанса()
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ДатаАктуальности", ДатаАктуальности);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Регистрации.РегистрацияВНалоговомОргане КАК РегистрацияВНалоговомОргане
	|ИЗ
	|	РегистрСведений.ИсторияРегистрацийВНалоговомОргане.СрезПоследних(&ДатаАктуальности, СтруктурнаяЕдиница = &СтруктурнаяЕдиница) КАК Регистрации";
	//-- НЕ УТ
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		
		Возврат Выборка.РегистрацияВНалоговомОргане;
		
	КонецЕсли;
	
	//++ НЕ УТ
	Если ТипЗнч(СтруктурнаяЕдиница) = Тип("СправочникСсылка.ПодразделенияОрганизаций") Тогда
		
		ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СтруктурнаяЕдиница, "Родитель,Владелец");
		Если ЗначениеЗаполнено(ЗначенияРеквизитов.Родитель) Тогда
			Возврат Справочники.РегистрацииВНалоговомОргане.РегистрацияВНалоговомОргане(ЗначенияРеквизитов.Родитель, ДатаАктуальности);
		Иначе
			Возврат Справочники.РегистрацииВНалоговомОргане.РегистрацияВНалоговомОргане(ЗначенияРеквизитов.Владелец, ДатаАктуальности);
		КонецЕсли;
		
	КонецЕсли;
	//-- НЕ УТ
	
	Возврат Справочники.РегистрацииВНалоговомОргане.ПустаяСсылка();
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"ПрисоединитьДополнительныеТаблицы
	|ЭтотСписок КАК ЭтотСписок
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК Владельцы 
	|	ПО Владельцы.Ссылка = ЭтотСписок.Владелец
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК ОбособленныеПодразделения 
	|	ПО ОбособленныеПодразделения.ГоловнаяОрганизация = Владельцы.Ссылка
	|;
	|РазрешитьЧтение
	|ГДЕ
	|	ЗначениеРазрешено(Владелец)
	| ИЛИ ЗначениеРазрешено(ОбособленныеПодразделения.Ссылка)
	|;
	|РазрешитьИзменениеЕслиРазрешеноЧтение
	|ГДЕ
	|	ЗначениеРазрешено(Владелец)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

//++ НЕ УТ
Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если Параметры.Отбор.Свойство("Организация") Тогда
		
		Если ЗначениеЗаполнено(Параметры.Отбор.Организация) Тогда
			
			ГоловнаяОрганизация = ОбщегоНазначенияУТВызовСервера.ЗначениеРеквизитаОбъекта(Параметры.Отбор.Организация, "ГоловнаяОрганизация");
			
			Если ЗначениеЗаполнено(ГоловнаяОрганизация) Тогда
				
				Параметры.Отбор.Организация = ГоловнаяОрганизация; 
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры
//-- НЕ УТ

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РегистрацииВНалоговомОргане.Ссылка
	|ИЗ
	|	Справочник.РегистрацииВНалоговомОргане КАК РегистрацииВНалоговомОргане
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Справочник.Организации КАК Организации
	|	ПО
	|		РегистрацииВНалоговомОргане.Владелец = Организации.Ссылка
	|ГДЕ
	|	Организации.ОбособленноеПодразделение
	|";
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяОбъекта = "Справочник.РегистрацииВНалоговомОргане";
	
	ОбъектыДляОбработки = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(Параметры.Очередь, ПолноеИмяОбъекта);
	
	КэшГоловныхОрганизаций = Новый Соответствие;
	
	Пока ОбъектыДляОбработки.Следующий() Цикл
		
		НачатьТранзакцию();
		
		Попытка
			
			// Устанавливаем управляемую блокировку, чтобы провести ответственное чтение объекта.
			Блокировка = Новый БлокировкаДанных;
			
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяОбъекта);
			ЭлементБлокировки.УстановитьЗначение("Ссылка", ОбъектыДляОбработки.Ссылка);
			
			Блокировка.Заблокировать();
			
			Объект = ОбъектыДляОбработки.Ссылка.ПолучитьОбъект();
			
			Если Объект = Неопределено Тогда
				ОтменитьТранзакцию();
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(ОбъектыДляОбработки.Ссылка);
				Продолжить;
			КонецЕсли;
			
			ГоловнаяОрганизация = КэшГоловныхОрганизаций[Объект.Владелец];
			Если ГоловнаяОрганизация = Неопределено Тогда
				ГоловнаяОрганизация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Владелец, "ГоловнаяОрганизация");
				КэшГоловныхОрганизаций.Вставить(Объект.Владелец, ГоловнаяОрганизация);
			КонецЕсли;
			Объект.Владелец = ГоловнаяОрганизация;
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(Объект);
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			МетаданныеОбъекта = Метаданные.НайтиПоПолномуИмени(ПолноеИмяОбъекта);
			
			ТекстСообщения = НСтр("ru = 'Не удалось обработать %ИмяОбъекта%: %Ссылка% по причине: %Причина%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ИмяОбъекта%", ПолноеИмяОбъекта);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Ссылка%", ОбъектыДляОбработки.Ссылка);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
										УровеньЖурналаРегистрации.Предупреждение,
										МетаданныеОбъекта,
										ОбъектыДляОбработки.Ссылка,
										ТекстСообщения);
			
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяОбъекта);
	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
