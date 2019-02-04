
#Область ПрограммныйИнтерфейс

// Возвращает направление деятельности по заданной ссылке
//
// Параметры:
// 		Ссылка - СправочникСсылка - Ссылка на справочник, по которой необходимо получить направление деятельности.
//
// Возвращаемое значение:
// 		СправочникСсылка.НаправленияДеятельности - Ссылка на элемент справочника направлений деятельности.
//
Функция НаправлениеДеятельности(Ссылка) Экспорт
	
	ВозвращаемоеЗначение = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "НаправлениеДеятельности");
	Возврат ?(ЗначениеЗаполнено(ВозвращаемоеЗначение), ВозвращаемоеЗначение, Справочники.НаправленияДеятельности.ПустаяСсылка());
	
КонецФункции

// Формирует данные выбора основных средств.
//
// Параметры:
//  Параметры			 - Структура - Содержит параметры выбора.
//  СтандартнаяОбработка - Булево - Параметр события ОбработкаПолученияДанныхВыбора.
// 
// Возвращаемое значение:
//  СписокЗначений - Значения для выбора.
//
Функция ДанныеВыбораОбъектовЭксплуатации(Параметры, СтандартнаяОбработка) Экспорт

	ДанныеВыбора = Неопределено;
	
	Если ДоступенВыборОбъектовЭксплуатации2_4(Параметры) Тогда
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = ДанныеВыбораОбъектовЭксплуатации2_4(Параметры);
	Иначе
		ДанныеВыбораОбъектовЭксплуатации2_2(Параметры);
	КонецЕсли;
	
	Возврат ДанныеВыбора;

КонецФункции

// Формирует данные выбора нематериальных активов.
//
// Параметры:
//  Параметры			 - Структура - Содержит параметры выбора.
//  СтандартнаяОбработка - Булево - Параметр события ОбработкаПолученияДанныхВыбора.
// 
// Возвращаемое значение:
//  СписокЗначений - Значения для выбора.
//
Функция ДанныеВыбораНематериальныхАктивов(Параметры, СтандартнаяОбработка) Экспорт

	ДанныеВыбора = Неопределено;
	
	Если ДоступенВыборНематериальныхАктивов2_4(Параметры) Тогда
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = ДанныеВыбораНематериальныхАктивов2_4(Параметры);
	Иначе
		ДанныеВыбораНематериальныхАктивов2_2(Параметры);
	КонецЕсли;
	
	Возврат ДанныеВыбора;

КонецФункции

// Проверяет заполнение переданных объектов
//
// Параметры:
//  МассивСсылок			 - Массив	 - Список объектов заполнение которых требуется проверить.
//  ЕстьПомеченныеНаУдаление - Булево	 - (возвращаемое значение) Истина, если есть помеченные на удаление документы.
// 
// Возвращаемое значение:
//  Булево - Истина, если нет ошибок.
//
Функция ПроверитьВозможностьПроведения(МассивСсылок, ЕстьПомеченныеНаУдаление) Экспорт

	Отказ = Ложь;
	Для каждого СсылкаНаОбъект Из МассивСсылок Цикл
		ДанныеОбъект = СсылкаНаОбъект.ПолучитьОбъект();
		Если ДанныеОбъект.ПометкаУдаления Тогда
			ЕстьПомеченныеНаУдаление = Истина;
		Иначе
			Отказ = НЕ ДанныеОбъект.ПроверитьЗаполнение() ИЛИ Отказ;
		КонецЕсли; 
	КонецЦикла;
	
	Возврат НЕ Отказ;

КонецФункции

#Область ОтборыПоДаннымУчета

// Возвращает массив элементов справочника по заданному в параметрах отбору
//
// Параметры:
// 		Параметры - Структура - Структура в формате одноименного параметра процедуры "ОбработкаПолученияДанныхВыбора" модуля менеджера справочника.
//
// Возвращаемое значение:
// 		Массив - Массив ссылок
//
Функция ЭлементыНМАПоОтборуБУ(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Активы.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.НематериальныеАктивы КАК Активы
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПервоначальныеСведенияНМАБухгалтерскийУчет.СрезПоследних(&ДатаСведений, Регистратор <> &ТекущийРегистратор) КАК ПервоначальныеСведенияНМАБухгалтерскийУчетСрезПоследних
	|		ПО Активы.Ссылка = ПервоначальныеСведенияНМАБухгалтерскийУчетСрезПоследних.НематериальныйАктив
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияНМАОрганизаций.СрезПоследних(&ДатаСведений, Регистратор <> &ТекущийРегистратор) КАК СостоянияНМАОрганизацийСрезПоследних
	|		ПО Активы.Ссылка = СостоянияНМАОрганизацийСрезПоследних.НематериальныйАктив
	|ГДЕ
	|	ИСТИНА
	|	И (НЕ &ТребуетсяБУОрганизация
	|			ИЛИ ЕСТЬNULL(ПервоначальныеСведенияНМАБухгалтерскийУчетСрезПоследних.Организация, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)) В (&БУОрганизация))
	|	И (НЕ &ТребуетсяБУСостояние
	|			ИЛИ ЕСТЬNULL(СостоянияНМАОрганизацийСрезПоследних.Состояние, ЗНАЧЕНИЕ(Перечисление.ВидыСостоянийНМА.НеПринятКУчету)) В (&БУСостояние))";
	
	ПоляОтбора = Новый Структура("БУОрганизация, БУСостояние, ТекущийРегистратор, ДатаСведений");
	ПоляОтбора.ДатаСведений = ТекущаяДатаСеанса();
	ЗаполнитьЗначенияСвойств(ПоляОтбора, Параметры);
	Если Параметры.Свойство("Отбор") Тогда
		ЗаполнитьЗначенияСвойств(ПоляОтбора, Параметры.Отбор);
	КонецЕсли;
	
	Для Каждого КлючИЗначение Из ПоляОтбора Цикл
		Запрос.УстановитьПараметр("Требуется"+КлючИЗначение.Ключ, ЗначениеЗаполнено(КлючИЗначение.Значение));
		Запрос.УстановитьПараметр(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Справочники.НематериальныеАктивы.ПустаяСсылка();
	КонецЕсли;
	
	Возврат Результат.Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции

// Возвращает массив элементов справочника по заданному в параметрах отбору
//
// Параметры:
// 		Параметры - Структура - Структура в формате одноименного параметра процедуры "ОбработкаПолученияДанныхВыбора" модуля менеджера справочника.
//
// Возвращаемое значение:
// 		Массив - Массив ссылок
//
Функция ЭлементыОСПоОтборуБУ(Параметры) Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Активы.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ОбъектыЭксплуатации КАК Активы
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПервоначальныеСведенияОСБухгалтерскийУчет.СрезПоследних(&ДатаСведений, Регистратор <> &ТекущийРегистратор) КАК ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних
	|		ПО Активы.Ссылка = ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних.ОсновноеСредство
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияОСОрганизаций.СрезПоследних(&ДатаСведений, Регистратор <> &ТекущийРегистратор) КАК СостоянияОСОрганизацийСрезПоследних
	|		ПО Активы.Ссылка = СостоянияОСОрганизацийСрезПоследних.ОсновноеСредство
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МестонахождениеОСБухгалтерскийУчет.СрезПоследних(&ДатаСведений, Регистратор <> &ТекущийРегистратор) КАК МестонахождениеОСБухгалтерскийУчетСрезПоследних
	|		ПО Активы.Ссылка = МестонахождениеОСБухгалтерскийУчетСрезПоследних.ОсновноеСредство
	|ГДЕ
	|	ИСТИНА
	|	И (НЕ &ТребуетсяБУОрганизация
	|			ИЛИ ЕСТЬNULL(ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних.Организация,ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)) В (&БУОрганизация))
	|	И (НЕ &ТребуетсяБУПодразделение
	|			ИЛИ ЕСТЬNULL(МестонахождениеОСБухгалтерскийУчетСрезПоследних.Местонахождение, ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка)) В (&БУПодразделение))
	|	И (НЕ &ТребуетсяБУСостояние
	|			ИЛИ ЕСТЬNULL(СостоянияОСОрганизацийСрезПоследних.Состояние,ЗНАЧЕНИЕ(Перечисление.СостоянияОС.НеПринятоКУчету)) В (&БУСостояние))
	|	И (НЕ &ТребуетсяБУГруппаОС
	|			ИЛИ Активы.ГруппаОС В (&БУГруппаОС))
	|	И (НЕ &ТребуетсяБУАмортизационнаяГруппа
	|			ИЛИ Активы.АмортизационнаяГруппа В (&БУАмортизационнаяГруппа))";
	
	Если Параметры.Свойство("Отбор")
		И Параметры.Отбор.Свойство("ВидНалога") Тогда
		
		ТекстЗапроса = ТекстЗапроса 
			+ "И " + ВнеоборотныеАктивыЛокализация.УсловияОтбораПоВидуНалога("Активы");
	КонецЕсли; 
	
	ПоляОтбора = Новый Структура("БУОрганизация, БУПодразделение, БУСостояние, БУГруппаОС, БУАмортизационнаяГруппа, ТекущийРегистратор, ДатаСведений, ВидНалога");
	ПоляОтбора.ДатаСведений = ТекущаяДатаСеанса();
	ЗаполнитьЗначенияСвойств(ПоляОтбора, Параметры);
	Если Параметры.Свойство("Отбор") Тогда
		ЗаполнитьЗначенияСвойств(ПоляОтбора, Параметры.Отбор);
	КонецЕсли;
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Для Каждого КлючИЗначение Из ПоляОтбора Цикл
		Запрос.УстановитьПараметр("Требуется"+КлючИЗначение.Ключ, ЗначениеЗаполнено(КлючИЗначение.Значение));
		Запрос.УстановитьПараметр(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Справочники.ОбъектыЭксплуатации.ПустаяСсылка();
	КонецЕсли;
	
	Возврат Новый ФиксированныйМассив(Результат.Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
КонецФункции

//++ НЕ УТКА

// Возвращает массив элементов справочника по заданному в параметрах отбору
//
// Параметры:
// 		Параметры - Структура - Структура в формате одноименного параметра процедуры "ОбработкаПолученияДанныхВыбора" модуля менеджера справочника.
//
// Возвращаемое значение:
// 		Массив - Массив ссылок
//
Функция ЭлементыНМАПоОтборуМФУ(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Активы.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.НематериальныеАктивы КАК Активы
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НематериальныеАктивыМеждународныйУчет.СрезПоследних(&ДатаСведений, Регистратор <> &ТекущийРегистратор) КАК ДанныеУчета
	|		ПО Активы.Ссылка = ДанныеУчета.НематериальныйАктив
	|ГДЕ
	|	ИСТИНА
	|	И (НЕ &ТребуетсяМФУОрганизация
	|			ИЛИ ЕСТЬNULL(ДанныеУчета.Организация, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)) В (&МФУОрганизация))
	|	И (НЕ &ТребуетсяМФУПодразделение
	|			ИЛИ ЕСТЬNULL(ДанныеУчета.Подразделение, ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка)) В (&МФУПодразделение))
	|	И (НЕ &ТребуетсяМФУСостояние
	|			ИЛИ ЕСТЬNULL(ДанныеУчета.Состояние, ЗНАЧЕНИЕ(Перечисление.ВидыСостоянийНМА.НеПринятКУчету)) В (&МФУСостояние))";
	
	ПоляОтбора = Новый Структура("МФУОрганизация, МФУПодразделение, МФУСостояние, ТекущийРегистратор, ДатаСведений");
	ПоляОтбора.ДатаСведений = ТекущаяДатаСеанса();
	ЗаполнитьЗначенияСвойств(ПоляОтбора, Параметры);
	Если Параметры.Свойство("Отбор") Тогда
		ЗаполнитьЗначенияСвойств(ПоляОтбора, Параметры.Отбор);
	КонецЕсли;
	
	Для Каждого КлючИЗначение Из ПоляОтбора Цикл
		Запрос.УстановитьПараметр("Требуется"+КлючИЗначение.Ключ, ЗначениеЗаполнено(КлючИЗначение.Значение));
		Запрос.УстановитьПараметр(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Справочники.НематериальныеАктивы.ПустаяСсылка();
	КонецЕсли;
	
	Возврат Результат.Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции

// Возвращает массив элементов справочника по заданному в параметрах отбору
//
// Параметры:
// 		Параметры - Структура - Структура в формате одноименного параметра процедуры "ОбработкаПолученияДанныхВыбора" модуля менеджера справочника.
//
// Возвращаемое значение:
// 		Массив - Массив ссылок
//
Функция ЭлементыОСПоОтборуМФУ(Параметры) Экспорт
	
	ЗаполнитьОтборыОСМФУ(Параметры);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Активы.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ОбъектыЭксплуатации КАК Активы
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОсновныеСредстваМеждународныйУчет.СрезПоследних(&ДатаСведений, Регистратор <> &ТекущийРегистратор) КАК ДанныеУчета
	|		ПО Активы.Ссылка = ДанныеУчета.ОсновноеСредство
	|ГДЕ
	|	ИСТИНА
	|	И (НЕ &ТребуетсяМФУОрганизация
	|			ИЛИ ЕСТЬNULL(ДанныеУчета.Организация, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)) В (&МФУОрганизация))
	|	И (НЕ &ТребуетсяМФУПодразделение
	|			ИЛИ ЕСТЬNULL(ДанныеУчета.Подразделение, ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка)) В (&МФУПодразделение))
	|	И (НЕ &ТребуетсяМФУСостояние
	|			ИЛИ ЕСТЬNULL(ДанныеУчета.Состояние, ЗНАЧЕНИЕ(Перечисление.СостоянияОС.НеПринятоКУчету)) В (&МФУСостояние))
	|	И (НЕ &ТребуетсяМФУВидАктива
	|			ИЛИ ЕСТЬNULL(ДанныеУчета.ВидАктива, ЗНАЧЕНИЕ(Перечисление.ВидыВнеоборотныхАктивов.ПустаяСсылка)) В (&МФУВидАктива))";
	
	ПоляОтбора = Новый Структура("МФУОрганизация, МФУПодразделение, МФУСостояние, МФУВидАктива, ТекущийРегистратор, ДатаСведений");
	ПоляОтбора.ДатаСведений = ТекущаяДатаСеанса();
	ЗаполнитьЗначенияСвойств(ПоляОтбора, Параметры);
	Если Параметры.Свойство("Отбор") Тогда
		ЗаполнитьЗначенияСвойств(ПоляОтбора, Параметры.Отбор);
	КонецЕсли;
	
	Для Каждого КлючИЗначение Из ПоляОтбора Цикл
		Запрос.УстановитьПараметр("Требуется"+КлючИЗначение.Ключ, ЗначениеЗаполнено(КлючИЗначение.Значение));
		Запрос.УстановитьПараметр(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Справочники.ОбъектыЭксплуатации.ПустаяСсылка();
	КонецЕсли;
	
	Возврат Результат.Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции

// Инициализирует параметры обработчика получения данных выбора
//
// Параметры:
// 		Параметры - Структура - Структура в формате одноименного параметра процедуры "ОбработкаПолученияДанныхВыбора" модуля менеджера справочника.
//
Процедура ЗаполнитьОтборыОСМФУ(Параметры) Экспорт
	
	Если Не Параметры.Свойство("Отбор") Тогда
		Параметры.Вставить("Отбор", Новый Структура)
	КонецЕсли;
	
	ВидОС = Перечисления.ВидыВнеоборотныхАктивов.ОсновноеСредство;
	ВидИИ = Перечисления.ВидыВнеоборотныхАктивов.ИнвестиционноеИмущество;
	
	Если Параметры.Свойство("МФУНаправлениеПеревода") Тогда
		Если Параметры.МФУНаправлениеПеревода = ВидОС Тогда
			Параметры.Отбор.Вставить("МФУВидАктива", ВидИИ);
		Иначе
			Параметры.Отбор.Вставить("МФУВидАктива", ВидОС);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

//-- НЕ УТКА

// Возвращает список значений показателями наработок, принадлежащих классу объектов эксплуатации.
//
// Параметры:
// 		ОбъектОтбора - СправочникСсылка.ОбъектыЭксплуатации, СправочникСсылка.УзлыОбъектаЭксплуатации, СправочникСсылка.КлассыОбъектовЭксплуатации - Объект отбора
// 		ПолучатьИсточникиНаработки - Булево - Признак необходимости получать показатели регистрируемые от источника
// 		ПоказательАмортизации - СправочникСсылка.ПоказателиНаработки - Текущее значение.
//
// Возвращаемое значение:
// 		СписокЗначений - Список данных выбора.
//
Функция ДанныеВыбораПоказателейНаработкиПоОтбору(Знач ОбъектОтбора, ПолучатьИсточникиНаработки, ПоказательАмортизации) Экспорт
	
	ДанныеВыбора = Новый СписокЗначений;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"
	//++ НЕ УТКА
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	&ОбъектОтбора КАК Класс
	|ПОМЕСТИТЬ Классы
	|ГДЕ
	|	&ИспользоватьУправлениеРемонтами
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Объекты.Класс
	|ИЗ
	|	Справочник.ОбъектыЭксплуатации КАК Объекты
	|ГДЕ
	|	Объекты.Ссылка = &ОбъектОтбора
	|	И &ИспользоватьУправлениеРемонтами
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Узлы.Класс
	|ИЗ
	|	Справочник.УзлыОбъектовЭксплуатации КАК Узлы
	|ГДЕ
	|	Узлы.Ссылка = &ОбъектОтбора
	|	И &ИспользоватьУправлениеРемонтами
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ПоказателиНаработки.ПоказательНаработки КАК ПоказательНаработки,
	|	ПоказателиНаработки.РегистрироватьОтИсточника КАК РегистрироватьОтИсточника
	|ПОМЕСТИТЬ Показатели
	|ИЗ
	|	Справочник.КлассыОбъектовЭксплуатации.ПоказателиНаработки КАК ПоказателиНаработки
	|ГДЕ
	|	ПоказателиНаработки.Ссылка В
	|			(ВЫБРАТЬ
	|				Классы.Класс
	|			ИЗ
	|				Классы)
	|	И ВЫБОР
	|			КОГДА &ПолучатьИсточникиНаработки
	|				ТОГДА НЕ ПоказателиНаработки.РегистрироватьОтИсточника
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	//-- НЕ УТКА
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПервоначальныеСведенияОС.ПоказательНаработки КАК Значение,
	|	ПервоначальныеСведенияОС.ПоказательНаработки.ПометкаУдаления КАК ПометкаУдаления
	|ИЗ
	|	РегистрСведений.ПервоначальныеСведенияОСБухгалтерскийУчет.СрезПоследних(
	|			,
	|			ОсновноеСредство = &ОбъектОтбора
	//++ НЕ УТКА
	|				И НЕ ПоказательНаработки В
	|						(ВЫБРАТЬ
	|							Показатели.ПоказательНаработки
	|						ИЗ
	|							Показатели КАК Показатели)
	//-- НЕ УТКА
	|	) КАК ПервоначальныеСведенияОС
	|ГДЕ
	|	НЕ &ПоказательАмортизации
	//++ НЕ УТКА
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Показатели.ПоказательНаработки,
	|	Показатели.ПоказательНаработки.ПометкаУдаления
	|ИЗ
	|	Показатели КАК Показатели
	|ГДЕ
	|	ВЫБОР
	|			КОГДА &ПолучатьИсточникиНаработки
	|				ТОГДА НЕ Показатели.РегистрироватьОтИсточника
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ
	//-- НЕ УТКА
	|";
	
	Запрос.УстановитьПараметр("ОбъектОтбора", ОбъектОтбора);
	Запрос.УстановитьПараметр("ПолучатьИсточникиНаработки", ПолучатьИсточникиНаработки);
	Запрос.УстановитьПараметр("ПоказательАмортизации", ПоказательАмортизации);
	Запрос.УстановитьПараметр("ИспользоватьУправлениеРемонтами", ПолучитьФункциональнуюОпцию("ИспользоватьУправлениеРемонтами"));
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат ДанныеВыбора;
	КонецЕсли;
	
	ШаблонПолейСтруктуры = "Значение, ПометкаУдаления";
	
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		СтруктураЭлемента = Новый Структура(ШаблонПолейСтруктуры);
		ЗаполнитьЗначенияСвойств(СтруктураЭлемента, Выборка);
		ДанныеВыбора.Добавить(СтруктураЭлемента);
		
	КонецЦикла;
	
	Возврат ДанныеВыбора;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция ДоступенВыборОбъектовЭксплуатации2_4(Параметры) Экспорт

	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьВнеоборотныеАктивы2_4") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Параметры.Свойство("Контекст") 
		И СтрНайти(Параметры.Контекст, "УУ") = 0 Тогда
		
		// Если в параметрах выбора нет УУ то форма не поддерживает выбор 2.4
		ДоступенВыбор = Ложь;
		
	ИначеЕсли ПолучитьФункциональнуюОпцию("ИспользоватьВнеоборотныеАктивы2_2") Тогда
	
		ДатаНачалаУчета = Константы.ДатаНачалаУчетаВнеоборотныхАктивов2_4.Получить();
		
		// Если в параметрах выбора есть МФУ, то форма поддерживает выбор 2.2 и 2.4 и Нужно по дате сведений определить какая
		// форма нужна. Если в параметрах выбора нет МФУ, то форма поддерживает только выбор 2.4.
		ДоступенВыбор = 
			Параметры.Свойство("Контекст") 
				И СтрНайти(Параметры.Контекст, "МФУ") = 0
			ИЛИ НЕ Параметры.Свойство("ДатаСведений")
				И ТекущаяДатаСеанса() >= ДатаНачалаУчета 
			ИЛИ Параметры.Свойство("ДатаСведений")
				И Параметры.ДатаСведений >= ДатаНачалаУчета;
	Иначе
		ДоступенВыбор = Истина;
	КонецЕсли;
			
	Если НЕ ДоступенВыбор Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Параметры.Свойство("Отбор") Тогда
		Если Параметры.Отбор.Свойство("БУСостояние") Тогда
			Параметры.Отбор.Вставить("Состояние", Параметры.Отбор.БУСостояние);
		КонецЕсли; 
		Если Параметры.Отбор.Свойство("БУОрганизация") Тогда
			Параметры.Отбор.Вставить("Организация", Параметры.Отбор.БУОрганизация);
		КонецЕсли; 
		Если Параметры.Отбор.Свойство("БУПодразделение") Тогда
			Параметры.Отбор.Вставить("Подразделение", Параметры.Отбор.БУПодразделение);
		КонецЕсли; 
	КонецЕсли; 
	
	Возврат Истина;

КонецФункции

Функция ДоступенВыборНематериальныхАктивов2_4(Параметры) Экспорт

	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьВнеоборотныеАктивы2_4") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьВнеоборотныеАктивы2_2") Тогда
		Возврат Истина;
	КонецЕсли;
	
	ДатаНачалаУчета = Константы.ДатаНачалаУчетаВнеоборотныхАктивов2_4.Получить();
	
	ДоступенВыбор = 
		Параметры.Свойство("Контекст") 
			И СтрНайти(Параметры.Контекст, "УУ") <> 0 
		ИЛИ НЕ Параметры.Свойство("ДатаСведений")
			И ТекущаяДатаСеанса() >= ДатаНачалаУчета 
		ИЛИ Параметры.Свойство("ДатаСведений")
			И Параметры.ДатаСведений >= ДатаНачалаУчета;
			
	Если НЕ ДоступенВыбор Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Параметры.Свойство("Отбор") Тогда
		Если Параметры.Отбор.Свойство("БУСостояние") Тогда
			Параметры.Отбор.Вставить("Состояние", Параметры.Отбор.БУСостояние);
		КонецЕсли; 
		Если Параметры.Отбор.Свойство("БУОрганизация") Тогда
			Параметры.Отбор.Вставить("Организация", Параметры.Отбор.БУОрганизация);
		КонецЕсли; 
		Если Параметры.Отбор.Свойство("БУПодразделение") Тогда
			Параметры.Отбор.Вставить("Подразделение", Параметры.Отбор.БУПодразделение);
		КонецЕсли; 
	КонецЕсли; 
	
	Возврат Истина;

КонецФункции
 
Процедура ПроверитьПараметрыРеквизитовОбъекта(ПараметрыРеквизитовОбъекта) Экспорт

	Если ПараметрыРеквизитовОбъекта.Количество() = 0 Тогда
		Возврат;
	КонецЕсли; 
	
	ПараметрыРеквизитовОбъектаТаблица = Новый ТаблицаЗначений;
	ПараметрыРеквизитовОбъектаТаблица.Колонки.Добавить("ИмяРеквизита");
	ПараметрыРеквизитовОбъектаТаблица.Колонки.Добавить("ИмяЭлемента");
	ПараметрыРеквизитовОбъектаТаблица.Колонки.Добавить("Свойство");
	ПараметрыРеквизитовОбъектаТаблица.Колонки.Добавить("Количество");
	
	ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(ПараметрыРеквизитовОбъекта, ПараметрыРеквизитовОбъектаТаблица);
	
	ПараметрыРеквизитовОбъектаТаблица.ЗаполнитьЗначения(1, "Количество");
	ПараметрыРеквизитовОбъектаТаблица.Свернуть("ИмяРеквизита,ИмяЭлемента,Свойство", "Количество");
	ПараметрыРеквизитовОбъектаТаблица.Сортировать("ИмяРеквизита,Свойство");
	
	Для каждого ПараметрыРеквизита Из ПараметрыРеквизитовОбъектаТаблица Цикл
		Если ПараметрыРеквизита.Количество > 1 И ПараметрыРеквизита.ИмяРеквизита <> "" Тогда
			ТекстСообщения = НСтр("ru = 'Для реквизита ""%1"" свойство ""%2"" определяется несколько раз. Обратитесь к администратору.'");
			ТекстСообщения = СтрШаблон(ТекстСообщения,
										?(ЗначениеЗаполнено(ПараметрыРеквизита.ИмяРеквизита), ПараметрыРеквизита.ИмяРеквизита, ПараметрыРеквизита.ИмяЭлемента), 
										ПараметрыРеквизита.Свойство);
										
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения); 
		КонецЕсли; 
	КонецЦикла; 
	
КонецПроцедуры

Функция ОперацияВводаОстатков(ДокументСсылка) Экспорт

	ХозяйственнаяОперация = Неопределено;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ВводОстатковВнеоборотныхАктивов.ХозяйственнаяОперация КАК ХозяйственнаяОперация
		|ИЗ
		|	Документ.ВводОстатковВнеоборотныхАктивов2_4 КАК ВводОстатковВнеоборотныхАктивов
		|ГДЕ
		|	ВводОстатковВнеоборотныхАктивов.Ссылка = &ДокументСсылка");
	Запрос.УстановитьПараметр("ДокументСсылка", ДокументСсылка);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ХозяйственнаяОперация = Выборка.ХозяйственнаяОперация;
	КонецЕсли;

	Возврат ХозяйственнаяОперация;
	
КонецФункции

Функция ПредставлениеВводаОстатков(Объект) Экспорт
	
	Если ТипЗнч(Объект) = Тип("Структура") 
		ИЛИ ТипЗнч(Объект) = Тип("ДанныеФормыСтруктура") Тогда
		РеквизитыОбъекта = Объект;
	Иначе	
		РеквизитыОбъекта = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект, "Ссылка, Номер, Дата, ХозяйственнаяОперация");
	КонецЕсли; 
	
	Если Не ЗначениеЗаполнено(РеквизитыОбъекта.ХозяйственнаяОперация) Тогда
		Возврат "";
	КонецЕсли;
	
	ПредставлениеНомерДата = НСтр("ru='(создание)'");
	Если ЗначениеЗаполнено(РеквизитыОбъекта.Ссылка) Тогда
		ПредставлениеНомерДата = СтрШаблон(НСтр("ru='%1 от %2'"), РеквизитыОбъекта.Номер, РеквизитыОбъекта.Дата);
	КонецЕсли;
	
	Представление = НСтр("ru='Ввод начальных остатков внеоборотных активов %1'");
	Если РеквизитыОбъекта.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВводОстатковОсновныхСредств") Тогда
		Представление = НСтр("ru='Ввод начальных остатков основных средств %1'");
	ИначеЕсли РеквизитыОбъекта.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВводОстатковПереданныхВАрендуОС") Тогда
		Представление = НСтр("ru='Ввод начальных остатков переданных в аренду основных средств %1'");
	ИначеЕсли РеквизитыОбъекта.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВводОстатковАрендованныхОС") Тогда
		Представление = НСтр("ru='Ввод начальных остатков полученных в аренду основных средств %1'");
	ИначеЕсли РеквизитыОбъекта.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВводОстатковНМАиРасходовНаНИОКР") Тогда
		Представление = НСтр("ru='Ввод начальных остатков НМА и расходов на НИОКР %1'");
	ИначеЕсли РеквизитыОбъекта.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВводОстатковВзаиморасчетовПоДоговорамЛизинга") Тогда
		Представление = НСтр("ru='Ввод начальных остатков взаиморасчетов по договорам лизинга %1'");
	ИначеЕсли РеквизитыОбъекта.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВводОстатковПредметовЛизингаНаБалансе") Тогда
		Представление = НСтр("ru='Ввод начальных остатков предметов лизинга на балансе %1'");
	ИначеЕсли РеквизитыОбъекта.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВводОстатковПредметовЛизингаЗаБалансом") Тогда
		Представление = НСтр("ru='Ввод начальных остатков предметов лизинга за балансом %1'");
	ИначеЕсли РеквизитыОбъекта.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВводОстатковПереданныхВАрендуПредметовЛизингаНаБалансе") Тогда
		Представление = НСтр("ru='Ввод начальных остатков переданных в аренду предметов лизинга на балансе %1'");
	ИначеЕсли РеквизитыОбъекта.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВводОстатковПредметовЛизингаЗаБалансом") Тогда
		Представление = НСтр("ru='Ввод начальных остатков предметов лизинга за балансом %1'");
	ИначеЕсли РеквизитыОбъекта.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВводОстатковВложенийВоВнеоборотныеАктивы") Тогда
		Представление = НСтр("ru='Ввод начальных остатков вложений во внеоборотные активы %1'");
	КонецЕсли;
	
	Возврат СтрШаблон(Представление, ПредставлениеНомерДата);
	
КонецФункции

Функция ПредставлениеВводаОстатков2_2(Объект) Экспорт
	
	Если ТипЗнч(Объект) = Тип("Структура") 
		ИЛИ ТипЗнч(Объект) = Тип("ДанныеФормыСтруктура") Тогда
		РеквизитыОбъекта = Объект;
	Иначе	
		РеквизитыОбъекта = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект, "Ссылка, Номер, Дата, ТипОперации");
	КонецЕсли; 
	
	Если Не ЗначениеЗаполнено(РеквизитыОбъекта.ТипОперации) Тогда
		Возврат "";
	КонецЕсли;
	
	ПредставлениеНомерДата = НСтр("ru='(создание)'");
	Если ЗначениеЗаполнено(РеквизитыОбъекта.Ссылка) Тогда
		ПредставлениеНомерДата = СтрШаблон(НСтр("ru='%1 от %2'"), РеквизитыОбъекта.Номер, РеквизитыОбъекта.Дата);
	КонецЕсли;
	
	Представление = НСтр("ru='Ввод начальных остатков внеоборотных активов %1'");
	Если РеквизитыОбъекта.ТипОперации = ПредопределенноеЗначение("Перечисление.ТипыОперацийВводаОстатков.ОстаткиОС") Тогда
		Представление = НСтр("ru='Ввод начальных остатков основных средств %1'");
	ИначеЕсли РеквизитыОбъекта.ТипОперации = ПредопределенноеЗначение("Перечисление.ТипыОперацийВводаОстатков.ОстаткиПереданныхВАрендуОС") Тогда
		Представление = НСтр("ru='Ввод начальных остатков переданных в аренду основных средств %1'");
	ИначеЕсли РеквизитыОбъекта.ТипОперации = ПредопределенноеЗначение("Перечисление.ТипыОперацийВводаОстатков.ОстаткиАрендованныхОС") Тогда
		Представление = НСтр("ru='Ввод начальных остатков полученных в аренду основных средств %1'");
	ИначеЕсли РеквизитыОбъекта.ТипОперации = ПредопределенноеЗначение("Перечисление.ТипыОперацийВводаОстатков.ОстаткиНМА") Тогда
		Представление = НСтр("ru='Ввод начальных остатков нематериальных активов и расходов на НИОКР %1'");
	ИначеЕсли РеквизитыОбъекта.ТипОперации = ПредопределенноеЗначение("Перечисление.ТипыОперацийВводаОстатков.ОстаткиВзаиморасчетовПоДоговорамЛизинга") Тогда
		Представление = НСтр("ru='Ввод начальных остатков взаиморасчетов по договорам лизинга %1'");
	ИначеЕсли РеквизитыОбъекта.ТипОперации = ПредопределенноеЗначение("Перечисление.ТипыОперацийВводаОстатков.ОстаткиПредметовЛизингаНаБалансе") Тогда
		Представление = НСтр("ru='Ввод начальных остатков предметов лизинга на балансе %1'");
	ИначеЕсли РеквизитыОбъекта.ТипОперации = ПредопределенноеЗначение("Перечисление.ТипыОперацийВводаОстатков.ОстаткиПереданныхВАрендуПредметовЛизингаНаБалансе") Тогда
		Представление = НСтр("ru='Ввод начальных остатков переданных в аренду предметов лизинга на балансе %1'");
	ИначеЕсли РеквизитыОбъекта.ТипОперации = ПредопределенноеЗначение("Перечисление.ТипыОперацийВводаОстатков.ОстаткиПредметовЛизингаЗаБалансом") Тогда
		Представление = НСтр("ru='Ввод начальных остатков предметов лизинга за балансом %1'");
	КонецЕсли;
	
	Возврат СтрШаблон(Представление, ПредставлениеНомерДата);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДанныеВыбораОбъектовЭксплуатации2_2(Параметры)

	Если Не Параметры.Свойство("Отбор") Тогда
		Параметры.Вставить("Отбор", Новый Структура);
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("ГруппаОС") Тогда
		Параметры.Отбор.Вставить("БУГруппаОС", Параметры.Отбор.ГруппаОС);
		Параметры.Отбор.Удалить("ГруппаОС");
	ИначеЕсли Параметры.Свойство("БУГруппаОС") Тогда
		Параметры.Отбор.Вставить("ГруппаОС", Параметры.Отбор.БУГруппаОС);
	КонецЕсли;
	Если Параметры.Отбор.Свойство("АмортизационнаяГруппа") Тогда
		Параметры.Отбор.Вставить("БУАмортизационнаяГруппа", Параметры.Отбор.АмортизационнаяГруппа);
	ИначеЕсли Параметры.Свойство("БУАмортизационнаяГруппа") Тогда
		Параметры.Отбор.Вставить("АмортизационнаяГруппа", Параметры.Отбор.БУАмортизационнаяГруппа);
	КонецЕсли;
	
	Если Параметры.Свойство("ДоговорЛизинга") И ЗначениеЗаполнено(Параметры.ДоговорЛизинга) Тогда
		Параметры.Отбор.Вставить("НаправлениеДеятельности", ВнеоборотныеАктивыВызовСервера.НаправлениеДеятельности(Параметры.ДоговорЛизинга));
	КонецЕсли;
	Если Параметры.Свойство("ВариантПримененияЦелевогоФинансирования")
		И Параметры.ВариантПримененияЦелевогоФинансирования = ПредопределенноеЗначение("Перечисление.ВариантыПримененияЦелевогоФинансирования.НеИспользуется") Тогда
		Параметры.Отбор.Удалить("НаправлениеДеятельности");
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("МФУГруппаОС") Тогда
		Параметры.Отбор.Вставить("ГруппаОСМеждународныйУчет", Параметры.Отбор.МФУГруппаОС);
	КонецЕсли;
	
	//++ НЕ УТКА
	Если Параметры.Свойство("МФУНаправлениеПеревода") Тогда
		Параметры.Отбор.Вставить("МФУВидАктива", Неопределено);
	КонецЕсли;
	
	//-- НЕ УТКА
	
	Если Параметры.Свойство("Контекст")Тогда
		
		ИндексЗапятой = СтрНайти(Параметры.Контекст, ",");
		Контекст = Параметры.Контекст;
		Если ИндексЗапятой <> 0 Тогда
			Контекст = Сред(Контекст, 1, ИндексЗапятой-1);
		КонецЕсли;
		
		Если Контекст = "БУ"
			И (ОбщегоНазначенияУТКлиентСервер.СтруктураСодержитКлючи(Параметры, "ТекущийРегистратор, ДатаСведений")
				Или Параметры.Свойство("Отбор")
				И ОбщегоНазначенияУТКлиентСервер.СтруктураСодержитКлючи(Параметры.Отбор, "БУОрганизация, БУПодразделение, БУСостояние, ВидНалога")) Тогда
			
			Параметры.Отбор.Вставить("Ссылка", ВнеоборотныеАктивыВызовСервера.ЭлементыОСПоОтборуБУ(Параметры));
		//++ НЕ УТКА
		ИначеЕсли Контекст = "МФУ"
			И (ОбщегоНазначенияУТКлиентСервер.СтруктураСодержитКлючи(Параметры, "ТекущийРегистратор, ДатаСведений")
				Или Параметры.Свойство("Отбор")
				И ОбщегоНазначенияУТКлиентСервер.СтруктураСодержитКлючи(Параметры.Отбор, "МФУСостояние, МФУОрганизация, МФУПодразделение")) Тогда
			
			Параметры.Отбор.Вставить("Ссылка", ВнеоборотныеАктивыВызовСервера.ЭлементыОСПоОтборуМФУ(Параметры));
		//-- НЕ УТКА
		КонецЕсли;
		
	КонецЕсли;
	
	
КонецПроцедуры
 
Функция ДанныеВыбораОбъектовЭксплуатации2_4(Параметры)

	ОписаниеЗапроса = Справочники.ОбъектыЭксплуатации.ОписаниеЗапросаДляВыбора(Параметры, Истина);
	
	Запрос = Новый Запрос(ОписаниеЗапроса.ТекстЗапроса);
	Для каждого ОписаниеПараметра Из ОписаниеЗапроса.ПараметрыЗапроса Цикл
		Запрос.УстановитьПараметр(ОписаниеПараметра.Ключ, ОписаниеПараметра.Значение);
	КонецЦикла; 
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	ДанныеВыбора = Новый СписокЗначений;
	Пока Выборка.Следующий() Цикл
		Представление = ВнеоборотныеАктивыСлужебный.ПредставлениеРезультатаПоискаПоСтроке(Выборка.Наименование, Параметры.СтрокаПоиска);
		ДанныеВыбора.Добавить(Выборка.Ссылка, Представление);
	КонецЦикла;
	
	Возврат ДанныеВыбора;
	
КонецФункции

Процедура ДанныеВыбораНематериальныхАктивов2_2(Параметры)

	Если Параметры.Свойство("Контекст")Тогда
		
		ИндексЗапятой = СтрНайти(Параметры.Контекст, ",");
		Контекст = Параметры.Контекст;
		Если ИндексЗапятой <> 0 Тогда
			Контекст = Сред(Контекст, 1, ИндексЗапятой-1);
		КонецЕсли;
		
		Если Контекст = "БУ"
			И (ОбщегоНазначенияУТКлиентСервер.СтруктураСодержитКлючи(Параметры, "ТекущийРегистратор, ДатаСведений")
				Или Параметры.Свойство("Отбор")
				И ОбщегоНазначенияУТКлиентСервер.СтруктураСодержитКлючи(Параметры.Отбор, "БУОрганизация, БУСостояние")) Тогда
			
			Параметры.Отбор.Вставить("Ссылка", ВнеоборотныеАктивыВызовСервера.ЭлементыНМАПоОтборуБУ(Параметры));
		//++ НЕ УТКА
		ИначеЕсли Контекст = "МФУ"
			И (ОбщегоНазначенияУТКлиентСервер.СтруктураСодержитКлючи(Параметры, "ТекущийРегистратор, ДатаСведений")
				Или Параметры.Свойство("Отбор")
				И ОбщегоНазначенияУТКлиентСервер.СтруктураСодержитКлючи(Параметры.Отбор, "МФУСостояние, МФУОрганизация, МФУПодразделение")) Тогда
			
			Параметры.Отбор.Вставить("Ссылка", ВнеоборотныеАктивыВызовСервера.ЭлементыНМАПоОтборуМФУ(Параметры));
		//-- НЕ УТКА
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Функция ДанныеВыбораНематериальныхАктивов2_4(Параметры)

	ОписаниеЗапроса = Справочники.НематериальныеАктивы.ОписаниеЗапросаДляВыбора(Параметры, Истина);
	
	Запрос = Новый Запрос(ОписаниеЗапроса.ТекстЗапроса);
	Для каждого ОписаниеПараметра Из ОписаниеЗапроса.ПараметрыЗапроса Цикл
		Запрос.УстановитьПараметр(ОписаниеПараметра.Ключ, ОписаниеПараметра.Значение);
	КонецЦикла; 
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	ДанныеВыбора = Новый СписокЗначений;
	Пока Выборка.Следующий() Цикл
		Представление = ВнеоборотныеАктивыСлужебный.ПредставлениеРезультатаПоискаПоСтроке(Выборка.Наименование, Параметры.СтрокаПоиска);
		ДанныеВыбора.Добавить(Выборка.Ссылка, Представление);
	КонецЦикла;
	
	Возврат ДанныеВыбора;
	
КонецФункции

#КонецОбласти
