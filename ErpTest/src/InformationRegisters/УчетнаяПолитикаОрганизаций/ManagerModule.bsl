#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Создает запись в регистре по переданным данным.
//
//	Параметры:
//		Организация 	- СправочникСсылка - ссылка на элемент справочника "Организации".
//		Период 			- Дата - Период записи регистра.
//		УчетнаяПолитика - СправочникСсылка - ссылка на элемент справочника "Учетные политики организаций".
//
Процедура СоздатьЗаписьРегистра(Знач Организация, Период, Знач УчетнаяПолитика) Экспорт
	
	Если Организация = Неопределено ИЛИ Организация = Справочники.Организации.ПустаяСсылка() Тогда
		Возврат;
	КонецЕсли;
	
	НоваяЗапись = РегистрыСведений.УчетнаяПолитикаОрганизаций.СоздатьМенеджерЗаписи();
	
	НоваяЗапись.Организация 	= Организация;
	НоваяЗапись.Период 			= Период;
	НоваяЗапись.УчетнаяПолитика = УчетнаяПолитика;
	
	НоваяЗапись.Записать();
	
КонецПроцедуры


// Возвращает структуру параметров действующей для организации учетной политики.
//
// Параметры:
//	Организация - СправочникСсылка - ссылка на элемент справочника "Организации".
//	Период 		- Дата - дата, на которую необходимо получить действующую учетную политику.
//
// Возвращаемое значение:
//	Структура
//		Ключ - имя реквизита справочника УчетныеПолитикиОрганизаций или имя реквизита регистра сведений УчетнаяПолитикаОрганизаций
//		Значение - значение реквизита
//
Функция ПараметрыУчетнойПолитики(Организация, Период = Неопределено) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		СтруктураПараметров = СтруктураПараметровПоУмолчанию();
	Иначе
		СтруктураПараметров = УчетныеПолитикиОрганизаций(Организация, Период, Истина);
	КонецЕсли;
	
	Возврат СтруктураПараметров;
	
КонецФункции

// Возвращает таблицу параметров действующих учетных политик для указанных организаций.
//
// Параметры:
//	Организации 				 - Массив, СправочникСсылка.Организации - организации для получения учетных политик.
//	Период 						 - Дата - дата, на которую необходимо получить действующие учетные политики.
//	СтруктураДляОднойОрганизации - Булево - возвращать результат в виде структуры, если передан отбор из одной организации
//
// Возвращаемое значение:
//	ТаблицаЗначений с колонками
//		Организация
//		Наименование - наименование политики
//		УчетнаяПолитикаСуществует - признак того, что учетная политика для организации назначена
//		<Имя реквизита справочника УчетныеПолитикиОрганизаций>
//		<Имя ресурса регистра сведений УчетнаяПолитикаОрганизаций>
// или Структура с аналогичными ключами, если СтруктураДляОднойОрганизации = Истина
//
Функция УчетныеПолитикиОрганизаций(Организации = Неопределено, Период = Неопределено, СтруктураДляОднойОрганизации = Ложь) Экспорт
	
	// Сформируем структуру параметров политики по умолчанию.
	СтруктураПараметров = СтруктураПараметровПоУмолчанию();
	
	Запрос 			    = Новый Запрос;
	ПоляЗапроса 	    = Новый Массив;
	ФиксированныеПоля   = Новый Структура("Наименование, УчетнаяПолитикаСуществует, Организация, ЮрФизЛицо");
	
	Для Каждого КлючИЗначение Из СтруктураПараметров Цикл
		Если ФиксированныеПоля.Свойство(КлючИЗначение.Ключ) Тогда
			Продолжить; // поле в явном виде прописано в запросе
		ИначеЕсли Метаданные.Справочники.УчетныеПолитикиОрганизаций.Реквизиты.Найти(КлючИЗначение.Ключ) <> Неопределено Тогда
			ПоляЗапроса.Добавить("УчетныеПолитики." + КлючИЗначение.Ключ);
		ИначеЕсли Метаданные.РегистрыСведений.УчетнаяПолитикаОрганизаций.Ресурсы.Найти(КлючИЗначение.Ключ) <> Неопределено Тогда
			ПоляЗапроса.Добавить("ДанныеРегистра." + КлючИЗначение.Ключ);
		ИначеЕсли ОбщегоНазначения.ЭтоСтандартныйРеквизит(Метаданные.Справочники.УчетныеПолитикиОрганизаций.СтандартныеРеквизиты, КлючИЗначение.Ключ) Тогда
			ПоляЗапроса.Добавить("УчетныеПолитики." + КлючИЗначение.Ключ);
		Иначе // рассчитываемое значение по умолчанию
			ПоляЗапроса.Добавить("&" + КлючИЗначение.Ключ + " КАК " + КлючИЗначение.Ключ);
			Запрос.УстановитьПараметр(КлючИЗначение.Ключ, КлючИЗначение.Значение);
		КонецЕсли;
	КонецЦикла;
	
	// Получим параметры учетных политик организаций.
	ПериодПолитики = НачалоМесяца(?(ЗначениеЗаполнено(Период), Период, ТекущаяДатаСеанса()));
	
	ОтборОрганизации = ?(ЗначениеЗаполнено(Организации),
		ОбщегоНазначенияУТКлиентСервер.Массив(Организации),
		Справочники.Организации.ДоступныеОрганизации(Истина));
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВЫБОР КОГДА УчетныеПолитики.Ссылка ЕСТЬ NULL
	|		ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ 				  		 КАК УчетнаяПолитикаСуществует,
	|	Организации.Ссылка    		 КАК Организация,
	|	Организации.ЮрФизЛицо 		 КАК ЮрФизЛицо,
	|	УчетныеПолитики.Наименование КАК Наименование,
	|	УчетныеПолитики.*
	|ИЗ
	|	Справочник.Организации КАК Организации
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.УчетнаяПолитикаОрганизаций.СрезПоследних(
	|	  &Период, Организация В (&ОтборОрганизации)) КАК ДанныеРегистра
	|		ПО Организации.Ссылка = ДанныеРегистра.Организация
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.УчетныеПолитикиОрганизаций КАК УчетныеПолитики
	|			ПО ДанныеРегистра.УчетнаяПолитика = УчетныеПолитики.Ссылка
	|ГДЕ
	|	Организации.Ссылка В (&ОтборОрганизации)";
	
	Запрос.Текст = СтрЗаменить(
		Запрос.Текст,
		"УчетныеПолитики.*",
		СтрСоединить(ПоляЗапроса, "," + Символы.ПС + "	"));
	
	Запрос.УстановитьПараметр("Период", 	 	  ПериодПолитики);
	Запрос.УстановитьПараметр("ОтборОрганизации", ОтборОрганизации);
	
	ТаблицаОрганизаций = Запрос.Выполнить().Выгрузить();
	
	// Скорректируем параметры.
	Для Каждого ТекСтр Из ТаблицаОрганизаций Цикл
		
		Если НЕ ТекСтр.УчетнаяПолитикаСуществует Тогда
			
			// Заполним параметры политики по умолчанию.
			ЗаполнитьЗначенияСвойств(ТекСтр, СтруктураПараметров);
			
		Иначе
			
			// Скорректируем некорректные значения параметров из справочника.
			СкорректироватьЗависимыеПараметрыУчетнойПолитики(ТекСтр, ПериодПолитики);
			
			// Скорректируем кэшируемые параметры политики из регистра.
			ЗаполнитьЗначенияСвойств(ТекСтр, СформироватьКэшируемыеПараметрыУчетнойПолитики(ТекСтр, ТекСтр));
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если ОтборОрганизации.Количество() = 1 И СтруктураДляОднойОрганизации Тогда
		
		ЗаполнитьЗначенияСвойств(СтруктураПараметров, ТаблицаОрганизаций[0]);
		
		Возврат СтруктураПараметров;
		
	КонецЕсли;
	
	ТаблицаОрганизаций.Индексы.Добавить("Организация");
	
	Возврат ТаблицаОрганизаций;
	
КонецФункции

// Создает временную таблицу, содержащую параметры действующих учетных политик для указанных организаций.
// Поля временной таблицы совпадают с полями таблицы, возвращаемой функцией УчетныеПолитикиОрганизаций().
//
// Параметры:
//	ЗапросИлиМенеджерВТ - Запрос, МенеджерВременныхТаблиц - источник менеджера временных таблиц
//	Организации 		- Массив, СправочникСсылка.Организации - организации для получения учетных политик.
//	Период 				- Дата - дата, на которую необходимо получить действующие учетные политики.
//  ИмяТаблицы 			- Строка - имя создаваемой таблицы, по умолчанию ВТУчетныеПолитикиОрганизаций
//
Процедура СформироватьВТУчетныеПолитикиОрганизаций(ЗапросИлиМенеджерВТ, Организации = Неопределено, Период = Неопределено, ИмяТаблицы = "") Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	*
	|ПОМЕСТИТЬ ВТУчетныеПолитикиОрганизаций
	|ИЗ
	|	&ТаблицаУчетныеПолитики КАК Т";
	
	Запрос.УстановитьПараметр("ТаблицаУчетныеПолитики", УчетныеПолитикиОрганизаций(Организации, Период));
	
	Если ТипЗнч(ЗапросИлиМенеджерВТ) = Тип("Запрос") Тогда
		Запрос.МенеджерВременныхТаблиц = ЗапросИлиМенеджерВТ.МенеджерВременныхТаблиц;
	Иначе
		Запрос.МенеджерВременныхТаблиц = ЗапросИлиМенеджерВТ;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИмяТаблицы) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ВТУчетныеПолитикиОрганизаций", ИмяТаблицы);
	Иначе
		ИмяТаблицы = "ВТУчетныеПолитикиОрганизаций";
	КонецЕсли;
	
	УниверсальныеМеханизмыПартийИСебестоимости.УничтожитьВременныеТаблицы(Запрос, ИмяТаблицы);
	
	Запрос.Выполнить();
	
КонецПроцедуры


// Функции для получение отдельных реквизитов учетной политики:

// Возвращает массив организаций, у которых установлен указанный параметр учетной политики.
//
// Параметры:
//	ИмяПараметра 	  - Строка - имя параметра учетной политики, см. результат функции ПараметрыУчетнойПолитики()
//	ЗначениеПараметра - Произвольный - значение указанного параметра учетной политики
//	Организации 	  - Массив, СправочникСсылка.Организации - организации для проверки учетных политик
//	Период 			  - Дата - дата, на которую необходимо проверить учетные политики
//
// Возвращаемое значение:
//	Массив - подмножество параметра Организации, с установленным параметров мучетной политики.
//
Функция ОрганизацииСЗаданнымПараметромПолитики(ИмяПараметра, ЗначениеПараметра,
			Организации = Неопределено, Период = Неопределено) Экспорт
	
	Результат = Новый Массив;
	
	УчетныеПолитики = УчетныеПолитикиОрганизаций(Организации, Период);
	
	Для Каждого ПараметрыУчетнойПолитики Из УчетныеПолитики Цикл
		
		Если ПараметрыУчетнойПолитики[ИмяПараметра] = ЗначениеПараметра Тогда
			Результат.Добавить(ПараметрыУчетнойПолитики.Организация);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Возвращает признак использования раздельного учета товаров по налогообложению НДС. 
//
// Параметры:
// 	Организация - СправочникСсылка.Организации - Организация, для которой необходимо получить признак учетной политики
// 	Период 		- Дата, Неопределено - Дата действия учетной политики, если Неопределено, то на текущую дату
//
// Возвращаемое значение:
// 	Результат - Булево - Значение признака
// 
Функция РаздельныйУчетТоваровПоНалогообложениюНДС(Организация, Период = Неопределено) Экспорт
	
	ПараметрыПолитики = ПараметрыУчетнойПолитики(Организация, Период);
	
	Возврат ПараметрыПолитики.РаздельныйУчетТоваровПоНалогообложениюНДС;
	
КонецФункции


#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает реквизиты справочника УчетныеПолитикиОрганизаций, кэшируемые в ресурсах регистра УчетнаяПолитикаОрганизаций.
// Используется при записи регистра.
//
Функция СформироватьКэшируемыеПараметрыУчетнойПолитики(ПоляУчетнойПолитики, ПоляОрганизации = Неопределено) Экспорт
	
	Если ТипЗнч(ПоляУчетнойПолитики) = Тип("СправочникСсылка.УчетныеПолитикиОрганизаций") Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	УчетныеПолитики.*
		|ИЗ
		|	Справочник.УчетныеПолитикиОрганизаций КАК УчетныеПолитики
		|ГДЕ
		|	УчетныеПолитики.Ссылка = &Ссылка";

		Запрос.УстановитьПараметр("Ссылка", ПоляУчетнойПолитики);
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			ИсточникПолейУчетнойПолитики = Выборка;
		Иначе
			ИсточникПолейУчетнойПолитики = Неопределено;
		КонецЕсли;
		
	Иначе
		ИсточникПолейУчетнойПолитики = ПоляУчетнойПолитики;
	КонецЕсли;
	
	Если ТипЗнч(ПоляОрганизации) = Тип("СправочникСсылка.Организации") Тогда
		ИсточникПолейОрганизации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ПоляОрганизации, "ЮрФизЛицо");
		ИсточникПолейОрганизации.Вставить("Организация", ПоляОрганизации);
	ИначеЕсли ТипЗнч(ПоляОрганизации) = Тип("СправочникОбъект.Организации") Тогда
		ИсточникПолейОрганизации = Новый Структура;
		ИсточникПолейОрганизации.Вставить("ЮрФизЛицо", 	 ПоляОрганизации.ЮрФизЛицо);
		ИсточникПолейОрганизации.Вставить("Организация", ПоляОрганизации.Ссылка);
	Иначе
		ИсточникПолейОрганизации = ПоляОрганизации;
	КонецЕсли;
	
	Параметры = Новый Структура;
	Параметры.Вставить("ПлательщикЕНВД", 				      Ложь);
	Параметры.Вставить("ПлательщикНалогаНаПрибыль", 	      Ложь);
	Параметры.Вставить("ПрименяетсяПБУ18", 				      Ложь);
	Параметры.Вставить("ПрименяетсяУСН", 				      Ложь);
	Параметры.Вставить("ПрименяетсяУСНДоходыМинусРасходы",    Ложь);
	
	ЭтоУправленческаяОрганизация =
		ИсточникПолейОрганизации <> Неопределено
		И ИсточникПолейОрганизации.Организация = Справочники.Организации.УправленческаяОрганизация;
	ЭтоЮрФизЛицо = 
		ИсточникПолейОрганизации <> Неопределено
		И ИсточникПолейОрганизации.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицо;
	
	Если ИсточникПолейУчетнойПолитики <> Неопределено И НЕ ЭтоУправленческаяОрганизация Тогда
		
		Параметры.ПлательщикЕНВД =
			ИсточникПолейУчетнойПолитики.ПрименяетсяЕНВД;
		Параметры.ПлательщикНалогаНаПрибыль =
			ИсточникПолейУчетнойПолитики.СистемаНалогообложения <> Перечисления.СистемыНалогообложения.Упрощенная 
			И ЭтоЮрФизЛицо;
		Параметры.ПрименяетсяПБУ18 =
			ИсточникПолейУчетнойПолитики.ПрименяетсяПБУ18;
		Параметры.ПрименяетсяУСН =
			ИсточникПолейУчетнойПолитики.СистемаНалогообложения = Перечисления.СистемыНалогообложения.Упрощенная;
		Параметры.ПрименяетсяУСНДоходыМинусРасходы =
			ИсточникПолейУчетнойПолитики.ОбъектНалогообложенияУСН = Перечисления.ОбъектыНалогообложенияПоУСН.ДоходыМинусРасходы;
		
	КонецЕсли;
	
	Возврат Параметры;
	
КонецФункции

// Изменяет значения "зависимых" параметров политики в зависимости от других параметров этой политики И ФО.
//
Процедура СкорректироватьЗависимыеПараметрыУчетнойПолитики(СтруктураПараметров, Период = Неопределено) Экспорт
	
	ИдетЗаписьПолитики 	   = (ТипЗнч(СтруктураПараметров) = Тип("СправочникОбъект.УчетныеПолитикиОрганизаций"));
	ПериодПолитики		   = НачалоМесяца(?(ЗначениеЗаполнено(Период), Период, ТекущаяДатаСеанса()));
	ПартионныйУчетВерсии22 = УниверсальныеМеханизмыПартийИСебестоимостиПовтИсп.ПартионныйУчетВерсии22(ПериодПолитики);
	
	Если СтруктураПараметров.СистемаНалогообложения = Перечисления.СистемыНалогообложения.Упрощенная
	 И СтруктураПараметров.РаздельныйУчетТоваровПоНалогообложениюНДС Тогда
		СтруктураПараметров.РаздельныйУчетТоваровПоНалогообложениюНДС = Ложь;
	ИначеЕсли СтруктураПараметров.СистемаНалогообложения = Перечисления.СистемыНалогообложения.Общая
	 И СтруктураПараметров.ПрименяетсяЕНВД
	 И НЕ СтруктураПараметров.РаздельныйУчетТоваровПоНалогообложениюНДС Тогда
		СтруктураПараметров.РаздельныйУчетТоваровПоНалогообложениюНДС = Истина;
	КонецЕсли;
	 
	Если НЕ СтруктураПараметров.РаздельныйУчетТоваровПоНалогообложениюНДС
	 ИЛИ СтруктураПараметров.МетодОценкиСтоимостиТоваров <> Перечисления.МетодыОценкиСтоимостиТоваров.ФИФОСкользящаяОценка
	 ИЛИ (НЕ ИдетЗаписьПолитики И НЕ ПартионныйУчетВерсии22) Тогда
 		УстановитьЗначениеПараметраПоУмолчанию(СтруктураПараметров, "РаздельныйУчетПостатейныхПроизводственныхЗатратПоНалогообложениюНДС");
	КонецЕсли;
	
	Если НЕ СтруктураПараметров.РаздельныйУчетТоваровПоНалогообложениюНДС
	 ИЛИ НЕ СтруктураПараметров.РаздельныйУчетПостатейныхПроизводственныхЗатратПоНалогообложениюНДС
	 ИЛИ СтруктураПараметров.МетодОценкиСтоимостиТоваров <> Перечисления.МетодыОценкиСтоимостиТоваров.ФИФОСкользящаяОценка
	 ИЛИ (НЕ ИдетЗаписьПолитики И НЕ ПартионныйУчетВерсии22) Тогда
	 	УстановитьЗначениеПараметраПоУмолчанию(СтруктураПараметров, "УчетНДСДлительногоЦиклаПроизводства");
	КонецЕсли;
	
	Если НЕ СтруктураПараметров.РаздельныйУчетТоваровПоНалогообложениюНДС
	 ИЛИ СтруктураПараметров.ПрименяетсяОсвобождениеОтУплатыНДС Тогда
	 	УстановитьЗначениеПараметраПоУмолчанию(СтруктураПараметров, "ПрименяетсяУчетНДСПоФактическомуИспользованию");
	 	УстановитьЗначениеПараметраПоУмолчанию(СтруктураПараметров, "Учитывать5ПроцентныйПорог");
	КонецЕсли;
	
	Если НЕ СтруктураПараметров.РаздельныйУчетТоваровПоНалогообложениюНДС Тогда
		УстановитьЗначениеПараметраПоУмолчанию(СтруктураПараметров, "ВариантУчетаНДСПриИзмененииВидаДеятельности");
	КонецЕсли;
	
	Если НЕ СтруктураПараметров.РаздельныйУчетТоваровПоНалогообложениюНДС
	 ИЛИ СтруктураПараметров.ВариантУчетаНДСПриИзмененииВидаДеятельности = Перечисления.ВариантыУчетаНДСПриИзмененииВидаДеятельностиНаНеоблагаемую.ВключатьВСтоимость
	 ИЛИ СтруктураПараметров.СистемаНалогообложения = Перечисления.СистемыНалогообложения.Упрощенная Тогда
	 	УстановитьЗначениеПараметраПоУмолчанию(СтруктураПараметров, "СтатьяРасходовНеНДС");
	 	УстановитьЗначениеПараметраПоУмолчанию(СтруктураПараметров, "АналитикаРасходовНеНДС");
	КонецЕсли;
	
	Если НЕ СтруктураПараметров.РаздельныйУчетТоваровПоНалогообложениюНДС
	 ИЛИ НЕ СтруктураПараметров.ПрименяетсяЕНВД
	 ИЛИ СтруктураПараметров.ВариантУчетаНДСПриИзмененииВидаДеятельности = Перечисления.ВариантыУчетаНДСПриИзмененииВидаДеятельностиНаНеоблагаемую.ВключатьВСтоимость
	 ИЛИ СтруктураПараметров.СистемаНалогообложения = Перечисления.СистемыНалогообложения.Упрощенная Тогда
	 	УстановитьЗначениеПараметраПоУмолчанию(СтруктураПараметров, "СтатьяРасходовЕНВД");
	 	УстановитьЗначениеПараметраПоУмолчанию(СтруктураПараметров, "АналитикаРасходовЕНВД");
	КонецЕсли;
	
	// Значения по умолчанию, зависящие от параметров учетной политики.
	Если НЕ ИдетЗаписьПолитики
		И (СтруктураПараметров.ПрименяетсяОсвобождениеОтУплатыНДС
	 		ИЛИ СтруктураПараметров.СистемаНалогообложения = Перечисления.СистемыНалогообложения.Упрощенная) Тогда
		СтруктураПараметров.НалогообложениеНДСПоУмолчанию = Перечисления.ТипыНалогообложенияНДС.ПродажаНеОблагаетсяНДС;
 	КонецЕсли;
 	
КонецПроцедуры

// Устанавливает значение указанного реквизита учетной политики значением по умолчанию, как оно задано в конфигурации.
//
Процедура УстановитьЗначениеПараметраПоУмолчанию(СтруктураПараметров, ИмяРеквизита)
	
	Реквизит = Метаданные.Справочники.УчетныеПолитикиОрганизаций.Реквизиты[ИмяРеквизита];
	
	СтруктураПараметров[ИмяРеквизита] = Реквизит.Тип.ПривестиЗначение(Реквизит.ЗначениеЗаполнения);
	
КонецПроцедуры

// Возвращает структуру со значениями параметров учетной политики по умолчанию.
//
Функция СтруктураПараметровПоУмолчанию()
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("УчетнаяПолитикаСуществует", Ложь);
	
	Для Каждого Реквизит Из Метаданные.Справочники.УчетныеПолитикиОрганизаций.СтандартныеРеквизиты Цикл
		СтруктураПараметров.Вставить(Реквизит.Имя, Реквизит.Тип.ПривестиЗначение(Реквизит.ЗначениеЗаполнения));
	КонецЦикла;
	
	Для Каждого Реквизит Из Метаданные.Справочники.УчетныеПолитикиОрганизаций.Реквизиты Цикл
		СтруктураПараметров.Вставить(Реквизит.Имя, Реквизит.Тип.ПривестиЗначение(Реквизит.ЗначениеЗаполнения));
	КонецЦикла;
	
	Для Каждого Ресурс Из Метаданные.РегистрыСведений.УчетнаяПолитикаОрганизаций.Ресурсы Цикл
		
		Если Ресурс = Метаданные.РегистрыСведений.УчетнаяПолитикаОрганизаций.Ресурсы.УчетнаяПолитика
		 ИЛИ СтруктураПараметров.Свойство(Ресурс.Имя) Тогда
			Продолжить;
		КонецЕсли;
			
		СтруктураПараметров.Вставить(Ресурс.Имя, Ресурс.Тип.ПривестиЗначение(Ресурс.ЗначениеЗаполнения));
		
	КонецЦикла;
	
	// Значения по умолчанию. Не хранятся в ИБ, а рассчитываются при необходимости.
	СтруктураПараметров.Вставить("НалогообложениеНДСПоУмолчанию", Перечисления.ТипыНалогообложенияНДС.ПродажаОблагаетсяНДС);
	
	Возврат СтруктураПараметров;
	
КонецФункции

#КонецОбласти

#КонецЕсли
