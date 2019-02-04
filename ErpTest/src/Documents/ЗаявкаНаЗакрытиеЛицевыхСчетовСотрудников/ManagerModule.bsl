#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ДляВсехСтрок( ЗначениеРазрешено(Сотрудники.ФизическоеЛицо, NULL КАК ИСТИНА)
	|	) И ЗначениеРазрешено(Организация)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область МеханизмФиксацииИзменений

Функция ПараметрыФиксацииВторичныхДанных() Экспорт
	Возврат 
		ФиксацияВторичныхДанныхВДокументах.ПараметрыФиксацииВторичныхДанных(
			ФиксируемыеРеквизиты(), , 
			ФиксируемыеТЧ());
КонецФункции

#КонецОбласти

// Возвращает описание состава документа
//
// Возвращаемое значение:
//  Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаДокумента.
Функция ОписаниеСоставаДокумента() Экспорт
	
	МетаданныеДокумента = Метаданные.Документы.ЗаявкаНаЗакрытиеЛицевыхСчетовСотрудников;
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаДокументаПоМетаданнымФизическиеЛицаВТабличныхЧастях(МетаданныеДокумента);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область МеханизмФиксацииИзменений

Функция ФиксируемыеРеквизиты()
	ФиксируемыеРеквизиты = Новый Соответствие;
	
	// Реквизиты табличной части Сотрудники.
	Шаблон = ФиксацияВторичныхДанныхВДокументах.ОписаниеФиксируемогоРеквизита();
	Шаблон.ИмяГруппы           = "Сотрудник";
	Шаблон.ОснованиеЗаполнения = "Сотрудник";
	Шаблон.Путь                = "Сотрудники";
	Шаблон.РеквизитСтроки      = Истина;
	
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ДатаЗакрытия");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ЛицевойСчет");
	
	Возврат Новый ФиксированноеСоответствие(ФиксируемыеРеквизиты);
КонецФункции

Функция ФиксируемыеТЧ()
	Возврат Новый Структура("Сотрудники", ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве("ФизическоеЛицо"));
КонецФункции

#КонецОбласти

#Область ФормированиеФайлаОбмена

// Формирует и прикрепляет файл обмена к документу с помощью подсистемы "Файлы".
//
// Параметры:
//		СтруктураПараметровДляФормированияФайла - Структура - должна содержать значения:
//			МассивДокументов - Массив ссылок на документы, по которым требуется сформировать файл.
//			МассивОписанийФайлов - Массив описаний сформированных файлов.
//
Процедура ВыгрузитьФайлыДляОбменаСБанком(СтруктураПараметровДляФормированияФайла) Экспорт
	
	Если Не СтруктураПараметровДляФормированияФайла.Свойство("СтруктураПараметровЭД") Тогда
		СтруктураПараметровДляФормированияФайла.Вставить("СтруктураПараметровЭД", Неопределено);
	КонецЕсли;
	
	Отказ = Ложь;
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивДокументов", СтруктураПараметровДляФормированияФайла.МассивДокументов);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗаявкаНаЗакрытиеЛицевыхСчетовСотрудников.Ссылка КАК Заявка,
	|	ЗаявкаНаЗакрытиеЛицевыхСчетовСотрудников.ЗарплатныйПроект КАК ЗарплатныйПроект,
	|	ЗаявкаНаЗакрытиеЛицевыхСчетовСотрудников.Проведен КАК Проведен
	|ИЗ
	|	Документ.ЗаявкаНаЗакрытиеЛицевыхСчетовСотрудников КАК ЗаявкаНаЗакрытиеЛицевыхСчетовСотрудников
	|ГДЕ
	|	ЗаявкаНаЗакрытиеЛицевыхСчетовСотрудников.Ссылка В(&МассивДокументов)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Не Выборка.Проведен Тогда
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Документ %1 не проведен.'"), Выборка.Заявка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, Выборка.Заявка,,, Отказ);
		КонецЕсли;
		Если НЕ ОбменСБанкамиПоЗарплатнымПроектам.ИспользоватьЭОИСБанком(Выборка.ЗарплатныйПроект) Тогда
			Если ЗначениеЗаполнено(Выборка.ЗарплатныйПроект) Тогда
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'По зарплатному проекту %1 не используется обмен электронными документами с банком.'"),
					Выборка.ЗарплатныйПроект);
			Иначе
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'В документе %1 не выбран зарплатный проект.'"), Выборка.Заявка);
			КонецЕсли;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстСообщения, Выборка.ЗарплатныйПроект, "ИспользоватьЭлектронныйДокументооборотСБанком",,Отказ);
		КонецЕсли;
	КонецЦикла;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ВидОперации = "ЗаявкаНаЗакрытиеЛицевыхСчетовСотрудников";
	
	ДанныеДокументов = 
		ДанныеЗакрытияЛицевыхСчетов(
			СтруктураПараметровДляФормированияФайла.МассивДокументов, 
			ТекущаяДатаСеанса());
	
	СтруктураПараметровДляФормированияФайла.Вставить("ВидОперации",      ВидОперации);
	СтруктураПараметровДляФормированияФайла.Вставить("ДанныеДокументов", ДанныеДокументов);
	СтруктураПараметровДляФормированияФайла.Вставить("КорневыеСвойства",      ОбменСБанкамиПоЗарплатнымПроектам.КорневыеСвойства(ВидОперации));
	СтруктураПараметровДляФормированияФайла.Вставить("ОбязательныеПоляФайла", ОбменСБанкамиПоЗарплатнымПроектам.ОбязательныеПоляФайла(ВидОперации));
	СтруктураПараметровДляФормированияФайла.Вставить("СоответствиеПреобразованияЗначений", ОбменСБанкамиПоЗарплатнымПроектам.СоответствиеПреобразованияЗначений(ВидОперации));
	СтруктураПараметровДляФормированияФайла.Вставить("СоответствиеТипов",                  ОбменСБанкамиПоЗарплатнымПроектам.СоответствиеТипов(ВидОперации));
	
	ОбменСБанкамиПоЗарплатнымПроектам.СоздатьФайлыДляОбменаСБанком(СтруктураПараметровДляФормированияФайла);
	
КонецПроцедуры

// Получает данные документа для формирования файла обмена, печатного документа.
//
// Параметры:
//		МассивДокументов - Массив ссылок на документы, по которым требуется получить данные.
//		ДатаПолученияДанных - дата формирования файла.
//
// Возвращаемое значение:
//		Соответствие - где Ключ - ссылка на документ, Значение - структура документа.
//
Функция ДанныеЗакрытияЛицевыхСчетов(МассивДокументов, ДатаПолученияДанных) Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("ЗаявкиНаЗакрытиеЛицевыхСчетов", МассивДокументов);
	Запрос.УстановитьПараметр("ДатаПолученияДанных", ДатаПолученияДанных);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗаявкаНаЗакрытиеЛицевыхСчетовСотрудники.Ссылка КАК Документ,
	|	КОЛИЧЕСТВО(ЗаявкаНаЗакрытиеЛицевыхСчетовСотрудники.Сотрудник) КАК КоличествоЗаписей,
	|	0 КАК СуммаИтого,
	|	ЗарплатныеПроекты.НомерДоговора КАК НомерДоговора,
	|	ЗарплатныеПроекты.ДатаДоговора КАК ДатаДоговора,
	|	ЗарплатныеПроекты.РасчетныйСчет КАК НомерРасчетногоСчетаОрганизации,
	|	ЗарплатныеПроекты.ОтделениеБанка КАК ОтделениеБанка,
	|	ЗарплатныеПроекты.ФилиалОтделенияБанка КАК ФилиалОтделенияБанка,
	|	ЗарплатныеПроекты.Валюта.Код КАК КодВалюты,
	|	ЗарплатныеПроекты.ФорматФайла КАК ФорматФайла,
	|	ЗарплатныеПроекты.КодировкаФайла КАК КодировкаФайла,
	|	ЗарплатныеПроекты.Банк КАК Банк
	|ПОМЕСТИТЬ ВТИтоговыеДанные
	|ИЗ
	|	Документ.ЗаявкаНаЗакрытиеЛицевыхСчетовСотрудников.Сотрудники КАК ЗаявкаНаЗакрытиеЛицевыхСчетовСотрудники
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаявкаНаЗакрытиеЛицевыхСчетовСотрудников КАК ЗаявкаНаЗакрытиеЛицевыхСчетовСотрудников
	|		ПО ЗаявкаНаЗакрытиеЛицевыхСчетовСотрудники.Ссылка = ЗаявкаНаЗакрытиеЛицевыхСчетовСотрудников.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ЗарплатныеПроекты КАК ЗарплатныеПроекты
	|		ПО (ЗаявкаНаЗакрытиеЛицевыхСчетовСотрудников.ЗарплатныйПроект = ЗарплатныеПроекты.Ссылка)
	|ГДЕ
	|	ЗаявкаНаЗакрытиеЛицевыхСчетовСотрудники.Ссылка В(&ЗаявкиНаЗакрытиеЛицевыхСчетов)
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗаявкаНаЗакрытиеЛицевыхСчетовСотрудники.Ссылка,
	|	ЗарплатныеПроекты.НомерДоговора,
	|	ЗарплатныеПроекты.ДатаДоговора,
	|	ЗарплатныеПроекты.РасчетныйСчет,
	|	ЗарплатныеПроекты.ОтделениеБанка,
	|	ЗарплатныеПроекты.ФилиалОтделенияБанка,
	|	ЗарплатныеПроекты.Валюта.Код,
	|	ЗарплатныеПроекты.ФорматФайла,
	|	ЗарплатныеПроекты.КодировкаФайла,
	|	ЗарплатныеПроекты.Банк
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ДанныеСотрудников.Ссылка КАК Документ,
	|	&ДатаПолученияДанных КАК Период,
	|	ДанныеСотрудников.Сотрудник КАК Сотрудник,
	|	ДанныеСотрудников.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ДанныеСотрудников.НомерСтроки КАК НомерСтроки,
	|	ДанныеСотрудников.ДатаЗакрытия КАК ДатаЗакрытия,
	|	ДанныеСотрудников.ЛицевойСчет
	|ПОМЕСТИТЬ ВТСписокСотрудников
	|ИЗ
	|	Документ.ЗаявкаНаЗакрытиеЛицевыхСчетовСотрудников.Сотрудники КАК ДанныеСотрудников
	|ГДЕ
	|	ДанныеСотрудников.Ссылка В(&ЗаявкиНаЗакрытиеЛицевыхСчетов)";
	
	Запрос.Выполнить();
	
	ОписательВременныхТаблиц = КадровыйУчет.ОписательВременныхТаблицДляСоздатьВТКадровыеДанныеСотрудников(Запрос.МенеджерВременныхТаблиц, "ВТСписокСотрудников");
	КадровыйУчет.СоздатьВТКадровыеДанныеСотрудников(ОписательВременныхТаблиц, Истина, "Фамилия,Имя,Отчество");
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗаявкиНаЗакрытиеЛицевыхСчетов.Документ КАК Документ,
	|	ЗаявкаНаЗакрытиеЛицевыхСчетовСотрудников.Номер КАК НомерДокумента,
	|	ЗаявкаНаЗакрытиеЛицевыхСчетовСотрудников.НомерРеестра КАК НомерРеестра,
	|	ЗаявкаНаЗакрытиеЛицевыхСчетовСотрудников.Дата КАК ДатаДокумента,
	|	ВЫБОР
	|		КОГДА Организации.НаименованиеПолное ПОДОБНО """"
	|			ТОГДА Организации.Наименование
	|		ИНАЧЕ Организации.НаименованиеПолное
	|	КОНЕЦ КАК ПолноеНаименованиеОрганизации,
	|	Организации.ИНН КАК ИННОрганизации,
	|	ЗаявкиНаЗакрытиеЛицевыхСчетов.НомерДоговора КАК НомерДоговора,
	|	ЗаявкиНаЗакрытиеЛицевыхСчетов.ДатаДоговора КАК ДатаДоговора,
	|	ЗаявкиНаЗакрытиеЛицевыхСчетов.НомерРасчетногоСчетаОрганизации КАК НомерРасчетногоСчетаОрганизации,
	|	ЗаявкиНаЗакрытиеЛицевыхСчетов.ОтделениеБанка КАК ОтделениеБанка,
	|	ЗаявкиНаЗакрытиеЛицевыхСчетов.ФилиалОтделенияБанка КАК ФилиалОтделенияБанка,
	|	ЗаявкиНаЗакрытиеЛицевыхСчетов.КодВалюты КАК КодВалюты,
	|	ЗаявкиНаЗакрытиеЛицевыхСчетов.ФорматФайла КАК ФорматФайла,
	|	ЗаявкиНаЗакрытиеЛицевыхСчетов.КодировкаФайла КАК КодировкаФайла,
	|	КлассификаторБанков.Код КАК БИКБанка,
	|	ЗаявкиНаЗакрытиеЛицевыхСчетов.КоличествоЗаписей КАК КоличествоЗаписей,
	|	ЗаявкиНаЗакрытиеЛицевыхСчетов.СуммаИтого КАК СуммаИтого
	|ИЗ
	|	ВТИтоговыеДанные КАК ЗаявкиНаЗакрытиеЛицевыхСчетов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаявкаНаЗакрытиеЛицевыхСчетовСотрудников КАК ЗаявкаНаЗакрытиеЛицевыхСчетовСотрудников
	|		ПО ЗаявкиНаЗакрытиеЛицевыхСчетов.Документ = ЗаявкаНаЗакрытиеЛицевыхСчетовСотрудников.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
	|		ПО (ЗаявкаНаЗакрытиеЛицевыхСчетовСотрудников.Организация = Организации.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлассификаторБанков КАК КлассификаторБанков
	|		ПО ЗаявкиНаЗакрытиеЛицевыхСчетов.Банк = КлассификаторБанков.Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЗаявкиНаЗакрытиеЛицевыхСчетов.Документ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаявкиНаЗакрытиеЛицевыхСчетов.Документ КАК Документ,
	|	ЗаявкаНаЗакрытиеЛицевыхСчетовСотрудниковСотрудники.НомерСтроки,
	|	ЗаявкаНаЗакрытиеЛицевыхСчетовСотрудниковСотрудники.Сотрудник КАК Сотрудник,
	|	ЗаявкаНаЗакрытиеЛицевыхСчетовСотрудниковСотрудники.ФизическоеЛицо КАК ФизическоеЛицо,
	|	КадровыеДанныеСотрудников.Фамилия КАК Фамилия,
	|	КадровыеДанныеСотрудников.Имя КАК Имя,
	|	КадровыеДанныеСотрудников.Отчество КАК Отчество,
	|	ЗаявкаНаЗакрытиеЛицевыхСчетовСотрудниковСотрудники.ДатаЗакрытия КАК ДатаЗакрытия,
	|	ЗаявкаНаЗакрытиеЛицевыхСчетовСотрудниковСотрудники.ЛицевойСчет КАК ЛицевойСчет,
	|	ЗаявкиНаЗакрытиеЛицевыхСчетов.ОтделениеБанка КАК ОтделениеБанка,
	|	ЗаявкиНаЗакрытиеЛицевыхСчетов.ФилиалОтделенияБанка КАК ФилиалОтделенияБанка,
	|	ЗаявкиНаЗакрытиеЛицевыхСчетов.КодВалюты КАК КодВалюты
	|ИЗ
	|	ВТИтоговыеДанные КАК ЗаявкиНаЗакрытиеЛицевыхСчетов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТСписокСотрудников КАК ЗаявкаНаЗакрытиеЛицевыхСчетовСотрудниковСотрудники
	|		ПО ЗаявкиНаЗакрытиеЛицевыхСчетов.Документ = ЗаявкаНаЗакрытиеЛицевыхСчетовСотрудниковСотрудники.Документ
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКадровыеДанныеСотрудников КАК КадровыеДанныеСотрудников
	|		ПО (ЗаявкаНаЗакрытиеЛицевыхСчетовСотрудниковСотрудники.Сотрудник = КадровыеДанныеСотрудников.Сотрудник)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЗаявкаНаЗакрытиеЛицевыхСчетовСотрудниковСотрудники.Документ,
	|	ЗаявкаНаЗакрытиеЛицевыхСчетовСотрудниковСотрудники.НомерСтроки";
	
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	
	ДанныеДокументов = Новый Соответствие;
	ВыборкаДокументов = РезультатыЗапроса[РезультатыЗапроса.ВГраница()-1].Выбрать();
	ВыборкаСтрокДокументов = РезультатыЗапроса[РезультатыЗапроса.ВГраница()].Выбрать();
	Пока ВыборкаДокументов.Следующий() Цикл
		
		ДанныеДокумента = ДанныеЗаполненияЗакрытияЛицевыхСчетов();
		ЗаполнитьЗначенияСвойств(ДанныеДокумента, ВыборкаДокументов);
		
		ДанныеДокумента.НомерРеестра = СтрЗаменить(ДанныеДокумента.НомерРеестра, Символы.НПП, "");
		ДанныеДокумента.ДанныеРеестра = Новый Структура("Год, НомерРеестра", Год(ДанныеДокумента.ДатаДокумента), ДанныеДокумента.НомерРеестра);
		ДанныеДокумента.ДатаФормирования = ДатаПолученияДанных;
		ДанныеДокумента.ИдПервичногоДокумента = ДанныеДокумента.Документ.УникальныйИдентификатор();
		ДанныеДокумента.ИмяФайла = ОбменСБанкамиПоЗарплатнымПроектам.ИмяФайлаОбменаСБанкамиПоЗарплатнымПроектам(ДанныеДокумента.Документ, ДанныеДокумента.ОтделениеБанка, ДанныеДокумента.НомерРеестра, "u");
		
		ОбменСБанкамиПоЗарплатнымПроектамПереопределяемый.ОпределитьДанныеШапкиДокументаДляПолученияТекстаФайла(ДанныеДокумента, ДанныеДокумента.Документ, ДатаПолученияДанных);
		
		ВыборкаСтрокДокументов.Сбросить();
		Пока ВыборкаСтрокДокументов.НайтиСледующий(ВыборкаДокументов.Документ, "Документ") Цикл
			
			ДанныеСтрокиДокумента = ДанныеЗаполненияСтрокиЗакрытияЛицевыхСчетов();
			ОбменСБанкамиПоЗарплатнымПроектамПереопределяемый.ДополнитьКолонкиДанныхСтрокДокументов(ДанныеСтрокиДокумента);
			
			ЗаполнитьЗначенияСвойств(ДанныеСтрокиДокумента, ВыборкаСтрокДокументов);
			ОбменСБанкамиПоЗарплатнымПроектамПереопределяемый.ЗаполнитьКолонкиДанныхСтрокДокумента(ДанныеСтрокиДокумента);
			
			ДанныеДокумента.Сотрудники.Добавить(ДанныеСтрокиДокумента);
			
		КонецЦикла;
		
		ОбменСБанкамиПоЗарплатнымПроектамПереопределяемый.ОпределитьДанныеСтрокДокументовДляПолученияТекстаФайла(ДанныеДокумента, ДатаПолученияДанных);
		
		ДанныеДокументов.Вставить(ВыборкаДокументов.Документ, ДанныеДокумента);
		
	КонецЦикла;
	
	Возврат ДанныеДокументов;
	
КонецФункции

// Возвращает структуру документа, используемую для формирования файла обмена, печатного документа.
//
Функция ДанныеЗаполненияЗакрытияЛицевыхСчетов()
	
	ДанныеЗаполнения = Новый Структура();
	ДанныеЗаполнения.Вставить("Документ", Документы.ЗаявкаНаОткрытиеЛицевыхСчетовСотрудников.ПустаяСсылка());
	ДанныеЗаполнения.Вставить("НомерДокумента", "");
	ДанныеЗаполнения.Вставить("НомерРеестра", "");
	ДанныеЗаполнения.Вставить("ДатаДокумента", Дата("00010101"));
	ДанныеЗаполнения.Вставить("ПолноеНаименованиеОрганизации", "");
	ДанныеЗаполнения.Вставить("ИННОрганизации", "");
	ДанныеЗаполнения.Вставить("НомерДоговора", "");
	ДанныеЗаполнения.Вставить("ДатаДоговора", Дата("00010101"));
	ДанныеЗаполнения.Вставить("НомерРасчетногоСчетаОрганизации", "");
	ДанныеЗаполнения.Вставить("ОтделениеБанка", "");
	ДанныеЗаполнения.Вставить("ФилиалОтделенияБанка", "");
	ДанныеЗаполнения.Вставить("КодВалюты", "");
	ДанныеЗаполнения.Вставить("ФорматФайла", Перечисления.ФорматыФайловОбменаПоЗарплатномуПроекту.ПустаяСсылка());
	ДанныеЗаполнения.Вставить("КодировкаФайла", Перечисления.КодировкаФайловОбменаПоЗарплатномуПроекту.ПустаяСсылка());
	ДанныеЗаполнения.Вставить("БИКБанка", "");
	ДанныеЗаполнения.Вставить("КоличествоЗаписей", 0);
	ДанныеЗаполнения.Вставить("СуммаИтого", 0);
	ДанныеЗаполнения.Вставить("ИдПервичногоДокумента", "");
	ДанныеЗаполнения.Вставить("ДатаФормирования", Дата("00010101"));
	ДанныеЗаполнения.Вставить("ИмяФайла", "");
	ДанныеЗаполнения.Вставить("ДанныеРеестра", "");
	
	ДанныеЗаполнения.Вставить("Сотрудники", Новый Массив);
	
	Возврат ДанныеЗаполнения;
	
КонецФункции

// Возвращает структуру строки документа, используемую для формирования файла обмена, печатного документа.
//
Функция ДанныеЗаполненияСтрокиЗакрытияЛицевыхСчетов()
	
	ДанныеЗаполнения = Новый Структура();
	ДанныеЗаполнения.Вставить("Сотрудник", Справочники.Сотрудники.ПустаяСсылка());
	ДанныеЗаполнения.Вставить("ФизическоеЛицо", Справочники.ФизическиеЛица.ПустаяСсылка());
	ДанныеЗаполнения.Вставить("НомерСтроки", 0);
	ДанныеЗаполнения.Вставить("Фамилия", "");
	ДанныеЗаполнения.Вставить("Имя", "");
	ДанныеЗаполнения.Вставить("Отчество", "");
	ДанныеЗаполнения.Вставить("ДатаЗакрытия", Дата("00010101"));
	ДанныеЗаполнения.Вставить("ЛицевойСчет", "");
	ДанныеЗаполнения.Вставить("ОтделениеБанка", "");
	ДанныеЗаполнения.Вставить("ФилиалОтделенияБанка", "");
	ДанныеЗаполнения.Вставить("КодВалюты", "");
	
	Возврат ДанныеЗаполнения;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли