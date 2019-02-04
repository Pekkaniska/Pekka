#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область Печать

// Сформировать печатные формы объектов
//
// ВХОДЯЩИЕ:
// 		ИменаМакетов    - Строка    - Имена макетов, перечисленные через запятую
// 		МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать
// 		ПараметрыПечати - Структура - Структура дополнительных параметров печати.
//
// ИСХОДЯЩИЕ:
// 		КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы
// 		ПараметрыВывода       - Структура        - Параметры сформированных табличных документов.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	СтруктураТипов = ОбщегоНазначенияУТ.СоответствиеМассивовПоТипамОбъектов(МассивОбъектов);
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Акт") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм, "Акт", НСтр("ru='Акт об оказании услуг'"),
			СформироватьПечатнуюФормуАктОбОказанииУслуг(СтруктураТипов, ОбъектыПечати, ПараметрыПечати));
		
	КонецЕсли;
	
	ФормированиеПечатныхФорм.ЗаполнитьПараметрыОтправки(ПараметрыВывода.ПараметрыОтправки, СтруктураТипов, КоллекцияПечатныхФорм);
	
КонецПроцедуры

Функция СформироватьПечатнуюФормуАктОбОказанииУслуг(СтруктураТипов, ОбъектыПечати, ПараметрыПечати) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_АктОбОказанииУслуг";
	
	НомерТипаДокумента = 0;
	
	Для Каждого СтруктураОбъектов Из СтруктураТипов Цикл
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(СтруктураОбъектов.Ключ);
		
		ЭтаПечатнаяФормаДоступна = Ложь;
		КомандыПечати = УправлениеПечатью.СоздатьКоллекциюКомандПечати();
		МенеджерОбъекта.ДобавитьКомандыПечати(КомандыПечати);
		Для Каждого ДоступнаяПечатнаяФорма Из КомандыПечати Цикл
			Если ДоступнаяПечатнаяФорма.Идентификатор = "Акт" Тогда
				ЭтаПечатнаяФормаДоступна = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если Не ЭтаПечатнаяФормаДоступна Тогда
			Продолжить;
		КонецЕсли;
		
		НомерТипаДокумента = НомерТипаДокумента + 1;
		Если НомерТипаДокумента > 1 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ДанныеДляПечати = МенеджерОбъекта.ПолучитьДанныеДляПечатнойФормыАктОбОказанииУслуг(ПараметрыПечати, СтруктураОбъектов.Значение);
		ЗаполнитьТабличныйДокументАктОбОказанииУслуг(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати);
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Процедура ЗаполнитьТабличныйДокументАктОбОказанииУслуг(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати)
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьАктОбОказанииУслуг.ПФ_MXL_Акт");
	
	ИспользоватьРучныеСкидки = ПолучитьФункциональнуюОпцию("ИспользоватьРучныеСкидкиВПродажах");
	ИспользоватьАвтоматическиеСкидки = ПолучитьФункциональнуюОпцию("ИспользоватьАвтоматическиеСкидкиВПродажах");
	ПоказыватьНДС = Константы.ВыводитьДопКолонкиНДС.Получить();
	
	ДанныеПечати = ДанныеДляПечати.РезультатПоШапке.Выбрать();
	ВыборкаПоДокументам = ДанныеДляПечати.РезультатПоТабличнойЧасти.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	ПервыйДокумент = Истина;
	СтруктураПоиска = Новый Структура("Ссылка");
	СсылкиБезСтрок = Новый Соответствие;
	
	Пока ДанныеПечати.Следующий() Цикл
		
		СтруктураПоиска.Ссылка = ДанныеПечати.Ссылка;
		ВыборкаПоДокументам.Сбросить();
		Если НЕ ВыборкаПоДокументам.НайтиСледующий(СтруктураПоиска) Тогда
			Если СсылкиБезСтрок[ДанныеПечати.Ссылка] = Неопределено Тогда
				Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'В документе %1 отсутствуют услуги. Печать акта об оказании услуг не требуется.'"), ДанныеПечати.Ссылка);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, ДанныеПечати.Ссылка);
			КонецЕсли;
			СсылкиБезСтрок.Вставить(ДанныеПечати.Ссылка,ДанныеПечати.Ссылка);
			Продолжить;
		КонецЕсли;
		ВыборкаПоУслугам = ВыборкаПоДокументам.Выбрать();
		ЗаголовокСкидки = ФормированиеПечатныхФорм.НужноВыводитьСкидки(ВыборкаПоУслугам, ИспользоватьРучныеСкидки Или ИспользоватьАвтоматическиеСкидки);
		ЕстьСкидки = ЗаголовокСкидки.ЕстьСкидки;
		
		ЕстьНДС = ДанныеПечати.УчитыватьНДС;
		ВыборкаПоУслугам.Сбросить();
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Выводим шапку акта
		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		ШтрихкодированиеПечатныхФорм.ВывестиШтрихкодВТабличныйДокумент(ТабличныйДокумент, Макет, ОбластьМакета, ДанныеПечати.Ссылка);

		ТекстЗаголовка = ОбщегоНазначенияУТКлиентСервер.СформироватьЗаголовокДокумента(ДанныеПечати, НСтр("ru='Акт'"));
		СтруктураДанныхШапки = Новый Структура;
		СтруктураДанныхШапки.Вставить("ТекстЗаголовка", ТекстЗаголовка);
		ОбластьМакета.Параметры.Заполнить(СтруктураДанныхШапки);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета                                   = Макет.ПолучитьОбласть("Поставщик");
		СтруктураДанныхПоставщик = Новый Структура;
		ПредставлениеПоставщика                         = ФормированиеПечатныхФорм.ОписаниеОрганизации(ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.Организация, ДанныеПечати.Дата), "ПолноеНаименование");
		СтруктураДанныхПоставщик.Вставить("ПредставлениеПоставщика", ПредставлениеПоставщика);
		СтруктураДанныхПоставщик.Вставить("Поставщик", ДанныеПечати.Организация);
		ОбластьМакета.Параметры.Заполнить(СтруктураДанныхПоставщик);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета                                   = Макет.ПолучитьОбласть("Покупатель");
		СтруктураДанныхПокупатель = Новый Структура;
		ПредставлениеПолучателя                         = ФормированиеПечатныхФорм.ОписаниеОрганизации(ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.Контрагент, ДанныеПечати.Дата), "ПолноеНаименование");
		СтруктураДанныхПокупатель.Вставить("ПредставлениеПолучателя", ПредставлениеПолучателя);
		СтруктураДанныхПокупатель.Вставить("Получатель", ДанныеПечати.Контрагент);
		ОбластьМакета.Параметры.Заполнить(СтруктураДанныхПокупатель);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		// Выводим заголовок таблицы Услуги
		
		СуффиксОбласти = ?(ЕстьСкидки, "СоСкидкой", "") + ?(ЕстьНДС И ПоказыватьНДС, "СНДС", "");
		
		ОбластьМакета = Макет.ПолучитьОбласть("ШапкаТаблицы" + СуффиксОбласти);
		ОбластьСтроки = Макет.ПолучитьОбласть("Строка" + СуффиксОбласти);
		Если ЕстьСкидки Тогда
			СтруктураЗаголовокСкидки = Новый Структура("Скидка, СуммаБезСкидки", 
				ЗаголовокСкидки.Скидка,
				ЗаголовокСкидки.СуммаСкидки);
			ОбластьМакета.Параметры.Заполнить(СтруктураЗаголовокСкидки);
		КонецЕсли; 
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		Сумма       = 0;
		СуммаНДС    = 0;
		НомерСтроки = 0;
		
		// Выводим строки таблицы Услуги
		
		Пока ВыборкаПоУслугам.Следующий() Цикл
		
			НомерСтроки = НомерСтроки + 1;
			
			ОбластьСтроки.Параметры.Заполнить(ВыборкаПоУслугам);
			
			СтруктураДанныхСтроки = Новый Структура;
			СтруктураДанныхСтроки.Вставить("НомерСтроки", НомерСтроки);
			СтруктураДанныхСтроки.Вставить("Товар", НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати(
				ВыборкаПоУслугам.УслугаНаименованиеПолное,
				ВыборкаПоУслугам.ХарактеристикаНаименованиеПолное));
			
			Если ЕстьСкидки Тогда
				СтруктураДанныхСтроки.Вставить("Скидка", ?(ЗаголовокСкидки.ТолькоНаценка,- ВыборкаПоУслугам.СуммаСкидки,ВыборкаПоУслугам.СуммаСкидки));
				СтруктураДанныхСтроки.Вставить("СуммаБезСкидки", ФормированиеПечатныхФорм.ФорматСумм(ВыборкаПоУслугам.Сумма + ВыборкаПоУслугам.СуммаСкидки));
			КонецЕсли;
			ОбластьСтроки.Параметры.Заполнить(СтруктураДанныхСтроки);
			Сумма    = Сумма    + ВыборкаПоУслугам.Сумма;
			СуммаНДС = СуммаНДС + ВыборкаПоУслугам.СуммаНДС;
			
			ТабличныйДокумент.Вывести(ОбластьСтроки);
		
		КонецЦикла;
		
		ОбластьМакета = Макет.ПолучитьОбласть("Итого");
		СтруктураДанныхВсего = Новый Структура("Всего", ФормированиеПечатныхФорм.ФорматСумм(Сумма));
		ОбластьМакета.Параметры.Заполнить(СтруктураДанныхВсего);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("ИтогоНДС");
		СтруктураДанныхИтогоНДС = Новый Структура;
		СтруктураДанныхИтогоНДС.Вставить("ВсегоНДС", СуммаНДС);
		Если ЕстьНДС Тогда
			СтруктураДанныхИтогоНДС.Вставить("НДС", ?(ДанныеПечати.ЦенаВключаетНДС, " " + НСтр("ru = 'В том числе НДС'"), " " + НСтр("ru = 'Сумма НДС'")));
		Иначе
			СтруктураДанныхИтогоНДС.Вставить("НДС", НСтр("ru='Без налога (НДС)'"));
		КонецЕсли;
		ОбластьМакета.Параметры.Заполнить(СтруктураДанныхИтогоНДС);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		СуммаКПрописи = Сумма + ?(ДанныеПечати.ЦенаВключаетНДС, 0, СуммаНДС);
		ОбластьМакета = Макет.ПолучитьОбласть("СуммаПрописью");
		
		ИтоговаяСтрока = НСтр("ru = 'Всего оказано услуг %КоличествоНаименований%, на сумму %СуммаДокумента%'");
		ИтоговаяСтрока = СтрЗаменить(ИтоговаяСтрока, "%КоличествоНаименований%", НомерСтроки);
		ИтоговаяСтрока = СтрЗаменить(ИтоговаяСтрока, "%СуммаДокумента%", ФормированиеПечатныхФорм.ФорматСумм(СуммаКПрописи, ДанныеПечати.Валюта));
		
		СтруктураДанныхСуммаПрописью = Новый Структура;
		СтруктураДанныхСуммаПрописью.Вставить("ИтоговаяСтрока", ИтоговаяСтрока);
		СтруктураДанныхСуммаПрописью.Вставить("СуммаПрописью", РаботаСКурсамиВалют.СформироватьСуммуПрописью(СуммаКПрописи, ДанныеПечати.Валюта));
		ОбластьМакета.Параметры.Заполнить(СтруктураДанныхСуммаПрописью);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Подписи");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ДанныеПечати.Ссылка);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
