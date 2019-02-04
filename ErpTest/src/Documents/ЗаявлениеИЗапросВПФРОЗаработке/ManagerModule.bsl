
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// СтандартныеПодсистемы.Печать

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "ЗарплатаКадрыКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Идентификатор = "ПФ_MXL_Заявление";
	КомандаПечати.Представление = НСтр("ru = 'Заявление'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.Порядок = 10;
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "ЗарплатаКадрыКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Идентификатор = "ПФ_MXL_Запрос";
	КомандаПечати.Представление = НСтр("ru = 'Запрос'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.Порядок = 20;
	
КонецПроцедуры

// Вызывается при печати документа.
//
// Параметры:
//   См. одноименные параметры процедуры УправлениеПечатьюПереопределяемый.ПриПечати.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
	МассивДопустимыхОбъектов = Новый Массив;
	Для каждого ДопустимыйОбъект Из МассивОбъектов Цикл
		Если ТипЗнч(ДопустимыйОбъект) = Тип("ДокументСсылка.ЗаявлениеИЗапросВПФРОЗаработке") Тогда
			МассивДопустимыхОбъектов.Добавить(ДопустимыйОбъект);
		КонецЕсли;
	КонецЦикла;
	
	Если МассивДопустимыхОбъектов.Количество() > 0 Тогда
		НапечататьМакет(МассивДопустимыхОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, "ПФ_MXL_Заявление", Нстр("ru = 'Заявление'"));
		НапечататьМакет(МассивДопустимыхОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, "ПФ_MXL_Запрос", Нстр("ru = 'Запрос'"));
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(ФизическоеЛицо)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура НапечататьМакет(МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ИмяМакета, Синоним)
	
	// Проверяем, нужно ли для макета Справка формировать табличный документ.
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, ИмяМакета) Тогда
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
			ИмяМакета, Синоним, ТабличныйДокументЗаявлениеЗапрос(МассивОбъектов, ОбъектыПечати, ИмяМакета));
	КонецЕсли;
	
КонецПроцедуры    

Функция ТабличныйДокументЗаявлениеЗапрос(МассивОбъектов, ОбъектыПечати, ИмяМакета)
	
	Если ИмяМакета = "ПФ_MXL_Заявление" Тогда
		ТабличныйДокумент = ПечатьЗаявления(МассивОбъектов, ОбъектыПечати);
	ИначеЕсли ИмяМакета = "ПФ_MXL_Запрос" Тогда
		ТабличныйДокумент = ПечатьЗапроса(МассивОбъектов, ОбъектыПечати);
	КонецЕсли;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция ПечатьЗаявления(МассивОбъектов, ОбъектыПечати)
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ПолеСлева = 0;
	ТабДокумент.ПолеСправа = 0;
	ТабДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ЗаявлениеОНаправленииЗапросаВПФР";
		
	// получаем данные для печати
	ВыборкаПоШапкеДокумента = СформироватьЗапросДляПечати(МассивОбъектов).Выбрать();
	
	Отказ = Ложь; 	
	
	ПервыйДокумент = Истина;
	
	Макет = ПолучитьМакет("ПФ_MXL_Заявление");
	
	Если ВыборкаПоШапкеДокумента.Следующий() Тогда 
						
		Если Не ПервыйДокумент Тогда
			// Все документы нужно выводить на разных страницах.
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;

		ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ);

		Макет.Параметры.Заполнить(ВыборкаПоШапкеДокумента);
		Макет.Параметры.НазваниеОрганизации = СокрЛП(Макет.Параметры.НазваниеОрганизации);
		Макет.Параметры.НазваниеСтрахователя = СокрЛП(Макет.Параметры.НазваниеСтрахователя);
		Макет.Параметры.ВидПособия = НРег(Макет.Параметры.ВидПособия);
		Макет.Параметры.ИныеПричиныОтсутствияСправки = СокрЛП(Макет.Параметры.ИныеПричиныОтсутствияСправки);
		Макет.Параметры.КемВыданДокумент = СокрЛП(Макет.Параметры.КемВыданДокумент);
		Макет.Параметры.ДатаВыдачиДокумента = Формат(Макет.Параметры.ДатаВыдачиДокумента,"ДЛФ=DD");
		
		СтруктураАдреса = ЗарплатаКадры.СтруктураАдресаИзXML(ВыборкаПоШапкеДокумента.Адрес, ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.АдресПоПропискеФизическиеЛица"));
		УправлениеКонтактнойИнформациейКлиентСервер.СформироватьПредставлениеАдреса(СтруктураАдреса, Макет.Параметры.Адрес);
		
		СтруктураТелефона = РаботаСАдресами.ПредыдущаяСтруктураКонтактнойИнформацииXML(ВыборкаПоШапкеДокумента.Телефон,	ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.ТелефонМобильныйФизическиеЛица"));
		Макет.Параметры.Телефон = УправлениеКонтактнойИнформациейКлиентСервер.СформироватьПредставлениеТелефона(СтруктураТелефона.КодСтраны, 
																					  СтруктураТелефона.КодГорода, 
																					  СтруктураТелефона.НомерТелефона, 
																					  СтруктураТелефона.Добавочный, 
																					  СтруктураТелефона.Комментарий);

		Область = Макет.Области[?(ВыборкаПоШапкеДокумента.СтраховательПрекратилДеятельность,"ПоИнымПричинам","ПрекращениеДеятельности")];
		Область.Шрифт = Новый Шрифт(Область.Шрифт,,,,,,Истина);
		
		ТабДокумент.Вывести(Макет);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, НомерСтрокиНачало, ОбъектыПечати, ВыборкаПоШапкеДокумента.Ссылка);
		
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат Новый ТабличныйДокумент;
	Иначе
		Возврат ТабДокумент;
	КонецЕсли;

КонецФункции

Функция ПечатьЗапроса(МассивОбъектов, ОбъектыПечати)
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ЗапросВПФРОЗаработкеСотрудника";
		
	// получаем данные для печати
	ВыборкаПоШапкеДокумента = СформироватьЗапросДляПечати(МассивОбъектов).Выбрать();
	
	Отказ = Ложь;
	
	ПервыйДокумент = Истина;
		
	Макет = ПолучитьМакет("ПФ_MXL_Запрос");
	
	Если ВыборкаПоШапкеДокумента.Следующий() Тогда 
		
		Если Не ПервыйДокумент Тогда
			// Все документы нужно выводить на разных страницах.
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;

		ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ);
				
		Макет.Параметры.Заполнить(ВыборкаПоШапкеДокумента);
		Макет.Параметры.НазваниеОрганизации = СокрЛП(Макет.Параметры.НазваниеОрганизации);
		Макет.Параметры.НазваниеСтрахователя = СокрЛП(Макет.Параметры.НазваниеСтрахователя);
		Макет.Параметры.КемВыданДокумент = СокрЛП(Макет.Параметры.КемВыданДокумент);
		Макет.Параметры.ДатаВыдачиДокумента = Формат(Макет.Параметры.ДатаВыдачиДокумента,"ДЛФ=DD");
		
		СтруктураАдреса = ЗарплатаКадры.СтруктураАдресаИзXML(ВыборкаПоШапкеДокумента.Адрес, ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.АдресПоПропискеФизическиеЛица"));
		УправлениеКонтактнойИнформациейКлиентСервер.СформироватьПредставлениеАдреса(СтруктураАдреса, Макет.Параметры.Адрес);

		СтруктураАдреса = ЗарплатаКадры.СтруктураАдресаИзXML(ВыборкаПоШапкеДокумента.АдресОрганизации, ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.ЮрАдресОрганизации"));
		УправлениеКонтактнойИнформациейКлиентСервер.СформироватьПредставлениеАдреса(СтруктураАдреса, Макет.Параметры.АдресОрганизации);
		
		СтруктураТелефона = РаботаСАдресами.ПредыдущаяСтруктураКонтактнойИнформацииXML(ВыборкаПоШапкеДокумента.ТелефонОрганизации,	ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.ТелефонОрганизации"));
		Макет.Параметры.ТелефонОрганизации = УправлениеКонтактнойИнформациейКлиентСервер.СформироватьПредставлениеТелефона(СтруктураТелефона.КодСтраны, 
																					  СтруктураТелефона.КодГорода, 
																					  СтруктураТелефона.НомерТелефона, 
																					  СтруктураТелефона.Добавочный, 
																					  СтруктураТелефона.Комментарий);

		СписокФизлиц = Новый Массив;
		СписокФизлиц.Добавить(ВыборкаПоШапкеДокумента.Руководитель);
				
		КадровыеДанныеФизическихЛиц = КадровыйУчет.КадровыеДанныеФизическихЛиц(Истина, СписокФизлиц, "ИОФамилия");
		
		ДанныеРуководителя = КадровыеДанныеФизическихЛиц.Найти(ВыборкаПоШапкеДокумента.Руководитель, "ФизическоеЛицо");
		Если НЕ ДанныеРуководителя = Неопределено Тогда
		   Макет.Параметры["ФИОРуководителя"] = ДанныеРуководителя.ИОФамилия;
		КонецЕсли;

		ТабДокумент.Вывести(Макет);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, НомерСтрокиНачало, ОбъектыПечати, ВыборкаПоШапкеДокумента.Ссылка);
		
	КонецЕсли;
		
	Если Отказ Тогда
		Возврат Новый ТабличныйДокумент;
	Иначе
		Возврат ТабДокумент;
	КонецЕсли;
	
КонецФункции

Функция СформироватьЗапросДляПечати(МассивОбъектов)

	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	// Установим параметры запроса.
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	ОписаниеИсточникаДанных = ПерсонифицированныйУчет.ОписаниеИсточникаДанныхДляСоздатьВТСведенияОбОрганизациях();
	ОписаниеИсточникаДанных.ИмяТаблицы = "Документ.ЗаявлениеИЗапросВПФРОЗаработке";
	ОписаниеИсточникаДанных.ИмяПоляОрганизация = "Организация";
	ОписаниеИсточникаДанных.ИмяПоляПериод = "Дата";
	ОписаниеИсточникаДанных.СписокСсылок = МассивОбъектов;

	ПерсонифицированныйУчет.СоздатьВТСведенияОбОрганизацияхПоОписаниюДокументаИсточникаДанных(Запрос.МенеджерВременныхТаблиц, ОписаниеИсточникаДанных);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗаявлениеЗапрос.Дата,
	|	ЗаявлениеЗапрос.Номер,
	|	ЗаявлениеЗапрос.Организация,
	|	ЗаявлениеЗапрос.Сотрудник,
	|	Организации.НаименованиеПолное КАК НазваниеОрганизации,
	|	Организации.ИНН КАК ИНН,
	|	Организации.КПП КАК КПП,
	|	Организации.РегистрационныйНомерПФР КАК РегистрационныйНомерПФР,
	|	Должности.Наименование КАК Должность,
	|	ЗаявлениеЗапрос.Страхователь.НаименованиеПолное КАК НазваниеСтрахователя,
	|	ЗаявлениеЗапрос.СтраховательПрекратилДеятельность,
	|	ЗаявлениеЗапрос.ИныеПричиныОтсутствияСправки КАК ИныеПричиныОтсутствияСправки,
	|	ЗаявлениеЗапрос.ВидПособия,
	|	ЗаявлениеЗапрос.ПериодРаботыС,
	|	ЗаявлениеЗапрос.ПериодРаботыПо,
	|	ЗаявлениеЗапрос.СтраховойНомерПФР,
	|	ЗаявлениеЗапрос.ДатаРождения,
	|	ЗаявлениеЗапрос.Фамилия + "" "" + ЗаявлениеЗапрос.Имя + "" "" + ЗаявлениеЗапрос.Отчество КАК ФИО,
	|	ЗаявлениеЗапрос.Фамилия,
	|	ЗаявлениеЗапрос.Имя,
	|	ЗаявлениеЗапрос.Отчество,
	|	ЗаявлениеЗапрос.Адрес,
	|	ЗаявлениеЗапрос.Телефон,
	|	ЗаявлениеЗапрос.СерияДокумента,
	|	ЗаявлениеЗапрос.НомерДокумента,
	|	ЗаявлениеЗапрос.ДатаВыдачиДокумента,
	|	ЗаявлениеЗапрос.КемВыданДокумент,
	|	ВЫБОР
	|		КОГДА ЗаявлениеЗапрос.Сотрудник.ФизическоеЛицо.Пол = ЗНАЧЕНИЕ(Перечисление.ПолФизическогоЛица.Женский)
	|			ТОГДА ""а""
	|		ИНАЧЕ """"
	|	КОНЕЦ КАК ОкончаниеГлагола,
	|	ЗаявлениеЗапрос.Страхователь,
	|	ЗаявлениеЗапрос.Ссылка,
	|	ЗаявлениеЗапрос.АдресОрганизации,
	|	ЗаявлениеЗапрос.ТелефонОрганизации,
	|	ЗаявлениеЗапрос.НаименованиеТерриториальногоОрганаПФР,
	|	ЗаявлениеЗапрос.Руководитель,
	|	ЗаявлениеЗапрос.ДолжностьРуководителя КАК ДолжностьРуководителя1,
	|	ГОД(ЗаявлениеЗапрос.ПериодРаботыС) КАК ГодС,
	|	ГОД(ЗаявлениеЗапрос.ПериодРаботыПо) КАК ГодПо
	|ИЗ
	|	Документ.ЗаявлениеИЗапросВПФРОЗаработке КАК ЗаявлениеЗапрос
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТСведенияОбОрганизациях КАК Организации
	|		ПО ЗаявлениеЗапрос.Организация = Организации.Организация
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Должности КАК Должности
	|		ПО ЗаявлениеЗапрос.ДолжностьРуководителя = Должности.Ссылка
	|ГДЕ
	|	ЗаявлениеЗапрос.Ссылка В(&МассивОбъектов)";

	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоШапке()

Процедура ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ)

	//  Организация
	Если Не ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.Организация) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не указана организация'"), , , , Отказ);
	КонецЕсли;
	
	//  Страхователь
	Если Не ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.Страхователь) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не указан другой страхователь'"), , , , Отказ);
	КонецЕсли;
	
	// Сотрудник
	Если Не ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.Сотрудник) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не выбран сотрудник'"), , , , Отказ);
	Иначе
		Если Не ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.ФИО) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не указано ФИО сотрудника'"), , , , Отказ);
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.ДатаРождения) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не указана дата рождения'"), , , , Отказ);
		КонецЕсли;
		Если Не ЗначениеЗаполнено(СтрЗаменить(ВыборкаПоШапкеДокумента.СтраховойНомерПФР,"-","")) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не указан страховой номер ПФР'"), , , , Отказ);
		КонецЕсли;
	КонецЕсли;

	Если Не ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.ВидПособия) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не указан вид пособия'"), , , , Отказ);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.ПериодРаботыС) Или Не ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.ПериодРаботыПо) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не указан период работы у другого страхователя'"), , , , Отказ);
	ИначеЕсли ВыборкаПоШапкеДокумента.ПериодРаботыС > ВыборкаПоШапкеДокумента.ПериодРаботыПо Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Неверно указан период работы у другого страхователя'"), , , , Отказ);
	КонецЕсли;
	
	Если Не ВыборкаПоШапкеДокумента.СтраховательПрекратилДеятельность И Не ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.ИныеПричиныОтсутствияСправки) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не указана иная причина отсутствия справки о сумме заработной платы'"), , , , Отказ);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.НаименованиеТерриториальногоОрганаПФР) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не указано наименование территориального органа ПФР'"), , , , Отказ);
	КонецЕсли;
	
КонецПроцедуры // ПроверитьЗаполнениеШапки()

#Область МеханизмФиксацииИзменений

Функция ПараметрыФиксацииВторичныхДанных() Экспорт
	
	ПараметрыФиксацииВторичныхДанных = ФиксацияВторичныхДанныхВДокументах.ПараметрыФиксацииВторичныхДанных(ФиксацияОписаниеФиксацииРеквизитов());
	Возврат ПараметрыФиксацииВторичныхДанных;
	
КонецФункции

Функция ФиксацияОписаниеФиксацииРеквизитов()
	
	ОписаниеФиксацииРеквизитов = Новый Соответствие;
	
	// Данные работодателя
	ОписаниеФиксацииРеквизитов.Вставить("НаименованиеТерриториальногоОрганаПФР", 	ФиксацияОписаниеФиксацииРеквизита("НаименованиеТерриториальногоОрганаПФР","РеквизитыОрганизации", "Организация"));
	ОписаниеФиксацииРеквизитов.Вставить("Руководитель", 							ФиксацияОписаниеФиксацииРеквизита("Руководитель","РеквизитыОрганизации", "Организация"));
	ОписаниеФиксацииРеквизитов.Вставить("ДолжностьРуководителя", 					ФиксацияОписаниеФиксацииРеквизита("ДолжностьРуководителя","РеквизитыОрганизации", "Организация"));
	ОписаниеФиксацииРеквизитов.Вставить("ОснованиеПодписиРуководителя", 			ФиксацияОписаниеФиксацииРеквизита("ОснованиеПодписиРуководителя","РеквизитыОрганизации", "Организация"));
	ОписаниеФиксацииРеквизитов.Вставить("ТелефонОрганизации", 						ФиксацияОписаниеФиксацииРеквизита("ТелефонОрганизации","РеквизитыОрганизации", "Организация"));
	ОписаниеФиксацииРеквизитов.Вставить("АдресОрганизации", 						ФиксацияОписаниеФиксацииРеквизита("АдресОрганизации","РеквизитыОрганизации", "Организация"));
	
	// Данные сотрудника
	ОписаниеФиксацииРеквизитов.Вставить("Фамилия", 									ФиксацияОписаниеФиксацииРеквизита("Фамилия","ФИОСотрудника", "Сотрудник"));
	ОписаниеФиксацииРеквизитов.Вставить("Имя", 										ФиксацияОписаниеФиксацииРеквизита("Имя","ФИОСотрудника", "Сотрудник"));
	ОписаниеФиксацииРеквизитов.Вставить("Отчество",	 								ФиксацияОписаниеФиксацииРеквизита("Отчество","ФИОСотрудника", "Сотрудник"));
	ОписаниеФиксацииРеквизитов.Вставить("СтраховойНомерПФР", 						ФиксацияОписаниеФиксацииРеквизита("СтраховойНомерПФР","РеквизитыСотрудника", "Сотрудник"));
	ОписаниеФиксацииРеквизитов.Вставить("ДатаРождения", 							ФиксацияОписаниеФиксацииРеквизита("ДатаРождения","РеквизитыСотрудника", "Сотрудник"));
	ОписаниеФиксацииРеквизитов.Вставить("ВидДокумента", 							ФиксацияОписаниеФиксацииРеквизита("ВидДокумента","РеквизитыУдостоверения", "Сотрудник", , Истина));
	ОписаниеФиксацииРеквизитов.Вставить("СерияДокумента", 							ФиксацияОписаниеФиксацииРеквизита("СерияДокумента","РеквизитыУдостоверения", "Сотрудник", , Истина));
	ОписаниеФиксацииРеквизитов.Вставить("НомерДокумента", 							ФиксацияОписаниеФиксацииРеквизита("НомерДокумента","РеквизитыУдостоверения", "Сотрудник", , Истина));
	ОписаниеФиксацииРеквизитов.Вставить("КемВыданДокумент", 						ФиксацияОписаниеФиксацииРеквизита("КемВыданДокумент","РеквизитыУдостоверения", "Сотрудник", , Истина));
	ОписаниеФиксацииРеквизитов.Вставить("ДатаВыдачиДокумента", 						ФиксацияОписаниеФиксацииРеквизита("ДатаВыдачиДокумента","РеквизитыУдостоверения", "Сотрудник", , Истина));
	ОписаниеФиксацииРеквизитов.Вставить("Адрес",		 							ФиксацияОписаниеФиксацииРеквизита("Адрес","РеквизитыСотрудника", "Сотрудник"));
	ОписаниеФиксацииРеквизитов.Вставить("Телефон",		 							ФиксацияОписаниеФиксацииРеквизита("Телефон","РеквизитыСотрудника", "Сотрудник"));
		
	Возврат Новый ФиксированноеСоответствие(ОписаниеФиксацииРеквизитов);  
	
КонецФункции 

Функция ФиксацияОписаниеФиксацииРеквизита(ИмяРеквизита, 
	ИмяГруппы, 
	ОснованиеЗаполнения,
	РеквизитСтроки = Ложь,
	ФиксацияГруппы = Ложь, 
	Путь = "",
	Используется = Истина, 
	ОтображатьПредупреждение = Истина, 
	СтрокаПредупреждения =  "")
	
	ФиксацияРеквизита = ФиксацияВторичныхДанныхВДокументах.ОписаниеФиксируемогоРеквизита();
	ФиксацияРеквизита.Вставить("ИмяРеквизита", ИмяРеквизита);
	ФиксацияРеквизита.Вставить("Используется", Используется);
	ФиксацияРеквизита.Вставить("ИмяГруппы", ИмяГруппы);
	ФиксацияРеквизита.Вставить("ФиксацияГруппы", ФиксацияГруппы);
	ФиксацияРеквизита.Вставить("ОснованиеЗаполнения", ОснованиеЗаполнения);
	ФиксацияРеквизита.Вставить("Путь", Путь);
	ФиксацияРеквизита.Вставить("ОтображатьПредупреждение", ОтображатьПредупреждение);
	Если СтрокаПредупреждения <> "" Тогда
		ФиксацияРеквизита.Вставить("СтрокаПредупреждения", СтрокаПредупреждения);
	КонецЕсли;
	ФиксацияРеквизита.Вставить("РеквизитСтроки", РеквизитСтроки);
	
	Возврат ФиксацияВторичныхДанныхВДокументах.ОписаниеФиксацииРеквизита(ФиксацияРеквизита);
	
КонецФункции 

#КонецОбласти

#КонецОбласти

#КонецЕсли