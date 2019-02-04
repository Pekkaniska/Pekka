#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьДокумент();
	
	ТипОснования = ТипЗнч(ДанныеЗаполнения);
	Если ТипОснования = Тип("СправочникСсылка.НематериальныеАктивы") Тогда
		ЗаполнитьНаОснованииНематериальногоАктива(ДанныеЗаполнения);
	ИначеЕсли ТипОснования = Тип("ДокументСсылка.ПринятиеКУчетуНМА2_4") Тогда
		ЗаполнитьНаОснованииПринятияКУчету(ДанныеЗаполнения);
	ИначеЕсли ТипОснования = Тип("ДокументСсылка.ПеремещениеНМА2_4") Тогда
		ЗаполнитьНаОснованииПеремещения(ДанныеЗаполнения);
	ИначеЕсли ТипОснования = Тип("ДокументСсылка.ИзменениеПараметровНМА2_4") Тогда
		ЗаполнитьНаОснованииИзмененияПараметров(ДанныеЗаполнения);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ВнеоборотныеАктивы.ПроверитьСоответствиеДатыВерсииУчета(ЭтотОбъект, Истина, Отказ);
	
	УправлениеВнеоборотнымиАктивамиПереопределяемый.ПроверитьОтсутствиеДублейВТабличнойЧасти(
		ЭтотОбъект, "НМА", Новый Структура("НематериальныйАктив"), Отказ);
		
	ПроверитьЗаполнениеПараметров(Отказ);
	
	НепроверяемыеРеквизиты = Новый Массив;
	
	ПараметрыРеквизитовОбъекта = ВнеоборотныеАктивыКлиентСервер.ЗначенияСвойствЗависимыхРеквизитов_ИзменениеПараметровНМА(ЭтотОбъект);
	ВнеоборотныеАктивыСлужебный.ОтключитьПроверкуЗаполненияРеквизитовОбъекта(ПараметрыРеквизитовОбъекта, НепроверяемыеРеквизиты);
	
	Если ГруппаФинансовогоУчетаФлаг И ЗначениеЗаполнено(ГруппаФинансовогоУчета) Тогда
		ПроверитьСоответствиеНастроек(Отказ);
	КонецЕсли;
	
	Если НепроверяемыеРеквизиты.Найти("АмортизационныеРасходы") <> Неопределено Тогда
		Для каждого РеквизитАмортизационныеРасходы Из Метаданные().ТабличныеЧасти.АмортизационныеРасходы.Реквизиты Цикл
			НепроверяемыеРеквизиты.Добавить("АмортизационныеРасходы." + РеквизитАмортизационныеРасходы.Имя);
		КонецЦикла;
	Иначе
		НепроверяемыеРеквизиты.Добавить("АмортизационныеРасходы.ОрганизацияПолучательРасходов");
		
		Для каждого ДанныеСтроки Из АмортизационныеРасходы Цикл
			Если ДанныеСтроки.ПередаватьРасходыВДругуюОрганизацию
				И Не ЗначениеЗаполнено(ДанныеСтроки.ОрганизацияПолучательРасходов) Тогда
				Путь = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(
					"АмортизационныеРасходы", ДанныеСтроки.НомерСтроки, "ОрганизацияПолучательРасходов");
				ТекстСообщения = СтрШаблон(
					НСтр("ru='Не заполнено поле ""Организация-получатель расходов"" в строке ""%1"" списка ""Амортизационные расходы"".'"),
					ДанныеСтроки.НомерСтроки);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Путь,, Отказ);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	ПланыВидовХарактеристик.СтатьиРасходов.ПроверитьЗаполнениеАналитик(
		ЭтотОбъект,
		Новый Структура("АмортизационныеРасходы", "СтатьяРасходов, АналитикаРасходов"),
		НепроверяемыеРеквизиты,
		Отказ);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ВнеоборотныеАктивыСлужебный.ПроверитьЧтоНМАПринятыКУчету(ЭтотОбъект, Отказ);
	КонецЕсли;
	
	СуммаКоэффициентовАмортизации = АмортизационныеРасходы.Итог("Коэффициент");
	СуммаКоэффициентовПредыдущихСтрок = 0;
	Для каждого ДанныеСтроки Из АмортизационныеРасходы Цикл
		ДанныеСтроки.СуммаКоэффициентовПредыдущихСтрок = СуммаКоэффициентовПредыдущихСтрок;
		СуммаКоэффициентовПредыдущихСтрок = СуммаКоэффициентовПредыдущихСтрок + ДанныеСтроки.Коэффициент;
	КонецЦикла;
	
	ЗначенияСвойствЗависимыхРеквизитов =
		ВнеоборотныеАктивыКлиентСервер.ЗначенияСвойствЗависимыхРеквизитов_ИзменениеПараметровНМА(ЭтотОбъект);
	ВнеоборотныеАктивыСлужебный.ОчиститьНеиспользуемыеРеквизиты(ЭтотОбъект, ЗначенияСвойствЗависимыхРеквизитов);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Отказ И ДополнительныеСвойства.РежимЗаписи <> РежимЗаписиДокумента.Проведение Тогда
		ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
		Документы.ИзменениеПараметровНМА2_4.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства, "РеестрДокументов, ДокументыПоНМА");
		РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
		РегистрыСведений.ДокументыПоНМА.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ДокументВДругомУчете = Неопределено;
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ЗаблокироватьДанные();
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	Документы.ИзменениеПараметровНМА2_4.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ПроведениеСерверУТ.ЗагрузитьТаблицыДвижений(ДополнительныеСвойства, Движения);
	РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	РегистрыСведений.ДокументыПоНМА.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	
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
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьДокумент()
	
	Ответственный = Пользователи.ТекущийПользователь();
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Подразделение = ЗначениеНастроекПовтИсп.ПодразделениеПользователя(Ответственный, Подразделение);
	
	ОтражатьВУпрУчете = Истина;
	ОтражатьВРеглУчете = ВнеоборотныеАктивыСлужебный.ДоступенВыборОтраженияВУчетах(ТекущаяДатаСеанса());
	
КонецПроцедуры

Процедура СформироватьСписокРегистровДляКонтроля()
	
	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Новый Массив);
	
КонецПроцедуры

Процедура ЗаблокироватьДанные()
	
	Блокировка = Новый БлокировкаДанных;
	
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ПорядокУчетаНМА");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.ИсточникДанных = НМА;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("НематериальныйАктив", "НематериальныйАктив");
	ЭлементБлокировки.УстановитьЗначение("Организация", Организация);
	
	Если ОтражатьВУпрУчете Тогда
		
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ПорядокУчетаНМАУУ");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.ИсточникДанных = НМА;
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("НематериальныйАктив", "НематериальныйАктив");
		ЭлементБлокировки.УстановитьЗначение("Организация", Организация);
		
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ПараметрыАмортизацииНМАУУ");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.ИсточникДанных = НМА;
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("НематериальныйАктив", "НематериальныйАктив");
		ЭлементБлокировки.УстановитьЗначение("Организация", Организация);
	КонецЕсли;
	
	Если ОтражатьВРеглУчете Тогда
		
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ПараметрыАмортизацииНМАБУ");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.ИсточникДанных = НМА;
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("НематериальныйАктив", "НематериальныйАктив");
		ЭлементБлокировки.УстановитьЗначение("Организация", Организация);
		
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ПараметрыАмортизацииНМАБУ");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.ИсточникДанных = НМА;
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("НематериальныйАктив", "НематериальныйАктив");
		ЭлементБлокировки.УстановитьЗначение("Организация", Организация);
	КонецЕсли;
	
	Блокировка.Заблокировать();
	
КонецПроцедуры

Процедура ПроверитьЗаполнениеПараметров(Отказ)
	
	Если Не ПорядокУчетаФлаг
		И Не НачислятьАмортизациюНУФлаг
		И Не СпособНачисленияАмортизацииУУФлаг
		И Не СрокИспользованияУУФлаг
		И Не ОбъемНаработкиФлаг
		И Не КоэффициентУскоренияУУФлаг
		И Не СпециальныйКоэффициентНУФлаг
		И Не ЛиквидационнаяСтоимостьФлаг
		И Не ГруппаФинансовогоУчетаФлаг
		И Не АмортизационныеРасходыФлаг Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Необходимо выбрать изменяемые параметры'"), Ссылка,,, Отказ);
	КонецЕсли;
	
	Если ГруппаФинансовогоУчетаФлаг 
		И (НЕ ОтражатьВРеглУчете ИЛИ НЕ ОтражатьВУпрУчете) Тогда
		
		ТекстЗапроса = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	1 КАК Поле1
		|ИЗ
		|	Справочник.НематериальныеАктивы КАК НематериальныеАктивы
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПорядокУчетаНМАБУ.СрезПоследних(
		|				&Дата,
		|				Регистратор <> &Ссылка
		|					И Организация = &Организация
		|					И НематериальныйАктив В (&СписокНМА)) КАК ПорядокУчетаБУ
		|		ПО (ПорядокУчетаБУ.НематериальныйАктив = НематериальныеАктивы.Ссылка)
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПорядокУчетаНМАУУ.СрезПоследних(
		|				&Дата,
		|				Регистратор <> &Ссылка
		|					И Организация = &Организация
		|					И НематериальныйАктив В (&СписокНМА)) КАК ПорядокУчетаУУ
		|		ПО (ПорядокУчетаУУ.НематериальныйАктив = НематериальныеАктивы.Ссылка)
		|ГДЕ
		|	НематериальныеАктивы.Ссылка В(&СписокНМА)
		|	И ПорядокУчетаБУ.Состояние = ЗНАЧЕНИЕ(Перечисление.ВидыСостоянийНМА.ПринятКУчету)
		|	И ПорядокУчетаУУ.Состояние = ЗНАЧЕНИЕ(Перечисление.ВидыСостоянийНМА.ПринятКУчету)";
		
		Запрос = Новый Запрос(ТекстЗапроса);
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Запрос.УстановитьПараметр("Дата", Дата);
		Запрос.УстановитьПараметр("Организация", Организация);
		Запрос.УстановитьПараметр("СписокНМА", НМА.ВыгрузитьКолонку("НематериальныйАктив"));
		
		Результат = Запрос.Выполнить();
		Если НЕ Результат.Пустой() Тогда
			ТекстСообщения = НСтр("ru = 'Необходимо отразить изменение параметров в управленческом и регламентированном учетах, т.к. изменяется группа финансового учета и выбраны нематериальные активы (расходы на НИОКР), которые приняты в обоих учетах'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "ВариантОтраженияВУчете");
		КонецЕсли; 
		
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПроверитьСоответствиеНастроек(Отказ)
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ТаблицаПроверки.НематериальныйАктив КАК НематериальныйАктив,
	|	ТаблицаПроверки.НематериальныйАктив.Представление КАК НематериальныйАктивПредставление,
	|	ТаблицаПроверки.НевернаяГФУ КАК НевернаяГФУ,
	|	ТаблицаПроверки.НедопускаетсяИзменениеНачисленияАмортизации КАК НедопускаетсяИзменениеНачисленияАмортизации
	|ИЗ
	|	(ВЫБРАТЬ
	|		НематериальныеАктивы.Ссылка КАК НематериальныйАктив,
	|		НематериальныеАктивы.ВидОбъектаУчета = ЗНАЧЕНИЕ(Перечисление.ВидыОбъектовУчетаНМА.НематериальныйАктив)
	|				И ГФУ.ВидАктива <> ЗНАЧЕНИЕ(Перечисление.ВидыВнеоборотныхАктивов.НМА)
	|			ИЛИ НематериальныеАктивы.ВидОбъектаУчета = ЗНАЧЕНИЕ(Перечисление.ВидыОбъектовУчетаНМА.РасходыНаНИОКР)
	|				И ГФУ.ВидАктива <> ЗНАЧЕНИЕ(Перечисление.ВидыВнеоборотныхАктивов.НИОКР) КАК НевернаяГФУ,
	|		НематериальныеАктивы.ВидОбъектаУчета <> ЗНАЧЕНИЕ(Перечисление.ВидыОбъектовУчетаНМА.НематериальныйАктив)
	|			И &НачислятьАмортизациюНУФлаг КАК НедопускаетсяИзменениеНачисленияАмортизации
	|	ИЗ
	|		Справочник.НематериальныеАктивы КАК НематериальныеАктивы
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ГруппыФинансовогоУчетаВнеоборотныхАктивов КАК ГФУ
	|			ПО (ГФУ.Ссылка = &ГФУ)
	|	ГДЕ
	|		НематериальныеАктивы.Ссылка В(&НематериальныеАктивы)) КАК ТаблицаПроверки
	|ГДЕ
	|	(ТаблицаПроверки.НевернаяГФУ = ИСТИНА
	|			ИЛИ ТаблицаПроверки.НедопускаетсяИзменениеНачисленияАмортизации = ИСТИНА)";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("НематериальныеАктивы", НМА.ВыгрузитьКолонку("НематериальныйАктив"));
	Запрос.УстановитьПараметр("ГФУ", ГруппаФинансовогоУчета);
	Запрос.УстановитьПараметр("НачислятьАмортизациюНУФлаг", НачислятьАмортизациюНУФлаг И ОтражатьВРеглУчете);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ДанныеСтроки = НМА.Найти(Выборка.НематериальныйАктив, "НематериальныйАктив");
		
		Путь = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("НМА", ДанныеСтроки.НомерСтроки, "НематериальныйАктив");
		
		Если Выборка.НевернаяГФУ = Истина Тогда
			ТекстСообщения = НСтр("ru='Вид объекта учета нематериального актива ""%1"" не соответствует виду актива группы финансового учета.'");
			ТекстСообщения = СтрШаблон(ТекстСообщения, Выборка.НематериальныйАктивПредставление);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Путь,, Отказ);
		КонецЕсли; 
			
		Если Выборка.НедопускаетсяИзменениеНачисленияАмортизации = Истина Тогда
			ТекстСообщения = НСтр("ru = 'Для расходов на НИОКР ""%1"" не допускается изменение начисления амортизации.'");
			ТекстСообщения = СтрШаблон(ТекстСообщения, Выборка.НематериальныйАктивПредставление);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Путь,, Отказ);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьНаОснованииНематериальногоАктива(Основание)
	
	Если НЕ ЗначениеЗаполнено(Основание) Тогда
		Возврат;
	КонецЕсли;
	
	РеквизитыОснования = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Основание, "ЭтоГруппа");
	
	Если РеквизитыОснования.ЭтоГруппа Тогда
		
		ТекстСообщения = НСтр("ru = 'Изменение параметров группы НМА невозможно.
			|Выберите НМА. Для раскрытия группы используйте клавиши Ctrl и стрелку вниз.'");
		ВызватьИсключение(ТекстСообщения);
		
	КонецЕсли;
	
	ПервоначальныеСведения = ВнеоборотныеАктивыСлужебный.СообщитьЕслиНМАНеПринятКУчету(Основание, Дата);

	МестоУчетаНМА = ВнеоборотныеАктивы.МестоУчетаНМА(Основание);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, МестоУчетаНМА);
	
	СтрокаТабличнойЧасти = НМА.Добавить();
	СтрокаТабличнойЧасти.НематериальныйАктив = Основание;
	
	ОтражатьВУпрУчете = ЗначениеЗаполнено(ПервоначальныеСведения.ДокументПринятияКУчетуУУ);
	ОтражатьВРеглУчете = ЗначениеЗаполнено(ПервоначальныеСведения.ДокументПринятияКУчетуБУ);
	
КонецПроцедуры

Процедура ЗаполнитьНаОснованииПринятияКУчету(Основание)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.НематериальныйАктив КАК НематериальныйАктив,
	|	&Основание КАК ДокументОснование,
	|	ДанныеДокумента.ОтражатьВРеглУчете КАК ОтражатьВРеглУчете,
	|	ДанныеДокумента.ОтражатьВУпрУчете КАК ОтражатьВУпрУчете
	|ИЗ
	|	Документ.ПринятиеКУчетуНМА2_4 КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Основание";
	
	Запрос.УстановитьПараметр("Основание", Основание);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
		НМА.Добавить().НематериальныйАктив = Выборка.НематериальныйАктив;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьНаОснованииИзмененияПараметров(Основание, НематериальныйАктив = Неопределено)

	ОснованиеОбъект = Основание.ПолучитьОбъект();
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ОснованиеОбъект,, "Номер,Дата,ВерсияДанных,Ответственный,ПометкаУдаления,Проведен");
	ДокументВДругомУчете = Основание;
	
	Если НЕ ЗначениеЗаполнено(НематериальныйАктив) Тогда
		Для каждого СтрокаОснования Из ОснованиеОбъект.НМА Цикл
			СтрокаТабличнойЧасти = НМА.Добавить();
			СтрокаТабличнойЧасти.НематериальныйАктив = СтрокаОснования.НематериальныйАктив;
		КонецЦикла; 
		НМА.Загрузить(ОснованиеОбъект.НМА.Выгрузить());
	Иначе
		СтрокаТабличнойЧасти = НМА.Добавить();
		СтрокаТабличнойЧасти.НематериальныйАктив = НематериальныйАктив;
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
	
КонецПроцедуры

Процедура ЗаполнитьНаОснованииПеремещения(Основание)
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА ДанныеДокумента.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПеремещениеНМАвПодразделениеВыделенноеНаБаланс)
	|			ТОГДА ДанныеДокумента.ОрганизацияПолучатель
	|		ИНАЧЕ ДанныеДокумента.Организация
	|	КОНЕЦ КАК Организация,
	|	ДанныеДокумента.Ссылка КАК ДокументОснование,
	|	ДанныеДокумента.ОтражатьВРеглУчете КАК ОтражатьВРеглУчете,
	|	ДанныеДокумента.ОтражатьВУпрУчете КАК ОтражатьВУпрУчете
	|ИЗ
	|	Документ.ПеремещениеНМА2_4 КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТабличнаяЧасть.НематериальныйАктив КАК НематериальныйАктив
	|ИЗ
	|	Документ.ПеремещениеНМА2_4.НМА КАК ТабличнаяЧасть
	|ГДЕ
	|	ТабличнаяЧасть.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТабличнаяЧасть.НомерСтроки";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Ссылка", Основание);
	Пакет = Запрос.ВыполнитьПакет();
	
	Если Не Пакет[0].Пустой() Тогда
		Выборка = Пакет[0].Выбрать();
		Выборка.Следующий();
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
	КонецЕсли;
	
	Если Не Пакет[1].Пустой() Тогда
		НМА.Загрузить(Пакет[1].Выгрузить());
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли