
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаОбъекта" Тогда
		
		Если (Параметры.Свойство("Основание")
			И ЗначениеЗаполнено(Параметры.Основание))
			ИЛИ (Параметры.Свойство("Ключ") И Не ЗначениеЗаполнено(Параметры.Ключ)) Тогда
			
			СтандартнаяОбработка = Ложь;
			ВыбраннаяФорма = "ФормаДокументаРМК";
			
		ИначеЕсли Параметры.Свойство("Ключ") И ЗначениеЗаполнено(Параметры.Ключ) Тогда
			
			СтандартнаяОбработка = Ложь;
			ВыбраннаяФорма = "ФормаДокумента";
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Определяет список команд создания на основании.
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	Возврат; //В дальнейшем будет добавлен код команд
	
КонецПроцедуры

// Добавляет команду создания документа "Возврат подарочных сертификатов".
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	Если ПравоДоступа("Добавление", Метаданные.Документы.ВозвратПодарочныхСертификатов) Тогда
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.ВозвратПодарочныхСертификатов.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(Метаданные.Документы.ВозвратПодарочныхСертификатов);
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		КомандаСоздатьНаОсновании.ФункциональныеОпции = "ИспользоватьПодарочныеСертификаты";
		
		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции

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
	
	ТекстЗапросаТаблицаПодарочныеСертификаты(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаИсторияПодарочныхСертификатов(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаДенежныеСредстваВКассахККМ(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаРасчетыПоЭквайрингу(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаДенежныеСредстваВПути(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаДвиженияДенежныеСредстваКонтрагент(Запрос, ТекстыЗапроса, Регистры);
	
	ПроведениеСерверУТ.ИнициализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Истина);
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ВозвратПодарочныхСертификатов.Дата        КАК Дата,
	|	ВозвратПодарочныхСертификатов.Валюта      КАК Валюта,
	|	ВозвратПодарочныхСертификатов.Организация КАК Организация,
	|	ВозвратПодарочныхСертификатов.Статус      КАК Статус
	|ИЗ
	|	Документ.ВозвратПодарочныхСертификатов КАК ВозвратПодарочныхСертификатов
	|ГДЕ
	|	ВозвратПодарочныхСертификатов.Ссылка = &Ссылка
	|";
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	Коэффициенты = РаботаСКурсамиВалютУТ.ПолучитьКоэффициентыПересчетаВалюты(
		Реквизиты.Валюта,
		Реквизиты.Валюта, // ВалютаВзаиморасчетов
		Реквизиты.Дата);
	
	Запрос.УстановитьПараметр("Ссылка",      ДокументСсылка);
	Запрос.УстановитьПараметр("Период",      Реквизиты.Дата);
	Запрос.УстановитьПараметр("Валюта",      Реквизиты.Валюта);
	Запрос.УстановитьПараметр("Организация", Реквизиты.Организация);
	Запрос.УстановитьПараметр("ХозяйственнаяОперация", Перечисления.ХозяйственныеОперации.РеализацияВРозницу);
	Запрос.УстановитьПараметр("СтатьяДвиженияДенежныхСредств", Справочники.СтатьиДвиженияДенежныхСредств.ВозвратОплатыКлиенту);
	Запрос.УстановитьПараметр("ЧекПробит",             Реквизиты.Статус = Перечисления.СтатусыЧековККМ.Пробит);
	Запрос.УстановитьПараметр("КоэффициентПересчетаВВалютуУпр",  Коэффициенты.КоэффициентПересчетаВВалютуУпр);
	Запрос.УстановитьПараметр("КоэффициентПересчетаВВалютуРегл", Коэффициенты.КоэффициентПересчетаВВалютуРегл);
	
КонецПроцедуры

Функция ТекстЗапросаТаблицаПодарочныеСертификаты(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПодарочныеСертификаты";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 

	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	&Период                                                 КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)                  КАК ВидДвижения,
	|	ТабличнаяЧасть.ПодарочныйСертификат                     КАК ПодарочныйСертификат,
	|	ТабличнаяЧасть.ПодарочныйСертификат.Владелец.Номинал    КАК Сумма,
	|	ТабличнаяЧасть.Сумма * &КоэффициентПересчетаВВалютуРегл КАК СуммаРегл
	|ИЗ
	|	Документ.ВозвратПодарочныхСертификатов.ПодарочныеСертификаты КАК ТабличнаяЧасть
	|ГДЕ
	|	ТабличнаяЧасть.Ссылка = &Ссылка
	|	И &ЧекПробит
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаИсторияПодарочныхСертификатов(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ИсторияПодарочныхСертификатов";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	&Период                                                        КАК Период,
	|	ТабличнаяЧасть.ПодарочныйСертификат                            КАК ПодарочныйСертификат,
	|	ЗНАЧЕНИЕ(Перечисление.СтатусыПодарочныхСертификатов.Возвращен) КАК Статус
	|ИЗ
	|	Документ.ВозвратПодарочныхСертификатов.ПодарочныеСертификаты КАК ТабличнаяЧасть
	|ГДЕ
	|	ТабличнаяЧасть.Ссылка = &Ссылка
	|	И &ЧекПробит
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаДенежныеСредстваВКассахККМ(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ДенежныеСредстваВКассахККМ";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 

	Если НЕ ПроведениеСерверУТ.ЕстьТаблицаЗапроса("ВтСуммаПлатежнымиКартами", ТекстыЗапроса) Тогда
		ТекстЗапросаВтСуммаПлатежнымиКартами(Запрос, ТекстыЗапроса);
	КонецЕсли; 
	
	УстановитьПараметрыЗапросаКоэффициентыВалют(Запрос);
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ДанныеДокумента.Дата КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	ДанныеДокумента.КассаККМ.Владелец КАК Организация,
	|	ДанныеДокумента.КассаККМ КАК КассаККМ,
	|	ДанныеДокумента.СуммаДокумента - ЕСТЬNULL(ВтСуммаПлатежнымиКартами.Сумма, 0) КАК Сумма,
	|	ВЫРАЗИТЬ((ДанныеДокумента.СуммаДокумента - ЕСТЬNULL(ВтСуммаПлатежнымиКартами.Сумма, 0)) * &КоэффициентПересчетаВВалютуРегл КАК ЧИСЛО(31,2)) КАК СуммаРегл,
	|	ВЫРАЗИТЬ((ДанныеДокумента.СуммаДокумента - ЕСТЬNULL(ВтСуммаПлатежнымиКартами.Сумма, 0)) * &КоэффициентПересчетаВВалютуУпр КАК ЧИСЛО(31,2)) КАК СуммаУпр,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВозвратОплатыКлиенту) КАК ХозяйственнаяОперация,
	|	&СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств
	|ИЗ
	|	Документ.ВозвратПодарочныхСертификатов КАК ДанныеДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВтСуммаПлатежнымиКартами КАК ВтСуммаПлатежнымиКартами
	|		ПО (ИСТИНА)
	|ГДЕ
	|	ДанныеДокумента.СуммаДокумента - ЕСТЬNULL(ВтСуммаПлатежнымиКартами.Сумма, 0) <> 0
	|	И ДанныеДокумента.Ссылка = &Ссылка
	|	И &ЧекПробит
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаРасчетыПоЭквайрингу(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "РасчетыПоЭквайрингу";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 

	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ТаблицаПлатежей.НомерСтроки КАК НомерСтроки,
	|	&Период КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыДенежныхСредствПоЭквайрингу.ПоступлениеПоПлатежнойКарте) КАК ТипДенежныхСредств,
	|	&Организация КАК Организация,
	|	&Валюта КАК Валюта,
	|	ТаблицаПлатежей.ЭквайринговыйТерминал КАК ЭквайринговыйТерминал,
	|	ТаблицаПлатежей.КодАвторизации КАК КодАвторизации,
	|	ТаблицаПлатежей.НомерПлатежнойКарты КАК НомерПлатежнойКарты,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВозвратОплатыКлиентуНаПлатежнуюКарту) КАК ХозяйственнаяОперация,
	|	&СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств,
	|	&Период КАК ДатаПлатежа,
	|	ТаблицаПлатежей.Сумма
	|ИЗ
	|	Документ.ВозвратПодарочныхСертификатов.ОплатаПлатежнымиКартами КАК ТаблицаПлатежей
	|
	|ГДЕ
	|	&ЧекПробит
	|	И ТаблицаПлатежей.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаДенежныеСредстваВПути(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ДенежныеСредстваВПути";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 

	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ТаблицаПлатежей.НомерСтроки КАК НомерСтроки,
	|	&Период КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|
	|	&Организация                                                                         КАК Организация,
	|	ТаблицаПлатежей.ЭквайринговыйТерминал.БанковскийСчет                                 КАК Получатель,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыПереводовДенежныхСредств.ПоступлениеОтБанкаПоЭквайрингу)   КАК ВидПереводаДенежныхСредств,
	|	ТаблицаПлатежей.ЭквайринговыйТерминал.Эквайер                                        КАК Контрагент,
	|	НЕОПРЕДЕЛЕНО                                                                         КАК ПлатежныйДокумент,
	|	&Валюта                                                                              КАК Валюта,
	|
	|	ТаблицаПлатежей.Сумма                                                                КАК Сумма,
	|	ВЫРАЗИТЬ(ТаблицаПлатежей.Сумма * &КоэффициентПересчетаВВалютуУпр КАК Число(15,2))    КАК СуммаУпр,
	|	ВЫРАЗИТЬ(ТаблицаПлатежей.Сумма * &КоэффициентПересчетаВВалютуРегл КАК Число(15,2))   КАК СуммаРегл,
	|
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВозвратОплатыКлиентуНаПлатежнуюКарту)    КАК ХозяйственнаяОперация,
	|	&СтатьяДвиженияДенежныхСредств                                                       КАК СтатьяДвиженияДенежныхСредств
	|
	|ИЗ
	|	Документ.ВозвратПодарочныхСертификатов.ОплатаПлатежнымиКартами КАК ТаблицаПлатежей
	|
	|ГДЕ
	|	&ЧекПробит
	|	И ТаблицаПлатежей.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаДвиженияДенежныеСредстваКонтрагент(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ДвиженияДенежныеСредстваКонтрагент";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ИнициализироватьВтДвиженияДенежныеСредстваКонтрагент(Запрос);
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	Таблица.Период,
	|	Таблица.ХозяйственнаяОперация,
	|	Таблица.Организация,
	|	Таблица.Подразделение,
	|
	|	Таблица.ДенежныеСредства,
	|	Таблица.ТипДенежныхСредств,
	|	Таблица.ВалютаПлатежа,
	|	Таблица.СтатьяДвиженияДенежныхСредств,
	|
	|	Таблица.Партнер,
	|	Таблица.Контрагент,
	|	Таблица.Договор,
	|	Таблица.ОбъектРасчетов,
	|
	|	Таблица.СуммаОплаты,
	|	Таблица.СуммаОплатыРегл,
	|	Таблица.СуммаОплатыВВалютеПлатежа,
	|
	|	Таблица.СуммаПостоплаты,
	|	Таблица.СуммаПостоплатыРегл,
	|	Таблица.СуммаПостоплатыВВалютеПлатежа,
	|	
	|	Таблица.СуммаПредоплаты,
	|	Таблица.СуммаПредоплатыРегл,
	|	Таблица.СуммаПредоплатыВВалютеПлатежа,
	|
	|	Таблица.ВалютаВзаиморасчетов,
	|
	|	Таблица.СуммаОплатыВВалютеВзаиморасчетов,
	|	Таблица.СуммаПостоплатыВВалютеВзаиморасчетов,
	|	Таблица.СуммаПредоплатыВВалютеВзаиморасчетов,
	|
	|	Таблица.ИсточникГФУДенежныхСредств,
	|	Таблица.ИсточникГФУРасчетов
	|ИЗ
	|	ВтДвиженияДенежныеСредстваКонтрагент КАК Таблица
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаВтСуммаПлатежнымиКартами(Запрос, ТекстыЗапроса)
	
	ИмяРегистра = "ВтСуммаПлатежнымиКартами";
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	СУММА(ТабличнаяЧасть.Сумма) КАК Сумма
	|ПОМЕСТИТЬ ВтСуммаПлатежнымиКартами
	|ИЗ
	|	Документ.ВозвратПодарочныхСертификатов.ОплатаПлатежнымиКартами КАК ТабличнаяЧасть
	|ГДЕ
	|	ТабличнаяЧасть.Ссылка = &Ссылка
	|	И ТабличнаяЧасть.ОплатаОтменена
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Процедура ИнициализироватьВтДвиженияДенежныеСредстваКонтрагент(Запрос)
	
	Если Запрос.Параметры.Свойство("ВтДвиженияДенежныеСредстваКонтрагентИнициализирована") Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПараметрыЗапросаКоэффициентыВалют(Запрос);
	
	ЗапросИнициализации = Новый Запрос("
	|ВЫБРАТЬ
	|	ДанныеДокумента.Дата КАК Период,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВозвратОплатыКлиенту) КАК ХозяйственнаяОперация,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.КассаККМ.Подразделение КАК Подразделение,
	|
	|	ДанныеДокумента.КассаККМ КАК ДенежныеСредства,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыДенежныхСредств.Наличные) КАК ТипДенежныхСредств,
	|	ДанныеДокумента.Валюта КАК ВалютаПлатежа,
	|	ЗНАЧЕНИЕ(Справочник.СтатьиДвиженияДенежныхСредств.ВозвратОплатыКлиенту) КАК СтатьяДвиженияДенежныхСредств,
	|
	|	НЕОПРЕДЕЛЕНО КАК Партнер,
	|	ЗНАЧЕНИЕ(Справочник.Контрагенты.РозничныйПокупатель) КАК Контрагент,
	|	НЕОПРЕДЕЛЕНО КАК Договор,
	|	ТаблицаПлатежей.ПодарочныйСертификат КАК ОбъектРасчетов,
	|
	|	0 КАК СуммаОплаты,
	|	0 КАК СуммаОплатыРегл,
	|	0 КАК СуммаОплатыВВалютеПлатежа,
	|
	|	ВЫРАЗИТЬ(ТаблицаПлатежей.Сумма * &КоэффициентПересчетаВВалютуУпр КАК Число(15,2)) КАК СуммаПостоплаты,
	|	ВЫРАЗИТЬ(ТаблицаПлатежей.Сумма * &КоэффициентПересчетаВВалютуРегл КАК Число(15,2)) КАК СуммаПостоплатыРегл,
	|	ТаблицаПлатежей.Сумма КАК СуммаПостоплатыВВалютеПлатежа,
	|	
	|	0 КАК СуммаПредоплаты,
	|	0 КАК СуммаПредоплатыРегл,
	|	ТаблицаПлатежей.Сумма КАК СуммаПредоплатыВВалютеПлатежа,
	|
	|	ДанныеДокумента.Валюта КАК ВалютаВзаиморасчетов,
	|
	|	0 КАК СуммаОплатыВВалютеВзаиморасчетов,
	|	0 КАК СуммаПостоплатыВВалютеВзаиморасчетов,
	|	0 КАК СуммаПредоплатыВВалютеВзаиморасчетов,
	|
	|	ДанныеДокумента.КассаККМ КАК ИсточникГФУДенежныхСредств,
	|	НЕОПРЕДЕЛЕНО КАК ИсточникГФУРасчетов
	|ИЗ
	|	Документ.ВозвратПодарочныхСертификатов КАК ДанныеДокумента
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	Документ.ВозвратПодарочныхСертификатов.ПодарочныеСертификаты КАК ТаблицаПлатежей
	|ПО
	|	ИСТИНА
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|	И ТаблицаПлатежей.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеДокумента.Дата КАК Период,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВозвратОплатыКлиентуНаПлатежнуюКарту) КАК ХозяйственнаяОперация,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ТаблицаПлатежей.ЭквайринговыйТерминал.БанковскийСчет.Подразделение КАК Подразделение,
	|
	|	ТаблицаПлатежей.ЭквайринговыйТерминал.Эквайер КАК ДенежныеСредства,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыДенежныхСредств.ДенежныеСредстваУЭквайера) КАК ТипДенежныхСредств,
	|	ДанныеДокумента.Валюта КАК ВалютаПлатежа,
	|	ЗНАЧЕНИЕ(Справочник.СтатьиДвиженияДенежныхСредств.ВозвратОплатыКлиенту) КАК СтатьяДвиженияДенежныхСредств,
	|
	|	НЕОПРЕДЕЛЕНО КАК Партнер,
	|	ЗНАЧЕНИЕ(Справочник.Контрагенты.РозничныйПокупатель) КАК Контрагент,
	|	НЕОПРЕДЕЛЕНО КАК Договор,
	|	НЕОПРЕДЕЛЕНО КАК ОбъектРасчетов,
	|
	|	0 КАК СуммаОплаты,
	|	0 КАК СуммаОплатыРегл,
	|	0 КАК СуммаОплатыВВалютеПлатежа,
	|
	|	ВЫРАЗИТЬ(ТаблицаПлатежей.Сумма * &КоэффициентПересчетаВВалютуУпр КАК Число(15,2)) КАК СуммаПостоплаты,
	|	ВЫРАЗИТЬ(ТаблицаПлатежей.Сумма * &КоэффициентПересчетаВВалютуРегл КАК Число(15,2)) КАК СуммаПостоплатыРегл,
	|	ТаблицаПлатежей.Сумма КАК СуммаПостоплатыВВалютеПлатежа,
	|	
	|	0 КАК СуммаПредоплаты,
	|	0 КАК СуммаПредоплатыРегл,
	|	0 КАК СуммаПредоплатыВВалютеПлатежа,
	|
	|	ДанныеДокумента.Валюта КАК ВалютаВзаиморасчетов,
	|
	|	0 КАК СуммаОплатыВВалютеВзаиморасчетов,
	|	ТаблицаПлатежей.Сумма КАК СуммаПостоплатыВВалютеВзаиморасчетов,
	|	0 КАК СуммаПредоплатыВВалютеВзаиморасчетов,
	|
	|	ТаблицаПлатежей.ЭквайринговыйТерминал.БанковскийСчет КАК ИсточникГФУДенежныхСредств,
	|	НЕОПРЕДЕЛЕНО КАК ИсточникГФУРасчетов
	|ИЗ
	|	Документ.ВозвратПодарочныхСертификатов КАК ДанныеДокумента
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	Документ.ВозвратПодарочныхСертификатов.ОплатаПлатежнымиКартами КАК ТаблицаПлатежей
	|ПО
	|	ИСТИНА
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|	И ТаблицаПлатежей.Ссылка = &Ссылка
	|");
	
	ЗапросИнициализации.Параметры.Вставить("Ссылка", Запрос.Параметры.Ссылка);
	ЗапросИнициализации.Параметры.Вставить("КоэффициентПересчетаВВалютуУпр", Запрос.Параметры.КоэффициентПересчетаВВалютуУпр);
	ЗапросИнициализации.Параметры.Вставить("КоэффициентПересчетаВВалютуРегл", Запрос.Параметры.КоэффициентПересчетаВВалютуРегл);
	
	РезультатЗапроса = ЗапросИнициализации.ВыполнитьПакет();
	ОплатаПодарочныеСертификаты = РезультатЗапроса[0].Выгрузить();
	ОплатаПлатежныеКарты        = РезультатЗапроса[1].Выгрузить();
	
	ЗапросПомещениеВоВременнуюТаблицу = Новый Запрос("
	|ВЫБРАТЬ
	|	Таблица.Период,
	|	Таблица.ХозяйственнаяОперация,
	|	Таблица.Организация,
	|	Таблица.Подразделение,
	|
	|	Таблица.ДенежныеСредства,
	|	Таблица.ТипДенежныхСредств,
	|	Таблица.ВалютаПлатежа,
	|	Таблица.СтатьяДвиженияДенежныхСредств,
	|
	|	Таблица.Партнер,
	|	Таблица.Контрагент,
	|	Таблица.Договор,
	|	Таблица.ОбъектРасчетов,
	|
	|	Таблица.СуммаОплаты,
	|	Таблица.СуммаОплатыРегл,
	|	Таблица.СуммаОплатыВВалютеПлатежа,
	|
	|	Таблица.СуммаПостоплаты,
	|	Таблица.СуммаПостоплатыРегл,
	|	Таблица.СуммаПостоплатыВВалютеПлатежа,
	|	
	|	Таблица.СуммаПредоплаты,
	|	Таблица.СуммаПредоплатыРегл,
	|	Таблица.СуммаПредоплатыВВалютеПлатежа,
	|
	|	Таблица.ВалютаВзаиморасчетов,
	|
	|	Таблица.СуммаОплатыВВалютеВзаиморасчетов,
	|	Таблица.СуммаПостоплатыВВалютеВзаиморасчетов,
	|	Таблица.СуммаПредоплатыВВалютеВзаиморасчетов,
	|
	|	Таблица.ИсточникГФУДенежныхСредств,
	|	Таблица.ИсточникГФУРасчетов
	|ПОМЕСТИТЬ ВтДвиженияДенежныеСредстваКонтрагент
	|ИЗ
	|	&Таблица КАК Таблица
	|");
	
	ДвиженияДенежныеСредстваКонтрагент = ПодарочныеСертификатыСервер.ПодготовитьТаблицуДвиженияДенежныеСредстваКонтрагент(
		ОплатаПодарочныеСертификаты,
		ОплатаПлатежныеКарты);
	ЗапросПомещениеВоВременнуюТаблицу.МенеджерВременныхТаблиц = Запрос.МенеджерВременныхТаблиц;
	ЗапросПомещениеВоВременнуюТаблицу.Параметры.Вставить("Таблица", ДвиженияДенежныеСредстваКонтрагент);
	ЗапросПомещениеВоВременнуюТаблицу.Выполнить();
	
	Запрос.УстановитьПараметр("ВтДвиженияДенежныеСредстваКонтрагентИнициализирована", Истина);
	
КонецПроцедуры

Процедура УстановитьПараметрыЗапросаКоэффициентыВалют(Запрос)
	
	Если Запрос.Параметры.Свойство("КоэффициентПересчетаВВалютуУПР")
		И Запрос.Параметры.Свойство("КоэффициентПересчетаВВалютуРегл") Тогда
		Возврат;
	КонецЕсли;
	
	Коэффициенты = РаботаСКурсамивалютУТ.ПолучитьКоэффициентыПересчетаВалюты(Запрос.Параметры.Валюта,
	                                                                         ,
	                                                                         Запрос.Параметры.Период);
	
	Запрос.УстановитьПараметр("КоэффициентПересчетаВВалютуУПР",  Коэффициенты.КоэффициентПересчетаВВалютуУПР);
	Запрос.УстановитьПараметр("КоэффициентПересчетаВВалютуРегл", Коэффициенты.КоэффициентПересчетаВВалютуРегл);
	
КонецПроцедуры

//++ НЕ УТ

// Функция возвращает текст запроса для отражения документа в регламентированном учете.
//
// Возвращаемое значение:
//	Строка - Текст запроса
//
Функция ТекстОтраженияВРеглУчете() Экспорт
	
	ТекстВозвратАвансаОтРозничногоКлиентаЭквайринг = "
	|ВЫБРАТЬ //// Возврат аванса розничному клиенту (Эквайринг) (Дт 76.09 :: Кт 57.03)
	|	Операция.Ссылка КАК Ссылка,
	|	Операция.Дата КАК Период,
	|	Операция.Организация КАК Организация,
	|	НЕОПРЕДЕЛЕНО КАК ИдентификаторСтроки,
	|
	|	Строки.СуммаРегл КАК Сумма,
	|	Строки.СуммаУУ КАК СуммаУУ,
	|	
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.РасчетыПоПодарочнымСертификатам) КАК ВидСчетаДт,
	|	Строки.ВидСертификата КАК АналитикаУчетаДт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаДт,
	|
	|	Строки.Валюта КАК ВалютаДт,
	|	НЕОПРЕДЕЛЕНО КАК ПодразделениеДт,
	|	ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка) КАК НаправлениеДеятельностиДт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетДт,
	|	ЗНАЧЕНИЕ(Справочник.Контрагенты.РозничныйПокупатель) КАК СубконтоДт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
	|
	|	Строки.СуммаВВалюте КАК ВалютнаяСуммаДт,
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
	|	ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка) КАК НаправлениеДеятельностиКт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПродажиПоПлатежнымКартам) КАК СчетКт,
	|	Строки.Эквайер КАК СубконтоКт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|
	|	0 КАК ВалютнаяСуммаКт,
	|	0 КАК КоличествоКт,
	|	0 КАК СуммаНУКт,
	|	0 КАК СуммаПРКт,
	|	0 КАК СуммаВРКт,
	|	""Возврат аванса розничному клиенту (эквайринг)"" КАК Содержание
	|
	|ИЗ 
	|	ДокументыКОтражению КАК ДокументыКОтражению
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.ВозвратПодарочныхСертификатов КАК Операция
	|	ПО
	|		ДокументыКОтражению.Ссылка = Операция.Ссылка
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ДвиженияДенежныхСредствЭквайринг КАК Строки
	|	ПО
	|		Операция.Ссылка = Строки.Ссылка";
	
	ТекстВозвратАвансаРозничномуКлиенту = "
	|ВЫБРАТЬ //// Возврат аванса розничному клиенту (Дт 76.09 :: Кт 50.02)
	|	Операция.Ссылка КАК Ссылка,
	|	Операция.Дата КАК Период,
	|	Операция.Организация КАК Организация,
	|	НЕОПРЕДЕЛЕНО КАК ИдентификаторСтроки,
	|
	|	Строки.СуммаРегл КАК Сумма,
	|	Строки.СуммаУУ КАК СуммаУУ,
	|	
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.РасчетыПоПодарочнымСертификатам) КАК ВидСчетаДт,
	|	Строки.ВидСертификата КАК АналитикаУчетаДт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаДт,
	|
	|	Строки.Валюта КАК ВалютаДт,
	|	НЕОПРЕДЕЛЕНО КАК ПодразделениеДт,
	|	ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка) КАК НаправлениеДеятельностиДт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетДт,
	|	ЗНАЧЕНИЕ(Справочник.Контрагенты.РозничныйПокупатель) КАК СубконтоДт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
	|
	|	Строки.СуммаВВалюте КАК ВалютнаяСуммаДт,
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
	|	ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка) КАК НаправлениеДеятельностиКт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ОперационнаяКасса) КАК СчетКт,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|
	|	0 КАК ВалютнаяСуммаКт,
	|	0 КАК КоличествоКт,
	|	0 КАК СуммаНУКт,
	|	0 КАК СуммаПРКт,
	|	0 КАК СуммаВРКт,
	|	""Возврат аванса розничному клиенту (наличные)"" КАК Содержание
	|
	|ИЗ 
	|	ДокументыКОтражению КАК ДокументыКОтражению
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.ВозвратПодарочныхСертификатов КАК Операция
	|	ПО
	|		ДокументыКОтражению.Ссылка = Операция.Ссылка
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ДвиженияДенежныхСредствНаличные КАК Строки
	|	ПО
	|		Операция.Ссылка = Строки.Ссылка
	|";
	
	ТекстыОтражения = Новый Массив;
	ТекстыОтражения.Добавить(ТекстВозвратАвансаОтРозничногоКлиентаЭквайринг);
	ТекстыОтражения.Добавить(ТекстВозвратАвансаРозничномуКлиенту);
	
	Возврат СтрСоединить(ТекстыОтражения, ОбщегоНазначенияУТ.РазделительЗапросовВОбъединении());
	
КонецФункции

// Функция возвращает текст запроса дополнительных временных таблиц, 
// необходимых для отражения в регламентированном учете.
//
Функция ТекстЗапросаВТОтраженияВРеглУчете() Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ДанныеРегистра.Регистратор КАК Ссылка,
	|	ДанныеРегистра.ОбъектРасчетов.Владелец КАК ВидСертификата,
	|	ДанныеРегистра.ДенежныеСредства КАК ЭквайринговыйТерминал,
	|	ВЫРАЗИТЬ(ДанныеРегистра.ДенежныеСредства КАК Справочник.ЭквайринговыеТерминалы).Эквайер КАК Эквайер,
	|	ДанныеРегистра.Подразделение КАК Подразделение,
	|	ДанныеРегистра.ВалютаПлатежа КАК Валюта,
	|	СУММА(ДанныеРегистра.СуммаПостоплаты) КАК СуммаУУ,
	|	СУММА(ДанныеРегистра.СуммаПостоплатыРегл) КАК СуммаРегл,
	|	СУММА(ДанныеРегистра.СуммаПостоплатыВВалютеПлатежа) КАК СуммаВВалюте 
	|ПОМЕСТИТЬ ДвиженияДенежныхСредствЭквайринг
	|ИЗ
	|	ДокументыКОтражению КАК ДокументыКОтражению
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		РегистрНакопления.ДвиженияДенежныеСредстваКонтрагент КАК ДанныеРегистра
	|	ПО
	|		ДокументыКОтражению.Ссылка = ДанныеРегистра.Регистратор
	|ГДЕ
	|	ДанныеРегистра.ТипДенежныхСредств = ЗНАЧЕНИЕ(Перечисление.ТипыДенежныхСредств.ДенежныеСредстваУЭквайера)
	|
	|СГРУППИРОВАТЬ ПО
	|	ДанныеРегистра.Регистратор, 
	|	ДанныеРегистра.ОбъектРасчетов.Владелец,
	|	ДанныеРегистра.ДенежныеСредства,
	|	ДанныеРегистра.Подразделение,
	|	ДанныеРегистра.ВалютаПлатежа
	|	
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;
	|
	|ВЫБРАТЬ
	|	ДанныеРегистра.Регистратор КАК Ссылка,
	|	ДанныеРегистра.ОбъектРасчетов.Владелец КАК ВидСертификата,
	|	ДанныеРегистра.ДенежныеСредства КАК КассаККМ,
	|	ВЫРАЗИТЬ(ДанныеРегистра.ДенежныеСредства КАК Справочник.КассыККМ).Подразделение КАК Подразделение,
	|	ДанныеРегистра.ВалютаПлатежа КАК Валюта,
	|	СУММА(ДанныеРегистра.СуммаПостоплаты) КАК СуммаУУ,
	|	СУММА(ДанныеРегистра.СуммаПостоплатыРегл) КАК СуммаРегл,
	|	СУММА(ДанныеРегистра.СуммаПостоплатыВВалютеПлатежа) КАК СуммаВВалюте 
	|ПОМЕСТИТЬ ДвиженияДенежныхСредствНаличные
	|ИЗ
	|	ДокументыКОтражению КАК ДокументыКОтражению
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрНакопления.ДвиженияДенежныеСредстваКонтрагент КАК ДанныеРегистра
	|	ПО
	|		ДокументыКОтражению.Ссылка = ДанныеРегистра.Регистратор
	|ГДЕ
	|	ДанныеРегистра.ТипДенежныхСредств = ЗНАЧЕНИЕ(Перечисление.ТипыДенежныхСредств.Наличные)
	|	
	|СГРУППИРОВАТЬ ПО
	|	ДанныеРегистра.Регистратор,
	|	ДанныеРегистра.ОбъектРасчетов.Владелец,
	|	ДанныеРегистра.ДенежныеСредства,
	|	ДанныеРегистра.ВалютаПлатежа
	|	
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;";
	
	Возврат ТекстЗапроса;
	
КонецФункции

//-- НЕ УТ

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

	Если ПолучитьФункциональнуюОпцию("ИспользоватьПодарочныеСертификаты") Тогда
		
		// КМ-3
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.Обработчик = "УправлениеПечатьюУТЛокализацияКлиент.ПечатьКМ3";
		КомандаПечати.МенеджерПечати = "Обработка.ПечатьКМ3";
		КомандаПечати.Идентификатор = "КМ3";
		КомандаПечати.Представление = НСтр("ru = 'КМ-3'");
		
	КонецЕсли;

КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
КонецПроцедуры

// Функция получает данные для формирования печатной формы КМ-3.
//
Функция ПолучитьДанныеДляПечатнойФормыКМ3(ПараметрыПечати, МассивОбъектов) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	ОтветственныеЛицаСервер.СформироватьВременнуюТаблицуОтветственныхЛицДокументов(МассивОбъектов, МенеджерВременныхТаблиц);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДокЧек.Ссылка КАК Ссылка,
	|	ДокЧек.Номер КАК Номер,
	|	ДокЧек.Дата КАК ДатаДокумента,
	|	ДокЧек.КассаККМ КАК КассаККМ,
	|	ДокЧек.КассаККМ.ТипКассы КАК ТипКассы,
	|	ДокЧек.КассаККМ.Представление КАК Покупатель,
	|	ДокЧек.Кассир.ФизическоеЛицо КАК КассирККМ,
	|	ДокЧек.Валюта КАК Валюта,
	|	ДокЧек.Организация КАК Организация,
	|	ТаблицаОтветственныеЛица.РуководительНаименование КАК Руководитель,
	|	ТаблицаОтветственныеЛица.РуководительДолжность КАК ДолжностьРуководителя,
	|	ТаблицаОтветственныеЛица.ГлавныйБухгалтерНаименование КАК ГлавныйБухгалтер,
	|	ДокЧек.Организация.Представление КАК Поставщик,
	|	ДокЧек.КассаККМ.СерийныйНомер КАК СерийныйНомерККМ,
	|	ДокЧек.КассаККМ.РегистрационныйНомер КАК РегистрационныйНомерККМ,
	|	ДокЧек.КассаККМ.Наименование КАК ПредставлениеККМ
	|ИЗ
	|	Документ.ВозвратПодарочныхСертификатов КАК ДокЧек
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаОтветственныеЛица КАК ТаблицаОтветственныеЛица
	|		ПО ДокЧек.Ссылка = ТаблицаОтветственныеЛица.Ссылка
	|ГДЕ
	|	ДокЧек.Ссылка В(&МассивОбъектов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДокЧек.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДокЧек.Ссылка                                           КАК Документ,
	|	ЖурналФискальныхОпераций.ФискальнаяОперацияНомерЧекаККМ КАК НомерЧека,
	|	ДокЧек.СуммаДокумента                                   КАК СуммаДокумента
	|ИЗ
	|	Документ.ВозвратПодарочныхСертификатов КАК ДокЧек
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЖурналФискальныхОпераций КАК ЖурналФискальныхОпераций
	|		ПО ЖурналФискальныхОпераций.ДокументОснование = ДокЧек.РеализацияПодарочныхСертификатов
	|ГДЕ
	|	ДокЧек.Ссылка В(&МассивОбъектов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Документ
	|ИТОГИ ПО
	|	Документ";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	СтруктураДанныхДляПечати    = Новый Структура("РезультатЗапроса, ЗаголовокДокумента",
		РезультатЗапроса, НСтр("ru = 'КМ-3'"));
	
	Если ПривилегированныйРежим() Тогда
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
	Возврат СтруктураДанныхДляПечати;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
