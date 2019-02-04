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
	
	РежимРаботы = Новый Структура;
	РежимРаботы.Вставить("СоставНабораКонстантФормы",    Новый ФиксированнаяСтруктура(СоставНабораКонстантФормы));
	РежимРаботы.Вставить("ВнешниеРодительскиеКонстанты", Новый ФиксированнаяСтруктура(ВнешниеРодительскиеКонстанты));
	
	РежимРаботы = Новый ФиксированнаяСтруктура(РежимРаботы);
	
	УчетВнеоборотныхАктивов = ЗначениеВыбораУчетВнеоборотныхАктивов(НаборКонстант);
	
	Если ПолучитьФункциональнуюОпцию("УправлениеПредприятием") Тогда
		Элементы.ГруппаКомментарийИспользоватьАмортизациюБухгалтерскогоУчетаКА.Видимость = Ложь;
	Иначе
		Элементы.ГруппаКомментарийИспользоватьАмортизациюБухгалтерскогоУчетаУП.Видимость = Ложь;
	КонецЕсли; 
	
	// Обновление состояния элементов
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_НаборКонстант" Тогда
	
		// Если это изменена константа, расположенная в другой форме и влияющая на значения констант этой формы,
		// то прочитаем значения констант и обновим элементы этой формы.
		Если РежимРаботы.ВнешниеРодительскиеКонстанты.Свойство(Источник)
		 ИЛИ (ТипЗнч(Параметр) = Тип("Структура")
		 		И ОбщегоНазначенияУТКлиентСервер.ПолучитьОбщиеКлючиСтруктур(
		 			Параметр, РежимРаботы.ВнешниеРодительскиеКонстанты).Количество() > 0)
		 ИЛИ Источник = "ИспользоватьВнеоборотныеАктивы2_4" Тогда
			
			ЭтаФорма.Прочитать();
			УчетВнеоборотныхАктивов = ЗначениеВыбораУчетВнеоборотныхАктивов(НаборКонстант);
			УстановитьДоступность();
			
		КонецЕсли;
		
	ИначеЕсли ИмяСобытия = "Запись_Организации" Тогда
		УстановитьДоступность();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура УчетВнеоборотныхАктивовПриИзменении(Элемент)
	
	НаличиеУчета = ОпределитьНаличиеУчета();
	Отказ = Ложь;
	
	Если УчетВнеоборотныхАктивов = "2_4" И НЕ ДоступностьУчета24.ДоступенУчет Тогда
		
		ПоказатьПредупреждение(,ДоступностьУчета24.КомментарийУчет2_4); 
		УчетВнеоборотныхАктивов = ЗначениеВыбораУчетВнеоборотныхАктивов(НаборКонстант);
		
		Отказ = Истина;
	
	ИначеЕсли УчетВнеоборотныхАктивов = "2_2" И НаличиеУчета.ИспользуетсяУУНаПланеСчетовХозрасчетный Тогда
		
		ТекстСообщения = НСтр("ru = 'Для включения учета версии 2.2 необходимо выключить опцию ""Управленческий учет на плане счетов регламентированного учета"" (раздел ""Регламентированный учет"" - ""Отражение операций"")'");
		
		ПоказатьПредупреждение(,ТекстСообщения); 
		УчетВнеоборотныхАктивов = ЗначениеВыбораУчетВнеоборотныхАктивов(НаборКонстант);
		
		Отказ = Истина;
		
	ИначеЕсли УчетВнеоборотныхАктивов = "2_4" 
		И НаборКонстант.ИспользоватьВнеоборотныеАктивы2_2
		И НЕ НаборКонстант.ИспользоватьВнеоборотныеАктивы2_4 Тогда
		
		ОткрытьФорму("Обработка.ПомощникПереходаНаУчетВнеоборотныхАктивовВерсии24.Форма");
		
		УчетВнеоборотныхАктивов = ЗначениеВыбораУчетВнеоборотныхАктивов(НаборКонстант);
		Отказ = Истина;
		
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// При понижении версии нужно предупредить пользователя
	ТекстВопроса = "";
	Если УчетВнеоборотныхАктивов = ""
		И (НаборКонстант.ИспользоватьВнеоборотныеАктивы2_2 
			ИЛИ НаборКонстант.ИспользоватьВнеоборотныеАктивы2_4) Тогда
			
		Если НаличиеУчета.ЕстьУчет 
			ИЛИ НаличиеУчета.ЕстьУчет2_2 
			ИЛИ НаличиеУчета.ЕстьУчет2_4 
			ИЛИ НаличиеУчета.ВедетсяУчетПлатежейВПлатон Тогда
			ТекстВопроса = НСтр("ru = 'Отключать учет внеоборотных активов после начала работы с системой не рекомендуется.
		                            |Продолжить редактирование?'");
		КонецЕсли;
		
	ИначеЕсли УчетВнеоборотныхАктивов = "2_2" И НаборКонстант.ИспользоватьВнеоборотныеАктивы2_4 Тогда
		
		Если НаличиеУчета.ЕстьУчет2_4 Тогда
				ТекстВопроса = НСтр("ru = 'Отключать учет внеоборотных активов версии 2.4 после начала работы с системой не рекомендуется.
				                 |Продолжить редактирование?'");
		КонецЕсли;
		
	КонецЕсли;
	
	Если ТекстВопроса <> "" Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("УчетВнеоборотныхАктивовПриИзмененииЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Иначе
		Подключаемый_ПриИзмененииРеквизита(Элемент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаУчетаВнеоборотныхАктивов2_4НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормыВыбораПериода = Новый Структура("Значение, РежимВыбораПериода", НаборКонстант.ДатаНачалаУчетаВнеоборотныхАктивов2_4, "МЕСЯЦ");
	ОписаниеОповещения = Новый ОписаниеОповещения("ДатаНачалаУчетаВнеоборотныхАктивов2_4Завершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборПериода",
		ПараметрыФормыВыбораПериода, 
		ЭтотОбъект, 
		ЭтотОбъект.УникальныйИдентификатор,,, 
		ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтображатьВнеоборотныеАктивы2_2ПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОбъектыСтроительстваПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьДокументыВнеоборотныхАктивовМеждународныйУчетПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьАмортизациюБухгалтерскогоУчетаПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьЛизингПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ПорядокУчетаВНАВУпрУчетеПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ВестиУчетПлатежейВПлатонПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьПомощникПерехода(Команда)
	
	ОткрытьФорму("Обработка.ПомощникПереходаНаУчетВнеоборотныхАктивовВерсии24.Форма");
	
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

&НаКлиенте
Процедура ДатаНачалаУчетаВнеоборотныхАктивов2_4Завершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если РезультатВыбора > ДоступностьУчета24.МаксимальнаяДатаНачалаУчета2_4 
		И ДоступностьУчета24.МаксимальнаяДатаНачалаУчета2_4 <> '000101010000' Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ДоступностьУчета24.КомментарийМаксДатаНачалаУчета2_4, , "НаборКонстант.ДатаНачалаУчетаВнеоборотныхАктивов2_4");
			
		НаборКонстант.ДатаНачалаУчетаВнеоборотныхАктивов2_4 = ДоступностьУчета24.МаксимальнаяДатаНачалаУчета2_4;
			
	ИначеЕсли РезультатВыбора < ДоступностьУчета24.МинимальнаяДатаНачалаУчета2_4 
		И ДоступностьУчета24.МинимальнаяДатаНачалаУчета2_4 <> '000101010000' Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ДоступностьУчета24.КомментарийМинДатаНачалаУчета2_4, , "НаборКонстант.ДатаНачалаУчетаВнеоборотныхАктивов2_4");
			
		НаборКонстант.ДатаНачалаУчетаВнеоборотныхАктивов2_4 = ДоступностьУчета24.МинимальнаяДатаНачалаУчета2_4;
		
	Иначе
		НаборКонстант.ДатаНачалаУчетаВнеоборотныхАктивов2_4 = РезультатВыбора;
	КонецЕсли;
	
	Подключаемый_ПриИзмененииРеквизита(Элементы.ДатаНачалаУчетаВнеоборотныхАктивов2_4, Ложь);
	Оповестить("ДатаНачалаУчетаВнеоборотныхАктивов2_4_Изменение", НаборКонстант.ДатаНачалаУчетаВнеоборотныхАктивов2_4, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура УчетВнеоборотныхАктивовПриИзмененииЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Подключаемый_ПриИзмененииРеквизита(Элементы.УчетВнеоборотныхАктивов);
	Иначе
		
		УчетВнеоборотныхАктивов = ЗначениеВыбораУчетВнеоборотныхАктивов(НаборКонстант);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ВызовСервера

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	КонстантаИмя = СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Новый Структура);
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат КонстантаИмя;
	
КонецФункции

#КонецОбласти

#Область Сервер

&НаСервере
Функция СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат)
	
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
		
		Если НастройкиСистемыПовтИсп.ЕстьПодчиненныеКонстанты(КонстантаИмя, КонстантаЗначение) Тогда
			ЭтаФорма.Прочитать();
		КонецЕсли;
		
	ИначеЕсли РеквизитПутьКДанным = "УчетВнеоборотныхАктивов" Тогда
		
		Если НастройкиСистемыПовтИсп.ЕстьПодчиненныеКонстанты("ИспользоватьВнеоборотныеАктивы2_2", НаборКонстант.ИспользоватьВнеоборотныеАктивы2_2)
			ИЛИ НастройкиСистемыПовтИсп.ЕстьПодчиненныеКонстанты("ИспользоватьВнеоборотныеАктивы2_4", НаборКонстант.ИспользоватьВнеоборотныеАктивы2_4) Тогда
			ЭтаФорма.Прочитать();
		КонецЕсли;
		
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "УчетВнеоборотныхАктивов" Тогда
		
		Если УчетВнеоборотныхАктивов = "2_2" Тогда
			КонстантаИмя = "ИспользоватьВнеоборотныеАктивы2_2";
			НаборКонстант.ИспользоватьВнеоборотныеАктивы2_2 = Истина;
			НаборКонстант.ИспользоватьВнеоборотныеАктивы2_4 = Ложь;
			НаборКонстант.ДатаНачалаУчетаВнеоборотныхАктивов2_4 = '000101010000';
		ИначеЕсли УчетВнеоборотныхАктивов = "2_4" Тогда
			КонстантаИмя = "ИспользоватьВнеоборотныеАктивы2_4";
			НаборКонстант.ИспользоватьВнеоборотныеАктивы2_4 = Истина;
			Если НаборКонстант.ИспользоватьВнеоборотныеАктивы2_2 Тогда
				Если ЗначениеЗаполнено(ДоступностьУчета24.МинимальнаяДатаНачалаУчета2_4) Тогда
					НаборКонстант.ДатаНачалаУчетаВнеоборотныхАктивов2_4 = НачалоМесяца(ДоступностьУчета24.МинимальнаяДатаНачалаУчета2_4);
				Иначе
					НаборКонстант.ДатаНачалаУчетаВнеоборотныхАктивов2_4 = НачалоМесяца(ДобавитьМесяц(ТекущаяДатаСеанса(), 1));
				КонецЕсли; 
			Иначе
				НаборКонстант.ДатаНачалаУчетаВнеоборотныхАктивов2_4 = '000101010000';
			КонецЕсли; 
		Иначе
			КонстантаИмя = "ИспользоватьВнеоборотныеАктивы2_2";
			НаборКонстант.ИспользоватьВнеоборотныеАктивы2_2 = Ложь;
			НаборКонстант.ИспользоватьВнеоборотныеАктивы2_4 = Ложь;
			НаборКонстант.ДатаНачалаУчетаВнеоборотныхАктивов2_4 = '000101010000';
		КонецЕсли;
		
		Константы.ИспользоватьВнеоборотныеАктивы2_2.Установить(НаборКонстант.ИспользоватьВнеоборотныеАктивы2_2);
		Константы.ИспользоватьВнеоборотныеАктивы2_4.Установить(НаборКонстант.ИспользоватьВнеоборотныеАктивы2_4);
		Константы.ДатаНачалаУчетаВнеоборотныхАктивов2_4.Установить(НаборКонстант.ДатаНачалаУчетаВнеоборотныхАктивов2_4);
		
		Если НаборКонстант.ОтображатьВнеоборотныеАктивы2_2 И НЕ НаборКонстант.ИспользоватьВнеоборотныеАктивы2_2 Тогда
			НаборКонстант.ОтображатьВнеоборотныеАктивы2_2 = Ложь;
			Константы.ОтображатьВнеоборотныеАктивы2_2.Установить(Ложь);
		ИначеЕсли НЕ НаборКонстант.ОтображатьВнеоборотныеАктивы2_2 И НаборКонстант.ИспользоватьВнеоборотныеАктивы2_2 Тогда
			НаборКонстант.ОтображатьВнеоборотныеАктивы2_2 = Истина;
			Константы.ОтображатьВнеоборотныеАктивы2_2.Установить(Истина);
		КонецЕсли; 
		
	КонецЕсли;
	
	Возврат КонстантаИмя
	
КонецФункции

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	ИспользоватьРеглУчет = Константы.ИспользоватьРеглУчет.Получить();
	
	НаличиеУчета = ОпределитьНаличиеУчета();
	ОпределитьДоступностьУчета2_4();
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьВнеоборотныеАктивы2_2" 
		ИЛИ РеквизитПутьКДанным = "НаборКонстант.ИспользоватьВнеоборотныеАктивы2_4" 
		ИЛИ РеквизитПутьКДанным = "УчетВнеоборотныхАктивов" 
		ИЛИ РеквизитПутьКДанным = "" Тогда
		
		ИспользуютсяОбеВерсии = НаборКонстант.ИспользоватьВнеоборотныеАктивы2_2 И НаборКонстант.ИспользоватьВнеоборотныеАктивы2_4;
		
		//
		Элементы.ОтображатьВнеоборотныеАктивы2_2.Видимость = ИспользуютсяОбеВерсии;
		Элементы.ДатаНачалаУчетаВнеоборотныхАктивов2_4.Видимость = ИспользуютсяОбеВерсии;
		Элементы.ИспользоватьОбъектыСтроительства.Видимость = НаборКонстант.ИспользоватьВнеоборотныеАктивы2_4;
		
		//
		Элементы.ГруппаВнеоборотныеАктивы22.Видимость = НаборКонстант.ИспользоватьВнеоборотныеАктивы2_2;
		Элементы.ГруппаВнеоборотныеАктивы22.ОтображатьЗаголовок = ИспользуютсяОбеВерсии;
		
		//
		Элементы.ГруппаВнеоборотныеАктивы24.Видимость = НаборКонстант.ИспользоватьВнеоборотныеАктивы2_4;
		Элементы.ГруппаВнеоборотныеАктивы24.ОтображатьЗаголовок = ИспользуютсяОбеВерсии;
		
		//
		Элементы.ВестиУчетПлатежейВПлатон.Видимость = 
			НаборКонстант.ИспользоватьВнеоборотныеАктивы2_2 
			ИЛИ НаборКонстант.ИспользоватьВнеоборотныеАктивы2_4;
			
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьВнеоборотныеАктивы2_2" 
		ИЛИ РеквизитПутьКДанным = "НаборКонстант.ИспользоватьВнеоборотныеАктивы2_4" 
		ИЛИ РеквизитПутьКДанным = "УчетВнеоборотныхАктивов" 
		ИЛИ РеквизитПутьКДанным = "НаборКонстант.ОтображатьВнеоборотныеАктивы2_2" 
		ИЛИ РеквизитПутьКДанным = "" Тогда
		
		Если НаборКонстант.ИспользоватьВнеоборотныеАктивы2_2 Тогда
			
			ПереносДанныхЗавершен = Обработки.ПомощникПереходаНаУчетВнеоборотныхАктивовВерсии24.ПереносДанныхЗавершен();
			Элементы.ОткрытьПомощникПерехода.Видимость = 
				(ПереносДанныхЗавершен <> Истина
					ИЛИ НаборКонстант.ОтображатьВнеоборотныеАктивы2_2
					ИЛИ НЕ НаборКонстант.ИспользоватьВнеоборотныеАктивы2_4);
			
		Иначе
			Элементы.ОткрытьПомощникПерехода.Видимость = Ложь;
		КонецЕсли; 
			
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьВнеоборотныеАктивы2_2" 
		ИЛИ РеквизитПутьКДанным = "НаборКонстант.ИспользоватьВнеоборотныеАктивы2_4" 
		ИЛИ РеквизитПутьКДанным = "УчетВнеоборотныхАктивов" 
		ИЛИ РеквизитПутьКДанным = "" Тогда
		
		УстановитьДоступностьИспользоватьЛизинг();
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьДокументыВнеоборотныхАктивовМеждународныйУчет"
		ИЛИ РеквизитПутьКДанным = "" Тогда
		
		ИспользоватьМФУ = Ложь;
		ИспользоватьДокументыВнеоборотныхАктивовМеждународныйУчет = Ложь;
		//++ НЕ УТКА
		ИспользоватьМФУ = Константы.ИспользоватьМеждународныйФинансовыйУчет.Получить();
		ИспользоватьДокументыВнеоборотныхАктивовМеждународныйУчет = НаборКонстант.ИспользоватьДокументыВнеоборотныхАктивовМеждународныйУчет;
		//-- НЕ УТКА
		
		Элементы.ГруппаИспользоватьДокументыВнеоборотныхАктивовМеждународныйУчет.Доступность = ИспользоватьМФУ;
		Элементы.ГруппаКомментарийВНАМеждународныйУчет.Видимость = 
			НЕ ИспользоватьМФУ И ПолучитьФункциональнуюОпцию("УправлениеПредприятием");
		//
		Элементы.ГруппаИспользоватьАмортизациюБухгалтерскогоУчета.Доступность =
			ИспользоватьРеглУчет И Не (ИспользоватьМФУ И ИспользоватьДокументыВнеоборотныхАктивовМеждународныйУчет);
		Элементы.ГруппаКомментарийИспользоватьАмортизациюБухгалтерскогоУчетаКА.Видимость =
		    НЕ ПолучитьФункциональнуюОпцию("УправлениеПредприятием")
			И (Не ИспользоватьРеглУчет ИЛИ (ИспользоватьМФУ И ИспользоватьДокументыВнеоборотныхАктивовМеждународныйУчет));
			
		//
		Элементы.ГруппаКомментарийИспользоватьАмортизациюБухгалтерскогоУчетаУП.Видимость =
			ПолучитьФункциональнуюОпцию("УправлениеПредприятием")
			И (Не ИспользоватьРеглУчет ИЛИ (ИспользоватьМФУ И ИспользоватьДокументыВнеоборотныхАктивовМеждународныйУчет));
	
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьОбъектыСтроительства" 
		ИЛИ РеквизитПутьКДанным = "УчетВнеоборотныхАктивов"
		ИЛИ РеквизитПутьКДанным = "" Тогда
		ОбщегоНазначенияУТКлиентСервер.ОтображениеПредупрежденияПриРедактировании(
			Элементы.ИспользоватьОбъектыСтроительства, 
			НаборКонстант.ИспользоватьОбъектыСтроительства И НаличиеУчета.ЕстьУчет2_4);
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "" Тогда
		
		ОбщегоНазначенияУТКлиентСервер.ОтображениеПредупрежденияПриРедактировании(
			Элементы.ПорядокУчетаВНАВУпрУчетеПоСтандартамРегл, НаличиеУчета.ЕстьУчет2_4);
			
		ОбщегоНазначенияУТКлиентСервер.ОтображениеПредупрежденияПриРедактировании(
			Элементы.ПорядокУчетаВНАВУпрУчетеПоСтандартамМУ, НаличиеУчета.ЕстьУчет2_4);
			
		ОбщегоНазначенияУТКлиентСервер.ОтображениеПредупрежденияПриРедактировании(
			Элементы.ДатаНачалаУчетаВнеоборотныхАктивов2_4, НаличиеУчета.ЕстьУчет2_4);
			
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ВестиУчетПлатежейВПлатон" 
		ИЛИ РеквизитПутьКДанным = "УчетВнеоборотныхАктивов"
		ИЛИ РеквизитПутьКДанным = "" Тогда
		
		ОбщегоНазначенияУТКлиентСервер.ОтображениеПредупрежденияПриРедактировании(
			Элементы.ВестиУчетПлатежейВПлатон, НаличиеУчета.ВедетсяУчетПлатежейВПлатон И НаборКонстант.ВестиУчетПлатежейВПлатон);
			
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ОпределитьНаличиеУчета()
	
	НаличиеУчета = Новый Структура;
	НаличиеУчета.Вставить("ЕстьУчет", ВнеоборотныеАктивыСлужебный.ЕстьУчетВнеоборотныхАктивов());
	НаличиеУчета.Вставить("ЕстьУчет2_2", ВнеоборотныеАктивыСлужебный.ЕстьУчетВнеоборотныхАктивов2_2());
	НаличиеУчета.Вставить("ЕстьУчет2_4", ВнеоборотныеАктивыСлужебный.ЕстьУчетВнеоборотныхАктивов2_4());
	НаличиеУчета.Вставить("ИспользуетсяУУНаПланеСчетовХозрасчетный", Константы.ВестиУУНаПланеСчетовХозрасчетный.Получить());
	НаличиеУчета.Вставить("ВедетсяУчетПлатежейВПлатон", ВнеоборотныеАктивыСлужебный.ВедетсяУчетПлатежейВПлатон());
	
	Возврат НаличиеУчета;

КонецФункции

&НаСервере
Процедура ОпределитьДоступностьУчета2_4()
	
	ДоступностьУчета24 = Новый ФиксированнаяСтруктура(ВнеоборотныеАктивыСлужебный.УсловияПереходаНаУчет2_4());
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ЗначениеВыбораУчетВнеоборотныхАктивов(НаборКонстант)

	Если НаборКонстант.ИспользоватьВнеоборотныеАктивы2_4 Тогда
		Возврат "2_4";
	ИначеЕсли НаборКонстант.ИспользоватьВнеоборотныеАктивы2_2 Тогда
		Возврат "2_2";
	Иначе
		Возврат "";
	КонецЕсли; 

КонецФункции

&НаСервере
Процедура УстановитьДоступностьИспользоватьЛизинг()
	
	Элементы.ГруппаИспользоватьЛизинг.Видимость = НаборКонстант.ИспользоватьВнеоборотныеАктивы2_2
		Или НаборКонстант.ИспользоватьВнеоборотныеАктивы2_4;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти