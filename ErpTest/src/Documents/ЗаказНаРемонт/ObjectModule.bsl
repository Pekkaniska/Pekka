#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Устанавливает статус для объекта документа
//
// Параметры:
// 		НовыйСтатус - Строка - Имя статуса, который будет установлен у документа
// 		ДополнительныеПараметры - Структура - Структура дополнительных параметров установки статуса.
//								Конструктор структуры: ЗаказыСервер.СтруктураКорректировкиСтрокЗаказа().
//
// Возвращаемое значение:
// 		Булево - Истина, в случае успешной установки нового статуса.
//
Функция УстановитьСтатус(НовыйСтатус, ДополнительныеПараметры) Экспорт
	
	ЗначениеНовогоСтатуса = Перечисления.СтатусыЗаказовНаРемонт[НовыйСтатус];
	
	Если ЗначениеНовогоСтатуса = Перечисления.СтатусыЗаказовНаРемонт.Выполняется Тогда
		ДатаНачалаФактическая = ТекущаяДатаСеанса();
	ИначеЕсли ЗначениеНовогоСтатуса = Перечисления.СтатусыЗаказовНаРемонт.Закрыт Тогда
		ДатаЗавершенияФактическая = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Если ДополнительныеПараметры <> Неопределено Тогда
		
		ЗаказыСервер.СкорректироватьСтрокиЗаказа(ЭтотОбъект, ДополнительныеПараметры);
		
	КонецЕсли;
	
	Статус = ЗначениеНовогоСтатуса;
	
	ПараметрыУказанияСерий = НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ЗаказНаРемонт);
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(ЭтотОбъект, ПараметрыУказанияСерий);
	
	Возврат ПроверитьЗаполнение();
	
КонецФункции // УстановитьСтатус()

// Корректирует строки, по которым не была оформлено списание или отгрузка или имеются расхождения по мерным товарам.
//
// Параметры:
// 		СтруктураПараметров - Структура - Структура параметров корректировки, конструктор: ЗаказыСервер.СтруктураКорректировкиСтрокЗаказа().
//
// Возвращаемое значение:
// 		Структура
// 		*	КоличествоСтрок - Количество отмененных/скорректированных строк.
//
Функция СкорректироватьСтрокиЗаказа(СтруктураПараметров) Экспорт
	
	Если Не СтруктураПараметров.ОтменитьНеотработанныеСтроки И Не СтруктураПараметров.СкорректироватьМерныеТовары Тогда
		Возврат ЗаказыСервер.РезультатОтменыНеотработанныхСтрок(Неопределено)
	КонецЕсли;
	
	КоличествоСкорректированныхСтрок = 0;
	
	КорректироватьМатериалы = (СтруктураПараметров.ОтменитьНеотработанныеСтроки Или СтруктураПараметров.СкорректироватьМерныеТовары)
		И (СтруктураПараметров.ИмяТабличнойЧасти = "Товары" Или СтруктураПараметров.ИмяТабличнойЧасти = "МатериалыИРаботы");
	КорректироватьТрудозатраты = СтруктураПараметров.ОтменитьНеотработанныеСтроки
		И (СтруктураПараметров.ИмяТабличнойЧасти = "Товары" Или СтруктураПараметров.ИмяТабличнойЧасти = "Трудозатраты");
	
	Если Не СтруктураПараметров.ПроверятьОстатки Тогда
		
		СвойстваОтмененнойСтроки = Новый Структура("Отменено, СтатусУказанияСерий", Истина, 0);
		
		Если КорректироватьМатериалы Тогда
			
			Для каждого СтрокаТовары Из МатериалыИРаботы Цикл
				Если Не СтрокаТовары.Отменено Тогда
					
					ЗаполнитьЗначенияСвойств(СтрокаТовары, СвойстваОтмененнойСтроки);
					КоличествоСкорректированныхСтрок = КоличествоСкорректированныхСтрок + 1;
					
				КонецЕсли;
			КонецЦикла;
			
		КонецЕсли;
		
		Если КорректироватьТрудозатраты Тогда
			
			Для каждого СтрокаТовары Из Трудозатраты Цикл
				Если Не СтрокаТовары.Отменено Тогда
					
					ЗаполнитьЗначенияСвойств(СтрокаТовары, СвойстваОтмененнойСтроки);
					КоличествоСкорректированныхСтрок = КоличествоСкорректированныхСтрок + 1;
					
				КонецЕсли;
			КонецЦикла;
			
		КонецЕсли;
		
		Возврат ЗаказыСервер.РезультатОтменыНеотработанныхСтрок(КоличествоСкорректированныхСтрок);
	КонецЕсли;
	
	Если КорректироватьМатериалы Тогда
		
		ПараметрыЗаполнения = ЗаказыСервер.ПараметрыЗаполненияДляОтменыСтрок();
		ПараметрыЗаполнения.МенеджерРегистра  = РегистрыНакопления.ЗаказыНаВнутреннееПотребление;
		ПараметрыЗаполнения.ИмяТабличнойЧасти = "МатериалыИРаботы";
		ПараметрыЗаполнения.ПутиКДанным.Вставить("Назначение", "Назначение");
		
		ПараметрыОтмены = ЗаказыСервер.ПараметрыОтменыСтрокЗаказов();
		ПараметрыОтмены.ОтменятьТолькоМерныеТовары = НЕ СтруктураПараметров.ОтменитьНеотработанныеСтроки
			И СтруктураПараметров.СкорректироватьМерныеТовары;
		ПараметрыОтмены.СкорректироватьМерныеТовары = СтруктураПараметров.СкорректироватьМерныеТовары;
		
		КоличествоСкорректированныхСтрок = КоличествоСкорректированныхСтрок
			+ ЗаказыСервер.ОтменитьНеотработанныеСтрокиПоОтгрузке(ЭтотОбъект, ПараметрыЗаполнения, ПараметрыОтмены).КоличествоСтрок;
		
		ПараметрыУказанияСерий = Новый ФиксированнаяСтруктура(НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ЗаказНаРемонт));
		НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(ЭтотОбъект, ПараметрыУказанияСерий);
		
	КонецЕсли;
	
	Если КорректироватьТрудозатраты Тогда
		
		КоличествоСкорректированныхСтрок = КоличествоСкорректированныхСтрок
			+ Документы.ЗаказНаРемонт.ОтменитьНевыполненныеСтрокиТрудозатрат(ЭтотОбъект, Истина);
		
	КонецЕсли;
	
	Возврат ЗаказыСервер.РезультатОтменыНеотработанныхСтрок(КоличествоСкорректированныхСтрок);
	
КонецФункции

// Проверяет правильность заполнения ключей ремонтов в табличной части
//
// Параметры:
// 		ТабличнаяЧасть - ТабличнаяЧасть - Табличная часть объекта документа.
//
Процедура СопоставитьКлючиРемонтовВТабличнойЧасти(ТабличнаяЧасть) Экспорт
	
	СоответствиеРемонтов = Неопределено;
	
	Если Не ДополнительныеСвойства.Свойство("СоответствиеРемонтов", СоответствиеРемонтов)
		Или СоответствиеРемонтов = Неопределено Тогда
		
		СоответствиеРемонтов = Новый Соответствие;
		Для Каждого Ремонт Из Ремонты Цикл
			СоответствиеРемонтов.Вставить(Ремонт.КодРемонта, Истина);
		КонецЦикла;
		ДополнительныеСвойства.Вставить("СоответствиеРемонтов", СоответствиеРемонтов);
		
	КонецЕсли;
	
	СтруктураНеСопоставленногоРемонта = Новый Структура("КодРемонта", 0);
	
	Для Каждого Строка Из ТабличнаяЧасть Цикл
		Если ЗначениеЗаполнено(Строка.КодРемонта) И СоответствиеРемонтов.Получить(Строка.КодРемонта)=Неопределено Тогда
			ЗаполнитьЗначенияСвойств(Строка, СтруктураНеСопоставленногоРемонта);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКопировании(ОбъектКопирования)
	
	ЖелаемаяДатаОтгрузки  = Дата(1, 1, 1);
	Статус = Метаданные().Реквизиты.Статус.ЗначениеЗаполнения;
	МаксимальныйКодСтрокиНоменклатуры = 0;
	МаксимальныйКодСтрокиТрудозатрат = 0;
	Назначение = Неопределено;
	
	Для каждого СтрокаТовары Из МатериалыИРаботы Цикл
		
		СтрокаТовары.Отменено = Ложь;
		СтрокаТовары.КодСтроки = 0;
		
	КонецЦикла;
	
	Для каждого СтрокаТовары Из Трудозатраты Цикл
		
		СтрокаТовары.КодСтроки = 0;
		
	КонецЦикла;
	
	ДоступныТрудозатраты = Ложь;
	Трудозатраты.Очистить();
	
	ОчиститьНедоступныеСтатьиРасходов();
	ПараметрыЗаполнения = Документы.ЗаказНаРемонт.ПараметрыЗаполненияВидаДеятельностиНДС(ЭтотОбъект);
	УчетНДСУП.ЗаполнитьВидДеятельностиНДС(ПотреблениеДляДеятельности, ПараметрыЗаполнения);
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("Структура") Тогда
		ЗаполнитьДокументПоОтбору(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("СправочникСсылка.ОбъектыЭксплуатации")
		Или ТипДанныхЗаполнения = Тип("СправочникСсылка.УзлыОбъектовЭксплуатации") Тогда
		ЗаполнитьДокументНаОснованииОбъектаЭксплуатации(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.РегистрацияДефекта") Тогда
		ЗаполнитьДокументНаОснованииРегистрацииДефекта(ДанныеЗаполнения);
	КонецЕсли;
	
	ПараметрыЗаполнения = Документы.ЗаказНаРемонт.ПараметрыЗаполненияВидаДеятельностиНДС(ЭтотОбъект);
	УчетНДСУП.ЗаполнитьВидДеятельностиНДС(ПотреблениеДляДеятельности, ПараметрыЗаполнения);
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
	ЗаполнениеСвойствПоСтатистикеСервер.ЗаполнитьСвойстваОбъекта(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	УстановитьКлючиВСтрокахТабличнойЧасти(Ремонты, "КодРемонта", МаксимальныйКодРемонта);
	УстановитьКлючиВСтрокахТабличнойЧасти(МатериалыИРаботы, "КодСтроки", МаксимальныйКодСтрокиНоменклатуры);
	УстановитьКлючиВСтрокахТабличнойЧасти(Трудозатраты, "КодСтроки", МаксимальныйКодСтрокиТрудозатрат);
	
	СопоставитьКлючиРемонтовВТабличнойЧасти(МатериалыИРаботы);
	СопоставитьКлючиРемонтовВТабличнойЧасти(Трудозатраты);
	
	ПараметрыОкругления = ОбщегоНазначенияУТ.ПараметрыОкругленияКоличестваШтучныхТоваров();
	ПараметрыОкругления.ИмяТЧ = "МатериалыИРаботы";
	ОбщегоНазначенияУТ.ОкруглитьКоличествоШтучныхТоваров(ЭтотОбъект, РежимЗаписи, ПараметрыОкругления);
	
	ШаблонНазначения = Документы.ЗаказНаРемонт.ШаблонНазначения(ЭтотОбъект);
	Справочники.Назначения.ПроверитьЗаполнитьПередЗаписью(Назначение, ШаблонНазначения, ЭтотОбъект, "НаправлениеДеятельности", Отказ);
	
	НоменклатураСервер.ОчиститьНеиспользуемыеСерии(ЭтотОбъект,
		НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ЗаказНаРемонт));
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Отказ
		И Не ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		РегистрыСведений.РеестрДокументов.ИнициализироватьИЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
		
	КонецЕсли;
	
	ШаблонНазначения = Документы.ЗаказНаРемонт.ШаблонНазначения(ЭтотОбъект);
	Справочники.Назначения.ПриЗаписиДокумента(Назначение, ШаблонНазначения, ЭтотОбъект, Подразделение, ПотреблениеДляДеятельности);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	Документы.ЗаказНаРемонт.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ЗаказыСервер.ОтразитьГрафикОтгрузкиТоваров(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьСвободныеОстатки(ДополнительныеСвойства, Движения, Отказ);
	ЗаказыСервер.ОтразитьЗаказыНаВнутреннееПотребление(ДополнительныеСвойства, Движения, Отказ);
	ЗаказыСервер.ОтразитьТоварыКОтгрузке(ДополнительныеСвойства, Движения, Отказ);
	Документы.ЗаказНаРемонт.ОтразитьПланРемонтов(ДополнительныеСвойства, Движения, Отказ);
	ОбъектыЭксплуатации.ОтразитьПериодыАктуальностиОбъектовЭксплуатации(ДополнительныеСвойства, Движения, Отказ);
	Документы.ЗаказНаРемонт.ОтразитьРемонтыРабочихЦентров(ДополнительныеСвойства, Движения, Отказ);
	ОперативныйУчетПроизводства.ОтразитьТрудозатратыКОформлению(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьОбеспечениеЗаказовРаботами(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьОбеспечениеЗаказов(ДополнительныеСвойства, Движения, Отказ);
	
	СформироватьСписокРегистровДляКонтроля();
	
	РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	ВыполнитьКонтрольЗаказаПослеПроведения(Отказ);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	СформироватьСписокРегистровДляКонтроля();
	
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Перем МассивВсехРеквизитов;
	Перем МассивРеквизитовОперации;
	
	ПроверяемыеРеквизиты.Добавить("Ремонты");
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	МассивНепроверяемыхРеквизитов.Добавить("МатериалыИРаботы.Склад");
	
//++ Рарус Лимаренко 09.01.2019
	МассивНепроверяемыхРеквизитов.Добавить("ОбщийВидРемонта");
//-- Рарус Лимаренко 09.01.2019
		
	Документы.ЗаказНаРемонт.ИменаРеквизитовПоХозяйственнойОперации(
		ХозяйственнаяОперация, 
		МассивВсехРеквизитов, 
		МассивРеквизитовОперации);
	
	ОбщегоНазначенияУТКлиентСервер.ЗаполнитьМассивНепроверяемыхРеквизитов(
		МассивВсехРеквизитов,
		МассивРеквизитовОперации,
		МассивНепроверяемыхРеквизитов);
	
	Если Статус = Перечисления.СтатусыЗаказовНаРемонт.Создан Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ДатаНачала");
		МассивНепроверяемыхРеквизитов.Добавить("ДатаЗавершения");
	КонецЕсли;

	Если Статус = Перечисления.СтатусыЗаказовНаРемонт.Выполняется Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("ДатаЗавершенияФактическая");
		
	ИначеЕсли Статус = Перечисления.СтатусыЗаказовНаРемонт.Создан
		Или Статус = Перечисления.СтатусыЗаказовНаРемонт.КВыполнению Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("ДатаНачалаФактическая");
		МассивНепроверяемыхРеквизитов.Добавить("ДатаЗавершенияФактическая");
		
		МассивНепроверяемыхРеквизитов.Добавить("Трудозатраты.Бригада");
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДатаНачала) И ЗначениеЗаполнено(ДатаЗавершения)
		И ДатаНачала > ДатаЗавершения Тогда
		
		ТекстОшибки = НСтр("ru='Плановая дата завершения работ %ДатаЗавершения% должна быть не меньше плановой даты начала %ДатаНачала%'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ДатаНачала%", Формат(ДатаНачала, "ДЛФ=DD"));
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ДатаЗавершения%", Формат(ДатаЗавершения, "ДЛФ=DD"));
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			"ДатаЗавершения",
			,
			Отказ);
		
	КонецЕсли;
	
	Если Статус = Перечисления.СтатусыЗаказовНаРемонт.Закрыт
		И ЗначениеЗаполнено(ДатаНачалаФактическая) И ЗначениеЗаполнено(ДатаЗавершенияФактическая)
		И ДатаНачалаФактическая > ДатаЗавершенияФактическая Тогда
		
		ТекстОшибки = НСтр("ru='Фактическая дата завершения работ %ДатаЗавершения% должна быть не меньше фактической даты начала %ДатаНачала%'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ДатаНачала%", Формат(ДатаНачалаФактическая, "ДЛФ=DD"));
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ДатаЗавершения%", Формат(ДатаЗавершенияФактическая, "ДЛФ=DD"));
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			"ДатаЗавершенияФактическая",
			,
			Отказ);
		
	КонецЕсли;
	
	Если Не НаправленияДеятельностиСервер.УказаниеНаправленияДеятельностиОбязательно(ХозяйственнаяОперация) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НаправлениеДеятельности");
	КонецЕсли;
	
	ПараметрыПроверки = ОбщегоНазначенияУТ.ПараметрыПроверкиЗаполненияКоличества();
	ПараметрыПроверки.ИмяТЧ = "МатериалыИРаботы";
	ОбщегоНазначенияУТ.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ, ПараметрыПроверки);
	
	ПараметрыПроверки = НоменклатураСервер.ПараметрыПроверкиЗаполненияХарактеристик();
	ПараметрыПроверки.ИмяТЧ = "МатериалыИРаботы";
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект, МассивНепроверяемыхРеквизитов, Отказ, ПараметрыПроверки);
	
	ПроверитьЗаполнениеРемонтов(Отказ);
	ПроверитьЗаполнениеМатериаловИРабот(Отказ);
	ПроверитьЗаполнениеРабочихЦентров(Отказ);
	НоменклатураСервер.ПроверитьЗаполнениеСерий(ЭтотОбъект,
												НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ЗаказНаРемонт),
												Отказ,
												МассивНепроверяемыхРеквизитов);
	
	ПараметрыПроверки = Документы.ЗаказНаРемонт.ПараметрыПроверкиЗаполненияДокументаПоВидуДеятельностиНДС(ЭтотОбъект);
	УчетНДСУП.ПроверитьЗаполнениеДокументаПоВидуДеятельностиНДС(ЭтотОбъект, ПотреблениеДляДеятельности, ПараметрыПроверки, Отказ);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);
	
	Если Не Отказ И ОбщегоНазначенияУТ.ПроверитьЗаполнениеРеквизитовОбъекта(ЭтотОбъект, ПроверяемыеРеквизиты) Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Заполняет документ в соответствии с отбором
//
Процедура ЗаполнитьДокументПоОтбору(Знач ДанныеЗаполнения)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

// Заполняет документ на основании ссылки на справочник объектов эксплуатации
//
Процедура ЗаполнитьДокументНаОснованииОбъектаЭксплуатации(Знач Основание)
	
	Ремонты.Очистить();
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ОбъектыЭксплуатации.Ссылка КАК ОбъектЭксплуатации,
		|	ОбъектыЭксплуатации.Статус КАК Статус,
		|	ВЫБОР
		|		КОГДА ОбъектыЭксплуатации.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыОбъектовЭксплуатации.ВЭксплуатации)
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК ЕстьОшибкиСтатус,
		|	ОбъектыЭксплуатации.ПометкаУдаления КАК ЕстьОшибкиУдален,
		|	ОбъектыЭксплуатации.ЭтоГруппа КАК ЕстьОшибкиГруппа
		|ИЗ
		|	Справочник.ОбъектыЭксплуатации КАК ОбъектыЭксплуатации
		|ГДЕ
		|	(ОбъектыЭксплуатации.Ссылка = &Ссылка
		|			ИЛИ ОбъектыЭксплуатации.Ссылка В
		|				(ВЫБРАТЬ
		|					Узлы.Владелец
		|				ИЗ
		|					Справочник.УзлыОбъектовЭксплуатации КАК Узлы
		|				ГДЕ
		|					Узлы.Ссылка = &Ссылка))
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Узлы.Ссылка КАК Узел,
		|	Узлы.Статус КАК Статус,
		|	ВЫБОР
		|		КОГДА Узлы.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыОбъектовЭксплуатации.ВЭксплуатации)
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК ЕстьОшибкиСтатус,
		|	Узлы.ПометкаУдаления КАК ЕстьОшибкиУдален
		|ИЗ
		|	Справочник.УзлыОбъектовЭксплуатации КАК Узлы
		|ГДЕ
		|	ВЫБОР
		|			КОГДА Узлы.Ссылка = &Ссылка
		|				ТОГДА ИСТИНА
		|			КОГДА Узлы.Владелец = &Ссылка
		|				ТОГДА Узлы.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыОбъектовЭксплуатации.ВЭксплуатации)
		|						И НЕ Узлы.ПометкаУдаления
		|			ИНАЧЕ ЛОЖЬ
		|		КОНЕЦ");
	
	Запрос.УстановитьПараметр("Ссылка", Основание);
	
	ТекстОшибкиГруппа = НСтр("ru='Элемент справочника ""%1"" является группой. Ввод на основании групп справочника запрещен.'");
	ТекстОшибкиУдален = НСтр("ru='%1 ""%2"" помечен на удаление. Ввод на основании помеченного на удаление элемента справочника запрещен.'");
	ТекстОшибкиСтатус = НСтр("ru='%1 ""%2"" находится в статусе ""%3"". Ввод на основании разрешен только в статусе ""В эксплуатации"".'");
	
	Пакет = Запрос.ВыполнитьПакет();
	Если Не Пакет[0].Пустой() Тогда
		
		Выборка = Пакет[0].Выбрать();
		Выборка.Следующий();
		
		Если Выборка.ЕстьОшибкиГруппа Тогда
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ТекстОшибкиГруппа,
				Выборка.ОбъектЭксплуатации);
			ВызватьИсключение ТекстОшибки;
		ИначеЕсли Выборка.ЕстьОшибкиУдален Тогда
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ТекстОшибкиУдален,
				НСтр("ru='Объект эксплуатации'"),
				Выборка.ОбъектЭксплуатации);
			ВызватьИсключение ТекстОшибки;
		ИначеЕсли Выборка.ЕстьОшибкиСтатус Тогда
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ТекстОшибкиСтатус,
				НСтр("ru='Объект эксплуатации'"),
				Выборка.ОбъектЭксплуатации,
				Выборка.Статус);
			ВызватьИсключение ТекстОшибки;
		КонецЕсли;
		
		ОбъектЭксплуатации = Выборка.ОбъектЭксплуатации;
		
	КонецЕсли;
	
	Если Не Пакет[1].Пустой() Тогда
		Выборка = Пакет[1].Выбрать();
		Пока Выборка.Следующий() Цикл
			Если Выборка.ЕстьОшибкиУдален Тогда
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ТекстОшибкиУдален,
					НСтр("ru='Узел объекта эксплуатации'"),
					Выборка.Узел);
				ВызватьИсключение ТекстОшибки;
			ИначеЕсли Выборка.ЕстьОшибкиСтатус Тогда
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ТекстОшибкиСтатус,
					НСтр("ru='Узел объекта эксплуатации'"),
					Выборка.Узел,
					Выборка.Статус);
				ВызватьИсключение ТекстОшибки;
			КонецЕсли;
			ЭтотОбъект.Ремонты.Добавить().Узел = Выборка.Узел;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

// Заполняет документ на основании зарегистрированного дефекта
//
Процедура ЗаполнитьДокументНаОснованииРегистрацииДефекта(Знач Основание)
	
	МассивДопустимыхСтатусов = Новый Массив();
	МассивДопустимыхСтатусов.Добавить(Перечисления.СтатусыДефектов.Зарегистрирован);
	МассивДопустимыхСтатусов.Добавить(Перечисления.СтатусыДефектов.ОтложеноУстранение);
	МассивДопустимыхСтатусов.Добавить(Перечисления.СтатусыДефектов.Признан);
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	РегистрацияДефекта.ОбъектЭксплуатации КАК ОбъектЭксплуатации,
		|	РегистрацияДефекта.Решение КАК ТехРешение,
		|	РегистрацияДефекта.Ссылка КАК Дефект,
		|	НЕ РегистрацияДефекта.Проведен КАК ЕстьОшибкиПроведен,
		|	ВЫБОР
		|		КОГДА РегистрацияДефекта.Статус В (&МассивДопустимыхСтатусов)
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК ЕстьОшибкиСтатус,
		|	РегистрацияДефекта.Статус КАК СтатусДокумента,
		|	РегистрацияДефекта.ТребуетсяЗаказНаРемонт КАК ТребуетсяЗаказНаРемонт
		|ИЗ
		|	Документ.РегистрацияДефекта КАК РегистрацияДефекта
		|ГДЕ
		|	РегистрацияДефекта.Ссылка = &Основание
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Узлы.Узел КАК Узел
		|ИЗ
		|	Документ.РегистрацияДефекта.ДефектныеУзлы КАК Узлы
		|ГДЕ
		|	Узлы.Ссылка = &Основание
		|
		|УПОРЯДОЧИТЬ ПО
		|	Узлы.НомерСтроки");
	
	Запрос.УстановитьПараметр("МассивДопустимыхСтатусов", МассивДопустимыхСтатусов);
	Запрос.УстановитьПараметр("Основание", Основание);
	
	Пакет = Запрос.ВыполнитьПакет();
	
	Если Не Пакет[0].Пустой() Тогда
		
		Таблица = Пакет[0].Выгрузить();
		Реквизиты = Таблица[0];
		
		ОбщегоНазначенияУТ.ПроверитьВозможностьВводаНаОсновании(
			Реквизиты.Дефект,
			Реквизиты.СтатусДокумента,
			Реквизиты.ЕстьОшибкиПроведен,
			Реквизиты.ЕстьОшибкиСтатус,
			МассивДопустимыхСтатусов);
		
		Если Не Реквизиты.ТребуетсяЗаказНаРемонт Тогда
			ТекстОшибки = НСтр("ru='Для документа %Документ% указан способ устранения ""Устраняется на месте"".
			|Ввод на основании разрешен только для способа устранения ""Требуется ремонт"".'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Документ%", Основание);
			ВызватьИсключение ТекстОшибки;
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Реквизиты, "ОбъектЭксплуатации, ТехРешение");
		УстраняемыеДефекты.Загрузить(Таблица);
		
	КонецЕсли;
	
	Если Не Пакет[1].Пустой() Тогда
		Ремонты.Загрузить(Пакет[1].Выгрузить());
	КонецЕсли;
	
КонецПроцедуры

// Инициализирует ремонтное задание
//
Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Дата = ТекущаяДатаСеанса();
	Ответственный = Пользователи.ТекущийПользователь();
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	
	Если Не ЗначениеЗаполнено(НаименованиеРабот) Тогда
		НаименованиеРабот = НСтр("ru='Ремонт'");
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДатаНачала) Тогда
		ДатаНачала = Дата;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОбъектЭксплуатации) Тогда
		
		Подразделение = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОбъектЭксплуатации, "ЭксплуатирующееПодразделение");
		
	КонецЕсли;
	
	ОбеспечениеСервер.ЗаполнитьВариантОбеспеченияПоУмолчанию(МатериалыИРаботы);
	
КонецПроцедуры

// Дополняет дополнительные свойства массивом регистров для контроля
//
Процедура СформироватьСписокРегистровДляКонтроля()
	
	Массив = Новый Массив;

	Массив.Добавить(Движения.ОбеспечениеЗаказов);

	Если Не ДополнительныеСвойства.ЭтоНовый Тогда
		Массив.Добавить(Движения.ЗаказыНаВнутреннееПотребление);
		Массив.Добавить(Движения.ТрудозатратыКОформлению);
		Массив.Добавить(Движения.ОбеспечениеЗаказовРаботами);
	КонецЕсли;
	
	// Контроль выполняется при перепроведении, отмене проведения или если используются серии, чтобы проверить возможность
	// резервирования серий.
	Если Не ДополнительныеСвойства.ЭтоНовый
		Или НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ЗаказНаРемонт).ИспользоватьСерииНоменклатуры Тогда
		Массив.Добавить(Движения.ТоварыКОтгрузке);
	КонецЕсли;
	
	Если ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		Массив.Добавить(Движения.ГрафикОтгрузкиТоваров);
		Массив.Добавить(Движения.СвободныеОстатки);
	КонецЕсли;
	
	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);
	
КонецПроцедуры

// Заполняет ключи строк для указаной табличной части
//
Процедура УстановитьКлючиВСтрокахТабличнойЧасти(ТабличнаяЧасть, ИмяКлюча, ТекущийМаксимальныйКлюч)
	
	СтрокиБезКлюча = ТабличнаяЧасть.НайтиСтроки(Новый Структура(ИмяКлюча, 0));
	Если СтрокиБезКлюча.Количество() > 0 Тогда
		
		Для Каждого СтрокаТовары Из СтрокиБезКлюча Цикл
			
			ТекущийМаксимальныйКлюч = ТекущийМаксимальныйКлюч + 1;
			СтрокаТовары[ИмяКлюча] = ТекущийМаксимальныйКлюч;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

// Проверяет правильность заполнения табличной части "Ремонты"
//
Процедура ПроверитьЗаполнениеРемонтов(Отказ) 
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ВЫРАЗИТЬ(ДанныеТабличнойЧасти.НомерСтроки КАК ЧИСЛО) КАК НомерСтроки,
		|	ВЫРАЗИТЬ(ДанныеТабличнойЧасти.Узел КАК Справочник.УзлыОбъектовЭксплуатации) КАК Узел,
		|	ВЫРАЗИТЬ(ДанныеТабличнойЧасти.ВидРемонта КАК Справочник.ВидыРемонтов) КАК ВидРемонта
		|ПОМЕСТИТЬ ДанныеТабличнойЧасти
		|ИЗ
		|	&ДанныеТабличнойЧасти КАК ДанныеТабличнойЧасти
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ДанныеТабличнойЧасти1.НомерСтроки КАК НомерСтроки
		|ИЗ
		|	ДанныеТабличнойЧасти КАК ДанныеТабличнойЧасти1
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ДанныеТабличнойЧасти КАК ДанныеТабличнойЧасти2
		|		ПО ДанныеТабличнойЧасти1.Узел = ДанныеТабличнойЧасти2.Узел
		|			И ДанныеТабличнойЧасти1.ВидРемонта = ДанныеТабличнойЧасти2.ВидРемонта
		|			И ДанныеТабличнойЧасти1.НомерСтроки <> ДанныеТабличнойЧасти2.НомерСтроки");
	
	ТаблицаРемонтов = ЭтотОбъект.Ремонты.Выгрузить();
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьУзлыОбъектовЭксплуатации") Тогда
		ТаблицаРемонтов.ЗаполнитьЗначения(Справочники.УзлыОбъектовЭксплуатации.ПустаяСсылка(), "Узел");
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ДанныеТабличнойЧасти", ТаблицаРемонтов);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	
	ШаблонОшибки = НСтр("ru='Ремонт ""%ВидРемонта%"" для ""%ОбъектИлиУзел%"" в строке %НомерСтроки% повторяется в других строках табличной части'");
	
	Пока Выборка.Следующий() Цикл
		
		СтрокаРемонта = ТаблицаРемонтов[Выборка.НомерСтроки - 1];
		ТекстОшибки = СтрЗаменить(ШаблонОшибки, "%ВидРемонта%", ?(ЗначениеЗаполнено(СтрокаРемонта.ВидРемонта), СтрокаРемонта.ВидРемонта, НСтр("ru='<произвольный ремонт>'")));
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ОбъектИлиУзел%", ?(ЗначениеЗаполнено(СтрокаРемонта.Узел), СтрокаРемонта.Узел, ЭтотОбъект.ОбъектЭксплуатации));
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%НомерСтроки%", Выборка.НомерСтроки);
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Ремонты", Выборка.НомерСтроки, "НомерСтроки"),,
			Отказ);
		
	КонецЦикла;
	
КонецПроцедуры

// Проверяет правильность заполнения табличной части "Материалы и работы"
//
Процедура ПроверитьЗаполнениеМатериаловИРабот(Отказ) 
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ВЫРАЗИТЬ(ДанныеТабличнойЧасти.НомерСтроки КАК ЧИСЛО) КАК НомерСтроки,
		|	ВЫРАЗИТЬ(ДанныеТабличнойЧасти.Номенклатура КАК Справочник.Номенклатура) КАК Номенклатура,
		|	ВЫРАЗИТЬ(ДанныеТабличнойЧасти.Склад КАК Справочник.Склады) КАК Склад,
		|	ДанныеТабличнойЧасти.Отменено КАК Отменено,
		|	ДанныеТабличнойЧасти.ВариантОбеспечения КАК ВариантОбеспечения
		|ПОМЕСТИТЬ ДанныеДляПроверки
		|ИЗ
		|	&ДанныеТабличнойЧасти КАК ДанныеТабличнойЧасти
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДанныеДляПроверки.НомерСтроки КАК НомерСтроки,
		|	ВЫБОР КОГДА ДанныеДляПроверки.Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
		|		И ДанныеДляПроверки.Номенклатура.ТипНоменклатуры В(
		|			ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар),
		|			ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара))
		|		И ДанныеДляПроверки.ВариантОбеспечения <> ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.НеТребуется)
		|		И НЕ ДанныеДляПроверки.Отменено ТОГДА
		|				ИСТИНА
		|			ИНАЧЕ
		|				ЛОЖЬ
		|		КОНЕЦ КАК ОшибкаСклад
		|ИЗ
		|	ДанныеДляПроверки КАК ДанныеДляПроверки");
	
	Запрос.УстановитьПараметр("ДанныеТабличнойЧасти", ЭтотОбъект.МатериалыИРаботы.Выгрузить( ,
		"НомерСтроки, Номенклатура, Склад, ВариантОбеспечения, Отменено"));
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ТекстОшибки = НСтр("ru='Не заполнена колонка ""%ИмяКолонки%"" в строке %НомерСтроки% списка ""Материалы и работы""'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%НомерСтроки%", Выборка.НомерСтроки);
		
		Если Выборка.ОшибкаСклад Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтрЗаменить(ТекстОшибки, "%ИмяКолонки%", НСтр("ru='Склад'")),
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("МатериалыИРаботы", Выборка.НомерСтроки, "Склад"),
				,
				Отказ);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Проверяет правильность заполнения табличной части "Рабочие центры" переданного объекта документа.
//
Процедура ПроверитьЗаполнениеРабочихЦентров(Отказ)
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ВЫРАЗИТЬ(ДанныеТабличнойЧасти.НомерСтроки КАК ЧИСЛО) КАК НомерСтроки,
		|	ДанныеТабличнойЧасти.РабочийЦентр КАК РабочийЦентр,
		|	ВЫРАЗИТЬ(ДанныеТабличнойЧасти.ДатаНачала КАК ДАТА) КАК ДатаНачала,
		|	ВЫРАЗИТЬ(ДанныеТабличнойЧасти.ДатаЗавершения КАК ДАТА) КАК ДатаЗавершения
		|ПОМЕСТИТЬ ДанныеТабличнойЧасти
		|ИЗ
		|	&ДанныеТабличнойЧасти КАК ДанныеТабличнойЧасти
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ДанныеТабличнойЧасти1.НомерСтроки КАК НомерСтроки
		|ИЗ
		|	ДанныеТабличнойЧасти КАК ДанныеТабличнойЧасти1
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ДанныеТабличнойЧасти КАК ДанныеТабличнойЧасти2
		|		ПО ДанныеТабличнойЧасти1.РабочийЦентр = ДанныеТабличнойЧасти2.РабочийЦентр
		|			И ДанныеТабличнойЧасти1.НомерСтроки <> ДанныеТабличнойЧасти2.НомерСтроки
		|			И (ДанныеТабличнойЧасти1.ДатаНачала <= ДанныеТабличнойЧасти2.ДатаНачала
		|					И ДанныеТабличнойЧасти1.ДатаЗавершения > ДанныеТабличнойЧасти2.ДатаНачала
		|				ИЛИ ДанныеТабличнойЧасти1.ДатаНачала < ДанныеТабличнойЧасти2.ДатаЗавершения
		|					И ДанныеТабличнойЧасти1.ДатаЗавершения >= ДанныеТабличнойЧасти2.ДатаЗавершения)");
	
	Запрос.УстановитьПараметр("ДанныеТабличнойЧасти", ЭтотОбъект.РабочиеЦентры.Выгрузить());
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	
	ШаблонОшибки = НСтр("ru='Интервал остановки рабочего центра ""%РЦ%"" в строке %НомерСтроки% пересекается с другими строками табличной части'");
	
	Пока Выборка.Следующий() Цикл
		
		Строка = ЭтотОбъект.РабочиеЦентры[Выборка.НомерСтроки - 1];
		ТекстОшибки = СтрЗаменить(ШаблонОшибки, "%РЦ%", Строка.РабочийЦентр);
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%НомерСтроки%", Выборка.НомерСтроки);
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("РабочиеЦентры", Выборка.НомерСтроки, "ДатаНачала"),,
			Отказ);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ВыполнитьКонтрольЗаказаПослеПроведения(Отказ)

	Если Статус = Перечисления.СтатусыЗаказовНаРемонт.Закрыт Тогда
		Массив = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Ссылка);
		ДополнительныеПараметры = Новый Структура("КонтрольВыполненияЗаказа", Истина);
		
		Запрос = Документы.ЗаказНаРемонт.СформироватьЗапросПроверкиПриСменеСтатуса(Массив, "Закрыт", ДополнительныеПараметры);
		
		Результат = Запрос.Выполнить();
		
		ВыборкаОтгрузка = Результат.Выбрать();
		
		ШаблонСообщения = НСтр("ru='У документа %Документ% не может быть установлен статус ""%Статус%"", т.к. заказ выполен не полностью'");
		
		Пока ВыборкаОтгрузка.Следующий() Цикл
			
			ПроверкаПройдена = Документы.ЗаказНаРемонт.ПроверкаПередСменойСтатуса(
									ВыборкаОтгрузка, 
									Статус, 
									ДополнительныеПараметры, 
									ШаблонСообщения); 
									
			Если Не ПроверкаПройдена Тогда
				Отказ = Истина;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;

КонецПроцедуры

Процедура ОчиститьНедоступныеСтатьиРасходов()

	НедоступныеСтатьи = УправлениеРемонтами.НедоступныеСтатьиРасходовНаРемонт(Ремонты.ВыгрузитьКолонку("СтатьяРасходов"));
	
	Если НедоступныеСтатьи.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого ДанныеСтроки Из Ремонты Цикл
		Если НедоступныеСтатьи.Найти(ДанныеСтроки.СтатьяРасходов) <> Неопределено Тогда
			ДанныеСтроки.СтатьяРасходов = Неопределено;
		КонецЕсли;
	КонецЦикла; 
	
КонецПроцедуры
 
#КонецОбласти

#КонецЕсли
