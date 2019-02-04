#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Если НЕ Параметры.Свойство("ГруппаРассылокИОповещений") 
		ИЛИ НЕ ТипЗнч(Параметры.ГруппаРассылокИОповещений) = Тип("СправочникСсылка.ГруппыРассылокИОповещений")
		ИЛИ Параметры.ГруппаРассылокИОповещений.Пустая() Тогда
		
		Отказ = Истина;
		Возврат;
		
	КонецЕсли;
	
	ГруппаРассылокИОповещений = Параметры.ГруппаРассылокИОповещений;
	РассылкиИОповещенияКлиентам.ЗаполнитьРеквизитыФормыПоГруппеРассылокИОповещений(ЭтотОбъект, ГруппаРассылокИОповещений);
	Если Принудительная Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ПравоИзменения = ПравоДоступа("Изменение", Метаданные.Справочники.ПодпискиНаРассылкиИОповещенияКлиентам);
	МассивЭлементов = Новый Массив;
	МассивЭлементов.Добавить("ФормаДобавить");
	МассивЭлементов.Добавить("ФормаДобавитьПоОтбору");
	МассивЭлементов.Добавить("Отписать");
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы, МассивЭлементов, "Видимость", ПравоИзменения);
	
	СформироватьОтчет();

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ПодпискиНаРассылкиИОповещенияКлиентам"
		И Параметр.Свойство("ГруппаРассылокИОповещений")
		И Параметр.ГруппаРассылокИОповещений = ГруппаРассылокИОповещений Тогда
		СформироватьОтчет();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.Партнеры")
		И Не ВыбранноеЗначение.Пустая() Тогда
		
		РассылкиИОповещенияКлиентамКлиент.ОткрытьФормуПодписки(ВыбранноеЗначение, ГруппаРассылокИОповещений, ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТаблицаОтчетаОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;

	ПоказатьЗначение(, Расшифровка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Добавить(Команда)
	
	ОткрытьФорму("Справочник.Партнеры.ФормаВыбора", , ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Приостановить(Команда)
	
	МассивРасшифровок = Новый Массив;
	ВыделенныеОбласти = ТаблицаОтчета.ВыделенныеОбласти;
	
	Для Каждого Область Из ВыделенныеОбласти Цикл
		Для Строка = Область.Верх По Область.Низ Цикл
			Для Столбец = 1 По 5 Цикл
				Расшифровка = ТаблицаОтчета.Область("R" + Формат(Строка, "ЧГ=0") + "C" + Столбец).Расшифровка;
				
				Если ТипЗнч(Расшифровка) = Тип("СправочникСсылка.ПодпискиНаРассылкиИОповещенияКлиентам") Тогда
					МассивРасшифровок.Добавить(Расшифровка);
					Прервать;
				КонецЕсли;
				
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
	КоличествоОтменяемыхПодписок = МассивРасшифровок.Количество();
	Если КоличествоОтменяемыхПодписок > 0 Тогда
		
		ПриостановитьПодписки(МассивРасшифровок);
		
		ТекстОповещения = НСтр("ru = 'Отмена подписки'");
		
		ТекстПояснения = НСтр("ru = 'Подписка отменена для %1 партнеров.'");
		ТекстПояснения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		               ТекстПояснения,
		               КоличествоОтменяемыхПодписок);
		ПоказатьОповещениеПользователя(ТекстОповещения, , ТекстПояснения);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПоОтбору(Команда)
	
	ПараметрыФормы = РассылкиИОповещенияКлиентамКлиент.ПараметрыФормыПодбораПоОтбору(ЭтотОбъект);
	
	ОбработчикОповещенияОЗакрытии = Новый ОписаниеОповещения("ПодборПартнеровПоОтборуПриЗакрытии", ЭтотОбъект);
	
	ОткрытьФорму("Обработка.ПодборПартнеровПоОтбору.Форма.Форма",
	             ПараметрыФормы,
	             ЭтаФорма,
	             УникальныйИдентификатор,
	             ,,
	             ОбработчикОповещенияОЗакрытии);
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	СформироватьОтчет();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СформироватьОтчет()
	
	ТаблицаОтчета.Очистить();
	ТаблицаОтчета.АвтоМасштаб = Истина;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ПодпискиНаРассылкиИОповещенияКлиентам.Владелец КАК Подписчик,
	|	ПодпискиНаРассылкиИОповещенияКлиентам.Владелец КАК АдресатПодписки,
	|	ПодпискиНаРассылкиИОповещенияКлиентам.ВидКИПартнераДляПисем КАК ВидКонтактнойИнформацииДляПисем,
	|	ПодпискиНаРассылкиИОповещенияКлиентам.ВидКИПартнераДляSMS КАК ВидКонтактнойИнформацииДляSMS,
	|	ЕСТЬNULL(ПартнерыКонтактнаяИнформацияEmail.Представление, """") КАК АдресЭП,
	|	ЕСТЬNULL(ПартнерыКонтактнаяИнформацияSMS.Представление, """") КАК НомерТелефона,
	|	0 КАК ЗначениеУпорядочивания,
	|	ПодпискиНаРассылкиИОповещенияКлиентам.КоличествоКонтактныхЛицАдресатов КАК КоличествоДопАдресатов,
	|	ПодпискиНаРассылкиИОповещенияКлиентам.ОтправлятьПартнеру,
	|	ПодпискиНаРассылкиИОповещенияКлиентам.ОтправлятьКонтактномуЛицуОбъектаОповещения,
	|	ПодпискиНаРассылкиИОповещенияКлиентам.ВидКИКонтактногоЛицаОбъектаОповещенияДляПисем,
	|	ПодпискиНаРассылкиИОповещенияКлиентам.ВидКИКонтактногоЛицаОбъектаОповещенияДляSMS,
	|	ПодпискиНаРассылкиИОповещенияКлиентам.Ссылка КАК Подписка,
	|	Партнеры.Наименование КАК ПодписчикНаименование
	|ИЗ
	|	Справочник.ПодпискиНаРассылкиИОповещенияКлиентам КАК ПодпискиНаРассылкиИОповещенияКлиентам
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Партнеры.КонтактнаяИнформация КАК ПартнерыКонтактнаяИнформацияEmail
	|		ПО ПодпискиНаРассылкиИОповещенияКлиентам.ВидКИПартнераДляПисем = ПартнерыКонтактнаяИнформацияEmail.Вид
	|			И ПодпискиНаРассылкиИОповещенияКлиентам.Владелец = ПартнерыКонтактнаяИнформацияEmail.Ссылка
	|			И (ПодпискиНаРассылкиИОповещенияКлиентам.ОтправлятьПартнеру)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Партнеры.КонтактнаяИнформация КАК ПартнерыКонтактнаяИнформацияSMS
	|		ПО ПодпискиНаРассылкиИОповещенияКлиентам.ВидКИПартнераДляSMS = ПартнерыКонтактнаяИнформацияSMS.Вид
	|			И ПодпискиНаРассылкиИОповещенияКлиентам.Владелец = ПартнерыКонтактнаяИнформацияSMS.Ссылка
	|			И (ПодпискиНаРассылкиИОповещенияКлиентам.ОтправлятьПартнеру)
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Партнеры КАК Партнеры
	|		ПО ПодпискиНаРассылкиИОповещенияКлиентам.Владелец = Партнеры.Ссылка
	|ГДЕ
	|	НЕ ПодпискиНаРассылкиИОповещенияКлиентам.ПометкаУдаления
	|	И ПодпискиНаРассылкиИОповещенияКлиентам.ГруппаРассылокИОповещений = &ГруппаРассылокИОповещений
	|	И ПодпискиНаРассылкиИОповещенияКлиентам.ПодпискаДействует
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПодпискиНаРассылкиИОповещенияКлиентам.Владелец,
	|	ПодпискиНаРассылкиИОповещенияКлиентамКонтактныеЛица.КонтактноеЛицо,
	|	ПодпискиНаРассылкиИОповещенияКлиентамКонтактныеЛица.ВидКИДляПисем,
	|	ПодпискиНаРассылкиИОповещенияКлиентамКонтактныеЛица.ВидКИДляSMS,
	|	ЕСТЬNULL(КонтактныеЛицаПартнеровКонтактнаяИнформацияEmail.Представление, """"),
	|	ЕСТЬNULL(КонтактныеЛицаПартнеровКонтактнаяИнформацияSMS.Представление, """"),
	|	1,
	|	0,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ПустаяСсылка),
	|	ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ПустаяСсылка),
	|	ПодпискиНаРассылкиИОповещенияКлиентам.Ссылка,
	|	Партнеры.Наименование
	|ИЗ
	|	Справочник.ПодпискиНаРассылкиИОповещенияКлиентам.КонтактныеЛица КАК ПодпискиНаРассылкиИОповещенияКлиентамКонтактныеЛица
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПодпискиНаРассылкиИОповещенияКлиентам КАК ПодпискиНаРассылкиИОповещенияКлиентам
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Партнеры КАК Партнеры
	|			ПО ПодпискиНаРассылкиИОповещенияКлиентам.Владелец = Партнеры.Ссылка
	|		ПО ПодпискиНаРассылкиИОповещенияКлиентамКонтактныеЛица.Ссылка = ПодпискиНаРассылкиИОповещенияКлиентам.Ссылка
	|			И (ПодпискиНаРассылкиИОповещенияКлиентам.ГруппаРассылокИОповещений = &ГруппаРассылокИОповещений)
	|			И (НЕ ПодпискиНаРассылкиИОповещенияКлиентам.ПометкаУдаления)
	|			И (ПодпискиНаРассылкиИОповещенияКлиентам.ПодпискаДействует)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КонтактныеЛицаПартнеров.КонтактнаяИнформация КАК КонтактныеЛицаПартнеровКонтактнаяИнформацияSMS
	|		ПО ПодпискиНаРассылкиИОповещенияКлиентамКонтактныеЛица.ВидКИДляSMS = КонтактныеЛицаПартнеровКонтактнаяИнформацияSMS.Вид
	|			И ПодпискиНаРассылкиИОповещенияКлиентамКонтактныеЛица.КонтактноеЛицо = КонтактныеЛицаПартнеровКонтактнаяИнформацияSMS.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КонтактныеЛицаПартнеров.КонтактнаяИнформация КАК КонтактныеЛицаПартнеровКонтактнаяИнформацияEmail
	|		ПО ПодпискиНаРассылкиИОповещенияКлиентамКонтактныеЛица.КонтактноеЛицо = КонтактныеЛицаПартнеровКонтактнаяИнформацияEmail.Ссылка
	|			И ПодпискиНаРассылкиИОповещенияКлиентамКонтактныеЛица.ВидКИДляПисем = КонтактныеЛицаПартнеровКонтактнаяИнформацияEmail.Вид
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПодписчикНаименование,
	|	ЗначениеУпорядочивания
	|ИТОГИ ПО
	|	Подписчик,
	|	АдресатПодписки";
	
	Запрос.УстановитьПараметр("ГруппаРассылокИОповещений", ГруппаРассылокИОповещений);
	
	ВыборкаИтоги = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Макет = Справочники.ПодпискиНаРассылкиИОповещенияКлиентам.ПолучитьМакет("ПодписчикиИАдресатыГруппы");
	
	// Вывод шапки
	ТаблицаОтчета.Вывести(Макет.ПолучитьОбласть("СтрокаШапка|Общее"));
	Если ПредназначенаДляЭлектронныхПисем Тогда
		ТаблицаОтчета.Присоединить(Макет.ПолучитьОбласть("СтрокаШапка|ЭлектроннаяПочта"));
	КонецЕсли;
	Если ПредназначенаДляSMS Тогда
		ТаблицаОтчета.Присоединить(Макет.ПолучитьОбласть("СтрокаШапка|Телефон"));
	КонецЕсли;
	
	ОбластьСтрокаПодписчикОбщее = Макет.ПолучитьОбласть("СтрокаПодписчик|Общее");
	ОбластьСтрокаАдресатОбщее   = Макет.ПолучитьОбласть("СтрокаАдресат|Общее");
	
	Если ПредназначенаДляSMS Тогда
		ОбластьСтрокаПодписчикТелефон = Макет.ПолучитьОбласть("СтрокаПодписчик|Телефон");
		ОбластьСтрокаАдресатТелефон   = Макет.ПолучитьОбласть("СтрокаАдресат|Телефон");
	КонецЕсли;
	Если ПредназначенаДляЭлектронныхПисем Тогда
		ОбластьСтрокаПодписчикЭлектроннаяПочта = Макет.ПолучитьОбласть("СтрокаПодписчик|ЭлектроннаяПочта");
		ОбластьСтрокаАдресатЭлектроннаяПочта   = Макет.ПолучитьОбласть("СтрокаАдресат|ЭлектроннаяПочта");
	КонецЕсли;
	
	НомерСтроки = 1;
	МассивАдресовЭП        = Новый Массив;
	МассивНомеровТелефонов = Новый Массив;
	МассивВидовКИДляПисем  = Новый Массив;
	МассивВидовКИДляSMS    = Новый Массив;
	
	Пока ВыборкаИтоги.Следующий() Цикл
		
		ОбластьСтрокаПодписчикОбщее.Параметры.НомерСтроки  = НомерСтроки;
		ОбластьСтрокаПодписчикОбщее.Параметры.Подписчик    = ВыборкаИтоги.Подписчик;
		
		ВыборкаАдресат = ВыборкаИтоги.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаАдресат.Следующий() Цикл
			
			МассивАдресовЭП.Очистить();
			МассивНомеровТелефонов.Очистить();
			МассивВидовКИДляПисем.Очистить();
			МассивВидовКИДляSMS.Очистить();
			
			ВыборкаДетали = ВыборкаАдресат.Выбрать();
			
			Пока ВыборкаДетали.Следующий() Цикл
				
				Если ПредназначенаДляЭлектронныхПисем Тогда
					РассылкиИОповещенияКлиентам.ДобавитьВМассив(МассивАдресовЭП, ВыборкаДетали.АдресЭП);
					РассылкиИОповещенияКлиентам.ДобавитьВМассив(МассивВидовКИДляПисем, ВыборкаДетали.ВидКонтактнойИнформацииДляПисем);
				КонецЕсли;
				Если ПредназначенаДляSMS Тогда
					РассылкиИОповещенияКлиентам.ДобавитьВМассив(МассивНомеровТелефонов, ВыборкаДетали.НомерТелефона);
					РассылкиИОповещенияКлиентам.ДобавитьВМассив(МассивВидовКИДляSMS, ВыборкаДетали.ВидКонтактнойИнформацииДляSMS);
				КонецЕсли;
				
				Если ВыборкаАдресат.АдресатПодписки = ВыборкаАдресат.Подписчик Тогда
					ТекстКому =  РассылкиИОповещенияКлиентам.ТекстКомуБудутОтправленыСообщения(ВыборкаДетали);
				КонецЕсли;
				
				ОтправлятьПартнеру = ВыборкаДетали.ОтправлятьПартнеру;
				Подписка = ВыборкаДетали.Подписка;
				
			КонецЦикла;
			
			Если ВыборкаАдресат.АдресатПодписки <> ВыборкаАдресат.Подписчик Тогда
				
				ОбластьСтрокаАдресатОбщее.Параметры.Адресат     = ВыборкаАдресат.АдресатПодписки;
				ОбластьСтрокаАдресатОбщее.Параметры.Расшифровка = Подписка;
				
				ТаблицаОтчета.Вывести(ОбластьСтрокаАдресатОбщее,2);
				
				Если ПредназначенаДляЭлектронныхПисем Тогда
					Email = РассылкиИОповещенияКлиентам.СтрокаАдресовИзМассива(МассивАдресовЭП, Символы.ПС);
					Если ПустаяСтрока(Email) Тогда
							ОбластьСтрокаАдресатЭлектроннаяПочта.Области.АдресатEmail.ЦветТекста = ЦветаСтиля.ПоясняющийОшибкуТекст;
							Email = НСтр("ru = 'не указаны'");
						Иначе
							ОбластьСтрокаАдресатЭлектроннаяПочта.Области.АдресатEmail.ЦветТекста =
						                                          ОбластьСтрокаПодписчикОбщее.Области.Подписчик.ЦветТекста;
					КонецЕсли;
					ОбластьСтрокаАдресатЭлектроннаяПочта.Параметры.Email = Email;
					ОбластьСтрокаАдресатЭлектроннаяПочта.Параметры.ВидКонтактнойИнформацииДляПисем =
					                      РассылкиИОповещенияКлиентам.СтрокаАдресовИзМассива(МассивВидовКИДляПисем, Символы.ПС);
					ОбластьСтрокаАдресатЭлектроннаяПочта.Параметры.Расшифровка = ВыборкаАдресат.АдресатПодписки;
					ТаблицаОтчета.Присоединить(ОбластьСтрокаАдресатЭлектроннаяПочта);
				КонецЕсли;
			
				Если ПредназначенаДляSMS Тогда
					Телефон = РассылкиИОповещенияКлиентам.СтрокаАдресовИзМассива(МассивНомеровТелефонов, Символы.ПС);
					Если ПустаяСтрока(Телефон) Тогда
						ОбластьСтрокаАдресатТелефон.Области.АдресатТелефон.ЦветТекста = ЦветаСтиля.ПоясняющийОшибкуТекст;
						Телефон = НСтр("ru = 'не указаны'");
					Иначе
						ОбластьСтрокаАдресатТелефон.Области.АдресатТелефон.ЦветТекста =
						                             ОбластьСтрокаПодписчикОбщее.Области.Подписчик.ЦветТекста;
					КонецЕсли;
					
					ОбластьСтрокаАдресатТелефон.Параметры.Телефон = Телефон;
					ОбластьСтрокаАдресатТелефон.Параметры.ВидКонтактнойИнформацииДляSMS =
					                     РассылкиИОповещенияКлиентам.СтрокаАдресовИзМассива(МассивВидовКИДляSMS, Символы.ПС);
					ОбластьСтрокаАдресатТелефон.Параметры.Расшифровка = ВыборкаАдресат.АдресатПодписки;
					ТаблицаОтчета.Присоединить(ОбластьСтрокаАдресатТелефон);
				КонецЕсли;
				
			Иначе
				
				ОбластьСтрокаПодписчикОбщее.Параметры.КомуБудутОтправленыСообщения = ТекстКому;
				ОбластьСтрокаПодписчикОбщее.Параметры.Расшифровка = Подписка;
				ТаблицаОтчета.Вывести(ОбластьСтрокаПодписчикОбщее, 1);
				
				Если ПредназначенаДляЭлектронныхПисем Тогда
					
					Email = РассылкиИОповещенияКлиентам.СтрокаАдресовИзМассива(МассивАдресовЭП, Символы.ПС);
					Если ПустаяСтрока(Email) Тогда
						Если ОтправлятьПартнеру Тогда
							ОбластьСтрокаПодписчикЭлектроннаяПочта.Области.ПодписчикEmail.ЦветТекста = ЦветаСтиля.ПоясняющийОшибкуТекст;
							Email = НСтр("ru = 'не указаны'");
						Иначе
							ОбластьСтрокаПодписчикЭлектроннаяПочта.Области.ПодписчикEmail.ЦветТекста = ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента;
							Email = НСтр("ru = '<не требуется>'");
						КонецЕсли;
					Иначе
						ОбластьСтрокаПодписчикЭлектроннаяПочта.Области.ПодписчикEmail.ЦветТекста =
						                                                   ОбластьСтрокаПодписчикОбщее.Области.Подписчик.ЦветТекста;
					КонецЕсли;
					
					ОбластьСтрокаПодписчикЭлектроннаяПочта.Параметры.Email = Email;
					
					Если ОтправлятьПартнеру Тогда
						ОбластьСтрокаПодписчикЭлектроннаяПочта.Области.ПодписчикВидКИДляПисем.ЦветТекста =
						                                                ОбластьСтрокаПодписчикОбщее.Области.Подписчик.ЦветТекста;
						ВидыКИ = РассылкиИОповещенияКлиентам.СтрокаАдресовИзМассива(МассивВидовКИДляПисем, Символы.ПС);
					Иначе
						ОбластьСтрокаПодписчикЭлектроннаяПочта.Области.ПодписчикВидКИДляПисем.ЦветТекста = ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента;
						ВидыКИ = НСтр("ru = '<не требуется>'");
					КонецЕсли;
					
					ОбластьСтрокаПодписчикЭлектроннаяПочта.Параметры.ВидКонтактнойИнформацииДляПисем = ВидыКИ;
					ОбластьСтрокаПодписчикЭлектроннаяПочта.Параметры.Расшифровка = ВыборкаАдресат.АдресатПодписки;
					ТаблицаОтчета.Присоединить(ОбластьСтрокаПодписчикЭлектроннаяПочта);
					
				КонецЕсли;
				Если ПредназначенаДляSMS Тогда
					
					Телефон = РассылкиИОповещенияКлиентам.СтрокаАдресовИзМассива(МассивНомеровТелефонов, Символы.ПС);
					Если ПустаяСтрока(Телефон) Тогда
						Если ОтправлятьПартнеру Тогда
							ОбластьСтрокаПодписчикТелефон.Области.ПодписчикТелефон.ЦветТекста = ЦветаСтиля.ПоясняющийОшибкуТекст;
							Телефон = НСтр("ru = 'не указаны'");
						Иначе
							ОбластьСтрокаПодписчикТелефон.Области.ПодписчикТелефон.ЦветТекста = ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента;
							Телефон = НСтр("ru = '<не требуется>'");
						КонецЕсли;
					Иначе
						ОбластьСтрокаПодписчикТелефон.Области.ПодписчикТелефон.ЦветТекста =
						                                             ОбластьСтрокаПодписчикОбщее.Области.Подписчик.ЦветТекста;
					КонецЕсли;
					
					ОбластьСтрокаПодписчикТелефон.Параметры.Телефон = Телефон;
					
					Если ОтправлятьПартнеру Тогда
						ОбластьСтрокаПодписчикТелефон.Области.ПодписчикВидКИДляSMS.ЦветТекста = 
						                                             ОбластьСтрокаПодписчикОбщее.Области.Подписчик.ЦветТекста;
						ВидыКИ = РассылкиИОповещенияКлиентам.СтрокаАдресовИзМассива(МассивВидовКИДляSMS, Символы.ПС);
					Иначе
						ОбластьСтрокаПодписчикТелефон.Области.ПодписчикВидКИДляSMS.ЦветТекста = ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента;
					КонецЕсли;
					
					ОбластьСтрокаПодписчикТелефон.Параметры.ВидКонтактнойИнформацииДляSMS = ВидыКИ;
					ОбластьСтрокаПодписчикТелефон.Параметры.Расшифровка = ВыборкаАдресат.АдресатПодписки;
					ТаблицаОтчета.Присоединить(ОбластьСтрокаПодписчикТелефон);
					
				КонецЕсли;
				
				ТаблицаОтчета.НачатьГруппуСтрок("Подписчик", Ложь);
				
			КонецЕсли;
			
		КонецЦикла;
		
		ТаблицаОтчета.ЗакончитьГруппуСтрок();
		НомерСтроки = НомерСтроки + 1;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПриостановитьПодписки(МассивПодписок)
	
	Справочники.ПодпискиНаРассылкиИОповещенияКлиентам.ОтменитьПодпискуДляМассива(МассивПодписок);
	СформироватьОтчет();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборПартнеровПоОтборуПриЗакрытии(АдресВоВременномХранилище, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(АдресВоВременномХранилище) Тогда
		ДобавитьПартнеровПоОтборуНаСервере(АдресВоВременномХранилище);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьПартнеровПоОтборуНаСервере(АдресВоВременномХранилище)
	
	РассылкиИОповещенияКлиентам.ДобавитьПодписчиковПоОтбору(АдресВоВременномХранилище, ГруппаРассылокИОповещений,
	                                                        ПредназначенаДляSMS, ПредназначенаДляЭлектронныхПисем);
	СформироватьОтчет();
	
КонецПроцедуры


#КонецОбласти

