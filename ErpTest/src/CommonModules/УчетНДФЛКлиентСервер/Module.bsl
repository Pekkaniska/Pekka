
#Область СлужебныйПрограммныйИнтерфейс

// Возвращает ссылку на вычет с кодом 405.
//
// Параметры:
//  нет
//
// Возвращаемое значение:
//   СправочникСсылка.ВидыВычетовНДФЛ
//
Функция ВычетВПределахНормативовПоАвторскимВознаграждениям() Экспорт

	Возврат ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыВычетовНДФЛ.Код405");

КонецФункции

// Возвращает строку, в которой перечислены коды допустимых документов.
//
// Параметры:
//  нет
//
// Возвращаемое значение:
//   Строка.
//
Функция КодыДопустимыхДокументовУдостоверяющихЛичность() Экспорт

	Возврат "21, 03, 07, 08, 10, 11, 12, 13, 14, 15, 18, 23, 24, 91"	

КонецФункции 

// Возвращает одну.из трех ставок налогообложения нерезидента, наиболее соответствующих доходу.
//
// Параметры:
//	КатегорияДохода - ПеречислениеСсылка.КатегорииДоходовНДФЛ - 
//
// Возвращаемое значение:
//	Тип ПеречислениеСсылка.НДФЛСтавкиНалогообложенияРезидента.
//
Функция СтавкаНалогообложенияКатегорииДоходовПоУмолчанию(КатегорияДохода) Экспорт

	Возврат ?(КатегорияДохода = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Перечисление.КатегорииДоходовНДФЛ.Дивиденды") 
			Или КатегорияДохода = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Перечисление.КатегорииДоходовНДФЛ.ДивидендыПоСтавке05")
			Или КатегорияДохода = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Перечисление.КатегорииДоходовНДФЛ.ДивидендыПоСтавке10") 
			Или КатегорияДохода = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Перечисление.КатегорииДоходовНДФЛ.ДивидендыПоСтавке12"),
		ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Перечисление.НДФЛСтавкиНалогообложенияРезидента.Ставка09"),
		ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Перечисление.НДФЛСтавкиНалогообложенияРезидента.Ставка13"));
	
КонецФункции 

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СправкиНДФЛЗаполнитьПолеИтогов(ДанныеСправки, ДанныеИтоговПоСтавке, ИмяПоля) Экспорт
	СправкиНДФЛУстановитьЗначениеПоляИтоговПоСтавке(ДанныеСправки, ДанныеИтоговПоСтавке.Ставка, ИмяПоля, ДанныеИтоговПоСтавке[ИмяПоля])
КонецПроцедуры

Процедура СправкиНДФЛУстановитьЗначениеПоляИтоговПоСтавке(ДанныеСправки, Ставка, ИмяПоля, Значение) Экспорт
	ИмяПоляСправки = УчетНДФЛКлиентСервер.СправкиНДФЛИмяПоляИтоговПоСтавке(ИмяПоля, Ставка);
	Если ИмяПоляСправки <> Неопределено И ДанныеСправки <> Неопределено И ДанныеСправки.Свойство(ИмяПоляСправки) Тогда 
		ДанныеСправки[ИмяПоляСправки] = Значение;
	КонецЕсли;
КонецПроцедуры

Процедура СправкиНДФЛУстановитьПризнакНаличияГражданства(Форма, ДанныеСправки) Экспорт
	Если ДанныеСправки.Гражданство = ПредопределенноеЗначение("Справочник.СтраныМира.ПустаяСсылка") Тогда
		Форма.ЛицоБезГражданства = 1;
		Форма.Элементы.Гражданство.Доступность = Ложь;
	Иначе
		Форма.ЛицоБезГражданства = 0;
		Форма.Элементы.Гражданство.Доступность = Истина;
	КонецЕсли;			
КонецПроцедуры

Процедура СправкиНДФЛУстановитьСвойстваЭлементовСФиксациейДанных(Форма, ДанныеСправки, ДокументПроведен = Ложь) Экспорт
	ИменаФиксируемыхПолей = СправкиНДФЛИменаФиксируемыхПолей();
	
	ЕстьФиксированныеДанные = Ложь;
	Для Каждого ИмяПоля Из ИменаФиксируемыхПолей Цикл
		СправкиНДФЛУстановитьСвойстваЭлементаФиксируемыхДанных(Форма, ДанныеСправки, ИмяПоля, ДокументПроведен);	
		
		ЕстьФиксированныеДанные = ЕстьФиксированныеДанные Или ДанныеСправки["Фикс" + ИмяПоля];
	КонецЦикла;	
	
	Форма.Элементы.ОтменитьИсправленияДанныхСотрудника.Доступность = ЕстьФиксированныеДанные;
КонецПроцедуры

Процедура СправкиНДФЛУстановитьСвойстваЭлементаФиксируемыхДанных(Форма, ДанныеСправки, ИмяПоля, ДокументПроведен = Ложь) Экспорт
	Элементы = Новый Массив;
	Элементы.Добавить(Форма.Элементы[ИмяПоля]);
	Если ИмяПоля = "Гражданство" Тогда
		Элементы.Добавить(Форма.Элементы["ЛицоБезГражданства"]);
		ИННвСтранеГражданства = Форма.Элементы.Найти("ИННвСтранеГражданства");
		Если ИННвСтранеГражданства <> Неопределено Тогда
			Элементы.Добавить(ИННвСтранеГражданства);
		КонецЕсли;
	КонецЕсли;
	
	Для Каждого Элемент Из Элементы Цикл
		Если ДанныеСправки["Фикс" + ИмяПоля] И 
			Элемент.ОтображениеПредупрежденияПриРедактировании = ОтображениеПредупрежденияПриРедактировании.Отображать Тогда
			
			Элемент.ОтображениеПредупрежденияПриРедактировании = ОтображениеПредупрежденияПриРедактировании.НеОтображать;
			
		ИначеЕсли Элемент.ОтображениеПредупрежденияПриРедактировании =  ОтображениеПредупрежденияПриРедактировании.НеОтображать
			И Не ДанныеСправки["Фикс" + ИмяПоля] И Не ДокументПроведен Тогда
			
			Элемент.ОтображениеПредупрежденияПриРедактировании = ОтображениеПредупрежденияПриРедактировании.Отображать;	
		ИначеЕсли ДокументПроведен И Элемент.ОтображениеПредупрежденияПриРедактировании = ОтображениеПредупрежденияПриРедактировании.Отображать Тогда
			
			Элемент.ОтображениеПредупрежденияПриРедактировании = ОтображениеПредупрежденияПриРедактировании.НеОтображать;	
		КонецЕсли;
	КонецЦикла;	
КонецПроцедуры	

Функция СправкиНДФЛИменаФиксируемыхПолей() Экспорт
	ЗаполняемыеПоля = Новый Массив;
	ЗаполняемыеПоля.Добавить("ИНН");
	ЗаполняемыеПоля.Добавить("Фамилия");
	ЗаполняемыеПоля.Добавить("Имя");
	ЗаполняемыеПоля.Добавить("Отчество");
	ЗаполняемыеПоля.Добавить("Адрес");
	ЗаполняемыеПоля.Добавить("ВидДокумента");
	ЗаполняемыеПоля.Добавить("СерияДокумента");
	ЗаполняемыеПоля.Добавить("НомерДокумента");
	ЗаполняемыеПоля.Добавить("Гражданство");
	ЗаполняемыеПоля.Добавить("ДатаРождения");
	ЗаполняемыеПоля.Добавить("СтатусНалогоплательщика");
	ЗаполняемыеПоля.Добавить("АдресЗарубежом");	
	
	Возврат ЗаполняемыеПоля;
КонецФункции	

Функция СправкиНДФЛИмяПоляИтоговПоСтавке(ИмяПоля, Ставка) Экспорт
	Если Ставка = ПредопределенноеЗначение("Перечисление.НДФЛСтавки.Ставка13") Тогда
		ИмяПоляСправки = ИмяПоля + "ПоСтавке13";
	ИначеЕсли Ставка = ПредопределенноеЗначение("Перечисление.НДФЛСтавки.Ставка30") Тогда
		ИмяПоляСправки =  ИмяПоля + "ПоСтавке30";
	ИначеЕсли Ставка = ПредопределенноеЗначение("Перечисление.НДФЛСтавки.Ставка09") Тогда
		ИмяПоляСправки = ИмяПоля + "ПоСтавке9";
	ИначеЕсли Ставка = ПредопределенноеЗначение("Перечисление.НДФЛСтавки.Ставка15") Тогда
		ИмяПоляСправки =  ИмяПоля + "ПоСтавке15";
	ИначеЕсли Ставка = ПредопределенноеЗначение("Перечисление.НДФЛСтавки.Ставка35") Тогда
		ИмяПоляСправки = ИмяПоля + "ПоСтавке35";
	ИначеЕсли Ставка = ПредопределенноеЗначение("Перечисление.НДФЛСтавки.Ставка05") Тогда
		ИмяПоляСправки = ИмяПоля + "ПоСтавке5";
	ИначеЕсли Ставка = ПредопределенноеЗначение("Перечисление.НДФЛСтавки.Ставка10") Тогда
		ИмяПоляСправки = ИмяПоля + "ПоСтавке10";
	ИначеЕсли Ставка = ПредопределенноеЗначение("Перечисление.НДФЛСтавки.Ставка03") Тогда
		ИмяПоляСправки = ИмяПоля + "ПоСтавке3";
	ИначеЕсли Ставка = ПредопределенноеЗначение("Перечисление.НДФЛСтавки.Ставка06") Тогда
		ИмяПоляСправки = ИмяПоля + "ПоСтавке6";
	ИначеЕсли Ставка = ПредопределенноеЗначение("Перечисление.НДФЛСтавки.Ставка07") Тогда
		ИмяПоляСправки = ИмяПоля + "ПоСтавке7";
	ИначеЕсли Ставка = ПредопределенноеЗначение("Перечисление.НДФЛСтавки.Ставка12") Тогда
		ИмяПоляСправки = ИмяПоля + "ПоСтавке12";
	КонецЕсли;
	
	Возврат ИмяПоляСправки;
КонецФункции

Функция СправкиНДФЛЗначениеИтоговПоСтавке(ДанныеСправки, ИмяПоля, Ставка) Экспорт 
	ИмяПоляИтоговПоСтавке = СправкиНДФЛИмяПоляИтоговПоСтавке(ИмяПоля, Ставка);
	
	Возврат ДанныеСправки[ИмяПоляИтоговПоСтавке];
КонецФункции

Функция СправкиНДФЛЕстьИтогиПоСтавке(ДанныеСправки, Ставка) Экспорт
	Возврат СправкиНДФЛЗначениеИтоговПоСтавке(ДанныеСправки, "ОбщаяСуммаДохода", Ставка) <> 0 
		Или СправкиНДФЛЗначениеИтоговПоСтавке(ДанныеСправки, "ОблагаемаяСуммаДохода", Ставка) <> 0
		Или СправкиНДФЛЗначениеИтоговПоСтавке(ДанныеСправки, "Исчислено", Ставка) <> 0
		Или СправкиНДФЛЗначениеИтоговПоСтавке(ДанныеСправки, "Удержано", Ставка) <> 0
  		Или СправкиНДФЛЗначениеИтоговПоСтавке(ДанныеСправки, "Перечислено", Ставка) <> 0
		Или СправкиНДФЛЗначениеИтоговПоСтавке(ДанныеСправки, "Задолженность", Ставка) <> 0
		Или СправкиНДФЛЗначениеИтоговПоСтавке(ДанныеСправки, "ИзлишнеУдержано", Ставка) <> 0;
	
КонецФункции	

Процедура СправкиНДФЛУстановитьИнфонадписьИсправления(Инфонадпись, ДанныеСправки, ДокументПроведен = Ложь, ДляНалогаНаПрибыль = Ложь) Экспорт
	ФиксируемыеПоля = СправкиНДФЛИменаФиксируемыхПолей();
	
	ЕстьЗафиксированныеДанные = Ложь;
	Для Каждого ИмяПоля Из ФиксируемыеПоля Цикл
		Если ДанныеСправки["Фикс" + ИмяПоля] Тогда	
			ЕстьЗафиксированныеДанные = Истина;
		КонецЕсли;	
	КонецЦикла;
	
	Если ДляНалогаНаПрибыль Тогда
		Если ДокументПроведен Тогда
			Инфонадпись = НСтр("ru = 'Документ проведен, данные получателя дохода зафиксированы и могут отличаться от данных в его карточке'");	
		ИначеЕсли ЕстьЗафиксированныеДанные Тогда
			Инфонадпись = НСтр("ru = 'Выделенные жирным шрифтом данные были зафиксированы в документе и могут отличаться от данных в карточке получателя дохода'");	
		Иначе
			Инфонадпись = НСтр("ru = 'Данные о получателе дохода берутся из его карточки автоматически.'");		
		КонецЕсли;	
	Иначе
		Если ДокументПроведен Тогда
			Инфонадпись = НСтр("ru = 'Документ проведен, данные сотрудника зафиксированы и могут отличаться от данных в карточке сотрудника'");	
		ИначеЕсли ЕстьЗафиксированныеДанные Тогда
			Инфонадпись = НСтр("ru = 'Выделенные жирным шрифтом данные были зафиксированы в документе и могут отличаться от данных в карточке сотрудника'");	
		Иначе
			Инфонадпись = НСтр("ru = 'Данные о сотруднике берутся из карточки сотрудника автоматически.'");		
		КонецЕсли;	
	КонецЕсли;
КонецПроцедуры		

Функция СправкиНДФЛДокументИспользуетКодОКТМО(ДанныеДокумента) Экспорт
	Если ДанныеДокумента.НалоговыйПериод >= 2013 
		И Не ДанныеДокумента.СпециальныйДокумент2013года Тогда 
		
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;	
КонецФункции	

Функция МесяцНалоговогоПериодаСтрокой(НомерМесяца) Экспорт
	Если НомерМесяца >= 1 И НомерМесяца <= 12 Тогда
		Возврат Формат(Дата(2012, НомерМесяца, 1), "ДФ=ММММ");
	Иначе
		Возврат "";
	КонецЕсли;
КонецФункции

#КонецОбласти

#Область ПанельПримененныеВычеты

// См. функцию УчетНДФЛКлиентСерверВнутренний.ОписаниеПанелиВычеты.
//
Функция ОписаниеПанелиВычеты() Экспорт
	
	Возврат УчетНДФЛКлиентСерверВнутренний.ОписаниеПанелиВычеты();
	
КонецФункции

// См. функцию УчетНДФЛКлиентСерверВнутренний.ОписаниеТабличнойЧастиНДФЛ.
//
Функция ОписаниеТабличнойЧастиНДФЛ() Экспорт
	
	Возврат УчетНДФЛКлиентСерверВнутренний.ОписаниеТабличнойЧастиНДФЛ();
	
КонецФункции

Функция НДФЛТекущиеДанные(Форма, ОписаниеПанелиВычеты) Экспорт

	Возврат УчетНДФЛКлиентСерверВнутренний.НДФЛТекущиеДанные(Форма, ОписаниеПанелиВычеты);
	
КонецФункции

Процедура ДополнитьПредставлениеВычетов(ПредставлениеВычетов, КодВычета, СуммаВычета) Экспорт
	
	Если ЗначениеЗаполнено(КодВычета) И ЗначениеЗаполнено(СуммаВычета) Тогда
		ПредставлениеВычетов = ПредставлениеВычетов + СуммаВычета;
	КонецЕсли; 
					
КонецПроцедуры

Процедура ЗаполнитьПредставлениеВычетовЛичныхСтрокиНДФЛ(Форма, СтрокаНДФЛ, ОписаниеПанелиВычеты) Экспорт
	
	ВычетыЛичные = ОписаниеПанелиВычеты.НастраиваемыеПанели.Получить("ВычетыЛичные");
	Если ВычетыЛичные <> Неопределено Тогда
	
		СтрокаНДФЛ.ПредставлениеВычетовЛичных = 0;
		ДополнитьПредставлениеВычетов(СтрокаНДФЛ.ПредставлениеВычетовЛичных, СтрокаНДФЛ.ПримененныйВычетЛичныйКодВычета, СтрокаНДФЛ.ПримененныйВычетЛичный);
		ДополнитьПредставлениеВычетов(СтрокаНДФЛ.ПредставлениеВычетовЛичных, СтрокаНДФЛ.ПримененныйВычетЛичныйКЗачетуВозвратуКодВычета, СтрокаНДФЛ.ПримененныйВычетЛичныйКЗачетуВозврату);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура НазначитьИдентификаторСтрокеНДФЛ(СтрокаНДФЛ, МаксимальныйИдентификаторСтрокиНДФЛ, НоваяСтрока) Экспорт
	
	Если Не НоваяСтрока Или СтрокаНДФЛ.ИдентификаторСтрокиНДФЛ > 0 Тогда
		Возврат;
	КонецЕсли;
	
	МаксимальныйИдентификаторСтрокиНДФЛ = МаксимальныйИдентификаторСтрокиНДФЛ + 1;
	СтрокаНДФЛ.ИдентификаторСтрокиНДФЛ = МаксимальныйИдентификаторСтрокиНДФЛ;
	
КонецПроцедуры

Функция ФормаПодробнееОРасчетеНДФЛОписаниеТаблицыНДФЛ() Экспорт
	
	Возврат УчетНДФЛКлиентСерверВнутренний.ФормаПодробнееОРасчетеНДФЛОписаниеТаблицыНДФЛ();
	
КонецФункции

#КонецОбласти
