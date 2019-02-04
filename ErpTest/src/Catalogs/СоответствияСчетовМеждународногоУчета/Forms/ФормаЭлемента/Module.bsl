
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Если Параметры.Свойство("УчетнаяПолитика") Тогда
		УчетнаяПолитика = Параметры.УчетнаяПолитика;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		НастройкаКомпоновки = Неопределено;
		Если Не Параметры.ЗначениеКопирования.Пустая() Тогда
			ДополнительныйОтбор = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.ЗначениеКопирования, "ДополнительныйОтбор");
			НастройкаКомпоновки = ДополнительныйОтбор.Получить();
		КонецЕсли;
		ИнициализироватьКомпоновщикНастроекСервер(НастройкаКомпоновки);
	КонецЕсли;
	
	ПроверитьИспользованиеВПравилахОтраженияВМеждународномУчете();
	УстановитьУсловноеОформление();
	
	Для каждого СтрокаНастройки Из Объект.НастройкиЗаполненияСубконто Цикл
		ПроверитьВыражение(СтрокаНастройки, КомпоновщикНастроек);
	КонецЦикла;
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ДополнительныйОтбор = ТекущийОбъект.ДополнительныйОтбор.Получить();
	ИнициализироватьКомпоновщикНастроекСервер(ДополнительныйОтбор);
	
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	НастройкиКомпоновщика = КомпоновщикНастроек.ПолучитьНастройки(); 
	
	ТекущийОбъект.ДополнительныйОтбор = Новый ХранилищеЗначения(НастройкиКомпоновщика);
	ТекущийОбъект.ПредставлениеОтбора = Строка(НастройкиКомпоновщика.Отбор);
	ТекущийОбъект.УстановленДополнительныйОтбор = (НастройкиКомпоновщика.Отбор.Элементы.Количество() > 0);
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Если ЗначениеЗаполнено(УчетнаяПолитика) Тогда
		РегистрыСведений.ПравилаОтраженияВМеждународномУчете.ВключитьВУчетнуюПолитику(УчетнаяПолитика, ТекущийОбъект.Ссылка);
		ПроверитьИспользованиеВПравилахОтраженияВМеждународномУчете();
	КонецЕсли;
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзмененыНастройкиИспользованияВУчетнойПолитике" Тогда
	    ПроверитьИспользованиеВПравилахОтраженияВМеждународномУчете();   
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("ЗаписьСоответствияСчетов", Объект.Ссылка);
	
	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СчетРеглУчетаПриИзменении(Элемент)
	
	СчетРеглУчетаПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура СчетМеждународногоУчетаПриИзменении(Элемент)
	
	ОбновитьСписокСубконтоМеждународногоУчета();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнениеСубконтоВыражениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.ЗаполнениеСубконто.ТекущиеДанные;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВидСубконто", ТекущиеДанные.ВидСубконто);
	ПараметрыФормы.Вставить("АдресСхемыКомпоновкиДанных", АдресСхемыКомпоновкиДанных);
	ПараметрыФормы.Вставить("ТекущееВыражение", ТекущиеДанные.Выражение);
	
	ОткрытьФорму("ОбщаяФорма.ВыборПоляЗаполненияСубконто", ПараметрыФормы, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнениеСубконтоВыражениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элементы.ЗаполнениеСубконто.ТекущиеДанные;
	ТекущиеДанные.Выражение = ВыбранноеЗначение;
	Модифицированность = Истина;
	ПроверитьВыражение(ТекущиеДанные, КомпоновщикНастроек);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнениеСубконтоПредставлениеВыраженияОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийКомандФормы

&НаКлиенте
Процедура НастроитьИспользованиеВУчетнойПолитике(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаОтветаНаВопросОЗаписиОбъекта", ЭтотОбъект);
		ТекстВопроса = НСтр("ru='Для настройки использования в учетной политики необходимо записать объект. Записать?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Возврат;
	КонецЕсли;
	
	ОткрытьФормуНастройкиИспользованияВУчетнойПолитике();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	// 
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ЭлементУсловногоОформления.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.Использование = Истина;
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.НастройкиЗаполненияСубконто.ЗаполнятьИзИсточника");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Истина;
	
	Оформление = ЭлементУсловногоОформления.Оформление.Элементы.Найти("Видимость");
	Оформление.Использование = Истина;
	Оформление.Значение = Ложь;
	
	ОформляемоеПоле = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ОформляемоеПоле.Использование = Истина;
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("ЗаполнениеСубконтоУказанноеЗначение");
	
	// 
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ЭлементУсловногоОформления.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.Использование = Истина;
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.НастройкиЗаполненияСубконто.ЗаполнятьИзИсточника");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Ложь;
	
	Оформление = ЭлементУсловногоОформления.Оформление.Элементы.Найти("Видимость");
	Оформление.Использование = Истина;
	Оформление.Значение = Ложь;
	
	ОформляемоеПоле = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ОформляемоеПоле.Использование = Истина;
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("ЗаполнениеСубконтоПредставлениеВыражения");
	
	ОформляемоеПоле = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ОформляемоеПоле.Использование = Истина;
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("ЗаполнениеСубконтоНетВДоступныхПолях");
	
	// 
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ЭлементУсловногоОформления.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.Использование = Истина;
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.НастройкиЗаполненияСубконто.ЗаполнятьИзИсточника");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Ложь;
	
	Оформление = ЭлементУсловногоОформления.Оформление.Элементы.Найти("Текст");
	Оформление.Использование = Истина;
	Оформление.Значение = НСтр("ru = 'Указанное значение'");
	
	ОформляемоеПоле = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ОформляемоеПоле.Использование = Истина;
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("ЗаполнениеСубконтоЗаполнятьИзИсточника");
	
	// 
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ЭлементУсловногоОформления.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.Использование = Истина;
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.НастройкиЗаполненияСубконто.ЗаполнятьИзИсточника");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Истина;
	
	Оформление = ЭлементУсловногоОформления.Оформление.Элементы.Найти("Текст");
	Оформление.Использование = Истина;
	Оформление.Значение = НСтр("ru = 'Из регл. учета'");
	
	ОформляемоеПоле = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ОформляемоеПоле.Использование = Истина;
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("ЗаполнениеСубконтоЗаполнятьИзИсточника");
	
КонецПроцедуры

&НаСервере
Процедура СчетРеглУчетаПриИзмененииСервер()
	
	ИнициализироватьКомпоновщикНастроекСервер();
	ОбновитьНастройкиЗаполненияСубконтоПоРеглУчету();
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьКомпоновщикНастроекСервер(НастройкаКомпоновки = Неопределено)
	
	СхемаКомпоновкиДанных = 
		Справочники.СоответствияСчетовМеждународногоУчета.СхемыКомпоновкиДанных(Объект.СчетРеглУчета);
	АдресСхемыКомпоновкиДанных = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, УникальныйИдентификатор);
	
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемыКомпоновкиДанных));
	Если НастройкаКомпоновки <> Неопределено Тогда
		КомпоновщикНастроек.ЗагрузитьНастройки(НастройкаКомпоновки);
	КонецЕсли;
	
	КомпоновщикНастроек.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.ПроверятьДоступность);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокСубконтоМеждународногоУчета()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	МеждународныйВидыСубконто.НомерСтроки КАК НомерСубконто,
	|	МеждународныйВидыСубконто.ВидСубконто КАК ВидСубконто,
	|	МеждународныйВидыСубконто.ВидСубконто.ТипЗначения КАК ОписаниеТипов
	|ИЗ
	|	ПланСчетов.Международный.ВидыСубконто КАК МеждународныйВидыСубконто
	|ГДЕ
	|	МеждународныйВидыСубконто.Ссылка = &СчетМеждународногоУчета";
	Запрос.УстановитьПараметр("СчетМеждународногоУчета", Объект.СчетМеждународногоУчета);
	
	Объект.НастройкиЗаполненияСубконто.Загрузить(Запрос.Выполнить().Выгрузить());
	
	ОбновитьНастройкиЗаполненияСубконтоПоРеглУчету();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьНастройкиЗаполненияСубконтоПоРеглУчету(ПоложениеСубконто = Неопределено)
	
	Для каждого СтрокаСубконто Из Объект.НастройкиЗаполненияСубконто Цикл
		
		Если СтрокаСубконто.ЗаполнятьИзИсточника Тогда
			СтрокаСубконто.Выражение = "";
		КонецЕсли;
		
		Для каждого ДоступноеПолеВыбора Из КомпоновщикНастроек.Настройки.ДоступныеПоляВыбора.Элементы Цикл
			Для каждого Тип Из ДоступноеПолеВыбора.ТипЗначения.Типы() Цикл
				Если СтрокаСубконто.ВидСубконто.ТипЗначения.СодержитТип(Тип) Тогда
					СтрокаСубконто.ЗаполнятьИзИсточника = Истина;
					СтрокаСубконто.Выражение = Строка(ДоступноеПолеВыбора.Поле);
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		
		ПроверитьВыражение(СтрокаСубконто, КомпоновщикНастроек);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьИспользованиеВПравилахОтраженияВМеждународномУчете()

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(ПравилаОтраженияВМеждународномУчете.УчетнаяПолитика) КАК УчетнаяПолитика
	|ИЗ
	|	РегистрСведений.ПравилаОтраженияВМеждународномУчете КАК ПравилаОтраженияВМеждународномУчете
	|ГДЕ
	|	ПравилаОтраженияВМеждународномУчете.ШаблонПроводки = &ШаблонПроводки
	|
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(ПравилаОтраженияВМеждународномУчете.УчетнаяПолитика) > 0";
	
	Запрос.УстановитьПараметр("ШаблонПроводки", Объект.Ссылка);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	ДоступноИзменениеНастроекМФУ = МеждународныйУчетОбщегоНазначения.ДоступноИзменениеНастроекМеждународногоУчета();
	
	Если Выборка.Следующий() Тогда
		СостояниеИспользованияВУчетнойПолитике = " " + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Используется (%1)'"),
			Выборка.УчетнаяПолитика);
		Если ДоступноИзменениеНастроекМФУ Тогда	
			Элементы.НастроитьИспользованиеВУчетнойПолитике.Заголовок = НСтр("ru = 'Изменить'");
		Иначе
			Элементы.НастроитьИспользованиеВУчетнойПолитике.Заголовок = НСтр("ru = 'Посмотреть'");
		КонецЕсли;	
	Иначе	
		СостояниеИспользованияВУчетнойПолитике = " " + НСтр("ru = 'Не используется'");
		Элементы.НастроитьИспользованиеВУчетнойПолитике.Заголовок = НСтр("ru = 'Настроить'");
		Элементы.НастроитьИспользованиеВУчетнойПолитике.Видимость = ДоступноИзменениеНастроекМФУ;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОтветаНаВопросОЗаписиОбъекта(Ответ, ДополнительныйПараметры) Экспорт 
	
	НастроитьИспользованиеВУчетнойПолитике = Ложь;
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		Если Записать() Тогда
			НастроитьИспользованиеВУчетнойПолитике = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если НастроитьИспользованиеВУчетнойПолитике Тогда
		ОткрытьФормуНастройкиИспользованияВУчетнойПолитике();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуНастройкиИспользованияВУчетнойПолитике()
	
	ПараметрыФормы = Новый Структура("ШаблонПроводки", Объект.Ссылка);
	ОткрытьФорму("РегистрСведений.ПравилаОтраженияВМеждународномУчете.Форма.НастройкаИспользованияВУчетнойПолитике", ПараметрыФормы, ЭтаФорма); 
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПроверитьВыражение(СтрокаНастройки, КомпоновщикНастроек)
	
	Если Не СтрокаНастройки.ЗаполнятьИзИсточника Тогда
		СтрокаНастройки.Выражение = "";
	КонецЕсли;
	
	Если СтрокаНастройки.Выражение = "" Тогда
		СтрокаНастройки.НетВДоступныхПолях = Ложь;
		СтрокаНастройки.ПредставлениеВыражения = "";
		Возврат;
	КонецЕсли;
	
	Поле = Новый ПолеКомпоновкиДанных(СтрокаНастройки.Выражение); 
	ДоступноеПоле = КомпоновщикНастроек.Настройки.ДоступныеПоляВыбора.НайтиПоле(Поле);
	
	Если ДоступноеПоле = Неопределено Тогда
		СтрокаНастройки.НетВДоступныхПолях = Истина;
		СтрокаНастройки.ПредставлениеВыражения = СтрокаНастройки.Выражение;
	Иначе
		СтрокаНастройки.НетВДоступныхПолях = Ложь;
		СтрокаНастройки.ПредставлениеВыражения = ДоступноеПоле.Заголовок;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти