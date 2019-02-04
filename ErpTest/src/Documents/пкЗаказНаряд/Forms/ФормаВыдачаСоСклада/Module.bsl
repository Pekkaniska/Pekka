&НаКлиенте
Процедура ВыделитьВсеВыполнить()
	
	Для Каждого СтрокаТЧ Из СписокМатериалы Цикл
		СтрокаТЧ.Пометка = Истина;
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьВыделитьВсеВыполнить()
	
	Для Каждого СтрокаТЧ Из СписокМатериалы Цикл
		СтрокаТЧ.Пометка = Ложь;
	КонецЦикла;	
	
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Склад = Параметры.Склад;
	ЗонаОтгрузки = Параметры.ЗонаОтгрузки;
	ЗаказНаряд = Параметры.ЗаказНаряд;
	ЗаказНаРемонт = Параметры.ЗаказНаРемонт;
	ЗаказКлиента = Параметры.ЗаказКлиента;
	//+++DubI Рарус-СПб 17.01.2017
	СкладскаяЯчейкаПользователя = Параметры.СкладскаяЯчейкаПользователя;
	//---DubI Рарус-СПб
	ЗаполнитьСписокМатериалов();
	//СписокМатериалы.Параметры.УстановитьЗначениеПараметра("ДокументОтгрузки", Параметры.ЗаказНаряд);
	//СписокМатериалы.Параметры.УстановитьЗначениеПараметра("Период", Параметры.Период);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокМатериалов()
	
	Менеджер = Новый МенеджерВременныхТаблиц;
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Менеджер;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ИСТИНА КАК Пометка,
	|	ЗаказКлиентаТовары.Номенклатура,
	|	ЗаказКлиентаТовары.Характеристика,
	|	ЗаказКлиентаТовары.Серия,
	|	ЗаказКлиентаТовары.Количество КАК Количество,
	|	ЗаказКлиентаТовары.Упаковка КАК Упаковка,
	|	ЗаказКлиентаТовары.КодСтроки КАК КодСтрокиЗаказа,
	|	ИСТИНА КАК ПлатныйРемонт,
	|	ЗаказКлиентаТовары.Номенклатура.НаборУпаковок КАК НаборУпаковок
	|ПОМЕСТИТЬ ВТ_Заказы
	|ИЗ
	|	Документ.ЗаказКлиента.Товары КАК ЗаказКлиентаТовары
	|ГДЕ
	|	ЗаказКлиентаТовары.Ссылка = &ЗаказКлиента
	|	И НЕ ЗаказКлиентаТовары.Отменено
	|	И ЗаказКлиентаТовары.ВариантОбеспечения = ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.Требуется)
	|	И ЗаказКлиентаТовары.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ИСТИНА,
	|	ЗаказНаРемонтМатериалыИРаботы.Номенклатура,
	|	ЗаказНаРемонтМатериалыИРаботы.Характеристика,
	|	ЗаказНаРемонтМатериалыИРаботы.Серия,
	|	ЗаказНаРемонтМатериалыИРаботы.Количество,
	|	ЗаказНаРемонтМатериалыИРаботы.Упаковка,
	|	ЗаказНаРемонтМатериалыИРаботы.КодСтроки,
	|	ЛОЖЬ,
	|	ЗаказНаРемонтМатериалыИРаботы.Номенклатура.НаборУпаковок
	|ИЗ
	|	Документ.ЗаказНаРемонт.МатериалыИРаботы КАК ЗаказНаРемонтМатериалыИРаботы
	|ГДЕ
	|	ЗаказНаРемонтМатериалыИРаботы.Ссылка = &ЗаказНаРемонт
	|	И НЕ ЗаказНаРемонтМатериалыИРаботы.Отменено
	|	И ЗаказНаРемонтМатериалыИРаботы.ВариантОбеспечения = ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.Требуется)
	|	И ЗаказНаРемонтМатериалыИРаботы.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(УпаковкиЕдиницыИзмерения.Ссылка) КАК Упаковка,
	|	УпаковкиЕдиницыИзмерения.Владелец КАК НаборУпаковок
	|ПОМЕСТИТЬ ВТ_Упаковки
	|ИЗ
	|	Справочник.УпаковкиЕдиницыИзмерения КАК УпаковкиЕдиницыИзмерения
	|ГДЕ
	|	УпаковкиЕдиницыИзмерения.Владелец В
	|			(ВЫБРАТЬ
	|				ВТ_Заказы.НаборУпаковок
	|			ИЗ
	|				ВТ_Заказы)
	|	И УпаковкиЕдиницыИзмерения.ТипИзмеряемойВеличины = ЗНАЧЕНИЕ(Перечисление.ТипыИзмеряемыхВеличин.Упаковка)
	|
	|СГРУППИРОВАТЬ ПО
	|	УпаковкиЕдиницыИзмерения.Владелец
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Заказы.Пометка,
	|	ВТ_Заказы.Номенклатура,
	|	ВТ_Заказы.Характеристика,
	|	ВТ_Заказы.Серия,
	|	СУММА(ВТ_Заказы.Количество) КАК Количество,
	|	ВТ_Упаковки.Упаковка,
	|	СУММА(ВТ_Заказы.КодСтрокиЗаказа) КАК КодСтрокиЗаказа,
	|	ВТ_Заказы.ПлатныйРемонт,
	|	ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка) КАК Назначение,
	|	ДАТАВРЕМЯ(1, 1, 1) КАК ДатаОтгрузки,
	|	0 КАК Приоритет,
	|	"""" КАК Распоряжение,
	|	ВЫРАЗИТЬ(ВТ_Заказы.Номенклатура КАК Справочник.Номенклатура).СкладскаяГруппа КАК СкладскаяГруппаНоменклатуры
	|ПОМЕСТИТЬ ТаблицаНоменклатуры
	|ИЗ
	|	ВТ_Заказы КАК ВТ_Заказы
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Упаковки КАК ВТ_Упаковки
	|		ПО ВТ_Заказы.НаборУпаковок = ВТ_Упаковки.НаборУпаковок
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_Заказы.Пометка,
	|	ВТ_Заказы.Номенклатура,
	|	ВТ_Заказы.Характеристика,
	|	ВТ_Заказы.Серия,
	|	ВТ_Упаковки.Упаковка,
	|	ВТ_Заказы.ПлатныйРемонт
	//|;
	//|
	//|////////////////////////////////////////////////////////////////////////////////
	//|УНИЧТОЖИТЬ ВТ_Заказы
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТ_Упаковки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаНоменклатуры.Пометка,
	|	ТаблицаНоменклатуры.Номенклатура,
	|	ТаблицаНоменклатуры.Характеристика,
	|	ТаблицаНоменклатуры.Серия,
	|	ТаблицаНоменклатуры.Количество КАК Количество,
	|	ТаблицаНоменклатуры.Упаковка,
	|	ТаблицаНоменклатуры.ПлатныйРемонт,
	|	ТаблицаНоменклатуры.Назначение,
	|	ТаблицаНоменклатуры.ДатаОтгрузки,
	|	ТаблицаНоменклатуры.Приоритет,
	|	ТаблицаНоменклатуры.Распоряжение,
	|	ТаблицаНоменклатуры.СкладскаяГруппаНоменклатуры
	|ИЗ
	|	ТаблицаНоменклатуры КАК ТаблицаНоменклатуры
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Заказы.Пометка,
	|	ВТ_Заказы.Номенклатура,
	|	ВТ_Заказы.Характеристика,
	|	ВТ_Заказы.Серия,
	|	ВТ_Заказы.Количество,
	|	ВТ_Заказы.Упаковка,
	|	ВТ_Заказы.КодСтрокиЗаказа,
	|	ВТ_Заказы.ПлатныйРемонт
	|ИЗ
	|	ВТ_Заказы КАК ВТ_Заказы";
	Запрос.УстановитьПараметр("ЗаказКлиента", ЗаказКлиента);
	Запрос.УстановитьПараметр("ЗаказНаРемонт", ЗаказНаРемонт);
	Результат = Запрос.ВыполнитьПакет();
	//+++DubI Рарус-СПб 17.01.2017
	//СтруктураВозврата = СкладыСервер.ОтобратьТоварИзЯчеек(Менеджер,Склад,Справочники.СкладскиеПомещения.ПустаяСсылка());
	СтруктураВозврата = СкладыСервер.ОтобратьТоварИзЯчеек(Менеджер, Склад, Справочники.СкладскиеПомещения.ПустаяСсылка(), 
		?(ЗначениеЗаполнено(СкладскаяЯчейкаПользователя), СкладскаяЯчейкаПользователя, Неопределено));
	//---DubI Рарус-СПб
	Менеджер.Закрыть();
	Если Не Результат[4].Пустой() Тогда 
		СписокМатериалы.Загрузить(Результат[4].Выгрузить());
		ТаблицаКодовСтрокЗаказа = Результат[5].Выгрузить();
		Для Каждого СтрТабл Из СписокМатериалы Цикл
			СтруктураПоиска = Новый Структура("Номенклатура,Характеристика,Серия,Пометка,Упаковка,ПлатныйРемонт");
			ЗаполнитьЗначенияСвойств(СтруктураПоиска, СтрТабл);
			МассивСтрокРезультата = ТаблицаКодовСтрокЗаказа.НайтиСтроки(СтруктураПоиска);
			Для Каждого СтрокаКодовСтрок Из МассивСтрокРезультата Цикл
				Если ЗначениеЗаполнено(СтрТабл.КодСтрокиЗаказа) Тогда 
					СтрТабл.КодСтрокиЗаказа = СтрТабл.КодСтрокиЗаказа + "," + Строка(СтрокаКодовСтрок.КодСтрокиЗаказа);
				Иначе
					СтрТабл.КодСтрокиЗаказа = Строка(СтрокаКодовСтрок.КодСтрокиЗаказа);
				КонецЕсли;
			КонецЦикла;	
		КонецЦикла;	
	КонецЕсли;
	
	ТаблицаРезультатов = СтруктураВозврата.ТаблицаРезультатов;
	Если ТаблицаРезультатов.Количество() > 0 Тогда 
		Для Каждого СтрТабл из СписокМатериалы Цикл
			СтруктураПоиска = Новый Структура("Номенклатура,Характеристика,Серия",СтрТабл.Номенклатура,СтрТабл.Характеристика,СтрТабл.Серия);
			МассивСтрокРезультата = ТаблицаРезультатов.НайтиСтроки(СтруктураПоиска);
			Если МассивСтрокРезультата.Количество() > 0 Тогда 
				СтрКоличество = СтрТабл.Количество;
				Для Каждого ЭлементМассива Из МассивСтрокРезультата Цикл
					Если ЭлементМассива.Количество = 0 Тогда 
						Продолжить;
					ИначеЕсли  ЭлементМассива.Количество = СтрКоличество Тогда 
						ЗаполнитьЗначенияСвойств(СтрТабл, ЭлементМассива);
						ТаблицаРезультатов.Удалить(ЭлементМассива);
						Прервать;
					ИначеЕсли ЭлементМассива.Количество > СтрКоличество Тогда 
						ЗаполнитьЗначенияСвойств(СтрТабл, ЭлементМассива,,"Количество");
						ЭлементМассива.Количество = ЭлементМассива.Количество - СтрКоличество;
						Прервать;
					ИначеЕсли ЭлементМассива.Количество < СтрКоличество Тогда 
						СтрКоличество = СтрКоличество - ЭлементМассива.Количество;
						НовСтр = СписокМатериалы.Добавить();
						ЗаполнитьЗначенияСвойств(НовСтр, СтрТабл);
						НовСтр.Количество = СтрКоличество;
						ЗаполнитьЗначенияСвойств(СтрТабл, ЭлементМассива);
						ТаблицаРезультатов.Удалить(ЭлементМассива);
						Прервать;	
					КонецЕсли;
				КонецЦикла;	
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;	
	
КонецПроцедуры	

&НаСервере
Процедура ВыдатьНаСервере(СозданныйДокумент)
	
	ДокументРКО = Документы.РасходныйОрдерНаТовары.СоздатьДокумент();
	//Если ЗаказНаряд.ВидРемонта.ОбщийВидРемонта.пкТипРемонта = Перечисления.пкТипыРемонтов.Платный Тогда 
	//	ДокументРКО.СкладскаяОперация = Перечисления.СкладскиеОперации.ОтгрузкаКлиенту;
	//	ДокументРКО.Получатель = ЗаказНаряд.Клиент; 
	//Иначе
		ДокументРКО.СкладскаяОперация = Перечисления.СкладскиеОперации.ОтгрузкаНаВнутренниеНужды;
		ДокументРКО.Получатель = ЗаказНаряд.Подразделение;
	//КонецЕсли;
	ДокументРКО.Склад = ЗаказНаряд.Склад;
	ДокументРКО.ЗонаОтгрузки = ЗаказНаряд.ЗонаОтгрузки;
	ДокументРКО.ДатаОтгрузки = ТекущаяДата();
	ДокументРКО.Дата =ДокументРКО.ДатаОтгрузки;
	ДокументРКО.ТоварыПоРаспоряжениям.Загрузить( СписокМатериалы.Выгрузить(Новый Структура("Пометка",Истина)));
	Для Каждого СтрокаРаспоряжение Из ДокументРКО.ТоварыПоРаспоряжениям Цикл
		СтрокаРаспоряжение.Распоряжение = ЗаказНаряд;
	КонецЦикла;	
	ДокументРКО.Заполнить(Неопределено);
	//ДокументРКО.Записать();
	ДокументРКО.Статус = Перечисления.СтатусыРасходныхОрдеров.КОтбору;
	//ДокументРКО.ДополнительныеСвойства.Вставить("ЭтоНовый",Ложь);
	Попытка
		ДокументРКО.Записать(РежимЗаписиДокумента.Проведение);
		СозданныйДокумент = ДокументРКО.Ссылка;
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
	КонецПопытки;	

КонецПроцедуры

&НаКлиенте
Процедура Выдать(Команда)
	
	Ошибки = Неопределено;
	МассивСтрок = СписокМатериалы.НайтиСтроки(Новый Структура("Пометка",Истина));
	Если МассивСтрок.Количество() = 0 Тогда 
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,	"Объект.СписокМатериалов",
				НСтр("ru='Не выбрана ни одна строка!'"),"",);
		ЕстьОшибки = НЕ Ошибки = Неопределено;
	ИначеЕсли Не ЗначениеЗаполнено(Получатель) Тогда 	
		 		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,	"Объект.Получатель",
				НСтр("ru='Не заполнен получатель!'"),"",);
		ЕстьОшибки = НЕ Ошибки = Неопределено;
	Иначе
		Для Каждого Стр Из МассивСтрок Цикл
			Если Стр.Количество = 0 Тогда 
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,	"Объект.СписокМатериалов",
				НСтр("ru='Не выбрано количество для номенклатуры '") + Стр.Номенклатура,"",);
			КонецЕсли;	
		КонецЦикла;
		ЕстьОшибки = НЕ Ошибки = Неопределено;
	КонецЕсли;	
	Если ЕстьОшибки Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки);		
		Возврат;
	КонецЕсли;
	Отказ = Ложь;
	//ВыдатьПлатныеМатериалыНаСервере(Отказ);
	//ВыдатьБесплатныеМатериалыНаСервере(Отказ);
	ВыдатьМатериалыНаСервере(Отказ,Истина);
	ВыдатьМатериалыНаСервере(Отказ,Ложь);
	ЗаполнитьСписокМатериалов();
	Если НЕ Отказ Тогда
		Оповестить("ОбновитьКоличество",,"ВыдачаВозврат");
		ЭтаФорма.Закрыть();
	КонецЕсли;	
	
КонецПроцедуры

//&НаСервере
//Процедура ВыдатьПлатныеМатериалыНаСервере(Отказ = Ложь)
//	
//	ВариантОбеспеченияОтгрузить = Перечисления.ВариантыОбеспечения.Отгрузить;
//	ОтборПлатных = Новый Структура();
//	ОтборПлатных.Вставить("Пометка", Истина);
//	ОтборПлатных.Вставить("ПлатныйРемонт", Истина);
//	ДатаДокументов = ТекущаяДата();
//	ТаблицаПлатных = СписокМатериалы.Выгрузить(ОтборПлатных);
//	МассивКоличество = Новый Массив;
//	Если ТаблицаПлатных.Количество() > 0 Тогда 
//		ЗаказКлиентаОбъект = ЗаказКлиента.ПолучитьОбъект();
//		СоответствиеУпаковок = Новый Соответствие;
//		Если НЕ ЗначениеЗаполнено(ЗаказКлиента.Контрагент) Тогда 
//			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не заполнен Клиент!!!");
//			Отказ = Истина;
//			Возврат;
//		КонецЕсли;
//		Для Каждого Стр Из ТаблицаПлатных Цикл
//			Если ЗначениеЗаполнено(Стр.Ячейка) Тогда 
//				МассивКодов = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(КодСтроки,",",Истина,Истина);
//				КоличествоОтгрузить = Стр.Количество;
//				
//				Для Каждого КодСтрокиЗаказа Из МассивКодов Цикл
//					
//					Если КоличествоОтгрузить > 0 Тогда 
//						СтрокаЗаказа = ЗаказКлиентаОбъект.Товары.Найти(Стр.КодСтрокиЗаказа,"КодСтроки");
//						Если ЗначениеЗаполнено(СтрокаЗаказа) И СтрокаЗаказа.ВариантОбеспечения <> ВариантОбеспеченияОтгрузить Тогда 
//							Если СтрокаЗаказа.Количество <= КоличествоОтгрузить Тогда 
//								СтрокаЗаказа.ВариантОбеспечения = ВариантОбеспеченияОтгрузить;
//								КоличествоОтгрузить = КоличествоОтгрузить - СтрокаЗаказа.Количество;
//							ИначеЕсли
//								НовСтрокаЗаказа = ЗаказКлиентаОбъект.Товары.Добавить();
//								ЗаполнитьЗначенияСвойств(НовСтрокаЗаказа,СтрокаЗаказа);
//								НовСтрокаЗаказа.Количество = НовСтрокаЗаказа.Количество - КоличествоОтгрузить;
//								НовСтрокаЗаказа.КоличествоУпаковок = НовСтрокаЗаказа.Количество;
//								СтрокаЗаказа.ВариантОбеспечения = ВариантОбеспеченияОтгрузить;
//								СтрокаЗаказа.Количество = КоличествоОтгрузить;
//								СтрокаЗаказа.КоличествоУпаковок = КоличествоОтгрузить;
//								МассивКоличество.Очистить();
//								МассивКоличество.Добавить(КоличествоОтгрузить);
//								МассивКоличество.Добавить(НовСтрокаЗаказа.Количество);
//								РаспределениеСумм = ОбщегоНазначения.РаспределитьСуммуПропорциональноКоэффициентам(СтрокаЗаказа.Сумма, МассивКоличество);
//								РаспределениеСуммНДС = ОбщегоНазначения.РаспределитьСуммуПропорциональноКоэффициентам(СтрокаЗаказа.СуммаНДС, МассивКоличество);
//								РаспределениеСуммСНДС = ОбщегоНазначения.РаспределитьСуммуПропорциональноКоэффициентам(СтрокаЗаказа.СуммаСНДС, МассивКоличество);
//								Если РаспределениеСумм <> Неопределено Тогда 
//									СтрокаЗаказа.Сумма = РаспределениеСумм[0];
//									НовСтрокаЗаказа.Сумма = РаспределениеСумм[1];
//								КонецЕсли;
//								Если РаспределениеСуммНДС <> Неопределено Тогда 
//									СтрокаЗаказа.СуммаНДС = РаспределениеСуммНДС[0];
//									НовСтрокаЗаказа.СуммаНДС = РаспределениеСуммНДС[1];
//								КонецЕсли;
//								Если РаспределениеСуммСНДС <> Неопределено Тогда 
//									СтрокаЗаказа.СуммаСНДС = РаспределениеСуммСНДС[0];
//									НовСтрокаЗаказа.СуммаСНДС = РаспределениеСуммСНДС[1];
//								КонецЕсли;
//						КонецЕсли;
//					КонецЕсли;
//					
//				КонецЦикла;	
//			Иначе
//				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не заполнены ячейки отгрузки!!!");
//				Отказ = Истина;
//				Возврат;
//			КонецЕсли;
//			Если Не ЗначениеЗаполнено(Стр.Упаковка) Тогда 
//				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не заполнены единицы измерения!!!");
//				Отказ = Истина;
//				Возврат;
//			КонецЕсли;
//			НаборУпаковок = Стр.Номенклатура.НаборУпаковок;
//			Если СоответствиеУпаковок.Получить(НаборУпаковок) = Неопределено Тогда 
//				ЗапросУпаковки = Новый Запрос("ВЫБРАТЬ
//				                              |	УпаковкиЕдиницыИзмерения.Ссылка
//				                              |ИЗ
//				                              |	Справочник.УпаковкиЕдиницыИзмерения КАК УпаковкиЕдиницыИзмерения
//				                              |ГДЕ
//				                              |	УпаковкиЕдиницыИзмерения.Владелец = &Владелец
//				                              |	И УпаковкиЕдиницыИзмерения.ТипИзмеряемойВеличины = ЗНАЧЕНИЕ(Перечисление.ТипыИзмеряемыхВеличин.Упаковка)");
//				ЗапросУпаковки.УстановитьПараметр("Владелец",НаборУпаковок);
//				РезультатУпаковки = ЗапросУпаковки.Выполнить();
//				Если Не РезультатУпаковки.Пустой() Тогда 
//					ВыборкаУпаковки = РезультатУпаковки.Выбрать();
//					ВыборкаУпаковки.Следующий();
//					СоответствиеУпаковок.Вставить(НаборУпаковок,ВыборкаУпаковки.Ссылка);
//				КонецЕсли;
//			КонецЕсли;
//		КонецЦикла;
//		
//		НачатьТранзакцию(РежимУправленияБлокировкойДанных.Управляемый);
//		
//		ЗаказКлиентаОбъект.Записать(РежимЗаписиДокумента.Проведение);
//		
//		//создадим расходный ордер и Отбор товара
//		РасхОрдер = Документы.РасходныйОрдерНаТовары.СоздатьДокумент();
//		РасхОрдер.СкладскаяОперация = Перечисления.СкладскиеОперации.ОтгрузкаКлиенту;
//		РасхОрдер.Получатель = ЗаказКлиента.Партнер;
//		РасхОрдер.Склад = ЗаказКлиента.Склад;
//		РасхОрдер.ЗонаОтгрузки = ЗонаОтгрузки;
//		РасхОрдер.ДатаОтгрузки = ДатаДокументов;
//		РасхОрдер.Дата = ДатаДокументов;
//		РасхОрдер.ТоварыПоРаспоряжениям.Загрузить(ТаблицаПлатных);
//		Для Каждого СтрокаРаспоряжение Из РасхОрдер.ТоварыПоРаспоряжениям Цикл
//			СтрокаРаспоряжение.Распоряжение = ЗаказКлиента;
//		КонецЦикла;	
//		РасхОрдер.Заполнить(Неопределено);
//		РасхОрдер.Статус = Перечисления.СтатусыРасходныхОрдеров.КОтбору;
//		//Документы.РасходныйОрдерНаТовары.ЗаполнитьОтгружаемыеТоварыПоТоварамПоРаспоряжениям(РасхОрдер);
//		РасхОрдер.ОтгружаемыеТовары.Загрузить(ТаблицаПлатных);
//		Для Каждого СтрокаТовары Из РасхОрдер.ОтгружаемыеТовары Цикл
//			СтрокаТовары.КоличествоУпаковок = СтрокаТовары.Количество;
//			СтрокаТовары.Действие = Перечисления.ДействияСоСтрокамиОрдеровНаОтгрузку.Отобрать;
//		КонецЦикла;
//		Попытка
//			РасхОрдер.Записать(РежимЗаписиДокумента.Проведение);
//		Исключение
//			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
//			Отказ = Истина;
//		КонецПопытки;
//				
//		Если Не Отказ Тогда
//				
//			//ЗаказНарядОбъект = ЗаказНаряд.ПолучитьОбъект();
//			////Заполним расходные ордера в тч заказ-наряда
//			//Для Каждого СтрПлатных Из ТаблицаПлатных Цикл
//			//	СтруктураПоиска = Новый Структура;
//			//	СтруктураПоиска.Вставить("КодСтрокиЗаказа",СтрПлатных.КодСтрокиЗаказа);
//			//	СтруктураПоиска.Вставить("ПлатныйРемонт",Истина);
//			//	СтрокиТЧ = ЗаказНарядОбъект.Материалы.НайтиСтроки(СтруктураПоиска);
//			//	Для Каждого СтрТч Из СтрокиТЧ Цикл
//			//		СтрТч.РасходныйОрдер = РасхОрдер.Ссылка;
//			//	КонецЦикла;
//			//КонецЦикла;
//			//ЗаказНарядОбъект.Записать();
//			
//			//создаем отбор/размещение товаров
//			//ПараметрыФормы = Новый Структура("Основание", РасхОрдер.Ссылка);
//			//ОткрытьФорму("Документ.ОтборРазмещениеТоваров.ФормаОбъекта", ПараметрыФормы);
//			ДокументОтбор = Документы.ОтборРазмещениеТоваров.СоздатьДокумент();
//			ДокументОтбор.Заполнить(РасхОрдер.Ссылка);
//			ДокументОтбор.Распоряжение = РасхОрдер.Ссылка;
//			ДокументОтбор.ТоварыОтбор.Загрузить(ТаблицаПлатных);
//			Для Каждого СтрокаТовары Из ДокументОтбор.ТоварыОтбор  Цикл
//				СтрокаТовары.КоличествоУпаковок = СтрокаТовары.Количество;
//			КонецЦикла;
//			//Для Каждого Стр Из ДокументОтбор.ТоварыОтбор Цикл
//			//	//подберем упаковку
//			//	Упаковка = СоответствиеУпаковок.Получить(Стр.Номенклатура.НаборУпаковок);
//			//	Если ЗначениеЗаполнено(Упаковка) Тогда 
//			//		Стр.Упаковка = Упаковка;
//			//	КонецЕсли;	
//			//	//подставим ячейку
//			//	ПараметрыПоиска = Новый Структура();
//			//	ПараметрыПоиска.Вставить("Номенклатура", Стр.Номенклатура);
//			//	ПараметрыПоиска.Вставить("Характеристика", Стр.Характеристика);
//			//	НайденныеСтроки = ТаблицаПлатных.НайтиСтроки(ПараметрыПоиска);
//			//	Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
//			//		Если ЗначениеЗаполнено(НайденнаяСтрока.Ячейка) Тогда
//			//			Стр.Ячейка = НайденнаяСтрока.Ячейка;
//			//			Прервать;
//			//		КонецЕсли;
//			//	КонецЦикла;	
//			//КонецЦикла;
//			//ДокументОтбор.ОтобратьТовары("ТоварыОтбор");
//			ДокументОтбор.Записать();
//			Попытка
//				ДокументОтбор.Записать(РежимЗаписиДокумента.Проведение);
//			Исключение
//				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
//				Отказ = Истина;
//			КонецПопытки;
//			Если НЕ Отказ Тогда 
//				ДокументОтбор.Статус = Перечисления.СтатусыОтборовРазмещенийТоваров.ВыполненоБезОшибок;
//				Попытка
//					ДокументОтбор.Записать(РежимЗаписиДокумента.Проведение);
//				Исключение
//					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
//					Отказ = Истина;
//				КонецПопытки;
//			КонецЕсли;	
//		КонецЕсли;	
//		
//		Если Отказ Тогда 
//			ОтменитьТранзакцию();
//		Иначе
//			ЗафиксироватьТранзакцию();
//		КонецЕсли;
//		
//	КонецЕсли;	

//КонецПроцедуры	

&НаСервере
Процедура ВыдатьМатериалыНаСервере(Отказ = Ложь, ПлатныйРемонт)
	
	ВариантОбеспеченияОтгрузить = Перечисления.ВариантыОбеспечения.Отгрузить;
	ОтборПлатных = Новый Структура();
	ОтборПлатных.Вставить("Пометка", Истина);
	ОтборПлатных.Вставить("ПлатныйРемонт", ПлатныйРемонт);
	ДатаДокументов = ТекущаяДата();
	ТаблицаВыдать = СписокМатериалы.Выгрузить(ОтборПлатных);
	МассивКоличество = Новый Массив;
	ЗаказНарядИзменен = Ложь;
	ЗаказНарядОбъект = ЗаказНаряд.ПолучитьОбъект();
	Если ТаблицаВыдать.Количество() > 0 И ТаблицаВыдать.Итог("Количество") > 0 Тогда 
		Если ПлатныйРемонт Тогда 
			ЗаказОбъект = ЗаказКлиента.ПолучитьОбъект();
			Если НЕ ЗначениеЗаполнено(ЗаказКлиента.Контрагент) Тогда 
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не заполнен Клиент!!!");
				Отказ = Истина;
				Возврат;
			КонецЕсли;
			ИмяТЧ = "Товары";
		Иначе
			ЗаказОбъект = ЗаказНаРемонт.ПолучитьОбъект();
			ИмяТЧ = "МатериалыИРаботы";
		КонецЕсли;	
		СоответствиеУпаковок = Новый Соответствие;
		Для Каждого Стр Из ТаблицаВыдать Цикл
			Если Стр.Количество <= 0 Тогда 
				Продолжить;
			КонецЕсли;	
			Если ЗначениеЗаполнено(Стр.Ячейка) Тогда 
				МассивКодов = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Стр.КодСтрокиЗаказа,",",Истина,Истина);
				КоличествоОтгрузить = Стр.Количество;
				
				Для Каждого КодСтрокиЗаказа Из МассивКодов Цикл
					
					Если КоличествоОтгрузить > 0 Тогда 
						СтрокаЗаказа = ЗаказОбъект[ИмяТЧ].Найти(Число(КодСтрокиЗаказа),"КодСтроки");
						Если ЗначениеЗаполнено(СтрокаЗаказа) И СтрокаЗаказа.ВариантОбеспечения <> ВариантОбеспеченияОтгрузить Тогда 
							Если СтрокаЗаказа.Количество <= КоличествоОтгрузить Тогда 
								СтрокаЗаказа.ВариантОбеспечения = ВариантОбеспеченияОтгрузить;
								КоличествоОтгрузить = КоличествоОтгрузить - СтрокаЗаказа.Количество;
							Иначе
								НовСтрокаЗаказа = ЗаказОбъект[ИмяТЧ].Добавить();
								ЗаполнитьЗначенияСвойств(НовСтрокаЗаказа,СтрокаЗаказа);
								НовСтрокаЗаказа.Количество = НовСтрокаЗаказа.Количество - КоличествоОтгрузить;
								НовСтрокаЗаказа.КоличествоУпаковок = НовСтрокаЗаказа.Количество;
								СтрокаЗаказа.ВариантОбеспечения = ВариантОбеспеченияОтгрузить;
								СтрокаЗаказа.Количество = КоличествоОтгрузить;
								СтрокаЗаказа.КоличествоУпаковок = КоличествоОтгрузить;
								КоличествоОтгрузить = 0;
								
								Если ПлатныйРемонт Тогда 
									НовСтрокаЗаказа.КодСтроки = ЗаказОбъект.МаксимальныйКодСтроки + 1;
									ЗаказОбъект.МаксимальныйКодСтроки = НовСтрокаЗаказа.КодСтроки;
									МассивКоличество.Очистить();
									МассивКоличество.Добавить(КоличествоОтгрузить);
									МассивКоличество.Добавить(НовСтрокаЗаказа.Количество);
									РаспределениеСумм = ОбщегоНазначения.РаспределитьСуммуПропорциональноКоэффициентам(СтрокаЗаказа.Сумма, МассивКоличество);
									РаспределениеСуммНДС = ОбщегоНазначения.РаспределитьСуммуПропорциональноКоэффициентам(СтрокаЗаказа.СуммаНДС, МассивКоличество);
									РаспределениеСуммСНДС = ОбщегоНазначения.РаспределитьСуммуПропорциональноКоэффициентам(СтрокаЗаказа.СуммаСНДС, МассивКоличество);
									Если РаспределениеСумм <> Неопределено Тогда 
										СтрокаЗаказа.Сумма = РаспределениеСумм[0];
										НовСтрокаЗаказа.Сумма = РаспределениеСумм[1];
									КонецЕсли;
									Если РаспределениеСуммНДС <> Неопределено Тогда 
										СтрокаЗаказа.СуммаНДС = РаспределениеСуммНДС[0];
										НовСтрокаЗаказа.СуммаНДС = РаспределениеСуммНДС[1];
									КонецЕсли;
									Если РаспределениеСуммСНДС <> Неопределено Тогда 
										СтрокаЗаказа.СуммаСНДС = РаспределениеСуммСНДС[0];
										НовСтрокаЗаказа.СуммаСНДС = РаспределениеСуммСНДС[1];
									КонецЕсли;
								Иначе
									НовСтрокаЗаказа.КодСтроки = ЗаказОбъект.МаксимальныйКодСтрокиНоменклатуры + 1;
									ЗаказОбъект.МаксимальныйКодСтрокиНоменклатуры = НовСтрокаЗаказа.КодСтроки;
								КонецЕсли;
								
								СтруктураПоиска = Новый Структура;
								СтруктураПоиска.Вставить("КодСтрокиЗаказа",Стр.КодСтрокиЗаказа);
								СтруктураПоиска.Вставить("ПлатныйРемонт",ПлатныйРемонт);
								СтрокиТЧ = ЗаказНарядОбъект.Материалы.НайтиСтроки(СтруктураПоиска);
								Для Каждого СтрТч Из СтрокиТЧ Цикл
									СтрТч.КодСтрокиЗаказа = Стр.КодСтрокиЗаказа + "," + НовСтрокаЗаказа.КодСтроки;
								КонецЦикла;
								ЗаказНарядИзменен = Истина;
							КонецЕсли;	
						КонецЕсли;
					КонецЕсли;
					
				КонецЦикла;
				Если КоличествоОтгрузить > 0 Тогда 
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Превышено количество к отгрузке по номенклатуре " + Стр.Номенклатура);
					Отказ = Истина;	
				КонецЕсли;
			Иначе
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не заполнены ячейки отгрузки!!!");
				Отказ = Истина;
				Возврат;
			КонецЕсли;
			Если Не ЗначениеЗаполнено(Стр.Упаковка) Тогда 
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не заполнены единицы измерения!!!");
				Отказ = Истина;
				Возврат;
			КонецЕсли;
			НаборУпаковок = Стр.Номенклатура.НаборУпаковок;
			Если СоответствиеУпаковок.Получить(НаборУпаковок) = Неопределено Тогда 
				ЗапросУпаковки = Новый Запрос("ВЫБРАТЬ
				                              |	УпаковкиЕдиницыИзмерения.Ссылка
				                              |ИЗ
				                              |	Справочник.УпаковкиЕдиницыИзмерения КАК УпаковкиЕдиницыИзмерения
				                              |ГДЕ
				                              |	УпаковкиЕдиницыИзмерения.Владелец = &Владелец
				                              |	И УпаковкиЕдиницыИзмерения.ТипИзмеряемойВеличины = ЗНАЧЕНИЕ(Перечисление.ТипыИзмеряемыхВеличин.Упаковка)");
				ЗапросУпаковки.УстановитьПараметр("Владелец",НаборУпаковок);
				РезультатУпаковки = ЗапросУпаковки.Выполнить();
				Если Не РезультатУпаковки.Пустой() Тогда 
					ВыборкаУпаковки = РезультатУпаковки.Выбрать();
					ВыборкаУпаковки.Следующий();
					СоответствиеУпаковок.Вставить(НаборУпаковок,ВыборкаУпаковки.Ссылка);
				КонецЕсли;
			КонецЕсли;	
		КонецЦикла;
		
		НачатьТранзакцию(РежимУправленияБлокировкойДанных.Управляемый);
		
		ЗаказОбъект.Записать(РежимЗаписиДокумента.Проведение);
		
		Если ЗаказНарядИзменен Тогда 
			ЗаказНарядОбъект.Записать();
		КонецЕсли;
		
		//создадим расходный ордер и Отбор товара
		РасхОрдер = Документы.РасходныйОрдерНаТовары.СоздатьДокумент();
		РасхОрдер.СкладскаяОперация = ?(ПлатныйРемонт,Перечисления.СкладскиеОперации.ОтгрузкаКлиенту,Перечисления.СкладскиеОперации.ОтгрузкаНаВнутренниеНужды);
		РасхОрдер.Получатель = ?(ПлатныйРемонт,ЗаказКлиента.Партнер,ЗаказНаРемонт.Подразделение);
		РасхОрдер.Склад = ЗаказНаряд.Склад;
		РасхОрдер.ЗонаОтгрузки = ЗонаОтгрузки;
		РасхОрдер.ДатаОтгрузки = ДатаДокументов;
		РасхОрдер.Дата = ДатаДокументов;
		РасхОрдер.пкПолучатель = Получатель;
		РасхОрдер.ТоварыПоРаспоряжениям.Загрузить(ТаблицаВыдать);
		Для Каждого СтрокаРаспоряжение Из РасхОрдер.ТоварыПоРаспоряжениям Цикл
			СтрокаРаспоряжение.Распоряжение = ЗаказОбъект.Ссылка;
		КонецЦикла;	
		РасхОрдер.Заполнить(Неопределено);
		РасхОрдер.Статус = Перечисления.СтатусыРасходныхОрдеров.КОтбору;
		//Документы.РасходныйОрдерНаТовары.ЗаполнитьОтгружаемыеТоварыПоТоварамПоРаспоряжениям(РасхОрдер);
		РасхОрдер.ОтгружаемыеТовары.Загрузить(ТаблицаВыдать);
		Для Каждого СтрокаТовары Из РасхОрдер.ОтгружаемыеТовары Цикл
			СтрокаТовары.КоличествоУпаковок = СтрокаТовары.Количество;
			СтрокаТовары.Действие = Перечисления.ДействияСоСтрокамиОрдеровНаОтгрузку.Отобрать;
		КонецЦикла;	
		Попытка
			РасхОрдер.Записать(РежимЗаписиДокумента.Проведение);
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
			Отказ = Истина;
		КонецПопытки;
				
		Если Не Отказ Тогда
				
			//создаем отбор/размещение товаров
			ДокументОтбор = Документы.ОтборРазмещениеТоваров.СоздатьДокумент();
			ДокументОтбор.Заполнить(РасхОрдер.Ссылка);
			ДокументОтбор.Распоряжение = РасхОрдер.Ссылка;
			ДокументОтбор.ТоварыОтбор.Загрузить(ТаблицаВыдать);
			Для Каждого СтрокаТовары Из ДокументОтбор.ТоварыОтбор  Цикл
				СтрокаТовары.КоличествоУпаковок = СтрокаТовары.Количество;
			КонецЦикла;
			ДокументОтбор.Записать();
			Попытка
				ДокументОтбор.Записать(РежимЗаписиДокумента.Проведение);
			Исключение
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
				Отказ = Истина;
			КонецПопытки;
			Если Не Отказ Тогда 
				ДокументОтбор.Статус = Перечисления.СтатусыОтборовРазмещенийТоваров.ВыполненоБезОшибок;
				Попытка
					ДокументОтбор.Записать(РежимЗаписиДокумента.Проведение);
				Исключение
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
					Отказ = Истина;
				КонецПопытки;
			КонецЕсли;	
		КонецЕсли;
		
		Если Отказ Тогда 
			ОтменитьТранзакцию();
		Иначе 
			ЗафиксироватьТранзакцию();
		КонецЕсли;	
			
	КонецЕсли;	

КонецПроцедуры	


&НаСервереБезКонтекста
Функция ПолучитьСписокЯчеек(Номенклатура,Характеристика,Склад,СкладскаяЯчейкаПользователя)
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ТоварыВЯчейкахОстатки.Ячейка
	                      |ИЗ
	                      |	РегистрНакопления.ТоварыВЯчейках.Остатки(
	                      |			,
	                      |			Номенклатура = &Номенклатура
	                      |				И Характеристика = &Характеристика) КАК ТоварыВЯчейкахОстатки
	                      |ГДЕ
	                      |	ТоварыВЯчейкахОстатки.Ячейка.Владелец = &Склад
						  //+++DubI Рарус-СПб 17.01.2017
						  | И Выбор когда &СкладскаяЯчейкаПользователя = Значение(Справочник.СкладскиеЯчейки.ПустаяСсылка) Тогда Истина Иначе ТоварыВЯчейкахОстатки.Ячейка = &СкладскаяЯчейкаПользователя Конец
						  //---DubI Рарус-СПб
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	ТоварыВЯчейкахОстатки.Ячейка");
	Запрос.УстановитьПараметр("Номенклатура",Номенклатура);
	Запрос.УстановитьПараметр("Характеристика",Характеристика);
	Запрос.УстановитьПараметр("Склад",Склад);
	//+++DubI Рарус-СПб 22.01.2017
	Запрос.УстановитьПараметр("СкладскаяЯчейкаПользователя", СкладскаяЯчейкаПользователя);
	//---DubI Рарус-СПб
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда 
		Возврат Неопределено;
	Иначе
		СписокЯчеек = Новый СписокЗначений;
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			СписокЯчеек.Добавить(Выборка.Ячейка);
		КонецЦикла;
		Возврат СписокЯчеек;
	КонецЕсли;	
	
КонецФункции


&НаКлиенте
Процедура СписокМатериалыЯчейкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекСтрока = Элементы.СписокМатериалы.ТекущиеДанные;
	Номенклатура = ТекСтрока.Номенклатура;
	ХарактеристикаНоменклатуры = ТекСтрока.Характеристика;
	//+++DubI Рарус-СПб 22.01.2017
	//СписокЯчеек = ПолучитьСписокЯчеек(Номенклатура, ХарактеристикаНоменклатуры,Склад);
	СписокЯчеек = ПолучитьСписокЯчеек(Номенклатура, ХарактеристикаНоменклатуры,Склад,СкладскаяЯчейкаПользователя);
	//---DubI Рарус-СПб
	
	Отбор = Новый Структура("Ссылка", СписокЯчеек);
    ПараметрыФормы = Новый Структура("Отбор", Отбор);
	ОткрытьФорму("Справочник.СкладскиеЯчейки.ФормаВыбора",ПараметрыФормы,Элемент);
	
КонецПроцедуры

