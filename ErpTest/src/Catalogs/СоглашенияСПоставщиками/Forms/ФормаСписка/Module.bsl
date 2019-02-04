
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Список.Параметры.УстановитьЗначениеПараметра("ДатаАктуальности", НачалоДня(ТекущаяДатаСеанса()));
	
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	ОтборыСписковКлиентСервер.ЗаполнитьСписокВыбораОтбораПоАктуальности(Элементы.ОтборСрокДействия.СписокВыбора);
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, "Менеджер", Менеджер, СтруктураБыстрогоОтбора);
	ОтборыСписковКлиентСервер.ОтборПоАктуальностиПриСозданииНаСервере(Список, Актуальность, ДатаСобытия, СтруктураБыстрогоОтбора);

	Если ОтборыСписковКлиентСервер.НеобходимОтборПоСостояниюПриСозданииНаСервере(Состояние, СтруктураБыстрогоОтбора) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Состояние", Состояние, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Состояние));
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("Партнер") Тогда
		Заголовок = НСтр("ru='Соглашения с поставщиком'");
	КонецЕсли;
	
	Элементы.УстановитьСтатусДействует.Видимость = ПравоДоступа("Изменение", Метаданные.Справочники.СоглашенияСПоставщиками);
	Элементы.УстановитьСтатусНеСогласовано.Видимость = ПравоДоступа("Изменение", Метаданные.Справочники.СоглашенияСПоставщиками);
	Элементы.УстановитьСтатусЗакрыто.Видимость = ПравоДоступа("Изменение", Метаданные.Справочники.СоглашенияСПоставщиками);
	
	ОтборыСписковКлиентСервер.СкопироватьСписокВыбораОтбораПоМенеджеру(
		Элементы.Менеджер.СписокВыбора,
		ОбщегоНазначенияУТ.ПолучитьСписокПользователейСПравомДобавления(Метаданные.Справочники.СоглашенияСПоставщиками, НСтр("ru = '<Мои соглашения>'")));

		
	Параметры.ДополнительныеПараметры.Свойство("АгентскаяУслугаНоменклатура", АгентскаяУслугаНоменклатура);
	Параметры.ДополнительныеПараметры.Свойство("АгентскаяУслугаХарактеристика", АгентскаяУслугаХарактеристика);
	
	Если Не ЗначениеЗаполнено(АгентскаяУслугаНоменклатура) Тогда
		Элементы.ОтборАгентскаяУслуга.Видимость = Ложь;
		Элементы.ДобавитьУслугуВСоглашение.Видимость = Ложь;
	Иначе
		
		Элементы.ОтборАгентскаяУслуга.СписокВыбора[0].Представление =
					НоменклатураКлиентСервер.ПредставлениеНоменклатуры(АгентскаяУслугаНоменклатура, АгентскаяУслугаХарактеристика);
					
		Если Параметры.ВключитьОтборПоАгентскойУслуге Тогда
			ОтборАгентскаяУслуга = "ТолькоДляНоменклатуры";
		КонецЕсли;
		
		Элементы.ДобавитьУслугуВСоглашение.Видимость = ПравоДоступа("Изменение", Метаданные.Справочники.СоглашенияСПоставщиками);
						
		УстановитьОтборПоАгентскойУслуге();
		
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаГлобальныеКоманды);
	// Конец ИнтеграцияС1СДокументооборотом
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если ЗначениеЗаполнено(ДатаАктуальности) Тогда
		Список.Параметры.УстановитьЗначениеПараметра("ДатаАктуальности", ДатаАктуальности);
	КонецЕсли;
	
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(Список, "Менеджер", Менеджер, СтруктураБыстрогоОтбора, Настройки);
	ОтборыСписковКлиентСервер.ОтборПоАктуальностиПриЗагрузкеИзНастроек(Список, Актуальность, ДатаСобытия, СтруктураБыстрогоОтбора, Настройки);
	
	Если ОтборыСписковКлиентСервер.НеобходимОтборПоСостояниюПриЗагрузкеИзНастроек(Состояние, СтруктураБыстрогоОтбора, Настройки) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Состояние", Состояние, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Состояние));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборСостояниеПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Состояние", Состояние, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Состояние));
	
КонецПроцедуры

&НаКлиенте
Процедура МенеджерПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Менеджер", Менеджер, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Менеджер));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСрокДействияПриИзменении(Элемент)
	
	ОтборыСписковКлиентСервер.ПриИзмененииОтбораПоАктуальности(Список, Актуальность, ДатаСобытия);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСрокДействияОчистка(Элемент, СтандартнаяОбработка)
	
	ОтборыСписковКлиентСервер.ПриОчисткеОтбораПоАктуальности(Список, Актуальность, ДатаСобытия, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСрокДействияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ОбщегоНазначенияУТКлиент.ПриВыбореОтбораПоАктуальности(
		ВыбранноеЗначение, 
		СтандартнаяОбработка, 
		ЭтаФорма,
		Список, 
		"Актуальность", 
		"ДатаСобытия");
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураПриИзменении(Элемент)
	УстановитьОтборПоАгентскойУслуге();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьСтатусНеСогласовано (Команда)
	
	Если Не ОбщегоНазначенияУТКлиент.ПроверитьНаличиеВыделенныхВСпискеСтрок(Элементы.Список) Тогда
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='У выделенных в списке соглашений будет установлен статус ""Не согласовано"". По действующим соглашениям могут быть оформлены документы. После изменения статуса действующие соглашения перестанут действовать. Продолжить?'");
	Ответ = Неопределено;

	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусНеСогласованоЗавершение", ЭтотОбъект), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусНеСогласованоЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Ответ = РезультатВопроса;
    
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    
    КоличествоОбработанных = УстановитьСтатусНеСогласованоСервер(Элементы.Список.ВыделенныеСтроки);
    ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(Элементы.Список, КоличествоОбработанных, Элементы.Список.ВыделенныеСтроки.Количество(), НСтр("ru='Не согласовано'"));

КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусДействует (Команда)
	
	Если Не ОбщегоНазначенияУТКлиент.ПроверитьНаличиеВыделенныхВСпискеСтрок(Элементы.Список) Тогда
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='У выделенных в списке соглашений будет установлен статус ""Действует"". Продолжить?'");
	Ответ = Неопределено;

	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусДействуетЗавершение", ЭтотОбъект), ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусДействуетЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Ответ = РезультатВопроса;
    
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    
    КоличествоОбработанных = УстановитьСтатусДействуетСервер(Элементы.Список.ВыделенныеСтроки);
    ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(Элементы.Список, КоличествоОбработанных, Элементы.Список.ВыделенныеСтроки.Количество(), НСтр("ru='Действует'"));

КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусЗакрыто (Команда)
	
	Если Не ОбщегоНазначенияУТКлиент.ПроверитьНаличиеВыделенныхВСпискеСтрок(Элементы.Список) Тогда
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='У выделенных в списке соглашений будет установлен статус ""Закрыто"". После изменения статуса действующие соглашения перестанут действовать. Продолжить?'");
	Ответ = Неопределено;

	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусЗакрытоЗавершение", ЭтотОбъект), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусЗакрытоЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Ответ = РезультатВопроса;
    
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    
    КоличествоОбработанных = УстановитьСтатусЗакрытоСервер(Элементы.Список.ВыделенныеСтроки);
    ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(Элементы.Список, КоличествоОбработанных, Элементы.Список.ВыделенныеСтроки.Количество(), НСтр("ru='Закрыто'"));

КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьУслугуВСоглашение(Команда)
	
	ОчиститьСообщения();
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		ТекстСообщения = НСтр("ru = 'Выберите соглашение'");
		ПоказатьПредупреждение(,ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	Если Не ТекущиеДанные.ИспользоватьУказанныеАгентскиеУслуги Тогда
		ТекстСообщения = НСтр("ru = 'Выбранное соглашение действует для всех услуг. Добавлять услугу не требуется.'");
		ПоказатьПредупреждение(,ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	Если СоглашенияПоУслуге.Найти(ТекущиеДанные.Ссылка) <> Неопределено Тогда
		ТекстСообщения = НСтр("ru = 'В выбранном соглашении уже указана данная услуга.'");
		ПоказатьПредупреждение(,ТекстСообщения);
		Возврат;
	КонецЕсли;	
	
	Записано = ДобавитьУслугуВСоглашениеСервер(ТекущиеДанные.Ссылка, АгентскаяУслугаНоменклатура, АгентскаяУслугаХарактеристика);
	
	Если Записано Тогда
		ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбИзмененииОбъекта(ТекущиеДанные.Ссылка, НСтр("ru='Услуга добавлена в соглашение.'"));
		Оповестить("Запись_СоглашенияСПоставщиками",,ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьОтборПоАгентскойУслуге()
	
	Если СоглашенияПоУслуге = Неопределено Тогда
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	СоглашенияСПоставщикамиАгентскиеУслуги.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.СоглашенияСПоставщиками.АгентскиеУслуги КАК СоглашенияСПоставщикамиАгентскиеУслуги
		|ГДЕ
		|	СоглашенияСПоставщикамиАгентскиеУслуги.Номенклатура = &Номенклатура
		|	И СоглашенияСПоставщикамиАгентскиеУслуги.Характеристика = &Характеристика
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	СоглашенияСПоставщиками.Ссылка
		|ИЗ
		|	Справочник.СоглашенияСПоставщиками КАК СоглашенияСПоставщиками
		|ГДЕ
		|	НЕ СоглашенияСПоставщиками.ИспользоватьУказанныеАгентскиеУслуги
		|	И СоглашенияСПоставщиками.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОказаниеАгентскихУслуг)";
		
		Запрос.УстановитьПараметр("Номенклатура", АгентскаяУслугаНоменклатура);
		Запрос.УстановитьПараметр("Характеристика", АгентскаяУслугаХарактеристика);
		
		СоглашенияПоУслуге = Новый ФиксированныйМассив(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	КонецЕсли;
	
	Если ОтборАгентскаяУслуга = "ТолькоДляНоменклатуры" Тогда
		СписокСоглашений = Новый СписокЗначений;
		СписокСоглашений.ЗагрузитьЗначения(Новый Массив(СоглашенияПоУслуге));
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
																			"Ссылка",
																			СписокСоглашений,
																			ВидСравненияКомпоновкиДанных.ВСписке,
																			,
																			Истина);
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Ссылка",,,,Ложь);
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция УстановитьСтатусНеСогласованоСервер (Знач Соглашения)
	
	Возврат Справочники.СоглашенияСПоставщиками.УстановитьСтатус(Соглашения, Перечисления.СтатусыСоглашенийСПоставщиками.НеСогласовано);
	
КонецФункции

&НаСервереБезКонтекста
Функция УстановитьСтатусДействуетСервер (Знач Соглашения)
	
	Возврат Справочники.СоглашенияСПоставщиками.УстановитьСтатус(Соглашения, Перечисления.СтатусыСоглашенийСПоставщиками.Действует);
	
КонецФункции

&НаСервереБезКонтекста
Функция УстановитьСтатусЗакрытоСервер (Знач Соглашения)
	
	Возврат Справочники.СоглашенияСПоставщиками.УстановитьСтатус(Соглашения, Перечисления.СтатусыСоглашенийСПоставщиками.Закрыто);
	
КонецФункции

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДобавитьУслугуВСоглашениеСервер(Соглашение, Номенклатура, Характеристика)
	
	УслугаДобавлена = Истина;
	
	Попытка
		ЗаблокироватьДанныеДляРедактирования(Соглашение);
	Исключение
		
		ТекстОшибки = НСтр("ru='Не удалось заблокировать %Соглашение%. %ОписаниеОшибки%'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Соглашение%",Соглашение);
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ОписаниеОшибки%", КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, Соглашение);
		
		УслугаДобавлена = Ложь;
	КонецПопытки;
	
	Если УслугаДобавлена Тогда 
		
		СоглашениеОбъект = Соглашение.ПолучитьОбъект();
		НоваяСтрока = СоглашениеОбъект.АгентскиеУслуги.Добавить();
		НоваяСтрока.Номенклатура = Номенклатура;
		НоваяСтрока.Характеристика = Характеристика;
		
		НайденыОшибкиПриПроверке = Ложь; 
		СоглашениеОбъект.ПроверитьАгентскиеУслуги(НайденыОшибкиПриПроверке);
		Если НайденыОшибкиПриПроверке Тогда
			УслугаДобавлена = Ложь;
		Иначе	
			Попытка
				СоглашениеОбъект.Записать();
			Исключение
				ТекстОшибки = НСтр("ru='Не удалось записать %Соглашение%. %ОписаниеОшибки%'");
				ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Соглашение%", Соглашение);
				ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ОписаниеОшибки%", КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, Соглашение);
				УслугаДобавлена = Ложь;
			КонецПопытки;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат УслугаДобавлена;
КонецФункции

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "Запись_СоглашенияСПоставщиками" Тогда
		Если ЗначениеЗаполнено(АгентскаяУслугаНоменклатура) Тогда
			СоглашенияПоУслуге = Неопределено;
			УстановитьОтборПоАгентскойУслуге();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
