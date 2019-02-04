
#Область ПрограммныйИнтерфейс

#Область ОбработчикиСобытий

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
	
	ТекстыОтражения = Новый Массив;
	
#Область ТекстПогрешностьРасчетаСебестоимостиТовары

	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	Операция.Ссылка КАК Ссылка,
	|	Операция.Дата КАК Период,
	|	Строки.Организация КАК Организация,
	|	НЕОПРЕДЕЛЕНО КАК ИдентификаторСтроки,
	|	Строки.Сумма КАК Сумма,
	|	Строки.СуммаУпр КАК СуммаУУ,
	|	НЕОПРЕДЕЛЕНО КАК ВидСчетаДт,
	|	НЕОПРЕДЕЛЕНО КАК АналитикаУчетаДт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаДт,
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаДт,
	|	ЕСТЬNULL(Строки.Склад.Подразделение, НЕОПРЕДЕЛЕНО) КАК ПодразделениеДт,
	|	ЕСТЬNULL(Строки.НаправленияДеятельности, НЕОПРЕДЕЛЕНО) КАК НаправлениеДеятельностиДт,
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПрочиеРасходы) КАК СчетДт,
	|	Строки.СтатьяРасходов КАК СубконтоДт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
	|	0 КАК ВалютнаяСуммаДт,
	|	0 КАК КоличествоДт,
	|	Строки.СуммаНУ КАК СуммаНУДт,
	|	Строки.СуммаПР КАК СуммаПРДт,
	|	Строки.СуммаВР КАК СуммаВРДт,
	|	ВЫБОР
	|		КОГДА Строки.РазделУчета = ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыПереданныеНаКомиссию)
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.ПередачаНаКомиссию)
	|		КОГДА Строки.РазделУчета = ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.СобственныеТоварыВПути)
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.ЗатратыНаПриобретениеТМЦ)
	|		КОГДА Строки.Склад ССЫЛКА Справочник.Партнеры
	|			ТОГДА НЕОПРЕДЕЛЕНО
	|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.НаСкладе)
	|	КОНЕЦ КАК ВидСчетаКт,
	|	Строки.ГруппаФинансовогоУчета КАК АналитикаУчетаКт,
	|	ВЫБОР
	|		КОГДА Строки.РазделУчета = ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыПереданныеНаКомиссию)
	|			ТОГДА НЕОПРЕДЕЛЕНО
	|		КОГДА Строки.РазделУчета = ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.СобственныеТоварыВПути)
	|			ТОГДА НЕОПРЕДЕЛЕНО
	|		ИНАЧЕ Строки.Склад
	|	КОНЕЦ КАК МестоУчетаКт,
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаКт,
	|	ЕСТЬNULL(Строки.Склад.Подразделение, НЕОПРЕДЕЛЕНО) КАК ПодразделениеКт,
	|	ЕСТЬNULL(Строки.НаправленияДеятельности, НЕОПРЕДЕЛЕНО) КАК НаправлениеДеятельностиКт,
	|	ВЫБОР
	|		КОГДА Строки.РазделУчета = ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыПереданныеНаКомиссию)
	|			ТОГДА НЕОПРЕДЕЛЕНО
	|		КОГДА Строки.РазделУчета = ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.СобственныеТоварыВПути)
	|			ТОГДА НЕОПРЕДЕЛЕНО
	|		КОГДА Строки.Склад ССЫЛКА Справочник.Партнеры
	|			ТОГДА ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ТоварыКОформлениюОтчетовКомитенту)
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК СчетКт,
	|	ВЫБОР
	|		КОГДА Строки.РазделУчета = ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.СобственныеТоварыВПути)
	|			ТОГДА Строки.Номенклатура
	|		КОГДА Строки.Склад ССЫЛКА Справочник.Партнеры
	|			ТОГДА Строки.Контрагент
	|		ИНАЧЕ Строки.Номенклатура
	|	КОНЕЦ КАК СубконтоКт1,
	|	ВЫБОР
	|		КОГДА Строки.РазделУчета = ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.СобственныеТоварыВПути)
	|			ТОГДА Строки.Контрагент
	|		КОГДА Строки.Склад ССЫЛКА Справочник.Партнеры
	|			ТОГДА Строки.Номенклатура
	|		ИНАЧЕ Строки.Склад
	|	КОНЕЦ КАК СубконтоКт2,
	|	ВЫБОР
	|		КОГДА Строки.РазделУчета = ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.СобственныеТоварыВПути)
	|			ТОГДА Строки.Договор
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК СубконтоКт3,
	|	0 КАК ВалютнаяСуммаКт,
	|	0 КАК КоличествоКт,
	|	Строки.СуммаНУ КАК СуммаНУКт,
	|	Строки.СуммаПР КАК СуммаПРКт,
	|	Строки.СуммаВР КАК СуммаВРКт,
	|	""%1"" КАК Содержание
	|ИЗ
	|	Документ.РасчетСебестоимостиТоваров КАК Операция
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВтПогрешностьТовары КАК Строки
	|		ПО Операция.Ссылка = Строки.Ссылка
	|ГДЕ
	|	Операция.Ссылка = &Ссылка
	|	И (Строки.Сумма <> 0
	|			ИЛИ Строки.СуммаУпр <> 0
	|			ИЛИ Строки.СуммаНУ <> 0
	|			ИЛИ Строки.СуммаВР <> 0
	|			ИЛИ Строки.СуммаПР <> 0)";
	ТекстыОтражения.Добавить(ТекстЗапроса);
	
#КонецОбласти

#Область ТекстПогрешностьРасчетаСебестоимостиПереработка

	ТекстЗапроса = "
	|ВЫБРАТЬ //// Погрешность расчета себестоимости (Дт 91.02 :: Кт 10.07)
	|
	|	Операция.Ссылка КАК Ссылка,
	|	Операция.Дата КАК Период,
	|	Строки.Организация КАК Организация,
	|	НЕОПРЕДЕЛЕНО КАК ИдентификаторСтроки,
	|
	|	Строки.Сумма КАК Сумма,
	|	Строки.СуммаУпр КАК СуммаУУ,
	|
	|	НЕОПРЕДЕЛЕНО КАК ВидСчетаДт,
	|	НЕОПРЕДЕЛЕНО КАК АналитикаУчетаДт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаДт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаДт,
	|	НЕОПРЕДЕЛЕНО КАК ПодразделениеДт,
	|	ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка) КАК НаправлениеДеятельностиДт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПрочиеРасходы) КАК СчетДт,
	|
	|	Строки.СтатьяРасходов КАК СубконтоДт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
	|
	|	0 КАК ВалютнаяСуммаДт,
	|	0 КАК КоличествоДт,
	|	Строки.СуммаНУ КАК СуммаНУДт,
	|	Строки.СуммаПР КАК СуммаПРДт,
	|	Строки.СуммаВР КАК СуммаВРДт,
	|
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.ПередачаВПереработку) КАК ВидСчетаКт,
	|	Строки.Номенклатура.ГруппаФинансовогоУчета КАК АналитикаУчетаКт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаКт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаКт,
	|	НЕОПРЕДЕЛЕНО КАК ПодразделениеКт,
	|	ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка) КАК НаправлениеДеятельностиКт,
	|
	|	НЕОПРЕДЕЛЕНО КАК СчетКт,
	|
	|	Строки.Контрагент КАК СубконтоКт1,
	|	Строки.Номенклатура КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|
	|	0 КАК ВалютнаяСуммаКт,
	|	0 КАК КоличествоКт,
	|	Строки.СуммаНУ КАК СуммаНУКт,
	|	Строки.СуммаПР КАК СуммаПРКт,
	|	Строки.СуммаВР КАК СуммаВРКт,
	|	""%2"" КАК Содержание
	|ИЗ
	|	Документ.РасчетСебестоимостиТоваров КАК Операция
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВтПогрешностьПереработка КАК Строки
	|	ПО
	|		Операция.Ссылка = Строки.Ссылка
	|ГДЕ
	|	Операция.Ссылка = &Ссылка
	|	И (Строки.Сумма <> 0 ИЛИ Строки.СуммаУпр <> 0 ИЛИ Строки.СуммаНУ <> 0 ИЛИ Строки.СуммаВР <> 0 ИЛИ Строки.СуммаПР <> 0)
	|";
	ТекстыОтражения.Добавить(ТекстЗапроса);
	
#КонецОбласти
	
#Область ТекстПогрешностьРасчетаСебестоимостиНЗП

	ТекстЗапроса = "
	|ВЫБРАТЬ //// Погрешность расчета себестоимости (Дт 91.02 :: Кт 20)
	|
	|	Операция.Ссылка КАК Ссылка,
	|	Операция.Дата КАК Период,
	|	Строки.Организация КАК Организация,
	|	НЕОПРЕДЕЛЕНО КАК ИдентификаторСтроки,
	|
	|	Строки.Сумма КАК Сумма,
	|	Строки.СуммаУпр КАК СуммаУУ,
	|
	|	НЕОПРЕДЕЛЕНО КАК ВидСчетаДт,
	|	НЕОПРЕДЕЛЕНО КАК АналитикаУчетаДт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаДт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаДт,
	|	Строки.Подразделение КАК ПодразделениеДт,
	|	Строки.НаправлениеДеятельности КАК НаправлениеДеятельностиДт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПрочиеРасходы) КАК СчетДт,
	|
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиРасходов.ПогрешностьРасчетаСебестоимости) КАК СубконтоДт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
	|
	|	0 КАК ВалютнаяСуммаДт,
	|	0 КАК КоличествоДт,
	|	Строки.СуммаНУ КАК СуммаНУДт,
	|	Строки.СуммаПР КАК СуммаПРДт,
	|	Строки.СуммаВР КАК СуммаВРДт,
	|
	|	Строки.ВидСчета КАК ВидСчетаКт,
	|	Строки.СтатьяРасходов КАК АналитикаУчетаКт,
	|	Строки.МестоУчетаКт КАК МестоУчетаКт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаКт,
	|	Строки.Подразделение КАК ПодразделениеКт,
	|	Строки.НаправлениеДеятельности КАК НаправлениеДеятельностиКт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетКт,
	|
	|	Строки.СтатьяРасходов КАК СубконтоКт1,
	|	Строки.ГруппаПродукции КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|
	|	0 КАК ВалютнаяСуммаКт,
	|	0 КАК КоличествоКт,
	|	Строки.СуммаНУ КАК СуммаНУКт,
	|	Строки.СуммаПР КАК СуммаПРКт,
	|	Строки.СуммаВР КАК СуммаВРКт,
	|	""%3"" КАК Содержание
	|ИЗ
	|	Документ.РасчетСебестоимостиТоваров КАК Операция
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВтПогрешностьНЗП КАК Строки
	|	ПО
	|		Операция.Ссылка = Строки.Ссылка
	|ГДЕ
	|	Операция.Ссылка = &Ссылка
	|	И (Строки.Сумма <> 0 ИЛИ Строки.СуммаУпр <> 0 ИЛИ Строки.СуммаНУ <> 0 ИЛИ Строки.СуммаВР <> 0 ИЛИ Строки.СуммаПР <> 0)
	|";
	ТекстыОтражения.Добавить(ТекстЗапроса);
	
#КонецОбласти

#Область ТекстПогрешностьРасчетаРезервов
	
	ТекстЗапроса = "
	|ВЫБРАТЬ //// Погрешность расчета себестоимости (Дт 96 :: Кт 91.02)
	|
	|	Операция.Ссылка КАК Ссылка,
	|	Операция.Дата КАК Период,
	|	Строки.Организация КАК Организация,
	|	НЕОПРЕДЕЛЕНО КАК ИдентификаторСтроки,
	|
	|	Строки.Сумма КАК Сумма,
	|	Строки.СуммаУпр КАК СуммаУУ,
	|
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.Резервы) КАК ВидСчетаДт,
	|	Строки.ВидРезервов КАК АналитикаУчетаДт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаДт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаДт,
	|	НЕОПРЕДЕЛЕНО КАК ПодразделениеДт,
	|	Строки.НаправлениеДеятельности КАК НаправлениеДеятельностиДт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетДт,
	|	Строки.ВидРезервов КАК СубконтоДт1,
	|	Строки.ОбъектУчетаРезервов КАК СубконтоДт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
	|	
	|	0 КАК ВалютнаяСуммаДт,
	|	0 КАК КоличествоДт,
	|	0 КАК СуммаНУДт,
	|	0 КАК СуммаПРДт,
	|	0 КАК СуммаВРДт,
	|
	|	НЕОПРЕДЕЛЕНО КАК ВидСчетаКт,
	|	НЕОПРЕДЕЛЕНО КАК АналитикаУчетаКт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаКт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаКт,
	|	Строки.Подразделение КАК ПодразделениеКт,
	|	Строки.НаправлениеДеятельностиСписания КАК НаправлениеДеятельностиКт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПрочиеРасходы) КАК СчетКт,
	|
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиРасходов.ПогрешностьРасчетаСебестоимости) КАК СубконтоКт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|
	|	0 КАК ВалютнаяСуммаКт,
	|	0 КАК КоличествоКт,
	|	Строки.СуммаНУ КАК СуммаНУКт,
	|	Строки.СуммаПР КАК СуммаПРКт,
	|	Строки.СуммаВР КАК СуммаВРКт,
	|	""%4"" КАК Содержание
	|ИЗ
	|	Документ.РасчетСебестоимостиТоваров КАК Операция
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВтПогрешностьРезервы КАК Строки
	|	ПО
	|		ИСТИНА
	|ГДЕ
	|	Операция.Ссылка = &Ссылка
	|	И (Строки.Сумма <> 0 ИЛИ Строки.СуммаУпр <> 0 ИЛИ Строки.СуммаНУ <> 0 ИЛИ Строки.СуммаВР <> 0 ИЛИ Строки.СуммаПР <> 0)
	|";
	ТекстыОтражения.Добавить(ТекстЗапроса);
	
#КонецОбласти
	
	ТекстЗапроса = СтрСоединить(ТекстыОтражения, ОбщегоНазначенияУТ.РазделительЗапросовВОбъединении());
	
	ТекстЗапроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ТекстЗапроса,
		НСтр("ru='Погрешность расчета себестоимости (товары)'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
		НСтр("ru='Погрешность расчета себестоимости (переработка)'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
		НСтр("ru='Погрешность расчета себестоимости (НЗП)'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
		НСтр("ru='Погрешность расчета себестоимости (резервы)'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()));
	
	Возврат ТекстЗапроса;
	
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
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	Погрешность.Организация,
	|	Погрешность.АналитикаУчетаНоменклатуры,
	|	Погрешность.ВидЗапасов,
	|	МАКСИМУМ(Движения.Подразделение) КАК Подразделение,
	|	Аналитика.Склад КАК МестоУчета
	|ПОМЕСТИТЬ
	|	Переработка
	|ИЗ
	|	РегистрНакопления.СебестоимостьТоваров КАК Погрешность
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
	|		ПО Аналитика.КлючАналитики = Погрешность.АналитикаУчетаНоменклатуры
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.СебестоимостьТоваров КАК Движения
	|		ПО Движения.Организация = Погрешность.Организация
	|		И Движения.АналитикаУчетаНоменклатуры = Погрешность.АналитикаУчетаНоменклатуры
	|		И Движения.РазделУчета = Погрешность.РазделУчета
	|		И Движения.ВидЗапасов = Погрешность.ВидЗапасов
	|ГДЕ
	|	Погрешность.Регистратор = &Ссылка
	|	И Погрешность.Активность
	|	И Погрешность.РазделУчета В (ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ПроизводственныеЗатраты),
	|										ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.НезавершенноеПроизводство))
	|	И Погрешность.СтатьяРасходовСписания = ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиРасходов.ПогрешностьРасчетаСебестоимости)
	|	И Аналитика.Склад ССЫЛКА Справочник.Партнеры
	|	И Движения.Период МЕЖДУ НАЧАЛОПЕРИОДА(&Дата, МЕСЯЦ) И КОНЕЦПЕРИОДА(&Дата, МЕСЯЦ)
	|	И Движения.Подразделение <> ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка)
	|СГРУППИРОВАТЬ ПО
	|	Погрешность.Организация,
	|	Погрешность.АналитикаУчетаНоменклатуры,
	|	Погрешность.ВидЗапасов,
	|	Аналитика.Склад
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Погрешность.Организация,
	|	Погрешность.АналитикаУчетаНоменклатуры,
	|	Погрешность.ВидЗапасов,
	|	Аналитика.Склад КАК Подразделение,
	|	ОтчетПереработчика.Партнер КАК МестоУчета
	|ИЗ
	|	РегистрНакопления.СебестоимостьТоваров КАК Погрешность
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
	|		ПО Аналитика.КлючАналитики = Погрешность.АналитикаУчетаНоменклатуры
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПартииПроизводства КАК ПартииПроизводства
	|		ПО ПартииПроизводства.Ссылка = Погрешность.Партия
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ОтчетПереработчика КАК ОтчетПереработчика
	|		ПО ОтчетПереработчика.Ссылка = ПартииПроизводства.Документ
	|ГДЕ
	|	Погрешность.Регистратор = &Ссылка
	|	И Погрешность.Активность
	|	И Погрешность.РазделУчета В (ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ПроизводственныеЗатраты),
	|										ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.НезавершенноеПроизводство))
	|	И Погрешность.СтатьяРасходовСписания = ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиРасходов.ПогрешностьРасчетаСебестоимости)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Погрешность.Организация,
	|	Погрешность.АналитикаУчетаНоменклатуры,
	|	Погрешность.ВидЗапасов,
	|	Аналитика.Склад.Подразделение,
	|	Аналитика.Склад.Подразделение
	|ИЗ
	|	РегистрНакопления.СебестоимостьТоваров КАК Погрешность
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
	|		ПО (Аналитика.КлючАналитики = Погрешность.АналитикаУчетаНоменклатуры)
	|ГДЕ
	|	Погрешность.Регистратор = &Ссылка
	|	И Погрешность.Активность
	|	И Погрешность.РазделУчета В (ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ПроизводственныеЗатраты),
	|										ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.НезавершенноеПроизводство))
	|	И Погрешность.СтатьяРасходовСписания = ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиРасходов.ПогрешностьРасчетаСебестоимости)
	|	И ВЫРАЗИТЬ(Аналитика.Склад КАК Справочник.Склады).ЦеховаяКладовая
	|;
	|ВЫБРАТЬ
	|	Погрешность.Организация,
	|	Погрешность.АналитикаУчетаНоменклатуры,
	|	Погрешность.ВидЗапасов,
	|	Погрешность.РазделУчета,
	|	МАКСИМУМ(АналитикаКомиссионера.Контрагент) КАК Контрагент
	|ПОМЕСТИТЬ
	|	Комиссия
	|ИЗ
	|	РегистрНакопления.СебестоимостьТоваров КАК Погрешность
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
	|		ПО Аналитика.КлючАналитики = Погрешность.АналитикаУчетаНоменклатуры
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.СебестоимостьТоваров КАК Движения
	|		ПО Движения.Организация = Погрешность.Организация
	|		И Движения.АналитикаУчетаНоменклатуры = Погрешность.АналитикаУчетаНоменклатуры
	|		И Движения.РазделУчета = Погрешность.РазделУчета
	|		И Движения.ВидЗапасов = Погрешность.ВидЗапасов
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК АналитикаКомиссионера
	|		ПО АналитикаКомиссионера.КлючАналитики = Движения.АналитикаУчетаПоПартнерам
	|ГДЕ
	|	Погрешность.Регистратор = &Ссылка
	|	И Погрешность.Активность
	|	И Погрешность.РазделУчета = ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыПереданныеНаКомиссию)
	|	И Погрешность.СтатьяРасходовСписания = ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиРасходов.ПогрешностьРасчетаСебестоимости)
	|	И Аналитика.Склад ССЫЛКА Справочник.Партнеры
	|	И Движения.Период МЕЖДУ НАЧАЛОПЕРИОДА(&Дата, МЕСЯЦ) И КОНЕЦПЕРИОДА(&Дата, МЕСЯЦ)
	|	И Движения.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|СГРУППИРОВАТЬ ПО
	|	Погрешность.Организация,
	|	Погрешность.АналитикаУчетаНоменклатуры,
	|	Погрешность.ВидЗапасов,
	|	Погрешность.РазделУчета
	|;
	|ВЫБРАТЬ
	|	Погрешность.Организация,
	|	Погрешность.АналитикаУчетаНоменклатуры,
	|	Погрешность.ВидЗапасов,
	|	МАКСИМУМ(
	|		ЕСТЬNULL(Передача.Контрагент,
	|			ЕСТЬNULL(Возврат.Контрагент,
	|				ЕСТЬNULL(ОтчетПереработчика.Контрагент, НЕОПРЕДЕЛЕНО)))
	|	) КАК Контрагент
	|ПОМЕСТИТЬ
	|	ПередачиПереработчику
	|ИЗ
	|	РегистрНакопления.СебестоимостьТоваров КАК Погрешность
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
	|		ПО Аналитика.КлючАналитики = Погрешность.АналитикаУчетаНоменклатуры
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.СебестоимостьТоваров КАК Движения
	|		ПО Движения.Организация = Погрешность.Организация
	|		И Движения.АналитикаУчетаНоменклатуры = Погрешность.АналитикаУчетаНоменклатуры
	|		И Движения.РазделУчета = Погрешность.РазделУчета
	|		И Движения.ВидЗапасов = Погрешность.ВидЗапасов
	|	ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПередачаСырьяПереработчику КАК Передача
	|		ПО Передача.Ссылка = Движения.Регистратор
	|	ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВозвратСырьяОтПереработчика КАК Возврат
	|		ПО Возврат.Ссылка = Движения.Регистратор
	|	ЛЕВОЕ СОЕДИНЕНИЕ Документ.ОтчетПереработчика КАК ОтчетПереработчика
	|		ПО ОтчетПереработчика.Ссылка = Движения.Регистратор
	|ГДЕ
	|	Погрешность.Регистратор = &Ссылка
	|	И Погрешность.Активность
	|	И Погрешность.РазделУчета = ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыПереданныеПереработчику)
	|	И Погрешность.СтатьяРасходовСписания = ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиРасходов.ПогрешностьРасчетаСебестоимости)
	|	И Движения.Период МЕЖДУ НАЧАЛОПЕРИОДА(&Дата, МЕСЯЦ) И КОНЕЦПЕРИОДА(&Дата, МЕСЯЦ)
	|	И (НЕ Передача.Контрагент ЕСТЬ NULL
	|		ИЛИ НЕ Возврат.Контрагент ЕСТЬ NULL
	|		ИЛИ НЕ ОтчетПереработчика.Контрагент ЕСТЬ NULL)
	|СГРУППИРОВАТЬ ПО
	|	Погрешность.Организация,
	|	Погрешность.АналитикаУчетаНоменклатуры,
	|	Погрешность.ВидЗапасов
	|;
	|ВЫБРАТЬ
	|	Движения.Регистратор КАК Ссылка,
	|	Движения.Организация КАК Организация,
	|	Аналитика.Номенклатура КАК Номенклатура,
	|	Аналитика.Склад КАК Склад,
	|	ВЫБОР
	|		КОГДА &ФормироватьВидыЗапасовПоГруппамФинансовогоУчета
	|			ТОГДА Движения.ВидЗапасов.ГруппаФинансовогоУчета
	|		ИНАЧЕ Аналитика.Номенклатура.ГруппаФинансовогоУчета
	|	КОНЕЦ КАК ГруппаФинансовогоУчета,
	|	Назначения.НаправлениеДеятельности КАК НаправленияДеятельности,
	|	Движения.СтатьяРасходовСписания КАК СтатьяРасходов,
	|	Движения.РазделУчета КАК РазделУчета,
	|	(ВЫБОР
	|		КОГДА Движения.РазделУчета = ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.СобственныеТоварыВПути)
	|			ТОГДА Приобретение.Контрагент
	|		ИНАЧЕ ЕСТЬNULL(Комиссия.Контрагент, Движения.ВидЗапасов.Контрагент) КОНЕЦ) КАК Контрагент,
	|	(ВЫБОР
	|		КОГДА Движения.РазделУчета = ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.СобственныеТоварыВПути)
	|			ТОГДА Приобретение.Договор
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО КОНЕЦ) КАК Договор,
	|	СУММА(Движения.СтоимостьРегл
	|		+ Движения.ДопРасходыРегл
	|		+ Движения.ТрудозатратыРегл
	|		+ Движения.ПостатейныеПеременныеРегл
	|		+ Движения.ПостатейныеПостоянныеРегл) КАК Сумма,
	|	СУММА(Движения.СтоимостьУпр
	|		+ Движения.ДопРасходыУпр
	|		+ Движения.ТрудозатратыУпр
	|		+ Движения.ПостатейныеПеременныеУпр
	|		+ Движения.ПостатейныеПостоянныеУпр) КАК СуммаУпр,
	|	СУММА(Движения.СтоимостьРегл
	|		+ Движения.ДопРасходыРегл
	|		+ Движения.ТрудозатратыРегл
	|		+ Движения.ПостатейныеПеременныеРегл
	|		+ Движения.ПостатейныеПостоянныеРегл
	|		- Движения.ПостояннаяРазница
	|		- Движения.ВременнаяРазница) КАК СуммаНУ,
	|	СУММА(Движения.ПостояннаяРазница) КАК СуммаПР,
	|	СУММА(Движения.ВременнаяРазница) КАК СуммаВР
	|ПОМЕСТИТЬ ВтПогрешностьТовары
	|ИЗ
	|	РегистрНакопления.СебестоимостьТоваров КАК Движения
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
	|		ПО Движения.АналитикаУчетаНоменклатуры = Аналитика.КлючАналитики
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыЗапасов КАК ВидыЗапасов
	|		ПО Движения.ВидЗапасов = ВидыЗапасов.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Назначения КАК Назначения
	|		ПО (Аналитика.Назначение = Назначения.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Комиссия КАК Комиссия
	|		ПО (Комиссия.Организация = Движения.Организация)
	|			И (Комиссия.АналитикаУчетаНоменклатуры = Движения.АналитикаУчетаНоменклатуры)
	|			И (Комиссия.ВидЗапасов = Движения.ВидЗапасов)
	|			И (Комиссия.РазделУчета = Движения.РазделУчета)
	|	ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПриобретениеТоваровУслуг КАК Приобретение
	|		ПО Приобретение.Ссылка = Движения.Партия
	|ГДЕ
	|	Движения.Регистратор = &Ссылка
	|	И Движения.Активность
	|	И Движения.РазделУчета В (
	|		ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыНаСкладах),
	|		ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.СобственныеТоварыВПути),
	|		ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыПереданныеНаКомиссию))
	|	И Движения.СтатьяРасходовСписания = ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиРасходов.ПогрешностьРасчетаСебестоимости)
	|	И Движения.ДокументДвижения В (НЕОПРЕДЕЛЕНО, &Ссылка)
	|
	|СГРУППИРОВАТЬ ПО
	|	Движения.Регистратор,
	|	Движения.Организация,
	|	Движения.РазделУчета,
	|	Аналитика.Номенклатура,
	|	Аналитика.Склад,
	|	(ВЫБОР
	|		КОГДА Движения.РазделУчета = ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.СобственныеТоварыВПути)
	|			ТОГДА Приобретение.Контрагент
	|		ИНАЧЕ ЕСТЬNULL(Комиссия.Контрагент, Движения.ВидЗапасов.Контрагент) КОНЕЦ),
	|	(ВЫБОР
	|		КОГДА Движения.РазделУчета = ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.СобственныеТоварыВПути)
	|			ТОГДА Приобретение.Договор
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО КОНЕЦ),
	|	ВЫБОР
	|		КОГДА &ФормироватьВидыЗапасовПоГруппамФинансовогоУчета
	|			ТОГДА Движения.ВидЗапасов.ГруппаФинансовогоУчета
	|		ИНАЧЕ Аналитика.Номенклатура.ГруппаФинансовогоУчета
	|	КОНЕЦ,
	|	Назначения.НаправлениеДеятельности,
	|	Движения.СтатьяРасходовСписания
	|;
	|
	|ВЫБРАТЬ
	|	Движения.Регистратор КАК Ссылка,
	|	Движения.Организация КАК Организация,
	|	Аналитика.Номенклатура КАК Номенклатура,
	|	Движения.СтатьяРасходовСписания КАК СтатьяРасходов,
	|	ЕСТЬNULL(ПередачиПереработчику.Контрагент, НЕОПРЕДЕЛЕНО) КАК Контрагент,
	|	СУММА(Движения.СтоимостьРегл
	|		+ Движения.ДопРасходыРегл
	|		+ Движения.ТрудозатратыРегл
	|		+ Движения.ПостатейныеПеременныеРегл
	|		+ Движения.ПостатейныеПостоянныеРегл) КАК Сумма,
	|	СУММА(Движения.СтоимостьУпр
	|		+ Движения.ДопРасходыУпр
	|		+ Движения.ТрудозатратыУпр
	|		+ Движения.ПостатейныеПеременныеУпр
	|		+ Движения.ПостатейныеПостоянныеУпр) КАК СуммаУпр,
	|	СУММА(Движения.СтоимостьРегл
	|		+ Движения.ДопРасходыРегл
	|		+ Движения.ТрудозатратыРегл
	|		+ Движения.ПостатейныеПеременныеРегл
	|		+ Движения.ПостатейныеПостоянныеРегл
	|		- Движения.ПостояннаяРазница
	|		- Движения.ВременнаяРазница) КАК СуммаНУ,
	|	СУММА(Движения.ПостояннаяРазница) КАК СуммаПР,
	|	СУММА(Движения.ВременнаяРазница) КАК СуммаВР
	|ПОМЕСТИТЬ ВтПогрешностьПереработка
	|ИЗ
	|	РегистрНакопления.СебестоимостьТоваров КАК Движения
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
	|	ПО
	|		Движения.АналитикаУчетаНоменклатуры = Аналитика.КлючАналитики
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ ПередачиПереработчику КАК ПередачиПереработчику
	|		ПО ПередачиПереработчику.Организация = Движения.Организация
	|		И ПередачиПереработчику.АналитикаУчетаНоменклатуры = Движения.АналитикаУчетаНоменклатуры
	|		И ПередачиПереработчику.ВидЗапасов = Движения.ВидЗапасов
	|ГДЕ
	|	Движения.Регистратор = &Ссылка
	|	И Движения.Активность
	|	И Движения.РазделУчета = ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыПереданныеПереработчику)
	|	И Движения.СтатьяРасходовСписания = ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиРасходов.ПогрешностьРасчетаСебестоимости)
	|	И Движения.ДокументДвижения В (НЕОПРЕДЕЛЕНО, &Ссылка)
	|
	|СГРУППИРОВАТЬ ПО
	|	Движения.Регистратор,
	|	Движения.Организация,
	|	Аналитика.Номенклатура,
	|	Движения.СтатьяРасходовСписания,
	|	ЕСТЬNULL(ПередачиПереработчику.Контрагент, НЕОПРЕДЕЛЕНО)
	|;
	|
	|ВЫБРАТЬ
	|	Движения.Регистратор КАК Ссылка,
	|	Движения.Организация КАК Организация,
	|	ВЫБОР КОГДА НЕ Переработка.МестоУчета ЕСТЬ NULL ТОГДА 
	|		Переработка.МестоУчета
	|	КОГДА Аналитика.Склад ССЫЛКА Справочник.Склады ТОГДА 
	|		Аналитика.Склад.Подразделение
	|	ИНАЧЕ 
	|		Аналитика.Склад 
	|	КОНЕЦ КАК МестоУчетаКт,
	|	ВЫБОР КОГДА НЕ Переработка.Подразделение ЕСТЬ NULL ТОГДА 
	|		Переработка.Подразделение
	|	КОГДА Аналитика.Склад ССЫЛКА Справочник.Склады ТОГДА 
	|		Аналитика.Склад.Подразделение
	|	ИНАЧЕ 
	|		Аналитика.Склад 
	|	КОНЕЦ КАК Подразделение,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.Производство) КАК ВидСчета,
	|	НЕОПРЕДЕЛЕНО КАК СтатьяРасходов,
	|	ВЫБОР КОГДА &ПартионныйУчетВерсии22 ТОГДА
	|		Движения.АналитикаФинансовогоУчета
	|		КОГДА Аналитика.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Работа) ТОГДА
	|		Аналитика.Номенклатура.ГруппаАналитическогоУчета
	|	ИНАЧЕ
	|		ЕСТЬNULL(Движения.ВидЗапасов.ГруппаПродукции, НЕОПРЕДЕЛЕНО)
	|	КОНЕЦ КАК ГруппаПродукции,
	|	Назначения.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	СУММА(Движения.СтоимостьРегл
	|		+ Движения.ДопРасходыРегл
	|		+ Движения.ТрудозатратыРегл
	|		+ Движения.ПостатейныеПеременныеРегл
	|		+ Движения.ПостатейныеПостоянныеРегл) КАК Сумма,
	|	СУММА(Движения.СтоимостьУпр
	|		+ Движения.ДопРасходыУпр
	|		+ Движения.ТрудозатратыУпр
	|		+ Движения.ПостатейныеПеременныеУпр
	|		+ Движения.ПостатейныеПостоянныеУпр) КАК СуммаУпр,
	|	СУММА(Движения.СтоимостьРегл
	|		+ Движения.ДопРасходыРегл
	|		+ Движения.ТрудозатратыРегл
	|		+ Движения.ПостатейныеПеременныеРегл
	|		+ Движения.ПостатейныеПостоянныеРегл
	|		- Движения.ПостояннаяРазница
	|		- Движения.ВременнаяРазница) КАК СуммаНУ,
	|	СУММА(Движения.ПостояннаяРазница) КАК СуммаПР,
	|	СУММА(Движения.ВременнаяРазница) КАК СуммаВР
	|ПОМЕСТИТЬ ВтПогрешностьНЗП
	|ИЗ
	|	РегистрНакопления.СебестоимостьТоваров КАК Движения
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
	|		ПО Движения.АналитикаУчетаНоменклатуры = Аналитика.КлючАналитики
	|	ЛЕВОЕ СОЕДИНЕНИЕ Переработка КАК Переработка
	|		ПО Переработка.Организация = Движения.Организация
	|		И Переработка.АналитикаУчетаНоменклатуры = Движения.АналитикаУчетаНоменклатуры
	|		И Переработка.ВидЗапасов = Движения.ВидЗапасов
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Назначения КАК Назначения
	|	ПО Аналитика.Назначение = Назначения.Ссылка
	|ГДЕ
	|	Движения.Регистратор = &Ссылка
	|	И Движения.Активность
	|	И Движения.РазделУчета В (ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ПроизводственныеЗатраты),
	|							ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.НезавершенноеПроизводство))
	|	И Движения.СтатьяРасходовСписания = ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиРасходов.ПогрешностьРасчетаСебестоимости)
	|	И Движения.ДокументДвижения В (НЕОПРЕДЕЛЕНО, &Ссылка)
	|
	|СГРУППИРОВАТЬ ПО
	|	Движения.Регистратор,
	|	Движения.Организация,
	|	ВЫБОР КОГДА НЕ Переработка.МестоУчета ЕСТЬ NULL ТОГДА 
	|		Переработка.МестоУчета
	|	КОГДА Аналитика.Склад ССЫЛКА Справочник.Склады ТОГДА 
	|		Аналитика.Склад.Подразделение
	|	ИНАЧЕ 
	|		Аналитика.Склад 
	|	КОНЕЦ,
	|	Назначения.НаправлениеДеятельности,
	|	ВЫБОР КОГДА НЕ Переработка.Подразделение ЕСТЬ NULL ТОГДА 
	|		Переработка.Подразделение
	|	КОГДА Аналитика.Склад ССЫЛКА Справочник.Склады ТОГДА 
	|		Аналитика.Склад.Подразделение
	|	ИНАЧЕ 
	|		Аналитика.Склад 
	|	КОНЕЦ,
	|	ВЫБОР КОГДА &ПартионныйУчетВерсии22 ТОГДА
	|		Движения.АналитикаФинансовогоУчета
	|	КОГДА Аналитика.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Работа) ТОГДА
	|		Аналитика.Номенклатура.ГруппаАналитическогоУчета
	|	ИНАЧЕ
	|		ЕСТЬNULL(Движения.ВидЗапасов.ГруппаПродукции, НЕОПРЕДЕЛЕНО)
	|	КОНЕЦ
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Движения.Регистратор КАК Ссылка,
	|	Движения.Организация КАК Организация,
	|	Движения.Подразделение КАК МестоУчетаКт,
	|	Движения.Подразделение КАК Подразделение,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.Расходы),
	|	Движения.СтатьяРасходов КАК СтатьяРасходов,
	|	НЕОПРЕДЕЛЕНО КАК ГруппаПродукции,
	|	Движения.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	СУММА(Движения.СуммаРегл) КАК Сумма,
	|	СУММА(Движения.СуммаУпр) КАК СуммаУпр,
	|	СУММА(Движения.СуммаРегл - Движения.ПостояннаяРазница - Движения.ВременнаяРазница) КАК СуммаНУ,
	|	СУММА(Движения.ПостояннаяРазница) КАК СуммаПР,
	|	СУММА(Движения.ВременнаяРазница) КАК СуммаВР
	|ИЗ
	|	РегистрНакопления.ПрочиеРасходы КАК Движения
	|ГДЕ
	|	Движения.Регистратор = &Ссылка
	|	И Движения.Активность
	|	И (Движения.СтатьяРасходов.ВариантРаспределенияРасходовУпр =
	|			ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаПроизводственныеЗатраты)
	|		ИЛИ Движения.СтатьяРасходов.ВариантРаспределенияРасходовРегл =
	|			ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаПроизводственныеЗатраты))
	|	И Движения.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПустаяСсылка)
	|	И Движения.СтатьяРасходов <> ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиРасходов.ПогрешностьРасчетаСебестоимости)
	|
	|СГРУППИРОВАТЬ ПО
	|	Движения.Регистратор,
	|	Движения.Организация,
	|	Движения.Подразделение,
	|	Движения.СтатьяРасходов,
	|	Движения.НаправлениеДеятельности
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Движения.Регистратор КАК Ссылка,
	|	Движения.Организация КАК Организация,
	|	Движения.Подразделение КАК МестоУчетаКт,
	|	Движения.Подразделение КАК Подразделение,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.Производство),
	|	НЕОПРЕДЕЛЕНО КАК СтатьяРасходов,
	|	Движения.ГруппаПродукции КАК ГруппаПродукции,
	|	Движения.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	СУММА(Движения.СтоимостьРегл) КАК Сумма,
	|	СУММА(Движения.СтоимостьУпр) КАК СуммаУпр,
	|	СУММА(Движения.СтоимостьРегл - Движения.ПостояннаяРазница - Движения.ВременнаяРазница) КАК СуммаНУ,
	|	СУММА(Движения.ПостояннаяРазница) КАК СуммаПР,
	|	СУММА(Движения.ВременнаяРазница) КАК СуммаВР
	|ИЗ
	|	РегистрНакопления.ПрочиеРасходыНезавершенногоПроизводства КАК Движения
	|ГДЕ
	|	Движения.Регистратор = &Ссылка
	|	И Движения.Активность
	|
	|СГРУППИРОВАТЬ ПО
	|	Движения.Регистратор,
	|	Движения.Организация,
	|	Движения.Подразделение,
	|	Движения.ГруппаПродукции,
	|	Движения.НаправлениеДеятельности,
	|	Движения.СтатьяРасходов
	|;
	|
	|ВЫБРАТЬ
	|	Движения.Организация КАК Организация,
	|	Движения.ВидРезервов КАК ВидРезервов,
	|	Движения.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	Движения.ОбъектУчетаРезервов.НаправлениеДеятельностиСписания КАК НаправлениеДеятельностиСписания,
	|	Движения.ОбъектУчетаРезервов КАК ОбъектУчетаРезервов,
	|	Движения.ОбъектУчетаРезервов.ПодразделениеСписания КАК Подразделение,
	|	СУММА(Движения.СуммаРегл) КАК Сумма,
	|	СУММА(Движения.СуммаУпр) КАК СуммаУпр,
	|	СУММА(Движения.СуммаРегл) КАК СуммаНУ,
	|	0 КАК СуммаПР,
	|	0 КАК СуммаВР
	|ПОМЕСТИТЬ ВтПогрешностьРезервы
	|ИЗ
	|	РегистрНакопления.РезервыПредстоящихРасходов КАК Движения
	|ГДЕ
	|	Движения.Регистратор = &Ссылка
	|	И Движения.Активность
	|
	|СГРУППИРОВАТЬ ПО
	|	Движения.Организация,
	|	Движения.ВидРезервов,
	|	Движения.ОбъектУчетаРезервов,
	|	Движения.НаправлениеДеятельности,
	|	Движения.ОбъектУчетаРезервов.НаправлениеДеятельностиСписания,
	|	Движения.ОбъектУчетаРезервов.ПодразделениеСписания
	|;
	|";
	
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
	
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
