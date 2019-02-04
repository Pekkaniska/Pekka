
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Параметры.Свойство("ВыполняемаяОперация", ВыполняемаяОперация) Тогда
	
		ВыполняемаяОперация = "ВыборЭтапаПроизводства";
		
	КонецЕсли;
	
	Если ВыполняемаяОперация = "ВыборЭтапаВыпускаПолуфабриката" Тогда
		
		ТекстШаблона = НСтр("ru = 'Этапы производства изделия %НоменклатураХарактеристика%'");
		
		ЭтаФорма.Заголовок = СтрЗаменить(ТекстШаблона, "%НоменклатураХарактеристика%", 
											НоменклатураКлиентСервер.ПредставлениеНоменклатуры(Параметры.Номенклатура, Параметры.Характеристика));
		
	Иначе
		
		ЭтаФорма.Заголовок = НСтр("ru = 'Этапы производства'");
		
	КонецЕсли;
	
	Если Параметры.Свойство("Этапы")
		И ЗначениеЗаполнено(Параметры.Этапы) Тогда
	
		СписокЭтапов = Параметры.Этапы;
		
	ИначеЕсли Параметры.Свойство("Адрес")
		И ЭтоАдресВременногоХранилища(Параметры.Адрес) Тогда
		
		СписокЭтапов = ПолучитьИзВременногоХранилища(Параметры.Адрес);
		
		Этапы.Загрузить(СписокЭтапов);
		
		Элементы.ФормаПоказатьВсе.Пометка = Этапы.НайтиСтроки(Новый Структура("КоличествоИзделияДостаточно", Истина)).ВГраница() = -1;
		
	КонецЕсли;
	
	ИдентификаторТекущейСтроки = Неопределено;
	
	Если ЗначениеЗаполнено(СписокЭтапов) 
		И Параметры.Свойство("ТекущийЭтап") Тогда
		
		ТекущийЭтап = Параметры.ТекущийЭтап;
	
		Для Каждого Строка Из СписокЭтапов Цикл
			
			НоваяСтрока = Этапы.Добавить();
			
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
			
			Если Строка.КлючСвязи = ТекущийЭтап Тогда
				ИдентификаторТекущейСтроки = НоваяСтрока.ПолучитьИдентификатор();
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если ИдентификаторТекущейСтроки <> Неопределено Тогда
		
		Элементы.Этапы.ТекущаяСтрока = ИдентификаторТекущейСтроки;
		
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЭтапы

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма, Действие = "")
	
	ЭлементыФормы = Форма.Элементы;
	
	ВсеДействия = ПустаяСтрока(Действие);
	
	ВыборЭтапаВыпускаПолуфабриката = (Форма.ВыполняемаяОперация = "ВыборЭтапаВыпускаПолуфабриката");
	
	Если ВсеДействия Тогда
		
		ЭлементыФормы.ФормаПоказатьВсе.Видимость = ВыборЭтапаВыпускаПолуфабриката И Форма.Этапы.Количество() > 0;
		
		ЭлементыФормы.ЭтапыГруппаКоличествоИзделия.Видимость = ВыборЭтапаВыпускаПолуфабриката;
		ЭлементыФормы.ЭтапыГруппаКоличествоЭтапа.Видимость = НЕ ВыборЭтапаВыпускаПолуфабриката;
		
	КонецЕсли;
	
	Если ВыборЭтапаВыпускаПолуфабриката Тогда
		
		Если ВсеДействия Или Действие = "УстановитьОтборСтрок" Тогда
			
			Если ЭлементыФормы.ФормаПоказатьВсе.Пометка Тогда
				ОтборСтрок = Новый ФиксированнаяСтруктура;
			Иначе
				ОтборСтрок = Новый ФиксированнаяСтруктура("КоличествоИзделияДостаточно", Истина);
			КонецЕсли;
			
			ЭлементыФормы.Этапы.ОтборСтрок = ОтборСтрок;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьВсе(Команда)
	
	Элементы.ФормаПоказатьВсе.Пометка = Не Элементы.ФормаПоказатьВсе.Пометка;
	
	УправлениеФормой(ЭтаФорма, "УстановитьОтборСтрок");
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Этапы.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		
		Если ТекущиеДанные.ЭтапВыполнен Тогда
			ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Нельзя выбрать выполненный этап производства.'"));
			Возврат;
		КонецЕсли;
		
		ЗначениеВыбора = Новый Структура;
		ЗначениеВыбора.Вставить("КлючСвязиЭтапы", ТекущиеДанные.КлючСвязи);
		ЗначениеВыбора.Вставить("КлючСвязиЭтапыСтрока", Строка(ТекущиеДанные.КлючСвязи));
		ЗначениеВыбора.Вставить("Этап", ТекущиеДанные.Этап);
		ЗначениеВыбора.Вставить("НаименованиеЭтапа", ТекущиеДанные.НаименованиеЭтапа);
		ЗначениеВыбора.Вставить("НаименованиеПолуфабриката", ТекущиеДанные.НаименованиеПолуфабриката);
		ЗначениеВыбора.Вставить("ПроизводствоНаСтороне", ТекущиеДанные.ПроизводствоНаСтороне);
		ЗначениеВыбора.Вставить("Подразделение", ТекущиеДанные.Подразделение);
		
		ОповеститьОВыборе(Новый Структура("ВыполняемаяОперация, ЗначениеВыбора", ВыполняемаяОперация, ЗначениеВыбора));
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЭтапыНомерЭтапа.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЭтапыНомерСледующегоЭтапа.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЭтапыЭтап.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЭтапыПодразделение.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЭтапыКоличество.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Этапы.ЭтапВыполнен");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВыполняемаяОперация");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = "ВыборЭтапаПроизводства";

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);

	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Этапы.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Этапы.КоличествоИзделияДостаточно");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВыполняемаяОперация");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = "ВыборЭтапаВыпускаПолуфабриката";
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);
	
КонецПроцедуры

#КонецОбласти
