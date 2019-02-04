////////////////////////////////////////////////////////////////////////////////
// СотрудникиКлиентСервер: методы, обслуживающие работу формы сотрудника.
//  
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Функция определяет пол физлица по его отчеству.
// Параметр:
// 		ОтчествоРаботника - отчество работника.
//
Функция ОпределитьПолПоОтчеству(ОтчествоРаботника) Экспорт
	
	Если Прав(ОтчествоРаботника, 2) = "ич" Тогда
		Возврат ПредопределенноеЗначение("Перечисление.ПолФизическогоЛица.Мужской");
	ИначеЕсли Прав(ОтчествоРаботника, 2) = "на" Тогда
		Возврат ПредопределенноеЗначение("Перечисление.ПолФизическогоЛица.Женский");
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

Процедура ОбработатьОтображениеСерияДокументаФизическогоЛица(ВидДокумента, Серия ,Элемент, Форма) Экспорт
	
	СообщенияПроверки = "";
	ТипСерии = ДокументыФизическихЛицКлиентСервер.ТипСерииДокументаУдостоверяющегоЛичность(ВидДокумента);
	Если ЗначениеЗаполнено(ВидДокумента) И ТипСерии > 0 Тогда
		Если НЕ ПустаяСтрока(Серия) Тогда
			СерияУказанаПравильно = ДокументыФизическихЛицКлиентСервер.СерияДокументаУказанаПравильно(ВидДокумента, Серия, СообщенияПроверки);
			Если СерияУказанаПравильно Тогда
				ЭлементЦветТекста = Форма.ЦветСтиляЦветТекстаПоля;
			Иначе
				ЭлементЦветТекста = Форма.ЦветСтиляПоясняющийОшибкуТекст;
			КонецЕсли;
		Иначе
			СообщенияПроверки = НСтр("ru='Не указана серия документа'");
			ЭлементЦветТекста = Форма.ЦветСтиляЦветТекстаПоля;
		КонецЕсли;
	Иначе
		ЭлементЦветТекста = Форма.ЦветСтиляЦветТекстаПоля;
	КонецЕсли;
	
	ЗарплатаКадрыКлиентСервер.УстановитьРасширеннуюПодсказкуЭлементуФормы(
		Форма,
		Элемент.Имя,
		СообщенияПроверки);
		
	Элемент.ЦветТекста = ЭлементЦветТекста;
	
КонецПроцедуры

Процедура ОбработатьОтображениеНомерДокументаФизическогоЛица(ВидДокумента, Номер ,Элемент, Форма) Экспорт
	
	СообщенияПроверки = "";
	ТипНомера = ДокументыФизическихЛицКлиентСервер.ТипНомераДокументаУдостоверяющегоЛичность(ВидДокумента);
	Если ЗначениеЗаполнено(ВидДокумента) И ТипНомера > 0 Тогда
		Если НЕ ПустаяСтрока(Номер) Тогда
			СерияУказанаПравильно = ДокументыФизическихЛицКлиентСервер.НомерДокументаУказанПравильно(ВидДокумента, Номер, СообщенияПроверки);
			Если СерияУказанаПравильно Тогда
				ЭлементЦветТекста = Форма.ЦветСтиляЦветТекстаПоля;
			Иначе
				ЭлементЦветТекста = Форма.ЦветСтиляПоясняющийОшибкуТекст;
			КонецЕсли;
		Иначе
			СообщенияПроверки = НСтр("ru='Не указан номер документа'");
			ЭлементЦветТекста = Форма.ЦветСтиляЦветТекстаПоля;
		КонецЕсли;
	Иначе
		ЭлементЦветТекста = Форма.ЦветСтиляЦветТекстаПоля;
	КонецЕсли;
	
	ЗарплатаКадрыКлиентСервер.УстановитьРасширеннуюПодсказкуЭлементуФормы(
		Форма,
		Элемент.Имя,
		СообщенияПроверки);
		
	Элемент.ЦветТекста = ЭлементЦветТекста;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЗависимостиВидовАдресов() Экспорт
	
	ЗависимостиВидов = Новый Соответствие;
	
	МассивЗависимых = Новый Массив;
	МассивЗависимых.Добавить(ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.АдресДляИнформированияФизическиеЛица"));
	
	ЗависимостиВидов.Вставить(ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.АдресМестаПроживанияФизическиеЛица"),
		МассивЗависимых);
	
	МассивЗависимых.Добавить(ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.АдресМестаПроживанияФизическиеЛица"));
	
	ЗависимостиВидов.Вставить(ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.АдресПоПропискеФизическиеЛица"),
		МассивЗависимых);
		
	Возврат ЗависимостиВидов;
	
КонецФункции

Процедура УстановитьВидЗанятостиНовогоСотрудника(Форма) Экспорт
	Если НЕ ЗначениеЗаполнено(Форма.Сотрудник.Ссылка) 
		И НЕ Форма.ИспользоватьКадровыйУчет Тогда
		Форма.ТекущийВидЗанятости = СотрудникиВызовСервера.ПолучитьВидЗанятостиДляНовогоСотрудника(Форма.Сотрудник, Форма.ТекущаяОрганизация, Форма.ФизическоеЛицоСсылка);
	КонецЕсли;
КонецПроцедуры

Процедура УстановитьВидимостьПолейФИО(Форма) Экспорт
	ФИОВведено = Не ПустаяСтрока(Форма.ФИОФизическихЛиц.Фамилия)
		Или Не ПустаяСтрока(Форма.ФИОФизическихЛиц.Имя)
		Или Не ПустаяСтрока(Форма.ФИОФизическихЛиц.Отчество);
	Форма.Элементы.ГруппаПолноеИмя.Видимость = ФИОВведено;
КонецПроцедуры

Процедура ОбновитьНаборЗаписейИсторииДокументыФизическихЛиц(Форма, ВедущийОбъект) Экспорт
	Перем ЗаписьНабора;
	
	Если Не Форма["ДокументыФизическихЛицНаборЗаписейПрочитан"] Тогда
		
		Форма.ПрочитатьНаборЗаписейПериодическихСведений("ДокументыФизическихЛиц", ВедущийОбъект);
		
	КонецЕсли;
	
	СтруктураЗаписиСтрокой = "";
	ПрежняяЗапись = Новый Структура;
	НужнаЗапятая = Ложь;
	Для Каждого КлючЗначение Из Форма["ДокументыФизическихЛицПрежняя"] Цикл
		Если НужнаЗапятая Тогда
			СтруктураЗаписиСтрокой = СтруктураЗаписиСтрокой + ",";
		КонецЕсли;
		СтруктураЗаписиСтрокой = СтруктураЗаписиСтрокой + КлючЗначение.Ключ;
		НужнаЗапятая = Истина;
		ПрежняяЗапись.Вставить(КлючЗначение.Ключ);
	КонецЦикла;
		
	Если ЗначениеЗаполнено(Форма["ДокументыФизическихЛиц"].Период) Тогда
		ПериодИзменен = Форма["ДокументыФизическихЛиц"].Период > Форма["ДокументыФизическихЛицПрежняя"].Период;
		РесурсыИзменены = Ложь;
		Для Каждого КлючЗначение Из Форма["ДокументыФизическихЛицПрежняя"] Цикл
			Если КлючЗначение.Ключ = "Период" Тогда
				Продолжить;
			КонецЕсли;
			Если КлючЗначение.Значение <> Форма["ДокументыФизическихЛиц"][КлючЗначение.Ключ] Тогда
				РесурсыИзменены = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		НаборЗаписей = Форма["ДокументыФизическихЛицНаборЗаписей"];
		Если (ПериодИзменен И РесурсыИзменены) ИЛИ НаборЗаписей.Количество() = 0 Тогда
			ЗаписьНаНовуюДату = НаборЗаписей.НайтиСтроки(Новый Структура("Период,ВидДокумента", Форма["ДокументыФизическихЛиц"].Период, Форма["ДокументыФизическихЛиц"].ВидДокумента));
			Если ЗаписьНаНовуюДату.Количество() = 0 Тогда
				ЗаписьНабора = НаборЗаписей.Добавить();
			КонецЕсли;
		Иначе
			ЗаписьНаНовуюДату = НаборЗаписей.НайтиСтроки(Новый Структура("Период,ВидДокумента", Форма["ДокументыФизическихЛиц"].Период, Форма["ДокументыФизическихЛиц"].ВидДокумента));
			Если ЗаписьНаНовуюДату.Количество() > 0 Тогда
				ЗаписьНабора = ЗаписьНаНовуюДату[0];
			Иначе
				ЗаписьНабора = НаборЗаписей.Добавить();
			КонецЕсли; 
		КонецЕсли;
		
		Если ЗаписьНабора <> НеОпределено Тогда
			
			// Если в этом периоде уже есть документы являющиеся удостоверением личности - 
			// сбросим признак.
			ЯвляющиесяУдостоверениямиЛичности = НаборЗаписей.НайтиСтроки(Новый Структура("Период,ЯвляетсяДокументомУдостоверяющимЛичность", Форма["ДокументыФизическихЛиц"].Период, Истина));
			Для каждого УдостоверениеЛичности Из ЯвляющиесяУдостоверениямиЛичности Цикл
				Если УдостоверениеЛичности.ВидДокумента <> ЗаписьНабора.ВидДокумента Тогда
					УдостоверениеЛичности.ЯвляетсяДокументомУдостоверяющимЛичность = Ложь;
				КонецЕсли; 
			КонецЦикла;
			
			ЗаполнитьЗначенияСвойств(ЗаписьНабора, Форма["ДокументыФизическихЛиц"]);
			НаборЗаписей.Сортировать("Период,ЯвляетсяДокументомУдостоверяющимЛичность");
			
			ЗаполнитьЗначенияСвойств(ПрежняяЗапись, Форма["ДокументыФизическихЛиц"]);
			Форма["ДокументыФизическихЛицПрежняя"] = Новый ФиксированнаяСтруктура(ПрежняяЗапись);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#Область ОбновлениеПредупреждающихНадписей

Процедура УстановитьИнфоНадпись(Форма, ДатаСеанса) Экспорт
	
	Если НЕ Форма.ИспользоватьКадровыйУчет Тогда
		Форма.ОформленПоТрудовомуДоговору = ЗначениеЗаполнено(Форма.ДатаПриема)
			И ЗначениеЗаполнено(Форма.ТекущаяОрганизация) И ЗначениеЗаполнено(Форма.ТекущийВидЗанятости);
	КонецЕсли; 
		
	СотрудникИнфо = "";	
	
	Если Форма.Сотрудник.ВАрхиве Тогда
		СотрудникИнфо = НСтр("ru = 'Все операции по сотруднику уже завершены. Сотрудник не отображается в списках'");
	ИначеЕсли НЕ Форма.ОформленПоТрудовомуДоговору Тогда
		
		Если Форма.ДоступенПросмотрДанныхДляНачисленияЗарплаты Тогда
			ТекстИнфоНадписи = НСтр("ru = 'Сотрудник не принят на работу, зарплата по нему не начисляется.'");
		Иначе
			ТекстИнфоНадписи = НСтр("ru = 'Сотрудник не принят на работу.'");
		КонецЕсли;
		
		Если Форма.ИспользоватьКадровыйУчет Тогда
			ТекстИнфоНадписи = ТекстИнфоНадписи + " " + НСтр("ru='Необходимо оформить прием на работу'");
		Иначе
			ТекстИнфоНадписи = ТекстИнфоНадписи + " " + НСтр("ru='Для приема на работу необходимо заполнить организацию и дату приема'");
		КонецЕсли;
		
		СотрудникИнфо = ТекстИнфоНадписи;
		
	ИначеЕсли ЗначениеЗаполнено(Форма.ДатаУвольнения) Тогда
		
		ПрошлоДнейСМоментаУвольнения = (ДатаСеанса - Форма.ДатаУвольнения) / 86400;
		Если ПрошлоДнейСМоментаУвольнения > 370 Тогда
			СотрудникИнфо = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Сотрудник давно уволен. Для того, чтобы сотрудник не отображался в списках можно установить флажок ""%2""'"),
				Формат(Форма.ДатаУвольнения, "ДФ='ММММ гггг ""г.""'"), Форма.Элементы.ВАрхиве.Заголовок);
		Иначе
				
			Если Форма.ДоступенПросмотрДанныхДляНачисленияЗарплаты Тогда
				
				СотрудникИнфо = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Сотрудник уволен. Месяц, после которого не начисляется зарплата: %1'"),
					Формат(Форма.ДатаУвольнения, "ДФ='ММММ гггг ""г.""'"));
					
			Иначе
				СотрудникИнфо = НСтр("ru = 'Сотрудник уволен.'");
			КонецЕсли;
				
		КонецЕсли;			
		
	ИначеЕсли Форма.ДоступенПросмотрДанныхДляНачисленияЗарплаты Тогда
		
		Если НЕ ЗначениеЗаполнено(Форма.ТекущаяТарифнаяСтавка) Тогда
			СотрудникИнфо = НСтр("ru = 'Сотрудник принят на работу, оклад сотрудника не задан. При начислении зарплаты сумма к начислению заполняется вручную'");
		Иначе
			
			Если ЗначениеЗаполнено(Форма.ДатаПриема) Тогда
				
				СотрудникИнфо = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Сотрудник принят на работу. Месяц, с которого начисляется зарплата: %1'"),
						Формат(Форма.ДатаПриема, "ДФ='ММММ гггг ""г.""'"));
						
			Иначе
				СотрудникИнфо = НСтр("ru = 'Сотрудник принят на работу.'");		
			КонецЕсли;
					
		КонецЕсли;
		
	Иначе
		СотрудникИнфо = НСтр("ru = 'Сотрудник принят на работу.'");
	КонецЕсли;		
	
	ЗарплатаКадрыКлиентСервер.УстановитьРасширеннуюПодсказкуЭлементуФормы(
		Форма,
		"ДатыПриемаУвольнения",
		СотрудникИнфо);
	
КонецПроцедуры

Процедура УстановитьДоступностьУточненияНаименования(Форма) Экспорт
	Форма.Элементы.УточнениеНаименования.Доступность = Форма.ДополнятьПредставление; 
КонецПроцедуры

Процедура ОбновитьПолеГражданствоПериод(Форма, ДатаСеанса)
	
	// Не обязательно заполнение поля Период если данные по умолчанию и при этом 
	// записи о гражданстве еще нет.
	Если ЗарплатаКадрыКлиентСервер.ГражданствоПоУмолчанию(Форма.ГражданствоФизическихЛиц)
		И (Форма.ГражданствоФизическихЛицПрежняя.Период = ЗарплатаКадрыКлиентСервер.ДатаОтсчетаПериодическихСведений()
			ИЛИ Форма.ГражданствоФизическихЛицПрежняя.Период = '00010101') Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Форма.Элементы,
			"ГражданствоФизическихЛицПериод",
			"АвтоОтметкаНезаполненного",
			Ложь);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Форма.Элементы,
			"ГражданствоФизическихЛицПериод",
			"ОтметкаНезаполненного",
			Ложь);
			
	Иначе
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Форма.Элементы,
			"ГражданствоФизическихЛицПериод",
			"АвтоОтметкаНезаполненного",
			Истина);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Форма.Элементы,
			"ГражданствоФизическихЛиц",
			"ОтметкаНезаполненного",
			НЕ ЗначениеЗаполнено(Форма.ГражданствоФизическихЛиц.Период));
		
		Если НЕ ЗарплатаКадрыКлиентСервер.ГражданствоПоУмолчанию(Форма.ГражданствоФизическихЛиц) 
			И Форма.ГражданствоФизическихЛиц.Период = ЗарплатаКадрыКлиентСервер.ДатаОтсчетаПериодическихСведений() Тогда
			
			Форма.ГражданствоФизическихЛиц.Период = НачалоДня(ДатаСеанса);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Форма.ГражданствоФизическихЛиц.Период = ЗарплатаКадрыКлиентСервер.ДатаОтсчетаПериодическихСведений() Тогда
		Форма.ГражданствоФизическихЛицПериод = '00010101';
	Иначе
		Форма.ГражданствоФизическихЛицПериод = Форма.ГражданствоФизическихЛиц.Период;
	КонецЕсли;

КонецПроцедуры

Процедура ОбновитьДоступностьПолейВводаГражданства(Форма, ДатаСеанса) Экспорт
	
	Форма.Элементы.ГражданствоФизическихЛицСтрана.Доступность = (Форма.ГражданствоФизическихЛицЛицоБезГражданства = 0);
	
	ОбновитьПолеГражданствоПериод(Форма, ДатаСеанса);
	
КонецПроцедуры

Процедура ОбновитьПолеУдостоверениеЛичностиПериод(Форма) Экспорт
	
	Если Форма.ДоступенПросмотрДанныхФизическихЛиц Тогда
		
		ЭтоЗначенияПоУмолчанию = Ложь;
		// Не обязательно заполнение поля Период если данные по умолчанию и при этом 
		// записи о сведениях об инвалидности еще нет.
		Если ЗарплатаКадрыКлиентСервер.УдостоверениеЛичностиПоУмолчанию(Форма.ДокументыФизическихЛиц)
			И НЕ ЗначениеЗаполнено(Форма.ДокументыФизическихЛицПрежняя.Период) Тогда
			
			ЭтоЗначенияПоУмолчанию = Истина;
			Форма.ДокументыФизическихЛиц.Период = '00010101';
			
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Форма.Элементы,
				"ДокументыФизическихЛицВидДокумента",
				"АвтоОтметкаНезаполненного",
				Ложь);

			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Форма.Элементы,
				"ДокументыФизическихЛицВидДокумента",
				"ОтметкаНезаполненного",
				Ложь);
			
		Иначе
			
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Форма.Элементы,
				"ДокументыФизическихЛицВидДокумента",
				"АвтоОтметкаНезаполненного",
				Истина);
				
			Если ЗначениеЗаполнено(Форма.ДокументыФизическихЛиц.ВидДокумента) Тогда
				ВидДокументаОтметкаНезаполненного = Ложь;
			Иначе
				ВидДокументаОтметкаНезаполненного = Истина;
			КонецЕсли;
			
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Форма.Элементы,
				"ДокументыФизическихЛицВидДокумента",
				"ОтметкаНезаполненного",
				ВидДокументаОтметкаНезаполненного);
				
			Если НЕ ЗначениеЗаполнено(Форма.ДокументыФизическихЛиц.Период) И ЗначениеЗаполнено(Форма.ДокументыФизическихЛиц.ДатаВыдачи) Тогда
				Форма.ДокументыФизическихЛиц.Период = Форма.ДокументыФизическихЛиц.ДатаВыдачи;
			КонецЕсли;
			
			Форма.ДокументыФизическихЛиц.ЯвляетсяДокументомУдостоверяющимЛичность = Истина;
			
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Форма.ДокументыФизическихЛиц.ДатаВыдачи) И НЕ ЗначениеЗаполнено(Форма.ДокументыФизическихЛицПрежняя.Период) Тогда
			ТолькоПросмотрПоляПериод = Истина;
		Иначе
			ТолькоПросмотрПоляПериод = Ложь;
		КонецЕсли;
		
		Если НЕ ЭтоЗначенияПоУмолчанию
			И НЕ ЗначениеЗаполнено(Форма.ДокументыФизическихЛицПрежняя.Период) Тогда
			
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Форма.Элементы,
				"ДокументыФизическихЛицДатаВыдачи",
				"АвтоОтметкаНезаполненного",
				Истина);
				
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Форма.Элементы,
				"ДокументыФизическихЛицДатаВыдачи",
				"ОтметкаНезаполненного",
				НЕ ЗначениеЗаполнено(Форма.ДокументыФизическихЛиц.ДатаВыдачи));
				
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Форма.Элементы,
			"ДокументыФизическихЛицПериод",
			"ТолькоПросмотр",
			ТолькоПросмотрПоЛяПериод);
		
		РедактированиеПериодическихСведенийКлиентСервер.ОбновитьОтображениеПолейВвода(Форма, "ДокументыФизическихЛиц", Форма.ФизическоеЛицоСсылка);
		
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыИФункцииДляПолейСодержащихИННСтраховойНомерПФР

// Осуществляет проверку заполненного элемента содержащему ИНН.
Процедура ОбработатьОтображениеПоляИНН(ИНН, Элемент, Форма) Экспорт
	
	СообщенияПроверки = "";
	Форма.ИННУказанПравильно = Ложь;
	
	Если НЕ ПустаяСтрока(ИНН) Тогда
	
		Форма.ИННУказанПравильно = РегламентированныеДанныеКлиентСервер.ИННСоответствуетТребованиям(ИНН, Ложь, СообщенияПроверки);
		Если Форма.ИННУказанПравильно Тогда
			ЭлементЦветТекста = Форма.ЦветСтиляЦветТекстаПоля;
		Иначе
			ЭлементЦветТекста = Форма.ЦветСтиляПоясняющийОшибкуТекст;
		КонецЕсли;
		
	Иначе
		
		СообщенияПроверки = НСтр("ru = 'Не указан ИНН (используется, например, в отчетности по форме 2-НДФЛ)'");
		ЭлементЦветТекста = Форма.ЦветСтиляЦветТекстаПоля;
			
	КонецЕсли;
	
	ЗарплатаКадрыКлиентСервер.УстановитьРасширеннуюПодсказкуЭлементуФормы(
		Форма,
		Элемент.Имя,
		СообщенияПроверки);
		
	Элемент.ЦветТекста = ЭлементЦветТекста;
	 
КонецПроцедуры

// Осуществляет проверку заполненного элемента содержащему СтраховойНомерПФР.
Процедура ОбработатьОтображениеПоляСтраховойНомерПФР(СтраховойНомерПФР ,Элемент, Форма) Экспорт
	
	СообщенияПроверки = "";
	Форма.СНИЛСУказанПравильно = Ложь;
	
	Если КадровыйУчетКлиентСервер.СНИЛСЗаполнен(СтраховойНомерПФР) Тогда
	
		Форма.СНИЛСУказанПравильно = РегламентированныеДанныеКлиентСервер.СтраховойНомерПФРСоответствуетТребованиям(СтраховойНомерПФР, СообщенияПроверки);
		Если Форма.СНИЛСУказанПравильно Тогда
			ЭлементЦветТекста = Форма.ЦветСтиляЦветТекстаПоля;
		Иначе
			ЭлементЦветТекста = Форма.ЦветСтиляПоясняющийОшибкуТекст;
		КонецЕсли;
		
	Иначе
		
		ЭлементЦветТекста = Форма.ЦветСтиляЦветТекстаПоля;
	
	КонецЕсли;
	
	ЗарплатаКадрыКлиентСервер.УстановитьРасширеннуюПодсказкуЭлементуФормы(
		Форма,
		Элемент.Имя,
		СообщенияПроверки);
		
	Элемент.ЦветТекста = ЭлементЦветТекста;
	 
КонецПроцедуры

Процедура УстановитьПодсказкуКДатеРождения(Форма) Экспорт
	
	Если ЗначениеЗаполнено(Форма.ФизическоеЛицо.ДатаРождения) Тогда
		ТекстПодсказки = "";
		ОтображениеПодсказкиЭлемента = ОтображениеПодсказки.Авто;
	Иначе
		ТекстПодсказки = НСтр("ru='Дата рождения используется при расчете страховых взносов в ПФР (до 2014 года)'");
		ОтображениеПодсказкиЭлемента = ОтображениеПодсказки.Кнопка;
	КонецЕсли;
	
	ЗарплатаКадрыКлиентСервер.УстановитьРасширеннуюПодсказкуЭлементуФормы(Форма, "ФизлицоДатаРождения", ТекстПодсказки);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"ФизлицоДатаРождения",
		"ОтображениеПодсказки",
		ОтображениеПодсказкиЭлемента);
	
КонецПроцедуры

#КонецОбласти

#Область РаботаСДополнительнымиФормами

Функция ОбщееОписаниеДополнительнойФормы(ИмяОткрываемойФормы) Экспорт
	
	ОписаниеФормы = Новый Структура;
	
	ОписаниеФормы.Вставить("ИмяФормы", ИмяОткрываемойФормы);
	ОписаниеФормы.Вставить("КлючевыеРеквизиты", Новый Структура);
	ОписаниеФормы.Вставить("РеквизитыОбъекта", Новый Структура);
	ОписаниеФормы.Вставить("ДополнительныеДанные", Новый Структура);
	ОписаниеФормы.Вставить("АдресВХранилище", "");
	
	Возврат ОписаниеФормы;
	
КонецФункции

// Частный случай формы сотрудников.
Функция ОписаниеДополнительнойФормы(ИмяОткрываемойФормы) Экспорт
	
	Возврат СотрудникиКлиентСерверВнутренний.ОписаниеДополнительнойФормы(ИмяОткрываемойФормы);
	
КонецФункции

Процедура УстановитьПризнакРедактированияДанныхВДополнительнойФорме(ИмяДополнительнойФормы, Форма) Экспорт
	
	ПрочитанныеДанные = Новый Соответствие;
	
	Если ТипЗнч(Форма.ПрочитанныеДанныеФорм) = Тип("ФиксированноеСоответствие") Тогда
		
		Для каждого ЭлементСтруктуры Из Форма.ПрочитанныеДанныеФорм Цикл
			ПрочитанныеДанные.Вставить(ЭлементСтруктуры.Ключ, ЭлементСтруктуры.Значение);
		КонецЦикла;
		
	КонецЕсли;
	
	ПрочитанныеДанные.Вставить(ИмяДополнительнойФормы, Истина);
	
	Форма.ПрочитанныеДанныеФорм = Новый ФиксированноеСоответствие(ПрочитанныеДанные);
	Форма.Модифицированность = Истина;
	
КонецПроцедуры

Процедура УстановитьРежимТолькоПросмотрВФормеРедактированияИстории(Форма) Экспорт
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы, 
		"НаборЗаписей",
		"ТолькоПросмотр",
		Истина);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы, 
		"ФормаКомандаОК",
		"Доступность",
		Ложь);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы, 
		"ФормаКомандаОтмена",
		"КнопкаПоУмолчанию",
		Истина);
	
КонецПроцедуры

#КонецОбласти

Функция ПредставлениеСотрудникаПоДаннымФормыСотрудника(Форма) Экспорт
	
	Возврат СотрудникиКлиентСерверВнутренний.ПредставлениеСотрудникаПоДаннымФормыСотрудника(Форма);
	
КонецФункции

Процедура УстановитьРежимТолькоПросмотраЛичныхДанныхВФормеСотрудника(Форма) Экспорт
	
	СотрудникиКлиентСерверВнутренний.УстановитьРежимТолькоПросмотраЛичныхДанныхВФормеСотрудника(Форма);
	
КонецПроцедуры

Процедура ОбновитьГруппуФамилияИмяЛатиницей(Форма, ПутьКДанным) Экспорт
	
	МенеджерЗаписи = Форма[ПутьКДанным];
	
	УстановитьВидимостьГруппыФамилияИмяЛатиницей(Форма, ПутьКДанным);
	
	Если Не МенеджерЗаписи.ВидДокумента = ПредопределенноеЗначение("Справочник.ВидыДокументовФизическихЛиц.ЗагранпаспортРФ") Тогда
		
		МенеджерЗаписи.ИмяЛатиницей = "";
		МенеджерЗаписи.ФамилияЛатиницей = "";
		
	КонецЕсли;

КонецПроцедуры

Процедура УстановитьВидимостьГруппыФамилияИмяЛатиницей(Форма, ПутьКДанным) Экспорт
	
	СотрудникиКлиентСерверВнутренний.УстановитьВидимостьГруппыФамилияИмяЛатиницей(Форма, ПутьКДанным);
	
КонецПроцедуры

Процедура ПроверитьНаписаниеФИДокументаЛатинскими(Форма, ПутьКДанным, Отказ) Экспорт
	
	МенеджерЗаписи = Форма[ПутьКДанным];
	Если МенеджерЗаписи.ВидДокумента = ПредопределенноеЗначение("Справочник.ВидыДокументовФизическихЛиц.ЗагранпаспортРФ") Тогда
		
		Если ЗначениеЗаполнено(МенеджерЗаписи.ИмяЛатиницей) И Не СтроковыеФункцииКлиентСервер.ТолькоЛатиницаВСтроке(МенеджерЗаписи.ИмяЛатиницей) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Документ: поле ""Имя"" должно содержать только латинские буквы.'"),, "ИмяЛатиницей", ПутьКДанным, Отказ);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(МенеджерЗаписи.ФамилияЛатиницей) И Не СтроковыеФункцииКлиентСервер.ТолькоЛатиницаВСтроке(МенеджерЗаписи.ФамилияЛатиницей) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Документ: поле ""Фамилия"" должно содержать только латинские буквы.'"),, "ФамилияЛатиницей", ПутьКДанным, Отказ);
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
