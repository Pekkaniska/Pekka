#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Определяет список команд создания на основании.
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	
	
КонецПроцедуры

// Добавляет команду создания документа "Изменение параметров ОС (международный учет)".
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	Если ПравоДоступа("Добавление", Метаданные.Документы.ИзменениеПараметровОСМеждународныйУчет)
		И ПолучитьФункциональнуюОпцию("ИспользоватьДокументыВнеоборотныхАктивовМеждународныйУчет") Тогда
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.ИзменениеПараметровОСМеждународныйУчет.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(Метаданные.Документы.ИзменениеПараметровОСМеждународныйУчет);
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		КомандаСоздатьНаОсновании.ФункциональныеОпции = "ОтображатьВнеоборотныеАктивыМеждународныйУчет2_2";
		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица с командами отчетов. Для изменения.
//       См. описание 1 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	
	
КонецПроцедуры

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

#Область Проведение

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт
	
	ИсточникиДанных = Новый Соответствие;
	
	Возврат ИсточникиДанных; 
	
КонецФункции

Функция АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра) Экспорт

	Запрос = Новый Запрос;
	ТекстыЗапроса = Новый СписокЗначений;
	
	ПолноеИмяДокумента = "Документ.ИзменениеПараметровОСМеждународныйУчет";
	
	ЗначенияПараметров = ЗначенияПараметровПроведения();
	ПереопределениеРасчетаПараметров = Новый Структура;
	ПереопределениеРасчетаПараметров.Вставить("НомерНаПечать", """""");
	
	ВЗапросеЕстьИсточник = Истина;
	
	Если ИмяРегистра = "РеестрДокументов" Тогда
		
		ТекстЗапроса = ТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, ИмяРегистра);
		СинонимТаблицыДокумента = "";
		ВЗапросеЕстьИсточник = Ложь;
		
	ИначеЕсли ИмяРегистра = "ДокументыПоОС" Тогда
		
		ТекстЗапроса = ТекстЗапросаТаблицаДокументыПоОС(Запрос, ТекстыЗапроса, ИмяРегистра);
		СинонимТаблицыДокумента = "ДанныеДокумента";
		
	Иначе
		ТекстИсключения = НСтр("ru = 'В документе %ПолноеИмяДокумента% не реализована адаптация текста запроса формирования движений по регистру %ИмяРегистра%.'");
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ПолноеИмяДокумента%", ПолноеИмяДокумента);
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ИмяРегистра%", ИмяРегистра);
		
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	Если ИмяРегистра = "РеестрДокументов"
		ИЛИ ИмяРегистра = "ДокументыПоОС" Тогда
		
		ТекстЗапроса = ОбновлениеИнформационнойБазыУТ.АдаптироватьЗапросПроведенияПоНезависимомуРегистру(
										ТекстЗапроса,
										ПолноеИмяДокумента,
										СинонимТаблицыДокумента,
										ВЗапросеЕстьИсточник,
										ПереопределениеРасчетаПараметров);
	Иначе	
		
		ТекстЗапроса = ОбновлениеИнформационнойБазыУТ.АдаптироватьЗапросМеханизмаПроведения(
										ТекстЗапроса,
										ПолноеИмяДокумента,
										СинонимТаблицыДокумента,
										ПереопределениеРасчетаПараметров);
	КонецЕсли; 

	Результат = ОбновлениеИнформационнойБазыУТ.РезультатАдаптацииЗапроса();
	Результат.ЗначенияПараметров = ЗначенияПараметров;
	Результат.ТекстЗапроса = ТекстЗапроса;
	
	Возврат Результат;
	
КонецФункции

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт
	
	Если Регистры = Неопределено Тогда
		ПроверитьБлокировкуВходящихДанныхПриОбновленииИБ(НСтр("ru = 'Изменение параметров ОС (международный учет)'"));
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
	
	ТекстыЗапроса = Новый СписокЗначений;
	МеждународныйУчетВнеоборотныеАктивы.ОтражениеДокументовВМеждународномУчете(ТекстыЗапроса, Регистры);
	МеждународныйУчетВнеоборотныеАктивы.ПрочиеРасходы(ТекстыЗапроса, Регистры);
	МеждународныйУчетВнеоборотныеАктивы.ПартииПрочихРасходов(ТекстыЗапроса, Регистры);
	МеждународныйУчетВнеоборотныеАктивы.ПрочиеАктивыПассивы(ТекстыЗапроса, Регистры);
	МеждународныйУчетВнеоборотныеАктивы.Международный(ТекстыЗапроса, Регистры, Международный(ТекстыЗапроса, Регистры));
	ОсновныеСредстваМеждународныйУчет(ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаДокументыПоОС(Запрос, ТекстыЗапроса, Регистры);
	
	ПроведениеСерверУТ.ИнициализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Истина);
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДокумента.Дата КАК Период,
	|	ДанныеДокумента.Номер КАК Номер,
	|	ДанныеДокумента.Ссылка КАК Ссылка,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.Ответственный,
	|	ДанныеДокумента.ПометкаУдаления,
	|	ДанныеДокумента.Проведен,
	|	ДанныеДокумента.Комментарий,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ОсновныеСредства) КАК ВидСубконтоОбъектаАмортизации,
	|	ДанныеДокумента.ОсновныеСредства.(
	|		ОсновноеСредство
	|	)
	|ИЗ
	|	Документ.ИзменениеПараметровОСМеждународныйУчет КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка";
	
	Результат = Запрос.Выполнить();
	Реквизиты = Результат.Выбрать();
	Реквизиты.Следующий();
	
	ОсновныеСредства = Реквизиты.ОсновныеСредства.Выгрузить().ВыгрузитьКолонку("ОсновноеСредство");
	
	Если НачалоДня(Реквизиты.Период) = НачалоМесяца(Реквизиты.Период) Тогда
		ТаблицаАмортизационныеРасходы = МеждународныйУчетВнеоборотныеАктивы.ТаблицаАмортизационныхРасходов();
	Иначе
		ТаблицаАмортизационныеРасходы = МеждународныйУчетВнеоборотныеАктивы.АмортизационныеРасходыПоОС(
			Реквизиты.Период,
			Реквизиты.Организация,
			ОсновныеСредства);
	КонецЕсли;
	ОшибкиШаблоновПроводок = МеждународныйУчетВнеоборотныеАктивы.ОшибкиЗаполненияШаблоновПроводокАмортизации(
		Реквизиты.Период,
		Реквизиты.Организация,
		ТаблицаАмортизационныеРасходы.ВыгрузитьКолонку("СтатьяРасходов"));
	
	Если ОшибкиШаблоновПроводок <> Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(ОшибкиШаблоновПроводок);
		ВызватьИсключение НСтр("ru='Требуется настроить счета расходов амортизации в шаблоне проводок для операции ""Амортизация внеоборотных активов""'");
	КонецЕсли;
	
	МеждународныйУчетВнеоборотныеАктивы.ИнициализироватьПараметрыЗапросаПриОтраженииАмортизации(Запрос);
	Для Каждого Колонка Из Результат.Колонки Цикл
		Запрос.УстановитьПараметр(Колонка.Имя, Реквизиты[Колонка.Имя]);
	КонецЦикла;
	
	Запрос.УстановитьПараметр("НачалоМесяца", НачалоМесяца(Реквизиты.Период));
	Запрос.УстановитьПараметр("Граница", Новый Граница(Реквизиты.Период, ВидГраницы.Исключая));
	Запрос.УстановитьПараметр("ТаблицаАмортизации", ТаблицаАмортизационныеРасходы);
	Запрос.УстановитьПараметр("ОсновныеСредства", ОсновныеСредства);
	
	ЗначенияПараметровПроведения = ЗначенияПараметровПроведения(Реквизиты);
	Для каждого КлючИЗначение Из ЗначенияПараметровПроведения Цикл
		Запрос.УстановитьПараметр(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла; 
	
	УниверсальныеМеханизмыПартийИСебестоимости.ЗаполнитьПараметрыИнициализации(Запрос, Реквизиты);
	
КонецПроцедуры

Функция ЗначенияПараметровПроведения(Реквизиты = Неопределено)

	ЗначенияПараметровПроведения = Новый Структура;
	ЗначенияПараметровПроведения.Вставить("ИдентификаторМетаданных", ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.ИзменениеПараметровОСМеждународныйУчет"));
	ЗначенияПараметровПроведения.Вставить("ХозяйственнаяОперация", Перечисления.ХозяйственныеОперации.ИзменениеПараметровОС);

	Если Реквизиты <> Неопределено Тогда
		ЗначенияПараметровПроведения.Вставить("НомерНаПечать", ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Реквизиты.Номер));
	КонецЕсли; 
	
	Возврат ЗначенияПараметровПроведения;
	
КонецФункции

Процедура ВременнаяТаблицаОбъектыДокумента(ТекстыЗапроса)
	
	ИмяТаблицы = "ТаблицаДокумента";
	
	Если ПроведениеСерверУТ.ЕстьТаблицаЗапроса(ИмяТаблицы, ТекстыЗапроса) Тогда
		Возврат;
	КонецЕсли;
	
	Текст = "
	|////////////////////////////////////////////////////////////////////////////////
	|// Таблица ВТ ТаблицаДокумента
	|"+
	"ВЫБРАТЬ
	|	ДанныеДокумента.ОсновноеСредство,
	|	ВЫБОР
	|		КОГДА ДанныеДокумента.Ссылка.ПорядокУчетаФлаг
	|			ТОГДА ДанныеДокумента.Ссылка.ПорядокУчета
	|		ИНАЧЕ ДанныеДокумента.Ссылка.ПорядокУчета
	|	КОНЕЦ КАК ПорядокУчета,
	|	ВЫБОР
	|		КОГДА ДанныеДокумента.Ссылка.ЛиквидационнаяСтоимостьФлаг
	|			ТОГДА ДанныеДокумента.Ссылка.ЛиквидационнаяСтоимость
	|		ИНАЧЕ Состояния.ЛиквидационнаяСтоимость
	|	КОНЕЦ КАК ЛиквидационнаяСтоимость,
	|	ВЫБОР
	|		КОГДА ДанныеДокумента.Ссылка.ЛиквидационнаяСтоимостьПредставленияФлаг
	|			ТОГДА ДанныеДокумента.Ссылка.ЛиквидационнаяСтоимостьПредставления
	|		ИНАЧЕ Состояния.ЛиквидационнаяСтоимостьПредставления
	|	КОНЕЦ КАК ЛиквидационнаяСтоимостьПредставления,
	|	ВЫБОР
	|		КОГДА ДанныеДокумента.Ссылка.СчетУчетаФлаг
	|			ТОГДА ДанныеДокумента.Ссылка.СчетУчета
	|		ИНАЧЕ Состояния.СчетУчета
	|	КОНЕЦ КАК СчетУчета,
	|	ВЫБОР
	|		КОГДА ДанныеДокумента.Ссылка.СчетАмортизацииФлаг
	|			ТОГДА ДанныеДокумента.Ссылка.СчетАмортизации
	|		ИНАЧЕ Состояния.СчетАмортизации
	|	КОНЕЦ КАК СчетАмортизации,
	|	ВЫБОР
	|		КОГДА ДанныеДокумента.Ссылка.МетодНачисленияАмортизацииФлаг
	|			ТОГДА ДанныеДокумента.Ссылка.МетодНачисленияАмортизации
	|		ИНАЧЕ Состояния.МетодНачисленияАмортизации
	|	КОНЕЦ КАК МетодНачисленияАмортизации,
	|	ВЫБОР
	|		КОГДА ДанныеДокумента.Ссылка.СрокИспользованияФлаг
	|			ТОГДА ДанныеДокумента.Ссылка.СрокИспользования
	|		ИНАЧЕ Состояния.СрокИспользования
	|	КОНЕЦ КАК СрокИспользования,
	|	ВЫБОР
	|		КОГДА ДанныеДокумента.Ссылка.ПоказательНаработкиФлаг
	|			ТОГДА ДанныеДокумента.Ссылка.ПоказательНаработки
	|		ИНАЧЕ Состояния.ПоказательНаработки
	|	КОНЕЦ КАК ПоказательНаработки,
	|	ВЫБОР
	|		КОГДА ДанныеДокумента.Ссылка.ОбъемНаработкиФлаг
	|			ТОГДА ДанныеДокумента.Ссылка.ОбъемНаработки
	|		ИНАЧЕ Состояния.ОбъемНаработки
	|	КОНЕЦ КАК ОбъемНаработки,
	|	ВЫБОР
	|		КОГДА ДанныеДокумента.Ссылка.КоэффициентУскоренияФлаг
	|			ТОГДА ДанныеДокумента.Ссылка.КоэффициентУскорения
	|		ИНАЧЕ Состояния.КоэффициентУскорения
	|	КОНЕЦ КАК КоэффициентУскорения,
	|	ВЫБОР
	|		КОГДА ДанныеДокумента.Ссылка.СтатьяРасходовФлаг
	|			ТОГДА ДанныеДокумента.Ссылка.СтатьяРасходов
	|		ИНАЧЕ Состояния.СтатьяРасходов
	|	КОНЕЦ КАК СтатьяРасходов,
	|	ВЫБОР
	|		КОГДА ДанныеДокумента.Ссылка.АналитикаРасходовФлаг
	|			ТОГДА ДанныеДокумента.Ссылка.АналитикаРасходов
	|		ИНАЧЕ Состояния.АналитикаРасходов
	|	КОНЕЦ КАК АналитикаРасходов,
	|	Состояния.СчетУчета КАК ТекСчетУчета,
	|	Состояния.СчетАмортизации КАК ТекСчетАмортизации,
	|	Состояния.СтатьяРасходов КАК ТекСтатьяРасходов,
	|	Состояния.АналитикаРасходов КАК ТекАналитикаРасходов,
	|	Состояния.Подразделение КАК Подразделение,
	|	ДанныеДокумента.ОсновноеСредство.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	ДанныеДокумента.Ссылка.СчетУчетаФлаг КАК СчетУчетаФлаг,
	|	ДанныеДокумента.Ссылка.СчетАмортизацииФлаг КАК СчетАмортизацииФлаг,
	|	Состояния.Состояние КАК Состояние,
	|	Состояния.ВидАктива КАК ВидАктива,
	|	Состояния.ИнвентарныйНомер КАК ИнвентарныйНомер
	|ПОМЕСТИТЬ ТаблицаДокумента
	|ИЗ
	|	Документ.ИзменениеПараметровОСМеждународныйУчет.ОсновныеСредства КАК ДанныеДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОсновныеСредстваМеждународныйУчет.СрезПоследних(
	|				&Граница,
	|				ОсновноеСредство В (&ОсновныеСредства)
	|					И Регистратор <> &Ссылка) КАК Состояния
	|		ПО ДанныеДокумента.ОсновноеСредство = Состояния.ОсновноеСредство
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка";
	
	ТекстыЗапроса.Добавить(Текст, ИмяТаблицы);
	
КонецПроцедуры

Процедура ОсновныеСредстваМеждународныйУчет(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ОсновныеСредстваМеждународныйУчет";
	
	Если Не ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	ВременнаяТаблицаОбъектыДокумента(ТекстыЗапроса);
	
	Текст = "
	|////////////////////////////////////////////////////////////////////////////////
	|// Таблица ОсновныеСредстваМеждународныйУчет
	|"+
	"ВЫБРАТЬ
	|	&Ссылка КАК Регистратор,
	|	&Период КАК Период,
	|	
	|	ТаблицаДокумента.ОсновноеСредство КАК ОсновноеСредство,
	|	
	|	&Организация КАК Организация,
	|	ТаблицаДокумента.Подразделение КАК Подразделение,
	|	ТаблицаДокумента.Состояние КАК Состояние,
	|	ТаблицаДокумента.ИнвентарныйНомер КАК ИнвентарныйНомер,
	|	ТаблицаДокумента.СчетУчета КАК СчетУчета,
	|	ТаблицаДокумента.ВидАктива КАК ВидАктива,
	|	ТаблицаДокумента.ЛиквидационнаяСтоимость КАК ЛиквидационнаяСтоимость,
	|	ТаблицаДокумента.ЛиквидационнаяСтоимостьПредставления КАК ЛиквидационнаяСтоимостьПредставления,
	|	ТаблицаДокумента.МетодНачисленияАмортизации КАК МетодНачисленияАмортизации,
	|	ТаблицаДокумента.ПорядокУчета КАК ПорядокУчета,
	|	ТаблицаДокумента.СчетАмортизации КАК СчетАмортизации,
	|	ТаблицаДокумента.СрокИспользования КАК СрокИспользования,
	|	ТаблицаДокумента.ПоказательНаработки КАК ПоказательНаработки,
	|	ТаблицаДокумента.ОбъемНаработки КАК ОбъемНаработки,
	|	ТаблицаДокумента.КоэффициентУскорения КАК КоэффициентУскорения,
	|	ТаблицаДокумента.СтатьяРасходов КАК СтатьяРасходов,
	|	ТаблицаДокумента.АналитикаРасходов КАК АналитикаРасходов
	|	
	|ИЗ
	|	ТаблицаДокумента КАК ТаблицаДокумента";
	
	ТекстыЗапроса.Добавить(Текст, ИмяРегистра);
	
КонецПроцедуры

Функция Международный(ТекстыЗапроса, Регистры)
	
	Если Не ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений("Международный", Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ВременнаяТаблицаОбъектыДокумента(ТекстыЗапроса);
	МеждународныйУчетВнеоборотныеАктивы.ВременнаяТаблицаНачисленнаяАмортизация(ТекстыЗапроса);
	
	Возврат
	"ВЫБРАТЬ // Перенос стоимости объекта со старого счета учета на новый
	|	&Период КАК Период,
	|	&Ссылка КАК Регистратор,
	|	
	|	&Организация КАК Организация,
	|	
	|	СтрокиДокумента.Подразделение КАК ПодразделениеДт,
	|	СтрокиДокумента.НаправлениеДеятельности КАК НаправлениеДеятельностиДт,
	|	НЕОПРЕДЕЛЕНО КАК ВалютаДт,
	|	СтрокиДокумента.СчетУчета КАК СчетДт,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ОсновныеСредства) КАК ВидСубконтоДт1,
	|	СтрокиДокумента.ОсновноеСредство КАК СубконтоДт1,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ПустаяСсылка) КАК ВидСубконтоДт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт2,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ПустаяСсылка) КАК ВидСубконтоДт3,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
	|	
	|	СтрокиДокумента.Подразделение КАК ПодразделениеКт,
	|	СтрокиДокумента.НаправлениеДеятельности КАК НаправлениеДеятельностиКт,
	|	НЕОПРЕДЕЛЕНО КАК ВалютаКт,
	|	СтрокиДокумента.ТекСчетУчета КАК СчетКт,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ОсновныеСредства) КАК ВидСубконтоКт1,
	|	СтрокиДокумента.ОсновноеСредство КАК СубконтоКт1,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ПустаяСсылка) КАК ВидСубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт2,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ПустаяСсылка) КАК ВидСубконтоКт3,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|	
	|	ЕСТЬNULL(ДанныеСчетУчета.СуммаОстаток,0) КАК Сумма,
	|	ЕСТЬNULL(ДанныеСчетУчета.СуммаПредставленияОстаток,0) КАК СуммаПредставления,
	|	0 КАК ВалютнаяСумма,
	|	
	|	НЕОПРЕДЕЛЕНО КАК Содержание,
	|	НЕОПРЕДЕЛЕНО КАК ШаблонПроводки,
	|	НЕОПРЕДЕЛЕНО КАК ТипПроводки
	|ИЗ
	|	ТаблицаДокумента КАК СтрокиДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Международный.Остатки(
	|				&Граница,
	|				Счет В
	|					(ВЫБРАТЬ
	|						ТаблицаДокумента.ТекСчетУчета
	|					ИЗ
	|						ТаблицаДокумента),
	|				,
	|				(Организация, Подразделение, Субконто1) В
	|						(ВЫБРАТЬ
	|							&Организация, ТаблицаДокумента.Подразделение, ТаблицаДокумента.ОсновноеСредство
	|						ИЗ
	|							ТаблицаДокумента)) КАК ДанныеСчетУчета
	|		ПО СтрокиДокумента.ОсновноеСредство = ДанныеСчетУчета.Субконто1
	|			И СтрокиДокумента.ТекСчетУчета = ДанныеСчетУчета.Счет
	|ГДЕ
	|	СтрокиДокумента.СчетУчетаФлаг
	|	И НЕ ДанныеСчетУчета.Счет ЕСТЬ NULL
	|	
	|ОБЪЕДИНИТЬ ВСЕ
	|	
	|ВЫБРАТЬ // Перенос начисленной амортизации со старого счета на новый
	|	&Период КАК Период,
	|	&Ссылка КАК Регистратор,
	|	
	|	&Организация КАК Организация,
	|	
	|	СтрокиДокумента.Подразделение КАК ПодразделениеДт,
	|	СтрокиДокумента.НаправлениеДеятельности КАК НаправлениеДеятельностиДт,
	|	НЕОПРЕДЕЛЕНО КАК ВалютаДт,
	|	СтрокиДокумента.ТекСчетАмортизации КАК СчетДт,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ОсновныеСредства) КАК ВидСубконтоДт1,
	|	СтрокиДокумента.ОсновноеСредство КАК СубконтоДт1,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ПустаяСсылка) КАК ВидСубконтоДт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт2,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ПустаяСсылка) КАК ВидСубконтоДт3,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
	|	
	|	СтрокиДокумента.Подразделение КАК ПодразделениеКт,
	|	СтрокиДокумента.НаправлениеДеятельности КАК НаправлениеДеятельностиКт,
	|	НЕОПРЕДЕЛЕНО КАК ВалютаКт,
	|	СтрокиДокумента.СчетАмортизации КАК СчетКт,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ОсновныеСредства) КАК ВидСубконтоКт1,
	|	СтрокиДокумента.ОсновноеСредство КАК СубконтоКт1,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ПустаяСсылка) КАК ВидСубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт2,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ПустаяСсылка) КАК ВидСубконтоКт3,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|	
	|	ЕСТЬNULL(-ДанныеСчетАмортизации.СуммаОстаток,0) + ЕСТЬNULL(ТаблицаАмортизации.Сумма, 0) КАК Сумма,
	|	ЕСТЬNULL(-ДанныеСчетАмортизации.СуммаПредставленияОстаток,0) + ЕСТЬNULL(ТаблицаАмортизации.СуммаПредставления, 0) КАК СуммаПредставления,
	|	0 КАК ВалютнаяСумма,
	|	
	|	НЕОПРЕДЕЛЕНО КАК Содержание,
	|	НЕОПРЕДЕЛЕНО КАК ШаблонПроводки,
	|	НЕОПРЕДЕЛЕНО КАК ТипПроводки
	|ИЗ
	|	ТаблицаДокумента КАК СтрокиДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Международный.Остатки(
	|				&Граница,
	|				Счет В
	|					(ВЫБРАТЬ
	|						ТаблицаДокумента.ТекСчетАмортизации
	|					ИЗ
	|						ТаблицаДокумента),
	|				,
	|				(Организация, Подразделение, Субконто1) В
	|						(ВЫБРАТЬ
	|							&Организация, ТаблицаДокумента.Подразделение, ТаблицаДокумента.ОсновноеСредство
	|						ИЗ
	|							ТаблицаДокумента)) КАК ДанныеСчетАмортизации
	|		ПО СтрокиДокумента.ОсновноеСредство = ДанныеСчетАмортизации.Субконто1
	|			И СтрокиДокумента.ТекСчетАмортизации = ДанныеСчетАмортизации.Счет
	|		ЛЕВОЕ СОЕДИНЕНИЕ втНачисленнаяАмортизация КАК ТаблицаАмортизации
	|		ПО СтрокиДокумента.ОсновноеСредство = ТаблицаАмортизации.ОбъектУчета
	|ГДЕ
	|	СтрокиДокумента.СчетАмортизацииФлаг
	|	И НЕ (ДанныеСчетАмортизации.Счет ЕСТЬ NULL И ТаблицаАмортизации.ОбъектУчета ЕСТЬ NULL)";
	
КонецФункции

Функция ТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "РеестрДокументов";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	&Ссылка                                 КАК Ссылка,
	|	&Период                                 КАК ДатаДокументаИБ,
	|	&Номер                                  КАК НомерДокументаИБ,
	|	&ИдентификаторМетаданных                КАК ТипСсылки,
	|	&Организация                            КАК Организация,
	|	&ХозяйственнаяОперация                  КАК ХозяйственнаяОперация,
	|	&Ответственный                          КАК Ответственный,
	|	&Комментарий                            КАК Комментарий,
	|	&Проведен                               КАК Проведен,
	|	&ПометкаУдаления                        КАК ПометкаУдаления,
	|	ЛОЖЬ                                    КАК ДополнительнаяЗапись,
	|	&Период                                 КАК ДатаПервичногоДокумента,
	|	&НомерНаПечать                          КАК НомерПервичногоДокумента,
	|	&Период    КАК ДатаОтраженияВУчете";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаДокументыПоОС(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ДокументыПоОС";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ЕСТЬNULL(ТаблицаОС.НомерСтроки-1, 0) КАК НомерЗаписи,
	|	&Ссылка                        КАК Ссылка,
	|	&Период                        КАК Дата,
	|	&Организация                   КАК Организация,
	|	&Проведен                      КАК Проведен,
	|	&ХозяйственнаяОперация         КАК ХозяйственнаяОперация,
	|	&ИдентификаторМетаданных       КАК ТипСсылки,
	|	ЛОЖЬ                           КАК ОтражатьВРеглУчете,
	|	ЛОЖЬ                           КАК ОтражатьВУпрУчете,
	|	ТаблицаОС.ОсновноеСредство     КАК ОсновноеСредство
	|ИЗ
	|	Документ.ИзменениеПараметровОСМеждународныйУчет КАК ДанныеДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ИзменениеПараметровОСМеждународныйУчет.ОсновныеСредства КАК ТаблицаОС
	|		ПО ТаблицаОС.Ссылка = ДанныеДокумента.Ссылка
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область БлокировкаПриОбновленииИБ

Процедура ПроверитьБлокировкуВходящихДанныхПриОбновленииИБ(ПредставлениеОперации)
	
	ВходящиеДанные = Новый Соответствие;
	
	ВходящиеДанные.Вставить(Метаданные.Документы.ПринятиеКУчетуНМАМеждународныйУчет);
	ВходящиеДанные.Вставить(Метаданные.РегистрыБухгалтерии.Международный);
	ВходящиеДанные.Вставить(Метаданные.РегистрыНакопления.ВыработкаНМА);
	ВходящиеДанные.Вставить(Метаданные.РегистрыНакопления.ПрочиеРасходы);
	ВходящиеДанные.Вставить(Метаданные.РегистрыСведений.НаработкиОбъектовЭксплуатации);
	ВходящиеДанные.Вставить(Метаданные.РегистрыСведений.НематериальныеАктивыМеждународныйУчет);
	ВходящиеДанные.Вставить(Метаданные.РегистрыСведений.ОсновныеСредстваМеждународныйУчет);
	ВходящиеДанные.Вставить(Метаданные.РегистрыСведений.ПравилаОтраженияВМеждународномУчете);
	ВходящиеДанные.Вставить(Метаданные.РегистрыСведений.ПравилаУточненияСчетовВМеждународномУчете);
	ВходящиеДанные.Вставить(Метаданные.РегистрыСведений.УчетнаяПолитикаОрганизацийДляМеждународногоУчета);
	
	ЗакрытиеМесяцаСервер.ПроверитьБлокировкуВходящихДанныхПриОбновленииИБ(ВходящиеДанные, ПредставлениеОперации);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли