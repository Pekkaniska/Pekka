
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
		
	Если Параметры.Свойство("МодельБюджетирования") Тогда
		Объект.МодельБюджетирования = Параметры.МодельБюджетирования;
	КонецЕсли;
	
	Если Параметры.Свойство("СформироватьПриОткрытии") И Параметры.СформироватьПриОткрытии <> Неопределено 
		И Параметры.СформироватьПриОткрытии Тогда	
		СформироватьПриОткрытии = Истина;
	КонецЕсли;

	Объект.МодельБюджетирования = Справочники.МоделиБюджетирования.МодельБюджетированияПоУмолчанию();
	
	Группировки = "Вариант1";
	
	ТекущаяДата = ТекущаяДатаСеанса(); 
	НачалоПериода = ТекущаяДата;
	КонецПериода = ТекущаяДата;
	
	ВосстановитьКлючТекущейНастройки();
	Если Не КлючТекущейНастройки = Неопределено Тогда
		ВосстановитьНастройку(КлючТекущейНастройки);
	КонецЕсли;
		
	УправлениеФормой();
			
	Результат.ОтображатьЛегенду = Ложь;
	Результат.ОтображатьЗаголовок = Ложь;
	
	Результат.ОбластьПостроения.Право = 1;
	
	ЗаполнитьКомандыВыбораСохраненныхНастроек();
		
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	Если ЗначениеЗаполнено(Объект.МодельБюджетирования) Тогда
		Настройки.Удалить("Объект.МодельБюджетирования");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
		
	Если ЗначениеЗаполнено(Объект.МодельБюджетирования) И СформироватьПриОткрытии Тогда
		ПодключитьОбработчикОжидания("Сформировать", 0.1, Истина);
	Иначе
		УстановитьСостояниеОтчетНеСформирован();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПериодНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПериодНачалоВыбораЗавершение", ЭтотОбъект);
	
	ОбщегоНазначенияУТКлиент.ВыбратьПериодИзСписка(
				ЭтаФорма,
				Элемент,
				ВидПериода,
				НачалоПериода,
				ОписаниеОповещения);
									
КонецПроцедуры
					
&НаКлиенте
Процедура ВидПериодаПриИзменении(Элемент)
	
	ПривестиЗначениеПериода(ВидПериода);
	
	УстановитьСостояниеОтчетНеСформирован();
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровки, СтандартнаяОбработка, Дата)
	
	Если ТипЗнч(Расшифровки) = Тип("Строка") Тогда
		ПоказатьПредупреждение(, Расшифровки);
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = ТипЗнч(Расшифровки) <> Тип("Массив");
	Если Не СтандартнаяОбработка Тогда
		СписокРезультат = Новый СписокЗначений;
		Для Каждого Расшифровка Из Расшифровки Цикл
			Если ТипЗнч(Расшифровка) = Тип("СписокЗначений") Тогда
				Для Каждого Элемент Из Расшифровка Цикл
					ЗаполнитьЗначенияСвойств(СписокРезультат.Добавить(), Элемент);
				КонецЦикла;
			КонецЕсли;
		КонецЦикла;
		Если СписокРезультат.Количество() = 1 Тогда
			ПоказатьЗначение(Неопределено, СписокРезультат[0].Значение);
		ИначеЕсли СписокРезультат.Количество() Тогда
			ВыбранноеЗначение = Неопределено;

			СписокРезультат.ПоказатьВыборЭлемента(Новый ОписаниеОповещения("РезультатОбработкаРасшифровкиЗавершение", ЭтотОбъект), НСтр("ru = 'Сведения о шаге процесса'"));
		Иначе
			ПоказатьПредупреждение(,НСтр("ru = 'Нет данных для расшифровки!'"));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаРасшифровкиЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
    
    ВыбранноеЗначение = ВыбранныйЭлемент;
    Если ВыбранноеЗначение <> Неопределено Тогда
        ПоказатьЗначение(Неопределено, ВыбранноеЗначение.Значение);
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ТекущиеНевыполненныеЗадачиНажатие(Элемент)
	
	ФиксированныеНастройки = Новый НастройкиКомпоновкиДанных;
	
	ЭлементОтбора = ФиксированныеНастройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("МодельБюджетирования");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение = Объект.МодельБюджетирования;
	ЭлементОтбора.Использование = Истина;
	
	Парам = Новый Структура;
	Парам.Вставить("КлючВарианта", "ТекущиеЗадачиРасшифровка");
	Парам.Вставить("СформироватьПриОткрытии", Истина);
	Парам.Вставить("ФиксированныеНастройки", ФиксированныеНастройки);
	Парам.Вставить("ВидимостьКомандВариантовОтчетов", Ложь);
	ОткрытьФорму("Отчет.ВыполнениеЗадачБюджетногоПроцесса.Форма", Парам);
	
КонецПроцедуры

&НаКлиенте
Процедура ТипОтчетаПриИзменении(Элемент)
	
	УправлениеФормой();	
	УстановитьСостояниеОтчетНеСформирован();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьПланВыполненияПроцессаПриИзменении(Элемент)
	
	УстановитьСостояниеОтчетНеСформирован();
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// КОМАНДЫ

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	
	Сформировать();	
	
КонецПроцедуры

&НаКлиенте
Процедура Сформировать()
	
	Перем Ошибки;
	
	ОчиститьСообщения();
	
	Отказ = Ложь;
	
	Если Не ЗначениеЗаполнено(Объект.МодельБюджетирования) Тогда
	
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,
			"МодельБюджетирования",
			НСтр("ru = 'Не указана модель бюджетирования'"), "");

		Отказ = Истина;
			
	КонецЕсли;
		
	Если Не ЗначениеЗаполнено(КонецПериода) Тогда
			
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,
			"ВидПериода",
			НСтр("ru = 'Не указана дата окончания отчета'"), "");
			
		Отказ = Истина;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Группировки) Тогда
			
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,
			"Группировки",
			НСтр("ru = 'Не указаны группировки отчета'"), "");
			
		Отказ = Истина;
		
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		СформироватьВФоне();
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПанельНастроек(Команда)
		
	СписокПараметров = Новый Структура();
	СписокПараметров.Вставить("МодельБюджетирования", Объект.МодельБюджетирования);
	СписокПараметров.Вставить("Группировки", Группировки); 
	СписокПараметров.Вставить("ОтветственныйЗначение", ОтветственныйЗначение); 
	СписокПараметров.Вставить("ОтветственныйФлаг", ОтветственныйФлаг);
	СписокПараметров.Вставить("ВидПериода", ВидПериода);
	СписокПараметров.Вставить("Период", Период);
	СписокПараметров.Вставить("ТипОтчета", ТипОтчета);
	СписокПараметров.Вставить("ПоказатьПланВыполненияПроцесса", ПоказатьПланВыполненияПроцесса);
	СписокПараметров.Вставить("НачалоПериода", НачалоПериода);
	СписокПараметров.Вставить("КонецПериода", КонецПериода);
		
	Оповещение = Новый ОписаниеОповещения("ОткрытьПанельНастроекЗавершение", ЭтотОбъект);

    ОткрытьФорму("Отчет.МониторБюджетныхПроцессов.Форма.ФормаНастроек", СписокПараметров, ЭтаФорма , , , , Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНастройки(Команда)
	
	Настройки = Новый Структура("ТипОтчета, МодельБюджетирования, Группировки, 
			|ОтветственныйЗначение, ОтветственныйФлаг, 
			|ПоказатьПланВыполненияПроцесса");
	ЗаполнитьЗначенияСвойств(Настройки, ЭтаФорма);
	Настройки.МодельБюджетирования = Объект.МодельБюджетирования;
	
	СписокПараметров = Новый Структура("КлючОбъекта,КлючТекущейНастройки,Настройки"
			,"Отчет.МониторБюджетныхПроцессов",КлючТекущейНастройки,Настройки);
	Оповещение = Новый ОписаниеОповещения("ОткрытьСохранениеНастроекОтчетаЗавершение", ЭтотОбъект);
    ОткрытьФорму("Отчет.МониторБюджетныхПроцессов.Форма.СохранениеНастроекОтчета", СписокПараметров, ЭтаФорма , , , , Оповещение);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// Подключаемые

&НаКлиенте
Процедура Подключаемый_ЗагрузитьНастройкуОтчета(Команда)
	
	Найденные = ДобавленныеНастройки.НайтиСтроки(Новый Структура("ИмяКоманды", Команда.Имя));
	Если Найденные.Количество() = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Вариант отчета не найден.'"));
		Возврат;
	КонецЕсли;
	НастройкаФормы = Найденные[0];
	ВосстановитьНастройку(НастройкаФормы.КлючНастройки);
	КлючТекущейНастройки = НастройкаФормы.КлючНастройки;
	УправлениеФормой();
	ЗаполнитьКомандыВыбораСохраненныхНастроек();
	Если СформироватьПриОткрытии Тогда
		ПодключитьОбработчикОжидания("Сформировать", 0.1, Истина);
	Иначе
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаСостояние;
		ОтображениеСостояния = Элементы.Состояние.ОтображениеСостояния;
		ОтображениеСостояния.Видимость = Истина;
		ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.Неактуальность;
		ОтображениеСостояния.Картинка  = БиблиотекаКартинок.Информация32;
		ОтображениеСостояния.Текст     = НСтр("ru = 'Выбран другой вариант отчета. Нажмите ""Сформировать"" для получения отчета.'");

	КонецЕсли;
	
	СохранитьКлючТекущейНастройки();
	
КонецПроцедуры

#КонецОбласти


////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УправлениеФормой()
	
	Модель = Объект.МодельБюджетирования;
	
	Если Группировки = "Вариант1" 
		И ЗначениеЗаполнено(Модель) Тогда
		
		ПериодичностьМодели = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Модель, "Периодичность");
		Если ЗначениеЗаполнено(ПериодичностьМодели) Тогда
			ИмяПериодичности = ОбщегоНазначения.ИмяЗначенияПеречисления(ПериодичностьМодели);
			НовыйВидПериода  = Перечисления.ДоступныеПериодыОтчета[ИмяПериодичности];
		Иначе
			НовыйВидПериода  = Перечисления.ДоступныеПериодыОтчета.ПустаяСсылка();
		КонецЕсли;
		Если ВидПериода <> НовыйВидПериода Тогда
			ВидПериода = НовыйВидПериода;
			ПривестиЗначениеПериода(ВидПериода);
		КонецЕсли;
	КонецЕсли;
	
	Элементы.ВидПериода.Доступность = Группировки <> "Вариант1";
	Элементы.ПоказатьПланВыполненияПроцесса.Видимость = ТипОтчета > 0;
	
	// Заголовок.
	Заголовок = Метаданные.Отчеты.МониторБюджетныхПроцессов.Синоним;
	Если ЗначениеЗаполнено(КлючТекущейНастройки) Тогда
		Заголовок = Заголовок + " (" + КлючТекущейНастройки + ")";;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура СформироватьВФоне()
	
	Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаСостояние;
	ОтображениеСостояния = Элементы.Состояние.ОтображениеСостояния;
	ОтображениеСостояния.Видимость                      = Истина;
	ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.Неактуальность;
	ОтображениеСостояния.Картинка                       = БиблиотекаКартинок.ДлительнаяОперация48;
	ОтображениеСостояния.Текст                          = НСтр("ru = 'Отчет формируется...'");

	
	ДлительнаяОперация = ЗаполнитьДиаграммуВФоне();
	
	Если ДлительнаяОперация <> Неопределено Тогда
		
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
		ПараметрыОжидания.Интервал = 0; 
		ОповещениеОЗавершении = Новый ОписаниеОповещения("ЗаполнитьДиаграммуВФонеЗавершение", ЭтотОбъект);
		ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
	Иначе
		Результат = Неопределено;
		УстановитьСостояниеОтчетНеСформирован();
	КонецЕсли;

	Элементы.ТекущиеНевыполненныеЗадачи.Заголовок = НСтр("ru='Получение данных...'");
	ДлительнаяОперация1 = ПолучитьСведенияОЗадачахВФоне();
	
	Если ДлительнаяОперация1 <> Неопределено Тогда
		
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
		ПараметрыОжидания.Интервал = 0; 
		ОповещениеОЗавершении = Новый ОписаниеОповещения("ПолучитьСведенияОЗадачахВФонеЗавершение", ЭтотОбъект);
		ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация1, ОповещениеОЗавершении, ПараметрыОжидания);
	КонецЕсли;
   	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДиаграммуВФонеЗавершение(РезультатФоновогоЗадания,ДополнительныеПараметры) Экспорт
	
	ДлительнаяОперация = Неопределено;
	
	Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаРезультат;

	Если РезультатФоновогоЗадания = Неопределено Тогда
		Результат = Неопределено;
		Возврат;
	ИначеЕсли РезультатФоновогоЗадания.Статус = "Ошибка" Тогда
		Результат = Неопределено;
		ВызватьИсключение РезультатФоновогоЗадания.КраткоеПредставлениеОшибки;
	ИначеЕсли РезультатФоновогоЗадания.Статус = "Выполнено" Тогда
		Результат = ПолучитьИзВременногоХранилища(РезультатФоновогоЗадания.АдресРезультата);
		Результат.ОтображатьЛегенду = Ложь;
		Результат.ОтображатьЗаголовок = Ложь;	
		Результат.ОбластьПостроения.Право = 1;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПолучитьСведенияОЗадачахВФонеЗавершение(РезультатФоновогоЗадания,ДополнительныеПараметры) Экспорт
	
	ДлительнаяОперация1 = Неопределено;

	Если РезультатФоновогоЗадания = Неопределено Тогда
		Элементы.ТекущиеНевыполненныеЗадачи.Заголовок = НСтр("ru='Ошибка получения данных'");
		Возврат;
	ИначеЕсли РезультатФоновогоЗадания.Статус = "Ошибка" Тогда
		Элементы.ТекущиеНевыполненныеЗадачи.Заголовок = НСтр("ru='Ошибка получения данных'");
		ВызватьИсключение РезультатФоновогоЗадания.КраткоеПредставлениеОшибки;
	ИначеЕсли РезультатФоновогоЗадания.Статус = "Выполнено" Тогда
		Элементы.ТекущиеНевыполненныеЗадачи.Заголовок = ПолучитьИзВременногоХранилища(РезультатФоновогоЗадания.АдресРезультата);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПривестиЗначениеПериода(ВидПериода)
	
	НачалоПериода = ОбщегоНазначенияУТКлиентСервер.НачалоПериодаОтчета(ВидПериода, НачалоПериода);
	КонецПериода =  ОбщегоНазначенияУТКлиентСервер.КонецПериодаОтчета(ВидПериода, НачалоПериода);
	
	СписокПериодов = ОбщегоНазначенияУТКлиентСервер.ДоступныеЗначенияПериодаПоВидуПериода(НачалоПериода, ВидПериода);
	ЭлементСписка = СписокПериодов.НайтиПоЗначению(НачалоПериода);
	
	Если ЭлементСписка = Неопределено Тогда
		Период = "";
	Иначе
		Период = ЭлементСписка.Представление;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодНачалоВыбораЗавершение(ВыбранныйПериод, ДополнительныеПараметры) Экспорт

	Если ВыбранныйПериод <> Неопределено Тогда
		
		Период = ВыбранныйПериод.Представление;
		
		НачалоПериода = ВыбранныйПериод.Значение;
		КонецПериода = ОбщегоНазначенияУТКлиентСервер.КонецПериодаОтчета(ВидПериода, ВыбранныйПериод.Значение);		
		
	КонецЕсли; 
	
	УстановитьСостояниеОтчетНеСформирован();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПанельНастроекЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
    	Возврат;
	КонецЕсли;
	
	НастройкиИзменены = Ложь;
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		Для каждого КлючЗначение Из Результат Цикл
			Если КлючЗначение.Ключ = "МодельБюджетирования" Тогда				
				Если Объект.МодельБюджетирования <> КлючЗначение.Значение Тогда
					НастройкиИзменены = Истина;
				КонецЕсли;
				Объект.МодельБюджетирования  = КлючЗначение.Значение;
				Продолжить;	
			ИначеЕсли КлючЗначение.Ключ = "Сформировать" Тогда 
				Продолжить;
			КонецЕсли;
			Если ЭтаФорма[КлючЗначение.Ключ] <> КлючЗначение.Значение Тогда
				НастройкиИзменены = Истина;
			КонецЕсли;
			ЭтаФорма[КлючЗначение.Ключ] = КлючЗначение.Значение;	  	
      	КонецЦикла;
  	КонецЕсли;
  
  	УправлениеФормой();
	
	Если НастройкиИзменены Тогда
		УстановитьСостояниеОтчетНеСформирован();
	КонецЕсли;
	
	Если Результат.Свойство("Сформировать") И Результат.Сформировать Тогда
		ПодключитьОбработчикОжидания("Сформировать", 0.1, Истина);	
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ЗаполнитьДиаграммуВФоне()
		
	Если ДлительнаяОперация <> Неопределено Тогда
		ДлительныеОперации.ОтменитьВыполнениеЗадания(ДлительнаяОперация.ИдентификаторЗадания);
	КонецЕсли;
	
	ДопПараметры = Новый Структура();
	ДопПараметры.Вставить("ПланВыполнения", 		ПоказатьПланВыполненияПроцесса);
	ДопПараметры.Вставить("ФлагИсполнитель", 		ОтветственныйФлаг);
	ДопПараметры.Вставить("ЗначениеИсполнитель", 	ОтветственныйЗначение);

	ПараметрыОбработки = Новый Структура;
	ПараметрыОбработки.Вставить("МодельБюджетирования", Объект.МодельБюджетирования);
	ПараметрыОбработки.Вставить("Результат", Результат);
	ПараметрыОбработки.Вставить("НачалоПериода", НачалоПериода);
	ПараметрыОбработки.Вставить("КонецПериода", КонецПериода);
	ПараметрыОбработки.Вставить("ТипОтчета", ТипОтчета);
	ПараметрыОбработки.Вставить("Группировки", Группировки);
	ПараметрыОбработки.Вставить("ДопПараметры", ДопПараметры);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.ОжидатьЗавершение = 0; // запускать сразу
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Монитор бюджетных процессов, заполнение диаграммы'");
		
	РезультатФоновогоЗадания = ДлительныеОперации.ВыполнитьВФоне("Отчеты.МониторБюджетныхПроцессов.ЗаполнитьДиаграмму",
		ПараметрыОбработки, ПараметрыВыполнения);
		

	Возврат РезультатФоновогоЗадания;
	
КонецФункции

&НаСервере
Функция ПолучитьСведенияОЗадачахВФоне()
		
	Если ДлительнаяОперация1 <> Неопределено Тогда
		ДлительныеОперации.ОтменитьВыполнениеЗадания(ДлительнаяОперация1.ИдентификаторЗадания);
	КонецЕсли;
	

	ПараметрыОбработки = Новый Структура;
	ПараметрыОбработки.Вставить("МодельБюджетирования", Объект.МодельБюджетирования);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.ОжидатьЗавершение = 0; // запускать сразу
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Монитор бюджетных процессов, получение сведений о задачах'");
		
	РезультатФоновогоЗадания = ДлительныеОперации.ВыполнитьВФоне("Отчеты.МониторБюджетныхПроцессов.ПолучитьСведенияОЗадачах",
		ПараметрыОбработки, ПараметрыВыполнения);

	Возврат РезультатФоновогоЗадания;
	
КонецФункции

&НаКлиенте
Процедура ОткрытьСохранениеНастроекОтчетаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено ИЛИ ТипЗнч(Результат) <> Тип("Строка") Тогда 
		Возврат
	КонецЕсли;
	КлючТекущейНастройки = Результат;
	ЗаполнитьКомандыВыбораСохраненныхНастроек();
	
КонецПроцедуры

&НаСервере
Процедура СохранитьКлючТекущейНастройки()

	ИмяНастройки = "КлючТекущейНастройки";

	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("Отчет.МониторБюджетныхПроцессов", ИмяНастройки, КлючТекущейНастройки); 

КонецПроцедуры

&НаСервере
Процедура ВосстановитьКлючТекущейНастройки()

	ИмяНастройки = "КлючТекущейНастройки";
	КлючТекущейНастройки = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"Отчет.МониторБюджетныхПроцессов", ИмяНастройки);

КонецПроцедуры

&НаСервере
Процедура ВосстановитьНастройку(КлючНастройки)

	ЗначениеНастроек = ОбщегоНазначения.ХранилищеСистемныхНастроекЗагрузить(
		"Отчет.МониторБюджетныхПроцессов", КлючНастройки);

	Если ТипЗнч(ЗначениеНастроек) = Тип("Структура") Тогда

		ЗаполнитьЗначенияСвойств(ЭтаФорма, ЗначениеНастроек);
		Если ЗначениеНастроек.Свойство("МодельБюджетирования") Тогда
			Объект.МодельБюджетирования = ЗначениеНастроек.МодельБюджетирования;
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьКомандыВыбораСохраненныхНастроек()
	
	НастройкиФормы = РеквизитФормыВЗначение("ДобавленныеНастройки");
	НастройкиФормы.Колонки.Добавить("Найден", Новый ОписаниеТипов("Булево"));
	ПользовательИБ = РассылкаОтчетов.ИмяПользователяИБ(ПользователиКлиентСервер.ТекущийПользователь());
	
	СписокНастроек = ХранилищеСистемныхНастроек.ПолучитьСписок("Отчет.МониторБюджетныхПроцессов");
	СписокНастроек.СортироватьПоЗначению(НаправлениеСортировки.Возр);
	
	Группа = Элементы.ВариантыОтчета;
	КнопкиГруппы = Группа.ПодчиненныеЭлементы;
	ПоследнийИндекс = НастройкиФормы.Количество() - 1;
	Для Каждого Стр Из СписокНастроек Цикл
		
		Найденные = НастройкиФормы.НайтиСтроки(Новый Структура("КлючНастройки, Найден", Стр.Значение, Ложь));
		Если Найденные.Количество() = 1 Тогда
			НастройкаФормы = Найденные[0];
			НастройкаФормы.Найден = Истина;
			Кнопка = Элементы.Найти(НастройкаФормы.ИмяКоманды);
			Кнопка.Видимость = Истина;
			Кнопка.Заголовок = Стр.Значение;
			Элементы.Переместить(Кнопка, Группа);
		Иначе
			ПоследнийИндекс = ПоследнийИндекс + 1;
			НастройкаФормы = НастройкиФормы.Добавить();
			НастройкаФормы.КлючНастройки = Стр.Значение;
			НастройкаФормы.Найден = Истина;
			НастройкаФормы.ИмяКоманды = "ВыбратьНастройку_" + Формат(ПоследнийИндекс, "ЧН=0; ЧГ=");
			
			Команда = Команды.Добавить(НастройкаФормы.ИмяКоманды);
			Команда.Действие = "Подключаемый_ЗагрузитьНастройкуОтчета";
			
			Кнопка = Элементы.Добавить(НастройкаФормы.ИмяКоманды, Тип("КнопкаФормы"), Группа);
			Кнопка.Вид = ВидКнопкиФормы.КнопкаКоманднойПанели;
			Кнопка.ИмяКоманды = НастройкаФормы.ИмяКоманды;
			Кнопка.Заголовок = Стр.Значение;
			
			ПостоянныеКоманды.Добавить(НастройкаФормы.ИмяКоманды);
		КонецЕсли;
		Кнопка.Пометка = (КлючТекущейНастройки = Стр.Значение);
	КонецЦикла;
	
	Найденные = НастройкиФормы.НайтиСтроки(Новый Структура("Найден", Ложь));
	Для Каждого НастройкаФормы Из Найденные Цикл
		Кнопка = Элементы.Найти(НастройкаФормы.ИмяКоманды);
		Кнопка.Видимость = Ложь;
	КонецЦикла;
	
	НастройкиФормы.Колонки.Удалить("Найден");
	ЗначениеВРеквизитФормы(НастройкиФормы, "ДобавленныеНастройки");
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСостояниеОтчетНеСформирован()
	
	Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаСостояние;
	ОтображениеСостояния = Элементы.Состояние.ОтображениеСостояния;
	ОтображениеСостояния.Видимость                      = Истина;
	ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.Неактуальность;
	ОтображениеСостояния.Картинка  = БиблиотекаКартинок.Информация32;
	ОтображениеСостояния.Текст = НСтр("ru = 'Отчет не сформирован. Нажмите ""Сформировать"" для получения отчета.'");
	
КонецПроцедуры

#КонецОбласти
