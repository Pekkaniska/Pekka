////////////////////////////////////////////////////////////////////////////////
// Подсистема "Интеграция с СППР"
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Создает прокси веб-сервиса СППР. В случае ошибки вызывается исключение.
//
// Возвращаемое значение:
//	WSПрокси - Прокси веб-сервиса
//
Функция ПолучитьПрокси() Экспорт

	МестоположениеWSDL = Константы.АдресВебСервисаСППР.Получить();
	
	Если ПустаяСтрока(МестоположениеWSDL) Тогда
		ВызватьИсключение 
			НСтр("ru = 'Ошибка подключения к СППР.
					|
					|В параметрах соединения не указан URL информационной базы СППР.'");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(МестоположениеWSDL) И 
		Прав(МестоположениеWSDL, 1) <> "/" И Прав(МестоположениеWSDL, 1) <> "\" Тогда
		МестоположениеWSDL = МестоположениеWSDL + "/";
	КонецЕсли;
	МестоположениеWSDL = МестоположениеWSDL + "ws/FunctionModel.1cws?wsdl";
	
	УстановитьПривилегированныйРежим(Истина);
	ПарольИЛогин = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(ВладелецЛогинаИПароля(), "Пароль, Логин");
	УстановитьПривилегированныйРежим(Ложь);
	
	ИмяПользователя = ПарольИЛогин.Логин;
	Пароль = ПарольИЛогин.Пароль;
	
	Если ПустаяСтрока(ИмяПользователя) Тогда
		ВызватьИсключение 
			НСтр("ru = 'Ошибка подключения к СППР.
					|
					|В параметрах соединения не указан пользователь.'");
	КонецЕсли;
	
	Попытка
		
		Определение = Новый WSОпределения(
			МестоположениеWSDL, 
			ИмяПользователя,
			Пароль,,
			7);
		
		Прокси = Новый WSПрокси(
			Определение,
			"http://www.1c.ru/SPPR/FunctionModel",
			"FunctionModel",
			"FunctionModelSoap",,
			20);
			
	Исключение	
		ПодробноеПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Интеграция с СППР'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Ошибка,,, 
			ПодробноеПредставлениеОшибки);
			
		ВызватьИсключение НСтр("ru = 'Ошибка подключения к СППР.
								|
								|Возможно не прошла авторизация, указан неверный адрес веб-сервиса 
								|или база СППР не опубликована на веб-сервере.
								|
								|Подробности в журнале регистрации.'");
		
	КонецПопытки;
		
	Прокси.Пользователь = ИмяПользователя;
	Прокси.Пароль = Пароль;
	
	Возврат Прокси;
	
КонецФункции

// Добавляет в форму команды для интеграции с СППР
//
// Параметры:
//  Форма					- УправляемаяФорма - Форма в которой нужно разместить команды СППР
//  ДополнительныеПараметры	- Структура - Дополнительные параметры, которые могут содержать место размещения команд
//											Если место размещения команд не указано, то команды будут размещены в командной панели,
//											содержащей команду справки.
//
Процедура ДобавитьКомандыИнтеграцииССППР(Форма, ДополнительныеПараметры = Неопределено) Экспорт

	Если НеТребуютсяКомандыИнтеграцииССППР(Форма) Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеПараметры <> Неопределено 
		И ДополнительныеПараметры.Свойство("РазмещениеКомандСППР") Тогда
		РазмещениеКоманд = ДополнительныеПараметры.РазмещениеКомандСППР;
	Иначе
		РазмещениеКоманд = ОпределитьРазмещениеКоманд(Форма);
	КонецЕсли; 
	
	// В форме отчета команда размещается во всех действиях, иначе ее не видно
	ТолькоВоВсехДействиях = (Найти(Форма.ИмяФормы, "Отчет.") <> 0);
	
	НомерКоманды = 1;
	Для каждого МестоРазмещенияКоманд Из РазмещениеКоманд Цикл
		ДобавитьКомандуФункциональнойМодели(
				Форма, 
				МестоРазмещенияКоманд, 
				НомерКоманды, 
				ТолькоВоВсехДействиях, 
				"Подключаемый_ВыполнитьПереопределяемуюКоманду");
				
		НомерКоманды = НомерКоманды + 1;
	КонецЦикла; 
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ЭкспортныеСлужебныеПроцедурыИФункции

// Возвращает список функций СППР
//
// Параметры:
//  ВебСервис	- WSПрокси - веб-сервис.
//
// Возвращаемое значение:
//   ДеревоЗначений   - Список функций в виде дерева значений.
//
Функция СписокФункций(ВебСервис = Неопределено) Экспорт
	
	СписокФункций = Новый ДеревоЗначений;
	СписокФункций.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(100)));
	СписокФункций.Колонки.Добавить("ИД", Новый ОписаниеТипов("УникальныйИдентификатор"));
	СписокФункций.Колонки.Добавить("Схема");
	СписокФункций.Колонки.Добавить("КонечнаяФункция", Новый ОписаниеТипов("Булево"));
	СписокФункций.Колонки.Добавить("ЭлементыСхемы", Новый ОписаниеТипов("ТаблицаЗначений"));
	СписокФункций.Колонки.Добавить("ФормыРабочегоМеста", Новый ОписаниеТипов("ТаблицаЗначений"));
	
	Если ВебСервис = Неопределено Тогда
		ВебСервис = ИнтеграцияССППРПовтИсп.ПолучитьПрокси();
	КонецЕсли; 
	
	Проект = Константы.ПроектСППР.Получить();
	Если ПустаяСтрока(Проект) Тогда
		
		ВызватьИсключение 
			НСтр("ru = 'Ошибка подключения к СППР.
					|
					|В настройках интеграции с СППР не указан проект.'");
	
	КонецЕсли;
 
	СписокФункцийПроекта = ВебСервис.GetListOfFunctions(Проект);
	Если СписокФункцийПроекта <> Неопределено Тогда
		ТаблицаФункций = Новый ТаблицаЗначений;
		ТаблицаФункций.Колонки.Добавить("ИД", Новый ОписаниеТипов("УникальныйИдентификатор"));
		ТаблицаФункций.Колонки.Добавить("ИД_родитель", Новый ОписаниеТипов("УникальныйИдентификатор"));
		ТаблицаФункций.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(100)));
		
		Для каждого ДанныеФункции Из СписокФункцийПроекта.FunctionDescription Цикл
			ДанныеСтроки = ТаблицаФункций.Добавить();
			ДанныеСтроки.ИД = ДанныеФункции.ID;
			ДанныеСтроки.ИД_родитель = ДанныеФункции.ID_Parent;
			ДанныеСтроки.Представление = ДанныеФункции.Name;
		КонецЦикла; 
		
		ТаблицаФункций.Индексы.Добавить("ИД_родитель");
		
		ТекущиеЭлементы = СписокФункций.Строки;
		
		ИД_родитель = Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000");
		ЗаполнитьСписокФункцийРекурсивно(ТаблицаФункций, ИД_родитель, ТекущиеЭлементы);
	КонецЕсли; 
	
	Возврат СписокФункций;
	
КонецФункции

// Возвращает список объектов СППР
//
// Параметры:
//  ВебСервис	- WSПрокси - веб-сервис.
//
// Возвращаемое значение:
//   ДеревоЗначений   - список объектов в виде дерева значений.
//
Функция СписокОбъектов(ВебСервис = Неопределено) Экспорт
	
	СписокОбъектов = Новый ДеревоЗначений;
	СписокОбъектов.Колонки.Добавить("ИД", Новый ОписаниеТипов("УникальныйИдентификатор"));
	СписокОбъектов.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(100)));
	СписокОбъектов.Колонки.Добавить("ОписаниеHTML", Новый ОписаниеТипов("Строка"));
	СписокОбъектов.Колонки.Добавить("ЭтоПапка", Новый ОписаниеТипов("Булево"));
	СписокОбъектов.Колонки.Добавить("ЭтоГруппаОбъектов", Новый ОписаниеТипов("Булево"));
	СписокОбъектов.Колонки.Добавить("ОписаниеПодготовлено", Новый ОписаниеТипов("Булево"));
	
	Если ВебСервис = Неопределено Тогда
		ВебСервис = ИнтеграцияССППРПовтИсп.ПолучитьПрокси();
	КонецЕсли; 
	
	Проект = Константы.ПроектСППР.Получить();
	
	СписокОбъектовПроекта = ВебСервис.GetListOfObjects(Проект);
	Если СписокОбъектовПроекта <> Неопределено Тогда
		ТаблицаОбъектов = Новый ТаблицаЗначений;
		ТаблицаОбъектов.Колонки.Добавить("ИД", Новый ОписаниеТипов("УникальныйИдентификатор"));
		ТаблицаОбъектов.Колонки.Добавить("ИД_родитель", Новый ОписаниеТипов("УникальныйИдентификатор"));
		ТаблицаОбъектов.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(100)));
		ТаблицаОбъектов.Колонки.Добавить("ЭтоПапка", Новый ОписаниеТипов("Булево"));
		ТаблицаОбъектов.Колонки.Добавить("ЭтоГруппаОбъектов", Новый ОписаниеТипов("Булево"));
		                                         
		Для каждого ДанныеОбъекта Из СписокОбъектовПроекта.ObjectDescription Цикл
			ДанныеСтроки = ТаблицаОбъектов.Добавить();
			ДанныеСтроки.ИД = ДанныеОбъекта.ID;
			ДанныеСтроки.ИД_родитель = ДанныеОбъекта.ID_Parent;
			ДанныеСтроки.Представление = ДанныеОбъекта.Name;
			ДанныеСтроки.ЭтоПапка = ДанныеОбъекта.IsFolder;
			ДанныеСтроки.ЭтоГруппаОбъектов = ДанныеОбъекта.IsGroup;
		КонецЦикла; 
		
		ТаблицаОбъектов.Индексы.Добавить("ИД_родитель");
		
		ТекущиеЭлементы = СписокОбъектов.Строки;
		
		ИД_родитель = Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000");
		ЗаполнитьСписокОбъектовРекурсивно(ТаблицаОбъектов, ИД_родитель, ТекущиеЭлементы);
	КонецЕсли; 
	
	Возврат СписокОбъектов;

КонецФункции

// Возвращает список профилей пользователей СППР
//
// Параметры:
//  ВебСервис	- WSПрокси - веб-сервис.
//
// Возвращаемое значение:
//   ДеревоЗначений   - список профилей пользователей в виде дерева значений.
//
Функция СписокПрофилей(ВебСервис = Неопределено) Экспорт

	СписокПрофилей = Новый ДеревоЗначений;
	СписокПрофилей.Колонки.Добавить("ИД", Новый ОписаниеТипов("УникальныйИдентификатор"));
	СписокПрофилей.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(100)));
	СписокПрофилей.Колонки.Добавить("ОписаниеHTML", Новый ОписаниеТипов("Строка"));
	СписокПрофилей.Колонки.Добавить("ЭтоПапка", Новый ОписаниеТипов("Булево"));
	СписокПрофилей.Колонки.Добавить("ОписаниеПодготовлено", Новый ОписаниеТипов("Булево"));
	
	Если ВебСервис = Неопределено Тогда
		ВебСервис = ИнтеграцияССППРПовтИсп.ПолучитьПрокси();
	КонецЕсли; 
	
	Проект = Константы.ПроектСППР.Получить();
	
	СписокПрофилейПроекта = ВебСервис.GetListOfPerformers(Проект);
	Если СписокПрофилейПроекта <> Неопределено Тогда
		ТаблицаПрофилей = Новый ТаблицаЗначений;
		ТаблицаПрофилей.Колонки.Добавить("ИД", Новый ОписаниеТипов("УникальныйИдентификатор"));
		ТаблицаПрофилей.Колонки.Добавить("ИД_родитель", Новый ОписаниеТипов("УникальныйИдентификатор"));
		ТаблицаПрофилей.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(100)));
		ТаблицаПрофилей.Колонки.Добавить("ЭтоПапка", Новый ОписаниеТипов("Булево"));
		ТаблицаПрофилей.Колонки.Добавить("ЭтоГруппаОбъектов", Новый ОписаниеТипов("Булево"));
		                                         
		Для каждого ОписаниеПрофиля Из СписокПрофилейПроекта.PerformerDescription Цикл
			ДанныеСтроки = ТаблицаПрофилей.Добавить();
			ДанныеСтроки.ИД = ОписаниеПрофиля.ID;
			ДанныеСтроки.ИД_родитель = ОписаниеПрофиля.ID_Parent;
			ДанныеСтроки.Представление = ОписаниеПрофиля.Name;
			ДанныеСтроки.ЭтоПапка = ОписаниеПрофиля.IsFolder;
		КонецЦикла; 
		
		ТаблицаПрофилей.Индексы.Добавить("ИД_родитель");
		
		ТекущиеЭлементы = СписокПрофилей.Строки;
		
		ИД_родитель = Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000");
		ЗаполнитьСписокПрофилейРекурсивно(ТаблицаПрофилей, ИД_родитель, ТекущиеЭлементы);
	КонецЕсли; 
	
	Возврат СписокПрофилей;

КонецФункции

// Возвращает данные функции
//
// Параметры:
//  ИДФункции	- Тип - Уникальный идентификатор ссылки на функцию.
//
// Возвращаемое значение:
//   ПакетXDTO	- Пакет XDTO, содержащий данные функции.
//
Функция ДанныеФункции(ИДФункции) Экспорт

	ВебСервис = ИнтеграцияССППРПовтИсп.ПолучитьПрокси();
	
	ДанныеФункции = ВебСервис.GetFunction(ИДФункции);
	
	Возврат ДанныеФункции;

КонецФункции

// Возвращает описание объекта в формате HTML
//
// Параметры:
//  ИДОбъекта	- Тип - Уникальный идентификатор ссылки на объект.
//
// Возвращаемое значение:
//   Строка   - Строка в формате HTML.
//
Функция ОписаниеОбъекта(ИДОбъекта) Экспорт

	ВебСервис = ИнтеграцияССППРПовтИсп.ПолучитьПрокси();
	ОписаниеHTML = ВебСервис.GetObjectDescription(ИДОбъекта);
	
	Возврат ОписаниеHTML;

КонецФункции

// Возвращает описание профиля в формате HTML
//
// Параметры:
//  ИДПрофиля	- Тип - Уникальный идентификатор ссылки на профиль.
//
// Возвращаемое значение:
//   Строка   - Строка в формате HTML.
//
Функция ОписаниеПрофиля(ИДПрофиля) Экспорт

	ВебСервис = ИнтеграцияССППРПовтИсп.ПолучитьПрокси();
	ОписаниеHTML = ВебСервис.GetPerformerDescription(ИДПрофиля);
	
	Возврат ОписаниеHTML;

КонецФункции

// Возвращает описание формы
//
// Параметры:
//  ИмяФормы		- Строка - Полное имя формы
//  ИмяМетаданных	- Строка - Имя объекта метаданных, который содержит форму.
//
// Возвращаемое значение:
//   Структура   - Структура
//
Функция ОписаниеФормы(ИмяФормы, ИмяМетаданных, ЗаголовокФормы) Экспорт

	ВебСервис = ИнтеграцияССППРПовтИсп.ПолучитьПрокси();
	Проект = Константы.ПроектСППР.Получить();
	ОписаниеФормы = ВебСервис.GetFormDescription(Проект, ИмяМетаданных, ИмяФормы, ЗаголовокФормы);
	
	ГотовоеОписаниеФормы = Новый Структура;
	
	Если ОписаниеФормы <> Неопределено Тогда
		Если ОписаниеФормы.Description <> "" Тогда
			ГотовоеОписаниеФормы.Вставить("ОписаниеHTML", ОписаниеФормы.Description);
		ИначеЕсли ОписаниеФормы.FunctionID <> Неопределено Тогда	
			ГотовоеОписаниеФормы.Вставить("Функция", ОписаниеФормы.FunctionID);
		ИначеЕсли ОписаниеФормы.ObjectID <> Неопределено Тогда	
			ГотовоеОписаниеФормы.Вставить("Объект", ОписаниеФормы.ObjectID);
		КонецЕсли;
	КонецЕсли; 
	
	Возврат ГотовоеОписаниеФормы;

КонецФункции

// Возвращает описание раздела интерфейса
//
// Параметры:
//  РазделИнтерфейса	- Строка - Имя раздела.
//
// Возвращаемое значение:
//   Строка   - Строка в формате HTML.
//
Функция ОписаниеРазделаИнтерфейса(РазделИнтерфейса) Экспорт

	ВебСервис = ИнтеграцияССППРПовтИсп.ПолучитьПрокси();
	Проект = Константы.ПроектСППР.Получить();
	ОписаниеHTML = ВебСервис.GetInterfaceDescription(Проект, РазделИнтерфейса);
	
	Возврат ОписаниеHTML;

КонецФункции

// Добавляет в общую форму отчета команды для интеграции с СППР
//
// Параметры:
//  Форма	- УправляемаяФорма - Форма отчета в которой нужно разместить команды СППР.
//
Процедура ПриСозданииФормыОтчета(Форма) Экспорт
	
	Если НеТребуютсяКомандыИнтеграцииССППР(Форма) Тогда
		Возврат;
	КонецЕсли;

	// У общей формы отчета свой алгоритм добавления команд СППР
	ИмяКоманды = ДобавитьКомандуФункциональнойМодели(
						Форма, 
						Форма.Элементы.ОсновнаяКоманднаяПанель, 
						1, 
						Истина, 
						"Подключаемый_Команда");

	ПостоянныеКоманды = Форма.ПостоянныеКоманды;
	ПостоянныеКоманды.Добавить(ИмяКоманды);
	
КонецПроцедуры

// Добавляет размещение команд СППР в структуру дополнительных параметров
//
// Параметры:
//  ГруппаФормы				- ГруппаФормы - Группа формы в которой нужно разместить команды СППР
//  ДополнительныеПараметры	- Структура - Структура параметров в которую добавляется размещение команд.
//
Процедура ДобавитьРазмещениеКомандСППРВДополнительныеПараметры(ГруппаФормы, ДополнительныеПараметры) Экспорт
	Перем РазмещениеКомандСППР;
	
	Если ДополнительныеПараметры = Неопределено Тогда
		ДополнительныеПараметры = Новый Структура;
	КонецЕсли;
	
	ДополнительныеПараметры.Свойство("РазмещениеКомандСППР", РазмещениеКомандСППР);
	
	Если РазмещениеКомандСППР = Неопределено Тогда
		РазмещениеКомандСППР = Новый Массив;
	КонецЕсли;
	РазмещениеКомандСППР.Добавить(ГруппаФормы);
	
	ДополнительныеПараметры.Вставить("РазмещениеКомандСППР", РазмещениеКомандСППР);
	
КонецПроцедуры

Функция ВладелецЛогинаИПароля() Экспорт

	Возврат ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Константа.АдресВебСервисаСППР");

КонецФункции

#КонецОбласти

#Область Прочее

Процедура ЗаполнитьСписокФункцийРекурсивно(ТаблицаФункций, ИД_родитель, ТекущиеЭлементы)

	СтруктураПоиска = Новый Структура("ИД_родитель", ИД_родитель);
	СписокСтрок = ТаблицаФункций.НайтиСтроки(СтруктураПоиска);
	Для каждого ДанныеСтроки Из СписокСтрок Цикл
		НоваяСтрока = ТекущиеЭлементы.Добавить();
		НоваяСтрока.Представление = ДанныеСтроки.Представление;
		НоваяСтрока.ИД = ДанныеСтроки.ИД;
		
		ТекущиеЭлементыСтроки = НоваяСтрока.Строки;		
		ЗаполнитьСписокФункцийРекурсивно(ТаблицаФункций, ДанныеСтроки.ИД, ТекущиеЭлементыСтроки);
		
	КонецЦикла;

КонецПроцедуры

Процедура ЗаполнитьСписокОбъектовРекурсивно(ТаблицаОбъектов, ИД_родитель, ТекущиеЭлементы)

	СтруктураПоиска = Новый Структура("ИД_родитель", ИД_родитель);
	СписокСтрок = ТаблицаОбъектов.НайтиСтроки(СтруктураПоиска);
	Для каждого ДанныеСтроки Из СписокСтрок Цикл
		НоваяСтрока = ТекущиеЭлементы.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ДанныеСтроки);
		
		ТекущиеЭлементыСтроки = НоваяСтрока.Строки;
		ЗаполнитьСписокОбъектовРекурсивно(ТаблицаОбъектов, ДанныеСтроки.ИД, ТекущиеЭлементыСтроки);
	КонецЦикла;

КонецПроцедуры

Процедура ЗаполнитьСписокПрофилейРекурсивно(ТаблицаПрофилей, ИД_родитель, ТекущиеЭлементы)

	СтруктураПоиска = Новый Структура("ИД_родитель", ИД_родитель);
	СписокСтрок = ТаблицаПрофилей.НайтиСтроки(СтруктураПоиска);
	Для каждого ДанныеСтроки Из СписокСтрок Цикл
		НоваяСтрока = ТекущиеЭлементы.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ДанныеСтроки);
		
		ТекущиеЭлементыСтроки = НоваяСтрока.Строки;
		ЗаполнитьСписокПрофилейРекурсивно(ТаблицаПрофилей, ДанныеСтроки.ИД, ТекущиеЭлементыСтроки);
	КонецЦикла;

КонецПроцедуры

Функция ОпределитьРазмещениеКоманд(Форма)

	РазмещениеКоманд = Новый Массив;
	
	Для каждого ЭлементФормы Из Форма.Элементы Цикл
		Если ТипЗнч(ЭлементФормы) = Тип("КнопкаФормы") 
			И СтрНайти(НРег(ЭлементФормы.Имя), НСтр("ru = 'справка'")) <> 0 
			И ЭлементФормы.Родитель <> Неопределено Тогда
			
			РазмещениеКоманд.Добавить(ЭлементФормы.Родитель);
		КонецЕсли; 
	КонецЦикла; 
	
	Возврат РазмещениеКоманд;

КонецФункции

Функция ДобавитьКомандуФункциональнойМодели(Форма, МестоРазмещенияКоманд, НомерКоманды, ТолькоВоВсехДействиях, Действие)
	
	ИмяКоманды = МестоРазмещенияКоманд.Имя + "КомандаСППР" + Формат(НомерКоманды, "ЧГ=0") ;
	
	КомандаФормы = Форма.Команды.Добавить(ИмяКоманды);
	КомандаФормы.Действие = Действие; // универсальный обработчик
	КомандаФормы.Заголовок = НСтр("ru = 'Функциональная модель'");
	КомандаФормы.Подсказка = НСтр("ru = 'Функциональная модель'");
	КомандаФормы.ИзменяетСохраняемыеДанные = Ложь;
	
	НовыйЭлемент = Форма.Элементы.Добавить(МестоРазмещенияКоманд.Имя + ИмяКоманды, Тип("КнопкаФормы"), МестоРазмещенияКоманд);
	НовыйЭлемент.Вид = ВидКнопкиФормы.КнопкаКоманднойПанели;
	НовыйЭлемент.ИмяКоманды = ИмяКоманды;
	НовыйЭлемент.ТолькоВоВсехДействиях = ТолькоВоВсехДействиях;
	НовыйЭлемент.Картинка = БиблиотекаКартинок.ФункциональнаяМодель;
	НовыйЭлемент.Отображение = ОтображениеКнопки.Картинка;
	
	Возврат ИмяКоманды;
	
КонецФункции

Функция НеТребуютсяКомандыИнтеграцииССППР(Форма)

	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьИнтеграциюССППР") 
		ИЛИ НЕ ПравоДоступа("Просмотр", Метаданные.Обработки.ИнтеграцияССППР) 
		ИЛИ Форма.ИмяФормы = "Обработка.ИнтеграцияССППР.Форма.ФункциональнаяМодель"
		ИЛИ СтрНайти(Форма.ИмяФормы, "Справочник.ЭлементыФинансовыхОтчетов") <> 0 Тогда
		Возврат Истина;
	КонецЕсли;

	Возврат Ложь;
	
КонецФункции
 
#КонецОбласти

#КонецОбласти
