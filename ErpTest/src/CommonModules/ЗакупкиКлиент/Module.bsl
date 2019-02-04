////////////////////////////////////////////////////////////////////////////////
// Модуль "ЗакупкиКлиент", содержит процедуры и функции для 
// обработки действий пользователя в процессе работы с документами закупки.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ПроцедурыИФункцииРаботыСВыборомЗначений

// Процедура - обработчик события "НачалоВыбора" элемента формы "Соглашение"
//
// Параметры:
//	Партнер                  - СправочникСсылка.Партнеры - ссылка на партнера, для которого выберите соглашение
//	Документ                 - ДокументСсылка - ссылка на ранее выбранное соглашение для  начального позиционирования в списке
//	ДатаДокумента            - Дата - дата документа, в котором выбирается соглашение
//	ДоступноДляЗакупки       - Булево - Если Истина, отбираются только соглашения с установленным флагом ДоступноДляЗакупки
//	БезКомиссионныхСоглашений - Булево - Если Истина, отбираются только соглашения с хоз. операций "Закупка у поставщика".
//
Процедура НачалоВыбораСоглашенияСПоставщиком(Элемент,
	                                         СтандартнаяОбработка,
	                                         Партнер,
	                                         Документ,
	                                         ДатаДокумента='00010101',
	                                         СтруктураДополнительногоОтбора = Неопределено) Экспорт

	СтандартнаяОбработка = Ложь;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Документ", Документ);
	ДополнительныеПараметры.Вставить("Элемент", Элемент);
	ДополнительныеПараметры.Вставить("ДатаДокумента", ДатаДокумента);
	
	Если Не ЗначениеЗаполнено(СтруктураДополнительногоОтбора) Тогда
		СтруктураДополнительногоОтбора = Новый Структура;
	КонецЕсли;
	Для Каждого ПараметрВыбора Из Элемент.ПараметрыВыбора Цикл
		СтруктураДополнительногоОтбора.Вставить(СтрЗаменить(ПараметрВыбора.Имя,"Отбор.",""), ПараметрВыбора.Значение);
	КонецЦикла;
	ДополнительныеПараметры.Вставить("СтруктураДополнительногоОтбора", СтруктураДополнительногоОтбора);
	
	Если Не ЗначениеЗаполнено(Партнер) Тогда
		
		СтруктураОтбора = Новый Структура;
		СтруктураОтбора.Вставить("Отбор", Новый Структура("Поставщик", Истина));
		
		ОткрытьФорму(
			"Справочник.Партнеры.ФормаВыбора",
			СтруктураОтбора ,,,,,
			Новый ОписаниеОповещения("НачалоВыбораСоглашенияСПоставщикомВыборПартнераЗавершение", ЗакупкиКлиент, ДополнительныеПараметры));
		
	Иначе
		НачалоВыбораСоглашенияСПоставщикомВыборПартнераЗавершение(Партнер, ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

// Проверяет заполненность реквизитов, необходимых для заполнения цен в документе по соглашению с поставщиком.
//
// Параметры:
//  Партнер                 - СправочникСсылка.Партнеры -  партнер, для которого отбираются соглашения.
//  ДополнительныеПараметры - Структура - дополнительные параметры для отбора соглашений.
//
Процедура НачалоВыбораСоглашенияСПоставщикомВыборПартнераЗавершение(Партнер, ДополнительныеПараметры) Экспорт
	
	Если Не ЗначениеЗаполнено(Партнер) Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДополнительныеПараметры.СтруктураДополнительногоОтбора) Тогда
		СтруктураОтбора = ДополнительныеПараметры.СтруктураДополнительногоОтбора;
		СтруктураОтбора.Вставить("Партнер", Партнер);
	Иначе
		СтруктураОтбора = Новый Структура("Партнер", Партнер);
	КонецЕсли;
	
	ОткрытьФорму (
		"Справочник.СоглашенияСПоставщиками.ФормаВыбора",
		Новый Структура("ДатаДокумента,ТекущаяСтрока,Отбор",
			ДополнительныеПараметры.ДатаДокумента,
			ДополнительныеПараметры.Документ,
			СтруктураОтбора),
		ДополнительныеПараметры.Элемент);
	
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыИФункцииПроверкиВозможностиВыполненияДействий

// Проверяет заполненность реквизитов, необходимых для заполнения цен в документе по соглашению с поставщиком.
//
// Параметры:
//  Документ                    - ДокументОбъект, для которого выполняются проверки
//  ИмяТабличнойЧасти           - Строка - имя табличной части, в которой необходимо осуществить проверку
//  ПредставлениеТабличнойЧасти - Строка - представление табличной части для информирования пользователя.
//
// Возвращаемое значение:
//  Булево - Ложь, если необходимые данные не заполнены.
//
Функция НеобходимоЗаполнениеЦенПоСоглашению(Документ, ИмяТабличнойЧасти, ПредставлениеТабличнойЧасти) Экспорт

	Если Не ЗначениеЗаполнено(Документ.Соглашение) Тогда
		
		ПоказатьПредупреждение(,НСтр("ru='В документе не указано соглашение с поставщиком, или соглашения с поставщиком отсутствуют. Цены не могут быть заполнены'"));
		Возврат Ложь;
		
	ИначеЕсли Не ЗначениеЗаполнено(Документ.Валюта) Тогда
		
		ПоказатьПредупреждение(,НСтр("ru='В документе не указана валюта. Цены не могут быть заполнены'"));
		Возврат Ложь;
		
	ИначеЕсли Документ[ИмяТабличнойЧасти].Количество() = 0 Тогда
		
		ТекстПредупреждения = НСтр("ru='В документе не заполнена таблица %ПредставлениеТабличнойЧасти%. Цены не могут быть заполнены'");
		ТекстПредупреждения = СтрЗаменить(ТекстПредупреждения, "%ПредставлениеТабличнойЧасти%", ПредставлениеТабличнойЧасти);
		ПоказатьПредупреждение(,ТекстПредупреждения);
		Возврат Ложь;
		
	Иначе
		
		Возврат Истина;
		
	КонецЕсли;

КонецФункции

// Проверяет заполненность реквизитов, необходимых для заполнения цен в документе по условию цен поставщика.
//
// Параметры:
//  Документ                    - ДокументОбъект, для которого выполняются проверки
//  ИмяТабличнойЧасти           - Строка - имя табличной части, в которой необходимо осуществить проверку
//  ПредставлениеТабличнойЧасти - Строка - представление табличной части для информирования пользователя.
//
// Возвращаемое значение:
//  Булево - Ложь, если необходимые данные не заполнены.
//
Функция НеобходимоЗаполнениеЦенПоВидуЦенПоставщика(Документ, ИмяТабличнойЧасти, ПредставлениеТабличнойЧасти) Экспорт

	Если Не ЗначениеЗаполнено(Документ.Валюта) Тогда
		
		ПоказатьПредупреждение(,НСтр("ru='В документе не указана валюта. Цены не могут быть заполнены'"));
		Возврат Ложь;
		
	ИначеЕсли Документ[ИмяТабличнойЧасти].Количество() = 0 Тогда
		
		ТекстПредупреждения = НСтр("ru='В документе не заполнена таблица %ПредставлениеТабличнойЧасти%. Цены не могут быть заполнены'");
		ТекстПредупреждения = СтрЗаменить(ТекстПредупреждения, "%ПредставлениеТабличнойЧасти%", ПредставлениеТабличнойЧасти);
		ПоказатьПредупреждение(,ТекстПредупреждения);
		Возврат Ложь;
		
	Иначе
		
		Возврат Истина;
		
	КонецЕсли;

КонецФункции

// Вызывает проверку на наличие в информационной базе ранее сопоставленной номенклатуры поставщика
// Если ранее сопоставленная номенклатура найдена - предупреждает об этом пользователя.
//
// Параметры:
//   Объект - ДанныеФормыКоллекция - документ, для которого необходимо осуществлять проверку.
//   ОписаниеОповещения - ОписаниеОповещения - определяет процедуру, которая будет вызвана после завершения проверки.
//   НеВыполнятьПроверкуДляПользователя - Булево - флаг, определяющий нужно ли осуществлять проверку.
//
Процедура ПроверитьСопоставленнуюНоменклатуруПоставщика(Объект, ОписаниеОповещения, НеВыполнятьПроверкуДляПользователя) Экспорт
	
	Если Объект.Товары.Количество() > 0 И Не НеВыполнятьПроверкуДляПользователя Тогда
		
		ВыводитьПредупреждение = ЗакупкиВызовСервера.ПроверитьСопоставленнуюНоменклатуруПоставщика(Объект);
		
		Если ВыводитьПредупреждение Тогда
			
			ТекстВопроса = НСтр("ru='Для некоторой номенклатуры найдена ранее сопоставленная номенклатура поставщика.'");
			ТекстВопроса = ТекстВопроса + Символы.ПС + НСтр("ru='Несопоставленная номенклатура поставщика будет сопоставлена с номенклатурой. Продолжить?'");
			
			ПоказатьВопрос(
				ОписаниеОповещения,
				ТекстВопроса,
				РежимДиалогаВопрос.ДаНет);
			
		Иначе
			
			ВыполнитьОбработкуОповещения(ОписаниеОповещения, Неопределено);
			
		КонецЕсли;
		
	Иначе
		
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, Неопределено);
		
	КонецЕсли;
	
КонецПроцедуры

// При попытке выбора номенклатуры поставщика в строке таблицы пользователь получает сообщение о незаполненности партнера.
//
// Параметры:
//	Объект              - ДанныеФормыСтруктура - документ, для выдачи сообщения об ошибках
//	Поле                - ПолеФормы - поле, в котором пользователь осуществляет выбор
//	ИмяПроверяемогоПоля - Строка - имя поля, для которого необходимо выдать ошибку.
//
Процедура ПриВыбореНоменклатурыПоставщика(Объект, Поле, ИмяПроверяемогоПоля, ПредставлениеПартнера) Экспорт
	
	Если Поле.Имя = ИмяПроверяемогоПоля Тогда
		
		Если Не ЗначениеЗаполнено(Объект.Партнер) Тогда
			
			ОчиститьСообщения();
			ТекстСообщения = НСтр("ru = 'Поле ""%ПредставлениеПартнера%"" не заполнено'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ПредставлениеПартнера%", ПредставлениеПартнера);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Объект.Ссылка, "Объект.Партнер");
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Проверяет является ли оповещение в форме событием изменения документов оплаты
//
// Параметры:
//  ИмяСобытия - Строка - имя события из процедуры формы "ОбработкаОповещения".
//
// Возвращаемое значение:
//  Булево - Истина, если оповещение является оплатой.
//
Функция ИзменилисьДокументыОплатыПоставщиком(ИмяСобытия) Экспорт
	
	Возврат
		ИмяСобытия = "Запись_АвансовыйОтчет"
		Или ИмяСобытия = "Запись_СписаниеБезналичныхДенежныхСредств"
		Или ИмяСобытия = "Запись_ПоступлениеБезналичныхДенежныхСредств"
		Или ИмяСобытия = "Запись_РасходныйКассовыйОрдер"
		Или ИмяСобытия = "Запись_ВзаимозачетЗадолженности"
		Или ИмяСобытия = "Запись_СписаниеЗадолженности";
	
КонецФункции

#КонецОбласти

#Область ПроцедурыОповещенияПользователяОВыполненныхДействиях

// Показывает оповещение пользователя об окончании заполнения условий закупок по умолчанию.
//
Процедура ОповеститьОбОкончанииЗаполненияУсловийЗакупокПоУмолчанию() Экспорт

	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Условия закупок заполнены'"),
		,
		НСтр("ru='Условия закупок по умолчанию заполнены'"),
		БиблиотекаКартинок.Информация32);

КонецПроцедуры

// Показывает оповещение пользователя об окончании заполнения условий закупок
//
Процедура ОповеститьОбОкончанииЗаполненияУсловийЗакупок() Экспорт

	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Условия закупок заполнены'"),
		,НСтр("ru='Условия закупок по соглашению с поставщиком заполнены'"),
		БиблиотекаКартинок.Информация32);

КонецПроцедуры

// Показывает оповещение пользователя об окончании заполнения цен по соглашению с клиентом.
//
// Параметры:
//	ЦеныРассчитаны - Булево - Признак успешного расчета цен хотя бы в одной строке.
//
Процедура ОповеститьОбОкончанииЗаполненияЦенПоСоглашению(ЦеныРассчитаны = Истина) Экспорт

	Если ЦеныРассчитаны Тогда
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Цены заполнены'"),
			,
			НСтр("ru='Цены по соглашению с поставщиком заполнены'"),
			БиблиотекаКартинок.Информация32);
	Иначе
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Цены не заполнены'"),
			,
			НСтр("ru='Ни в одной строке цены по соглашению с поставщиком не заполнены'"),
			БиблиотекаКартинок.Информация32);
	КонецЕсли;
	
КонецПроцедуры

// Показывает оповещение пользователя об окончании заполнения цен по условию цен поставщика.
//
// Параметры:
//  ЦеныРассчитаны       - Булево - Признак успешного расчета цен хотя бы в одной строке.
//  ВидЦеныПоставщика - СправочникСсылка.ВидыЦенПоставщиков - Вид цены поставщика, по которому осуществлялось заполнение
//                                                            цен.
//
Процедура ОповеститьОбОкончанииЗаполненияЦенПоВидуЦеныПоставщика(ЦеныРассчитаны, ВидЦеныПоставщика) Экспорт

	Если ЦеныРассчитаны Тогда
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Цены заполнены'"),
			,
			СтрЗаменить(НСтр("ru='Цены по виду цены поставщика ""%ВидЦеныПоставщика%"" заполнены'"), "%ВидЦеныПоставщика%", ВидЦеныПоставщика),
			БиблиотекаКартинок.Информация32);
	Иначе
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Цены не заполнены'"),
			,
			СтрЗаменить(НСтр("ru='Ни в одной строке цены по виду цены поставщика ""%ВидЦеныПоставщика%"" не заполнены'"), "%ВидЦеныПоставщика%", ВидЦеныПоставщика),
			БиблиотекаКартинок.Информация32);
	КонецЕсли;
	
КонецПроцедуры

// Показывает оповещение пользователя об окончании заполнения дат поступления всех строк тч.
//
// Параметры:
//	ДатаПоступления - Дата - дата отгрузки, по которой заполнялась дата в табличной части
//	ВыделенныеСтроки - Массив - влияет на текст сообщения.
//
Процедура ОповеститьОбОкончанииЗаполненияДатПоступления(ДатаПоступления, ЗаполнениеВыделенныхСтрок) Экспорт

	Если ЗаполнениеВыделенныхСтрок Тогда
		
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Дата поступления заполнена'"),
			,
			СтрЗаменить(НСтр("ru='Для выделенных строк установлена дата поступления %ДатаПоступления%'"), "%ДатаПоступления%", Формат(ДатаПоступления, "ДЛФ=D")),
			БиблиотекаКартинок.Информация32);
		
	Иначе
		
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Дата поступления заполнена'"),
			,
			СтрЗаменить(НСтр("ru='Для всех строк установлена дата поступления %ДатаПоступления%'"), "%ДатаПоступления%", Формат(ДатаПоступления, "ДЛФ=D")),
			БиблиотекаКартинок.Информация32);
		
	КонецЕсли;
	
КонецПроцедуры

// Показывает оповещение пользователя об окончании перезаполнения товаров по фактической приемке.
//
// Параметры:
//	ЕстьИзменения           - Булево - Если Истина - есть изменения в табличной части
//	КоличествоПерезаполнено - Булево - Если Истина - количество было перезаполнено по фактической приемке.
//
Процедура ОповеститьОбОкончанииПерезаполненияТоваровПоПриемке(ЕстьИзменения, КоличествоПерезаполнено) Экспорт
	
	Если ЕстьИзменения Тогда
		
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Количество перезаполнено'"),
			,
			НСтр("ru='В строках перезаполнено количество.'"),
			БиблиотекаКартинок.Информация32);
		
	Иначе
		
		Если КоличествоПерезаполнено Тогда
			
			ПоказатьОповещениеПользователя(
				НСтр("ru = 'Перезаполнение не требуется'"),
				,
				НСтр("ru='Перезаполнение не требуется, т.к. во всех строках количество совпадает с указанным.'"),
				БиблиотекаКартинок.Информация32);
			
		Иначе
		
			ПоказатьОповещениеПользователя(
				НСтр("ru = 'Перезаполнение не требуется'"),
				,
				НСтр("ru='Ни по одной строке не начата приемка.'"),
				БиблиотекаКартинок.Информация32);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыОбработкиКомандПользователя

// Процедура для выбора условия цен поставщика из формы выбора.
//
// Параметры:
//	Партнер - СправочникСсылка.Партнер - партнер, для которого выберите условия цен поставщиков.
//
Процедура ВыбратьВидЦеныПоставщика(ОписаниеОповещения, Партнер, ЦенаВключаетНДС = Неопределено) Экспорт

	Отбор = Новый Структура("Владелец", Партнер);
	Если ЦенаВключаетНДС <> Неопределено Тогда
		Отбор.Вставить("ЦенаВключаетНДС", ЦенаВключаетНДС);
	КонецЕсли;

	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОписаниеОповещения", ОписаниеОповещения);
	
	ОткрытьФорму(
		"Справочник.ВидыЦенПоставщиков.ФормаВыбора",
		Новый Структура("Отбор", Отбор),,,,,
		Новый ОписаниеОповещения("ВыбратьВидЦеныПоставщикаЗавершение", ЗакупкиКлиент, ДополнительныеПараметры));

КонецПроцедуры

// Обработчик завершения выбора вида цен поставщика.
//
// Параметры:
//  ВидЦеныПоставщика       - СправочникСсылка.ВидыЦенПоставщиков - выбранный вид цен поставщика.
//  ДополнительныеПараметры - Структура - дополнительные параметры.
//
Процедура ВыбратьВидЦеныПоставщикаЗавершение(ВидЦеныПоставщика, ДополнительныеПараметры) Экспорт
	
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеОповещения, ВидЦеныПоставщика);
	
КонецПроцедуры

// Формирует список выбора номенклатуры поставщика с отбором по номенклатуре, характеристике, упаковке.
//
// Параметры:
//	Партнер       - СправочникСсылка.Партнеры - владелец номенклатуры поставщика
//	ТекущаяСтрока - ДанныеФормыЭлементКоллекции - текущая строка таблицы Товары
//	СписокВыбора  - СписокЗначений - список выбора номенклатуры поставщика.
//
Процедура ЗаполнитьСписокВыбораНоменклатурыПоставщика(Партнер, ТекущаяСтрока, СписокВыбора) Экспорт
	
	Если ТекущаяСтрока = Неопределено Или Не ЗначениеЗаполнено(ТекущаяСтрока.Номенклатура) Тогда
		СписокВыбора.Очистить();
	Иначе
		
		МассивЗначений = ЗакупкиВызовСервера.СформироватьСписокВыбораНоменклатурыПоставщика(
			Партнер,
			ТекущаяСтрока.Номенклатура,
			ТекущаяСтрока.Характеристика);
		
		СписокВыбора.ЗагрузитьЗначения(МассивЗначений);
		
	КонецЕсли;
	
КонецПроцедуры

// Формирует список выбора номеров ГТД с отбором по номенклатуре, характеристике
//
// Параметры:
//	ТекущаяСтрока - ДанныеФормыЭлементКоллекции - текущая строка таблицы Товары
//	СписокВыбора  - СписокЗначений - список выбора номеров ГТД.
//
Процедура ЗаполнитьСписокВыбораНомеровГТД(ТекущаяСтрока, СписокВыбора) Экспорт
	
	Если ТекущаяСтрока = Неопределено Или Не ЗначениеЗаполнено(ТекущаяСтрока.Номенклатура) Тогда
		СписокВыбора.Очистить();
	Иначе
		СписокЗначений = ЗакупкиВызовСервера.ЗаполнитьСписокВыбораНомеровГТД(
			ТекущаяСтрока.Номенклатура,
			ТекущаяСтрока.Характеристика,
			ТекущаяСтрока.СтранаПроисхождения);
		
		СписокВыбора.Очистить();
		Для каждого ТекСтр Из СписокЗначений Цикл
			НовСтрока = СписокВыбора.Добавить();
			ЗаполнитьЗначенияСвойств(НовСтрока,ТекСтр);
		КонецЦикла; 
	КонецЕсли;
	
КонецПроцедуры

// Открывает форму списка номенклатуры поставщика с отбором по владельцу, номенклатуре, характеристике, упаковке.
//
// Параметры:
//	Партнер       - СправочникСсылка.Партнеры - владелец номенклатуры поставщика
//	Ссылка        - ДокументСсылка - ссылка на документ из формы которого вызывается процедура
//	ТекущаяСтрока - ДанныеФормыЭлементКоллекции - текущая строка таблицы Товары.
//
Процедура ПоказатьНоменклатуруПоставщика(Партнер, Ссылка, ТекущаяСтрока) Экспорт
	
	Отказ = Ложь;
	
	Если Не ЗначениеЗаполнено(Партнер) Тогда
		Отказ = Истина;
	КонецЕсли;
		
	Если ТекущаяСтрока = Неопределено Тогда
		Отказ = Истина;
	ИначеЕсли Не ЗначениеЗаполнено(ТекущаяСтрока.Номенклатура) Тогда
		Отказ = Истина;
	КонецЕсли;
	
	Если Отказ Тогда
		
		ОчиститьСообщения();
		
		Если Не ЗначениеЗаполнено(Партнер) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Поле ""Партнер"" не заполнено'"), Ссылка, "Объект.Партнер");
		КонецЕсли;
		
		Если ТекущаяСтрока = Неопределено Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Выберите строку таблицы ""Товары""'"), Ссылка, "Объект.Товары");
		ИначеЕсли Не ЗначениеЗаполнено(ТекущаяСтрока.Номенклатура) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Не заполнена колонка ""Номенклатура""'"),
				Ссылка,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Объект.Товары", ТекущаяСтрока.НомерСтроки, "Номенклатура"));
		КонецЕсли;
		
	Иначе
		
		СтруктураПараметров = Новый Структура();
		СтруктураПараметров.Вставить("Владелец",       Партнер);
		СтруктураПараметров.Вставить("Номенклатура",   ТекущаяСтрока.Номенклатура);
		СтруктураПараметров.Вставить("Характеристика", ТекущаяСтрока.Характеристика);
		СтруктураПараметров.Вставить("Упаковка",       ТекущаяСтрока.Упаковка);
		
		ОткрытьФорму("Справочник.НоменклатураПоставщиков.Форма.ФормаСписка", Новый Структура("Отбор", СтруктураПараметров));
		
	КонецЕсли;
	
КонецПроцедуры

// Проверяет заполненность реквизитов, необходимых для заполнения товаров по приемке.
//
// Параметры:
//  ЕстьПринятыеТовары              - Булево - признак наличия принятых товаров.
//  ЗаполнятьПринимающимисяТоварами - Булево - признак, указывающий на необходимость заполнения принимающимися товарами.
//
// Возвращаемое значение:
//  Булево - Ложь, если пользователь отказался от заполнения.
//
Функция ВопросОПерезаполненииПринятымиТоварами(ОписаниеОповещения, ЕстьПринятыеТовары) Экспорт
	
	СписокКнопок = Новый СписокЗначений();
	
	Если ЕстьПринятыеТовары Тогда
		
		ТекстВопроса = НСтр("ru='Не все товары приняты. Учитывать при заполнении товары, которые принимаются?'");
		СписокКнопок.Добавить("Учитывать", НСтр("ru = 'Учитывать'"));
		СписокКнопок.Добавить("НеУчитывать", НСтр("ru = 'Не учитывать'"));
		
	Иначе
		
		ТекстВопроса = НСтр("ru='Отсутствуют принятые товары. Учитывать при заполнении товары, которые принимаются?'");
		СписокКнопок.Добавить("Учитывать", НСтр("ru = 'Учитывать'"));
		
	КонецЕсли;
	
	СписокКнопок.Добавить("НеПерезаполнять", НСтр("ru = 'Не перезаполнять'"));
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОписаниеОповещения", ОписаниеОповещения);
	ПоказатьВопрос(
		Новый ОписаниеОповещения("ВопросОПерезаполненииПринятымиТоварамиЗавершение", ЗакупкиКлиент, ДополнительныеПараметры),
		ТекстВопроса,
		СписокКнопок);
	
КонецФункции

// Обработчик завершения ответа на вопрос перезаполнения принятыми товарами.
//
// Параметры:
//  ОтветНаВопрос           - Строка - вариант ответа на вопрос, выбранный пользователем.
//  ДополнительныеПараметры - Структура - дополнительные параметры.
//
Процедура ВопросОПерезаполненииПринятымиТоварамиЗавершение(ОтветНаВопрос, ДополнительныеПараметры) Экспорт
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("ЗаполнятьПринимающимисяТоварами", (ОтветНаВопрос = "Учитывать"));
	ВозвращаемоеЗначение.Вставить("Результат", (ОтветНаВопрос <> "НеПерезаполнять"));
	
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеОповещения, ВозвращаемоеЗначение);
	
КонецПроцедуры

// Открывает отчет ДинамикаИзмененияЦенНоменклатурыПоставщика с отбором из формы
//
// Параметры:
//	Форма - УправляемаяФорма - форма документа, из которого открывается отчет.
//
Процедура ОткрытьОтчетПоДинамикеЦенПоставщика(Форма) Экспорт
	
	СписокНоменклатуры  = Новый СписокЗначений;
	СписокХарактеристик = Новый СписокЗначений;
	Для Каждого ИдентификаторСтрокиДереваЦен Из Форма.Элементы.ДеревоЦен.ВыделенныеСтроки Цикл
		СтрокаТЧ = Форма.ДеревоЦен.НайтиПоИдентификатору(ИдентификаторСтрокиДереваЦен);
		СписокНоменклатуры.Добавить(СтрокаТЧ.Номенклатура);
		Если СтрокаТЧ.ХарактеристикиИспользуются Тогда
			Если СтрокаТЧ.ПолучитьРодителя() = Неопределено Тогда
				Для Каждого СтрокаХарактеристика Из СтрокаТЧ.ПолучитьЭлементы() Цикл
					Если СписокХарактеристик.НайтиПоЗначению(СтрокаХарактеристика.Характеристика) = Неопределено Тогда
						СписокХарактеристик.Добавить(СтрокаХарактеристика.Характеристика);
					КонецЕсли;
				КонецЦикла;
			Иначе
				Если СписокХарактеристик.НайтиПоЗначению(СтрокаТЧ.Характеристика) = Неопределено Тогда
					СписокХарактеристик.Добавить(СтрокаТЧ.Характеристика);
				КонецЕсли;
			КонецЕсли;
		Иначе
			Если СписокХарактеристик.НайтиПоЗначению(
					ПредопределенноеЗначение("Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка")) = Неопределено Тогда
				СписокХарактеристик.Добавить(ПредопределенноеЗначение("Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка"));
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	СписокВидовЦен = Новый СписокЗначений;
	Для Каждого СтрокаВидЦены Из УстановкаЦенКлиентСервер.ВыбранныеСтрокиТаблицыВидовЦен(Форма) Цикл
		СписокВидовЦен.Добавить(СтрокаВидЦены.Ссылка, СтрокаВидЦены.Наименование);
	КонецЦикла;
	
	Отбор = Новый Структура;
	Отбор.Вставить("Номенклатура", СписокНоменклатуры);
	Отбор.Вставить("Характеристика", СписокХарактеристик);
	Отбор.Вставить("ВидЦеныПоставщика", СписокВидовЦен);
	Отбор.Вставить("Партнер", Форма.Объект.Партнер);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отбор", Отбор);
	ПараметрыФормы.Вставить("КлючНазначенияИспользования", НСтр("ru = 'Динамика изменения цен по номенклатуре (Диаграмма)'"));
	ПараметрыФормы.Вставить("КлючВарианта", НСтр("ru = 'Динамика изменения цен по номенклатуре (Диаграмма)'"));
	ПараметрыФормы.Вставить("СформироватьПриОткрытии", Истина);
	
	ОткрытьФорму("Отчет.ДинамикаИзмененияЦенНоменклатурыПоставщика.Форма",
	        ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыИФункцииРаботыСНоменклатуройПоставщикаВДокументахЗакупки

// Открывает форму заполнения номенклатуры по номенклатуре поставщика.
//
// Параметры:
//  ОписаниеОповещения - ОписаниеОповещения - описание оповещения.
//  АдресТоваровВХранилище - Строка - адрес товаров в хранилище.
//  Форма - УправляемаяФорма - владелец открываемой формы.
//
Процедура ОткрытьФормуЗаполненияНоменклатурыПоставщика(ОписаниеОповещения, АдресТоваровВХранилище, Форма, ОтборТипНоменклатуры = Неопределено) Экспорт
	
	Если АдресТоваровВХранилище = Неопределено Тогда
		
		ПоказатьПредупреждение(,НСтр("ru = 'Отсутствуют строки, в которых указана номенклатура поставщика, но не указана номенклатура'"));
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, Неопределено);
		Возврат;
		
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("АдресТоваровВХранилище", АдресТоваровВХранилище);
	Если ЗначениеЗаполнено(ОтборТипНоменклатуры) Тогда
		ПараметрыФормы.Вставить("ОтборТипНоменклатуры",ОтборТипНоменклатуры);
	КонецЕсли;
	
	ОткрытьФорму(
		"ОбщаяФорма.ЗаполнениеНоменклатурыПоНоменклатуреПоставщика",
		ПараметрыФормы,
		Форма,,,,
		ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти
