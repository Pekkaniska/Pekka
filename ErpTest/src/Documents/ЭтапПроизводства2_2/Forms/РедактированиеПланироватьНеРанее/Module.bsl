
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Ссылка = Параметры.Ссылка;
	Распоряжение = Параметры.Распоряжение;
	Элементы.РезультатДата.ФорматРедактирования = Параметры.ФорматДатыГрафика;
	
	Если ЗначениеЗаполнено(Параметры.ПланироватьНеРанее) Тогда
		
		Если ТипЗнч(Параметры.ПланироватьНеРанее) = Тип("Дата") Тогда
			
			Режим = РежимДата();
			РезультатДата = Параметры.ПланироватьНеРанее;
			
		Иначе
			
			Режим = РежимЭтап();
			РезультатЭтап = Параметры.ПланироватьНеРанее;
			РезультатЭтапПредставление = ПредставлениеЭтапа(РезультатЭтап);
			
		КонецЕсли;
		
	КонецЕсли;
	
	УправлениеДоступностью(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(
		Новый ОписаниеОповещения("ПередЗакрытиемПрименитьИЗакрыть", ЭтотОбъект),
		Отказ,
		ЗавершениеРаботы,
		НСтр("ru = 'Данные были изменены. Применить изменения?'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемПрименитьИЗакрыть(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	ПеренестиИзмененияВДокумент();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если Режим = РежимДата() Тогда
		МассивНепроверяемыхРеквизитов.Добавить("РезультатЭтапПредставление");
	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("РезультатДата");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(
		ПроверяемыеРеквизиты,
		МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Применить(Команда)
	
	ПеренестиИзмененияВДокумент();
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура РежимПриИзменении(Элемент)
	
	Если Режим = РежимДата() Тогда
		ОчиститьРезультатЭтап(ЭтаФорма);
	Иначе
		РезультатДата = Неопределено;
	КонецЕсли;
	
	УправлениеДоступностью(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатЭтапПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Отбор = Новый Структура;
	Отбор.Вставить("ПометкаУдаления", Ложь);
	
	Если РезультатЭтап.Пустая()
		ИЛИ РаспоряжениеЭтапа(РезультатЭтап) = Распоряжение Тогда
		Отбор.Вставить("Распоряжение", Распоряжение);
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТекущаяСтрока", РезультатЭтап);
	ПараметрыФормы.Вставить("Отбор", Отбор);
	ПараметрыФормы.Вставить("СсылкаИсключить", Ссылка);
	
	ОткрытьФорму(
		"Документ.ЭтапПроизводства2_2.ФормаВыбора",
		ПараметрыФормы,
		ЭтаФорма,,,,
		Новый ОписаниеОповещения("ЭтапВыборЗавершение", ЭтотОбъект),
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтапВыборЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт

	Если РезультатЗакрытия <> Неопределено Тогда
		
		РезультатЭтап = РезультатЗакрытия;
		РезультатЭтапПредставление = ПредставлениеЭтапа(РезультатЭтап);
		
		Модифицированность = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатЭтапПредставлениеОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОчиститьРезультатЭтап(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатЭтапПредставлениеОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(РезультатЭтап) Тогда
		ПоказатьЗначение(, РезультатЭтап);
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
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.РезультатДата.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Режим");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = РежимЭтап();
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.РезультатЭтапПредставление.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Режим");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = РежимДата();
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция УправлениеДоступностью(Форма)
	
	Форма.Элементы.РезультатДата.Доступность = (Форма.Режим = РежимДата());
	Форма.Элементы.РезультатЭтапПредставление.Доступность = (Форма.Режим = РежимЭтап());
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция РежимДата()
	
	Возврат 0;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция РежимЭтап()
	
	Возврат 1;
	
КонецФункции

&НаКлиенте
Процедура ПеренестиИзмененияВДокумент()
	
	Если ПроверитьЗаполнение() Тогда
		
		Если Режим = РежимДата() Тогда
			Результат = РезультатДата;
		Иначе
			Результат = РезультатЭтап;
		КонецЕсли;
		
		Модифицированность = Ложь;
		Закрыть(Результат);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПредставлениеЭтапа(Этап)
	
	Возврат Документы.ЭтапПроизводства2_2.ПредставлениеЭтапа(Этап);
	
КонецФункции

&НаСервереБезКонтекста
Функция РаспоряжениеЭтапа(Этап)
	
	Возврат Общегоназначения.ЗначениеРеквизитаОбъекта(Этап, "Распоряжение");
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОчиститьРезультатЭтап(Форма)
	
	Форма.РезультатЭтап = Неопределено;
	Форма.РезультатЭтапПредставление = "";
	
	Форма.Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти
