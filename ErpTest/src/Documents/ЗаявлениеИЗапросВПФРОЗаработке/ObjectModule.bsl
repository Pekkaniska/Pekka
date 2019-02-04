#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступом.ЗаполнитьНаборыЗначенийДоступа.
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	ЗарплатаКадры.ЗаполнитьНаборыПоОрганизацииИФизическимЛицам(ЭтотОбъект, Таблица, "Организация", "ФизическоеЛицо");
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, ПериодРаботыС, "Объект.ПериодРаботыС", Отказ, НСтр("ru='Начало периода'"), , , Ложь);
	ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, ДатаРождения, "Объект.ДатаРождения", Отказ, НСтр("ru='Начало периода'"), '19000101', , Ложь);
	ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, ДатаВыдачиДокумента, "Объект.ДатаВыдачиДокумента", Отказ, НСтр("ru='Дата выдачи'"), , , Ложь);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция возвращает признак завершенности работы с объектом.
Функция ОбъектЗафиксирован() Экспорт
	Возврат Проведен;
КонецФункции

// Процедура обновляет вторичные данные в документе с учетом фиксации.
Функция ОбновитьВторичныеДанныеДокумента(ДанныеОрганизации = Истина, ДанныеСотрудника = Истина, ДанныеОЗаработке = Истина, ОбновлятьБезусловно = Истина) Экспорт
	Модифицирован = Ложь;
	
	Если ОбъектЗафиксирован() И НЕ ОбновлятьБезусловно Тогда
		Возврат Модифицирован;
	КонецЕсли;
	
	ПараметрыФиксации = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(Метаданные().ПолноеИмя()).ПараметрыФиксацииВторичныхДанных();
	
	Если ДанныеОрганизации И ОбновитьДанныеСтрахователя(ПараметрыФиксации) Тогда
		Модифицирован = Истина;
	КонецЕсли;
	
	Если ДанныеСотрудника И ОбновитьДанныеСотрудника(ПараметрыФиксации) Тогда
		Модифицирован = Истина;
	КонецЕсли;
	
	Возврат Модифицирован
КонецФункции

Функция ОбновитьДанныеСтрахователя(ПараметрыФиксации)
	Если Не ЗначениеЗаполнено(Организация) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	СтрокаРеквизиты = "НаименованиеТерриториальногоОрганаПФР,Руководитель,ДолжностьРуководителя,ОснованиеПодписиРуководителя,ТелефонОрганизации,АдресОрганизации";
	
	РеквизитыДокумента = Новый Структура(СтрокаРеквизиты);
	
	СтрокаРеквизитыОрганизации = "НаименованиеТерриториальногоОрганаПФР";
	РеквизитыОрганизации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Организация, СтрокаРеквизитыОрганизации);
	
	ЗаполнитьЗначенияСвойств(РеквизитыДокумента, РеквизитыОрганизации, СтрокаРеквизитыОрганизации);
	
	ЗаполняемыеЗначения = ПодписиДокументов.СведенияОПодписяхПоУмолчаниюДляОбъектаМетаданных(Метаданные(), Организация);
	ЗаполнитьЗначенияСвойств(РеквизитыДокумента, ЗаполняемыеЗначения);
	
	АдресаОрганизации = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(Организация, Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации, , Ложь);
	Если АдресаОрганизации.Количество() > 0 Тогда
		РеквизитыДокумента.АдресОрганизации = АдресаОрганизации[0].Значение;
	Иначе
		РеквизитыДокумента.АдресОрганизации = "";
	КонецЕсли;
	
	ТелефоныОрганизации = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(Организация, Справочники.ВидыКонтактнойИнформации.ТелефонОрганизации, , Ложь);
	Если ТелефоныОрганизации.Количество() > 0 Тогда
		РеквизитыДокумента.ТелефонОрганизации = ТелефоныОрганизации[0].Значение;
	Иначе
		РеквизитыДокумента.ТелефонОрганизации = "";
	КонецЕсли;
	
	Возврат ФиксацияВторичныхДанныхВДокументах.ОбновитьДанныеШапки(РеквизитыДокумента, ЭтотОбъект, ПараметрыФиксации);
КонецФункции

Функция ОбновитьДанныеСотрудника(ПараметрыФиксации)
	КадровыеДанные = Новый Массив;
	КадровыеДанные.Добавить("ФизическоеЛицо");
	КадровыеДанные.Добавить("Фамилия");
	КадровыеДанные.Добавить("Имя");
	КадровыеДанные.Добавить("Отчество");
	КадровыеДанные.Добавить("СтраховойНомерПФР");
	КадровыеДанные.Добавить("ДатаРождения");
	КадровыеДанные.Добавить("ДокументВид");
	КадровыеДанные.Добавить("ДокументСерия");
	КадровыеДанные.Добавить("ДокументНомер");
	КадровыеДанные.Добавить("ДокументКемВыдан");
	КадровыеДанные.Добавить("ДокументДатаВыдачи");
	КадровыеДанные.Добавить("АдресПоПрописке");
	КадровыеДанные.Добавить("АдресПоПропискеПредставление");
	КадровыеДанные.Добавить("ТелефонМобильный");
	КадровыеДанные.Добавить("ТелефонМобильныйПредставление");
	
	КадровыеДанныеСотрудников = КадровыйУчет.КадровыеДанныеСотрудников(Истина, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Сотрудник), КадровыеДанные, Дата);
	Если КадровыеДанныеСотрудников.Количество() = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	КадровыеДанныеСотрудника = КадровыеДанныеСотрудников[0];
	
	ФизическоеЛицо = КадровыеДанныеСотрудника["ФизическоеЛицо"];
	
	РеквизитыДокумента = Новый Структура("ФизическоеЛицо,Фамилия,Имя,Отчество,СтраховойНомерПФР,ДатаРождения,ВидДокумента,СерияДокумента,НомерДокумента,КемВыданДокумент,ДатаВыдачиДокумента,Адрес,Телефон");
	
	ЗаполнитьЗначенияСвойств(РеквизитыДокумента, КадровыеДанныеСотрудника, "ФизическоеЛицо,Фамилия,Имя,Отчество,СтраховойНомерПФР,ДатаРождения");
	
	РеквизитыДокумента["ВидДокумента"] 			= КадровыеДанныеСотрудника["ДокументВид"];
	РеквизитыДокумента["СерияДокумента"] 		= КадровыеДанныеСотрудника["ДокументСерия"];
	РеквизитыДокумента["НомерДокумента"] 		= КадровыеДанныеСотрудника["ДокументНомер"];
	РеквизитыДокумента["КемВыданДокумент"]		= КадровыеДанныеСотрудника["ДокументКемВыдан"];
	РеквизитыДокумента["ДатаВыдачиДокумента"] 	= КадровыеДанныеСотрудника["ДокументДатаВыдачи"];
	РеквизитыДокумента["Адрес"] 				= КадровыеДанныеСотрудника["АдресПоПрописке"];
	РеквизитыДокумента["Телефон"] 				= КадровыеДанныеСотрудника["ТелефонМобильный"];
	
	Возврат ФиксацияВторичныхДанныхВДокументах.ОбновитьДанныеШапки(РеквизитыДокумента, ЭтотОбъект, ПараметрыФиксации);
КонецФункции

#КонецОбласти

#КонецЕсли

