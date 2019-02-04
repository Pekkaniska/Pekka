#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Записывает результаты планирования графика производства в регистр.
//
// Параметры:
//  Распоряжение - ДокументСсылка.ЗаказНаПроизводство2_2 - запланированный заказ.
//  СтатусГрафика - Число - статус графика производства.
//  ЗагрузкаВРЦ	- ТаблицаЗначений - данные для записи в регистр.
//
Процедура ЗаписатьРезультатыПланирования(Распоряжение, СтатусГрафика, ЗагрузкаВРЦ) Экспорт
	
	НачатьТранзакцию();
	
	Попытка
		
		Набор = РегистрыСведений.ПланированиеЗагрузкиВидовРабочихЦентров.СоздатьНаборЗаписей();
		
		Набор.Отбор.Распоряжение.Установить(Распоряжение);
		Набор.Отбор.СтатусГрафика.Установить(СтатусГрафика);
		
		Для каждого Строка Из ЗагрузкаВРЦ Цикл
			
			Запись = Набор.Добавить();
			ЗаполнитьЗначенияСвойств(Запись, Строка);
			Запись.Распоряжение = Распоряжение;
			Запись.СтатусГрафика = СтатусГрафика;
			
		КонецЦикла;
		
		Набор.Записать();
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ИмяСобытия = НСтр("ru = 'Запись результатов планирования загрузки видов рабочих центров'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
		ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
  		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

// Переводит данные графика из предварительного статуса в рабочий.
// Вместе с записью рабочего графика происходит очистка данных предварительного графика и модели.
//
// Параметры:
//  Распоряжение - ДокументСсылка.ЗаказНаПроизводство2_2 - заказ, данные которого необходимо записать.
//  Этапы - Массив - этапы производства, данные которых необходимо записать.
//
Процедура ЗаписатьПредварительныйГрафикВРабочий(Распоряжение, Этапы) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ПланированиеЗагрузкиВидовРабочихЦентров.ЭтапПроизводства,
	|	ПланированиеЗагрузкиВидовРабочихЦентров.ВидРабочегоЦентра,
	|	ПланированиеЗагрузкиВидовРабочихЦентров.ДатаИнтервала,
	|	ПланированиеЗагрузкиВидовРабочихЦентров.Занято
	|ИЗ
	|	РегистрСведений.ПланированиеЗагрузкиВидовРабочихЦентров КАК ПланированиеЗагрузкиВидовРабочихЦентров
	|ГДЕ
	|	ПланированиеЗагрузкиВидовРабочихЦентров.Распоряжение = &Распоряжение
	|	И ПланированиеЗагрузкиВидовРабочихЦентров.СтатусГрафика = &СтатусПредварительныйГрафик");
	
	Запрос.УстановитьПараметр("Распоряжение", Распоряжение);
	Запрос.УстановитьПараметр("СтатусПредварительныйГрафик",
		РегистрыСведений.ГрафикЭтаповПроизводства2_2.СтатусПредварительныйГрафик());
	
	ГрафикПроизводства = Запрос.Выполнить().Выгрузить();
	
	РегистрыНакопления.ДоступностьВидовРабочихЦентров.ЗаписатьЗанятоГрафикомПроизводства(
		Этапы,
		ГрафикПроизводства);
	
	ОчиститьПредварительныйГрафик(Распоряжение);
	
КонецПроцедуры

// Очищает график заданного распоряжения.
//
// Параметры:
//  Распоряжение - ДокументСсылка.ЗаказНаПроизводство2_2 - распоряжение, график которого необходимо очистить.
//
Процедура ОчиститьПредварительныйГрафик(Распоряжение) Экспорт
	
	НачатьТранзакцию();
	
	Попытка
		
		Набор = РегистрыСведений.ПланированиеЗагрузкиВидовРабочихЦентров.СоздатьНаборЗаписей();
		Набор.Отбор.Распоряжение.Установить(Распоряжение);
		Набор.Записать();
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ИмяСобытия = НСтр("ru = 'Очистка предварительного графика'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
		ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
  		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли