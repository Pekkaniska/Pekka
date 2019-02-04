#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.События.ПриСозданииНаСервере = Истина;
	Настройки.События.ПередЗагрузкойВариантаНаСервере = Истина;
	Настройки.События.ПриЗагрузкеВариантаНаСервере = Истина;
КонецПроцедуры

// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// Подробнее - см. ОтчетыПереопределяемый.ПередЗагрузкойВариантаНаСервере
//
Процедура ПередЗагрузкойВариантаНаСервере(ЭтаФорма, НовыеНастройкиКД) Экспорт
	
	
	Отчет = ЭтаФорма.Отчет;
	КомпоновщикНастроекФормы = Отчет.КомпоновщикНастроек;
	Если Не КомпоновщикНастроекФормы.Настройки.ДополнительныеСвойства.Свойство("КлючТекущегоВарианта") Тогда
		КомпоновщикНастроекФормы.Настройки.ДополнительныеСвойства.Вставить("КлючТекущегоВарианта", ЭтаФорма.КлючТекущегоВарианта);
	КонецЕсли;
	НовыеНастройкиКД = КомпоновщикНастроекФормы.Настройки;
	

КонецПроцедуры

// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// Подробнее - см. ОтчетыПереопределяемый.ПриЗагрузкеВариантаНаСервере
//
Процедура ПриЗагрузкеВариантаНаСервере(ЭтаФорма, НовыеНастройкиКД) Экспорт
	
	
	Если ЭтаФорма.КлючТекущегоВарианта = "Расшифровка" Тогда
		
		КомпоновщикНастроекФормы = ЭтаФорма.Отчет.КомпоновщикНастроек;
		ФиксированныеНастройки = КомпоновщикНастроекФормы.ФиксированныеНастройки;
		
		ИсточникДобавления = ФиксированныеНастройки.Структура;
		МестоДобавления = КомпоновщикНастроекФормы.Настройки.Структура;
		
		Пока ИсточникДобавления.Количество() Цикл
			Группировка = ИсточникДобавления[0];
			НоваяГруппировка = ФинансоваяОтчетностьСервер.НоваяГруппировка(МестоДобавления, Группировка.Имя);
			МестоДобавления = НоваяГруппировка.Структура;
			ИсточникДобавления = Группировка.Структура;
		КонецЦикла;
		
		КомпоновкаДанныхКлиентСервер.СкопироватьЭлементы(КомпоновщикНастроекФормы.Настройки.Выбор, ФиксированныеНастройки.Выбор, Истина);
		
	КонецЕсли;
	

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	Перем КоличествоДокументов;
	
	СтандартнаяОбработка = Ложь;
	ПользовательскиеНастройкиМодифицированы = Ложь;
	
	УстановитьОбязательныеНастройки(ПользовательскиеНастройкиМодифицированы);
	
	ВнешниеНаборы = НаборыДанных();
	
	БюджетированиеСервер.ДополнитьСКДАналитикойПоВиду(СхемаКомпоновкиДанных, "ПоказательБюджетов");
	
	БюджетированиеСервер.ДополнитьСКДВыражениямиПредставленияАналитики(СхемаКомпоновкиДанных,
	                                                                   "НаборыДанных.Аналитика.Поля",
	                                                                   "ПоказательБюджетов");
	
	//++ НЕ УТКА
	#Область ЗапускФоновогоОтраженияДокументовВБюджетировании
	
		Период = БюджетированиеСервер.ЗначениеНастройкиСКД(КомпоновщикНастроек, "Период");
		НачалоПериода = Период.ДатаНачала;
		КонецПериода = Период.ДатаОкончания;
		ДопСвойства = КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства;
		
		ДопСвойства.Удалить("КоличествоДокументовКОтражениюВБюджетировании");
		Если РегистрыСведений.ЗаданияКОтражениюВБюджетировании.ТребуетсяОтражениеВБюджетированииДляОтчетаЗаПериод(
																	НачалоПериода, КонецПериода, КоличествоДокументов) Тогда
			
			ФактическиеДанныеБюджетированияСервер.ОтразитьДокументыФоновымЗаданием(НачалоПериода, КонецПериода);
			ДопСвойства.Вставить("КоличествоДокументовКОтражениюВБюджетировании", КоличествоДокументов);
			ДопСвойства.Вставить("НачалоПериода", НачалоПериода);
			ДопСвойства.Вставить("КонецПериода", КонецПериода);
			
		КонецЕсли;
	#КонецОбласти
	//-- НЕ УТКА
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(
		СхемаКомпоновкиДанных, КомпоновщикНастроек.ПолучитьНастройки(), ДанныеРасшифровки);
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, ВнешниеНаборы, ДанныеРасшифровки, Истина);
	
	ПроцессорВыводаВТабличныйДокумент = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВыводаВТабличныйДокумент.УстановитьДокумент(ДокументРезультат);
	ПроцессорВыводаВТабличныйДокумент.Вывести(ПроцессорКомпоновкиДанных);
	
	//++ НЕ УТКА
	ФактическиеДанныеБюджетированияСервер.ВывестиАктуальностьОтраженияФактическихДанных(ДокументРезультат, ДопСвойства);
	//-- НЕ УТКА
	
	// Сообщим форме отчета, что настройки модифицированы
	Если ПользовательскиеНастройкиМодифицированы Тогда
		КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ПользовательскиеНастройкиМодифицированы", Истина);
	КонецЕсли;
	
	ОтчетПустой = ВзаиморасчетыСервер.ОтчетПустой(ПроцессорКомпоновкиДанных);
	КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ОтчетПустой", ОтчетПустой);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПолучениеДанныхОтчета

Функция НаборыДанных()
	
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	ПараметрыПолученияФакта = ПараметрыПолученияФактаПоНастройкамОтчета(НастройкиОтчета);
	
	Период = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(НастройкиОтчета, "Период").Значение;
	ПериодОстатковНаНачало = Период.ДатаНачала;
	
	ЭлементОтбораПоПерирду = Неопределено;
	Для каждого Периодичность Из Перечисления.Периодичность.УпорядоченныеПериодичности() Цикл
		Период = "Период" + Периодичность;
		ЭлементОтбораПоПериоду = ФинансоваяОтчетностьСервер.НайтиЭлементОтбора(НастройкиОтчета.Отбор, Период);
		Если ЭлементОтбораПоПериоду <> Неопределено Тогда
			ЭлементОтбораПоПериоду.Использование = Ложь; // Отключим, чтобы не мешал получению оборотов
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	ОборотыПлан = ОборотыПлан(НастройкиОтчета);
	ОборотыФакт = ОборотыФакт(НастройкиОтчета, ПараметрыПолученияФакта);
	ОстаткиНаНачало = ОстаткиНаНачало(НастройкиОтчета, ПараметрыПолученияФакта);
	
	Если ЭлементОтбораПоПериоду <> Неопределено Тогда
		
		Если ЭлементОтбораПоПериоду.ВидСравнения <> ВидСравненияКомпоновкиДанных.Равно
			И ЭлементОтбораПоПериоду.ВидСравнения <> ВидСравненияКомпоновкиДанных.ВСписке Тогда
			ВызватьИсключение НСтр("ru = 'Не допускается строить отчет c видом сравнения в отборе по периоду отличном от ""Равно"" или ""В списке""'");
		КонецЕсли;
		
		Если ЭлементОтбораПоПериоду.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке Тогда
			ПериодОстатковНаНачало = ЭлементОтбораПоПериоду.ПравоеЗначение[0].Значение;
		Иначе
			ПериодОстатковНаНачало = ЭлементОтбораПоПериоду.ПравоеЗначение;
		КонецЕсли;
		
		// Досчитаем остаки на период отбора от остатков на начала периода оборотами
		СхемаРасчетаОстатков = Отчеты.ОборотноСальдоваяВедомостьБюджетирования.ПолучитьМакет("РасчетНачальныхОстатков");
		
		НастройкиРасчетаОстатков = СхемаРасчетаОстатков.НастройкиПоУмолчанию;
		КомпоновкаДанныхКлиентСервер.ДобавитьОтбор(
			НастройкиРасчетаОстатков, 
			ЭлементОтбораПоПериоду.ЛевоеЗначение,
			ПериодОстатковНаНачало,
			ВидСравненияКомпоновкиДанных.Меньше);
		
		ВнешниеНаборы = Новый Структура;
		ВнешниеНаборы.Вставить("ОборотыПлан", ОборотыПлан);
		ВнешниеНаборы.Вставить("ОборотыФакт", ОборотыФакт);
		ВнешниеНаборы.Вставить("ОстаткиНаНачало", ОстаткиНаНачало);
		
		ОстаткиНаНачало = ФинансоваяОтчетностьСервер.ВыгрузитьРезультатСКД(СхемаРасчетаОстатков, НастройкиРасчетаОстатков, ВнешниеНаборы);
		
	КонецЕсли;
	
	КолонкиПериода = "";
	Для каждого Периодичность Из Перечисления.Периодичность.УпорядоченныеПериодичности() Цикл
		Если Не ЗначениеЗаполнено(Периодичность) Тогда
			Продолжить;
		КонецЕсли;
		КолонкаПериод = "Период" + Периодичность;
		ОстаткиНаНачало.Колонки.Добавить(КолонкаПериод);
		КолонкиПериода = КолонкиПериода + ?(ПустаяСтрока(КолонкиПериода), "", ",") + КолонкаПериод;
	КонецЦикла;
	ОстаткиНаНачало.ЗаполнитьЗначения(ПериодОстатковНаНачало, КолонкиПериода);
	
	НаборыДанных = Новый Структура;
	НаборыДанных.Вставить("ОборотыПлан", ОборотыПлан);
	НаборыДанных.Вставить("ОборотыФакт", ОборотыФакт);
	НаборыДанных.Вставить("ОборотыТолькоФакт", ОборотыФакт.Скопировать(Новый Структура("Сценарий", Справочники.Сценарии.ФактическиеДанные)));
	НаборыДанных.Вставить("ОстаткиНаНачало", ОстаткиНаНачало);
	
	Возврат НаборыДанных;
	
КонецФункции

Функция ОборотыПлан(НастройкиОтчета) 
	
	СхемаКомпоновкиПлана = Отчеты.ОборотноСальдоваяВедомостьБюджетирования.ПолучитьМакет("ОборотыПлан");
	Настройки = СхемаКомпоновкиПлана.НастройкиПоУмолчанию;
	
	БюджетированиеСервер.ДополнитьСКДАналитикойПоВиду(СхемаКомпоновкиПлана, "ПоказательБюджетов");
	
	Набор = СхемаКомпоновкиПлана.НаборыДанных.План;
	
	ПараметрыВыражения = БюджетированиеСервер.ШаблонПараметровПоляАналитикиСУсловиемПоКоличествуВидовАналитики();
	ПараметрыВыражения.ВыражениеКоличествоИспользуемыхАналитик = "СвязиПоказателей.КоличествоИспользуемыхАналитик";
	ПараметрыВыражения.ВыражениеЗначенияАналитикиБезИндекса = "СвязиПоказателей.Аналитика";
	ПараметрыВыражения.ПараметрыТрансляцииАналитики.ВозможнаТрансляцияАналитики = Истина;
	ПараметрыВыражения.ПараметрыТрансляцииАналитики.ВыражениеТранслироватьАналитикуБезИндекса = "СвязиПоказателей.ТранслироватьАналитику";
	ПараметрыВыражения.ПараметрыТрансляцииАналитики.ВыражениеАдресТрансляцииАналитикиБезИндекса = "СвязиПоказателей.АдресТрансляцииАналитики";
	ПараметрыВыражения.ПараметрыТрансляцииАналитики.ВыражениеЗначенияАналитикиПриТрансляцииБезИндекса = "ОборотыБюджетов.Аналитика";
	
	МаксимальноеКоличествоАналитик = БюджетированиеКлиентСервер.МаксимальноеКоличествоАналитик();
	Для НомерАналитики = 1 По МаксимальноеКоличествоАналитик Цикл
		Набор.Запрос = СтрЗаменить(Набор.Запрос, "&ВыражениеАналитика" + НомерАналитики,
			БюджетированиеСервер.ТекстПоляАналитикиСУсловиемПоКоличествуВидовАналитики(ПараметрыВыражения, НомерАналитики));
	КонецЦикла;
	
	КомпоновкаДанныхКлиентСервер.ЗаполнитьЭлементы(Настройки.ПараметрыДанных, НастройкиОтчета.ПараметрыДанных);
	КомпоновкаДанныхКлиентСервер.СкопироватьОтборКомпоновкиДанных(СхемаКомпоновкиПлана, Настройки, НастройкиОтчета);
	
	Группировка = Настройки.Структура[0];
	
	Если КомпоновкаДанныхКлиентСервер.ПолеИспользуется(НастройкиОтчета, "Регистратор", Истина) Тогда
		ФинансоваяОтчетностьСервер.НовоеПолеГруппировки(Группировка, "Регистратор");
	КонецЕсли;
	
	Для каждого Периодичность Из Перечисления.Периодичность.УпорядоченныеПериодичности() Цикл
		Если Не ЗначениеЗаполнено(Периодичность) Тогда
			Продолжить;
		КонецЕсли;
		ПолеПериод = "Период" + Строка(Периодичность);
		ФинансоваяОтчетностьСервер.НовоеПолеГруппировки(Группировка, ПолеПериод);
	КонецЦикла;
	Если КомпоновкаДанныхКлиентСервер.ПолеИспользуется(НастройкиОтчета, "ДатаАктуальности", Истина) Тогда
		ФинансоваяОтчетностьСервер.НовоеПолеГруппировки(Группировка, "ДатаАктуальности");
	КонецЕсли;
	
	ВалютаОтчета = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(НастройкиОтчета, "Валюта").Значение;
	Период = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(НастройкиОтчета, "Период").Значение; 
	
	Если ВалютаОтчета = Константы.ВалютаРегламентированногоУчета.Получить() Тогда
		ВыражениеСуммы = "СуммаРегл";
	ИначеЕсли ВалютаОтчета = Константы.ВалютаУправленческогоУчета.Получить() Тогда
		ВыражениеСуммы = "СуммаУпр";
	Иначе
		ВыражениеСуммы = "ВЫБОР КОГДА Валюта = &Валюта ТОГДА СуммаВВалюте ИНАЧЕ СуммаРегл / ЕСТЬNULL(Курс,1) КОНЕЦ";
	КонецЕсли;
	
	Ресурсы = Новый Структура;
	Ресурсы.Вставить("Сумма", ВыражениеСуммы);
	Ресурсы.Вставить("Количество", "Количество");
	ВыражениеПриход = "ВЫБОР КОГДА Расход ТОГДА 0 ИНАЧЕ Коэффициент * %Поле КОНЕЦ";
	ВыражениеРасход = "ВЫБОР КОГДА Расход ТОГДА Коэффициент * %Поле ИНАЧЕ 0 КОНЕЦ";
	Для каждого Ресурс Из Ресурсы Цикл
		РесурсПриход = Ресурс.Ключ + "ПриходПлан";
		ФинансоваяОтчетностьСервер.НовыйВычисляемыйРесурс(
			СхемаКомпоновкиПлана, 
			РесурсПриход, 
			СтрЗаменить(ВыражениеПриход, "%Поле", Ресурс.Значение), 
			"Сумма");
		ФинансоваяОтчетностьСервер.НовоеПолеВыбора(Настройки, РесурсПриход);
		
		РесурсРасход = Ресурс.Ключ + "РасходПлан";
		ФинансоваяОтчетностьСервер.НовыйВычисляемыйРесурс(
			СхемаКомпоновкиПлана, 
			РесурсРасход, 
			СтрЗаменить(ВыражениеРасход, "%Поле", Ресурс.Значение),
			"Сумма");
		ФинансоваяОтчетностьСервер.НовоеПолеВыбора(Настройки, РесурсРасход);
	КонецЦикла;
	
	ОборотыПлан = ФинансоваяОтчетностьСервер.ВыгрузитьРезультатСКД(СхемаКомпоновкиПлана, Настройки);
	
	Возврат ОборотыПлан;
	
КонецФункции

Функция ОборотыФакт(НастройкиОтчета, ПараметрыПолученияФакта)
	
	ФактПоСтатьямБюджетов = БюджетированиеСервер.ФактПоСтатьямВлияющимНаПоказателиБюджетов(
		НастройкиОтчета, ПараметрыПолученияФакта, Истина);
	
	Если ПараметрыПолученияФакта.Свойство("ЕстьПериодичностьСекунда")
	   И ПараметрыПолученияФакта.ЕстьПериодичностьСекунда Тогда
		ФактПоСтатьямБюджетов.Колонки["ПериодСекунда"].Имя = "ДатаАктуальности";
	КонецЕсли;
	
	Возврат ФактПоСтатьямБюджетов;
	
КонецФункции

Функция ОстаткиНаНачало(НастройкиОтчета, ПараметрыПолученияФакта)
	
	ФактПоПоказателямБюджетов = БюджетированиеСервер.ФактПоПоказателямБюджетов(НастройкиОтчета, ПараметрыПолученияФакта);
	ФактПоПоказателямБюджетов.Колонки.Сумма.Имя = "СуммаНачальныйОстатокСценария";
	ФактПоПоказателямБюджетов.Колонки.Количество.Имя = "КоличествоНачальныйОстатокСценария";
	
	ФактПоПоказателямБюджетов.Колонки.Добавить("СуммаНачальныйОстатокФакт");
	ФактПоПоказателямБюджетов.ЗагрузитьКолонку(
		ФактПоПоказателямБюджетов.ВыгрузитьКолонку("СуммаНачальныйОстатокСценария"),
		"СуммаНачальныйОстатокФакт");
	
	ФактПоПоказателямБюджетов.Колонки.Добавить("КоличествоНачальныйОстатокФакт");
	ФактПоПоказателямБюджетов.ЗагрузитьКолонку(
		ФактПоПоказателямБюджетов.ВыгрузитьКолонку("КоличествоНачальныйОстатокСценария"),
		"КоличествоНачальныйОстатокФакт");
	
	Если ПараметрыПолученияФакта.Свойство("ЕстьПериодичностьСекунда")
	   И ПараметрыПолученияФакта.ЕстьПериодичностьСекунда Тогда
		ФактПоПоказателямБюджетов.Колонки["ПериодСекунда"].Имя = "ДатаАктуальности";
	КонецЕсли;
	
	Возврат ФактПоПоказателямБюджетов;
	
КонецФункции

#КонецОбласти

#Область Прочее

Функция ПараметрыПолученияФактаПоНастройкамОтчета(НастройкиОтчета)
	
	Параметры = БюджетированиеСервер.ШаблонПараметровПолученияФакта();
	
	Параметры.ВалютаОтчета = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(НастройкиОтчета, "Валюта").Значение;
	Параметры.Период = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(НастройкиОтчета, "Период").Значение; 
	
	Параметры.ОстаткиТолькоНаНачалоПериода = Истина;
	Параметры.ПоОрганизациям = Истина;
	Параметры.ПоПодразделениям = Истина;
	
	Если КомпоновкаДанныхКлиентСервер.ПолеИспользуется(НастройкиОтчета, "Регистратор", Истина) Тогда
		Параметры.ПоРегистратору = Истина;
	КонецЕсли;
	
	Для каждого Периодичность Из Перечисления.Периодичность.УпорядоченныеПериодичности() Цикл
		Если КомпоновкаДанныхКлиентСервер.ПолеИспользуется(НастройкиОтчета, "Период" + Строка(Периодичность), Истина) Тогда
			Параметры.Периодичность = Периодичность;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	ЕстьПериодичностьСекунда = КомпоновкаДанныхКлиентСервер.ПолеИспользуется(НастройкиОтчета,
	                                                                         "ДатаАктуальности",
	                                                                         Истина);
	Параметры.Вставить("ЕстьПериодичностьСекунда", ЕстьПериодичностьСекунда);
	
	Возврат Параметры; 
	
КонецФункции

Процедура УстановитьОбязательныеНастройки(ПользовательскиеНастройкиМодифицированы)
	
	ПараметрВалютаПользовательские = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "Валюта");
	ПараметрВалютаФиксированные = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек.ФиксированныеНастройки, "Валюта");
	
	ЕстьВалюта = ПараметрВалютаПользовательские <> Неопределено И ЗначениеЗаполнено(ПараметрВалютаПользовательские.Значение);
	Если Не ЕстьВалюта Тогда
		ЕстьВалюта = ПараметрВалютаФиксированные <> Неопределено И ЗначениеЗаполнено(ПараметрВалютаФиксированные.Значение);
	КонецЕсли;
	
	Если Не ЕстьВалюта Тогда
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(
			КомпоновщикНастроек, "Валюта", Константы.ВалютаУправленческогоУчета.Получить());
		ПользовательскиеНастройкиМодифицированы = Истина;
	КонецЕсли;
	
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   Отказ - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Передается из параметров обработчика "как есть".
//
// См. также:
//   "УправляемаяФорма.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	
	КомпоновщикНастроекФормы = ЭтаФорма.Отчет.КомпоновщикНастроек;
	Параметры = ЭтаФорма.Параметры;
	
	Если Параметры.Свойство("ПараметрКоманды") Тогда
		ЭтаФорма.ФормаПараметры.Отбор.Вставить("ПоказательБюджетов", Параметры.ПараметрКоманды);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли