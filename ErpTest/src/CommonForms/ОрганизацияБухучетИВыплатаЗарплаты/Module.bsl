
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("Заголовок",			Заголовок);
	Параметры.Свойство("ОрганизацияСсылка",	ОрганизацияСсылка);
	
	ПрочитатьДанные();
	
	УстановитьДоступностьНомераДняВыплатыЗарплаты(ЭтаФорма);
	НастроитьПоляМестВыплатыЗарплаты();
	
	ОтражениеЗарплатыВБухучете.УстановитьСписокВыбораОтношениеКЕНВД(Элементы, "БухучетЗарплатыОрганизацийОтношениеКЕНВД");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОтредактированаИстория" И ОрганизацияСсылка = Источник Тогда
		Если Параметр.ИмяРегистра = "БухучетЗарплатыОрганизаций" Тогда
			Если БухучетЗарплатыОрганизацийНаборЗаписейПрочитан Тогда
				РедактированиеПериодическихСведенийКлиент.ОбработкаОповещения(
					ЭтаФорма,
					ОрганизацияСсылка,
					ИмяСобытия,
					Параметр,
					Источник);
				ОбновитьПолеСведенияОБухучетеПериод(ЭтаФорма, ОбщегоНазначенияКлиент.ДатаСеанса());
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
Процедура ОбработкаЗаписиНового(НовыйОбъект, Источник, СтандартнаяОбработка)
	МестоВыплатыЗарплатыОрганизации.МестоВыплаты = НовыйОбъект;
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	РедактированиеПериодическихСведений.ПроверитьЗаписьВФорме(ЭтаФорма, "БухучетЗарплатыОрганизаций", ОрганизацияСсылка, Отказ);
	ВзаиморасчетыССотрудникамиРасширенный.ПроверитьМестоВыплатыЗарплатыОрганизации(ДанныеФормыВЗначение(МестоВыплатыЗарплатыОрганизации, Тип("РегистрСведенийМенеджерЗаписи.МестаВыплатыЗарплатыОрганизаций")), Отказ)
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура БухучетЗарплатыОрганизацийСтатьяФинансированияПриИзменении(Элемент)
	
	ОбновитьПолеСведенияОБухучетеПериод(ЭтаФорма, ОбщегоНазначенияКлиент.ДатаСеанса());
	
КонецПроцедуры

&НаКлиенте
Процедура СпособОтраженияЗарплатыВБухучетеПриИзменении(Элемент)
	
	ОбновитьПолеСведенияОБухучетеПериод(ЭтаФорма, ОбщегоНазначенияКлиент.ДатаСеанса());
	
КонецПроцедуры

&НаКлиенте
Процедура ОтношениеКЕНВДПриИзменении(Элемент)
	
	ОбновитьПолеСведенияОБухучетеПериод(ЭтаФорма, ОбщегоНазначенияКлиент.ДатаСеанса());
	
КонецПроцедуры

&НаКлиенте
Процедура БухучетЗарплатыОрганизацийПериодСтрокойПриИзменении(Элемент)
	
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "БухучетЗарплатыОрганизаций.Период", "БухучетЗарплатыОрганизацийПериодСтрокой", Модифицированность);
	
КонецПроцедуры

&НаКлиенте
Процедура БухучетЗарплатыОрганизацийПериодСтрокойНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(
		ЭтаФорма,
		ЭтаФорма,
		"БухучетЗарплатыОрганизаций.Период",
		"БухучетЗарплатыОрганизацийПериодСтрокой");
	
КонецПроцедуры

&НаКлиенте
Процедура БухучетЗарплатыОрганизацийПериодСтрокойРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "БухучетЗарплатыОрганизаций.Период", "БухучетЗарплатыОрганизацийПериодСтрокой", Направление, Модифицированность);
	
КонецПроцедуры

&НаКлиенте
Процедура БухучетЗарплатыОрганизацийПериодСтрокойАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура БухучетЗарплатыОрганизацийПериодСтрокойОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

#Область МестаВыплатыЗарплаты

&НаКлиенте
Процедура ВидМестаВыплатыЗарплатыПриИзменении(Элемент)
	УстановитьДоступностьМестВыплатыЗарплаты(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура МестоВыплатыКассаПолеОткрытие(Элемент, СтандартнаяОбработка)
	МестаВыплатыЗарплатыКлиентРасширенный.МестоВыплатыОткрытие(Элемент, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура МестоВыплатыЗарплатныйПроектПолеОткрытие(Элемент, СтандартнаяОбработка)
	МестаВыплатыЗарплатыКлиентРасширенный.МестоВыплатыОткрытие(Элемент, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура БухучетЗарплатыОрганизацийИстория(Команда)
	
	РедактированиеПериодическихСведенийКлиент.ОткрытьИсторию("БухучетЗарплатыОрганизаций", ОрганизацияСсылка, ЭтаФорма, ЭтаФорма.ТолькоПросмотр);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	СохранитьИЗакрытьНаКлиенте();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПрочитатьДанные()
	
	ОрганизацияОбъект = ОрганизацияСсылка.ПолучитьОбъект();
	
	ЗначениеВРеквизитФормы(ОрганизацияОбъект, "Организация");
	
	// Бух учет зарплаты
	
	РедактированиеПериодическихСведений.ПрочитатьЗаписьДляРедактированияВФорме(ЭтаФорма, "БухучетЗарплатыОрганизаций", ОрганизацияСсылка);
	ОбновитьПолеСведенияОБухучетеПериод(ЭтаФорма, ТекущаяДатаСеанса());
	
	// Выплата зарплаты
	
	УстановитьМестоВыплатыОрганизации();
	УстановитьДоступностьМестВыплатыЗарплаты(ЭтаФорма);
	
	НастройкиЗарплатаКадрыРасширеннаяЗначение = РегистрыСведений.НастройкиЗарплатаКадрыРасширенная.СоздатьМенеджерЗаписи();
	НастройкиЗарплатаКадрыРасширеннаяЗначение.Организация = ОрганизацияСсылка;
	НастройкиЗарплатаКадрыРасширеннаяЗначение.Прочитать();
	ЗначениеВРеквизитФормы(НастройкиЗарплатаКадрыРасширеннаяЗначение, "НастройкиЗарплатаКадрыРасширенная");
	ВыплачиватьЗарплатуВПоследнийДеньМесяца = ?(НастройкиЗарплатаКадрыРасширеннаяЗначение.ВыплачиватьЗарплатуВПоследнийДеньМесяца, 1, 0);
	Если НастройкиЗарплатаКадрыРасширенная.ДатаВыплатыАвансаНеПозжеЧем = 0 Тогда
		НастройкиЗарплатаКадрыРасширенная.ДатаВыплатыАвансаНеПозжеЧем = 20;
	КонецЕсли;
	Если НастройкиЗарплатаКадрыРасширенная.ДатаВыплатыЗарплатыНеПозжеЧем = 0 Тогда
		НастройкиЗарплатаКадрыРасширенная.ДатаВыплатыЗарплатыНеПозжеЧем = 5;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СохранитьДанные(Отказ, ОповещениеЗавершения = Неопределено)

	ЗапроситьРежимИзмененияБухгалтерскогоУчета(БухучетЗарплатыОрганизаций.Период, Отказ, ОповещениеЗавершения);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьДанныеЗавершение(Отказ, ОповещениеЗавершения) 

	Если Не Отказ Тогда
		СохранитьДанныеНаСервере(Отказ);
	КонецЕсли;
	
	Если ОповещениеЗавершения <> Неопределено Тогда 
		ВыполнитьОбработкуОповещения(ОповещениеЗавершения, Отказ);
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура СохранитьДанныеНаСервере(Отказ)
	
	Если ПроверитьЗаполнение() Тогда
		
		РедактированиеПериодическихСведений.ЗаписатьЗаписьПослеРедактированияВФорме(ЭтаФорма, "БухучетЗарплатыОрганизаций", ОрганизацияСсылка);
		
		НастройкиЗарплатаКадрыРасширеннаяЗначение = РеквизитФормыВЗначение("НастройкиЗарплатаКадрыРасширенная");
		НастройкиЗарплатаКадрыРасширеннаяЗначение.Организация = ОрганизацияСсылка;
		НастройкиЗарплатаКадрыРасширеннаяЗначение.Записать();
		
		ВзаиморасчетыССотрудникамиРасширенный.ЗаписатьМестоВыплатыЗарплаты(ДанныеФормыВЗначение(МестоВыплатыЗарплатыОрганизации, Тип("РегистрСведенийМенеджерЗаписи.МестаВыплатыЗарплатыОрганизаций")));
		
		Модифицированность = Ложь;
		
	Иначе
		Отказ = Истина;
		
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		Модифицированность = Ложь;
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьНаборЗаписейПериодическихСведений(ИмяРегистра, ВедущийОбъект) Экспорт
	
	РедактированиеПериодическихСведений.ПрочитатьНаборЗаписей(ЭтаФорма, ИмяРегистра, ВедущийОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьПолеСведенияОБухучетеПериод(Форма, ДатаСеанса)
	
	// Не обязательно заполнение поля Период если данные по умолчанию и при этом 
	// записи о бухучете еще нет.
	Если ЗарплатаКадрыКлиентСервер.СведенияОБухучетеСотрудникаПоУмолчанию(Форма.БухучетЗарплатыОрганизаций) И 
		НЕ ЗначениеЗаполнено(Форма.БухучетЗарплатыОрганизацийПрежняя.Период) Тогда
		Если ЗначениеЗаполнено(Форма.БухучетЗарплатыОрганизаций.Период) Тогда
			Форма.БухучетЗарплатыОрганизаций.Период = '00010101';
		КонецЕсли; 
	Иначе
		Если НЕ ЗначениеЗаполнено(Форма.БухучетЗарплатыОрганизаций.Период) Тогда
			Форма.БухучетЗарплатыОрганизаций.Период = НачалоМесяца(ДатаСеанса);
		КонецЕсли;
	КонецЕсли;
	
	РедактированиеПериодическихСведенийКлиентСервер.ОбновитьОтображениеПолейВвода(Форма, "БухучетЗарплатыОрганизаций", Форма.ОрганизацияСсылка);
	
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(Форма, "БухучетЗарплатыОрганизаций.Период", "БухучетЗарплатыОрганизацийПериодСтрокой");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапроситьРежимИзмененияБухгалтерскогоУчета(ДатаИзменения, Отказ, ОповещениеЗавершения)
	
	ДополнительныеПараметры = Новый Структура("ОповещениеЗавершения", ОповещениеЗавершения);
	Оповещение = Новый ОписаниеОповещения("ЗапроситьРежимИзмененияБухгалтерскогоУчетаЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ТекстКнопкиДа = НСтр("ru = 'Изменился бухучет'");
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru =  'При редактировании изменился бухгалтерский учет для организации.
					|Если просто исправлены прежние данные (они были ошибочны), нажмите ""Исправлена ошибка"".
					|Если бухучет организации изменился с %1, нажмите ""Изменился бухучет""'"), 
		Формат(ДатаИзменения, "ДФ='д ММММ гггг ""г""'"));
	
	РедактированиеПериодическихСведенийКлиент.ЗапроситьРежимИзмененияРегистра(ЭтаФорма, "БухучетЗарплатыОрганизаций", ТекстВопроса, ТекстКнопкиДа, Отказ, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапроситьРежимИзмененияБухгалтерскогоУчетаЗавершение(Отказ, ДополнительныеПараметры) Экспорт 
	
	СохранитьДанныеЗавершение(Отказ, ДополнительныеПараметры.ОповещениеЗавершения);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИЗакрыть(Результат, ДополнительныеПараметры) Экспорт 
	
	СохранитьИЗакрытьНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИЗакрытьНаКлиенте()  

	Оповещение = Новый ОписаниеОповещения("СохранитьИЗакрытьНаКлиентеЗавершение", ЭтотОбъект);
	СохранитьДанные(Ложь, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИЗакрытьНаКлиентеЗавершение(Отказ, ДополнительныеПараметры) Экспорт 

	Если Не Отказ Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли; 
	
КонецПроцедуры

#Область МестаВыплатыЗарплаты

&НаСервере
Процедура УстановитьМестоВыплатыОрганизации()
	ЗначениеВДанныеФормы(ВзаиморасчетыССотрудникамиРасширенный.МестоВыплатыЗарплатыОрганизации(Организация.Ссылка), МестоВыплатыЗарплатыОрганизации);
КонецПроцедуры

&НаСервере
Процедура НастроитьПоляМестВыплатыЗарплаты()
	
	ОписателиПолейМестВыплаты = Новый Соответствие;
	ОписателиПолейМестВыплаты.Вставить(Элементы.МестоВыплатыКассаПоле,				Перечисления.ВидыМестВыплатыЗарплаты.Касса);
	ОписателиПолейМестВыплаты.Вставить(Элементы.МестоВыплатыЗарплатныйПроектПоле,	Перечисления.ВидыМестВыплатыЗарплаты.ЗарплатныйПроект);
	
	МестаВыплатыЗарплатыФормыРасширенный.НастроитьПоляМестВыплатыЗарплаты(ОписателиПолейМестВыплаты);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьМестВыплатыЗарплаты(Форма)

	Если Форма.МестоВыплатыЗарплатыОрганизации.Вид = ПредопределенноеЗначение("Перечисление.ВидыМестВыплатыЗарплаты.Касса") Тогда
		Форма.Элементы.МестаВыплатыЗарплаты.ТекущаяСтраница = Форма.Элементы.МестоВыплатыКасса;
	Иначе
		Форма.Элементы.МестаВыплатыЗарплаты.ТекущаяСтраница = Форма.Элементы.МестоВыплатыЗарплатныйПроект;
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиЗарплатаКадрыРасширеннаяВыплачиватьЗарплатуВПоследнийДеньМесяцаПриИзменении(Элемент)
	
	УстановитьПорядокВыплатыЗарплаты(ВыплачиватьЗарплатуВПоследнийДеньМесяца);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиЗарплатаКадрыРасширеннаяВыплачиватьЗарплатуНеВПоследнийДеньМесяцаПриИзменении(Элемент)
	
	УстановитьПорядокВыплатыЗарплаты(ВыплачиватьЗарплатуВПоследнийДеньМесяца);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПорядокВыплатыЗарплаты(ПорядокВыплаты)
	
	НастройкиЗарплатаКадрыРасширенная.ВыплачиватьЗарплатуВПоследнийДеньМесяца = (ПорядокВыплаты = 1);
	УстановитьДоступностьНомераДняВыплатыЗарплаты(ЭтаФорма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьНомераДняВыплатыЗарплаты(Форма)
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"ДатаВыплатыЗарплатыНеПозжеЧем",
		"Доступность",
		Не Форма.НастройкиЗарплатаКадрыРасширенная.ВыплачиватьЗарплатуВПоследнийДеньМесяца);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
