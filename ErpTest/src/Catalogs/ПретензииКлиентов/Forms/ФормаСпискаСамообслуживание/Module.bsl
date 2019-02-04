
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ПартнерыИКонтрагентыВызовСервера.ДанныеАвторизовавшегосяВнешнегоПользователя());
		
	Если Партнер = Неопределено ИЛИ Партнер.Пустая() Тогда
		 Отказ = Истина;
		 Возврат;
	КонецЕсли;

	СамообслуживаниеСервер.ЗаполнитьСписокВыбораКонтактныхЛиц(Элементы.КонтактноеЛицоОтбор.СписокВыбора, Партнер, КонтактноеЛицо);
	УстановитьПараметрыЗапросаДинамическогоСписка();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	НеПоказыватьРассмотренные = Настройки.Получить("НеПоказыватьРассмотренные");
	КонтактноеЛицоОтбор       = Настройки.Получить("КонтактноеЛицоОтбор");
	
	ИзменитьОтборКонтактноеЛицо();
	Если НеПоказыватьРассмотренные Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Статус", СписокЗакрытыхСтатусовПретензий(),
		                                                     ВидСравненияКомпоновкиДанных.НеВСписке,,Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КонтактноеЛицоОтборПриИзменении(Элемент)
	
	ИзменитьОтборКонтактноеЛицо();
	
КонецПроцедуры

&НаКлиенте
Процедура НеПоказыватьРассмотренныеПриИзменении(Элемент)
	
	Если НеПоказыватьРассмотренные Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Статус", СписокЗакрытыхСтатусовПретензий(),
		                                                     ВидСравненияКомпоновкиДанных.НеВСписке,,Истина);
	Иначе
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список, "Статус");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.Статус <> ПредопределенноеЗначение("Перечисление.СтатусыПретензийКлиентов.Зарегистрирована") Тогда
		Отказ = Истина;
		СамообслуживаниеКлиент.ПечатьПретензияКлиента(ТекущиеДанные.Ссылка);
	КонецЕсли;

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

#Область ОбработчикиСобытийЭлементовУправленияФормы

&НаКлиенте
Процедура СписокПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	// СтандартныеПодсистемы.Взаимодействия
	ВзаимодействияКлиент.СписокПредметПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле);
	// Конец СтандартныеПодсистемы.Взаимодействия
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	// СтандартныеПодсистемы.Взаимодействия
	ВзаимодействияКлиент.СписокПредметПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле);
	// Конец СтандартныеПодсистемы.Взаимодействия

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СвязанныеДокументы(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		
		ОткрытьФорму("ОбщаяФорма.СтруктураПодчиненности",Новый Структура("ОбъектОтбора", ТекущиеДанные.Ссылка),ЭтаФорма);
		
	КонецЕсли;
	
КонецПроцедуры

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
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Функция СписокЗакрытыхСтатусовПретензий()

	СписокЗакрытыхСтатусовПретензий = Новый СписокЗначений;
	СписокЗакрытыхСтатусовПретензий.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыПретензийКлиентов.НеУдовлетворена"));
	СписокЗакрытыхСтатусовПретензий.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыПретензийКлиентов.Удовлетворена"));
	
	Возврат СписокЗакрытыхСтатусовПретензий;

КонецФункции

&НаСервере
Процедура ИзменитьОтборКонтактноеЛицо()

	Если НЕ ЗначениеЗаполнено(КонтактноеЛицоОтбор) Тогда
		
		ТекстЗапроса = "
		|ВЫБРАТЬ
		|	ПретензииКлиентов.Наименование,
		|	ВЫБОР
		|		КОГДА ПретензииКлиентов.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыПретензийКлиентов.Зарегистрирована)
		|				ИЛИ ПретензииКлиентов.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыПретензийКлиентов.Обрабатывается)
		|			ТОГДА ПРЕДСТАВЛЕНИЕ(ПретензииКлиентов.Статус)
		|		ИНАЧЕ &Рассмотрена
		|	КОНЕЦ КАК СтатусПредставление,
		|	ПретензииКлиентов.Статус,
		|	ПретензииКлиентов.ОписаниеПретензии,
		|	ПретензииКлиентов.РезультатыОтработки,
		|	ПретензииКлиентов.ДатаРегистрации,
		|	ПретензииКлиентов.ДатаОкончания,
		|	ПретензииКлиентов.Ссылка
		|ИЗ
		|	Справочник.ПретензииКлиентов КАК ПретензииКлиентов
		|ГДЕ
		|	ПретензииКлиентов.Партнер = &Партнер
		|";
		
	Иначе
		
		ТекстЗапроса = "
		|ВЫБРАТЬ
		|	ПретензииКлиентов.Наименование,
		|	ВЫБОР
		|		КОГДА ПретензииКлиентов.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыПретензийКлиентов.Зарегистрирована)
		|				ИЛИ ПретензииКлиентов.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыПретензийКлиентов.Обрабатывается)
		|			ТОГДА ПРЕДСТАВЛЕНИЕ(ПретензииКлиентов.Статус)
		|		ИНАЧЕ &Рассмотрена
		|	КОНЕЦ КАК СтатусПредставление,
		|	ПретензииКлиентов.Статус,
		|	ПретензииКлиентов.ОписаниеПретензии,
		|	ПретензииКлиентов.РезультатыОтработки,
		|	ПретензииКлиентов.ДатаРегистрации,
		|	ПретензииКлиентов.ДатаОкончания,
		|	ПретензииКлиентов.Ссылка
		|ИЗ
		|	Справочник.ПретензииКлиентов КАК ПретензииКлиентов
		|ГДЕ
		|	ПретензииКлиентов.Ссылка В
		|			(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|				ПретензииКлиентов.Ссылка КАК Ссылка
		|			ИЗ
		|				Справочник.ПретензииКлиентов.ПартнерыИКонтактныеЛица КАК ПретензииКлиентовПартнерыИКонтактныеЛица
		|					ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПретензииКлиентов КАК ПретензииКлиентов
		|					ПО
		|						ПретензииКлиентовПартнерыИКонтактныеЛица.Ссылка = ПретензииКлиентов.Ссылка
		|			ГДЕ
		|				ПретензииКлиентов.Партнер = &Партнер
		|				И ПретензииКлиентовПартнерыИКонтактныеЛица.КонтактноеЛицо = &КонтактноеЛицо)";
		
	КонецЕсли;
	
	Свойства = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
	Свойства.ТекстЗапроса = ТекстЗапроса;
	
	ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.Список, Свойства);
	
	УстановитьПараметрыЗапросаДинамическогоСписка();

КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыЗапросаДинамическогоСписка()

	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "Партнер", Партнер);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "КонтактноеЛицо", КонтактноеЛицоОтбор);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "Рассмотрена", НСтр("ru = 'Рассмотрена'"));

КонецПроцедуры


#КонецОбласти
