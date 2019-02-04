#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
   		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	ДополнительныеПараметры.Вставить("ОтложеннаяИнициализация", Истина);
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриЧтенииСозданииНаСервере();
	
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если НЕ СинхроннаяЗагрузка Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ВремяРаботыПриСинхроннойЗагрузке");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	// Проверка реквизитов вида операции
	НомерСтроки = 1;
	
	Для каждого Строка Из ДопРеквизиты Цикл
		
		Если Строка.ЗначениеМин > Строка.ЗначениеМакс И Строка.ЗначениеМакс <> 0 Тогда
			
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Минимальное значение реквизита ""%1"" превышает максимальное значение'"),
				Строка.Заголовок);
				
			Путь = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ДопРеквизиты", НомерСтроки, "ЗначениеМин");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, Путь,, Отказ);
			
		КонецЕсли;
		
		НомерСтроки = НомерСтроки + 1;
		
	КонецЦикла;
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ЗагрузитьНормативыВидаОперации(ТекущийОбъект, ДопРеквизиты);
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ТехнологическиеОперации", ПараметрыЗаписи);

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ВариантыНаладки" ИЛИ ИмяСобытия = "Запись_ВидыРабочихЦентров" Тогда
		ПрочитатьРеквизитыРабочегоЦентра();
	КонецЕсли;
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	// СтандартныеПодсистемы.Свойства
	Если ТекущаяСтраница.Имя = "ГруппаДополнительныеРеквизиты"
		И Не ЭтотОбъект.ПараметрыСвойств.ВыполненаОтложеннаяИнициализация Тогда
		
		СвойстваВыполнитьОтложеннуюИнициализацию();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
		
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура РабочийЦентрПриИзменении(Элемент)
	
	РабочийЦентрПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантНаладкиПриИзменении(Элемент)
	
	ВариантНаладкиПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантНаладкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Объект.РабочийЦентр) Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ПараметрыФормы = Новый Структура;
		
		НастройкиОтбора = Новый Структура("Владелец", ВидРабочегоЦентра(Объект.РабочийЦентр));
		ПараметрыФормы.Вставить("Отбор", НастройкиОтбора);
		
		Если ЗначениеЗаполнено(Объект.ВариантНаладки) Тогда
			ПараметрыФормы.Вставить("ТекущаяСтрока", Объект.ВариантНаладки);
		КонецЕсли;
		
		ОткрытьФорму("Справочник.ВариантыНаладки.ФормаВыбора", ПараметрыФормы, Элемент);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоПриИзменении(Элемент)
	
	ЗаполнитьПодсказкуВводаЕдиницыИзмерения(ЭтотОбъект);
	ЗаполнитьЕдиницуИзмеренияПередаточнойПартии(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЕдиницаИзмеренияПриИзменении(Элемент)
	
	ЗаполнитьЕдиницуИзмеренияПередаточнойПартии(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередаточнаяПартияПриИзменении(Элемент)
	
	ЗаполнитьЕдиницуИзмеренияПередаточнойПартии(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидОперацииПриИзменении(Элемент)
	
	Если Объект.ВидОперации <> КешРеквизитов.ВидОперации Тогда
		
		КешРеквизитов.ВидОперации = Объект.ВидОперации;
		
		ДопРеквизиты.Очистить();
		ДопРеквизитыКоличество = ДопРеквизиты.Количество();
		
		Объект.НормативыВидаОперации.Очистить();
		
	ИначеЕсли НЕ Объект.ВидОперации.Пустая() Тогда
		
		ЗагрузитьНормативыВидаОперации(Объект, ДопРеквизиты);
		
	КонецЕсли;
	
	ПрочитатьРеквизитыВидаОперации();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДопРеквизиты

&НаКлиенте
Процедура ДопРеквизитыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "ДопРеквизитыЗаголовок" Тогда
		
		СтандартнаяОбработка = Ложь;
	
		ПоказатьЗначение(, Элементы.ДопРеквизиты.ТекущиеДанные.Свойство);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДопРеквизитыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ТекущиеДанные = Элементы.ДопРеквизиты.ТекущиеДанные;
	
	Элементы.ДопРеквизитыЗначениеМин.ФорматРедактирования = ТекущиеДанные.Формат;
	Элементы.ДопРеквизитыЗначениеМакс.ФорматРедактирования = ТекущиеДанные.Формат;
	
КонецПроцедуры

&НаКлиенте
Процедура ДопРеквизитыЗначениеМинПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
	ТекущиеДанные = Элементы.ДопРеквизиты.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено
		И ТекущиеДанные.ТипЗначения.КвалификаторыЧисла.ДопустимыйЗнак = ДопустимыйЗнак.Неотрицательный
		И ТекущиеДанные.ЗначениеМин < 0 Тогда
		
		ТекущиеДанные.ЗначениеМин = -ТекущиеДанные.ЗначениеМин;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДопРеквизитыЗначениеМаксПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
	ТекущиеДанные = Элементы.ДопРеквизиты.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено
		И ТекущиеДанные.ТипЗначения.КвалификаторыЧисла.ДопустимыйЗнак = ДопустимыйЗнак.Неотрицательный
		И ТекущиеДанные.ЗначениеМакс < 0 Тогда
		
		ТекущиеДанные.ЗначениеМакс = -ТекущиеДанные.ЗначениеМакс;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область СтандартныеПодсистемы_Свойства

&НаСервере
Процедура СвойстваВыполнитьОтложеннуюИнициализацию()
	
	УправлениеСвойствами.ЗаполнитьДополнительныеРеквизитыВФорме(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	// Инициализация служебных реквизитов.
	СтатусВладельца = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Владелец, "Статус");
	ДоступностьЭлементов = (СтатусВладельца = Перечисления.СтатусыМаршрутныхКарт.ВРазработке);
	
	ПрочитатьРеквизитыРабочегоЦентра();
	НастроитьВидимостьДоступностьПриЧтенииСоздании();
	НастроитьПараметрыВыбораРабочихЦентров();
	ПрочитатьРеквизитыВидаОперации();
	
	Если Объект.СодержитВложенныйМаршрут Тогда
		// Выполняется смена вида операции
		Объект.СодержитВложенныйМаршрут = Ложь;
		Объект.РабочийЦентр = Неопределено;
		Объект.ВариантНаладки = Неопределено;
		Объект.ВидОперации = Неопределено;
		Объект.ВремяШтучное = 0;
		Объект.ВремяПЗ = 0;
		Объект.Загрузка = 0;
		Объект.Непрерывная = Ложь;
		Объект.МожноПовторить = Ложь;
		Объект.МожноПропустить = Ложь;
		Объект.ВспомогательныеРабочиеЦентры.Очистить();
		Объект.НормативыВидаОперации.Очистить();
		Модифицированность = Истина;
	КонецЕсли;
	
	ЗаполнитьПодсказкуВводаЕдиницыИзмерения(ЭтотОбъект);
	ЗаполнитьЕдиницуИзмеренияПередаточнойПартии(ЭтотОбъект);
	
	КешРеквизитов = Новый Структура("ВидОперации", Объект.ВидОперации);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьВидимостьДоступностьПриЧтенииСоздании()
	
	Если НЕ ТолькоПросмотр Тогда
		
		Элементы.НомерОперации.ТолькоПросмотр = НЕ ДоступностьЭлементов;
		Элементы.НомерСледующейОперации.ТолькоПросмотр = НЕ ДоступностьЭлементов;
		Элементы.РабочийЦентр.ТолькоПросмотр = НЕ ДоступностьЭлементов;
		Элементы.ВариантНаладки.Доступность = ДоступностьЭлементов;
		Элементы.ВремяШтучное.ТолькоПросмотр = НЕ ДоступностьЭлементов;
		Элементы.ВремяШтучноеЕдИзм.ТолькоПросмотр = НЕ ДоступностьЭлементов;
		Элементы.ВремяПЗ.ТолькоПросмотр = НЕ ДоступностьЭлементов;
		Элементы.ВремяПЗЕдИзм.ТолькоПросмотр = НЕ ДоступностьЭлементов;
		Элементы.Загрузка.ТолькоПросмотр = НЕ ДоступностьЭлементов;
		Элементы.Непрерывная.ТолькоПросмотр = НЕ ДоступностьЭлементов;
		Элементы.ВспомогательныеРабочиеЦентры.ТолькоПросмотр = НЕ ДоступностьЭлементов;
		Элементы.ВариантНаладки.Доступность = ДоступностьЭлементов И ИспользуютсяВариантыНаладки;
		Элементы.Количество.ТолькоПросмотр = НЕ ДоступностьЭлементов;
		Элементы.ЕдиницаИзмерения.ТолькоПросмотр = НЕ ДоступностьЭлементов;
		Элементы.МожноПовторить.ТолькоПросмотр = НЕ ДоступностьЭлементов;
		Элементы.МожноПропустить.ТолькоПросмотр = НЕ ДоступностьЭлементов;
		Элементы.ВидОперации.ТолькоПросмотр = НЕ ДоступностьЭлементов;
		
	КонецЕсли;
	
	НастройкиПодсистемы = ПроизводствоСервер.НастройкиПодсистемыПроизводство();
	
	ТолькоПроизводство22 = НастройкиПодсистемы.ИспользуетсяПроизводство22 И НЕ НастройкиПодсистемы.ИспользуетсяПроизводство21;
	
	Элементы.ГруппаКоличество.Видимость         = ТолькоПроизводство22;
	Элементы.ГруппаВыполнение.Видимость         = ТолькоПроизводство22;
	Элементы.ГруппаПередаточнаяПартия.Видимость = ТолькоПроизводство22
		И ПолучитьФункциональнуюОпцию("ИспользоватьПооперационноеПланирование");
	
	#Область ПараметрыПооперационногоПланирования
	
	Подразделение = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Владелец, "Подразделение");
	Если ЗначениеЗаполнено(Подразделение) Тогда
		ПараметрыПодразделения = ПроизводствоСервер.ПараметрыПроизводственногоПодразделения(Подразделение);
		ВидимостьПараметров = (ПараметрыПодразделения.ИспользоватьПооперационноеПланирование
									И НастройкиПодсистемы.ИспользуетсяПроизводство22
								ИЛИ ПараметрыПодразделения.УправлениеМаршрутнымиЛистами = Перечисления.УправлениеМаршрутнымиЛистами.ПооперационноеПланирование
									И НастройкиПодсистемы.ИспользуетсяПроизводство21);
	Иначе
		ВидимостьПараметров = Истина;
	КонецЕсли;
	
	Элементы.Непрерывная.Видимость                          = ВидимостьПараметров;
	Элементы.СтраницаВспомогательныеРабочиеЦентры.Видимость = ВидимостьПараметров;
	
	#КонецОбласти
	
	НастроитьВидимостьДоступностьПоРеквизитамРЦ();
	
КонецПроцедуры

&НаСервере
Процедура НастроитьВидимостьДоступностьПоРеквизитамРЦ()
	
	Если ДоступностьЭлементов Тогда
		Элементы.ВариантНаладки.Доступность = ИспользуютсяВариантыНаладки;
	КонецЕсли;
	
	Элементы.Загрузка.Видимость = ПараллельнаяЗагрузка;
	Элементы.ЕдиницаИзмеренияЗагрузки.Видимость = ПараллельнаяЗагрузка;
	
	Элементы.ВремяШтучное.Видимость = НЕ СинхроннаяЗагрузка;
	Элементы.ВремяШтучноеЕдИзм.Видимость = НЕ СинхроннаяЗагрузка;
	Элементы.ВремяПЗ.Видимость = НЕ СинхроннаяЗагрузка;
	Элементы.ВремяПЗЕдИзм.Видимость = НЕ СинхроннаяЗагрузка;
	
	Элементы.ВремяРаботыПриСинхроннойЗагрузке.Видимость = СинхроннаяЗагрузка;
	Элементы.ЕдиницаИзмеренияПриСинхроннойЗагрузке.Видимость = СинхроннаяЗагрузка;
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьЗначенияНедоступныхРеквизитов()
	
	Если НЕ Элементы.Загрузка.Видимость Тогда
		Объект.Загрузка = 0;
	КонецЕсли;
	Если НЕ Элементы.ВремяШтучное.Видимость Тогда
		Объект.ВремяШтучное = 0;
	КонецЕсли;
	Если НЕ Элементы.ВремяПЗ.Видимость Тогда
		Объект.ВремяПЗ = 0;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура РабочийЦентрПриИзмененииНаСервере()
	
	Если ЗначениеЗаполнено(Объект.РабочийЦентр) Тогда
		ПрочитатьРеквизитыРабочегоЦентра();
	Иначе
		ОчиститьРеквизитыРабочегоЦентра();
	КонецЕсли;
	
	НастроитьВидимостьДоступностьПоРеквизитамРЦ();
	ОчиститьЗначенияНедоступныхРеквизитов();
	
	ПроверитьКорректностьВариантаНаладки();
	
КонецПроцедуры

&НаСервере
Процедура ВариантНаладкиПриИзмененииНаСервере()
	
	Если РеквизитыЗависятОтВариантаНаладки() Тогда
		ПрочитатьРеквизитыВариантаНаладки();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьПараметрыВыбораРабочихЦентров()
	
	ИмяПараметра = "Отбор.Подразделение";
	ЗначениеПараметра = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Владелец, "Подразделение");
	
	НастроитьПараметрыВыбора(ИмяПараметра, ЗначениеПараметра, Элементы.РабочийЦентр);
	НастроитьПараметрыВыбора(ИмяПараметра, ЗначениеПараметра, Элементы.ВспомогательныеРабочиеЦентрыРабочийЦентр);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьПараметрыВыбора(ИмяПараметра, ЗначениеПараметра, ЭлементФормы)
	
	ПараметрыВыбораЭлемента = Новый Массив(ЭлементФормы.ПараметрыВыбора);
	
	Индекс = 0;
	Пока Индекс <= ПараметрыВыбораЭлемента.ВГраница() Цикл
		Если ПараметрыВыбораЭлемента[Индекс].Имя = ИмяПараметра Тогда
			ПараметрыВыбораЭлемента.Удалить(Индекс);
		Иначе
			Индекс = Индекс + 1;
		КонецЕсли;
	КонецЦикла;
	
	Если ЗначениеЗаполнено(ЗначениеПараметра) Тогда
		НовыйПараметр = Новый ПараметрВыбора(ИмяПараметра, ЗначениеПараметра);
		ПараметрыВыбораЭлемента.Добавить(НовыйПараметр);
	КонецЕсли;
	
	ЭлементФормы.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбораЭлемента);
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьРеквизитыРабочегоЦентра()
	
	Если ЗначениеЗаполнено(Объект.РабочийЦентр) Тогда
		
		Реквизиты = Новый Структура;
		Реквизиты.Вставить("ИспользуютсяВариантыНаладки", "ИспользуютсяВариантыНаладки");
		Реквизиты.Вставить("ПараллельнаяЗагрузка", "ПараллельнаяЗагрузка");
		Реквизиты.Вставить("ВремяРаботыПриСинхроннойЗагрузке", "ВремяРаботы");
		Реквизиты.Вставить("ЕдиницаИзмеренияПриСинхроннойЗагрузке", "ЕдиницаИзмерения");
		Реквизиты.Вставить("ЕдиницаИзмеренияЗагрузки", "ЕдиницаИзмеренияЗагрузки");
		Реквизиты.Вставить("ВариантЗагрузки", "ВариантЗагрузки");
		
		Если ТипЗнч(Объект.РабочийЦентр) = Тип("СправочникСсылка.РабочиеЦентры") Тогда
			Для каждого Элемент Из Реквизиты Цикл
				Реквизиты.Вставить(Элемент.Ключ, "ВидРабочегоЦентра." + Элемент.Значение);
			КонецЦикла;
		КонецЕсли;
		
		ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.РабочийЦентр, Реквизиты);
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЗначенияРеквизитов);
		
		Если ЗначенияРеквизитов.ВариантЗагрузки = Перечисления.ВариантыЗагрузкиРабочихЦентров.Синхронный Тогда
			СинхроннаяЗагрузка = Истина;
		Иначе
			СинхроннаяЗагрузка = Ложь;
		КонецЕсли;
		
		Если РеквизитыЗависятОтВариантаНаладки() Тогда
			ПрочитатьРеквизитыВариантаНаладки();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьРеквизитыРабочегоЦентра()
	
	ИспользуютсяВариантыНаладки = Ложь;
	ПараллельнаяЗагрузка = Ложь;
	СинхроннаяЗагрузка = Ложь;
	
	ВремяРаботыПриСинхроннойЗагрузке = 0;
	ЕдиницаИзмеренияПриСинхроннойЗагрузке = Перечисления.ЕдиницыИзмеренияВремени.ПустаяСсылка();
	ЕдиницаИзмеренияЗагрузки = "";
		
КонецПроцедуры

&НаСервере
Функция РеквизитыЗависятОтВариантаНаладки()

	Возврат СинхроннаяЗагрузка И ИспользуютсяВариантыНаладки;

КонецФункции

&НаСервере
Процедура ПрочитатьРеквизитыВариантаНаладки()
	
	Реквизиты = Новый Структура;
	Реквизиты.Вставить("ВремяРаботыПриСинхроннойЗагрузке", "ВремяРаботы");
	Реквизиты.Вставить("ЕдиницаИзмеренияПриСинхроннойЗагрузке", "ЕдиницаИзмерения");
	
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.ВариантНаладки, Реквизиты);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЗначенияРеквизитов);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ВидРабочегоЦентра(РабочийЦентр)
	
	Если ТипЗнч(РабочийЦентр) = Тип("СправочникСсылка.ВидыРабочихЦентров") Тогда
		
		Возврат РабочийЦентр;
		
	Иначе
		
		Возврат ЗначениеРеквизитаОбъекта(РабочийЦентр, "ВидРабочегоЦентра");
		
	КонецЕсли;
	
КонецФункции

&НаСервереБезКонтекста
Функция ЗначениеРеквизитаОбъекта(Ссылка, ИмяРеквизита)
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, ИмяРеквизита);
	
КонецФункции

&НаСервере
Процедура ПроверитьКорректностьВариантаНаладки()
	
	Если ЗначениеЗаполнено(Объект.ВариантНаладки) Тогда
		
		Если ЗначениеЗаполнено(Объект.РабочийЦентр) Тогда
			
			ВладелецВН = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.ВариантНаладки, "Владелец");
			ВидРабочегоЦентра = ВидРабочегоЦентра(Объект.РабочийЦентр);
			
			Если НЕ ВладелецВН = ВидРабочегоЦентра Тогда
				
				Объект.ВариантНаладки = Справочники.ВариантыНаладки.ПустаяСсылка();
				
			КонецЕсли;
			
		Иначе
			
			Объект.ВариантНаладки = Справочники.ВариантыНаладки.ПустаяСсылка();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьПодсказкуВводаЕдиницыИзмерения(Форма)
	
	Форма.Элементы.ЕдиницаИзмерения.ПодсказкаВвода = УправлениеПроизводствомКлиентСервер.ПредставлениеЕдиницыИзмеренияОперации(
		,
		Форма.Объект.Количество);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьЕдиницуИзмеренияПередаточнойПартии(Форма)
	
	Если Форма.Объект.ПередаточнаяПартия = 0 Тогда
		Форма.ЕдиницаИзмеренияПередаточнойПартии = НСтр("ru = 'передается вся партия этапа'");
	Иначе
		Форма.ЕдиницаИзмеренияПередаточнойПартии = " * " + 
			Форма.Объект.Количество + ?(ЗначениеЗаполнено(Форма.Объект.ЕдиницаИзмерения), " " + 
			УправлениеПроизводствомКлиентСервер.ПредставлениеЕдиницыИзмеренияОперации(
				Форма.Объект.ЕдиницаИзмерения, 
				Форма.Объект.Количество), "") + " = " + 
			(Форма.Объект.ПередаточнаяПартия * Форма.Объект.Количество) + " " +
			УправлениеПроизводствомКлиентСервер.ПредставлениеЕдиницыИзмеренияОперации(
				Форма.Объект.ЕдиницаИзмерения, 
				Форма.Объект.ПередаточнаяПартия * Форма.Объект.Количество);
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ПрочитатьРеквизитыВидаОперации()
	
	Если Объект.ВидОперации.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Справочники.ВидыТехнологическихОпераций.СоздатьВТСвойстваНабора(
		Объект.ВидОперации,
		МенеджерВременныхТаблиц,
		Истина,
		Ложь);
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	Нормативы.Свойство     КАК Свойство,
		|	Нормативы.ЗначениеМин  КАК ЗначениеМин,
		|	Нормативы.ЗначениеМакс КАК ЗначениеМакс
		|ПОМЕСТИТЬ ВТНормативы
		|ИЗ
		|	&Нормативы КАК Нормативы
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Свойство
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СвойстваНабора.Свойство             КАК Свойство,
		|	СвойстваНабора.Заголовок            КАК Заголовок,
		|	СвойстваНабора.ТипЗначения          КАК ТипЗначения,
		|	СвойстваНабора.ФорматСвойства       КАК Формат,
		|	СвойстваНабора.НомерСтроки          КАК НомерСтроки,
		|	3                                   КАК НомерКартинки,
		|	ЕСТЬNULL(Нормативы.ЗначениеМин, 0)  КАК ЗначениеМин,
		|	ЕСТЬNULL(Нормативы.ЗначениеМакс, 0) КАК ЗначениеМакс,
		|	ЛОЖЬ                                КАК Удален
		|ИЗ
		|	ВТСвойстваНабора КАК СвойстваНабора
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТНормативы КАК Нормативы
		|		ПО СвойстваНабора.Свойство = Нормативы.Свойство
		|ГДЕ
		|	НЕ СвойстваНабора.ЭтоДополнительноеСведение
		|	И НЕ СвойстваНабора.ПометкаУдаления
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Нормативы.Свойство,
		|	Нормативы.Свойство.Заголовок,
		|	Нормативы.Свойство.ТипЗначения,
		|	Нормативы.Свойство.ФорматСвойства,
		|	0,
		|	3,
		|	Нормативы.ЗначениеМин,
		|	Нормативы.ЗначениеМакс,
		|	ИСТИНА
		|ИЗ
		|	ВТНормативы КАК Нормативы
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТСвойстваНабора КАК СвойстваНабора
		|		ПО Нормативы.Свойство = СвойстваНабора.Свойство
		|			И (НЕ СвойстваНабора.ПометкаУдаления)
		|ГДЕ
		|	СвойстваНабора.Свойство ЕСТЬ NULL
		|
		|УПОРЯДОЧИТЬ ПО
		|	Удален,
		|	НомерСтроки
		|");
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Нормативы", Объект.НормативыВидаОперации.Выгрузить());
	
	ДопРеквизиты.Загрузить(Запрос.Выполнить().Выгрузить());
	ДопРеквизитыКоличество = ДопРеквизиты.Количество();
	
	// Заполнение формата доп. реквизитов
	Для каждого Строка Из ДопРеквизиты Цикл
		
		Если Строка.ТипЗначения.СодержитТип(Тип("Число")) Тогда
			
			Если ЗначениеЗаполнено(Строка.Формат) Тогда
				
				Если СтрНайти(Строка.Формат, "ЧЦ") = 0 Тогда
					Строка.Формат = Строка.Формат + "; ЧЦ=" + Строка.ТипЗначения.КвалификаторыЧисла.Разрядность;
				КонецЕсли;
				
				Если СтрНайти(Строка.Формат, "ЧДЦ") = 0 Тогда
					Строка.Формат = Строка.Формат + "; ЧДЦ=" + Строка.ТипЗначения.КвалификаторыЧисла.РазрядностьДробнойЧасти;
				КонецЕсли;
				
			Иначе
				
				Строка.Формат = СтрШаблон("ЧЦ=%1; ЧДЦ=%2",
					Строка.ТипЗначения.КвалификаторыЧисла.Разрядность,
					Строка.ТипЗначения.КвалификаторыЧисла.РазрядностьДробнойЧасти);
					
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	СвойстваБезНормативов = Новый СписокЗначений;
	
	//
	
	Для каждого Строка Из ДопРеквизиты Цикл
		
		Если Строка.ТипЗначения.Типы().ВГраница() = 0
			И Строка.ТипЗначения.СодержитТип(Тип("Число")) Тогда
			
			Элемент = УсловноеОформление.Элементы.Добавить();
			
			ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
			ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДопРеквизитыЗначениеМин.Имя);
			
			ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
			ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДопРеквизитыЗначениеМакс.Имя);
			
			ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДопРеквизиты.Свойство");
			ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
			ОтборЭлемента.ПравоеЗначение = Строка.Свойство;
			
			Элемент.Оформление.УстановитьЗначениеПараметра("Формат", Строка.Формат);
			
		Иначе
			
			СвойстваБезНормативов.Добавить(Строка.Свойство);
			
		КонецЕсли;
		
	КонецЦикла;
	
	//
	
	Если СвойстваБезНормативов.Количество() > 0 Тогда
		
		Элемент = УсловноеОформление.Элементы.Добавить();
		
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДопРеквизитыЗначениеМин.Имя);
		
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДопРеквизиты.Свойство");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
		ОтборЭлемента.ПравоеЗначение = СвойстваБезНормативов;
		
		Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НезаполненноеПолеТаблицы);
		Элемент.Оформление.УстановитьЗначениеПараметра("ГоризонтальноеПоложение", ГоризонтальноеПоложение.Лево);
		Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<не используются>'"));
		Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
		
		//
		
		Элемент = УсловноеОформление.Элементы.Добавить();
		
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДопРеквизитыЗначениеМакс.Имя);
		
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДопРеквизиты.Свойство");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
		ОтборЭлемента.ПравоеЗначение = СвойстваБезНормативов;
		
		Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
		
	КонецЕсли;
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
			
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДопРеквизиты.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДопРеквизиты.Удален");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(,,,,,Истина));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НезаполненноеПолеТаблицы);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗагрузитьНормативыВидаОперации(ТекущийОбъект, ДопРеквизиты)
	
	ТекущийОбъект.НормативыВидаОперации.Очистить();
	
	Для каждого Строка Из ДопРеквизиты Цикл
		Если Строка.ЗначениеМин <> 0 ИЛИ Строка.ЗначениеМакс <> 0 Тогда
			ЗаполнитьЗначенияСвойств(ТекущийОбъект.НормативыВидаОперации.Добавить(), Строка, "Свойство, ЗначениеМин, ЗначениеМакс");
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
