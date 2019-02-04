
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.События.ПриСозданииНаСервере = Истина;
	Настройки.События.ПриЗагрузкеВариантаНаСервере = Истина;
	
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   Отказ - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Передается из параметров обработчика "как есть".
//
// См. также:
//   "УправляемаяФорма.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	
	Параметры = ЭтаФорма.Параметры;
	
	Если Параметры.Свойство("ПараметрКоманды")
			И Параметры.Свойство("ОписаниеКоманды")
			И Параметры.ОписаниеКоманды.Свойство("ДополнительныеПараметры") Тогда 
			
		СтруктураОтборов = Новый Структура("Регистратор", Параметры.ПараметрКоманды);
		ЭтаФорма.ФормаПараметры.Отбор = СтруктураОтборов;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗагрузкеВариантаНаСервере(ЭтаФорма, НовыеНастройкиКД) Экспорт
	
	Отчет = ЭтаФорма.Отчет;
	КомпоновщикНастроекФормы = Отчет.КомпоновщикНастроек;
	
	// Изменение настроек по функциональным опциям.
	НастроитьПараметрыОтборыПоФункциональнымОпциям(КомпоновщикНастроекФормы);
	
	НовыеНастройкиКД = КомпоновщикНастроекФормы.Настройки;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	МенеджерВТ = Новый МенеджерВременныхТаблиц;
	
	ДоступныеПоляОтбора = Новый Массив;
	ДоступныеПоляУсловий = Новый Массив;
	
	СхемаРазузлования = Отчеты.ДеревоСебестоимостиПродукции.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	НастройкиРазузлования = СхемаРазузлования.НастройкиПоУмолчанию;
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	
	НаборДанныхРазузловки = СхемаРазузлования.НаборыДанных.Найти("ВыпущеннаяПродукция");
	Если НаборДанныхРазузловки = Неопределено Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Изменилась схема разузлования продукции. Разузлование невозможно.'"));
		Возврат;
		
	КонецЕсли;	
	
	ВалютаУпрУчета = Константы.ВалютаУправленческогоУчета.Получить();
	ВалютаРеглУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	ПараметрПериод = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Период"));
	НачалоПериода = ?(ПараметрПериод.Использование, ПараметрПериод.Значение.ДатаНачала, НачалоГода(ТекущаяДатаСеанса()));
	КонецПериода = ?(ПараметрПериод.Использование, ПараметрПериод.Значение.ДатаОкончания, ТекущаяДатаСеанса());
	
	ДанныеПоСебестоимости = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ДанныеПоСебестоимости")).Значение;
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(НастройкиРазузлования, "ДанныеПоСебестоимости", ДанныеПоСебестоимости);
	
	Если ПараметрПериод.Использование Тогда
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(НастройкиРазузлования, "Период", ПараметрПериод.Значение);
	КонецЕсли;
	
	Для Каждого ДоступноеПолеОтбора Из НастройкиОтчета.Отбор.ДоступныеПоляОтбора.Элементы Цикл
		ДоступныеПоляОтбора.Добавить(ДоступноеПолеОтбора.Поле);
	КонецЦикла;
	
	Для Каждого ПолеДанных Из НаборДанныхРазузловки.Поля Цикл
		
		Если ПолеДанных.ОграничениеИспользования.Условие Тогда
			Продолжить;
		КонецЕсли;
		
		ДоступныеПоляУсловий.Добавить(Новый ПолеКомпоновкиДанных(ПолеДанных.Поле));
		
	КонецЦикла;
	
	Накладные = Неопределено;
	Для Каждого ЭлементОтбора Из НастройкиОтчета.Отбор.Элементы Цикл
		
		Если ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Регистратор") Тогда
			Накладные = ЭлементОтбора.ПравоеЗначение;
		КонецЕсли;
		
		Если ДоступныеПоляОтбора.Найти(ЭлементОтбора.ЛевоеЗначение) = Неопределено Тогда
			НастройкиОтчета.Отбор.Элементы.Удалить(ЭлементОтбора);
		КонецЕсли;
		
	КонецЦикла;
	
	Если Не Накладные = Неопределено Тогда
		
		ПараметрРегистратор = СхемаРазузлования.Параметры.Найти("Регистраторы");
		Если Не ПараметрРегистратор = Неопределено Тогда
			ПараметрРегистратор.Значение = Накладные;
		КонецЕсли;
				
	КонецЕсли;
		
	НастройкиРазузлования.Отбор.Элементы.Очистить();
	ЗаполнитьНастройкиОтчетаРекурсивно(НастройкиРазузлования.Отбор, НастройкиОтчета.Отбор, ДоступныеПоляУсловий);
	
	ПараметрыДереваСебестоимости = СтруктураСебестоимости.ПараметрыДереваСебестоимости();
	ПараметрыДереваСебестоимости.ДинамическоеСчитывание = Ложь;
	ПараметрыДереваСебестоимости.ТипРезультата = "МенеджерВременныхТаблиц";
	ПараметрыДереваСебестоимости.Результат = МенеджерВТ;
	
	ПараметрыУзлаДереваСебестоимости = СтруктураСебестоимости.ПараметрыУзлаДереваСебестоимости();
	ПараметрыУзлаДереваСебестоимости.ИнтерактивнаяНастройка = Истина;
	ПараметрыУзлаДереваСебестоимости.СхемаКД = СхемаРазузлования;
	ПараметрыУзлаДереваСебестоимости.НастройкиКД = НастройкиРазузлования;
	ПараметрыУзлаДереваСебестоимости.Отборы.ДанныеПоСебестоимости = ДанныеПоСебестоимости;
	
	СтруктураСебестоимости.ПостроитьДеревоСебестоимости(ПараметрыДереваСебестоимости, ПараметрыУзлаДереваСебестоимости);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВТ;
	
	Запрос.УстановитьПараметр("Накладные", Накладные);
	Запрос.УстановитьПараметр("ДанныеПоСебестоимости", ДанныеПоСебестоимости);
	
#Область ТекстЗапроса
	Запрос.Текст =
		"ВЫБРАТЬ
		|	АналитикаУчетаНоменклатуры.Номенклатура КАК Продукция,
		|	АналитикаУчетаНоменклатуры.Характеристика КАК ХарактеристикаПродукции,
		|	АналитикаУчетаНоменклатуры.Назначение КАК Назначение,
		|	Результат.ПартияПродукции КАК ПартияПродукции,
		|	Результат.ПартияЗатрата КАК ПартияПолуфабриката,
		|	Результат.Номенклатура КАК Полуфабрикат,
		|	Результат.Характеристика КАК ХарактеристикаПолуфабриката,
		|	ВЫБОР
		|		КОГДА Результат.ВидСтроки = ЗНАЧЕНИЕ(Перечисление.ВидыСтрокДереваСебестоимости.ПартияПродукции)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ЭтоПродукция,
		|	СУММА(Результат.Количество) КАК Количество,
		|	Результат.АналитикаУчетаПродукции КАК АналитикаУчетаПродукции,
		|	Результат.Организация КАК Организация,
		|	АналитикаУчетаНоменклатуры.Серия КАК Серия,
		|	СУММА(ВЫБОР
		|			КОГДА Результат.ТребуетсяРазузлование
		|				ТОГДА 0
		|			ИНАЧЕ Результат.Сумма
		|		КОНЕЦ) КАК Сумма,
		|	СУММА(ВЫБОР
		|			КОГДА Результат.ТребуетсяРазузлование
		|				ТОГДА 0
		|			ИНАЧЕ Результат.Материальные
		|		КОНЕЦ) КАК Материальные,
		|	СУММА(ВЫБОР
		|			КОГДА Результат.ТребуетсяРазузлование
		|				ТОГДА 0
		|			ИНАЧЕ Результат.Трудозатраты
		|		КОНЕЦ) КАК Трудозатраты,
		|	СУММА(ВЫБОР
		|			КОГДА Результат.ТребуетсяРазузлование
		|				ТОГДА 0
		|			ИНАЧЕ Результат.ПостатейныеПостоянные
		|		КОНЕЦ) КАК ПостатейныеПостоянные,
		|	СУММА(ВЫБОР
		|			КОГДА Результат.ТребуетсяРазузлование
		|				ТОГДА 0
		|			ИНАЧЕ Результат.ПостатейныеПеременные
		|		КОНЕЦ) КАК ПостатейныеПеременные,
		|	СУММА(ВЫБОР
		|			КОГДА Результат.ТребуетсяРазузлование
		|				ТОГДА 0
		|			ИНАЧЕ Результат.СуммаЗабалансовая
		|		КОНЕЦ) КАК Забалансовая
		|ПОМЕСТИТЬ КоличествоВыпуска
		|ИЗ
		|	Результат КАК Результат
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры
		|		ПО Результат.АналитикаУчетаПродукции = АналитикаУчетаНоменклатуры.КлючАналитики
		|ГДЕ
		|	(Результат.ТребуетсяРазузлование
		|			ИЛИ Результат.ВидСтроки В (ЗНАЧЕНИЕ(Перечисление.ВидыСтрокДереваСебестоимости.ПартияПродукции), ЗНАЧЕНИЕ(Перечисление.ВидыСтрокДереваСебестоимости.ПартияПолуфабриката)))
		|
		|СГРУППИРОВАТЬ ПО
		|	Результат.Номенклатура,
		|	Результат.Характеристика,
		|	АналитикаУчетаНоменклатуры.Номенклатура,
		|	АналитикаУчетаНоменклатуры.Характеристика,
		|	ВЫБОР
		|		КОГДА Результат.ВидСтроки = ЗНАЧЕНИЕ(Перечисление.ВидыСтрокДереваСебестоимости.ПартияПродукции)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ,
		|	Результат.АналитикаУчетаПродукции,
		|	АналитикаУчетаНоменклатуры.Назначение,
		|	Результат.ПартияЗатрата,
		|	Результат.ПартияПродукции,
		|	Результат.Организация,
		|	АналитикаУчетаНоменклатуры.Серия
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КоличествоВыпуска.Продукция КАК Продукция,
		|	КоличествоВыпуска.ХарактеристикаПродукции КАК ХарактеристикаПродукции,
		|	КоличествоВыпуска.Назначение КАК Назначение,
		|	КоличествоВыпуска.ПартияПродукции КАК ПартияПродукции,
		|	СУММА(КоличествоВыпуска.Количество) КАК Количество,
		|	КоличествоВыпуска.АналитикаУчетаПродукции КАК АналитикаУчетаПродукции,
		|	КоличествоВыпуска.Организация КАК Организация,
		|	КоличествоВыпуска.Серия КАК Серия,
		|	СУММА(КоличествоВыпуска.Сумма) КАК Сумма,
		|	СУММА(КоличествоВыпуска.Материальные) КАК Материальные,
		|	СУММА(КоличествоВыпуска.Трудозатраты) КАК Трудозатраты,
		|	СУММА(КоличествоВыпуска.ПостатейныеПостоянные) КАК ПостатейныеПостоянные,
		|	СУММА(КоличествоВыпуска.ПостатейныеПеременные) КАК ПостатейныеПеременные,
		|	СУММА(КоличествоВыпуска.Забалансовая) КАК Забалансовая
		|ПОМЕСТИТЬ ВТПродукция
		|ИЗ
		|	КоличествоВыпуска КАК КоличествоВыпуска
		|ГДЕ
		|	КоличествоВыпуска.ЭтоПродукция
		|
		|СГРУППИРОВАТЬ ПО
		|	КоличествоВыпуска.Продукция,
		|	КоличествоВыпуска.АналитикаУчетаПродукции,
		|	КоличествоВыпуска.Назначение,
		|	КоличествоВыпуска.ПартияПродукции,
		|	КоличествоВыпуска.ХарактеристикаПродукции,
		|	КоличествоВыпуска.Организация,
		|	КоличествоВыпуска.Серия
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВложенныйЗапрос.АналитикаУчетаВыходноеИзделие КАК АналитикаУчетаВыходноеИзделие,
		|	ВложенныйЗапрос.Количество КАК Количество,
		|	ВложенныйЗапрос.Сумма КАК Сумма,
		|	ВложенныйЗапрос.Материальные КАК Материальные,
		|	ВложенныйЗапрос.Трудозатраты КАК Трудозатраты,
		|	ВложенныйЗапрос.ПостатейныеПостоянные КАК ПостатейныеПостоянные,
		|	ВложенныйЗапрос.ПостатейныеПеременные КАК ПостатейныеПеременные,
		|	ВложенныйЗапрос.Забалансовая КАК Забалансовая,
		|	ВложенныйЗапрос.Затрата КАК Затрата,
		|	ВложенныйЗапрос.ХарактеристикаЗатраты КАК ХарактеристикаЗатраты,
		|	ВложенныйЗапрос.Полуфабрикат КАК Полуфабрикат,
		|	ВложенныйЗапрос.ХарактеристикаПолуфабриката КАК ХарактеристикаПолуфабриката,
		|	ВложенныйЗапрос.АналитикаУчетаПродукции КАК АналитикаУчетаПродукции,
		|	ВложенныйЗапрос.ВидСтроки КАК ВидСтроки,
		|	ВложенныйЗапрос.ПартияПолуфабриката КАК ПартияПолуфабриката,
		|	ВложенныйЗапрос.ПартияПродукции КАК ПартияПродукции,
		|	ВЫБОР
		|		КОГДА ВложенныйЗапрос.Количество = 0
		|			ТОГДА 0
		|		ИНАЧЕ ВложенныйЗапрос.Сумма / ВложенныйЗапрос.Количество
		|	КОНЕЦ КАК Цена,
		|	ВложенныйЗапрос.ЭтоПолуфабрикат КАК ЭтоПолуфабрикат,
		|	ВложенныйЗапрос.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		|	ВложенныйЗапрос.Организация КАК Организация,
		|	ВложенныйЗапрос.Подразделение КАК Подразделение,
		|	ВложенныйЗапрос.СтатьяКалькуляции КАК СтатьяКалькуляции,
		|	ВложенныйЗапрос.ПартияЗатрата КАК ПартияЗатрата
		|ПОМЕСТИТЬ Затраты
		|ИЗ
		|	(ВЫБРАТЬ
		|		Результат.АналитикаУчетаВыходноеИзделие КАК АналитикаУчетаВыходноеИзделие,
		|		СУММА(Результат.Количество) КАК Количество,
		|		СУММА(ВЫБОР
		|				КОГДА Результат.ТребуетсяРазузлование
		|					ТОГДА 0
		|				ИНАЧЕ Результат.Сумма
		|			КОНЕЦ) КАК Сумма,
		|		СУММА(ВЫБОР
		|				КОГДА Результат.ТребуетсяРазузлование
		|					ТОГДА 0
		|				ИНАЧЕ Результат.Материальные
		|			КОНЕЦ) КАК Материальные,
		|		СУММА(ВЫБОР
		|				КОГДА Результат.ТребуетсяРазузлование
		|					ТОГДА 0
		|				ИНАЧЕ Результат.Трудозатраты
		|			КОНЕЦ) КАК Трудозатраты,
		|		СУММА(ВЫБОР
		|				КОГДА Результат.ТребуетсяРазузлование
		|					ТОГДА 0
		|				ИНАЧЕ Результат.ПостатейныеПостоянные
		|			КОНЕЦ) КАК ПостатейныеПостоянные,
		|		СУММА(ВЫБОР
		|				КОГДА Результат.ТребуетсяРазузлование
		|					ТОГДА 0
		|				ИНАЧЕ Результат.ПостатейныеПеременные
		|			КОНЕЦ) КАК ПостатейныеПеременные,
		|		СУММА(ВЫБОР
		|				КОГДА Результат.ТребуетсяРазузлование
		|					ТОГДА 0
		|				ИНАЧЕ Результат.СуммаЗабалансовая
		|			КОНЕЦ) КАК Забалансовая,
		|		Результат.Номенклатура КАК Затрата,
		|		Результат.Характеристика КАК ХарактеристикаЗатраты,
		|		АналитикаУчетаПолуфабриката.Номенклатура КАК Полуфабрикат,
		|		АналитикаУчетаПолуфабриката.Характеристика КАК ХарактеристикаПолуфабриката,
		|		Результат.АналитикаУчетаПродукции КАК АналитикаУчетаПродукции,
		|		Результат.ВидСтроки КАК ВидСтроки,
		|		Результат.ПартияВыходноеИзделие КАК ПартияПолуфабриката,
		|		Результат.ПартияПродукции КАК ПартияПродукции,
		|		Результат.ТребуетсяРазузлование КАК ЭтоПолуфабрикат,
		|		ВЫБОР
		|			КОГДА ТИПЗНАЧЕНИЯ(Результат.Номенклатура) = ТИП(Справочник.Номенклатура)
		|				ТОГДА ВЫРАЗИТЬ(Результат.Номенклатура КАК Справочник.Номенклатура).ЕдиницаИзмерения
		|			КОГДА ТИПЗНАЧЕНИЯ(Результат.Номенклатура) = ТИП(Справочник.ВидыРаботСотрудников)
		|				ТОГДА ВЫРАЗИТЬ(Результат.Номенклатура КАК Справочник.ВидыРаботСотрудников).ЕдиницаИзмерения
		|			ИНАЧЕ ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)
		|		КОНЕЦ КАК ЕдиницаИзмерения,
		|		Результат.Организация КАК Организация,
		|		Результат.Подразделение КАК Подразделение,
		|		Результат.СтатьяКалькуляции КАК СтатьяКалькуляции,
		|		Результат.ПартияЗатрата КАК ПартияЗатрата
		|	ИЗ
		|		Результат КАК Результат
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаНоменклатуры КАК АналитикаУчетаПолуфабриката
		|			ПО Результат.АналитикаУчетаВыходноеИзделие = АналитикаУчетаПолуфабриката.КлючАналитики
		|	
		|	СГРУППИРОВАТЬ ПО
		|		Результат.Характеристика,
		|		АналитикаУчетаПолуфабриката.Номенклатура,
		|		Результат.АналитикаУчетаПродукции,
		|		АналитикаУчетаПолуфабриката.Характеристика,
		|		Результат.Подразделение,
		|		Результат.Организация,
		|		Результат.ПартияВыходноеИзделие,
		|		Результат.СтатьяКалькуляции,
		|		Результат.Номенклатура,
		|		Результат.АналитикаУчетаВыходноеИзделие,
		|		Результат.ТребуетсяРазузлование,
		|		Результат.ПартияПродукции,
		|		Результат.ВидСтроки,
		|		Результат.ПартияЗатрата) КАК ВложенныйЗапрос
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТПродукция.Продукция КАК Продукция,
		|	ВТПродукция.ХарактеристикаПродукции КАК ХарактеристикаПродукции,
		|	ВТПродукция.Назначение КАК Назначение,
		|	ВТПродукция.ПартияПродукции КАК ПартияПродукции,
		|	ВТПродукция.Количество КАК КоличествоВыпуск,
		|	ВТПродукция.Продукция КАК Полуфабрикат,
		|	ВТПродукция.ХарактеристикаПродукции КАК ХарактеристикаПолуфабриката,
		|	Затраты.Затрата КАК Затрата,
		|	Затраты.ХарактеристикаЗатраты КАК ХарактеристикаЗатраты,
		|	Затраты.Сумма КАК Стоимость,
		|	Затраты.Материальные КАК Материальные,
		|	Затраты.Трудозатраты КАК Трудозатраты,
		|	Затраты.ПостатейныеПостоянные КАК ПостатейныеПостоянные,
		|	Затраты.ПостатейныеПеременные КАК ПостатейныеПеременные,
		|	Затраты.Забалансовая КАК Забалансовая,
		|	Затраты.Количество КАК Количество,
		|	Затраты.Цена КАК Цена,
		|	Затраты.ЭтоПолуфабрикат КАК ЭтоПолуфабрикат,
		|	Затраты.ЕдиницаИзмерения КАК ЕдиницаИзмеренияЗатраты,
		|	Затраты.Организация КАК Организация,
		|	Затраты.Подразделение КАК Подразделение,
		|	Затраты.СтатьяКалькуляции КАК СтатьяКалькуляции,
		|	ВТПродукция.Серия КАК Серия,
		|	ВТПродукция.Сумма КАК СуммаВыпуск,
		|	ВТПродукция.Материальные КАК МатериальныеВыпуск,
		|	ВТПродукция.Трудозатраты КАК ТрудозатратыВыпуск,
		|	ВТПродукция.ПостатейныеПостоянные КАК ПостатейныеПостоянныеВыпуск,
		|	ВТПродукция.ПостатейныеПеременные КАК ПостатейныеПеременныеВыпуск,
		|	ВТПродукция.Забалансовая КАК ЗабалансоваяВыпуск,
		|	Затраты.ПартияЗатрата КАК ПартияЗатрата
		|ПОМЕСТИТЬ ЗатратыВРазрезе
		|ИЗ
		|	ВТПродукция КАК ВТПродукция
		|		ЛЕВОЕ СОЕДИНЕНИЕ Затраты КАК Затраты
		|		ПО ВТПродукция.АналитикаУчетаПродукции = Затраты.АналитикаУчетаВыходноеИзделие
		|			И (НЕ Затраты.ВидСтроки = ЗНАЧЕНИЕ(Перечисление.ВидыСтрокДереваСебестоимости.ПартияПродукции))
		|			И ВТПродукция.ПартияПродукции = Затраты.ПартияПродукции
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	КоличествоВыпуска.Продукция,
		|	КоличествоВыпуска.ХарактеристикаПродукции,
		|	КоличествоВыпуска.Назначение,
		|	КоличествоВыпуска.ПартияПродукции,
		|	КоличествоВыпуска.Количество,
		|	КоличествоВыпуска.Полуфабрикат,
		|	КоличествоВыпуска.ХарактеристикаПолуфабриката,
		|	Затраты.Затрата,
		|	Затраты.ХарактеристикаЗатраты,
		|	СУММА(Затраты.Сумма),
		|	СУММА(Затраты.Материальные),
		|	СУММА(Затраты.Трудозатраты),
		|	СУММА(Затраты.ПостатейныеПостоянные),
		|	СУММА(Затраты.ПостатейныеПеременные),
		|	СУММА(Затраты.Забалансовая),
		|	СУММА(Затраты.Количество),
		|	СРЕДНЕЕ(Затраты.Цена),
		|	Затраты.ЭтоПолуфабрикат,
		|	Затраты.ЕдиницаИзмерения,
		|	Затраты.Организация,
		|	Затраты.Подразделение,
		|	Затраты.СтатьяКалькуляции,
		|	КоличествоВыпуска.Серия,
		|	0,
		|	0,
		|	0,
		|	0,
		|	0,
		|	0,
		|	Затраты.ПартияЗатрата
		|ИЗ
		|	КоличествоВыпуска КАК КоличествоВыпуска
		|		ЛЕВОЕ СОЕДИНЕНИЕ Затраты КАК Затраты
		|		ПО КоличествоВыпуска.АналитикаУчетаПродукции = Затраты.АналитикаУчетаПродукции
		|			И КоличествоВыпуска.Полуфабрикат = Затраты.Полуфабрикат
		|			И КоличествоВыпуска.ХарактеристикаПолуфабриката = Затраты.ХарактеристикаПолуфабриката
		|			И КоличествоВыпуска.ПартияПолуфабриката = Затраты.ПартияПолуфабриката
		|			И КоличествоВыпуска.ПартияПродукции = Затраты.ПартияПродукции
		|ГДЕ
		|	НЕ КоличествоВыпуска.ЭтоПродукция
		|
		|СГРУППИРОВАТЬ ПО
		|	КоличествоВыпуска.Продукция,
		|	КоличествоВыпуска.ХарактеристикаПродукции,
		|	КоличествоВыпуска.Назначение,
		|	КоличествоВыпуска.Серия,
		|	КоличествоВыпуска.ПартияПродукции,
		|	КоличествоВыпуска.Количество,
		|	КоличествоВыпуска.Полуфабрикат,
		|	КоличествоВыпуска.ХарактеристикаПолуфабриката,
		|	Затраты.Затрата,
		|	Затраты.ХарактеристикаЗатраты,
		|	Затраты.ЭтоПолуфабрикат,
		|	Затраты.ЕдиницаИзмерения,
		|	Затраты.Организация,
		|	Затраты.Подразделение,
		|	Затраты.СтатьяКалькуляции,
		|	Затраты.ПартияЗатрата
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СебестоимостьТоваров.АналитикаУчетаНоменклатуры.Номенклатура КАК Номенклатура,
		|	СебестоимостьТоваров.АналитикаУчетаНоменклатуры.Характеристика КАК Характеристика,
		|	СебестоимостьТоваров.АналитикаУчетаНоменклатуры.Серия КАК Серия,
		|	СебестоимостьТоваров.Партия КАК Партия,
		|	СебестоимостьТоваров.Организация КАК Организация,
		|	СУММА(СебестоимостьТоваров.Количество) КАК Количество,
		|	СУММА(ВЫБОР
		|			КОГДА &ДанныеПоСебестоимости = 1
		|				ТОГДА СебестоимостьТоваров.Стоимость
		|				+ СебестоимостьТоваров.Трудозатраты
		|				+ СебестоимостьТоваров.ПостатейныеПостоянныеСНДС
		|				+ СебестоимостьТоваров.ПостатейныеПеременныеСНДС
		|				+ СебестоимостьТоваров.ДопРасходы
		|			КОГДА &ДанныеПоСебестоимости = 2
		|				ТОГДА СебестоимостьТоваров.СтоимостьБезНДС
		|				+ СебестоимостьТоваров.Трудозатраты
		|				+ СебестоимостьТоваров.ПостатейныеПостоянныеБезНДС
		|				+ СебестоимостьТоваров.ПостатейныеПеременныеБезНДС
		|				+ СебестоимостьТоваров.ДопРасходыБезНДС
		|			КОГДА &ДанныеПоСебестоимости = 3
		|				ТОГДА СебестоимостьТоваров.СтоимостьРегл
		|				+ СебестоимостьТоваров.ТрудозатратыРегл
		|				+ СебестоимостьТоваров.ПостатейныеПостоянныеРегл
		|				+ СебестоимостьТоваров.ПостатейныеПеременныеРегл
		|				+ СебестоимостьТоваров.ДопРасходыРегл
		|		КОНЕЦ)												КАК Стоимость,
		|	СУММА(ВЫБОР
		|			КОГДА &ДанныеПоСебестоимости = 1
		|				ТОГДА СебестоимостьТоваров.Стоимость
		|				+ СебестоимостьТоваров.ДопРасходы
		|			КОГДА &ДанныеПоСебестоимости = 2
		|				ТОГДА СебестоимостьТоваров.СтоимостьБезНДС
		|				+ СебестоимостьТоваров.ДопРасходыБезНДС
		|			КОГДА &ДанныеПоСебестоимости = 3
		|				ТОГДА СебестоимостьТоваров.СтоимостьРегл
		|				+ СебестоимостьТоваров.ДопРасходыРегл
		|		КОНЕЦ)												КАК Материальные,
		|	СУММА(ВЫБОР
		|			КОГДА &ДанныеПоСебестоимости = 1
		|				ТОГДА СебестоимостьТоваров.Трудозатраты
		|			КОГДА &ДанныеПоСебестоимости = 2
		|				ТОГДА СебестоимостьТоваров.Трудозатраты
		|			КОГДА &ДанныеПоСебестоимости = 3
		|				ТОГДА СебестоимостьТоваров.ТрудозатратыРегл
		|		КОНЕЦ)												КАК Трудозатраты,
		|	СУММА(ВЫБОР
		|			КОГДА &ДанныеПоСебестоимости = 1
		|				ТОГДА СебестоимостьТоваров.ПостатейныеПостоянныеСНДС
		|			КОГДА &ДанныеПоСебестоимости = 2
		|				ТОГДА СебестоимостьТоваров.ПостатейныеПостоянныеБезНДС
		|			КОГДА &ДанныеПоСебестоимости = 3
		|				ТОГДА СебестоимостьТоваров.ПостатейныеПостоянныеРегл
		|		КОНЕЦ)												КАК ПостатейныеПостоянные,
		|	СУММА(ВЫБОР
		|			КОГДА &ДанныеПоСебестоимости = 1
		|				ТОГДА СебестоимостьТоваров.ПостатейныеПеременныеСНДС
		|			КОГДА &ДанныеПоСебестоимости = 2
		|				ТОГДА СебестоимостьТоваров.ПостатейныеПеременныеБезНДС
		|			КОГДА &ДанныеПоСебестоимости = 3
		|				ТОГДА СебестоимостьТоваров.ПостатейныеПеременныеРегл
		|		КОНЕЦ)												КАК ПостатейныеПеременные,
		|	СУММА(ВЫБОР
		|			КОГДА &ДанныеПоСебестоимости = 1
		|				ТОГДА СебестоимостьТоваров.СтоимостьЗабалансовая
		|			КОГДА &ДанныеПоСебестоимости = 2
		|				ТОГДА СебестоимостьТоваров.СтоимостьЗабалансовая
		|			КОГДА &ДанныеПоСебестоимости = 3
		|				ТОГДА СебестоимостьТоваров.СтоимостьЗабалансоваяРегл
		|		КОНЕЦ)												КАК Забалансовая
		|ПОМЕСТИТЬ МатериалыПродукция
		|ИЗ
		|	РегистрНакопления.СебестоимостьТоваров КАК СебестоимостьТоваров
		|ГДЕ
		|	СебестоимостьТоваров.Регистратор В(&Накладные)
		|	И СебестоимостьТоваров.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
		|
		|СГРУППИРОВАТЬ ПО
		|	СебестоимостьТоваров.Партия,
		|	СебестоимостьТоваров.АналитикаУчетаНоменклатуры.Серия,
		|	СебестоимостьТоваров.АналитикаУчетаНоменклатуры.Характеристика,
		|	СебестоимостьТоваров.АналитикаУчетаНоменклатуры.Номенклатура,
		|	СебестоимостьТоваров.Организация
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ФактическиеДанные.Продукция КАК Продукция,
		|	ФактическиеДанные.ХарактеристикаПродукции КАК ХарактеристикаПродукции,
		|	ФактическиеДанные.Назначение КАК НазначениеПродукции,
		|	ФактическиеДанные.ПартияПродукции КАК ПартияПродукции,
		|	ФактическиеДанные.Полуфабрикат КАК Полуфабрикат,
		|	ФактическиеДанные.ХарактеристикаПолуфабриката КАК ХарактеристикаПолуфабриката,
		|	ФактическиеДанные.Затрата КАК Затрата,
		|	ФактическиеДанные.ХарактеристикаЗатраты КАК ХарактеристикаЗатраты,
		|	ФактическиеДанные.Цена КАК Цена,
		|	ВЫБОР
		|		КОГДА ФактическиеДанные.СуммаВыпуск > 0
		|			ТОГДА ФактическиеДанные.СуммаВыпуск
		|		ИНАЧЕ ФактическиеДанные.Стоимость
		|	КОНЕЦ КАК Стоимость,
		|	ВЫБОР
		|		КОГДА ФактическиеДанные.МатериальныеВыпуск > 0
		|			ТОГДА ФактическиеДанные.МатериальныеВыпуск
		|		ИНАЧЕ ФактическиеДанные.Материальные
		|	КОНЕЦ КАК Материальные,
		|	ВЫБОР
		|		КОГДА ФактическиеДанные.ТрудозатратыВыпуск > 0
		|			ТОГДА ФактическиеДанные.ТрудозатратыВыпуск
		|		ИНАЧЕ ФактическиеДанные.Трудозатраты
		|	КОНЕЦ КАК Трудозатраты,
		|	ВЫБОР
		|		КОГДА ФактическиеДанные.ПостатейныеПостоянныеВыпуск > 0
		|			ТОГДА ФактическиеДанные.ПостатейныеПостоянныеВыпуск
		|		ИНАЧЕ ФактическиеДанные.ПостатейныеПостоянные
		|	КОНЕЦ КАК ПостатейныеПостоянные,
		|	ВЫБОР
		|		КОГДА ФактическиеДанные.ПостатейныеПеременныеВыпуск > 0
		|			ТОГДА ФактическиеДанные.ПостатейныеПеременныеВыпуск
		|		ИНАЧЕ ФактическиеДанные.ПостатейныеПеременные
		|	КОНЕЦ КАК ПостатейныеПеременные,
		|	ВЫБОР
		|		КОГДА ФактическиеДанные.ЗабалансоваяВыпуск > 0
		|			ТОГДА ФактическиеДанные.ЗабалансоваяВыпуск
		|		ИНАЧЕ ФактическиеДанные.Забалансовая
		|	КОНЕЦ КАК Забалансовые,
		|	ФактическиеДанные.Количество КАК Количество,
		|	ФактическиеДанные.Продукция.ЕдиницаИзмерения КАК ЕдиницаИзмеренияПродукции,
		|	ФактическиеДанные.Полуфабрикат.ЕдиницаИзмерения КАК ЕдиницаИзмеренияПолуфабриката,
		|	ФактическиеДанные.ЕдиницаИзмеренияЗатраты КАК ЕдиницаИзмеренияЗатраты,
		|	ФактическиеДанные.Организация КАК Организация,
		|	ФактическиеДанные.СтатьяКалькуляции КАК СтатьяКалькуляции,
		|	ФактическиеДанные.Подразделение КАК Подразделение,
		|	""Продукция"" КАК ТипДанных,
		|	ФактическиеДанные.Серия КАК Серия,
		|	ФактическиеДанные.ПартияЗатрата КАК ПартияЗатраты,
		|	0 КАК Уровень
		|ИЗ
		|	ЗатратыВРазрезе КАК ФактическиеДанные
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	NULL,
		|	NULL,
		|	NULL,
		|	NULL,
		|	NULL,
		|	NULL,
		|	МатериалыПродукция.Номенклатура,
		|	МатериалыПродукция.Характеристика,
		|	СУММА(ВЫБОР
		|			КОГДА МатериалыПродукция.Количество = 0
		|				ТОГДА 0
		|			ИНАЧЕ МатериалыПродукция.Стоимость / МатериалыПродукция.Количество
		|		КОНЕЦ),
		|	СУММА(МатериалыПродукция.Стоимость),
		|	СУММА(МатериалыПродукция.Материальные),
		|	СУММА(МатериалыПродукция.Трудозатраты),
		|	СУММА(МатериалыПродукция.ПостатейныеПостоянные),
		|	СУММА(МатериалыПродукция.ПостатейныеПеременные),
		|	СУММА(МатериалыПродукция.Забалансовая),
		|	СУММА(МатериалыПродукция.Количество),
		|	NULL,
		|	NULL,
		|	МатериалыПродукция.Номенклатура.ЕдиницаИзмерения,
		|	МатериалыПродукция.Организация,
		|	NULL,
		|	NULL,
		|	""Материалы"",
		|	МатериалыПродукция.Серия,
		|	МатериалыПродукция.Партия,
		|	0
		|ИЗ
		|	МатериалыПродукция КАК МатериалыПродукция
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.СебестоимостьТоваров КАК СебестоимостьТоваров
		|		ПО (СебестоимостьТоваров.АналитикаУчетаНоменклатуры.Номенклатура = МатериалыПродукция.Номенклатура)
		|			И (СебестоимостьТоваров.АналитикаУчетаНоменклатуры.Характеристика = МатериалыПродукция.Характеристика)
		|			И (СебестоимостьТоваров.АналитикаУчетаНоменклатуры.Серия = МатериалыПродукция.Серия)
		|			И (СебестоимостьТоваров.РазделУчета В (ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ПроизводственныеЗатраты), ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыПринятыеНаОтветхранение)))
		|			И (СебестоимостьТоваров.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход))
		|			И (СебестоимостьТоваров.ХозяйственнаяОперация В (ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВыпускПродукции), ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВыпускПродукцииНаСклад), ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВыпускПродукцииВПодразделение)))
		|			И (НЕ СебестоимостьТоваров.Партия = НЕОПРЕДЕЛЕНО)
		|ГДЕ
		|	СебестоимостьТоваров.Регистратор ЕСТЬ NULL
		|
		|СГРУППИРОВАТЬ ПО
		|	МатериалыПродукция.Номенклатура,
		|	МатериалыПродукция.Характеристика,
		|	МатериалыПродукция.Организация,
		|	МатериалыПродукция.Серия,
		|	МатериалыПродукция.Номенклатура.ЕдиницаИзмерения,
		|	МатериалыПродукция.Партия
		//++ НЕ УТКА	
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВТПродукция.Продукция,
		|	ВТПродукция.ХарактеристикаПродукции,
		|	ВТПродукция.Назначение,
		|	ВТПродукция.ПартияПродукции,
		|	NULL,
		|	NULL,
		|	Затраты.Номенклатура,
		|	Затраты.Характеристика,
		|	ВЫБОР
		|		КОГДА Затраты.Количество = 0
		|			ТОГДА 0
		|		ИНАЧЕ Затраты.Сумма / Затраты.Количество
		|	КОНЕЦ,
		|	Затраты.Сумма,
		|	Затраты.Материальные,
		|	Затраты.Трудозатраты,
		|	Затраты.ПостатейныеПостоянные,
		|	Затраты.ПостатейныеПеременные,
		|	Затраты.СуммаЗабалансовая,
		|	Затраты.Количество,
		|	ВТПродукция.Продукция.ЕдиницаИзмерения,
		|	NULL,
		|	Затраты.ЕдиницаИзмерения,
		|	ВТПродукция.Организация,
		|	Затраты.СтатьяКалькуляции,
		|	Затраты.Подразделение,
		|	""МатериалыДавальца"",
		|	ВТПродукция.Серия,
		|	Затраты.ПартияЗатрата,
		|	Затраты.Уровень
		|ИЗ
		|	ВТПродукция КАК ВТПродукция
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Результат КАК Затраты
		|		ПО ВТПродукция.АналитикаУчетаПродукции = Затраты.АналитикаУчетаПродукции
		|			И ВТПродукция.ПартияПродукции = Затраты.ПартияПродукции
		|			И (Затраты.ВидСтроки = ЗНАЧЕНИЕ(Перечисление.ВидыСтрокДереваСебестоимости.ПартияЗатраты))
		|			И (ТИПЗНАЧЕНИЯ(Затраты.ПартияЗатрата) = ТИП(Документ.ПоступлениеСырьяОтДавальца))
		//-- НЕ УТКА	
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ФактическиеДанные.Продукция КАК Продукция,
		|	ФактическиеДанные.ХарактеристикаПродукции КАК ХарактеристикаПродукции,
		|	ФактическиеДанные.Назначение КАК НазначениеПродукции,
		|	ФактическиеДанные.ПартияПродукции КАК ПартияПродукции,
		|	ФактическиеДанные.Полуфабрикат КАК Полуфабрикат,
		|	ФактическиеДанные.ХарактеристикаПолуфабриката КАК ХарактеристикаПолуфабриката,
		|	СУММА(ФактическиеДанные.Количество) КАК КоличествоВыпуск,
		|	ФактическиеДанные.Организация КАК Организация
		|ИЗ
		|	КоличествоВыпуска КАК ФактическиеДанные
		|
		|СГРУППИРОВАТЬ ПО
		|	ФактическиеДанные.Продукция,
		|	ФактическиеДанные.Полуфабрикат,
		|	ФактическиеДанные.ХарактеристикаПолуфабриката,
		|	ФактическиеДанные.ПартияПродукции,
		|	ФактическиеДанные.ХарактеристикаПродукции,
		|	ФактическиеДанные.Назначение,
		|	ФактическиеДанные.Организация";
	
#КонецОбласти

	МассивРезультатов = Запрос.ВыполнитьПакет();
	ВнешниеНаборыДанных = Новый Структура();
	ВнешниеНаборыДанных.Вставить("Факт", МассивРезультатов[МассивРезультатов.Количество() - 2].Выгрузить());
	ВнешниеНаборыДанных.Вставить("Выпуски", МассивРезультатов[МассивРезультатов.Количество() - 1].Выгрузить());
	
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	Если ДанныеПоСебестоимости = 3 Тогда
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(НастройкиОтчета, "Валюта", ВалютаРеглУчета);	
	Иначе
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(НастройкиОтчета, "Валюта", ВалютаУпрУчета);	
	КонецЕсли;
	
	ЭлементыКУдалению = Новый Массив;
	Для Каждого ЭлементОтбора Из НастройкиОтчета.Отбор.Элементы Цикл
		
		Если ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Регистратор") Тогда
			ЭлементыКУдалению.Добавить(ЭлементОтбора);
		КонецЕсли;
		
		//++ НЕ УТКА	
		Если ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Калькуляция") Тогда
			// Отчет вызван в качестве расширофвки отчета "Плановая и фактическая себестоимость".
			ЭлементыКУдалению.Добавить(ЭлементОтбора);
		КонецЕсли;
		//-- НЕ УТКА	
		
	КонецЦикла;
	
	Для Каждого УдаляемыйЭлемент Из ЭлементыКУдалению Цикл
		НастройкиОтчета.Отбор.Элементы.Удалить(УдаляемыйЭлемент);
	КонецЦикла;
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	
	ВывестиТекстПредупрежденияОбОграниченияхИспользованияОтчета(НачалоПериода,
		КонецПериода,
		ДокументРезультат);
		
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	//++ НЕ УТКА	
	Если Не ТипЗнч(Накладные) = Тип("ДокументСсылка.ОтчетДавальцу") Тогда
	//-- НЕ УТКА	
		КомпоновкаДанныхСервер.СкрытьВспомогательныеПараметрыОтчета(
			СхемаКомпоновкиДанных, КомпоновщикНастроек, ДокументРезультат, ВспомогательныеПараметрыОтчета());
	//++ НЕ УТКА	
	КонецЕсли;
	//-- НЕ УТКА	
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Заполняет отбор в СКД получателе возможными отборами.
//	ПриемникНастроек - ОтборКомпоновкиДанных
//	ИсточникНастроек - ОтборКомпоновкиДанных
//	ВозможныеПоляУсловия - Массив - полей компоновки данных, на которые возможно наложить отбор в приемнике настроек.
//
Процедура ЗаполнитьНастройкиОтчетаРекурсивно(ПриемникНастроек, ИсточникНастроек, ВозможныеПоляУсловия)
	
	Для Каждого ЭлементОтбора Из ИсточникНастроек.Элементы Цикл
		
		Если Не ЭлементОтбора.Использование Тогда
			Продолжить;
		КонецЕсли;
		
		Если ТипЗнч(ЭлементОтбора) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			
			НовыйЭлемент = ПриемникНастроек.Элементы.Добавить(ТипЗнч(ЭлементОтбора));
			ЗаполнитьЗначенияСвойств(НовыйЭлемент, ЭлементОтбора);
			ЗаполнитьНастройкиОтчетаРекурсивно(НовыйЭлемент, ЭлементОтбора, ВозможныеПоляУсловия);
			
		Иначе
			
			Если ВозможныеПоляУсловия.Найти(ЭлементОтбора.ЛевоеЗначение) = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			ЗаполнитьЗначенияСвойств(ПриемникНастроек.Элементы.Добавить(ТипЗнч(ЭлементОтбора)), ЭлементОтбора);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ВспомогательныеПараметрыОтчета()
	
	Параметры = Новый Массив;
	Параметры.Добавить("ТолькоМатериалыДавальца");
	
	Возврат Параметры;
	
КонецФункции

Процедура НастроитьПараметрыОтборыПоФункциональнымОпциям(КомпоновщикНастроекФормы)
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристикиНоменклатуры") Тогда
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(КомпоновщикНастроекФормы, "ХарактеристикаПродукции");
	КонецЕсли;
	
	КомпоновкаДанныхСервер.ОчиститьСтруктуруПоФункциональнымОпциям(КомпоновщикНастроекФормы.Настройки.Структура, УдаляемыеПоляПоФО());
	
КонецПроцедуры

Функция УдаляемыеПоляПоФО()
	
	УдаляемыеПоля = Новый Массив;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристикиНоменклатуры") Тогда
		
		УдаляемыеПоля.Добавить(Новый ПолеКомпоновкиДанных("ХарактеристикаПродукции"));
		УдаляемыеПоля.Добавить(Новый ПолеКомпоновкиДанных("ХарактеристикаПолуфабриката"));
		УдаляемыеПоля.Добавить(Новый ПолеКомпоновкиДанных("ХарактеристикаЗатраты"));
		
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьСерииНоменклатуры") Тогда
		УдаляемыеПоля.Добавить(Новый ПолеКомпоновкиДанных("Серия"));
	КонецЕсли;
	
	Возврат УдаляемыеПоля;
	
КонецФункции

Процедура ВывестиТекстПредупрежденияОбОграниченияхИспользованияОтчета(НачалоПериода, КонецПериода, ДокументРезультат)
	
	ТекстПредупреждения = УниверсальныеМеханизмыПартийИСебестоимости.ТекстПредупрежденияНеподдерживаемыеОрганизации(НачалоПериода, КонецПериода);
	Если Не ПустаяСтрока(ТекстПредупреждения) Тогда
		
		ТаблицаПредупреждение = Новый ТабличныйДокумент;
		ОбластьПредупреждение = ТаблицаПредупреждение.Область(1,1,1,1);
		
		ОбластьПредупреждение.Текст 	 = СокрЛП(ТекстПредупреждения);
		ОбластьПредупреждение.ЦветТекста = ЦветаСтиля.ЦветОтрицательногоЧисла;
		
		ДокументРезультат.ВставитьОбласть(
		ОбластьПредупреждение,
		ДокументРезультат.Область(1,1,1,1),
		ТипСмещенияТабличногоДокумента.ПоВертикали);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли