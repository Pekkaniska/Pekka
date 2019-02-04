
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Данные = Неопределено;
	ПараметрыЗаполнения = Неопределено;
	Параметры.Свойство("Данные", Данные);
	Параметры.Свойство("ПараметрыЗаполнения", ПараметрыЗаполнения);
	
	Объект.ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаР13001;
	УведомлениеОСпецрежимахНалогообложения.НачальныеОперацииПриСозданииНаСервере(ЭтотОбъект);
	УведомлениеОСпецрежимахНалогообложения.СформироватьСпискиВыбора(ЭтотОбъект, "СпискиВыбора2014_1");
	
	Если ТипЗнч(Данные) = Тип("Структура") Тогда
		СформироватьДеревоСтраниц();
		УведомлениеОСпецрежимахНалогообложения.СформироватьСтруктуруДанныхУведомления(ЭтотОбъект, Истина);
		УведомлениеОСпецрежимахНалогообложения.ЗагрузитьДанныеПростогоУведомления(ЭтотОбъект, Данные, ПредставлениеУведомления)
	ИначеЕсли Параметры.Свойство("Ключ") И ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.Организация = Параметры.Ключ.Организация;
		ЗагрузитьДанные(Параметры.Ключ);
	ИначеЕсли Параметры.Свойство("ЗначениеКопирования") И ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
		Объект.Организация = Параметры.ЗначениеКопирования.Организация;
		ЗагрузитьДанные(Параметры.ЗначениеКопирования);
	Иначе
		Параметры.Свойство("Организация", Объект.Организация);
		СформироватьДеревоСтраниц();
		
		ВходящийКонтейнер = Новый Структура("ИмяФормы, ДеревоСтраниц", ИмяФормы, РеквизитФормыВЗначение("ДеревоСтраниц"));
		РезультатКонтейнер = Новый Структура;
		УведомлениеОСпецрежимахНалогообложения.СформироватьКонтейнерДанныхУведомления(ВходящийКонтейнер, РезультатКонтейнер, Истина);
		Для Каждого КЗ Из РезультатКонтейнер Цикл 
			ЭтаФорма[КЗ.Ключ] = КЗ.Значение;
		КонецЦикла;
		
		РезультатКонтейнер.Очистить();
		УведомлениеОСпецрежимахНалогообложения.НачальныеОперацииСКонтейнеромМногострочныхБлоков(ВходящийКонтейнер, РезультатКонтейнер);
		Для Каждого КЗ Из РезультатКонтейнер Цикл 
			ЗначениеВРеквизитФормы(КЗ.Значение, КЗ.Ключ);
		КонецЦикла;
	КонецЕсли;
	
	Если Параметры.СформироватьФормуОтчетаАвтоматически Тогда 
		ЗаполнитьАвтоНаСервере(ПараметрыЗаполнения);
	КонецЕсли;
	
	Если Параметры.СформироватьПечатнуюФорму Тогда
		Модифицированность = Истина;
		СохранитьДанные();
		Отказ = Истина;
		Если ЗначениеЗаполнено(Объект.Ссылка) Тогда 
			РазблокироватьДанныеДляРедактирования(Объект.Ссылка, УникальныйИдентификатор);
		КонецЕсли;
		
		Возврат;
	КонецЕсли;
	
	УведомлениеОСпецрежимахНалогообложения.ЗаполнитьТаблицуФорматов(ЭтотОбъект, "Форматы2014_1");
	ИдДляСвор = УведомлениеОСпецрежимахНалогообложения.ПолучитьИдентификаторыДляСворачивания(ЭтотОбъект);
	СворачиваемыеЭлементы = ПоместитьВоВременноеХранилище(ИдДляСвор);
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда 
		СохраненныеДанныеУведомления = Объект.Ссылка.ДанныеУведомления.Получить();
		УведомлениеЗаполненоВПомощнике = СохраненныеДанныеУведомления.Свойство("ДанныеПомощникаЗаполнения") 
			И ТипЗнч(СохраненныеДанныеУведомления.ДанныеПомощникаЗаполнения) = Тип("Структура")
			И ЗначениеЗаполнено(СохраненныеДанныеУведомления.ДанныеПомощникаЗаполнения);
	Иначе
		УведомлениеЗаполненоВПомощнике = Ложь;
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УведомлениеОСпецрежимахНалогообложенияКлиент.ПриОткрытии(ЭтотОбъект, Отказ);
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		ПриЗакрытииНаСервере();
	КонецЕсли;
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения",,Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	РегламентированнаяОтчетностьКлиент.ПередЗакрытиемРегламентированногоОтчета(ЭтаФорма, Отказ, СтандартнаяОбработка, ЗавершениеРаботы, ТекстПредупреждения);
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура Очистить(Команда)
	УведомлениеОСпецрежимахНалогообложенияКлиент.ОчиститьУведомление(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ОчисткаОтчета() Экспорт
	СформироватьДеревоСтраниц();
	
	ВходящийКонтейнер = Новый Структура("ИмяФормы, ДеревоСтраниц", ИмяФормы, РеквизитФормыВЗначение("ДеревоСтраниц"));
	РезультатКонтейнер = Новый Структура;
	УведомлениеОСпецрежимахНалогообложения.СформироватьКонтейнерДанныхУведомления(ВходящийКонтейнер, РезультатКонтейнер, Истина);
	Для Каждого КЗ Из РезультатКонтейнер Цикл 
		ЭтаФорма[КЗ.Ключ] = КЗ.Значение;
	КонецЦикла;
	
	РезультатКонтейнер.Очистить();
	УведомлениеОСпецрежимахНалогообложения.НачальныеОперацииСКонтейнеромМногострочныхБлоков(ВходящийКонтейнер, РезультатКонтейнер);
	Для Каждого КЗ Из РезультатКонтейнер Цикл 
		ЗначениеВРеквизитФормы(КЗ.Значение, КЗ.Ключ);
	КонецЦикла;
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ИДОтчета(Знач ЭтаФормаИмя)
	
	Если СтрЧислоВхождений(ЭтаФормаИмя, "ВнешнийОтчет.") > 0 Тогда
		ЭтаФормаИмя = СтрЗаменить(ЭтаФормаИмя, "ВнешнийОтчет.", "");
	ИначеЕсли СтрЧислоВхождений(ЭтаФормаИмя, "Отчет.") > 0 Тогда
		ЭтаФормаИмя = СтрЗаменить(ЭтаФормаИмя, "Отчет.", "");
	КонецЕсли;
	ЭтаФормаИмя = Лев(ЭтаФормаИмя, СтрНайти(ЭтаФормаИмя, ".Форма.") - 1);
	
	Возврат ЭтаФормаИмя;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьАвтоНаСервере(ПараметрыЗаполнения = Неопределено)
	ПараметрыОтчета = Новый Структура();
	ПараметрыОтчета.Вставить("Организация", 			     Объект.Организация);
	ПараметрыОтчета.Вставить("УникальныйИдентификаторФормы", ЭтаФорма.УникальныйИдентификатор);
	ПараметрыОтчета.Вставить("ПараметрыЗаполнения",          ПараметрыЗаполнения);
	
	ЭтаФормаИмя = ИДОтчета(ЭтаФорма.ИмяФормы);
	Контейнер = СформироватьКонтейнерДляАвтозаполнения();
	РегламентированнаяОтчетностьПереопределяемый.ЗаполнитьОтчет(ЭтаФормаИмя, Сред(ЭтаФорма.ИмяФормы, СтрНайти(ЭтаФорма.ИмяФормы, ".Форма.") + 7), ПараметрыОтчета, Контейнер);
	ЗагрузитьПодготовленныеДанные(Контейнер);
КонецПроцедуры

&НаСервере
Функция СформироватьКонтейнерДляАвтозаполнения()
	Контейнер = Новый Структура;
	Для Каждого КЗ Из ДанныеУведомления Цикл 
		Контейнер.Вставить(КЗ.Ключ, ОбщегоНазначенияКлиентСервер.СкопироватьРекурсивно(КЗ.Значение));
	КонецЦикла;
	
	Контейнер.Вставить("МногострочнаяЧасть1", РеквизитФормыВЗначение("МногострочнаяЧасть1"));
	Контейнер.Вставить("МногострочнаяЧасть2", РеквизитФормыВЗначение("МногострочнаяЧасть2"));
	
	СтруктураДерева = Новый Соответствие;
	Для Каждого КЗ Из ДанныеМногостраничныхРазделов Цикл 
		Для Каждого Стр Из КЗ.Значение Цикл 
			СтруктураДерева[Стр.Значение.УИД] = Новый Структура("Раздел, Данные", КЗ.Ключ, ОбщегоНазначенияКлиентСервер.СкопироватьРекурсивно(Стр.Значение));
		КонецЦикла;
	КонецЦикла;
	
	Для Каждого КЗ Из СтруктураДерева Цикл 
		Если КЗ.Значение.Данные.Свойство("УИДРодителя") Тогда 
			Родитель = СтруктураДерева[КЗ.Значение.Данные.УИДРодителя];
			Если Не Родитель.Данные.Свойство(КЗ.Значение.Раздел) Тогда 
				Родитель.Данные.Вставить(КЗ.Значение.Раздел, Новый СписокЗначений);
			КонецЕсли;
			Родитель.Данные[КЗ.Значение.Раздел].Добавить(КЗ.Значение.Данные);
		ИначеЕсли Не Контейнер.Свойство(КЗ.Значение.Раздел) Тогда 
			Контейнер.Вставить(КЗ.Значение.Раздел, Новый СписокЗначений);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого КЗ Из СтруктураДерева Цикл 
		КЗ.Значение.Данные.Удалить("УИД");
		КЗ.Значение.Данные.Удалить("УИДРодителя");
	КонецЦикла;
	
	Для Каждого КЗ Из СтруктураДерева Цикл 
		Если Контейнер.Свойство(КЗ.Значение.Раздел) Тогда 
			Контейнер[КЗ.Значение.Раздел].Добавить(КЗ.Значение.Данные);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Контейнер;
КонецФункции

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные(Контейнер)
	КУдалению = Новый Массив;
	Для Каждого КЗ Из ДанныеМногостраничныхРазделов Цикл
		КЗ.Значение.Очистить();
	КонецЦикла;
	
	Для Каждого КЗ Из Контейнер Цикл 
		Если ДанныеУведомления.Свойство(КЗ.Ключ) Тогда 
			ЗаполнитьЗначенияСвойств(ДанныеУведомления[КЗ.Ключ], КЗ.Значение);
		ИначеЕсли ДанныеМногостраничныхРазделов.Свойство(КЗ.Ключ) Тогда 
			Для Каждого Стр Из КЗ.Значение Цикл 
				ВставляемыеДанные = ОбщегоНазначенияКлиентСервер.СкопироватьРекурсивно(Стр.Значение);
				ВставляемыеДанные.Вставить("УИД", Новый УникальныйИдентификатор);
				ДанныеМногостраничныхРазделов[КЗ.Ключ].Добавить(ВставляемыеДанные);
				ДобавитьДочерниеСтраницы(ВставляемыеДанные);
				КУдалению.Добавить(КЗ.Ключ);
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Элт Из КУдалению Цикл
		ВставляемыеДанные.Удалить(Элт);
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(Контейнер.МногострочнаяЧасть1, "МногострочнаяЧасть1");
	ЗначениеВРеквизитФормы(Контейнер.МногострочнаяЧасть2, "МногострочнаяЧасть2");
	СформироватьДеревоСтраницПоДанным();
КонецПроцедуры

&НаСервере
Процедура ДобавитьДочерниеСтраницы(ВставляемыеДанные)
	КУдалению = Новый Массив;
	
	Для Каждого КЗ Из ВставляемыеДанные Цикл 
		Если ТипЗнч(КЗ.Значение) = Тип("СписокЗначений")
			И ДанныеМногостраничныхРазделов.Свойство(КЗ.Ключ) Тогда
			
			Для Каждого Стр Из КЗ.Значение Цикл
				ДочерниеВставляемыеДанные = ОбщегоНазначенияКлиентСервер.СкопироватьРекурсивно(Стр.Значение);
				ДочерниеВставляемыеДанные.Вставить("УИД", Новый УникальныйИдентификатор);
				ДочерниеВставляемыеДанные.Вставить("УИДРодителя", ВставляемыеДанные.УИД);
				ДанныеМногостраничныхРазделов[КЗ.Ключ].Добавить(ДочерниеВставляемыеДанные);
				ДобавитьДочерниеСтраницы(ДочерниеВставляемыеДанные);
				КУдалению.Добавить(КЗ.Ключ);
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Элт Из КУдалению Цикл
		ВставляемыеДанные.Удалить(Элт);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура СформироватьДеревоСтраницПоДанным()
	Разложение = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИмяФормы, ".");
	ДС = Неопределено;
	Отчеты[Разложение[1]].СформироватьДеревоСтраницПоДанным(ДС, ДанныеМногостраничныхРазделов);
	ЗначениеВРеквизитФормы(ДС, "ДеревоСтраниц");
КонецПроцедуры

&НаСервере
Процедура СформироватьДеревоСтраниц() Экспорт
	Разложение = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИмяФормы, ".");
	ДС = Отчеты[Разложение[1]].СформироватьДеревоСтраниц(Разложение[3]);
	ЗначениеВРеквизитФормы(ДС, "ДеревоСтраниц");
КонецПроцедуры

&НаКлиенте
Функция ПолучитьИмяВыводимогоМакета(ТекущиеДанные)
	Если ЗначениеЗаполнено(ТекущиеДанные.ИмяМакета) Тогда 
		Возврат ТекущиеДанные.ИмяМакета;
	Иначе
		Возврат ТекущиеДанные.ПолучитьЭлементы()[0].ИмяМакета;
	КонецЕсли;
КонецФункции

&НаКлиенте
Процедура ДеревоСтраницПриАктивизацииСтроки(Элемент)
	Если УИДТекущаяСтраница <> Элемент.ТекущиеДанные.УИД Тогда 
		УИДТекущаяСтраница = Элемент.ТекущиеДанные.УИД;
		ТекущееИДНаименования = Элемент.ТекущиеДанные.ИДНаименования;
		Если Не ЗначениеЗаполнено(ТекущееИДНаименования) Тогда 
			ТекущееИДНаименования = Элемент.ТекущиеДанные.ПолучитьЭлементы()[0].ИДНаименования;
			УИДТекущаяСтраница = Элемент.ТекущиеДанные.ПолучитьЭлементы()[0].УИД;
		КонецЕсли;
		
		Если Элемент.ТекущиеДанные.Многостраничность Тогда 
			ИмяМакета = ПолучитьИмяВыводимогоМакета(Элемент.ТекущиеДанные);
			ПоказатьТекущуюМногостраничнуюСтраницу(ИмяМакета);
		Иначе 
			ПоказатьТекущуюСтраницу(Элемент.ТекущиеДанные.ИмяМакета);
			
			Если Элемент.ТекущиеДанные.Многострочность Тогда
				Если ТекущееИДНаименования = "ЛистЛ1" Тогда 
					ВывестиМногострочнуюЧасть("МногострочнаяЧасть1");
				ИначеЕсли ТекущееИДНаименования = "ЛистЛ2" Тогда
					ВывестиМногострочнуюЧасть("МногострочнаяЧасть2");
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПоказатьТекущуюСтраницу(ИмяМакета)
	ПредставлениеУведомления.Очистить();
	ПредставлениеУведомления.Вывести(Отчеты[Объект.ИмяОтчета].ПолучитьМакет(ИмяМакета));
	УведомлениеОСпецрежимахНалогообложения.УстановитьФорматыВПолях(ЭтотОбъект);
	СтрДанных = ДанныеУведомления[ТекущееИДНаименования];
	Для Каждого Обл Из ПредставлениеУведомления.Области Цикл 
		Если Обл.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Прямоугольник
			И Обл.СодержитЗначение Тогда 
			
			СтрДанных.Свойство(Обл.Имя, Обл.Значение);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ПоказатьТекущуюМногостраничнуюСтраницу(ИмяМакета)
	ПредставлениеУведомления.Очистить();
	ПредставлениеУведомления.Вывести(Отчеты[Объект.ИмяОтчета].ПолучитьМакет(ИмяМакета));
	УведомлениеОСпецрежимахНалогообложения.УстановитьФорматыВПолях(ЭтотОбъект);
	СтрДанных = Неопределено;
	Для Каждого Элт Из ДанныеМногостраничныхРазделов[ТекущееИДНаименования] Цикл 
		Если Элт.Значение.УИД = УИДТекущаяСтраница Тогда 
			СтрДанных = Элт.Значение;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Обл Из ПредставлениеУведомления.Области Цикл 
		Если Обл.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Прямоугольник
			И Обл.СодержитЗначение Тогда 
			
			СтрДанных.Свойство(Обл.Имя, Обл.Значение);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеУведомленияПриИзмененииСодержимогоОбласти(Элемент, Область)
	УведомлениеОСпецрежимахНалогообложенияКлиент.ПриИзмененииСодержимогоОбласти(ЭтотОбъект, Область, Истина);
КонецПроцедуры

&НаСервере
Процедура СохранитьДанные() Экспорт
	Если ЗначениеЗаполнено(Объект.Ссылка) И Не Модифицированность Тогда 
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.Дата = ТекущаяДатаСеанса() 
	КонецЕсли;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ДанныеУведомления", ДанныеУведомления);
	СтруктураПараметров.Вставить("ДанныеМногостраничныхРазделов", ДанныеМногостраничныхРазделов);
	СтруктураПараметров.Вставить("ДанныеПомощникаЗаполнения", Новый Структура);
	СтруктураПараметров.Вставить("ДеревоСтраниц", РеквизитФормыВЗначение("ДеревоСтраниц"));
	СтруктураПараметров.Вставить("МногострочнаяЧасть1", РеквизитФормыВЗначение("МногострочнаяЧасть1"));
	СтруктураПараметров.Вставить("МногострочнаяЧасть2", РеквизитФормыВЗначение("МногострочнаяЧасть2"));
	
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.ДанныеУведомления = Новый ХранилищеЗначения(СтруктураПараметров);
	Документ.Записать();
	ЗначениеВДанныеФормы(Документ, Объект);
	
	РегламентированнаяОтчетность.СохранитьСтатусОтправкиУведомления(ЭтаФорма);
	
	Модифицированность = Ложь;
	ЭтотОбъект.Заголовок = СтрЗаменить(ЭтотОбъект.Заголовок, " (создание)", "");
	
	УведомлениеОСпецрежимахНалогообложения.СохранитьНастройкиРучногоВвода(ЭтотОбъект);
	УведомлениеЗаполненоВПомощнике = Ложь;
	УправлениеФормой(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	СохранитьНаКлиенте();
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения",,Объект.Ссылка);
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьДанные(СсылкаНаДанные)
	СтруктураПараметров = СсылкаНаДанные.Ссылка.ДанныеУведомления.Получить();
	ДанныеУведомления = СтруктураПараметров.ДанныеУведомления;
	ДанныеМногостраничныхРазделов = СтруктураПараметров.ДанныеМногостраничныхРазделов;
	МногострочнаяЧасть1.Загрузить(СтруктураПараметров.МногострочнаяЧасть1);
	МногострочнаяЧасть2.Загрузить(СтруктураПараметров.МногострочнаяЧасть2);
	ЗначениеВРеквизитФормы(СтруктураПараметров.ДеревоСтраниц, "ДеревоСтраниц");
КонецПроцедуры

&НаКлиенте
Функция ЭтоОбластьОКСМ(Область)
	Если (Область.Имя = "Д02020000" И ТекущееИДНаименования = "ЛистД")
		Или (Область.Имя = "Д03020100" И ТекущееИДНаименования = "ЛистД")
		Или (Область.Имя = "Е03060201" И ТекущееИДНаименования = "ЛистЕ")
		Или (Область.Имя = "К03020201" И ТекущееИДНаименования = "ЛистК")
		Или (Область.Имя = "К04020201" И ТекущееИДНаименования = "ЛистК")
		Или (Область.Имя = "Ж040203050201" И ТекущееИДНаименования = "ЛистЖ2_4")
		Или (Область.Имя = "М03050201" И ТекущееИДНаименования = "ЛистМ") Тогда
		
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
КонецФункции

&НаКлиенте
Процедура ПредставлениеУведомленияВыбор(Элемент, Область, СтандартнаяОбработка)
	Если СтрЧислоВхождений(Область.Имя, "ДобавитьСтроку") > 0 Тогда
		ДобавитьСтроку();
		СтандартнаяОбработка = Ложь;
		Модифицированность = Истина;
		Возврат;
	ИначеЕсли СтрЧислоВхождений(Область.Имя, "УдалитьСтроку") > 0 Тогда
		УдалитьСтроку(Область);
		СтандартнаяОбработка = Ложь;
		Модифицированность = Истина;
		Возврат;
	ИначеЕсли СтрЧислоВхождений(Область.Имя, "ДобавитьСтраницу") > 0 Тогда
		ДобавитьСтраницу(Неопределено);
		СтандартнаяОбработка = Ложь;
		Возврат;
	ИначеЕсли СтрЧислоВхождений(Область.Имя, "УдалитьСтраницу") > 0 Тогда
		УведомлениеОСпецрежимахНалогообложенияКлиент.УдалитьСтраницу(ЭтотОбъект);
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;
	
	Если РучнойВвод Тогда 
		Возврат;
	КонецЕсли;
	
	УведомлениеОСпецрежимахНалогообложенияКлиент.ПредставлениеУведомленияВыбор(ЭтотОбъект, Область, СтандартнаяОбработка, Истина);
	
	Если СтандартнаяОбработка Тогда 
		ОбработкаАдреса(Область, СтандартнаяОбработка);
	КонецЕсли;
	
	Если СтандартнаяОбработка Тогда
		Если (Область.Имя = "П02000000" И ТекущееИДНаименования = "Лист001") Тогда 
			СтандартнаяОбработка = Ложь;
			Область.Значение = ?(ЗначениеЗаполнено(Область.Значение), "", "V");
			УведомлениеОСпецрежимахНалогообложенияКлиент.ПриИзмененииСодержимогоОбласти(ЭтотОбъект, Область, Истина);
			Возврат;
		КонецЕсли;
		
		Если ЭтоОбластьОКСМ(Область) Тогда 
			СтандартнаяОбработка = Ложь;
			ДополнительныеПараметры = Новый Структура("Область, СтандартнаяОбработка, Элемент", Область, СтандартнаяОбработка, Элемент);
			ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьФормуВыбораСтраныЗавершение", ЭтотОбъект, ДополнительныеПараметры);
			ОткрытьФорму("Справочник.СтраныМира.ФормаВыбора", Новый Структура("РежимВыбора", Истина), ЭтотОбъект,,,,ОписаниеОповещения,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьСтраницу(Команда)
	ДобавитьСтраницуНаСервере();
КонецПроцедуры

&НаСервере
Процедура ДобавитьСтраницуНаСервере()
	НовИд = УведомлениеОСпецрежимахНалогообложения.ДобавитьСтраницуУведомления(ЭтотОбъект);
	Если НовИд <> Неопределено Тогда 
		Элементы.ДеревоСтраниц.ТекущаяСтрока = НовИд;
	КонецЕсли;
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура УдалитьСтраницу() Экспорт
	УдалитьСтраницуНаСервере();
КонецПроцедуры

&НаСервере
Процедура УдалитьСтраницуНаСервере()
	НовИд = УведомлениеОСпецрежимахНалогообложения.УдалитьСтраницуНаСервере(ЭтотОбъект);
	Если НовИд <> Неопределено Тогда 
		Элементы.ДеревоСтраниц.ТекущаяСтрока = НовИд;
	КонецЕсли;
	Модифицированность = Истина;
КонецПроцедуры

&НаСервере
Процедура ПриЗакрытииНаСервере()
	СохранитьДанные();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаАдреса(Область, СтандартнаяОбработка) Экспорт
	РоссийскийАдрес = Неопределено;
	ЗначенияПолей = Неопределено;
	ПредставлениеАдреса = Неопределено;
	УведомлениеОСпецрежимахНалогообложенияКлиент.ОбработкаАдреса(ЭтотОбъект, Область, РоссийскийАдрес, ЗначенияПолей, ПредставлениеАдреса, СтандартнаяОбработка);
	Если СтандартнаяОбработка Тогда 
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Заголовок",				"Ввод адреса");
	ПараметрыФормы.Вставить("ЗначенияПолей", 			ЗначенияПолей);
	ПараметрыФормы.Вставить("Представление", 			ПредставлениеАдреса);
	ПараметрыФормы.Вставить("ВидКонтактнойИнформации",	ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.АдресМестаПроживанияФизическиеЛица"));
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("РоссийскийАдрес", РоссийскийАдрес);
	ДополнительныеПараметры.Вставить("Префикс", ?(СтрНачинаетсяС(Область.Имя, "АДДР"), Лев(Область.Имя, 6), ""));
	
	ТипЗначения = Тип("ОписаниеОповещения");
	ПараметрыКонструктора = Новый Массив(3);
	ПараметрыКонструктора[0] = "ОткрытьФормуКонтактнойИнформацииЗавершение";
	ПараметрыКонструктора[1] = ЭтотОбъект;
	ПараметрыКонструктора[2] = ДополнительныеПараметры;
	
	Оповещение = Новый (ТипЗначения, ПараметрыКонструктора);
	
	ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеКонтактнойИнформациейКлиент").ОткрытьФормуКонтактнойИнформации(ПараметрыФормы, , Оповещение);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуКонтактнойИнформацииЗавершение(Результат, Параметры) Экспорт
	УведомлениеОСпецрежимахНалогообложенияКлиент.ОбновитьАдресВТабличномДокументе(ЭтотОбъект, Результат, Параметры, Истина);
КонецПроцедуры

&НаСервере
Функция КодЭлементаСправочника(Результат)
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Результат, "Код");
КонецФункции

&НаКлиенте
Процедура ОткрытьФормуВыбораСтраныЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат <> Неопределено Тогда
		КодЭлементаСправочника = КодЭлементаСправочника(Результат);
		Область = ДополнительныеПараметры.Область;
		Если Область.Значение <> КодЭлементаСправочника Тогда
			Область.Значение = КодЭлементаСправочника;
			Модифицированность = Истина;
		КонецЕсли;
		ПредставлениеУведомленияПриИзмененииСодержимогоОбласти(Элементы.ПредставлениеУведомления, Область);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьСтроку()
	Если ТекущееИДНаименования = "ЛистЛ1" Тогда 
		МногострочнаяЧасть1.Добавить();
		ВывестиМногострочнуюЧасть("МногострочнаяЧасть1");
	ИначеЕсли ТекущееИДНаименования = "ЛистЛ2" Тогда
		МногострочнаяЧасть2.Добавить();
		ВывестиМногострочнуюЧасть("МногострочнаяЧасть2");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УдалитьСтроку(Область)
	ОбластьИмя = Область.Имя;
	Номер = Число(Сред(ОбластьИмя, СтрНайти(ОбластьИмя, "_") + 1)) - 1;
	
	Если ТекущееИДНаименования = "ЛистЛ1" Тогда
		МногострочнаяЧасть1.Удалить(Номер);
		Если МногострочнаяЧасть1.Количество() = 0 Тогда 
			МногострочнаяЧасть1.Добавить();
		КонецЕсли;
		ВывестиМногострочнуюЧасть("МногострочнаяЧасть1");
	ИначеЕсли ТекущееИДНаименования = "ЛистЛ2" Тогда
		МногострочнаяЧасть2.Удалить(Номер);
		Если МногострочнаяЧасть2.Количество() = 0 Тогда 
			МногострочнаяЧасть2.Добавить();
		КонецЕсли;
		ВывестиМногострочнуюЧасть("МногострочнаяЧасть2");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ВывестиМногострочнуюЧасть(МногострочнаяЧасть)
	Обл = ПредставлениеУведомления.Область(МногострочнаяЧасть);
	ПредставлениеУведомления.УдалитьОбласть(ПредставлениеУведомления.Область(Обл.Верх, , Обл.Верх + 10 * ЭтаФорма[МногострочнаяЧасть].Количество()), ТипСмещенияТабличногоДокумента.ПоВертикали);
	
	Колонки = РеквизитФормыВЗначение(МногострочнаяЧасть).Колонки;
	Если ТекущееИДНаименования = "ЛистЛ1" Тогда 
		Макет = Отчеты[Объект.ИмяОтчета].ПолучитьМакет("Форма2014_1_СтраницаЛ1");
	ИначеЕсли ТекущееИДНаименования = "ЛистЛ2" Тогда
		Макет = Отчеты[Объект.ИмяОтчета].ПолучитьМакет("Форма2014_1_СтраницаЛ2");
	КонецЕсли;
	ОбластьМнг = Макет.ПолучитьОбласть(МногострочнаяЧасть);
	ОбластьДоб = Макет.ПолучитьОбласть("ДобавлениеСтроки");
	
	Инд = 1;
	Для Каждого Стр Из ЭтаФорма[МногострочнаяЧасть] Цикл 
		Если Инд > 1 Тогда 
			Для Каждого Колонка Из Колонки Цикл 
				ОбластьМнг.Области[Колонка.Имя + "_" + (Инд - 1)].Имя = Колонка.Имя + "_" + Инд;
			КонецЦикла;
			ОбластьМнг.Области["УдалитьСтроку_" + (Инд - 1)].Имя = "УдалитьСтроку_" + Инд;
			Если Инд = 2 Тогда 
				ОбластьМнг.Области[МногострочнаяЧасть].Имя = "";
			КонецЕсли;
		КонецЕсли;
		ПредставлениеУведомления.Вывести(ОбластьМнг);
		
		Для Каждого Колонка Из Колонки Цикл 
			ПредставлениеУведомления.Области[Колонка.Имя + "_" + Инд].Значение = Стр[Колонка.Имя];
		КонецЦикла;
		Инд = Инд + 1;
	КонецЦикла;
	
	ПредставлениеУведомления.Вывести(ОбластьДоб);
КонецПроцедуры

&НаКлиенте
Функция ОпределитьПринадлежностьОбластиКМногострочномуРазделу(ОбластьИмя) Экспорт 
	Если ("А01020000" = Лев(ОбластьИмя, СтрНайти(ОбластьИмя, "_") - 1)) Тогда 
		Если ТекущееИДНаименования = "ЛистЛ1" Тогда
			Возврат "МногострочнаяЧасть1";
		ИначеЕсли ТекущееИДНаименования = "ЛистЛ2" Тогда
			Возврат "МногострочнаяЧасть2";
		КонецЕсли;
	КонецЕсли;
КонецФункции

&НаКлиенте
Процедура ПредварительныйПросмотр(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ТекстВопроса = "Перед печатью необходимо сохранить изменения. Сохранить изменения?";
		ОписаниеОповещения = Новый ОписаниеОповещения("ПредварительныйПросмотрЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 0);
		Возврат;
	ИначеЕсли Модифицированность Тогда 
		СохранитьДанные();
	КонецЕсли;
	
	МассивПечати = Новый Массив;
	МассивПечати.Добавить(Объект.Ссылка);
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
		"Документ.УведомлениеОСпецрежимахНалогообложения",
		"Уведомление", МассивПечати, Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредварительныйПросмотрЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		СохранитьДанные();
		МассивПечати = Новый Массив;
		МассивПечати.Добавить(Объект.Ссылка);
		УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
			"Документ.УведомлениеОСпецрежимахНалогообложения",
			"Уведомление", МассивПечати, Неопределено);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция СформироватьXMLНаСервере(УникальныйИдентификатор)
	СохранитьДанные();
	Документ = РеквизитФормыВЗначение("Объект");
	Возврат Документ.ВыгрузитьДокумент(УникальныйИдентификатор);
КонецФункции

&НаКлиенте
Процедура СформироватьXML(Команда)
	
	ВыгружаемыеДанные = СформироватьXMLНаСервере(УникальныйИдентификатор);
	Если ВыгружаемыеДанные <> Неопределено Тогда 
		РегламентированнаяОтчетностьКлиент.ВыгрузитьФайлы(ВыгружаемыеДанные);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСДвухмернымШтрихкодомPDF417(Команда)
	РегламентированнаяОтчетностьКлиент.ВывестиМашиночитаемуюФормуУведомленияОСпецрежимах(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Функция СформироватьВыгрузкуИПолучитьДанные() Экспорт 
	Выгрузка = СформироватьXMLНаСервере(УникальныйИдентификатор);
	Если Выгрузка = Неопределено Тогда 
		Возврат Неопределено;
	КонецЕсли;
	Выгрузка = Выгрузка[0];
	Возврат Новый Структура("ТестВыгрузки,КодировкаВыгрузки,Данные,ИмяФайла", 
			Выгрузка.ТестВыгрузки, Выгрузка.КодировкаВыгрузки, 
			Отчеты[Объект.ИмяОтчета].ПолучитьМакет("TIFF_2014_1"),
			"1111502_5.01000_06.tif");
КонецФункции

&НаКлиенте
Процедура СохранитьНаКлиенте(Автосохранение = Ложь,ВыполняемоеОповещение = Неопределено) Экспорт 
	Если Модифицированность И УведомлениеЗаполненоВПомощнике Тогда
		Оповестить("ЗакрытьПомощникВнесенияИзмененийЕГР", Объект.Ссылка);
	КонецЕсли;
	
	СохранитьДанные();
	Если ВыполняемоеОповещение <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ВыполняемоеОповещение);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	СохранитьНаКлиенте();
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения",,Объект.Ссылка);
	Закрыть(Неопределено);
КонецПроцедуры

#Область ОтправкаВФНС
////////////////////////////////////////////////////////////////////////////////
// Отправка в ФНС
&НаКлиенте
Процедура ОтправитьВКонтролирующийОрган(Команда)
	
	РегламентированнаяОтчетностьКлиент.ПриНажатииНаКнопкуОтправкиВКонтролирующийОрган(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВИнтернете(Команда)
	
	РегламентированнаяОтчетностьКлиент.ПроверитьВИнтернете(ЭтотОбъект);
	
КонецПроцедуры
#КонецОбласти

#Область ПанельОтправкиВКонтролирующиеОрганы

&НаКлиенте
Процедура ОбновитьОтправку(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОбновитьОтправкуИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаПротоколНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьПротоколИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьНеотправленноеИзвещение(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОтправитьНеотправленноеИзвещениеИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыОтправкиНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьСостояниеОтправкиИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура КритическиеОшибкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьКритическиеОшибкиИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаНаименованиеЭтапаНажатие(Элемент)
	
	ПараметрыИзменения = Новый Структура;
	ПараметрыИзменения.Вставить("Форма", ЭтаФорма);
	ПараметрыИзменения.Вставить("Организация", Объект.Организация);
	ПараметрыИзменения.Вставить("КонтролирующийОрган",
		ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ФНС"));
	ПараметрыИзменения.Вставить("ТекстВопроса", НСтр("ru='Вы уверены, что уведомление уже сдано?'"));
	
	РегламентированнаяОтчетностьКлиент.ИзменитьСтатусОтправки(ПараметрыИзменения);
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ПроверитьВыгрузкуНаСервере()
	СохранитьДанные();
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.ПроверитьДокумент(УникальныйИдентификатор);
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВыгрузку(Команда)
	ПроверитьВыгрузкуНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОткрытьПрисоединенныеФайлы(Команда)
	
	РегламентированнаяОтчетностьКлиент.СохранитьУведомлениеИОткрытьФормуПрисоединенныеФайлы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьБРО(Команда)
	ПечатьБРОНаСервере();
	РегламентированнаяОтчетностьКлиент.ОткрытьФормуПредварительногоПросмотра(ЭтотОбъект, , Ложь, СтруктураРеквизитовУведомления.СписокПечатаемыхЛистов);
КонецПроцедуры

&НаСервере
Процедура ПечатьБРОНаСервере()
	УведомлениеОСпецрежимахНалогообложения.ПечатьУведомленияБРО(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьКодОКСМ(Команда)
	ПредставлениеУведомления.ТекущаяОбласть.Значение = "";
	УведомлениеОСпецрежимахНалогообложенияКлиент.ПриИзмененииСодержимогоОбласти(ЭтотОбъект, ПредставлениеУведомления.ТекущаяОбласть, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеУведомленияПриАктивизацииОбласти(Элемент)
	Элементы.ПредставлениеУведомленияКонтекстноеМенюОчиститьКодОКСМ.Доступность = ЭтоОбластьОКСМ(Элемент.ТекущаяОбласть);
КонецПроцедуры

&НаКлиенте
Процедура РучнойВвод(Команда)
	РучнойВвод = Не РучнойВвод;
	Элементы.ФормаРучнойВвод.Пометка = РучнойВвод;
КонецПроцедуры

&НаКлиенте
Процедура КомментарийПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура УведомлениеЗаполненоВПомощникеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	Если НавигационнаяСсылкаФорматированнойСтроки = "ВнесениеИзмененийЕГР" Тогда
		СтандартнаяОбработка = Ложь;
		
		МодульРегистрацияОрганизацииКлиентСервер = ОбщегоНазначенияКлиент.ОбщийМодуль("РегистрацияОрганизацииКлиентСервер");
		ПараметрыПомощника = МодульРегистрацияОрганизацииКлиентСервер.НовыеПараметрыПомощникаВнесенияИзменений();
		ПараметрыПомощника.Организация = Объект.Организация;
		ПараметрыПомощника.КонтекстныйВызов = Истина;
		
		МодульРегистрацияОрганизацииКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РегистрацияОрганизацииКлиент");
		МодульРегистрацияОрганизацииКлиент.ОткрытьПомощникВнесенияИзменений(ПараметрыПомощника);
		
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьУведомлениеЗаполненоВПомощникеНажатие(Элемент)
	УведомлениеЗаполненоВПомощнике = Ложь;
	УправлениеФормой(ЭтотОбъект);
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	Форма.Элементы.ГруппаУведомлениеИзПомощника.Видимость = Форма.УведомлениеЗаполненоВПомощнике;
КонецПроцедуры
