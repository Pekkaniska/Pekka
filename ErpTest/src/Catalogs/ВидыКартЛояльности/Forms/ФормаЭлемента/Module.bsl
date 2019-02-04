
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	// Обработчик подсистемы "Свойства"
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
	
	// подсистема запрета редактирования ключевых реквизитов объектов	
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	
	ТипКартыПриИзмененииНаСервере();
	
	ЗначениеКопирования = Параметры.ЗначениеКопирования;
	СкидкиНаценкиСервер.ПриСозданииНаСервереИсточниковДействияСкидок(ЭтотОбъект,
	                                                                ?(ЗначениеКопирования.Пустая(), Объект.Ссылка, ЗначениеКопирования));
	
	Если Объект.Персонализирована Тогда
		ТипПерсонализации = "Персонализированная";
	Иначе
		ТипПерсонализации = "Обезличенная";
	КонецЕсли;
	
	Если Объект.АвтоматическаяРегистрацияПриПервомСчитывании Тогда
		ПорядокАктивации = "ПриПервомСчитывании";
	Иначе
		ПорядокАктивации = "СПомощьюПомощника";
	КонецЕсли;
	
	Элементы.ПорядокАктивации.Доступность = НЕ Объект.ТипКарты = Перечисления.ТипыКарт.Смешанная;
	Элементы.ГруппаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	
	Элементы.БонуснаяПрограммаЛояльности.Видимость = Объект.Персонализирована;
	Элементы.УстановитьСтатусДействует.Видимость = ПравоДоступа("Изменение", Метаданные.Справочники.СкидкиНаценки);
	Элементы.УстановитьСтатусНеДействует.Видимость = ПравоДоступа("Изменение", Метаданные.Справочники.СкидкиНаценки);
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	СформироватьОписаниеНастроек();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	// Подсистема "Свойства"
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_ДействиеСкидокНаценок" И Параметр.Источник.Найти(Объект.Ссылка) <> Неопределено Тогда
		ОбновитьДеревоСкидок();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Обработчик подсистемы "Свойства"
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// Обработчик подсистемы "Свойства"
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// подсистема запрета редактирования ключевых реквизитов объектов	
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	Элементы.ГруппаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Элементы.ГруппаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

КонецПроцедуры

&НаКлиенте
Процедура  ПослеЗаписи(ПараметрыЗаписи)

	Оповестить("Запись_ВидКартыЛояльности", ПараметрыЗаписи, Объект.Ссылка);
	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	СкидкиНаценкиСервер.ПриЗаписиНаСервереИсточниковДействияСкидокНаценок(ТекущийОбъект, ЗначениеКопирования);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипКартыПриИзменении(Элемент)
	
	ТипКартыПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ТипКартыОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ТипПерсонализацииПриИзменении(Элемент)
	
	Объект.Персонализирована = ТипПерсонализации = "Персонализированная";
	Элементы.БонуснаяПрограммаЛояльности.Видимость = Объект.Персонализирована;
	СформироватьОписаниеНастроек();
	
КонецПроцедуры

&НаКлиенте
Процедура ПорядокАктивацииПриИзменении(Элемент)
	
	Объект.АвтоматическаяРегистрацияПриПервомСчитывании = ПорядокАктивации = "ПриПервомСчитывании";
	СформироватьОписаниеНастроек();
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ВыбранноеЗначение = ПредопределенноеЗначение("Перечисление.СтатусыВидовКартЛояльности.Закрыт") Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ПоказатьВопрос(Новый ОписаниеОповещения("СтатусОбработкаВыбораЗавершение", ЭтотОбъект,
			Новый Структура("ВыбранноеЗначение", ВыбранноеЗначение)), 
			НСтр("ru = 'Действующие карты лояльности будут аннулированы, продолжить?'"), РежимДиалогаВопрос.ДаНет);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусОбработкаВыбораЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	ВыбранноеЗначение = ДополнительныеПараметры.ВыбранноеЗначение;
	
	Ответ = РезультатВопроса;
	Если Ответ = КодВозвратаДиалога.Да Тогда
		Объект.Статус = ВыбранноеЗначение;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВариантОтображенияСкидокПриИзменении(Элемент)
	
	ОбновитьДеревоСкидок();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаСрезаПриИзменении(Элемент)
	
	ОбновитьДеревоСкидок();
	
КонецПроцедуры

&НаКлиенте
Процедура ИнформацияОДействииСкидокОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если НавигационнаяСсылка = "НастроитьСкидки" Тогда
			
			ОткрытьФорму("Справочник.СкидкиНаценки.ФормаСписка", ,ЭтотОбъект);
			
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТабличнойЧастиСкидкиНаценки

&НаКлиенте
Процедура СкидкиНаценкиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Элементы.СкидкиНаценки.ТекущиеДанные.Ссылка) Тогда
		ПоказатьЗначение(Неопределено, Элементы.СкидкиНаценки.ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СкидкиНаценкиПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("Подключаемый_СписокПриАктивизацииСтроки", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СкидкиНаценкиПередРазворачиванием(Элемент, Строка, Отказ)
	
	СкидкиНаценкиКлиент.СохранитьПризнакРазвернутостиУзлаДереваВСписке(Строка, Элементы.СкидкиНаценки, РазвернутыеУзлыДерева, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СкидкиНаценкиПередСворачиванием(Элемент, Строка, Отказ)
	
	СкидкиНаценкиКлиент.СохранитьПризнакРазвернутостиУзлаДереваВСписке(Строка, Элементы.СкидкиНаценки, РазвернутыеУзлыДерева, Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПроверитьПересеченияДиапазонов(Команда)
	
	ОчиститьСообщения();
	ПроверитьПересечениеДиапазоновНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИнтервал(Команда)
	
	ОбщегоНазначенияУТКлиент.РедактироватьПериод(Объект, 
		Новый Структура("ДатаНачала, ДатаОкончания", "ДатаНачалаДействия", "ДатаОкончанияДействия"));
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	ОбщегоНазначенияУТКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияДействияСкидкиНаценки(Команда)
	
	СкидкиНаценкиКлиент.ОткрытьФормуИсторииИзмененияСтатуса(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусДействует(Команда)
	
	СкидкиНаценкиКлиент.ОткрытьФормуУстановкиСтатуса(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.СтатусыДействияСкидок.Действует"),
		Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусНеДействует(Команда)
	
	СкидкиНаценкиКлиент.ОткрытьФормуУстановкиСтатуса(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.СтатусыДействияСкидок.НеДействует"),
		Объект.Ссылка);
	
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

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();
	
	СкидкиНаценкиСервер.УстановитьУсловноеОформлениеФормыИсточникаДействияСкидок(УсловноеОформление, Элементы);

КонецПроцедуры

#Область ПриИзмененииРеквизитов

&НаСервере
Процедура ТипКартыПриИзмененииНаСервере()
	
	Элементы.ШаблоныКодовКартЛояльностиДлинаМагнитногоКода.Видимость = Объект.ТипКарты = Перечисления.ТипыКарт.Магнитная ИЛИ Объект.ТипКарты = Перечисления.ТипыКарт.Смешанная;
	Элементы.ШаблоныКодовКартЛояльностиНачалоДиапазонаМагнитногоКода.Видимость = Объект.ТипКарты = Перечисления.ТипыКарт.Магнитная ИЛИ Объект.ТипКарты = Перечисления.ТипыКарт.Смешанная;
	Элементы.ШаблоныКодовКартЛояльностиКонецДиапазонаМагнитногоКода.Видимость = Объект.ТипКарты = Перечисления.ТипыКарт.Магнитная ИЛИ Объект.ТипКарты = Перечисления.ТипыКарт.Смешанная;
	Элементы.ШаблоныКодовКартЛояльностиШаблонКодаМагнитнойКарты.Видимость = Объект.ТипКарты = Перечисления.ТипыКарт.Магнитная ИЛИ Объект.ТипКарты = Перечисления.ТипыКарт.Смешанная;
	
	Элементы.ШаблоныКодовКартЛояльностиДлинаШтрихкода.Видимость = Объект.ТипКарты = Перечисления.ТипыКарт.Штриховая ИЛИ Объект.ТипКарты = Перечисления.ТипыКарт.Смешанная;
	Элементы.ШаблоныКодовКартЛояльностиНачалоДиапазонаШтрихкода.Видимость = Объект.ТипКарты = Перечисления.ТипыКарт.Штриховая ИЛИ Объект.ТипКарты = Перечисления.ТипыКарт.Смешанная;
	Элементы.ШаблоныКодовКартЛояльностиКонецДиапазонаШтрихкода.Видимость = Объект.ТипКарты = Перечисления.ТипыКарт.Штриховая ИЛИ Объект.ТипКарты = Перечисления.ТипыКарт.Смешанная;
	
	Элементы.ПорядокАктивации.Доступность = НЕ Объект.ТипКарты = Перечисления.ТипыКарт.Смешанная;
	Если Объект.ТипКарты = Перечисления.ТипыКарт.Смешанная Тогда
		Объект.АвтоматическаяРегистрацияПриПервомСчитывании = Ложь;
		ПорядокАктивации = "СПомощьюПомощника";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыПодсистемыСвойств

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ПостроитьДеревоСкидкиНаценки()
	
	СкидкиНаценкиСервер.ПостроитьДеревоСкидкиНаценкиВФорме(
	                                            ЭтотОбъект,
	                                            ?(ЗначениеКопирования.Пустая(),Объект.Ссылка, ЗначениеКопирования));
	ИнформацияОКоличествеСкидок = СкидкиНаценкиСервер.ИнформацияОКоличествеСкидок(
	                                            ?(ЗначениеКопирования.Пустая(),Объект.Ссылка, ЗначениеКопирования),
	                                            ДатаСреза);
	ОбновитьИспользованиеСкидокНаценок(АктивизированнаяСкидкаНаценка);
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьПересечениеДиапазоновНаСервере()
	
	Для Каждого СтрокаТЧ Из Объект.ШаблоныКодовКартЛояльности Цикл
		
		Запрос = Новый Запрос(
		"
		|ВЫБРАТЬ
		|	ЗНАЧЕНИЕ(Перечисление.ТипыКодовКарт.Штрихкод) КАК ТипКода,
		|	ШаблоныКодовКартЛояльности.Ссылка КАК ВидКарты,
		|	ШаблоныКодовКартЛояльности.НомерСтроки КАК НомерСтроки,
		|	ШаблоныКодовКартЛояльности.ДлинаКода КАК ДлинаКода,
		|	ШаблоныКодовКартЛояльности.НачалоДиапазона КАК НачалоДиапазона,
		|	ШаблоныКодовКартЛояльности.КонецДиапазона КАК КонецДиапазона
		|ИЗ
		|	(ВЫБРАТЬ
		|		ШаблоныКодовКартЛояльности.Ссылка КАК Ссылка,
		|		ШаблоныКодовКартЛояльности.НомерСтроки КАК НомерСтроки,
		|		ШаблоныКодовКартЛояльности.ДлинаШтрихкода КАК ДлинаКода,
		|		ШаблоныКодовКартЛояльности.НачалоДиапазонаШтрихкода КАК НачалоДиапазона,
		|		ШаблоныКодовКартЛояльности.КонецДиапазонаШтрихкода КАК КонецДиапазона
		|	ИЗ
		|		Справочник.ВидыКартЛояльности.ШаблоныКодовКартЛояльности КАК ШаблоныКодовКартЛояльности
		|	ГДЕ
		|		&ПроверятьШтрихкоды
		|	) КАК ШаблоныКодовКартЛояльности
		|ГДЕ
		|	ШаблоныКодовКартЛояльности.ДлинаКода = &ДлинаШтрихкода
		|	И ВЫБОР
		|			КОГДА ШаблоныКодовКартЛояльности.Ссылка = &ВидКарты
		|					И ШаблоныКодовКартЛояльности.НомерСтроки = &НомерСтроки
		|				ТОГДА ЛОЖЬ
		|			ИНАЧЕ ИСТИНА
		|		КОНЕЦ
		|	И ВЫБОР
		|			КОГДА ШаблоныКодовКартЛояльности.НачалоДиапазона < &НачалоДиапазонаШтрихкода
		|					И ШаблоныКодовКартЛояльности.КонецДиапазона < &НачалоДиапазонаШтрихкода
		|				ТОГДА ЛОЖЬ
		|			ИНАЧЕ ВЫБОР
		|					КОГДА ШаблоныКодовКартЛояльности.НачалоДиапазона > &КонецДиапазонаШтрихкода
		|							И ШаблоныКодовКартЛояльности.КонецДиапазона > &КонецДиапазонаШтрихкода
		|						ТОГДА ЛОЖЬ
		|					ИНАЧЕ ИСТИНА
		|				КОНЕЦ
		|		КОНЕЦ
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ЗНАЧЕНИЕ(Перечисление.ТипыКодовКарт.МагнитныйКод) КАК ТипКода,
		|	ШаблоныКодовКартЛояльности.Ссылка КАК ВидКарты,
		|	ШаблоныКодовКартЛояльности.НомерСтроки КАК НомерСтроки,
		|	ШаблоныКодовКартЛояльности.ДлинаКода КАК ДлинаКода,
		|	ШаблоныКодовКартЛояльности.НачалоДиапазона КАК НачалоДиапазона,
		|	ШаблоныКодовКартЛояльности.КонецДиапазона КАК КонецДиапазона
		|ИЗ
		|	(ВЫБРАТЬ
		|		ШаблоныКодовКартЛояльности.Ссылка КАК Ссылка,
		|		ШаблоныКодовКартЛояльности.НомерСтроки КАК НомерСтроки,
		|		ШаблоныКодовКартЛояльности.ДлинаМагнитногоКода КАК ДлинаКода,
		|		ШаблоныКодовКартЛояльности.НачалоДиапазонаМагнитногоКода КАК НачалоДиапазона,
		|		ШаблоныКодовКартЛояльности.КонецДиапазонаМагнитногоКода КАК КонецДиапазона
		|	ИЗ
		|		Справочник.ВидыКартЛояльности.ШаблоныКодовКартЛояльности КАК ШаблоныКодовКартЛояльности
		|	ГДЕ
		|		&ПроверятьМагнитныеКоды
		|	) КАК ШаблоныКодовКартЛояльности
		|ГДЕ
		|	ШаблоныКодовКартЛояльности.ДлинаКода = &ДлинаМагнитногоКода
		|	И ВЫБОР
		|			КОГДА ШаблоныКодовКартЛояльности.Ссылка = &ВидКарты
		|					И ШаблоныКодовКартЛояльности.НомерСтроки = &НомерСтроки
		|				ТОГДА ЛОЖЬ
		|			ИНАЧЕ ИСТИНА
		|		КОНЕЦ
		|	И ВЫБОР
		|			КОГДА ШаблоныКодовКартЛояльности.НачалоДиапазона < &НачалоДиапазонаМагнитногоКода
		|					И ШаблоныКодовКартЛояльности.КонецДиапазона < &НачалоДиапазонаМагнитногоКода
		|				ТОГДА ЛОЖЬ
		|			ИНАЧЕ ВЫБОР
		|					КОГДА ШаблоныКодовКартЛояльности.НачалоДиапазона > &КонецДиапазонаМагнитногоКода
		|							И ШаблоныКодовКартЛояльности.КонецДиапазона > &КонецДиапазонаМагнитногоКода
		|						ТОГДА ЛОЖЬ
		|					ИНАЧЕ ИСТИНА
		|				КОНЕЦ
		|		КОНЕЦ
		
		|");
		
		Запрос.УстановитьПараметр("ДлинаМагнитногоКода"          , СтрокаТЧ.ДлинаМагнитногоКода);
		Запрос.УстановитьПараметр("НачалоДиапазонаМагнитногоКода", СтрокаТЧ.НачалоДиапазонаМагнитногоКода);
		Запрос.УстановитьПараметр("КонецДиапазонаМагнитногоКода" , СтрокаТЧ.КонецДиапазонаМагнитногоКода);
		
		Запрос.УстановитьПараметр("ДлинаШтрихкода"          , СтрокаТЧ.ДлинаШтрихкода);
		Запрос.УстановитьПараметр("НачалоДиапазонаШтрихкода", СтрокаТЧ.НачалоДиапазонаШтрихкода);
		Запрос.УстановитьПараметр("КонецДиапазонаШтрихкода" , СтрокаТЧ.КонецДиапазонаШтрихкода);
		
		Запрос.УстановитьПараметр("ПроверятьШтрихкоды" ,    Объект.ТипКарты = Перечисления.ТипыКарт.Штриховая ИЛИ Объект.ТипКарты = Перечисления.ТипыКарт.Смешанная);
		Запрос.УстановитьПараметр("ПроверятьМагнитныеКоды", Объект.ТипКарты = Перечисления.ТипыКарт.Магнитная ИЛИ Объект.ТипКарты = Перечисления.ТипыКарт.Смешанная);
		
		Запрос.УстановитьПараметр("НомерСтроки" ,    СтрокаТЧ.НомерСтроки);
		Запрос.УстановитьПараметр("ВидКарты" ,       Объект.Ссылка);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			
			Если Выборка.ТипКода = Перечисления.ТипыКодовКарт.МагнитныйКод Тогда
				
				Если Выборка.ВидКарты <> Объект.Ссылка Тогда
					ТекстСообщения = НСтр("ru = 'Диапазон магнитных кодов %2 - %3 в строке %1 пересекается с диапазоном магнитных кодов карт ""%5"" %6 - %7 в строке %4'");
				Иначе
					Если Выборка.НомерСтроки > СтрокаТЧ.НомерСтроки Тогда
						Продолжить;
					КонецЕсли;
					ТекстСообщения = НСтр("ru = 'Диапазон магнитных кодов %2 - %3 в строке %1 пересекается с диапазоном магнитных кодов %6 - %7 в строке %4'");
				КонецЕсли;
				
				ТекстШаблона = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ТекстСообщения,
					СтрокаТЧ.НомерСтроки,                   //%1
					СтрокаТЧ.НачалоДиапазонаМагнитногоКода, //%2
					СтрокаТЧ.КонецДиапазонаМагнитногоКода,  //%3
					Выборка.НомерСтроки,                    //%4
					Выборка.ВидКарты,                       //%5
					Выборка.НачалоДиапазона,                //%6
					Выборка.КонецДиапазона); //%7
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстШаблона, Объект.Ссылка, ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Объект.ШаблоныКодовКартЛояльности", СтрокаТЧ.НомерСтроки, "НачалоДиапазонаМагнитногоКода"));
				
			Иначе
				
				Если Выборка.ВидКарты <> Объект.Ссылка Тогда
					ТекстСообщения = НСтр("ru = 'Диапазон штрихкодов %2 - %3 в строке %1 пересекается с диапазоном штрихкодов карт ""%5"" %6 - %7 в строке %4'");
				Иначе
					Если Выборка.НомерСтроки > СтрокаТЧ.НомерСтроки Тогда
						Продолжить;
					КонецЕсли;
					ТекстСообщения = НСтр("ru = 'Диапазон штрихкодов %2 - %3 в строке %1 пересекается с диапазоном штрихкодов %6 - %7 в строке %4'");
				КонецЕсли;
				
				ТекстШаблона = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ТекстСообщения,
					СтрокаТЧ.НомерСтроки,                   //%1
					СтрокаТЧ.НачалоДиапазонаШтрихкода,      //%2
					СтрокаТЧ.КонецДиапазонаШтрихкода,       //%3
					Выборка.НомерСтроки,                    //%4
					Выборка.ВидКарты,                       //%5
					Выборка.НачалоДиапазона,                //%6
					Выборка.КонецДиапазона); //%7
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстШаблона, Объект.Ссылка, ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Объект.ШаблоныКодовКартЛояльности", СтрокаТЧ.НомерСтроки, "НачалоДиапазонаШтрихкода"));
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьОписаниеНастроек()
	
	Если Объект.Персонализирована И Объект.АвтоматическаяРегистрацияПриПервомСчитывании Тогда
		ОписаниеНастроек = НСтр("ru = 'Карты данного вида могут быть накопительными
		                              |и активируются при первом считывании в документе продажи или с помощью помощника регистрации'");
	ИначеЕсли Объект.Персонализирована И НЕ Объект.АвтоматическаяРегистрацияПриПервомСчитывании Тогда
		ОписаниеНастроек = НСтр("ru = 'Карты данного вида могут быть накопительными
		                              |и активируются с помощью помощника регистрации карт лояльности.'");
	ИначеЕсли Не Объект.Персонализирована И Объект.АвтоматическаяРегистрацияПриПервомСчитывании Тогда
		ОписаниеНастроек = НСтр("ru = 'Карты данного вида не могут быть накопительными
		                              |и активируются при первом считывании в документе продажи или с помощью помощника регистрации'");
	ИначеЕсли Не Объект.Персонализирована И Не Объект.АвтоматическаяРегистрацияПриПервомСчитывании Тогда
		ОписаниеНастроек = НСтр("ru = 'Карты данного вида не могут быть накопительными
		                              |и активируются с помощью помощника регистрации карт лояльности.'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СписокПриАктивизацииСтроки()
	
	ТекущиеДанные = Элементы.СкидкиНаценки.ТекущиеДанные;
	СкидкаНаценка = ?(ТекущиеДанные = Неопределено ИЛИ ТекущиеДанные.ЭтоГруппа, Неопределено, ТекущиеДанные.Ссылка);
	
	Если СкидкаНаценка <> АктивизированнаяСкидкаНаценка Тогда
		ОбновитьИспользованиеСкидокНаценок(СкидкаНаценка);
		АктивизированнаяСкидкаНаценка = ?(ТекущиеДанные = Неопределено, Неопределено, ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьИспользованиеСкидокНаценок(СкидкаНаценка)
	
	ИспользованиеСкидкиНаценки = СкидкиНаценкиСервер.ИспользованиеСкидкиНаценки(СкидкаНаценка, ДатаСреза);
	СкидкиНаценкиСервер.СформироватьИнформационнуюНадписьИспользованиеСкидокНаценок(ИнформацияОДействииСкидок,
	                                                                                ИспользованиеСкидкиНаценки,
	                                                                                "НастроитьСкидки");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДеревоСкидок()
	
	ПостроитьДеревоСкидкиНаценки();
	СкидкиНаценкиКлиент.РазвернутьДеревоСкидокРекурсивно(СкидкиНаценки, Элементы.СкидкиНаценки, РазвернутыеУзлыДерева);
	СкидкиНаценкиКлиент.ПозиционироватьсяНаЗначениеВДереве(АктивизированнаяСкидкаНаценка, СкидкиНаценки, Элементы.СкидкиНаценки, "Ссылка");
	
КонецПроцедуры 

#КонецОбласти

#КонецОбласти

