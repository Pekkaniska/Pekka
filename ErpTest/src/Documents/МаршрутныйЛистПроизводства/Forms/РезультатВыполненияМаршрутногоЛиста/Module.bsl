#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Запланировано = Параметры.Запланировано;
	Произведено = Параметры.Произведено;
	Брак = Параметры.Брак;
	ОписаниеБрака = Параметры.ОписаниеБрака;
	
	ПроизведеноДоРедактирования = Параметры.ПроизведеноДоРедактирования;
	
	ПересчетФакта = 2;
	
	УправлениеДоступностью(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если Брак = 0 Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ОписаниеБрака");
	КонецЕсли; 
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПроизведеноПриИзменении(Элемент)
	
	УправлениеДоступностью(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура БракПриИзменении(Элемент)

	Если Брак = 0 И ЗначениеЗаполнено(ОписаниеБрака) Тогда
		ОписаниеБрака = "";
	КонецЕсли;
	
	УправлениеДоступностью(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура БракАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	
	Если Текст = "" Тогда
		Возврат;
	КонецЕсли; 
	
	Брак = ?(ПустаяСтрока(Текст), 0, Число(Текст));
	УправлениеДоступностью(ЭтаФорма,, Число(Текст));
	
КонецПроцедуры

&НаКлиенте
Процедура ПроизведеноАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	
	Если Текст = "" Тогда
		Возврат;
	КонецЕсли; 
	
	Произведено = ?(ПустаяСтрока(Текст), 0, Число(Текст));
	УправлениеДоступностью(ЭтаФорма, Число(Текст));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	ЗавершитьВвод();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеДоступностью(Форма, Знач Произведено = Неопределено, Знач Брак = Неопределено)

	Если Произведено = Неопределено Тогда
		Произведено = Форма.Произведено;
	КонецЕсли; 
	Если Брак = Неопределено Тогда
		Брак = Форма.Брак;
	КонецЕсли; 
	
	Форма.Элементы.ОписаниеБрака.Доступность = (Брак <> 0);

	// Возможность пересчитать с учетом брака
	Если Брак <> 0 Тогда
		
		Форма.Элементы.ПересчетСУчетомБрака.Видимость = Истина;
		
		ПересчетСУчетомБрака = Форма.Элементы.ПересчетСУчетомБрака.СписокВыбора[0];
		ПересчетСУчетомБрака.Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Пересчитать с учетом брака на %1 единиц/партий изделий (будут отклонения от нормативов)'"),
				Произведено + Брак);
		
	Иначе
		
		Форма.Элементы.ПересчетСУчетомБрака.Видимость = Ложь;
		
	КонецЕсли; 		
				
	// Возможность оставить прежним
	БезПересчета = Форма.Элементы.БезПересчета.СписокВыбора[0];
	Если Произведено <> Форма.ПроизведеноДоРедактирования Тогда
		БезПересчета.Представление = НСтр("ru = 'Оставить прежним (будут отклонения от нормативов)'");
	Иначе
		БезПересчета.Представление = НСтр("ru = 'Оставить прежним'");
	КонецЕсли;
	
	// Возможность пересчитать без учета брака
	ПересчетБезУчетаБрака = Форма.Элементы.ПересчетБезУчетаБрака.СписокВыбора[0];
	Если Брак <> 0 Тогда
		
		ПересчетБезУчетаБрака.Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Пересчитать без учета брака на %1 единиц/партий изделий (отклонений от нормативов не будет)'"),
				Произведено);
	Иначе

		ПересчетБезУчетаБрака.Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Пересчитать на %1 единиц/партий изделий (отклонений от нормативов не будет)'"),
				Произведено);
		
	КонецЕсли; 
	
	Если Форма.ПересчетФакта = 2 И НЕ Форма.Элементы.ПересчетБезУчетаБрака.Видимость Тогда
		Форма.ПересчетФакта = 1;
	КонецЕсли; 
	
	Если Форма.ПересчетФакта = 1 И НЕ Форма.Элементы.ПересчетСУчетомБрака.Видимость Тогда
		Форма.ПересчетФакта = 0;
	КонецЕсли; 
	
	Форма.Элементы.ПояснениеПересчетНормативов.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Нормативное количество будет пересчитано на %1 единиц/партий изделий.'"),
				Произведено);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьВвод()

	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Модифицированность = Ложь;

	РезультатВвода = Новый Структура;
	РезультатВвода.Вставить("Произведено", Произведено);
	РезультатВвода.Вставить("Брак", Брак);
	РезультатВвода.Вставить("ОписаниеБрака", ОписаниеБрака);
	РезультатВвода.Вставить("ПересчетФакта", ПересчетФакта);
	
	Закрыть(РезультатВвода);
	
КонецПроцедуры


#КонецОбласти
