#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

	// Горячие клавиши
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ГорячиеКлавиши";
	КомандаПечати.Представление = НСтр("ru = 'Горячие клавиши'");

КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ГорячиеКлавиши") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ГорячиеКлавиши", "ГорячиеКлавиши", СформироватьПечатнуюФорму(МассивОбъектов, ОбъектыПечати));
	КонецЕсли;
	
КонецПроцедуры

Функция СформироватьПечатнуюФорму(МассивОбъектов, ОбъектыПечати)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	РезультатЗапроса = ПолучитьДанныеДляПечати(МассивОбъектов);
	Выборка = РезультатЗапроса.Выбрать();
	
	ПервыйДокумент = Истина;
	
	Пока Выборка.Следующий() Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ЗаполнитьТабличныйДокументПоДаннымОбъекта(ТабличныйДокумент, ПолучитьДанныеОбъектаПоВыборке(Выборка));
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Выборка.Ссылка);
		
	КонецЦикла;
	
	Если ПривилегированныйРежим() Тогда
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция ПолучитьДанныеДляПечати(МассивОбъектов)
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СправочникГорячиеКлавиши.Ссылка        КАК Ссылка,
	|	СправочникГорячиеКлавиши.БыстрыеТовары КАК БыстрыеТовары,
	|	СправочникГорячиеКлавиши.КомандыФормы  КАК КомандыФормы
	|ИЗ
	|	Справочник.ГорячиеКлавиши КАК СправочникГорячиеКлавиши
	|ГДЕ
	|	СправочникГорячиеКлавиши.Ссылка В(&МассивОбъектов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	СправочникГорячиеКлавиши.Ссылка";
	
	Возврат Запрос.Выполнить();
	
КонецФункции

Функция ПолучитьДанныеОбъектаПоВыборке(Выборка)
	
	ДанныеОбъекта = Новый Структура;
	
	ДанныеОбъекта.Вставить("Ссылка",        Выборка.Ссылка);
	ДанныеОбъекта.Вставить("БыстрыеТовары", Выборка.БыстрыеТовары);
	ДанныеОбъекта.Вставить("КомандыФормы",  Выборка.КомандыФормы);
	
	Возврат ДанныеОбъекта;
	
КонецФункции

Процедура ЗаполнитьТабличныйДокументПоДаннымОбъекта(ТабличныйДокумент, ДанныеОбъекта)
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Справочник.ГорячиеКлавиши.ПФ_MXL_ГорячиеКлавиши");
	
	Область = Макет.ПолучитьОбласть("Заголовок");
	ЗаполнитьЗначенияСвойств(Область.Параметры, ДанныеОбъекта);
	ТабличныйДокумент.Вывести(Область);
	
	Область = Макет.ПолучитьОбласть("Строка");
	БыстрыеТовары = ДанныеОбъекта.БыстрыеТовары.Получить();
	Для Каждого СтрокаТЧ Из БыстрыеТовары Цикл
		Параметры = Новый Структура("Наименование, СочетаниеКлавиш",
		СтрокаТЧ.Заголовок, СтрокаТЧ.СочетаниеКлавиш);
		ЗаполнитьЗначенияСвойств(Область.Параметры, Параметры);
		ТабличныйДокумент.Вывести(Область);
	КонецЦикла;
	
	КомандыФормы = ДанныеОбъекта.КомандыФормы.Получить();
	Для Каждого СтрокаТЧ Из КомандыФормы Цикл
		Параметры = Новый Структура("Наименование, СочетаниеКлавиш",
		СтрокаТЧ.Заголовок, СтрокаТЧ.СочетаниеКлавиш);
		ЗаполнитьЗначенияСвойств(Область.Параметры, Параметры);
		ТабличныйДокумент.Вывести(Область);
	КонецЦикла;
	
	Область = Макет.ПолучитьОбласть("Подвал");
	ТабличныйДокумент.Вывести(Область);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли