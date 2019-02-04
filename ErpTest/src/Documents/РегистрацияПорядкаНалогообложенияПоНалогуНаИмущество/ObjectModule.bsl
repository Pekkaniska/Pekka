#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ИнициализироватьДокумент();
	
	Если ТекущаяДатаСеанса() >= '201901010000' 
		И ВидОбъектаНалогаНаИмущество <> Перечисления.ВидыОбъектовНалогаНаИмущество.НедвижимоеИмущество 
		И ЗначениеЗаполнено(ВидОбъектаНалогаНаИмущество) Тогда
		Дата = ОбъектКопирования.Дата;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ДополнительныеСвойства.Вставить("ДляПроведения", Новый Структура);
	ДополнительныеСвойства.ДляПроведения.Вставить("СтруктураВременныеТаблицы", Новый Структура("МенеджерВременныхТаблиц", Новый МенеджерВременныхТаблиц));
	
	ПодлежитНалогообложению = (ПорядокНалогообложения <> Перечисления.ПорядокНалогообложенияИмущества.НеПодлежитНалогообложению);
	ЭтоНедвижимоеИмущество = (ВидОбъектаНалогаНаИмущество = Перечисления.ВидыОбъектовНалогаНаИмущество.НедвижимоеИмущество);
	
	ЗначенияЗаполнения = Новый Структура();

	ЗначенияЗаполнения.Вставить("КадастровыйНомер"); 
	ЗначенияЗаполнения.Вставить("КадастровыйНомерПомещения"); 
	ЗначенияЗаполнения.Вставить("УсловныйНомер"); 
	ЗначенияЗаполнения.Вставить("КадастроваяСтоимость"); 
	ЗначенияЗаполнения.Вставить("НеоблагаемаяКадастроваяСтоимость"); 
	ЗначенияЗаполнения.Вставить("ДатаРегистрацииПраваСобственности"); 
	ЗначенияЗаполнения.Вставить("ДатаПрекращенияПраваСобственности");
	ЗначенияЗаполнения.Вставить("КадастроваяСтоимостьОпределенаПоДолеПлощади"); 
	ЗначенияЗаполнения.Вставить("ДоляПлощадиЧислитель"); 
	ЗначенияЗаполнения.Вставить("ДоляПлощадиЗнаменатель"); 
	ЗначенияЗаполнения.Вставить("ОбщаяСобственность");
	ЗначенияЗаполнения.Вставить("ДоляВПравеОбщейСобственностиЧислитель");
	ЗначенияЗаполнения.Вставить("ДоляВПравеОбщейСобственностиЗнаменатель");
	ЗначенияЗаполнения.Вставить("ОтноситсяКТерриторииСубъектаРФВДоле"); 
	ЗначенияЗаполнения.Вставить("ДоляСтоимостиЧислитель"); 
	ЗначенияЗаполнения.Вставить("ДоляСтоимостиЗнаменатель"); 
	
	Для Каждого Строка Из ОС Цикл
		
		Если ПодлежитНалогообложению И ЭтоНедвижимоеИмущество Тогда
			
			Если Не Строка.ОтноситсяКТерриторииСубъектаРФВДоле Тогда
				Строка.ДоляСтоимостиЧислитель = 0;
				Строка.ДоляСтоимостиЗнаменатель = 0;
			КонецЕсли;
			Если Не Строка.ОбщаяСобственность Тогда
				Строка.ДоляВПравеОбщейСобственностиЗнаменатель = 0;
				Строка.ДоляВПравеОбщейСобственностиЧислитель = 0;
			КонецЕсли;
			Если Не Строка.КадастроваяСтоимостьОпределенаПоДолеПлощади Тогда
				Строка.ДоляПлощадиЧислитель = 0;
				Строка.ДоляПлощадиЗнаменатель = 0;
			КонецЕсли;
		Иначе
			ЗаполнитьЗначенияСвойств(Строка, ЗначенияЗаполнения);
		КонецЕсли;
		
	КонецЦикла;
	
	Если Дата = Дата(1, 1, 1, 0, 0, 0) Или Год(Дата) >= 2014 Тогда
		КодПоОКАТО = "";
	КонецЕсли;
	
	Если НЕ Документы.РегистрацияПорядкаНалогообложенияПоНалогуНаИмущество.ТребуетсяУказаниеКБК(КодВидаИмущества) Тогда
		КБК = "";
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		ПодготовитьДанныеДляФормированияЗаданияКЗакрытиюМесяцаПередЗаписью();
	КонецЕсли; 
	
	УказаныСпособыОтражениеРасходов = (ОтражениеРасходов.Количество() <> 0);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Отказ И ДополнительныеСвойства.РежимЗаписи <> РежимЗаписиДокумента.Проведение Тогда
		ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
		Документы.РегистрацияПорядкаНалогообложенияПоНалогуНаИмущество.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства, "РеестрДокументов,ДокументыПоОС");
		РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
		РегистрыСведений.ДокументыПоОС.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НепроверяемыеРеквизиты = Новый Массив;
	
	Если Дата = Дата(1, 1, 1, 0, 0, 0) Или Год(Дата) >= 2014 Тогда
		НепроверяемыеРеквизиты.Добавить("КодПоОКАТО");
	КонецЕсли;
	
	Если ПостановкаНаУчетВНалоговомОргане <> Перечисления.ПостановкаНаУчетВНалоговомОргане.ВДругомНалоговомОргане Тогда
		НепроверяемыеРеквизиты.Добавить("НалоговыйОрган");
	КонецЕсли;
	Если ПостановкаНаУчетВНалоговомОргане <> Перечисления.ПостановкаНаУчетВНалоговомОргане.СДругимКодомПоОКАТО
		И ПостановкаНаУчетВНалоговомОргане <> Перечисления.ПостановкаНаУчетВНалоговомОргане.ВДругомНалоговомОргане Тогда
		
		НепроверяемыеРеквизиты.Добавить("КодПоОКАТО");
		НепроверяемыеРеквизиты.Добавить("КодПоОКТМО");
		
	КонецЕсли;
	
	Если ПостановкаНаУчетВНалоговомОргане <> Перечисления.ПостановкаНаУчетВНалоговомОргане.ВДругомНалоговомОргане
		И НалоговаяБаза <> Перечисления.НалоговаяБазаПоНалогуНаИмущество.КадастроваяСтоимость Тогда
		
		НепроверяемыеРеквизиты.Добавить("НалоговаяСтавка");
		
	КонецЕсли;
	
	Если ПорядокНалогообложения <> Перечисления.ПорядокНалогообложенияИмущества.ОсвобождаетсяОтНалогообложения Тогда
		НепроверяемыеРеквизиты.Добавить("КодНалоговойЛьготыОсвобождениеОтНалогообложения");
	КонецЕсли; 
	
	Если КодНалоговойЛьготыОсвобождениеОтНалогообложения = "2010257" 
		И ВидОбъектаНалогаНаИмущество <> Перечисления.ВидыОбъектовНалогаНаИмущество.ДвижимоеИмуществоПринятоеС2013 Тогда
		ТекстСообщения = НСтр("ru = 'Код льготы 2010257 может применяться только для движимого имущества принятого с 2013 г.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "КодНалоговойЛьготыОсвобождениеОтНалогообложения",, Отказ); 
	КонецЕсли; 
	
	ОбработкаПроверкиЗаполненияОС(Отказ, НепроверяемыеРеквизиты);
	
	ПланыВидовХарактеристик.СтатьиРасходов.ПроверитьЗаполнениеАналитик(
		ЭтотОбъект,
		Новый Структура("ОтражениеРасходов"),
		НепроверяемыеРеквизиты,
		Отказ);
		
	Если НЕ Документы.РегистрацияПорядкаНалогообложенияПоНалогуНаИмущество.ТребуетсяУказаниеКБК(КодВидаИмущества) Тогда
		НепроверяемыеРеквизиты.Добавить("КБК");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	МенеджерВременныхТаблиц = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Документы.РегистрацияПорядкаНалогообложенияПоНалогуНаИмущество.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	РегистрыСведений.ДокументыПоОС.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	
	ПроведениеСерверУТ.ЗагрузитьТаблицыДвижений(ДополнительныеСвойства, Движения);
	
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПодготовитьДанныеДляФормированияЗаданияКЗакрытиюМесяцаПриЗаписи();
	
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	МенеджерВременныхТаблиц = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПодготовитьДанныеДляФормированияЗаданияКЗакрытиюМесяцаПриЗаписи();
	
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Заполнение

Процедура ИнициализироватьДокумент()
	
	Ответственный = Пользователи.ТекущийПользователь();
	
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	
КонецПроцедуры

#КонецОбласти

#Область ПроверкаЗаполнения

Процедура ОбработкаПроверкиЗаполненияОС(Отказ, НепроверяемыеРеквизиты)
	
	ТребуетсяПроверкаТабличнойЧасти =
		(ПорядокНалогообложения <> Перечисления.ПорядокНалогообложенияИмущества.НеПодлежитНалогообложению)
		И (ВидОбъектаНалогаНаИмущество = Перечисления.ВидыОбъектовНалогаНаИмущество.НедвижимоеИмущество);
	
	ОпределениеНалоговойБазыПоКадастровойСтоимости = (НалоговаяБаза = Перечисления.НалоговаяБазаПоНалогуНаИмущество.КадастроваяСтоимость);
	Если Не ТребуетсяПроверкаТабличнойЧасти Или Не ОпределениеНалоговойБазыПоКадастровойСтоимости Тогда
		НепроверяемыеРеквизиты.Добавить("ОС.КадастровыйНомер");
		НепроверяемыеРеквизиты.Добавить("ОС.КадастроваяСтоимость");
		НепроверяемыеРеквизиты.Добавить("ОС.ДатаРегистрацииПраваСобственности");
	КонецЕсли;
	
	НепроверяемыеРеквизиты.Добавить("ОС.ДоляСтоимостиЧислитель");
	НепроверяемыеРеквизиты.Добавить("ОС.ДоляСтоимостиЗнаменатель");
	
	Если Не ТребуетсяПроверкаТабличнойЧасти Тогда
		Возврат;
	КонецЕсли;
	
	ТекстОшибки = НСтр("ru='Не заполнена колонка ""%1"" в строке %2 списка ""Основные средства""'");
	
	Для Каждого Строка Из ОС Цикл
		
		Если Строка.ОтноситсяКТерриторииСубъектаРФВДоле Тогда
			
			Если Не ЗначениеЗаполнено(Строка.ДоляСтоимостиЧислитель) Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					СтрШаблон(ТекстОшибки, НСтр("ru='Числитель доли кадастровой стоимости, относящейся к субъекту РФ'"), Строка.НомерСтроки),
					ЭтотОбъект,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ОС", Строка.НомерСтроки, "ДоляСтоимостиЧислитель"),
					,
					Отказ);
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(Строка.ДоляСтоимостиЗнаменатель) Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					СтрШаблон(ТекстОшибки, НСтр("ru='Знаменталь доли кадастровой стоимости, относящейся к субъекту РФ'"), Строка.НомерСтроки),
					ЭтотОбъект,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ОС", Строка.НомерСтроки, "ДоляСтоимостиЗнаменатель"),
					,
					Отказ);
			КонецЕсли;
			
		КонецЕсли;
		
		Если Строка.ОбщаяСобственность Тогда
			
			Если Не ЗначениеЗаполнено(Строка.ДоляВПравеОбщейСобственностиЧислитель) Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					СтрШаблон(ТекстОшибки, НСтр("ru='Числитель доли в праве общей собственности'"), Строка.НомерСтроки),
					ЭтотОбъект,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ОС", Строка.НомерСтроки, "ДоляВПравеОбщейСобственностиЧислитель"),
					,
					Отказ);
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(Строка.ДоляВПравеОбщейСобственностиЗнаменатель) Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					СтрШаблон(ТекстОшибки, НСтр("ru='Знаменатель доли в праве общей собственности'"), Строка.НомерСтроки),
					ЭтотОбъект,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ОС", Строка.НомерСтроки, "ДоляВПравеОбщейСобственностиЗнаменатель"),
					,
					Отказ);
			КонецЕсли;
			
		КонецЕсли;
		
		Если Строка.КадастроваяСтоимостьОпределенаПоДолеПлощади Тогда
			
			Если Не ЗначениеЗаполнено(Строка.ДоляПлощадиЧислитель) Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					СтрШаблон(ТекстОшибки, НСтр("ru='Числитель доли в площади здания'"), Строка.НомерСтроки),
					ЭтотОбъект,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ОС", Строка.НомерСтроки, "ДоляПлощадиЧислитель"),
					,
					Отказ);
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(Строка.ДоляПлощадиЗнаменатель) Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					СтрШаблон(ТекстОшибки, НСтр("ru='Знаменатель доли в площади здания'"), Строка.НомерСтроки),
					ЭтотОбъект,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ОС", Строка.НомерСтроки, "ДоляПлощадиЗнаменатель"),
					,
					Отказ);
			КонецЕсли;
			
		КонецЕсли;
		
		Если Строка.НеоблагаемаяКадастроваяСтоимость > Строка.КадастроваяСтоимость Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Необлагаемая кадастровая стоимость не может превышать кадастровую стоимость'"),
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ОС", Строка.НомерСтроки, "НеоблагаемаяКадастроваяСтоимость"),
				,
				Отказ);
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Строка.ДатаПрекращенияПраваСобственности)
			И Строка.ДатаПрекращенияПраваСобственности < Строка.ДатаРегистрацииПраваСобственности Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Дата прекращения права собственности не может быть меньше даты регистрации права собственности'"),
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ОС", Строка.НомерСтроки, "ДатаПрекращенияПраваСобственности"),
				,
				Отказ);
			
		КонецЕсли;
		Если ЗначениеЗаполнено(Строка.ДатаПрекращенияПраваСобственности)
			И Строка.ДатаРегистрацииПраваСобственности > Строка.ДатаПрекращенияПраваСобственности Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Дата регистрации права собственности не может быть больше даты прекращения права собственности'"),
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ОС", Строка.НомерСтроки, "ДатаРегистрацииПраваСобственности"),
				,
				Отказ);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ЗаданияКЗакрытиюМесяца

Процедура ПодготовитьДанныеДляФормированияЗаданияКЗакрытиюМесяцаПередЗаписью()

	Если ДополнительныеСвойства.ЭтоНовый 
		ИЛИ (ДополнительныеСвойства.РежимЗаписи <> РежимЗаписиДокумента.Проведение 
			И ДополнительныеСвойства.РежимЗаписи <> РежимЗаписиДокумента.ОтменаПроведения) Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ТаблицаПередЗаписью.Дата КАК Период,
	|	ТаблицаПередЗаписью.Организация КАК Организация
	|ПОМЕСТИТЬ РегистрацияПорядкаНалогообложенияПоНалогуНаИмущество_ПередЗаписью
	|ИЗ
	|	Документ.РегистрацияПорядкаНалогообложенияПоНалогуНаИмущество КАК ТаблицаПередЗаписью
	|ГДЕ
	|	ТаблицаПередЗаписью.Ссылка = &Ссылка
	|	И ТаблицаПередЗаписью.Проведен
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаПередЗаписью.Ссылка.Дата КАК Период,
	|	ТаблицаПередЗаписью.Подразделение,
	|	ТаблицаПередЗаписью.СтатьяРасходов,
	|	ТаблицаПередЗаписью.АналитикаРасходов,
	|	ТаблицаПередЗаписью.Коэффициент
	|ПОМЕСТИТЬ РегистрацияПорядкаНалогообложенияПоНалогуНаИмущество_ОтражениеРасходов_ПередЗаписью
	|ИЗ
	|	Документ.РегистрацияПорядкаНалогообложенияПоНалогуНаИмущество.ОтражениеРасходов КАК ТаблицаПередЗаписью
	|ГДЕ
	|	ТаблицаПередЗаписью.Ссылка = &Ссылка
	|	И ТаблицаПередЗаписью.Ссылка.Проведен
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаПередЗаписью.Ссылка.Дата КАК Период,
	|	ТаблицаПередЗаписью.ОсновноеСредство
	|ПОМЕСТИТЬ РегистрацияПорядкаНалогообложенияПоНалогуНаИмущество_ОС_ПередЗаписью
	|ИЗ
	|	Документ.РегистрацияПорядкаНалогообложенияПоНалогуНаИмущество.ОС КАК ТаблицаПередЗаписью
	|ГДЕ
	|	ТаблицаПередЗаписью.Ссылка = &Ссылка
	|	И ТаблицаПередЗаписью.Ссылка.Проведен";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Выполнить();
	
КонецПроцедуры

Процедура ПодготовитьДанныеДляФормированияЗаданияКЗакрытиюМесяцаПриЗаписи()

	Если ДополнительныеСвойства.ЭтоНовый Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;

	ТекстЗапроса =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	1
	|ИЗ
	|	РегистрацияПорядкаНалогообложенияПоНалогуНаИмущество_ОтражениеРасходов_ПередЗаписью КАК ТаблицаПередЗаписью
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.РегистрацияПорядкаНалогообложенияПоНалогуНаИмущество.ОтражениеРасходов КАК ТаблицаПослеЗаписи
	|		ПО ТаблицаПередЗаписью.Подразделение = ТаблицаПослеЗаписи.Подразделение
	|			И ТаблицаПередЗаписью.СтатьяРасходов = ТаблицаПослеЗаписи.СтатьяРасходов
	|			И ТаблицаПередЗаписью.АналитикаРасходов = ТаблицаПослеЗаписи.АналитикаРасходов
	|			И ТаблицаПередЗаписью.Коэффициент = ТаблицаПослеЗаписи.Коэффициент
	|			И (ТаблицаПослеЗаписи.Ссылка = &Ссылка)
	|			И (ТаблицаПослеЗаписи.Ссылка.Проведен)
	|ГДЕ
	|	ТаблицаПослеЗаписи.Ссылка ЕСТЬ NULL
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	1
	|ИЗ
	|	Документ.РегистрацияПорядкаНалогообложенияПоНалогуНаИмущество.ОтражениеРасходов КАК ТаблицаПослеЗаписи
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрацияПорядкаНалогообложенияПоНалогуНаИмущество_ОтражениеРасходов_ПередЗаписью КАК ТаблицаПередЗаписью
	|		ПО ТаблицаПередЗаписью.Подразделение = ТаблицаПослеЗаписи.Подразделение
	|			И ТаблицаПередЗаписью.СтатьяРасходов = ТаблицаПослеЗаписи.СтатьяРасходов
	|			И ТаблицаПередЗаписью.АналитикаРасходов = ТаблицаПослеЗаписи.АналитикаРасходов
	|			И ТаблицаПередЗаписью.Коэффициент = ТаблицаПослеЗаписи.Коэффициент
	|ГДЕ
	|	ТаблицаПослеЗаписи.Ссылка = &Ссылка
	|	И ТаблицаПередЗаписью.Подразделение ЕСТЬ NULL
	|	И ТаблицаПослеЗаписи.Ссылка.Проведен";
	
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Дата", Дата);
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Таблица.Период           КАК Период,
	|	Таблица.Организация      КАК Организация,
	|	Таблица.ОсновноеСредство КАК ОсновноеСредство,
	|	ИСТИНА                   КАК ОтражатьВРеглУчете,
	|	ЛОЖЬ                     КАК ОтражатьВУпрУчете,
	|	&Ссылка                  КАК Документ
	|ПОМЕСТИТЬ РегистрацияПорядкаНалогообложенияПоНалогуНаИмуществоИзменение
	|ИЗ
	|	(ВЫБРАТЬ
	|		ШапкаПередЗаписью.Период              КАК Период,
	|		ШапкаПередЗаписью.Организация         КАК Организация,
	|		ТаблицаПередЗаписью.ОсновноеСредство  КАК ОсновноеСредство
	|	ИЗ
	|		РегистрацияПорядкаНалогообложенияПоНалогуНаИмущество_ОС_ПередЗаписью КАК ТаблицаПередЗаписью
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрацияПорядкаНалогообложенияПоНалогуНаИмущество_ПередЗаписью КАК ШапкаПередЗаписью
	|			ПО ИСТИНА
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		&Дата,
	|		&Организация,
	|		ТаблицаПриЗаписи.ОсновноеСредство
	|	ИЗ
	|		Документ.РегистрацияПорядкаНалогообложенияПоНалогуНаИмущество.ОС КАК ТаблицаПриЗаписи
	|	ГДЕ
	|		ТаблицаПриЗаписи.Ссылка = &Ссылка
	|		И ТаблицаПриЗаписи.Ссылка.Проведен
	|
	|	) КАК Таблица
	|
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ РегистрацияПорядкаНалогообложенияПоНалогуНаИмущество_ОтражениеРасходов_ПередЗаписью
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ РегистрацияПорядкаНалогообложенияПоНалогуНаИмущество_ОС_ПередЗаписью
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ РегистрацияПорядкаНалогообложенияПоНалогуНаИмущество_ПередЗаписью";
	Запрос.Текст = ТекстЗапроса;
	Выборка = Запрос.ВыполнитьПакет()[0].Выбрать();
	Выборка.Следующий();
	
	СтруктураВременныеТаблицы.Вставить("РегистрацияПорядкаНалогообложенияПоНалогуНаИмуществоИзменение", Выборка.Количество > 0);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
