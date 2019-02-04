
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ДанныеОбъекта = Справочники.ЭлементыФинансовыхОтчетов.ФормаПриСозданииНаСервере(ЭтаФорма);
	ИдентификаторГлавногоХранилища = Параметры.ИдентификаторГлавногоХранилища;
	ВидПоказателей = Параметры.ВидПоказателей;
	
	Если Параметры.Свойство("НастройкаЯчеек") Тогда
		АдресЭлементовОтчета = Параметры.АдресЭлементовОтчета;
		АдресТаблицыЭлементов = Параметры.АдресТаблицыЭлементов;
	КонецЕсли;
	
	ОбновитьДеревоНовыхЭлементов();
	
	ДеревоОператоров = ФинансоваяОтчетностьВызовСервера.ПостроитьДеревоОператоров();
	ЗначениеВРеквизитФормы(ДеревоОператоров, "Операторы");
	//++ НЕ УТКА
	ДанныеЗаполнения = МеждународнаяОтчетностьКлиентСервер.НовыеДанныеЗаполненияСтроки();
	Для Каждого СтрокаОперанда Из ДанныеОбъекта.ОперандыФормулы Цикл
		НоваяСтрока = Операнды.Добавить();
		НоваяСтрока.ЭлементОтчета = СтрокаОперанда.Операнд;
		НоваяСтрока.Идентификатор = СтрокаОперанда.Идентификатор;
		Если ТипЗнч(СтрокаОперанда) = Тип("СтрокаТаблицыЗначений") Тогда
			НоваяСтрока.АдресСтруктурыЭлемента = СтрокаОперанда.АдресСтруктурыЭлемента;
		Иначе
			НоваяСтрока.АдресСтруктурыЭлемента = ФинансоваяОтчетностьВызовСервера.ПоместитьЭлементВХранилище(СтрокаОперанда.Операнд, Параметры.ИдентификаторГлавногоХранилища);
		КонецЕсли;
		Если ЗначениеЗаполнено(НоваяСтрока.АдресСтруктурыЭлемента) Тогда
			ДанныеЭлемента = ПолучитьИзВременногоХранилища(НоваяСтрока.АдресСтруктурыЭлемента);
		Иначе
			ДанныеЭлемента = НоваяСтрока.ЭлементОтчета;
		КонецЕсли;
		ДанныеЗаполнения.Источник = ДанныеЭлемента;
		ДанныеЗаполнения.СтрокаПриемник = НоваяСтрока;
		ДанныеЗаполнения.АдресЭлементаВХранилище = НоваяСтрока.АдресСтруктурыЭлемента;
		ФинансоваяОтчетностьКлиентСервер.ЗаполнитьСтрокуДерева(ДанныеЗаполнения);
		ДопСтрокаПоиска = "";
		Если ТипЗнч(НоваяСтрока.СчетПоказательИзмерение) = Тип("ПланСчетовСсылка.Хозрасчетный") Тогда
			ДопСтрокаПоиска = "Регл";
		КонецЕсли;
		НоваяСтрока.НестандартнаяКартинка = ФинансоваяОтчетностьПовтИсп.НестандартнаяКартинка(НоваяСтрока.ВидЭлемента, ДопСтрокаПоиска);
	КонецЦикла;
	//-- НЕ УТКА
	
	Элементы.ГруппаДопРеквизиты.Видимость = Параметры.ПоказатьКодСтрокиПримечание;
	ОбновитьЗаголовокФормы();

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РазделыОператоров = Операторы.ПолучитьЭлементы();
	Если РазделыОператоров.Количество() > 0 Тогда
		Элементы.Операторы.Развернуть(РазделыОператоров[0].ПолучитьИдентификатор());
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	//++ НЕ УТКА
	ПроверитьФормулуСервер(Отказ);
	Если НЕ Отказ Тогда
		ДопРежим = Перечисления.ДополнительныеРежимыЭлементовОтчетов.ВидОтчета;
		Справочники.ЭлементыФинансовыхОтчетов.ФормаПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект, Отказ, ДопРежим);
		Если ЗначениеЗаполнено(ЭтаФорма.АдресЭлементаВХранилище) Тогда
			СтруктураЭлемента = ПолучитьИзВременногоХранилища(ЭтаФорма.АдресЭлементаВХранилище);
			СтруктураЭлемента.ОперандыФормулы.Очистить();
			Для Каждого СтрокаОперанда Из Операнды Цикл
				Если Не ЗначениеЗаполнено(СтрокаОперанда.АдресСтруктурыЭлемента) Тогда
					АдресЭлемента = МеждународнаяОтчетностьКлиентСервер.ПоместитьЭлементВХранилище(СтрокаОперанда, ИдентификаторГлавногоХранилища);
					СтрокаОперанда.АдресСтруктурыЭлемента = АдресЭлемента;
				КонецЕсли;
				ЗаполнитьЗначенияСвойств(СтруктураЭлемента.ОперандыФормулы.Добавить(), СтрокаОперанда);
			КонецЦикла;
			ПоместитьВоВременноеХранилище(СтруктураЭлемента, ЭтаФорма.АдресЭлементаВХранилище);
		КонецЕсли;
	КонецЕсли;
	//-- НЕ УТКА
	Возврат;// в УТ11 обработчик пустой
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ОбновитьЗаголовокФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(АдресЭлементаВХранилище) Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		ВидОтчета = ВыбранноеЗначение;
		ОбновитьДеревоСохраненныхЭлементов();
	КонецЕсли;
	//++ НЕ УТКА
	МеждународнаяОтчетностьКлиент.РазвернутьДеревоСохраненныхЭлементов(ЭтаФорма, ДеревоСохраненныхЭлементов);
	//-- НЕ УТКА
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НаименованиеДляПечатиПриИзменении(Элемент)
	
	Объект.Наименование = Объект.НаименованиеДляПечати;
	
КонецПроцедуры

&НаКлиенте
Процедура КоментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования, 
		ЭтотОбъект, 
		"Объект.Комментарий");
	
КонецПроцедуры

&НаКлиенте
Процедура БыстрыйПоискНовыхПриИзменении(Элемент)

	ОбновитьДеревоНовыхЭлементов();

КонецПроцедуры

&НаКлиенте
Процедура БыстрыйПоискСохранненыхПриИзменении(Элемент)

	ОбновитьДеревоСохраненныхЭлементов();

КонецПроцедуры

&НаКлиенте
Процедура ВидОтчетаПриИзменении(Элемент)
	
	ОбновитьДеревоСохраненныхЭлементов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОператоры

&НаКлиенте
Процедура ОператорыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВставитьОператорВФормулу();
	
КонецПроцедуры

&НаКлиенте
Процедура ОператорыНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	Если ЗначениеЗаполнено(Элемент.ТекущиеДанные.Оператор) Тогда
		ПараметрыПеретаскивания.Значение = Элемент.ТекущиеДанные.Оператор;
	Иначе
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоновыхэлементов

&НаКлиенте
Процедура ДеревоНовыхЭлементовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ВыбранныеОперанды = Новый Массив;
	ВыбранныеОперанды.Добавить(Элемент.ТекущиеДанные);
	//++ НЕ УТКА
	МеждународнаяОтчетностьКлиент.ДобавитьОперандыФормулы(ЭтаФорма,ВыбранныеОперанды,Операнды);
	//-- НЕ УТКА
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоНовыхЭлементовНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	Индекс = 0;
	Пока Индекс < ПараметрыПеретаскивания.Значение.Количество() Цикл
		
		Ид = ПараметрыПеретаскивания.Значение[Индекс];
		Операнд = ДеревоНовыхЭлементов.НайтиПоИдентификатору(Ид);
		Если Операнд.ЭтоГруппа Тогда
			ПараметрыПеретаскивания.Значение.Удалить(Индекс);
			Продолжить;
		КонецЕсли;
		Индекс = Индекс + 1;
		
	КонецЦикла;
	
	Если ПараметрыПеретаскивания.Значение.Количество() = 0 Тогда
		Выполнение = Ложь;
	КонецЕсли;

	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоНовыхЭлементовОкончаниеПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	//++ НЕ УТКА
	НовыеОперанды = МеждународнаяОтчетностьКлиент.ДобавитьОперандыФормулы(ЭтаФорма, ПараметрыПеретаскивания.Значение, Операнды);
	ФинансоваяОтчетностьКлиент.ДобавитьТекстФормулы(ЭтаФорма, НовыеОперанды);
	//-- НЕ УТКА
	Возврат;// в УТ11 обработчик пустой
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревосохраненныхэлементов

&НаКлиенте
Процедура ДеревоСохраненныхЭлементовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	//++ НЕ УТКА
	ВыбранныеОперанды = Новый Массив;
	ВыбранныеОперанды.Добавить(Элемент.ТекущиеДанные);
	МеждународнаяОтчетностьКлиент.ДобавитьОперандыФормулы(ЭтаФорма,ВыбранныеОперанды,Операнды);
	//-- НЕ УТКА
	Возврат;// в УТ11 обработчик пустой
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоСохраненныхЭлементовОкончаниеПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	//++ НЕ УТКА
	МеждународнаяОтчетностьКлиент.ДобавитьОперандыФормулы(ЭтаФорма,ПараметрыПеретаскивания.Значение,Операнды);
	//-- НЕ УТКА
	Возврат;// в УТ11 обработчик пустой
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОперанды

&НаКлиенте
Процедура ОперандыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя <> "ПоказателиИдентификатор" Тогда
		РедактироватьПоказатель();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОперандыОкончаниеПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	ФинансоваяОтчетностьКлиент.ДобавитьТекстФормулы(ЭтаФорма,ПараметрыПеретаскивания.Значение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОперандыПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	//++ НЕ УТКА
	МеждународнаяОтчетностьКлиент.ДобавитьОперандыФормулы(ЭтаФорма,ПараметрыПеретаскивания.Значение,Операнды);
	//-- НЕ УТКА
	// чтобы не срабатывало события окончания перетаскивания дерева новых элементов
	ПараметрыПеретаскивания.Значение.Очистить();
	
КонецПроцедуры

&НаКлиенте
Процедура ОперандыИдентификаторОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	Текст = СокрЛП(Текст);
	НовыйИд = "[" + Текст + "]";
	СтарыйИд = "[" + Элементы.Операнды.ТекущиеДанные.Идентификатор + "]";
	Формула = СтрЗаменить(Формула, СтарыйИд, НовыйИд);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗавершитьРедактирование(Команда)
	
	ФинансоваяОтчетностьКлиент.ЗавершитьРедактированиеЭлементаОтчета(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура НайтиНовыйЭлемент(Команда)
	
	ОбновитьДеревоНовыхЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура НайтиСохраненныйЭлемент(Команда)
	
	ОбновитьДеревоСохраненныхЭлементов();
	//++ НЕ УТКА
	МеждународнаяОтчетностьКлиент.РазвернутьДеревоСохраненныхЭлементов(ЭтаФорма, ДеревоСохраненныхЭлементов);
	//-- НЕ УТКА
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьФормулу(Команда)
	
	ОчиститьСообщения();
	Отказ = Ложь;
	ПроверитьФормулуСервер(Отказ);
	Если НЕ Отказ Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Синтаксических ошибок не обнаружено!'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьОперанд(Команда)
	
	РедактироватьПоказатель();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОперандыТипИтога.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Операнды.НачальноеСальдо");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Операнды.ТипИтога");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ТипыИтогов.Сальдо;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Операнды.ВидЭлемента");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ВидыЭлементовФинансовогоОтчета.МонетарныйПоказатель;

	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Начальное сальдо'"));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОперандыТипИтога.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Операнды.НачальноеСальдо");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Операнды.ТипИтога");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ТипыИтогов.СальдоДт;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Операнды.ВидЭлемента");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ВидыЭлементовФинансовогоОтчета.МонетарныйПоказатель;

	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Начальное сальдо Дт'"));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОперандыТипИтога.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Операнды.НачальноеСальдо");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Операнды.ТипИтога");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ТипыИтогов.СальдоКт;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Операнды.ВидЭлемента");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ВидыЭлементовФинансовогоОтчета.МонетарныйПоказатель;

	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Начальное сальдо Кт'"));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОперандыТипИтога.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Операнды.НачальноеСальдо");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Операнды.ТипИтога");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ТипыИтогов.Сальдо;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Операнды.ВидЭлемента");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ВидыЭлементовФинансовогоОтчета.МонетарныйПоказатель;

	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Конечное сальдо'"));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОперандыТипИтога.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Операнды.НачальноеСальдо");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Операнды.ТипИтога");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ТипыИтогов.СальдоДт;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Операнды.ВидЭлемента");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ВидыЭлементовФинансовогоОтчета.МонетарныйПоказатель;

	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Конечное сальдо Дт'"));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОперандыТипИтога.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Операнды.НачальноеСальдо");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Операнды.ТипИтога");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ТипыИтогов.СальдоКт;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Операнды.ВидЭлемента");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ВидыЭлементовФинансовогоОтчета.МонетарныйПоказатель;

	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Конечное сальдо Кт'"));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОперандыТипИтога.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Операнды.ВидЭлемента");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ВидыЭлементовФинансовогоОтчета.МонетарныйПоказатель;

	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", ""); 

КонецПроцедуры

&НаСервере 
Процедура ОбновитьДеревоНовыхЭлементов()
	
	//++ НЕ УТКА
	ПараметрыДерева = МеждународнаяОтчетностьКлиентСервер.НовыеПараметрыДереваЭлементов();
	ПараметрыДерева.ВидПоказателей = ВидПоказателей;
	ПараметрыДерева.РежимРаботы = Неопределено;
	ПараметрыДерева.БыстрыйПоиск = БыстрыйПоискНовых;
	
	МеждународнаяОтчетностьСервер.ОбновитьДеревоНовыхЭлементов(ЭтаФорма, ПараметрыДерева);
	//-- НЕ УТКА
	Возврат;// в УТ11 обработчик пустой
	
КонецПроцедуры

&НаСервере 
Процедура ОбновитьДеревоСохраненныхЭлементов()
	
	Если НЕ ЗначениеЗаполнено(БыстрыйПоискСохраненных)
		И НЕ ЗначениеЗаполнено(ФильтрПоВидуОтчета) Тогда
		СохраненныеЭлементы = ДеревоСохраненныхЭлементов.ПолучитьЭлементы();
		СохраненныеЭлементы.Очистить();
		Возврат;
	КонецЕсли;
	//++ НЕ УТКА
	ПараметрыДерева = МеждународнаяОтчетностьКлиентСервер.НовыеПараметрыДереваЭлементов();
	ПараметрыДерева.ИмяЭлементаДерева = "ДеревоСохраненныхЭлементов";
	ПараметрыДерева.ВидПоказателей = ВидПоказателей;
	ПараметрыДерева.РежимРаботы = Перечисления.РежимыОтображенияДереваНовыхЭлементов.НастройкаВидаОтчетаТолькоПоказатели;
	ПараметрыДерева.БыстрыйПоиск = БыстрыйПоискСохраненных;
	ПараметрыДерева.ФильтрПоВидуОтчета = ФильтрПоВидуОтчета;
	
	МеждународнаяОтчетностьСервер.ОбновитьДеревоСохраненныхЭлементов(ЭтаФорма, ПараметрыДерева);
	//-- НЕ УТКА
	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьПоказатель()
	
	ВыделенныеСтроки = ОбщегоНазначенияУТКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Операнды);
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Операнды.ТекущиеДанные;
	//++ НЕ УТКА
	Если ПустаяСтрока(ТекущиеДанные.АдресСтруктурыЭлемента) Тогда
		ТекущиеДанные.АдресСтруктурыЭлемента = МеждународнаяОтчетностьКлиентСервер.ПоместитьЭлементВХранилище(ТекущиеДанные, ИдентификаторГлавногоХранилища);
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ИдентификаторСтрокиОперанда",		ТекущиеДанные.ПолучитьИдентификатор());
	ПараметрыФормы.Вставить("Ключ", 							ТекущиеДанные.ЭлементОтчета);
	ПараметрыФормы.Вставить("ВидЭлемента", 						ТекущиеДанные.ВидЭлемента);
	ПараметрыФормы.Вставить("АдресЭлементаВХранилище", 			ТекущиеДанные.АдресСтруктурыЭлемента);
	ПараметрыФормы.Вставить("ИдентификаторГлавногоХранилища", 	ИдентификаторГлавногоХранилища);
	ПараметрыФормы.Вставить("АдресЭлементовОтчета", 			АдресЭлементовОтчета);
	ПараметрыФормы.Вставить("АдресТаблицыЭлементов", 			АдресТаблицыЭлементов);
	ПараметрыФормы.Вставить("АдресРедактируемогоЭлемента", 		АдресЭлементаВХранилище);
	ПараметрыФормы.Вставить("ПоказатьКодСтрокиПримечание", 		Ложь);
	
	Оповещение = Новый ОписаниеОповещения("ОбновитьСтрокуОперандаПослеИзменения", ЭтаФорма, ПараметрыФормы);
	
	ОткрытьФорму("Справочник.ЭлементыФинансовыхОтчетов.ФормаОбъекта",
				ПараметрыФормы, ЭтаФорма, , , , Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	//-- НЕ УТКА

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСтрокуОперандаПослеИзменения(Результат, ДополнительныеПараметры) Экспорт
	
	//++ НЕ УТКА
	ДанныеЗаполнения = МеждународнаяОтчетностьКлиентСервер.НовыеДанныеЗаполненияСтроки();
	ДанныеЗаполнения.Источник = Результат;
	ДанныеЗаполнения.СтрокаПриемник = ДополнительныеПараметры.ИдентификаторСтрокиОперанда;
	ДанныеЗаполнения.АдресЭлементаВХранилище = ДополнительныеПараметры.АдресЭлементаВХранилище;
	ДанныеЗаполнения.Поле = Операнды;
	
	ФинансоваяОтчетностьКлиентСервер.ЗаполнитьСтрокуДерева(ДанныеЗаполнения);
	//-- НЕ УТКА
	Возврат;// в УТ11 обработчик пустой
	
КонецПроцедуры

&НаКлиенте
Процедура ВставитьОператорВФормулу()
	
	Если ЗначениеЗаполнено(Элементы.Операторы.ТекущиеДанные.Оператор) Тогда
		ТекстДляВставки = Элементы.Операторы.ТекущиеДанные.Оператор;
		Если Элементы.Операторы.ТекущиеДанные.Наименование = "( )" 
			И ЗначениеЗаполнено(Элементы.Формула.ВыделенныйТекст) Тогда
			ТекстДляВставки = "(" + Элементы.Формула.ВыделенныйТекст + ")";
		КонецЕсли;
		Элементы.Формула.ВыделенныйТекст = ТекстДляВставки;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьФормулуСервер(Отказ)
	
	//++ НЕ УТКА
	МеждународнаяОтчетностьВызовСервера.ПроверитьФормулу(Формула, Операнды.Выгрузить(),Отказ,"Формула","Объект.Формула");
	//-- НЕ УТКА
	Возврат;// в УТ11 обработчик пустой
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЗаголовокФормы(Запись = Ложь)
	
	Если НЕ ЗначениеЗаполнено(Объект.НаименованиеДляПечати) Тогда
		ЭтаФорма.Заголовок = НСтр("ru = 'Производный показатель (создание)'");
	Иначе
		ЭтаФорма.Заголовок = Объект.НаименованиеДляПечати + НСтр("ru = ' (Производный показатель)'");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
