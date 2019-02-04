
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
	
#Область ТекстСписаниеКомиссионныхТоваров
	ТекстСписаниеКомиссионныхТоваров = "
	|ВЫБРАТЬ //// Списание комиссионных товаров (Дт  :: Кт 004.02)
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
	|	ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка) КАК ПодразделениеКт,
	|	ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка) КАК НаправлениеДеятельностиКт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ТоварыПереданныеНаКомиссию) КАК СчетКт,
	|	Операция.Контрагент КАК СубконтоКт1,
	|	Строки.Номенклатура КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|
	|	0 КАК ВалютнаяСуммаКт,
	|	Строки.Количество КАК КоличествоКт,
	|	0 КАК СуммаНУКт,
	|	0 КАК СуммаПРКт,
	|	0 КАК СуммаВРКт,
	|	""Списание комиссионных товаров"" КАК Содержание
	|
	|ИЗ
	|	ДокументыКОтражению КАК ДокументыКОтражению
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.ОтчетКомиссионераОСписании КАК Операция
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
	|
	|ГДЕ
	|	Строки.РазделУчета = ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыПринятыеНаКомиссию)
	|";
#КонецОбласти
	
#Область ТекстОтражениеВзаиморасчетовПоКомиссионномуТовару
	ТекстОтражениеВзаиморасчетовПоКомиссионномуТовару = "
	|ВЫБРАТЬ //// Взаиморасчеты по комиссионному товару (Дт 62.01 :: Кт 76.ОК)
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
	|	Операция.Контрагент КАК СубконтоДт1,
	|	Операция.Договор КАК СубконтоДт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
	|
	|	Строки.СуммаСНДС КАК ВалютнаяСуммаДт,
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
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ТоварыКОформлениюОтчетовКомитенту) КАК СчетКт,
	|	Строки.ВидЗапасов.Контрагент КАК СубконтоКт1,
	|	Аналитика.Номенклатура КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|
	|	0 КАК ВалютнаяСуммаКт,
	|	Строки.Количество КАК КоличествоКт,
	|	0 КАК СуммаНУКт,
	|	0 КАК СуммаПРКт,
	|	0 КАК СуммаВРКт,
	|	""Взаиморасчеты по комиссионному товару"" КАК Содержание
	|
	|ИЗ
	|	ДокументыКОтражению КАК ДокументыКОтражению
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.ОтчетКомиссионераОСписании КАК Операция
	|	ПО
	|		ДокументыКОтражению.Ссылка = Операция.Ссылка
	|	
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ 
	|			Документ.ОтчетКомиссионераОСписании.ВидыЗапасов КАК Строки
	|
	|			ЛЕВОЕ СОЕДИНЕНИЕ 
	|				РегистрСведений.СуммыДокументовВВалютеРегл КАК СуммыДокументовВВалютеРегл
	|			ПО 
	|				Строки.Ссылка = СуммыДокументовВВалютеРегл.Регистратор
	|				И Строки.ИдентификаторСтроки = СуммыДокументовВВалютеРегл.ИдентификаторСтроки
	|
	|		ПО 
	|			(Строки.Ссылка = Операция.Ссылка)
	|
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|			РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
	|		ПО
	|			Строки.АналитикаУчетаНоменклатуры = Аналитика.КлючАналитики
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		КурсыВалют КАК КурсВалютыУпрУчета
	|	ПО
	|		КурсВалютыУпрУчета.Валюта = &ВалютаУпрУчета
	|		И КурсВалютыУпрУчета.Дата = НАЧАЛОПЕРИОДА(Операция.Дата, День)
	|
	|ГДЕ
	|	Строки.ВидЗапасов.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.КомиссионныйТовар)
	|";
#КонецОбласти

#Область ТекстОтражениеПрочихДоходов
	ТекстОтражениеПрочихДоходов = "
	|ВЫБРАТЬ //// Отражение прочих доходов (Дт 62.01 :: Кт 91.01.1)
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
	|	ЕСТЬNULL(Расчеты.ГруппаФинансовогоУчета, Операция.ГруппаФинансовогоУчета) КАК ГруппаФинансовогоУчетаДт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаДт,
	|
	|	Операция.Валюта КАК ВалютаДт,
	|	ЕСТЬNULL(Расчеты.Подразделение, Операция.Подразделение) КАК ПодразделениеДт,
	|	ЕСТЬNULL(Расчеты.НаправлениеДеятельности, Операция.НаправлениеДеятельности) КАК НаправлениеДеятельностиДт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетДт,
	|	Операция.Контрагент КАК СубконтоДт1,
	|	Операция.Договор КАК СубконтоДт2,
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
	|		Документ.ОтчетКомиссионераОСписании КАК Операция
	|	ПО
	|		ДокументыКОтражению.Ссылка = Операция.Ссылка
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ 
	|		Документ.ОтчетКомиссионераОСписании.ВидыЗапасов КАК Строки
	|	ПО 
	|		Строки.Ссылка = Операция.Ссылка
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Расчеты КАК Расчеты
	|	ПО
	|		Операция.Ссылка = Расчеты.Ссылка
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
	|	Строки.ВидЗапасов.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Товар)
	|";
#КонецОбласти

#Область ТекстСписаниеСебестоимостиТовара
	ТекстСписаниеСебестоимостиТовара = "
	|ВЫБРАТЬ //// Списание себестоимости товара (Дт 94 :: Кт 45.01)
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
	|	Строки.СтатьяРасходов КАК ГруппаФинансовогоУчетаДт,
	|	Операция.Подразделение КАК МестоУчетаДт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаДт,
	|	Операция.Подразделение КАК ПодразделениеДт,
	|	ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка) КАК НаправлениеДеятельностиДт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетДт,
	|	Строки.СтатьяРасходов КАК СубконтоДт1,
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
	|	Операция.Контрагент	КАК СубконтоКт1,
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
	|		Документ.ОтчетКомиссионераОСписании КАК Операция
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
	|		И Строки.ТипЗапасов = Стоимости.ТипЗапасов
	|ГДЕ
	|	Строки.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Товар)
	|	И Строки.Склад = Операция.Партнер
	|";
#КонецОбласти
	
#Область ТекстВключениеИсключениеНДСВСтоимостьРасходов // (Дт 25, 26, 44 :: Кт 19.03)
	
	ТекстВключениеИсключениеНДСВСтоимостьРасходов = "
	|ВЫБРАТЬ //// Включение/исключение НДС в стоимость товара на складе - получателе (Дт 25, 26, 44 :: Кт 19.03)
	|
	|	Партии.Ссылка КАК Ссылка,
	|	Партии.Период КАК Период,
	|	Партии.Организация КАК Организация,
	|	"""" КАК ИдентификаторСтроки,
	|
	|	ВЫБОР КОГДА Партии.ВключениеНДСВСтоимость ТОГДА
	|		Партии.НДСРегл
	|	ИНАЧЕ
	|		-Партии.НДСРегл
	|	КОНЕЦ КАК Сумма,
	|
	|	(ВЫБОР
	|		КОГДА Статья.ВариантРаспределенияРасходовРегл = ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаПрочиеАктивы) 
	|			  И Статья.ВидЦенностиНДС = ЗНАЧЕНИЕ(Перечисление.ВидыЦенностей.ПрочиеРаботыИУслуги)
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.ПрочиеОперации)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.Расходы) КОНЕЦ) КАК ВидСчетаДт,
	|	Операция.СтатьяРасходов КАК АналитикаУчетаДт,
	|	Операция.Подразделение КАК МестоУчетаДт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаДт,
	|	Операция.Подразделение КАК ПодразделениеДт,
	|	Партии.НаправлениеДеятельности КАК НаправлениеДеятельностиДт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетДт,
	|
	|	Операция.АналитикаРасходов КАК СубконтоДт1,
	|	Операция.СтатьяРасходов КАК СубконтоДт2,
	|	ВЫБОР
	|		КОГДА Статья.ВариантРаспределенияРасходовРегл = ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаВнеоборотныеАктивы) ТОГДА 
	|			ВЫБОР КОГДА ОбъектыСтроительства.СпособСтроительства <> ЗНАЧЕНИЕ(Перечисление.СпособыСтроительства.ПустаяСсылка) 
	|					ТОГДА ОбъектыСтроительства.СпособСтроительства
	|				ИНАЧЕ 
	|					ЗНАЧЕНИЕ(Перечисление.СпособыСтроительства.Подрядный) 
	|			КОНЕЦ
	|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ТипыЗатратРегл.Прочее) 
	|	КОНЕЦ КАК СубконтоДт3,
	|
	|	0 КАК ВалютнаяСуммаДт,
	|	0 КАК КоличествоДт,
	|	0 КАК СуммаНУДт,
	|	0 КАК СуммаПРДт,
	|	0 КАК СуммаВРДт,
	|
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.НДСпоПриобретеннымЦенностям) КАК ВидСчетаКт,
	|	Партии.ВидДеятельностиНДС                                              КАК АналитикаУчетаКт,
	|	Партии.ВидЦенности                                                     КАК МестоУчетаКт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаКт,
	|	НЕОПРЕДЕЛЕНО КАК ПодразделениеКт,
	|	Партии.НаправлениеДеятельности КАК НаправлениеДеятельностиКт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетКт,
	|
	|	Партии.Контрагент КАК СубконтоКт1,
	|	Партии.ДокументПоступления КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|
	|	0 КАК ВалютнаяСуммаКт,
	|	0 КоличествоКт,
	|	0 КАК СуммаНУКт,
	|	0 КАК СуммаПРКт,
	|	0 КАК СуммаВРКт,
	|	""Включение/исключение НДС в стоимость товара"" КАК Содержание
	|ИЗ
	|	ДокументыКОтражению КАК ДокументыКОтражению
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.ОтчетКомиссионераОСписании КАК Операция
	|	ПО
	|		ДокументыКОтражению.Ссылка = Операция.Ссылка
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Партии КАК Партии
	|	ПО
	|		Партии.Ссылка = Операция.Ссылка
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ 
	|		ПланВидовХарактеристик.СтатьиРасходов КАК Статья
	|	ПО
	|		Статья.Ссылка = Операция.СтатьяРасходов
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ 
	|		Справочник.ОбъектыСтроительства КАК ОбъектыСтроительства
	|	ПО 
	|		ОбъектыСтроительства.Ссылка = Операция.АналитикаРасходов
	|ГДЕ
	|	(Партии.ВключениеНДСВСтоимость ИЛИ Партии.ИсключениеНДСИзСтоимости)
	|";
#КонецОбласти
	
	ТекстыОтражения = Новый Массив;
	ТекстыОтражения.Добавить(ТекстСписаниеКомиссионныхТоваров);
	ТекстыОтражения.Добавить(ТекстОтражениеВзаиморасчетовПоКомиссионномуТовару);
	ТекстыОтражения.Добавить(ТекстОтражениеПрочихДоходов);
	ТекстыОтражения.Добавить(ТекстСписаниеСебестоимостиТовара);
	
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
	
	Возврат "
	|ВЫБРАТЬ
	|	Расчеты.Регистратор КАК Ссылка,
	|	МАКСИМУМ(Расчеты.ЗаказКлиента.ГруппаФинансовогоУчета) КАК ГруппаФинансовогоУчета,
	|	МАКСИМУМ(Расчеты.ЗаказКлиента.Подразделение) КАК Подразделение,
	|	МАКСИМУМ(Расчеты.ЗаказКлиента.НаправлениеДеятельности) КАК НаправлениеДеятельности
	|ПОМЕСТИТЬ Расчеты
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
	|СГРУППИРОВАТЬ ПО
	|	Расчеты.Регистратор
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;
	|";
	
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
	
	Если Не ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	
	Если Не ПроведениеСерверУТ.ЕстьТаблицаЗапроса("ВтПрочиеРасходы", ТекстыЗапроса) Тогда
		Документы.ОтчетКомиссионераОСписании.ТекстЗапросаТаблицаВтПрочиеРасходы(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	&Период                      КАК Период,
	|	&Организация                 КАК Организация,
	|	НАЧАЛОПЕРИОДА(&Период, ДЕНЬ) КАК ДатаОтражения
	|";
	ТекстЗапроса = ТекстЗапроса + "ОБЪЕДИНИТЬ ВСЕ"
		+ ДоходыИРасходыСервер.ДополнитьТекстЗапросаТаблицаОтражениеДокументовВРеглУчете(Ложь);
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции
//-- НЕ УТ
//-- Локализация

#КонецОбласти

#КонецОбласти
