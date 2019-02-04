

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Параметры.Свойство("ТипОформляемойОбласти", ТипОформляемойОбласти)
	 ИЛИ НЕ Параметры.Свойство("АдресЭлементовОтчета")
	 ИЛИ НЕ Параметры.Свойство("ОформляемыеСтроки")
	 ИЛИ НЕ Параметры.Свойство("ОформляемыеКолонки") Тогда
		ТекстСообщения = НСтр("ru='Непосредственное открытие этой формы не предусмотрено.'");
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
	Если Параметры.Свойство("НастройкаЯчеек") Тогда
		ОформляемыеСтроки.Очистить();
		ОформляемыеКолонки.Очистить();
		Для Каждого Строка Из Параметры.ОформляемыеСтроки Цикл
			НоваяСтрока = ОформляемыеСтроки.Добавить();
			НоваяСтрока.ЭлементОтчета = Строка;
		КонецЦикла;
		Для Каждого Колонка Из Параметры.ОформляемыеКолонки Цикл
			НоваяСтрока = ОформляемыеКолонки.Добавить();
			НоваяСтрока.ЭлементОтчета = Колонка;
		КонецЦикла;
	Иначе
		ОформляемыеСтроки.Загрузить(ПолучитьИзВременногоХранилища(Параметры.ОформляемыеСтроки));
		ОформляемыеКолонки.Загрузить(ПолучитьИзВременногоХранилища(Параметры.ОформляемыеКолонки));
	КонецЕсли;
	
	Для Каждого Строка Из ОформляемыеСтроки Цикл
		Если ЗначениеЗаполнено(Строка.ЭлементОтчета) Тогда
			Строка.НаименованиеДляПечати = ПолучитьИзВременногоХранилища(Строка.ЭлементОтчета).НаименованиеДляПечати;
		Иначе
			Строка.НаименованиеДляПечати = НСтр("ru = 'Заголовок таблицы'");
		КонецЕсли;
	КонецЦикла;
	Для Каждого Колонка Из ОформляемыеКолонки Цикл
		Если ЗначениеЗаполнено(Колонка.ЭлементОтчета) Тогда
			Колонка.НаименованиеДляПечати = ПолучитьИзВременногоХранилища(Колонка.ЭлементОтчета).НаименованиеДляПечати;
		Иначе
			Колонка.НаименованиеДляПечати = НСтр("ru = 'Заголовок таблицы'");
		КонецЕсли;
	КонецЦикла;
	
	Если Параметры.Свойство("КлючЭлементаОформления") Тогда
		КлючЭлементаОформления = Параметры.КлючЭлементаОформления;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(КлючЭлементаОформления) Тогда
		КлючЭлементаОформления = Новый УникальныйИдентификатор;
	КонецЕсли;
	
	СКД = ФинансоваяОтчетностьСервер.НоваяСхема();
	Набор = ФинансоваяОтчетностьСервер.НовыйНабор(СКД, Тип("НаборДанныхОбъектСхемыКомпоновкиДанных"));
	Для Каждого Поле Из Параметры.ПоляОтбора Цикл
		СтруктураЭлемента = ПолучитьИзВременногоХранилища(Поле);
		Если Не (СтруктураЭлемента.ВидЭлемента = Перечисления.ВидыЭлементовФинансовогоОтчета.Измерение) Тогда
			Продолжить;
		КонецЕсли;
		ТипИзмерения = ФинансоваяОтчетностьВызовСервера.ЗначениеДополнительногоРеквизита(СтруктураЭлемента, "ТипИзмерения");
		Если ТипИзмерения <> Перечисления.ТипыИзмеренийФинансовогоОтчета.Аналитика
			И ТипИзмерения <> Перечисления.ТипыИзмеренийФинансовогоОтчета.ИзмерениеРегистра Тогда
			Продолжить;
		КонецЕсли;
		Если ТипИзмерения = Перечисления.ТипыИзмеренийФинансовогоОтчета.ИзмерениеРегистра Тогда
			ИмяИзмерения = ФинансоваяОтчетностьВызовСервера.ЗначениеДополнительногоРеквизита(СтруктураЭлемента, "ИмяИзмерения");
			Если ИмяИзмерения = "Организация" Тогда
				ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.Организации");
			ИначеЕсли ИмяИзмерения = "Подразделение" Тогда
				ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.СтруктураПредприятия");
			ИначеЕсли ИмяИзмерения = "Сценарий" Тогда
				ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.Сценарии");
			ИначеЕсли ИмяИзмерения = "Валюта" Тогда
				ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.Валюты");
			КонецЕсли;
		Иначе
			ВидАналитики = ФинансоваяОтчетностьВызовСервера.ЗначениеДополнительногоРеквизита(СтруктураЭлемента, "ВидАналитики");
			ТипЗначения = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидАналитики, "ТипЗначения");
			ИмяИзмерения = ФинансоваяОтчетностьПовтИсп.ИмяПоляБюджетногоОтчета(ВидАналитики);
		КонецЕсли;
		
		ПолеНабора = ФинансоваяОтчетностьСервер.НовоеПолеНабора(Набор, ИмяИзмерения, ИмяИзмерения, СтруктураЭлемента.НаименованиеДляПечати, ТипЗначения);
		ПолеНабора.ОграничениеИспользованияРеквизитов.Условие = Истина;
		
	КонецЦикла;
	
	ЭлементыОтчета = ПолучитьИзВременногоХранилища(Параметры.АдресЭлементовОтчета);
	МассивПоказателей = Новый СписокЗначений;
	Если Не Параметры.ЭтоПростаяТаблица Тогда
		
		МассивПоказателей.Добавить("ЗначениеЯчейки", НСтр("ru = 'Значение ячейки'"));
		
	Иначе
		
		Таблица = ФинансоваяОтчетностьКлиентСервер.ТаблицаЭлемента(ЭлементыОтчета, Параметры.АдресЭлементаВХранилище);
		
		НайденныеСтроки = Таблица.Строки.НайтиСтроки(Новый Структура("ВидЭлемента", Перечисления.ВидыЭлементовФинансовогоОтчета.НефинансовыйПоказатель));
		Если НайденныеСтроки.Количество() Тогда
			МассивПоказателей.Добавить("Значение", НСтр("ru = 'Значение (НФП)'"));
		КонецЕсли;
		
		СтатьиБюджета = Таблица.Строки.НайтиСтроки(Новый Структура("ВидЭлемента", Перечисления.ВидыЭлементовФинансовогоОтчета.СтатьяБюджетов), Истина);
		НайденныеСтроки = Таблица.Строки.НайтиСтроки(Новый Структура("ВидЭлемента", Перечисления.ВидыЭлементовФинансовогоОтчета.ПоказательБюджетов), Истина);
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(НайденныеСтроки, СтатьиБюджета);
		
		ЕстьСумма = Ложь;
		ЕстьКоличество = Ложь;
		Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			ВидПоказателей = ФинансоваяОтчетностьВызовСервера.ЗначениеДополнительногоРеквизита(НайденнаяСтрока.АдресСтруктурыЭлемента, "ВыводимыеПоказатели");
			Если ВидПоказателей = Перечисления.ТипыВыводимыхПоказателейБюджетногоОтчета.Количество
				ИЛИ ВидПоказателей = Перечисления.ТипыВыводимыхПоказателейБюджетногоОтчета.КоличествоИСумма Тогда
				ЕстьКоличество = Истина;
			КонецЕсли;
			Если ВидПоказателей = Перечисления.ТипыВыводимыхПоказателейБюджетногоОтчета.Сумма
				ИЛИ ВидПоказателей = Перечисления.ТипыВыводимыхПоказателейБюджетногоОтчета.КоличествоИСумма Тогда
				ЕстьСумма = Истина;
			КонецЕсли;
			Если ЕстьКоличество И ЕстьСумма Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если ЕстьКоличество Тогда
			МассивПоказателей.Добавить("Количество");
		КонецЕсли;
		
		Если ЕстьСумма Тогда
			МассивПоказателей.Добавить("Сумма");
		КонецЕсли;
		
	КонецЕсли;
	
	Если ТипОформляемойОбласти = Перечисления.ТипыОформляемыхОбластейБюджетныхОтчетов.ЯчейкиНаПересеченииСтрокИКолонок Тогда
		
		Для Каждого Показатель Из МассивПоказателей Цикл
		
			ПолеНабора = ФинансоваяОтчетностьСервер.НовоеПолеНабора(Набор, Показатель.Значение, Показатель.Значение, 
										Показатель.Представление, ОбщегоНазначенияУТ.ОписаниеТипаДенежногоПоля());
		
		КонецЦикла;
		
	Иначе
		
		Для Каждого Поле Из Параметры.ПоляОтбораЗначений Цикл
			
			Элемент = ПолучитьИзВременногоХранилища(Поле);
			ИмяЯчейки = СтрЗаменить(Элемент.НаименованиеДляПечати, ".", " ");
			
			Для Каждого Показатель Из МассивПоказателей Цикл
			
				ИмяПоля = "Отбор_" + ИмяЯчейки + " " + Показатель.Значение;
				
				ПолеНабора = ФинансоваяОтчетностьСервер.НовоеПолеНабора(Набор, ИмяПоля, ИмяПоля, 
									"[" + ИмяЯчейки + "] " + Показатель.Значение, ОбщегоНазначенияУТ.ОписаниеТипаДенежногоПоля());
				
				Если Не РасшифровкаПолейОтбораЭО.НайтиСтроки(
							Новый Структура("ЭлементОтчета, ИмяРесурса", Поле, Показатель)).Количество() Тогда
					НоваяСтрока = РасшифровкаПолейОтбораЭО.Добавить();
					НоваяСтрока.ЭлементОтчета = Поле;
					НоваяСтрока.ИмяПоляОтбора = ИмяПоля;
					НоваяСтрока.ИмяРесурса = Показатель.Значение;
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЕсли;
	
	АдресСхемы = ПоместитьВоВременноеХранилище(СКД, УникальныйИдентификатор);
	ИсточникДоступныхНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемы);
	Условия.Инициализировать(ИсточникДоступныхНастроек);
	Если Параметры.Свойство("Условие") Тогда
		Условия.ЗагрузитьНастройки(ПолучитьИзВременногоХранилища(Параметры.Условие));
	Иначе
		Условия.ЗагрузитьНастройки(СКД.НастройкиПоУмолчанию);
	КонецЕсли;
	
	ЦветФона = Новый Структура;
	ЦветФона.Вставить("Имя",         "ЦветФона");
	ЦветФона.Вставить("ПоУмолчанию", ЦветаСтиля.ЦветФонаПоля);
	ЦветФона.Вставить("Тип",         "Цвет");
	ЦветФона.Вставить("Порядок",     1);
	
	ЦветТекста = Новый Структура;
	ЦветТекста.Вставить("Имя",         "ЦветТекста");
	ЦветТекста.Вставить("ПоУмолчанию", ЦветаСтиля.ЦветТекстаПоля);
	ЦветТекста.Вставить("Тип",         "Цвет");
	ЦветТекста.Вставить("Порядок",     2);
	
	ЦветГраницы = Новый Структура;
	ЦветГраницы.Вставить("Имя",         "ЦветГраницы");
	ЦветГраницы.Вставить("ПоУмолчанию", ЦветаСтиля.ЦветЛинииОтчета);
	ЦветГраницы.Вставить("Тип",         "Цвет");
	ЦветГраницы.Вставить("Порядок",     3);
	
	Шрифт = Новый Структура;
	Шрифт.Вставить("Имя",         "Шрифт");
	Шрифт.Вставить("ПоУмолчанию", ШрифтыСтиля.ШрифтТекста);
	Шрифт.Вставить("Тип",         "Шрифт");
	Шрифт.Вставить("Порядок",     4);
	
	СвойстваГоризонтальногоПоложения = Новый Структура;
	СвойстваГоризонтальногоПоложения.Вставить("Имя",         "ГоризонтальноеПоложение");
	СвойстваГоризонтальногоПоложения.Вставить("ПоУмолчанию", ГоризонтальноеПоложение.Авто);
	СвойстваГоризонтальногоПоложения.Вставить("Тип",         "ГоризонтальноеПоложение");
	СвойстваГоризонтальногоПоложения.Вставить("Порядок",     5);
	
	СвойстваВертикальногоПоложения = Новый Структура;
	СвойстваВертикальногоПоложения.Вставить("Имя",         "ВертикальноеПоложение");
	СвойстваВертикальногоПоложения.Вставить("ПоУмолчанию", ВертикальноеПоложение.Центр);
	СвойстваВертикальногоПоложения.Вставить("Тип",         "ВертикальноеПоложение");
	СвойстваВертикальногоПоложения.Вставить("Порядок",     6);
	
	ОриентацияТекста = Новый Структура;
	ОриентацияТекста.Вставить("Имя",         "ОриентацияТекста");
	ОриентацияТекста.Вставить("ПоУмолчанию", 0);
	ОриентацияТекста.Вставить("Тип",         "ОриентацияТекста");
	ОриентацияТекста.Вставить("Порядок",     7);
	
	СвойстваФорматаСтроки = Новый Структура;
	СвойстваФорматаСтроки.Вставить("Имя",         "Формат");
	СвойстваФорматаСтроки.Вставить("ПоУмолчанию", "");
	СвойстваФорматаСтроки.Вставить("Тип",         "Формат");
	СвойстваФорматаСтроки.Вставить("Порядок",     8);
	
	СоответствиеПараметров = Новый Соответствие;
	СоответствиеПараметров.Вставить(НСтр("ru = 'Цвет фона'"),                ЦветФона);
	СоответствиеПараметров.Вставить(НСтр("ru = 'Цвет текста'"),              ЦветТекста);
	СоответствиеПараметров.Вставить(НСтр("ru = 'Цвет границы'"),             ЦветГраницы);
	СоответствиеПараметров.Вставить(НСтр("ru = 'Шрифт'"),                    Шрифт);
	СоответствиеПараметров.Вставить(НСтр("ru = 'Горизонтальное положение'"), СвойстваГоризонтальногоПоложения);
	СоответствиеПараметров.Вставить(НСтр("ru = 'Вертикальное положение'"),   СвойстваВертикальногоПоложения);
	СоответствиеПараметров.Вставить(НСтр("ru = 'Ориентация текста'"),        ОриентацияТекста);
	СоответствиеПараметров.Вставить(НСтр("ru = 'Формат'"),                   СвойстваФорматаСтроки);
	
	АдресСоответствияПараметров = ПоместитьВоВременноеХранилище(СоответствиеПараметров, УникальныйИдентификатор);
	
	ПредыдущееОформление = Неопределено;
	Если Параметры.Свойство("Оформление") Тогда
		ПредыдущееОформление = ПолучитьИзВременногоХранилища(Параметры.Оформление);
	КонецЕсли;
	
	Для Каждого КлючИЗначение Из СоответствиеПараметров Цикл
		
		НоваяСтрока = Оформление.Добавить();
		НоваяСтрока.Параметр = КлючИЗначение.Ключ;
		НоваяСтрока.Порядок = КлючИЗначение.Значение.Порядок;
		Если ПредыдущееОформление <> Неопределено Тогда
			ЗначениеОформления = ПредыдущееОформление.Найти(КлючИЗначение.Ключ, "Параметр");
			Если ЗначениеОформления <> Неопределено Тогда
				НоваяСтрока.Использование = ЗначениеОформления.Использование;
				НоваяСтрока[КлючИЗначение.Значение.Тип] = ЗначениеОформления.Оформление;
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		НоваяСтрока[КлючИЗначение.Значение.Тип] = КлючИЗначение.Значение.ПоУмолчанию;
		
	КонецЦикла;
	
	Оформление.Сортировать("Порядок");
	ЭтаФорма.КлючСохраненияПоложенияОкна = "ВариантОкна_" + ОбщегоНазначения.ИмяЗначенияПеречисления(ТипОформляемойОбласти);
	УправлениеФормой();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормы

&НаКлиенте
Процедура ДеревоОформленияФорматНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Конструктор = Новый КонструкторФорматнойСтроки;
	Конструктор.Текст = Элементы.ДеревоОформления.ТекущиеДанные.Формат;
	Конструктор.ДоступныеТипы = Новый ОписаниеТипов("Число, Дата");
	ОписаниеОповещение = Новый ОписаниеОповещения("ПриВыбореФормата", ЭтаФорма);
	Конструктор.Показать(ОписаниеОповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОформленияЦветПриИзменении(Элемент)
	
	УстановитьФлагТекущейСтроки();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОформленияШрифтПриИзменении(Элемент)
	
	УстановитьФлагТекущейСтроки();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОформленияФорматПриИзменении(Элемент)
	
	УстановитьФлагТекущейСтроки();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОформленияГоризонтальноеПоложениеПриИзменении(Элемент)
	
	УстановитьФлагТекущейСтроки();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОформленияВертикальноеПоложениеПриИзменении(Элемент)
	
	УстановитьФлагТекущейСтроки();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОформленияОриентацияТекстаПриИзменении(Элемент)
	
	УстановитьФлагТекущейСтроки();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗавершитьРедактирование(Команда)
	
	Закрыть(ПолучитьАдресРезультата());
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПриВыбореФормата(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ДеревоОформления.ТекущиеДанные.Формат = Результат;
	УстановитьФлагТекущейСтроки();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлагТекущейСтроки()
	
	ТекущиеДанные = Элементы.ДеревоОформления.ТекущиеДанные;
	ТекущиеДанные.Использование = Истина;
	
КонецПроцедуры

&НаСервере
Процедура УправлениеФормой()
	
	ВидимостьСтрок = Истина;
	ВидимостьКолонок = Истина;
	МожноНакладыватьОтбор = Истина;
	
	Если ТипОформляемойОбласти = Перечисления.ТипыОформляемыхОбластейБюджетныхОтчетов.ВсяТаблица Тогда
		ВидимостьСтрок = Ложь;
		ВидимостьКолонок = Ложь;
		МожноНакладыватьОтбор = Ложь;
	ИначеЕсли ТипОформляемойОбласти = Перечисления.ТипыОформляемыхОбластейБюджетныхОтчетов.ВсяКолонка Тогда
		ВидимостьСтрок = Ложь;
	ИначеЕсли ТипОформляемойОбласти = Перечисления.ТипыОформляемыхОбластейБюджетныхОтчетов.ВсяСтрока Тогда
		ВидимостьКолонок = Ложь;
	ИначеЕсли ТипОформляемойОбласти = Перечисления.ТипыОформляемыхОбластейБюджетныхОтчетов.ЗаголовкиКолонок Тогда
		ВидимостьСтрок = Ложь;
	ИначеЕсли ТипОформляемойОбласти = Перечисления.ТипыОформляемыхОбластейБюджетныхОтчетов.ЗаголовкиСтрок Тогда
		ВидимостьКолонок = Ложь;
	КонецЕсли;
	
	Элементы.ОформляемыеКолонки.Видимость 	= ВидимостьКолонок;
	Элементы.ОформляемыеСтроки.Видимость 	= ВидимостьСтрок;
	Элементы.СтраницаУсловие.Видимость 		= МожноНакладыватьОтбор;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьАдресРезультата()
	
	РезультатОформления = Оформление.Выгрузить();
	НайденныеСтроки = РезультатОформления.НайтиСтроки(Новый Структура("Использование", Ложь));
	Для Каждого СтрокаТаблицы Из НайденныеСтроки Цикл
		РезультатОформления.Удалить(СтрокаТаблицы);
	КонецЦикла;
	
	СоответствиеПараметров = ПолучитьИзВременногоХранилища(АдресСоответствияПараметров);
	ПриведенныйРезультат = РезультатОформления.СкопироватьКолонки("Использование, Параметр");
	ПриведенныйРезультат.Колонки.Добавить("Оформление");
	Для Каждого СтрокаРезультата Из РезультатОформления Цикл
		НоваяСтрока = ПриведенныйРезультат.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаРезультата);
		НоваяСтрока.Оформление = СтрокаРезультата[СоответствиеПараметров[СтрокаРезультата.Параметр].Тип];
	КонецЦикла;
	
	СтруктураРезультат = Новый Структура;
	СтруктураРезультат.Вставить("Оформление", ПриведенныйРезультат);
	СтруктураРезультат.Вставить("Условие", Условия.ПолучитьНастройки());
	СтруктураРезультат.Вставить("ТипОформляемойОбласти", ТипОформляемойОбласти);
	СтруктураРезультат.Вставить("КлючЭлементаОформления", КлючЭлементаОформления);
	СтруктураРезультат.Вставить("ОформляемыеСтроки", ОформляемыеСтроки.Выгрузить());
	СтруктураРезультат.Вставить("ОформляемыеКолонки", ОформляемыеКолонки.Выгрузить());
	СтруктураРезультат.Вставить("РасшифровкаПолейОтбораЭО", РасшифровкаПолейОтбораЭО.Выгрузить());
	
	Возврат ПоместитьВоВременноеХранилище(СтруктураРезультат);
	
КонецФункции

#КонецОбласти

