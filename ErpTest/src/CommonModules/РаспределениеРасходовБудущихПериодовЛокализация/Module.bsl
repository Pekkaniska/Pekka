
#Область ПрограммныйИнтерфейс

#Область ОбработчикиСобытий

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый документ.
//  Отказ - Булево - Признак проведения документа.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то проведение документа выполнено не будет.
//  РежимПроведения - РежимПроведенияДокумента - В данный параметр передается текущий режим проведения.
//
Процедура ОбработкаПроведения(Объект, Отказ, РежимПроведения) Экспорт
	
	Движения = Объект.Движения;
	ДополнительныеСвойства = Объект.ДополнительныеСвойства;
	//++ Локализация
	//++ НЕ УТ
	РеглУчетПроведениеСервер.ОтразитьПорядокОтраженияПрочихОпераций(ДополнительныеСвойства, Отказ);
	РеглУчетПроведениеСервер.ЗарегистрироватьКОтражению(Объект, ДополнительныеСвойства, Движения, Отказ);
	//-- НЕ УТ
	//-- Локализация
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то будет выполнен отказ от продолжения работы после выполнения проверки заполнения.
//  ПроверяемыеРеквизиты - Массив - Массив путей к реквизитам, для которых будет выполнена проверка заполнения.
//
Процедура ОбработкаПроверкиЗаполнения(Объект, Отказ, ПроверяемыеРеквизиты) Экспорт
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект.
//  ДанныеЗаполнения - Произвольный - Значение, которое используется как основание для заполнения.
//  СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения стандартной (системной) обработки события.
//
Процедура ОбработкаЗаполнения(Объект, ДанныеЗаполнения, СтандартнаяОбработка) Экспорт
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Признак отказа от записи.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то запись выполнена не будет и будет вызвано исключение.
//
Процедура ОбработкаУдаленияПроведения(Объект, Отказ) Экспорт
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Признак отказа от записи.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то запись выполнена не будет и будет вызвано исключение.
//  РежимЗаписи - РежимЗаписиДокумента - В параметр передается текущий режим записи документа. Позволяет определить в теле процедуры режим записи.
//  РежимПроведения - РежимПроведенияДокумента - В данный параметр передается текущий режим проведения.
//
Процедура ПередЗаписью(Объект, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	//++ Локализация
		//++ НЕ УТ
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		УстановитьПараметрыВыборочнойРегистрацииКОтражениюВРеглУчете(Объект, Объект.ДополнительныеСвойства);
	КонецЕсли;
		//-- НЕ УТ
	//-- Локализация
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Признак отказа от записи.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина, то запись выполнена не будет и будет вызвано исключение.
//
Процедура ПриЗаписи(Объект, Отказ) Экспорт
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  ОбъектКопирования - ДокументОбъект.<Имя документа> - Исходный документ, который является источником копирования.
//
Процедура ПриКопировании(Объект, ОбъектКопирования) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#Область ПодключаемыеКоманды

// Определяет список команд создания на основании.
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	
КонецПроцедуры

// Добавляет команду создания документа "Авансовый отчет".
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Процедура ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт


КонецПроцедуры

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

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#Область Печать

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

//++ НЕ УТ
#Область ПроводкиРегУчета

// Функция возвращает текст запроса для отражения документа в регламентированном учете.
//
// Возвращаемое значение:
//	Строка - Текст запроса
//
Функция ТекстОтраженияВРеглУчете() Экспорт
	
	//++ Локализация
	
	ТекстРаспределениеРБПНаРасходы = "
	|ВЫБРАТЬ // Распределение РБП (Дт <25, 26, 44, 20, 23, 08.3, 20> :: Кт <97.х> )
	|
	|	Операция.Ссылка КАК Ссылка,
	|	Строки.Период КАК Период,
	|	Операция.Организация КАК Организация,
	|	НЕОПРЕДЕЛЕНО КАК ИдентификаторСтроки,
	|
	|	Строки.СуммаРегл КАК Сумма,
	|	Строки.СуммаУпр КАК СуммаУУ,
	|
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.Расходы) КАК ВидСчетаДт,
	|	Строки.СтатьяРасходов КАК АналитикаУчетаДт,
	|	Строки.Подразделение КАК МестоУчетаДт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаДт,
	|	Строки.Подразделение КАК ПодразделениеДт,
	|	Строки.НаправлениеДеятельности КАК НаправлениеДеятельностиДт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетДт,
	|
	|	Строки.СтатьяРасходов КАК СубконтоДт1,
	|	Строки.АналитикаРасходов КАК СубконтоДт2,
	|	ВЫБОР КОГДА СтатьиСтроительства.Ссылка ЕСТЬ НЕ NULL ТОГДА
	|				ВЫБОР КОГДА ОбъектыСтроительства.СпособСтроительства <> ЗНАЧЕНИЕ(Перечисление.СпособыСтроительства.ПустаяСсылка) 
	|						ТОГДА ОбъектыСтроительства.СпособСтроительства
	|					ИНАЧЕ 
	|						ЗНАЧЕНИЕ(Перечисление.СпособыСтроительства.Подрядный) 
	|				КОНЕЦ
	|	ИНАЧЕ
	|		ЗНАЧЕНИЕ(Перечисление.ТипыЗатратРегл.Прочее)
	|	КОНЕЦ КАК СубконтоДт3,
	|	
	|	0 КАК ВалютнаяСуммаДт,
	|	0 КАК КоличествоДт,
	|	Строки.СуммаРегл - Строки.ПостояннаяРазница - Строки.ВременнаяРазница КАК СуммаНУДт,
	|	Строки.ПостояннаяРазница КАК СуммаПРДт,
	|	Строки.ВременнаяРазница КАК СуммаВРДт,
	|	
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.Расходы) КАК ВидСчетаКт,
	|	Операция.СтатьяРасходов КАК АналитикаУчетаКт,
	|	Операция.Подразделение КАК МестоУчетаКт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаКт,
	|	Операция.Подразделение КАК ПодразделениеКт,
	|	Операция.НаправлениеДеятельности КАК НаправлениеДеятельностиКт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетКт,
	|	Операция.СтатьяРасходов КАК СубконтоКт1,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗатратРегл.Прочее) КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|
	|	0 КАК ВалютнаяСуммаКт,
	|	0 КАК КоличествоКт,
	|	КорСтроки.СуммаРегл - КорСтроки.ПостояннаяРазница - КорСтроки.ВременнаяРазница КАК СуммаНУКт,
	|	КорСтроки.ПостояннаяРазница КАК СуммаПРКт,
	|	КорСтроки.ВременнаяРазница КАК СуммаВРКт,
	|	""Распределение РБП на расходы"" КАК Содержание
	|ИЗ
	|	ДокументыКОтражению КАК ДокументыКОтражению
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.РаспределениеРасходовБудущихПериодов КАК Операция
	|	ПО	
	|		ДокументыКОтражению.Ссылка = Операция.Ссылка
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		РегистрНакопления.ПрочиеРасходы КАК Строки
	|	ПО
	|		Строки.Регистратор = Операция.Ссылка
	|		И Строки.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		РегистрНакопления.ПрочиеРасходы КАК КорСтроки
	|	ПО
	|		КорСтроки.Регистратор = Операция.Ссылка
	|		И КорСтроки.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|		И КорСтроки.Период = Строки.Период
	|		И КорСтроки.СуммаРегл = Строки.СуммаРегл
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ПланВидовХарактеристик.СтатьиРасходов КАК СтатьиСтроительства
	|	ПО
	|		Строки.СтатьяРасходов = СтатьиСтроительства.Ссылка
	|		И СтатьиСтроительства.ВариантРаспределенияРасходовРегл = ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаВнеоборотныеАктивы)
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ПланВидовХарактеристик.СтатьиРасходов КАК СтатьиНаПрочиеАктивы
	|	ПО
	|		Строки.СтатьяРасходов = СтатьиНаПрочиеАктивы.Ссылка
	|		И СтатьиНаПрочиеАктивы.ВариантРаспределенияРасходовРегл = ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаПрочиеАктивы)
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ 
	|		Справочник.ОбъектыСтроительства КАК ОбъектыСтроительства
	|	ПО 
	|		ОбъектыСтроительства.Ссылка = Строки.АналитикаРасходов
	|ГДЕ
	|	(Строки.СуммаРегл <> 0 ИЛИ Строки.ПостояннаяРазница <> 0 ИЛИ Строки.ВременнаяРазница <> 0 ИЛИ Строки.СуммаУпр <> 0)
	|	И СтатьиНаПрочиеАктивы.Ссылка ЕСТЬ NULL
	|";
	
	ТекстРаспределениеРБПНаДопРасходыПоТоварам = "
	|ВЫБРАТЬ // Распределение РБП (Дт <10.ДР, 41.ДР> :: Кт <97.х> )
	|
	|	Операция.Ссылка КАК Ссылка,
	|	Строки.Период КАК Период,
	|	Операция.Организация КАК Организация,
	|	НЕОПРЕДЕЛЕНО КАК ИдентификаторСтроки,
	|
	|	Строки.СтоимостьРегл КАК Сумма,
	|	Строки.Стоимость КАК СуммаУУ,
	|
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.Расходы) КАК ВидСчетаДт,
	|	Строки.СтатьяРасходов КАК АналитикаУчетаДт,
	|	Строки.Подразделение КАК МестоУчетаДт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаДт,
	|	Строки.Подразделение КАК ПодразделениеДт,
	|	Строки.НаправлениеДеятельности КАК НаправлениеДеятельностиДт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетДт,
	|
	|	Строки.СтатьяРасходов КАК СубконтоДт1,
	|	Строки.АналитикаРасходов КАК СубконтоДт2,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗатратРегл.Прочее) КАК СубконтоДт3,
	|	
	|	0 КАК ВалютнаяСуммаДт,
	|	0 КАК КоличествоДт,
	|	Строки.СтоимостьРегл - Строки.ПостояннаяРазница - Строки.ВременнаяРазница КАК СуммаНУДт,
	|	Строки.ПостояннаяРазница КАК СуммаПРДт,
	|	Строки.ВременнаяРазница КАК СуммаВРДт,
	|	
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.Расходы) КАК ВидСчетаКт,
	|	Операция.СтатьяРасходов КАК АналитикаУчетаКт,
	|	Операция.Подразделение КАК МестоУчетаКт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаКт,
	|	Операция.Подразделение КАК ПодразделениеКт,
	|	Операция.НаправлениеДеятельности КАК НаправлениеДеятельностиКт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетКт,
	|	Операция.СтатьяРасходов КАК СубконтоКт1,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗатратРегл.Прочее) КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|
	|	0 КАК ВалютнаяСуммаКт,
	|	0 КАК КоличествоКт,
	|	КорСтроки.СуммаРегл - КорСтроки.ПостояннаяРазница - КорСтроки.ВременнаяРазница КАК СуммаНУКт,
	|	КорСтроки.ПостояннаяРазница КАК СуммаПРКт,
	|	КорСтроки.ВременнаяРазница КАК СуммаВРКт,
	|	""Распределение РБП на расходы"" КАК Содержание
	|ИЗ
	|	ДокументыКОтражению КАК ДокументыКОтражению
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.РаспределениеРасходовБудущихПериодов КАК Операция
	|	ПО	
	|		ДокументыКОтражению.Ссылка = Операция.Ссылка
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		РегистрНакопления.ПартииПрочихРасходов КАК Строки
	|	ПО
	|		Строки.Регистратор = Операция.Ссылка
	|		И Строки.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		РегистрНакопления.ПрочиеРасходы КАК КорСтроки
	|	ПО
	|		КорСтроки.Регистратор = Операция.Ссылка
	|		И КорСтроки.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|		И КорСтроки.Период = Строки.Период
	|		И КорСтроки.СуммаРегл = Строки.СтоимостьРегл
	|ГДЕ
	|	(Строки.СтоимостьРегл <> 0 ИЛИ Строки.ПостояннаяРазница <> 0 ИЛИ Строки.ВременнаяРазница <> 0 ИЛИ Строки.Стоимость <> 0)
	|";
	
	ТекстРаспределениеРБПНаПрочиеАктивы = "
	// Поддержка статей расходов с устаревшим направлением распределения "НаПрочиеАктивы".
	|ВЫБРАТЬ // Распределение РБП на прочие активы (Дт <ХХ> :: Кт <97.х> )
	|
	|	Операция.Ссылка КАК Ссылка,
	|	Строки.Дата КАК Период,
	|	Операция.Организация КАК Организация,
	|	"""" КАК ИдентификаторСтроки,
	|
	|	Строки.СуммаРегл КАК Сумма,
	|	Строки.СуммаУпр КАК СуммаУУ,
	|
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.ПрочиеОперации) КАК ВидСчетаДт,
	|	НЕОПРЕДЕЛЕНО КАК АналитикаУчетаДт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаДт,
	|	
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаДт,
	|	Строки.Подразделение КАК ПодразделениеДт,
	|	Операция.НаправлениеДеятельности КАК НаправлениеДеятельностиДт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетДт,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
	|	
	|	0 КАК ВалютнаяСуммаДт,
	|	0 КАК КоличествоДт,
	|	Строки.СуммаРегл - Строки.ПостояннаяРазница - Строки.ВременнаяРазница КАК СуммаНУДт,
	|	Строки.ПостояннаяРазница КАК СуммаПРДт,
	|	Строки.ВременнаяРазница КАК СуммаВРДт,
	|	
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.Расходы) КАК ВидСчетаКт,
	|	Операция.СтатьяРасходов КАК АналитикаУчетаКт,
	|	Операция.Подразделение КАК МестоУчетаКт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаКт,
	|	Операция.Подразделение КАК ПодразделениеКт,
	|	Операция.НаправлениеДеятельности КАК НаправлениеДеятельностиКт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетКт,
	|	Операция.СтатьяРасходов КАК СубконтоКт1,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗатратРегл.Прочее) КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|
	|	0 КАК ВалютнаяСуммаКт,
	|	0 КАК КоличествоКт,
	|	Строки.СуммаРегл - Строки.ПостояннаяРазница - Строки.ВременнаяРазница КАК СуммаНУКт,
	|	Строки.ПостояннаяРазница КАК СуммаПРКт,
	|	Строки.ВременнаяРазница КАК СуммаВРКт,
	|	""Распределение РБП на прочие активы"" КАК Содержание
	|ИЗ
	|	ДокументыКОтражению КАК ДокументыКОтражению
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.РаспределениеРасходовБудущихПериодов КАК Операция
	|	ПО	
	|		ДокументыКОтражению.Ссылка = Операция.Ссылка
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.РаспределениеРасходовБудущихПериодов.РаспределениеРасходов КАК Строки
	|	ПО
	|		Строки.Ссылка = Операция.Ссылка
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ПланВидовХарактеристик.СтатьиРасходов КАК СтатьиПрочихОпераций
	|	ПО
	|		Строки.СтатьяРасходов = СтатьиПрочихОпераций.Ссылка
	|		И СтатьиПрочихОпераций.ВариантРаспределенияРасходовРегл = ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаПрочиеАктивы)
	|
	|ГДЕ
	|	(Строки.СуммаРегл <> 0 ИЛИ Строки.ПостояннаяРазница <> 0 ИЛИ Строки.ВременнаяРазница <> 0 ИЛИ Строки.СуммаУпр <> 0)
	|";

	ТекстыОтражения = Новый Массив;
	ТекстыОтражения.Добавить(ТекстРаспределениеРБПНаРасходы);
	ТекстыОтражения.Добавить(ТекстРаспределениеРБПНаДопРасходыПоТоварам);
	ТекстыОтражения.Добавить(ТекстРаспределениеРБПНаПрочиеАктивы);
	
	Возврат СтрСоединить(ТекстыОтражения, ОбщегоНазначенияУТ.РазделительЗапросовВОбъединении());
	
	//-- Локализация
	Возврат "";
	
КонецФункции

// Функция возвращает текст запроса дополнительных временных таблиц,
// необходимых для отражения в регламентированном учете
//
// Возвращаемое значение:
//   Строка - сформированный текст запроса.
//
Функция ТекстЗапросаВТОтраженияВРеглУчете() Экспорт
	
	//++ Локализация
	//-- Локализация
	Возврат "";
	
КонецФункции

#КонецОбласти
//-- НЕ УТ

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

// Процедура дополняет тексты запросов проведения документа.
//
// Параметры:
//  Запрос - Запрос - Общий запрос проведения документа.
//  ТекстыЗапроса - СписокЗначений - Список текстов запроса проведения.
//  Регистры - Строка, Структура - Список регистров проведения документа через запятую или в ключах структуры.
//
Процедура ДополнитьТекстыЗапросовПроведения(Запрос, ТекстыЗапроса, Регистры) Экспорт
	
	//++ Локализация
	//++ НЕ УТ
	ТекстЗапросаТаблицаПорядокОтраженияПрочихОпераций(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаОтражениеДокументовВРеглУчете(Запрос, ТекстыЗапроса, Регистры);
	//-- НЕ УТ
	//-- Локализация
	
КонецПроцедуры
//++ Локализация
//++ НЕ УТ

Функция ТекстЗапросаТаблицаПорядокОтраженияПрочихОпераций(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПорядокОтраженияПрочихОпераций";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	Операция.Дата        КАК Дата,
	|	Операция.Организация КАК Организация,
	|	Операция.Ссылка      КАК Документ,
	|	""""                 КАК ИдентификаторСтроки
	|ИЗ
	|	Документ.РаспределениеРасходовБудущихПериодов КАК Операция
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ 
	|		Документ.РаспределениеРасходовБудущихПериодов.РаспределениеРасходов КАК Строки
	|	ПО 
	|		Операция.Ссылка = Строки.Ссылка
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ 
	|		ПланВидовХарактеристик.СтатьиРасходов КАК Статья
	|	ПО 
	|		Статья.Ссылка = Строки.СтатьяРасходов
	|ГДЕ
	|	Операция.Ссылка = &Ссылка
	|	И Статья.ВариантРаспределенияРасходовРегл
	|		= ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаПрочиеАктивы)
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
КонецФункции

Функция ТекстЗапросаТаблицаОтражениеДокументовВРеглУчете(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ОтражениеДокументовВРеглУчете";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	Если Не ПроведениеСерверУТ.ЕстьТаблицаЗапроса("ВтПрочиеРасходы", ТекстыЗапроса) Тогда
		Документы.РаспределениеРасходовБудущихПериодов.ТекстЗапросаТаблицаВтПрочиеРасходы(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	Если Не ПроведениеСерверУТ.ЕстьТаблицаЗапроса("ВтПартииПрочихРасходов", ТекстыЗапроса) Тогда
		Документы.РаспределениеРасходовБудущихПериодов.ТекстЗапросаТаблицаВтПартииПрочихРасходов(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДанныеДокумента.Дата                   КАК Период,
	|	ДанныеДокумента.Организация            КАК Организация,
	|	Строки.Дата                            КАК ДатаОтражения
	|ИЗ
	|	Документ.РаспределениеРасходовБудущихПериодов КАК ДанныеДокумента
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.РаспределениеРасходовБудущихПериодов.РаспределениеРасходов КАК Строки
	|	ПО
	|		ДанныеДокумента.Ссылка = Строки.Ссылка
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|";
	ТекстЗапроса = ТекстЗапроса + "ОБЪЕДИНИТЬ ВСЕ"
		+ ДоходыИРасходыСервер.ДополнитьТекстЗапросаТаблицаОтражениеДокументовВРеглУчете();
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции
//-- НЕ УТ
//-- Локализация

#КонецОбласти

#Область Прочее

//++ Локализация
//++ НЕ УТ

Процедура УстановитьПараметрыВыборочнойРегистрацииКОтражениюВРеглУчете(Объект, ДополнительныеСвойства)
	
	Если НЕ Объект.Проведен Тогда
		Возврат;
	КонецЕсли;
	
	НепроверяемыеРеквизиты = Новый Структура;
	НепроверяемыеРеквизиты.Вставить("Комментарий");
	НепроверяемыеРеквизиты.Вставить("НачалоПериода");
	НепроверяемыеРеквизиты.Вставить("КонецПериода");
	НепроверяемыеРеквизиты.Вставить("КоличествоМесяцев");
	НепроверяемыеРеквизиты.Вставить("СуммаДокумента");
	НепроверяемыеРеквизиты.Вставить("СуммаДокументаРегл");
	НепроверяемыеРеквизиты.Вставить("СуммаДокументаПР");
	НепроверяемыеРеквизиты.Вставить("СуммаДокументаВР");
	
	ИзмененияДокумента = ОбщегоНазначенияУТ.ИзмененияДокумента(Объект, НепроверяемыеРеквизиты);
	
	Если ИзмененияДокумента.Свойство("Реквизиты") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ИзмененияДокумента.Свойство("ТабличныеЧасти") Тогда
		РеглУчетПроведениеСервер.НеРегистрироватьКОтражениюВРеглУчете(ДополнительныеСвойства);
	Иначе
		Если ИзмененияДокумента.ТабличныеЧасти.Количество() = 1
			И ИзмененияДокумента.ТабличныеЧасти.Свойство("РаспределениеРасходов") Тогда
			Для Каждого Строка Из ИзмененияДокумента.ТабличныеЧасти.РаспределениеРасходов Цикл
				
				РеглУчетПроведениеСервер.ДобавитьПараметрыВыборочнойРегистрацииКОтражениюВРеглУчете(
				ДополнительныеСвойства, 
				Объект.Организация, 
				Строка.Дата);
				
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры
//-- НЕ УТ
//-- Локализация
#КонецОбласти

#КонецОбласти
