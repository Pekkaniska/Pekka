#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем МаксУровень;

#КонецОбласти

#Область ПрограммныйИнтерфейс

// Выполняет формирование отчета.
//
// Параметры:
//  ПолеТабличногоДокумента	 - ТабличныйДокумент  - документ для вывода отчета.
// 
// Возвращаемое значение:
//  Булево - Истина, если отчет сформирован успешно. Ложь в противном случае.
//
Функция СформироватьОтчет(ПолеТабличногоДокумента) Экспорт
	
	Отказ = Ложь;
	
	МаксУровень = 1000;
	
	ЭтапыПроцесса = Неопределено;
	СписокМаршрутныхКарт = Новый Массив;
	ДобавитьЭтапыПроцесса(МаршрутнаяКарта, ЭтапыПроцесса, 1, СписокМаршрутныхКарт, -1, Отказ);
	
	Если Отказ Тогда
		Возврат Ложь;
	КонецЕсли; 
	
	Макет = ПолучитьМакет("Макет");
	
	// Если маршрутных карт больше 1, то раскрасим операции
	СписокЦветов = Новый Массив;
	Если СписокМаршрутныхКарт.Количество() > 1 Тогда
		Область_Цвета = Макет.ПолучитьОбласть("ВложенныеМК_Цвета");
		Для Сч = 1 По Область_Цвета.ВысотаТаблицы Цикл
			СписокЦветов.Добавить(Область_Цвета.Область(Сч,1,Сч,1).ЦветФона);
		КонецЦикла;
	КонецЕсли; 
	
	ЭтапыПроцесса.Колонки.Добавить("Текст1", Новый ОписаниеТипов("Строка"));
	ЭтапыПроцесса.Колонки.Добавить("Текст2", Новый ОписаниеТипов("Строка"));
	
	Для каждого СтрокаЭтапа Из ЭтапыПроцесса Цикл
		Если СтрокаЭтапа.СодержитВложенныйМаршрут Тогда
			СтрокаЭтапа.Текст1 = НСтр("ru = 'Вложенный маршрут'");
		Иначе	
			СтрокаЭтапа.Текст1 = НСтр("ru = '%1'");
			СтрокаЭтапа.Текст1 = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
											СтрокаЭтапа.Текст1, 
											СтрокаЭтапа.ПодразделениеПредставление);
			
			СтрокаЭтапа.Текст2 = СтрокаЭтапа.РабочийЦентрПредставление;
			СтрокаЭтапа.ПараметрыВывода.Вставить("РазмещениеТекста2", ТипРазмещенияТекстаТабличногоДокумента.Переносить);
		КонецЕсли;
		
		ЦветФонаЭтапа = ПолучитьЦветМаршрутнойКарты(СписокМаршрутныхКарт.Найти(СтрокаЭтапа.Владелец), СписокЦветов);;
		СтрокаЭтапа.ПараметрыВывода.Вставить("ЦветФонаЭтапа", ЦветФонаЭтапа);
	КонецЦикла;
	
	Результат = УниверсальнаяОбработкаПроцессов.СформироватьГрафическоеПредставлениеПроцесса(ЭтапыПроцесса);
	
	ПолеТабличногоДокумента.Очистить();
	
	ОбластьОтступ = Макет.ПолучитьОбласть("Отступ");
	
	// Заголовок
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОбластьЗаголовок.Параметры.МаршрутнаяКарта = МаршрутнаяКарта;
	
	ПолеТабличногоДокумента.Вывести(ОбластьЗаголовок);
	
	// Список вложенных маршртуных карт
	Если СписокМаршрутныхКарт.Количество() > 1 Тогда
		ПолеТабличногоДокумента.Вывести(ОбластьОтступ);
		ПолеТабличногоДокумента.Вывести(Макет.ПолучитьОбласть("ВложенныеМК_Заголовок"));
		ПолеТабличногоДокумента.НачатьГруппуСтрок(, Ложь);
		
		ОбластьВложенныеМК_Строка = Макет.ПолучитьОбласть("ВложенныеМК_Строка");
		Для каждого МаршрутнаяКартаСхемы Из СписокМаршрутныхКарт Цикл
			ОбластьВложенныеМК_Строка.Область(1,2,1,2).ЦветФона = ПолучитьЦветМаршрутнойКарты(СписокМаршрутныхКарт.Найти(МаршрутнаяКартаСхемы), СписокЦветов);
			ОбластьВложенныеМК_Строка.Параметры.МаршрутнаяКарта = МаршрутнаяКартаСхемы;
			ПолеТабличногоДокумента.Вывести(ОбластьВложенныеМК_Строка);
		КонецЦикла;
		ПолеТабличногоДокумента.ЗакончитьГруппуСтрок();
	КонецЕсли;
	
	// Схема
	ПолеТабличногоДокумента.Вывести(Результат.ТабличныйДокумент);
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьЭтапыПредшественники(НомерОперации, Процесс, Уровень, Группа)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ТехнологическиеОперации.Ссылка КАК ЭтапПроцесса,
	               |	ВЫБОР
	               |		КОГДА ТехнологическиеОперации.РабочийЦентр ССЫЛКА Справочник.РабочиеЦентры
	               |			ТОГДА ЕСТЬNULL(ВЫРАЗИТЬ(ТехнологическиеОперации.РабочийЦентр КАК Справочник.РабочиеЦентры).ВидРабочегоЦентра.Подразделение, """")
	               |		ИНАЧЕ ЕСТЬNULL(ВЫРАЗИТЬ(ТехнологическиеОперации.РабочийЦентр КАК Справочник.ВидыРабочихЦентров).Подразделение, """")
	               |	КОНЕЦ КАК Цех,
				   |	&Группа КАК Группа
	               |ИЗ
	               |	Справочник.ТехнологическиеОперации КАК ТехнологическиеОперации
	               |ГДЕ
	               |	ТехнологическиеОперации.Владелец = &МаршрутнаяКарта
	               |	И НЕ ТехнологическиеОперации.ПометкаУдаления
	               |	И ТехнологическиеОперации.НомерСледующейОперации = &НомерОперации
	               |	И (&Уровень = 1
	               |			ИЛИ &ПоказатьОперацииВложенныхМаршрутов
	               |			ИЛИ ТехнологическиеОперации.СодержитВложенныйМаршрут)";

	Запрос.УстановитьПараметр("МаршрутнаяКарта", Процесс);
	Запрос.УстановитьПараметр("НомерОперации",   НомерОперации);
	Запрос.УстановитьПараметр("Уровень", Уровень);
	Запрос.УстановитьПараметр("Группа", Группа);
	Запрос.УстановитьПараметр("ПоказатьОперацииВложенныхМаршрутов", ПоказатьОперацииВложенныхМаршрутов);
		
 	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Функция ДобавитьЭтапыПроцесса(Процесс, ЭтапыПроцесса, Уровень, СписокМаршрутныхКарт, Группа, Отказ)

	Если НЕ Справочники.МаршрутныеКарты.ПоследовательностьОперацийПравильная(МаршрутнаяКарта, Отказ) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ТехнологическиеОперации.Владелец КАК Владелец,
	               |	ТехнологическиеОперации.Ссылка КАК Этап,
	               |	ТехнологическиеОперации.Представление КАК ПредставлениеЭтапа,
	               |	ТехнологическиеОперации.Ссылка КАК Расшифровка,
	               |	ТехнологическиеОперации.НомерОперации КАК НомерОперации,
	               |	ТехнологическиеОперации.НомерСледующейОперации КАК НомерСледующейОперации,
	               |	ТехнологическиеОперации.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	               |	ТехнологическиеОперации.СодержитВложенныйМаршрут КАК СодержитВложенныйМаршрут,
	               |	ТехнологическиеОперации.ВложенныйМаршрут КАК ВложенныйМаршрут,
	               |	ТехнологическиеОперации.РабочийЦентр.Представление КАК РабочийЦентрПредставление,
	               |	ВЫБОР
	               |		КОГДА ТехнологическиеОперации.РабочийЦентр ССЫЛКА Справочник.РабочиеЦентры
	               |			ТОГДА ЕСТЬNULL(ВЫРАЗИТЬ(ТехнологическиеОперации.РабочийЦентр КАК Справочник.РабочиеЦентры).ВидРабочегоЦентра.Подразделение, """")
	               |		ИНАЧЕ ЕСТЬNULL(ВЫРАЗИТЬ(ТехнологическиеОперации.РабочийЦентр КАК Справочник.ВидыРабочихЦентров).Подразделение, """")
	               |	КОНЕЦ КАК Подразделение,
	               |	ВЫБОР
	               |		КОГДА ТехнологическиеОперации.РабочийЦентр ССЫЛКА Справочник.РабочиеЦентры
	               |			ТОГДА ЕСТЬNULL(ВЫРАЗИТЬ(ТехнологическиеОперации.РабочийЦентр КАК Справочник.РабочиеЦентры).ВидРабочегоЦентра.Подразделение.Представление, """")
	               |		ИНАЧЕ ЕСТЬNULL(ВЫРАЗИТЬ(ТехнологическиеОперации.РабочийЦентр КАК Справочник.ВидыРабочихЦентров).Подразделение.Представление, """")
	               |	КОНЕЦ КАК ПодразделениеПредставление
	               |ИЗ
	               |	Справочник.ТехнологическиеОперации КАК ТехнологическиеОперации
	               |ГДЕ
	               |	ТехнологическиеОперации.Владелец = &МаршрутнаяКарта
	               |	И НЕ ТехнологическиеОперации.ПометкаУдаления";
				   
	Запрос.УстановитьПараметр("МаршрутнаяКарта", Процесс);
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	Если ЭтапыПроцесса = Неопределено Тогда
		ЭтапыПроцесса = РезультатЗапроса.СкопироватьКолонки();
		УниверсальнаяОбработкаПроцессов.ДобавитьОбязательныеКолонкиВЭтапыПроцесса(ЭтапыПроцесса);
	КонецЕсли;
	
	// Оставим только вложенные маршруты
	Если Уровень > 1 И НЕ ПоказатьОперацииВложенныхМаршрутов Тогда
		МассивОпераций = Новый Массив;
		
		Для каждого Выборка Из РезультатЗапроса Цикл
			Если НЕ Выборка.СодержитВложенныйМаршрут Тогда
				МассивОпераций.Добавить(Выборка.Этап);
			КонецЕсли;
		КонецЦикла; 
		
		// Удалим операции
		Для каждого Этап Из МассивОпераций Цикл
			УдаляемыйЭтап = РезультатЗапроса.Найти(Этап, "Этап");
			ПредыдущиеЭтапы = РезультатЗапроса.НайтиСтроки(Новый Структура("НомерСледующейОперации", УдаляемыйЭтап.НомерОперации));
			Для каждого ПредыдущийЭтап Из ПредыдущиеЭтапы Цикл
				ПредыдущийЭтап.НомерСледующейОперации = УдаляемыйЭтап.НомерСледующейОперации;
			КонецЦикла;
			РезультатЗапроса.Удалить(УдаляемыйЭтап);
		КонецЦикла; 
	КонецЕсли; 
	
	Если Уровень = 1 ИЛИ ПоказатьОперацииВложенныхМаршрутов Тогда
		СписокМаршрутныхКарт.Добавить(Процесс);
	КонецЕсли; 
	
	Для каждого Выборка Из РезультатЗапроса Цикл
		
		СтрокаЭтапа = ЭтапыПроцесса.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаЭтапа, Выборка);
		СтрокаЭтапа.ПорядковыйНомер = Формат(МаксУровень - Уровень, "ЧГ=0") + "_" + Формат(Выборка.НомерОперации, "ЧГ=0");
		СтрокаЭтапа.Группа = Группа;
		
		СтрокаЭтапа.ЭтапыПредшественники = ПолучитьЭтапыПредшественники(СтрокаЭтапа.НомерОперации, Процесс, Уровень, Группа);
		
		Если Выборка.СодержитВложенныйМаршрут Тогда
			
			ЭтапыВложенногоМаршрута = ДобавитьЭтапыПроцесса(
				Выборка.ВложенныйМаршрут,
				ЭтапыПроцесса,
				Уровень + 1,
				СписокМаршрутныхКарт,
				ЭтапыПроцесса.Индекс(СтрокаЭтапа),
				Отказ);
				
			Для каждого ЭлементКоллекции Из ЭтапыВложенногоМаршрута Цикл
				НоваяСтрока = СтрокаЭтапа.ЭтапыПредшественники.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, ЭлементКоллекции);
				НоваяСтрока.Группа = ЭтапыПроцесса.Индекс(СтрокаЭтапа);
			КонецЦикла;
			
			Если НЕ ПоказатьОперацииВложенныхМаршрутов Тогда
				СтрокаЭтапа.Владелец = Выборка.ВложенныйМаршрут;
				СписокМаршрутныхКарт.Добавить(Выборка.ВложенныйМаршрут);
			КонецЕсли; 
			
		КонецЕсли; 
		
	КонецЦикла; 
	
	ПредшественникиТекущегоПроцесса = Новый ТаблицаЗначений;
	ПредшественникиТекущегоПроцесса.Колонки.Добавить("ЭтапПроцесса",  Новый ОписаниеТипов("СправочникСсылка.ТехнологическиеОперации"));
	ПредшественникиТекущегоПроцесса.Колонки.Добавить("Подразделение", Новый ОписаниеТипов("СправочникСсылка.СтруктураПредприятия"));
	
	Для каждого Выборка Из РезультатЗапроса Цикл
		Если Выборка.НомерСледующейОперации = 0 Тогда
			Этап = ПредшественникиТекущегоПроцесса.Добавить();
			Этап.ЭтапПроцесса  = Выборка.Этап;
			Этап.Подразделение = Выборка.Подразделение;
		КонецЕсли; 
	КонецЦикла; 
	
	Возврат ПредшественникиТекущегоПроцесса;
	
КонецФункции

Функция ПолучитьЦветМаршрутнойКарты(НомерШаблона, СписокЦветов)

	Если НомерШаблона < СписокЦветов.ВГраница() Тогда
		Возврат СписокЦветов.Получить(НомерШаблона)
	Иначе
		Возврат Новый Цвет;
	КонецЕсли; 

КонецФункции

#КонецОбласти

#КонецЕсли