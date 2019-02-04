
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	Склад = Настройки.Получить("Склад");
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Склад", Склад,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(Склад));
	Настройки.Удалить("Склад");
	
	ХозяйственнаяОперация = Настройки.Получить("ХозяйственнаяОперация");
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"ХозяйственнаяОперация",
		ХозяйственнаяОперация,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(ХозяйственнаяОперация));
	Настройки.Удалить("ХозяйственнаяОперация");
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	
	СписокВыбора = Элементы.ХозяйственнаяОперация.СписокВыбора;
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьПроизводство") Тогда
		СписокВыбора.Добавить(Перечисления.ХозяйственныеОперации.ПоступлениеИзПроизводства);
	Иначе
		Элементы.СписокСоздатьПоступлениеИзПроизводства.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.СписокСкопировать.Видимость = ПравоДоступа("Добавление", Метаданные.Документы.ПрочееОприходованиеТоваров);
	
	СписокВыбора.Добавить(Перечисления.ХозяйственныеОперации.ВозвратИзЭксплуатации);
	СписокВыбора.Добавить(Перечисления.ХозяйственныеОперации.СторноСписанияНаРасходы);
	//++ НЕ УТ
	СписокВыбора.Добавить(Перечисления.ХозяйственныеОперации.ОприходованиеЗаСчетДоходов);
	//-- НЕ УТ
	
	УстановитьВидимость();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаГлобальныеКоманды);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	

	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.Дата", Элементы.СписокДата.Имя);


КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтаФорма, "СканерШтрихкода");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияУТКлиент.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(МенеджерОборудованияУТКлиент.ПреобразоватьДанныеСоСканераВСтруктуру(Параметр));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

&НаКлиенте
Процедура СкладПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Склад",
		Склад,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(Склад));
	
КонецПроцедуры

&НаКлиенте
Процедура ХозяйственнаяОперацияПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"ХозяйственнаяОперация",
		ХозяйственнаяОперация,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(ХозяйственнаяОперация));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьСторноСписанияНаРасходы(Команда)
	
	СоздатьПрочееОприходованиеТоваров(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.СторноСписанияНаРасходы"));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьВозвратИзЭксплуатации(Команда)
	
	Операция = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратИзЭксплуатации");
	СоздатьПрочееОприходованиеТоваров(Операция);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПоступлениеИзПроизводства(Команда)
	
	Операция = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПоступлениеИзПроизводства");
	СоздатьПрочееОприходованиеТоваров(Операция);
	
КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьОприходованиеЗаСчетДоходов(Команда)
	
	//++ НЕ УТ
	СоздатьПрочееОприходованиеТоваров(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ОприходованиеЗаСчетДоходов"));
	//-- НЕ УТ
	Возврат; // В УТ11 не используется
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьОприходованиеЗаСчетРасходов(Команда)
	
	//++ НЕ УТ
	СоздатьПрочееОприходованиеТоваров(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ОприходованиеЗаСчетРасходов"));
	//-- НЕ УТ
	Возврат; // В УТ11 не используется
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Функция ПолучитьСсылкуНаЭлементСпискаПоШтрихкоду(Штрихкод)
	
	Менеджеры = Новый Массив();
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ПрочееОприходованиеТоваров.ПустаяСсылка"));
	Возврат ШтрихкодированиеПечатныхФормКлиент.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
	
КонецФункции

&НаКлиенте
Процедура ОбработатьШтрихкоды(Данные)
	
	МассивСсылок = ПолучитьСсылкуНаЭлементСпискаПоШтрихкоду(Данные.Штрихкод);
	Если МассивСсылок.Количество() > 0 Тогда
		Элементы.Список.ТекущаяСтрока = МассивСсылок[0];
		ПоказатьЗначение(Неопределено, МассивСсылок[0]);
	Иначе
		ШтрихкодированиеПечатныхФормКлиент.ОбъектНеНайден(Данные.Штрихкод);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура УстановитьВидимость()
	
	ВидимостьКомандыСоздатьОприходованиеЗаСчетДоходовРасходов = Ложь;
//++ НЕ УТ
	ВидимостьКомандыСоздатьОприходованиеЗаСчетДоходовРасходов = ПолучитьФункциональнуюОпцию("ИспользоватьУчетПрочихДоходовРасходов");
//-- НЕ УТ
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СписокСоздатьОприходованиеЗаСчетДоходов",  "Видимость", ВидимостьКомандыСоздатьОприходованиеЗаСчетДоходовРасходов);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СписокСоздатьОприходованиеЗаСчетРасходов", "Видимость", ВидимостьКомандыСоздатьОприходованиеЗаСчетДоходовРасходов);
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы, 
			"СписокГруппаСоздать",
			"Видимость", 
			ПравоДоступа("Добавление", Метаданные.Документы.ПрочееОприходованиеТоваров));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПрочееОприходованиеТоваров(Операция)
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("ХозяйственнаяОперация", Операция);
	
	Если ЗначениеЗаполнено(Склад) Тогда
		ЗначенияЗаполнения.Вставить("Склад", Склад);
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	ОткрытьФорму("Документ.ПрочееОприходованиеТоваров.ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#КонецОбласти
