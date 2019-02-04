#Область ОписаниеПеременных

&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ИнициализироватьРеквизиты();
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаГлобальныеКоманды);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.Дата", Элементы.Дата.Имя);
	
	Элементы.ОрганизацияОтбор.Видимость = ИспользоватьНесколькоОрганизаций;
	
	РазделениеВключено = ОбщегоНазначения.РазделениеВключено();
	
	Если Не ЕстьСохраненныеПользовательскиеНастройки() Тогда 
		
		УстановитьНастройкиФормы();
		
	КонецЕсли;
	
	Элементы.ФормаЗагрузитьОперацииПоЯндексКассе.Видимость = ИнтеграцияСЯндексКассой.ЕстьПравоНаЗагрузкуОперацийПоЯндексКассе();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_НастройкиЯндексКассы" Тогда 
		ОбработкаОповещенияЗаписьДоговорыСЯндексКассой();
	ИначеЕсли ИмяСобытия = "ЗавершенаЗагрузкаОперацииПоЯндексКассе"	Тогда
		УстановитьЗаголовокКомандыИнформацияОСостоянииОбменов();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если ИспользоватьНесколькоОрганизаций Тогда
		Организация = Настройки.Получить("Организация");
	КонецЕсли;
	
	ВидОперации = Настройки.Получить("ВидОперации");
	
	НачалоПериода = Настройки.Получить("НачалоПериода");
	КонецПериода = Настройки.Получить("КонецПериода");
	Если ЗначениеЗаполнено(НачалоПериода) = Неопределено
		Или ЗначениеЗаполнено(КонецПериода) = Неопределено Тогда
		НачалоПериода = НачалоДня(ТекущаяДатаСеанса());
		КонецПериода = КонецДня(ТекущаяДатаСеанса());
	КонецЕсли;
	
	УстановитьЗначениеОтбораПоПериоду("НачалоПериода", "Дата", НачалоПериода);
	УстановитьЗначениеОтбораПоПериоду("КонецПериода", "Дата", КонецПериода);
	
	УстановитьНастройкиФормы();
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииДанныхВНастройкахНаСервере(Настройки)
	
	Настройки.Вставить("НачалоПериода", ЗначениеОтбораПоПериоду("НачалоПериода", "Дата"));
	Настройки.Вставить("КонецПериода",  ЗначениеОтбораПоПериоду("КонецПериода", "Дата"));
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если РазделениеВключено Тогда
		ПодключитьОбработчикОжидания("ОбработчикОжидания_ЗагрузитьОперации", 60);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовОтбораФормы

&НаКлиенте
Процедура ОрганизацияОтборПриИзменении(Элемент)
	
	ОрганизацияОтборПриИзмененииСервер()
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияОтборПриИзмененииСервер()
	
	УстановитьЗаголовокКомандыИнформацияОСостоянииОбменов();
	УстановитьОтборИПараметрыДинамическогоСписка();

КонецПроцедуры	

&НаКлиенте
Процедура НачалоПериодаПриИзменении(Элемент)
	
	НачалоПериода = ЗначениеОтбораПоПериоду("НачалоПериода", "Дата");
	КонецПериода =  ЗначениеОтбораПоПериоду("КонецПериода", "Дата");
	
	Если НачалоПериода > КонецПериода И ЗначениеЗаполнено(КонецПериода) Тогда
		УстановитьЗначениеОтбораПоПериоду("НачалоПериода", "Дата", КонецПериода);
	КонецЕсли;
	
	ПериодПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура КонецПериодаПриИзменении(Элемент)
	
	НачалоПериода = ЗначениеОтбораПоПериоду("НачалоПериода", "Дата");
	КонецПериода =  ЗначениеОтбораПоПериоду("КонецПериода", "Дата");
	
	Если КонецПериода < НачалоПериода И ЗначениеЗаполнено(КонецПериода) Тогда
		УстановитьЗначениеОтбораПоПериоду("КонецПериода", "Дата", НачалоПериода);
	КонецЕсли;
	
	ПериодПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ВидОперацииОтборПриИзменении(Элемент)
	
	УстановитьОтборИПараметрыДинамическогоСписка();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтображатьТолькоПроблемныеДокументыПриИзменении(Элемент)
	
	УстановитьОтборИПараметрыДинамическогоСписка();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Документ.ОперацияПоЯндексКассе.ФормаСпискаДокументов.ОткрытиеДокумента");
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьПериод(Команда)
	
	Оповещение = Новый ОписаниеОповещения(
		"ВыбратьПериодЗавершение",
		ЭтотОбъект);
	
	НачалоПериода = ЗначениеОтбораПоПериоду("НачалоПериода", "Дата");
	КонецПериода =  ЗначениеОтбораПоПериоду("КонецПериода", "Дата");
	
	ОбщегоНазначенияУТКлиент.РедактироватьПериод(
		ЭтаФорма,
		Новый Структура("ДатаНачала, ДатаОкончания", "НачалоПериода", "КонецПериода"),
		Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериодЗавершение(Период, ДополнительныеПараметры) Экспорт
	
	Если Период <> Неопределено Тогда
		УстановитьЗначениеОтбораПоПериоду("НачалоПериода", "Дата", НачалоПериода);
		УстановитьЗначениеОтбораПоПериоду("КонецПериода", "Дата", КонецПериода);
		ПериодПриИзмененииНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИнформацияОСостоянииОбменов(Команда)
	
	МассивДоступныхОрганизаций = СписокДоступныхОрганизаций.ВыгрузитьЗначения();
	Если Элементы.ИнформацияОСостоянииОбменов.Заголовок =НСтр("ru = 'Показать информацию о дате последней загрузки'") Тогда 
		Отбор = Новый Структура();
		Отбор.Вставить("Ссылка", МассивДоступныхОрганизаций);
		
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("Отбор", Отбор);
		ПараметрыФормы.Вставить("ВысотаВСтрокахТаблицы", МассивДоступныхОрганизаций.Количество());
		
		ОткрытьФорму("РегистрСведений.СтатусОбменовСЯндексКассой.Форма.ФормаПросмотраСостоянияОбменов", ПараметрыФормы,
			ЭтотОбъект, УникальныйИдентификатор, ВариантОткрытияОкна.ОтдельноеОкно);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьОперацииПоЯндексКассе(Команда)
		
	ОповещениеПолученияОперацийПоЯндексКассе = Новый ОписаниеОповещения(
		"ОбработкаПолученияОперацийПоЯндексКассеЗавершение", ЭтотОбъект, Новый Структура("ВыводитьСообщения", Истина));
		
	ПараметрыЗагрузки = Новый Структура;
	ПараметрыЗагрузки.Вставить("Период", Неопределено);
	ПараметрыЗагрузки.Вставить("Организация", Неопределено);
	ПараметрыЗагрузки.Вставить("СДоговором", Истина);
		
	ИнтеграцияСЯндексКассойУТКлиент.НачатьЗагрузкуОперацийПоЯндексКассе(ПараметрыЗагрузки, ОповещениеПолученияОперацийПоЯндексКассе);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОжидания_ЗагрузитьОперации()
	
	ОповещениеПолученияОперацийПоЯндексКассе = Новый ОписаниеОповещения(
	"ОбработкаПолученияОперацийПоЯндексКассеЗавершение", ЭтотОбъект, Новый Структура("ВыводитьСообщения", Ложь));
	
	ПараметрыЗагрузки = Новый Структура;
	ПараметрыЗагрузки.Вставить("Период", Неопределено);
	ПараметрыЗагрузки.Вставить("Организация", Неопределено);
	ПараметрыЗагрузки.Вставить("СДоговором", Истина);
	
	ИнтеграцияСЯндексКассойУТКлиент.НачатьЗагрузкуОперацийПоЯндексКассе(ПараметрыЗагрузки, ОповещениеПолученияОперацийПоЯндексКассе, Ложь);
		
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

#КонецОбласти




#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ИнициализироватьРеквизиты()

	ИспользоватьНесколькоОрганизаций = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	
	Если Не ИспользоватьНесколькоОрганизаций Тогда
		Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаОповещенияЗаписьДоговорыСЯндексКассой()
	
	УстановитьСписокДоступныхОрганизаций();
	УстановитьЗаголовокКомандыИнформацияОСостоянииОбменов();
	УстановитьОтборИПараметрыДинамическогоСписка();
	
КонецПроцедуры

&НаСервере
Процедура ПериодПриИзмененииНаСервере()
	
	УстановитьОтборИПараметрыДинамическогоСписка();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовокКомандыИнформацияОСостоянииОбменов()
	
	КоличествоДоступныхОрганизаций = СписокДоступныхОрганизаций.Количество();
	
	Если ЗначениеЗаполнено(Организация) Тогда 
		ОтобраннаяОрганизация = Организация;
	ИначеЕсли КоличествоДоступныхОрганизаций = 1 Тогда
		ОтобраннаяОрганизация = СписокДоступныхОрганизаций[0].Значение;
	Иначе
		ОтобраннаяОрганизация = Неопределено;
	КонецЕсли;
	
	
	Если ЗначениеЗаполнено(ОтобраннаяОрганизация) Тогда 
		ДатаЗагрузки = ДатаПоследнегоУспешногоОбмена(ОтобраннаяОрганизация);
		ТекстЗаголовка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
									?(ЗначениеЗаполнено(ДатаЗагрузки)
										,НСтр("ru = 'Последний раз данные были загружены %1'")
										,НСтр("ru = 'Информация о дате последней загрузки отсутствует'"))
									,ДатаЗагрузки);
	ИначеЕсли КоличествоДоступныхОрганизаций > 1 Тогда 
		ТекстЗаголовка = НСтр("ru = 'Показать информацию о дате последней загрузки'");
	Иначе		
		ТекстЗаголовка = НСтр("ru = 'Информация о дате последней загрузки отсутствует'");
	КонецЕсли;
	
	Элементы.ИнформацияОСостоянииОбменов.Заголовок = ТекстЗаголовка; 
	
	КонецПериода = ЗначениеОтбораПоПериоду("КонецПериода", "Дата");
	Если Не КонецДня(КонецПериода) = КонецДня(ТекущаяДатаСеанса()) и ЗначениеЗаполнено(КонецПериода) Тогда 
		УстановитьЗначениеОтбораПоПериоду("КонецПериода", "Дата", КонецДня(ТекущаяДатаСеанса()));
		ПериодПриИзмененииНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДатаПоследнегоУспешногоОбмена(ОтобраннаяОрганизация)
	
	Возврат РегистрыСведений.СтатусОбменовСЯндексКассой.ДатаПоследнегоУспешногоОбменаПоОрганизации(ОтобраннаяОрганизация);
	
КонецФункции

&НаСервере
Процедура УстановитьСписокДоступныхОрганизаций()
	
	СписокДоступныхОрганизаций.Очистить();
	
	Если Не ИспользоватьНесколькоОрганизаций Тогда
		СписокДоступныхОрганизаций.Добавить(Организация);
		Возврат;
	КонецЕсли;
	
	Элементы.ОрганизацияОтбор.СписокВыбора.Очистить();
	НеДействительныеНастройки.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	НастройкиЯндексКассы.Ссылка КАК Настройка,
	               |	НастройкиЯндексКассы.Организация КАК Организация,
	               |	Представление(НастройкиЯндексКассы.Организация) КАК Представление,
	               |	НастройкиЯндексКассы.Недействительна КАК Недействителен
	               |ИЗ
	               |	Справочник.НастройкиЯндексКассы КАК НастройкиЯндексКассы
	               |ГДЕ
	               |	НЕ НастройкиЯндексКассы.ПометкаУдаления
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Недействителен,
	               |	Организация";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл 
		Элементы.ОрганизацияОтбор.СписокВыбора.Добавить(Выборка.Организация
			,ПредставлениеОрганизации(Выборка.Представление, Выборка.Недействителен));
		
		Если Выборка.Недействителен Тогда 
			НеДействительныеНастройки.Добавить(Выборка.Настройка);
		КонецЕсли;
	КонецЦикла;
	
	СписокДоступныхОрганизаций.ЗагрузитьЗначения(Элементы.ОрганизацияОтбор.СписокВыбора.ВыгрузитьЗначения());
	
КонецПроцедуры

&НаСервере
Функция ПредставлениеОрганизации(Представление, ПризнакНедействителен)
	
	Если ПризнакНедействителен Тогда 
		Возврат Новый ФорматированнаяСтрока(Представление + " " + НСтр("ru = '(Настройка недействительна)'"),,
			Метаданные.ЭлементыСтиля.НедоступныеДанныеЭДЦвет.Значение);
	Иначе
		Возврат Представление;
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура УстановитьОтборИПараметрыДинамическогоСписка()
	
	//Предустановленные отборы
	УстановитьЗначениеОтбораПоПериоду("НачалоПериода", "Использование",
		ЗначениеЗаполнено(ЗначениеОтбораПоПериоду("НачалоПериода", "Дата")));
		
	УстановитьЗначениеОтбораПоПериоду("КонецПериода", "Использование",
		ЗначениеЗаполнено(ЗначениеОтбораПоПериоду("КонецПериода", "Дата")));
		
	//Отборы
	СоответствиеХозОпераций = Новый Соответствие;
	СоответствиеХозОпераций.Вставить(1, Перечисления.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента);
	СоответствиеХозОпераций.Вставить(2, Перечисления.ХозяйственныеОперации.ВозвратОплатыКлиенту);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
		"ХозяйственнаяОперация",
		СоответствиеХозОпераций.Получить(ВидОперации),
		ВидСравненияКомпоновкиДанных.Равно,,
		ВидОперации>0);
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
		"Организация",
		Организация,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(Организация));

	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
		"ЕстьПроблемы",
		Истина,
		ВидСравненияКомпоновкиДанных.Равно,,
		ОтображатьТолькоПроблемныеДокументы);
		
КонецПроцедуры

&НаСервере 
Функция ЗначениеОтбораПоПериоду(Представление, ИмяСвойства)
	
	НайденныеОтборы = ОбщегоНазначенияКлиентСервер.НайтиЭлементыИГруппыОтбора(Список.КомпоновщикНастроек.Настройки.Отбор, , Представление);
	Если НайденныеОтборы.Количество() Тогда 
		Если ИмяСвойства = "Дата" Тогда 
			Возврат НайденныеОтборы[0].ПравоеЗначение.Дата;
		ИначеЕсли ИмяСвойства = "Использование" Тогда
			Возврат НайденныеОтборы[0].Использование;
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура УстановитьЗначениеОтбораПоПериоду(Представление, ИмяСвойства, Значение)
	
	НайденныеОтборы = ОбщегоНазначенияКлиентСервер.НайтиЭлементыИГруппыОтбора(Список.КомпоновщикНастроек.Настройки.Отбор, , Представление);
	Если НайденныеОтборы.Количество() Тогда 
		Если ИмяСвойства = "Дата" Тогда 
			НайденныеОтборы[0].ПравоеЗначение.Дата = Значение;
		ИначеЕсли ИмяСвойства = "Использование" Тогда
			НайденныеОтборы[0].Использование = Значение;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЕстьСохраненныеПользовательскиеНастройки()
	
	// Получение имени пользователя
	УстановитьПривилегированныйРежим(Истина);
	ПользовательСсылка = Пользователи.ТекущийПользователь();
	ИдентификаторПользователяИБ = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПользовательСсылка, "ИдентификаторПользователяИБ");
	ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(ИдентификаторПользователяИБ);
	УстановитьПривилегированныйРежим(Ложь);
	
	// Проверка на наличие настроек
	Если Не ПользовательИБ = Неопределено Тогда
		Отбор = Новый Структура();
		Отбор.Вставить("КлючОбъекта", "Документ.ОперацияПоЯндексКассе.Форма.ФормаСпискаДокументов.Список/КлючТекущихПользовательскихНастроек");
		Отбор.Вставить("Пользователь", ПользовательИБ.Имя);
		ВыборкаНастроек = ХранилищеСистемныхНастроек.Выбрать(Отбор);
		Попытка
			Если ВыборкаНастроек.Следующий() Тогда 
				Возврат Истина;
			КонецЕсли;
		Исключение
			Возврат Ложь;
		КонецПопытки;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

&НаСервере
Процедура УстановитьНастройкиФормы()
	
	УстановитьСписокДоступныхОрганизаций();
	УстановитьЗаголовокКомандыИнформацияОСостоянииОбменов();
	УстановитьОтборИПараметрыДинамическогоСписка();
	
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

#Область ОбработкаПолученияОперацийПоЯндексКассе

&НаКлиенте
Процедура ОбработкаПолученияОперацийПоЯндексКассеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда  // отменено пользователем
		Возврат;
	КонецЕсли;
	
	Если Результат.Свойство("Сообщения") Тогда 
		Для Каждого Сообщение из Результат.Сообщения Цикл 
			Сообщение.Сообщить();
		КонецЦикла;
	КонецЕсли;
	
	Если НЕ ЭтоАдресВременногоХранилища(Результат.АдресРезультата) Тогда 
		Возврат;
	КонецЕсли;	
		
	ЗагруженныеОперации = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
	
	СчетчикДокументов = 0;
	
	Для каждого ЭлементКоллекции Из ЗагруженныеОперации Цикл
		СчетчикДокументов = СчетчикДокументов + ЗагруженныеОперации[ЭлементКоллекции.Ключ];
	КонецЦикла;
	
	Если ДополнительныеПараметры.ВыводитьСообщения Тогда
		
		ТекстСообщения = ?(СчетчикДокументов > 0, НСтр("ru = 'Операций по Яндекс.Кассе загружено: %1'"), 
			НСтр("ru = 'Новых операций по Яндекс.Кассе не было'"));
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ТекстСообщения, СчетчикДокументов);
		
		ПоказатьОповещениеПользователя(НСтр("ru = 'Загрузка завершена'"),
			"e1cib/list/Документ.ОперацияПоЯндексКассе",
			ТекстСообщения);
		
	КонецЕсли;
		
	Оповестить("ЗавершенаЗагрузкаОперацииПоЯндексКассе");
	
	Если СчетчикДокументов > 0 Тогда 
		ОповеститьОбИзменении(Тип("ДокументСсылка.ОперацияПоЯндексКассе"));			
	КонецЕсли;
		
КонецПроцедуры 

#КонецОбласти

#КонецОбласти


