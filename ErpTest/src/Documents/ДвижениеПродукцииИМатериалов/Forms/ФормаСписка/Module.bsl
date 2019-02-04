
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ИнициализацияФормыПриСозданииНаСервере();
	
	#Область СтандартныеМеханизмы
	
	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма, Элементы.СписокКоманднаяПанель);
	// Конец ИнтеграцияС1СДокументооборотом
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.Дата", Элементы.СписокДата.Имя);
	#КонецОбласти
	
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

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	СохраненныеОперации = Настройки.Получить("ДоступныеХозяйственныеОперации");	
	Если СохраненныеОперации <> Неопределено Тогда
		
		Для каждого СохраненнаяОперация Из СохраненныеОперации Цикл
			
			Если СохраненнаяОперация.Пометка Тогда
				
				НайденнаяОперация = ДоступныеХозяйственныеОперации.НайтиПоЗначению(СохраненнаяОперация.Значение);
				Если НайденнаяОперация <> Неопределено Тогда
					НайденнаяОперация.Пометка = Истина;
				КонецЕсли;	
				
			КонецЕсли;	
			
		КонецЦикла;
		
		Настройки.Удалить("ДоступныеХозяйственныеОперации");
		
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	УстановитьОтборПоПодразделению(ЭтаФорма);
	УстановитьОтборПоОперации(ЭтаФорма);
	УстановитьОтборПоОтветственному(ЭтаФорма);
	УстановитьОтборПоСтатусу(ЭтаФорма);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборПодразделениеПриИзменении(Элемент)
	
	УстановитьОтборПоПодразделению(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОперацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФорму("Перечисление.ХозяйственныеОперации.Форма.ФормаВыбораОперации",
		Новый Структура("СписокОпераций", ДоступныеХозяйственныеОперации), Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОперацияПриИзменении(Элемент)
	
	УстановитьОтборПоОперации(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОперацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СписокЗначений") Тогда
		СтандартнаяОбработка = Ложь;
		ДоступныеХозяйственныеОперации = ВыбранноеЗначение;
		УстановитьОтборПоОперации(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОперацияОчистка(Элемент, СтандартнаяОбработка)
	
	ДоступныеХозяйственныеОперации.ЗаполнитьПометки(Ложь);
	УстановитьОтборПоОперации(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСтатусПриИзменении(Элемент)
	
	УстановитьОтборПоСтатусу(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОтветственныйПриИзменении(Элемент)
	
	УстановитьОтборПоОтветственному(ЭтаФорма);
	
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

#Область ОбработчикиКомандФормы

#Область ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_СоздатьДокумент(Команда)
	
	МассивИмен = СтрРазделить(Команда.Имя, "_");
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("ХозяйственнаяОперация", ДоступныеХозяйственныеОперации.Получить(МассивИмен[1]).Значение);
	
	Если ЗначениеЗаполнено(ОтборПодразделение) Тогда
		ЗначенияЗаполнения.Вставить("Подразделение", ОтборПодразделение);
	КонецЕсли;
	
	ОткрытьФорму("Документ.ДвижениеПродукцииИМатериалов.ФормаОбъекта", Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения));
	
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

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Функция СсылкаНаЭлементСпискаПоШтрихкоду(Штрихкод)
	
	Менеджеры = Новый Массив();
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ДвижениеПродукцииИМатериалов.ПустаяСсылка"));
	Возврат ШтрихкодированиеПечатныхФормКлиент.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
	
КонецФункции

&НаКлиенте
Процедура ОбработатьШтрихкоды(Данные)
	
	МассивСсылок = СсылкаНаЭлементСпискаПоШтрихкоду(Данные.Штрихкод);
	Если МассивСсылок.Количество() > 0 Тогда
		Элементы.Список.ТекущаяСтрока = МассивСсылок[0];
		ПоказатьЗначение(, МассивСсылок[0]);
	Иначе
		ШтрихкодированиеПечатныхФормКлиент.ОбъектНеНайден(Данные.Штрихкод);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура УстановитьУсловноеОформление()

	Документы.ДвижениеПродукцииИМатериалов.УстановитьУсловноеОформлениеОперации(Список.УсловноеОформление);

КонецПроцедуры

&НаСервере
Процедура ИнициализацияФормыПриСозданииНаСервере()
	
	ДоступныеХозяйственныеОперации = Документы.ДвижениеПродукцииИМатериалов.СписокОпераций();
	
	УстановитьОтборПоПодразделению(ЭтаФорма); //Для инициализации параметров дин списка.
	
	ОтборыСписковКлиентСервер.СкопироватьСписокВыбораОтбораПоМенеджеру(
		Элементы.ОтборОтветственный.СписокВыбора,
		ОбщегоНазначенияУТ.ПолучитьСписокПользователейСПравомДобавления(Метаданные.Документы.ДвижениеПродукцииИМатериалов));
		
	Если ПравоДоступа("ИнтерактивноеДобавление", Метаданные.Документы.ДвижениеПродукцииИМатериалов) Тогда
		
		Для Индекс = 0 По ДоступныеХозяйственныеОперации.Количество() - 1 Цикл
		
			Представление = ДоступныеХозяйственныеОперации.Получить(Индекс).Представление;
			Значение      = ДоступныеХозяйственныеОперации.Получить(Индекс).Значение;
			
			ИмяКоманды = "Создать_" + Индекс;
			НайденнаяКоманда = Команды.Найти(ИмяКоманды);
			
			Если НайденнаяКоманда = Неопределено Тогда
				НоваяКоманда = Команды.Добавить(ИмяКоманды);
				НоваяКоманда.Действие = "Подключаемый_СоздатьДокумент";
			Иначе
				НоваяКоманда = НайденнаяКоманда;
			КонецЕсли;
			
			ЭлементКнопкаПодменю = Элементы.Добавить(ИмяКоманды, Тип("КнопкаФормы"), Элементы.СписокДокументыГруппаСоздать);
			ЭлементКнопкаПодменю.Вид = ВидКнопкиФормы.КнопкаКоманднойПанели;
			ЭлементКнопкаПодменю.ИмяКоманды = НоваяКоманда.Имя;
			ЭлементКнопкаПодменю.Заголовок = Представление;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоПодразделению(Форма)

	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Форма.Список,
		"ПолучательИлиОтправитель",
		Форма.ОтборПодразделение);

	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Форма.Список,
		"ИспользоватьПолучательИлиОтправитель",
		НЕ Форма.ОтборПодразделение.Пустая());
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоОперации(Форма)

	ЗаполнитьПредставлениеОтбораПоОперации(Форма);
	
	ВыбранныеОперации = Новый СписокЗначений;
	Для каждого ЭлементКоллекции Из Форма.ДоступныеХозяйственныеОперации Цикл
		Если ЭлементКоллекции.Пометка Тогда
			ВыбранныеОперации.Добавить(ЭлементКоллекции.Значение);
		КонецЕсли; 
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Форма.Список,
		"ХозяйственнаяОперация",
		ВыбранныеОперации,
		ВидСравненияКомпоновкиДанных.ВСписке,,
		ВыбранныеОперации.Количество() <> 0);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоОтветственному(Форма)

	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Форма.Список,
		"Ответственный",
		Форма.ОтборОтветственный,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(Форма.ОтборОтветственный));

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоСтатусу(Форма)

	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Форма.Список,
		"Статус",
		Форма.ОтборСтатус,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(Форма.ОтборСтатус));

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьПредставлениеОтбораПоОперации(Форма)
	
	Форма.ОтборОперация = "";
	Для Каждого ЭлементСписка Из Форма.ДоступныеХозяйственныеОперации Цикл
		Если ЭлементСписка.Пометка Тогда
			Представление = ?(ПустаяСтрока(ЭлементСписка.Представление), ЭлементСписка.Значение, ЭлементСписка.Представление);
			Форма.ОтборОперация = Форма.ОтборОперация +
				?(ЗначениеЗаполнено(Форма.ОтборОперация), ", ", "") + Представление;
		КонецЕсли;
	КонецЦикла;
		
КонецПроцедуры

#КонецОбласти

#КонецОбласти
