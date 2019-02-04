
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ТипОбъектаВыбора = Параметры.ТипОбъектаВыбора;
	РезультатыПоиска = ПолучитьИзВременногоХранилища(Параметры.АдресВоВременномХранилище);
	АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(Параметры.Отбор, Новый УникальныйИдентификатор());
	
	// скроем элементы, которые не получаем запросом
	Для каждого Элемент из Элементы Цикл
		Если ТипЗнч(Элемент) = Тип("ПолеФормы") и Элемент.Родитель = Элементы.НайденныеОбъекты Тогда
			Если Элемент.Имя = "name" 
				Или РезультатыПоиска.НаборКолонок.Найти(Элемент.Имя) <> Неопределено Тогда
				Элемент.Видимость = Истина;
			Иначе
				Элемент.Видимость = Ложь;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если ИнтеграцияС1СДокументооборотПовтИсп.ИспользоватьТерминКорреспонденты() Тогда
		Элементы.correspondent.Заголовок = НСтр("ru = 'Корреспондент'");
	КонецЕсли;
	
	ЗаполнитьФормуРезультатамиПоиска(РезультатыПоиска.НайденныеОбъекты, РезультатыПоиска.ПредставлениеУсловийПоиска);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПредставлениеУсловийПоискаПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеУсловийПоискаПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	Если ТипЗнч(ПараметрыПеретаскивания.Значение) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеРеквизита = ПараметрыПеретаскивания.Значение;
	Если ОписаниеРеквизита.Свойство("Имя") и ОписаниеРеквизита.Свойство("Значение") Тогда
		СтандартнаяОбработка = Ложь;
		УточнитьПоиск(ОписаниеРеквизита);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеУсловийПоискаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ИзменитьУсловияПоиска();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНайденныеОбъекты

&НаКлиенте
Процедура НайденныеОбъектыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ВыбратьТекущуюСтроку();
	
КонецПроцедуры

&НаКлиенте
Процедура НайденныеОбъектыНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	ОписаниеРеквизита = Новый Структура;
	ИмяРеквизита = Элемент.ТекущийЭлемент.Имя;
	ОписаниеРеквизита.Вставить("Имя", ИмяРеквизита);
	ОписаниеРеквизита.Вставить("Представление", Элемент.ТекущийЭлемент.Заголовок);
	ОписаниеРеквизита.Вставить("Значение", Элемент.ТекущиеДанные[ИмяРеквизита]);
	Если Найти("documentType, organization, correspondent, folder", ИмяРеквизита) <> 0 Тогда // ссылочный тип ДО
		ОписаниеРеквизита.Вставить("ЗначениеID", Элемент.ТекущиеДанные[Элемент.ТекущийЭлемент.Имя + "ID"]);
		Если ИмяРеквизита = "documentType" Тогда
			ОписаниеРеквизита.Вставить("ЗначениеТип", ТипОбъектаВыбора + "Type");
		ИначеЕсли ИмяРеквизита = "organization" Тогда
			ОписаниеРеквизита.Вставить("ЗначениеТип", "DMOrganization");
		ИначеЕсли ИмяРеквизита = "correspondent" Тогда
			ОписаниеРеквизита.Вставить("ЗначениеТип", "DMCorrespondent");
		ИначеЕсли ИмяРеквизита = "folder" Тогда
			ОписаниеРеквизита.Вставить("ЗначениеТип", "DMInternalDocumentFolder");
		КонецЕсли;
	КонецЕсли;
	ПараметрыПеретаскивания.Значение = ОписаниеРеквизита;
	Выполнение = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	ВыбратьТекущуюСтроку();
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьУсловия(Команда)
	
	ИзменитьУсловияПоиска();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыбратьТекущуюСтроку()
	
	ТекущиеДанные = Элементы.НайденныеОбъекты.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		Результат = Новый Структура;
		Результат.Вставить("РеквизитID",  ТекущиеДанные.ID);
		Результат.Вставить("РеквизитТип", ТипОбъектаВыбора);
		Результат.Вставить("РеквизитПредставление", ТекущиеДанные.name);
		Закрыть(Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УточнитьПоиск(ОписаниеРеквизита)
	
	СтруктураОтбора = ПолучитьИзВременногоХранилища(АдресВоВременномХранилище);
	ОписаниеУсловия = Новый Структура;
	Если ОписаниеРеквизита.Свойство("ЗначениеID") Тогда
		ОписаниеУсловия.Вставить("ЗначениеID", ОписаниеРеквизита.ЗначениеID);
		ОписаниеУсловия.Вставить("ЗначениеТип", ОписаниеРеквизита.ЗначениеТип);
	КонецЕсли;
	Если ОписаниеРеквизита.Имя = "name" Тогда
		ОписаниеУсловия.Вставить("ОператорСравнения", "LIKE");
		ОписаниеУсловия.Вставить("Значение", "%" + ОписаниеРеквизита.Значение + "%");
		ОписаниеУсловия.Вставить("ПредставлениеУсловия", СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'содержит ""%1""'"), ОписаниеРеквизита.Значение));
	Иначе
		ОписаниеУсловия.Вставить("ОператорСравнения", "=");
		ОписаниеУсловия.Вставить("Значение", ОписаниеРеквизита.Значение);
	КонецЕсли;
	ОписаниеУсловия.Вставить("Представление", ОписаниеРеквизита.Представление);
	СтруктураОтбора.Вставить(ОписаниеРеквизита.Имя, ОписаниеУсловия);
	
	КоличествоРезультатов = 0; ПредельноеКоличествоРезультатов = 0;
	Обработки.ИнтеграцияС1СДокументооборот.ВыполнитьПоискПоРеквизитам(ТипОбъектаВыбора, СтруктураОтбора, АдресВоВременномХранилище, 
		КоличествоРезультатов, ПредельноеКоличествоРезультатов);
		
	РезультатыПоиска = ПолучитьИзВременногоХранилища(АдресВоВременномХранилище);
	АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(СтруктураОтбора, Новый УникальныйИдентификатор());
	
	// скроем элементы, которые не получаем запросом
	Для каждого Элемент из Элементы Цикл
		Если ТипЗнч(Элемент) = Тип("ПолеФормы") и Элемент.Родитель = Элементы.НайденныеОбъекты Тогда
			Если Элемент.Имя = "name" 
				Или РезультатыПоиска.НаборКолонок.Найти(Элемент.Имя) <> Неопределено Тогда
				Элемент.Видимость = Истина;
			Иначе
				Элемент.Видимость = Ложь;
			КонецЕсли;
		КонецЕсли;                                                
	КонецЦикла;
	
	ЗаполнитьФормуРезультатамиПоиска(РезультатыПоиска.НайденныеОбъекты, РезультатыПоиска.ПредставлениеУсловийПоиска);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьФормуРезультатамиПоиска(МассивРезультатов, Представление)
	
	ПредставлениеУсловийПоиска.Очистить();
	ПредставлениеУсловийПоиска.Добавить().Представление = Представление;
	
	НайденныеОбъекты.Очистить();
	Для каждого РезультатПоиска из МассивРезультатов Цикл
		
		НайденныйОбъект = НайденныеОбъекты.Добавить();
		ЗаполнитьЗначенияСвойств(НайденныйОбъект, РезультатПоиска);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьУсловияПоиска()
	
	СтруктураОтбора = ПолучитьИзВременногоХранилища(АдресВоВременномХранилище);
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТипОбъектаВыбора", ТипОбъектаВыбора);
	ПараметрыФормы.Вставить("Отбор", СтруктураОтбора);
	ПараметрыФормы.Вставить("ИскатьСразу", Ложь);
	
	ЭтоРасширенныйПоиск = Ложь;
	Для каждого РеквизитПоиска из СтруктураОтбора Цикл
		ИмяРеквизита = РеквизитПоиска.Ключ;
		ОписаниеУсловия = РеквизитПоиска.Значение;
		Если Найти("correspondent, organization, documentType,
			|name, sum, regNumber, anyDate, inn, kpp", ИмяРеквизита) = 0 Тогда
			ЭтоРасширенныйПоиск = Истина;
			Прервать;
		ИначеЕсли ИмяРеквизита = "name" и ОписаниеУсловия.ОператорСравнения <> "LIKE" Тогда
			ЭтоРасширенныйПоиск = Истина;
			Прервать;
		ИначеЕсли ИмяРеквизита = "anyDate" и ОписаниеУсловия.ОператорСравнения <> ">=" Тогда
			ЭтоРасширенныйПоиск = Истина;
			Прервать;
		ИначеЕсли Найти("regNumber, inn, kpp", ИмяРеквизита) <> 0 
			и ОписаниеУсловия.ОператорСравнения <> "=" Тогда
			ЭтоРасширенныйПоиск = Истина;
			Прервать;
		КонецЕсли;	
	КонецЦикла;
	Если ЭтоРасширенныйПоиск Тогда
		Закрыть();
		ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.ВыборОбъектаПоискомРасширенный", ПараметрыФормы,,,,,
			ОписаниеОповещенияОЗакрытии,РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	Иначе
		Закрыть();
		ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.ВыборОбъектаПоиском", ПараметрыФормы,,,,,
			ОписаниеОповещенияОЗакрытии,РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

