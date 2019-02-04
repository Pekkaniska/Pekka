
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьДеревоПодразделений(Дерево.ПолучитьЭлементы(), "DMSubdivision", "");
	ЭлементВсеПользователи = Дерево.ПолучитьЭлементы().Вставить(0);
	ЭлементВсеПользователи.Наименование = НСтр("ru = 'Все пользователи'");
	ЭлементВсеПользователи.ID = "";
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДерево

&НаКлиенте
Процедура ДеревоПередРазворачиванием(Элемент, Строка, Отказ)
	
	Лист = Дерево.НайтиПоИдентификатору(Строка);
	
	Если Лист = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Лист.ID) И НЕ Лист.ПодпапкиСчитаны Тогда
		ЗаполнитьДеревоПапокПоИдентификатору(Строка, Лист.ID);
		Лист.ПодпапкиСчитаны = Истина;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ОбработкаОжидания", 0.2, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокПользователей

&НаКлиенте
Процедура СписокПользователейВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ВыбратьВыполнить();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	ВыбратьВыполнить();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьДеревоПодразделений(ВеткаДерева, ТипОбъектаВыбора, ИдентификаторПапки = Неопределено, СтрокаПоиска = Неопределено)
	
	ВеткаДерева.Очистить();
	Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();
	
	УсловияОтбораОбъектов = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMObjectListQuery");
	Если ИдентификаторПапки <> Неопределено Тогда
		РодительИд = ИнтеграцияС1СДокументооборот.СоздатьObjectID(Прокси, ИдентификаторПапки, ТипОбъектаВыбора);
		
		Условие = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMObjectListCondition");
		Условие.property = "parent";
		Условие.value = РодительИд;
		
		УсловияОтбораОбъектов.conditions.Добавить(Условие);
	КонецЕсли;
	
	Если СтрокаПоиска <> Неопределено Тогда
		Условие = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMObjectListCondition");
		Условие.property = "name";
		Условие.value = СтрокаПоиска;
		
		УсловияОтбораОбъектов.conditions.Добавить(Условие);
	КонецЕсли;
	
	Если ТипЗнч(Отбор) = Тип("Структура") Тогда 
		Для Каждого СтрокаОтбора Из Отбор Цикл
			Условие = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMObjectListCondition");
			Условие.property = СтрокаОтбора.Ключ;
			
			Если ТипЗнч(СтрокаОтбора.Значение) = Тип("Структура") Тогда
				Условие.value = ИнтеграцияС1СДокументооборот.СоздатьObjectID(Прокси, СтрокаОтбора.Значение.id, СтрокаОтбора.Значение.type);
			Иначе
				Условие.value = СтрокаОтбора.Значение;
			КонецЕсли;
		
			УсловияОтбораОбъектов.conditions.Добавить(Условие);
		КонецЦикла;
	КонецЕсли;
	
	Запрос = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMGetObjectListRequest");
	Запрос.type = ТипОбъектаВыбора;
	Запрос.query = УсловияОтбораОбъектов;
	
	Результат = Прокси.execute(Запрос);
	ИнтеграцияС1СДокументооборот.ПроверитьВозвратВебСервиса(Прокси, Результат);
	
	Для Каждого Элемент Из Результат.items Цикл
		
		НоваяСтрока = ВеткаДерева.Добавить();
		НоваяСтрока.Наименование = Элемент.object.name;
		НоваяСтрока.ID = Элемент.object.objectId.id;
		НоваяСтрока.Тип = Элемент.object.objectId.type;
		
		Если ТипОбъектаВыбора = "DMFileFolder" Тогда
			НоваяСтрока.Картинка = 0;
		Иначе
			Если Элемент.isFolder Тогда
				НоваяСтрока.Картинка = 0;
			Иначе	
				НоваяСтрока.Картинка = 0;
			КонецЕсли;
		КонецЕсли;
		
		Если Элемент.CanHaveChildren И (СтрокаПоиска = Неопределено) Тогда
			НоваяСтрока.ПодпапкиСчитаны = Ложь;
			НоваяСтрока.ПолучитьЭлементы().Добавить(); // чтобы появился плюсик
		Иначе
			НоваяСтрока.ПодпапкиСчитаны = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокПользователей(ПодразделениеИД)
	
	Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();
	
	//получение руководителя текущего подразделения
	Если ЗначениеЗаполнено(ПодразделениеИД) Тогда
		Подразделения = ИнтеграцияС1СДокументооборот.ПолучитьОбъект(Прокси, "DMSubdivision", ПодразделениеИД);
		Если Подразделения.objects[0].head <> неопределено Тогда
			IDРуководителя = Подразделения.objects[0].head.objectId.id;
		КонецЕсли;
	КонецЕсли;
	
	//заполнение списка пользователей	
	Запрос = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMGetObjectListRequest");
	Запрос.type = "DMUser";
	
	УсловияОтбораОбъектов = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMObjectListQuery");
	Если ЗначениеЗаполнено(ПодразделениеИД) Тогда
		Условие = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMObjectListCondition");
		Условие.property = "Subdivision";
		Условие.value = ИнтеграцияС1СДокументооборот.СоздатьObjectID(Прокси, ПодразделениеИД, "DMSubdivision");
		
		УсловияОтбораОбъектов.conditions.Добавить(Условие);
		Запрос.query = УсловияОтбораОбъектов;
	КонецЕсли;
	
	Результат = Прокси.execute(Запрос);
	ИнтеграцияС1СДокументооборот.ПроверитьВозвратВебСервиса(Прокси, Результат);
	
	СписокПользователей.Очистить();
	Для Каждого ПользовательВСписке Из Результат.Items Цикл
		НоваяСтрока = СписокПользователей.Добавить();
		НоваяСтрока.Наименование = ПользовательВСписке.object.name;
		НоваяСтрока.ID = ПользовательВСписке.object.objectId.id;
		НоваяСтрока.Тип = ПользовательВСписке.object.objectId.type;
		НоваяСтрока.Руководитель = (IDРуководителя = ПользовательВСписке.object.objectId.id);
	КонецЦикла;
	
	СписокПользователей.Сортировать("Наименование Возр");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоПапокПоИдентификатору(ИдентификаторЭлементаДерева, ИдентификаторПапки)
	
	Лист = Дерево.НайтиПоИдентификатору(ИдентификаторЭлементаДерева);
	
	Если Лист = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьДеревоПодразделений(Лист.ПолучитьЭлементы(), "DMSubdivision", Лист.ID);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОжидания()
	
	ЗаполнитьСписокПользователей(Элементы.Дерево.ТекущиеДанные.ID);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВыполнить()
	
	ТекущиеДанные = Элементы.СписокПользователей.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("РеквизитID",  ТекущиеДанные.ID);
	Результат.Вставить("РеквизитТип", ТекущиеДанные.Тип);
	Результат.Вставить("РеквизитПредставление", ТекущиеДанные.Наименование);
	
	Закрыть(Результат);
	
КонецПроцедуры

#КонецОбласти
