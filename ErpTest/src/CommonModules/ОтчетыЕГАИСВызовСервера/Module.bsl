
#Область СлужебныйПрограммныйИнтерфейс

// Возвращает структуру параметров и отборов расшифровки
// Параметры:
//   Расшифровка            - ИдентификаторРасшифровкиКомпоновкиДанных - значение, полученное из отчета при расшифровке.
//   АдресДанныхРасшифровки - Строка - адрес, указывающий на значение во временном хранилище.
//   СписокПараметров       - Массив - содержит имена параметров и полей, используемых при расшифровке
//   ПоляРасшифровки        - Строка - содержит имена полей, используемых при расшифровке.
//
// Возвращаемое значение:
//   Структура - в качестве ключа возвращается имя параметра или отбора для отчета-приемника,
//               а в качестве значения - значение параметра или отбора.
//
Функция ПараметрыФормыРасшифровки(Расшифровка, АдресДанныхРасшифровки, СписокПараметров, ПоляРасшифровки) Экспорт

	ПараметрыФормыРасшифровки = Новый Структура;
	
	ДанныеРасшифровки = ПолучитьИзВременногоХранилища(АдресДанныхРасшифровки);
	
	ПроверкаПолейРасшифровки = Новый ТаблицаЗначений;
	ПроверкаПолейРасшифровки.Колонки.Добавить("Значение");
	ПроверкаПолейРасшифровки.Колонки.Добавить("ИмяПоля");
	
	ДобавитьРодителей(ДанныеРасшифровки.Элементы[Расшифровка], ПроверкаПолейРасшифровки);
	
	Для Каждого ДанныеПоля Из ПроверкаПолейРасшифровки Цикл
		ИмяПоля = СтрЗаменить(ДанныеПоля.ИмяПоля, ".", "_");
		Если ПоляРасшифровки.Найти(ИмяПоля) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Если ПараметрыФормыРасшифровки.Свойство(ИмяПоля) Тогда
			ПараметрыФормыРасшифровки.Вставить(ИмяПоля + "_Родитель", ДанныеПоля.Значение);
		Иначе
			ПараметрыФормыРасшифровки.Вставить(ИмяПоля, ДанныеПоля.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого ИмяПараметра Из СписокПараметров Цикл
		ЗначениеПараметра = ДанныеРасшифровки.Настройки.ПараметрыДанных.Элементы.Найти(ИмяПараметра);
		Если ЗначениеПараметра = Неопределено ИЛИ НЕ ЗначениеПараметра.Использование Тогда
			Продолжить;
		КонецЕсли;
		ПараметрыФормыРасшифровки.Вставить(ИмяПараметра, ЗначениеПараметра.Значение);
	КонецЦикла; 
	
	ПараметрыФормыРасшифровки.Вставить("Отбор", ДанныеРасшифровки.Настройки.Отбор);
	
	Возврат ПараметрыФормыРасшифровки;
	
КонецФункции

// Подготавливает данные запросов в ЕГАИС из переданного массива расшифровок.
//
// Параметры:
//  МассивРасшифровок - Массив - массив расшифровок выделенной области,
//  АдресДанныхРасшифровки - Строка - адрес, указывающий на значение во временном хранилище.
//
// Возвращаемое значение:
//  Массив - подготовленные данные.
//
Функция ПодготовитьДанныеЗапросовИзМассиваРасшифровок(МассивРасшифровок, АдресДанныхРасшифровки) Экспорт
	
	ТаблицаЗапросов = Новый ТаблицаЗначений;
	ТаблицаЗапросов.Колонки.Добавить("ОрганизацияЕГАИС");
	ТаблицаЗапросов.Колонки.Добавить("Операция");
	ТаблицаЗапросов.Колонки.Добавить("ИмяПараметра");
	ТаблицаЗапросов.Колонки.Добавить("ЗначениеПараметра");
	
	Для Каждого Расшифровка Из МассивРасшифровок Цикл
		
		ПоляРасшифровки = Новый Массив;
		ПоляРасшифровки.Добавить("ОрганизацияЕГАИС");
		ПоляРасшифровки.Добавить("ИдентификаторЕГАИС");
		ПоляРасшифровки.Добавить("КодГрузоотправителя");
		
		СтруктураРасшифровки = ПараметрыФормыРасшифровки(Расшифровка, АдресДанныхРасшифровки, Новый Массив, ПоляРасшифровки);
		
		Если НЕ СтруктураРасшифровки.Свойство("ОрганизацияЕГАИС") ИЛИ НЕ ЗначениеЗаполнено(СтруктураРасшифровки.ОрганизацияЕГАИС) Тогда
			Продолжить;
		КонецЕсли;
		
		Если СтруктураРасшифровки.Свойство("ИдентификаторЕГАИС") И ЗначениеЗаполнено(СтруктураРасшифровки.ИдентификаторЕГАИС) Тогда
			СтрокаТаблицы = ТаблицаЗапросов.Добавить();
			СтрокаТаблицы.ОрганизацияЕГАИС  = СтруктураРасшифровки.ОрганизацияЕГАИС;
			СтрокаТаблицы.Операция          = Перечисления.ВидыДокументовЕГАИС.ЗапросТТН;
			СтрокаТаблицы.ЗначениеПараметра = СтруктураРасшифровки.ИдентификаторЕГАИС;
		КонецЕсли;
		
		Если СтруктураРасшифровки.Свойство("КодГрузоотправителя") И ЗначениеЗаполнено(СтруктураРасшифровки.КодГрузоотправителя) Тогда
			СтрокаТаблицы = ТаблицаЗапросов.Добавить();
			СтрокаТаблицы.ОрганизацияЕГАИС  = СтруктураРасшифровки.ОрганизацияЕГАИС;
			СтрокаТаблицы.Операция          = Перечисления.ВидыДокументовЕГАИС.ЗапросДанныхОрганизации;
			СтрокаТаблицы.ИмяПараметра      = "СИО";
			СтрокаТаблицы.ЗначениеПараметра = СтруктураРасшифровки.КодГрузоотправителя;
		КонецЕсли;
		
		Если СтруктураРасшифровки.Свойство("КодАлкогольнойПродукции") И ЗначениеЗаполнено(СтруктураРасшифровки.КодАлкогольнойПродукции) Тогда
			СтрокаТаблицы = ТаблицаЗапросов.Добавить();
			СтрокаТаблицы.ОрганизацияЕГАИС  = СтруктураРасшифровки.ОрганизацияЕГАИС;
			СтрокаТаблицы.Операция          = Перечисления.ВидыДокументовЕГАИС.ЗапросАлкогольнойПродукции;
			СтрокаТаблицы.ИмяПараметра      = "КОД";
			СтрокаТаблицы.ЗначениеПараметра = СтруктураРасшифровки.КодАлкогольнойПродукции;
		КонецЕсли;
		
	КонецЦикла;
	
	ТаблицаЗапросов.Свернуть("ОрганизацияЕГАИС, Операция, ИмяПараметра, ЗначениеПараметра");
	
	Результат = Новый Массив;
	
	Для Каждого СтрокаТаблицы Из ТаблицаЗапросов Цикл
		
		ПараметрыЗапроса = Новый Структура;
		ПараметрыЗапроса.Вставить("Операция"         , СтрокаТаблицы.Операция);
		ПараметрыЗапроса.Вставить("ИмяПараметра"     , СтрокаТаблицы.ИмяПараметра);
		ПараметрыЗапроса.Вставить("ЗначениеПараметра", СтрокаТаблицы.ЗначениеПараметра);
		ПараметрыЗапроса.Вставить("ОрганизацияЕГАИС" , СтрокаТаблицы.ОрганизацияЕГАИС);
		
		Результат.Добавить(ПараметрыЗапроса);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Подготавливает данные запросов в ЕГАИС из переданной схемы компоновки данных.
//
// Параметры:
//  КомпоновщикНастроек - КомпоновщикНастроекКомпоновкиДанных - компоновщик настроек отчета,
//  АдресСхемы - Строка - адрес, указывающий на значение во временном хранилище.
//
// Возвращаемое значение:
//  Массив - подготовленные данные.
//
Функция ПодготовитьДанныеЗапросовИзСхемыКомпоновкиДанных(КомпоновщикНастроек, АдресСхемы) Экспорт
	
	СхемаКомпоновкиДанных = ПолучитьИзВременногоХранилища(АдресСхемы);
	
	НастройкиКомпоновки = КомпоновщикНастроек.ПолучитьНастройки();
	НастройкиКомпоновки.Выбор.Элементы.Очистить();
	
	ВыбранноеПоле = НастройкиКомпоновки.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ВыбранноеПоле.Использование = Истина;
	ВыбранноеПоле.Поле = Новый ПолеКомпоновкиДанных("ОрганизацияЕГАИС");
	
	ВыбранноеПоле = НастройкиКомпоновки.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ВыбранноеПоле.Использование = Истина;
	ВыбранноеПоле.Поле = Новый ПолеКомпоновкиДанных("ИдентификаторЕГАИС");
	
	ВыбранноеПоле = НастройкиКомпоновки.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ВыбранноеПоле.Использование = Истина;
	ВыбранноеПоле.Поле = Новый ПолеКомпоновкиДанных("ТТН.ИдентификаторЕГАИС");
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиКомпоновки,,, Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ТаблицаОтчета = ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных, Истина);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаОтчета", ТаблицаОтчета);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаОтчета.ИдентификаторЕГАИС КАК ИдентификаторЕГАИС,
	|	ТаблицаОтчета.ТТНИдентификаторЕГАИС КАК ТТНИдентификаторЕГАИС,
	|	ТаблицаОтчета.ОрганизацияЕГАИС КАК ОрганизацияЕГАИС
	|ПОМЕСТИТЬ ТаблицаОтчета
	|ИЗ
	|	&ТаблицаОтчета КАК ТаблицаОтчета
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаОтчета.ИдентификаторЕГАИС КАК ИдентификаторЕГАИС,
	|	ТаблицаОтчета.ОрганизацияЕГАИС КАК ОрганизацияЕГАИС
	|ИЗ
	|	ТаблицаОтчета КАК ТаблицаОтчета
	|ГДЕ
	|	ЕСТЬNULL(ТаблицаОтчета.ИдентификаторЕГАИС, """") <> """"
	|	И ЕСТЬNULL(ТаблицаОтчета.ТТНИдентификаторЕГАИС, """") = """"";
	
	Результат = Новый Массив;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ПараметрыЗапроса = Новый Структура;
		ПараметрыЗапроса.Вставить("Операция"         , Перечисления.ВидыДокументовЕГАИС.ЗапросТТН);
		ПараметрыЗапроса.Вставить("ОрганизацияЕГАИС" , Выборка.ОрганизацияЕГАИС);
		ПараметрыЗапроса.Вставить("ЗначениеПараметра", Выборка.ИдентификаторЕГАИС);
		
		Результат.Добавить(ПараметрыЗапроса);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДобавитьРодителей(ЭлементРасшифровки, ПроверкаПолейРасшифровки)
	
	Если ТипЗнч(ЭлементРасшифровки) = Тип("ЭлементРасшифровкиКомпоновкиДанныхПоля") Тогда
		Для каждого Поле Из ЭлементРасшифровки.ПолучитьПоля() Цикл
			Отбор = Новый Структура("Значение, ИмяПоля", Поле.Значение, Поле.Поле); 
			НайденныеСтроки = ПроверкаПолейРасшифровки.НайтиСтроки(Отбор);
			
			Если НайденныеСтроки.Количество() = 0 Тогда
				НовоеПоле = ПроверкаПолейРасшифровки.Добавить();
				НовоеПоле.Значение = Поле.Значение;
				НовоеПоле.ИмяПоля = Поле.Поле;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Для Каждого Родитель Из ЭлементРасшифровки.ПолучитьРодителей() Цикл
		ДобавитьРодителей(Родитель, ПроверкаПолейРасшифровки);
	КонецЦикла;
	
КонецФункции

#КонецОбласти