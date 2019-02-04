#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// Формирует таблицу с материалами, имеющими наибольшую задержку в обеспечении по данным модели графика производства.
//
// Параметры:
//  Параметры  - Структура - параметры формирования отчета.
//		* Распоряжение - ДокументСсылка.ЗаказНаПроизводство2_2 - заказ, график которого необходимо проанализировать.
//		* КоличествоЕдиниц - Число - максимальное количество позиций номенклатуры данные по которым необходимо вернуть.
//			Выборка и обход данных выполняются в порядке убывания срока задержки в обеспечении.
//  АдресХранилища - Строка - адрес хранилища, в которое будет помещен результат.
//
Процедура ПолучитьМатериалыСНаибольшейЗадержкойВОбеспечении(Параметры, АдресХранилища) Экспорт
	
	Распоряжение = Параметры.Распоряжение;
	ОсталосьЕдиниц = Параметры.КоличествоЕдиниц;
	
	СхемаКомпоновкиДанных = Отчеты.ПотребностьВМатериалахПоМоделиГрафикаПроизводства.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	
	ИмяВарианта = "МатериалыСЗадержкойВОбеспеченииКонтекст";
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.ВариантыНастроек.Найти(ИмяВарианта).Настройки);
	
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	ВнешниеНаборы = Новый Структура;
	
	Параметр = ПараметрРаспоряжение(НастройкиОтчета);
	Параметр.Значение = Распоряжение;
	
	НастроитьНаборыДанных(СхемаКомпоновкиДанных, НастройкиОтчета, ВнешниеНаборы);
	
	// Компоновка и вывод.
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(
		СхемаКомпоновкиДанных,
		НастройкиОтчета,
		,
		,
		Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборы, , Истина);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	РезультатВывода = Новый ТаблицаЗначений;
	ПроцессорВывода.УстановитьОбъект(РезультатВывода);
	ПроцессорВывода.НачатьВывод();
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	ПроцессорВывода.ЗакончитьВывод();
	
	Результат = РезультатВывода.СкопироватьКолонки();
	Для Индекс = 0 По РезультатВывода.Количество()-1 Цикл
		
		НоваяСтрока = Результат.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, РезультатВывода[Индекс]);
		
		ОсталосьЕдиниц = ОсталосьЕдиниц - 1;
		Если ОсталосьЕдиниц = 0 Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	ПоместитьВоВременноеХранилище(Результат, АдресХранилища);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура НастроитьНаборыДанных(СхемаКомпоновкиДанных, НастройкиОтчета, ВнешниеНаборы) Экспорт
	
	// Изменение текста запроса.
	ТекстЗапроса = СхемаКомпоновкиДанных.НаборыДанных.Потребность.Запрос;
	ПодставитьВТекстЗапросаПараметрыВесаОбъема(ТекстЗапроса);
	СхемаКомпоновкиДанных.НаборыДанных.Потребность.Запрос = ТекстЗапроса;
	
	// Заполнение внешних наборов данных.
	ЗаполнитьВнешниеНаборы(НастройкиОтчета, ВнешниеНаборы);
	
КонецПроцедуры

Процедура ПодставитьВТекстЗапросаПараметрыВесаОбъема(ТекстЗапроса)
	
	ТекстЗапросаВес = Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаВесУпаковки(
		"ЭтапПроизводства2_2ОбеспечениеМатериаламиИРаботами.Номенклатура.ЕдиницаИзмерения",
		"ЭтапПроизводства2_2ОбеспечениеМатериаламиИРаботами.Номенклатура");
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ВесНоменклатуры", ТекстЗапросаВес);
	
	ТекстЗапросаОбъем = Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаОбъемУпаковки(
		"ЭтапПроизводства2_2ОбеспечениеМатериаламиИРаботами.Номенклатура.ЕдиницаИзмерения",
		"ЭтапПроизводства2_2ОбеспечениеМатериаламиИРаботами.Номенклатура");
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ОбъемНоменклатуры", ТекстЗапросаОбъем);
	
КонецПроцедуры

Процедура ЗаполнитьВнешниеНаборы(НастройкиОтчета, ВнешниеНаборы)
	
	Распоряжение = ПараметрРаспоряжение(НастройкиОтчета).Значение;
	Обеспечение = ДатыОбеспеченияМатериалов(Распоряжение);
	ВнешниеНаборы.Вставить("Обеспечение", Обеспечение);
	
КонецПроцедуры

Функция ПараметрРаспоряжение(НастройкиОтчета)
	
	ПараметрКомпоновки = Новый ПараметрКомпоновкиДанных("Распоряжение");
	Результат = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(ПараметрКомпоновки);
	Если Результат = Неопределено Тогда
		ВызватьИсключение НСтр("ru = 'Отсутствует обязательный параметр ""Распоряжение""'");
	Иначе
		Возврат Результат;
	КонецЕсли;
	
КонецФункции

Функция ДатыОбеспеченияМатериалов(Распоряжение)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ЭтапПроизводства2_2.Ссылка КАК ЭтапПроизводства
	|ИЗ
	|	Документ.ЭтапПроизводства2_2 КАК ЭтапПроизводства2_2
	|ГДЕ
	|	ЭтапПроизводства2_2.Распоряжение = &Распоряжение
	|	И ЭтапПроизводства2_2.Проведен
	|	И ЭтапПроизводства2_2.Статус В(&СтатусыЭтапа)");
	
	Запрос.УстановитьПараметр("Распоряжение", Распоряжение);
	Запрос.УстановитьПараметр("СтатусыЭтапа",
		Документы.ЭтапПроизводства2_2.СтатусыЭтапМожетБытьЗапланирован());
	
	Этапы = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ЭтапПроизводства");
	
	Возврат Документы.ЭтапПроизводства2_2.ДатыОбеспеченияЭтапов(Этапы, Истина);
	
КонецФункции

#КонецОбласти

#КонецЕсли
