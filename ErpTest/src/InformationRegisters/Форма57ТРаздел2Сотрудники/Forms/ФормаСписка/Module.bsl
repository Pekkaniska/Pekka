
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Параметры.Отбор.Свойство("Организация", Организация);
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		ЗначенияДляЗаполнения = Новый Структура("Организация", "Организация");
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
		
		Если Не ЗначениеЗаполнено(Организация) Тогда
			Организация = ЗарплатаКадры.ПерваяДоступнаяОрганизация();
		КонецЕсли;
	КонецЕсли;
	
	Параметры.Свойство("ПериодОтчета", ПериодОтчета);
	
	Если Не ЗначениеЗаполнено(ПериодОтчета) Тогда
		
		ГодОтчета = Год(ТекущаяДатаСеанса());
		Если Цел(ГодОтчета / 2) = ГодОтчета / 2 Тогда
			ГодОтчета = ГодОтчета + 1;
		КонецЕсли;
		
		ПериодОтчета = Дата(ГодОтчета, 10, 1);
		
	КонецЕсли;
	
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтотОбъект, "ПериодОтчета", "ПериодОтчетаСтрокой");
	
	УстановитьОтборСписка(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	ДобавитьВыбранныхСотрудников(ВыбранноеЗначение);
	Элементы.Список.Обновить();
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	УстановитьОтборСписка(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодОтчетаСтрокойПриИзменении(Элемент)
	
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтотОбъект, "ПериодОтчета", "ПериодОтчетаСтрокой", Модифицированность);
	УстановитьОтборСписка(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодОтчетаСтрокойНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ПериодОтчетаСтрокойНачалоВыбораЗавершение", ЭтотОбъект);
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтотОбъект, ЭтотОбъект, "ПериодОтчета", "ПериодОтчетаСтрокой", , Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодОтчетаСтрокойРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтотОбъект, "ПериодОтчета", "ПериодОтчетаСтрокой", Направление, Модифицированность);
	УстановитьОтборСписка(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодОтчетаСтрокойАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодОтчетаСтрокойОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	КадровыйУчетКлиент.ВыбратьСотрудниковРаботающихНаДатуПоПараметрамОткрытияФормыСписка(
		ЭтотОбъект,
		Организация,
		,
		ПериодОтчета,
		Истина,
		АдресСпискаПодобранныхСотрудников(Организация, ПериодОтчета, УникальныйИдентификатор));
	
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьАвтоматически(Команда)
	
	ЗаполнитьАвтоматическиНаСервере();
	Элементы.Список.Обновить();
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборСписка(Форма)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Форма.Список, "Организация", Форма.Организация);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Форма.Список, "ПериодОтчета", Форма.ПериодОтчета);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодОтчетаСтрокойНачалоВыбораЗавершение(Результат = Истина, Параметр = Неопределено) Экспорт
	
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтотОбъект, "ПериодОтчета", "ПериодОтчетаСтрокой");
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция АдресСпискаПодобранныхСотрудников(Организация, ПериодОтчета, УникальныйИдентификатор)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ПериодОтчета", ПериодОтчета);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Форма57ТРаздел2Сотрудники.Сотрудник КАК Сотрудник
		|ИЗ
		|	РегистрСведений.Форма57ТРаздел2Сотрудники КАК Форма57ТРаздел2Сотрудники
		|ГДЕ
		|	Форма57ТРаздел2Сотрудники.Организация = &Организация
		|	И Форма57ТРаздел2Сотрудники.ПериодОтчета = &ПериодОтчета";
	
	Возврат ПоместитьВоВременноеХранилище(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Сотрудник"), УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Процедура ДобавитьВыбранныхСотрудников(ВыбранныеСотрудники)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ПериодОтчета", ПериодОтчета);
	Запрос.УстановитьПараметр("Сотрудники", ВыбранныеСотрудники);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Сотрудники.Ссылка КАК Сотрудник
		|ИЗ
		|	Справочник.Сотрудники КАК Сотрудники
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Форма57ТРаздел2Сотрудники КАК Форма57ТРаздел2Сотрудники
		|		ПО Сотрудники.Ссылка = Форма57ТРаздел2Сотрудники.Сотрудник
		|			И (Форма57ТРаздел2Сотрудники.Организация = &Организация)
		|			И (Форма57ТРаздел2Сотрудники.ПериодОтчета = &ПериодОтчета)
		|ГДЕ
		|	Сотрудники.Ссылка В(&Сотрудники)
		|	И Форма57ТРаздел2Сотрудники.Сотрудник ЕСТЬ NULL";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		
		ВыборкаСотрудников = РезультатЗапроса.Выбрать();
		
		Запрос.Текст =
			"ВЫБРАТЬ
			|	ЕСТЬNULL(МАКСИМУМ(Форма57ТРаздел2Сотрудники.НомерСтрокиОтчета), 0) КАК НомерСтрокиОтчета
			|ИЗ
			|	РегистрСведений.Форма57ТРаздел2Сотрудники КАК Форма57ТРаздел2Сотрудники
			|ГДЕ
			|	Форма57ТРаздел2Сотрудники.Организация = &Организация
			|	И Форма57ТРаздел2Сотрудники.ПериодОтчета = &ПериодОтчета";
		
		Выборка = Запрос.Выполнить().Выбрать();
		Выборка.Следующий();
		
		НомерПоследнейСтроки = Выборка.НомерСтрокиОтчета;
		
		Пока ВыборкаСотрудников.Следующий() Цикл
			
			НомерПоследнейСтроки = НомерПоследнейСтроки + 1;
			
			НаборЗаписей = РегистрыСведений.Форма57ТРаздел2Сотрудники.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Организация.Установить(Организация);
			НаборЗаписей.Отбор.ПериодОтчета.Установить(ПериодОтчета);
			
			НаборЗаписей.Прочитать();
			
			Запись = НаборЗаписей.Добавить();
			Запись.Организация = Организация;
			Запись.ПериодОтчета = ПериодОтчета;
			Запись.Сотрудник = ВыборкаСотрудников.Сотрудник;
			Запись.НомерСтрокиОтчета = НомерПоследнейСтроки;
			
			НаборЗаписей.Записать();
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьАвтоматическиНаСервере()
	
	СтатистикаПерсоналаРасширенный.ЗаполнитьСотрудниковРаздела2Формы57Т(Организация, ПериодОтчета);
	
КонецПроцедуры

#КонецОбласти
