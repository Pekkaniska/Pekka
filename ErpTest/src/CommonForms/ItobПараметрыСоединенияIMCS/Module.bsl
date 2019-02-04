
#Область ОбработчикиСобытийФормы

// Процедура - обработчик открытия формы
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	СтруктураСтрокаСоединенияБазаIMCS = ПолучитьКонстантуItobСтрокаСоединенияБазаIMCS();
	Если ТипЗнч(СтруктураСтрокаСоединенияБазаIMCS) = Тип("Структура") Тогда
		ЭтотОбъект.АутентификацияОперационнойСистемы = СтруктураСтрокаСоединенияБазаIMCS.АутентификацияОперационнойСистемы;
		ЭтотОбъект.АутентификацияСтандартная 		 = СтруктураСтрокаСоединенияБазаIMCS.АутентификацияСтандартная;
		ЭтотОбъект.ТипСУБД 			= СтруктураСтрокаСоединенияБазаIMCS.ТипСУБД;
		ЭтотОбъект.СтрокаСоединения	= СтруктураСтрокаСоединенияБазаIMCS.СтрокаСоединения;
		ЭтотОбъект.Сервер 			= СтруктураСтрокаСоединенияБазаIMCS.Сервер;
		ЭтотОбъект.Порт 			= СтруктураСтрокаСоединенияБазаIMCS.Порт;
		ЭтотОбъект.ПарольУстановлен	= СтруктураСтрокаСоединенияБазаIMCS.ПарольУстановлен;
		ЭтотОбъект.ИмяПользователя 	= СтруктураСтрокаСоединенияБазаIMCS.ИмяПользователя;
		ЭтотОбъект.Пароль 			= СтруктураСтрокаСоединенияБазаIMCS.Пароль;
		ЭтотОбъект.ИмяБазы 			= СтруктураСтрокаСоединенияБазаIMCS.ИмяБазы;
	КонецЕсли;
	
	Элементы.ГруппаИмяПароль.Видимость = ПарольУстановлен; 
КонецПроцедуры

#КонецОбласти
 
#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик выбора типа СУБД
//
&НаКлиенте
Процедура ТипСУБДОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	СтрокаСоединения = ПолучитьСтрокуСоединения(ВыбранноеЗначение); 
КонецПроцедуры

// Процедура - обработчик изменения аутентификации
//
&НаКлиенте
Процедура ПарольУстановленПриИзменении(Элемент)
	Элементы.ГруппаИмяПароль.Видимость = ПарольУстановлен;
КонецПроцедуры

#КонецОбласти
 
#Область ОбработчикиКомандФормы

// Процедура - обработчик записи значения в константу ItobСтрокаСоединенияБазаIMCS
//
&НаКлиенте
Процедура Записать(Команда)
	СтруктураСтрокаСоединенияБазаIMCS = Новый Структура;
	СтруктураСтрокаСоединенияБазаIMCS.Вставить("АутентификацияОперационнойСистемы", ЭтотОбъект.АутентификацияОперационнойСистемы);
	СтруктураСтрокаСоединенияБазаIMCS.Вставить("АутентификацияСтандартная", ЭтотОбъект.АутентификацияСтандартная);
	СтруктураСтрокаСоединенияБазаIMCS.Вставить("СтрокаСоединения", ЭтотОбъект.СтрокаСоединения);
	СтруктураСтрокаСоединенияБазаIMCS.Вставить("ТипСУБД", ЭтотОбъект.ТипСУБД);
	СтруктураСтрокаСоединенияБазаIMCS.Вставить("Порт", ЭтотОбъект.Порт);
	СтруктураСтрокаСоединенияБазаIMCS.Вставить("Сервер", ЭтотОбъект.Сервер);
	СтруктураСтрокаСоединенияБазаIMCS.Вставить("ПарольУстановлен", ЭтотОбъект.ПарольУстановлен);
	СтруктураСтрокаСоединенияБазаIMCS.Вставить("ИмяПользователя", ЭтотОбъект.ИмяПользователя);
	СтруктураСтрокаСоединенияБазаIMCS.Вставить("Пароль", ЭтотОбъект.Пароль);
	СтруктураСтрокаСоединенияБазаIMCS.Вставить("ИмяБазы", ЭтотОбъект.ИмяБазы);
	ЗаписатьКонстантуItobСтрокаСоединенияБазаIMCS(СтруктураСтрокаСоединенияБазаIMCS);
	ЭтотОбъект.Закрыть();
КонецПроцедуры

// Процедура - обработчик закрытия формы
//
&НаКлиенте
Процедура Отмена(Команда)
	ЭтотОбъект.Закрыть();
КонецПроцедуры

#КонецОбласти
 
#Область СлужебныеПроцедурыИФункции

// Функция записи значений в константу ItobСтрокаСоединенияБазаIMCS
//
&НаСервере
Процедура ЗаписатьКонстантуItobСтрокаСоединенияБазаIMCS(Значение)
	Константы.ItobСтрокаСоединенияБазаIMCS.Установить(Новый ХранилищеЗначения(Значение));
КонецПроцедуры

// Функция получения значений с константы ItobСтрокаСоединенияБазаIMCS
//
&НаСервере
Функция ПолучитьКонстантуItobСтрокаСоединенияБазаIMCS()
	Возврат Константы.ItobСтрокаСоединенияБазаIMCS.Получить().Получить();
КонецФункции

// Функция получения строки соединения
//
&НаСервере
Функция ПолучитьСтрокуСоединения(Значение)
	Если Значение = Перечисления.itobТипыСУБД.MS_SQL_Server Тогда
		Возврат "DRIVER={SQL Server}";
	ИначеЕсли Значение = Перечисления.itobТипыСУБД.PostgreSQL  Тогда
		Возврат "Driver={PostgreSQL}";
	КонецЕсли; 
КонецФункции

#КонецОбласти
