
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НастроитьПолеКодировкаФайла();
	
	ПроизвольныйПериод         = Новый СтандартныйПериод;
	ПроизвольныйПериод.Вариант = ВариантСтандартногоПериода.Вчера;
	Объект.ДатаНач             = ПроизвольныйПериод.ДатаНачала;
	Объект.ДатаКон             = ПроизвольныйПериод.ДатаОкончания;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ИнициализацияКомпоновщика();
	
	Если Объект.ПоляФайлаОбмена.Количество() = 0 Тогда
		СброситьНастройкиПолейФайлаОбмена();
	КонецЕсли;
	
	Если Объект.Разделитель = Неопределено Или ПустаяСтрока(СокрЛП(Объект.Разделитель)) Тогда
		Объект.Разделитель = ";";
	КонецЕсли;
	
	Если Объект.Разделитель = Символы.Таб Тогда 
		РазделительТабулятор(Неопределено);
	Иначе 
		РазделительСимвол(Неопределено);
	КонецЕсли;
	
	Элементы.ИнфНадписьЗагрузкаЗавершена.Заголовок = "загрузка не выполнена";
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьИнтервал(Команда)
	
	ПроизвольныйПериод               = Новый СтандартныйПериод;
	ПроизвольныйПериод.Вариант       = ВариантСтандартногоПериода.ПроизвольныйПериод;
	ПроизвольныйПериод.ДатаНачала    = Объект.ДатаНач;
	ПроизвольныйПериод.ДатаОкончания = Объект.ДатаКон;
	
	ДиалогВыбораПериода        = Новый ДиалогРедактированияСтандартногоПериода();
	ДиалогВыбораПериода.Период = ПроизвольныйПериод;
	
	ДиалогВыбораПериода.Показать(Новый ОписаниеОповещения("УстановитьИнтервалЗавершение", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗагрузку(Команда)
	
	Если Объект.ТаблицаДанных.Количество() = 0 Тогда
		Элементы.СтраницыЗагрузки.ТекущаяСтраница = Элементы.СтраницыЗагрузки.ПодчиненныеЭлементы.СтраницаОсновное;
		ТекстОшибки = "Не загружены данные из файла";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,,"Объект.ТаблицаДанных");
		Элементы.ИнфНадписьЗагрузкаЗавершена.Заголовок = "нет данных для загрузки в регистр";
		Элементы.ИнфНадписьЗагрузкаЗавершена.ЦветТекста = Новый Цвет(255,0,0);
		Возврат;
	КонецЕсли; 
	
	ПоказатьВопрос(Новый ОписаниеОповещения("ВыполнитьЗагрузкуЗавершение", ЭтотОбъект),
		"Выполнить загрузку регистра сведений?", РежимДиалогаВопрос.ОКОтмена);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьФО(Команда)
	
	Если ПустаяСтрока(Объект.Разделитель) И Не Объект.Разделитель = Символы.Таб Тогда
		ТекстОшибки = "Не указан разделитель";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,,"Объект.Разделитель");
		Возврат;
	КонецЕсли; 
	
	ПоказатьВопрос(Новый ОписаниеОповещения("ПрочитатьФОЗавершение", ЭтотОбъект),
		"Выполнить загрузку данных GPS из файла?", РежимДиалогаВопрос.ОКОтмена);
	
КонецПроцедуры

&НаКлиенте
Процедура РазделительСимвол(Команда)
	
	Если Объект.Разделитель = Символы.Таб Или ПустаяСтрока(СокрЛП(Объект.Разделитель))Тогда
		Объект.Разделитель = ";";
	КонецЕсли;
	
	Элементы.РазделительКонтекстноеМенюРазделительТабулятор.Пометка = Ложь;
	Элементы.РазделительКонтекстноеМенюРазделительСимвол.Пометка    = Истина;
	
	Элементы.Разделитель.ТолькоПросмотр = Ложь;
	Элементы.Разделитель.ЦветФона       = Новый Цвет(255,255,255)
	
КонецПроцедуры

&НаКлиенте
Процедура РазделительТабулятор(Команда)
	
	Элементы.РазделительКонтекстноеМенюРазделительТабулятор.Пометка = Истина;
	Элементы.РазделительКонтекстноеМенюРазделительСимвол.Пометка    = Ложь;
	
	Объект.Разделитель = Символы.Таб;
	
	Элементы.Разделитель.ТолькоПросмотр = Истина;
	Элементы.Разделитель.ЦветФона       = Новый Цвет(252,250,235);
	
КонецПроцедуры

&НаКлиенте
Процедура СброситьПоля(Команда)
	
	ПоказатьВопрос(Новый ОписаниеОповещения("СброситьПоляЗавершение", ЭтотОбъект),
		"Установить настройки по умолчанию?", РежимДиалогаВопрос.ОКОтмена);
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НастроитьПолеКодировкаФайла()
	
	Элементы.КодировкаФайла.СписокВыбора.Добавить("UTF-8",  "UTF-8");
	Элементы.КодировкаФайла.СписокВыбора.Добавить("UTF-16", "UTF-16");
	Элементы.КодировкаФайла.СписокВыбора.Добавить("ANSI",   "ANSI");
	Элементы.КодировкаФайла.СписокВыбора.Добавить("OEM",    "OEM");
	
	КодировкаФайла = "UTF-8";
	
КонецПроцедуры

&НаКлиенте
Процедура СброситьНастройкиПолейФайлаОбмена()
	
	Объект.ПоляФайлаОбмена.Очистить();
	НоваяСтрока = Объект.ПоляФайлаОбмена.Добавить(); НоваяСтрока.Использование = Истина; НоваяСтрока.Поле = "Дата";
	НоваяСтрока = Объект.ПоляФайлаОбмена.Добавить(); НоваяСтрока.Использование = Истина; НоваяСтрока.Поле = "Время";
	НоваяСтрока = Объект.ПоляФайлаОбмена.Добавить(); НоваяСтрока.Использование = Истина; НоваяСтрока.Поле = "ТС";
	НоваяСтрока = Объект.ПоляФайлаОбмена.Добавить(); НоваяСтрока.Использование = Истина; НоваяСтрока.Поле = "Лат";
	НоваяСтрока = Объект.ПоляФайлаОбмена.Добавить(); НоваяСтрока.Использование = Истина; НоваяСтрока.Поле = "Лон";
	НоваяСтрока = Объект.ПоляФайлаОбмена.Добавить(); НоваяСтрока.Использование = Истина; НоваяСтрока.Поле = "Пункт";
	НоваяСтрока = Объект.ПоляФайлаОбмена.Добавить(); НоваяСтрока.Использование = Ложь;   НоваяСтрока.Поле = "Скорость";
	НоваяСтрока = Объект.ПоляФайлаОбмена.Добавить(); НоваяСтрока.Использование = Ложь;   НоваяСтрока.Поле = "ЗначениеОдометра";
	НоваяСтрока = Объект.ПоляФайлаОбмена.Добавить(); НоваяСтрока.Использование = Ложь;   НоваяСтрока.Поле = "ПотребленноеТопливо";
	НоваяСтрока = Объект.ПоляФайлаОбмена.Добавить(); НоваяСтрока.Использование = Ложь;   НоваяСтрока.Поле = "УровеньТоплива";
	НоваяСтрока = Объект.ПоляФайлаОбмена.Добавить(); НоваяСтрока.Использование = Ложь;   НоваяСтрока.Поле = "ЗначениеДатчика1";
	НоваяСтрока = Объект.ПоляФайлаОбмена.Добавить(); НоваяСтрока.Использование = Ложь;   НоваяСтрока.Поле = "ЗначениеДатчика2";
	НоваяСтрока = Объект.ПоляФайлаОбмена.Добавить(); НоваяСтрока.Использование = Ложь;   НоваяСтрока.Поле = "ЗначениеДатчика3";
	НоваяСтрока = Объект.ПоляФайлаОбмена.Добавить(); НоваяСтрока.Использование = Ложь;   НоваяСтрока.Поле = "ЗначениеДатчика4";
	НоваяСтрока = Объект.ПоляФайлаОбмена.Добавить(); НоваяСтрока.Использование = Ложь;   НоваяСтрока.Поле = "ЗначениеДатчика5";
	
КонецПроцедуры

&НаСервере
Функция ПолучитьТаблицуОтбор(ТекстОшибки)
	
	ОтборКомп = КомпоновщикОтбора.ПолучитьНастройки();
	ПустойОтбор = Новый ПолеКомпоновкиДанных("");
	Для Каждого ТекОтбор Из ОтборКомп.Отбор.Элементы Цикл
		Если ТекОтбор.Использование И ТекОтбор.ЛевоеЗначение = ПустойОтбор Тогда
			ТекстОшибки = "Некорректно настроены отборы!";
			Возврат Новый ТаблицаЗначений;
		КонецЕсли;
	КонецЦикла;
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	Макет = КомпоновщикМакета.Выполнить(ПолучитьИзВременногоХранилища(АдресСхемыКомпоновкиДанных),
       КомпоновщикОтбора.ПолучитьНастройки(), , ,
       Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(Макет, , , Истина);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ТЗ =  Новый ТаблицаЗначений;
	ПроцессорВывода.УстановитьОбъект(ТЗ);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	Возврат ТЗ;
	
КонецФункции // ПолучитьТаблицуОтбор()

//Считывает одну строку файла обмена и добавляет позицию номенклатуры в дерево
&НаСервере
Процедура ДобавитьСтрокуФайлаВТаблицу(СтрокаОбмена, флОтборТСУстановлен, тблОтборТС)
	
	Если ПустаяСтрока(СтрокаОбмена) Тогда
		Возврат;
	КонецЕсли; 
	
	//Формат строки по умолчанию:
	Формат_строки_по_умолчанию = "Дата Время ТС Лат Лон Скорость Пункт ЗначениеОдометра ПотребленноеТопливо УровеньТоплива ЗначениеДатчика1 ЗначениеДатчика2 ЗначениеДатчика3 ЗначениеДатчика4 ЗначениеДатчика5";
		
	//обрезаем кавычки и добавляем справа доп. разделитель
	ОригинальнаяСтрокаОбмена = СтрокаОбмена;
	СтрокаОбмена = СтрокаОбмена + Объект.Разделитель;//Символы.Таб;
	
	//считаем поля из строки
	списПодстрокиПоля = Новый СписокЗначений; //массив полей, выделенных из строки
	Пока Истина Цикл
		НомРазделителя = Найти(СтрокаОбмена, Объект.Разделитель); //Символы.Таб);
		Если НомРазделителя = 0 Тогда
			Прервать;
		КонецЕсли;
		ПодстрокаПоле = Лев(СтрокаОбмена, НомРазделителя - 1);
		
		списПодстрокиПоля.Добавить(ПодстрокаПоле);
		СтрокаОбмена = Сред(СтрокаОбмена, НомРазделителя + 1);
	КонецЦикла;
	
	Если списПодстрокиПоля.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	//промежуточная структура, необходимая для первоначального заполнения строки без помещения в таблицу данных,
	//для возможности отбора, если он установлен
	ТекСтруктураДанных = Новый Структура("Дата, Время, ТС, ПредставлениеТС, Лат, Лон, Пункт, Скорость, ЗначениеОдометра, ПотребленноеТопливо, УровеньТоплива, ЗначениеДатчика1, ЗначениеДатчика2, ЗначениеДатчика3, ЗначениеДатчика4, ЗначениеДатчика5");
	
	НомПоля = 1;
	Для Каждого ТекПодстрока Из списПодстрокиПоля Цикл
		НомПоляНастройка = 1;
		Для Каждого ТекСтрокаПолеНастройка Из Объект.ПоляФайлаОбмена Цикл //поиск имени поля в таблице настроек
			Если НомПоляНастройка = НомПоля Тогда
				ТекИмяПоля = ТекСтрокаПолеНастройка.Поле;
				Если ТекИмяПоля = "ТС" Тогда
					ТекСтруктураДанных.ПредставлениеТС = Строка(ТекПодстрока.Значение);
					ТекСтруктураДанных[ТекИмяПоля] = Справочники.ТранспортныеСредства.НайтиПоРеквизиту("уатИДвСистемеНавигации", ТекПодстрока.Значение);
				ИначеЕсли ТекИмяПоля = "Дата" Тогда
					ТекСтруктураДанных[ТекИмяПоля] = Дата(Сред(ТекПодстрока.Значение, 7, 4) + Сред(ТекПодстрока.Значение, 4, 2) + Лев(ТекПодстрока.Значение, 2) + "000000");
				ИначеЕсли ТекИмяПоля = "Время" Тогда
					ТекСтруктураДанных[ТекИмяПоля] = Дата("00010101" + СтрЗаменить(ТекПодстрока.Значение, ":", ""));
				Иначе
					ТекСтруктураДанных[ТекИмяПоля] = Строка(ТекПодстрока.Значение);
				КонецЕсли;
				Прервать;
			КонецЕсли;
			НомПоляНастройка = НомПоляНастройка + 1;
		КонецЦикла;
		
		НомПоля = НомПоля + 1;
	КонецЦикла;
	
	ТекДата = ТекСтруктураДанных.Дата + (ТекСтруктураДанных.Время - '00010101');
	
	Если ((Не флОтборТСУстановлен) Или тблОтборТС.Найти(ТекСтруктураДанных.ПредставлениеТС, "ИДвСистемеНавигации") <> Неопределено)
		И ТекДата >= Объект.ДатаНач И ТекДата <= Объект.ДатаКон Тогда
		НоваяСтрокаДанных = Объект.ТаблицаДанных.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаДанных, ТекСтруктураДанных);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьКодировкуТекста()
	
	Если КодировкаФайла = "UTF-8" Тогда 
		Возврат КодировкаТекста.UTF8;
	ИначеЕсли КодировкаФайла = "UTF-16" Тогда 
		Возврат КодировкаТекста.UTF16;
	ИначеЕсли КодировкаФайла = "ANSI" Тогда 
		Возврат КодировкаТекста.ANSI;
	ИначеЕсли КодировкаФайла = "OEM" Тогда 
		Возврат КодировкаТекста.OEM;
	Иначе 
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции // ПолучитьКодировкуТекста()

&НаСервере
Процедура ЗагрузитьФайлОбмена(ТекстОшибки)
	
	УникальныйИД = Новый УникальныйИдентификатор;
	
	ИмяВременногоФайлаОбмена = КаталогВременныхФайлов() + УникальныйИД + "_data.txt";
	
	ДанныеХранилища = ПолучитьИзВременногоХранилища(ХранилищеФайлаВыгрузки);
	ДанныеХранилища.Записать(ИмяВременногоФайлаОбмена);
	
	//Сначала очистим таблицу номенклатур для загрузки
	Объект.ТаблицаДанных.Очистить();
	
	//Проверим заполнение структуры файла
	ПарамОтбораСтрок = Новый Структура;
	ПарамОтбораСтрок.Вставить("Использование", Истина);
	МассНайденныхСтрок = Объект.ПоляФайлаОбмена.НайтиСтроки(ПарамОтбораСтрок);
	Если МассНайденныхСтрок.Количество() = 0 Тогда
		ТекстОшибки = "Не выбраны поля в таблице полей файла обмена";
		Возврат;
	КонецЕсли;
	
	//Проверим наличие файла
	ФайлОб = Новый Файл(ИмяВременногоФайлаОбмена);
	Если Не ФайлОб.Существует() Тогда
		ТекстОшибки = "Неудалось прочитать Файл обмена на сервере";
		Возврат;
	КонецЕсли;
	
	МассивНоменклатуры = Новый Массив;
	
	//проверяем установлен ли отбор по ТС, если не установлен то запрос не будем использовать вообще
	флОтборТСУстановлен = Ложь;
	тблОтборТС = Новый ТаблицаЗначений;
	Для Каждого ТекОтбор Из КомпоновщикОтбора.Настройки.Отбор.Элементы Цикл
		Если ТекОтбор.Использование Тогда
			флОтборТСУстановлен = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Если флОтборТСУстановлен Тогда
		тблОтборТС = ПолучитьТаблицуОтбор(ТекстОшибки);
		тблОтборТС.Индексы.Добавить("ИДвСистемеНавигации");
	КонецЕсли;
	
	//Считаем файл
	ФайлОбменаОбъект = Новый ЧтениеТекста(ИмяВременногоФайлаОбмена, ПолучитьКодировкуТекста());
	
	Попытка
		ТекстДок = Новый ТекстовыйДокумент;
		ТекстДок.Прочитать(ИмяВременногоФайлаОбмена);
		ВсегоСтрок = ТекстДок.КоличествоСтрок();
	Исключение
		ВсегоСтрок = "?";
	КонецПопытки;
	НомСтроки = 1;
	
	СтрокаФайлаОбмена = "";
	Пока Не СтрокаФайлаОбмена = Неопределено Цикл
		СтрокаФайлаОбмена = ФайлОбменаОбъект.ПрочитатьСтроку();
		
		Если (СтрокаФайлаОбмена <> Неопределено) И (НЕ ПустаяСтрока(СокрЛП(СтрокаФайлаОбмена))) Тогда
			//Для каждой строки файла обмена сформируем строку
			СтрокаФайлаОбмена = СокрЛП(СтрокаФайлаОбмена);
			Попытка
				ДобавитьСтрокуФайлаВТаблицу(СтрокаФайлаОбмена, флОтборТСУстановлен, тблОтборТС);
			Исключение
				ТекстОшибки = "Произошла ошибка при загрузке данных.";
				Возврат;
			КонецПопытки;
		КонецЕсли;
		
		НомСтроки = НомСтроки + 1;
	КонецЦикла;
	
	ФайлОбменаОбъект.Закрыть();
	
	Попытка
		УдалитьФайлы(ИмяВременногоФайлаОбмена);  // Удаляем временный файл обмена
	Исключение КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузкаРегистраМестонахождениеGPS()
	
	ВсегоСтрок = Объект.ТаблицаДанных.Количество();
	Для Каждого ТекСтрока Из Объект.ТаблицаДанных Цикл
		МенеджерЗаписиМестоположениеGPS = РегистрыСведений.уатМестоположениеПоGPS.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(МенеджерЗаписиМестоположениеGPS, ТекСтрока);
		МенеджерЗаписиМестоположениеGPS.Период = ТекСтрока.Дата + (ТекСтрока.Время - '00010101');
		
		Попытка
			МенеджерЗаписиМестоположениеGPS.Записать();
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не удалось записать: " + (ТекСтрока.Дата + (ТекСтрока.Время - '00010101')) + "; " + ТекСтрока.ТС);
		КонецПопытки;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ИнициализацияКомпоновщика()
	
	СхемаКомпоновкиДанных = Обработки.уатЗагрузкаДанныхGPS.ПолучитьМакет("НастройкиПостроителя");
	АдресСхемыКомпоновкиДанных = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, УникальныйИдентификатор);
	
	КомпоновщикОтбора.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемыКомпоновкиДанных));
	КомпоновщикОтбора.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИнтервалЗавершение(Период, ДополнительныеПараметры) Экспорт
	
	Если Не Период = Неопределено Тогда
		Объект.ДатаНач = Период.ДатаНачала;
		Объект.ДатаКон = Период.ДатаОкончания;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗагрузкуЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.ОК Тогда
		Состояние("Идет загрузка данных в регистр сведений");
		ЗагрузкаРегистраМестонахождениеGPS();
		Состояние("Загрузка данных в регистр сведений завершена");
		Элементы.ИнфНадписьЗагрузкаЗавершена.Заголовок = "загрузка данных завершена успешно";
		Элементы.ИнфНадписьЗагрузкаЗавершена.ЦветТекста = Новый Цвет(25,85,174);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьФОЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.ОК Тогда
		ПоказатьОповещениеПользователя("Идет чтение данных из файла обмена",,"Операция может занять длительное время");
		
		НачатьПомещениеФайла(
			Новый ОписаниеОповещения("ПрочитатьФОПослеПомещенияВХранилище", ЭтотОбъект),
			ХранилищеФайлаВыгрузки,
			Объект.ФайлОбмена,
			Истина,
			УникальныйИдентификатор);
		
	Иначе 
		Элементы.ИнфНадписьЗагрузкаЗавершена.Заголовок = "файл обмена не прочитан";
		Элементы.ИнфНадписьЗагрузкаЗавершена.ЦветТекста = Новый Цвет(255,0,0);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьФОПослеПомещенияВХранилище(Результат, Адрес, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт
	
	Если Результат = Ложь Тогда 
		Возврат;
	КонецЕсли;
	
	Объект.ФайлОбмена = ВыбранноеИмяФайла;
	
	ОбработкаПрерыванияПользователя();
	
	ХранилищеФайлаВыгрузки = Адрес;
	
	ТекстОшибки = "";
	ЗагрузитьФайлОбмена(ТекстОшибки);
	Если Не ТекстОшибки = "" Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		Элементы.ИнфНадписьЗагрузкаЗавершена.Заголовок = "ошибка чтения файла обмена";
		Элементы.ИнфНадписьЗагрузкаЗавершена.ЦветТекста = Новый Цвет(255,0,0);
	Иначе 
		ПоказатьОповещениеПользователя("Чтение файла обмена завершено");
		Элементы.ИнфНадписьЗагрузкаЗавершена.Заголовок = "файл обмена прочитан";
		Элементы.ИнфНадписьЗагрузкаЗавершена.ЦветТекста = Новый Цвет(25,85,174);
	КонецЕсли;
	УдалитьИзВременногоХранилища(ХранилищеФайлаВыгрузки);
	
КонецПроцедуры

&НаКлиенте
Процедура СброситьПоляЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.ОК Тогда
		СброситьНастройкиПолейФайлаОбмена();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
