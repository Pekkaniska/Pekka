
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ВнеоборотныеАктивы.ПроверитьСоответствиеДатыВерсииУчета(ЭтотОбъект, Истина, Отказ);
	
	ВспомогательныеРеквизиты = Новый Структура;
	ВспомогательныеРеквизиты.Вставить("ИспользоватьОбъектыСтроительства", ПолучитьФункциональнуюОпцию("ИспользоватьОбъектыСтроительства"));
	ВспомогательныеРеквизиты.Вставить("ПлательщикНалогаНаПрибыль", УчетнаяПолитика.ПлательщикНалогаНаПрибыль(Организация, Дата));
	ПараметрыРеквизитовОбъекта = ВнеоборотныеАктивыКлиентСервер.ЗначенияСвойствЗависимыхРеквизитов_МодернизацияОС(ЭтотОбъект, ВспомогательныеРеквизиты);
	ВнеоборотныеАктивыСлужебный.ОтключитьПроверкуЗаполненияРеквизитовОбъекта(ПараметрыРеквизитовОбъекта, МассивНепроверяемыхРеквизитов);
	
	ПроверитьРеквизитыУчета(ПараметрыРеквизитовОбъекта, МассивНепроверяемыхРеквизитов, Отказ);
	ПроверитьВозможностьВводаАмортизационнойПремииВПроцентах(Отказ);
	ПроверитьОсновныеСредства(Отказ);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьДокументПередЗаполнением();
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("Структура") Тогда
		ЗаполнитьДокументПоОтбору(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("СправочникСсылка.ОбъектыЭксплуатации") Тогда
		ЗаполнитьНаОснованииОбъектаЭксплуатации(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("СправочникСсылка.ОбъектыСтроительства") Тогда
		ЗаполнитьНаОснованииОбъектаСтроительства(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.МодернизацияОС2_4") Тогда
		ЗаполнитьНаОснованииМодернизации(ДанныеЗаполнения);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ДокументВДругомУчете = Неопределено;
	Комментарий = "";
	
	ИнициализироватьДокументПередЗаполнением();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	Если Не Отказ И ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ВнеоборотныеАктивыСлужебный.ПроверитьЧтоОСПринятыКУчету(ЭтотОбъект, Отказ);
	КонецЕсли;
	
	ВнеоборотныеАктивыСлужебный.ЗаполнитьСуммыЦелевыхСредств(ОС, ЦелевоеФинансирование, ВариантПримененияЦелевогоФинансирования);
	ВнеоборотныеАктивыСлужебный.ЦелевоеФинансированиеОчиститьСубконто(ЦелевоеФинансирование);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Отказ И ДополнительныеСвойства.РежимЗаписи <> РежимЗаписиДокумента.Проведение Тогда
		ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
		Документы.МодернизацияОС2_4.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства, "РеестрДокументов,ДокументыПоОС");
		РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
		РегистрыСведений.ДокументыПоОС.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ЗаблокироватьЧитаемыеДанные();
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	Документы.МодернизацияОС2_4.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ПроведениеСерверУТ.ЗагрузитьТаблицыДвижений(ДополнительныеСвойства, Движения);
	РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	РегистрыСведений.ДокументыПоОС.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	
	РеглУчетПроведениеСервер.ЗарегистрироватьКОтражению(ЭтотОбъект, ДополнительныеСвойства, Движения, Отказ);
	//++ НЕ УТКА
	МеждународныйУчетПроведениеСервер.ЗарегистрироватьКОтражению(ЭтотОбъект, ДополнительныеСвойства, Движения, Отказ);
	//-- НЕ УТКА
	
	СформироватьСписокРегистровДляКонтроля();
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	СформироватьСписокРегистровДляКонтроля();
	
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Заполнение

Процедура ИнициализироватьДокументПередЗаполнением()
	
	Ответственный = Пользователи.ТекущийПользователь();
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	
	ОтражатьВУпрУчете = Истина;
	
	Если ВнеоборотныеАктивыСлужебный.ДоступенВыборОтраженияВУчетах(Дата) Тогда
		ОтражатьВРеглУчете = Истина;
	Иначе
		ОтражатьВРеглУчете = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьДокументПоОтбору(Основание)

	Если Основание.Свойство("ОсновноеСредство") Тогда
		ЗаполнитьНаОснованииОбъектаЭксплуатации(Основание.ОсновноеСредство);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ЗаполнитьНаОснованииОбъектаЭксплуатации(Основание)
	
	Если НЕ ЗначениеЗаполнено(Основание) Тогда
		Возврат;
	КонецЕсли;
	
	РеквизитыОснования = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Основание, "ЭтоГруппа,НаправлениеДеятельности");
	
	Если РеквизитыОснования.ЭтоГруппа Тогда
		
		ТекстСообщения = НСтр("ru = 'Создание модернизации на основании группы ОС невозможно.
			|Выберите ОС. Для раскрытия группы используйте клавиши Ctrl и стрелку вниз.'");
		ВызватьИсключение(ТекстСообщения);
		
	КонецЕсли;
	
	ПервоначальныеСведения = ВнеоборотныеАктивыСлужебный.СообщитьЕслиОСНеПринятоКУчету(Основание, Дата);
	
	МестонахождениеОС = ВнеоборотныеАктивы.МестонахождениеОС(Основание);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, МестонахождениеОС);
	Подразделение = МестонахождениеОС.Местонахождение;
	
	НаправлениеДеятельности = РеквизитыОснования.НаправлениеДеятельности;
	
	СтрокаТабличнойЧасти = ОС.Добавить();
	СтрокаТабличнойЧасти.ОсновноеСредство = Основание;
	
	ОтражатьВУпрУчете = ЗначениеЗаполнено(ПервоначальныеСведения.ДокументВводаВЭксплуатациюУУ);
	ОтражатьВРеглУчете = ЗначениеЗаполнено(ПервоначальныеСведения.ДокументВводаВЭксплуатациюБУ);
	
	Документы.МодернизацияОС2_4.ЗаполнитьСуммуЗатрат(ЭтотОбъект);
	
КонецПроцедуры

Процедура ЗаполнитьНаОснованииОбъектаСтроительства(Основание)

	Если НЕ ЗначениеЗаполнено(Основание) Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Основание, "ЭтоГруппа") Тогда
		
		ТекстСообщения = НСтр("ru = 'Создание модернизации на основании группы объектов строительства невозможно.
			|Выберите объект строительства. Для раскрытия группы используйте клавиши Ctrl и стрелку внизю'");
		ВызватьИсключение(ТекстСообщения);
		
	КонецЕсли;
	
	ВидАналитикиКапитализацииРасходов = Перечисления.ВидыАналитикиКапитализацииРасходов.ОбъектСтроительства;
	ОбъектСтроительства = Основание;
	
КонецПроцедуры

Процедура ЗаполнитьНаОснованииМодернизации(Основание, ОсновноеСредство = Неопределено)

	ОснованиеОбъект = Основание.ПолучитьОбъект();
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ОснованиеОбъект,, "Номер,Дата,ВерсияДанных,Ответственный,ПометкаУдаления,Проведен");
	ДокументВДругомУчете = Основание;
	
	Если НЕ ЗначениеЗаполнено(ОсновноеСредство) Тогда
		Для каждого СтрокаОснования Из ОснованиеОбъект.ОС Цикл
			СтрокаТабличнойЧасти = ОС.Добавить();
			СтрокаТабличнойЧасти.ОсновноеСредство = СтрокаОснования.ОсновноеСредство;
		КонецЦикла; 
		ОС.Загрузить(ОснованиеОбъект.ОС.Выгрузить());
	Иначе
		СтрокаТабличнойЧасти = ОС.Добавить();
		СтрокаТабличнойЧасти.ОсновноеСредство = ОсновноеСредство;
	КонецЕсли; 
	
	Если ВнеоборотныеАктивыСлужебный.ДоступенВыборОтраженияВУчетах(Дата) Тогда
		Если ОснованиеОбъект.ОтражатьВРеглУчете Тогда
			ОтражатьВРеглУчете = Ложь;
			ОтражатьВУпрУчете  = Истина;
		Иначе
			ОтражатьВРеглУчете = Истина;
			ОтражатьВУпрУчете  = Ложь;
		КонецЕсли; 
	Иначе	
		ОтражатьВРеглУчете = Ложь;
		ОтражатьВУпрУчете  = Истина;
	КонецЕсли;
	
	Документы.МодернизацияОС2_4.ЗаполнитьСуммуЗатрат(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ПроверкаЗаполнения

Процедура ПроверитьРеквизитыУчета(ПараметрыРеквизитовОбъекта, МассивНепроверяемыхРеквизитов, Отказ)

	Если ВнеоборотныеАктивыКлиентСервер.ЗначениеСвойстваРеквизитаОбъекта("СтатьяРасходовАмортизационнойПремии", "Видимость", ПараметрыРеквизитовОбъекта) Тогда
		ПланыВидовХарактеристик.СтатьиРасходов.ПроверитьЗаполнениеАналитик(
			ЭтотОбъект, "СтатьяРасходовАмортизационнойПремии, АналитикаРасходовАмортизационнойПремии", МассивНепроверяемыхРеквизитов, Отказ);
	КонецЕсли; 
	
	Если ВнеоборотныеАктивыКлиентСервер.ЗначениеСвойстваРеквизитаОбъекта("СтатьяДоходов", "Видимость", ПараметрыРеквизитовОбъекта) Тогда
		ПланыВидовХарактеристик.СтатьиДоходов.ПроверитьЗаполнениеАналитик(ЭтотОбъект,, МассивНепроверяемыхРеквизитов, Отказ);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПроверитьОсновныеСредства(Отказ)

	УправлениеВнеоборотнымиАктивамиПереопределяемый.ПроверитьОтсутствиеДублейВТабличнойЧасти(
		ЭтотОбъект, "ОС", Новый Структура("ОсновноеСредство"), Отказ);
	
КонецПроцедуры

Процедура ПроверитьВозможностьВводаАмортизационнойПремииВПроцентах(Отказ)

	Если АмортизационнаяПремияУказанаВПроцентах
		И НЕ Документы.МодернизацияОС2_4.ДоступенВводАмортизационнойПремииВПроцентах(ЭтотОбъект) Тогда
		ТекстСообщения = НСтр("ru = 'Амортизационная премия должна указываться в виде фиксированной суммы, т.к. выбрана статья расходов с вариантом распределения ""На себестоимость товаров"" и основные средства используются в нескольких видах деятельности.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "СпособВводаАмортизационнойПремии",, Отказ); 
	КонецЕсли;
	
КонецПроцедуры
 
#КонецОбласти

#Область Прочее

Процедура СформироватьСписокРегистровДляКонтроля()
	
	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Новый Массив);
	
КонецПроцедуры

Процедура ЗаблокироватьЧитаемыеДанные()

	// Нужно заблокировать данные, которые используются при записи движений.
	// Например, данные регистров сведений, которые используются для заполнения недостающих ресурсов.
	
	Блокировка = Новый БлокировкаДанных;
	
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ПорядокУчетаОС");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.ИсточникДанных = ОС;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("ОсновноеСредство", "ОсновноеСредство");
	
	Если ОтражатьВРеглУчете Тогда
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ПараметрыАмортизацииОСБУ");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.ИсточникДанных = ОС;
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("ОсновноеСредство", "ОсновноеСредство");
		ЭлементБлокировки.УстановитьЗначение("Организация", Организация);
	КонецЕсли; 
	
	Если ОтражатьВУпрУчете Тогда
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ПараметрыАмортизацииОСУУ");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.ИсточникДанных = ОС;
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("ОсновноеСредство", "ОсновноеСредство");
		ЭлементБлокировки.УстановитьЗначение("Организация", Организация);
	КонецЕсли; 
		
	Блокировка.Заблокировать(); 
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли