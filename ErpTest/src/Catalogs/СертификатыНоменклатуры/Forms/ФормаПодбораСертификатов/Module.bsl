#Область ОписаниеПеременных

&НаКлиенте
Перем ВыполняетсяЗакрытие;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ФОИспользоватьХарактеристикиНоменклатуры = ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристикиНоменклатуры");
	ФОИспользоватьСерииНоменклатуры = ПолучитьФункциональнуюОпцию("ИспользоватьСерииНоменклатуры");
	
	Параметры.Свойство("Номенклатура",ИсходнаяНоменклатура); 
	РеквизитыНоменклатуры = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ИсходнаяНоменклатура,"ВидНоменклатуры, ИспользованиеХарактеристик");
	ИсходныйВидНоменклатуры = РеквизитыНоменклатуры.ВидНоменклатуры;	
	ВидНоменклатурыИспользоватьСерии = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ИсходныйВидНоменклатуры,"ИспользоватьСерии");
	НеИспользоватьХарактеристики =  Перечисления.ВариантыИспользованияХарактеристикНоменклатуры.НеИспользовать;
	НоменклатураИспользоватьХарактеристики = РеквизитыНоменклатуры.ИспользованиеХарактеристик <> НеИспользоватьХарактеристики;		

	ИспользоватьХарактеристики = ФОИспользоватьХарактеристикиНоменклатуры И НоменклатураИспользоватьХарактеристики;
	ИспользоватьСерии = ФОИспользоватьСерииНоменклатуры И ВидНоменклатурыИспользоватьСерии;
	
	Элементы.ПодобранныеСертификатыНоменклатурыХарактеристика.Видимость = ИспользоватьХарактеристики;
	Элементы.ПодобранныеСертификатыНоменклатурыСерия.Видимость 			= ИспользоватьСерии;
	
	МассивТипов = Справочники.СертификатыНоменклатуры.СформироватьСписокВыбораТиповСертификатов();
	Элементы.ТипСертификата.СписокВыбора.ЗагрузитьЗначения(МассивТипов);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		ОбластьДействия,
		"СертификатНоменклатуры",
		Справочники.СертификатыНоменклатуры.ПустаяСсылка(),
		ВидСравненияКомпоновкиДанных.Равно);
			
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		СертификатыНоменклатуры,
		"Номенклатура",
		Справочники.Номенклатура.ПустаяСсылка());
			
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		СертификатыНоменклатуры,
		"ВидНоменклатуры",
		Справочники.ВидыНоменклатуры.ПустаяСсылка());
				
	Если ТолькоДействующиеНаДату Тогда
		Элементы.Дата.Доступность = Истина;
	Иначе	
		Элементы.Дата.Доступность = Ложь;
	КонецЕсли;
	
	Дата = ТекущаяДатаСеанса();
	
	ТекстЗаголовка = НСтр("ru='Подобранные сертификаты (0)'");
	Элементы.ГруппаПодобранныеСертификаты.ЗаголовокСвернутогоОтображения = ТекстЗаголовка;
	Элементы.ГруппаПодобранныеСертификаты.Заголовок = ТекстЗаголовка;

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_СертификатНоменклатуры" Тогда
		
		МассивТипов = СформироватьСписокВыбораТиповСертификатов();
		Элементы.ТипСертификата.СписокВыбора.ЗагрузитьЗначения(МассивТипов);
		Элементы.СертификатыНоменклатуры.Обновить();
		Элементы.ОбластьДействия.Обновить();

	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ПодобранныеСертификатыНоменклатуры.Количество() > 0
		И Не СертификатыПодобраны
		И Не ВыполняетсяЗакрытие Тогда
		
		Отказ = Истина;
		
		Если ЗавершениеРаботы Тогда
			ТекстПредупреждения =  НСтр("ru = 'Данные были изменены.
				|Работа по подбору сертификатов для номенклатуры будет прервана.'");
			Возврат;
		КонецЕсли;
		
		ОповещениеЗакрытия = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Подобранные сертификаты не будут действовать для номенклатуры. Сопоставить сертификаты с номенклатурой?'");
		
		ПоказатьВопрос(ОповещениеЗакрытия, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Да Тогда
		
		Если ПодобратьСертификатыНаСервере() Тогда
			Оповестить("Запись_СертификатНоменклатуры");
			СертификатыПодобраны = Истина;
			ВыполняетсяЗакрытие = Истина;
			Закрыть();
			
		КонецЕсли;
		Возврат;
		
	КонецЕсли;
	
	ВыполняетсяЗакрытие = Истина;
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипСертификатаПриИзменении(Элемент)
			
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СертификатыНоменклатуры,
		"ТипСертификата",
		ТипСертификата,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(ТипСертификата));
			
КонецПроцедуры

&НаКлиенте
Процедура ТипСертификатаАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	
	МассивТипов = СформироватьСписокТипов(Текст);
	ДанныеВыбора = Новый СписокЗначений;
	ДанныеВыбора.ЗагрузитьЗначения(МассивТипов);

КонецПроцедуры

&НаКлиенте
Процедура ТолькоДействующиеНаДатуПриИзменении(Элемент)
	
	Если ТолькоДействующиеНаДату Тогда
		Элементы.Дата.Доступность = Истина;
	Иначе	
		Элементы.Дата.Доступность = Ложь;
	КонецЕсли;
	
	УстановитьОтборПоТолькоДействубщимНаДату();	
		
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	УстановитьОтборПоТолькоДействубщимНаДату();
	
КонецПроцедуры
	
&НаКлиенте
Процедура НоменклатураОтборПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		СертификатыНоменклатуры,
		"Номенклатура",
		НоменклатураОтбор);
		
	Если ЗначениеЗаполнено(НоменклатураОтбор) Тогда
					
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
			СертификатыНоменклатуры,
			"ВидНоменклатуры",
			ВидНоменклатуры(НоменклатураОтбор));
			
		Если Не ЗначениеЗаполнено(ВариантОтображенияТаблицы) Тогда			
			Если Элементы.СертификатыНоменклатуры.Отображение = ОтображениеТаблицы.ИерархическийСписок Тогда
				ВариантОтображенияТаблицы = "ИерархическийСписок";
			Иначе
				ВариантОтображенияТаблицы = Элементы.СертификатыНоменклатуры.Отображение;
			КонецЕсли;
			Элементы.СертификатыНоменклатуры.Отображение = ОтображениеТаблицы.Список;		
		КонецЕсли;
		
	Иначе
				
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
			СертификатыНоменклатуры,
			"ВидНоменклатуры",
			ПредопределенноеЗначение("Справочник.ВидыНоменклатуры.ПустаяСсылка"));
			
		Если ЗначениеЗаполнено(ВариантОтображенияТаблицы) Тогда
			Если ВариантОтображенияТаблицы = "ИерархическийСписок" Тогда
				Элементы.СертификатыНоменклатуры.Отображение = ОтображениеТаблицы.ИерархическийСписок;
			Иначе
				Элементы.СертификатыНоменклатуры.Отображение = ОтображениеТаблицы[ВариантОтображенияТаблицы];
			КонецЕсли;	
			ВариантОтображенияТаблицы = Неопределено;
		КонецЕсли;

	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСертификатыНоменклатуры

&НаКлиенте
Процедура СертификатыНоменклатурыПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("СертификатыНоменклатурыАктивизацияСтроки", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатыНоменклатурыАктивизацияСтроки()
		
	ТекущаяСтрока = Элементы.СертификатыНоменклатуры.ТекущиеДанные;
	Если ТекущаяСтрока <> Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			ОбластьДействия, "СертификатНоменклатуры", ТекущаяСтрока.Ссылка, ВидСравненияКомпоновкиДанных.Равно);		
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			ОбластьДействия,
			"СертификатНоменклатуры",
			ПредопределенноеЗначение("Справочник.СертификатыНоменклатуры.ПустаяСсылка"),
			ВидСравненияКомпоновкиДанных.Равно);	
	КонецЕсли;	

КонецПроцедуры

&НаКлиенте
Процедура СертификатыНоменклатурыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если Элементы.СертификатыНоменклатуры.ТекущиеДанные = Неопределено Тогда
		Возврат;
	ИначеЕсли Элементы.СертификатыНоменклатуры.ТекущиеДанные.ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	НоваяСтрока = ПодобранныеСертификатыНоменклатуры.Добавить();
	НоваяСтрока.Сертификат = ВыбраннаяСтрока;
	ОбновитьЗаголовокПодобранныеСертификаты();
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОбластьДействия

&НаКлиенте
Процедура ОбластьДействияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПодобранныеСертификатыНоменклатуры

&НаКлиенте
Процедура ПодобранныеСертификатыНоменклатурыСерияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ВидНоменклатуры", ИсходныйВидНоменклатуры);
	ПараметрыФормы.Вставить("Номенклатура", ИсходнаяНоменклатура);
	ПараметрыФормы.Вставить("Характеристика", Элементы.ПодобранныеСертификатыНоменклатуры.ТекущиеДанные.Характеристика);
	ПараметрыФормы.Вставить("ХарактеристикиИспользуются", ИспользоватьХарактеристики);
	Серия = Неопределено;

	ОткрытьФорму("Справочник.СертификатыНоменклатуры.Форма.ФормаПодбораОбластиДействияСерия",ПараметрыФормы,,,,, Новый ОписаниеОповещения("ПодобранныеСертификатыНоменклатурыСерияНачалоВыбораЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобранныеСертификатыНоменклатурыСерияНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    Серия = Результат;
    Элементы.ПодобранныеСертификатыНоменклатуры.ТекущиеДанные.Серия = Серия;

КонецПроцедуры

&НаКлиенте
Процедура ПодобранныеСертификатыНоменклатурыПриИзменении(Элемент)
	ОбновитьЗаголовокПодобранныеСертификаты();
КонецПроцедуры

&НаКлиенте
Процедура ПодобранныеСертификатыНоменклатурыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	ОбновитьЗаголовокПодобранныеСертификаты();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	ОчиститьСообщения();
	Если ПодобратьСертификатыНаСервере() Тогда
		Оповестить("Запись_СертификатНоменклатуры");
		СертификатыПодобраны = Истина;
		Закрыть();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Отменить(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьИзображение(Команда)
	
	ОчиститьСообщения();
	
	ТекущаяСтрока = Элементы.СертификатыНоменклатуры.ТекущиеДанные;
	
	СтркутураВозврата = ОткрытьИзображениеНаСервере(ТекущаяСтрока.Ссылка);	

	Если СтркутураВозврата.Результат = "НетИзображений" Тогда
		ТекстСообщения = НСтр("ru='Для сертификата номенклатуры ""%Сертификат%"" отсутствует изображение для просмотра'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения,"%Сертификат%",ТекущаяСтрока.Ссылка);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);	
	ИначеЕсли СтркутураВозврата.Результат = "ОдноИзображение" Тогда
		РаботаСФайламиКлиент.ОткрытьФайл(
			РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайла(
			СтркутураВозврата.ПрисоединенныйФайл,
			УникальныйИдентификатор));
	Иначе
		ПараметрыВыбора = Новый Структура("ВладелецФайла, ЗакрыватьПриВыборе, РежимВыбора",
										   ТекущаяСтрока.Ссылка, Истина, Истина);
		ЗначениеВыбора = Неопределено;

		ОткрытьФорму("Обработка.РаботаСФайлами.Форма.ПрисоединенныеФайлы", ПараметрыВыбора,,,,, Новый ОписаниеОповещения("ОткрытьИзображениеЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;	
			
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьИзображениеЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    ЗначениеВыбора = Результат;
    
    Если ЗначениеЗаполнено(ЗначениеВыбора) Тогда
        
        РаботаСФайламиКлиент.ОткрытьФайл(
        РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайла(
        ЗначениеВыбора,
        УникальныйИдентификатор));
        
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОбластьДействияНоменклатура.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОбластьДействия.Номенклатура");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<для всей номенклатуры>'"));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОбластьДействияХарактеристика.Имя);

	ГруппаОтбораИ = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбораИ.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	
	ОтборЭлемента = ГруппаОтбораИ.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОбластьДействия.Характеристика");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;

	ОтборЭлемента = ГруппаОтбораИ.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОбластьДействия.ИспользоватьХарактеристики");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
		
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<для всех характеристик>'"));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОбластьДействияСерия.Имя);

	ГруппаОтбораИ = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбораИ.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	
	ОтборЭлемента = ГруппаОтбораИ.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОбластьДействия.Серия");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;

	ОтборЭлемента = ГруппаОтбораИ.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОбластьДействия.ИспользоватьСерии");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
		
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<для всех серий>'"));
	
	//	
	
	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтаФорма, 
																			 "ОбластьДействияХарактеристика",
																		     "ОбластьДействия.ИспользоватьХарактеристики");

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОбластьДействияСерия.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОбластьДействия.ИспользоватьСерии");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
		
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<серия не указывается>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("Доступность", Ложь);

	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СертификатыНоменклатурыДатаОкончанияСрокаДействия.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СертификатыНоменклатуры.Бессрочный");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
		
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<бессрочный>'"));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПодобранныеСертификатыНоменклатурыХарактеристика.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПодобранныеСертификатыНоменклатуры.Характеристика");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<для всех характеристик>'"));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПодобранныеСертификатыНоменклатурыСерия.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПодобранныеСертификатыНоменклатуры.Серия");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<для всех серий>'"));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПодобранныеСертификатыНоменклатурыСерия.Имя);

	ГруппаОтбораИ = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбораИ.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	
	ОтборЭлемента = ГруппаОтбораИ.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПодобранныеСертификатыНоменклатуры.Характеристика");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;

	ОтборЭлемента = ГруппаОтбораИ.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИспользоватьХарактеристики");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
		
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);
	Элемент.Оформление.УстановитьЗначениеПараметра("Доступность", Ложь);

КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборПоТолькоДействубщимНаДату()
	                              
	ГруппаОтборПоДействующимНаДату = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(
		ОбщегоНазначенияУТКлиентСервер.ПолучитьОтборДинамическогоСписка(СертификатыНоменклатуры).Элементы,
		"ГруппаОтборПоДействующимНаДату",
		ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ);
	                                                                         
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтборПоДействующимНаДату, "Статус", ПредопределенноеЗначение("Перечисление.СтатусыСертификатовНоменклатуры.Действующий"), 
		ВидСравненияКомпоновкиДанных.Равно, "ГруппаОтборПоДействующимНаДату", ТолькоДействующиеНаДату И ЗначениеЗаполнено(Дата));
		
	ГруппаОтборПоДате = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(
		ГруппаОтборПоДействующимНаДату,
		"ГруппаОтборПоДате",
		ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли);	
		
    ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтборПоДате, "ДатаОкончанияСрокаДействия", Дата, 
		ВидСравненияКомпоновкиДанных.БольшеИлиРавно, "ОтборПоДате", ТолькоДействующиеНаДату И ЗначениеЗаполнено(Дата));
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтборПоДате, "Бессрочный", Истина, 
		ВидСравненияКомпоновкиДанных.Равно, "ОтборПоДатеБессрочный", ТолькоДействующиеНаДату И ЗначениеЗаполнено(Дата));
	
КонецПроцедуры

&НаСервере
Функция ВидНоменклатуры(Номенклатура)

	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Номенклатура,"ВидНоменклатуры");
		
КонецФункции

&НаСервере
Функция ПодобратьСертификатыНаСервере()

	ШаблонОшибка = НСтр("ru = 'Не заполнена колонка ""Сертификат"" в строке %НомерСтроки% списка ""Подобранные сертификаты""'");
	Ошибка = Ложь;
	
	НомерСтроки = 1;
	Для Каждого СтрокаПодобранныхТоваров Из ПодобранныеСертификатыНоменклатуры Цикл
		Если СтрокаПодобранныхТоваров.Сертификат = Справочники.СертификатыНоменклатуры.ПустаяСсылка() Тогда
			ТекстСообщения = СтрЗаменить(ШаблонОшибка, "%НомерСтроки%", Строка(НомерСтроки));
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ПодобранныеСертификатыНоменклатуры", НомерСтроки, "Сертификат");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,Поле);
			Ошибка = Истина;
		КонецЕсли;
		НомерСтроки = НомерСтроки + 1;
	КонецЦикла;
	
	Если Ошибка Тогда
		Возврат Ложь
	КонецЕсли;	
	
	НаборЗаписей = РегистрыСведений.ОбластиДействияСертификатовНоменклатуры.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Номенклатура.Установить(ИсходнаяНоменклатура);	
	НаборЗаписей.Прочитать();	
	ТаблицаРегистраОбластиДействия = НаборЗаписей.Выгрузить();
	ВидНоменклатуры = ВидНоменклатуры(ИсходнаяНоменклатура);	
	
	Для Каждого СтрокаПодобранныхТоваров Из ПодобранныеСертификатыНоменклатуры Цикл
		НоваяЗапись = ТаблицаРегистраОбластиДействия.Добавить();
		НоваяЗапись.ВидНоменклатуры = ВидНоменклатуры;
		НоваяЗапись.Номенклатура = ИсходнаяНоменклатура;
		НоваяЗапись.Характеристика = СтрокаПодобранныхТоваров.Характеристика;
		НоваяЗапись.Серия = СтрокаПодобранныхТоваров.Серия;
		НоваяЗапись.СертификатНоменклатуры = СтрокаПодобранныхТоваров.Сертификат;
	КонецЦикла;	
	
	ТаблицаРегистраОбластиДействия.Свернуть("СертификатНоменклатуры,ВидНоменклатуры,Номенклатура,Характеристика,Серия");
	
	НаборЗаписей.Загрузить(ТаблицаРегистраОбластиДействия);
	НаборЗаписей.Записать();
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Функция ОткрытьИзображениеНаСервере(СертификатНоменкалтуры);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	МАКСИМУМ(СертификатыНоменклатурыПрисоединенныеФайлы.Ссылка) КАК ПрисоединенныйФайл,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ СертификатыНоменклатурыПрисоединенныеФайлы.Ссылка) КАК КоличествоФайлов,
	|	СертификатыНоменклатурыПрисоединенныеФайлы.ВладелецФайла
	|ИЗ
	|	Справочник.СертификатыНоменклатурыПрисоединенныеФайлы КАК СертификатыНоменклатурыПрисоединенныеФайлы
	|ГДЕ
	|	СертификатыНоменклатурыПрисоединенныеФайлы.ВладелецФайла = &ВладелецФайла
	|	И СертификатыНоменклатурыПрисоединенныеФайлы.ПометкаУдаления = ЛОЖЬ
	|
	|СГРУППИРОВАТЬ ПО
	|	СертификатыНоменклатурыПрисоединенныеФайлы.ВладелецФайла";
	Запрос.УстановитьПараметр("ВладелецФайла", СертификатНоменкалтуры);
	
	Выборка = Запрос.Выполнить().Выбрать();	

	СтруктураВозврата = Новый Структура;
	
	Если Выборка.Следующий() Тогда
		Если Выборка.КоличествоФайлов > 1 Тогда
			СтруктураВозврата.Вставить("Результат", "МассивИзображений");
		ИначеЕсли Выборка.КоличествоФайлов = 1 Тогда
			СтруктураВозврата.Вставить("Результат", "ОдноИзображение");
			СтруктураВозврата.Вставить("ПрисоединенныйФайл", Выборка.ПрисоединенныйФайл);
		КонецЕсли;				
	Иначе
		СтруктураВозврата.Вставить("Результат", "НетИзображений");
	КонецЕсли;	
			
	Возврат СтруктураВозврата;
	
КонецФункции	

&НаСервереБезКонтекста
Функция СформироватьСписокТипов(Текст)
	
	Возврат Справочники.СертификатыНоменклатуры.АвтоПодборТиповСертификатов(Текст);
	
КонецФункции

&НаСервереБезКонтекста
Функция СформироватьСписокВыбораТиповСертификатов()
	
	Возврат Справочники.СертификатыНоменклатуры.СформироватьСписокВыбораТиповСертификатов();
	
КонецФункции

&НаКлиенте
Процедура ОбновитьЗаголовокПодобранныеСертификаты()
	
	ТекстЗаголовка = НСтр("ru='Подобранные сертификаты (%Количество%)'");	
	ТекстЗаголовка = СтрЗаменить(ТекстЗаголовка,"%Количество%",ПодобранныеСертификатыНоменклатуры.Количество());
	
	Элементы.ГруппаПодобранныеСертификаты.ЗаголовокСвернутогоОтображения = ТекстЗаголовка;
	Элементы.ГруппаПодобранныеСертификаты.Заголовок = ТекстЗаголовка;

КонецПроцедуры

&НаКлиенте
Процедура СертификатыНоменклатурыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	ПараметрыФормы = Новый Структура();
	Если Копирование Тогда
		Если Элементы.СертификатыНоменклатуры.ТекущиеДанные = Неопределено Тогда
			Возврат;
		ИначеЕсли Элементы.СертификатыНоменклатуры.ТекущиеДанные.ЭтоГруппа Тогда
			Возврат;
		КонецЕсли;
		
		ПараметрыФормы.Вставить("ЗначениеКопирования", Элементы.СертификатыНоменклатуры.ТекущиеДанные.Ссылка); 	
	Иначе		
		ПараметрыФормы.Вставить("Номенклатура", НоменклатураОтбор);
		ПараметрыФормы.Вставить("ТипСертификата", ТипСертификата);
	КонецЕсли;
	
	ОткрытьФорму("Справочник.СертификатыНоменклатуры.Форма.ФормаЭлемента", ПараметрыФормы, ЭтаФорма);

КонецПроцедуры

#КонецОбласти

#Область Инициализация

ВыполняетсяЗакрытие = Ложь;

#КонецОбласти
