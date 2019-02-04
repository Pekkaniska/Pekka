
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры,,
	                        "ЗакрыватьПриВыборе, ЗакрыватьПриЗакрытииВладельца, ТолькоПросмотр");
	

	ЗаполнитьПериоды();

	Если Соглашение = Неопределено Тогда
		Если РасхожденияКлиентСервер.ТипОснованияВозвратПоставщику(ТипОснованияАктаОРасхождении)
			//++ НЕ УТ
			Или РасхожденияКлиентСервер.ТипОснованияОтгрузкаТоваровСХранения(ТипОснованияАктаОРасхождении)
			//-- НЕ УТ
			Тогда
			
			Соглашение = Справочники.СоглашенияСПоставщиками.ПустаяСсылка();
			
		Иначе
			Соглашение = Справочники.СоглашенияСКлиентами.ПустаяСсылка();
		КонецЕсли;
	КонецЕсли;
	
	
	Если ОбщегоНазначенияУТКлиентСервер.АвторизованВнешнийПользователь() Тогда
		Элементы.ИнформационнаяНадписьОтборы.Высота = 1;
	КонецЕсли;
	
	ЗаполнитьТаблицуДокументовОснований();
	СформироватьИнформационнуюНадписьОтборы();
	СформироватьИнформационнуюНадписьКоличествоДокументов(ЭтаФорма);

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПериоды()
	
	Если Не ДокументыОснования.Количество() = 0 Тогда
		
		Если РасхожденияКлиентСервер.ТипОснованияРеализацияТоваровУслуг(ТипОснованияАктаОРасхождении) Тогда
			
			ИмяТаблицы = "Документ.РеализацияТоваровУслуг";
			
		ИначеЕсли ТипОснованияАктаОРасхождении = Перечисления.ТипыОснованияАктаОРасхождении.ПриобретениеТоваровУслуг Тогда
			
			ИмяТаблицы = "Документ.ПриобретениеТоваровУслуг";
			
		ИначеЕсли ТипОснованияАктаОРасхождении = Перечисления.ТипыОснованияАктаОРасхождении.ВозвратТоваровОтКлиента Тогда
			
			ИмяТаблицы = "Документ.ВозвратТоваровОтКлиента";
			
		ИначеЕсли ТипОснованияАктаОРасхождении = Перечисления.ТипыОснованияАктаОРасхождении.ВозвратПоставщику Тогда
			
			ИмяТаблицы = "Документ.ВозвратТоваровПоставщику";
			
		//++ НЕ УТ
		ИначеЕсли ТипОснованияАктаОРасхождении = Перечисления.ТипыОснованияАктаОРасхождении.ПриемкаТоваровНаХранение Тогда
			
			ИмяТаблицы = "Документ.ПриемкаТоваровНаХранение";
			
		ИначеЕсли ТипОснованияАктаОРасхождении = Перечисления.ТипыОснованияАктаОРасхождении.ОтгрузкаТоваровСХранения Тогда
			
			ИмяТаблицы = "Документ.ОтгрузкаТоваровСХранения";
			
		//-- НЕ УТ
		Иначе
			
			ВызватьИсключение НСтр("ru = 'Не известный тип документа-основания.""'");
			
		КонецЕсли;
		
		Запрос = Новый Запрос;
		Запрос.Текст = "
		|ВЫБРАТЬ
		|	МИНИМУМ(ТаблицаДокумента.Дата)  КАК МинимальнаяДата,
		|	МАКСИМУМ(ТаблицаДокумента.Дата) КАК МаксимальнаяДата
		|ИЗ
		|	&ТаблицаДокумента КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка В(&ДокументыОснования)
		|
		|УПОРЯДОЧИТЬ ПО
		|	МинимальнаяДата";
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТаблицаДокумента", ИмяТаблицы);
		Запрос.УстановитьПараметр("ДокументыОснования", ДокументыОснования);
		
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
		
			Период.ДатаНачала    = ДобавитьМесяц(Выборка.МинимальнаяДата, - 1);
			Период.ДатаОкончания = ДобавитьМесяц(Выборка.МаксимальнаяДата, 1);
		
		КонецЦикла;
		
	КонецЕсли;
	
	Если Период.ДатаНачала = Дата(1, 1, 1) И Период.ДатаОкончания = Дата(1, 1, 1) Тогда
		Период.Вариант = ВариантСтандартногоПериода.Месяц;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если ЗакрытьФорму Тогда
		Возврат;
	КонецЕсли;
	
	Если Модифицированность И НЕ ПеренестиВДокумент Тогда
		
		ЕстьИзменения = Ложь;
		
		ВыбранныеСтроки = Основания.НайтиСтроки(Новый Структура("Выбран", Истина));
		Если ВыбранныеСтроки.Количество() <> ДокументыОснования.Количество() Тогда
			ЕстьИзменения = Истина;
		ИначеЕсли ВыбранныеСтроки.Количество() = 0 ИЛИ ДокументыОснования.Количество() = 0 Тогда
			
			ЕстьИзменения = Истина;
			
		Иначе
			Для Каждого ВыбраннаяСтрока Из ВыбранныеСтроки Цикл
				Если ДокументыОснования.НайтиПоЗначению(ВыбраннаяСтрока.Ссылка) = Неопределено Тогда
					ЕстьИзменения = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		Если ЕстьИзменения Тогда
			ТекстВопроса = НСтр("ru = 'Состав документов-оснований был изменен. Принять изменения?'");
			ОбработчикОповещения = Новый ОписаниеОповещения("ВопросОПринятииИзмененийПриОтвете", ЭтаФорма);
			ПоказатьВопрос(ОбработчикОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
			Отказ = Истина;
		КонецЕсли;
		
	ИначеЕсли ПеренестиВДокумент  Тогда
		
		Если Не ОчисткаПодтверждена И ТабличнаяЧастьНеПустая Тогда
			ТекстВопроса = НСтр("ru = 'Табличная часть документа будет очищена и перезаполнена. Продолжить?'");
			ОбработчикОповещения = Новый ОписаниеОповещения("ВопросООчисткеТабличнойЧастиПриОтвете", ЭтаФорма);
			ПоказатьВопрос(ОбработчикОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
			Отказ = Истина;
		Иначе
			
			ПеренестиВДокумент();
			Отказ = Истина;
			
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПериодВариантПриИзменении(Элемент)
	
	ЗаполнитьТаблицуДокументовОснований();
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийТабличнойЧастиРеализации

&НаКлиенте
Процедура РеализацииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если ВыбраннаяСтрока <> Неопределено Тогда
		ПоказатьЗначение(, Основания.НайтиПоИдентификатору(ВыбраннаяСтрока).Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РеализацииВыбранПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Реализации.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗнакОперации = ?(ТекущиеДанные.Выбран,1,-1);
	КоличествоДокументов = КоличествоДокументов + 1*ЗнакОперации;
	ДокументыНаСумму     = ДокументыНаСумму + ТекущиеДанные.СуммаДокумента*ЗнакОперации;
	
	ВывестиИнформационнуюНадписьКоличествоДокументов(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область КомандыФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	ЗаполнитьТаблицуДокументовОснований();
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьВсе(Команда)
	
	УстановитьФлагиВыбрано(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВсе(Команда)
	
	УстановитьФлагиВыбрано(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиВДокументВыполнить()
	
	ПеренестиВДокумент = Истина;
	Закрыть(КодВозвратаДиалога.OK);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьТаблицуДокументовОснований()
	
	ТаблицаОснованийДокумента = Новый ТаблицаЗначений;
	Запрос = Новый Запрос;
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ОснованияДокумента.Реализация КАК Реализация
	|
	|ПОМЕСТИТЬ ВыбранныеДокументы
	|ИЗ
	|	&ОснованияДокумента КАК ОснованияДокумента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////";
	
	Если РасхожденияКлиентСервер.ТипОснованияРеализацияТоваровУслуг(ТипОснованияАктаОРасхождении) Тогда
		
		ТаблицаОснованийДокумента.Колонки.Добавить("Реализация", Новый ОписаниеТипов("ДокументСсылка.РеализацияТоваровУслуг"));
		
		Запрос.Текст = Запрос.Текст + "
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВЫБОР
		|		КОГДА ВыбранныеДокументы.Реализация ЕСТЬ NULL 
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК Выбран,
		|	РеализацияТоваровУслуг.Номер,
		|	РеализацияТоваровУслуг.Дата,
		|	РеализацияТоваровУслуг.СуммаДокумента,
		|	РеализацияТоваровУслуг.Ссылка
		|ИЗ
		|	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВыбранныеДокументы КАК ВыбранныеДокументы
		|		ПО РеализацияТоваровУслуг.Ссылка = ВыбранныеДокументы.Реализация
		|ГДЕ
		|	ВЫБОР 
		|		КОГДА НЕ &ИспользоватьСоглашенияСКлиентами
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ РеализацияТоваровУслуг.Соглашение = &Соглашение
		|	КОНЕЦ
		|	И РеализацияТоваровУслуг.Контрагент = &Контрагент
		|	И РеализацияТоваровУслуг.Организация = &Организация
		|	И РеализацияТоваровУслуг.Партнер = &Партнер
		|	И РеализацияТоваровУслуг.Валюта = &Валюта
		|	И РеализацияТоваровУслуг.НалогообложениеНДС = &НалогообложениеНДС
		|	И РеализацияТоваровУслуг.ЦенаВключаетНДС = &ЦенаВключаетНДС
		|	И РеализацияТоваровУслуг.ХозяйственнаяОперация = &ХозяйственнаяОперация
		|	И ВЫБОР
		|			КОГДА &УказаниеДоговораНеТребуется
		|				ТОГДА ИСТИНА
		|			ИНАЧЕ РеализацияТоваровУслуг.Договор = &Договор
		|		КОНЕЦ
		|	И РеализацияТоваровУслуг.Проведен
		|	И РеализацияТоваровУслуг.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыРеализацийТоваровУслуг.Отгружено)
		|	И ВЫБОР
		|			КОГДА &ДатаНачала = &ПустаяДата
		|					И &ДатаОкончания = &ПустаяДата
		|				ТОГДА ИСТИНА
		|			КОГДА &ДатаНачала = &ПустаяДата
		|				ТОГДА РеализацияТоваровУслуг.Дата <= &ДатаОкончания
		|			КОГДА &ДатаОкончания = &ПустаяДата
		|				ТОГДА РеализацияТоваровУслуг.Дата >= &ДатаНачала
		|			ИНАЧЕ РеализацияТоваровУслуг.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
		|		КОНЕЦ
		|
		|УПОРЯДОЧИТЬ ПО
		|	РеализацияТоваровУслуг.Дата УБЫВ";
		
		Запрос.УстановитьПараметр("ИспользоватьСоглашенияСКлиентами", ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСКлиентами"));
		
	ИначеЕсли ТипОснованияАктаОРасхождении = Перечисления.ТипыОснованияАктаОРасхождении.ПриобретениеТоваровУслуг Тогда
		
		ТаблицаОснованийДокумента.Колонки.Добавить("Реализация", Новый ОписаниеТипов("ДокументСсылка.ПриобретениеТоваровУслуг"));
		
		Запрос.Текст = Запрос.Текст + "
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВЫБОР
		|		КОГДА ВыбранныеДокументы.Реализация ЕСТЬ NULL 
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК Выбран,
		|	ПриобретениеТоваровУслуг.Номер,
		|	ПриобретениеТоваровУслуг.Дата,
		|	ПриобретениеТоваровУслуг.СуммаДокумента,
		|	ПриобретениеТоваровУслуг.Ссылка
		|ИЗ
		|	Документ.ПриобретениеТоваровУслуг КАК ПриобретениеТоваровУслуг
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВыбранныеДокументы КАК ВыбранныеДокументы
		|		ПО ПриобретениеТоваровУслуг.Ссылка = ВыбранныеДокументы.Реализация
		|ГДЕ
		|	ВЫБОР 
		|		КОГДА НЕ &ИспользоватьСоглашенияСКлиентами
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ПриобретениеТоваровУслуг.Соглашение = &Соглашение
		|	КОНЕЦ
		|	И ПриобретениеТоваровУслуг.Контрагент = &Контрагент
		|	И ПриобретениеТоваровУслуг.Организация = &Организация
		|	И ПриобретениеТоваровУслуг.Партнер = &Партнер
		|	И ПриобретениеТоваровУслуг.Валюта = &Валюта
		|	И ПриобретениеТоваровУслуг.НалогообложениеНДС = &НалогообложениеНДС
		|	И ПриобретениеТоваровУслуг.ЦенаВключаетНДС = &ЦенаВключаетНДС
		|	И ПриобретениеТоваровУслуг.ХозяйственнаяОперация = &ХозяйственнаяОперация
		|	И ПриобретениеТоваровУслуг.ВариантПриемкиТоваров = &ВариантПриемкиТоваров
		|	И ВЫБОР
		|			КОГДА &УказаниеДоговораНеТребуется
		|				ТОГДА ИСТИНА
		|			ИНАЧЕ ПриобретениеТоваровУслуг.Договор = &Договор
		|		КОНЕЦ
		|	И ПриобретениеТоваровУслуг.Проведен
		|	И ВЫБОР
		|			КОГДА &ДатаНачала = &ПустаяДата
		|					И &ДатаОкончания = &ПустаяДата
		|				ТОГДА ИСТИНА
		|			КОГДА &ДатаНачала = &ПустаяДата
		|				ТОГДА ПриобретениеТоваровУслуг.Дата <= &ДатаОкончания
		|			КОГДА &ДатаОкончания = &ПустаяДата
		|				ТОГДА ПриобретениеТоваровУслуг.Дата >= &ДатаНачала
		|			ИНАЧЕ ПриобретениеТоваровУслуг.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
		|		КОНЕЦ
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПриобретениеТоваровУслуг.Дата УБЫВ";
		
		Запрос.УстановитьПараметр("ИспользоватьСоглашенияСКлиентами", ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСКлиентами"));
		
	//++ НЕ УТ
	ИначеЕсли ТипОснованияАктаОРасхождении = Перечисления.ТипыОснованияАктаОРасхождении.ПриемкаТоваровНаХранение Тогда
		
		ТаблицаОснованийДокумента.Колонки.Добавить("Реализация", Новый ОписаниеТипов("ДокументСсылка.ПриемкаТоваровНаХранение"));
		
		Запрос.Текст = Запрос.Текст + "
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ПриемкаТоваровНаХранение.Ссылка         КАК Ссылка,
		|	ВЫБОР
		|		КОГДА ВыбранныеДокументы.Реализация ЕСТЬ NULL 
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ                                   КАК Выбран,
		|	ПриемкаТоваровНаХранение.Номер          КАК Номер,
		|	ПриемкаТоваровНаХранение.Дата           КАК Дата,
		|	ПриемкаТоваровНаХранение.СуммаДокумента КАК СуммаДокумента
		|ИЗ
		|	Документ.ПриемкаТоваровНаХранение КАК ПриемкаТоваровНаХранение
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВыбранныеДокументы КАК ВыбранныеДокументы
		|		ПО ПриемкаТоваровНаХранение.Ссылка = ВыбранныеДокументы.Реализация
		|ГДЕ
		|	ВЫБОР
		|		КОГДА НЕ &ИспользоватьСоглашенияСКлиентами
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ПриемкаТоваровНаХранение.Соглашение = &Соглашение
		|	КОНЕЦ
		|	И ПриемкаТоваровНаХранение.Контрагент            = &Контрагент
		|	И ПриемкаТоваровНаХранение.Организация           = &Организация
		|	И ПриемкаТоваровНаХранение.Партнер               = &Партнер
		|	И ПриемкаТоваровНаХранение.Валюта                = &Валюта
		|	И ПриемкаТоваровНаХранение.ЦенаВключаетНДС       = &ЦенаВключаетНДС
		|	И ПриемкаТоваровНаХранение.ХозяйственнаяОперация = &ХозяйственнаяОперация
		|	И ВЫБОР
		|			КОГДА &УказаниеДоговораНеТребуется
		|				ТОГДА ИСТИНА
		|			ИНАЧЕ ПриемкаТоваровНаХранение.Договор = &Договор
		|		КОНЕЦ
		|	И ПриемкаТоваровНаХранение.Проведен
		|	И ВЫБОР
		|			КОГДА &ДатаНачала = &ПустаяДата
		|					И &ДатаОкончания = &ПустаяДата
		|				ТОГДА ИСТИНА
		|			КОГДА &ДатаНачала = &ПустаяДата
		|				ТОГДА ПриемкаТоваровНаХранение.Дата <= &ДатаОкончания
		|			КОГДА &ДатаОкончания = &ПустаяДата
		|				ТОГДА ПриемкаТоваровНаХранение.Дата >= &ДатаНачала
		|			ИНАЧЕ ПриемкаТоваровНаХранение.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
		|		КОНЕЦ
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПриемкаТоваровНаХранение.Дата УБЫВ";
		
		Запрос.УстановитьПараметр("ИспользоватьСоглашенияСКлиентами", ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСКлиентами"));
		
	//-- НЕ УТ
	ИначеЕсли ТипОснованияАктаОРасхождении = Перечисления.ТипыОснованияАктаОРасхождении.ВозвратТоваровОтКлиента Тогда
		
		ТаблицаОснованийДокумента.Колонки.Добавить("Реализация", Новый ОписаниеТипов("ДокументСсылка.ВозвратТоваровОтКлиента"));
		
		Запрос.Текст = Запрос.Текст + "
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВЫБОР
		|		КОГДА ВыбранныеДокументы.Реализация ЕСТЬ NULL 
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК Выбран,
		|	ВозвратТоваровОтКлиента.Номер,
		|	ВозвратТоваровОтКлиента.Дата,
		|	ВозвратТоваровОтКлиента.СуммаДокумента,
		|	ВозвратТоваровОтКлиента.Ссылка
		|ИЗ
		|	Документ.ВозвратТоваровОтКлиента КАК ВозвратТоваровОтКлиента
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВыбранныеДокументы КАК ВыбранныеДокументы
		|		ПО ВозвратТоваровОтКлиента.Ссылка = ВыбранныеДокументы.Реализация
		|ГДЕ
		|	ВЫБОР 
		|		КОГДА НЕ &ИспользоватьСоглашенияСПоставщиками
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ВозвратТоваровОтКлиента.Соглашение = &Соглашение
		|	КОНЕЦ
		|	И ВозвратТоваровОтКлиента.Контрагент = &Контрагент
		|	И ВозвратТоваровОтКлиента.Организация = &Организация
		|	И ВозвратТоваровОтКлиента.Партнер = &Партнер
		|	И ВозвратТоваровОтКлиента.Валюта = &Валюта
		|	И ВозвратТоваровОтКлиента.НалогообложениеНДС = &НалогообложениеНДС
		|	И ВозвратТоваровОтКлиента.ЦенаВключаетНДС = &ЦенаВключаетНДС
		|	И ВозвратТоваровОтКлиента.ХозяйственнаяОперация = &ХозяйственнаяОперация
		|	И ВЫБОР
		|			КОГДА &УказаниеДоговораНеТребуется
		|				ТОГДА ИСТИНА
		|			ИНАЧЕ ВозвратТоваровОтКлиента.Договор = &Договор
		|		КОНЕЦ
		|	И ВозвратТоваровОтКлиента.Проведен
		|	И ВЫБОР
		|			КОГДА &ДатаНачала = &ПустаяДата
		|					И &ДатаОкончания = &ПустаяДата
		|				ТОГДА ИСТИНА
		|			КОГДА &ДатаНачала = &ПустаяДата
		|				ТОГДА ВозвратТоваровОтКлиента.Дата <= &ДатаОкончания
		|			КОГДА &ДатаОкончания = &ПустаяДата
		|				ТОГДА ВозвратТоваровОтКлиента.Дата >= &ДатаНачала
		|			ИНАЧЕ ВозвратТоваровОтКлиента.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
		|		КОНЕЦ
		|
		|УПОРЯДОЧИТЬ ПО
		|	ВозвратТоваровОтКлиента.Дата УБЫВ";
		
	ИначеЕсли РасхожденияКлиентСервер.ТипОснованияВозвратПоставщику(ТипОснованияАктаОРасхождении) Тогда
		
		ТаблицаОснованийДокумента.Колонки.Добавить("Реализация", Новый ОписаниеТипов("ДокументСсылка.ВозвратТоваровПоставщику"));
		
		Запрос.Текст = Запрос.Текст + "
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВЫБОР
		|		КОГДА ВыбранныеДокументы.Реализация ЕСТЬ NULL 
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК Выбран,
		|	ВозвратТоваровПоставщику.Номер,
		|	ВозвратТоваровПоставщику.Дата,
		|	ВозвратТоваровПоставщику.СуммаДокумента,
		|	ВозвратТоваровПоставщику.Ссылка
		|ИЗ
		|	Документ.ВозвратТоваровПоставщику КАК ВозвратТоваровПоставщику
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВыбранныеДокументы КАК ВыбранныеДокументы
		|		ПО ВозвратТоваровПоставщику.Ссылка = ВыбранныеДокументы.Реализация
		|ГДЕ
		|	ВЫБОР 
		|		КОГДА НЕ &ИспользоватьСоглашенияСПоставщиками
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ВозвратТоваровПоставщику.Соглашение = &Соглашение
		|	КОНЕЦ
		|	И ВозвратТоваровПоставщику.Контрагент = &Контрагент
		|	И ВозвратТоваровПоставщику.Организация = &Организация
		|	И ВозвратТоваровПоставщику.Партнер = &Партнер
		|	И ВозвратТоваровПоставщику.Валюта = &Валюта
		|	И ВозвратТоваровПоставщику.НалогообложениеНДС = &НалогообложениеНДС
		|	И ВозвратТоваровПоставщику.ЦенаВключаетНДС = &ЦенаВключаетНДС
		|	И ВозвратТоваровПоставщику.ХозяйственнаяОперация = &ХозяйственнаяОперация
		|	И ВЫБОР
		|			КОГДА &УказаниеДоговораНеТребуется
		|				ТОГДА ИСТИНА
		|			ИНАЧЕ ВозвратТоваровПоставщику.Договор = &Договор
		|		КОНЕЦ
		|	И ВозвратТоваровПоставщику.Проведен
		|	И ВЫБОР
		|			КОГДА &ДатаНачала = &ПустаяДата
		|					И &ДатаОкончания = &ПустаяДата
		|				ТОГДА ИСТИНА
		|			КОГДА &ДатаНачала = &ПустаяДата
		|				ТОГДА ВозвратТоваровПоставщику.Дата <= &ДатаОкончания
		|			КОГДА &ДатаОкончания = &ПустаяДата
		|				ТОГДА ВозвратТоваровПоставщику.Дата >= &ДатаНачала
		|			ИНАЧЕ ВозвратТоваровПоставщику.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
		|		КОНЕЦ
		|
		|УПОРЯДОЧИТЬ ПО
		|	ВозвратТоваровПоставщику.Дата УБЫВ";
		
	//++ НЕ УТ
	Иначе
		
		ТаблицаОснованийДокумента.Колонки.Добавить("Реализация", Новый ОписаниеТипов("ДокументСсылка.ОтгрузкаТоваровСХранения"));
		
		Запрос.Текст = Запрос.Текст + "
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ОтгрузкаТоваровСХранения.Ссылка         КАК Ссылка,
		|	ВЫБОР
		|		КОГДА ВыбранныеДокументы.Реализация ЕСТЬ NULL 
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ                                   КАК Выбран,
		|	ОтгрузкаТоваровСХранения.Номер          КАК Номер,
		|	ОтгрузкаТоваровСХранения.Дата           КАК Дата,
		|	ОтгрузкаТоваровСХранения.СуммаДокумента КАК СуммаДокумента
		|ИЗ
		|	Документ.ОтгрузкаТоваровСХранения КАК ОтгрузкаТоваровСХранения
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВыбранныеДокументы КАК ВыбранныеДокументы
		|		ПО ОтгрузкаТоваровСХранения.Ссылка = ВыбранныеДокументы.Реализация
		|ГДЕ
		|	ОтгрузкаТоваровСХранения.Проведен
		|	И ОтгрузкаТоваровСХранения.Партнер               = &Партнер
		|	И ОтгрузкаТоваровСХранения.Контрагент            = &Контрагент
		|	И ОтгрузкаТоваровСХранения.Организация           = &Организация
		|	И ОтгрузкаТоваровСХранения.ХозяйственнаяОперация = &ХозяйственнаяОперация
		|	И ОтгрузкаТоваровСХранения.Валюта                = &Валюта
		|	И ОтгрузкаТоваровСХранения.ЦенаВключаетНДС       = &ЦенаВключаетНДС
		|	И ВЫБОР
		|			КОГДА НЕ &ИспользоватьСоглашенияСПоставщиками
		|				ТОГДА ИСТИНА
		|			ИНАЧЕ ОтгрузкаТоваровСХранения.Соглашение = &Соглашение
		|		КОНЕЦ
		|	И ВЫБОР
		|			КОГДА &УказаниеДоговораНеТребуется
		|				ТОГДА ИСТИНА
		|			ИНАЧЕ ОтгрузкаТоваровСХранения.Договор   = &Договор
		|		КОНЕЦ
		|	И ВЫБОР
		|			КОГДА &ДатаНачала = &ПустаяДата
		|					И &ДатаОкончания = &ПустаяДата
		|				ТОГДА ИСТИНА
		|			КОГДА &ДатаНачала = &ПустаяДата
		|				ТОГДА ОтгрузкаТоваровСХранения.Дата <= &ДатаОкончания
		|			КОГДА &ДатаОкончания = &ПустаяДата
		|				ТОГДА ОтгрузкаТоваровСХранения.Дата >= &ДатаНачала
		|			ИНАЧЕ ОтгрузкаТоваровСХранения.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
		|		КОНЕЦ
		|
		|УПОРЯДОЧИТЬ ПО
		|	ОтгрузкаТоваровСХранения.Дата УБЫВ";
		
	//-- НЕ УТ
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Партнер", Партнер);
	Запрос.УстановитьПараметр("Валюта", Валюта);
	Запрос.УстановитьПараметр("УказаниеДоговораНеТребуется", УказаниеДоговораНеТребуется);
	Запрос.УстановитьПараметр("Договор", Договор);
	Запрос.УстановитьПараметр("ДокументыОснования", ДокументыОснования);
	Запрос.УстановитьПараметр("НалогообложениеНДС", НалогообложениеНДС);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Соглашение", Соглашение);
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("ХозяйственнаяОперация", ХозяйственнаяОперация);
	Запрос.УстановитьПараметр("ВариантПриемкиТоваров", ВариантПриемкиТоваров);
	Запрос.УстановитьПараметр("ЦенаВключаетНДС", ЦенаВключаетНДС);
	Запрос.УстановитьПараметр("ДатаНачала", Период.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", Период.ДатаОкончания);
	Запрос.УстановитьПараметр("ИспользоватьСоглашенияСПоставщиками", ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСПоставщиками"));
	Запрос.УстановитьПараметр("ИспользоватьСоглашенияСКлиентами", ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСКлиентами"));
	Запрос.УстановитьПараметр("ПустаяДата", Дата(1, 1, 1));

	Для Каждого ЭлементСписка Из ДокументыОснования Цикл
		НоваяСтрока = ТаблицаОснованийДокумента.Добавить();
		НоваяСтрока.Реализация = ЭлементСписка.Значение;
	КонецЦикла;
	Запрос.УстановитьПараметр("ОснованияДокумента", ТаблицаОснованийДокумента);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Основания.Очистить();
		Элементы.РеализацииВыбратьВсе.Доступность   = Ложь; 
		Элементы.РеализацииИсключитьВсе.Доступность = Ложь;
	Иначе
		Основания.Загрузить(Результат.Выгрузить());
		Элементы.РеализацииВыбратьВсе.Доступность   = Истина;
		Элементы.РеализацииИсключитьВсе.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросОПринятииИзмененийПриОтвете(РезультатВопроса, ДополнительныеПараметры) Экспорт

	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ПеренестиВДокумент = Истина;
		Закрыть();
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВопросООчисткеТабличнойЧастиПриОтвете(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		
		ПеренестиВДокумент();
		
	Иначе
		
		ПеренестиВДокумент = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиВДокумент()
	
	МассивВыбранныхДокументов = Новый Массив;
	ВыбранныеСтроки = Основания.НайтиСтроки(Новый Структура("Выбран", Истина));
	Для Каждого ВыбраннаяСтрока Из ВыбранныеСтроки Цикл
		МассивВыбранныхДокументов.Добавить(ВыбраннаяСтрока.Ссылка);
	КонецЦикла;
	
	ОчисткаПодтверждена = Истина;
	ЗакрытьФорму = Истина;
	ОповеститьОВыборе(МассивВыбранныхДокументов);
	
КонецПроцедуры 

&НаКлиенте
Процедура УстановитьФлагиВыбрано(Включать)

	Для Каждого СтрокаТаблицы Из Основания Цикл
		СтрокаТаблицы.Выбран = Включать;
	КонецЦикла;
	
	Если Включать Тогда
		СформироватьИнформационнуюНадписьКоличествоДокументов(ЭтаФорма)
	Иначе
		КоличествоДокументов = 0;
		ДокументыНаСумму     = 0;
		ВывестиИнформационнуюНадписьКоличествоДокументов(ЭтаФорма);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура СформироватьИнформационнуюНадписьОтборы()
	
	
	Если НЕ ОбщегоНазначенияУТКлиентСервер.АвторизованВнешнийПользователь() Тогда
		ИнформационнаяНадписьОтборы = НСтр("ru='Отбор по: %Организация%, %Партнер%,%Контрагент% %Валюта%, %Соглашение%, %НалогообложениеНДС%,%Договор%%ХозяйственнаяОперация%, %ЦенаВключаетНДС%'");
	Иначе
		ИнформационнаяНадписьОтборы = НСтр("ru='Отбор по: %Контрагент%%Договор%%Соглашение%'");
	КонецЕсли;
	
	ИнформационнаяНадписьОтборы = СтрЗаменить(ИнформационнаяНадписьОтборы,"%Организация%", Организация);
	ИнформационнаяНадписьОтборы = СтрЗаменить(ИнформационнаяНадписьОтборы,"%Партнер%", Партнер);
	ИнформационнаяНадписьОтборы = СтрЗаменить(ИнформационнаяНадписьОтборы,"%Контрагент%", ?(ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов"),""," " + Контрагент  + ", "));
	ИнформационнаяНадписьОтборы = СтрЗаменить(ИнформационнаяНадписьОтборы,"%Соглашение%", Соглашение);
	ИнформационнаяНадписьОтборы = СтрЗаменить(ИнформационнаяНадписьОтборы,"%Валюта%", Валюта);
	ИнформационнаяНадписьОтборы = СтрЗаменить(ИнформационнаяНадписьОтборы,"%НалогообложениеНДС%", НалогообложениеНДС);
	ИнформационнаяНадписьОтборы = СтрЗаменить(ИнформационнаяНадписьОтборы,"%Договор%", ?(УказаниеДоговораНеТребуется,""," " + Договор + ", "));
	ИнформационнаяНадписьОтборы = СтрЗаменить(ИнформационнаяНадписьОтборы,"%ХозяйственнаяОперация%", ХозяйственнаяОперация);
	ИнформационнаяНадписьОтборы = СтрЗаменить(ИнформационнаяНадписьОтборы,"%ЦенаВключаетНДС%", ?(ЦенаВключаетНДС, НСтр("ru = 'Цена включает НДС'"), НСтр("ru = 'Цена не включает НДС'")));
	
	Если Прав(ИнформационнаяНадписьОтборы,2) = ", " Тогда
		ИнформационнаяНадписьОтборы = Лев(ИнформационнаяНадписьОтборы, СтрДлина(ИнформационнаяНадписьОтборы) - 2);
	КонецЕсли;
	
	ИнформационнаяНадписьОтборы = ИнформационнаяНадписьОтборы + ".";
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура СформироватьИнформационнуюНадписьКоличествоДокументов(Форма)

	Форма.КоличествоДокументов = 0;
	Форма.ДокументыНаСумму     = 0;
	
	Для Каждого СтрокаТаблицы Из Форма.Основания Цикл
		Если СтрокаТаблицы.Выбран Тогда
			Форма.КоличествоДокументов = Форма.КоличествоДокументов + 1;
			Форма.ДокументыНаСумму     = Форма.ДокументыНаСумму + СтрокаТаблицы.СуммаДокумента;
		КонецЕсли;
	КонецЦикла;
	
	ВывестиИнформационнуюНадписьКоличествоДокументов(Форма);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ВывестиИнформационнуюНадписьКоличествоДокументов(Форма)

	Если Форма.КоличествоДокументов <> 0 Тогда
		ТекстНадписи = НСтр("ru = 'Подобрано документов - %КоличествоДокументов%, на сумму %ДокументыНаСумму% %Валюта%.'");
		ТекстНадписи = СтрЗаменить(ТекстНадписи,"%КоличествоДокументов%", Форма.КоличествоДокументов);
		ТекстНадписи = СтрЗаменить(ТекстНадписи,"%ДокументыНаСумму%", Форма.ДокументыНаСумму);
		ТекстНадписи = СтрЗаменить(ТекстНадписи,"%Валюта%", Форма.Валюта);
	Иначе
		ТекстНадписи = НСтр("ru = 'Подобрано 0 документов.'");
	КонецЕсли;
	
	Форма.ИнформационнаяНадписьКоличествоДокументов = ТекстНадписи;

КонецПроцедуры

#КонецОбласти

