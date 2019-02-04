
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Элементы.ОтправитьПоЭлектроннойПочте.Видимость = РаботаСПочтовымиСообщениями.ДоступнаОтправкаПисем();
	
	ЗаполнитьСписокДокументов();
	
	УправлениеДоступностью(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	ВыбранныеДокументыНастройки = Настройки.Получить("ВыбранныеДокументы");
	Если Настройки.Получить("ВыбранныеДокументы") <> Неопределено Тогда
		
		Для Каждого ЭлементСпискаНастроек Из ВыбранныеДокументыНастройки Цикл
			
			Если ЭлементСпискаНастроек.Пометка Тогда
				
				ЭлементСписка = ВыбранныеДокументы.НайтиПоЗначению(ЭлементСпискаНастроек.Значение);
				Если ЭлементСписка <> Неопределено Тогда
					ЭлементСписка.Пометка = Истина;
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
		Настройки.Удалить("ВыбранныеДокументы");
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	УправлениеДоступностью(ЭтотОбъект);
	
	СформироватьОтчетНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЕстьВыбранныеДокументы = Ложь;
	Для Каждого ЭлементСписка Из ВыбранныеДокументы Цикл
		Если ЭлементСписка.Пометка Тогда
			ЕстьВыбранныеДокументы = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если Не ЕстьВыбранныеДокументы Тогда
		
		ВыбранныеДокументы.ЗаполнитьПометки(Истина);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДокументыПриИзменении(Элемент)
	
	УправлениеДоступностью(ЭтотОбъект);
	
	УстановитьСостояниеОтчетНеСформирован();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыводитьСправочникиПриИзменении(Элемент)
	
	УстановитьСостояниеОтчетНеСформирован();
	
КонецПроцедуры

&НаКлиенте
Процедура НачалоПериодаПриИзменении(Элемент)
	
	УстановитьСостояниеОтчетНеСформирован();
	
КонецПроцедуры

&НаКлиенте
Процедура КонецПериодаПриИзменении(Элемент)
	
	УстановитьСостояниеОтчетНеСформирован();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьПериод(Команда)
	
	ПараметрыВыбора = Новый Структура("НачалоПериода,КонецПериода", Отчет.НачалоПериода, Отчет.КонецПериода);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериода", ПараметрыВыбора, Элементы.ВыбратьПериод, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
	
	СформироватьНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыДокументов(Команда)
	
	ВыбранныеДокументы.ПоказатьОтметкуЭлементов(Новый ОписаниеОповещения("НастройкиЗавершение", ЭтотОбъект), НСтр("ru = 'Выбор видов документов'"));
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_Команда(Команда)
	
	// Механизмы расширения
	ОтчетыКлиентПереопределяемый.ОбработчикКоманды(ЭтотОбъект, Команда, Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПоЭлектроннойПочте(Команда)
	
	ОтображениеСостояния = Элементы.Результат.ОтображениеСостояния;
	Если ОтображениеСостояния.Видимость = Истина
		И ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.Неактуальность Тогда
		ТекстВопроса = НСтр("ru = 'Отчет не сформирован. Сформировать?'");
		Обработчик = Новый ОписаниеОповещения("ОтправитьПоЭлектроннойПочтеЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Обработчик, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60, КодВозвратаДиалога.Да);
	Иначе
		ПоказатьДиалогОтправкиПоЭлектроннойПочте();
	КонецЕсли;
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СформироватьОтчетНаСервере()

	Результат.Очистить();
	ОбъектОтчет =  РеквизитФормыВЗначение("Отчет");
	
	ОбъектОтчет.СформироватьОтчет(Результат, ВыбранныеДокументы)

КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(Отчет, РезультатВыбора, "НачалоПериода,КонецПериода");
	УстановитьСостояниеОтчетНеСформирован();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеДоступностью(Форма)

	Форма.Элементы.ГруппаНастройкиДокументы.Доступность = Форма.Отчет.ВыводитьДокументы;

КонецПроцедуры 

&НаКлиенте
Функция НастройкиОтчетаКорректны()
	
	ОчиститьСообщения();
	
	НастройкиОтчетаКорректны = Истина;
	
	Если Не Отчет.ВыводитьДокументы И Не Отчет.ВыводитьСправочники Тогда
		
		НастройкиОтчетаКорректны = Ложь;

		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не указан ни один из типов данных для вывода'"), ,"ВыводитьСправочники", "Отчет");
		
	КонецЕсли;
	
	Возврат НастройкиОтчетаКорректны;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСписокДокументов()
	
	ДополнитьСписокДокументовПоСчетФактуре("СчетФактураВыданный", Ложь);
	ДополнитьСписокДокументовПоСчетФактуре("СчетФактураВыданныйАванс", Ложь);
	ДополнитьСписокДокументовПоСчетФактуре("СчетФактураНалоговыйАгент", Ложь);
	ДополнитьСписокДокументовПоСчетФактуре("СчетФактураПолученный", Истина);
	ДополнитьСписокДокументовПоСчетФактуре("СчетФактураПолученныйНалоговыйАгент", Истина);
	ДополнитьСписокДокументовПоСчетФактуре("СчетФактураПолученныйАванс", Ложь);
	
	ВыбранныеДокументы.СортироватьПоПредставлению();
	
КонецПроцедуры 

&НаСервере
Процедура ДополнитьСписокДокументовПоСчетФактуре(ИмяСчетФактуры, ОснованиеВТабличнойЧасти)

	МетаданныеСчетФактуры = Метаданные.Документы[ИмяСчетФактуры];
	
	Если НЕ ПравоДоступа("Просмотр", МетаданныеСчетФактуры) 
		Или НЕ ОбщегоНазначения.ОбъектМетаданныхДоступенПоФункциональнымОпциям(МетаданныеСчетФактуры) Тогда
		Возврат;
	КонецЕсли;
	
	ДобавитьВСписокПоМетаданным(МетаданныеСчетФактуры);
	
	Если ОснованиеВТабличнойЧасти Тогда
		МассивТипов = МетаданныеСчетФактуры.ТабличныеЧасти.ДокументыОснования.Реквизиты.ДокументОснование.Тип.Типы();
	Иначе
		МассивТипов = МетаданныеСчетФактуры.Реквизиты.ДокументОснование.Тип.Типы();
	КонецЕсли;
	
	Для Каждого ТипДокумента Из МассивТипов Цикл
		
		МетаданныеДокументаОснования = Метаданные.НайтиПоТипу(ТипДокумента);
		
		Если  ПравоДоступа("Просмотр", МетаданныеДокументаОснования)
			И ОбщегоНазначения.ОбъектМетаданныхДоступенПоФункциональнымОпциям(МетаданныеДокументаОснования) Тогда
			
			ДобавитьВСписокПоМетаданным(МетаданныеДокументаОснования);
			
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ДобавитьВСписокПоМетаданным(МетаданныеДокумента)
	
	ИмяДокументаОснования = МетаданныеДокумента.Имя;
	СинонимДокументаОснования = МетаданныеДокумента.Синоним;
	
	Если ВыбранныеДокументы.НайтиПоЗначению(ИмяДокументаОснования) = Неопределено Тогда
		ВыбранныеДокументы.Добавить(ИмяДокументаОснования, СинонимДокументаОснования);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	УстановитьСостояниеОтчетНеСформирован();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСостояниеОтчетНеСформирован()
	
	Элементы.Результат.ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.Неактуальность;
	Элементы.Результат.ОтображениеСостояния.Текст = НСтр("ru = 'Отчет не сформирован. Нажмите ""Сформировать"" для получения отчета.'");
	Элементы.Результат.ОтображениеСостояния.Видимость = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьДиалогОтправкиПоЭлектроннойПочте()
	
	Вложение = Новый Структура;
	Вложение.Вставить("АдресВоВременномХранилище", ПоместитьВоВременноеХранилище(Результат, УникальныйИдентификатор));
	Вложение.Вставить("Представление", Заголовок);
	
	СписокВложений = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Вложение);
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСПочтовымиСообщениями") Тогда
		МодульРаботаСПочтовымиСообщениямиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСПочтовымиСообщениямиКлиент");
		ПараметрыОтправки                       = МодульРаботаСПочтовымиСообщениямиКлиент.ПараметрыОтправкиПисьма();
		ПараметрыОтправки.Тема                  = Заголовок;
		ПараметрыОтправки.Вложения              = СписокВложений;
		МодульРаботаСПочтовымиСообщениямиКлиент.СоздатьНовоеПисьмо(ПараметрыОтправки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПоЭлектроннойПочтеЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		СформироватьНаКлиенте();
		ПоказатьДиалогОтправкиПоЭлектроннойПочте();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьНаКлиенте()

	Если НастройкиОтчетаКорректны() Тогда
		
		СформироватьОтчетНаСервере();
		Элементы.Результат.ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.НеИспользовать;
		Элементы.Результат.ОтображениеСостояния.Видимость = Ложь;
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти