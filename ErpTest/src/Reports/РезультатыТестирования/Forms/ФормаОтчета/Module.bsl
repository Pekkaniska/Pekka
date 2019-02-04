#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Параметры.ПутьКФайлу) Тогда
		Элементы.ИмяФайла.Видимость = Ложь;
		Отчет.АдресХранилища = Параметры.ПутьКФайлу;
		ИнициализироватьКомпоновку();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	
	ДиалогВыбораФайла.Фильтр = НСтр("ru='Файл результатов сравнения (*.xml)|*.xml'");
	ДиалогВыбораФайла.Заголовок = Заголовок;
	ДиалогВыбораФайла.ПредварительныйПросмотр = Ложь;
	ДиалогВыбораФайла.Расширение = "xml";
	ДиалогВыбораФайла.ИндексФильтра = 0;
	ДиалогВыбораФайла.ПолноеИмяФайла = Элемент.ТекстРедактирования;
	ДиалогВыбораФайла.ПроверятьСуществованиеФайла = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ИмяФайлаЗавершениеВыбора", ЭтотОбъект);
	ДиалогВыбораФайла.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаЗавершениеВыбора(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	Если ВыбранныеФайлы <> Неопределено Тогда
		ПолноеИмяФайла = ВыбранныеФайлы[0];
		ОписаниеОповещения = Новый ОписаниеОповещения(
	  		"ПослеПомещенияФайла", ЭтотОбъект);
		НачатьПомещениеФайла(ОписаниеОповещения,,
			ПолноеИмяФайла,  Ложь,
			УникальныйИдентификатор);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеПомещенияФайла(Результат, Адрес, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт  

   Отчет.АдресХранилища = Адрес;
   ИнициализироватьКомпоновку();
   ИмяФайла = ВыбранноеИмяФайла;

КонецПроцедуры

&НаСервере
Процедура ИнициализироватьКомпоновку()
	
	СхемаКомпоновкиДанных = Новый СхемаКомпоновкиДанных;
	КомпоновщикНастроек = Отчет.КомпоновщикНастроек;
	
	Источник = СхемаКомпоновкиДанных.ИсточникиДанных.Добавить();
	Источник.Имя = "ЛокальнаяБаза";
	Источник.СтрокаСоединения = "";
	Источник.ТипИсточникаДанных = "Local";
	
	НастройкиКомпоновкиДанных = СхемаКомпоновкиДанных.НастройкиПоУмолчанию;
	ВнешниеНаборыДанных = Новый Структура();
	
	ПутьКФайлу = ПолучитьИмяВременногоФайла("xml");
	
	ФайлОтчета = ПолучитьИзВременногоХранилища(Отчет.АдресХранилища);
	ФайлОтчета.Записать(ПутьКФайлу);
	Чтение = Новый ЧтениеXML;
	Чтение.ОткрытьФайл(ПутьКФайлу);
	
	Пока Чтение.Прочитать() Цикл
		Если ЗначениеЗаполнено(Чтение.Значение) Тогда
			Если Чтение.КонтекстПространствИмен.Глубина = 3 Тогда // это объект метаданных, формируем по нему группировку и таблицу.
				Попытка
					ОбъектМетаданных = ОбщегоНазначения.ЗначениеИзСтрокиXML(Чтение.Значение);
					МассивСтрокОбъекта = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ОбъектМетаданных, ".");
					ТипОбъекта = МассивСтрокОбъекта.Получить(0);
					ИмяОбъекта = МассивСтрокОбъекта.Получить(1);
				Исключение
					ОбъектМетаданных = Неопределено;
					Продолжить;
				КонецПопытки;
				
				Если СхемаКомпоновкиДанных.НаборыДанных.Найти(ИмяОбъекта) <> Неопределено Тогда // уже добавлен в схему
					НаборДанных = СхемаКомпоновкиДанных.НаборыДанных[ИмяОбъекта];
					Продолжить;
				КонецЕсли;
				
				// каждый объект метаданных это новый отдельный набор данных для СКД.
				НаборДанных = СхемаКомпоновкиДанных.НаборыДанных.Добавить(Тип("НаборДанныхОбъектСхемыКомпоновкиДанных"));
				НаборДанных.Имя = ИмяОбъекта;
				НаборДанных.ИмяОбъекта = ИмяОбъекта;
				НаборДанных.ИсточникДанных = "ЛокальнаяБаза";
				
				// группировка таблиц по объектам метаданных: один объект - одна таблица.
				Таблица = НастройкиКомпоновкиДанных.Структура.Добавить(Тип("ТаблицаКомпоновкиДанных"));
				Таблица.Имя = ИмяОбъекта;
				
				НастройкиКомпоновкиДанных.ПараметрыВывода.УстановитьЗначениеПараметра("АвтоПозицияРесурсов", АвтоПозицияРесурсовКомпоновкиДанных.НеИспользовать);
				ЗаголовокТаблицы = Таблица.ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Заголовок"));
				Если ЗаголовокТаблицы <> Неопределено Тогда
					ЗаголовокТаблицы.Значение = "Таблица: " + ОбъектМетаданных;
					ЗаголовокТаблицы.Использование = Истина;
				КонецЕсли;
				
				Строки = Таблица.Строки.Добавить();
				Строки.ПараметрыВывода.УстановитьЗначениеПараметра("АвтоПозицияРесурсов", АвтоПозицияРесурсовКомпоновкиДанных.НеИспользовать);
				
				ПолеГруппировкаРегистратор = Строки.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
				ПолеГруппировкаРегистратор.Поле = Новый ПолеКомпоновкиДанных(ИмяОбъекта + "_Регистратор");
				ПолеГруппировкаРегистратор.Использование = Истина;
				
				ГруппировкаРегистратор = Строки.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
				ГруппировкаРегистратор.Поле = Новый ПолеКомпоновкиДанных(ИмяОбъекта + "_Регистратор");
				ГруппировкаРегистратор.Использование = Истина;
				
				ГруппировкаДельта = Строки.Структура.Добавить();
				
				ПолеВыбораРегистратор = ГруппировкаДельта.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
				ПолеВыбораРегистратор.Поле = Новый ПолеКомпоновкиДанных(ИмяОбъекта + "_Регистратор");
				ПолеВыбораРегистратор.Использование = Истина;
				
				ПолеГруппировкиДельта = ГруппировкаДельта.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
				ПолеГруппировкиДельта.Поле = Новый ПолеКомпоновкиДанных(ИмяОбъекта + "_Регистратор");
				ПолеГруппировкиДельта.Использование = Истина;
				// поля группировки определим позже
				
				ДетальныеЗаписи = ГруппировкаДельта.Структура.Добавить();
				ДетальныеЗаписи.Имя = ГруппировкаДельта.Имя + "_ДетальныеЗаписи";
				ДетальныеЗаписи.Использование = Истина;
				// поля группировки определим позже
				
			ИначеЕсли Чтение.КонтекстПространствИмен.Глубина = 4 И ИмяОбъекта <> Неопределено Тогда // это записи, выводим их в таблицу.
				
				Попытка
					Набор = ОбщегоНазначения.ЗначениеИзСтрокиXML(Чтение.Значение);
				Исключение
					Продолжить;
				КонецПопытки;
				Для Каждого Колонка Из Набор.Колонки Цикл
					
					ИмяПоля = "" + ИмяОбъекта + "_" + Колонка.Имя;
					
					Если НаборДанных.Поля.Найти(ИмяПоля) <> Неопределено Тогда // уже есть в схеме, добавлять не надо
						Продолжить;
					КонецЕсли;
					
					Поле             = НаборДанных.Поля.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
					Поле.Заголовок   = Колонка.Имя;
					Поле.Поле        = Колонка.Имя;
					Поле.ПутьКДанным = ИмяПоля;
					Поле.ТипЗначения = Колонка.ТипЗначения;
					
					МаксимальнаяШирина = Поле.Оформление.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("МаксимальнаяШирина"));
					Если МаксимальнаяШирина <> Неопределено Тогда
						МаксимальнаяШирина.Значение = 15;
						МаксимальнаяШирина.Использование = Истина;
					КонецЕсли;
					
					Если Колонка.ТипЗначения.СодержитТип(Тип("Число")) Тогда // создаем вычисляемое поле и рассчитываем дельту старых и новых записей.
						
						ВычисляемоеПолеПутьКДанным = ИмяОбъекта + "_Вычисляемое_" + Колонка.Имя;
						Если СхемаКомпоновкиДанных.ВычисляемыеПоля.Найти(ВычисляемоеПолеПутьКДанным) <> Неопределено Тогда
							Продолжить;
						КонецЕсли;
						ВычисляемоеПоле = СхемаКомпоновкиДанных.ВычисляемыеПоля.Добавить();
						ВычисляемоеПоле.ПутьКДанным = ИмяОбъекта + "_Вычисляемое_" + Колонка.Имя;
						Шаблон = "ВЫБОР КОГДА %ОбъектМетаданных%_ТипЗаписиТестирования = ""ИсходныеЗаписи"" ТОГДА -%ИмяПоля% ИНАЧЕ %ИмяПоля% КОНЕЦ";
						ВычисляемоеПоле.Выражение = СтрЗаменить(Шаблон, "%ИмяПоля%", ИмяПоля);
						ВычисляемоеПоле.Выражение = СтрЗаменить(ВычисляемоеПоле.Выражение, "%ОбъектМетаданных%", ИмяОбъекта);
						ВычисляемоеПоле.ТипЗначения = Колонка.ТипЗначения;
						ВычисляемоеПоле.Заголовок = Колонка.Имя;
						ВычисляемоеПоле.Оформление.УстановитьЗначениеПараметра("ВыделятьОтрицательные", Истина);
						ВычисляемоеПоле.Оформление.УстановитьЗначениеПараметра("МаксимальнаяШирина", 15);
						
						ПолеИтога = СхемаКомпоновкиДанных.ПоляИтога.Добавить();
						ПолеИтога.ПутьКДанным = ВычисляемоеПоле.ПутьКДанным;
						ПолеИтога.Выражение = "СУММА(" + ВычисляемоеПоле.ПутьКДанным + ")";
						ПолеИтога.Группировки.Добавить(ИмяОбъекта + "_Регистратор");
						
						ПолеЗначения = СхемаКомпоновкиДанных.ПоляИтога.Добавить();
						ПолеЗначения.ПутьКДанным = ВычисляемоеПоле.ПутьКДанным;
						ПолеЗначения.Выражение = ИмяПоля;
						ПолеЗначения.Группировки.Добавить(ИмяОбъекта + "_ТипЗаписиТестирования");
						
						ИмяПоля = ВычисляемоеПоле.ПутьКДанным;
						
						ПолеГруппировкиРегистратор = Строки.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
						ПолеГруппировкиРегистратор.Поле = Новый ПолеКомпоновкиДанных(ИмяПоля);
						
						ПолеГруппировкиДельта = ГруппировкаДельта.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
						ПолеГруппировкиДельта.Поле = Новый ПолеКомпоновкиДанных(ИмяПоля);
					Иначе
						Если Колонка.Имя <> "ТипЗаписиТестирования" И Колонка.Имя <> "Регистратор" Тогда // добавим в группировку по дельте
							ПолеГруппировкиДельта = ГруппировкаДельта.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
							ПолеГруппировкиДельта.Поле = Новый ПолеКомпоновкиДанных(ИмяПоля);
							ПолеГруппировкиДельта.Использование = Истина;

							ПолеГруппировкиДельта = ГруппировкаДельта.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
							ПолеГруппировкиДельта.Поле = Новый ПолеКомпоновкиДанных(ИмяПоля);
						КонецЕсли;
						Если Колонка.Имя <> "Регистратор" Тогда // выведем в детальные записи
							ПолеГруппировкиДетальныеЗаписи = ДетальныеЗаписи.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
							ПолеГруппировкиДетальныеЗаписи.Поле = Новый ПолеКомпоновкиДанных(ИмяПоля);
							ПолеГруппировкиДетальныеЗаписи.Использование = Истина;
						КонецЕсли;
					КонецЕсли;
					Если Колонка.Имя <> "Регистратор" И Колонка.Имя <> "ИмяРегистра" И Колонка.Имя <> "ПолноеИмяРегистра" Тогда // добавим в группировку по дельте
						ПолеГруппировкиДетальныеЗаписи = ДетальныеЗаписи.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
						ПолеГруппировкиДетальныеЗаписи.Поле = Новый ПолеКомпоновкиДанных(ИмяПоля);
					КонецЕсли;
					Если Колонка.Имя <> "ТипЗаписиТестирования" Тогда 
						ПолеПорядка = ДетальныеЗаписи.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
						ПолеПорядка.Поле = Новый ПолеКомпоновкиДанных(ИмяПоля);
						ПолеПорядка.Использование = Истина;
						ПолеПорядка.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
					КонецЕсли;
				КонецЦикла;
				ВнешниеНаборыДанных.Вставить(ИмяОбъекта, Набор);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
		
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	КомпоновщикНастроек.ЗагрузитьНастройки(НастройкиКомпоновкиДанных);
	
	Отчет.КомпоновщикНастроек = КомпоновщикНастроек;
		
	НастройкиКомпоновкиДанных = КомпоновщикНастроек.ПолучитьНастройки();
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	Макет = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиКомпоновкиДанных);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(Макет, ВнешниеНаборыДанных);
	
	Чтение.Закрыть(); // освобождаем файл
	УдалитьФайлы(ПутьКФайлу);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, СтандартнаяОбработка)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	УдалитьВременныеФайлыНаСервере();
КонецПроцедуры

&НаСервере
Процедура УдалитьВременныеФайлыНаСервере()
	Если ЗначениеЗаполнено(Отчет.ПутьКФайлу) Тогда
		УдалитьФайлы(Отчет.ПутьКФайлу);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры)
	СтандартнаяОбработка = Ложь;
	РезультатРасшифровки = РезультатОбработкаРасшифровкиСервер(Расшифровка);
	
	ТекстСообщения = НСтр("ru = 'Представление: %Представление% || Значение: %Значение% || Тип: %Тип%'");
	ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Представление%", Строка(РезультатРасшифровки.Значение));
	ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Тип%", Строка(ТипЗнч(РезультатРасшифровки.Значение)));
	
	Если РезультатРасшифровки.ЭтоПеречисление Тогда
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Значение%", РезультатРасшифровки.ИмяЗначенияПеречисления);
	ИначеЕсли РезультатРасшифровки.ЭтоСсылка Тогда
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Значение%", Строка(РезультатРасшифровки.Значение.УникальныйИдентификатор())); 
	Иначе
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Значение%", Строка(РезультатРасшифровки.Значение)); 
	КонецЕсли;
	
	Если РезультатРасшифровки.ЭтоСсылка Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,РезультатРасшифровки.Значение);
		Если ЗначениеЗаполнено(РезультатРасшифровки.Значение) Тогда
			ПоказатьЗначение(Неопределено, РезультатРасшифровки.Значение);
		КонецЕсли;
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция РезультатОбработкаРасшифровкиСервер(Расшифровка)
	РасшифровкаДанные = ПолучитьИзВременногоХранилища(ДанныеРасшифровки);
	Значение =  РасшифровкаДанные.Элементы[Расшифровка].ПолучитьПоля()[0].Значение;
	
	РезультатРасшифровки = Новый Структура;
	
	ЭтоСсылка = ОбщегоНазначения.ЭтоСсылка(ТипЗнч(Значение));
	РезультатРасшифровки.Вставить("ЭтоСсылка", ЭтоСсылка);
	РезультатРасшифровки.Вставить("Значение", Значение);
	
	Если ЭтоСсылка
		И ОбщегоНазначения.ЭтоПеречисление(Значение.Метаданные()) Тогда
		РезультатРасшифровки.Вставить("ЭтоПеречисление", Истина);
		РезультатРасшифровки.Вставить("ИмяЗначенияПеречисления", ОбщегоНазначения.ИмяЗначенияПеречисления(Значение));
	Иначе
		РезультатРасшифровки.Вставить("ЭтоПеречисление", Ложь);
		РезультатРасшифровки.Вставить("ИмяЗначенияПеречисления","");
	КонецЕсли;		
	
	Возврат РезультатРасшифровки;
КонецФункции

#КонецОбласти