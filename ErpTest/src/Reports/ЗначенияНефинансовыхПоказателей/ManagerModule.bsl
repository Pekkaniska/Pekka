#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область КомандыПодменюОтчеты

// Добавляет команду отчета в список команд.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов.
//
Функция ДобавитьКомандуОтчета(КомандыОтчетов) Экспорт

	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.ЗначенияНефинансовыхПоказателей) 
			И ПолучитьФункциональнуюОпцию("ИспользоватьБюджетирование") Тогда
		
		КомандаОтчет = КомандыОтчетов.Добавить();
		
		КомандаОтчет.Менеджер = Метаданные.Отчеты.ЗначенияНефинансовыхПоказателей.ПолноеИмя();
		КомандаОтчет.Представление = НСтр("ru = 'Значения показателя'");
		
		КомандаОтчет.МножественныйВыбор = Ложь;
		КомандаОтчет.Важность = "Важное";
		КомандаОтчет.КлючВарианта = "ЗначенияНефинансовогоПоказателя";
		
		Возврат КомандаОтчет;
		
	КонецЕсли;

	Возврат Неопределено;

КонецФункции

#КонецОбласти

#КонецОбласти
	
#Область СлужебныеПроцедурыИФункции

Функция ПредставлениеПериодаПоНомеру(Период, НомерПериода, Периодичность) Экспорт
	
	Результат = "";
	
	Если Периодичность = Перечисления.Периодичность.День Тогда
		Результат = Формат(Период, "ДФ='dd MMMM'");
	ИначеЕсли Периодичность = Перечисления.Периодичность.Неделя Тогда
		Шаблон = НСтр("ru = '%1 неделя'");
		Результат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			Шаблон, НомерПериода);
	ИначеЕсли Периодичность = Перечисления.Периодичность.Декада Тогда
		Шаблон = НСтр("ru = '%1 декада'");
		Результат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			Шаблон, НомерПериода);
	ИначеЕсли Периодичность = Перечисления.Периодичность.Месяц Тогда
		Результат = Формат(Период, "ДФ='MMMM'");
	ИначеЕсли Периодичность = Перечисления.Периодичность.Квартал Тогда
		Шаблон = НСтр("ru = '%1 квартал'");
		Результат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			Шаблон, НомерПериода);
	ИначеЕсли Периодичность = Перечисления.Периодичность.Полугодие Тогда
		Шаблон = НСтр("ru = '%1 полугодие'");
		Результат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			Шаблон, НомерПериода);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает значения нефинансового показателя в периоде с учетом его вида
//
// Параметры
// 	ТаблицаЗначенийПоказателя - ТаблицаЗначений -  Значения нефинансового показателя для группировки
// 	Валюта - СправочникСсылка.Валюты - Валюта денежного нефинансового показателя
// 	ЕдиницаИзмерения - СправочникСсылка.УпаковкиЕдиницыИзмерения - Единица измерения количественного нефинансового показателя
// 	ВидПоказателя - ПеречислениеСсылка.ВидыНефинансовыхПоказателей - Вид нефинансового показателя
// 	ПоПериодам - Булево - Признак того, что значения вводятся по подпериодам
// 	ПоОрганизациям - Булево - Признак того, что значения вводятся по организациям
// 	ПоПодразделениям - Булево - Признак того, что значения вводятся по подразделениям
// 	КоличествоАналитик - Число - Количество аналитик, используемых для финансового показателя
// 	УстанавливатьЗначениеНаКаждыйПериод - Булево - Признак, что требуется установка значения на каждый период
// 	Период - Дата - Текущий период отчета
// 	ПериодичностьОтчета - ПеречислениеСсылка.Периодичность - Периодичность построения отчета
// 	ПериодичностьПоказателя - ПеречислениеСсылка.Периодичность - Периодичность показателя
// 	Группировка - Строка - Группировка, для которой возвращается значение нефинансового показателя
// 	РежимРасшифровки - Булево - Признак, что отчет выполняется в режиме расшифровки
// 	Кэш - Соответствие - Кэш, используемый при работе функции.
// 
// Возвращаемое значение
// 	Строка - Представление значений нефинансового показателя для периода отчета.
//
Функция Подключаемый_ЗначениеПоказателяДляГруппировки(
		ТаблицаЗначенийПоказателя,
		Валюта,
		ЕдиницаИзмерения,
		НефинансовыйПоказатель,
		ВидПоказателя,
		ПоПериодам,
		ПоОрганизациям,
		ПоПодразделениям,
		КоличествоАналитик,
		УстанавливатьЗначениеНаКаждыйПериод,
		Период,
		ПериодичностьОтчета,
		ПериодичностьПоказателя,
		Группировка,
		РежимРасшифровки,
		Кэш) Экспорт
		
	Результат = "";
	
	Если НЕ ЗначениеЗаполнено(НефинансовыйПоказатель) Тогда
		Возврат Результат;
	КонецЕсли;
	
	НастройкиПоказателя = Новый Структура;
	НастройкиПоказателя.Вставить("ПоОрганизациям",     ПоОрганизациям);
	НастройкиПоказателя.Вставить("ПоПодразделениям",   ПоПодразделениям);
	НастройкиПоказателя.Вставить("КоличествоАналитик", КоличествоАналитик);
	НастройкиПоказателя.Вставить("РежимРасшифровки",   РежимРасшифровки);
	НастройкиПоказателя.Вставить("ОбщееКоличествоГруппировок", 0);
	
	ПорядокГруппировок = ПолучитьПорядокГруппировок(НастройкиПоказателя, Группировка);
	
	НастройкиПоказателя.Вставить("ПорядокГруппировок", ПорядокГруппировок);
	
	Группировки = Новый Соответствие;
	ДобавитьГруппировку(Группировки, НастройкиПоказателя, "НефинансовыйПоказатель");
	ДобавитьГруппировку(Группировки, НастройкиПоказателя, "Организация");
	ДобавитьГруппировку(Группировки, НастройкиПоказателя, "Подразделение");
	ДобавитьГруппировку(Группировки, НастройкиПоказателя, "Аналитика1");
	ДобавитьГруппировку(Группировки, НастройкиПоказателя, "Аналитика2");
	ДобавитьГруппировку(Группировки, НастройкиПоказателя, "Аналитика3");
	ДобавитьГруппировку(Группировки, НастройкиПоказателя, "Аналитика4");
	ДобавитьГруппировку(Группировки, НастройкиПоказателя, "Аналитика5");
	ДобавитьГруппировку(Группировки, НастройкиПоказателя, "Аналитика6");
	ДобавитьГруппировку(Группировки, НастройкиПоказателя, "Сценарий");
	ДобавитьГруппировку(Группировки, НастройкиПоказателя, "Регистратор");
	
	СвойстваГруппировки = Группировки.Получить(Группировка);
	Если НЕ СвойстваГруппировки.Используется
	 ИЛИ СвойстваГруппировки.НомерГруппировки <> НастройкиПоказателя.ОбщееКоличествоГруппировок Тогда
		Возврат Результат;
	КонецЕсли;
	
	ПустаяТаблица = Истина;
	Для каждого СтрокаТаблицы Из ТаблицаЗначенийПоказателя Цикл
		Если ЗначениеЗаполнено(СтрокаТаблицы.Значение) Тогда
			ПустаяТаблица = Ложь;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ПустаяТаблица Тогда
		Возврат Результат;
	КонецЕсли;
	
	Если ТаблицаЗначенийПоказателя.Количество() = 1
		И (ПериодичностьОтчета = ПериодичностьПоказателя 
			Или Не УстанавливатьЗначениеНаКаждыйПериод) Тогда
		Строка = ТаблицаЗначенийПоказателя[0];
		Результат = ПредставлениеЗначенияПоказателяПоВиду(Строка.Значение, ВидПоказателя, Валюта, ЕдиницаИзмерения);
		Возврат Результат;
	КонецЕсли;
	
	ОкончаниеПериода = БюджетированиеКлиентСервер.ДобавитьИнтервал(Период, ПериодичностьОтчета, 1, Кэш) - 1;
	МассивПодстрокРезультата = Новый Массив;
	Для каждого Строка Из ТаблицаЗначенийПоказателя Цикл
		Если ПоПериодам Тогда
			Если Строка.ПериодУстановки < Период Или Строка.ПериодУстановки > ОкончаниеПериода Тогда
				Продолжить;
			КонецЕсли;
			ПредставлениеПериода = Отчеты.ЗначенияНефинансовыхПоказателей.ПредставлениеПериодаПоНомеру(Строка.ПериодУстановки, Строка.НомерПодпериода, ПериодичностьПоказателя);
		ИначеЕсли УстанавливатьЗначениеНаКаждыйПериод Тогда
			ПредставлениеПериода = БюджетированиеКлиентСервер.ПредставлениеПериодаПоДате(Строка.ПериодУстановки, ПериодичностьПоказателя);
		Иначе
			ПредставлениеПериода = БюджетированиеКлиентСервер.ПредставлениеПериодаПоДате(Строка.ПериодУстановки, ПериодичностьОтчета);
		КонецЕсли;
		
		ПредставлениеЗначения = ПредставлениеЗначенияПоказателяПоВиду(
			Строка.Значение, ВидПоказателя, Валюта, ЕдиницаИзмерения, "-");
			
		МассивПодстрокРезультата.Добавить(ПредставлениеПериода + ": " + ПредставлениеЗначения);
		
	КонецЦикла;
	
	Результат = СтрСоединить(
		МассивПодстрокРезультата, 
		"
		|");
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьПорядокГруппировок(НастройкиПоказателя, Группировка)
	
	ПорядокГруппировок = Новый Массив;
	
	ПорядокГруппировок.Добавить("НефинансовыйПоказатель");
	Если НастройкиПоказателя.ПоОрганизациям Тогда
		ПорядокГруппировок.Добавить("Организация");
	КонецЕсли;
	Если НастройкиПоказателя.ПоПодразделениям Тогда
		ПорядокГруппировок.Добавить("Подразделение");
	КонецЕсли;
	Для НомерАналитики = 1 По 6 Цикл
		Если НомерАналитики <= НастройкиПоказателя.КоличествоАналитик Тогда
			ИмяАналитики = "Аналитика" + НомерАналитики;
			ПорядокГруппировок.Добавить(ИмяАналитики);
		КонецЕсли;
	КонецЦикла;
	
	Если НастройкиПоказателя.РежимРасшифровки Тогда
		Если Группировка = "Сценарий" Тогда
			ПорядокГруппировок.Добавить("Сценарий"); // Сценарий в колонке с Периодом
		КонецЕсли;
		Если Группировка = "Регистратор" Тогда
			ПорядокГруппировок.Добавить("Регистратор");
		КонецЕсли;
		
		Если Группировка = "Организация"
		   И НЕ НастройкиПоказателя.ПоОрганизациям Тогда
			
			ЕстьГруппировкиГлубжеТекущей = НастройкиПоказателя.ПоПодразделениям
			                           ИЛИ НастройкиПоказателя.КоличествоАналитик > 0;
			
			Если НЕ ЕстьГруппировкиГлубжеТекущей Тогда
				ПорядокГруппировок.Добавить("Организация");
			КонецЕсли;
		КонецЕсли;
		Если Группировка = "Подразделение"
		   И НЕ НастройкиПоказателя.ПоПодразделениям Тогда
			
			ЕстьГруппировкиГлубжеТекущей = НастройкиПоказателя.КоличествоАналитик > 0;
			
			Если НЕ ЕстьГруппировкиГлубжеТекущей Тогда
				ПорядокГруппировок.Добавить("Подразделение");
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
		
	Возврат ПорядокГруппировок;
	
КонецФункции

Процедура ДобавитьГруппировку(Группировки, НастройкиПоказателя, Группировка)
	
	ПорядокГруппировок = НастройкиПоказателя.ПорядокГруппировок;
	
	ИндексГруппировки = ПорядокГруппировок.Найти(Группировка);
	
	Если ИндексГруппировки <> Неопределено Тогда
		СвойстваГруппировки = Новый Структура("Используется, НомерГруппировки", Истина, ИндексГруппировки + 1);
	Иначе
		СвойстваГруппировки = Новый Структура("Используется, НомерГруппировки", Ложь, 0);
	КонецЕсли;
	
	Группировки.Вставить(Группировка, СвойстваГруппировки);
	Если СвойстваГруппировки.Используется Тогда
		НастройкиПоказателя.ОбщееКоличествоГруппировок = НастройкиПоказателя.ОбщееКоличествоГруппировок + 1;
	КонецЕсли;
	
КонецПроцедуры

Функция ПредставлениеЗначенияПоказателяПоВиду(Значение, ВидПоказателя, Валюта, ЕдиницаИзмерения, ПредставлениеНезаполненного = "")
	
	Если Не ЗначениеЗаполнено(Значение) Тогда
		Возврат ПредставлениеНезаполненного;
	КонецЕсли;
	
	Если ВидПоказателя = Перечисления.ВидыНефинансовыхПоказателей.Денежный Тогда
		Возврат Формат(Строка(Значение), "ЧДЦ=2") + " " + Строка(Валюта);
	ИначеЕсли ВидПоказателя = Перечисления.ВидыНефинансовыхПоказателей.Количественный Тогда
		Возврат Формат(Строка(Значение), "ЧЦ=15; ЧДЦ=3") + " " + Строка(ЕдиницаИзмерения);
	Иначе
		Возврат Строка(Значение);
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецЕсли