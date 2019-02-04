#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Организация = Параметры.Организация;
	Подразделение = Параметры.Подразделение;
	СтатьяРасходов = Параметры.СтатьяРасходов;
	Период.ДатаОкончания = Параметры.ДатаОкончания;
	
	ЗаполнитьТаблицуСчетовУчетаРасходов();
	
	Элементы.ФормаСохранитьНастройку.Доступность = Ложь;
	
КонецПроцедуры // ПриСозданииНаСервере()

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ПоказыватьОтраженныеВУчете = Настройки.Получить("ПоказыватьОтраженныеВУчете");
	Если ПоказыватьОтраженныеВУчете Тогда
		ЗаполнитьТаблицуСчетовУчетаРасходов();
	КонецЕсли;
	
КонецПроцедуры // ПриЗагрузкеДанныхИзНастроекНаСервере()

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность И ЗавершениеРаботы Тогда
		Отказ = Истина;
		ТекстПредупреждения = 
		НСтр("ru = 'Настройки счетов были изменены, но не сохранены. Для того, чтобы изменения вступили в силу следует сохранить настройку.'");
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		
		ТекстВопроса = НСтр("ru = 'Настройки счетов были изменены. Сохранить изменения?'");
		Ответ = Неопределено;

		ПоказатьВопрос(Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект), ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ИзмененыНастройкиОтраженияВУчете И Не ЗавершениеРаботы Тогда
		Оповестить("ИзмененыНастройкиОтраженияВУчете");
	КонецЕсли;
	
КонецПроцедуры // ПриЗакрытии()

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбновитьСчетаУчетаРасходов(Команда)
	
	ЗаполнитьТаблицуСчетовУчетаРасходов();
	
КонецПроцедуры // ОбновитьСчетаУчетаРасходов()

&НаКлиенте
Процедура СохранитьНастройку(Команда)
	
	СохранитьСчетаУчетаРасходов();
	УправлениеЭлементамиФормы();
	
КонецПроцедуры // СохранитьНастройку()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПериодВариантПриИзменении(Элемент)
	
	ЗаполнитьТаблицуСчетовУчетаРасходов();
	
КонецПроцедуры // ПериодВариантПриИзменении()

&НаКлиенте
Процедура ПериодДатаНачалаПриИзменении(Элемент)
	
	ЗаполнитьТаблицуСчетовУчетаРасходов();
	
КонецПроцедуры // ПериодДатаНачалаПриИзменении()

&НаКлиенте
Процедура ПериодДатаОкончанияПриИзменении(Элемент)
	
	ЗаполнитьТаблицуСчетовУчетаРасходов();
	
КонецПроцедуры // ПериодДатаОкончанияПриИзменении()

&НаКлиенте
Процедура ПоказыватьОтраженныеВУчетеПриИзменении(Элемент)
	
	ЗаполнитьТаблицуСчетовУчетаРасходов();
	
КонецПроцедуры // ПоказыватьОтраженныеВУчетеПриИзменении()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСчетаУчетаРасходов

&НаКлиенте
Процедура СчетаУчетаРасходовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтрокаТаблицы = Элемент.ТекущиеДанные;
	Если Поле = Элементы.СчетаУчетаРасходовНомер
	 ИЛИ Поле = Элементы.СчетаУчетаРасходовДата
	 ИЛИ Поле = Элементы.СчетаУчетаРасходовТип Тогда
		ПоказатьЗначение(Неопределено, СтрокаТаблицы.Документ);
	КонецЕсли;
	
КонецПроцедуры // СчетаУчетаРасходовВыбор()

&НаКлиенте
Процедура СчетаУчетаРасходовПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	СтрокаТаблицы = Элемент.ТекущиеДанные;
	СтрокаТаблицы.ДанныеИзменены = Истина;
	УправлениеЭлементамиФормы();
	
КонецПроцедуры // СчетаУчетаРасходовПриОкончанииРедактирования()

&НаКлиенте
Процедура СчетаУчетаРасходовСчетУчетаПриИзменении(Элемент)
	
	СтрокаТаблицы = Элементы.СчетаУчетаРасходов.ТекущиеДанные;
	СтрокаТаблицы.СчетУчетаНУ = СтрокаТаблицы.СчетУчета;
	
КонецПроцедуры // СчетаУчетаРасходовСчетУчетаПриИзменении()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура заполняет таблицу настройки счетов учета расходов.
//
&НаСервере
Процедура ЗаполнитьТаблицуСчетовУчетаРасходов()
	
	МассивОрганизаций = Новый Массив;
	МассивОрганизаций.Добавить(Организация);
	
	СчетаУчетаРасходов.Очистить();
	
	РезультатЗапроса = РегистрыСведений.ПорядокОтраженияРасходов.РезультатЗапросаПоНастройкамОтраженияВУчетеДетально(
		Организация,
		Подразделение,
		СтатьяРасходов,
		Период.ДатаНачала,
		Период.ДатаОкончания,
		ПоказыватьОтраженныеВУчете);
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = СчетаУчетаРасходов.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		
	КонецЦикла;
	
КонецПроцедуры // ЗаполнитьТаблицуСчетовУчетаРасходов()

// В процедуре выполняется установка свойств элементов формы.
//
&НаКлиенте
Процедура УправлениеЭлементамиФормы()
	
	Элементы.ФормаСохранитьНастройку.Доступность = Модифицированность;
	
КонецПроцедуры // УправлениеЭлементамиФормы()

// Процедура производит сохранение счетов учета расходов.
//
&НаСервере
Процедура СохранитьСчетаУчетаРасходов()
	
	МассивСтрок = СчетаУчетаРасходов.НайтиСтроки(Новый Структура("ДанныеИзменены", Истина));
	
	Для Каждого СтрокаТаблицы Из МассивСтрок Цикл
		
		СтрокаТаблицы.ДанныеИзменены = Ложь;
		
		МенеджерЗаписи = РегистрыСведений.ПорядокОтраженияРасходов.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(МенеджерЗаписи, СтрокаТаблицы);
		
		МенеджерЗаписи.Организация = Организация;
		МенеджерЗаписи.Подразделение = Подразделение;
		МенеджерЗаписи.СтатьяРасходов = СтатьяРасходов;
		МенеджерЗаписи.СпособНастройкиСчетовУчета = Неопределено;
		
		МенеджерЗаписи.Записать(Истина);
		
	КонецЦикла;
	
	Модифицированность = Ложь;
	
КонецПроцедуры // СохранитьСчетаУчетаРасходов()

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Ответ = РезультатВопроса;
    Если Ответ = КодВозвратаДиалога.Да Тогда
        СохранитьСчетаУчетаРасходов();
    КонецЕсли;

КонецПроцедуры // ПередЗакрытием()

#КонецОбласти