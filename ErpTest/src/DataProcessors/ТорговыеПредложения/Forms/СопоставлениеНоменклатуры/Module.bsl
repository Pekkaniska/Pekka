
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НавигационнаяСсылка = "e1cib/app/" + ЭтотОбъект.ИмяФормы;

	РежимСопоставления = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ТорговыеПредложения",
		"СопоставлениеНоменклатуры\РежимСопоставления");
	
	Если Не ЗначениеЗаполнено(РежимСопоставления) Тогда
		РежимСопоставления = "ПоНоменклатуре";
	КонецЕсли;
	
	ТорговыеПредложенияПереопределяемый.ИнициализацияСпискаСопоставленияПоИерархии(Элементы.СписокПоИерархии);
	ТорговыеПредложенияПереопределяемый.ИнициализацияСпискаСопоставленияПоНоменклатуре(Элементы.СписокПоНоменклатуре);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокПоНоменклатуре,
		"ЭтоГруппа", Ложь, ВидСравненияКомпоновкиДанных.Равно,, Истина);
	
	ИспользоватьВидыНоменклатуры = Ложь;
	ТорговыеПредложенияПереопределяемый.ФункциональнаяОпцияИспользуется(ИмяФормы, ИспользоватьВидыНоменклатуры);
	Если Не ИспользоватьВидыНоменклатуры Тогда
		Элементы.ГруппаРежимПоВидам.Видимость = Ложь;
		Если РежимСопоставления = "ПоВидам" Тогда
			РежимСопоставления = "";
		КонецЕсли;
	Иначе
		ТорговыеПредложенияПереопределяемый.ИнициализацияСпискаСопоставленияНоменклатуры(Элементы.СписокПоВидам);	
	КонецЕсли;
	
	УстановитьРежимСопоставления();
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ТипыЗначенийСвойств = Новый СписокЗначений;
	ТорговыеПредложенияПереопределяемый.ПолучитьДоступныеТипыЗначенийСвойствДляСопоставления(ТипыЗначенийСвойств);
	
	ПустаяСсылкаРеквизитаОбъекта = Неопределено;
	ТорговыеПредложенияПереопределяемый.ПустаяСсылкаРеквизитаОбъектаДляСопоставления(ПустаяСсылкаРеквизитаОбъекта);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура РежимСопоставленияНажатие(Элемент)
	
	Если Элемент.Имя = "РежимПоВидам" Тогда
		РежимСопоставления = "ПоВидам";
	ИначеЕсли Элемент.Имя = "РежимПоИерархии" Тогда
		РежимСопоставления = "ПоИерархии";
	Иначе
		РежимСопоставления = "ПоНоменклатуре";
	КонецЕсли;
	
	УстановитьРежимСопоставления(Истина);
	ОбновитьРеквизитыСервиса();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ОбновитьРеквизитыСервиса", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущийСписок = Элементы["Список" + РежимСопоставления];
	
	Если Найти(Поле.Имя, "Категория")
		И Не (РежимСопоставления = "ПоВидам" И ТекущийСписок.ТекущиеДанные.ЭтоГруппа) Тогда
		
		// Если сопоставление подчиненное переход к списку родителя.
		Если РежимСопоставления = "ПоНоменклатуре" И Не ЗначениеЗаполнено(ТекущийСписок.ТекущиеДанные.КатегорияПоНоменклатуре) Тогда
			
			Если ЗначениеЗаполнено(ТекущийСписок.ТекущиеДанные.КатегорияПоВидам)
				И ЗначениеЗаполнено(ТекущийСписок.ТекущиеДанные.ВидНоменклатуры) Тогда
				
				СтандартнаяОбработка = Ложь;
				РежимСопоставления = "ПоВидам";
				УстановитьРежимСопоставления(Истина, ТекущийСписок.ТекущиеДанные.ВидНоменклатуры);
				
			ИначеЕсли ЗначениеЗаполнено(ТекущийСписок.ТекущиеДанные.КатегорияПоИерархии) 
				И ЗначениеЗаполнено(ТекущийСписок.ТекущиеДанные.Родитель) Тогда
				
				СтандартнаяОбработка = Ложь;
				РежимСопоставления = "ПоИерархии";
				УстановитьРежимСопоставления(Истина, ТекущийСписок.ТекущиеДанные.Родитель);
			Иначе
				
				СтандартнаяОбработка = Ложь;
				ВыбратьКатегориюСервиса(Элемент.ТекущиеДанные.ИдентификаторКатегории);
				
			КонецЕсли;
			
		Иначе
			
			СтандартнаяОбработка = Ложь;
			ВыбратьКатегориюСервиса(Элемент.ТекущиеДанные.ИдентификаторКатегории);
		
		КонецЕсли;
		
	ИначеЕсли Найти(Поле.Имя, "Ссылка") И Не Элемент.Имя = "СписокПоНоменклатуре" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокПоНоменклатуре,
			"ВидНоменклатуры", Неопределено, ВидСравненияКомпоновкиДанных.Равно,, Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокПоНоменклатуре,
			"Родитель", Неопределено, ВидСравненияКомпоновкиДанных.Равно,, Ложь);
		Элементы.ГруппаОтбор.Видимость = Ложь;
		
		Если РежимСопоставления = "ПоВидам" Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокПоНоменклатуре,
				"ВидНоменклатуры", Элемент.ТекущиеДанные.Ссылка, ВидСравненияКомпоновкиДанных.Равно,, Истина);
			Элементы.ДекорацияИмяПоляОтбора.Заголовок = НСтр("ru = 'Вид номенклатуры'") + ":";
			Элементы.ДекорацияЗначениеОтбора.Заголовок = Элемент.ТекущиеДанные.Ссылка;
			Элементы.ГруппаОтбор.Видимость = Истина;
		ИначеЕсли РежимСопоставления = "ПоИерархии" Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокПоНоменклатуре,
				"Родитель", Элемент.ТекущиеДанные.Ссылка, ВидСравненияКомпоновкиДанных.Равно,, Истина);
			Элементы.ДекорацияИмяПоляОтбора.Заголовок = НСтр("ru = 'Группа номенклатуры'") + ":";
			Элементы.ДекорацияЗначениеОтбора.Заголовок = Элемент.ТекущиеДанные.Ссылка;
			Элементы.ГруппаОтбор.Видимость = Истина;
		КонецЕсли;
		
		РежимСопоставления = "ПоНоменклатуре";
		УстановитьРежимСопоставления(Истина);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыРеквизиты

&НаКлиенте
Процедура РеквизитыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущийСписок = Элементы["Список" + РежимСопоставления];
	
	СтрокаРеквизита = Элементы.Реквизиты.ТекущиеДанные;
	СтрокаСопоставления = ТекущийСписок.ТекущиеДанные;
	Если Поле.Имя = "РеквизитыСоответствие" Тогда
		СтандартнаяОбработка = Ложь;
		Если СтрокаРеквизита.ВозможноСопоставление Тогда
			ОбработчикЗакрытия = Новый ОписаниеОповещения("ОбновитьСоответствие", ЭтотОбъект, СтрокаСопоставления.Ссылка);
			ОбъектСопоставления = СтрокаСопоставления.Ссылка;
			Если РежимСопоставления <> "ПоВидам" И ЗначениеЗаполнено(СтрокаСопоставления.ИдентификаторКатегорииПоВидам) Тогда
				ОбъектСопоставления = СтрокаСопоставления.ВидНоменклатуры;
			КонецЕсли;
			ПараметрыОткрытия = Новый Структура;
			ПараметрыОткрытия.Вставить("РеквизитОбъекта",                 СтрокаРеквизита.РеквизитОбъекта);
			ПараметрыОткрытия.Вставить("ОбъектСопоставления",             ОбъектСопоставления);
			ПараметрыОткрытия.Вставить("ТипЗначения",                     СтрокаРеквизита.ТипЗначения);
			ПараметрыОткрытия.Вставить("ИдентификаторКатегории",          СтрокаСопоставления.ИдентификаторКатегории);
			ПараметрыОткрытия.Вставить("ИдентификаторРеквизитаКатегории", СтрокаРеквизита.ИдентификаторРеквизитаКатегории);
			ПараметрыОткрытия.Вставить("ТолькоПросмотр", ЗапретРедактированиеРеквизитов);
			ОткрытьФорму("Обработка.ТорговыеПредложения.Форма.СопоставлениеЗначений", ПараметрыОткрытия,,,,, ОбработчикЗакрытия);
		КонецЕсли;
	ИначеЕсли Поле.Имя = "РеквизитыТипРеквизитаРубрикатора" Тогда
		СтандартнаяОбработка = Ложь;
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("ИдентификаторКатегории",          СтрокаСопоставления.ИдентификаторКатегории);
		ПараметрыОткрытия.Вставить("ИдентификаторРеквизитаКатегории", СтрокаРеквизита.ИдентификаторРеквизитаКатегории);
		ПараметрыОткрытия.Вставить("Категория",                       СтрокаСопоставления.Категория);
		ПараметрыОткрытия.Вставить("ТипРеквизитаРубрикатора",         СтрокаРеквизита.ТипРеквизитаРубрикатора);
		ПараметрыОткрытия.Вставить("ПредставлениеРеквизитаКатегории", СтрокаРеквизита.ПредставлениеРеквизитаКатегории);
		ОткрытьФорму("Обработка.ТорговыеПредложения.Форма.ПросмотрЗначений", ПараметрыОткрытия);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РеквизитыРеквизитОбъектаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Реквизиты.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПриИзмененииРеквизитаОбъекта(ТекущиеДанные);
	
КонецПроцедуры

// Определяет, что тип значения содержит тип дополнительных значений свойств.
//
// Параметры:
//  ТипЗначения	 - ОписаниеТипов - передаваемые типы.
// 
// Возвращаемое значение:
//  Булево - результат проверки.
//
&НаКлиенте
Функция ТипЗначенияСодержитЗначенияСвойств(ТипЗначения)
	
	Результат = Ложь;
	
	Для каждого ДоступныйТип Из ТипыЗначенийСвойств Цикл
		Если ТипЗначения.СодержитТип(ДоступныйТип.Значение) Тогда
			Результат = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура РеквизитыПриАктивизацииСтроки(Элемент)
	
	ДанныеВыбора = Новый СписокЗначений;
	ТекущиеДанные = Элементы.Реквизиты.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// Заполнение списка выбора.
	Элементы.РеквизитыРеквизитОбъекта.СписокВыбора.Очистить();
	Для каждого ЭлементСписка Из СписокВыбораРеквизитов Цикл
		Если Реквизиты.НайтиСтроки(Новый Структура("РеквизитОбъекта", ЭлементСписка.Значение)).Количество()
			И ТекущиеДанные.РеквизитОбъекта <> ЭлементСписка.Значение Тогда
			Продолжить;
		КонецЕсли;
		Элементы.РеквизитыРеквизитОбъекта.СписокВыбора.Добавить(ЭлементСписка.Значение, ЭлементСписка.Представление);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура РеквизитыРеквизитОбъектаОткрытие(Элемент, СтандартнаяОбработка)
	
	Если Элементы.Реквизиты.ТекущиеДанные.РеквизитОбъекта = Неопределено
		ИЛИ Не ЗначениеЗаполнено(Элементы.Реквизиты.ТекущиеДанные.РеквизитОбъекта) Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьКатегорию(Команда)
	
	ТекущиеДанные = Элементы["Список" + РежимСопоставления].ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено
		И Не (РежимСопоставления = "ПоВидам" И ТекущиеДанные.ЭтоГруппа) Тогда
		ВыбратьКатегориюСервиса(ТекущиеДанные.ИдентификаторКатегории);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьКатегорию(Команда)
	
	Если ЭтотОбъект.ТекущийЭлемент.ВыделенныеСтроки.Количество() <> 0 Тогда
		РежимУдаления = Истина;
		Отказ = Ложь;
		ОчиститьСопоставлениеКатегорий(ЭтотОбъект.ТекущийЭлемент.ВыделенныеСтроки, Отказ);
		
		Если Не Отказ Тогда
			ЭтотОбъект.ТекущийЭлемент.Обновить();
			КатегорияРеквизитов = "";
			ОбновитьРеквизитыСервиса();
			Оповестить("ТорговыеПредложение_СопоставлениеНоменклатуры");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьРеквизит(Команда)
	
	ТекущиеДанные = Элементы.Реквизиты.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено ИЛИ Не ЗначениеЗаполнено(ТекущиеДанные.РеквизитОбъекта) Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные.РеквизитОбъекта = Неопределено;
	ПриИзмененииРеквизитаОбъекта(ТекущиеДанные);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьРеквизитыСервиса()
	
	ТекстЗаголовка = НСтр("ru = 'Сопоставление реквизитов номенклатуры'");
	ТребуетсяОбновлениеРеквизитов = Ложь;
	
	Если ПустаяСтрока(РежимСопоставления) Тогда
		КатегорияРеквизитов = "";
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы["Список" + РежимСопоставления].ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		КатегорияРеквизитов = "";
		Реквизиты.Очистить();
		Возврат;
	КонецЕсли;
	
	ПараметрыПроцедуры = Новый Структура;
	ЗапретРедактированиеРеквизитов = Ложь;
	
	Если РежимСопоставления = "ПоНоменклатуре" Тогда
		
		// Для сопоставления по номенклатуре возможно заполнение данных по родителям (виду, группе).
		Если ЗначениеЗаполнено(ТекущиеДанные.ИдентификаторКатегорииПоНоменклатуре) Тогда
			ПараметрыПроцедуры.Вставить("Ссылка", ТекущиеДанные.Ссылка);
			ПараметрыПроцедуры.Вставить("ИдентификаторКатегории", ТекущиеДанные.ИдентификаторКатегорииПоНоменклатуре);
			НоваяКатегорияРеквизитов = ТекущиеДанные.ИдентификаторКатегорииПоНоменклатуре;
			ТекстЗаголовка = НСтр("ru = 'Сопоставление реквизитов номенклатуры'");
		ИначеЕсли ЗначениеЗаполнено(ТекущиеДанные.ИдентификаторКатегорииПоВидам) Тогда
			ПараметрыПроцедуры.Вставить("Ссылка", ТекущиеДанные.ВидНоменклатуры);
			ПараметрыПроцедуры.Вставить("ИдентификаторКатегории", ТекущиеДанные.ИдентификаторКатегорииПоВидам);
			НоваяКатегорияРеквизитов = ТекущиеДанные.ИдентификаторКатегорииПоВидам;
			ЗапретРедактированиеРеквизитов = Истина;
			ТекстЗаголовка = НСтр("ru = 'Сопоставленные реквизиты по виду номенклатуры'");
		ИначеЕсли ЗначениеЗаполнено(ТекущиеДанные.ИдентификаторКатегорииПоИерархии) Тогда
			ПараметрыПроцедуры.Вставить("Ссылка", ТекущиеДанные.Родитель);
			ПараметрыПроцедуры.Вставить("ИдентификаторКатегории", ТекущиеДанные.ИдентификаторКатегорииПоИерархии);
			НоваяКатегорияРеквизитов = ТекущиеДанные.ИдентификаторКатегорииПоИерархии;
			ЗапретРедактированиеРеквизитов = Истина;
			ТекстЗаголовка = НСтр("ru = 'Сопоставленные реквизиты по группе номенклатуры'");
		Иначе
			НоваяКатегорияРеквизитов = "";
		КонецЕсли;
		
	Иначе
		
		ПараметрыПроцедуры.Вставить("Ссылка", ТекущиеДанные.Ссылка);
		ПараметрыПроцедуры.Вставить("ИдентификаторКатегории", ТекущиеДанные.ИдентификаторКатегории); //ТекущиеДанные.ИдентификаторКатегории);
		НоваяКатегорияРеквизитов = ТекущиеДанные.ИдентификаторКатегории;
		
	КонецЕсли;
	
	Если КатегорияРеквизитов <> НоваяКатегорияРеквизитов Тогда
		КатегорияРеквизитов = НоваяКатегорияРеквизитов;
		ТребуетсяОбновлениеРеквизитов = Истина;
	КонецЕсли;
	
	Если Элементы.ГруппаРеквизитов.Заголовок <> ТекстЗаголовка Тогда 
		ТребуетсяОбновлениеРеквизитов = Истина;
		Элементы.Реквизиты.ТолькоПросмотр = ЗапретРедактированиеРеквизитов;
		Элементы.ГруппаРеквизитов.Заголовок = ТекстЗаголовка;
		Элементы.РеквизитыРеквизитОбъекта.КартинкаШапки =
			?(ЗапретРедактированиеРеквизитов, Новый Картинка, БиблиотекаКартинок.Изменить);
		Элементы.РеквизитыСоответствие.КартинкаШапки =
			?(ЗапретРедактированиеРеквизитов, Новый Картинка, БиблиотекаКартинок.Изменить);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(КатегорияРеквизитов) Тогда
		Реквизиты.Очистить();
		Возврат;
	КонецЕсли;
	
	Если Не ТребуетсяОбновлениеРеквизитов Тогда
		Возврат
	КонецЕсли;
	
	Если ИдентификаторЗаданияОбновленияРеквизитов <> Неопределено Тогда
		ОтменитьВыполнениеЗадания(ИдентификаторЗаданияОбновленияРеквизитов);
	КонецЕсли;
	
	Элементы.ГруппаСтраницРеквизитовСервиса.ТекущаяСтраница = Элементы.СтраницаДлительногоОжидания;
	
	Задание = Новый Структура("ИмяПроцедуры, Наименование, ПараметрыПроцедуры");
	Задание.Наименование = НСтр("ru = '1С:Бизнес-сеть. Получение реквизитов рубрикатора'");
	Задание.ИмяПроцедуры = "ТорговыеПредложения.ПолучитьРеквизитыРубрикатора";
	Задание.ПараметрыПроцедуры = ПараметрыПроцедуры;
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ТекстСообщения = Задание.Наименование;
	ПараметрыОжидания.ВыводитьПрогрессВыполнения = Ложь;
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ПараметрыОжидания.ОповещениеПользователя.Показать = Ложь;
	ПараметрыОжидания.ВыводитьСообщения = Истина;
	
	ДлительнаяОперация = ВыполнитьЗаданиеВФоне(Задание, УникальныйИдентификатор);
		
	Если СписокВыбораРеквизитов.Количество() Тогда
		СписокВыбораРеквизитов.Очистить();
	КонецЕсли;
		
	ИдентификаторЗаданияОбновленияРеквизитов = ДлительнаяОперация.ИдентификаторЗадания;
	
	ПараметрыПроцедуры.Вставить("ИдентификаторЗадания", ИдентификаторЗаданияОбновленияРеквизитов);
	ДлительнаяОперацияЗавершение = Новый ОписаниеОповещения(
		"ОбновитьРеквизитыСервисаЗавершение", ЭтотОбъект, ПараметрыПроцедуры);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация,
		ДлительнаяОперацияЗавершение,
		ПараметрыОжидания);
			
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииРеквизитаОбъекта(ТекущиеДанные)
	
	Если Не ЗначениеЗаполнено(ТекущиеДанные.РеквизитОбъекта) Тогда
		ТекущиеДанные.РеквизитОбъекта = ПустаяСсылкаРеквизитаОбъекта;
	КонецЕсли;
	
	ТекущийСписок = Элементы["Список" + РежимСопоставления];
	
	Отказ = Ложь;
	СохранитьСопоставлениеРеквизитов(ТекущийСписок.ТекущиеДанные.Ссылка, ТекущиеДанные.РеквизитОбъекта,
		ТекущиеДанные.ИдентификаторРеквизитаКатегории, ТекущиеДанные.ПредставлениеРеквизитаКатегории,
		ТекущийСписок.ТекущиеДанные.ИдентификаторКатегории, ТекущиеДанные.ТипЗначения, Отказ);
		
	Если Не ЗначениеЗаполнено(ТекущиеДанные.РеквизитОбъекта) Тогда
		ТекущиеДанные.Сопоставлено = Неопределено;
	КонецЕсли;
	
	ВозможноСопоставление = Ложь; ЗначениеСопоставления = "";
	Если ТипЗначенияСодержитЗначенияСвойств(Элементы.Реквизиты.ТекущиеДанные.ТипЗначения)
		И Элементы.Реквизиты.ТекущиеДанные.ТипРеквизитаРубрикатора = "Список" Тогда
		ВозможноСопоставление = Истина;
		ЗначениеСопоставления = СоответствиеЗначенийВСтроке(ТекущийСписок.ТекущаяСтрока, ТекущиеДанные.РеквизитОбъекта);
	КонецЕсли;
	Элементы.Реквизиты.ТекущиеДанные.ВозможноСопоставление = ВозможноСопоставление;
	Элементы.Реквизиты.ТекущиеДанные.Сопоставлено = ЗначениеСопоставления;

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьРеквизитыСервисаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Отказ = Ложь;
	ТекстСообщения = "";
	
	Элементы.ГруппаСтраницРеквизитовСервиса.ТекущаяСтраница = Элементы.СтраницаРеквизитов;
	
	Если Результат = Неопределено Тогда // отменено пользователем.
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Не Отказ И Результат.Статус = "Выполнено" Тогда
		// Обновление реквизитов.
		Если ЗначениеЗаполнено(Результат.АдресРезультата)
			И ЭтоАдресВременногоХранилища(Результат.АдресРезультата)
			И КатегорияРеквизитов = ДополнительныеПараметры.ИдентификаторКатегории
			И ИдентификаторЗаданияОбновленияРеквизитов = ДополнительныеПараметры.ИдентификаторЗадания Тогда
			
			ЗаполнитьСопоставлениеРеквизитов(Результат.АдресРезультата);
		КонецЕсли;
		ИдентификаторЗаданияОбновленияРеквизитов = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСопоставлениеРеквизитов(АдресРезультата)
	
	Результат = ПолучитьИзВременногоХранилища(АдресРезультата);
	
	Если Результат = Неопределено Тогда
		СписокВыбораРеквизитов.Очистить();
		Реквизиты.Очистить();
		Возврат;
	КонецЕсли;
	
	Если Результат.СопоставленныеРеквизиты.Количество() Тогда
		СписокВыбораРеквизитов.Очистить();
		Элементы.РеквизитыРеквизитОбъекта.СписокВыбора.Очистить();
		Для каждого СтрокаРеквизита Из Результат.СопоставленныеРеквизиты Цикл
			Если СписокВыбораРеквизитов.НайтиПоЗначению(СтрокаРеквизита.РеквизитОбъекта) = Неопределено Тогда
				СписокВыбораРеквизитов.Добавить(СтрокаРеквизита.РеквизитОбъекта, СтрокаРеквизита.Представление);
			КонецЕсли;
			СписокВыбораРеквизитов.СортироватьПоПредставлению();
		КонецЦикла;
	КонецЕсли;
	
	Реквизиты.Загрузить(Результат.РеквизитыРубрикатора);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВыполнитьЗаданиеВФоне(Знач Задание, УникальныйИдентификатор) 
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = Задание.Наименование;
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	Возврат ДлительныеОперации.ВыполнитьВФоне(Задание.ИмяПроцедуры, Задание.ПараметрыПроцедуры, ПараметрыВыполнения);
	
КонецФункции

&НаСервереБезКонтекста
Процедура ОтменитьВыполнениеЗадания(ИдентификаторЗадания)
	
	Если ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
		ИдентификаторЗадания = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКатегориюСервиса(ИдентификаторКатегории)
	
	ОчиститьСообщения();

	ТребуетсяОбновлениеКэшаКатегории = Ложь;
	Если ПустаяСтрока(АдресКэшаКатегорийРубрик) Тогда
		АдресКэшаКатегорийРубрик = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		ТребуетсяОбновлениеКэшаКатегории = Истина;
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ВыбратьКатегориюСервисаПродолжение", ЭтотОбъект);
	ПараметрыФормыВыбора = Новый Структура;
	ПараметрыФормыВыбора.Вставить("РежимВыбора",              Истина);
	ПараметрыФормыВыбора.Вставить("ЗакрыватьПриВыборе",       Истина);
	ПараметрыФормыВыбора.Вставить("РежимОткрытияОкна",        РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ПараметрыФормыВыбора.Вставить("Отбор",                    Новый Структура("ЭтоГруппа", Истина));
	ПараметрыФормыВыбора.Вставить("АдресКэшаКатегорийРубрик", АдресКэшаКатегорийРубрик);
	ПараметрыФормыВыбора.Вставить("ТребуетсяОбновлениеКэшаКатегории", ТребуетсяОбновлениеКэшаКатегории);
	ПараметрыФормыВыбора.Вставить("Идентификатор",            ИдентификаторКатегории);
	ОткрытьФорму("Обработка.ТорговыеПредложения.Форма.ДеревоКатегорий", ПараметрыФормыВыбора,,,,, Оповещение,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКатегориюСервисаПродолжение(Результат, ПараметрыВыбора) Экспорт
	
	Если Результат = Неопределено ИЛИ ТипЗнч(Результат) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	ЭлементСписок = ЭтотОбъект.ТекущийЭлемент;
	
	Результат.Свойство("АдресКэшаКатегорийРубрик", АдресКэшаКатегорийРубрик);
	
	Если ЭлементСписок.ВыделенныеСтроки.Количество() <> 0 И Результат.Свойство("Идентификатор") Тогда
		Отказ = Ложь;
		ЗаписатьЗначениеСопоставления(ЭлементСписок.ВыделенныеСтроки, Результат, Отказ);
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
		ЭлементСписок.Обновить();
		КатегорияРеквизитов = "";
		ОбновитьРеквизитыСервиса();
	КонецЕсли;
		
	Оповестить("ТорговыеПредложение_СопоставлениеНоменклатуры");
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаписатьЗначениеСопоставления(Знач ВыделенныеСтроки, Результат, Отказ)
	
	ОчиститьСопоставлениеКатегорий(ВыделенныеСтроки, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.СоответствиеНоменклатурыБизнесСеть.СоздатьНаборЗаписей();
	Для каждого ЗначениеМассива Из ВыделенныеСтроки Цикл
		НоваяЗапись = НаборЗаписей.Добавить();
		НоваяЗапись.ОбъектСопоставления    = ЗначениеМассива;
		НоваяЗапись.ИдентификаторКатегории = Результат.Идентификатор;
		НоваяЗапись.ПредставлениеКатегории = Результат.Представление;
	КонецЦикла;
	НаборЗаписей.Записать(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСоответствие(Результат, ПараметрыОбработчика) Экспорт
	
	// Обновление данных по строке.
	ТекущиеДанные = Элементы.Реквизиты.ТекущиеДанные;
	ТекущийСписок = Элементы["Список" + РежимСопоставления];
	ТекущиеДанныеСписка = ТекущийСписок.ТекущиеДанные;
	
	ОбъектСопоставления = ТекущийСписок.ТекущаяСтрока;
	Если РежимСопоставления <> "ПоВидам" И ЗначениеЗаполнено(ТекущиеДанныеСписка.ИдентификаторКатегорииПоВидам) Тогда
		ОбъектСопоставления = ТекущиеДанныеСписка.ВидНоменклатуры;
	КонецЕсли;
	
	ТекущиеДанные.Сопоставлено = СоответствиеЗначенийВСтроке(ОбъектСопоставления, ТекущиеДанные.РеквизитОбъекта);
	
КонецПроцедуры

&НаСервере
Функция СоответствиеЗначенийВСтроке(ОбъектСопоставления, РеквизитОбъекта)

	// Заполнение списка набора реквизитов.
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ОбъектСопоставления", ОбъектСопоставления);
	Запрос.УстановитьПараметр("РеквизитОбъекта", РеквизитОбъекта);
	
	ТорговыеПредложенияПереопределяемый.ИнициализацияЗапросаСоответствияЗначенийРеквизитовВидаНоменклатуры(Запрос);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Выборка.Следующий();
	Если Выборка.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Результат = СтрШаблон(НСтр("ru = 'Сопоставлено %1 из %2'"),
		Выборка.КоличествоСопоставленныхРеквизитов,
		Выборка.КоличествоЗначенийРеквизита);
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
// Очистка сопоставлений категорий.
//
// Параметры:
//  ВидыНоменклатуры - Массив - ссылки на виды номенклатуры, для которых требуется очистить сопоставления.
//
Процедура ОчиститьСопоставлениеКатегорий(Знач ОбъектыСопоставления, Отказ)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СоответствиеНоменклатурыБизнесСеть.ОбъектСопоставления КАК ОбъектСопоставления,
	|	СоответствиеНоменклатурыБизнесСеть.ИдентификаторКатегории КАК ИдентификаторКатегории
	|ИЗ
	|	РегистрСведений.СоответствиеНоменклатурыБизнесСеть КАК СоответствиеНоменклатурыБизнесСеть
	|ГДЕ
	|	СоответствиеНоменклатурыБизнесСеть.ОбъектСопоставления В(&ОбъектыСопоставления)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СоответствиеРеквизитовБизнесСеть.ОбъектСопоставления,
	|	СоответствиеРеквизитовБизнесСеть.РеквизитОбъекта,
	|	СоответствиеРеквизитовБизнесСеть.ИдентификаторРеквизитаКатегории
	|ИЗ
	|	РегистрСведений.СоответствиеРеквизитовБизнесСеть КАК СоответствиеРеквизитовБизнесСеть
	|ГДЕ
	|	СоответствиеРеквизитовБизнесСеть.ОбъектСопоставления В(&ОбъектыСопоставления)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СоответствиеЗначенийРеквизитовБизнесСеть.ОбъектСопоставления,
	|	СоответствиеЗначенийРеквизитовБизнесСеть.РеквизитОбъекта,
	|	СоответствиеЗначенийРеквизитовБизнесСеть.Значение
	|ИЗ
	|	РегистрСведений.СоответствиеЗначенийРеквизитовБизнесСеть КАК СоответствиеЗначенийРеквизитовБизнесСеть
	|ГДЕ
	|	СоответствиеЗначенийРеквизитовБизнесСеть.ОбъектСопоставления В(&ОбъектыСопоставления)";
	
	Запрос.УстановитьПараметр("ОбъектыСопоставления", ОбъектыСопоставления);
	
	Результат = Запрос.ВыполнитьПакет();
	
	Выборка = Результат[0].Выбрать();
	Если Выборка.Количество() = 0 Тогда
		// Если ранее не было сопоставления вида номенклатуры очистка сопоставлений не требуется.
		Возврат;
	КонецЕсли;
	
	НачатьТранзакцию();
	Попытка
		// Удаление записей р/с СопоставлениеНоменклатуры1СБизнесСеть.
		Пока Выборка.Следующий() Цикл
			МенеджерЗаписи = РегистрыСведений.СоответствиеНоменклатурыБизнесСеть.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.ОбъектСопоставления = Выборка.ОбъектСопоставления;
			МенеджерЗаписи.ИдентификаторКатегории = Выборка.ИдентификаторКатегории;
			МенеджерЗаписи.Удалить();
		КонецЦикла;

		// Удаление записей р/с СопоставлениеРеквизитов1СБизнесСеть.
		Выборка = Результат[1].Выбрать();
		Пока Выборка.Следующий() Цикл
			МенеджерЗаписи = РегистрыСведений.СоответствиеРеквизитовБизнесСеть.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.ОбъектСопоставления = Выборка.ОбъектСопоставления;
			МенеджерЗаписи.РеквизитОбъекта = Выборка.РеквизитОбъекта;
			МенеджерЗаписи.ИдентификаторРеквизитаКатегории = Выборка.ИдентификаторРеквизитаКатегории;
			МенеджерЗаписи.Удалить();
		КонецЦикла;
		
		// Удаление записей р/с СопоставлениеЗначенийРеквизитов1СБизнесСеть.
		Выборка = Результат[2].Выбрать();
		Пока Выборка.Следующий() Цикл
			МенеджерЗаписи = РегистрыСведений.СоответствиеЗначенийРеквизитовБизнесСеть.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.ОбъектСопоставления = Выборка.ОбъектСопоставления;
			МенеджерЗаписи.РеквизитОбъекта = Выборка.РеквизитОбъекта;
			МенеджерЗаписи.Значение = Выборка.Значение;
			МенеджерЗаписи.Удалить();
		КонецЦикла;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ТекстСообщения = НСтр("ru = 'Ошибка очистки сопоставления реквизитов:'") + " " + ИнформацияОбОшибке().Описание;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,, Отказ);
		ЭлектронноеВзаимодействиеСлужебный.ВыполнитьЗаписьСобытияПоЭДВЖурналРегистрации(
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()), "БизнесСеть");
	КонецПопытки;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СохранитьСопоставлениеРеквизитов(Знач ВидНоменклатуры, Знач РеквизитОбъекта,
	Знач ИдентификаторРеквизитаКатегории, Знач ПредставлениеРеквизитаКатегории, Знач ИдентификаторКатегории,
	ТипЗначения, Отказ)
	
	Если ЗначениеЗаполнено(РеквизитОбъекта) Тогда
		
		НачатьТранзакцию();
		Попытка
			// Удаление всех старых записей для идентификатора реквизита категории.
			Если ЗначениеЗаполнено(ИдентификаторРеквизитаКатегории) Тогда
				НаборЗаписей = РегистрыСведений.СоответствиеРеквизитовБизнесСеть.СоздатьНаборЗаписей();
				НаборЗаписей.Отбор.ОбъектСопоставления.Установить(ВидНоменклатуры);
				НаборЗаписей.Отбор.ИдентификаторРеквизитаКатегории.Установить(ИдентификаторРеквизитаКатегории);
				НаборЗаписей.Прочитать();
				НаборЗаписей.Очистить();
				НаборЗаписей.Записать(Истина);
			КонецЕсли;
			МенеджерЗаписи = РегистрыСведений.СоответствиеРеквизитовБизнесСеть.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.ОбъектСопоставления = ВидНоменклатуры;
			МенеджерЗаписи.РеквизитОбъекта = РеквизитОбъекта;
			МенеджерЗаписи.ИдентификаторРеквизитаКатегории = ИдентификаторРеквизитаКатегории;
			МенеджерЗаписи.ПредставлениеРеквизитаКатегории = ПредставлениеРеквизитаКатегории;
			МенеджерЗаписи.Записать(Истина);
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ТекстСообщения = НСтр("ru = 'Ошибка записи сопоставления:'") + " " + ИнформацияОбОшибке().Описание;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,, Отказ);
			ЭлектронноеВзаимодействиеСлужебный.ВыполнитьЗаписьСобытияПоЭДВЖурналРегистрации(
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()), "БизнесСеть");
			Возврат;
		КонецПопытки;
		
		// Обновление типа для текущей строки.
		СписокРеквизитов = Новый Соответствие;
		ТорговыеПредложенияПереопределяемый.ПолучитьРеквизитыНоменклатурыДоступныеДляПубликации(СписокРеквизитов);
		СвойстваРеквизита = СписокРеквизитов.Получить(РеквизитОбъекта);
		Если СвойстваРеквизита <> Неопределено Тогда
			ТипЗначения = СвойстваРеквизита.ТипЗначения;
		Иначе
			ТипЗначения = РеквизитОбъекта.ТипЗначения;
		КонецЕсли;
		
	Иначе
		
		НачатьТранзакцию();
		Попытка
			// Удаление сопоставления реквизитов.
			НаборЗаписей = РегистрыСведений.СоответствиеРеквизитовБизнесСеть.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.ОбъектСопоставления.Установить(ВидНоменклатуры);
			НаборЗаписей.Отбор.ИдентификаторРеквизитаКатегории.Установить(ИдентификаторРеквизитаКатегории);
			НаборЗаписей.Прочитать();
			
			// Очистка сопоставления значений реквизитов.
			Для каждого ЗаписьРеквизита Из НаборЗаписей Цикл
				НаборЗаписейЗначений = РегистрыСведений.СоответствиеЗначенийРеквизитовБизнесСеть.СоздатьНаборЗаписей();
				НаборЗаписейЗначений.Отбор.ОбъектСопоставления.Значение = ВидНоменклатуры;
				НаборЗаписейЗначений.Отбор.ОбъектСопоставления.Использование = Истина;
				НаборЗаписейЗначений.Отбор.РеквизитОбъекта.Значение = ЗаписьРеквизита.РеквизитОбъекта;
				НаборЗаписейЗначений.Отбор.РеквизитОбъекта.Использование = Истина;
				НаборЗаписейЗначений.Записать();
			КонецЦикла;
			
			НаборЗаписей.Очистить();
			НаборЗаписей.Записать();
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ТекстСообщения = НСтр("ru = 'Ошибка очистки сопоставления:'") + " " + ИнформацияОбОшибке().Описание;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,, Отказ);
			ЭлектронноеВзаимодействиеСлужебный.ВыполнитьЗаписьСобытияПоЭДВЖурналРегистрации(
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()), "БизнесСеть");
			Возврат;
		КонецПопытки;
		
		ТипЗначения = Неопределено;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	// Надпись <Укажите реквизит>.
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.РеквизитыРеквизитОбъекта.Имя);
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Реквизиты.РеквизитОбъекта");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЗапретРедактированиеРеквизитов");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НедоступныеДанныеЭДЦвет);
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<Укажите реквизит>'"));
	
	// Надпись <Автоматически>.
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.РеквизитыСоответствие.Имя);
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Реквизиты.РеквизитОбъекта");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Реквизиты.ВозможноСопоставление");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НедоступныеДанныеЭДЦвет);
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<Автоматически>'"));
	
	// Подчиненные по группам и видам номенклатуры (выделение серым).
	ЭлементУсловногоОформления = СписокПоНоменклатуре.УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("Категория");
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("КатегорияПоНоменклатуре");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НедоступныеДанныеЭДЦвет);
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(,,, Истина));
	
	// Переопределение значений выводе реквизитов сопоставления.
	СписокРеквизитов = Новый Соответствие;
	ТорговыеПредложенияПереопределяемый.ПолучитьРеквизитыНоменклатурыДоступныеДляПубликации(СписокРеквизитов);
	Для каждого ДоступныйРеквизит Из СписокРеквизитов Цикл
		ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
		ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.РеквизитыРеквизитОбъекта.Имя);
		ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Реквизиты.РеквизитОбъекта");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = ДоступныйРеквизит.Значение.ПутьКДанным;
		ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", ДоступныйРеквизит.Значение.Представление);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьРежимСопоставления(Интерактивно = Ложь, ТекущаяСтрока = Неопределено)
	
	Элементы.ГруппаРежимПоВидам.ЦветФона        = ?(РежимСопоставления = "ПоВидам", ЦветаСтиля.ЦветФонаШапкиТаблицы, ЦветаСтиля.ЦветФонаФормы);
	Элементы.ГруппаРежимПоИерархии.ЦветФона     = ?(РежимСопоставления = "ПоИерархии", ЦветаСтиля.ЦветФонаШапкиТаблицы, ЦветаСтиля.ЦветФонаФормы);
	Элементы.ГруппаРежимПоНоменклатуре.ЦветФона = ?(РежимСопоставления = "ПоНоменклатуре", ЦветаСтиля.ЦветФонаШапкиТаблицы, ЦветаСтиля.ЦветФонаФормы);
	
	Элементы.РежимПоВидам.Гиперссылка        = ?(РежимСопоставления <> "ПоВидам", Истина, Ложь);
	Элементы.РежимПоИерархии.Гиперссылка     = ?(РежимСопоставления <> "ПоИерархии", Истина, Ложь);
	Элементы.РежимПоНоменклатуре.Гиперссылка = ?(РежимСопоставления <> "ПоНоменклатуре", Истина, Ложь);
	
	Если РежимСопоставления = "ПоВидам" Тогда
		Элементы.СтраницыСписки.ТекущаяСтраница = Элементы.СтраницаПоВидам;
	ИначеЕсли РежимСопоставления = "ПоИерархии" Тогда
		Элементы.СтраницыСписки.ТекущаяСтраница = Элементы.СтраницаПоИерархии;
	ИначеЕсли РежимСопоставления = "ПоНоменклатуре" Тогда
		
		Если Не Интерактивно Тогда
			// Очистка отбора.
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокПоНоменклатуре,
				"ВидНоменклатуры", Неопределено, ВидСравненияКомпоновкиДанных.Равно,, Ложь);
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокПоНоменклатуре,
				"Родитель", Неопределено, ВидСравненияКомпоновкиДанных.Равно,, Ложь); 
			Элементы.ГруппаОтбор.Видимость = Ложь;
		КонецЕсли;
		Элементы.СтраницыСписки.ТекущаяСтраница = Элементы.СтраницаПоНоменклатуре;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекущаяСтрока) Тогда
		Элементы["Список" + РежимСопоставления].ТекущаяСтрока = ТекущаяСтрока;
	КонецЕсли;
	
	Если Интерактивно Тогда
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ТорговыеПредложения",
			"СопоставлениеНоменклатуры\РежимСопоставления", РежимСопоставления);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияОтменитьОтборНажатие(Элемент)
	
	РежимСопоставления = "ПоНоменклатуре";
	УстановитьРежимСопоставления(Ложь);
	
КонецПроцедуры

#КонецОбласти
