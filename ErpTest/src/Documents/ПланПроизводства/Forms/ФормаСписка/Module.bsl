#Область ОписаниеПеременных

&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Список.Параметры.УстановитьЗначениеПараметра("ТекущаяДата", ТекущаяДатаСеанса());
	ТолькоАктуальные = Истина;
	АктуальностьПлана = Новый СписокЗначений;
	АктуальностьПлана.Добавить(1);
	АктуальностьПлана.Добавить(2);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "АктуальностьПлана",  АктуальностьПлана, ВидСравненияКомпоновкиДанных.ВСписке,, ТолькоАктуальные);
	
	Поля = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве("СостояниеРасчетаПотребностей");
	Список.УстановитьОграниченияИспользованияВГруппировке(Поля);
	Список.УстановитьОграниченияИспользованияВПорядке(Поля);
	Список.УстановитьОграниченияИспользованияВОтборе(Поля);
	
	ТекущиеДелаПереопределяемый.ПриСозданииНаСервере(ЭтаФорма, Список);
	
	ОтборыСписковКлиентСервер.СкопироватьСписокВыбораОтбораПоМенеджеру(
		Элементы.ОтборОтветственный.СписокВыбора,
		ОбщегоНазначенияУТ.ПолучитьСписокПользователейСПравомДобавления(Метаданные.Документы.ПланПроизводства));
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаГлобальныеКоманды);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	

	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.Дата", Элементы.Дата.Имя);


КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	КонтрольЗамещенияПланов();
	ПодключитьОбработчикОжидания("КонтрольЗамещенияПланов", 3600);
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если НЕ ЗавершениеРаботы = Истина Тогда
		ПриЗакрытииНаСервере(ИдентификаторЗадания);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	Сценарий  = Настройки.Получить("Сценарий");
	Статус = Настройки.Получить("Статус");
	Ответственный = Настройки.Получить("Ответственный");
	ТолькоАктуальные = Настройки.Получить("ТолькоАктуальные");
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Сценарий",  Сценарий, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Сценарий));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Статус",  Статус, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Статус));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Ответственный",  Ответственный, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Ответственный));
	
	АктуальностьПлана = Новый СписокЗначений;
	АктуальностьПлана.Добавить(1);
	АктуальностьПлана.Добавить(2);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "АктуальностьПлана",  АктуальностьПлана, ВидСравненияКомпоновкиДанных.ВСписке,, ТолькоАктуальные);
	
	ТекущиеДелаПереопределяемый.ПередЗагрузкойДанныхИзНастроекНаСервере(ЭтаФорма, Настройки);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборСценарийПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Сценарий",  Сценарий, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Сценарий));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСтатусПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Статус",  Статус, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Статус));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОтветственныйПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Ответственный",  Ответственный, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Ответственный));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборТолькоАктуальныеПриИзменении(Элемент)
	
	АктуальностьПлана = Новый СписокЗначений;
	АктуальностьПлана.Добавить(1);
	АктуальностьПлана.Добавить(2);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "АктуальностьПлана",  АктуальностьПлана, ВидСравненияКомпоновкиДанных.ВСписке,, ТолькоАктуальные);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	Состояния = Документы.ПланПроизводства.СостояниеРасчетаПотребностей(Строки.ПолучитьКлючи());
	СостояниеРассчитана = Документы.ПланПроизводства.КодыСостоянийРасчетаПотребностей().ПотребностьРассчитана;
	
	Для каждого КлючИЗначение Из Состояния Цикл
		
		Если КлючИЗначение.Значение = СостояниеРассчитана Тогда
			Состояние = 0; // Если потребность рассчитана, то индикатор не отображается чтобы не "засорять" список.
		Иначе
			Состояние = КлючИЗначение.Значение;
		КонецЕсли;
		
		Строки[КлючИЗначение.Ключ].Данные.СостояниеРасчетаПотребностей = Состояние;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура УстановитьСтатусВПодготовке(Команда)
	
	УстановитьСтатус("ВПодготовке", НСтр("ru = 'В подготовке'"));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусНаУтверждении(Команда)
	
	УстановитьСтатус("НаУтверждении", НСтр("ru = 'На утверждении'"));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусУтвержден(Команда)
	
	УстановитьСтатус("Утвержден", НСтр("ru = 'Утвержден'"));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусОтменен(Команда)
	
	УстановитьСтатус("Отменен", НСтр("ru = 'Отменен'"));
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьПотребностиПланаПроизводства(Команда)
	
	Ссылки = ОбщегоНазначенияУТКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	Если Ссылки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Результат = ПересчитатьПотребностиПланаПроизводстваНаСервере(Ссылки);
	
	Если НЕ Результат.ЗаданиеВыполнено Тогда
		
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		АдресХранилища		 = Результат.АдресХранилища;
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьПроведение(Команда)
	МассивСсылок = Элементы.Список.ВыделенныеСтроки;
	ОтменитьПроведениеПлановНаСервере(МассивСсылок);
	Элементы.Список.Обновить()
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьСтатус(Статус, ТексСтатуса)
	
	ВыделенныеСтроки = ОбщегоНазначенияУТКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='У выделенных в списке планов будет установлен статус ""%Статус%"". По принятым в работу планам могут быть оформлены документы. Продолжить?'");
	ТекстВопроса = СтрЗаменить(ТекстВопроса, "%Статус%", ТексСтатуса);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Статус", Статус);
	ДополнительныеПараметры.Вставить("ТексСтатуса", ТексСтатуса);
	ДополнительныеПараметры.Вставить("ВыделенныеСтроки", ВыделенныеСтроки);
	
	Оповещение = Новый ОписаниеОповещения("УстановитьСтатусЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусЗавершение(Результат, ДополнительныеПараметры) Экспорт 
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ОчиститьСообщения();
	КоличествоОбработанных = ОбщегоНазначенияУТВызовСервера.УстановитьСтатусДокументов(
		ДополнительныеПараметры.ВыделенныеСтроки, 
		ДополнительныеПараметры.Статус);
	ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(Элементы.Список, 
		КоличествоОбработанных, 
		ДополнительныеПараметры.ВыделенныеСтроки.Количество(), 
		ДополнительныеПараметры.ТексСтатуса);
	
КонецПроцедуры

&НаСервере
Функция ПересчитатьПотребностиПланаПроизводстваНаСервере(Ссылки)
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Ссылки", Ссылки);
	
	НаименованиеЗадания = НСтр("ru = 'Пересчет потребностей планов производства'");
	
	Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
		УникальныйИдентификатор,
		"РегистрыНакопления.ПланыПроизводства.ПересчитатьПотребностиПланов",
		СтруктураПараметров,
		НаименованиеЗадания);
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		
		Если ФормаДлительнойОперации.Открыта() 
			И ФормаДлительнойОперации.ИдентификаторЗадания = ИдентификаторЗадания Тогда
			
			Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда
				
				ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
				
			Иначе
				
				ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
				
				ПодключитьОбработчикОжидания(
					"Подключаемый_ПроверитьВыполнениеЗадания",
					ПараметрыОбработчикаОжидания.ТекущийИнтервал,
					Истина);
					
			КонецЕсли;
			
		КонецЕсли;
		
	Исключение
		
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		
		СообщенияПользователю = СообщенияФоновогоЗадания(ИдентификаторЗадания);
		Если СообщенияПользователю <> Неопределено Тогда
			Для каждого СообщениеФоновогоЗадания Из СообщенияПользователю Цикл
				СообщениеФоновогоЗадания.Сообщить();
			КонецЦикла;
		КонецЕсли;
		
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаСервереБезКонтекста
Функция СообщенияФоновогоЗадания(ИдентификаторЗадания)
	
	СообщенияПользователю = Новый Массив;
	ФоновоеЗадание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
	Если ФоновоеЗадание <> Неопределено Тогда
		СообщенияПользователю = ФоновоеЗадание.ПолучитьСообщенияПользователю();
	КонецЕсли;
	
	Возврат СообщенияПользователю;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ПриЗакрытииНаСервере(ИдентификаторЗадания)
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрольЗамещенияПланов()
	
	КонтрольЗамещенияПлановНаСервере();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура КонтрольЗамещенияПлановНаСервере()
	
	Планирование.КонтрольЗамещенияПланов();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОтменитьПроведениеПлановНаСервере(МассивСсылок)
	
	Планирование.ОтменитьПроведениеПланов(МассивСсылок, "ПланПроизводства");
	
КонецПроцедуры

#КонецОбласти
