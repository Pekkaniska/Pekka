#Область ОписаниеПеременных

&НаКлиенте
Перем мНомерТекущейСтроиЗаписиОСтаже;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ПерсонифицированныйУчетФормы.ДокументыСЗВПриСозданииНаСервере(ЭтаФорма, ОписаниеДокумента());
	Если Параметры.Ключ.Пустая() Тогда
		ЗапрашиваемыеЗначенияПервоначальногоЗаполнения();
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗапрашиваемыеЗначенияПервоначальногоЗаполнения());
		Если Объект.ОтчетныйПериод > '20131001' Тогда
			Объект.ОтчетныйПериод = '20131001';
			ПериодСтрока = ПерсонифицированныйУчетКлиентСервер.ПредставлениеОтчетногоПериода(Объект.ОтчетныйПериод);
		КонецЕсли;	
		
		ПриПолученииДанныхНаСервере();
	КонецЕсли;	

	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ПриИнициализацииФормыРегламентированногоОтчета(ЭтаФорма, "ПФР");	
	ЭлектронныйДокументооборотСКонтролирующимиОрганами.ОтметитьКакПрочтенное(Объект.Ссылка);
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаПечатьПереопределенная;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриПолученииДанныхНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ИзменениеДанныхФизическогоЛица" Тогда
		СтруктураОтбора = Новый Структура("Сотрудник", Источник);
		СтрокиПоСотруднику = Объект.Сотрудники.НайтиСтроки(СтруктураОтбора);
		ЗарплатаКадрыКлиентСервер.ОбработкаИзмененияДанныхФизическогоЛица(Объект, Параметр, СтрокиПоСотруднику, Модифицированность);
	ИначеЕсли ИмяСобытия = "РедактированиеДанныхСЗВ6ПоСотруднику" Тогда
		ПриИзмененииДанныхДокументаПоСотруднику(Параметр.АдресВоВременномХранилище);		
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	Если Объект.ДокументПринятВПФР Тогда
		ТолькоПросмотр = Истина;
	КонецЕсли;
	
	ПерсонифицированныйУчетКлиентСервер.УстановитьЗаголовкиВТаблице(ЭтотОбъект, Объект.Сотрудники, ОписаниеКолонокЗаголовковТаблицыСотрудники());
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_ПачкаДокументовСПВ_1", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтчетныйПериодНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ОтчетныйПериодНачалоВыбораЗавершение", ЭтотОбъект);
	ПерсонифицированныйУчетКлиент.ОтчетныйПериодНачалоВыбора(ЭтаФорма, ЭтаФорма, "Объект.ОтчетныйПериод", "ПериодСтрока", '20100101', '20131001', Оповещение);	
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчетныйПериодНачалоВыбораЗавершение(Отказ, ДополнительныеПараметры) Экспорт 
	
	УстановитьКатегориюЗастрахованныхЛицЗаПериод();
	
КонецПроцедуры

&НаКлиенте
Функция РежимВыбораПериода(ВыбираемыйПериод) Экспорт
	Год = Год(ВыбираемыйПериод);
	Если Год < 2011 Тогда
		Возврат "Полугодие";
	Иначе
		Возврат "Квартал";
	КонецЕсли; 
КонецФункции

&НаКлиенте
Процедура ОтчетныйПериодРегулирование(Элемент, Направление, СтандартнаяОбработка)
	Отказ = Ложь;
	ПерсонифицированныйУчетКлиент.ОтчетныйПериодРегулирование(Объект.ОтчетныйПериод, ПериодСтрока, Направление, '20100101', '20131001', Отказ);	
	Если НЕ Отказ Тогда
		УстановитьКатегориюЗастрахованныхЛицЗаПериод();
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ТипСведенийПриИзменении(Элемент)
	ТипСведенийПриИзмененииСервере();
КонецПроцедуры

&НаСервере
Процедура ТипСведенийПриИзмененииСервере()
	УстановитьДоступностьПолейСтажаИВзносов(ЭтаФорма);
	ПерсонифицированныйУчетФормы.УстановитьВидимостьКолонокЗаголовков(ЭтотОбъект, "Сотрудники", ОписаниеКолонокЗаголовковТаблицыСотрудники());
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ОрганизацияПриИзмененииНаСервере();	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Если Копирование Тогда
		Отказ = Истина;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока Тогда
		ПерсонифицированныйУчетКлиентСервер.УстановитьЗаголовкиВСтрокеТаблицы(
			ЭтотОбъект,
			Элементы.Сотрудники.ТекущиеДанные,
			ОписаниеКолонокЗаголовковТаблицыСотрудники());
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиСотрудникПриИзменении(Элемент)
	СотрудникиСотрудникПриИзмененииНаСервере();		
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ОбработкаПодбораНаСервере(ВыбранноеЗначение);
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиПередУдалением(Элемент, Отказ)
	ПерсонифицированныйУчетКлиентСервер.ДокументыРедактированияСтажаСотрудникиПередУдалением(Элементы.Сотрудники.ВыделенныеСтроки, Объект.Сотрудники, Объект.ЗаписиОСтаже);	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Элементы.Сотрудники.ТекущийЭлемент = Элементы.СотрудникиФизическоеЛицо
		И Не ЗначениеЗаполнено(Элементы.Сотрудники.ТекущиеДанные.Сотрудник) Тогда
		
		Возврат;
	КонецЕсли;	
		
	ОткрытьФормуРедактированияКарточкиДокумента();
КонецПроцедуры

&НаКлиенте
Процедура ФлагБлокировкиДокументаПриИзменении(Элемент)
	ФлагБлокировкиДокументаПриИзмененииНаСервере();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подбор(Команда)
	КадровыйУчетКлиент.ПодобратьФизическихЛицОрганизации(Элементы.Сотрудники, Объект.Организация, АдресСпискаПодобранныхСотрудников());
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДанныеСотрудников(Команда)
	
	Если Не ЗарплатаКадрыКлиент.ОрганизацияЗаполнена(Объект) Тогда 
		Возврат;
	КонецЕсли;

	Если Объект.Сотрудники.Количество() > 0 Тогда
	    ТекстВопроса = НСтр("ru = 'Данные о сотрудниках будут перезаполнены, продолжить?'");
		Оповещение = Новый ОписаниеОповещения("ЗаполнитьДанныеСотрудниковЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Иначе 
		ЗаполнитьДанныеСотрудниковЗавершение(КодВозвратаДиалога.Да, Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДанныеСотрудниковЗавершение(Ответ, ДополнительныеПараметры) Экспорт 
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьДанныеФизЛицДокументаНаСервере();	
КонецПроцедуры

&НаКлиенте
Процедура РасположитьЗаписиСтажа(Команда)
	Если Элементы.Сотрудники.ТекущиеДанные <> Неопределено Тогда
		ПерсонифицированныйУчетКлиент.ДокументыСЗВВыполнитьНумерациюЗаписейОСтаже(Элементы.Сотрудники, Объект.ЗаписиОСтаже);
		РасположитьЗаписиСтажаНаСервере(Элементы.Сотрудники.ТекущиеДанные.Сотрудник);
		ПерсонифицированныйУчетКлиент.ДокументыСЗВВыполнитьНумерациюЗаписейОСтаже(Элементы.Сотрудники, Объект.ЗаписиОСтаже);
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьНаДиск(Команда)
	
	Если Год(Объект.ОтчетныйПериод) >= 2014 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'С первого квартала 2014 г. действует форма СПВ-2.'"));
	Иначе 
		Оповещение = Новый ОписаниеОповещения("ЗаписатьНаДискЗавершение", ЭтотОбъект);
		ПроверитьСЗапросомДальнейшегоДействия(Оповещение);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФайл(Команда)
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;

	ДанныеФайла = ПолучитьДанныеФайлаНаСервере(Объект.Ссылка, УникальныйИдентификатор);
	Если ДанныеФайла <> Неопределено Тогда
		РаботаСФайламиКлиент.ОткрытьФайл(ДанныеФайла, Ложь);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СформироватьФайл(Команда)
	ОчиститьСообщения();
	СформироватьФайлНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьВсеАдреса(Команда)
	Если НЕ ЗарплатаКадрыКлиент.ОрганизацияЗаполнена(Объект) Тогда 
		Возврат;
	КонецЕсли;

	ЗаполнитьВсеАдресаНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьВКонтролирующийОрган(Команда)
	
	Если Год(Объект.ОтчетныйПериод) >= 2014 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'С первого квартала 2014 г. действует форма СПВ-2.'"));
	Иначе 
		Оповещение = Новый ОписаниеОповещения("ОтправитьВКонтролирующийОрганЗавершение", ЭтотОбъект);
		ПроверитьСЗапросомДальнейшегоДействия(Оповещение);
	КонецЕсли;	

КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВИнтернете(Команда)
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;

	РегламентированнаяОтчетностьКлиент.ПроверитьВИнтернете(ЭтаФорма, "ПФР");	
КонецПроцедуры

&НаКлиенте
Процедура Проверить(Команда)
	ОчиститьСообщения();

	Отказ = Ложь;
	ПроверкаЗаполненияДокумента(Отказ);
	
	ПроверкаСтороннимиПрограммами(Отказ);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Функция ОписаниеКолонокЗаголовковТаблицФормы()
	ОписаниеКолонокЗаголовковТаблиц = Новый Соответствие;
	
	ОписаниеКолонокЗаголовковТаблиц.Вставить("Сотрудники", ОписаниеКолонокЗаголовковТаблицыСотрудники());  
	
	Возврат ОписаниеКолонокЗаголовковТаблиц;
КонецФункции	

&НаКлиентеНаСервереБезКонтекста
Функция ОписаниеКолонокЗаголовковТаблицыСотрудники()
	ОписаниеЗаголовковКолонок = Новый Массив;
	
	ОписаниеЗаголовка = ПерсонифицированныйУчетКлиентСервер.СтруктураОписанияКолонокЗаголовков();
	ОписаниеЗаголовка.ПолеТаблицы = "СотрудникиНачисленоСтраховая";
	
	ОписаниеЗаголовковКолонок.Добавить(ОписаниеЗаголовка);
	
	ОписаниеЗаголовка = ПерсонифицированныйУчетКлиентСервер.СтруктураОписанияКолонокЗаголовков();
	ОписаниеЗаголовка.ПолеТаблицы = "СотрудникиУплаченоСтраховая";
		
	ОписаниеЗаголовковКолонок.Добавить(ОписаниеЗаголовка);
	
	ОписаниеЗаголовка = ПерсонифицированныйУчетКлиентСервер.СтруктураОписанияКолонокЗаголовков();
	ОписаниеЗаголовка.ПолеТаблицы = "СотрудникиНачисленоНакопительная";
	
	ОписаниеЗаголовковКолонок.Добавить(ОписаниеЗаголовка);
		
	ОписаниеЗаголовка = ПерсонифицированныйУчетКлиентСервер.СтруктураОписанияКолонокЗаголовков();
	ОписаниеЗаголовка.ПолеТаблицы = "СотрудникиУплаченоНакопительная";
	
	ОписаниеЗаголовковКолонок.Добавить(ОписаниеЗаголовка);
		
	Возврат ОписаниеЗаголовковКолонок;
		
КонецФункции

&НаКлиенте
Процедура ОткрытьФормуРедактированияКарточкиДокумента()
	ДанныеТекущейСтроки = Элементы.Сотрудники.ТекущиеДанные;
	
	ДанныеШапкиТекущегоДокумента = Объект;
	
	Период = Объект.ОтчетныйПериод;
		
	Если ДанныеТекущейСтроки <> Неопределено Тогда	
		ДанныеТекущегоДокументаПоСотрудникуВоВременноеХранилище();
		
		ПараметрыОткрытияФормы = Новый Структура;
		ПараметрыОткрытияФормы.Вставить("АдресВоВременномХранилище", АдресДанныхТекущегоДокументаВХранилище);
		ПараметрыОткрытияФормы.Вставить("РедактируемыйДокументСсылка", ДанныеШапкиТекущегоДокумента.Ссылка);
		ПараметрыОткрытияФормы.Вставить("Сотрудник", ДанныеТекущейСтроки.Сотрудник);
		ПараметрыОткрытияФормы.Вставить("ТипСведенийСЗВ", ДанныеШапкиТекущегоДокумента.ТипСведенийСЗВ);
		ПараметрыОткрытияФормы.Вставить("Организация", ДанныеШапкиТекущегоДокумента.Организация);
		ПараметрыОткрытияФормы.Вставить("Период", Период);
		ПараметрыОткрытияФормы.Вставить("ИсходныйНомерСтроки", 0);
		ПараметрыОткрытияФормы.Вставить("ТолькоПросмотр", ТолькоПросмотр);
		ПараметрыОткрытияФормы.Вставить("НеОтображатьОшибки", Истина);
		
		ОткрытьФорму("Обработка.ПодготовкаКвартальнойОтчетностиВПФР.Форма.ФормаКарточкиСЗВ6", ПараметрыОткрытияФормы, ЭтаФорма);	
	КонецЕсли;	
КонецПроцедуры	

&НаСервере
Процедура ДанныеТекущегоДокументаПоСотрудникуВоВременноеХранилище()
	Если Элементы.Сотрудники.ТекущаяСтрока = Неопределено Тогда
		АдресДанныхТекущегоДокументаВХранилище = "";
		Возврат;
	КонецЕсли;	
	
	ДанныеТекущейСтрокиПоСотруднику = Объект.Сотрудники.НайтиПоИдентификатору(Элементы.Сотрудники.ТекущаяСтрока);
	
	Если ДанныеТекущейСтрокиПоСотруднику = Неопределено Тогда
		АдресДанныхТекущегоДокументаВХранилище = "";
		Возврат;
	КонецЕсли;
	
	ДанныеСотрудника = Новый Структура;
	ДанныеСотрудника.Вставить("Сотрудник", ДанныеТекущейСтрокиПоСотруднику.Сотрудник);
	ДанныеСотрудника.Вставить("ДатаСоставления", ДанныеТекущейСтрокиПоСотруднику.ДатаСоставления);
	ДанныеСотрудника.Вставить("СтраховойНомерПФР", ДанныеТекущейСтрокиПоСотруднику.СтраховойНомерПФР);
	ДанныеСотрудника.Вставить("Фамилия", ДанныеТекущейСтрокиПоСотруднику.Фамилия);
	ДанныеСотрудника.Вставить("Имя", ДанныеТекущейСтрокиПоСотруднику.Имя);
	ДанныеСотрудника.Вставить("Отчество", ДанныеТекущейСтрокиПоСотруднику.Отчество);
	ДанныеСотрудника.Вставить("НачисленоСтраховая", ДанныеТекущейСтрокиПоСотруднику.НачисленоСтраховая);
	ДанныеСотрудника.Вставить("УплаченоСтраховая", ДанныеТекущейСтрокиПоСотруднику.УплаченоСтраховая);
	ДанныеСотрудника.Вставить("НачисленоНакопительная", ДанныеТекущейСтрокиПоСотруднику.НачисленоНакопительная);
	ДанныеСотрудника.Вставить("УплаченоНакопительная", ДанныеТекущейСтрокиПоСотруднику.УплаченоНакопительная);
	ДанныеСотрудника.Вставить("ДоначисленоСтраховая", 0);
	ДанныеСотрудника.Вставить("ДоначисленоНакопительная", 0);
	ДанныеСотрудника.Вставить("ДоУплаченоНакопительная", 0);
	ДанныеСотрудника.Вставить("ДоУплаченоСтраховая", 0);
		
	ДанныеСотрудника.Вставить("ФиксНачисленныеВзносы", Ложь);
	ДанныеСотрудника.Вставить("ФиксУплаченныеВзносы", Ложь);
	ДанныеСотрудника.Вставить("ФиксСтаж", Ложь);
	ДанныеСотрудника.Вставить("ФиксЗаработок", Ложь);
	ДанныеСотрудника.Вставить("СведенияОЗаработке", Новый Массив);
    ДанныеСотрудника.Вставить("ЗаписиОСтаже", Новый Массив);
	ДанныеСотрудника.Вставить("ИсходныйНомерСтроки", ДанныеТекущейСтрокиПоСотруднику.ИсходныйНомерСтроки);
	
	СтруктураПоиска = Новый Структура("Сотрудник", ДанныеТекущейСтрокиПоСотруднику.Сотрудник);
				
	СтрокиЗаписиОСтаже = Объект.ЗаписиОСтаже.НайтиСтроки(СтруктураПоиска);
	
	Для Каждого СтрокаСтаж Из СтрокиЗаписиОСтаже Цикл
		СтруктураПолейЗаписиОСтаже = СтруктураПолейЗаписиОСтаже();
		ЗаполнитьЗначенияСвойств(СтруктураПолейЗаписиОСтаже, СтрокаСтаж);
		СтруктураПолейЗаписиОСтаже.ИдентификаторИсходнойСтроки = СтрокаСтаж.ПолучитьИдентификатор(); 
				
		ДанныеСотрудника.ЗаписиОСтаже.Добавить(СтруктураПолейЗаписиОСтаже);
	КонецЦикла;	

	Если ЗначениеЗаполнено(АдресДанныхТекущегоДокументаВХранилище) Тогда
		ПоместитьВоВременноеХранилище(ДанныеСотрудника, АдресДанныхТекущегоДокументаВХранилище);	
	Иначе	
		АдресДанныхТекущегоДокументаВХранилище = ПоместитьВоВременноеХранилище(ДанныеСотрудника, УникальныйИдентификатор);
	КонецЕсли;	
	
КонецПроцедуры	

&НаКлиенте
Процедура ПриИзмененииДанныхДокументаПоСотруднику(АдресВоВременномХранилище)
	ДанныеТекущегоДокументаПоСотрудникуВДанныеФормы(АдресВоВременномХранилище);
КонецПроцедуры	

&НаСервере
Процедура ДанныеТекущегоДокументаПоСотрудникуВДанныеФормы(АдресВоВременномХранилище)
	
	ДанныеШапкиДокумента = Объект;
	
	ДанныеТекущегоДокумента = ПолучитьИзВременногоХранилища(АдресВоВременномХранилище);
	
	Если ДанныеТекущегоДокумента = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеТекущейСтрокиПоСотруднику = Неопределено;
	НайденныеСтроки = Объект.Сотрудники.НайтиСтроки(Новый Структура("Сотрудник", ДанныеТекущегоДокумента.Сотрудник));
		
	Если НайденныеСтроки.Количество() > 0 Тогда
		ДанныеТекущейСтрокиПоСотруднику = НайденныеСтроки[0];
		
		Если ДанныеТекущейСтрокиПоСотруднику.Сотрудник <> ДанныеТекущегоДокумента.Сотрудник Тогда
			ДанныеТекущейСтрокиПоСотруднику = Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	Если ДанныеТекущейСтрокиПоСотруднику = Неопределено  Тогда
		
		ВызватьИсключение НСтр("ru = 'В текущем документе не найдены данные по редактируемому сотруднику.'");
	КонецЕсли;
	
	ДанныеТекущейСтрокиПоСотруднику = Объект.Сотрудники.НайтиПоИдентификатору(Элементы.Сотрудники.ТекущаяСтрока);
		
	ЗаполнитьЗначенияСвойств(ДанныеТекущейСтрокиПоСотруднику, ДанныеТекущегоДокумента);
		
	СтруктураПоиска = Новый Структура("Сотрудник", ДанныеТекущейСтрокиПоСотруднику.Сотрудник);
			
	СтрокиСтажа = Объект.ЗаписиОСтаже.НайтиСтроки(СтруктураПоиска);
	Для Каждого СтрокаСтажСотрудника Из СтрокиСтажа Цикл
		Объект.ЗаписиОСтаже.Удалить(Объект.ЗаписиОСтаже.Индекс(СтрокаСтажСотрудника));
	КонецЦикла;
	
	СтрокиСтажаПоСотруднику = Новый Массив;
	Для Каждого СтрокаСтаж Из ДанныеТекущегоДокумента.ЗаписиОСтаже Цикл
		СтрокаСтажОбъекта = Объект.ЗаписиОСтаже.Добавить();
		СтрокаСтажОбъекта.Сотрудник = ДанныеТекущейСтрокиПоСотруднику.Сотрудник;		
		ЗаполнитьЗначенияСвойств(СтрокаСтажОбъекта, СтрокаСтаж);
		
		СтрокиСтажаПоСотруднику.Добавить(СтрокаСтажОбъекта);
	КонецЦикла;
	
	Если ДанныеТекущегоДокумента.Модифицированность Тогда
		Модифицированность = Истина;
	КонецЕсли;
	
	ПерсонифицированныйУчетКлиентСервер.ВыполнитьНумерациюЗаписейОСтаже(СтрокиСтажаПоСотруднику);
	
КонецПроцедуры

&НаСервере
Функция СтруктураПолейЗаписиОСтаже()
	СтруктураПолей = Новый Структура;
	СтруктураПолей.Вставить("НомерОсновнойЗаписи");
	СтруктураПолей.Вставить("НомерДополнительнойЗаписи");
	СтруктураПолей.Вставить("ДатаНачалаПериода");
	СтруктураПолей.Вставить("ДатаОкончанияПериода");
	СтруктураПолей.Вставить("ОсобыеУсловияТруда");
	СтруктураПолей.Вставить("КодПозицииСписка");
	СтруктураПолей.Вставить("ОснованиеИсчисляемогоСтажа");
	СтруктураПолей.Вставить("ПервыйПараметрИсчисляемогоСтажа");
	СтруктураПолей.Вставить("ВторойПараметрИсчисляемогоСтажа");
	СтруктураПолей.Вставить("ТретийПараметрИсчисляемогоСтажа");
	СтруктураПолей.Вставить("ОснованиеВыслугиЛет");
	СтруктураПолей.Вставить("ПервыйПараметрВыслугиЛет");
	СтруктураПолей.Вставить("ВторойПараметрВыслугиЛет");
	СтруктураПолей.Вставить("ТретийПараметрВыслугиЛет");
	СтруктураПолей.Вставить("ТерриториальныеУсловия");
	СтруктураПолей.Вставить("ПараметрТерриториальныхУсловий");
	СтруктураПолей.Вставить("ИдентификаторИсходнойСтроки");

	Возврат СтруктураПолей;	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ОписаниеДокумента()
	ОписаниеДокумента = ПерсонифицированныйУчетКлиентСервер.ОписаниеДокументаСЗВ();
	ОписаниеДокумента.ВариантОтчетногоПериода = "КВАРТАЛ";
	ОписаниеДокумента.ЕстьКорректируемыйПериод = Ложь;
	ОписаниеДокумента.ИмяПоляКорректируемыйПериод = "ОтчетныйПериод";
	
	Возврат ОписаниеДокумента;
КонецФункции	

&НаСервере
Процедура ПриПолученииДанныхНаСервере()	
	Если Не ТаблицаДополнена Тогда 
		ИменаТаблиц = Новый Массив;
		ИменаТаблиц.Добавить("Сотрудники");

		ПерсонифицированныйУчетФормы.ДобавитьЗаголовкиКПолямТаблицФормы(ЭтотОбъект, ИменаТаблиц, ОписаниеКолонокЗаголовковТаблицФормы());
		
		ТаблицаДополнена = Истина;
	КонецЕсли;	
	
	ПерсонифицированныйУчетФормы.ДокументыСЗВПриПолученииДанныхНаСервере(ЭтаФорма, ОписаниеДокумента());
	
	ПериодСтрока = ПерсонифицированныйУчетКлиентСервер.ПредставлениеОтчетногоПериода(Объект.ОтчетныйПериод);
	
	УстановитьДоступностьПолейСтажаИВзносов(ЭтаФорма);
	
	ФлагБлокировкиДокумента = Объект.ДокументПринятВПФР;
	
	УстановитьДоступностьДанныхФормы();

	ПерсонифицированныйУчетКлиентСервер.УстановитьЗаголовкиВТаблице(ЭтотОбъект, Объект.Сотрудники, ОписаниеКолонокЗаголовковТаблицыСотрудники());
	ПерсонифицированныйУчетФормы.УстановитьВидимостьКолонокЗаголовков(ЭтотОбъект, "Сотрудники", ОписаниеКолонокЗаголовковТаблицыСотрудники());
КонецПроцедуры

&НаСервере
Процедура ФлагБлокировкиДокументаПриИзмененииНаСервере()
	Модифицированность = Истина;
	Объект.ДокументПринятВПФР = ФлагБлокировкиДокумента;
	Если Не ФлагБлокировкиДокумента Тогда
		ТолькоПросмотр = Ложь;
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьДанныхФормы()
	Если Объект.ДокументПринятВПФР Тогда  
		ТолькоПросмотр = Истина;	
	КонецЕсли;		
КонецПроцедуры	

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьПолейСтажаИВзносов(Форма)
	Если Форма.Объект.ТипСведенийСЗВ = ПредопределенноеЗначение("Перечисление.ТипыСведенийСЗВ.ОТМЕНЯЮЩАЯ") Тогда
		Форма.Элементы.Страховая.Видимость = Ложь;
	    Форма.Элементы.Накопительная.Видимость = Ложь;
		Форма.Объект.ЗаписиОСтаже.Очистить();
	Иначе
		Форма.Элементы.Страховая.Видимость = Истина;
	    Форма.Элементы.Накопительная.Видимость = Истина;
	КонецЕсли;	
КонецПроцедуры	

&НаСервереБезКонтекста
Функция ЗапрашиваемыеЗначенияПервоначальногоЗаполнения()
	ЗапрашиваемыеЗначения = ЗапрашиваемыеЗначенияЗаполненияПоОрганизации();
	ЗапрашиваемыеЗначения.Вставить("Организация", "Объект.Организация");
	ЗапрашиваемыеЗначения.Вставить("ПредыдущийКвартал", "Объект.ОтчетныйПериод");

	Возврат ЗапрашиваемыеЗначения;
КонецФункции

&НаСервереБезКонтекста
Функция ЗапрашиваемыеЗначенияЗаполненияПоОрганизации()
	
	ЗапрашиваемыеЗначения = Новый Структура;
	ЗапрашиваемыеЗначения.Вставить("Руководитель", "Объект.Руководитель");
	ЗапрашиваемыеЗначения.Вставить("ДолжностьРуководителя", "Объект.ДолжностьРуководителя");
	
	Возврат ЗапрашиваемыеЗначения;
	
КонецФункции 

&НаСервереБезКонтекста
Функция ПолучитьДанныеФайлаНаСервере(Ссылка, УникальныйИдентификатор)	
	Возврат ЗарплатаКадры.ПолучитьДанныеФайла(Ссылка, УникальныйИдентификатор);	
КонецФункции	

&НаСервере
Процедура ЗаполнитьДанныеФизЛицДокументаНаСервере() 
	 ПерсонифицированныйУчет.ДокументыСЗВЗаполнитьДанныеСотрудников(Объект, Ложь)	
КонецПроцедуры	

&НаСервере
Процедура ОбработкаПодбораНаСервере(МассивСотрудников)
	ПерсонифицированныйУчет.ДокументыСЗВОбработкаПодбораНаСервере(Объект, МассивСотрудников, Ложь);	
	ПерсонифицированныйУчетКлиентСервер.УстановитьЗаголовкиВТаблице(
			ЭтотОбъект,
			Объект.Сотрудники,
			ОписаниеКолонокЗаголовковТаблицыСотрудники());
КонецПроцедуры

&НаСервере
Процедура СотрудникиСотрудникПриИзмененииНаСервере()
	ПерсонифицированныйУчет.ДокументыСЗВСотрудникПриИзменении(Элементы.Сотрудники, Объект, ТекущийСотрудник, Ложь);	
КонецПроцедуры	

&НаСервере
Процедура РасположитьЗаписиСтажаНаСервере(Сотрудник)
	ПерсонифицированныйУчет.РасположитьЗаписиСтажа(Сотрудник, Объект.ЗаписиОСтаже);	
КонецПроцедуры	

&НаСервере
Процедура СформироватьФайлНаСервере()
	ПерсонифицированныйУчет.СформироватьФайл(ЭтаФорма);	
КонецПроцедуры	

&НаСервере 
Процедура ЗаполнитьВсеАдресаНаСервере()
	ПерсонифицированныйУчет.ДокументыСЗВЗаполнитьАдресаВДанныеПачек(Объект.Организация, Объект.ОтчетныйПериод, Объект.Сотрудники, Объект.Дата, Истина);	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	Объект.Сотрудники.Очистить();
	Объект.ЗаписиОСтаже.Очистить();
	
	ПерсонифицированныйУчетФормы.ОрганизацияПриИзменении(ЭтаФорма, ЗапрашиваемыеЗначенияЗаполненияПоОрганизации());
	
	УстановитьКатегориюЗастрахованныхЛицЗаПериод();
КонецПроцедуры

&НаСервере
Процедура УстановитьКатегориюЗастрахованныхЛицЗаПериод() Экспорт
	ПерсонифицированныйУчетФормы.ДокументыСЗВУстановитьКатегориюЗастрахованныхЛицЗаПериод(ЭтаФорма, ОписаниеДокумента());	
КонецПроцедуры	

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	Если Год(Объект.ОтчетныйПериод) >= 2014 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'С первого квартала 2014 г. действует форма СПВ-2.'"));
	Иначе
		Оповещение = Новый ОписаниеОповещения("ВыполнитьПодключаемуюКомандуЗавершение", ЭтотОбъект, Команда);
		ПроверитьСЗапросомДальнейшегоДействия(Оповещение);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПодключаемуюКомандуЗавершение(Результат, Команда) Экспорт
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаСервере
Функция АдресСпискаПодобранныхСотрудников()
	
	Возврат ПоместитьВоВременноеХранилище(Объект.Сотрудники.Выгрузить(,"Сотрудник").ВыгрузитьКолонку("Сотрудник"), УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Процедура ПроверкаЗаполненияДокумента(Отказ = Ложь)
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	
	ДокументОбъект.ПроверитьДанныеДокумента(Отказ);
КонецПроцедуры	

&НаКлиенте
Процедура ПроверкаСтороннимиПрограммами(Отказ)
	
	Если Отказ Тогда
		ТекстВопроса = НСтр("ru = 'При проверке встроенной проверкой обнаружены ошибки.
		|Выполнить проверку сторонними программами?'")
	Иначе	
		ТекстВопроса = НСтр("ru = 'При проверке встроенной проверкой ошибок не обнаружено.
		|Выполнить проверку сторонними программами?'");
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ПроверкаСтороннимиПрограммамиЗавершение", ЭтотОбъект);
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверкаСтороннимиПрограммамиЗавершение(Ответ, ДополнительныеПараметры) Экспорт 
	
	Если Ответ = КодВозвратаДиалога.Да Тогда 
		ПроверитьСтороннимиПрограммами();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьСтороннимиПрограммами()
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;

	ПараметрыОткрытия = Новый Структура;
	
	ПроверяемыеОбъекты = Новый Массив;
	ПроверяемыеОбъекты.Добавить(Объект.Ссылка);
	
	ПараметрыОткрытия.Вставить("СсылкиНаПроверяемыеОбъекты", ПроверяемыеОбъекты);
	
	ОткрытьФорму("ОбщаяФорма.ПроверкаФайловОтчетностиПерсУчетаПФР", ПараметрыОткрытия, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьСЗапросомДальнейшегоДействия(ОповещениеЗавершения = Неопределено)
	ОчиститьСообщения();
	
	Отказ = Ложь;
	ПроверкаЗаполненияДокумента(Отказ);	
	
	ДополнительныеПараметры = Новый Структура("ОповещениеЗавершения", ОповещениеЗавершения);
	
	Если Отказ Тогда 
		ТекстВопроса = НСтр("ru = 'В комплекте обнаружены ошибки.
							|Продолжить (не рекомендуется)?'");
							
		Оповещение = Новый ОписаниеОповещения("ПроверитьСЗапросомДальнейшегоДействияЗавершение", ЭтотОбъект, ДополнительныеПараметры);					
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет, НСтр("ru = 'Предупреждение.'"));
	Иначе 
		ПроверитьСЗапросомДальнейшегоДействияЗавершение(КодВозвратаДиалога.Да, ДополнительныеПараметры);				
	КонецЕсли;	
	
КонецПроцедуры	

&НаКлиенте
Процедура ПроверитьСЗапросомДальнейшегоДействияЗавершение(Ответ, ДополнительныеПараметры) Экспорт 
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;			
	
	Если ДополнительныеПараметры.ОповещениеЗавершения <> Неопределено Тогда 
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеЗавершения);
	КонецЕсли;
	
КонецПроцедуры	

&НаКлиенте
Процедура ЗаписатьНаДискЗавершение(Результат, Параметры) Экспорт
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;

	ДанныеФайла = ПолучитьДанныеФайлаНаСервере(Объект.Ссылка, УникальныйИдентификатор);
	РаботаСФайламиКлиент.СохранитьФайлКак(ДанныеФайла);	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьВКонтролирующийОрганЗавершение(Результат, Параметры) Экспорт
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;

	РегламентированнаяОтчетностьКлиент.ПриНажатииНаКнопкуОтправкиВКонтролирующийОрган(ЭтаФорма, "ПФР");	
КонецПроцедуры

#КонецОбласти
