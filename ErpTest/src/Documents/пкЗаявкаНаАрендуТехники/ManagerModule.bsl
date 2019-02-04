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

// Функция возвращает текст запроса для определения реквизитов доставки.
//
// Возвращаемое значение:
//	Строка - Текст запроса
//
Функция ТекстЗапросаРеквизитыДоставки() Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Шапка.Номер             КАК Номер,
	|	Шапка.Проведен          КАК Проведен,
	|	Шапка.Ссылка            КАК Ссылка,
	|	Шапка.Дата              КАК Дата,
	|	Шапка.Партнер           КАК ПолучательОтправитель,
	|	Шапка.ПеревозчикПартнер КАК Перевозчик,
	|	ВЫБОР КОГДА Шапка.СпособДоставки = ЗНАЧЕНИЕ(Перечисление.СпособыДоставки.СиламиПеревозчика)
	|			И НЕ &ИспользоватьЗаданияНаПеревозкуДляУчетаДоставкиПеревозчиками
	|		ТОГДА ЗНАЧЕНИЕ(Перечисление.СпособыДоставки.Самовывоз)
	|		ИНАЧЕ Шапка.СпособДоставки
	|	КОНЕЦ                   КАК СпособДоставки,
	|	Шапка.ЗонаДоставки      КАК Зона,
	|
	|	ВЫБОР КОГДА СпособДоставки = ЗНАЧЕНИЕ(Перечисление.СпособыДоставки.СиламиПеревозчикаПоАдресу)
	|		ТОГДА Шапка.АдресДоставкиПеревозчика
	|		ИНАЧЕ Шапка.АдресДоставки
	|		КОНЕЦ               КАК Адрес,
	|
	|	ВЫБОР КОГДА СпособДоставки = ЗНАЧЕНИЕ(Перечисление.СпособыДоставки.СиламиПеревозчикаПоАдресу)
	|		ТОГДА Шапка.АдресДоставкиПеревозчикаЗначенияПолей
	|		ИНАЧЕ Шапка.АдресДоставкиЗначенияПолей
	|		КОНЕЦ               КАК АдресЗначенияПолей,
	|
	|	Шапка.ВремяДоставкиС    КАК ВремяС,
	|	Шапка.ВремяДоставкиПо   КАК ВремяПо,
	|	Шапка.ДополнительнаяИнформацияПоДоставке
	|		                    КАК ДополнительнаяИнформация,
	|	Т.Склад                 КАК Склад,
	|	Т.ДоставитьПолностью    КАК ДоставитьПолностью,
	|	Шапка.ОсобыеУсловияПеревозки  КАК ОсобыеУсловияПеревозки,
	|	Шапка.ОсобыеУсловияПеревозкиОписание КАК ОсобыеУсловияПеревозкиОписание,
	|	Шапка.Соглашение.РазбиватьРасходныеОрдераПоРаспоряжениям КАК РазбиватьРасходныеОрдераПоРаспоряжениям
	|
	|ИЗ
	|	(ВЫБРАТЬ
	|		Т.Ссылка КАК Ссылка,
	|		Т.Склад КАК Склад,
	|		МИНИМУМ(Т.ВариантОбеспечения В (
	|			ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.Отгрузить),
	|			ЗНАЧЕНИЕ(перечисление.ВариантыОбеспечения.ОтгрузитьОбособленно)))
	|				КАК ДоставитьПолностью
	|	ИЗ
	|		Документ.пкЗаявкаНаАрендуТехники.Товары КАК Т
	|	ГДЕ
	|		Т.Ссылка В (&Ссылки)
	|		И Т.Номенклатура.ТипНоменклатуры В (
	|			ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар),
	|			ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара))
	|	
	|	СГРУППИРОВАТЬ ПО
	|		Т.Ссылка,
	|		Т.Склад
	|	
	|	ИМЕЮЩИЕ
	|		МАКСИМУМ(ВЫБОР
	|				КОГДА Т.ВариантОбеспечения В (
	|					ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.Отгрузить),
	|					ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.ОтгрузитьОбособленно))
	|				ТОГДА ИСТИНА
	|			КОНЕЦ) = ИСТИНА
	|	) КАК Т
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.пкЗаявкаНаАрендуТехники КАК Шапка
	|		ПО (Шапка.Ссылка = Т.Ссылка)";
	
	Возврат ТекстЗапроса;
	
КонецФункции

#Область СозданиеНаОсновании

// Заполняет список команд создания на основании.
// 
// Параметры:
//   КомандыСоздатьНаОсновании - ТаблицаЗначений - состав полей см. в функции ВводНаОсновании.СоздатьКоллекциюКомандСоздатьНаОсновании
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСоздатьНаОсновании, НастройкиФормы) Экспорт
		
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

	Если ПравоДоступа("Добавление", Метаданные.Документы.ЗаказКлиента) Тогда
		КомандаСоздатьНаОсновании = КомандыСоздатьНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Идентификатор = Метаданные.Документы.ЗаказКлиента.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(Метаданные.Документы.ЗаказКлиента);
		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;

	Возврат Неопределено;
КонецФункции

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
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ДанныеДокумента.Дата КАК Дата,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.Партнер КАК Партнер,
	|	ДанныеДокумента.Контрагент КАК Контрагент,
	|	ДанныеДокумента.Проведен КАК Проведен,
	|	ДанныеДокумента.Договор КАК Договор
	|ИЗ
	|	Документ.пкЗаявкаНаАрендуТехники КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &ДокументСсылка
	|");
	
	Запрос.УстановитьПараметр("ДокументСсылка", ДокументСсылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Дата = Выборка.Дата;
		Организация = Выборка.Организация;
		Партнер = Выборка.Партнер;
		Контрагент = Выборка.Контрагент;
		Договор = Выборка.Договор;
	Иначе
		Дата = Дата(1,1,1);
		Организация = Справочники.Организации.ПустаяСсылка();
		Партнер = Справочники.Партнеры.ПустаяСсылка();
		Контрагент = Справочники.Контрагенты.ПустаяСсылка();
		Договор = Справочники.ДоговорыКонтрагентов.ПустаяСсылка();
	КонецЕсли;
	
	СтруктураРеквизитов = Новый Структура("Дата, Организация, Партнер, Контрагент, Договор",
		Дата,
		Организация,
		Партнер,
		Контрагент,
		Договор);
	
	Возврат СтруктураРеквизитов;

КонецФункции

#КонецОбласти 

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
	ТаблицаМоделиКДоставкеПоЗаявкамНаАрендуТехники(Запрос, ТекстыЗапроса, Регистры);
    
	ПроведениеСерверУТ.ИнициализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Истина);	
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
    
	Запрос.Текст = 
	"ВЫБРАТЬ
    |   ДанныеШапки.Дата КАК Период,
    |   ДанныеШапки.Партнер КАК Партнер,
    |   ДанныеШапки.Контрагент КАК Контрагент,
    |   ДанныеШапки.Организация КАК Организация,
    |   ДанныеШапки.Ссылка КАК ЗаявкаНаАрендуТехники,
    |   ДанныеШапки.Договор КАК Договор,
    |   ДанныеШапки.ОбъектСтроительства,
    |   ДанныеШапки.Подразделение
    |ИЗ
    |   Документ.пкЗаявкаНаАрендуТехники КАК ДанныеШапки
    |ГДЕ
    |   ДанныеШапки.Ссылка = &Ссылка";
    
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	Запрос.УстановитьПараметр("Период",          	   Реквизиты.Период);
	Запрос.УстановитьПараметр("ЗаявкаНаАрендуТехники", Реквизиты.ЗаявкаНаАрендуТехники);
	Запрос.УстановитьПараметр("Партнер",           	   Реквизиты.Партнер);
	Запрос.УстановитьПараметр("Подразделение", 		   Реквизиты.Подразделение);
	Запрос.УстановитьПараметр("Договор",			   Реквизиты.Договор);
	Запрос.УстановитьПараметр("ПустаяДата",			   '00010101');
	
КонецПроцедуры

Процедура ОтразитьМоделиКДоставкеПоЗаявкамНаАрендуТехники(ДополнительныеСвойства, Движения, Отказ) Экспорт
	
	Таблица = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицапкМоделиКДоставкеПоЗаявкамНаАрендуТехники;
	
	Если Отказ ИЛИ Таблица.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДвиженияДоставка = Движения.пкМоделиКДоставкеПоЗаявкамНаАрендуТехники;
	ДвиженияДоставка.Записывать = Истина;
	ДвиженияДоставка.Загрузить(Таблица);
	
КонецПроцедуры

Функция ТаблицаМоделиКДоставкеПоЗаявкамНаАрендуТехники(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "пкМоделиКДоставкеПоЗаявкамНаАрендуТехники";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ
    |   ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
    |   НАЧАЛОПЕРИОДА(пкЗаявкаНаАрендуТехникиТовары.ДатаОтгрузки, ДЕНЬ) КАК Период,
    |   &Ссылка КАК ЗаявкаНаАрендуТехники,
    |   ЗНАЧЕНИЕ(Документ.пкЗаданиеНаПеревозку.ПустаяСсылка) КАК ЗаданиеНаПеревозку,
    |   пкЗаявкаНаАрендуТехникиТовары.НомерСтроки КАК НомерСтроки,
    |   пкЗаявкаНаАрендуТехникиТовары.КоличествоПоМодели КАК КОтгрузке,
    |   0 КАК КВозврату,
    |   пкЗаявкаНаАрендуТехникиТовары.Номенклатура КАК Модель
    |ИЗ
    |   Документ.пкЗаявкаНаАрендуТехники.Товары КАК пкЗаявкаНаАрендуТехникиТовары
    |ГДЕ
    |   пкЗаявкаНаАрендуТехникиТовары.Ссылка = &Ссылка
    |   И пкЗаявкаНаАрендуТехникиТовары.ДатаОтгрузки <> &ПустаяДата
    |   И НЕ пкЗаявкаНаАрендуТехникиТовары.Ссылка.Отменена
    |
    |ОБЪЕДИНИТЬ ВСЕ
    |
    |ВЫБРАТЬ
    |   ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход),
    |   пкЗаявкаНаАрендуТехникиТовары.ДатаВозврата,
    |   &Ссылка,
    |   ЗНАЧЕНИЕ(Документ.пкЗаданиеНаПеревозку.ПустаяСсылка),
    |   пкЗаявкаНаАрендуТехникиТовары.НомерСтроки,
    |   0,
    |   пкЗаявкаНаАрендуТехникиТовары.КоличествоПоМодели,
    |   пкЗаявкаНаАрендуТехникиТовары.Номенклатура
    |ИЗ
    |   Документ.пкЗаявкаНаАрендуТехники.Товары КАК пкЗаявкаНаАрендуТехникиТовары
    |ГДЕ
    |   пкЗаявкаНаАрендуТехникиТовары.Ссылка = &Ссылка
    |   И пкЗаявкаНаАрендуТехникиТовары.ДатаВозврата <> &ПустаяДата
	|   И НЕ пкЗаявкаНаАрендуТехникиТовары.Ссылка.Отменена";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область Отчеты

// Заполняет список команд отчетов.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт

	ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуСтруктураПодчиненности(КомандыОтчетов);

    //ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуПродажиПоЗаказу(КомандыОтчетов);

    //КомандаОтчет = ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуКарточкаРасчетовСКлиентомПоДокументам(КомандыОтчетов);
    //Если КомандаОтчет <> Неопределено Тогда
    //	КомандаОтчет.СписокФорм = "ФормаДокумента,ФормаСписка";
    //КонецЕсли;

    //КомандаОтчет = ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуСостояниеРасчетовСКлиентомПоДокументам(КомандыОтчетов);
    //Если КомандаОтчет <> Неопределено Тогда
    //	КомандаОтчет.СписокФорм = "ФормаСпискаДокументов";
    //	КомандаОтчет.МестоРазмещенияКоманды = "ПодменюОтчетыПерейти";
    //	КомандаОтчет.Порядок = 1;
    //КонецЕсли;
    //
    //КомандаОтчет = ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуКарточкаРасчетовСКлиентомПоДокументам(КомандыОтчетов);
    //Если КомандаОтчет <> Неопределено Тогда
    //	КомандаОтчет.СписокФорм = "ФормаСпискаДокументов";
    //	КомандаОтчет.МестоРазмещенияКоманды = "ПодменюОтчетыПерейти";
    //	КомандаОтчет.Порядок = 2;
    //КонецЕсли;
    
КонецПроцедуры

#КонецОбласти 

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
		
    Если НЕ ПраваПользователяПовтИсп.ЭтоПартнер() Тогда
    	
    	// Комплект документов с настройкой...
    	КомандаПечати = КомандыПечати.Добавить();
    	КомандаПечати.МенеджерПечати = "Документ.пкЗаявкаНаАрендуТехники";
    	КомандаПечати.Идентификатор = "ЗаявкаНаАрендуТехники";
    	КомандаПечати.Представление = НСтр("ru = 'Заявка на аренду техники'");
    	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
    	КомандаПечати.Порядок = 3;        
        
    	// Комплект документов на принтер
    	КомандаПечати = КомандыПечати.Добавить();
    	КомандаПечати.Обработчик = "УправлениеПечатьюУТКлиент.ПечатьКомплектаДокументов";
    	КомандаПечати.МенеджерПечати = "";
    	КомандаПечати.Идентификатор = "КомплектДокументов";
    	КомандаПечати.СразуНаПринтер = Истина;
    	КомандаПечати.Представление = НСтр("ru = 'Комплект документов на принтер'");
    	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
    	КомандаПечати.Порядок = 1;
    	
    	// Комплект документов с настройкой...
    	КомандаПечати = КомандыПечати.Добавить();
    	КомандаПечати.Обработчик = "УправлениеПечатьюУТКлиент.ПечатьКомплектаДокументовСНастройкой";
    	КомандаПечати.МенеджерПечати = "";
    	КомандаПечати.Идентификатор = "КомплектДокументовСНастройкой";
    	КомандаПечати.Представление = НСтр("ru = 'Комплект документов с настройкой...'");
    	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
    	КомандаПечати.Порядок = 2;
    	
    КонецЕсли;
		
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
    
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ЗаявкаНаАрендуТехники") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ЗаявкаНаАрендуТехники", НСтр("ru = 'Заявка на аренду техники'"), СформироватьПечатнуюФормуЗаявкаНаАрендуТехники(МассивОбъектов, ОбъектыПечати, Неопределено, ПараметрыПечати));
    КонецЕсли;
    
	ФормированиеПечатныхФорм.ЗаполнитьПараметрыОтправки(ПараметрыВывода.ПараметрыОтправки, МассивОбъектов, КоллекцияПечатныхФорм);
	
КонецПроцедуры

Функция СформироватьПечатнуюФормуЗаявкаНаАрендуТехники(МассивОбъектов, ОбъектыПечати, КомплектыПечати, ПараметрыПечати = Неопределено)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	ДанныеДляПечати = ПолучитьДанныеДляПечати(МассивОбъектов, ПараметрыПечати);
	
	ДанныеПечати = ДанныеДляПечати.РезультатПоШапке.Выбрать();
	Товары       = ДанныеДляПечати.РезультатПоТабличнойЧасти.Выгрузить();
	
	ПервыйДокумент = Истина;
	
	Пока ДанныеПечати.Следующий() Цикл
		
		// Для печати комплектов
		Если КомплектыПечати <> Неопределено И КомплектыПечати.Колонки.Найти("Ссылка") <> Неопределено Тогда
			КомплектПечатиПоСсылке = КомплектыПечати.Найти(ДанныеПечати.Ссылка,"Ссылка");
			Если КомплектПечатиПоСсылке = Неопределено Тогда
				КомплектПечатиПоСсылке = КомплектыПечати[0];
			КонецЕсли;
			Если КомплектПечатиПоСсылке.Экземпляров = 0 Тогда
				Продолжить
			КонецЕсли;
		КонецЕсли;
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ЗаполнитьТабличныйДокументЗаявкаНаАрендуТехники(ТабличныйДокумент, ДанныеПечати, Товары);
		
		// Выведем нужное количество экземпляров (при печати комплектов)
		Если КомплектыПечати <> Неопределено И КомплектыПечати.Колонки.Найти("Ссылка") <> Неопределено И КомплектПечатиПоСсылке.Экземпляров > 1 Тогда
			ОбластьКопирования = ТабличныйДокумент.ПолучитьОбласть(НомерСтрокиНачало,,ТабличныйДокумент.ВысотаТаблицы);
			Для Итератор = 2 По КомплектПечатиПоСсылке.Экземпляров Цикл
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				ТабличныйДокумент.Вывести(ОбластьКопирования);
			КонецЦикла;
		КонецЕсли;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ДанныеПечати.Ссылка);
		
	КонецЦикла;
	
	Если ПривилегированныйРежим() Тогда
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция ПолучитьДанныеДляПечати(МассивОбъектов, ПараметрыПечати)
		
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Запрос.Текст = 
	"ВЫБРАТЬ
    |   пкЗаявкаНаАрендуТехникиТовары.Номенклатура.НаименованиеПолное КАК Модель,
    |   пкЗаявкаНаАрендуТехникиТовары.КоличествоПоМодели КАК Количество,
    |   пкЗаявкаНаАрендуТехникиТовары.ДатаНачалаАренды,
    |   пкЗаявкаНаАрендуТехникиТовары.ДатаОкончанияАренды
    |ПОМЕСТИТЬ ВТ_Техника
    |ИЗ
    |   Документ.пкЗаявкаНаАрендуТехники.Товары КАК пкЗаявкаНаАрендуТехникиТовары
    |ГДЕ
    |   пкЗаявкаНаАрендуТехникиТовары.Ссылка В(&МассивОбъектов)
    |;
    |
    |////////////////////////////////////////////////////////////////////////////////
    |ВЫБРАТЬ
    |   МИНИМУМ(ВТ_Техника.ДатаНачалаАренды) КАК ДатаНачалаАренды,
    |   МАКСИМУМ(ВТ_Техника.ДатаОкончанияАренды) КАК ДатаОкончанияАренды
    |ПОМЕСТИТЬ ВТ_СрокиАренды
    |ИЗ
    |   ВТ_Техника КАК ВТ_Техника
    |;
    |
    |////////////////////////////////////////////////////////////////////////////////
    |ВЫБРАТЬ
    |   пкЗаявкаНаАрендуТехники.Ссылка КАК Ссылка,
    |   пкЗаявкаНаАрендуТехники.Номер КАК Номер,
    |   пкЗаявкаНаАрендуТехники.Дата КАК Дата,
    |   пкЗаявкаНаАрендуТехники.Организация КАК Организация,
    |   пкЗаявкаНаАрендуТехники.Организация.НаименованиеСокращенное КАК ОрганизацияСокращенноеНаименование,
    |   пкЗаявкаНаАрендуТехники.Организация.Наименование КАК ОрганизацияНаименование,
    |   ЕСТЬNULL(пкЗаявкаНаАрендуТехники.Менеджер.ФизическоеЛицо.Наименование, пкЗаявкаНаАрендуТехники.Менеджер.Наименование) КАК Менеджер,
    |   пкЗаявкаНаАрендуТехники.КонтактноеЛицо КАК КонтактноеЛицо,
    |   пкЗаявкаНаАрендуТехники.Партнер КАК Партнер,
    |   пкЗаявкаНаАрендуТехники.ДополнительнаяИнформация КАК ДополнительнаяИнформация,
    |   пкЗаявкаНаАрендуТехники.ОбъектСтроительства,
    |   пкЗаявкаНаАрендуТехники.НаличиеППР,
    |   пкЗаявкаНаАрендуТехники.ОтветственныйЗаБезопасность,
    |   пкЗаявкаНаАрендуТехники.Рабочие,
    |   пкЗаявкаНаАрендуТехники.Машинисты,
    |   пкЗаявкаНаАрендуТехники.ВидРабот,
    |   пкЗаявкаНаАрендуТехники.НаличиеЛЭП,
    |   пкЗаявкаНаАрендуТехники.ДокументыПереданы,
    |   ВТ_СрокиАренды.ДатаНачалаАренды,
    |   ВТ_СрокиАренды.ДатаОкончанияАренды
    |ИЗ
    |   Документ.пкЗаявкаНаАрендуТехники КАК пкЗаявкаНаАрендуТехники
    |       ЛЕВОЕ СОЕДИНЕНИЕ ВТ_СрокиАренды КАК ВТ_СрокиАренды
    |       ПО (ИСТИНА)
    |ГДЕ
    |   пкЗаявкаНаАрендуТехники.Ссылка В(&МассивОбъектов)
    |
    |УПОРЯДОЧИТЬ ПО
    |   Ссылка
    |;
    |
    |////////////////////////////////////////////////////////////////////////////////
    |ВЫБРАТЬ
    |   ВТ_Техника.Модель,
    |   ВТ_Техника.Количество
    |ИЗ
    |   ВТ_Техника КАК ВТ_Техника";
			
	ПакетРезультатовЗапроса = Запрос.ВыполнитьПакет();
	
	СтруктураДанныхДляПечати = Новый Структура;
	СтруктураДанныхДляПечати.Вставить("РезультатПоШапке", ПакетРезультатовЗапроса[2]);
	СтруктураДанныхДляПечати.Вставить("РезультатПоТабличнойЧасти", ПакетРезультатовЗапроса[3]);
	
	Возврат СтруктураДанныхДляПечати;
	
КонецФункции

Процедура ЗаполнитьТабличныйДокументЗаявкаНаАрендуТехники(ТабДокумент, ДанныеОбъекта, Товары)
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.пкЗаявкаНаАрендуТехники.ЗаявкаНаАрендуТехники");
    
    ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
    ОбластьШапка.Параметры.Контрагент = ДанныеОбъекта.Партнер;
    
    СведенияОбАрендаторе = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеОбъекта.Партнер, ДанныеОбъекта.Дата);

    ОбластьШапка.Параметры.Телефоны = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОбАрендаторе, "Телефоны");
	
//rarus+ saveld 08.11.2016	
	ШтрихкодированиеПечатныхФорм.кнВывестиШтрихкодEANВТабличныйДокумент(ТабДокумент, Макет, ОбластьШапка, ДанныеОбъекта.Ссылка, "Заявка на аренду техники");
//rarus- saveld 08.11.2016	
	
	ТабДокумент.Вывести(ОбластьШапка);
    
    ОбластьНоменклатура = Макет.ПолучитьОбласть("ТабЧасть");
    СтрТехника = "";
    Для каждого Строка Из Товары Цикл
        Если СтрТехника <> "" Тогда
            СтрТехника = СтрТехника + ", " + Строка.Модель + " - " + Строка(Строка.Количество) + "шт.";
        Иначе
            СтрТехника = Строка.Модель + " - " + Строка(Строка.Количество) + "шт.";
        КонецЕсли;	
    КонецЦикла;
    
    ОбластьНоменклатура.Параметры.Техника = СтрТехника;

    ТабДокумент.Вывести(ОбластьНоменклатура);
    
    ОбластьДанные = Макет.ПолучитьОбласть("Данные");
    
    ОбластьДанные.Параметры.ВидРабот 	   =  ДанныеОбъекта.ВидРабот;
    ОбластьДанные.Параметры.ППР 		   =  ДанныеОбъекта.НаличиеППР;
    ОбластьДанные.Параметры.Объект 		   =  ДанныеОбъекта.ОбъектСтроительства;
    ОбластьДанные.Параметры.ДатаНач		   =  Формат(ДанныеОбъекта.ДатаНачалаАренды, "ДЛФ=Д");
    ОбластьДанные.Параметры.ДатаКон		   =  Формат(ДанныеОбъекта.ДатаОкончанияАренды, "ДЛФ=Д");
    ОбластьДанные.Параметры.Ответственный  =  ДанныеОбъекта.ОтветственныйЗаБезопасность;
    ОбластьДанные.Параметры.Рабочие        =  ДанныеОбъекта.Рабочие;
    ОбластьДанные.Параметры.Машинисты 	   =  ДанныеОбъекта.Машинисты;
    ОбластьДанные.Параметры.КонтактноеЛицо =  ДанныеОбъекта.КонтактноеЛицо;
    ОбластьДанные.Параметры.ЛЭП 		   =  ДанныеОбъекта.НаличиеЛЭП;
    ОбластьДанные.Параметры.НСС 		   =  ДанныеОбъекта.ДокументыПереданы;
	
    ТабДокумент.Вывести(ОбластьДанные);
        
КонецПроцедуры

Функция СформироватьКомплектПечатныхФорм(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати) Экспорт
	
	Перем АдресКомплектаПечатныхФорм;
	
	Если ТипЗнч(ПараметрыПечати) = Тип("Структура") И ПараметрыПечати.Свойство("АдресКомплектаПечатныхФорм", АдресКомплектаПечатныхФорм) Тогда
		
		КомплектПечатныхФорм = ПолучитьИзВременногоХранилища(АдресКомплектаПечатныхФорм);
		
	Иначе
		
		КомплектПечатныхФорм = РегистрыСведений.НастройкиПечатиОбъектов.КомплектПечатныхФорм(
			Метаданные.Документы.пкЗаявкаНаАрендуТехники.ПолноеИмя(),
			МассивОбъектов, Неопределено);
		
	КонецЕсли;
		
	Если КомплектПечатныхФорм = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	СтруктураТипов = Новый Соответствие;
	СтруктураТипов.Вставить("Документ.пкЗаявкаНаАрендуТехники", МассивОбъектов);
	
	ИмяМакета = "ЗаявкаНаАрендуТехники";
	ТекущийКомплект = КомплектПечатныхФорм.Скопировать(Новый Структура("Имя,Печатать,",ИмяМакета,Истина));
	Если ТекущийКомплект.Количество() > 0 Тогда
		
		Если ТекущийКомплект.Колонки.Найти("Ссылка") <> Неопределено И ЗначениеЗаполнено(ТекущийКомплект[0].Ссылка) Тогда
			
			РегистрыСведений.НастройкиПечатиОбъектов.СкопироватьПечатнуюФормуВКоллекциюОдинЭкземпляр(КоллекцияПечатныхФорм, ИмяМакета);
			ТаблицаСсылок = ТекущийКомплект.Скопировать(, "Ссылка");
			ТаблицаСсылок.Свернуть("Ссылка");
			ТекущаяСтруктураТипов = Новый Соответствие;
			ТекущаяСтруктураТипов.Вставить("Документ.пкЗаявкаНаАрендуТехники", ТаблицаСсылок.ВыгрузитьКолонку("Ссылка"));
			
		Иначе
			
			РегистрыСведений.НастройкиПечатиОбъектов.СкопироватьПечатнуюФормуВКоллекцию(КоллекцияПечатныхФорм, ТекущийКомплект[0]);
			ТекущаяСтруктураТипов = СтруктураТипов;
			
		КонецЕсли;
				
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			ИмяМакета,
			ТекущийКомплект[0].Представление,
			Обработки.ПечатьЗаказовНаТоварыУслуги.СформироватьПечатнуюФормуЗаказаКлиента(ТекущаяСтруктураТипов, ОбъектыПечати, ПараметрыПечати, ТекущийКомплект));
		
	КонецЕсли;
		
	РегистрыСведений.НастройкиПечатиОбъектов.СформироватьКомплектВнешнихПечатныхФорм(
		"Документ.пкЗаявкаНаАрендуТехники",
		МассивОбъектов,
		ПараметрыПечати,
		КоллекцияПечатныхФорм,
		ОбъектыПечати);
	
КонецФункции

Функция КомплектПечатныхФорм() Экспорт
	
	КомплектПечатныхФорм = РегистрыСведений.НастройкиПечатиОбъектов.ПодготовитьКомплектПечатныхФорм();
	
	РегистрыСведений.НастройкиПечатиОбъектов.ДобавитьПечатнуюФормуВКомплект(КомплектПечатныхФорм, "пкЗаявкаНаАрендуТехники", НСтр("ru = 'Заявка на аренду техники'"), 0);
	
	Возврат КомплектПечатныхФорм;
	
КонецФункции

Процедура ЗаполнитьСтруктуруПолучателейПечатныхФорм(СтруктураДанныхОбъектаПечати) Экспорт
	
	СтруктураДанныхОбъектаПечати.ОсновнойПолучатель = "Партнер";
	
	СтруктураДанныхОбъектаПечати.МассивРеквизитовПолучателей.Добавить("Партнер");
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровИКонтрагентов") Тогда 
		СтруктураДанныхОбъектаПечати.МассивРеквизитовПолучателей.Добавить("Контрагент");
	КонецЕсли;
	СтруктураДанныхОбъектаПечати.МассивРеквизитовПолучателей.Добавить("КонтактноеЛицо");
	СтруктураДанныхОбъектаПечати.МассивРеквизитовПолучателей.Добавить("Грузоотправитель");
	СтруктураДанныхОбъектаПечати.МассивРеквизитовПолучателей.Добавить("Грузополучатель");
	
КонецПроцедуры

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

Функция ПолноеИмяОбъекта()
	Возврат "Документ.пкЗаявкаНаАрендуТехники";
КонецФункции

Функция МетаданныеДокумента() Экспорт
	
	СтруктураОбъекта = НаправленияДеятельностиСервер.СтруктураОбъекта();
	СтруктураОбъекта.ЭтоИсточникПотребности = Истина;
	СтруктураОбъекта.ЕстьНазначениеВТЧ = Ложь;
	Возврат СтруктураОбъекта;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли

