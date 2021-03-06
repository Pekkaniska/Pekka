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

#Область СозданиеНаОсновании

// Заполняет список команд создания на основании.
// 
// Параметры:
//   КомандыСоздатьНаОсновании - ТаблицаЗначений - состав полей см. в функции ВводНаОсновании.СоздатьКоллекциюКомандСоздатьНаОсновании
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСоздатьНаОсновании, НастройкиФормы) Экспорт
	
	Документы.пкЗаданиеНаПеревозку.ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании);
	Документы.пкДоставка.ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании);
	СозданиеНаОснованииПереопределяемый.ДобавитьКомандуСоздатьНаОснованииБизнесПроцессЗадание(КомандыСоздатьНаОсновании);
	
КонецПроцедуры

// Заполняет список команд создания на основании.
// 
// Параметры:
//   КомандыСоздатьНаОсновании - ТаблицаЗначений - состав полей см. в функции ВводНаОсновании.СоздатьКоллекциюКомандСоздатьНаОсновании
//
// Возвращаемое значение:
//	 КомандыСоздатьНаОсновании - ТаблицаЗначений - состав полей см. в функции ВводНаОсновании.СоздатьКоллекциюКомандСоздатьНаОсновании
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании) Экспорт

	Если ПравоДоступа("Добавление", Метаданные.Документы.пкЗаданиеНаПеревозку) Тогда
		КомандаСоздатьНаОсновании = КомандыСоздатьНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Идентификатор = Метаданные.Документы.пкЗаданиеНаПеревозку.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(Метаданные.Документы.пкЗаданиеНаПеревозку);	
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;

	Возврат Неопределено;	
КонецФункции

#КонецОбласти 
#КонецОбласти 

// Определяет реквизиты выбранного документа
//
// Параметры:
//	ДокументСсылка - Ссылка на документа
//
// Возвращаемое значение:
//	Структура - реквизиты выбранного документа
//
Функция РеквизитыДокумента(ДокументСсылка) Экспорт
	
	СтруктураРеквизитов = Новый Структура();
	
	Возврат СтруктураРеквизитов;

КонецФункции

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаОбъекта" Тогда
		Если ОбщегоНазначенияУТКлиентСервер.АвторизованВнешнийПользователь() Тогда
			//СтандартнаяОбработка = Ложь;
			//ВыбраннаяФорма = "ФормаДокументаСамообслуживание";
		КонецЕсли;
	ИначеЕсли ВидФормы = "ФормаСписка" Тогда
		Если ОбщегоНазначенияУТКлиентСервер.АвторизованВнешнийПользователь() Тогда
			//СтандартнаяОбработка = Ложь;
			//ВыбраннаяФорма = "ФормаСпискаСамообслуживание";
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область Проведение

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт

	ИсточникиДанных = Новый Соответствие;

	Возврат ИсточникиДанных; 

КонецФункции

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт
	
	////////////////////////////////////////////////////////////////////////////
	// Создадим запрос инициализации движений
	
	Запрос = Новый Запрос;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
	
	////////////////////////////////////////////////////////////////////////////
	// Сформируем текст запроса
	
	ТекстыЗапроса = Новый СписокЗначений;
	ТекстЗапросаТаблица_пкМоделиКДоставкеПоЗаявкамНаАрендуТехники(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблица_пкТехникаКПеремещениюМеждуРегионами(Запрос, ТекстыЗапроса, Регистры);
	ПроведениеСерверУТ.ИнициализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Истина);
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка                КАК Ссылка,
	|	ДанныеДокумента.ВидОперации           КАК ВидОперации,
	|	ДанныеДокумента.Подразделение         КАК Подразделение,
	|	ДанныеДокумента.ДатаОтгрузки          КАК ДатаОтгрузки,
	|	ДанныеДокумента.ЗаявкаНаАрендуТехники КАК ЗаявкаНаАрендуТехники,
	|	ДанныеДокумента.Модель                КАК Модель,
	|	ДанныеДокумента.Техника               КАК Техника,
	|	ДанныеДокумента.РегионПолучатель      КАК РегионПолучатель,
	|	ДанныеДокумента.ВремяДоставкиС        КАК ВремяДоставкиС,
	|	ДанныеДокумента.ВремяДоставкиПо       КАК ВремяДоставкиПо,
	|	ДанныеДокумента.СпособДоставки        КАК СпособДоставки,
	|	ДанныеДокумента.ЗаданиеНаПеревозку    КАК ЗаданиеНаПеревозку
	|ИЗ
	|	Документ.пкЗаданиеНаПеревозку КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|";
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	Запрос.УстановитьПараметр("ВидОперации",			Реквизиты.ВидОперации);
	Запрос.УстановитьПараметр("Подразделение",			Реквизиты.Подразделение);
	Запрос.УстановитьПараметр("ДатаОтгрузки",			Реквизиты.ДатаОтгрузки);
	Запрос.УстановитьПараметр("ЗаявкаНаАрендуТехники",	Реквизиты.ЗаявкаНаАрендуТехники);
	Запрос.УстановитьПараметр("Модель",					Реквизиты.Модель);
	Запрос.УстановитьПараметр("Техника",				Реквизиты.Техника);
	Запрос.УстановитьПараметр("РегионПолучатель",		Реквизиты.РегионПолучатель);
	Запрос.УстановитьПараметр("ВремяДоставкиС",			Реквизиты.ВремяДоставкиС);
	Запрос.УстановитьПараметр("ВремяДоставкиПо",		Реквизиты.ВремяДоставкиПо);
	Запрос.УстановитьПараметр("СпособДоставки",			Реквизиты.СпособДоставки);
	Запрос.УстановитьПараметр("ЗаданиеНаПеревозку",		Реквизиты.ЗаданиеНаПеревозку);
	Запрос.УстановитьПараметр("ПустаяДата",				'00010101');

КонецПроцедуры

Функция ТекстЗапросаТаблица_пкМоделиКДоставкеПоЗаявкамНаАрендуТехники(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "пкМоделиКДоставкеПоЗаявкамНаАрендуТехники";
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
    |   ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
    |   пкЗаявкаНаАрендуТехникиТовары.ДатаОтгрузки КАК Период,
    |   &ЗаявкаНаАрендуТехники КАК ЗаявкаНаАрендуТехники,
    |   &Модель КАК Модель,
    |   &Техника КАК Техника,
    |   -1 КАК КОтгрузке,
    |   0 КАК КВозврату,
    |   0 КАК Выгрузить,
    |   0 КАК Погрузить,
    |   ЗНАЧЕНИЕ(Документ.пкЗаданиеНаПеревозку.ПустаяСсылка) КАК ЗаданиеНаПеревозку
    |ИЗ
    |   Документ.пкЗаданиеНаПеревозку КАК ТаблицаЗадание
    |       ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.пкЗаявкаНаАрендуТехники.Товары КАК пкЗаявкаНаАрендуТехникиТовары
    |       ПО ТаблицаЗадание.ЗаявкаНаАрендуТехники = пкЗаявкаНаАрендуТехникиТовары.Ссылка
    |           И ТаблицаЗадание.Модель = пкЗаявкаНаАрендуТехникиТовары.Номенклатура
    |           И (пкЗаявкаНаАрендуТехникиТовары.ДатаОтгрузки <> &ПустаяДата)
    |ГДЕ
    |   ТаблицаЗадание.Ссылка = &Ссылка
    |   И ТаблицаЗадание.ВидОперации = ЗНАЧЕНИЕ(Перечисление.пкВидыОперацийЗаданийНаПеревозку.ДоставкаКлиенту)
    |
    |ОБЪЕДИНИТЬ ВСЕ
    |
    |ВЫБРАТЬ
    |   ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход),
    |   &ДатаОтгрузки,
    |   &ЗаявкаНаАрендуТехники,
    |   &Модель,
    |   &Техника,
    |   1,
    |   0,
    |   0,
    |   0,
    |   &Ссылка
    |ИЗ
    |   Документ.пкЗаданиеНаПеревозку КАК ТаблицаЗадание
    |       ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.пкЗаявкаНаАрендуТехники.Товары КАК пкЗаявкаНаАрендуТехникиТовары
    |       ПО ТаблицаЗадание.ЗаявкаНаАрендуТехники = пкЗаявкаНаАрендуТехникиТовары.Ссылка
    |           И ТаблицаЗадание.Модель = пкЗаявкаНаАрендуТехникиТовары.Номенклатура
    |ГДЕ
    |   ТаблицаЗадание.Ссылка = &Ссылка
    |   И ТаблицаЗадание.ВидОперации = ЗНАЧЕНИЕ(Перечисление.пкВидыОперацийЗаданийНаПеревозку.ДоставкаКлиенту)
    |
    |ОБЪЕДИНИТЬ ВСЕ
    |
    |ВЫБРАТЬ
    |   ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход),
    |   пкЗаявкаНаАрендуТехникиТовары.ДатаВозврата,
    |   &ЗаявкаНаАрендуТехники,
    |   &Модель,
    |   &Техника,
    |   0,
    |   -1,
    |   0,
    |   0,
    |   ЗНАЧЕНИЕ(Документ.пкЗаданиеНаПеревозку.ПустаяСсылка)
    |ИЗ
    |   Документ.пкЗаданиеНаПеревозку КАК ТаблицаЗадание
    |       ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.пкЗаявкаНаАрендуТехники.Товары КАК пкЗаявкаНаАрендуТехникиТовары
    |       ПО ТаблицаЗадание.ЗаявкаНаАрендуТехники = пкЗаявкаНаАрендуТехникиТовары.Ссылка
    |           И ТаблицаЗадание.Модель = пкЗаявкаНаАрендуТехникиТовары.Номенклатура
    |           И (пкЗаявкаНаАрендуТехникиТовары.ДатаВозврата <> &ПустаяДата)
    |ГДЕ
    |   ТаблицаЗадание.Ссылка = &Ссылка
    |   И ТаблицаЗадание.ВидОперации = ЗНАЧЕНИЕ(Перечисление.пкВидыОперацийЗаданийНаПеревозку.ВозвратОтКлиента)
    |   И НЕ ТаблицаЗадание.ЗаменаТехники
    |
    |ОБЪЕДИНИТЬ ВСЕ
    |
    |ВЫБРАТЬ
    |   ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход),
    |   &ДатаОтгрузки,
    |   &ЗаявкаНаАрендуТехники,
    |   &Модель,
    |   &Техника,
    |   0,
    |   1,
    |   0,
    |   0,
    |   &Ссылка
    |ИЗ
    |   Документ.пкЗаданиеНаПеревозку КАК ТаблицаЗадание
    |       ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.пкЗаявкаНаАрендуТехники.Товары КАК пкЗаявкаНаАрендуТехникиТовары
    |       ПО ТаблицаЗадание.ЗаявкаНаАрендуТехники = пкЗаявкаНаАрендуТехникиТовары.Ссылка
    |           И ТаблицаЗадание.Модель = пкЗаявкаНаАрендуТехникиТовары.Номенклатура
    |ГДЕ
    |   ТаблицаЗадание.Ссылка = &Ссылка
    |   И ТаблицаЗадание.ВидОперации = ЗНАЧЕНИЕ(Перечисление.пкВидыОперацийЗаданийНаПеревозку.ВозвратОтКлиента)
    |
    |ОБЪЕДИНИТЬ ВСЕ
    |
    |ВЫБРАТЬ
    |   ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход),
    |   пкЗаявкаНаАрендуТехникиТовары.ДатаОтгрузки,
    |   &ЗаявкаНаАрендуТехники,
    |   &Модель,
    |   &Техника,
    |   -1,
    |   0,
    |   0,
    |   0,
    |   ЗНАЧЕНИЕ(Документ.пкЗаданиеНаПеревозку.ПустаяСсылка)
    |ИЗ
    |   Документ.пкЗаданиеНаПеревозку КАК ТаблицаЗадание
    |       ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.пкЗаявкаНаАрендуТехники.Товары КАК пкЗаявкаНаАрендуТехникиТовары
    |       ПО ТаблицаЗадание.ЗаявкаНаАрендуТехники = пкЗаявкаНаАрендуТехникиТовары.Ссылка
    |           И ТаблицаЗадание.Модель = пкЗаявкаНаАрендуТехникиТовары.Номенклатура
    |           И (пкЗаявкаНаАрендуТехникиТовары.ДатаОтгрузки <> &ПустаяДата)
    |ГДЕ
    |   ТаблицаЗадание.Ссылка = &Ссылка
    |   И ТаблицаЗадание.ВидОперации = ЗНАЧЕНИЕ(Перечисление.пкВидыОперацийЗаданийНаПеревозку.Перекат)
    |   И ЕСТЬNULL(ТаблицаЗадание.ЗаданиеНаПеревозку, ЗНАЧЕНИЕ(Документ.пкЗаданиеНаПеревозку.ПустаяСсылка)) <> ЗНАЧЕНИЕ(Документ.пкЗаданиеНаПеревозку.ПустаяСсылка)
    |
    |ОБЪЕДИНИТЬ ВСЕ
    |
    |ВЫБРАТЬ
    |   ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход),
    |   &ДатаОтгрузки,
    |   &ЗаявкаНаАрендуТехники,
    |   &Модель,
    |   &Техника,
    |   1,
    |   0,
    |   0,
    |   0,
    |   &Ссылка
    |ИЗ
    |   Документ.пкЗаданиеНаПеревозку КАК ТаблицаЗадание
    |       ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.пкЗаявкаНаАрендуТехники.Товары КАК пкЗаявкаНаАрендуТехникиТовары
    |       ПО ТаблицаЗадание.ЗаявкаНаАрендуТехники = пкЗаявкаНаАрендуТехникиТовары.Ссылка
    |           И ТаблицаЗадание.Модель = пкЗаявкаНаАрендуТехникиТовары.Номенклатура
    |ГДЕ
    |   ТаблицаЗадание.Ссылка = &Ссылка
    |   И ТаблицаЗадание.ВидОперации = ЗНАЧЕНИЕ(Перечисление.пкВидыОперацийЗаданийНаПеревозку.Перекат)
    |   И ЕСТЬNULL(ТаблицаЗадание.ЗаданиеНаПеревозку, ЗНАЧЕНИЕ(Документ.пкЗаданиеНаПеревозку.ПустаяСсылка)) <> ЗНАЧЕНИЕ(Документ.пкЗаданиеНаПеревозку.ПустаяСсылка)
    |
    |ОБЪЕДИНИТЬ ВСЕ
    |
    |ВЫБРАТЬ
    |   ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход),
    |   пкЗаявкаНаАрендуТехникиТовары.ДатаВозврата,
    |   &ЗаявкаНаАрендуТехники,
    |   &Модель,
    |   &Техника,
    |   0,
    |   -1,
    |   0,
    |   0,
    |   ЗНАЧЕНИЕ(Документ.пкЗаданиеНаПеревозку.ПустаяСсылка)
    |ИЗ
    |   Документ.пкЗаданиеНаПеревозку КАК ТаблицаЗадание
    |       ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.пкЗаявкаНаАрендуТехники.Товары КАК пкЗаявкаНаАрендуТехникиТовары
    |       ПО ТаблицаЗадание.ЗаявкаНаАрендуТехники = пкЗаявкаНаАрендуТехникиТовары.Ссылка
    |           И ТаблицаЗадание.Модель = пкЗаявкаНаАрендуТехникиТовары.Номенклатура
    |           И (пкЗаявкаНаАрендуТехникиТовары.ДатаВозврата <> &ПустаяДата)
    |ГДЕ
    |   ТаблицаЗадание.Ссылка = &Ссылка
    |   И ТаблицаЗадание.ВидОперации = ЗНАЧЕНИЕ(Перечисление.пкВидыОперацийЗаданийНаПеревозку.Перекат)
    |   И ЕСТЬNULL(ТаблицаЗадание.ЗаданиеНаПеревозку, ЗНАЧЕНИЕ(Документ.пкЗаданиеНаПеревозку.ПустаяСсылка)) = ЗНАЧЕНИЕ(Документ.пкЗаданиеНаПеревозку.ПустаяСсылка)
    |
    |ОБЪЕДИНИТЬ ВСЕ
    |
    |ВЫБРАТЬ
    |   ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход),
    |   &ДатаОтгрузки,
    |   &ЗаявкаНаАрендуТехники,
    |   &Модель,
    |   &Техника,
    |   0,
    |   1,
    |   0,
    |   0,
    |   &Ссылка
    |ИЗ
    |   Документ.пкЗаданиеНаПеревозку КАК ТаблицаЗадание
    |       ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.пкЗаявкаНаАрендуТехники.Товары КАК пкЗаявкаНаАрендуТехникиТовары
    |       ПО ТаблицаЗадание.ЗаявкаНаАрендуТехники = пкЗаявкаНаАрендуТехникиТовары.Ссылка
    |           И ТаблицаЗадание.Модель = пкЗаявкаНаАрендуТехникиТовары.Номенклатура
    |ГДЕ
    |   ТаблицаЗадание.Ссылка = &Ссылка
    |   И ТаблицаЗадание.ВидОперации = ЗНАЧЕНИЕ(Перечисление.пкВидыОперацийЗаданийНаПеревозку.Перекат)
    |   И ЕСТЬNULL(ТаблицаЗадание.ЗаданиеНаПеревозку, ЗНАЧЕНИЕ(Документ.пкЗаданиеНаПеревозку.ПустаяСсылка)) = ЗНАЧЕНИЕ(Документ.пкЗаданиеНаПеревозку.ПустаяСсылка)
    |
    |ОБЪЕДИНИТЬ ВСЕ
    |
    |ВЫБРАТЬ
    |   ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход),
    |   &ДатаОтгрузки,
    |   &ЗаявкаНаАрендуТехники,
    |   &Модель,
    |   &Техника,
    |   1,
    |   0,
    |   0,
    |   0,
    |   &Ссылка
    |ИЗ
    |   Документ.пкЗаданиеНаПеревозку КАК ТаблицаЗадание
    |ГДЕ
    |   ТаблицаЗадание.Ссылка = &Ссылка
    |   И ТаблицаЗадание.Статус = ЗНАЧЕНИЕ(Перечисление.пкСтатусыЗаданийНаПеревозку.КДоставке)
    |   И ТаблицаЗадание.ВидОперации = ЗНАЧЕНИЕ(Перечисление.пкВидыОперацийЗаданийНаПеревозку.ДоставкаКлиенту)
    |
    |ОБЪЕДИНИТЬ ВСЕ
    |
    |ВЫБРАТЬ
    |   ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход),
    |   &ДатаОтгрузки,
    |   &ЗаявкаНаАрендуТехники,
    |   &Модель,
    |   &Техника,
    |   0,
    |   1,
    |   0,
    |   0,
    |   &Ссылка
    |ИЗ
    |   Документ.пкЗаданиеНаПеревозку КАК ТаблицаЗадание
    |ГДЕ
    |   ТаблицаЗадание.Ссылка = &Ссылка
    |   И ТаблицаЗадание.Статус = ЗНАЧЕНИЕ(Перечисление.пкСтатусыЗаданийНаПеревозку.КДоставке)
    |   И ТаблицаЗадание.ВидОперации = ЗНАЧЕНИЕ(Перечисление.пкВидыОперацийЗаданийНаПеревозку.ВозвратОтКлиента)
    |
    |ОБЪЕДИНИТЬ ВСЕ
    |
    |ВЫБРАТЬ
    |   ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход),
    |   &ДатаОтгрузки,
    |   &ЗаявкаНаАрендуТехники,
    |   &Модель,
    |   &Техника,
    |   1,
    |   0,
    |   0,
    |   0,
    |   &Ссылка
    |ИЗ
    |   Документ.пкЗаданиеНаПеревозку КАК ТаблицаЗадание
    |ГДЕ
    |   ТаблицаЗадание.Ссылка = &Ссылка
    |   И ТаблицаЗадание.Статус = ЗНАЧЕНИЕ(Перечисление.пкСтатусыЗаданийНаПеревозку.КДоставке)
    |   И ТаблицаЗадание.ВидОперации = ЗНАЧЕНИЕ(Перечисление.пкВидыОперацийЗаданийНаПеревозку.Перекат)
    |   И ЕСТЬNULL(ТаблицаЗадание.ЗаданиеНаПеревозку, ЗНАЧЕНИЕ(Документ.пкЗаданиеНаПеревозку.ПустаяСсылка)) <> ЗНАЧЕНИЕ(Документ.пкЗаданиеНаПеревозку.ПустаяСсылка)
    |
    |ОБЪЕДИНИТЬ ВСЕ
    |
    |ВЫБРАТЬ
    |   ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход),
    |   &ДатаОтгрузки,
    |   &ЗаявкаНаАрендуТехники,
    |   &Модель,
    |   &Техника,
    |   0,
    |   1,
    |   0,
    |   0,
    |   &Ссылка
    |ИЗ
    |   Документ.пкЗаданиеНаПеревозку КАК ТаблицаЗадание
    |ГДЕ
    |   ТаблицаЗадание.Ссылка = &Ссылка
    |   И ТаблицаЗадание.Статус = ЗНАЧЕНИЕ(Перечисление.пкСтатусыЗаданийНаПеревозку.КДоставке)
    |   И ТаблицаЗадание.ВидОперации = ЗНАЧЕНИЕ(Перечисление.пкВидыОперацийЗаданийНаПеревозку.Перекат)
    |   И ЕСТЬNULL(ТаблицаЗадание.ЗаданиеНаПеревозку, ЗНАЧЕНИЕ(Документ.пкЗаданиеНаПеревозку.ПустаяСсылка)) = ЗНАЧЕНИЕ(Документ.пкЗаданиеНаПеревозку.ПустаяСсылка)
    |
    |ОБЪЕДИНИТЬ ВСЕ
    |
    |ВЫБРАТЬ
    |   ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход),
    |   &ДатаОтгрузки,
    |   &ЗаявкаНаАрендуТехники,
    |   &Модель,
    |   &Техника,
    |   0,
    |   0,
    |   1,
    |   0,
    |   &Ссылка
    |ИЗ
    |   Документ.пкЗаданиеНаПеревозку КАК ТаблицаЗадание
    |ГДЕ
    |   ТаблицаЗадание.Ссылка = &Ссылка
    |   И ТаблицаЗадание.Статус = ЗНАЧЕНИЕ(Перечисление.пкСтатусыЗаданийНаПеревозку.КДоставке)
    |   И ТаблицаЗадание.ВидОперации = ЗНАЧЕНИЕ(Перечисление.пкВидыОперацийЗаданийНаПеревозку.ДоставкаКлиенту)
    |
    |ОБЪЕДИНИТЬ ВСЕ
    |
    |ВЫБРАТЬ
    |   ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход),
    |   &ДатаОтгрузки,
    |   &ЗаявкаНаАрендуТехники,
    |   &Модель,
    |   &Техника,
    |   0,
    |   0,
    |   0,
    |   1,
    |   &Ссылка
    |ИЗ
    |   Документ.пкЗаданиеНаПеревозку КАК ТаблицаЗадание
    |ГДЕ
    |   ТаблицаЗадание.Ссылка = &Ссылка
    |   И ТаблицаЗадание.Статус = ЗНАЧЕНИЕ(Перечисление.пкСтатусыЗаданийНаПеревозку.КДоставке)
    |   И ТаблицаЗадание.ВидОперации = ЗНАЧЕНИЕ(Перечисление.пкВидыОперацийЗаданийНаПеревозку.ВозвратОтКлиента)
    |
    |ОБЪЕДИНИТЬ ВСЕ
    |
    |ВЫБРАТЬ
    |   ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход),
    |   &ДатаОтгрузки,
    |   &ЗаявкаНаАрендуТехники,
    |   &Модель,
    |   &Техника,
    |   0,
    |   0,
    |   1,
    |   0,
    |   &Ссылка
    |ИЗ
    |   Документ.пкЗаданиеНаПеревозку КАК ТаблицаЗадание
    |ГДЕ
    |   ТаблицаЗадание.Ссылка = &Ссылка
    |   И ТаблицаЗадание.Статус = ЗНАЧЕНИЕ(Перечисление.пкСтатусыЗаданийНаПеревозку.КДоставке)
    |   И ТаблицаЗадание.ВидОперации = ЗНАЧЕНИЕ(Перечисление.пкВидыОперацийЗаданийНаПеревозку.Перекат)
    |   И ЕСТЬNULL(ТаблицаЗадание.ЗаданиеНаПеревозку, ЗНАЧЕНИЕ(Документ.пкЗаданиеНаПеревозку.ПустаяСсылка)) <> ЗНАЧЕНИЕ(Документ.пкЗаданиеНаПеревозку.ПустаяСсылка)
    |
    |ОБЪЕДИНИТЬ ВСЕ
    |
    |ВЫБРАТЬ
    |   ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход),
    |   &ДатаОтгрузки,
    |   &ЗаявкаНаАрендуТехники,
    |   &Модель,
    |   &Техника,
    |   0,
    |   0,
    |   0,
    |   1,
    |   &Ссылка
    |ИЗ
    |   Документ.пкЗаданиеНаПеревозку КАК ТаблицаЗадание
    |ГДЕ
    |   ТаблицаЗадание.Ссылка = &Ссылка
    |   И ТаблицаЗадание.Статус = ЗНАЧЕНИЕ(Перечисление.пкСтатусыЗаданийНаПеревозку.КДоставке)
    |   И ТаблицаЗадание.ВидОперации = ЗНАЧЕНИЕ(Перечисление.пкВидыОперацийЗаданийНаПеревозку.Перекат)
    |   И ЕСТЬNULL(ТаблицаЗадание.ЗаданиеНаПеревозку, ЗНАЧЕНИЕ(Документ.пкЗаданиеНаПеревозку.ПустаяСсылка)) = ЗНАЧЕНИЕ(Документ.пкЗаданиеНаПеревозку.ПустаяСсылка)
    |
    |ОБЪЕДИНИТЬ ВСЕ
    |
    |ВЫБРАТЬ
    |   ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход),
    |   &ДатаОтгрузки,
    |   &ЗаявкаНаАрендуТехники,
    |   &Модель,
    |   ЗНАЧЕНИЕ(Справочник.ОбъектыЭксплуатации.ПустаяСсылка),
    |   1,
    |   0,
    |   0,
    |   0,
    |   ЗНАЧЕНИЕ(Документ.пкЗаданиеНаПеревозку.ПустаяСсылка)
    |ИЗ
    |   Документ.пкЗаданиеНаПеревозку КАК ТаблицаЗадание
    |ГДЕ
    |   ТаблицаЗадание.Ссылка = &Ссылка
    |   И ТаблицаЗадание.ВидОперации = ЗНАЧЕНИЕ(Перечисление.пкВидыОперацийЗаданийНаПеревозку.ВозвратОтКлиента)
    |   И ТаблицаЗадание.ЗаменаТехники";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблица_пкТехникаКПеремещениюМеждуРегионами(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "пкТехникаКПеремещениюМеждуРегионами";
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	&ДатаОтгрузки КАК Период,
	|	&Ссылка КАК ЗаданиеНаПеревозку,
	|	&Техника КАК Техника,
	|	1 КАК Выгрузить
	|ИЗ
	|	Документ.пкЗаданиеНаПеревозку КАК ТаблицаЗадание
	|ГДЕ
	|	ТаблицаЗадание.Ссылка = &Ссылка
    
    //+++rarus-spb_zlov 12.09.2016    
    |   И ТаблицаЗадание.Статус = ЗНАЧЕНИЕ(Перечисление.пкСтатусыЗаданийНаПеревозку.КДоставке)
    //---rarus-spb_zlov 12.09.2016 
    
	|	И ТаблицаЗадание.ВидОперации = ЗНАЧЕНИЕ(Перечисление.пкВидыОперацийЗаданийНаПеревозку.ПеремещениеМеждуРегионами)";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Процедура Отразить_пкМоделиКДоставкеПоЗаявкамНаАрендуТехники(ДополнительныеСвойства, Движения, Отказ) Экспорт

	Таблица= ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицапкМоделиКДоставкеПоЗаявкамНаАрендуТехники;
	
	Если Отказ ИЛИ Таблица.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	Движения.пкМоделиКДоставкеПоЗаявкамНаАрендуТехники.Записывать = Истина;
	Движения.пкМоделиКДоставкеПоЗаявкамНаАрендуТехники.Загрузить(Таблица);
	
КонецПроцедуры

Процедура Отразить_пкТехникаКПеремещениюМеждуРегионами(ДополнительныеСвойства, Движения, Отказ) Экспорт

	Таблица = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицапкТехникаКПеремещениюМеждуРегионами;
	
	Если Отказ ИЛИ Таблица.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	Движения.пкТехникаКПеремещениюМеждуРегионами.Записывать = Истина;
	Движения.пкТехникаКПеремещениюМеждуРегионами.Загрузить(Таблица);
	
КонецПроцедуры

Функция ЕстьИзмененияВТаблице(СтруктураДанных, Ключ)
	Перем ЕстьИзменения;

	Возврат СтруктураДанных.Свойство(Ключ, ЕстьИзменения) И ЕстьИзменения;

КонецФункции

Процедура СообщитьОбОшибкахПроведенияПриДвижениипкМоделиКДоставкеПоЗаявкамНаАрендуТехники(Объект, Отказ, РезультатЗапроса)

	ШаблонСообщения = НСтр("ru = 'По документу %ЗаявкаНаАрендуТехники% 
		|не запланирована перевозка модели %Модель%'");

	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл

		ТекстСообщения = СтрЗаменить(ШаблонСообщения, "%Модель%", Выборка.Модель);
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ЗаявкаНаАрендуТехники%", Выборка.ЗаявкаНаАрендуТехники);

		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Объект, ,, Отказ);

	КонецЦикла;

КонецПроцедуры

Процедура ВыполнитьКонтрольРезультатовПроведения(Объект, Отказ) Экспорт

	Если ЗначениеЗаполнено(ПараметрыСеанса.ПараметрыОбработчикаОбновления.РежимВыполнения) 
		Или Объект.ДополнительныеСвойства.ДляПроведения.РегистрыДляКонтроля.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	ДанныеТаблиц    = Объект.ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	ПакетЗапросов   = Новый Запрос;
	МассивКонтролей = Новый Массив;
	ТекстЗапроса    = "";

	Если ЕстьИзмененияВТаблице(ДанныеТаблиц,"ДвиженияпкМоделиКДоставкеПоЗаявкамНаАрендуТехникиИзменение") Тогда

		МассивКонтролей.Добавить(Врег("ДвиженияпкМоделиКДоставкеПоЗаявкамНаАрендуТехникиИзменение"));

		ТекстЗапроса = ТекстЗапроса + 
		"
		|ВЫБРАТЬ
		|	Остатки.ЗаявкаНаАрендуТехники КАК ЗаявкаНаАрендуТехники,
		|	Остатки.Модель                КАК Модель,
		|	Остатки.КОтгрузкеОстаток      КАК КОтгрузке,
		|	Остатки.КВозвратуОстаток      КАК КВозврату
		|
		|ИЗ 
		|	РегистрНакопления.пкМоделиКДоставкеПоЗаявкамНаАрендуТехники.Остатки(
		|			,
		|			(ЗаявкаНаАрендуТехники, Модель) В
		|				(ВЫБРАТЬ
		|					Т.ЗаявкаНаАрендуТехники,
		|					Т.Модель
		|				ИЗ
		|					ДвиженияпкМоделиКДоставкеПоЗаявкамНаАрендуТехникиИзменение КАК Т)) КАК Остатки
		|
		|ГДЕ
		|	Остатки.КОтгрузкеОстаток < 0	
		|	ИЛИ Остатки.КВозвратуОстаток < 0	
		|;
		|///////////////////////////////////////////////////////////////////
		|";
	КонецЕсли;
	
	Если МассивКонтролей.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ПакетЗапросов.Текст = ТекстЗапроса;
	ПакетЗапросов.МенеджерВременныхТаблиц = ДанныеТаблиц.МенеджерВременныхТаблиц;
	МассивРезультатов = ПакетЗапросов.ВыполнитьПакет();

	Итератор = -1;
	Для Каждого Результат Из МассивРезультатов Цикл

		Итератор = Итератор + 1;
		Если Результат.Пустой() Тогда
			Продолжить;
		КонецЕсли;

		ИмяКонтроля = МассивКонтролей[Итератор];

		Если ИмяКонтроля = Врег("ДвиженияпкМоделиКДоставкеПоЗаявкамНаАрендуТехникиИзменение") Тогда

			СообщитьОбОшибкахПроведенияПриДвижениипкМоделиКДоставкеПоЗаявкамНаАрендуТехники(Объект, Отказ, Результат)
			
		Иначе

			ВызватьИсключение НСтр("ru = 'Ошибка контроля проведения!'");

		КонецЕсли;
	КонецЦикла;

	Если Отказ Тогда

		Если Объект.ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
			ТекстСообщения = НСтр("ru = 'Проведение не выполнено %ПредставлениеОбъекта%'");
		Иначе
			ТекстСообщения = НСтр("ru = 'Отмена проведения не выполнена %ПредставлениеОбъекта%'");
		КонецЕсли;

		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ПредставлениеОбъекта%", Строка(Объект));
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Объект);

	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область Отчеты

// Заполняет список команд отчетов.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт

	ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуСтруктураПодчиненности(КомандыОтчетов);

КонецПроцедуры

#КонецОбласти 

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

КонецПроцедуры

// Сформировать печатные формы объектов
//
// ВХОДЯЩИЕ:
//   ИменаМакетов    - Строка    - Имена макетов, перечисленные через запятую
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать
//   ПараметрыПечати - Структура - Структура дополнительных параметров печати
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "КомплектДокументов") Тогда
		КоллекцияПечатныхФорм.Очистить();
		СформироватьКомплектПечатныхФорм(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати);
	КонецЕсли;
	
	ФормированиеПечатныхФорм.ЗаполнитьПараметрыОтправки(ПараметрыВывода.ПараметрыОтправки, МассивОбъектов, КоллекцияПечатныхФорм);
	
КонецПроцедуры

Функция СформироватьКомплектПечатныхФорм(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати) Экспорт
	
	Перем АдресКомплектаПечатныхФорм;
	
	Если ТипЗнч(ПараметрыПечати) = Тип("Структура") И ПараметрыПечати.Свойство("АдресКомплектаПечатныхФорм", АдресКомплектаПечатныхФорм) Тогда
		
		КомплектПечатныхФорм = ПолучитьИзВременногоХранилища(АдресКомплектаПечатныхФорм);
		
	Иначе
		
		КомплектПечатныхФорм = РегистрыСведений.НастройкиПечатиОбъектов.КомплектПечатныхФорм(
			Метаданные.Документы.пкЗаданиеНаПеревозку.ПолноеИмя(),
			МассивОбъектов, Неопределено);
		
	КонецЕсли;
		
	Если КомплектПечатныхФорм = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	СтруктураТипов = Новый Соответствие;
	СтруктураТипов.Вставить("Документ.пкЗаданиеНаПеревозку", МассивОбъектов);
	
	РегистрыСведений.НастройкиПечатиОбъектов.СформироватьКомплектВнешнихПечатныхФорм(
		"Документ.пкЗаданиеНаПеревозку",
		МассивОбъектов,
		ПараметрыПечати,
		КоллекцияПечатныхФорм,
		ОбъектыПечати);
	
КонецФункции

Функция КомплектПечатныхФорм() Экспорт
	
	КомплектПечатныхФорм = РегистрыСведений.НастройкиПечатиОбъектов.ПодготовитьКомплектПечатныхФорм();
	
	Возврат КомплектПечатныхФорм;
	
КонецФункции

Процедура ЗаполнитьСтруктуруПолучателейПечатныхФорм(СтруктураДанныхОбъектаПечати) Экспорт
	
КонецПроцедуры

Функция ДоступныеДляШаблоновПечатныеФормы() Экспорт

	МассивДоступныхПечатныхФорм = Новый Массив;
	ШаблоныСообщенийСервер.ДобавитьВМассивПечатныеФормыСчета(МассивДоступныхПечатныхФорм);
	
	Возврат МассивДоступныхПечатныхФорм

КонецФункции

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

Функция ПолноеИмяОбъекта()
	
	Возврат "Документ.пкЗаданиеНаПеревозку";
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли

///////////////////////////////////////////////////////////////////////
Функция СоотвествиеДанныхМоделиИТехники(ИсходныйОбъект, ОбъектСравнения) Экспорт
	
	УстановленоНесоответствие = Ложь;
	
	Если ИсходныйОбъект.ВидОперации <> ОбъектСравнения.ВидОперации Тогда
		
		УстановленоНесоответствие = Истина;
		
		тСообщение = Новый СообщениеПользователю;
		тСообщение.Текст = НСтр("ru='Нет соответствия вида операции!: '") + ИсходныйОбъект.Ссылка + " / " + ОбъектСравнения.Ссылка;
		тСообщение.Сообщить();
		
	КонецЕсли;
		
	Если ЗначениеЗаполнено(ИсходныйОбъект.ЗаданиеНаПеревозку) И ЗначениеЗаполнено(ОбъектСравнения.ЗаданиеНаПеревозку) Тогда
		
		УстановленоНесоответствие = Истина;
		
		тСообщение = Новый СообщениеПользователю;
		тСообщение.Текст = НСтр("ru='Нельзя вводить задание на перекат на основании подчиенного задания!: '") + ИсходныйОбъект.Ссылка + " / " + ОбъектСравнения.Ссылка;
		тСообщение.Сообщить();
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИсходныйОбъект.ЗаданиеНаПеревозку) И ИсходныйОбъект.ЗаданиеНаПеревозку <> ОбъектСравнения.Ссылка Тогда
		
		УстановленоНесоответствие = Истина;
		
		тСообщение = Новый СообщениеПользователю;
		тСообщение.Текст = НСтр("ru='Задание завершает другой перекат:'") + ИсходныйОбъект.Ссылка + " / " + ОбъектСравнения.Ссылка;
		тСообщение.Сообщить();
		
	КонецЕсли;

	Если ЗначениеЗаполнено(ОбъектСравнения.ЗаданиеНаПеревозку) И ОбъектСравнения.ЗаданиеНаПеревозку <> ИсходныйОбъект.Ссылка Тогда
		
		УстановленоНесоответствие = Истина;
		
		тСообщение = Новый СообщениеПользователю;
		тСообщение.Текст = НСтр("ru='Задание завершается другим перекатом!: '") + ИсходныйОбъект.Ссылка + " / " + ОбъектСравнения.Ссылка;
		тСообщение.Сообщить();
		
	КонецЕсли;
	
	Если ИсходныйОбъект.Модель <> ОбъектСравнения.Модель Тогда
		
		УстановленоНесоответствие = Истина;
		
		тСообщение = Новый СообщениеПользователю;
		тСообщение.Текст = НСтр("ru='Нет соответствия модели основного и подчиненного заданий!: '") + ИсходныйОбъект.Ссылка + " / " + ОбъектСравнения.Ссылка;
		тСообщение.Сообщить();
		
	КонецЕсли;
	
	Если ИсходныйОбъект.Техника <> ОбъектСравнения.Техника Тогда
		
		УстановленоНесоответствие = Истина;
		
		тСообщение = Новый СообщениеПользователю;
		тСообщение.Текст = НСтр("ru='Нет соответствия выбранной техники основного и подчиненного заданий!: '") + ИсходныйОбъект.Ссылка + " / " + ОбъектСравнения.Ссылка;
		тСообщение.Сообщить();
		
	КонецЕсли;
				
	Возврат НЕ УстановленоНесоответствие;
				
КонецФункции

// Проставляет технику в документ и проводит его. Возвращает структуру (ДокументПроведен, ОписаниеОшибки)
//
Функция УстановитьТехнику(ДокументСсылка, Техника) Экспорт
	
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("ДокументПроведен");
	СтруктураВозврата.Вставить("ОписаниеОшибки");
	
	Если ЗначениеЗаполнено(ДокументСсылка) Тогда 
		
		Если Техника <> ДокументСсылка.Техника Тогда 
			
			ДокументОбъект = ДокументСсылка.ПолучитьОбъект();
			ДокументОбъект.Техника = Техника;
			Попытка
				ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение, РежимПроведенияДокумента.Неоперативный);
				СтруктураВозврата.ДокументПроведен = Истина;
			Исключение
				СтруктураВозврата.ДокументПроведен = Ложь;
				СтруктураВозврата.ОписаниеОшибки = ОписаниеОшибки();
			КонецПопытки;
			
		Иначе
			
			Если Техника = ДокументСсылка.Техника Тогда 
				СтруктураВозврата.ДокументПроведен = Ложь;
				СтруктураВозврата.ОписаниеОшибки = "Техника не изменилась!";
			Иначе
				СтруктураВозврата.ДокументПроведен = Ложь;
				СтруктураВозврата.ОписаниеОшибки = "Техника не заполнена!";
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		СтруктураВозврата.ДокументПроведен = Ложь;
		СтруктураВозврата.ОписаниеОшибки = "Документ не найден!";
		
	КонецЕсли;	

	Возврат СтруктураВозврата;
	
КонецФункции

