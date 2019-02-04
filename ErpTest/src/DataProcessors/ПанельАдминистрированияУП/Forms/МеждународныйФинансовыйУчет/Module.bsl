#Область ОписаниеПеременных

&НаКлиенте
Перем ОбновитьИнтерфейс;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Значения реквизитов формы
	СоставНабораКонстантФормы    = ОбщегоНазначенияУТ.ПолучитьСтруктуруНабораКонстант(НаборКонстант);
	
	ВнешниеРодительскиеКонстанты = НастройкиСистемыПовтИсп.ПолучитьСтруктуруРодительскихКонстант(СоставНабораКонстантФормы);
	ВнешниеРодительскиеКонстанты.Вставить("ИспользоватьСделкиСКлиентами");
	
	РежимРаботы = Новый Структура;
	РежимРаботы.Вставить("СоставНабораКонстантФормы",    Новый ФиксированнаяСтруктура(СоставНабораКонстантФормы));
	РежимРаботы.Вставить("ВнешниеРодительскиеКонстанты", Новый ФиксированнаяСтруктура(ВнешниеРодительскиеКонстанты));
	РежимРаботы.Вставить("БазоваяВерсия", 				 ПолучитьФункциональнуюОпцию("БазоваяВерсия"));
	
	РежимРаботы = Новый ФиксированнаяСтруктура(РежимРаботы);
	УчетВФункциональнойВалютеУпр = Константы.УчетВФункциональнойВалюте.Получить() = Перечисления.ВидыУчетаВФункциональнойВалюте.ВВалютеУпр;
	
	// Настройки видимости при запуске
	
	// Обновление состояния элементов
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	ОбновитьИнтерфейсПрограммы();
КонецПроцедуры

&НаКлиенте
// Обработчик оповещения формы.
//
// Параметры:
//	ИмяСобытия - Строка - обрабатывается только событие Запись_НаборКонстант, генерируемое панелями администрирования.
//	Параметр   - Структура - содержит имена констант, подчиненных измененной константе, "вызвавшей" оповещение.
//	Источник   - Строка - имя измененной константы, "вызвавшей" оповещение.
//
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия <> "Запись_НаборКонстант" Тогда
		Возврат; // такие событие не обрабатываются
	КонецЕсли;
	
	// Если это изменена константа, расположенная в другой форме и влияющая на значения констант этой формы,
	// то прочитаем значения констант и обновим элементы этой формы.
	Если РежимРаботы.ВнешниеРодительскиеКонстанты.Свойство(Источник)
	 ИЛИ (ТипЗнч(Параметр) = Тип("Структура")
	 		И ОбщегоНазначенияУТКлиентСервер.ПолучитьОбщиеКлючиСтруктур(
	 			Параметр, РежимРаботы.ВнешниеРодительскиеКонстанты).Количество() > 0) Тогда
		
		ЭтаФорма.Прочитать();
		УстановитьДоступность();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьМеждународныйФинансовыйУчетПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ФормироватьПроводкиМеждународногоУчетаПоДаннымОперативногоПриИзменении(Элемент)
	
	Если НЕ НаборКонстант.ФормироватьПроводкиМеждународногоУчетаПоДаннымОперативного И УчетВФункциональнойВалютеУпр Тогда
		ОбработкаОтвета = Новый ОписаниеОповещения("ОтветНаВопросОтключенияТранслятораОУ", ЭтаФорма);
		ПоказатьВопрос(
			ОбработкаОтвета,
			НСтр("ru = 'При изменении настройки произойдет смена типа учета в функциональной валюте.
			|Продолжить?'"),
			РежимДиалогаВопрос.ДаНет,,КодВозвратаДиалога.Нет);
	Иначе
		Подключаемый_ПриИзмененииРеквизита(Элемент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветНаВопросОтключенияТранслятораОУ(Ответ, ДопПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		Подключаемый_ПриИзмененииРеквизита(ТекущийЭлемент);
	Иначе
		ЭтаФорма.Прочитать();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФормироватьПроводкиМеждународногоУчетаПоДаннымРегламентированногоПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ВалютаФункциональнаяПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ВалютаПредставленияПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура УчетВФункциональнойВалютеПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьВалюты(Команда)
	
	ОткрытьФорму("Справочник.Валюты.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьМодельУчета(Команда)
	
	ОткрытьФорму("Обработка.ПомощникВыгрузкиЗагрузкиМоделиМеждународногоУчета.Форма.Выгрузка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьМодельУчета(Команда)
	
	ОткрытьФорму("Обработка.ПомощникВыгрузкиЗагрузкиМоделиМеждународногоУчета.Форма.Загрузка", , ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Клиент

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	КонстантаИмя = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	Если ОбновлятьИнтерфейс Тогда
		ОбновитьИнтерфейс = Истина;
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 2, Истина);
	КонецЕсли;
	
	Если КонстантаИмя <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, КонстантаИмя);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ВызовСервера

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	КонстантаИмя = СохранитьЗначениеРеквизита(РеквизитПутьКДанным);
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат КонстантаИмя;
	
КонецФункции

#КонецОбласти

#Область Сервер

&НаСервере
Функция СохранитьЗначениеРеквизита(РеквизитПутьКДанным)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "" Тогда
		Возврат "";
	КонецЕсли;
	
	// Определение имени константы.
	КонстантаИмя = "";
	Если НРег(Лев(РеквизитПутьКДанным, 14)) = НРег("НаборКонстант.") Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		КонстантаИмя = Сред(РеквизитПутьКДанным, 15);
	Иначе
		// Определение имени и запись значения реквизита в соответствующей константе из "НаборКонстант".
		// Используется для тех реквизитов формы, которые связаны с константами напрямую (в отношении один-к-одному).
	КонецЕсли;
	
	// Сохранения значения константы.
	Если КонстантаИмя <> "" Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = НаборКонстант[КонстантаИмя];
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
		
		Если КонстантаИмя = "ФормироватьПроводкиМеждународногоУчетаПоДаннымОперативного" И НЕ КонстантаЗначение Тогда
			
		КонецЕсли;
		
		Если КонстантаИмя = "УчетВФункциональнойВалюте" Тогда
			УчетВФункциональнойВалютеУпр = КонстантаЗначение = Перечисления.ВидыУчетаВФункциональнойВалюте.ВВалютеУпр;
		КонецЕсли;
		
		Если НастройкиСистемыПовтИсп.ЕстьПодчиненныеКонстанты(КонстантаИмя, КонстантаЗначение) Тогда
			ЭтаФорма.Прочитать();
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат КонстантаИмя
	
КонецФункции

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьМеждународныйФинансовыйУчет" ИЛИ РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = НаборКонстант.ИспользоватьМеждународныйФинансовыйУчет;
		Элементы.УчетВФункциональнойВалюте.Доступность = ЗначениеКонстанты;
		Элементы.ВалютаПредставления.Доступность = ЗначениеКонстанты;
		
		Элементы.ОткрытьВалюты.Доступность = ЗначениеКонстанты;
		Элементы.ЗагрузитьМодельУчета.Доступность = ЗначениеКонстанты;
		Элементы.ВыгрузитьМодельУчетаВФайл.Доступность = ЗначениеКонстанты;
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ФормироватьПроводкиМеждународногоУчетаПоДаннымОперативного" ИЛИ РеквизитПутьКДанным = "" Тогда
		СписокВыбора = Элементы.УчетВФункциональнойВалюте.СписокВыбора;
		СписокВыбора.Очистить();
		Если НаборКонстант.ФормироватьПроводкиМеждународногоУчетаПоДаннымОперативного Тогда
			СписокВыбора.Добавить(Перечисления.ВидыУчетаВФункциональнойВалюте.ВВалютеУпр);
		КонецЕсли;
		СписокВыбора.Добавить(Перечисления.ВидыУчетаВФункциональнойВалюте.ВВалютеРегл);
		Элементы.УчетВФункциональнойВалюте.Доступность = СписокВыбора.Количество() > 1;
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.УчетВФункциональнойВалюте" ИЛИ РеквизитПутьКДанным = "" Тогда
		ОбщегоНазначенияУТКлиентСервер.ОтображениеПредупрежденияПриРедактировании(
			Элементы.УчетВФункциональнойВалюте, ЗначениеЗаполнено(НаборКонстант.УчетВФункциональнойВалюте));
	КонецЕсли;
		
	Если РеквизитПутьКДанным = "НаборКонстант.ВалютаПредставления" ИЛИ РеквизитПутьКДанным = "" Тогда
		ОбщегоНазначенияУТКлиентСервер.ОтображениеПредупрежденияПриРедактировании(
			Элементы.ВалютаПредставления, ЗначениеЗаполнено(НаборКонстант.ВалютаПредставления));
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьМеждународныйФинансовыйУчет" ИЛИ РеквизитПутьКДанным = "" Тогда
		ИспользоватьМеждународныйФинансовыйУчет = НаборКонстант.ИспользоватьМеждународныйФинансовыйУчет;
		ИспользоватьРеглУчет = Константы.ИспользоватьРеглУчет.Получить();
		Элементы.ФормироватьПроводкиМеждународногоУчетаПоДаннымОперативного.Доступность = ИспользоватьМеждународныйФинансовыйУчет;
		Элементы.ФормироватьПроводкиМеждународногоУчетаПоДаннымРегламентированного.Доступность = ИспользоватьМеждународныйФинансовыйУчет И ИспользоватьРеглУчет;
		Элементы.ГруппаКомментарийПроводкиМеждународногоПоДаннымРегл.Видимость = Не ИспользоватьРеглУчет;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецОбласти
