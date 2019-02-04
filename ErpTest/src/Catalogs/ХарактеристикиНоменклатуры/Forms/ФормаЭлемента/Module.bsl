
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	// Обработчик механизма "Свойства"
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства	
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ОбменСКонтрагентами.ПриСозданииФормыХарактеристики(ЭтотОбъект);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
	Элементы.ДекорацияПредупреждение.Видимость =  (ТипЗнч(Объект.Владелец) = Тип("СправочникСсылка.ВидыНоменклатуры"));
	
	Если ТипЗнч(Объект.Владелец) = Тип("СправочникСсылка.Номенклатура") Тогда
		ВидНоменклатуры = Объект.Владелец.ВидНоменклатуры;
		Элементы.Владелец.Заголовок = НСтр("ru='Номенклатура'");
	ИначеЕсли ТипЗнч(Объект.Владелец) = Тип("СправочникСсылка.ВидыНоменклатуры") Тогда
		ВидНоменклатуры = Объект.Владелец;
		Элементы.Владелец.Заголовок = НСтр("ru='Вид номенклатуры'");
	КонецЕсли;
	
	РеквизитыВидаНоменклатуры = Новый Структура;
	РеквизитыВидаНоменклатуры.Вставить("ШаблонНаименованияДляПечати","ШаблонНаименованияДляПечатиХарактеристики");
	РеквизитыВидаНоменклатуры.Вставить("ШаблонРабочегоНаименования","ШаблонРабочегоНаименованияХарактеристики");
	РеквизитыВидаНоменклатуры.Вставить("ЗапретРедактированияРабочегоНаименования","ЗапретРедактированияРабочегоНаименованияХарактеристики");
	РеквизитыВидаНоменклатуры.Вставить("ЗапретРедактированияНаименованияДляПечати","ЗапретРедактированияНаименованияДляПечатиХарактеристики");
	РеквизитыВидаНоменклатуры.Вставить("ТипНоменклатуры","ТипНоменклатуры");
	РеквизитыВидаНоменклатуры.Вставить("ОсобенностьУчета","ОсобенностьУчета");
	
	РеквизитыВидаНоменклатуры = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ВидНоменклатуры, РеквизитыВидаНоменклатуры);
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, РеквизитыВидаНоменклатуры);
	
	Элементы.ЗаполнитьНаименованиеДляПечатиПоШаблону.Доступность = ЗначениеЗаполнено(ШаблонНаименованияДляПечати);
	Элементы.ЗаполнитьРабочееНаименованиеПоШаблону.Доступность   = ЗначениеЗаполнено(ШаблонРабочегоНаименования);
	
	Элементы.Наименование.ТолькоПросмотр       = ЗапретРедактированияРабочегоНаименования;
	Элементы.НаименованиеПолное.ТолькоПросмотр = ЗапретРедактированияНаименованияДляПечати;
	
	НастройкиВидимостиПоТипу = ЗначениеНастроекПовтИсп.ВсеРеквизитыХарактеристикНоменклатуры(
									РеквизитыВидаНоменклатуры.ТипНоменклатуры, РеквизитыВидаНоменклатуры.ОсобенностьУчета);
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	Для Каждого НастройкаРеквизита Из НастройкиВидимостиПоТипу Цикл
		Элементы[НастройкаРеквизита.Ключ].Видимость = НастройкаРеквизита.Значение.Использование;
	КонецЦикла;
	
	Если РеквизитыВидаНоменклатуры.ОсобенностьУчета = Перечисления.ОсобенностиУчетаНоменклатуры.ОрганизациейПоАгентскойСхеме Тогда
		ТипСсылкаОрганизации = Новый ОписаниеТипов("СправочникСсылка.Организации");
		Элементы.Принципал.ОграничениеТипа = ТипСсылкаОрганизации;
	КонецЕсли;
	
	Если РеквизитыВидаНоменклатуры.ОсобенностьУчета = Перечисления.ОсобенностиУчетаНоменклатуры.Партнером Тогда
		ТипСсылкаКонтрагенты = Новый ОписаниеТипов("СправочникСсылка.Контрагенты");
		ТипСсылкаПартнеры    = Новый ОписаниеТипов("СправочникСсылка.Партнеры");
		
		Элементы.Принципал.ОграничениеТипа  = ТипСсылкаПартнеры;
		Элементы.Контрагент.ОграничениеТипа = ТипСсылкаКонтрагенты;
	КонецЕсли;
	
	//СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// Обработчик механизма "Свойства"
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры
 
&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	ФормироватьРабочееНаименование = Ложь;
	ФормироватьНаименованиеДляПечати = Ложь;
	
	Если (Не ЗначениеЗаполнено(Объект.Наименование)
		И ЗначениеЗаполнено(ШаблонРабочегоНаименования))
		Или ЗапретРедактированияРабочегоНаименования Тогда
		
		ФормироватьРабочееНаименование = Истина;
		
	КонецЕсли;
	
	Если (Не ЗначениеЗаполнено(Объект.НаименованиеПолное)
		И ЗначениеЗаполнено(ШаблонНаименованияДляПечати))
		Или ЗапретРедактированияНаименованияДляПечати Тогда
		
		ФормироватьНаименованиеДляПечати = Истина;
		
	КонецЕсли;
	
	Если ФормироватьРабочееНаименование
		И ФормироватьНаименованиеДляПечати Тогда
		
		ЗаполнитьНаименованиеПоШаблонуКлиент("Оба");
		
	ИначеЕсли ФормироватьРабочееНаименование Тогда
		
		ЗаполнитьНаименованиеПоШаблонуКлиент("Рабочее");
		
	ИначеЕсли ФормироватьНаименованиеДляПечати Тогда
		
		ЗаполнитьНаименованиеПоШаблонуКлиент("ДляПечати");
		
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	// Обработчик механизма "Свойства"
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	
	СтруктураРеквизитов = Новый Структура;
	СтруктураРеквизитов.Вставить("ШаблонРабочегоНаименованияХарактеристики");
	СтруктураРеквизитов.Вставить("ЗапретРедактированияРабочегоНаименованияХарактеристики");
	СтруктураРеквизитов.Вставить("ШаблонНаименованияДляПечатиХарактеристики");
	СтруктураРеквизитов.Вставить("ЗапретРедактированияНаименованияДляПечатиХарактеристики");
	
	РеквизитыОбъекта = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ВидНоменклатуры, СтруктураРеквизитов);
	
	ТекущийОбъект.ДополнительныеСвойства.Вставить("РабочееНаименованиеСформировано");
	ТекущийОбъект.ДополнительныеСвойства.Вставить("НаименованиеДляПечатиСформировано");
	
	Если Не ЗначениеЗаполнено(ТекущийОбъект.Наименование) Тогда
		ТекстСообщения = НСтр("ru='Поле ""Рабочее наименование"" не заполнено'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Наименование", "Объект"); 
		Отказ = Истина;
	КонецЕсли;
	
	КонтролироватьУникальностьРабочегоНаименования = Константы.КонтролироватьУникальностьРабочегоНаименованияНоменклатурыИХарактеристик.Получить();
	
	Если КонтролироватьУникальностьРабочегоНаименования
		И Не Отказ Тогда
		
		НаименованиеУникально = Справочники.ХарактеристикиНоменклатуры.РабочееНаименованиеУникально(ТекущийОбъект);
		
		Если Не НаименованиеУникально Тогда
			ТекстСообщения = НСтр("ru='Значение поля ""Рабочее наименование"" не уникально'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Наименование", "Объект"); 
			Отказ = Истина;
		КонецЕсли;
		
		ТекущийОбъект.ДополнительныеСвойства.Вставить("РабочееНаименованиеПроверено", Истина);
	КонецЕсли;

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура  ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПринципалПриИзменении(Элемент)
	ПринципалПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПринципалПриИзмененииНаСервере()
	ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Объект.Принципал, Объект.Контрагент);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьНаименованиеДляПечатиПоШаблону(Команда)
	ЗаполнитьНаименованиеПоШаблонуКлиент("ДляПечати");
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьРабочееНаименованиеПоШаблону(Команда)
	ЗаполнитьНаименованиеПоШаблонуКлиент("Рабочее");
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

#Область Прочее

&НаКлиенте
Процедура ЗаполнитьНаименованиеПоШаблонуКлиент(ВариантФормирования)
	
	#Если ВебКлиент Тогда
		ЗаполнитьНаименованиеПоШаблонуСервер(ВариантФормирования);
		Возврат;
	#КонецЕсли
	
	ФормулыНаименования = ФормулыНаименования();
	
	Если ВариантФормирования = "Рабочее" Тогда
		Объект.Наименование = НоменклатураКлиент.НаименованиеПоФормуле(
								ФормулыНаименования.ФормулаРабочегоНаименования,
								ВидНоменклатуры);
	ИначеЕсли ВариантФормирования = "ДляПечати" Тогда 
		Объект.НаименованиеПолное = НоменклатураКлиент.НаименованиеПоФормуле(
								ФормулыНаименования.ФормулаНаименованияДляПечати,
								ВидНоменклатуры,
								Объект.Наименование);
	ИначеЕсли ВариантФормирования = "Оба" Тогда
		Объект.Наименование = НоменклатураКлиент.НаименованиеПоФормуле(
								ФормулыНаименования.ФормулаРабочегоНаименования,
								ВидНоменклатуры);
		Объект.НаименованиеПолное = НоменклатураКлиент.НаименованиеПоФормуле(
								ФормулыНаименования.ФормулаНаименованияДляПечати,
								ВидНоменклатуры,
								Объект.Наименование);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаименованиеПоШаблонуСервер(ВариантФормирования)
	
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, Объект);
	
	СправочникОбъект = РеквизитФормыВЗначение("Объект");
	
	Если ВариантФормирования = "Рабочее" ИЛИ ВариантФормирования = "Оба" Тогда
		Объект.Наименование = НоменклатураСервер.НаименованиеПоШаблону(ШаблонРабочегоНаименования, СправочникОбъект);
		СправочникОбъект.Наименование = Объект.Наименование;
	КонецЕсли;
	Если ВариантФормирования = "ДляПечати" ИЛИ ВариантФормирования = "Оба" Тогда
		Объект.НаименованиеПолное = НоменклатураСервер.НаименованиеПоШаблону(ШаблонНаименованияДляПечати, СправочникОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ФормулыНаименования()
	
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, Объект);
	
	СправочникОбъект = РеквизитФормыВЗначение("Объект");
	
	Результат = Новый Структура;
	Результат.Вставить("ФормулаРабочегоНаименования", НоменклатураСервер.ФормулаНаименования(ШаблонРабочегоНаименования, СправочникОбъект)); 
	Результат.Вставить("ФормулаНаименованияДляПечати", НоменклатураСервер.ФормулаНаименования(ШаблонНаименованияДляПечати, СправочникОбъект)); 
	
	Возврат Результат; 
		
КонецФункции

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
