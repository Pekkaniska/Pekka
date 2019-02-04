
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	СправочникПодключаемоеОборудование.Ссылка КАК Устройство,
	|	СправочникПодключаемоеОборудование.ТипОборудования КАК ТипОборудования
	|ИЗ
	|	Справочник.ПодключаемоеОборудование КАК СправочникПодключаемоеОборудование
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.НастройкиРМК.КассыККМ КАК КассыККМ
	|		ПО (КассыККМ.ПодключаемоеОборудование = СправочникПодключаемоеОборудование.Ссылка)
	|		И КассыККМ.Ссылка.РабочееМесто = &ТекущееРабочееМесто
	|ГДЕ
	|	СправочникПодключаемоеОборудование.ТипОборудования = ЗНАЧЕНИЕ(Перечисление.ТипыПодключаемогоОборудования.ККМОфлайн)
	|	И СправочникПодключаемоеОборудование.ПравилоОбмена <> ЗНАЧЕНИЕ(Справочник.ПравилаОбменаСПодключаемымОборудованиемOffline.ПустаяСсылка)
	|	И СправочникПодключаемоеОборудование.УстройствоИспользуется
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СправочникПодключаемоеОборудование.Ссылка,
	|	СправочникПодключаемоеОборудование.ТипОборудования
	|ИЗ
	|	Справочник.ПодключаемоеОборудование КАК СправочникПодключаемоеОборудование
	|ГДЕ
	|	СправочникПодключаемоеОборудование.ТипОборудования = ЗНАЧЕНИЕ(Перечисление.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток)
	|	И СправочникПодключаемоеОборудование.ПравилоОбмена <> ЗНАЧЕНИЕ(Справочник.ПравилаОбменаСПодключаемымОборудованиемOffline.ПустаяСсылка)
	|	И СправочникПодключаемоеОборудование.УстройствоИспользуется");
	
	Запрос.УстановитьПараметр("ТекущееРабочееМесто", Параметры.РабочееМесто);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = Оборудование.Добавить();
		НоваяСтрока.ВыполнятьОбмен         = Истина;
		НоваяСтрока.Устройство             = Выборка.Устройство;
		НоваяСтрока.ТипОборудования        = Выборка.ТипОборудования;
		НоваяСтрока.СостояниеВыгрузки      = НСтр("ru = '<Выгрузка не производилась>'");
		НоваяСтрока.ИндексКартинкиЗагрузки = 1;
		НоваяСтрока.ИндексКартинкиВыгрузки = 1;
		
		Если НоваяСтрока.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток Тогда
			НоваяСтрока.СостояниеЗагрузки = НСтр("ru = '<Не требуется>'");
		Иначе
			НоваяСтрока.СостояниеЗагрузки = НСтр("ru = '<Загрузка не производилась>'");
		КонецЕсли;
		
	КонецЦикла;
	
	Состояние = "";
	
	Элементы.Начать.Доступность              = Истина;
	Элементы.Завершить.Доступность           = Ложь;
	
	Элементы.ОборудованиеВыполнитьСейчас.Доступность = ПравоДоступа("Добавление", Метаданные.Документы.ОтчетОРозничныхПродажах);
	
КонецПроцедуры

#Область ПроцедурыОбработчикиКоманд

&НаКлиенте
Процедура Начать(Команда)
	
	ОчиститьСообщения();
	
	Если Не ЗначениеЗаполнено(ПериодичностьОбмена) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не задана периодичность обмена с оборудованием'"),,"ПериодичностьОбмена");
		Возврат;
	КонецЕсли;
	
	Если Не ЕстьОборудованиеДляОбмена() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не выбрано оборудование для обмена'"),,"Оборудование");
		Возврат;
	КонецЕсли;
	
	Элементы.ПериодичностьОбмена.Доступность                         = Ложь;
	Элементы.ОборудованиеВыполнятьОбмен.Доступность                  = Ложь;
	Элементы.ОборудованиеУстановитьФлажки.Доступность                = Ложь;
	Элементы.ОборудованиеСнятьФлажки.Доступность                     = Ложь;
	Элементы.ОборудованиеКонтекстноеМенюУстановитьФлажки.Доступность = Ложь;
	Элементы.ОборудованиеКонтекстноеМенюСнятьФлажки.Доступность      = Ложь;
	
	Элементы.Начать.Доступность              = Ложь;
	Элементы.Завершить.Доступность           = Истина;
	
	Состояние = НСтр("ru = 'Выполняется обмен с подключенным оборудованием...'");
	
	ПодключитьОбработчикОжидания("ОбработчикОжиданияОбмен", ПериодичностьОбмена * 60, Ложь);
	
	ОбменВыполняется = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура Завершить(Команда)
	
	Элементы.ПериодичностьОбмена.Доступность                         = Истина;
	Элементы.ОборудованиеВыполнятьОбмен.Доступность                  = Истина;
	Элементы.ОборудованиеУстановитьФлажки.Доступность                = Истина;
	Элементы.ОборудованиеСнятьФлажки.Доступность                     = Истина;
	Элементы.ОборудованиеКонтекстноеМенюУстановитьФлажки.Доступность = Истина;
	Элементы.ОборудованиеКонтекстноеМенюСнятьФлажки.Доступность      = Истина;
	
	Элементы.Начать.Доступность              = Истина;
	Элементы.Завершить.Доступность           = Ложь;
	
	Состояние = НСтр("ru = 'Обмен завершен'");
	
	ОтключитьОбработчикОжидания("ОбработчикОжиданияОбмен");
	
	ОбменВыполняется = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если ОбменВыполняется Тогда
		
		Отказ = Истина;
		ПоказатьВопрос(Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект), 
			НСтр("ru = 'После закрытия обмен с оборудованием выполняться не будет. Закрыть и остановить обмен?'"), 
			РежимДиалогаВопрос.ДаНет);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ОбменВыполняется = Ложь;
		Закрыть();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	УстановитьФлажкиНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	СнятьФлажкиНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьСейчас(Команда)
	
	Состояние = НСтр("ru = 'Выполняется обмен с подключенным оборудованием...'");
	ВыполнитьОбмен();
	Состояние = НСтр("ru = 'Обмен завершен'");
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаКлиенте
Процедура ВыполнитьОбмен()
	
	Для Каждого СтрокаТЧ Из Оборудование Цикл
		
		Если Не СтрокаТЧ.ВыполнятьОбмен Тогда
			Продолжить;
		КонецЕсли;
		
		МассивУстройств = Новый Массив;
		МассивУстройств.Добавить(СтрокаТЧ.Устройство);
		
		// Выгрузка данных
		Если СтрокаТЧ.ТипОборудования = ПредопределенноеЗначение("Перечисление.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток") Тогда
			ПодключаемоеОборудованиеOfflineКлиент.ВыгрузитьТоварыВВесы(
				Новый ОписаниеОповещения("ВыгрузитьТоварыЗавершение", ЭтотОбъект, СтрокаТЧ),
				МассивУстройств,
				Ложь);
		Иначе
			МенеджерОфлайнОборудованияКлиент.НачатьВыгрузкуДанныхНаККМ(СтрокаТЧ.Устройство, 
				УникальныйИдентификатор,
				Новый ОписаниеОповещения("ПослеВыполненияОбмена", ЭтотОбъект, СтрокаТЧ));
		КонецЕсли;
		
		// Загрузка данных
		Если СтрокаТЧ.ТипОборудования = ПредопределенноеЗначение("Перечисление.ТипыПодключаемогоОборудования.ККМОфлайн") Тогда
			МенеджерОфлайнОборудованияКлиент.НачатьЗагрузкуДанныхИзККМ(СтрокаТЧ.Устройство,
				УникальныйИдентификатор,
				Новый ОписаниеОповещения("ПослеВыполненияОбмена", ЭтотОбъект, СтрокаТЧ));
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьТоварыЗавершение(Результат, СтрокаТЧ) Экспорт

	СтрокаТЧ.СостояниеВыгрузки      = Результат.ТекстСообщения;
	СтрокаТЧ.ИндексКартинкиВыгрузки = ?(Результат.Выполнено > 0, 1, 0);
	СтрокаТЧ.ДатаЗавершенияВыгрузки = ТекущаяДата();

КонецПроцедуры

&НаКлиенте
Процедура ПослеВыполненияОбмена(Результат, СтрокаТЧ) Экспорт
	
	СтрокаТЧ.СостояниеВыгрузки      = Результат.ОписаниеОшибки;
	СтрокаТЧ.ИндексКартинкиВыгрузки = ?(Результат.Результат, 1, 0);
	СтрокаТЧ.ДатаЗавершенияВыгрузки = ТекущаяДата();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОжиданияОбмен()
	
	ВыполнитьОбмен();
	
	ОтключитьОбработчикОжидания("ОбработчикОжиданияОбмен");
	ПодключитьОбработчикОжидания("ОбработчикОжиданияОбмен", ПериодичностьОбмена * 60, Ложь);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьФлажкиНаСервере()
	
	Для Каждого СтрокаТЧ Из Оборудование Цикл
		СтрокаТЧ.ВыполнятьОбмен = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СнятьФлажкиНаСервере()
	
	Для Каждого СтрокаТЧ Из Оборудование Цикл
		СтрокаТЧ.ВыполнятьОбмен = Ложь;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ЕстьОборудованиеДляОбмена()
	
	Возврат Оборудование.НайтиСтроки(Новый Структура("ВыполнятьОбмен", Истина)).Количество() > 0;
	
КонецФункции

#КонецОбласти

#КонецОбласти
