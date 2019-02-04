////////////////////////////////////////////////////////////////////////////////
// Подсистема "Облачные классификаторы".
// ОбщийМодуль.ОблачныеКлассификаторыСлужебный.
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

#Область ОписаниеПараметровЗапросов

// Описание параметров запроса разделов классификатора ТН ВЭД.
//
Функция ОписаниеПараметровЗапросаРазделыТНВЭД() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("НаборПолей",        ""); // набор полей возвращаемых данных.
	Результат.Вставить("КоличествоЗаписей", 0); // количество записей (пагинация).
	Результат.Вставить("НомерСтраницы",     0); // номер страницы (пагинация).
	
	Возврат Результат;
	
КонецФункции

// Описание параметров запроса подчиненных элементов (детей) классификатора ТН ВЭД.
//
Функция ОписаниеПараметровЗапросаПодчиненныеЭлементыТНВЭД() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Код",               ""); // код, для которого необходимо получить подчиненные элементы.
	Результат.Вставить("НаборПолей",        ""); // набор полей возвращаемых данных.
	Результат.Вставить("КоличествоЗаписей", 0);  // количество записей (пагинация).
	Результат.Вставить("НомерСтраницы",     0);  // номер страницы (пагинация).
	
	Возврат Результат;
	
КонецФункции

// Описание параметров запроса элементов классификатора ТН ВЭД.
//
Функция ОписаниеПараметровЗапросаЭлементыТНВЭД() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Коды",              ""); // коды элементов, информацию о которых необходимо получить;
	Результат.Вставить("НаборПолей",        ""); // набор полей возвращаемых данных.
	Результат.Вставить("КоличествоЗаписей", 0);  // количество записей (пагинация).
	Результат.Вставить("НомерСтраницы",     0);  // номер страницы (пагинация).
	
	Возврат Результат;
	
КонецФункции

// Описание параметров запроса элементов классификатора ТН ВЭД по строке поиска.
//
Функция ОписаниеПараметровЗапросаПоискЭлементовТНВЭД() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("СтрокаПоиска",      ""); // значение, по которому будет выполняться поиск элементов.
	Результат.Вставить("НаборПолей",        ""); // набор полей возвращаемых данных.
	Результат.Вставить("НомерСтраницы",     0);  // номер страницы (пагинация, размер порции - 100 элементов).
	
	Возврат Результат;
	
КонецФункции

// Описание параметров запроса предков элемента классификатора ТН ВЭД.
//
Функция ОписаниеПараметровЗапросаПредкиЭлементаТНВЭД() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Код",               ""); // код элемента классификатора, для которого необходимо получить предков
	Результат.Вставить("НаборПолей",        ""); // набор полей возвращаемых данных.
	Результат.Вставить("КоличествоЗаписей", 0);  // количество записей (пагинация).
	Результат.Вставить("НомерСтраницы",     0);  // номер страницы (пагинация).
	
	Возврат Результат;
	
КонецФункции

// Описание параметров запроса потомков элемента классификатора ТН ВЭД.
//
Функция ОписаниеПараметровЗапросаПотомкиЭлементаТНВЭД() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Код",               ""); // код элемента классификатора, для которого необходимо получить потомков
	Результат.Вставить("НаборПолей",        ""); // набор полей возвращаемых данных.
	Результат.Вставить("КоличествоЗаписей", 0);  // количество записей (пагинация).
	Результат.Вставить("НомерСтраницы",     0);  // номер страницы (пагинация).
	
	Возврат Результат;
	
КонецФункции

// Описание параметров запроса обновлений классификатора ТН ВЭД.
//
Функция ОписаниеПараметровЗапросаОбновлениеТНВЭД() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Дата",              0);  // дата последнего получения изменений классификатора в формате Unix time
	Результат.Вставить("НаборПолей",        ""); // набор полей возвращаемых данных.
	Результат.Вставить("КоличествоЗаписей", 0);  // количество записей (пагинация).
	Результат.Вставить("НомерСтраницы",     0);  // номер страницы (пагинация).
	
	Возврат Результат;
	
КонецФункции

// Описание параметров запроса элементов классификатора ОКЕИ.
//
Функция ОписаниеПараметровЗапросаЭлементыОКЕИ() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Коды",              Новый Массив); // массив кодов, информацию по которым необходимо получить.
	Результат.Вставить("НаборПолей",        "");           // набор полей возвращаемых данных.
	Результат.Вставить("КоличествоЗаписей", 0);            // количество записей (пагинация).
	Результат.Вставить("НомерСтраницы",     0);            // номер страницы (пагинация).
	
	Возврат Результат;
	
КонецФункции

// Запрос разделов классификатора ТН ВЭД.
//
// Параметры:
//  ПараметрыЗапроса - Структура - см. ОписаниеПараметровЗапросаРазделыТНВЭД().
// 
// Возвращаемое значение:
//  Структура - параметры команды.
//
Функция ПараметрыЗапросаРазделыТНВЭД(ПараметрыЗапроса) Экспорт
	
	// Общие параметры.
	ПараметрыКоманды = РаботаСНоменклатуройСлужебный.ОписаниеПараметровКомандыСервиса();
	ПараметрыКоманды.Наименование = НСтр("ru = 'Запрос разделов классификатора ТН ВЭД'");
	КоличествоЗаписей = ?(ПараметрыЗапроса.КоличествоЗаписей, СтрШаблон("?pagesize=%1",
		Строка(ПараметрыЗапроса.КоличествоЗаписей)), "");
	ПараметрыКоманды.Адрес = СтрШаблон("/api/v2/catalog/tnved/roots%1", КоличествоЗаписей);
	ПараметрыКоманды.Метод = "get";
	ПараметрыКоманды.Аутентификация = Истина;
	ПараметрыКоманды.Результат = "elements";
	ПараметрыКоманды.Ошибки.Вставить(400, НСтр("ru = 'Ошибка выполнения запроса.'"));
	ПараметрыКоманды.Обработка = ОписаниеЭлементовТНВЭД();
	
	Возврат ПараметрыКоманды;
	
КонецФункции

// Запрос подчиненных элементов классификатора ТН ВЭД.
//
// Параметры:
//  ПараметрыЗапроса - Структура - см. ОписаниеПараметровЗапросаПодчиненныеЭлементыТНВЭД().
// 
// Возвращаемое значение:
//  Структура - параметры команды.
//
Функция ПараметрыЗапросаПодчиненныеЭлементыТНВЭД(ПараметрыЗапроса) Экспорт
	
	// Общие параметры.
	ПараметрыКоманды = РаботаСНоменклатуройСлужебный.ОписаниеПараметровКомандыСервиса();
	ПараметрыКоманды.Наименование = НСтр("ru = 'Запрос подчиненных элементов классификатора ТН ВЭД'");
	ПараметрыКоманды.Адрес = "/api/v2/catalog/tnved/" + ПараметрыЗапроса.Код + "/children";
	ПараметрыКоманды.Метод = "get";
	ПараметрыКоманды.Аутентификация = Истина;
	ПараметрыКоманды.Результат = "elements";
	ПараметрыКоманды.Ошибки.Вставить(400, НСтр("ru = 'Ошибка выполнения запроса.'"));
	ПараметрыКоманды.Обработка = ОписаниеЭлементовТНВЭД();
	
	Возврат ПараметрыКоманды;
	
КонецФункции

// Запрос элементов классификатора ТН ВЭД.
//
// Параметры:
//  ПараметрыЗапроса - Структура - см. ОписаниеПараметровЗапросаЭлементыТНВЭД().
// 
// Возвращаемое значение:
//  Структура - параметры команды.
//
Функция ПараметрыЗапросаЭлементыТНВЭД(ПараметрыЗапроса) Экспорт
	
	// Общие параметры.
	ПараметрыКоманды = РаботаСНоменклатуройСлужебный.ОписаниеПараметровКомандыСервиса();
	ПараметрыКоманды.Наименование = НСтр("ru = 'Запрос элементов классификатора ТН ВЭД'");
	ПараметрыКоманды.Адрес = "/api/v2/catalog/tnved/" + ПараметрыЗапроса.Коды;
	ПараметрыКоманды.Метод = "get";
	ПараметрыКоманды.Аутентификация = Истина;
	ПараметрыКоманды.Результат = "elements";
	ПараметрыКоманды.Ошибки.Вставить(400, НСтр("ru = 'Ошибка выполнения запроса.'"));
	ПараметрыКоманды.Обработка = ОписаниеЭлементовТНВЭД();
	
	Возврат ПараметрыКоманды;
	
КонецФункции

// Запрос элементов классификатора ТН ВЭД по строке поиска.
//
// Параметры:
//  ПараметрыЗапроса - Структура - см. ОписаниеПараметровЗапросаПоискЭлементовТНВЭД().
// 
// Возвращаемое значение:
//  Структура - параметры команды.
//
Функция ПараметрыЗапросаПоискЭлементовТНВЭД(ПараметрыЗапроса) Экспорт
	
	// Общие параметры.
	ПараметрыКоманды = РаботаСНоменклатуройСлужебный.ОписаниеПараметровКомандыСервиса();
	ПараметрыКоманды.Наименование = НСтр("ru = 'Поиск элементов классификатора ТН ВЭД'");
	НомерСтраницы = ?(ПараметрыЗапроса.НомерСтраницы, СтрШаблон("?page=%1",
		Строка(ПараметрыЗапроса.НомерСтраницы)), "");
	ПараметрыКоманды.Адрес = СтрШаблон("/api/v2/catalog/tnved/search/%1%2",
		ПараметрыЗапроса.СтрокаПоиска, НомерСтраницы);
	ПараметрыКоманды.Метод = "get";
	ПараметрыКоманды.Аутентификация = Истина;
	ПараметрыКоманды.Результат = "elements";
	ПараметрыКоманды.Ошибки.Вставить(400, НСтр("ru = 'Ошибка выполнения запроса.'"));
	ПараметрыКоманды.Обработка = ОписаниеЭлементовТНВЭД();
	
	Возврат ПараметрыКоманды;
	
КонецФункции

// Запрос предков элементов классификатора ТН ВЭД.
//
// Параметры:
//  ПараметрыЗапроса - Структура - см. ОписаниеПараметровЗапросаПредкиЭлементаТНВЭД().
// 
// Возвращаемое значение:
//  Структура - параметры команды.
//
Функция ПараметрыЗапросаПредкиЭлементаТНВЭД(ПараметрыЗапроса) Экспорт
	
	// Общие параметры.
	ПараметрыКоманды = РаботаСНоменклатуройСлужебный.ОписаниеПараметровКомандыСервиса();
	ПараметрыКоманды.Наименование = НСтр("ru = 'Запрос предков элемента классификатора ТН ВЭД'");
	ПараметрыКоманды.Адрес = "/api/v2/catalog/tnved/" + ПараметрыЗапроса.Код + "/ancestors";
	ПараметрыКоманды.Метод = "get";
	ПараметрыКоманды.Аутентификация = Истина;
	ПараметрыКоманды.Результат = "elements";
	ПараметрыКоманды.Ошибки.Вставить(400, НСтр("ru = 'Ошибка выполнения запроса.'"));
	ПараметрыКоманды.Обработка = ОписаниеЭлементовТНВЭД();
	
	Возврат ПараметрыКоманды;
	
КонецФункции

// Запрос потомков элементов классификатора ТН ВЭД.
//
// Параметры:
//  ПараметрыЗапроса - Структура - см. ОписаниеПараметровЗапросаПотомкиЭлементаТНВЭД().
// 
// Возвращаемое значение:
//  Структура - параметры команды.
//
Функция ПараметрыЗапросаПотомкиЭлементаТНВЭД(ПараметрыЗапроса) Экспорт
	
	// Общие параметры.
	ПараметрыКоманды = РаботаСНоменклатуройСлужебный.ОписаниеПараметровКомандыСервиса();
	ПараметрыКоманды.Наименование = НСтр("ru = 'Запрос потомков элемента классификатора ТН ВЭД'");
	КоличествоЗаписей = ?(ПараметрыЗапроса.КоличествоЗаписей, СтрШаблон("?pagesize=%1",
		Строка(ПараметрыЗапроса.КоличествоЗаписей)), "");
	НомерСтраницы = ?(ПараметрыЗапроса.НомерСтраницы, СтрШаблон("&page=%1",
		Строка(ПараметрыЗапроса.НомерСтраницы)), "");
	ПараметрыКоманды.Адрес = СтрШаблон("/api/v2/catalog/tnved/%1/descendants%2%3",
		ПараметрыЗапроса.Код, КоличествоЗаписей, НомерСтраницы);
	ПараметрыКоманды.Метод = "get";
	ПараметрыКоманды.Аутентификация = Истина;
	ПараметрыКоманды.Результат = "elements";
	ПараметрыКоманды.Ошибки.Вставить(400, НСтр("ru = 'Ошибка выполнения запроса.'"));
	ПараметрыКоманды.Обработка = ОписаниеЭлементовТНВЭД();
	
	Возврат ПараметрыКоманды;
	
КонецФункции

// Запрос элементов классификатора ОКЕИ.
//
// Параметры:
//  ПараметрыЗапроса - Структура - см. ОписаниеПараметровЗапросаЭлементыОКЕИ().
// 
// Возвращаемое значение:
//  Структура - параметры команды.
//
Функция ПараметрыЗапросаЭлементыОКЕИ(ПараметрыЗапроса) Экспорт
	
	// Общие параметры.
	ПараметрыКоманды = РаботаСНоменклатуройСлужебный.ОписаниеПараметровКомандыСервиса();
	ПараметрыКоманды.Наименование = НСтр("ru = 'Запрос элементов классификатора ОКЕИ'");
	ПараметрыКоманды.Адрес = "/api/v2/catalog/okei";
	ПараметрыКоманды.Метод = "post";
	ПараметрыКоманды.Аутентификация = Истина;
	ПараметрыКоманды.Результат = "units";
	ПараметрыКоманды.Ошибки.Вставить(400, НСтр("ru = 'Ошибка выполнения запроса.'"));
	ПараметрыКоманды.Обработка = ОписаниеЭлементовОКЕИ();
	ПараметрыКоманды.Данные = ЗначениеВФорматJSON(Новый Структура("okei", ПараметрыЗапроса.Коды));
	
	Возврат ПараметрыКоманды;
	
КонецФункции

#КонецОбласти

#Область ОписаниеВозвращаемыхЗначений

// Описание элементов классификатора ТН ВЭД.
//
Функция ОписаниеЭлементовТНВЭД() Экспорт
	
	ТипИдентификатор = Новый ОписаниеТипов("Число",,,   Новый КвалификаторыЧисла(12, 0, ДопустимыйЗнак.Неотрицательный));
	ТипКод           = Новый ОписаниеТипов("Строка",,,, Новый КвалификаторыСтроки(13));
	ТипПорядок       = Новый ОписаниеТипов("Число",,,   Новый КвалификаторыЧисла(11, 0, ДопустимыйЗнак.Неотрицательный));
	ТипДата          = Новый ОписаниеТипов("Дата",,,,,  Новый КвалификаторыДаты(ЧастиДаты.Дата));
	ТипНаименование  = Новый ОписаниеТипов("Строка",,,, Новый КвалификаторыСтроки(1024));
	ТипСтрока        = Новый ОписаниеТипов("Строка");
	ТипКодОКЕИ       = Новый ОписаниеТипов("Строка",,,, Новый КвалификаторыСтроки(4));
	ТипБулево        = Новый ОписаниеТипов("Строка");
	ТипПошлина       = Новый ОписаниеТипов("Строка",,,, Новый КвалификаторыСтроки(100));
	ТипНДС           = Новый ОписаниеТипов("Строка",,,, Новый КвалификаторыСтроки(2));
	ТипПотомки       = Новый ОписаниеТипов("Число",,,   Новый КвалификаторыЧисла(5, 0, ДопустимыйЗнак.Неотрицательный));
	
	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("Идентификатор",           ТипИдентификатор, "id");
	Результат.Колонки.Добавить("Код",                     ТипКод,           "code");
	Результат.Колонки.Добавить("КодРодителя",             ТипКод,           "parentCode");
	Результат.Колонки.Добавить("Порядок",                 ТипПорядок,       "order");
	Результат.Колонки.Добавить("ДатаНачалаДействия",      ТипДата,          "startDate|ДесериализоватьДату");
	Результат.Колонки.Добавить("ДатаОкончанияДействия",   ТипДата,          "endDate|ДесериализоватьДату");
	Результат.Колонки.Добавить("Наименование",            ТипНаименование,  "name");
	Результат.Колонки.Добавить("НаименованиеПолное",      ТипСтрока,        "fullName");
	Результат.Колонки.Добавить("Описание",                ТипСтрока,        "description");
	Результат.Колонки.Добавить("КодОКЕИ",                 ТипКодОКЕИ,       "okei");
	Результат.Колонки.Добавить("Сырьевой",                ТипБулево,        "raw");
	Результат.Колонки.Добавить("ТаможеннаяПошлина",       ТипПошлина,       "dutyRate");
	Результат.Колонки.Добавить("СтавкаНДС",               ТипНДС,           "vat");
	Результат.Колонки.Добавить("ПодлежитУтилизации",      ТипБулево,        "recyclable");	
	Результат.Колонки.Добавить("ИзменениеСоставаТоваров", ТипБулево,        "changedGoodsComposition");
	Результат.Колонки.Добавить("ПотомковИтого",           ТипПотомки,       "descendantsTotal");
	Результат.Колонки.Добавить("ПотомковАктуальных",      ТипПотомки,       "descendantsTotalActual");
	Результат.Колонки.Добавить("ДатаИзменения",           ТипДата,          "modified|ДесериализоватьДату");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Описание элементов классификатора ОКЕИ.
//
Функция ОписаниеЭлементовОКЕИ()
	
	ТипКод = Новый ОписаниеТипов("Строка",,,, Новый КвалификаторыСтроки(4));
	ТипСтрока = Новый ОписаниеТипов("Строка",,,, Новый КвалификаторыСтроки(50));
	ТипЧисло = Новый ОписаниеТипов("Число",,,   Новый КвалификаторыЧисла(15, 3, ДопустимыйЗнак.Неотрицательный));
	ТипИдентификатор = Новый ОписаниеТипов("Строка",,,, Новый КвалификаторыСтроки(12));
	
	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("Код",                                      ТипКод,           "okei");
	Результат.Колонки.Добавить("Наименование",                             ТипСтрока,        "name");
	Результат.Колонки.Добавить("УсловноеОбозначениеНациональное",          ТипСтрока,        "nationalSymbol");
	Результат.Колонки.Добавить("УсловноеОбозначениеМеждународное",         ТипСтрока,        "internationalSymbol");
	Результат.Колонки.Добавить("КодовоеБуквенноеОбозначениеНациональное",  ТипСтрока,        "nationalCodeMark");
	Результат.Колонки.Добавить("КодовоеБуквенноеОбозначениеМеждународное", ТипСтрока,        "internationalCodeMark");
	Результат.Колонки.Добавить("ТипИзмеряемойВеличины",                    ТипСтрока,        "type");
	Результат.Колонки.Добавить("Числитель",                                ТипЧисло,         "baseUnitCount");
	Результат.Колонки.Добавить("Знаменатель",                              ТипЧисло,         "unitCount");
	Результат.Колонки.Добавить("Идентификатор",                            ТипИдентификатор, "id");
	Результат.Колонки.Добавить("ИдентификаторРодителя",                    ТипИдентификатор, "parentId");
	
	Возврат Результат;
	
КонецФункции

// Сериализует примитивный тип в формат JSON.
//
Функция ЗначениеВФорматJSON(Данные, ПараметрыЗаписи = Неопределено)
	
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку(ПараметрыЗаписи);
	ЗаписатьJSON(ЗаписьJSON, Данные);
	
	Возврат ЗаписьJSON.Закрыть();
	
КонецФункции

#КонецОбласти
