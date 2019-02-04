
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("СтруктурнаяЕдиница", СтруктурнаяЕдиница);
	Если НЕ ЗначениеЗаполнено(СтруктурнаяЕдиница) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ПрочитатьРегистрациюВНалоговомОргане();
	ИнициализироватьФорму();
	
	// Позиционирование на элементах формы
	// см. ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентПереопределяемый.ОткрытьФормуОрганизацииНаРеквизите.
	
	Если Параметры.Свойство("ИмяРеквизита") И Не ПустаяСтрока(Параметры.ИмяРеквизита) Тогда
		
		Если Не ПустаяСтрока(Параметры.ИмяРеквизита) Тогда
			
			ТекущийЭлементФормы = Элементы.Найти(Параметры.ИмяРеквизита);
			Если ТекущийЭлементФормы <> Неопределено Тогда
				ТекущийЭлемент = ТекущийЭлементФормы;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("СохранитьИЗакрыть", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)

	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		
		Модифицированность = Истина;
		ЗаполнитьЗначенияСвойств(РегистрацияВНалоговомОргане, ВыбранноеЗначение);
		Если ВыбранноеЗначение.Свойство("Представитель") Тогда
			ОтчетностьПодписываетПредставитель = ?(ЗначениеЗаполнено(РегистрацияВНалоговомОргане.Представитель), 1, 0);
		КонецЕсли;
	
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОтредактированаИстория"
		И Параметр.ИмяРегистра = "ИсторияРегистрацийВНалоговомОргане"
		И Источник = СтруктурнаяЕдиница Тогда
		
		Если ЗначениеЗаполнено(РегистрацияВНалоговомОргане.Ссылка)
			ИЛИ Параметр.МассивЗаписей.Количество() > 0 Тогда
			
			РедактированиеПериодическихСведенийКлиент.ОбработкаОповещения(ЭтаФорма, СтруктурнаяЕдиница, ИмяСобытия, Параметр, Источник);
			ПоместитьДанныеРегистрацииВФорму(ИсторияРегистрацийВНалоговомОргане.РегистрацияВНалоговомОргане);
		
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ОтчетностьПодписываетПредставитель = 1
		И НЕ ЗначениеЗаполнено(РегистрацияВНалоговомОргане.Представитель) Тогда
		
		ТекстСообщения = НСтр("ru = 'Заполните сведения о представителе'"); 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "ПредставлениеПредставителя",, Отказ);
	
	КонецЕсли;
	
	Попытка
		РегистрацияВНалоговомОрганеОбъект = РеквизитФормыВЗначение("РегистрацияВНалоговомОргане");
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки(), , , , Отказ);
	КонецПопытки;
	
	Если НЕ Отказ И НЕ РегистрацияВНалоговомОрганеОбъект.ПроверитьЗаполнение() Тогда
		Отказ = Истина;
	КонецЕсли; 
	
	Если НЕ Отказ Тогда
		РедактированиеПериодическихСведений.ПроверитьЗаписьВФорме(ЭтаФорма, "ИсторияРегистрацийВНалоговомОргане", СтруктурнаяЕдиница, Отказ);
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КПППриИзменении(Элемент)
	
	РегистрацияВНалоговомОргане.Код = Лев(СокрЛ(РегистрацияВНалоговомОргане.КПП), 4);
	ОбновитьИсторияРегистрацийВНалоговомОрганеПериод(ЭтаФорма, ОбщегоНазначенияКлиент.ДатаСеанса());
	НайтиСуществующуюРегистрацию();
	УстановитьДоступностьЭлементовФормы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура КодПриИзменении(Элемент)
	НайтиСуществующуюРегистрацию();
	УстановитьДоступностьЭлементовФормы(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	Если ПустаяСтрока(РегистрацияВНалоговомОргане.НаименованиеИФНС) Тогда
		
		НаименованиеИФНС = РегистрацияВНалоговомОргане.Наименование;
		НаименованиеИФНС = СтрЗаменить(НаименованиеИФНС,	НСтр("ru='МИФНС'"),	НСтр("ru='Межрайонная инспекция федеральной налоговой службы'"));
		НаименованиеИФНС = СтрЗаменить(НаименованиеИФНС,	НСтр("ru='ИФНС'"),	НСтр("ru='Инспекция федеральной налоговой службы'"));
		НаименованиеИФНС = СтрЗаменить(НаименованиеИФНС,	НСтр("ru='ФНС'"),	НСтр("ru='Федеральная налоговая служба'"));
		
		РегистрацияВНалоговомОргане.НаименованиеИФНС	= НаименованиеИФНС;
		
	КонецЕсли;
	ОбновитьИсторияРегистрацийВНалоговомОрганеПериод(ЭтаФорма, ОбщегоНазначенияКлиент.ДатаСеанса());
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчетностьПодписываетПредставительПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	ОбновитьИсторияРегистрацийВНалоговомОрганеПериод(ЭтаФорма, ОбщегоНазначенияКлиент.ДатаСеанса());
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПредставителяНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ЗначенияЗаполнения = Новый Структура("Владелец,Представитель,УполномоченноеЛицоПредставителя,ДокументПредставителя,Доверенность");
	ЗаполнитьЗначенияСвойств(ЗначенияЗаполнения, РегистрацияВНалоговомОргане);
	
	ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	ОткрытьФорму("Справочник.РегистрацииВНалоговомОргане.Форма.ФормаПредставителя", ПараметрыФормы, ЭтаФорма, КлючУникальности);
	ОбновитьИсторияРегистрацийВНалоговомОрганеПериод(ЭтаФорма, ОбщегоНазначенияКлиент.ДатаСеанса());
	
КонецПроцедуры

&НаКлиенте
Процедура КодПоОКАТОПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(РегистрацияВНалоговомОргане.КодПоОКАТО) Тогда
		
		ДлинаЗначения = СтрДлина(СокрЛП(РегистрацияВНалоговомОргане.КодПоОКАТО));
		
		Для Инд = ДлинаЗначения + 1 По 11 Цикл
			
			РегистрацияВНалоговомОргане.КодПоОКАТО = СокрЛП(РегистрацияВНалоговомОргане.КодПоОКАТО) + "0";
			
		КонецЦикла;
		
	КонецЕсли;
	ОбновитьИсторияРегистрацийВНалоговомОрганеПериод(ЭтаФорма, ОбщегоНазначенияКлиент.ДатаСеанса());

КонецПроцедуры

&НаКлиенте
Процедура ИсторияРегистрацийВНалоговомОрганеПериодПриИзменении(Элемент)
	
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(
		ЭтаФорма,
		"ИсторияРегистрацийВНалоговомОрганеПериод",
		"ИсторияРегистрацийВНалоговомОрганеПериодСтрокой",
		Модифицированность);
		
	ИсторияРегистрацийВНалоговомОргане.Период = ИсторияРегистрацийВНалоговомОрганеПериод;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияРегистрацийВНалоговомОрганеПериодНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	Оповещение = Новый ОписаниеОповещения("ИсторияРегистрацийВНалоговомОрганеПериодНачалоВыбораЗавершение", ЭтотОбъект);
	
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(
		ЭтаФорма,
		ЭтаФорма,
		"ИсторияРегистрацийВНалоговомОрганеПериод",
		"ИсторияРегистрацийВНалоговомОрганеПериодСтрокой", ,
		Оповещение);
		
КонецПроцедуры

&НаКлиенте
Процедура ИсторияРегистрацийВНалоговомОрганеПериодНачалоВыбораЗавершение(ЗначениеВыбрано, ДополнительныеПараметры) Экспорт 
	
	ИсторияРегистрацийВНалоговомОргане.Период = ИсторияРегистрацийВНалоговомОрганеПериод;

КонецПроцедуры

&НаКлиенте
Процедура ИсторияРегистрацийВНалоговомОрганеПериодРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(
		ЭтаФорма,
		"ИсторияРегистрацийВНалоговомОрганеПериод",
		"ИсторияРегистрацийВНалоговомОрганеПериодСтрокой",
		Направление,
		Модифицированность);
		
	ИсторияРегистрацийВНалоговомОргане.Период = ИсторияРегистрацийВНалоговомОрганеПериод;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияРегистрацийВНалоговомОрганеПериодСтрокойАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ИсторияРегистрацийВНалоговомОрганеПериодОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ЗаписатьИЗакрытьЗавершение", ЭтотОбъект);
	ЗаписатьРегистрациюВНалоговомОргане(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрытьЗавершение(Отказ, ДополнительныеПараметры) Экспорт 
	
	Если Не Отказ Тогда
		Оповестить("Запись_Организации", , РегистрацияВНалоговомОргане.Владелец);
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияРегистрацийВНалоговомОрганеИстория(Команда)
	
	Отказ = Ложь;
	
	Если Модифицированность Тогда
		
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?'");
		
		Оповещение = Новый ОписаниеОповещения("ИсторияРегистрацийВНалоговомОрганеИсторияПродолжение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена, , КодВозвратаДиалога.Отмена);
		
	Иначе 
		
		ИсторияРегистрацийВНалоговомОрганеИсторияПродолжение(КодВозвратаДиалога.Да, Неопределено);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьРегистрациюОрганизации(Команда)
	
	ПараметрыОткрытия = Новый Структура;
	Отборы = Новый Структура("Владелец", ВладелецРегистрацииВНалоговомОргане);
	ПараметрыОткрытия.Вставить("Отбор", Отборы);
	
	Оповещение = Новый ОписаниеОповещения("ВыбратьРегистрациюОрганизацииЗавершение", ЭтотОбъект);
	
	ОткрытьФорму("Справочник.РегистрацииВНалоговомОргане.ФормаВыбора", ПараметрыОткрытия, , Истина, , , Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияРегистрацийВНалоговомОрганеИсторияПродолжение(Ответ, ДополнительныеПараметры) Экспорт 
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда 
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		Оповещение = Новый ОписаниеОповещения("ИсторияРегистрацийВНалоговомОрганеИсторияЗавершение", ЭтотОбъект);
		ЗаписатьРегистрациюВНалоговомОргане(Оповещение);
	Иначе 
		ИсторияРегистрацийВНалоговомОрганеИсторияЗавершение(Ложь, Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияРегистрацийВНалоговомОрганеИсторияЗавершение(Отказ, ДополнительныеПараметры) Экспорт 

	Если Не Отказ Тогда 
		РедактированиеПериодическихСведенийКлиент.ОткрытьИсторию("ИсторияРегистрацийВНалоговомОргане", СтруктурнаяЕдиница, ЭтаФорма, ТолькоПросмотр);
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ИнициализироватьФорму()
	
	ЭтоОбособленноеПодразделение = Ложь;
	ЭтоФизическоеЛицо            = Ложь;
	
	Если ЗначениеЗаполнено(РегистрацияВНалоговомОргане.Владелец) Тогда 
		
		Элементы.Владелец.ТолькоПросмотр = Истина;
		Элементы.Владелец.КнопкаОткрытия = Ложь;
		Элементы.Владелец.КнопкаВыбора = Ложь;
		Элементы.Владелец.АвтоОтметкаНезаполненного = Ложь;
		
		Если РегистрацияВНалоговомОргане.Владелец.Метаданные().Реквизиты.Найти("ЮридическоеФизическоеЛицо") <> Неопределено
			И РегистрацияВНалоговомОргане.Владелец.Метаданные().Реквизиты.Найти("ОбособленноеПодразделение") <> Неопределено Тогда 
			
			РеквизитыОрганизации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(РегистрацияВНалоговомОргане.Владелец, "ЮридическоеФизическоеЛицо, ОбособленноеПодразделение");
			
			ЭтоОбособленноеПодразделение = РеквизитыОрганизации.ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо
				И РеквизитыОрганизации.ОбособленноеПодразделение;
			
			ЭтоФизическоеЛицо = РеквизитыОрганизации.ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо;
			
		КонецЕсли;
	
	КонецЕсли;
	
	Элементы.КПП.Видимость = НЕ ЭтоФизическоеЛицо;
	
	Если ЭтоОбособленноеПодразделение Тогда
		
		ГоловнаяОрганизация = РегламентированнаяОтчетность.ГоловнаяОрганизация(РегистрацияВНалоговомОргане.Владелец);
		
	Иначе
		
		Элементы.Владелец.Заголовок	= НСтр("ru = 'Организация'");
		Элементы.ГоловнаяОрганизация.Видимость = Ложь;
		Элементы.НаименованиеОбособленногоПодразделения.Видимость = Ложь;
		
	КонецЕсли;
	
	ОтчетностьПодписываетПредставитель = ?(ЗначениеЗаполнено(РегистрацияВНалоговомОргане.Представитель), 1, 0);
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Элементы = Форма.Элементы;
	Объект   = Форма.РегистрацияВНалоговомОргане;
	
	Если Форма.ОтчетностьПодписываетПредставитель = 1 Тогда
		Форма.Элементы.ГруппаПредставлениеПредставителяСтраницы.ТекущаяСтраница = Форма.Элементы.ГруппаПредставительГиперссылка;
	Иначе
		Форма.Элементы.ГруппаПредставлениеПредставителяСтраницы.ТекущаяСтраница = Форма.Элементы.ГруппаПредставительНеВыбран;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Представитель) Тогда
		Форма.ПредставлениеПредставителя = НСтр("ru = 'Заполнить'");
	ИначеЕсли ТипЗнч(Объект.Представитель) = Тип("СправочникСсылка.ФизическиеЛица")
		ИЛИ НЕ ЗначениеЗаполнено(Объект.УполномоченноеЛицоПредставителя) Тогда
		Форма.ПредставлениеПредставителя = Объект.Представитель;
	ИначеЕсли ТипЗнч(Объект.Представитель) = Тип("СправочникСсылка.Контрагенты") Тогда
		Форма.ПредставлениеПредставителя = Объект.УполномоченноеЛицоПредставителя + " (" + Объект.Представитель + ")";
	КонецЕсли;
	
	УстановитьДоступностьЭлементовФормы(Форма);
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьРегистрациюВНалоговомОргане()
	
	Запрос = Новый Запрос;
	
	Если ТипЗнч(СтруктурнаяЕдиница) = Тип("СправочникСсылка.Организации") Тогда
		ОрганизацияВладельцаРегистрацииВНалоговомОргане = СтруктурнаяЕдиница;
	Иначе
		ОрганизацияВладельцаРегистрацииВНалоговомОргане = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтруктурнаяЕдиница, "Владелец");
	КонецЕсли;
	
	ВладелецРегистрацииВНалоговомОргане = ЗарплатаКадры.ГоловнаяОрганизация(ОрганизацияВладельцаРегистрацииВНалоговомОргане);
	
	Запрос.УстановитьПараметр("Владелец", ВладелецРегистрацииВНалоговомОргане);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	РегистрацииВНалоговомОргане.Ссылка КАК РегистрацияВНалоговомОргане,
		|	РегистрацииВНалоговомОргане.Код,
		|	РегистрацииВНалоговомОргане.КПП
		|ИЗ
		|	Справочник.РегистрацииВНалоговомОргане КАК РегистрацииВНалоговомОргане
		|ГДЕ
		|	РегистрацииВНалоговомОргане.Владелец = &Владелец";
	
	ВсеРегистрацииВНалогомОргане.Загрузить(Запрос.Выполнить().Выгрузить());
	
	РедактированиеПериодическихСведений.ПрочитатьЗаписьДляРедактированияВФорме(ЭтаФорма, "ИсторияРегистрацийВНалоговомОргане", СтруктурнаяЕдиница);
	Регистрация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ИсторияРегистрацийВНалоговомОргане.РегистрацияВНалоговомОргане, "Ссылка");
	Если НЕ ЗначениеЗаполнено(Регистрация) Тогда
		ИсторияРегистрацийВНалоговомОргане.РегистрацияВНалоговомОргане = СтруктурнаяЕдиница.РегистрацияВНалоговомОргане;
		ИсторияРегистрацийВНалоговомОрганеНоваяЗапись = Истина;
	КонецЕсли;
	
	ПоместитьДанныеРегистрацииВФорму(ИсторияРегистрацийВНалоговомОргане.РегистрацияВНалоговомОргане);
	
КонецПроцедуры

&НаСервере
Процедура ПоместитьДанныеРегистрацииВФорму(РегистрацияВНалоговомОрганеСсылка, ОбновитьДанныеПрежней = Истина)
	
	Если РегистрацияВНалоговомОрганеСсылка.Пустая() Тогда
		РегистрацияВНалоговомОрганеОбъект = Неопределено;
	Иначе
		РегистрацияВНалоговомОрганеОбъект = РегистрацияВНалоговомОрганеСсылка.ПолучитьОбъект();
	КонецЕсли;
	
	Если РегистрацияВНалоговомОрганеОбъект = Неопределено Тогда
		РегистрацияВНалоговомОрганеОбъект = Справочники.РегистрацииВНалоговомОргане.СоздатьЭлемент();
		РегистрацияВНалоговомОрганеОбъект.Владелец = ВладелецРегистрацииВНалоговомОргане;
	КонецЕсли;
	
	ЗаблокироватьДанныеФормыДляРедактирования();
	
	ЗначениеВРеквизитФормы(РегистрацияВНалоговомОрганеОбъект, "РегистрацияВНалоговомОргане");
	Если ОбновитьДанныеПрежней Тогда
		ЗначениеВРеквизитФормы(РегистрацияВНалоговомОрганеОбъект, "РегистрацияВНалоговомОрганеПрежняя");
	КонецЕсли;
	
	ОбновитьИсторияРегистрацийВНалоговомОрганеПериод(ЭтаФорма, ТекущаяДатаСеанса());
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьРегистрациюВНалоговомОргане(ОповещениеЗакрытия = Неопределено)
	
	ОчиститьСообщения();
	
	Если Не ПроверитьЗаполнение() Тогда
		
		Отказ = Истина;
		Если ОповещениеЗакрытия <> Неопределено Тогда 
			ВыполнитьОбработкуОповещения(ОповещениеЗакрытия, Отказ);
		КонецЕсли;
		
		Возврат;
		
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура("ОповещениеЗакрытия", ОповещениеЗакрытия);
	
	Если Не ЗначениеЗаполнено(ИсторияРегистрацийВНалоговомОрганеПрежняя.РегистрацияВНалоговомОргане)
		Или  ПустаяСтрока(ЗарплатаКадрыВызовСервера.ДанныеРегистрацииВНалоговомОргане(СтруктурнаяЕдиница, ИсторияРегистрацийВНалоговомОрганеПрежняя.РегистрацияВНалоговомОргане).КПП) Тогда
		
		ЗаписатьРегистрациюВНалоговомОрганеЗавершение(Неопределено, ДополнительныеПараметры);
		Возврат;
		
	КонецЕсли; 
	
	ТекстКнопкиДа = НСтр("ru = 'Изменились данные о регистрации в налоговом органе'");
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'При редактировании изменили данные о регистрации. 
					|Если была исправлена прежняя запись (она была ошибочной), нажмите ""Исправлена ошибка"".
					|Если изменились данные о регистрации с %1, нажмите ""%2""'"), 
			Формат(ИсторияРегистрацийВНалоговомОргане.Период, "ДФ='д ММММ гггг ""г""'"),
			ТекстКнопкиДа);
		
	МассивИменПроверяемыхРеквизитов = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(КлючевыеРеквизитыРегистрацииВНалоговомОргане());
		
	ОбъектИзменен = Ложь;
	Для каждого ИмяПроверяемогоРеквизита Из МассивИменПроверяемыхРеквизитов Цикл
		Если РегистрацияВНалоговомОргане[ИмяПроверяемогоРеквизита] <> РегистрацияВНалоговомОрганеПрежняя[ИмяПроверяемогоРеквизита] Тогда
			ОбъектИзменен = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ОбъектИзменен И ИсторияРегистрацийВНалоговомОргане.Период <> ИсторияРегистрацийВНалоговомОрганеПрежняя.Период Тогда
		
		Кнопки = Новый СписокЗначений();
		Кнопки.Добавить(КодВозвратаДиалога.Нет,  	НСтр("ru = 'Исправлена ошибка'"));
		Кнопки.Добавить(КодВозвратаДиалога.Да, 		ТекстКнопкиДа);
		Кнопки.Добавить(КодВозвратаДиалога.Отмена, 	НСтр("ru = 'Отмена'"));
		
		Оповещение = Новый ОписаниеОповещения("ЗаписатьРегистрациюВНалоговомОрганеЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Кнопки, , КодВозвратаДиалога.Отмена);
		
	Иначе
		
		ЗаписатьРегистрациюВНалоговомОрганеЗавершение(Неопределено, ДополнительныеПараметры);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьРегистрациюВНалоговомОрганеЗавершение(Ответ, ДополнительныеПараметры) Экспорт 
	
	Отказ = Ложь;
	
	Если Ответ = КодВозвратаДиалога.Отмена Тогда
		Отказ = Истина;
	ИначеЕсли Ответ = КодВозвратаДиалога.Да Тогда
		ИсторияРегистрацийВНалоговомОрганеНоваяЗапись = Истина;
	КонецЕсли;
		
	Если Не Отказ Тогда
		ЗаписатьРегистрациюВНалоговомОрганеНаСервере(Отказ);
	КонецЕсли;
	
	Если Не Отказ Тогда
		ПараметрОповещения = Новый Структура("Ссылка, Владелец", РегистрацияВНалоговомОргане.Ссылка, РегистрацияВНалоговомОргане.Владелец);
		Оповестить("ИзмененаРегистрацияВНалоговомОргане", ПараметрОповещения, ВладелецФормы);
		ПроверитьЗаполнениеРегистраций();
	КонецЕсли;
	
	Если ДополнительныеПараметры.ОповещениеЗакрытия <> Неопределено Тогда 
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеЗакрытия, Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьЗаполнениеРегистраций()
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("СтруктурнаяЕдиница", РегистрацияВНалоговомОргане.Владелец);
	
	ОткрытьФорму("Обработка.ПерезаполнениеРегистрацийВНалоговомОргане.Форма", ПараметрыОткрытия, ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьРегистрациюВНалоговомОрганеНаСервере(Отказ)
	
	СуществующаяЗапись = Неопределено;
	Если ИсторияРегистрацийВНалоговомОрганеНоваяЗапись И ЗначениеЗаполнено(РегистрацияВНалоговомОрганеПрежняя.Код) Тогда
		
		СуществующаяЗапись = РегламентированнаяОтчетность.ПолучитьПоКодамРегистрациюВИФНС(
			РегистрацияВНалоговомОргане.Владелец, РегистрацияВНалоговомОргане.Код, ?(ПустаяСтрока(РегистрацияВНалоговомОргане.КПП), Неопределено, РегистрацияВНалоговомОргане.КПП));
		
		Если СуществующаяЗапись = Неопределено Тогда
			РегистрацияОбъект = Справочники.РегистрацииВНалоговомОргане.СоздатьЭлемент();
		Иначе
			РегистрацияОбъект = СуществующаяЗапись.ПолучитьОбъект();
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(РегистрацияОбъект, РеквизитФормыВЗначение("РегистрацияВНалоговомОргане"), КлючевыеРеквизитыРегистрацииВНалоговомОргане());
		РегистрацияОбъект.Владелец = РегистрацияВНалоговомОргане.Владелец;
		
	Иначе
		РегистрацияОбъект = РеквизитФормыВЗначение("РегистрацияВНалоговомОргане");
	КонецЕсли;
	
	Если ОтчетностьПодписываетПредставитель = 0 Тогда
		РегистрацияОбъект.Представитель						= Неопределено;
		РегистрацияОбъект.УполномоченноеЛицоПредставителя	= "";
		РегистрацияОбъект.ДокументПредставителя				= "";
		РегистрацияОбъект.Доверенность						= "";
	КонецЕсли;
	
	Попытка
		
		РегистрацияОбъект.Записать();
		
		Если ИсторияРегистрацийВНалоговомОрганеНоваяЗапись И СуществующаяЗапись = Неопределено Тогда
			
			ЗаписьВсехРегистраций = ВсеРегистрацииВНалогомОргане.Добавить();
			ЗаписьВсехРегистраций.Код = РегистрацияВНалоговомОргане.Код;
			ЗаписьВсехРегистраций.КПП = РегистрацияВНалоговомОргане.КПП;
			ЗаписьВсехРегистраций.РегистрацияВНалоговомОргане = РегистрацияОбъект.Ссылка;
			
		КонецЕсли;
		
	Исключение
		Отказ = Истина;
		Возврат;
	КонецПопытки;
	
	ЗначениеВРеквизитФормы(РегистрацияОбъект, "РегистрацияВНалоговомОргане");
	
	ДополнительныеСвойства = Неопределено;
	Если НЕ ЗначениеЗаполнено(ИсторияРегистрацийВНалоговомОрганеПрежняя.РегистрацияВНалоговомОргане) Тогда
		ДополнительныеСвойства = Новый Структура("ОтключитьПроверкуДатыЗапретаИзменения", Истина);
	КонецЕсли; 
	
	ИсторияРегистрацийВНалоговомОргане.РегистрацияВНалоговомОргане = РегистрацияОбъект.Ссылка;
	РедактированиеПериодическихСведений.ЗаписатьЗаписьПослеРедактированияВФорме(ЭтаФорма, "ИсторияРегистрацийВНалоговомОргане", СтруктурнаяЕдиница, , ДополнительныеСвойства);
	
	ПодчиненныеСтруктурныеЕдиницы = Справочники.ПодразделенияОрганизаций.ПодчиненныеСтруктурныеЕдиницы(СтруктурнаяЕдиница);
	РегистрыСведений.ИсторияРегистрацийВНалоговомОргане.ОбновитьПодчиненныеСтруктурныеЕдиницы(ПодчиненныеСтруктурныеЕдиницы);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Модифицированность = Ложь;
	ПрочитатьРегистрациюВНалоговомОргане();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция КлючевыеРеквизитыРегистрацииВНалоговомОргане()
	
	Возврат "КПП,НаименованиеИФНС,КодПоОКАТО,КодПоОКТМО,НаименованиеОбособленногоПодразделения,Представитель,УполномоченноеЛицоПредставителя,ДокументПредставителя,Доверенность,Код,Наименование";
	
КонецФункции

&НаСервере
Процедура ПрочитатьНаборЗаписейПериодическихСведений(ИмяРегистра, ВедущийОбъект) Экспорт
	
	РедактированиеПериодическихСведений.ПрочитатьНаборЗаписей(ЭтаФорма, ИмяРегистра, ВедущийОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьИсторияРегистрацийВНалоговомОрганеПериод(Форма, ДатаСеанса)
	
	РедактированиеПериодическихСведенийКлиентСервер.ОбновитьОтображениеПолейВвода(Форма, "ИсторияРегистрацийВНалоговомОргане", Форма.СтруктурнаяЕдиница);
	
	Если (Форма.ИсторияРегистрацийВНалоговомОрганеПрежняя.Период = НачалоМесяца(ЗарплатаКадрыКлиентСервер.ДатаОтсчетаПериодическихСведенийСПериодомМесяц())
		ИЛИ Форма.ИсторияРегистрацийВНалоговомОрганеПрежняя.Период = '00010101') И НЕ Форма.Модифицированность Тогда
		
		Форма.Элементы.ИсторияРегистрацийВНалоговомОрганеПериодСтрокой.АвтоОтметкаНезаполненного = Ложь;
		Форма.Элементы.ИсторияРегистрацийВНалоговомОрганеПериодСтрокой.ОтметкаНезаполненного = Ложь;
		
	Иначе
		Если Форма.Модифицированность
			И (Форма.ИсторияРегистрацийВНалоговомОрганеПрежняя.Период = '00010101'
				Или Форма.ИсторияРегистрацийВНалоговомОргане.Период = НачалоМесяца(ЗарплатаКадрыКлиентСервер.ДатаОтсчетаПериодическихСведенийСПериодомМесяц())) Тогда
			Форма.ИсторияРегистрацийВНалоговомОргане.Период = НачалоМесяца(ДатаСеанса);
		КонецЕсли;
	КонецЕсли;
	
	Если Форма.ИсторияРегистрацийВНалоговомОргане.Период = НачалоМесяца(ЗарплатаКадрыКлиентСервер.ДатаОтсчетаПериодическихСведенийСПериодомМесяц()) Тогда
		Форма.ИсторияРегистрацийВНалоговомОрганеПериод = '00010101';
	Иначе
		Форма.ИсторияРегистрацийВНалоговомОрганеПериод = Форма.ИсторияРегистрацийВНалоговомОргане.Период;
	КонецЕсли;
	
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(Форма, "ИсторияРегистрацийВНалоговомОрганеПериод", "ИсторияРегистрацийВНалоговомОрганеПериодСтрокой");
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИЗакрыть(Результат, ДополнительныеПараметры) Экспорт 
	
	Оповещение = Новый ОписаниеОповещения("СохранитьИЗакрытьЗавершение", ЭтотОбъект);
	ЗаписатьРегистрациюВНалоговомОргане(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИЗакрытьЗавершение(Отказ, ДополнительныеПараметры) Экспорт
	
	Если Не Отказ Тогда 
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НайтиСуществующуюРегистрацию()
	
	СтруктураПоиска = Новый Структура;
	СтруктураПоиска.Вставить("Код", РегистрацияВНалоговомОргане.Код);
	СтруктураПоиска.Вставить("КПП", РегистрацияВНалоговомОргане.КПП);
	
	СтрокиСуществующейРегистрации = ВсеРегистрацииВНалогомОргане.НайтиСтроки(СтруктураПоиска);
	Если СтрокиСуществующейРегистрации.Количество() > 0 Тогда
		ПоместитьДанныеРегистрацииВФорму(СтрокиСуществующейРегистрации[0].РегистрацияВНалоговомОргане);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьЭлементовФормы(Форма)
	
	ДоступностьРеквизитов = ЗначениеЗаполнено(Форма.РегистрацияВНалоговомОргане.Код)
		И (ЗначениеЗаполнено(Форма.РегистрацияВНалоговомОргане.КПП) ИЛИ Форма.ЭтоФизическоеЛицо);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"ГруппаРеквизитовЗаписи",
		"Доступность",
		ДоступностьРеквизитов);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"ИсторияРегистрацийВНалоговомОрганеПериодСтрокой",
		"Доступность",
		ДоступностьРеквизитов);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьРегистрациюОрганизацииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		ПоместитьДанныеРегистрацииВФорму(Результат, Ложь);
		УстановитьДоступностьЭлементовФормы(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
