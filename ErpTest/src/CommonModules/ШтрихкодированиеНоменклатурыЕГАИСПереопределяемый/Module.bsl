
#Область ПрограммныйИнтерфейс

// В функции нужно реализовать подготовку данных для дальнейшей обработки штрихкодов.
//
// Параметры:
//  Форма - УправляемаяФорма - форма документа, в которой происходит обработка,
//  ДанныеШтрихкодов - Массив - полученные штрихкоды,
//  ПараметрыЗаполнения - Структура - параметры заполнения (см. ИнтеграцияЕГАИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти()).
//
// Возвращаемое значение:
//  Структура - подготовленные данные.
//
Функция ПодготовитьДанныеДляОбработкиШтрихкодов(Форма, ДанныеШтрихкодов, ПараметрыЗаполнения) Экспорт
	
	//++ НЕ ГОСИС
	ПараметрыЗаполненияНоменклатурыЕГАИС = Новый Структура;
	ПараметрыЗаполненияНоменклатурыЕГАИС.Вставить("ЗаполнитьФлагАлкогольнаяПродукция", Ложь);
	ПараметрыЗаполненияНоменклатурыЕГАИС.Вставить("ИмяКолонки", "АлкогольнаяПродукция");
	
	СтруктураДействийСДобавленнымиСтроками = Новый Структура;
	СтруктураДействийСДобавленнымиСтроками.Вставить("ЗаполнитьНоменклатуруЕГАИС", ПараметрыЗаполненияНоменклатурыЕГАИС);
	
	Если ПараметрыЗаполнения.ПересчитатьКоличествоЕдиниц Тогда
		СтруктураДействийСДобавленнымиСтроками.Вставить("ПересчитатьКоличествоЕдиниц");
	КонецЕсли;
	Если ПараметрыЗаполнения.ПересчитатьСумму Тогда
		СтруктураДействийСДобавленнымиСтроками.Вставить("ПересчитатьСумму");
	КонецЕсли;
	Если ПараметрыЗаполнения.ЗаполнитьИндексАкцизнойМарки Тогда
		СтруктураДействийСДобавленнымиСтроками.Вставить("ЗаполнитьИндексАкцизнойМарки");
	КонецЕсли;
	
	СтруктураДействийСИзмененнымиСтроками = Новый Структура;
	Если ПараметрыЗаполнения.ПересчитатьКоличествоЕдиниц Тогда
		СтруктураДействийСИзмененнымиСтроками.Вставить("ПересчитатьКоличествоЕдиниц");
	КонецЕсли;
	Если ПараметрыЗаполнения.ПересчитатьСумму Тогда
		СтруктураДействийСИзмененнымиСтроками.Вставить("ПересчитатьСумму");
	КонецЕсли;
	Если ПараметрыЗаполнения.ЗаполнитьИндексАкцизнойМарки Тогда
		СтруктураДействийСИзмененнымиСтроками.Вставить("ЗаполнитьИндексАкцизнойМарки");
	КонецЕсли;
	
	СтруктураДействий = ПараметрыОбработкиШтрихкодов();
	
	СтруктураДействий.Штрихкоды                               = ДанныеШтрихкодов;
	СтруктураДействий.СтруктураДействийСДобавленнымиСтроками  = СтруктураДействийСДобавленнымиСтроками;
	СтруктураДействий.СтруктураДействийСИзмененнымиСтроками   = СтруктураДействийСИзмененнымиСтроками;
	СтруктураДействий.ТолькоТовары                            = Истина;
	СтруктураДействий.ШтрихкодыВТЧ                            = ПараметрыЗаполнения.ШтрихкодыВТЧ;
	СтруктураДействий.МаркируемаяАлкогольнаяПродукцияВТЧ      = ПараметрыЗаполнения.МаркируемаяАлкогольнаяПродукцияВТЧ;
	
	Возврат СтруктураДействий;
	//-- НЕ ГОСИС
	
	Возврат Неопределено;
	
КонецФункции

// В процедуре требуется реализовать алгоритм обработки полученных штрихкодов.
//
// Параметры:
//  Форма - УправляемаяФорма - форма документа, в которой происходит обработка,
//  ДанныеДляОбработки - Структура - подготовленные ранее данные для обработки,
//  КэшированныеЗначения - Структура - используется механизмом обработки изменения реквизитов ТЧ.
//
Процедура ОбработатьШтрихкоды(Форма, ДанныеДляОбработки, КэшированныеЗначения) Экспорт
	
	//++ НЕ ГОСИС
	ШтрихкодированиеНоменклатурыСервер.ОбработатьШтрихкоды(
		Форма, Форма.Объект,
		ДанныеДляОбработки, КэшированныеЗначения);
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

// В процедуре требуется реализовать алгоритм обработки полученных штрихкодов из ТСД.
//
// Параметры:
//  Форма - УправляемаяФорма - форма документа, в которой происходит обработка,
//  ДанныеДляОбработки - Структура - подготовленные ранее данные для обработки,
//  КэшированныеЗначения - Структура - используется механизмом обработки изменения реквизитов ТЧ.
//
Процедура ОбработатьДанныеИзТСД(Форма, ДанныеДляОбработки, КэшированныеЗначения) Экспорт
	
	//++ НЕ ГОСИС
	ШтрихкодированиеНоменклатурыСервер.ОбработатьШтрихкоды(
		Форма, Форма.Объект,
		ДанныеДляОбработки, КэшированныеЗначения);
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

// В функции требуется реализовать алгоритм получения массива штрихкодов по переданному отбору.
//
// Параметры:
//  Отбор - Структура - структура с ключами:
//   * Номенклатура - ОпределяемыйТип.Номенклатура - ссылка на номенклатуру,
//   * Характеристика - ОпределяемыйТип.ХарактеристикаНоменклатуры - ссылка на характеристику номенклатуры,
//   * Упаковка - ОпределяемыйТип.Упаковка - ссылка на упаковку.
//
// Возвращаемое значение:
//  Массив - массив штрихкодов.
//
Функция ПолучитьШтрихкодыНоменклатуры(Отбор) Экспорт
	
	//++ НЕ ГОСИС
	Возврат РозничныеПродажиВызовСервера.ПолучитьШтрихкодыНоменклатуры(Отбор);
	//-- НЕ ГОСИС
	
	Возврат Новый Массив;
	
КонецФункции

// Получить данные о номенклатуре по штрихкоду.
//
// Параметры:
//  Штрихкод - Строка - считанный штрихкод.
// 
// Возвращаемое значение:
//  Структура - Структура со свойствами:
//   * НоменклатураЕГАИС - СправочникСсылка.КлассификаторАлкогольнойПродукцииЕГАИС - ссылка на алкогольную продукцию,
//   * Номенклатура - ОпределяемыйТип.Номенклатура - ссылка на номенклатуру,
//   * Характеристика - ОпределяемыйТип.ХарактеристикаНоменклатуры - ссылка на характеристику номенклатуры.
//   * Упаковка - ОпределяемыйТип.Упаковка - ссылка на упаковку номенклатуры.
//  Неопределено - номенклатура не найдена.
//
Функция НайтиПоШтрихкоду(Штрихкод) Экспорт
	
	//++ НЕ ГОСИС
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ШтрихкодыНоменклатуры.Номенклатура КАК Номенклатура,
	|	ШтрихкодыНоменклатуры.Характеристика КАК Характеристика,
	|	ШтрихкодыНоменклатуры.Упаковка КАК Упаковка
	|ПОМЕСТИТЬ ДанныеПоШтрихкоду
	|ИЗ
	|	РегистрСведений.ШтрихкодыНоменклатуры КАК ШтрихкодыНоменклатуры
	|ГДЕ
	|	ШтрихкодыНоменклатуры.Штрихкод = &Штрихкод
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(ЕСТЬNULL(СоответствиеНоменклатурыЕГАИС.АлкогольнаяПродукция,ЗНАЧЕНИЕ(Справочник.КлассификаторАлкогольнойПродукцииЕГАИС.ПустаяСсылка))) КАК АлкогольнаяПродукция,
	|	ТабличнаяЧасть.Номенклатура КАК Номенклатура,
	|	ТабличнаяЧасть.Характеристика КАК Характеристика
	|ПОМЕСТИТЬ СопоставленныеПозиции
	|ИЗ
	|	ДанныеПоШтрихкоду КАК ТабличнаяЧасть
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоответствиеНоменклатурыЕГАИС КАК СоответствиеНоменклатурыЕГАИС
	|		ПО СоответствиеНоменклатурыЕГАИС.Номенклатура = ТабличнаяЧасть.Номенклатура
	|			И СоответствиеНоменклатурыЕГАИС.Характеристика = ТабличнаяЧасть.Характеристика
	|СГРУППИРОВАТЬ ПО
	|	ТабличнаяЧасть.Номенклатура,
	|	ТабличнаяЧасть.Характеристика
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЕСТЬNULL(СоответствиеНоменклатурыЕГАИС.АлкогольнаяПродукция,ЗНАЧЕНИЕ(Справочник.КлассификаторАлкогольнойПродукцииЕГАИС.ПустаяСсылка))) = 1
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеПоШтрихкоду.Номенклатура КАК Номенклатура,
	|	ДанныеПоШтрихкоду.Характеристика КАК Характеристика,
	|	ДанныеПоШтрихкоду.Упаковка КАК Упаковка,
	|	МАКСИМУМ(ЕСТЬNULL(СоответствиеНоменклатурыЕГАИС.АлкогольнаяПродукция, ЗНАЧЕНИЕ(Справочник.КлассификаторАлкогольнойПродукцииЕГАИС.ПустаяСсылка))) КАК АлкогольнаяПродукция
	|ИЗ
	|	ДанныеПоШтрихкоду КАК ДанныеПоШтрихкоду
	|		ЛЕВОЕ СОЕДИНЕНИЕ СопоставленныеПозиции КАК СоответствиеНоменклатурыЕГАИС
	|		ПО ДанныеПоШтрихкоду.Номенклатура = СоответствиеНоменклатурыЕГАИС.Номенклатура
	|			И ДанныеПоШтрихкоду.Характеристика = СоответствиеНоменклатурыЕГАИС.Характеристика
	|
	|СГРУППИРОВАТЬ ПО
	|	ДанныеПоШтрихкоду.Номенклатура,
	|	ДанныеПоШтрихкоду.Характеристика,
	|	ДанныеПоШтрихкоду.Упаковка";
	
	Запрос.УстановитьПараметр("Штрихкод", Штрихкод);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		
		ВозвращаемоеЗначение = Новый Структура;
		ВозвращаемоеЗначение.Вставить("АлкогольнаяПродукция", Выборка.АлкогольнаяПродукция);
		ВозвращаемоеЗначение.Вставить("Номенклатура",         Выборка.Номенклатура);
		ВозвращаемоеЗначение.Вставить("Характеристика",       Выборка.Характеристика);
		ВозвращаемоеЗначение.Вставить("Упаковка",             Выборка.Упаковка);
		
		Возврат ВозвращаемоеЗначение;
		
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	//-- НЕ ГОСИС
	
	Возврат Неопределено;
	
КонецФункции

// В функции требуется определить право на регистрацию нового штрихкода для текущего пользователя.
//
// Возвращаемое значение:
//  Булево - Истина, если есть право на регистрацию штрихкода. Ложь - в противном случае.
//
Функция ЕстьПравоРегистрацииШтрихкодовНоменклатуры() Экспорт
	
	//++ НЕ ГОСИС
	Возврат ПравоДоступа("Изменение", Метаданные.РегистрыСведений.ШтрихкодыНоменклатуры);
	//-- НЕ ГОСИС
	
	Возврат Ложь;
	
КонецФункции



#КонецОбласти

//++ НЕ ГОСИС
#Область СлужебныеПроцедурыИФункцииУТ

//Возвращает структуру параметров обработки штрихкодов.
//
// Возвращаемое значение:
//  Структура - Параметры обработки штрихкодов.
//
Функция ПараметрыОбработкиШтрихкодов()
	
	ПараметрыОбработки = Новый Структура;
	ПараметрыОбработки.Вставить("Штрихкоды",                                      Неопределено);
	ПараметрыОбработки.Вставить("СтруктураДействийСДобавленнымиСтроками",         Неопределено);
	ПараметрыОбработки.Вставить("СтруктураДействийСИзмененнымиСтроками",          Неопределено);
	ПараметрыОбработки.Вставить("СтруктураДействийСоСтрокамиИзУпаковочныхЛистов", Неопределено);
	ПараметрыОбработки.Вставить("ПараметрыУказанияСерий",                 Неопределено);
	ПараметрыОбработки.Вставить("ДействияСНеизвестнымиШтрихкодами",       "ЗарегистрироватьПеренестиВДокумент");
	ПараметрыОбработки.Вставить("ИмяКолонкиКоличество",                   "КоличествоУпаковок");
	ПараметрыОбработки.Вставить("НеИспользоватьУпаковки",                 Ложь);
	ПараметрыОбработки.Вставить("ИмяТЧ",                                  "Товары");
	ПараметрыОбработки.Вставить("ИзменятьКоличество",                     Истина);
	ПараметрыОбработки.Вставить("БлокироватьДанныеФормы",                 Истина);
	ПараметрыОбработки.Вставить("ТолькоТовары",                           Ложь);
	ПараметрыОбработки.Вставить("ТолькоТоварыИРабота",                    Ложь);
	ПараметрыОбработки.Вставить("ТолькоУслуги",                           Ложь);
	ПараметрыОбработки.Вставить("ТолькоТара",                             Ложь);
	ПараметрыОбработки.Вставить("ТолькоНеПодакцизныйТовар",               Ложь);
	ПараметрыОбработки.Вставить("НеизвестныеШтрихкоды",                   Новый Массив);
	ПараметрыОбработки.Вставить("ОтложенныеТовары",                       Новый Массив);
	ПараметрыОбработки.Вставить("ПараметрыПроверкиАссортимента",          Неопределено);
	ПараметрыОбработки.Вставить("РассчитыватьНаборы",                     Ложь);
	ПараметрыОбработки.Вставить("УчитыватьУпаковочныеЛисты",              Ложь);
	ПараметрыОбработки.Вставить("ОтработатьИзменениеУпаковочныхЛистов",   Ложь);
	ПараметрыОбработки.Вставить("ШтрихкодыВТЧ",                           Ложь);
	ПараметрыОбработки.Вставить("МаркируемаяАлкогольнаяПродукцияВТЧ",     Ложь);
	ПараметрыОбработки.Вставить("УвеличиватьКоличествоВСтрокахССериями",  Истина);
	ПараметрыОбработки.Вставить("ТекущийУпаковочныйЛист",                 Неопределено);
	ПараметрыОбработки.Вставить("ЗаполнятьНазначения",                    Ложь);
	ПараметрыОбработки.Вставить("ЗагрузкаИзТСД",                          Ложь);
	
	//Возвращаемые параметры
	ПараметрыОбработки.Вставить("МассивСтрокССериями",          Новый Массив);
	ПараметрыОбработки.Вставить("МассивСтрокСАкцизнымиМарками", Новый Массив);
	ПараметрыОбработки.Вставить("ТекущаяСтрока",       Неопределено);
	
	Возврат ПараметрыОбработки;
	
КонецФункции

#КонецОбласти
//-- НЕ ГОСИС