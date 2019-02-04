#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	//++ НЕ УТ
	ТребуетсяКонтрольГОЗ = Ложь;
	Если Параметры.Свойство("ТребуетсяКонтрольГОЗ") Тогда
		ТребуетсяКонтрольГОЗ = Параметры.ТребуетсяКонтрольГОЗ;
	КонецЕсли;
	
	Если Не ТребуетсяКонтрольГОЗ Тогда
	//-- НЕ УТ
		ЗагрузитьСозданныеДокументы();
	//++ НЕ УТ
	Иначе
		Заголовок = НСтр("ru='Контроль заявок на расходование денежных средств'");
		ДокументыКСозданию = ДенежныеСредстваСервер.ДокументыКСозданию(
			ПолучитьИзВременногоХранилища(Параметры.АдресСтрокГрафика),
			"СписаниеБезналичныхДенежныхСредств",
			Ложь);
		ЗаполнитьТаблицуЗаявок(ДокументыКСозданию);
		ПровестиКонтрольГОЗ();
		ПереключитьОтборКонтроля();
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаКонтроль;
	КонецЕсли;
	//-- НЕ УТ
	
	СозданныеДокументы.Параметры.УстановитьЗначениеПараметра("ИдОбъектаПоступлениеБезналичныхДС",
		ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.ПоступлениеБезналичныхДенежныхСредств"));
	СозданныеДокументы.Параметры.УстановитьЗначениеПараметра("ИдОбъектаСписаниеБезналичныхДС",
		ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.СписаниеБезналичныхДенежныхСредств"));
	СозданныеДокументы.Параметры.УстановитьЗначениеПараметра("ИдОбъектаПКО",
		ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.ПриходныйКассовыйОрдер"));
	СозданныеДокументы.Параметры.УстановитьЗначениеПараметра("ИдОбъектаРКО",
		ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.РасходныйКассовыйОрдер"));
	СозданныеДокументы.Параметры.УстановитьЗначениеПараметра("ИдОбъектаЗаявка",
		ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.ЗаявкаНаРасходованиеДенежныхСредств"));
	
	УправлениеЭлементамиФормы();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	СписокТипов = СозданныеДокументы.КомпоновщикНастроек.Настройки.Выбор.ДоступныеПоляВыбора.НайтиПоле(Новый ПолеКомпоновкиДанных("Ссылка")).Тип;
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.Источники = СписокТипов;
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаКомандыСпискаДокументов;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ЭлектронноеВзаимодействие.ОбменСБанками
	ОбменСБанками.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюЭДО);
	// Конец ЭлектронноеВзаимодействие.ОбменСБанками
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ПоступлениеБезналичныхДенежныхСредств"
		Или ИмяСобытия = "Запись_СписаниеБезналичныхДенежныхСредств"
		Или ИмяСобытия = "Запись_ПриходныйКассовыйОрдер"
		Или ИмяСобытия = "Запись_РасходныйКассовыйОрдер"
		Или ИмяСобытия = "Запись_ОперацияПоПлатежнойКарте" Тогда
		
		Элементы.СозданныеДокументы.Обновить();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Не ЗакрытьБезВопроса Тогда
		СтандартнаяОбработка = Ложь;
		Отказ = Истина;
		Если ЗавершениеРаботы Тогда
			ТекстПредупреждения = НСтр("ru = 'Данные были изменены. Все изменения будут потеряны.'");
			Возврат;
		КонецЕсли;
		
		Кнопки = Новый СписокЗначений();
		Кнопки.Добавить(КодВозвратаДиалога.ОК, НСтр("ru = 'Закрыть'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru = 'Отмена'"));
		
		ТекстВопроса = НСтр("ru = 'Работа по созданию документов не была завершена. Закрыть форму?'");
		ПоказатьВопрос(Новый ОписаниеОповещения("ВопросОЗакрытии", ЭтотОбъект), ТекстВопроса, Кнопки);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Провести(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиДокументы(Элементы.СозданныеДокументы, Заголовок);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьИУдалить(Команда)
	
	ДлительнаяОперация = НачатьУдалениеСозданныхДокументов();
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.Вставить("ТекстСообщения", НСтр("ru = 'Удаление платежных документов...'"));
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриЗавершенииУдаленияСозданныхДокументов", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОписаниеОповещения, ПараметрыОжидания);
	
КонецПроцедуры

&НаКлиенте
Процедура ПринятьИЗакрыть(Команда)
	
	ВопросНепроведенныеДокументы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПринятьИВыгрузить(Команда)
	
	ВопросНепроведенныеДокументы(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтметитьВсе(Команда)
	
	Для Каждого Заявка Из Заявки Цикл
		Заявка.Пометка = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьОтметки(Команда)
	
	Для Каждого Заявка Из Заявки Цикл
		Заявка.Пометка = Ложь;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПоРезультатамКонтроляПриИзменении(Элемент)
	
	ОтборЗаявок = Неопределено;
	Если ОтборПоРезультатамКонтроля = 0 Тогда
		ОтборЗаявок = Новый ФиксированнаяСтруктура("КонтрольПройден", Ложь);
	ИначеЕсли ОтборПоРезультатамКонтроля = 1 Тогда
		ОтборЗаявок = Новый ФиксированнаяСтруктура("КонтрольПройден", Истина);
	КонецЕсли;
	
	Элементы.Заявки.ОтборСтрок = ОтборЗаявок;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьПлатежи(Команда)
	
	ДлительнаяОперация = СформироватьПлатежиНаСервере();
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриЗавершенииСозданияПлатежныхДокументов", ЭтотОбъект);
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтаФорма);
	ПараметрыОжидания.Вставить("ТекстСообщения", НСтр("ru = 'Создание платежных документов...'"));
	ПараметрыОжидания.Вставить("ВыводитьПрогрессВыполнения", Истина);
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОписаниеОповещения, ПараметрыОжидания);
	
КонецПроцедуры

&НаСервере
Функция СформироватьПлатежиНаСервере()
	
	ДокументыКСозданию = Новый Массив;
	
	СтрокиКОплате = Заявки.НайтиСтроки(Новый Структура("Пометка", Истина));
	ТаблицаДокументов = Заявки.Выгрузить(СтрокиКОплате);
	
	Для каждого СтрокаДокумента Из ТаблицаДокументов Цикл
		
		Если ТипЗнч(СтрокаДокумента.Ссылка) = Тип("ДокументСсылка.ЗаявкаНаРасходованиеДенежныхСредств") Тогда
			ДанныеЗаполнения = Новый Структура;
			ДанныеЗаполнения.Вставить("ДокументОснование", СтрокаДокумента.Ссылка);
			ДанныеЗаполнения.Вставить("НесколькоЗаявокНаРасходованиеСредств", Истина);
			ДанныеЗаполнения.Вставить("БанковскийСчетКасса", СтрокаДокумента.БанковскийСчет);
			ДанныеЗаполнения.Вставить("ПлательщикПолучатель", СтрокаДокумента.ПлательщикПолучатель);
			ДанныеЗаполнения.Вставить("ХозяйственнаяОперация", СтрокаДокумента.ХозяйственнаяОперация);
			ДанныеЗаполнения.Вставить("Сумма", СтрокаДокумента.СуммаКОплате);
			ДанныеЗаполнения.Вставить("Валюта", СтрокаДокумента.Валюта);
		Иначе
			ДанныеЗаполнения = СтрокаДокумента.Ссылка;
		КонецЕсли;
		
		ДокументКСозданию = Новый Структура;
		ДокументКСозданию.Вставить("ТипДокумента", "СписаниеБезналичныхДенежныхСредств");
		ДокументКСозданию.Вставить("ДанныеЗаполнения", ДанныеЗаполнения);
		ДокументыКСозданию.Добавить(ДокументКСозданию);
	КонецЦикла;
	
	НаименованиеЗадания = НСтр("ru = 'Формирование платежных документов'");
	ВыполняемыйМетод = "ДенежныеСредстваСервер.СоздатьПлатежи";
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ДокументыКСозданию", ДокументыКСозданию);
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ВыполняемыйМетод, СтруктураПараметров, ПараметрыВыполнения);
	
КонецФункции

&НаКлиенте
Процедура ПриЗавершенииСозданияПлатежныхДокументов(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Ошибка" Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Результат.КраткоеПредставлениеОшибки);
		Возврат;
	ИначеЕсли Результат.Статус = "Выполнено" Тогда
		ПриЗавершенииСозданияПлатежныхДокументовНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗавершенииСозданияПлатежныхДокументовНаСервере()
	
	ЗагрузитьСозданныеДокументы();
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

// ЭлектронноеВзаимодействие.ОбменСКонтрагентами

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуЭДО(Команда)
	
	ЭлектронноеВзаимодействиеКлиент.ВыполнитьПодключаемуюКомандуЭДО(Команда, ЭтаФорма, Элементы.СозданныеДокументы);
	
КонецПроцедуры

// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами

&НаКлиенте
Процедура СинхронизироватьСБанком(Команда)
	
	// ЭлектронноеВзаимодействие.ОбменСБанками
	ОбменСБанкамиКлиент.СинхронизироватьСБанком();
	// Конец ЭлектронноеВзаимодействие.ОбменСБанками
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.СозданныеДокументы);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.СозданныеДокументы, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.СозданныеДокументы);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ЗаявкиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ПоказатьЗначение(, Элементы.Заявки.ТекущиеДанные.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаявкиПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		Элементы.РезультатыКонтроля.ОтборСтрок = Новый ФиксированнаяСтруктура("Ссылка", Элемент.ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СозданныеДокументыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбщегоНазначенияУТКлиент.ИзменитьЭлемент(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СозданныеДокументыПриАктивизацииСтроки(Элемент)
	
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатыКонтроляДокументаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ПоказатьЗначение(, Элементы.РезультатыКонтроля.ТекущиеДанные.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "СозданныеДокументы.Дата", "СозданныеДокументыДата");
	
КонецПроцедуры

&НаСервере
Процедура УправлениеЭлементамиФормы()
	
	ЭтапКонтроля = (Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаКонтроль);
	
	Элементы.Закрыть.Видимость = ЭтапКонтроля;
	Элементы.ОтменитьИУдалить.Видимость = Не ЭтапКонтроля;
	Элементы.СформироватьПлатежи.Видимость = ЭтапКонтроля;
	Элементы.ПринятьИЗакрыть.Видимость = Не ЭтапКонтроля;
	Элементы.ПринятьИВыгрузить.Видимость = Не ЭтапКонтроля И ЕстьПлатежныеПоручения;
	
	Если Не ЭтапКонтроля И ЕстьПлатежныеПоручения Тогда
		Элементы.ПринятьИВыгрузить.КнопкаПоУмолчанию = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьСписок()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СозданныеДокументы,
		"Ссылка",
		СписокДокументов,
		ВидСравненияКомпоновкиДанных.ВСписке,,
		Истина);
		
	ОбъектыМетаданных = Новый Массив;
	Для каждого ТекСтрока Из СписокДокументов Цикл
		ОбъектМетаданных = Метаданные.НайтиПоТипу(ТипЗнч(ТекСтрока.Значение));
		Если ОбъектМетаданных = Метаданные.Документы.СписаниеБезналичныхДенежныхСредств Тогда
			ЕстьПлатежныеПоручения = Истина;
		КонецЕсли;
		ОбъектыМетаданных.Добавить(ОбъектМетаданных);
	КонецЦикла;
	ОбъектыМетаданных = ОбщегоНазначенияКлиентСервер.СвернутьМассив(ОбъектыМетаданных);
	
	Если ОбъектыМетаданных.Найти(Метаданные.Документы.ПриходныйКассовыйОрдер) <> Неопределено
		Или ОбъектыМетаданных.Найти(Метаданные.Документы.РасходныйКассовыйОрдер) <> Неопределено Тогда
		ОплатаНаличными = Истина;
	КонецЕсли;
	
	Если ОбъектыМетаданных.Найти(Метаданные.Документы.ПриходныйКассовыйОрдер) <> Неопределено
		Или ОбъектыМетаданных.Найти(Метаданные.Документы.ПоступлениеБезналичныхДенежныхСредств) <> Неопределено Тогда
		ДокументыПоступления = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция НачатьУдалениеСозданныхДокументов()
	
	ВыполняемыйМетод = "ДенежныеСредстваСервер.УдалитьПлатежи";
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	Возврат ДлительныеОперации.ВыполнитьВФоне(ВыполняемыйМетод, СписокДокументов.ВыгрузитьЗначения(), ПараметрыВыполнения);
	
КонецФункции

&НаКлиенте
Процедура ПриЗавершенииУдаленияСозданныхДокументов(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Ошибка" Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Результат.КраткоеПредставлениеОшибки);
		Возврат;
	КонецЕсли;
	
	СписокОшибок = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
	Если ЗначениеЗаполнено(СписокОшибок) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(СписокОшибок);
		Элементы.СозданныеДокументы.Обновить();
	Иначе
		ЗакрытьБезВопроса = Истина;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросНепроведенныеДокументы(ВыгрузкаВБанк = Ложь)
	
	Если ЕстьНепроведенныеДокументы() Тогда
		Кнопки = Новый СписокЗначений();
		Кнопки.Добавить(КодВозвратаДиалога.Да);
		Кнопки.Добавить(КодВозвратаДиалога.Нет);
		ТекстВопроса = НСтр("ru='Некоторые документы не были проведены. Вы уверены, что хотите оставить документы непроведенными?'");
		ОписаниеОповещения = Новый ОписаниеОповещения("ВопросОЗакрытииНепроведенныеДокументы", ЭтотОбъект, ВыгрузкаВБанк);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Кнопки);
	Иначе
		Если ВыгрузкаВБанк Тогда
			ПараметрыКлиентБанка = Новый Структура("АдресДокументовДляВыгрузки", АдресДокументовДляВыгрузки());
			ОткрытьФорму("Обработка.КлиентБанк.Форма.ВыгрузкаВБанк",
				ПараметрыКлиентБанка,
				ЭтаФорма.ВладелецФормы,,,,,
				РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		КонецЕсли;
		ЗакрытьБезВопроса = Истина;
		Закрыть(Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросОЗакрытииНепроведенныеДокументы(РезультатВопроса, ВыгрузкаВБанк) Экспорт
	
	Ответ = РезультатВопроса;
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;
	ИначеЕсли Ответ = КодВозвратаДиалога.Да Тогда
		Если ВыгрузкаВБанк Тогда
			ПараметрыКлиентБанка = Новый Структура("АдресДокументовДляВыгрузки", АдресДокументовДляВыгрузки());
			ОткрытьФорму("Обработка.КлиентБанк.Форма.ВыгрузкаВБанк",
				ПараметрыКлиентБанка,
				ЭтаФорма.ВладелецФормы,,,,,
				РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		КонецЕсли;
		ЗакрытьБезВопроса = Истина;
		Закрыть(Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросОЗакрытии(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Ответ = РезультатВопроса;
	Если Ответ = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	ИначеЕсли Ответ = КодВозвратаДиалога.ОК Тогда
		ЗакрытьБезВопроса = Истина;
		Закрыть(Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЕстьНепроведенныеДокументы()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	1
	|ИЗ
	|	РегистрСведений.РеестрДокументов КАК Платежи
	|ГДЕ
	|	НЕ Платежи.Проведен
	|	И Платежи.Ссылка В (&СписокДокументов)
	|");
	
	Запрос.УстановитьПараметр("СписокДокументов", СписокДокументов);
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

&НаСервере
Функция АдресДокументовДляВыгрузки()
	
	СКД = Элементы.СозданныеДокументы.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	Настройки = Элементы.СозданныеДокументы.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	Настройки.Структура.Очистить();
	ДетальныеЗаписи = Настройки.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	ДетальныеЗаписи.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных")).Поле = Новый ПолеКомпоновкиДанных("Ссылка");
	ДетальныеЗаписи.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных")).Поле = Новый ПолеКомпоновкиДанных("БанковскийСчет");
	РезультатСКД = ФинансоваяОтчетностьСервер.ВыгрузитьРезультатСКД(СКД, Настройки);
	
	Возврат ПоместитьВоВременноеХранилище(РезультатСКД, УникальныйИдентификатор);
	
КонецФункции

&НаСервереБезКонтекста
Функция ПрочитатьДанныеИзБезопасногоХранилища()
	
	Владелец = Пользователи.АвторизованныйПользователь();
	УстановитьПривилегированныйРежим(Истина);
	ЗащищенныеДанные = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Владелец, "ПомощникФормированияПлатежныхДокументов");
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ЗащищенныеДанные;
	
КонецФункции

&НаСервереБезКонтекста
Процедура УдалитьДанныеИзБезопасногоХранилища()
	
	Владелец = Пользователи.АвторизованныйПользователь();
	УстановитьПривилегированныйРежим(Истина);
	ОбщегоНазначения.УдалитьДанныеИзБезопасногоХранилища(Владелец, "ПомощникФормированияПлатежныхДокументов");
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовок()
	
	КоличествоДокументов = СписокДокументов.Количество();
	
	СклонениеСоздано = НСтр("ru = 'Создан, Создано, Создано'");
	Создано = СтроковыеФункцииКлиентСервер.ЧислоЦифрамиПредметИсчисленияПрописью(КоличествоДокументов, СклонениеСоздано);
	Создано = СтрЗаменить(Создано, КоличествоДокументов + " ", "");
	
	СклонениеДокументов = НСтр("ru = 'документ, документа, документов'");
	Документов = СтроковыеФункцииКлиентСервер.ЧислоЦифрамиПредметИсчисленияПрописью(КоличествоДокументов, СклонениеДокументов);
	
	Заголовок = Создано + " " + Документов;
	
	Если ДокументыПоступления Тогда
		Элементы.СозданныеДокументыПолучательПлательщик.Заголовок = НСтр("ru = 'Плательщик'");
	Иначе
		Элементы.СозданныеДокументыПолучательПлательщик.Заголовок = НСтр("ru = 'Получатель'");
	КонецЕсли;
	
	Если ОплатаНаличными Тогда
		Элементы.СозданныеДокументыБанковскийСчетКасса.Заголовок = НСтр("ru = 'Касса'");
	Иначе
		Элементы.СозданныеДокументыБанковскийСчетКасса.Заголовок = НСтр("ru = 'Банковский счет'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьСозданныеДокументы()
	
	АдресДокументов = ПрочитатьДанныеИзБезопасногоХранилища();
	Если ЗначениеЗаполнено(АдресДокументов) Тогда
		УдалитьДанныеИзБезопасногоХранилища();
	Иначе
		ВызватьИсключение НСтр("ru='При создании документов произошла исключительная ситуация. Обратитесь к администратору системы.'");
		Возврат;
	КонецЕсли;
	СписокДокументов.ЗагрузитьЗначения(ПолучитьИзВременногоХранилища(АдресДокументов));
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаСозданныеДокументы;
	ЗагрузитьСписок();
	УстановитьЗаголовок();
	
КонецПроцедуры

//++ НЕ УТ
&НаСервере
Процедура ЗаполнитьТаблицуЗаявок(ДокументыКСозданию)
	
	Для каждого ДокументКСозданию Из ДокументыКСозданию Цикл
		
		ДанныеЗаполнения = ДокументКСозданию.ДанныеЗаполнения;
		
		Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура")
			И (ТипЗнч(ДанныеЗаполнения.ДокументОснование[0]) = Тип("ДокументСсылка.ЗаявкаНаРасходованиеДенежныхСредств")
				Или ТипЗнч(ДанныеЗаполнения.ДокументОснование[0]) = Тип("ДокументСсылка.РаспоряжениеНаПеремещениеДенежныхСредств")) Тогда
			НоваяЗаявка = Заявки.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяЗаявка, ДанныеЗаполнения);
			НоваяЗаявка.Ссылка = ДанныеЗаполнения.ДокументОснование[0];
			НоваяЗаявка.БанковскийСчет = ДанныеЗаполнения.БанковскийСчетКасса;
			НоваяЗаявка.СуммаКОплате = ДанныеЗаполнения.Сумма;
			
			СписокЗаявок.Добавить(НоваяЗаявка.Ссылка);
		КонецЕсли;
	КонецЦикла;
	
	НазначенияПлатежей = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(СписокЗаявок.ВыгрузитьЗначения(), "НазначениеПлатежа");
	
	Для каждого Заявка Из Заявки Цикл
		Заявка.НазначениеПлатежа = НазначенияПлатежей[Заявка.Ссылка];
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПровестиКонтрольГОЗ()
	
	РезультатыКонтроля.Очистить();
	ДанныеДляКонтроля = ДенежныеСредстваСервер.ДанныеДокументовДляКонтроля(СписокЗаявок.ВыгрузитьЗначения());
	
	Для каждого Заявка Из Заявки Цикл
		ПровестиКонтрольДокумента275ФЗ(Заявка.Ссылка, ДанныеДляКонтроля);
		СводныеПоказатели = СводныеПоказателиКонтроляПоДокументу(Заявка);
		ЗаполнитьРеквизитыКонтроля(Заявка, СводныеПоказатели);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПереключитьОтборКонтроля()
	
	Если РезультатыКонтроля.НайтиСтроки(Новый Структура("КонтрольПройден", Ложь)).Количество() Тогда
		ОтборПоРезультатамКонтроля = 0;
		Элементы.Заявки.ОтборСтрок = Новый ФиксированнаяСтруктура("КонтрольПройден", Ложь);
	Иначе
		ОтборПоРезультатамКонтроля = 2;
		Элементы.Заявки.ОтборСтрок = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПровестиКонтрольДокумента275ФЗ(Заявка, Знач ДанныеДляКонтроля)
	
	Перем КонтрольДокумента, ОписаниеРезультата;
	
	КонтрольДокумента = ДенежныеСредстваСервер.КонтрольДокумента(Заявка, ДанныеДляКонтроля);
	
	Если КонтрольДокумента.ВсеКонтролиПройдены Тогда
		ДобавитьРезультатКонтроля(Заявка,
			НСтр("ru = 'Платежный документ может быть сформирован'"),
			КонтрольДокумента.ВсеКонтролиПройдены);
	Иначе
		Для Каждого ОписаниеРезультата Из КонтрольДокумента.ОписанияРезультатов Цикл
			Если Не ОписаниеРезультата.КонтрольПройден Тогда
				ДобавитьРезультатКонтроля(Заявка,
					ОписаниеРезультата.Описание,
					ОписаниеРезультата.КонтрольПройден);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьРезультатКонтроля(Ссылка, РезультатКонтроля, КонтрольПройден)
	
	Отбор = Новый Структура("Ссылка, РезультатКонтроля, КонтрольПройден", Ссылка, РезультатКонтроля, КонтрольПройден);
	СтрокиПроверки = РезультатыКонтроля.НайтиСтроки(Отбор);
	
	Если СтрокиПроверки.Количество() = 0 Тогда
		НовыйРезультат = РезультатыКонтроля.Добавить();
		НовыйРезультат.Ссылка = Ссылка;
		НовыйРезультат.РезультатКонтроля = РезультатКонтроля;
		НовыйРезультат.КартинкаКонтроля = ?(КонтрольПройден, 1, 4);
		НовыйРезультат.КонтрольПройден = КонтрольПройден;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыКонтроля(ДанныеЗаполнения, СводныеПоказателиКонтроля)
	
	ДанныеЗаполнения.КоличествоОшибок = СводныеПоказателиКонтроля.КоличествоОшибок;
	
	РезультатКонтроля = "";
	Если СводныеПоказателиКонтроля.КоличествоОшибок = 0 Тогда
		РезультатКонтроля = НСтр("ru = 'Контроль пройден'");
	ИначеЕсли СводныеПоказателиКонтроля.КоличествоОшибок = 1 Тогда
		РезультатКонтроля = СводныеПоказателиКонтроля.РезультатКонтроля;
	Иначе
		РезультатКонтроля = НСтр("ru = 'См. ""Результаты контроля""'");
	КонецЕсли;
	
	ДанныеЗаполнения.КонтрольПройден = СводныеПоказателиКонтроля.КонтрольПройден;
	ДанныеЗаполнения.Пометка = СводныеПоказателиКонтроля.КонтрольПройден;
	ДанныеЗаполнения.РезультатКонтроля = РезультатКонтроля;
	ДанныеЗаполнения.КартинкаКонтроля = ?(СводныеПоказателиКонтроля.КонтрольПройден, 1, 4);
	
КонецПроцедуры

&НаСервере
Функция СводныеПоказателиКонтроляПоДокументу(Заявка)
	
	СводныеПоказатели = Новый Структура("КоличествоОшибок, КоличествоВсе, КонтрольПройден, РезультатКонтроля"); 
	
	Отбор = Новый Структура("Ссылка");
	ЗаполнитьЗначенияСвойств(Отбор, Заявка.Ссылка);
	СтрокиКонтроляВсе = РезультатыКонтроля.НайтиСтроки(Отбор);
	
	ОтборКонтрольНеПройден = Новый Структура("Ссылка, КонтрольПройден");
	ЗаполнитьЗначенияСвойств(ОтборКонтрольНеПройден, Заявка);
	ОтборКонтрольНеПройден.Вставить("КонтрольПройден", Ложь);
	СтрокиКонтроляКонтрольНеПройден = РезультатыКонтроля.НайтиСтроки(ОтборКонтрольНеПройден);
	
	КоличествоВсе = СтрокиКонтроляВсе.Количество();
	КоличествоОшибок = СтрокиКонтроляКонтрольНеПройден.Количество();
	
	КонтрольПройден = (КоличествоОшибок = 0);
	
	СводныеПоказатели.Вставить("КоличествоВсе", КоличествоВсе);
	СводныеПоказатели.Вставить("КоличествоОшибок", КоличествоОшибок);
	СводныеПоказатели.Вставить("КонтрольПройден", КонтрольПройден);
	СводныеПоказатели.Вставить("РезультатКонтроля", 
		?(СтрокиКонтроляКонтрольНеПройден.Количество() = 1, СтрокиКонтроляКонтрольНеПройден[0].РезультатКонтроля, ""));
	
	Возврат СводныеПоказатели;
	
КонецФункции
//-- НЕ УТ

#КонецОбласти