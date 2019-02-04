
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
	//++ Локализация
	//-- Локализация
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
	//++ Локализация
	//-- Локализация
КонецПроцедуры

//++ Локализация

// Формирует временную таблицу, содержащую табличную часть по таблице данных документов.
//
// Параметры:
//	МенеджерВременныхТаблиц - МенеджерВременныхТаблиц - Менеджер временных таблиц, содержащий таблицу ТаблицаДанныхДокументов с полями:
//		Ссылка.
//
//	ПараметрыЗаполнения - Структура - структура, возвращаемая функцией ПродажиСервер.ПараметрыЗаполненияВременнойТаблицыТоваров.
//
Процедура ПоместитьВременнуюТаблицуТоваров(МенеджерВременныхТаблиц, ПараметрыЗаполнения = Неопределено) Экспорт
	
	Если ПараметрыЗаполнения = Неопределено Тогда
		ПараметрыЗаполнения = ПродажиСервер.ПараметрыЗаполненияВременнойТаблицыТоваров();
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ПересчитыватьВВалютуРегл", ПараметрыЗаполнения.ПересчитыватьВВалютуРегл);
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ТаблицаТоваров.Ссылка                     КАК Ссылка,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.Упаковка                   КАК Упаковка,
	|	МАКСИМУМ(ТаблицаТоваров.НомерСтроки)      КАК НомерСтроки
	|
	|ПОМЕСТИТЬ СтрокиТоваров
	|ИЗ
	|	Документ.ОтчетПоКомиссииМеждуОрганизациями.Товары КАК ТаблицаТоваров
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ТаблицаДанныхДокументов КАК ДанныеДокументов
	|	ПО
	|		ТаблицаТоваров.Ссылка = ДанныеДокументов.Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаТоваров.Ссылка,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.Упаковка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ТаблицаТоваров.Ссылка,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.Упаковка
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаДокумента.Ссылка                                        КАК Ссылка,
	|	СтрокиТоваров.НомерСтроки                                      КАК НомерСтроки,
	|	Аналитика.Номенклатура                                         КАК Номенклатура,
	|	Аналитика.Характеристика                                       КАК Характеристика,
	|	ТаблицаДокумента.НомерГТД                                      КАК НомерГТД,
	|	СУММА(ТаблицаДокумента.Количество)                             КАК Количество,
	|	СУММА(ТаблицаДокумента.КоличествоУпаковок)                     КАК КоличествоУпаковок,
	|	
	|	СУММА(ЕСТЬNULL(
	|		СуммыДокументовВВалютеРегл.СуммаБезНДСРегл,
	|		ТаблицаДокумента.СуммаСНДС - ТаблицаДокумента.СуммаНДС
	|	))                                                             КАК СуммаБезНДС,
	|	
	|	ТаблицаДокумента.СтавкаНДС                                     КАК СтавкаНДС,
	|	
	|	СУММА(ЕСТЬNULL(
	|		СуммыДокументовВВалютеРегл.СуммаНДСРегл,
	|		ТаблицаДокумента.СуммаНДС
	|	))                                                             КАК СуммаНДС,
	|	
	|	ИСТИНА                                                         КАК ЭтоТовар,
	|	ТаблицаДокумента.Упаковка                                      КАК Упаковка,
	|	ТаблицаДокумента.ДатаСчетаФактурыКомиссионера                  КАК ДатаСчетаФактурыКомиссионера,
	|	ТаблицаДокумента.Покупатель                                    КАК Покупатель
	|
	|ПОМЕСТИТЬ ОтчетПоКомиссииМеждуОрганизациямиТаблицаТоваров
	|ИЗ
	|	Документ.ОтчетПоКомиссииМеждуОрганизациями.ВидыЗапасов КАК ТаблицаДокумента
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ТаблицаДанныхДокументов КАК ДанныеДокументов
	|	ПО
	|		ТаблицаДокумента.Ссылка = ДанныеДокументов.Ссылка
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.СуммыДокументовВВалютеРегл КАК СуммыДокументовВВалютеРегл
	|	ПО
	|		ТаблицаДокумента.Ссылка = СуммыДокументовВВалютеРегл.Регистратор
	|		И ТаблицаДокумента.ИдентификаторСтроки = СуммыДокументовВВалютеРегл.ИдентификаторСтроки
	|		И СуммыДокументовВВалютеРегл.Активность
	|		И &ПересчитыватьВВалютуРегл
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		СтрокиТоваров КАК СтрокиТоваров
	|	ПО
	|		ТаблицаДокумента.Ссылка                       = СтрокиТоваров.Ссылка
	|		И ТаблицаДокумента.АналитикаУчетаНоменклатуры = СтрокиТоваров.АналитикаУчетаНоменклатуры
	|		И ТаблицаДокумента.Упаковка                   = СтрокиТоваров.Упаковка
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
	|	ПО
	|		ТаблицаДокумента.АналитикаУчетаНоменклатуры = Аналитика.КлючАналитики
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаДокумента.Ссылка,
	|	СтрокиТоваров.НомерСтроки,
	|	Аналитика.Номенклатура,
	|	Аналитика.Характеристика,
	|	ТаблицаДокумента.СтавкаНДС,
	|	ТаблицаДокумента.Упаковка,
	|	ТаблицаДокумента.НомерГТД,
	|	ТаблицаДокумента.ДатаСчетаФактурыКомиссионера,
	|	ТаблицаДокумента.Покупатель
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|ВЫБРАТЬ
	|	ТаблицаУслуги.Ссылка                                           КАК Ссылка,
	|	ТаблицаУслуги.НомерСтроки                                      КАК НомерСтроки,
	|	ТаблицаУслуги.Номенклатура                                     КАК Номенклатура,
	|	ТаблицаУслуги.Характеристика                                   КАК Характеристика,
	|	ЗНАЧЕНИЕ(Справочник.НомераГТД.ПустаяСсылка)                    КАК НомерГТД,
	|	СУММА(ТаблицаУслуги.Количество)                                КАК Количество,
	|	СУММА(ТаблицаУслуги.КоличествоУпаковок)                        КАК КоличествоУпаковок,
	|	
	|	СУММА(ТаблицаУслуги.СуммаСНДС - ТаблицаУслуги.СуммаНДС)        КАК СуммаБезНДС,
	|	
	|	ТаблицаУслуги.СтавкаНДС                                        КАК СтавкаНДС,
	|	
	|	СУММА(ТаблицаУслуги.СуммаНДС)                                  КАК СуммаНДС,
	|	
	|	ЛОЖЬ                                                           КАК ЭтоТовар,
	|	ТаблицаУслуги.Упаковка                                         КАК Упаковка,
	|	ТаблицаУслуги.ДатаСчетаФактурыКомиссионера                     КАК ДатаСчетаФактурыКомиссионера,
	|	ТаблицаУслуги.Покупатель                                       КАК Покупатель
	|
	|ИЗ
	|	Документ.ОтчетПоКомиссииМеждуОрганизациями.Товары КАК ТаблицаУслуги
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ТаблицаДанныхДокументов КАК ДанныеДокументов
	|	ПО
	|		ТаблицаУслуги.Ссылка = ДанныеДокументов.Ссылка
	|ГДЕ
	|	ТаблицаУслуги.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Услуга)
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаУслуги.Ссылка,
	|	ТаблицаУслуги.НомерСтроки,
	|	ТаблицаУслуги.Номенклатура,
	|	ТаблицаУслуги.Характеристика,
	|	ТаблицаУслуги.СтавкаНДС,
	|	ТаблицаУслуги.Упаковка,
	|	ТаблицаУслуги.ДатаСчетаФактурыКомиссионера,
	|	ТаблицаУслуги.Покупатель
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ СтрокиТоваров
	|";
	
	Запрос.Выполнить();
	
КонецПроцедуры

// Преобразует временную таблицу товаров, созданную функцией ПоместитьВременнуюТаблицуТоваров()
// к виду, используемому при печати счетов-фактуры.
// Дополняет таблицу услугой по вознаграждению.
// После преобразования исходная временная таблица уничтожается.
//
// Параметры:
//	МенеджерВременныхТаблиц - МенеджерВременныхТаблиц - Менеджер временных таблиц, содержащий таблицу ТаблицаТоваров.
//
Процедура ПреобразоватьВременнуюТаблицуТоваровДляСчетаФактуры(МенеджерВременныхТаблиц) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаТоваров.Ссылка                                        КАК Ссылка,
	|	ТаблицаТоваров.Номенклатура                                  КАК Номенклатура,
	|	ТаблицаТоваров.Характеристика                                КАК Характеристика,
	|	ТаблицаТоваров.НомерГТД                                      КАК НомерГТД,
	|	ТаблицаТоваров.Количество                                    КАК Количество,
	|	ТаблицаТоваров.КоличествоУпаковок                            КАК КоличествоУпаковок,
	|	ТаблицаТоваров.СтавкаНДС                                     КАК СтавкаНДС,
	|	ТаблицаТоваров.СуммаБезНДС                                   КАК СуммаБезНДС,
	|	ТаблицаТоваров.СуммаНДС                                      КАК СуммаНДС,
	|	ТаблицаТоваров.НомерСтроки                                   КАК НомерСтроки,
	|	ТаблицаТоваров.Упаковка                                      КАК Упаковка,
	|	ТаблицаТоваров.ЭтоТовар                                      КАК ЭтоТовар,
	|	ТаблицаТоваров.ДатаСчетаФактурыКомиссионера                  КАК ДатаСчетаФактурыКомиссионера,
	|	ТаблицаТоваров.Покупатель                                    КАК Покупатель,
	|	ЛОЖЬ                                                         КАК ВернутьМногооборотнуюТару,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыВыданныхСчетовФактур.ВыставляемыйКомиссионеру)   КАК ТипСчетаФактуры
	|
	|ПОМЕСТИТЬ ОтчетПоКомиссииМеждуОрганизациямиТаблицаТоваров
	|ИЗ
	|	ТаблицаТоваров КАК ТаблицаТоваров
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ТаблицаТоваров
	|";
	
	Запрос.Выполнить();
	
КонецПроцедуры
//-- Локализация
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

	ТекстыОтражения = Новый Массив;
	
#Область ТекстКомитентСписаниеКомиссионногоТовара // (Дт  :: Кт 004.02)
	ТекстЗапроса = "
	|ВЫБРАТЬ //// Списание комиссионного товара (Дт  :: Кт 004.02)
	|
	|	Операция.Ссылка КАК Ссылка,
	|	Операция.Дата КАК Период,
	|	Операция.Организация КАК Организация,
	|   НЕОПРЕДЕЛЕНО КАК ИдентификаторСтроки,
	|
	|	ЕСТЬNULL(Стоимости.Сумма, Строки.Сумма) КАК Сумма,
	|	ЕСТЬNULL(Стоимости.СуммаУУ, Строки.СуммаУУ) КАК СуммаУУ,
	|
	|	НЕОПРЕДЕЛЕНО КАК ВидСчетаДт,
	|	НЕОПРЕДЕЛЕНО КАК ГруппаФинансовогоУчетаДт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаДт,
	|
	|	НЕОПРЕДЕЛЕНО КАК ВалютаДт,
	|	НЕОПРЕДЕЛЕНО КАК ПодразделениеДт,
	|	ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка) КАК НаправлениеДеятельностиДт,
	|
	|	НЕОПРЕДЕЛЕНО КАК СчетДт,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
	|
	|	0 КАК ВалютнаяСуммаДт,
	|	0 КАК КоличествоДт,
	|	0 КАК СуммаНУДт,
	|	0 КАК СуммаПРДт,
	|	0 КАК СуммаВРДт,
	|
	|	НЕОПРЕДЕЛЕНО КАК ВидСчетаКт,
	|	НЕОПРЕДЕЛЕНО КАК ГруппаФинансовогоУчетаКт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаКт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаКт,
	|	Операция.Подразделение КАК ПодразделениеКт,
	|	ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка) КАК НаправлениеДеятельностиКт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ТоварыПереданныеНаКомиссию) КАК СчетКт,
	|	ВЫБОР КОГДА Операция.РасчетыЧерезОтдельногоКонтрагента ТОГДА
	|		Операция.Контрагент
	|	ИНАЧЕ
	|		Операция.Комиссионер
	|	КОНЕЦ КАК СубконтоКт1,
	|	Строки.Номенклатура КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|
	|	0 КАК ВалютнаяСуммаКт,
	|	Строки.Количество КАК КоличествоКт,
	|	0 КАК СуммаНУКт,
	|	0 КАК СуммаПРКт,
	|	0 КАК СуммаВРКт,
	|	""Списание комиссионного товара"" КАК Содержание
	|
	|ИЗ
	|	ДокументыКОтражению КАК ДокументыКОтражению
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.ОтчетПоКомиссииМеждуОрганизациямиОСписании КАК Операция
	|	ПО
	|		ДокументыКОтражению.Ссылка = Операция.Ссылка
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ВтСтроки КАК Строки
	|	ПО
	|		Строки.Ссылка = Операция.Ссылка
	|		И Строки.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ВтСтоимости КАК Стоимости
	|	ПО
	|		Строки.Ссылка = Стоимости.Ссылка
	|		И Строки.Номенклатура = Стоимости.Номенклатура
	|		И Строки.Склад = Стоимости.Склад
	|		И Строки.ГруппаФинансовогоУчета = Стоимости.ГруппаФинансовогоУчета
	|		И Строки.РазделУчета = Стоимости.РазделУчета
	|ГДЕ
	|	Строки.РазделУчета = ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыПринятыеНаКомиссию)
	|";
	ТекстыОтражения.Добавить(ТекстЗапроса);
#КонецОбласти

#Область ТекстКомитентВзаиморасчетыПоКомиссионномуТовару // (Дт 76.09 :: Кт 76.ОК)
	ТекстЗапроса = "
	|ВЫБРАТЬ //// Отражение взаиморасчетов по комиссионному товару (Дт 62.01 :: Кт 76.ОК)
	|
	|	Операция.Ссылка КАК Ссылка,
	|	Операция.Дата КАК Период,
	|	Операция.Организация КАК Организация,
	|	НЕОПРЕДЕЛЕНО КАК ИдентификаторСтроки,
	|
	|	ЕСТЬNULL(СуммыДокументовВВалютеРегл.СуммаБезНДСРегл + СуммыДокументовВВалютеРегл.СуммаНДСРегл, Строки.СуммаСНДС) КАК Сумма,
	|	ЕСТЬNULL(СуммыДокументовВВалютеРегл.СуммаБезНДСУпр + СуммыДокументовВВалютеРегл.СуммаНДСУпр, Строки.СуммаСНДС / КурсВалютыУпрУчета.Курс) КАК СуммаУУ,
	|
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.РасчетыСКлиентами) КАК ВидСчетаДт,
	|	ЕСТЬNULL(Расчеты.ГруппаФинансовогоУчета, Операция.ГруппаФинансовогоУчета) КАК ГруппаФинансовогоУчетаДт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаДт,
	|
	|	Операция.Валюта КАК ВалютаДт,
	|	ЕСТЬNULL(Расчеты.Подразделение, Операция.Подразделение) КАК ПодразделениеДт,
	|	Операция.НаправлениеДеятельности КАК НаправлениеДеятельностиДт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетДт,
	|	ВЫБОР КОГДА Операция.РасчетыЧерезОтдельногоКонтрагента ТОГДА
	|		Операция.Контрагент
	|	ИНАЧЕ
	|		Операция.Комиссионер
	|	КОНЕЦ КАК СубконтоДт1,
	|	ВЫБОР КОГДА Операция.РасчетыЧерезОтдельногоКонтрагента ТОГДА
	|		Операция.ДоговорПокупки
	|	ИНАЧЕ
	|		Операция.Договор
	|	КОНЕЦ КАК СубконтоДт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
	|
	|	0 КАК ВалютнаяСуммаДт,
	|	0 КАК КоличествоДт,
	|	0 КАК СуммаНУДт,
	|	0 КАК СуммаПРДт,
	|	0 КАК СуммаВРДт,
	|
	|	НЕОПРЕДЕЛЕНО КАК ВидСчетаКт,
	|	НЕОПРЕДЕЛЕНО КАК ГруппаФинансовогоУчетаКт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаКт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаКт,
	|	Операция.Подразделение КАК ПодразделениеКт,
	|	Аналитика.Назначение.НаправлениеДеятельности КАК НаправлениеДеятельностиКт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ТоварыКОформлениюОтчетовКомитенту) КАК СчетКт,
	|	Строки.ВидЗапасовКомитента.Контрагент КАК СубконтоКт1,
	|	Аналитика.Номенклатура КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|
	|	0 КАК ВалютнаяСуммаКт,
	|	Строки.Количество КАК КоличествоКт,
	|	0 КАК СуммаНУКт,
	|	0 КАК СуммаПРКт,
	|	0 КАК СуммаВРКт,
	|	""Отражение взаиморасчетов по комиссионному товару"" КАК Содержание
	|
	|ИЗ
	|	ДокументыКОтражению КАК ДокументыКОтражению
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.ОтчетПоКомиссииМеждуОрганизациямиОСписании КАК Операция
	|	ПО
	|		ДокументыКОтражению.Ссылка = Операция.Ссылка
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ 
	|		Документ.ОтчетПоКомиссииМеждуОрганизациямиОСписании.ВидыЗапасов КАК Строки
	|	ПО 
	|		(Строки.Ссылка = Операция.Ссылка)
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ 
	|		Справочник.ВидыЗапасов КАК ВидыЗапасовКомитента
	|	ПО 
	|		(Строки.ВидЗапасовКомитента = ВидыЗапасовКомитента.Ссылка)
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ 
	|		РегистрСведений.СуммыДокументовВВалютеРегл КАК СуммыДокументовВВалютеРегл
	|	ПО 
	|		Строки.Ссылка = СуммыДокументовВВалютеРегл.Регистратор
	|		И Строки.ИдентификаторСтроки = СуммыДокументовВВалютеРегл.ИдентификаторСтроки
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
	|	ПО
	|		Строки.АналитикаУчетаНоменклатуры = Аналитика.КлючАналитики
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ДанныеОбъектаРасчетов КАК Расчеты
	|	ПО 
	|		Операция.Ссылка = Расчеты.Ссылка
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		КурсыВалют КАК КурсВалютыУпрУчета
	|	ПО
	|		КурсВалютыУпрУчета.Валюта = &ВалютаУпрУчета
	|		И КурсВалютыУпрУчета.Дата = НАЧАЛОПЕРИОДА(Операция.Дата, День)
	|
	|ГДЕ
	|	Строки.ВидЗапасовКомитента.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.КомиссионныйТовар)
	|	И ЕСТЬNULL(СуммыДокументовВВалютеРегл.СуммаБезНДСРегл + СуммыДокументовВВалютеРегл.СуммаНДСРегл, Строки.СуммаСНДС) <> 0
	|";
	ТекстыОтражения.Добавить(ТекстЗапроса);
#КонецОбласти

#Область ТекстКомитентПрочихДоходов // (Дт 76.09 :: Кт 91.01.1)
	ТекстЗапроса = "
	|ВЫБРАТЬ //// Отражение прочих доходов (Дт 76.09 :: Кт 91.01.1)
	|
	|	Операция.Ссылка КАК Ссылка,
	|	Операция.Дата КАК Период,
	|	Операция.Организация КАК Организация,
	|   НЕОПРЕДЕЛЕНО КАК ИдентификаторСтроки,
	|
	|	ЕСТЬNULL(СуммыДокументовВВалютеРегл.СуммаБезНДСРегл + СуммыДокументовВВалютеРегл.СуммаНДСРегл, Строки.СуммаСНДС) КАК Сумма,
	|	ЕСТЬNULL(СуммыДокументовВВалютеРегл.СуммаБезНДСУпр + СуммыДокументовВВалютеРегл.СуммаНДСУпр, Строки.СуммаСНДС / КурсВалютыУпрУчета.Курс) КАК СуммаУУ,
	|
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.РасчетыСКлиентами) КАК ВидСчетаДт,
	|	Операция.ГруппаФинансовогоУчета КАК ГруппаФинансовогоУчетаДт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаДт,
	|
	|	Операция.Валюта КАК ВалютаДт,
	|	Операция.Подразделение КАК ПодразделениеДт,
	|	Операция.НаправлениеДеятельности КАК НаправлениеДеятельностиДт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетДт,
	|	ВЫБОР КОГДА Операция.РасчетыЧерезОтдельногоКонтрагента ТОГДА
	|		Операция.Контрагент
	|	ИНАЧЕ
	|		Операция.Комиссионер
	|	КОНЕЦ КАК СубконтоДт1,
	|	ВЫБОР КОГДА Операция.РасчетыЧерезОтдельногоКонтрагента ТОГДА
	|		Операция.ДоговорПокупки
	|	ИНАЧЕ
	|		Операция.Договор
	|	КОНЕЦ КАК СубконтоДт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
	|
	|	Строки.СуммаСНДС КАК ВалютнаяСуммаДт,
	|	0 КАК КоличествоДт,
	|	0 КАК СуммаНУДт,
	|	0 КАК СуммаПРДт,
	|	0 КАК СуммаВРДт,
	|
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.Доходы) КАК ВидСчетаКт,
	|	Операция.СтатьяДоходов КАК ГруппаФинансовогоУчетаКт,
	|	Операция.Подразделение КАК МестоУчетаКт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаКт,
	|	Операция.Подразделение КАК ПодразделениеКт,
	|	Операция.НаправлениеДеятельности КАК НаправлениеДеятельностиКт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетКт,
	|	Операция.СтатьяДоходов КАК СубконтоКт1,
	|	Аналитика.Номенклатура КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|
	|	0 КАК ВалютнаяСуммаКт,
	|	Строки.Количество КАК КоличествоКт,
	|	0 КАК СуммаНУКт,
	|	0 КАК СуммаПРКт,
	|	0 КАК СуммаВРКт,
	|	""Отражение прочих доходов"" КАК Содержание
	|
	|ИЗ
	|	ДокументыКОтражению КАК ДокументыКОтражению
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.ОтчетПоКомиссииМеждуОрганизациямиОСписании КАК Операция
	|	ПО
	|		ДокументыКОтражению.Ссылка = Операция.Ссылка
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ 
	|		Документ.ОтчетПоКомиссииМеждуОрганизациямиОСписании.ВидыЗапасов КАК Строки
	|	ПО 
	|		Строки.Ссылка = Операция.Ссылка
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ 
	|		РегистрСведений.СуммыДокументовВВалютеРегл КАК СуммыДокументовВВалютеРегл
	|	ПО 
	|		Строки.Ссылка = СуммыДокументовВВалютеРегл.Регистратор
	|		И Строки.ИдентификаторСтроки = СуммыДокументовВВалютеРегл.ИдентификаторСтроки
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
	|	ПО
	|		Строки.АналитикаУчетаНоменклатуры = Аналитика.КлючАналитики
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		КурсыВалют КАК КурсВалютыУпрУчета
	|	ПО
	|		КурсВалютыУпрУчета.Валюта = &ВалютаУпрУчета
	|		И КурсВалютыУпрУчета.Дата = НАЧАЛОПЕРИОДА(Операция.Дата, День)
	|
	|ГДЕ
	|	Строки.ВидЗапасовКомитента.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Товар)
	|	И ЕСТЬNULL(СуммыДокументовВВалютеРегл.СуммаБезНДСРегл + СуммыДокументовВВалютеРегл.СуммаНДСРегл, Строки.СуммаСНДС) <> 0
	|";
	ТекстыОтражения.Добавить(ТекстЗапроса);
#КонецОбласти

#Область ТекстКомитентСписаниеСебестоимостиТовара // (Дт 91.02 :: Кт 45.01)
	ТекстЗапроса = "
	|ВЫБРАТЬ //// Списание себестоимости товара (Дт 91.02 :: Кт 45.01)
	|
	|	Операция.Ссылка КАК Ссылка,
	|	Операция.Дата КАК Период,
	|	Операция.Организация КАК Организация,
	|   НЕОПРЕДЕЛЕНО КАК ИдентификаторСтроки,
	|
	|	ЕСТЬNULL(Стоимости.Сумма, Строки.Сумма) КАК Сумма,
	|	ЕСТЬNULL(Стоимости.СуммаУУ, Строки.СуммаУУ) КАК СуммаУУ,
	|
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.Расходы) КАК ВидСчетаДт,
	|	Операция.СтатьяРасходов КАК ГруппаФинансовогоУчетаДт,
	|	Операция.Подразделение КАК МестоУчетаДт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаДт,
	|	Операция.Подразделение КАК ПодразделениеДт,
	|	Операция.НаправлениеДеятельности КАК НаправлениеДеятельностиДт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетДт,
	|	Операция.СтатьяРасходов КАК СубконтоДт1,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗатратРегл.Прочее) КАК СубконтоДт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
	|
	|	0 КАК ВалютнаяСуммаДт,
	|	Строки.Количество КАК КоличествоДт,
	|	ЕСТЬNULL(Стоимости.СуммаНУ, Строки.СуммаНУ) КАК СуммаНУДт,
	|	ЕСТЬNULL(Стоимости.СуммаПР, Строки.СуммаПР) КАК СуммаПРДт,
	|	ЕСТЬNULL(Стоимости.СуммаВР, Строки.СуммаВР) КАК СуммаВРДт,
	|
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.ПередачаНаКомиссию) КАК ВидСчетаКт,
	|	Строки.ГруппаФинансовогоУчета КАК ГруппаФинансовогоУчетаКт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаКт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаКт,
	|	НЕОПРЕДЕЛЕНО КАК ПодразделениеКт,
	|	ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка) КАК НаправлениеДеятельностиКт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетКт,
	|	Операция.Комиссионер КАК СубконтоКт1,
	|	Строки.Номенклатура КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|
	|	0 КАК ВалютнаяСуммаКт,
	|	Строки.Количество КАК КоличествоКт,
	|	ЕСТЬNULL(Стоимости.СуммаНУ, Строки.СуммаНУ) КАК СуммаНУКт,
	|	ЕСТЬNULL(Стоимости.СуммаПР, Строки.СуммаПР) КАК СуммаПРКт,
	|	ЕСТЬNULL(Стоимости.СуммаВР, Строки.СуммаВР) КАК СуммаВРКт,
	|	""Списание себестоимости товара"" КАК Содержание
	|
	|ИЗ
	|	ДокументыКОтражению КАК ДокументыКОтражению
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.ОтчетПоКомиссииМеждуОрганизациямиОСписании КАК Операция
	|	ПО
	|		ДокументыКОтражению.Ссылка = Операция.Ссылка
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ВтСтроки КАК Строки
	|	ПО
	|		Строки.Ссылка = Операция.Ссылка
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ВтСтоимости КАК Стоимости
	|	ПО
	|		Строки.Ссылка = Стоимости.Ссылка
	|		И Строки.Номенклатура = Стоимости.Номенклатура
	|		И Строки.Склад = Стоимости.Склад
	|		И Строки.ГруппаФинансовогоУчета = Стоимости.ГруппаФинансовогоУчета
	|		И Строки.РазделУчета = Стоимости.РазделУчета
	|ГДЕ
	|	Строки.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Товар)
	|	И Строки.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|	И Строки.РазделУчета <> ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыПринятыеНаКомиссию)
	|";
	ТекстыОтражения.Добавить(ТекстЗапроса);
#КонецОбласти

#Область ТекстКомиссионерЗадолженностьПередКомитентом // (Дт 76.ОК :: Кт 60.01)
	ТекстЗапроса = "
	|ВЫБРАТЬ //// Задолженность перед комитентом (Дт 76.ОК :: Кт 60.01)
	|
	|	Операция.Ссылка КАК Ссылка,
	|	Операция.Дата КАК Период,
	|	Операция.Комиссионер КАК Организация,
	|   НЕОПРЕДЕЛЕНО КАК ИдентификаторСтроки,
	|
	|	ЕСТЬNULL(СуммыДокументовВВалютеРегл.СуммаБезНДСРегл + СуммыДокументовВВалютеРегл.СуммаНДСРегл, Строки.СуммаСНДС) КАК Сумма,
	|	ЕСТЬNULL(СуммыДокументовВВалютеРегл.СуммаБезНДСУпр + СуммыДокументовВВалютеРегл.СуммаНДСУпр, Строки.СуммаСНДС / КурсВалютыУпрУчета.Курс) КАК СуммаУУ,
	|
	|	НЕОПРЕДЕЛЕНО КАК ВидСчетаДт,
	|	НЕОПРЕДЕЛЕНО КАК ГруппаФинансовогоУчетаДт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаДт,
	|
	|	НЕОПРЕДЕЛЕНО КАК ВалютаДт,
	|	ВидыЗапасовКомитента.Договор.Подразделение КАК ПодразделениеДт,
	|	ВидыЗапасовКомитента.Договор.НаправлениеДеятельности КАК НаправлениеДеятельностиДт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ТоварыКОформлениюОтчетовКомитенту) КАК СчетДт,
	|	ВидыЗапасовКомитента.Контрагент КАК СубконтоДт1,
	|	Аналитика.Номенклатура КАК СубконтоДт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
	|
	|	0 КАК ВалютнаяСуммаДт,
	|	Строки.Количество КАК КоличествоДт,
	|	0 КАК СуммаНУДт,
	|	0 КАК СуммаПРДт,
	|	0 КАК СуммаВРДт,
	|
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.РасчетыСПоставщиками) КАК ВидСчетаКт,
	|	Операция.ГруппаФинансовогоУчетаПолучателя КАК ГруппаФинансовогоУчетаКт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаКт,
	|
	|	Операция.Валюта КАК ВалютаКт,
	|	ЕСТЬNULL(Расчеты.Подразделение, Операция.Подразделение) КАК ПодразделениеКт,
	|	Операция.НаправлениеДеятельности КАК НаправлениеДеятельностиКт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетКт,
	|	ВЫБОР КОГДА Операция.РасчетыЧерезОтдельногоКонтрагента ТОГДА
	|		Операция.Контрагент
	|	ИНАЧЕ
	|		Операция.Организация
	|	КОНЕЦ КАК СубконтоКт1,
	|	ВЫБОР КОГДА Операция.РасчетыЧерезОтдельногоКонтрагента ТОГДА
	|		Операция.ДоговорПокупки
	|	ИНАЧЕ
	|		Операция.Договор
	|	КОНЕЦ КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|
	|	Строки.СуммаСНДС КАК ВалютнаяСуммаКт,
	|	0 КАК КоличествоКт,
	|	0 КАК СуммаНУКт,
	|	0 КАК СуммаПРКт,
	|	0 КАК СуммаВРКт,
	|	""Задолженность перед комитентом"" КАК Содержание
	|
	|ИЗ
	|	ДокументыКОтражению КАК ДокументыКОтражению
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.ОтчетПоКомиссииМеждуОрганизациямиОСписании КАК Операция
	|	ПО
	|		ДокументыКОтражению.Ссылка = Операция.Ссылка
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ 
	|		Документ.ОтчетПоКомиссииМеждуОрганизациямиОСписании.ВидыЗапасов КАК Строки
	|	ПО 
	|		(Строки.Ссылка = Операция.Ссылка)
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ 
	|		Справочник.ВидыЗапасов КАК ВидыЗапасовКомитента
	|	ПО 
	|		(Строки.ВидЗапасовКомитента = ВидыЗапасовКомитента.Ссылка)
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ 
	|		РегистрСведений.СуммыДокументовВВалютеРегл КАК СуммыДокументовВВалютеРегл
	|	ПО 
	|		Строки.Ссылка = СуммыДокументовВВалютеРегл.Регистратор
	|		И Строки.ИдентификаторСтроки = СуммыДокументовВВалютеРегл.ИдентификаторСтроки
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
	|	ПО
	|		Строки.АналитикаУчетаНоменклатуры = Аналитика.КлючАналитики
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ДанныеОбъектаРасчетов КАК Расчеты
	|	ПО 
	|		Операция.Ссылка = Расчеты.Ссылка
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		КурсыВалют КАК КурсВалютыУпрУчета
	|	ПО
	|		КурсВалютыУпрУчета.Валюта = &ВалютаУпрУчета
	|		И КурсВалютыУпрУчета.Дата = НАЧАЛОПЕРИОДА(Операция.Дата, День)
	|
	|";
	ТекстыОтражения.Добавить(ТекстЗапроса);
#КонецОбласти

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
	
	ТекстыЗапроса = Новый Массив;
		
	#Область ДанныеОбъектаРасчетов
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Расчеты.Регистратор КАК Ссылка,
	|	ВЫБОР КОГДА Расчеты.Регистратор = Расчеты.ЗаказКлиента ТОГДА NULL ИНАЧЕ Расчеты.ЗаказКлиента.Подразделение КОНЕЦ КАК Подразделение,
	|	ВЫБОР КОГДА Расчеты.Регистратор = Расчеты.ЗаказКлиента ТОГДА NULL ИНАЧЕ Расчеты.ЗаказКлиента.ГруппаФинансовогоУчета КОНЕЦ КАК ГруппаФинансовогоУчета
	|ПОМЕСТИТЬ ДанныеОбъектаРасчетов
	|ИЗ
	|	ДокументыКОтражению КАК ДокументыКОтражению
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		РегистрНакопления.РасчетыСКлиентами КАК Расчеты
	|	ПО
	|		ДокументыКОтражению.Ссылка = Расчеты.Регистратор
	|ГДЕ
	|	НЕ ТИПЗНАЧЕНИЯ(Расчеты.ЗаказКлиента) В (
	|			ТИП(Документ.ПриходныйКассовыйОрдер),
	|			ТИП(Документ.ПоступлениеБезналичныхДенежныхСредств),
	|			ТИП(Документ.ОперацияПоПлатежнойКарте),
	|			ТИП(Документ.ВводОстатков))
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса);
	
	#КонецОбласти
	
	ТекстЗапроса = СтрСоединить(ТекстыЗапроса, ОбщегоНазначения.РазделительПакетаЗапросов());
	ТекстЗапроса = ТекстЗапроса + ОбщегоНазначения.РазделительПакетаЗапросов();
	Возврат ТекстЗапроса;
	
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
	ТекстЗапросаТаблицаОтражениеДокументовВРеглУчете(Запрос, ТекстыЗапроса, Регистры);
	//-- НЕ УТ
	//-- Локализация
	
КонецПроцедуры
//++ Локализация
//++ НЕ УТ

Функция ТекстЗапросаТаблицаОтражениеДокументовВРеглУчете(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ОтражениеДокументовВРеглУчете";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	Если Не ПроведениеСерверУТ.ЕстьТаблицаЗапроса("ВтПрочиеРасходы", ТекстыЗапроса) Тогда
		Документы.ОтчетПоКомиссииМеждуОрганизациямиОСписании.ТекстЗапросаТаблицаВтПрочиеРасходы(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	&Период						 КАК Период,
	|	&Комитент 					 КАК Организация,
	|	НАЧАЛОПЕРИОДА(&Период, ДЕНЬ) КАК ДатаОтражения
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	&Период						 КАК Период,
	|	&Комиссионер 	 			 КАК Организация,
	|	НАЧАЛОПЕРИОДА(&Период, ДЕНЬ) КАК ДатаОтражения";
	ТекстЗапроса = ТекстЗапроса + ОбщегоНазначенияУТ.РазделительЗапросовВОбъединении()
		+ ДоходыИРасходыСервер.ДополнитьТекстЗапросаТаблицаОтражениеДокументовВРеглУчете(Ложь);
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции
//-- НЕ УТ
//-- Локализация

#КонецОбласти

#КонецОбласти
