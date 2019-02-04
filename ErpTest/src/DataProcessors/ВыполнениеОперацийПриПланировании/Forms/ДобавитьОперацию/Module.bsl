
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗаполнитьРеквизитыФормыПоПараметрам() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	НастроитьЭлементыФормы();
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если НЕ ИспользоватьУчастки Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Участок");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура КоличествоПриИзменении(Элемент)
	
	НастроитьЗависимыеЭлементыФормы(ЭтаФорма, "Количество");
	
КонецПроцедуры

&НаКлиенте
Процедура СкрытьСообщениеОбОшибкеНажатие(Элемент)
	
	Элементы.ГруппаСообщениеОбОшибке.Видимость = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьСообщениеОбОшибкеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ЗначенияЗаполнения = ЗначенияЗаполненияНовойОперации();
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	ПараметрыФормы.Вставить("ПроверитьПриОткрытии", Истина);
	
	ОткрытьФорму("Документ.ПроизводственнаяОперация2_2.ФормаОбъекта",
		ПараметрыФормы,
		ЭтотОбъект,
		,
		,
		,
		,
		РежимОткрытияОкнаФормы.Независимый);
		
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ИсполнительНачалоВыбораЗавершение", ЭтотОбъект);
	
	ПроизводствоКлиент.ОткрытьФормуВыбораИсполнителя(
		Организация,
		Подразделение,
		Исполнитель,
		ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ИсполнительПолучениеДанныхВыбора(ДанныеВыбора, Текст, Подразделение);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ИсполнительПолучениеДанныхВыбора(ДанныеВыбора, Текст, Подразделение);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ОчиститьСообщения();
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	ТребуетсяРучноеЗаполнение = Ложь;
	
	Если Не ЗаписатьДанные(ТребуетсяРучноеЗаполнение) Тогда
		
		ОчиститьСообщения();
		
		ТекстСообщения = НСтр("ru='Ошибка создания производственной операции!'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		
		Элементы.ГруппаСообщениеОбОшибке.Видимость = ТребуетсяРучноеЗаполнение;
		
		Возврат;
		
	КонецЕсли;
	
	ОповеститьОбИзменении(Тип("РегистрСведенийКлючЗаписи.ПооперационноеРасписание2_2"));
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ЗаписатьДанные(ТребуетсяРучноеЗаполнение = Ложь)
	
	ЗначенияЗаполнения = ЗначенияЗаполненияНовойОперации();
	
	ОперацияОбъект = Документы.ПроизводственнаяОперация2_2.СоздатьДокумент();
	ОперацияОбъект.Заполнить(ЗначенияЗаполнения);
	
	Если НЕ ОперацияОбъект.ПроверитьЗаполнение() Тогда
		ТребуетсяРучноеЗаполнение = Истина;
		Возврат Ложь;
	КонецЕсли;
	
	ЕстьОшибки = Ложь;
	НачатьТранзакцию();
	Попытка
		
		РегистрыСведений.ОчередьПроизводственныхОпераций.ЗаблокироватьОчередьДляЗаписиПоКлючу(ЗначенияЗаполнения.КлючОперации);
		
		РегистрыСведений.ПооперационноеРасписание2_2.ЗаблокироватьРасписаниеДляЗаписиПоКлючу(ЗначенияЗаполнения.КлючОперации, ЗначенияЗаполнения.НомерПартии);
		
		Если ВыполнитьКонтрольОстатковПриДобавленииОперации(ЗначенияЗаполнения) Тогда
			
			ОперацияОбъект.Записать(РежимЗаписиДокумента.Проведение);
			
		Иначе
			
			ЗаполнитьРеквизитыФормыПоДаннымОперации();
			ЕстьОшибки =  Истина;
			
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Выполнение операции'",
				ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,
			,
			,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		ЕстьОшибки = Истина;
		
	КонецПопытки;
	
	Возврат НЕ ЕстьОшибки;
	
КонецФункции

// Заполнение списка реквизитов по параметрам формы.
//
&НаСервере
Функция ЗаполнитьРеквизитыФормыПоПараметрам()
	
	Этап     = Параметры.КлючОперации.Этап; 
	Операция = Параметры.КлючОперации.Операция;
	
	Если Этап.Пустая() Или Операция.Пустая() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Не Параметры.Свойство("РежимРаботы", РежимРаботы) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Параметры.Свойство("НомерПартии") Тогда
		НомерПартии = Параметры.НомерПартии;
	КонецЕсли;
	
	Если Параметры.Свойство("РабочийЦентр") Тогда
		РабочийЦентр = Параметры.РабочийЦентр;
	КонецЕсли;
	
	Если Параметры.Свойство("Участок") Тогда
		Участок = Параметры.Участок;
	КонецЕсли;
	
	ЗаполнитьРеквизитыФормыПоДаннымОперации();
	Если КоличествоДоступно = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Количество = КоличествоДоступно;
	Организация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Этап, "Организация");
	
	ИспользоватьУчастки = ПолучитьФункциональнуюОпцию(
		"ИспользоватьПроизводственныеУчастки",
		Новый Структура("Подразделение", Подразделение));
	
	НастроитьЗависимыеЭлементыФормы(ЭтаФорма, "Количество");
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьРеквизитыФормыПоДаннымОперации()
	
	ДанныеОперации = РегистрыСведений.ПооперационноеРасписание2_2.ДанныеОперацииРасписания(Параметры.КлючОперации, НомерПартии, РабочийЦентр);
	
	Если ДанныеОперации = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(
		ЭтаФорма, 
		ДанныеОперации,
		"Подразделение,
		|МаршрутнаяКарта,
		|РабочийЦентр,
		|НомерПартии,
		|ВидРабочегоЦентра,
		|ЕдиницаИзмерения");
		
	Если РабочийЦентр.Пустая() Тогда
		РабочийЦентр = ДанныеОперации.РабочийЦентр;
	КонецЕсли;
	
	КоличествоЗапланировано = ДанныеОперации.Запланировано;
	
	Если РежимРаботы = РежимРаботыСоздать() Тогда
		КоличествоДоступно = ДанныеОперации.ОжиданиеСоздания;
	Иначе
		КоличествоДоступно = ДанныеОперации.МожноВыполнять;
	КонецЕсли;
	
	НастроитьЗависимыеЭлементыФормы(ЭтаФорма);

КонецПроцедуры

&НаСервере
Функция ВыполнитьКонтрольОстатковПриДобавленииОперации(ДанныеЗаполнения)
	
	ДанныеОперации = РегистрыСведений.ПооперационноеРасписание2_2.ДанныеОперацииРасписания(ДанныеЗаполнения.КлючОперации, ДанныеЗаполнения.НомерПартии, ДанныеЗаполнения.РабочийЦентр);
	
	Если ДанныеОперации = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ДанныеЗаполнения.Статус = Перечисления.СтатусыПроизводственныхОпераций.Создана
			И ДанныеЗаполнения.Количество > ДанныеОперации.ОжиданиеСоздания
		ИЛИ ДанныеЗаполнения.Статус = Перечисления.СтатусыПроизводственныхОпераций.Выполняется
			И ДанныеЗаполнения.Количество > ДанныеОперации.МожноВыполнять Тогда
		
		Возврат Ложь;
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Функция возвращает данные для заполнения операций на форме "Добавить операцию".
//
&НаСервере
Функция ЗначенияЗаполненияНовойОперации()
	
	СтатусОперации = Неопределено;
	Если РежимРаботы = РежимРаботыСоздать() Тогда
		СтатусОперации = ПредопределенноеЗначение("Перечисление.СтатусыПроизводственныхОпераций.Создана");
	ИначеЕсли РежимРаботы = РежимРаботыПринятьВРаботу() Тогда
		СтатусОперации = ПредопределенноеЗначение("Перечисление.СтатусыПроизводственныхОпераций.Выполняется");
	ИначеЕсли РежимРаботы = РежимРаботыОтметитьВыполнение() Тогда
		СтатусОперации = ПредопределенноеЗначение("Перечисление.СтатусыПроизводственныхОпераций.Выполнена");
	КонецЕсли;
	
	ВидРЦ = ?(ВидРабочегоЦентра.Пустая(),
		?(РабочийЦентр.Пустая(),
			ВидРабочегоЦентра,
			ОбщегоНазначения.ЗначениеРеквизитаОбъекта(РабочийЦентр, "ВидРабочегоЦентра")),
		ВидРабочегоЦентра);
	
	ДанныеЗаполнения = Новый Структура;
	
	ДанныеЗаполнения.Вставить("СпособЗаполнения", "ЗаполнитьПоОперации");
	ДанныеЗаполнения.Вставить("Статус", СтатусОперации);
	ДанныеЗаполнения.Вставить("Подразделение", Подразделение);
	ДанныеЗаполнения.Вставить("КлючОперации", Параметры.КлючОперации);
	ДанныеЗаполнения.Вставить("НомерПартии", НомерПартии);
	ДанныеЗаполнения.Вставить("НаОснованииПланирования", Истина);
	ДанныеЗаполнения.Вставить("Исполнитель", Исполнитель);
	ДанныеЗаполнения.Вставить("ВидРабочегоЦентра", ВидРЦ);
	ДанныеЗаполнения.Вставить("РабочийЦентр", РабочийЦентр);
	ДанныеЗаполнения.Вставить("Участок", Участок);
	ДанныеЗаполнения.Вставить("Количество", Количество);
	
	Возврат ДанныеЗаполнения;

КонецФункции

&НаКлиенте
Процедура ИсполнительНачалоВыбораЗавершение(Результат, Параметры) Экспорт
	
	Если ЗначениеЗаполнено(Результат) Тогда
		
		Исполнитель = Результат;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ИсполнительПолучениеДанныхВыбора(ДанныеВыбора, Текст, Подразделение)
	
	ДанныеВыбора = Новый СписокЗначений;
	ПараметрыОтбора = Новый Структура("Организация, Подразделение");
	ПараметрыОтбора.Подразделение = Подразделение;
	ПроизводствоСервер.ЗаполнитьДанныеВыбораПриВводеИсполнителя(ДанныеВыбора, Текст, ПараметрыОтбора);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьЭлементыФормы() 
	
	// Связи параметров выбора рабочего центра
	#Область РабочийЦентр 
	
	МассивПараметров = Новый Массив;
	
	Если ВидРабочегоЦентра.Пустая() Тогда
		МассивПараметров.Добавить(Новый СвязьПараметраВыбора("Отбор.Подразделение", "Подразделение"));
	Иначе
		МассивПараметров.Добавить(Новый СвязьПараметраВыбора("Отбор.ВидРабочегоЦентра", "ВидРабочегоЦентра"));
	КонецЕсли;
	Если ИспользоватьУчастки Тогда
		МассивПараметров.Добавить(Новый СвязьПараметраВыбора("Отбор.Участок", "Участок"));
	КонецЕсли;
	
	Элементы.РабочийЦентр.СвязиПараметровВыбора = Новый ФиксированныйМассив(МассивПараметров);
	
	#КонецОбласти
	
	УстановитьТипИсполнителя();
	
	НастроитьЗависимыеЭлементыФормы(ЭтаФорма);
	
	УстановитьЗаголовкиЭлементовФормы();
	
	Элементы.Участок.Видимость = ИспользоватьУчастки;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовкиЭлементовФормы()
	
	// Установка заголовка формы
	#Область ЗаголовокФормы
	
	Если РежимРаботы = РежимРаботыСоздать() Тогда
		ТекстЗаголовок = НСтр("ru = 'Создать операцию'");
	ИначеЕсли РежимРаботы = РежимРаботыПринятьВРаботу() Тогда
		ТекстЗаголовок = НСтр("ru = 'Принять в работу операцию'");
	ИначеЕсли РежимРаботы = РежимРаботыОтметитьВыполнение() Тогда
		ТекстЗаголовок = НСтр("ru = 'Отметить выполнение операции'");
	КонецЕсли;
	
	РеквизитыЭтапа = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Этап, "Номер,НаименованиеЭтапа"); 
	ПредставлениеЭтапа = Документы.ЭтапПроизводства2_2.ПредставлениеЭтапа(РеквизитыЭтапа);
	
	ТекстЗаголовок = ТекстЗаголовок + " (" + ПредставлениеЭтапа + ", " + Операция + ")";
	
	АвтоЗаголовок = Ложь;
	Заголовок = ТекстЗаголовок;
	
	#КонецОбласти
	
	// Установка заголовка поля "Количество доступно"
	#Область КоличествоДоступно
	
	Если РежимРаботы = РежимРаботыСоздать() Тогда
		ТекстЗаголовок = НСтр("ru = 'Ожидает создания'");
	Иначе
		ТекстЗаголовок = НСтр("ru = 'Можно выполнять'");
	КонецЕсли;
	
	Элементы.КоличествоДоступно.Заголовок = ТекстЗаголовок;
	
	#КонецОбласти
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТипИсполнителя()
	
	Если ЗначениеЗаполнено(Подразделение) Тогда
		
		ПараметрыПодразделения = ПроизводствоСервер.ПараметрыПроизводственногоПодразделения(Подразделение);
		
		УправлениеПроизводствомКлиентСервер.УстановитьТипИсполнителя(Исполнитель, ПараметрыПодразделения.ИспользоватьБригадныеНаряды);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьЗависимыеЭлементыФормы(Форма, СписокРеквизитов = "")

	Инициализация = ПустаяСтрока(СписокРеквизитов);
	СтруктураРеквизитов = Новый Структура(СписокРеквизитов);
	
	// Настройка элемента Количество
	Если Инициализация
		Или СтруктураРеквизитов.Свойство("КоличествоДоступно") Тогда
		
		Если Форма.РежимРаботы <> РежимРаботыОтметитьВыполнение() Тогда
			Форма.Элементы.Количество.МаксимальноеЗначение = Форма.КоличествоДоступно;
		Иначе
			Форма.Элементы.Количество.МаксимальноеЗначение = Неопределено;
		КонецЕсли;
		
	КонецЕсли;
	
	// Настройка элемента ЕдиницаИзмеренияПредставление
	Если Инициализация
		Или СтруктураРеквизитов.Свойство("Количество") Тогда
		
		Форма.ЕдиницаИзмеренияПредставление = УправлениеПроизводствомКлиентСервер.ПредставлениеЕдиницыИзмеренияОперации(
			Форма.ЕдиницаИзмерения,
			Форма.Количество);
		
	КонецЕсли;
	
	// Настройка элемента ЕдиницаИзмеренияЗапланированоПредставление
	Если Инициализация
		Или СтруктураРеквизитов.Свойство("КоличествоЗапланировано") Тогда
			
		Форма.ЕдиницаИзмеренияЗапланированоПредставление = УправлениеПроизводствомКлиентСервер.ПредставлениеЕдиницыИзмеренияОперации(
			Форма.ЕдиницаИзмерения,
			Форма.КоличествоЗапланировано);
			
	КонецЕсли;
	
	// Настройка элемента ЕдиницаИзмеренияДоступноПредставление
	Если Инициализация
		Или СтруктураРеквизитов.Свойство("КоличествоДоступно") Тогда
		
		Форма.ЕдиницаИзмеренияДоступноПредставление = УправлениеПроизводствомКлиентСервер.ПредставлениеЕдиницыИзмеренияОперации(
			Форма.ЕдиницаИзмерения,
			Форма.КоличествоДоступно);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция РежимРаботыСоздать()
	
	Возврат "Создать";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция РежимРаботыПринятьВРаботу()
	
	Возврат "ПринятьВРаботу";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция РежимРаботыОтметитьВыполнение()
	
	Возврат "ОтметитьВыполнение";
	
КонецФункции

#КонецОбласти
