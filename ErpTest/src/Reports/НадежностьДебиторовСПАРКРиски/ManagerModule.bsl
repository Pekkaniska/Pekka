#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Инициализирует набор параметров, задающих флаги выполнения дополнительных действий над сущностями, обрабатываемыми
// в процессе формирования отчета.
//
// Возвращаемое значение:
//   Структура   - флаги, задающие необходимость дополнительных действий.
//
Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИспользоватьПередКомпоновкойМакета", Истина);
	Результат.Вставить("ИспользоватьПослеКомпоновкиМакета",  Ложь);
	Результат.Вставить("ИспользоватьПослеВыводаРезультата",  Истина);
	Результат.Вставить("ИспользоватьДанныеРасшифровки",      Истина);
	Результат.Вставить("ИспользоватьРасширенныеПараметрыРасшифровки", Истина);
	
	Возврат Результат;

КонецФункции

// Формирует текст, выводимый в заголовке отчета.
//
// Параметры:
//  ПараметрыОтчета - Структура - см. ПодготовитьПараметрыОтчета() в ФормаОтчета.
//
// Возвращаемое значение:
//   Строка      - текст заголовка с учётом периода.
//
Функция ПолучитьТекстЗаголовка(ПараметрыОтчета) Экспорт 
	
	ЗаголовокОтчета = "";
	
	Если ПараметрыОтчета.Свойство("РежимРасшифровки") И ПараметрыОтчета.РежимРасшифровки Тогда
		ЗаголовокОтчета = НСтр("ru='Расшифровка дебиторской задолженности на %1'");
	Иначе
		ЗаголовокОтчета = НСтр("ru='Надежность дебиторов на %1'");
	КонецЕсли;
	
	ЗаголовокОтчета = СтрШаблон(ЗаголовокОтчета, Формат(ПараметрыОтчета.Период, "Л=ru_RU; ДЛФ=D; ДП=..."));	
	
	Возврат ЗаголовокОтчета;
		
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет. Изменения сохранены не будут.
//
// Параметры:
//  ПараметрыОтчета - Структура - см. ПодготовитьПараметрыОтчета() в ФормаОтчета.
//  Схема        - СхемаКомпоновкиДанных - описание получаемых данных.
//  КомпоновщикНастроек - КомпоновщикНастроекКомпоновкиДанных - связь настроек компоновки данных и схемы компоновки.
//
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.Период) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Период", КонецДня(ПараметрыОтчета.Период) + 1);
	КонецЕсли;
	
	//БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
	//	КомпоновщикНастроек, 
	//	"СчетаРасчетовСПокупателями",
	//	ПараметрыОтчета.СчетаРасчетовСПокупателями);
	//	
	//БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
	//	КомпоновщикНастроек, 
	//	"СчетаРасчетовСПоставщиками",
	//	ПараметрыОтчета.СчетаРасчетовСПоставщиками);
	//			
	//БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
	//	КомпоновщикНастроек, 
	//	"СчетаСДокументомРасчетов",
	//	ПараметрыОтчета.СчетаСДокументомРасчетов);
	//	
	//БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
	//	КомпоновщикНастроек, 
	//	"СчетаБезДокументаРасчетов",
	//	ПараметрыОтчета.СчетаБезДокументаРасчетов);
		
	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);
	
	Если ПараметрыОтчета.РежимРасшифровки Тогда
		Возврат;
	КонецЕсли;	
	
	// Если не подключен сервис 1СПАРК Риски, то выводим баннер, скрываем легенду раскраски полей рисков
	// и устанавливаем параметр отчета - по значению параметра отчета "СервисНеПодключен" устанавливается
	// условное оформление полей рисков.
		
	СервисНеПодключен = Ложь;
	Если ПараметрыОтчета.Свойство("СервисНеПодключен") И ПараметрыОтчета.СервисНеПодключен Тогда
		СервисНеПодключен = Истина;
	КонецЕсли;	
	
	ГруппировкаЛегенда 	= НайтиПоИмени(КомпоновщикНастроек.Настройки.Структура, "Легенда");
	ГруппировкаБаннер 	= НайтиПоИмени(КомпоновщикНастроек.Настройки.Структура, "Баннер1СПАРК");
	
	ГруппировкаЛегенда.Использование 	= НЕ СервисНеПодключен;
	ГруппировкаБаннер.Использование 	= СервисНеПодключен;
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
		КомпоновщикНастроек, 
		"СервисНеПодключен",
		СервисНеПодключен);
	
КонецПроцедуры

// В процедуре можно изменить табличный документ после вывода в него данных.
//
// Параметры:
//  ПараметрыОтчета - Структура - см. ПодготовитьПараметрыОтчета() в ФормаОтчета.
//  Результат    - ТабличныйДокумент - сформированный отчет.
//
Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
		
	// Выведем картинку баннера сервиса 1СПАРК Риски и установим гиперссылку 
	ОбластьРисунка1СПАРК = Результат.НайтиТекст("Картинка 1СПАРК",,,, Истина);
	Если ОбластьРисунка1СПАРК <> Неопределено Тогда
		
		ОбластьРисунка1СПАРК.Текст = "";
		МакетКартинки1СПАРК = ПолучитьМакет("Логотип1СПАРКРиски");
		Картинка1СПАРК = Новый Картинка(МакетКартинки1СПАРК, Истина);
		
		ОбластьРисунка1СПАРК.Картинка = Картинка1СПАРК;
		ОбластьРисунка1СПАРК.ВертикальноеПоложениеКартинки = ВертикальноеПоложение.Верх;
		ОбластьРисунка1СПАРК.ГоризонтальноеПоложениеКартинки = ГоризонтальноеПоложение.Центр;
		
		ОбластьУзнатьПодробнее = Результат.НайтиТекст("Узнать подробнее",,,, Истина);
		ОбластьУзнатьПодробнее.Гиперссылка = Истина;
		
	КонецЕсли;
	
	// Установим гиперссылку в поле "Досье"
	ОбластьДосье = Результат.НайтиТекст("Досье",,,, Истина);
	Если ОбластьДосье <> Неопределено Тогда
		
		// Найдена первая ячейка расшифровки досье.
		// Установим в ней гиперссылку, а затем в этой же колонке аналогично обработаем все остальные ячейки.
		ОбластьДосье.Гиперссылка = Истина;
		
		Пока Истина Цикл
			ОбластьДосье = Результат.НайтиТекст("Досье", ОбластьДосье,, Ложь, Истина);
			Если ОбластьДосье = Неопределено Тогда
				Прервать;
			Иначе
				ОбластьДосье.Гиперссылка = Истина;
			КонецЕсли;	
		КонецЦикла;	
		
	КонецЕсли;
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);
	
КонецПроцедуры

// Настройки размещения в панели отчетов.
//
// Параметры:
//   Настройки - Коллекция - Передается "как есть" из ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов().
//   ОписаниеОтчета - СтрокаДереваЗначений - Настройки этого отчета,
//       уже сформированные при помощи функции ВариантыОтчетов.ОписаниеОтчета() и готовые к изменению.
//
Процедура НастроитьВариантыОтчета(Настройки, ОписаниеОтчета) Экспорт
	
	ОписаниеВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, "НадежностьДебиторовСПАРКРиски");
	ОписаниеВарианта.Описание = НСтр("ru= 'Контроль надеждности дебиторов с помощью сервиса СПАРК Риски.'");
	ВариантыОтчетовУТПереопределяемый.ОтключитьВариантОтчета(Настройки, ОписаниеОтчета, "СписокКонтрагентовДляОбновления");
	ВариантыОтчетовУТПереопределяемый.ОтключитьВариантОтчета(Настройки, ОписаниеОтчета, "Расшифровка");
	
	ОписаниеВарианта.Размещение.Вставить(Метаданные.Подсистемы.Продажи.Подсистемы.РасчетыСКлиентами, "");
	
КонецПроцедуры

// Заполняет описание настроек отчета в коллекции Настройки.
// Процедура используется подсистемой варианты отчетов.
//
// Параметры:
//   Настройки - Коллекция - Передается "как есть" из ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов().
//
Процедура НастройкиОтчета(Настройки) Экспорт
	
	Схема = ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	Для Каждого Вариант Из Схема.ВариантыНастроек Цикл
		 Настройки.ОписаниеВариантов.Вставить(Вариант.Имя,Вариант.Представление);
	КонецЦикла;
	
КонецПроцедуры

// Заполняет параметры расшифровки ячейки отчета.
//
// Параметры:
//	Адрес - Строка - Адрес временного хранилища с данными расшифровки отчета.
//	Расшифровка - Произвольный - Значения полей расшифровки.
//	ПараметрыРасшифровки - Структура - Коллеккция параметров расшифроки, которую требуется заполнить. 
//		Подробнее см. БухгалтерскиеОтчетыВызовСервера.ПолучитьМассивПолейРасшифровки()
//
Процедура ЗаполнитьПараметрыРасшифровкиОтчета(Адрес, Расшифровка, ПараметрыРасшифровки) Экспорт
	
	// Инициализируем список пунктов меню
	СписокПунктовМеню = Новый СписокЗначений();
	
	// Укажем что открывать объект сразу не нужно
	ПараметрыРасшифровки.Вставить("ОткрытьОбъект", Ложь);
	
	ДанныеОтчета = ПолучитьИзВременногоХранилища(Адрес);
	
	Если ДанныеОтчета = Неопределено Тогда 
		ПараметрыРасшифровки.Вставить("СписокПунктовМеню", СписокПунктовМеню);
		Возврат;
	КонецЕсли;
	
	ОткрытьРасшифровочныйОтчет = Ложь;
	
	ЗначениеРасшифровки = ДанныеОтчета.ДанныеРасшифровки.Элементы[Расшифровка];
	Если ТипЗнч(ЗначениеРасшифровки) = Тип("ЭлементРасшифровкиКомпоновкиДанныхПоля") Тогда
		Если ЗначениеРасшифровки.ОсновноеДействие = ДействиеОбработкиРасшифровкиКомпоновкиДанных.Расшифровать Тогда
			// Требуется открыть расшифровывающий отчет - выполним ниже
			ОткрытьРасшифровочныйОтчет = Истина;
		ИначеЕсли ЗначениеРасшифровки.ОсновноеДействие = ДействиеОбработкиРасшифровкиКомпоновкиДанных.ОткрытьЗначение Тогда
			Если ЗначениеРасшифровки.ПолучитьПоля().Количество() > 0 Тогда
				ПараметрыРасшифровки.Вставить("ОткрытьОбъект", Истина);
				ПараметрыРасшифровки.Вставить("Значение",  ЗначениеРасшифровки.ПолучитьПоля()[0].Значение);
			КонецЕсли;	
		Иначе
			// В расшифровке не более одного поля
			Для Каждого ПолеРасшифровки Из ЗначениеРасшифровки.ПолучитьПоля() Цикл
				Если ПолеРасшифровки.Поле = "Досье" Тогда
					ПараметрыРасшифровки.Вставить("ОткрытьФорму", Истина);
					ПараметрыРасшифровки.Вставить("Форма", "Отчет.ДосьеКонтрагента.Форма");
					Если ТипЗнч(ПолеРасшифровки.Значение) = Тип("СправочникСсылка.Контрагенты") Тогда
						ПараметрыФормы = Новый Структура("Контрагент", ПолеРасшифровки.Значение);
					Иначе
						ПараметрыФормы = Новый Структура("ИНН", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПолеРасшифровки.Значение, "ИНН"));
					КонецЕсли;
					ПараметрыРасшифровки.Вставить("ПараметрыФормы", ПараметрыФормы);
				ИначеЕсли ПолеРасшифровки.Поле = "ИндексДолжнойОсмотрительности" Тогда
					ПараметрыРасшифровки.Вставить("ОткрытьФорму", Истина);
					ПараметрыРасшифровки.Вставить("Форма", "Обработка.СправкаСПАРКРиски.Форма.ЧтоТакоеИндексДолжнойОсмотрительности");
					ПараметрыРасшифровки.Вставить("ПараметрыФормы", Новый Структура());
				ИначеЕсли ПолеРасшифровки.Поле = "ИндексФинансовогоРиска" Тогда
					ПараметрыРасшифровки.Вставить("ОткрытьФорму", Истина);
					ПараметрыРасшифровки.Вставить("Форма", "Обработка.СправкаСПАРКРиски.Форма.ЧтоТакоеИндексФинансовогоРиска");
					ПараметрыРасшифровки.Вставить("ПараметрыФормы", Новый Структура());
				ИначеЕсли ПолеРасшифровки.Поле = "ИндексПлатежнойДисциплины" Тогда
					ПараметрыРасшифровки.Вставить("ОткрытьФорму", Истина);
					ПараметрыРасшифровки.Вставить("Форма", "Обработка.СправкаСПАРКРиски.Форма.ЧтоТакоеИндексПлатежнойДисциплины");
					ПараметрыРасшифровки.Вставить("ПараметрыФормы", Новый Структура());
				ИначеЕсли ПолеРасшифровки.Поле = "Ссылка" Тогда
					ПараметрыРасшифровки.Вставить("ПерейтиПоСсылке", Истина);
					ПараметрыРасшифровки.Вставить("Значение", ПолеРасшифровки.Значение);
				КонецЕсли;	
			КонецЦикла;	
		КонецЕсли;
	Иначе
		Возврат;
	КонецЕсли;
	
	Если НЕ ОткрытьРасшифровочныйОтчет Тогда
		Возврат;
	КонецЕсли;	
	
	// Инициализация пользовательских настроек
	ПользовательскиеНастройки = Новый ПользовательскиеНастройкиКомпоновкиДанных;
	ДополнительныеСвойства = ПользовательскиеНастройки.ДополнительныеСвойства;
	ДополнительныеСвойства.Вставить("РежимРасшифровки", 					Истина);
	ДополнительныеСвойства.Вставить("Организация", 							ДанныеОтчета.Объект.Организация);
	ДополнительныеСвойства.Вставить("Период", 								ДанныеОтчета.Объект.Период);
	ДополнительныеСвойства.Вставить("ВыводитьЗаголовок",					ДанныеОтчета.Объект.ВыводитьЗаголовок);
	ДополнительныеСвойства.Вставить("ВыводитьПодвал",						ДанныеОтчета.Объект.ВыводитьПодвал);
	ДополнительныеСвойства.Вставить("МакетОформления",						ДанныеОтчета.Объект.МакетОформления);
	ДополнительныеСвойства.Вставить("ВключатьОбособленныеПодразделения",	ДанныеОтчета.Объект.ВключатьОбособленныеПодразделения);
	ДополнительныеСвойства.Вставить("КлючВарианта",							"Расшифровка");
	
	ОтборПоЗначениямРасшифровки = ПользовательскиеНастройки.Элементы.Добавить(Тип("ОтборКомпоновкиДанных"));
	ОтборПоЗначениямРасшифровки.ИдентификаторПользовательскойНастройки = "Отбор";
	
	// Отбор по расшифровываемому контрагенту
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборПоЗначениямРасшифровки, "Контрагент", ЗначениеРасшифровки.ПолучитьПоля()[0].Значение);
	
	СписокПунктовМеню.Добавить("НадежностьДебиторовСПАРКРиски", НСтр("ru='Надежность дебиторов'"));
	
	НастройкиРасшифровки = Новый Структура();
	НастройкиРасшифровки.Вставить("НадежностьДебиторовСПАРКРиски", ПользовательскиеНастройки);
	ДанныеОтчета.Вставить("НастройкиРасшифровки", НастройкиРасшифровки);
	
	ПоместитьВоВременноеХранилище(ДанныеОтчета, Адрес);
	
	ПараметрыРасшифровки.Вставить("СписокПунктовМеню", СписокПунктовМеню);
	
КонецПроцедуры

#Область КомандыПодменюОтчеты

// Добавляет команду отчета в список команд.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов.
//
Функция ДобавитьКомандуНадежностьДебиторовСПАРКРиски(КомандыОтчетов) Экспорт
	
	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.НадежностьДебиторовСПАРКРиски) Тогда
		
		КомандаОтчет = КомандыОтчетов.Добавить();
		
		КомандаОтчет.Менеджер = Метаданные.Отчеты.НадежностьДебиторовСПАРКРиски.ПолноеИмя();
		КомандаОтчет.Представление = НСтр("ru = 'Надежность дебиторов'");
		
		КомандаОтчет.МножественныйВыбор = Истина;
		КомандаОтчет.Важность = "Обычное";
		КомандаОтчет.ДополнительныеПараметры.Вставить("ИмяКоманды", "НадежностьДебиторовСПАРКРиски");
		
		Возврат КомандаОтчет;
		
	КонецЕсли;
	
	Возврат Неопределено;

КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НайтиПоИмени(Структура, Имя)
	
	Группировка = Неопределено;
	Для каждого Элемент Из Структура Цикл
		Если ТипЗнч(Элемент) = Тип("ТаблицаКомпоновкиДанных") Тогда
			Если Элемент.Имя = Имя Тогда
				Возврат Элемент;
			КонецЕсли;	
		Иначе
			Если Элемент.Имя = Имя Тогда
				Возврат Элемент;
			КонецЕсли;	
			Для каждого Поле Из Элемент.ПоляГруппировки.Элементы Цикл
				Если Не ТипЗнч(Поле) = Тип("АвтоПолеГруппировкиКомпоновкиДанных") Тогда
					Если Поле.Поле = Новый ПолеКомпоновкиДанных(Имя) Тогда
						Возврат Элемент;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			Если Элемент.Структура.Количество() = 0 Тогда
				Продолжить;
			Иначе
				Группировка = НайтиПоИмени(Элемент.Структура, Имя);
				Если Не Группировка = Неопределено Тогда
					Возврат	Группировка;
				КонецЕсли;	
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Возврат Группировка;
	
КонецФункции

#КонецОбласти

#КонецЕсли

