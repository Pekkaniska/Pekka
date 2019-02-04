#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает настройки комплекта печатных форм, используемых для объекта
//
// Параметры:
//  ТипОбъекта - строка - полное наименование объекта, для которого необходимо получить настройки печатных форм
//  Ссылка - ЛюбаяСсылка, ссылка для которой необходимо получить реквизиты
//  ВариантИспользования - Число - переменная, в которую помещается описание, для каких измерений применяется настройка.
//
// Возвращаемое значение:
//  ТаблицаЗначений - таблица значений, возвращаемая функций ПодготовитьКомплектПечатныхФорм().
//
Функция КомплектПечатныхФорм(ТипОбъекта, Знач МассивСсылок = Неопределено, ВариантИспользования = 0) Экспорт
	
	ТаблицаОбъектов = ТаблицаОбъектовДляПечатиКомплектно();
	ТекущийОбъект = ТаблицаОбъектов.Найти(ТипОбъекта, "ТипОбъекта");
	ВариантИспользования = 0;
	
	Если ТекущийОбъект = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ЕстьОрганизация = ТекущийОбъект.ЕстьОрганизация И МассивСсылок <> Неопределено;
	ЕстьПартнер = ТекущийОбъект.ЕстьПартнер И МассивСсылок <> Неопределено;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ОбъектыПечати.Ссылка КАК Ссылка"
		+?(ЕстьОрганизация,", ОбъектыПечати.Организация КАК Организация","")
		+ ?(ЕстьПартнер,", ОбъектыПечати.Партнер","") + "
	|ПОМЕСТИТЬ ВТ_Ссылки
	|ИЗ
	|	" + ТипОбъекта + " КАК ОбъектыПечати
	|ГДЕ
	|	ОбъектыПечати.Ссылка В(&МассивСсылок)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НастройкиПечатиОбъектов.Настройки КАК Настройки,
	|	1 КАК Порядок,
	|	ЕСТЬNULL(ВТ_Ссылки.Ссылка, НЕОПРЕДЕЛЕНО) КАК Ссылка,
	|	NULL КАК Организация,
	|	NULL КАК Партнер
	|ПОМЕСТИТЬ ВТ_НастройкиПечати
	|ИЗ
	|	РегистрСведений.НастройкиПечатиОбъектов КАК НастройкиПечатиОбъектов
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Ссылки КАК ВТ_Ссылки
	|		ПО (ИСТИНА)
	|ГДЕ
	|	НастройкиПечатиОбъектов.ТипОбъекта = &ТипОбъекта
	|	И НастройкиПечатиОбъектов.Организация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|	И НастройкиПечатиОбъектов.Партнер = ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка)";
	
	Если ЕстьОрганизация Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	НастройкиПечатиОбъектов.Настройки,
		|	2,
		|	ЕСТЬNULL(ВТ_Ссылки.Ссылка, НЕОПРЕДЕЛЕНО),
		|	NULL,
		|	НастройкиПечатиОбъектов.Партнер
		|ИЗ
		|	РегистрСведений.НастройкиПечатиОбъектов КАК НастройкиПечатиОбъектов
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_Ссылки КАК ВТ_Ссылки
		|		ПО (ВТ_Ссылки.Организация = НастройкиПечатиОбъектов.Организация)
		|ГДЕ
		|	НастройкиПечатиОбъектов.ТипОбъекта = &ТипОбъекта
		|	И НастройкиПечатиОбъектов.Партнер = ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка)";
	КонецЕсли;
	
	Если ЕстьПартнер Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	НастройкиПечатиОбъектов.Настройки,
		|	2,
		|	ЕСТЬNULL(ВТ_Ссылки.Ссылка, НЕОПРЕДЕЛЕНО),
		|	NULL,
		|	НастройкиПечатиОбъектов.Партнер
		|ИЗ
		|	РегистрСведений.НастройкиПечатиОбъектов КАК НастройкиПечатиОбъектов
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_Ссылки КАК ВТ_Ссылки
		|		ПО (ВТ_Ссылки.Партнер = НастройкиПечатиОбъектов.Партнер)
		|ГДЕ
		|	НастройкиПечатиОбъектов.ТипОбъекта = &ТипОбъекта
		|	И НастройкиПечатиОбъектов.Организация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)";
	КонецЕсли;
	
	Если ТекущийОбъект.ЕстьПартнер И ТекущийОбъект.ЕстьОрганизация И МассивСсылок <> Неопределено Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	НастройкиПечатиОбъектов.Настройки,
		|	3,
		|	ЕСТЬNULL(ВТ_Ссылки.Ссылка, НЕОПРЕДЕЛЕНО),
		|	НастройкиПечатиОбъектов.Организация,
		|	НастройкиПечатиОбъектов.Партнер
		|ИЗ
		|	РегистрСведений.НастройкиПечатиОбъектов КАК НастройкиПечатиОбъектов
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_Ссылки КАК ВТ_Ссылки
		|		ПО (ВТ_Ссылки.Партнер = НастройкиПечатиОбъектов.Партнер)
		|			И (ВТ_Ссылки.Организация = НастройкиПечатиОбъектов.Организация)
		|ГДЕ
		|	НастройкиПечатиОбъектов.ТипОбъекта = &ТипОбъекта";
	КонецЕсли;
	
	ТекстЗапроса = ТекстЗапроса + "
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_НастройкиПечатиСгруппированная.Ссылка КАК Ссылка,
	|	ВТ_НастройкиПечатиСгруппированная.Порядок КАК Порядок,
	|	ВТ_НастройкиПечати.Настройки
	|ИЗ
	|	(ВЫБРАТЬ
	|		МАКСИМУМ(ВТ_НастройкиПечати.Порядок) КАК Порядок,
	|		ВТ_НастройкиПечати.Ссылка КАК Ссылка
	|	ИЗ
	|		ВТ_НастройкиПечати КАК ВТ_НастройкиПечати
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ВТ_НастройкиПечати.Ссылка) КАК ВТ_НастройкиПечатиСгруппированная
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_НастройкиПечати КАК ВТ_НастройкиПечати
	|		ПО ВТ_НастройкиПечатиСгруппированная.Порядок = ВТ_НастройкиПечати.Порядок
	|			И ВТ_НастройкиПечатиСгруппированная.Ссылка = ВТ_НастройкиПечати.Ссылка";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ТипОбъекта", ТипОбъекта);
	Если ТипЗнч(МассивСсылок) <> Тип("Массив") Тогда
		НовыйМассивСсылок = Новый Массив;
		НовыйМассивСсылок.Добавить(МассивСсылок);
		МассивСсылок = НовыйМассивСсылок;
	КонецЕсли;
	Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
	РезультатЗапроса = Запрос.Выполнить();
	
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ТипОбъекта);
	КомплектПоУмолчанию = МенеджерОбъекта.КомплектПечатныхФорм();
	КоллекцияПечатныхФорм = ПодготовитьКомплектПечатныхФорм();
	
	// добавление внешних печатных форм в комплект
	ПрефиксВнешнихПечатныхФорм = "ВнешняяПечатнаяФорма.";
	КоллекцияВнешнихПечатныхФорм = ПодготовитьКомплектПечатныхФорм();
	
	ЗапросТаблицаКоманд = ДополнительныеОтчетыИОбработки.НовыйЗапросПоДоступнымКомандам(Перечисления.ВидыДополнительныхОтчетовИОбработок.ПечатнаяФорма, ТипОбъекта, Истина);
	ТаблицаКоманд = ЗапросТаблицаКоманд.Выполнить().Выгрузить();
	
	Для Каждого КомандаПечати Из ТаблицаКоманд Цикл
		ДобавитьПечатнуюФормуВКомплект(КомплектПоУмолчанию, ПрефиксВнешнихПечатныхФорм + КомандаПечати.Идентификатор, КомандаПечати.Представление, 0);
	КонецЦикла;
	
	Выборка = РезультатЗапроса.Выбрать();
	Для Каждого ОбъектСсылка Из МассивСсылок Цикл
		Если Выборка.НайтиСледующий(ОбъектСсылка, "Ссылка") Тогда
			НастройкиПечати = Выборка.Настройки.Получить();
			НастройкиПечати.Колонки.Добавить("Ссылка");
		Иначе
			НастройкиПечати = КомплектПоУмолчанию;
		КонецЕсли;
		НастройкиПечати.ЗаполнитьЗначения(ОбъектСсылка, "Ссылка");
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(НастройкиПечати,КоллекцияПечатныхФорм);
		Выборка.Сбросить();
	КонецЦикла;
	
	Если Выборка.Следующий() Тогда
		Если Выборка.Порядок = 1 Или Выборка.Порядок = 2 Тогда
				ВариантИспользования = Выборка.Порядок;
			Иначе
				ВариантИспользования = 3;
		КонецЕсли;
	КонецЕсли;
	
	Возврат КоллекцияПечатныхФорм;
	
КонецФункции

// Записывает настройки комплекта печатных форм, используемых для документа
//
// Параметры:
//		ТипОбъекта - строка - полное наименование объекта, для которого необходимо получить настройки печатных форм
//		КомплектПечатныхФорм - ТаблицаЗначений возвращаемая функций ПодготовитьКомплектПечатныхФорм()
//		ЗаписыватьОрганизацию - Булево - признак, указывающий на необходимость записи настройки в разрезе организации
//		ЗаписыватьПартнера - Булево - признак, указывающий на необходимость записи настройки в разрезе партнера
//		Ссылка - ЛюбаяСсылка, ссылка из которой необходимо извлечь организацию и/или партнера.
//
Процедура ЗаписатьНастройкиПечатиОбъекта(ТипОбъекта, КомплектПечатныхФорм, ЗаписыватьОрганизацию = Ложь, ЗаписыватьПартнера = Ложь, Ссылка = Неопределено) Экспорт
	
	ТаблицаОбъектов = ТаблицаОбъектовДляПечатиКомплектно();
	ТекущийОбъект = ТаблицаОбъектов.Найти(ТипОбъекта, "ТипОбъекта");
	
	Если ТекущийОбъект = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаписьНастройкиПечатиОбъектов = РегистрыСведений.НастройкиПечатиОбъектов.СоздатьМенеджерЗаписи();
	ЗаписьНастройкиПечатиОбъектов.ТипОбъекта = ТипОбъекта;
	ЗаписьНастройкиПечатиОбъектов.Настройки = Новый ХранилищеЗначения(КомплектПечатныхФорм);
	
	Если ЗаписыватьОрганизацию И ЗаписыватьПартнера Тогда
		Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "Партнер,Организация");
		ЗаписьНастройкиПечатиОбъектов.Организация = Реквизиты.Организация;
		ЗаписьНастройкиПечатиОбъектов.Партнер = Реквизиты.Партнер;
	ИначеЕсли ЗаписыватьОрганизацию Тогда
		Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "Организация");
		ЗаписьНастройкиПечатиОбъектов.Организация = Реквизиты.Организация;
	ИначеЕсли ЗаписыватьПартнера Тогда
		Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "Партнер");
		ЗаписьНастройкиПечатиОбъектов.Партнер = Реквизиты.Партнер;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	ЗаписьНастройкиПечатиОбъектов.Записать();
	
КонецПроцедуры

// Удаляет настройки комплекта печатных форм, используемых для объекта
//
// Параметры:
//		ТипОбъекта - строка - полное наименование объекта, для которого необходимо получить настройки печатных форм
//		Организация - СправочникСсылка.Организации - организация, для которой необходимо удалить настройки
//		Партнер - СправочникСсылка.Партнеры - партнер, для которого необходимо удалить настройки.
//
Процедура УдалитьНастройкиПечатиОбъекта(ТипОбъекта, Организация, Партнер) Экспорт
	
	ЗаписьНастройкиПечатиОбъектов = РегистрыСведений.НастройкиПечатиОбъектов.СоздатьМенеджерЗаписи();
	ЗаписьНастройкиПечатиОбъектов.ТипОбъекта  = ТипОбъекта;
	ЗаписьНастройкиПечатиОбъектов.Организация = Организация;
	ЗаписьНастройкиПечатиОбъектов.Партнер = Партнер;
	ЗаписьНастройкиПечатиОбъектов.Удалить();
	
КонецПроцедуры

// Возвращает настройки комплекта печатных форм, используемых для объекта
//
// Возвращаемое значение:
// ТаблицаЗначений - таблица значений с колонками:
//  * Имя           - Строка - внутреннее имя печатной формы.
//  * Представление -Строка - пользовательской представление печатной формы.
//  * Экземпляров   - Число - количество экземпляров, выводимых на печать.
//  * Печатать      - Булево - признак, указывающий на необходимость печати печатной формы.
//
Функция ПодготовитьКомплектПечатныхФорм() Экспорт
	
	КомплектПечатныхФорм = Новый ТаблицаЗначений();
	КомплектПечатныхФорм.Колонки.Добавить("Имя");
	КомплектПечатныхФорм.Колонки.Добавить("Представление");
	КомплектПечатныхФорм.Колонки.Добавить("Экземпляров");
	КомплектПечатныхФорм.Колонки.Добавить("Печатать");
	КомплектПечатныхФорм.Колонки.Добавить("Ссылка");
	
	Возврат КомплектПечатныхФорм;
	
КонецФункции

// Добавляет печатную форму в таблицу с комплектом печатных форм
// Флаг "Печатать" устанавливается в Истина, если количество печатных форм больше нуля.
//
// Параметры:
//  КомплектПечатныхФорм - ТаблицаЗначений возвращаемая функций ПодготовитьКомплектПечатныхФорм(),
//  Имя - Строка - внутреннее имя печатной формы,
//  Представление - Строка - представление печатной формы,
//  Экземпляров - Число - количество экземпляров, выводимых на печать.
//
// Возвращаемое значение:
//  СтрокаТаблицыЗначений - строка с добавленной печатной формой.
//
Функция ДобавитьПечатнуюФормуВКомплект(КомплектПечатныхФорм, Имя, Представление, Экземпляров = 0) Экспорт
	
	НоваяПечатнаяФорма = КомплектПечатныхФорм.Добавить();
	НоваяПечатнаяФорма.Имя = Имя;
	НоваяПечатнаяФорма.Представление = Представление;
	НоваяПечатнаяФорма.Экземпляров = Экземпляров;
	НоваяПечатнаяФорма.Печатать = Экземпляров > 0;
	
	Возврат НоваяПечатнаяФорма;
	
КонецФункции

// Получает параметры объекта для печати комплекта печатных форм
//
// Параметры:
//		ТипОбъекта - строка - полное наименование объекта, для которого необходимо получить, параметры для печати комплекта печатных форм.
//
// Возвращаемое значение:
//	Структура - параметры для печати:
//		* ДоступнаПечатьКомплекта - Булево - признак возможности печати комплекта печатных форм для объекта.
//		* ЕстьОрганизация         - Булево - признак наличия организации в объекте.
//		* ЕстьПартнер             - Булево - признак наличия партнера в объекте.
//
Функция ПараметрыОбъектаДляПечатиКомплектно(ТипОбъекта) Экспорт
	
	ПараметрыОбъектаДляПечатиКомплектно = Новый Структура();
	ПараметрыОбъектаДляПечатиКомплектно.Вставить("ДоступнаПечатьКомплекта", Ложь);
	ПараметрыОбъектаДляПечатиКомплектно.Вставить("ЕстьОрганизация", Ложь);
	ПараметрыОбъектаДляПечатиКомплектно.Вставить("ЕстьПартнер", Ложь);
	
	Если ЗначениеЗаполнено(ТипОбъекта) Тогда
	
		ТаблицаОбъектов = ТаблицаОбъектовДляПечатиКомплектно();
		ТекущийОбъект = ТаблицаОбъектов.Найти(ТипОбъекта, "ТипОбъекта");
		Если ТекущийОбъект <> Неопределено Тогда
			ЗаполнитьЗначенияСвойств(ПараметрыОбъектаДляПечатиКомплектно, ТекущийОбъект);
			ПараметрыОбъектаДляПечатиКомплектно.ДоступнаПечатьКомплекта = Истина;
		КонецЕсли;
	
	КонецЕсли;
	
	Возврат ПараметрыОбъектаДляПечатиКомплектно;
	
КонецФункции

// Возвращает таблицу с описанием объектов, для которых предусмотрена
// возможность печати комплекта печатных форм.
//
// Возвращаемое значение:
// ТаблицаЗначений - таблица значений с колонками:
//  * ТипОбъекта      - Строка - полное наименование объекта.
//  * Представление   - Строка - пользовательское представление объекта.
//  * ЕстьОрганизация - Булево - признак наличия организации в объекте.
//  * ЕстьПартнер     - Булево - признак наличия партнера в объекте.
//
Функция ТаблицаОбъектовДляПечатиКомплектно() Экспорт
	
	ТаблицаОбъектов = Новый ТаблицаЗначений();
	ТаблицаОбъектов.Колонки.Добавить("ТипОбъекта");
	ТаблицаОбъектов.Колонки.Добавить("Представление");
	ТаблицаОбъектов.Колонки.Добавить("ЕстьОрганизация");
	ТаблицаОбъектов.Колонки.Добавить("ЕстьПартнер");
	
	// Коммерческое предложение клиенту
	Если ПолучитьФункциональнуюОпцию("ИспользоватьКоммерческиеПредложенияКлиентам") Тогда
		НоваяСтрока = ТаблицаОбъектов.Добавить();
		НоваяСтрока.ТипОбъекта = Метаданные.Документы.КоммерческоеПредложениеКлиенту.ПолноеИмя();
		НоваяСтрока.Представление = Метаданные.Документы.КоммерческоеПредложениеКлиенту.Представление();
		НоваяСтрока.ЕстьОрганизация = Истина;
		НоваяСтрока.ЕстьПартнер = Истина;
	КонецЕсли;
	
	// Заказ клиента
	Если ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыКлиентов") Тогда
		НоваяСтрока = ТаблицаОбъектов.Добавить();
		НоваяСтрока.ТипОбъекта = Метаданные.Документы.ЗаказКлиента.ПолноеИмя();
		НоваяСтрока.Представление = Метаданные.Документы.ЗаказКлиента.Представление();
		НоваяСтрока.ЕстьОрганизация = Истина;
		НоваяСтрока.ЕстьПартнер = Истина;
	КонецЕсли;
	
	// Заявка на возврат товаров от клиента
	Если ПолучитьФункциональнуюОпцию("ИспользоватьЗаявкиНаВозвратТоваровОтКлиентов") Тогда
		НоваяСтрока = ТаблицаОбъектов.Добавить();
		НоваяСтрока.ТипОбъекта = Метаданные.Документы.ЗаявкаНаВозвратТоваровОтКлиента.ПолноеИмя();
		НоваяСтрока.Представление = Метаданные.Документы.ЗаявкаНаВозвратТоваровОтКлиента.Представление();
		НоваяСтрока.ЕстьОрганизация = Истина;
		НоваяСтрока.ЕстьПартнер = Истина;
	КонецЕсли;
	
	// Счет на оплату
	Если ПолучитьФункциональнуюОпцию("ИспользоватьСчетаНаОплатуКлиентам") Тогда
		НоваяСтрока = ТаблицаОбъектов.Добавить();
		НоваяСтрока.ТипОбъекта = Метаданные.Документы.СчетНаОплатуКлиенту.ПолноеИмя();
		НоваяСтрока.Представление = Метаданные.Документы.СчетНаОплатуКлиенту.Представление();
		НоваяСтрока.ЕстьОрганизация = Истина;
		НоваяСтрока.ЕстьПартнер = Истина;
	КонецЕсли;
	
	// Доверенность
	Если ПолучитьФункциональнуюОпцию("ИспользоватьДоверенностиНаПолучениеТМЦ") Тогда
		НоваяСтрока = ТаблицаОбъектов.Добавить();
		НоваяСтрока.ТипОбъекта = Метаданные.Документы.ДоверенностьВыданная.ПолноеИмя();
		НоваяСтрока.Представление = Метаданные.Документы.ДоверенностьВыданная.Представление();
		НоваяСтрока.ЕстьОрганизация = Истина;
		НоваяСтрока.ЕстьПартнер = Истина;
	КонецЕсли;
	
	// Приходный кассовый ордер
	НоваяСтрока = ТаблицаОбъектов.Добавить();
	НоваяСтрока.ТипОбъекта = Метаданные.Документы.ПриходныйКассовыйОрдер.ПолноеИмя();
	НоваяСтрока.Представление = Метаданные.Документы.ПриходныйКассовыйОрдер.Представление();
	НоваяСтрока.ЕстьОрганизация = Истина;
	НоваяСтрока.ЕстьПартнер = Ложь;
	
	// Реализация товаров и услуг
	НоваяСтрока = ТаблицаОбъектов.Добавить();
	НоваяСтрока.ТипОбъекта = Метаданные.Документы.РеализацияТоваровУслуг.ПолноеИмя();
	НоваяСтрока.Представление = Метаданные.Документы.РеализацияТоваровУслуг.Представление();
	НоваяСтрока.ЕстьОрганизация = Истина;
	НоваяСтрока.ЕстьПартнер = Истина;
	
	// Акт выполненных работ
	НоваяСтрока = ТаблицаОбъектов.Добавить();
	НоваяСтрока.ТипОбъекта = Метаданные.Документы.АктВыполненныхРабот.ПолноеИмя();
	НоваяСтрока.Представление = Метаданные.Документы.АктВыполненныхРабот.Представление();
	НоваяСтрока.ЕстьОрганизация = Истина;
	НоваяСтрока.ЕстьПартнер = Истина;
	
	// Перемещение товаров
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПеремещениеТоваров") Тогда
		НоваяСтрока = ТаблицаОбъектов.Добавить();
		НоваяСтрока.ТипОбъекта = Метаданные.Документы.ПеремещениеТоваров.ПолноеИмя();
		НоваяСтрока.Представление = Метаданные.Документы.ПеремещениеТоваров.Представление();
		НоваяСтрока.ЕстьОрганизация = Истина;
		НоваяСтрока.ЕстьПартнер = Ложь;
	КонецЕсли;
	
	//++ НЕ УТКА
	// Отчет давальцу
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПроизводствоИзДавальческогоСырья") Тогда
		НоваяСтрока = ТаблицаОбъектов.Добавить();
		НоваяСтрока.ТипОбъекта = Метаданные.Документы.ОтчетДавальцу.ПолноеИмя();
		НоваяСтрока.Представление = Метаданные.Документы.ОтчетДавальцу.Представление();
		НоваяСтрока.ЕстьОрганизация = Истина;
		НоваяСтрока.ЕстьПартнер = Истина;
	КонецЕсли;
	//-- НЕ УТКА
	
	// Выкуп возвратной тары клиентом
	Если ПолучитьФункциональнуюОпцию("ИспользоватьМногооборотнуюТару") Тогда
		НоваяСтрока = ТаблицаОбъектов.Добавить();
		НоваяСтрока.ТипОбъекта = Метаданные.Документы.ВыкупВозвратнойТарыКлиентом.ПолноеИмя();
		НоваяСтрока.Представление = Метаданные.Документы.ВыкупВозвратнойТарыКлиентом.Представление();
		НоваяСтрока.ЕстьОрганизация = Истина;
		НоваяСтрока.ЕстьПартнер = Ложь;
	КонецЕсли;
	
	//Рарус Владимир Подрезов Доставка печать комплекта 10.10.2016
	// Доставка
	НоваяСтрока = ТаблицаОбъектов.Добавить();
	НоваяСтрока.ТипОбъекта = Метаданные.Документы.пкДоставка.ПолноеИмя();
	НоваяСтрока.Представление = Метаданные.Документы.пкДоставка.Представление();
	НоваяСтрока.ЕстьОрганизация = Истина;
	НоваяСтрока.ЕстьПартнер = Ложь;
	//Рарус Владимир Подрезов Конец
	
	Возврат ТаблицаОбъектов;
	
КонецФункции

// Копирует строку в коллекцию печатных форм из строки настроек печати комплекта
//
// Параметры:
// КоллекцияПечатныхФорм - ТаблицаЗначений, передаваемая в процедуру Печать() модуля менеджера
// НастройкаПечати - СтрокаТаблицыЗначений таблицы, возвращаемой функцией ПодготовитьКомплектПечатныхФорм().
//
Процедура СкопироватьПечатнуюФормуВКоллекцию(КоллекцияПечатныхФорм, НастройкаПечати) Экспорт
	
	НоваяСтрока = КоллекцияПечатныхФорм.Добавить();
	НоваяСтрока.ИмяМакета = НастройкаПечати.Имя;
	НоваяСтрока.Экземпляров = НастройкаПечати.Экземпляров;
	НоваяСтрока.ИмяВРЕГ = ВРЕГ(НоваяСтрока.ИмяМакета);
	
КонецПроцедуры

// Дополняет коллекцию печатных форм внешними печатными формами
// Параметры:
// ТипОбъекта - строка - полное наименование объекта, для которого необходимо получить настройки печатных форм
// ДополняемыйКомплект - ТаблицаЗначений, возвращаемой функцией ПодготовитьКомплектПечатныхФорм().
//
Процедура ДополнитьКомплектВнешнимиПечатнымиФормами(ТипОбъекта, ДополняемыйКомплект) Экспорт
	
	// добавление внешних печатных форм в комплект
	ПрефиксВнешнихПечатныхФорм = "ВнешняяПечатнаяФорма.";
	КоллекцияВнешнихПечатныхФорм = ПодготовитьКомплектПечатныхФорм();
	ЗапросТаблицаКоманд = ДополнительныеОтчетыИОбработки.НовыйЗапросПоДоступнымКомандам(Перечисления.ВидыДополнительныхОтчетовИОбработок.ПечатнаяФорма, ТипОбъекта, Истина);
	ТаблицаКоманд = ЗапросТаблицаКоманд.Выполнить().Выгрузить();
	
	Для Каждого КомандаПечати Из ТаблицаКоманд Цикл
		ДобавитьПечатнуюФормуВКомплект(ДополняемыйКомплект, ПрефиксВнешнихПечатныхФорм + КомандаПечати.Идентификатор, КомандаПечати.Представление, 0);
	КонецЦикла;
	
КонецПроцедуры

// Возвращает сгруппированные по объектам настройки комплектов печатных
//
// Параметры:
// КоллекцияПечатныхФорм - ТаблицаЗначений, передаваемая в процедуру Печать() модуля менеджера
// КомплектПечатныхФорм - Массив, объекты для печати
// ИмяМакета - Строка, имя макета для печати.
//
// Возвращаемое значение:
// ТаблицаЗначений - таблица значений с колонками:
//  * Имя           - Строка - внутреннее имя печатной формы.
//  * Представление -Строка - пользовательской представление печатной формы.
//  * Экземпляров   - Число - количество экземпляров, выводимых на печать.
//  * Печатать      - Булево - признак, указывающий на необходимость печати печатной формы.
//  * Объекты       - Массив - ссылки на объекты, которые необходимо распечатать.
//
Функция КомплектыПечатиПоОбъектам(КоллекцияПечатныхФорм, Знач КомплектПечатныхФорм, Знач МассивОбъектов, Знач ИмяМакета) Экспорт
	
	КомплектыПечати = КомплектПечатныхФорм.Скопировать(Новый Структура("Имя,Печатать,", ИмяМакета, Истина));
	КомплектыПечатиПоОбъектам = ПодготовитьКомплектПечатныхФорм();
	КомплектыПечатиПоОбъектам.Колонки.Добавить("Объекты");
	КомплектыПечатиПоОбъектам.Колонки.Удалить("Ссылка");
	
	Если КомплектыПечати.Количество() > 0 Тогда
		Если КомплектыПечати.Колонки.Найти("Ссылка") <> Неопределено И ЗначениеЗаполнено(КомплектыПечати[0].Ссылка) Тогда
			
			НомерПечатнойФормы = 0;
			
			Для Каждого КомплектПечати Из КомплектыПечати Цикл
				ПрефиксИмени = "";
				Если ЗначениеЗаполнено(КомплектПечати.Ссылка) Тогда 
					КомплектПечатиСсылкаМетаданные = Метаданные.НайтиПоТипу(ТипЗнч(КомплектПечати.Ссылка));
					Если КомплектПечатиСсылкаМетаданные <> Неопределено Тогда
						ПрефиксИмени = КомплектПечатиСсылкаМетаданные.Имя + ".";
					КонецЕсли;  
				КонецЕсли;  
				КомплектПечати.Имя = ПрефиксИмени + ИмяМакета + Строка(НомерПечатнойФормы);				
				НомерПечатнойФормы = НомерПечатнойФормы + 1;
				
				СкопироватьПечатнуюФормуВКоллекцию(КоллекцияПечатныхФорм, КомплектПечати);
				
				НоваяСтрока = КомплектыПечатиПоОбъектам.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, КомплектПечати);
				МассивСсылок = Новый Массив();
				МассивСсылок.Добавить(КомплектПечати.Ссылка);
				НоваяСтрока.Объекты = МассивСсылок;
				
			КонецЦикла;
			
		Иначе
			
			СкопироватьПечатнуюФормуВКоллекцию(КоллекцияПечатныхФорм, КомплектыПечати[0]);
				
			НоваяСтрока = КомплектыПечатиПоОбъектам.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, КомплектыПечати[0]);
			НоваяСтрока.Объекты = МассивОбъектов;
				
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат КомплектыПечатиПоОбъектам;
		
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Печать

// Сформировать печатные формы объектов
//
// ВХОДЯЩИЕ:
//   ИменаМакетов    - Строка    - Имена макетов, перечисленные через запятую
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать
//   ПараметрыПечати - Структура - Структура дополнительных параметров печати.
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "КомплектДокументов") Тогда
		КоллекцияПечатныхФорм.Очистить();
		СформироватьКомплектПечатныхФорм(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати);
	КонецЕсли;
	
КонецПроцедуры

// Формирует комплект печатных форм по переданному массиву объектов
// Массив объектов может включать объекты различных типов, для которых поддерживается комплектная печать.
//
// Параметры:
// МассивОбъектов - Массив - объекты, для которых необходимо сформировать комплекты печатных форм
// ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати - совпадает с параметрами процедуры Печать() в модуле менеджера.
//
Процедура СформироватьКомплектПечатныхФорм(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати) Экспорт
	
	СоответствиеТипов = ОбщегоНазначенияУТ.СоответствиеМассивовПоТипамОбъектов(МассивОбъектов);
	
	Для Каждого ТекТипОбъекта Из СоответствиеТипов Цикл
		
		МенеджерПечати = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ТекТипОбъекта.Ключ);
		МенеджерПечати.СформироватьКомплектПечатныхФорм(
			ТекТипОбъекта.Значение,
			ПараметрыПечати,
			КоллекцияПечатныхФорм,
			ОбъектыПечати);
		
	КонецЦикла;
	
КонецПроцедуры

// Формирует комплект внешних печатных форм по переданному массиву объектов
// Массив объектов может включать объекты различных типов, для которых поддерживается комплектная печать.
//
// Параметры:
// ИмяМенеджераПечати - Строка - имя менеджера печати документа
// МассивОбъектов - Массив - объекты, для которых необходимо сформировать комплекты печатных форм
// ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати - совпадает с параметрами процедуры Печать() в модуле менеджера.
//
Процедура СформироватьКомплектВнешнихПечатныхФорм(ИмяМенеджераПечати, МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати) Экспорт
	
	Перем АдресКомплектаПечатныхФорм;
	
	Если ТипЗнч(ПараметрыПечати) = Тип("Структура") И ПараметрыПечати.Свойство("АдресКомплектаПечатныхФорм", АдресКомплектаПечатныхФорм) Тогда
		
		КомплектПечатныхФорм = ПолучитьИзВременногоХранилища(АдресКомплектаПечатныхФорм);
		
	Иначе
		КомплектПечатныхФорм = КомплектПечатныхФорм(
			ИмяМенеджераПечати,
			МассивОбъектов, 
			Неопределено);
		
	КонецЕсли;
	
	СтруктураТипов = Новый Соответствие;
	СтруктураТипов.Вставить("Документ.РеализацияТоваровУслуг", МассивОбъектов);
	
	ПараметрыВывода = УправлениеПечатью.ПодготовитьСтруктуруПараметровВывода();
	ВнешниеПечатныеФормы = УправлениеПечатью.СписокПечатныхФормИзВнешнихИсточников(ИмяМенеджераПечати);
	
	ПрефиксВнешнихПечатныхФорм = "ВнешняяПечатнаяФорма.";
	
	Для каждого ПечатнаяФорма Из КомплектПечатныхФорм Цикл
		// поиск указания дополнительного менеджера печати в имени печатной формы
		ИмяДополнительногоМенеджераПечати = "";
		ИмяМакета = ПечатнаяФорма.Имя;
		Идентификатор = ИмяМакета;
		
		Если СтрНайти(Идентификатор, ПрефиксВнешнихПечатныхФорм) > 0 Тогда // это внешняя печатная форма
			Идентификатор = Сред(Идентификатор, СтрДлина(ПрефиксВнешнихПечатныхФорм) + 1);
		Иначе
			Продолжить;
		КонецЕсли;
		
		ТекущийКомплект = КомплектПечатныхФорм.Скопировать(Новый Структура("Имя,Печатать,",ИмяМакета,Истина));
		Если ТекущийКомплект.Количество() > 0 И КоллекцияПечатныхФорм.Найти(ИмяМакета, "ИмяМакета") = Неопределено Тогда
			Если ТекущийКомплект.Колонки.Найти("Ссылка") <> Неопределено И ЗначениеЗаполнено(ПечатнаяФорма.Ссылка) Тогда
				
				Для каждого ПечатнаяФорма Из ТекущийКомплект Цикл
					
					ВременныйМассивОбъектов = Новый Массив;
					ВременныйМассивОбъектов.Добавить(ПечатнаяФорма.Ссылка);
					
					ВременнаяКоллекцияДляОднойПечатнойФормы = УправлениеПечатью.ПодготовитьКоллекциюПечатныхФорм(Идентификатор);
					
					// печать внешней печатной формы
					ДополнительныеОтчетыИОбработки.ПечатьПоВнешнемуИсточнику(
						ВнешняяПечатнаяФорма(Идентификатор, ИмяМенеджераПечати),
						Новый Структура("ИдентификаторКоманды, ОбъектыНазначения", Идентификатор, ВременныйМассивОбъектов),
						ВременнаяКоллекцияДляОднойПечатнойФормы,
						Новый СписокЗначений,
						ПараметрыВывода);
					
					// Выведем нужное количество экземпляров (при печати комплектов)
					ТабличныйДокумент = ВременнаяКоллекцияДляОднойПечатнойФормы[0].ТабличныйДокумент;
					ТабличныйДокумент.КоличествоЭкземпляров = ПечатнаяФорма.Экземпляров;
					
					ВывестиТабличныйДокументВнешнейПФВКоллекцию(
						КоллекцияПечатныхФорм, 
						ПечатнаяФорма,
						ИмяМакета,
						ТабличныйДокумент);
					
				КонецЦикла; 
			
			Иначе
				ВременнаяКоллекцияДляОднойПечатнойФормы = УправлениеПечатью.ПодготовитьКоллекциюПечатныхФорм(Идентификатор);
				
				// печать внешней печатной формы
				ДополнительныеОтчетыИОбработки.ПечатьПоВнешнемуИсточнику(
					ВнешняяПечатнаяФорма(Идентификатор, ИмяМенеджераПечати),
					Новый Структура("ИдентификаторКоманды, ОбъектыНазначения", Идентификатор, МассивОбъектов),
					ВременнаяКоллекцияДляОднойПечатнойФормы,
					ОбъектыПечати,
					ПараметрыВывода);
					
				СкопироватьПечатнуюФормуВКоллекцию(КоллекцияПечатныхФорм, ТекущийКомплект[0]);
				ТекущаяСтруктураТипов = СтруктураТипов;
			
				УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
					КоллекцияПечатныхФорм,
					ИмяМакета,
					ТекущийКомплект[0].Представление,
					ВременнаяКоллекцияДляОднойПечатнойФормы[0].ТабличныйДокумент);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Возвращает ссылку на объект-источник внешней печатной формы.
//
// Параметры:
//  Идентификатор              - Строка - идентификатор формы;
//  ПолноеИмяОбъектаМетаданных - Строка - полное имя объекта метаданных, для которого требуется получить ссылку
//                                        на источник внешней печатной формы.
//
// Возвращаемое значение:
//  Ссылка - см. ДополнительныеОтчетыИОбработки.ПечатьПоВнешнемуИсточнику, параметр Ссылка.
Функция ВнешняяПечатнаяФорма(Идентификатор, ПолноеИмяОбъектаМетаданных)
	ВнешняяПечатнаяФормаСсылка = Неопределено;
	
	ДополнительныеОтчетыИОбработки.ПриПолученииВнешнейПечатнойФормы(Идентификатор, ПолноеИмяОбъектаМетаданных, ВнешняяПечатнаяФормаСсылка);
	
	Возврат ВнешняяПечатнаяФормаСсылка;
КонецФункции

// Добавляет табличный документ внешней печатной формы в коллекцию печатных форм.
//
// Параметры:
//  КоллекцияПечатныхФорм - ТаблицаЗначений - см. ПодготовитьКоллекциюПечатныхФорм();
//  НастройкаПечати - СтрокаТаблицыЗначений таблицы, возвращаемой функцией ПодготовитьКомплектПечатныхФорм()
//  ИмяМакета             - Строка - имя макета;
//  ТабличныйДокумент     - ТабличныйДокумент - печатная форма документа;
//  Картинка              - Картинка;
//  ПолныйПутьКМакету     - Строка - путь к макету в дереве метаданных.
//
Процедура ВывестиТабличныйДокументВнешнейПФВКоллекцию(КоллекцияПечатныхФорм, НастройкаПечати, ИмяМакета, ТабличныйДокумент, Картинка = Неопределено, ПолныйПутьКМакету = "")
	
	НоваяСтрока = КоллекцияПечатныхФорм.Добавить();
	НоваяСтрока.ИмяМакета = НастройкаПечати.Имя;
	НоваяСтрока.Экземпляров = НастройкаПечати.Экземпляров;
	НоваяСтрока.ИмяВРЕГ = ВРЕГ(НоваяСтрока.ИмяМакета);
	НоваяСтрока.СинонимМакета = НастройкаПечати.Представление;
	НоваяСтрока.ТабличныйДокумент = ТабличныйДокумент;
	НоваяСтрока.Картинка = Картинка;
	НоваяСтрока.ПолныйПутьКМакету = ПолныйПутьКМакету;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
