
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Ответственный = Пользователи.АвторизованныйПользователь();
	УстановитьОтборВСпискеПоЭлементуКлиентСервер(Список, "Ответственный", Ответственный);
	
	ОтветственныйИсх = Ответственный;
	УстановитьОтборВСпискеПоЭлементуКлиентСервер(СписокИсх, "Ответственный", ОтветственныйИсх);
	
	СтатусНеРаспакованногоПакета = Перечисления.СтатусыПакетовЭД.КРаспаковке;
	УстановитьОтборВСпискеПоЭлементуКлиентСервер(НераспакованныеПакеты, "Статус", СтатусНеРаспакованногоПакета);
	
	СтатусНеОтправленногоПакета = Перечисления.СтатусыПакетовЭД.ПодготовленКОтправке;
	УстановитьОтборВСпискеПоЭлементуКлиентСервер(НеотправленныеПакеты, "Статус", СтатусНеОтправленногоПакета);
	
	ЗаполнитьСпискиВыбораВидовДокументов();
	
	ИзменитьВидимостьДоступностьНаСервере();
	
	НавигационнаяСсылка = "e1cib/app/" + ЭтотОбъект.ИмяФормы;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ОтборПоЭлементуПриЗагрузкеИзНастроек(ЭтотОбъект, Список, "ВидЭД",    Настройки);
	ОтборПоЭлементуПриЗагрузкеИзНастроек(ЭтотОбъект, Список, "СостояниеЭДО", Настройки);
	
	ОтборПоЭлементуПриЗагрузкеИзНастроек(ЭтотОбъект, СписокИсх, "ВидЭДИсх",    Настройки);
	ОтборПоЭлементуПриЗагрузкеИзНастроек(ЭтотОбъект, СписокИсх, "СостояниеЭДОИсх", Настройки);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьСостояниеЭД" Тогда
		
		Элементы.Список.Обновить();
		Элементы.СписокИсх.Обновить();
		Элементы.СписокНераспакованныеПакеты.Обновить();
		Элементы.СписокНеотправленныеПакеты.Обновить();
		Элементы.ВсеПакеты.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если Элемент.ТекущиеДанные <> Неопределено Тогда		
		ОбменСКонтрагентамиСлужебныйКлиент.ОткрытьЭДДляПросмотра(ВыбраннаяСтрока);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйПриИзменении(Элемент)
	
	УстановитьОтборВСпискеПоЭлементуКлиентСервер(Список, "Ответственный", Ответственный);
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусЭДПриИзменении(Элемент)
	
	УстановитьОтборВСпискеПоЭлементуКлиентСервер(Список, "СостояниеЭДО", СостояниеЭДО);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентНеРаспакованногоПакетаПриИзменении(Элемент)
	
	УстановитьОтборВСпискеПоЭлементуКлиентСервер(НераспакованныеПакеты, "Контрагент", КонтрагентНеРаспакованногоПакета);
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусНеРаспакованногоПакетаПриИзменении(Элемент)
	
	УстановитьОтборВСпискеПоЭлементуКлиентСервер(НераспакованныеПакеты, "Статус", СтатусНеРаспакованногоПакета);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентНеотправленногоПакетаПриИзменении(Элемент)
	
	УстановитьОтборВСпискеПоЭлементуКлиентСервер(НеотправленныеПакеты, "Контрагент", КонтрагентНеОтправленногоПакета);
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусНеОтправленногоПакетаПриИзменении(Элемент)
	
	УстановитьОтборВСпискеПоЭлементуКлиентСервер(НеотправленныеПакеты, "Статус", СтатусНеОтправленногоПакета);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйИсхПриИзменении(Элемент)
	
	УстановитьОтборВСпискеПоЭлементуКлиентСервер(СписокИсх, "Ответственный", ОтветственныйИсх);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидЭДПриИзменении(Элемент)
	
	УстановитьОтборВСпискеПоВидуЭлектронногоДокумента("Список", "ВидЭД");
	
КонецПроцедуры

&НаКлиенте
Процедура ВидЭДИсхПриИзменении(Элемент)
	
	УстановитьОтборВСпискеПоВидуЭлектронногоДокумента("СписокИсх", "ВидЭДИсх");
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусЭДИсхПриИзменении(Элемент)
	
	УстановитьОтборВСпискеПоЭлементуКлиентСервер(СписокИсх, "СостояниеЭДО", СостояниеЭДОИсх);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьОтветственного(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВыборГруппПользователей", Ложь);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе",      Истина);
	ПараметрыФормы.Вставить("РежимВыбора",             Истина);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработатьВыборОтветственного", ЭтотОбъект);
	НовыйОтветственный = ОткрытьФорму("Справочник.Пользователи.ФормаВыбора", ПараметрыФормы, ЭтотОбъект,
		УникальныйИдентификатор, , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура СравнитьДанныеВходящихЭД(Команда)
	
	СравнитьДанныеЭД(Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура СравнитьДанныеИсходящихЭД(Команда)
	
	СравнитьДанныеЭД(Элементы.СписокИсх);
	
КонецПроцедуры

&НаКлиенте
Процедура Распаковать(Команда)
	
	// Распаковываем только выделенные строки
	ОбменСКонтрагентамиСлужебныйКлиент.РаспаковатьПакетыЭДНаКлиенте(Элементы.СписокНераспакованныеПакеты.ВыделенныеСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура Отправить(Команда)
	
	// Отправить только выделенные строки
	МассивЭД = Элементы.СписокНеотправленныеПакеты.ВыделенныеСтроки; 
	
	ОбработкаОповещения = Новый ОписаниеОповещения("КомандаОтправитьОповещение", ЭтотОбъект);
	
	ОбменСКонтрагентамиСлужебныйКлиент.ОтправитьМассивПакетовЭД(МассивЭД, ОбработкаОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтправитьОповещение(КолОтправленныхПакетов, ДополнительныеПараметры) Экспорт
	
	ЗаголовокОповещения = НСтр("ru = 'Обмен электронными документами'");
	ТекстОповещения     = НСтр("ru = 'Отправленных пакетов нет'");
	
	Если ЗначениеЗаполнено(КолОтправленныхПакетов) Тогда
	
		ТекстОповещения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Отправлено пакетов: (%1)'"), КолОтправленныхПакетов);
	КонецЕсли;
	
	ПоказатьОповещениеПользователя(ЗаголовокОповещения, , ТекстОповещения);
	
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусКРаспаковке(Команда)
	
	ТаблицаПакетов = "СписокНеРаспакованныеПакеты";
	Количество = 0;
	УстановитьСтатусПакетов(ТаблицаПакетов, ПредопределенноеЗначение("Перечисление.СтатусыПакетовЭД.КРаспаковке"), Количество);
	
	ТекстОповещения = НСтр("ru = 'Изменен статус пакетов на ""К распаковке""'") + ": (%1)";
	ТекстОповещения = СтрЗаменить(ТекстОповещения, "%1", Количество);
	
	ПоказатьОповещениеПользователя(НСтр("ru = 'Обмен электронными документами'"), , ТекстОповещения);
	Элементы[ТаблицаПакетов].Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусОтменен(Команда)
	
	Если Команда.Имя = "УстановитьСтатусОтмененНеРаспакованныеПакеты" Тогда
		ТаблицаПакетов = "СписокНеРаспакованныеПакеты";
	Иначе
		ТаблицаПакетов = "СписокНеОтправленныеПакеты";
	КонецЕсли;
	
	Количество = 0;
	УстановитьСтатусПакетов(ТаблицаПакетов, ПредопределенноеЗначение("Перечисление.СтатусыПакетовЭД.Отменен"), Количество);
	ТекстОповещения = НСтр("ru = 'Изменен статус пакетов на ""Отменен""'") + ": (%1)";
	ТекстОповещения = СтрЗаменить(ТекстОповещения, "%1", Количество);
	ПоказатьОповещениеПользователя(НСтр("ru = 'Обмен электронными документами'"), , ТекстОповещения);
	Элементы[ТаблицаПакетов].Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусПодготовленКОтправке(Команда)
	
	ТаблицаПакетов = "СписокНеотправленныеПакеты";
	Количество = 0;
	УстановитьСтатусПакетов(ТаблицаПакетов, ПредопределенноеЗначение("Перечисление.СтатусыПакетовЭД.ПодготовленКОтправке"), Количество);
	ТекстОповещения = НСтр("ru = 'Изменен статус пакетов на ""Подготовлен к отправке""'" + ": (%1)");
	ТекстОповещения = СтрЗаменить(ТекстОповещения, "%1", Количество);
	ПоказатьОповещениеПользователя(НСтр("ru = 'Обмен электронными документами'"), , ТекстОповещения);
	Элементы[ТаблицаПакетов].Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьПакетыЭДНаДиск(Команда)
	
	ДанныеФайлов = ПолучитьДанныеПрисоединенныхФайловПакетовЭДНаСервере(
		Элементы.ВсеПакеты.ВыделенныеСтроки, УникальныйИдентификатор);
	
	МассивФайлов = Новый Массив;
	Для Каждого ДанныеФайла Из ДанныеФайлов Цикл
		ОписаниеФайла = Новый ОписаниеПередаваемогоФайла(
			ДанныеФайла.ИмяФайла, ДанныеФайла.СсылкаНаДвоичныеДанныеФайла);
		МассивФайлов.Добавить(ОписаниеФайла);
	КонецЦикла;
	
	Если МассивФайлов.Количество() Тогда
		Оповещение = Новый ОписаниеОповещения("СохранитьПакетыЭДНаДискПослеУстановкиРасширения", ЭтотОбъект, МассивФайлов);
		ТекстСообщения = НСтр("ru = 'Для сохранения пакетов ЭД необходимо установить расширение работы с файлами.'");
		ОбщегоНазначенияКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(Оповещение, ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьПакетыЭДНаДискПослеУстановкиРасширения(РасширениеПодключено, МассивФайлов) Экспорт
	
	Если РасширениеПодключено Тогда
		МодульЭлектронноеВзаимодействиеСлужебныйКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ЭлектронноеВзаимодействиеСлужебныйКлиент");
		
		ПустойОбработчик = Новый ОписаниеОповещения;
		НачатьПолучениеФайлов(ПустойОбработчик, МассивФайлов);
	Иначе
		ДанныеФайла = МассивФайлов[0];
		ПолучитьФайл(ДанныеФайла.Хранение, ДанныеФайла.Имя);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВходящиеВыгрузитьЭлектронныеДокументыДляФНС(Команда)
	
	ВыгрузитьОбменСКонтрагентамиДляФНС(ПредопределенноеЗначение("Перечисление.НаправленияЭД.Входящий"));
	
КонецПроцедуры

&НаКлиенте
Процедура ИсходящиеВыгрузитьЭлектронныеДокументыДляФНС(Команда)
	
	ВыгрузитьОбменСКонтрагентамиДляФНС(ПредопределенноеЗначение("Перечисление.НаправленияЭД.Исходящий"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборВСпискеПоЭлементуКлиентСервер(СписокДанных, ВидЭлемента, ЗначениеЭлемента)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокДанных, ВидЭлемента,
		ЗначениеЭлемента, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(ЗначениеЭлемента));
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборВСпискеПоВидуЭлектронногоДокумента(Знач ИмяСписка, Знач ИмяРеквизита)
	
	СписокДанных = ЭтотОбъект[ИмяСписка];
	ВидДокумента = ЭтотОбъект[ИмяРеквизита];
	ИмяГруппыОтбора = "ГруппаОтбора" + ИмяРеквизита;
	
	ГруппаБыстрыйОтбор = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(
		СписокДанных.Отбор.Элементы, ИмяГруппыОтбора, ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли);
	
	Если НЕ ЗначениеЗаполнено(ВидДокумента) Тогда
		ГруппаБыстрыйОтбор.Использование = Ложь;
		Возврат;
	КонецЕсли;
	
	ТипДокумента = Неопределено;
	Если ВидДокумента = Перечисления.ВидыЭД.СчетНаОплату Тогда
		ТипДокумента = Перечисления.ТипыЭД.СчетНаОплату;
	ИначеЕсли ВидДокумента = Перечисления.ВидыЭД.ТОРГ12Продавец Тогда
		ТипДокумента = Перечисления.ТипыЭД.ТоварнаяНакладная;
	ИначеЕсли ВидДокумента = Перечисления.ВидыЭД.АктВыполненныхРабот Тогда
		ТипДокумента = Перечисления.ТипыЭД.АктВыполненныхРабот;
	ИначеЕсли ТипЗнч(ВидДокумента) = Тип("ПеречислениеСсылка.ТипыЭД") Тогда
		ИмяРеквизита = "ТипДокумента";
	ИначеЕсли ОбменСКонтрагентамиСлужебный.ЭтоПрикладнойВидЭД(ВидДокумента) Тогда
		ИмяРеквизита = "ПрикладнойВидЭД";
	КонецЕсли;
	
	Если ТипДокумента = Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
			ГруппаБыстрыйОтбор, ИмяРеквизита, ВидСравненияКомпоновкиДанных.Равно, ВидДокумента);
	Иначе
			
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
			ГруппаБыстрыйОтбор, "ТипДокумента", ВидСравненияКомпоновкиДанных.Равно, ТипДокумента);
			
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
			ГруппаБыстрыйОтбор, ИмяРеквизита, ВидСравненияКомпоновкиДанных.Равно, ВидДокумента);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьВидимостьДоступностьНаСервере()
	
	Элементы.Пакеты.Видимость = Пользователи.ЭтоПолноправныйПользователь();
	
	#Если НЕ ТолстыйКлиентУправляемоеПриложение И НЕ ТолстыйКлиентОбычноеПриложение Тогда
		Элементы.СписокИсхСравнитьДанныеЭДИсх.Видимость = Ложь;
		Элементы.СравнитьДанныеЭДВходящие.Видимость     = Ложь;
	#КонецЕсли
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтветственногоЭД(Знач СписокОбъектов, НовыйОтветственный, КоличествоОбработанныхЭД)
	
	МассивЭД = Новый Массив();
	КоличествоОбработанных = 0;
	
	Для Каждого ЭлСписка Из СписокОбъектов Цикл
		Если ТипЗнч(ЭлСписка) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			Продолжить;
		КонецЕсли;
		МассивЭД.Добавить(ЭлСписка.Ссылка);
	КонецЦикла;
	
	Если МассивЭД.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЭДВходящий.Ссылка,
	|	ЭДВходящий.Ответственный
	|ИЗ
	|	Документ.ЭлектронныйДокументВходящий КАК ЭДВходящий
	|ГДЕ
	|	ЭДВходящий.Ссылка В(&МассивЭД)
	|	И ЭДВходящий.Ответственный <> &Ответственный";
	Запрос.УстановитьПараметр("МассивЭД", МассивЭД);
	Запрос.УстановитьПараметр("Ответственный", НовыйОтветственный);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	НачатьТранзакцию();
	Попытка
		Пока Выборка.Следующий() Цикл
			ЗаблокироватьДанныеДляРедактирования(Выборка.Ссылка);
			СтруктураПараметров = Новый Структура("Ответственный", НовыйОтветственный);
			ЭДВходящий = Выборка.Ссылка.ПолучитьОбъект();
			ЭДВходящий.Ответственный = НовыйОтветственный;
			ЭДВходящий.Записать(РежимЗаписиДокумента.Запись);
			КоличествоОбработанныхЭД = КоличествоОбработанныхЭД + 1;
		КонецЦикла;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ТекстОшибки = НСтр("ru='Не удалось выполнить запись электронного документа (%Объект%). %ОписаниеОшибки%'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Объект%", Выборка.Ссылка);
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ОписаниеОшибки%", КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение ТекстОшибки;
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура СравнитьДанныеЭД(ТекущийСписок)
	
	#Если ТолстыйКлиентУправляемоеПриложение Или ТолстыйКлиентОбычноеПриложение Тогда
		
		Если ТекущийСписок.ТекущиеДанные = Неопределено
			ИЛИ ТекущийСписок.ВыделенныеСтроки.Количество() <> 2 Тогда
			Возврат;
		КонецЕсли;
		
		ТекущийЭД    = ТекущийСписок.ВыделенныеСтроки.Получить(0);
		ПослВерсияЭД = ТекущийСписок.ВыделенныеСтроки.Получить(1);
		
		Если Не (ЗначениеЗаполнено(ТекущийЭД) И ЗначениеЗаполнено(ПослВерсияЭД)) Тогда
			ТекстСообщения = НСтр("ru='Не указан один из сравниваемых электронных документов.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Возврат;
		КонецЕсли;
		
		ИмяФайла = ПолучитьИмяВременногоФайла("mxl");
		ПереченьВременныхФайлов = ВременныеФайлыЭД(ТекущийЭД, ПослВерсияЭД);
		
		Если ПереченьВременныхФайлов = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		// Необходимо заменить фрагмент от последнего подчеркивания до фрагмента ".mxl".
		ДлинаСтроки = СтрДлина(ИмяФайла);
		Для ОбратныйИндекс = 0 По ДлинаСтроки Цикл
			Если Сред(ИмяФайла, ДлинаСтроки - ОбратныйИндекс, 1) = "_" Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		НазваниеЭД = ПереченьВременныхФайлов[0].НазваниеЭД;
		СкорректироватьИмяФайла(НазваниеЭД);
		ИмяПервогоФайлаMXL = Лев(ИмяФайла, ДлинаСтроки - ОбратныйИндекс) + НазваниеЭД + Прав(ИмяФайла, 4);
		ТабличныйДокумент = ПолучитьИзВременногоХранилища(ПереченьВременныхФайлов[0].АдресФайлаДанных);
		ТабличныйДокумент.Записать(ИмяПервогоФайлаMXL);
		
		НазваниеЭД = ПереченьВременныхФайлов[1].НазваниеЭД;
		СкорректироватьИмяФайла(НазваниеЭД);
		ИмяВторогоФайлаMXL = Лев(ИмяФайла, ДлинаСтроки - ОбратныйИндекс) + НазваниеЭД + Прав(ИмяФайла, 4);
		ТабличныйДокумент = ПолучитьИзВременногоХранилища(ПереченьВременныхФайлов[1].АдресФайлаДанных);
		ТабличныйДокумент.Записать(ИмяВторогоФайлаMXL);
		
		Сравнение = Новый СравнениеФайлов;
		Сравнение.СпособСравнения = СпособСравненияФайлов.ТабличныйДокумент;
		Сравнение.ПервыйФайл = ИмяПервогоФайлаMXL;
		Сравнение.ВторойФайл = ИмяВторогоФайлаMXL;
		Сравнение.ПоказатьРазличияМодально();
		
		НачатьУдалениеФайлов(Новый ОписаниеОповещения(), ИмяПервогоФайлаMXL);
		НачатьУдалениеФайлов(Новый ОписаниеОповещения(), ИмяВторогоФайлаMXL);
		
	#КонецЕсли
	
КонецПроцедуры

&НаСервере
Функция ВременныеФайлыЭД(ТекущийЭД, ПослВерсияЭД)
	
	МассивЭД = Новый Массив;
	МассивЭД.Добавить(ОбменСКонтрагентамиСлужебный.ПрисоединенныйФайл(ПослВерсияЭД));
	МассивЭД.Добавить(ОбменСКонтрагентамиСлужебный.ПрисоединенныйФайл(ТекущийЭД));
	
	ПереченьВременныхФайлов = ОбменСКонтрагентамиСлужебный.ПодготовитьВременныеФайлыПросмотраЭД(МассивЭД);
	
	Если Не ЗначениеЗаполнено(ПереченьВременныхФайлов) Тогда
		ТекстСообщения = НСтр("ru='Ошибка при разборе электронного документа.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ПереченьВременныхФайлов

КонецФункции

&НаСервере
Процедура СкорректироватьИмяФайла(СтрИмяФайла)
	
	// Перечень запрещенных символов взят отсюда: http://support.microsoft.com/kb/100108/ru.
	// При этом были объединены запрещенные символы для файловых систем FAT и NTFS.
	СтрИсключения = """ / \ [ ] : ; | = , ? * < >";
	СтрИсключения = СтрЗаменить(СтрИсключения, " ", "");
	
	Для Сч=1 По СтрДлина(СтрИсключения) Цикл
		Символ = Сред(СтрИсключения, Сч, 1);
		Если СтрНайти(СтрИмяФайла, Символ) <> 0 Тогда
			СтрИмяФайла = СтрЗаменить(СтрИмяФайла, Символ, " ");
		КонецЕсли;
	КонецЦикла;
	
	СтрИмяФайла = СокрЛП(СтрИмяФайла);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСтатусПакетов(ТаблицаПакетов, СтатусПакета, КоличествоИзмененных)
	
	КоличествоИзмененных = 0;
	Для Каждого СтрокаТаблицы Из Элементы[ТаблицаПакетов].ВыделенныеСтроки Цикл
		Попытка
			Пакет = СтрокаТаблицы.Ссылка.ПолучитьОбъект();
			Пакет.СтатусПакета = СтатусПакета;
			Пакет.Записать();
			КоличествоИзмененных = КоличествоИзмененных + 1;
		Исключение
			ТекстСообщения = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
			ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ОбработатьОшибку(
				НСтр("ru = 'изменение статуса пакетов ЭД'"), ТекстОшибки, ТекстСообщения);
		КонецПопытки;
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДанныеПрисоединенныхФайловПакетовЭДНаСервере(Знач ПакетыЭД, УникальныйИдентификатор)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПакетЭДПрисоединенныеФайлы.Ссылка
	|ИЗ
	|	Справочник.ПакетЭДПрисоединенныеФайлы КАК ПакетЭДПрисоединенныеФайлы
	|ГДЕ
	|	ПакетЭДПрисоединенныеФайлы.ВладелецФайла В (&ПакетыЭД)";
	
	Запрос.УстановитьПараметр("ПакетыЭД", ПакетыЭД);
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);

	ДанныеФайлов = Новый Массив;
	Пока Выборка.Следующий() Цикл
		ДанныеФайла = РаботаСФайлами.ДанныеФайла(Выборка.Ссылка,
			УникальныйИдентификатор);
		ДанныеФайлов.Добавить(ДанныеФайла);
	КонецЦикла;
	
	Возврат ДанныеФайлов;
	
КонецФункции

&НаСервере
Процедура ОтборПоЭлементуПриЗагрузкеИзНастроек(Форма, СписокДанных, ВидЭлемента, Настройки)
	
	ЗначениеЭлемента = Настройки.Получить(ВидЭлемента);
	
	Если ЗначениеЗаполнено(ЗначениеЭлемента) Тогда
		Форма[ВидЭлемента] = ЗначениеЭлемента;
		УстановитьОтборВСпискеПоЭлементуКлиентСервер(СписокДанных, ВидЭлемента, ЗначениеЭлемента);
	КонецЕсли;
	
	Настройки.Удалить(ВидЭлемента);
	
КонецПроцедуры

&НаКлиенте
Процедура ОповеститьПользователяОСменеОтветственного(КоличествоОбработанных, СписокОбъектов, Ответственный)
	
	ОчиститьСообщения();
	
	Если КоличествоОбработанных > 0 Тогда
		
		СписокОбъектов.Обновить();
		
		ТекстСообщения = НСтр("ru='Для %КоличествоОбработанных% из %КоличествоВсего% выделенных эл.документов
		|установлен ответственный ""%Ответственный%""'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%КоличествоОбработанных%", КоличествоОбработанных);
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%КоличествоВсего%",        СписокОбъектов.ВыделенныеСтроки.Количество());
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Ответственный%",          Ответственный);
		ТекстЗаголовка = НСтр("ru='Ответственный ""%Ответственный%"" установлен'");
		ТекстЗаголовка = СтрЗаменить(ТекстЗаголовка, "%Ответственный%", Ответственный);
		ПоказатьОповещениеПользователя(ТекстЗаголовка, , ТекстСообщения, БиблиотекаКартинок.Информация32);
		
	Иначе
		
		ТекстСообщения = НСтр("ru='Ответственный ""%Ответственный%"" не установлен ни для одного эл.документа.'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Ответственный%", Ответственный);
		ТекстЗаголовка = НСтр("ru='Ответственный ""%Ответственный%"" не установлен'");
		ТекстЗаголовка = СтрЗаменить(ТекстЗаголовка, "%Ответственный%", Ответственный);
		ПоказатьОповещениеПользователя(ТекстЗаголовка,, ТекстСообщения, БиблиотекаКартинок.Информация32);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьОбменСКонтрагентамиДляФНС(НаправлениеЭД)
	
	СтруктураПараметров = Новый Структура("НаправлениеЭД, ВерсияВызова", НаправлениеЭД, 1);
	ОткрытьФорму("Обработка.ОбменСКонтрагентами.Форма.ВыгрузкаЭлектронныхДокументовДляФНС",
		СтруктураПараметров, ЭтотОбъект, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыборОтветственного(НовыйОтветственный, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(НовыйОтветственный) Тогда
		КоличествоОбработанныхЭД = 0;
		УстановитьОтветственногоЭД(Элементы.Список.ВыделенныеСтроки, НовыйОтветственный, КоличествоОбработанныхЭД);
		ОповеститьПользователяОСменеОтветственного(КоличествоОбработанныхЭД, Элементы.Список, НовыйОтветственный);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСпискиВыбораВидовДокументов()
	
	ВидыДокументов = ОбменСКонтрагентамиСлужебный.ВидыДокументовДляОтбораВСписках();
	Элементы.ВидЭД.СписокВыбора.ЗагрузитьЗначения(ВидыДокументов);
	Элементы.ВидЭДИсх.СписокВыбора.ЗагрузитьЗначения(ВидыДокументов);
	
КонецПроцедуры

#КонецОбласти
