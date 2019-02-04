#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьПараметрыДинамическогоСписка();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если Метаданные.ПланыСчетов.Найти("Хозрасчетный") <> Неопределено Тогда
		Элементы.КорреспондирующийСчет.Видимость = Ложь;
	КонецЕсли;
	
	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.ПланыВидовХарактеристик.СтатьиРасходов);
	Элементы.ФормаИзменитьВыделенные.Видимость = МожноРедактировать;
	Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = МожноРедактировать;
	
	ФормироватьФинансовыйРезультат = ПолучитьФункциональнуюОпцию("ФормироватьФинансовыйРезультат");
	
	ПараметрыФО = Новый Структура("Период, Организация", Дата(1,1,1), Справочники.Организации.ПустаяСсылка());
	УстановитьПараметрыФункциональныхОпцийФормы(ПараметрыФО);
	//++ НЕ УТ
	Если Параметры.ПараметрыФункциональныхОпций.Свойство("Организация") И Параметры.ПараметрыФункциональныхОпций.Свойство("Период") Тогда
		УстановитьПараметрыФункциональныхОпцийФормы(Параметры.ПараметрыФункциональныхОпций);
	КонецЕсли;
	//-- НЕ УТ
	
	ЭтоУТБазовая = ПолучитьФункциональнуюОпцию("БазоваяВерсия");
	Если ЭтоУТБазовая Тогда
		Элементы.ВариантРаспределенияРасходовРегл.Заголовок = НСтр("ru = 'Вариант распределения'");
		Элементы.ВариантРаспределенияРасходовУпр.Видимость = Ложь;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	СписокТипов = Список.КомпоновщикНастроек.Настройки.Выбор.ДоступныеПоляВыбора.НайтиПоле(Новый ПолеКомпоновкиДанных("Ссылка")).Тип;
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.Источники = СписокТипов;
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ФормаКоманднаяПанель;
	
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы


&НаКлиенте
Процедура ПризнаниеРасходовПриИзменении(Элемент)
	
	//++ НЕ УТ
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ПризнаватьРасходамиПриУСН", ПризнаниеРасходов = 1,,, ПризнаниеРасходов);
	//-- НЕ УТ
	Возврат; // в УТ пустой
	
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

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
	
КонецПроцедуры


&НаКлиенте
Процедура ПризнаватьРасходом(Команда)
	
	//++ НЕ УТ
	УстановитьПризнаниеРасхода(Истина);
	//-- НЕ УТ
	Возврат; // в УТ пустой
	
КонецПроцедуры

&НаКлиенте
Процедура НеПризнаватьРасходом(Команда)
	
	//++ НЕ УТ
	УстановитьПризнаниеРасхода(Ложь);
	//-- НЕ УТ
	Возврат; // в УТ пустой
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьПараметрыДинамическогоСписка()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Ссылка",
		ПланыВидовХарактеристик.СтатьиРасходов.ЗаблокированныеСтатьиРасходов(),
		ВидСравненияКомпоновкиДанных.НеВСписке);

	
КонецПроцедуры

//++ НЕ УТ

&НаКлиенте
Процедура УстановитьПризнаниеРасхода(ПризнаватьРасходом)
	
	ВыделенныеСтроки = Элементы.Список.ВыделенныеСтроки;
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='Расходы по выделенным статьям%1 будут признаваться для целей УСН. Продолжить?'");
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстВопроса, ?(ПризнаватьРасходом, "", " " + НСтр("ru = 'не'")));
	
	ПараметрыОповещения = Новый Структура("ВыделенныеСтроки, НовоеЗначение", ВыделенныеСтроки, ПризнаватьРасходом);
	ОповещениеПризнаниеРасходаЗавершение = Новый ОписаниеОповещения("УстановитьПризнаниеРасходаЗавершение", ЭтотОбъект, ПараметрыОповещения);
	ПоказатьВопрос(ОповещениеПризнаниеРасходаЗавершение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПризнаниеРасходаЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	ВыделенныеСтроки = ДополнительныеПараметры.ВыделенныеСтроки;
        
    Ответ = РезультатВопроса;
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        Возврат;
	КонецЕсли;
	
	ОчиститьСообщения();
		
	МассивИзменяемыхСсылок = СписокСсылокПоВыбраннымСтрокамДинамическогоСписка(ДополнительныеПараметры.ВыделенныеСтроки);
	                                                                                  
	// Присваиваем объектам новые значения.
	ВыполнитьИзменениеОбъектов(МассивИзменяемыхСсылок, ДополнительныеПараметры.НовоеЗначение);
	
КонецПроцедуры
	
&НаСервере
Функция СписокСсылокПоВыбраннымСтрокамДинамическогоСписка(ВыделенныеСтрокиСписка)
	
	#Область ПодготовкаОтбораПоДинамическомуСпискуИЕгоВыделеннымЭлементам
	
	ОтборСписка = Новый ОтборКомпоновкиДанных;
	
	ОтборПоГруппировке = Неопределено;
	ОтборПоСсылке = Неопределено;
	
	Для каждого ТекущаяСтрокаСписка Из ВыделенныеСтрокиСписка Цикл
		
		Если ТипЗнч(ТекущаяСтрокаСписка) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			Если ОтборПоГруппировке = Неопределено Тогда
				ОтборПоГруппировке = КомпоновкаДанныхКлиентСервер.ДобавитьОтбор(ОтборСписка,
																				ТекущаяСтрокаСписка.ИмяГруппировки,
																				ТекущаяСтрокаСписка.Ключ);
			Иначе
				ОтборПоГруппировке.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
				Если Не ТипЗнч(ОтборПоГруппировке.ПравоеЗначение) = Тип("СписокЗначений") Тогда
					СписокДляОтбора = Новый СписокЗначений;
					СписокДляОтбора.Добавить(ОтборПоГруппировке.ПравоеЗначение);
					ОтборПоГруппировке.ПравоеЗначение = СписокДляОтбора;
				КонецЕсли;	
				ОтборПоГруппировке.ПравоеЗначение.Добавить(ТекущаяСтрокаСписка.Ключ);
			КонецЕсли;
		Иначе
			
			Если ОтборПоСсылке = Неопределено Тогда
				ТекущийВидСравнения = ВидСравненияКомпоновкиДанных.ВИерархии;
				ОтборПоСсылке = КомпоновкаДанныхКлиентСервер.ДобавитьОтбор(ОтборСписка, "Ссылка", ТекущаяСтрокаСписка, ТекущийВидСравнения);
			Иначе
				ОтборПоСсылке.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСпискеПоИерархии;
				Если Не ТипЗнч(ОтборПоСсылке.ПравоеЗначение) = Тип("СписокЗначений") Тогда
					СписокДляОтбора = Новый СписокЗначений;
					СписокДляОтбора.Добавить(ОтборПоСсылке.ПравоеЗначение);
					ОтборПоСсылке.ПравоеЗначение = СписокДляОтбора;
				КонецЕсли;	
				ОтборПоСсылке.ПравоеЗначение.Добавить(ТекущаяСтрокаСписка);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	КомпоновкаДанныхКлиентСервер.СкопироватьЭлементы(ОтборСписка, Список.Отбор, Ложь);
	КомпоновкаДанныхКлиентСервер.СкопироватьЭлементы(ОтборСписка, Список.КомпоновщикНастроек.Настройки.Отбор, Ложь);	
	// Исключим группы из списка ссылок:
	КомпоновкаДанныхКлиентСервер.ДобавитьОтбор(ОтборСписка, "ЭтоГруппа", Ложь, ВидСравненияКомпоновкиДанных.Равно);
	
	#КонецОбласти
	
	#Область ПолучениеСпискаСсылокНаОснованииОтбора
	
	ИзменениеРеквизитов = Обработки.ГрупповоеИзменениеРеквизитов.Создать();
	
	// Определим текст запроса:
	Если ЗначениеЗаполнено(Список.ТекстЗапроса) Тогда
		ТекстЗапроса = Список.ТекстЗапроса;
	Иначе
		ТекстЗапроса = ИзменениеРеквизитов.ТекстЗапроса(Список.ОсновнаяТаблица);
	КонецЕсли;
	
	СхемаКомпоновкиДанных = ИзменениеРеквизитов.СхемаКомпоновкиДанных(ТекстЗапроса);
	
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	НастройкиКомпоновки = КомпоновщикНастроек.Настройки;
	КомпоновкаДанныхКлиентСервер.СкопироватьЭлементы(НастройкиКомпоновки.Отбор, ОтборСписка);
	
	ГруппировкаСКД = ФинансоваяОтчетностьСервер.НоваяГруппировка(КомпоновщикНастроек.Настройки.Структура, "Ссылка");
	ФинансоваяОтчетностьСервер.НовоеПолеГруппировки(ГруппировкаСКД, "ВариантРаспределенияРасходовРегл");
	ФинансоваяОтчетностьСервер.НовоеПолеГруппировки(ГруппировкаСКД, "ВидДеятельностиДляНалоговогоУчетаЗатрат");
	ТаблицаИзменяемыхОбъектов = ФинансоваяОтчетностьСервер.ВыгрузитьРезультатСКД(СхемаКомпоновкиДанных, НастройкиКомпоновки);
		
	#КонецОбласти
	
	#Область ВыборкаСсылокДоступныхДляИзменения
	// Если СтатьяРасходов имеет варианты распределения "На внеоборотные активы", "На себестоимость товаров" или относится
	// к ЕНВД, то значение реквизита признания изменять нельзя.
	
	МассивСсылокДляИзменения = Новый Массив;
	МассивСсылокНеДоступныхДляИзменения = Новый Массив;
	Для каждого СтрокаИзменяемогоОбъекта Из ТаблицаИзменяемыхОбъектов Цикл
		Если СтрокаИзменяемогоОбъекта.ВариантРаспределенияРасходовРегл = Перечисления.ВариантыРаспределенияРасходов.НаВнеоборотныеАктивы
			ИЛИ СтрокаИзменяемогоОбъекта.ВариантРаспределенияРасходовРегл = Перечисления.ВариантыРаспределенияРасходов.НаСебестоимостьТоваров
			ИЛИ СтрокаИзменяемогоОбъекта.ВидДеятельностиДляНалоговогоУчетаЗатрат = Перечисления.ВидыДеятельностиДляНалоговогоУчетаЗатрат.ОсобыйПорядокНалогообложения Тогда
			
			// Данная статья расходов не должна попадать в список для дальнейшего изменения.
			МассивСсылокНеДоступныхДляИзменения.Добавить(СтрокаИзменяемогоОбъекта.Ссылка);
		Иначе
			МассивСсылокДляИзменения.Добавить(СтрокаИзменяемогоОбъекта.Ссылка);
		КонецЕсли;
	КонецЦикла;
	
	Если МассивСсылокНеДоступныхДляИзменения.Количество() Тогда
		ТекстСообщенияПользователю = НСтр("ru = 'Изменение флага ""Признание расходов при УСН"" недоступно для следующих статей расходов: %СтатьиРасходов%.'");
		ТекстСообщенияПользователю = СтрЗаменить(ТекстСообщенияПользователю, "%СтатьиРасходов%", СтрСоединить(МассивСсылокНеДоступныхДляИзменения, ", "));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщенияПользователю);
	КонецЕсли;
		
	Возврат МассивСсылокДляИзменения;
	
	#КонецОбласти
	
КонецФункции

#Область ВыполнениеОперацийНадВыбраннымиОбъектами

&НаКлиенте
Процедура ВыполнитьИзменениеОбъектов(ОбъектыДляИзменения, ПрисваиваемоеЗначение)
	
	Если Не ТипЗнч(ОбъектыДляИзменения) = Тип("Массив") ИЛИ ОбъектыДляИзменения.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОбработкиИзменения = ПараметрыОбработкиИзменения();
	ПараметрыОбработкиИзменения.ИмяМетаданныхОбъекта = "ПланВидовХарактеристик.СтатьиРасходов";
	ПараметрыОбработкиИзменения.ИзменяемыеРеквизиты = Новый Структура("ПризнаватьРасходамиПриУСН", ПрисваиваемоеЗначение);
	ПараметрыОбработкиИзменения.ОбрабатываемыеОбъекты = ОбъектыДляИзменения;
	
	Результат = ВыполнитьИзменениеОбъектовВФоновомЗадании(ПараметрыОбработкиИзменения, УникальныйИдентификатор);
	
	Если Результат.Статус = "Выполняется" Тогда
		
		ПараметрыФормаДлительнойОперации = ПараметрыФормыДлительнойОперации();
		ПараметрыФормаДлительнойОперации.ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		
		ОповещениеОЗакрытии = Новый ОписаниеОповещения("ИзменениеОбъектовЗавершено", ЭтотОбъект);
		
		ОткрытьФорму("ОбщаяФорма.ДлительнаяОперация", ПараметрыФормаДлительнойОперации, ЭтотОбъект, , , , ОповещениеОЗакрытии);
		
	Иначе
		
		ИзменениеОбъектовЗавершено(Результат);
		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Функция ПараметрыОбработкиИзменения()
	
	ПараметрыОбработкиИзменения = Новый Структура;
	ПараметрыОбработкиИзменения.Вставить("ИмяМетаданныхОбъекта");
	ПараметрыОбработкиИзменения.Вставить("ИзменяемыеРеквизиты");
	ПараметрыОбработкиИзменения.Вставить("ОбрабатываемыеОбъекты");
	
	Возврат ПараметрыОбработкиИзменения;
	
КонецФункции

&НаКлиенте
Функция ПараметрыФормыДлительнойОперации()
	
	ПараметрыДлительнойОперации = Новый Структура;
	ПараметрыДлительнойОперации.Вставить("ИдентификаторЗадания");
	ПараметрыДлительнойОперации.Вставить("ВыводитьОкноОжидания", Истина);
	ПараметрыДлительнойОперации.Вставить("ВыводитьПрогрессВыполнения", Истина);
	ПараметрыДлительнойОперации.Вставить("ВыводитьСообщения", Истина);
	
	Возврат ПараметрыДлительнойОперации;
	
КонецФункции

&НаСервереБезКонтекста
Функция ВыполнитьИзменениеОбъектовВФоновомЗадании(ПараметрыОбработки, УникальныйИдентификатор)
	
	ВыполняемыйМетод = "Обработки.ПомощникПодготовкиУведомленияОКонтролируемыхСделках.УстановитьНовыеЗначенияДляСпискаОбъектов";
	
	ПараметрыФоновогоЗадания = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыФоновогоЗадания.ОжидатьЗавершение = 0.5;
	ПараметрыФоновогоЗадания.НаименованиеФоновогоЗадания = НСтр("ru = 'Групповое изменение реквизита ""ПризнаватьРасходамиПриУСН"" для списка статей расходов'");
	ПараметрыФоновогоЗадания.КлючФоновогоЗадания = "ИзменениеРеквизитаПризнаватьРасходамиПриУСН";
	
	РезультатФоновогоЗадания = ДлительныеОперации.ВыполнитьВФоне(ВыполняемыйМетод, ПараметрыОбработки, ПараметрыФоновогоЗадания);
			
	Возврат РезультатФоновогоЗадания;
	
КонецФункции

&НаКлиенте
Процедура ИзменениеОбъектовЗавершено(Результат, Параметры = Неопределено) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		
		Если ЗначениеЗаполнено(Результат.АдресРезультата) Тогда
			СтрокаОшибок = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
			
			Если ЗначениеЗаполнено(СтрокаОшибок) Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаОшибок);
			КонецЕсли;
		КонецЕсли;
		
		// Обновляем данные формы:
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

//-- НЕ УТ

#КонецОбласти
