
#Область ПрограммныйИнтерфейс

//++ НЕ УТ
#Область ПравилаПолученияФактическихДанных
	
// Возвращает ссылку на схему по типу, разделу и указанному источнику данных
// Предназначен для обезличенного, не зависящего от ссылки кэшированного получения схем из справочников-правил получения
// данных Если схема модифицируется в последствии в коде, то именно она будет возвращаться из кэша.
// 
// Параметры:
//  ИмяСправочникаИсточника - Строка - например, "ПравилаПолученияФактаПоПоказателямБюджетов"
//  РазделИсточникаДанных - ПеречислениеСсылка.РазделыИсточниковДанныхБюджетирования - оперативный, международный или
//                                                                                     регламентированный учет
//  ИсточникДанных - СправочникСсылка.НастройкиХозяйственныхОпераций, ПланВидовХарактеристикСсылка.СтатьиАктивовПассивов
//                   - объект, содержащий имя макета СКД в правиле.
// 
// Возвращаемое значение:
// 	 СхемаКомпоновкиДанных - СхемаКомпоновкиДанных - схема получения фактических данных, соответствующая источнику. 
//						   - Неопределено - если макет не найден.
//
Функция СхемаКомпоновкиДанныхПравила(ИмяСправочникаИсточника, РазделИсточникаДанных, ИсточникДанных) Экспорт
	
	СхемаКомпоновкиДанныхПравила = Неопределено;
	ИмяСхемы = Неопределено;
	МакетИсточникаДанных = Неопределено;
	
	МетаданныеИсточника = Метаданные.НайтиПоПолномуИмени("Справочник." + ИмяСправочникаИсточника);
	РазделыИсточников = Перечисления.РазделыИсточниковДанныхБюджетирования;
	
	Если РазделИсточникаДанных = РазделыИсточников.ОперативныйУчет Тогда
		
		Если ЗначениеЗаполнено(ИсточникДанных) Тогда
			ИмяСхемы = ИмяМакетаПоЗначениюИсточника(ИсточникДанных);
		КонецЕсли;
		
	ИначеЕсли РазделИсточникаДанных = РазделыИсточников.РегламентированныйУчет Тогда
		
		ИмяСхемы = "РегламентированныйУчет";
		
//++ НЕ УТКА
	ИначеЕсли РазделИсточникаДанных = РазделыИсточников.МеждународныйУчет Тогда
		
		ИмяСхемы = "МеждународныйУчет";
		
//-- НЕ УТКА
	Иначе
		ВызватьИсключение НСтр("ru = 'Недопустимый раздел источника получения данных.'");
	КонецЕсли;
	
	СхемаКомпоновкиДанныхПравила = ПолучитьМакетСправочника(ИмяСправочникаИсточника, ИмяСхемы);
	
	Возврат СхемаКомпоновкиДанныхПравила;
	
КонецФункции

// Возвращает ссылку на схему по типу, разделу и указанному хешу компоновки данных
// Предназначен для обезличенного, не зависящего от ссылки кэшированного получения схем из справочников-правил получения
// данных Если схема модифицируется в последствии в коде, то именно она будет возвращаться из кэша.
// 
// Параметры:
//  ИмяСправочникаИсточника - Строка - например, "ПравилаПолученияФактаПоПоказателямБюджетов"
//  РазделИсточникаДанных - ПеречислениеСсылка.РазделыИсточниковДанныхБюджетирования - произвольные данные
//  ХешСхемыКомпоновкиДанных - Строка - хеш сумма произвольной схемы компоновки данных.
// 
// Возвращаемое значение:
// 	 СхемаКомпоновкиДанных - СхемаКомпоновкиДанных - схема получения фактических данных, соответствующая источнику. 
//						   - Неопределено - если макет не найден.
//
Функция ПроизвольнаяСхемаКомпоновкиДанныхПравила(ИмяСправочникаИсточника, РазделИсточникаДанных, ХешСхемыКомпоновкиДанных) Экспорт
	
	СхемаКомпоновкиДанныхПравила = Неопределено;
	
	Если Не РазделИсточникаДанных = Перечисления.РазделыИсточниковДанныхБюджетирования.ПроизвольныеДанные Тогда
		ВызватьИсключение НСтр("ru = 'Недопустимый раздел источника получения данных.'");
	КонецЕсли;
	
	НайденнаяСхемаИсточникаДанных = ПолучитьХранимыйМакетСправочника(ИмяСправочникаИсточника, ХешСхемыКомпоновкиДанных);
	
	Если Не НайденнаяСхемаИсточникаДанных = Неопределено Тогда
		СхемаКомпоновкиДанныхПравила = НайденнаяСхемаИсточникаДанных;
	КонецЕсли;
	
	Возврат СхемаКомпоновкиДанныхПравила;
	
КонецФункции

// Возвращает соответствие поддерживаемых типов и их имен
// 
// Возвращаемое значение:
// 	 Соответствие -
//		* Ключ - Тип- тип поддерживаемого объекта метаданных
//		* Значение - Строка - имя справочника, как оно задано в конфигураторе.
//
Функция ПоддерживаемыеСправочникиИсточникиДанных() Экспорт
	Поддерживаемые = Новый Соответствие;
	Поддерживаемые.Вставить(Тип("СправочникСсылка.ПравилаПолученияФактаПоПоказателямБюджетов"), "ПравилаПолученияФактаПоПоказателямБюджетов");
	Поддерживаемые.Вставить(Тип("СправочникСсылка.ПравилаПолученияФактаПоСтатьямБюджетов"),     "ПравилаПолученияФактаПоСтатьямБюджетов");
	
	Возврат Поддерживаемые;
КонецФункции

// Возвращает имя схемы-умолчания на случай, когда иные схемы не найдены
// 
// Возвращаемое значение:
// 	 Соответствие -
//		* Ключ - Строка - имя справочника, как оно задано в конфигураторе
//		* Значение - Строка - имя макета схемы компоновки данных.
//
Функция ИменаСхемУмолчанийДляИсточниковДанных() Экспорт
	Умолчания = Новый Соответствие;
	Умолчания.Вставить("ПравилаПолученияФактаПоПоказателямБюджетов", "ПрочиеАктивыПассивы");
	Умолчания.Вставить("ПравилаПолученияФактаПоСтатьямБюджетов", "");
	
	Возврат Умолчания;
КонецФункции

// Возвращает макет из указанного справочника
//
// Параметры:
//  ИмяСправочникаИсточника - Строка - например, "ПравилаПолученияФактаПоПоказателямБюджетов"
//  ИмяМакета               - Строка - например, "ВыданныеАвансы".
//
// Возвращаемое значение:
//  ТабличныйДокумент, ТекстовыйДокумент, другой объект, который может быть макетом. 
//
Функция ПолучитьМакетСправочника(ИмяСправочникаИсточника, Знач ИмяМакета = Неопределено) Экспорт

	Перем ИскомыйМакет;
	
	Если Не ИмяМакета = Неопределено Тогда
		Если Метаданные.Справочники[ИмяСправочникаИсточника].Макеты.Найти(ИмяМакета) = Неопределено Тогда
			ИмяМакета = ИменаСхемУмолчанийДляИсточниковДанных()[ИмяСправочникаИсточника];
		КонецЕсли;
		ИскомыйМакет = Справочники[ИмяСправочникаИсточника].ПолучитьМакет(ИмяМакета);
	КонецЕсли;
	
	Возврат ИскомыйМакет;

КонецФункции

// Возвращает массив поддерживаемых типов источников имени макета
// 
// Возвращаемое значение:
// 	 Массив - Тип - тип поддерживаемого объекта метаданных.
//
Функция ПоддерживаемыеТипыИсточниковИмениМакета() Экспорт
	Поддерживаемые = Новый Массив;
	Поддерживаемые.Добавить(Тип("СправочникСсылка.НастройкиХозяйственныхОпераций"));
	Поддерживаемые.Добавить(Тип("ПланВидовХарактеристикСсылка.СтатьиАктивовПассивов"));
	Поддерживаемые.Добавить(Тип("ПеречислениеСсылка.ХозяйственныеОперации"));
	
	Возврат Поддерживаемые;
КонецФункции

// Возвращает хранимые настройки из указанного справочника
//
// Параметры:
//  ИмяСправочникаИсточника  - Строка - например, "ПравилаПолученияФактаПоПоказателямБюджетов"
//  ХешНастроек - Строка - хеш-сумма настроенных отборов компоновки данных.
//
// Возвращаемое значение:
//  КомпоновщикНастроекКомпоновкиДанных 
//
Функция ПолучитьХранимыеНастройкиСправочника(ИмяСправочникаИсточника, ХешНастроек) Экспорт
	
	Возврат ИсточникиДанныхСервер.ПолучитьХранимыеНастройкиСправочника(ИмяСправочникаИсточника, ХешНастроек);
	
КонецФункции

// Возвращает хранимый макет из указанного справочника
//
// Параметры:
//  ИмяСправочникаИсточника  - Строка - например, "ПравилаПолученияФактаПоПоказателямБюджетов"
//  ХешСхемыКомпоновкиДанных - Строка - хеш-сумма произвольной схемы компоновки данных.
//
// Возвращаемое значение:
//  ТабличныйДокумент, ТекстовыйДокумент, другой объект, который может быть макетом. 
//
Функция ПолучитьХранимыйМакетСправочника(ИмяСправочникаИсточника, ХешСхемыКомпоновкиДанных) Экспорт
	
	Возврат ИсточникиДанныхСервер.ПолучитьХранимыйМакетСправочника(ИмяСправочникаИсточника, ХешСхемыКомпоновкиДанных);
	
КонецФункции

// Возвращает описание типов правил получения фактических данных
//
// Возвращаемое значение:
//  ОписаниеТипов
//
Функция ОписаниеТипаПравил() Экспорт
	ТипыПравил = Новый Массив;
	ТипыПравил.Добавить(Тип("СправочникСсылка.ПравилаПолученияФактаПоПоказателямБюджетов"));
	ТипыПравил.Добавить(Тип("СправочникСсылка.ПравилаПолученияФактаПоСтатьямБюджетов"));
	
	Возврат Новый ОписаниеТипов(ТипыПравил);
КонецФункции 

// Возвращает описание типов типа правила получения фактических данных
//
// Возвращаемое значение:
//  ОписаниеТипов
//
Функция ОписаниеТипаПолученияДанныхБюджетирования() Экспорт
	Возврат Новый ОписаниеТипов("ПеречислениеСсылка.ТипПравилаПолученияФактическихДанныхБюджетирования");
КонецФункции 

// Возвращает выражение суммового показателя для правила получения фактических данных.
// 
// Параметры:
//	ИмяСправочникаИсточника      - Строка - например, "ПравилаПолученияФактаПоПоказателямБюджетов". См. подробнее ИсточникиДанныхПовтИсп.ПоддерживаемыеСправочникиИсточникиДанных()
//	ИдентификаторИсточникаДанных - Строка - имя поставляемого макета или хеш-сумма произвольной схемы компоновки данных. В СКД должен быть набор данных - ОбъединенныйФакт
//	ИсточникВалюты               - Строка - может принимать значения "Валюта", "ВалютаУпр", "ВалютаРегл", "ВалютаМеждународ", "КорВалюта"
//	РазделИсточникаДанных        - ПеречислениеСсылка.РазделыИсточниковДанныхБюджетирования - оперативный, международный, регламентированный учет или произвольные данные
//	ТипИтога                     - ПеречислениеСсылка.ТипыИтогов - тип итоговых данных по счету, если он источник данных
//	ИсточникСуммыОперации        - ПеречислениеСсылка.ПоказателиАналитическихРегистров, Неопределено - источник получения суммы из аналитического регистра
//  ИсточникВалютный             - Булево - признак того, что суммы могут хранятся в разных валютах.
//
// Возвращаемое значение:
//	Строка - имя поля в схеме-источнике данных.
//
Функция ВыражениеПоказателяСуммы(ИмяСправочникаИсточника, ИдентификаторИсточникаДанных, ИсточникВалюты, РазделИсточникаДанных, ТипИтога, ИсточникСуммыОперации = Неопределено, ИсточникВалютный = Ложь) Экспорт
	
	ВыражениеПоказателяСуммы = Неопределено;
	
	ИсточникиСуммы = ВыраженияПоказателейСуммы(ИмяСправочникаИсточника, 
		ИдентификаторИсточникаДанных, 
		РазделИсточникаДанных, 
		ТипИтога, 
		ИсточникСуммыОперации,
		ИсточникВалютный);
	
	ИсточникиСуммы.Свойство(ИсточникВалюты, ВыражениеПоказателяСуммы);
	
	Возврат ВыражениеПоказателяСуммы;
	
КонецФункции

// Возвращает все возможные выражения суммового показателя для правила получения фактических данных.
// 
// Параметры:
//  ИмяСправочникаИсточника      - Строка - например, "ПравилаПолученияФактаПоПоказателямБюджетов". См. подробнее ИсточникиДанныхПовтИсп.ПоддерживаемыеСправочникиИсточникиДанных()
//  ИдентификаторИсточникаДанных - Строка - имя поставляемого макета или хеш-сумма произвольной схемы компоновки данных.
//                                          В СКД должен быть набор данных - ОбъединенныйФакт
//  РазделИсточникаДанных        - ПеречислениеСсылка.РазделыИсточниковДанныхБюджетирования - оперативный,
//      международный, регламентированный учет или произвольные данные
//  ТипИтога                     - ПеречислениеСсылка.ТипыИтогов, Неопределено - тип итоговых данных по счету, если он
//                                                                               источник данных
//  ИсточникСуммыОперации        - ПеречислениеСсылка.ПоказателиАналитическихРегистров, Неопределено - источник
//      получения суммы из аналитического регистра
//  ИсточникВалютный             - Булево - признак того, что суммы могут хранятся в разных валютах.
//
// Возвращаемое значение:
//	ИсточникиСуммы - Структура - сопоставленные показатели факта и поля источника данных
//		* Ключ     - Строка - имя показателя фактических данных
//		* Значение - Строка - имя поля в схеме-источнике данных.
// 
Функция ВыраженияПоказателейСуммы(ИмяСправочникаИсточника, ИдентификаторИсточникаДанных, РазделИсточникаДанных, ТипИтога = Неопределено, ИсточникСуммыОперации = Неопределено, ИсточникВалютный = Ложь) Экспорт
	
	ИсточникиСуммы = Новый Структура;
	РазделыИсточниковДанных = Перечисления.РазделыИсточниковДанныхБюджетирования;
	
	Если РазделИсточникаДанных = РазделыИсточниковДанных.ОперативныйУчет Тогда
		
		ПоставляемаяСхема = ПолучитьМакетСправочника(ИмяСправочникаИсточника, ИдентификаторИсточникаДанных);
		НаборДанных = НаборДанныхСКДИсточника(ПоставляемаяСхема, ИмяСправочникаИсточника, ИдентификаторИсточникаДанных);
		
		Если ИмяСправочникаИсточника = "ПравилаПолученияФактаПоПоказателямБюджетов" Тогда
			
			БюджетированиеСервер.ЗаполнитьИсточникиСуммыПоСхеме(ИсточникиСуммы, НаборДанных, Истина);
			
		ИначеЕсли ИмяСправочникаИсточника = "ПравилаПолученияФактаПоСтатьямБюджетов" Тогда
			
			ПоказателиРегистра = МеждународныйУчетСерверПовтИсп.Показатели(ИдентификаторИсточникаДанных);
			РесурсыИсточникаСуммы = ПоказателиРегистра.Получить(ИсточникСуммыОперации).Ресурсы;
			
			Для каждого Ресурс Из РесурсыИсточникаСуммы Цикл
				ПолеСуммы = Ресурс["Имя"];
				Если НаборДанных.Поля.Найти(ПолеСуммы) = Неопределено Тогда
					// Ресурс не выбирается в источнике
					Продолжить;
				КонецЕсли;
				Если Ресурс["ИсточникВалюты"] = "ВалютаУпр" Тогда
					ИсточникиСуммы.Вставить("ВалютаУпр", ПолеСуммы);
				ИначеЕсли Ресурс["ИсточникВалюты"] = "ВалютаРегл" Тогда
					ИсточникиСуммы.Вставить("ВалютаРегл", ПолеСуммы);
				Иначе
					ИсточникиСуммы.Вставить("Валюта", ПолеСуммы);
				КонецЕсли;
			КонецЦикла;
			
		КонецЕсли;
		
	ИначеЕсли РазделИсточникаДанных = РазделыИсточниковДанных.РегламентированныйУчет Тогда
		
		ИсточникиСуммы.Вставить("ВалютаРегл", БюджетированиеСервер.ПолеРесурсаБухгалтерии("Сумма", ТипИтога));
		Если ИсточникВалютный Тогда
			ИсточникиСуммы.Вставить("Валюта", БюджетированиеСервер.ПолеРесурсаБухгалтерии("СуммаВВалюте", ТипИтога));
		КонецЕсли;
		
	ИначеЕсли РазделИсточникаДанных = РазделыИсточниковДанных.МеждународныйУчет Тогда
		
		ИсточникиСуммы.Вставить("ВалютаМеждународ", БюджетированиеСервер.ПолеРесурсаБухгалтерии("Сумма", ТипИтога));
		Если ИсточникВалютный Тогда
			ИсточникиСуммы.Вставить("Валюта", БюджетированиеСервер.ПолеРесурсаБухгалтерии("СуммаВВалюте", ТипИтога));
		КонецЕсли;
		
	ИначеЕсли РазделИсточникаДанных = РазделыИсточниковДанных.ПроизвольныеДанные Тогда
		
		ПроизвольнаяСхема = ПолучитьХранимыйМакетСправочника(ИмяСправочникаИсточника, ИдентификаторИсточникаДанных);
		
		НаборДанных = НаборДанныхСКДИсточника(ПроизвольнаяСхема, ИмяСправочникаИсточника, ИдентификаторИсточникаДанных);
	
		БюджетированиеСервер.ЗаполнитьИсточникиСуммыПоСхеме(ИсточникиСуммы, НаборДанных, Истина);
		
	КонецЕсли;
	
	Возврат ИсточникиСуммы;
	
КонецФункции

// Возвращает выражение количественного показателя для правила получения фактических данных.
// 
// Параметры:
//  ИмяСправочникаИсточника      - Строка - например, "ПравилаПолученияФактаПоПоказателямБюджетов". См. подробнее ИсточникиДанныхПовтИсп.ПоддерживаемыеСправочникиИсточникиДанных()
//  ИдентификаторИсточникаДанных - Строка - имя поставляемого макета или хеш-сумма произвольной схемы компоновки данных
//  РазделИсточникаДанных        - ПеречислениеСсылка.РазделыИсточниковДанныхБюджетирования - оперативный,
//      международный, регламентированный учет или произвольные данные
//  ТипИтога                     - ПеречислениеСсылка.ТипыИтогов - тип итоговых данных по счету, если он источник данных.
//
// Возвращаемое значение:
//	ИсточникиСуммы - Структура - сопоставленные показатели факта и поля источника данных
//		* Ключ     - Строка - имя показателя фактических данных
//		* Значение - Строка - имя поля в схеме-источнике данных.
// 
Функция ВыражениеПоказателяКоличества(ИмяСправочникаИсточника, ИдентификаторИсточникаДанных, РазделИсточникаДанных, ТипИтога) Экспорт
	
	ВыражениеПоказателяКоличества = Неопределено;
	
	ИсточникиКоличества = Новый Структура;
	РазделыИсточниковДанных = Перечисления.РазделыИсточниковДанныхБюджетирования;
	
	Если РазделИсточникаДанных = РазделыИсточниковДанных.ОперативныйУчет Тогда
		
		ПоставляемаяСхема = ПолучитьМакетСправочника(ИмяСправочникаИсточника, ИдентификаторИсточникаДанных);
		БюджетированиеСервер.ЗаполнитьИсточникиКоличестваПоСхеме(ИсточникиКоличества, ПоставляемаяСхема.НаборыДанных[0]);
			
	ИначеЕсли РазделИсточникаДанных = РазделыИсточниковДанных.РегламентированныйУчет Тогда
		
		ИсточникиКоличества.Вставить("Количество", БюджетированиеСервер.ПолеРесурсаБухгалтерии("Количество", ТипИтога));
		
	ИначеЕсли РазделИсточникаДанных = РазделыИсточниковДанных.МеждународныйУчет Тогда
		
		ИсточникиКоличества.Вставить("Количество", 0);
		
	ИначеЕсли РазделИсточникаДанных = РазделыИсточниковДанных.ПроизвольныеДанные Тогда
		
		ПроизвольнаяСхема = ПолучитьХранимыйМакетСправочника(ИмяСправочникаИсточника, ИдентификаторИсточникаДанных);
		БюджетированиеСервер.ЗаполнитьИсточникиКоличестваПоСхеме(ИсточникиКоличества, ПроизвольнаяСхема.НаборыДанных[0]);
		
	КонецЕсли;
	
	ИсточникиКоличества.Свойство("Количество", ВыражениеПоказателяКоличества);
	
	Возврат ВыражениеПоказателяКоличества;
	
КонецФункции

// Возвращает служебные поля-измерения, недоступные для выбора пользователем
//
// Возвращаемое значение:
//	Массив - массив служебных полей-измерений.
//
Функция СлужебныеПоляМакетовРасчета() Экспорт
	
	СлужебныеПоля = Новый Массив;
	
	СлужебныеПоля.Добавить("СистемныеПоля");
	СлужебныеПоля.Добавить("ПараметрыДанных");
	
	// Поля-периоды не являются полями отборов
	СлужебныеПоля.Добавить("ПериодСекунда");
	СлужебныеПоля.Добавить("ПериодДень");
	СлужебныеПоля.Добавить("ПериодНеделя");
	СлужебныеПоля.Добавить("ПериодДекада");
	СлужебныеПоля.Добавить("ПериодМесяц");
	СлужебныеПоля.Добавить("ПериодКвартал");
	СлужебныеПоля.Добавить("ПериодПолугодие");
	СлужебныеПоля.Добавить("ПериодГод");
	СлужебныеПоля.Добавить("ПериодКурса");
	СлужебныеПоля.Добавить("Период");
	
	// Вспомогательные поля
	СлужебныеПоля.Добавить("ИдентификаторИсточникаДанных");
	СлужебныеПоля.Добавить("ХозяйственнаяОперация");
	СлужебныеПоля.Добавить("Счет");
	СлужебныеПоля.Добавить("ИсточникДанных");
	
	// Вспомогательные параметры
	СлужебныеПоля.Добавить("ПривилегированныйРежим");
	СлужебныеПоля.Добавить("ПривилегированныйРежимИсточника");
	
	Возврат СлужебныеПоля;
	
КонецФункции

#КонецОбласти 
//-- НЕ УТ

#Область НастройкиХозяйственныхОпераций

// Для хозяйственной операции возвращает схему компоновки данных
// с помощью которой можно получить движения по текущей хозяйственной операции.
//
// Параметры:
//  ХозяйственнаяОперация - СправочникСсылка.НастройкиХозяйственныхОпераций - хозяйственная операция 
//                        для которой требуется получить схему получения данных.
//
// Возвращаемое значение:
//   СхемаКомпоновкиДанных - схема получения данных по текущей хозяйственной операции.
//
Функция СхемаПолученияДанных(ХозяйственнаяОперация) Экспорт

	СхемаПолученияДанных = Неопределено;
	ИмяИсточникаДанных = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ХозяйственнаяОперация, "ИсточникДанных");
	МакетыИсточниковПолученияДанных = Метаданные.Справочники.НастройкиХозяйственныхОпераций.Макеты;
	МакетИсточникаПолученияДанных = МакетыИсточниковПолученияДанных.Найти(ИмяИсточникаДанных);
	Если МакетИсточникаПолученияДанных <> Неопределено Тогда
		ИмяСхемы = МакетИсточникаПолученияДанных.Имя; 
		СхемаПолученияДанных = Справочники.НастройкиХозяйственныхОпераций.ПолучитьМакет(ИмяСхемы);
	КонецЕсли;
	
	Возврат СхемаПолученияДанных;

КонецФункции

// Определяет список хозяйственных операций отражаемых в текущем регистре накопления.
//
// Параметры:
//  ИмяРегистра - Строка - имя регистра накопления.
//
// Возвращаемое значение:
//    СправочникСсылка.НастройкиХозяйственныхОпераций - массив хозяйственных операций отражаемых в переданном регистре накопления.
//
Функция ХозяйственныеОперацииАналитическихРегистров(ИмяРегистра) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	НастройкиХозяйственныхОпераций.Ссылка
	|ИЗ
	|	Справочник.НастройкиХозяйственныхОпераций КАК НастройкиХозяйственныхОпераций
	|ГДЕ
	|	НастройкиХозяйственныхОпераций.ИсточникДанных = &ИмяРегистра";
	Запрос.УстановитьПараметр("ИмяРегистра", ИмяРегистра);
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		Возврат РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Ссылка");
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

// Возвращает список всех регистров накопления используемых для хранения аналитической информации.
//
// Возвращаемое значение:
//    СписокЗначений - список регистров накопления.
//
Функция ДоступныеИсточникиДанных() Экспорт
	
	Список = Новый СписокЗначений;
	Регистры = Метаданные.РегистрыНакопления;
	Список.Добавить(Регистры.ВыручкаИСебестоимостьПродаж.Имя, Регистры.ВыручкаИСебестоимостьПродаж.Синоним);
	Список.Добавить(Регистры.ДвиженияДенежныеСредстваДоходыРасходы.Имя, Регистры.ДвиженияДенежныеСредстваДоходыРасходы.Синоним);
	Список.Добавить(Регистры.ДвиженияДенежныеСредстваКонтрагент.Имя, Регистры.ДвиженияДенежныеСредстваКонтрагент.Синоним);
	Список.Добавить(Регистры.ДвиженияДенежныхСредств.Имя, Регистры.ДвиженияДенежныхСредств.Синоним);
	Список.Добавить(Регистры.ДвиженияДоходыРасходыПрочиеАктивыПассивы.Имя, Регистры.ДвиженияДоходыРасходыПрочиеАктивыПассивы.Синоним);
	Список.Добавить(Регистры.ДвиженияКонтрагентДоходыРасходы.Имя, Регистры.ДвиженияКонтрагентДоходыРасходы.Синоним);
	Список.Добавить(Регистры.ДвиженияКонтрагентКонтрагент.Имя, Регистры.ДвиженияКонтрагентКонтрагент.Синоним);
	Список.Добавить(Регистры.ДвиженияНоменклатураДоходыРасходы.Имя, Регистры.ДвиженияНоменклатураДоходыРасходы.Синоним);
	Список.Добавить(Регистры.ДвиженияНоменклатураНоменклатура.Имя, Регистры.ДвиженияНоменклатураНоменклатура.Синоним);
	Список.Добавить(Регистры.Закупки.Имя, Регистры.Закупки.Синоним);
	Список.Добавить(Регистры.НДСЗаписиКнигиПокупок.Имя, Регистры.НДСЗаписиКнигиПокупок.Синоним);
	Список.Добавить(Регистры.НДСЗаписиКнигиПродаж.Имя, Регистры.НДСЗаписиКнигиПродаж.Синоним);
	Список.Добавить(Регистры.ПрочиеРасходы.Имя, Регистры.ПрочиеРасходы.Синоним);
	Список.Добавить(Регистры.РасчетыСКлиентамиПоДокументам.Имя, Регистры.РасчетыСКлиентамиПоДокументам.Синоним);
	Список.Добавить(Регистры.РасчетыСПоставщикамиПоДокументам.Имя, Регистры.РасчетыСПоставщикамиПоДокументам.Синоним);
	//++ НЕ УТ
	Список.Добавить(Регистры.АмортизацияОС.Имя, Регистры.АмортизацияОС.Синоним);
	Список.Добавить(Регистры.АмортизацияНМА.Имя, Регистры.АмортизацияНМА.Синоним);
	Список.Добавить(Регистры.СтоимостьОС.Имя, Регистры.СтоимостьОС.Синоним);
	Список.Добавить(Регистры.СтоимостьНМА.Имя, Регистры.СтоимостьНМА.Синоним);
	//-- НЕ УТ
	
	Возврат Список;
	
КонецФункции

#КонецОбласти 

#КонецОбласти

//++ НЕ УТ
#Область СлужебныеПроцедурыИФункции

Функция ИмяМакетаПоЗначениюИсточника(ИсточникИмениМакета)
	
	ИмяМакета = Неопределено;
	
	ПоддерживаемыеТипы = ПоддерживаемыеТипыИсточниковИмениМакета();
	ТипИсточникаИмениМакета = ТипЗнч(ИсточникИмениМакета);
	
	Если ПоддерживаемыеТипы.Найти(ТипИсточникаИмениМакета) = Неопределено Тогда
		ВызватьИсключение НСтр("ru = 'Недопустимый тип источника получения данных.'");
	КонецЕсли;
	
	Если ТипИсточникаИмениМакета = Тип("ПеречислениеСсылка.ХозяйственныеОперации") Тогда
		ИмяОперации = ОбщегоНазначения.ИмяЗначенияПеречисления(ИсточникИмениМакета);
		ИмяМакета = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Справочники.НастройкиХозяйственныхОпераций[ИмяОперации], "ИсточникДанных");
		
	ИначеЕсли ТипИсточникаИмениМакета = Тип("СправочникСсылка.НастройкиХозяйственныхОпераций") Тогда
		ИмяМакета = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ИсточникИмениМакета, "ИсточникДанных");
		
	ИначеЕсли ТипИсточникаИмениМакета = Тип("ПланВидовХарактеристикСсылка.СтатьиАктивовПассивов") Тогда
		ИмяМакета = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ИсточникИмениМакета, "ИмяПредопределенныхДанных");
		
	КонецЕсли;
		
	Возврат ИмяМакета;
		
КонецФункции

Функция НаборДанныхСКДИсточника(Знач СхемаКомпоновкиДанных, Знач ИмяСправочникаИсточника, Знач ИдентификаторИсточникаДанных)
	Перем НаборДанныхСКДИсточника;
	
	НаборДанныхСКДИсточника = СхемаКомпоновкиДанных.НаборыДанных.Найти("ОбъединенныйФакт");
	Если НаборДанныхСКДИсточника = Неопределено Тогда
		Если СхемаКомпоновкиДанных.НаборыДанных.Количество() > 0 Тогда
			НаборДанныхСКДИсточника = СхемаКомпоновкиДанных.НаборыДанных[0];
		Иначе 
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'В СКД справочника ""%1"" макета ""%2"" нет ни одного набора данных.'"), 
				ИмяСправочникаИсточника,
				ИдентификаторИсточникаДанных);
				
			ВызватьИсключение ТекстСообщения;
		КонецЕсли;
	КонецЕсли;

	Возврат НаборДанныхСКДИсточника;
КонецФункции

#КонецОбласти
//-- НЕ УТ

