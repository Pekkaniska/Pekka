
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	НастроитьФормуПриСоздании();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	
	ОтборСписокОрганизаций.Очистить();
	ОтборСписокОрганизаций.Добавить(ОтборОрганизация);
	
	УстановитьОтборы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПодразделениеПриИзменении(Элемент)
	
	УстановитьОтборы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборВажностьПриИзменении(Элемент)
	
	УстановитьОтборы(ЭтаФорма);
		
КонецПроцедуры

&НаКлиенте
Процедура ОтборОсновноеСредствоПриИзменении(Элемент)
	
	УстановитьОтборы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборНематериальныйАктивПриИзменении(Элемент)
	
	УстановитьОтборы(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокОсновныеСредства

&НаКлиенте
Процедура СписокОсновныеСредстваВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.СписокОсновныеСредства.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	Если Поле = Элементы.СписокОбъектовОписаниеПроблемы Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ЗаголовокФормы", НСтр("ru = 'Описание'"));
		ПараметрыФормы.Вставить("ТекстИнформации", ТекущиеДанные.ОписаниеПроблемы);
		ОткрытьФорму("Обработка.ПомощникПереходаНаУчетВнеоборотныхАктивовВерсии24.Форма.ФормаИнформация", ПараметрыФормы);
	ИначеЕсли Поле = Элементы.СписокОбъектовВнеоборотныйАктив Тогда
		ПоказатьЗначение(, ТекущиеДанные.ВнеоборотныйАктив);
	ИначеЕсли Поле = Элементы.СписокОсновныеСредстваКартинкаСостояния Тогда
		РедактироватьДанные(Элементы.СписокОсновныеСредства.ТекущиеДанные);
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокНМА

&НаКлиенте
Процедура СписокНМАВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.СписокНМА.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	Если Поле = Элементы.СписокНМАОписаниеПроблемы Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ЗаголовокФормы", НСтр("ru = 'Описание'"));
		ПараметрыФормы.Вставить("ТекстИнформации", ТекущиеДанные.ОписаниеПроблемы);
		ОткрытьФорму("Обработка.ПомощникПереходаНаУчетВнеоборотныхАктивовВерсии24.Форма.ФормаИнформация", ПараметрыФормы);
	ИначеЕсли Поле = Элементы.СписокНМАВнеоборотныйАктив Тогда
		ПоказатьЗначение(, ТекущиеДанные.ВнеоборотныйАктив);
	ИначеЕсли Поле = Элементы.СписокНМАКартинкаСостояния Тогда
		РедактироватьДанные(Элементы.СписокНМА.ТекущиеДанные);
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СписокОсновныеСредства_УстановитьВажностьОшибка(Команда)
	
	УстановитьВажность("Ошибка", Элементы.СписокОсновныеСредства.ВыделенныеСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокОсновныеСредства_УстановитьВажностьРешено(Команда)
	
	УстановитьВажность("Информация", Элементы.СписокОсновныеСредства.ВыделенныеСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокОсновныеСредства_УстановитьВажностьПредупреждение(Команда)
	
	УстановитьВажность("Предупреждение", Элементы.СписокОсновныеСредства.ВыделенныеСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНМА_УстановитьВажностьРешено(Команда)
	
	УстановитьВажность("Информация", Элементы.СписокНМА.ВыделенныеСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНМА_УстановитьВажностьПредупреждение(Команда)
	
	УстановитьВажность("Предупреждение", Элементы.СписокНМА.ВыделенныеСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНМА_УстановитьВажностьОшибка(Команда)
	
	УстановитьВажность("Ошибка", Элементы.СписокНМА.ВыделенныеСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокОсновныеСредства_РедактироватьДанные(Команда)
	
	РедактироватьДанные(Элементы.СписокОсновныеСредства.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНМА_РедактироватьДанные(Команда)
	
	РедактироватьДанные(Элементы.СписокНМА.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСписокДокументовОС(Команда)
	
	ОткрытьСписокДокументов(Элементы.СписокОсновныеСредства.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСписокДокументовНМА(Команда)
	
	ОткрытьСписокДокументов(Элементы.СписокНМА.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокОсновныеСредства_Удалить(Команда)
	
	УдалитьЗаписи(Элементы.СписокОсновныеСредства);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНМА_Удалить(Команда)
	
	УдалитьЗаписи(Элементы.СписокНМА);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИзменениеВажности

&НаКлиенте
Процедура УстановитьВажность(НоваяВажность, ВыделенныеСтроки)

	МассивВыделенныхСтрок = ПроверитьПолучитьВыделенныеВСпискеСсылки(ВыделенныеСтроки);
	Если МассивВыделенныхСтрок.Количество() = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru='Необходимо выбрать строки'"));
		Возврат;
	КонецЕсли;
	
	УстановитьВажностьНаСервере(МассивВыделенныхСтрок, НоваяВажность);
	
	ОповеститьОбИзменении(Тип("РегистрСведенийКлючЗаписи.ОбъектыПроблемСостоянияСистемы"));
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьВажностьНаСервере(Знач ВыделенныеСтроки, Знач НоваяВажность)
	
	Важность = Перечисления.ВариантыВажностиПроблемыСостоянияСистемы[НоваяВажность];
	
	Для каждого КлючЗаписи Из ВыделенныеСтроки Цикл
		
		НачатьТранзакцию();
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			
			ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ОбъектыПроблемСостоянияСистемы");
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			ЭлементБлокировки.УстановитьЗначение("Проверка", КлючЗаписи.Проверка);
			ЭлементБлокировки.УстановитьЗначение("Организация", КлючЗаписи.Организация);
			ЭлементБлокировки.УстановитьЗначение("ПроверяемыйПериод", КлючЗаписи.ПроверяемыйПериод);
			ЭлементБлокировки.УстановитьЗначение("Объект", КлючЗаписи.Объект);
			
			ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ПроблемыСостоянияСистемы");
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			ЭлементБлокировки.УстановитьЗначение("Проверка", КлючЗаписи.Проверка);
			ЭлементБлокировки.УстановитьЗначение("Организация", КлючЗаписи.Организация);
			ЭлементБлокировки.УстановитьЗначение("ПроверяемыйПериод", КлючЗаписи.ПроверяемыйПериод);
			
			Блокировка.Заблокировать();
			
			ТекстЗапроса = 
			"ВЫБРАТЬ
			|	ТекущаяПроблема.Проверка                   КАК Проверка,
			|	ТекущаяПроблема.Организация                КАК Организация,
			|	ТекущаяПроблема.ПроверяемыйПериод          КАК ПроверяемыйПериод,
			|	ТекущаяПроблема.Представление              КАК Представление,
			|	ТекущаяПроблема.ДополнительнаяИнформация   КАК ДополнительнаяИнформация,
			|	ДругаяПроблемаСНужнойВажностью.Проблема    КАК ПроблемаСНужнойВажностью
			|ИЗ
			|	РегистрСведений.ПроблемыСостоянияСистемы КАК ТекущаяПроблема
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПроблемыСостоянияСистемы КАК ДругаяПроблемаСНужнойВажностью
			|		ПО (ДругаяПроблемаСНужнойВажностью.Проверка = ТекущаяПроблема.Проверка)
			|			И (ДругаяПроблемаСНужнойВажностью.Организация = ТекущаяПроблема.Организация)
			|			И (ДругаяПроблемаСНужнойВажностью.ПроверяемыйПериод = ТекущаяПроблема.ПроверяемыйПериод)
			|			И (ВЫРАЗИТЬ(ДругаяПроблемаСНужнойВажностью.Представление КАК СТРОКА(1024)) = ВЫРАЗИТЬ(ТекущаяПроблема.Представление КАК СТРОКА(1024)))
			|			И (ДругаяПроблемаСНужнойВажностью.Важность = &Важность)
			|			И (ДругаяПроблемаСНужнойВажностью.Проблема <> ТекущаяПроблема.Проблема)
			|ГДЕ
			|	ТекущаяПроблема.Важность <> &Важность
			|	И ТекущаяПроблема.Проверка = &Проверка
			|	И ТекущаяПроблема.Организация = &Организация
			|	И ТекущаяПроблема.ПроверяемыйПериод = &ПроверяемыйПериод
			|	И ТекущаяПроблема.Проблема = &Проблема";
			
			Запрос = Новый Запрос(ТекстЗапроса);
			Запрос.УстановитьПараметр("Проверка", КлючЗаписи.Проверка);
			Запрос.УстановитьПараметр("Организация", КлючЗаписи.Организация);
			Запрос.УстановитьПараметр("ПроверяемыйПериод", КлючЗаписи.ПроверяемыйПериод);
			Запрос.УстановитьПараметр("Проблема", КлючЗаписи.Проблема);
			Запрос.УстановитьПараметр("Важность", Важность);
			
			Выборка = Запрос.Выполнить().Выбрать();
			
			Если Выборка.Следующий() Тогда
				
				Если Выборка.ПроблемаСНужнойВажностью = NULL Тогда
					Проблема = Новый УникальныйИдентификатор;
					НаборЗаписей = РегистрыСведений.ПроблемыСостоянияСистемы.СоздатьНаборЗаписей();
					Запись = НаборЗаписей.Добавить();
					ЗаполнитьЗначенияСвойств(Запись, Выборка);
					Запись.Проблема	= Проблема;
					Запись.Важность	= Важность;
					НаборЗаписей.Записать(Ложь);
				Иначе
					Проблема = Выборка.ПроблемаСНужнойВажностью;
				КонецЕсли; 
				
				ЗаписьРегистра = РегистрыСведений.ОбъектыПроблемСостоянияСистемы.СоздатьМенеджерЗаписи();
				ЗаполнитьЗначенияСвойств(ЗаписьРегистра, КлючЗаписи);
				ЗаписьРегистра.Прочитать();
				
				Если ЗаписьРегистра.Выбран() Тогда
					
					ЗаписьРегистра.Проблема = Проблема;
					ЗаписьРегистра.Записать();
					
				КонецЕсли;
				
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ВызватьИсключение ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		КонецПопытки; 
		
	КонецЦикла; 

КонецПроцедуры
 
#КонецОбласти

#Область Прочее

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборы(Форма)

	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Форма.СписокОсновныеСредства,
		"Организация",
		Форма.ОтборСписокОрганизаций,
		ВидСравненияКомпоновкиДанных.ВСписке,
		,
		Форма.ОтборСписокОрганизаций.Количество() <> 0);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Форма.СписокНМА,
		"Организация",
		Форма.ОтборСписокОрганизаций,
		ВидСравненияКомпоновкиДанных.ВСписке,
		,
		Форма.ОтборСписокОрганизаций.Количество() <> 0);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Форма.СписокОсновныеСредства,
		"Подразделение",
		Форма.ОтборПодразделение,
		ВидСравненияКомпоновкиДанных.ВИерархии,
		,
		НЕ Форма.ОтборПодразделение.Пустая());
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Форма.СписокНМА,
		"Подразделение",
		Форма.ОтборПодразделение,
		ВидСравненияКомпоновкиДанных.ВИерархии,
		,
		НЕ Форма.ОтборПодразделение.Пустая());
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Форма.СписокОсновныеСредства,
		"Важность",
		Форма.ОтборВажность,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		НЕ Форма.ОтборВажность.Пустая());

	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Форма.СписокНМА,
		"Важность",
		Форма.ОтборВажность,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		НЕ Форма.ОтборВажность.Пустая());

	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Форма.СписокОсновныеСредства,
		"ВнеоборотныйАктив",
		Форма.ОтборОсновноеСредство,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		НЕ Форма.ОтборОсновноеСредство.Пустая());

	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Форма.СписокНМА,
		"ВнеоборотныйАктив",
		Форма.ОтборНематериальныйАктив,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		НЕ Форма.ОтборНематериальныйАктив.Пустая());

КонецПроцедуры

&НаКлиенте
Функция ПроверитьПолучитьВыделенныеВСпискеСсылки(ВыделенныеСтроки)

	МассивСсылок = Новый Массив;
	
	Для Итератор = 0 По ВыделенныеСтроки.Количество() - 1 Цикл
		Если ТипЗнч(ВыделенныеСтроки[Итератор]) <> Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			МассивСсылок.Добавить(ВыделенныеСтроки[Итератор]);
		КонецЕсли;
	КонецЦикла;
	
	Возврат МассивСсылок;

КонецФункции

&НаСервереБезКонтекста
Функция ПараметрыРедактированияДанных(Знач Объект, Знач ПроверкаИдентификатор)

	Если ПроверкаИдентификатор = "ПереносПараметровУчетаОС" Тогда
		
		ИмяФормыДокумента = "Документ.ВводОстатковВнеоборотныхАктивов2_4.ФормаОбъекта";
			
		ТекстЗапроса = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ВЫБОР
		|		КОГДА ТабличнаяЧасть.Ссылка.Проведен
		|			ТОГДА 1
		|		ИНАЧЕ 2
		|	КОНЕЦ КАК Порядок,
		|	ТабличнаяЧасть.Ссылка КАК Ссылка,
		|	ТабличнаяЧасть.НомерСтроки КАК НомерСтроки
		|ИЗ
		|	Документ.ВводОстатковВнеоборотныхАктивов2_4.ОС КАК ТабличнаяЧасть
		|ГДЕ
		|	ТабличнаяЧасть.ОсновноеСредство = &Объект
		|	И НЕ ТабличнаяЧасть.Ссылка.ПометкаУдаления
		|	И ТабличнаяЧасть.Ссылка.ХозяйственнаяОперация В (
		|			ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВводОстатковОсновныхСредств), 
		|			ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВводОстатковПредметовЛизингаНаБалансе), 
		|			ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВводОстатковПереданныхВАрендуОС), 
		|			ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВводОстатковПереданныхВАрендуПредметовЛизингаНаБалансе))
		|
		|УПОРЯДОЧИТЬ ПО
		|	Порядок";
			
	ИначеЕсли ПроверкаИдентификатор = "ПереносПараметровУчетаАрендованныхОС" Тогда
		
		ИмяФормыДокумента = "Документ.ВводОстатковВнеоборотныхАктивов2_4.ФормаОбъекта";
			
		ТекстЗапроса = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ВЫБОР
		|		КОГДА ТабличнаяЧасть.Ссылка.Проведен
		|			ТОГДА 1
		|		ИНАЧЕ 2
		|	КОНЕЦ КАК Порядок,
		|	ТабличнаяЧасть.Ссылка КАК Ссылка,
		|	ТабличнаяЧасть.НомерСтроки КАК НомерСтроки
		|ИЗ
		|	Документ.ВводОстатковВнеоборотныхАктивов2_4.АрендованныеОС КАК ТабличнаяЧасть
		|ГДЕ
		|	ТабличнаяЧасть.ОсновноеСредство = &Объект
		|	И НЕ ТабличнаяЧасть.Ссылка.ПометкаУдаления
		|	И ТабличнаяЧасть.Ссылка.ХозяйственнаяОперация В (
		|			ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВводОстатковАрендованныхОС), 
		|			ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВводОстатковПредметовЛизингаЗаБалансом))
		|
		|УПОРЯДОЧИТЬ ПО
		|	Порядок";
			
	ИначеЕсли ПроверкаИдентификатор = "ПереносПараметровУчетаНМА" Тогда
			
		ИмяФормыДокумента = "Документ.ВводОстатковВнеоборотныхАктивов2_4.ФормаОбъекта";
		
		ТекстЗапроса = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ВЫБОР
		|		КОГДА ТабличнаяЧасть.Ссылка.Проведен
		|			ТОГДА 1
		|		ИНАЧЕ 2
		|	КОНЕЦ КАК Порядок,
		|	ТабличнаяЧасть.Ссылка КАК Ссылка,
		|	ТабличнаяЧасть.НомерСтроки КАК НомерСтроки
		|ИЗ
		|	Документ.ВводОстатковВнеоборотныхАктивов2_4.НМА КАК ТабличнаяЧасть
		|ГДЕ
		|	ТабличнаяЧасть.НематериальныйАктив = &Объект
		|	И НЕ ТабличнаяЧасть.Ссылка.ПометкаУдаления
		|
		|УПОРЯДОЧИТЬ ПО
		|	Порядок";
			
	ИначеЕсли ПроверкаИдентификатор = "ПереносВложенийВоВнеоборотныеАктивы" Тогда
		
		ИмяФормыДокумента = "Документ.ВводОстатковВнеоборотныхАктивов2_4.ФормаОбъекта";
		
		ТекстЗапроса = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ВЫБОР
		|		КОГДА ТабличнаяЧасть.Ссылка.Проведен
		|			ТОГДА 1
		|		ИНАЧЕ 2
		|	КОНЕЦ КАК Порядок,
		|	ТабличнаяЧасть.Ссылка КАК Ссылка,
		|	ТабличнаяЧасть.НомерСтроки КАК НомерСтроки
		|ИЗ
		|	Документ.ВводОстатковВнеоборотныхАктивов2_4.ПрочиеРасходы КАК ТабличнаяЧасть
		|ГДЕ
		|	ТабличнаяЧасть.ВнеоборотныйАктив = &Объект
		|	И НЕ ТабличнаяЧасть.Ссылка.ПометкаУдаления
		|
		|УПОРЯДОЧИТЬ ПО
		|	Порядок";
		
	ИначеЕсли ПроверкаИдентификатор = "КорректировкаОстаткаПрочиеАктивы" Тогда
		
		ИмяФормыДокумента = "Документ.ВводОстатков.ФормаОбъекта";
		
		ТекстЗапроса = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ВЫБОР
		|		КОГДА ТабличнаяЧасть.Ссылка.Проведен
		|			ТОГДА 1
		|		ИНАЧЕ 2
		|	КОНЕЦ КАК Порядок,
		|	ТабличнаяЧасть.Ссылка КАК Ссылка,
		|	ТабличнаяЧасть.НомерСтроки КАК НомерСтроки
		|ИЗ
		|	Документ.ВводОстатков.ПрочиеРасходы КАК ТабличнаяЧасть
		|ГДЕ
		|	ТабличнаяЧасть.АналитикаРасходов = &Объект
		|	И НЕ ТабличнаяЧасть.Ссылка.ПометкаУдаления
		|	И ТабличнаяЧасть.Ссылка.ТипОперации = ЗНАЧЕНИЕ(Перечисление.ТипыОперацийВводаОстатков.ОстаткиПрочихАктивовПассивов)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Порядок";
		
	ИначеЕсли ПроверкаИдентификатор = "ПереносПараметровУчетаОС_ИзменениеПараметров" Тогда
		
		ИмяФормыДокумента = "Документ.ИзменениеПараметровОС2_4.ФормаОбъекта";
		
		ТекстЗапроса = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ВЫБОР
		|		КОГДА ТабличнаяЧасть.Ссылка.Проведен
		|			ТОГДА 1
		|		ИНАЧЕ 2
		|	КОНЕЦ КАК Порядок,
		|	ТабличнаяЧасть.Ссылка КАК Ссылка,
		|	ТабличнаяЧасть.НомерСтроки КАК НомерСтроки
		|ИЗ
		|	Документ.ИзменениеПараметровОС2_4.ОС КАК ТабличнаяЧасть
		|ГДЕ
		|	ТабличнаяЧасть.ОсновноеСредство = &Объект
		|	И НЕ ТабличнаяЧасть.Ссылка.ПометкаУдаления
		|
		|УПОРЯДОЧИТЬ ПО
		|	Порядок";
			
	ИначеЕсли ПроверкаИдентификатор = "ПереносПараметровУчетаНМА_ИзменениеПараметров" Тогда
		
		ИмяФормыДокумента = "Документ.ИзменениеПараметровНМА2_4.ФормаОбъекта";
		
		ТекстЗапроса = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ВЫБОР
		|		КОГДА ТабличнаяЧасть.Ссылка.Проведен
		|			ТОГДА 1
		|		ИНАЧЕ 2
		|	КОНЕЦ КАК Порядок,
		|	ТабличнаяЧасть.Ссылка КАК Ссылка,
		|	ТабличнаяЧасть.НомерСтроки КАК НомерСтроки
		|ИЗ
		|	Документ.ИзменениеПараметровНМА2_4.НМА КАК ТабличнаяЧасть
		|ГДЕ
		|	ТабличнаяЧасть.НематериальныйАктив = &Объект
		|	И НЕ ТабличнаяЧасть.Ссылка.ПометкаУдаления
		|
		|УПОРЯДОЧИТЬ ПО
		|	Порядок";
			
	Иначе
		Возврат Неопределено;
	КонецЕсли; 
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Объект", Объект);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ", Выборка.Ссылка);
	ПараметрыФормы.Вставить("АктивизироватьСтроку", Выборка.НомерСтроки);
	
	ПараметрыРедактирования = Новый Структура;
	ПараметрыРедактирования.Вставить("ИмяФормы", ИмяФормыДокумента);
	ПараметрыРедактирования.Вставить("ПараметрыФормы", ПараметрыФормы);

	Возврат ПараметрыРедактирования;
	
КонецФункции

&НаКлиенте
Процедура ОткрытьСписокДокументов(ТекущиеДанные)

	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ТекущиеДанные.Объект) = Тип("СправочникСсылка.ОбъектыЭксплуатации") Тогда
		ИмяФормыЖурнала = "Обработка.ЖурналДокументовОС2_4.Форма.ДокументыПоОС";
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ОбъектЭксплуатации", ТекущиеДанные.Объект);
	Иначе
		ИмяФормыЖурнала = "Обработка.ЖурналДокументовНМА2_4.Форма.ДокументыПоНМА";
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("НематериальныйАктив", ТекущиеДанные.Объект);
	КонецЕсли; 
	
	ОткрытьФорму(ИмяФормыЖурнала, ПараметрыФормы,, ТекущиеДанные.Объект);

КонецПроцедуры

&НаКлиенте
Процедура РедактироватьДанные(ТекущиеДанные)

	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыРедактирования = ПараметрыРедактированияДанных(
								ТекущиеДанные.Объект, 
								ТекущиеДанные.ПроверкаИдентификатор);
								
	Если ПараметрыРедактирования <> Неопределено Тогда
		
		ОткрытьФорму(ПараметрыРедактирования.ИмяФормы, ПараметрыРедактирования.ПараметрыФормы);
		
	Иначе
		
		Если ТипЗнч(ТекущиеДанные.Объект) = Тип("СправочникСсылка.НематериальныеАктивы") Тогда
			Если ТекущиеДанные.ВидОбъектаУчета = ПредопределенноеЗначение("Перечисление.ВидыОбъектовУчетаНМА.НематериальныйАктив") Тогда
				ТекстСообщения = НСтр("ru = 'Для выбранного нематериального актива возможности открыть документ.
	                                       |Возможно, данные не перенесены или помечены на удаление или открытие документа не предусмотрено.
										   |Если текст сообщения содержит информацию о документе, то документ можно открыть из журнала документов.'");
			Иначе
				ТекстСообщения = НСтр("ru = 'Для выбранных расходов на НИОКР нет возможности открыть документ.
	                                       |Возможно, данные не перенесены или помечены на удаление или открытие документа не предусмотрено.
										   |Если текст сообщения содержит информацию о документе, то документ можно открыть из журнала документов.'");
			КонецЕсли; 
		Иначе
			
			ТекстСообщения = НСтр("ru = 'Для выбранного основного средства нет возможности открыть документ.
                                       |Возможно, данные не перенесены или помечены на удаление или открытие документа не предусмотрено.
									   |Если текст сообщения содержит информацию о документе, то документ можно открыть из журнала документов.'");
		КонецЕсли; 
		
		ПоказатьПредупреждение(, ТекстСообщения);
		
	КонецЕсли; 

КонецПроцедуры

&НаКлиенте
Процедура УдалитьЗаписи(ТекущийСписок)

	МассивВыделенныхСтрок = ПроверитьПолучитьВыделенныеВСпискеСсылки(ТекущийСписок.ВыделенныеСтроки);
	Если МассивВыделенныхСтрок.Количество() = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru='Необходимо выбрать строки'"));
		Возврат;
	КонецЕсли;
	
	СписокКнопок = Новый СписокЗначений;
	СписокКнопок.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Удалить'"));
	СписокКнопок.Добавить(КодВозвратаДиалога.Нет);
	
	ТекстВопроса = НСтр("ru = 'Удалить выбранные записи?'");
	ОписаниеОповещения = Новый ОписаниеОповещения("УдалитьЗаписиЗавершение", ЭтотОбъект, МассивВыделенныхСтрок);
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, СписокКнопок);

КонецПроцедуры

&НаКлиенте
Процедура УдалитьЗаписиЗавершение(РезультатВопроса, МассивВыделенныхСтрок) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	УдалитьЗаписиНаСервере(МассивВыделенныхСтрок);
	
	ОповеститьОбИзменении(Тип("РегистрСведенийКлючЗаписи.ОбъектыПроблемСостоянияСистемы"));
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УдалитьЗаписиНаСервере(МассивВыделенныхСтрок)

	Для каждого КлючЗаписи Из МассивВыделенныхСтрок Цикл
		
		ЗаписьРегистра = РегистрыСведений.ОбъектыПроблемСостоянияСистемы.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(ЗаписьРегистра, КлючЗаписи);
		ЗаписьРегистра.Удалить();
		
	КонецЦикла; 

КонецПроцедуры

&НаСервере
Процедура НастроитьФормуПриСоздании()

	СписокПроверок = Обработки.ПомощникПереходаНаУчетВнеоборотныхАктивовВерсии24.ИспользуемыеПроверки();
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокОсновныеСредства,
		"Проверка",
		СписокПроверок,
		ВидСравненияКомпоновкиДанных.ВСписке,
		,
		Истина);
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокНМА,
		"Проверка",
		СписокПроверок,
		ВидСравненияКомпоновкиДанных.ВСписке,
		,
		Истина);
		
	Если Параметры.Свойство("МассивОрганизаций") Тогда
		Если Параметры.МассивОрганизаций.ВГраница() = 0 Тогда
			ОтборОрганизация = Параметры.МассивОрганизаций[0];
			ОтборСписокОрганизаций.Добавить(ОтборОрганизация);
		Иначе
			ОтборСписокОрганизаций.ЗагрузитьЗначения(Параметры.МассивОрганизаций);
			Элементы.ОтборОрганизация.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если Параметры.Свойство("ОтборВажность") Тогда
		ОтборВажность = Параметры.ОтборВажность;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОтборВажность) 
		ИЛИ ЗначениеЗаполнено(ОтборОрганизация)
		ИЛИ ОтборСписокОрганизаций.Количество() <> 0 Тогда
		УстановитьОтборы(ЭтаФорма);
	КонецЕсли; 
	
	Если НЕ Пользователи.ЭтоПолноправныйПользователь() Тогда
		Элементы.СписокОсновныеСредства_Удалить.Видимость = Ложь;
		Элементы.СписокНМА_Удалить.Видимость = Ложь;
	КонецЕсли; 

КонецПроцедуры
 
#КонецОбласти

#КонецОбласти


