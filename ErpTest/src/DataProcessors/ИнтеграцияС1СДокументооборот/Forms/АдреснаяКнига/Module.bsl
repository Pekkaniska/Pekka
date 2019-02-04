
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("ТипАдресатов") Тогда
		ТипАдресатов = Параметры.ТипАдресатов;
	Иначе
		ТипАдресатов = "СотрудникиПоПодразделениям";
	КонецЕсли;
	
	Если ИнтеграцияС1СДокументооборотПовтИсп.ИспользоватьТерминКорреспонденты() Тогда
		Элементы.ОткрытьКонтрагенты.Заголовок = НСтр("ru = 'Корреспонденты'");
	КонецЕсли;
	
	ЗаполнитьАдреснуюКнигу(ТипАдресатов);
	ОбновитьКомандыПереходаКСтраницамНаСервере(Элементы.ОткрытьСотрудникиПоПодразделениям);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОткрытьСотрудникиСпискомНажатие(Элемент)
	
	ЗаполнитьАдреснуюКнигуНаСервере(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСотрудникиПоПодразделениямНажатие(Элемент)
	
	ЗаполнитьАдреснуюКнигуНаСервере(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСотрудникиПоГруппамНажатие(Элемент)
	
	ЗаполнитьАдреснуюКнигуНаСервере(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКонтрагентыНажатие(Элемент)
	
	ЗаполнитьАдреснуюКнигуНаСервере(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЛичныеАдресатыНажатие(Элемент)
	
	ЗаполнитьАдреснуюКнигуНаСервере(Элемент.Имя);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыАдресаты

&НаКлиенте
Процедура АдресатыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	МассивАдресатов = Новый Массив;
	
	МассивСтрок = Элементы.Адресаты.ВыделенныеСтроки;
	Если МассивСтрок.Количество() <> 0 Тогда
		Для каждого ЭлементМассива из МассивСтрок Цикл
			СтрокаАдресата = Адресаты.НайтиПоИдентификатору(ЭлементМассива);
			Если СтрокаАдресата.Адреса.Количество() > 0 Тогда
				СтрокаТаблицы = новый Структура("Адресат, ТипАдресатов, АдресатID, АдресатТип, АдресатАдрес");
				ЗаполнитьЗначенияСвойств(СтрокаТаблицы,СтрокаАдресата);
				СтрокаТаблицы.АдресатАдрес = СтрокаАдресата.Адреса[0].Адрес;
				СтрокаТаблицы.Адресат = СтрокаТаблицы.Адресат + "<" + СтрокаТаблицы.АдресатАдрес + ">";
				МассивАдресатов.Добавить(СтрокаТаблицы);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если МассивАдресатов.Количество() > 0 Тогда
		СтандартнаяОбработка = Ложь;
		Закрыть(МассивАдресатов);
	Иначе
		СтандартнаяОбработка = Истина;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура АдресатыАдресаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	МассивАдресатов = Новый Массив;
	МассивАдресов = Элементы.АдресатыАдреса.ВыделенныеСтроки;
	СтрокаАдресата = Элементы.Адресаты.ТекущиеДанные;
	
	Если МассивАдресов.Количество() <> 0 Тогда
		Для каждого ЭлементМассива из МассивАдресов Цикл
			СтрокаТаблицы = новый Структура("Адресат, ТипАдресатов, АдресатID, АдресатТип, АдресатАдрес");
			ЗаполнитьЗначенияСвойств(СтрокаТаблицы,СтрокаАдресата);
			СтрокаТаблицы.АдресатАдрес = СтрокаАдресата.Адреса.НайтиПоИдентификатору(ЭлементМассива).Адрес;
			СтрокаТаблицы.Адресат = СтрокаТаблицы.Адресат + "<" + СтрокаТаблицы.АдресатАдрес + ">";
			МассивАдресатов.Добавить(СтрокаТаблицы);
		КонецЦикла;
	КонецЕсли;
	
	Закрыть(МассивАдресатов);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьАдреснуюКнигуНаСервере(ИмяЭлемента)
	
	ЗаполнитьАдреснуюКнигу(ИмяЭлемента);
	ОбновитьКомандыПереходаКСтраницамНаСервере(Элементы.Найти(ИмяЭлемента));
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьКомандыПереходаКСтраницамНаСервере(ТекущийЭлементПредставления)
	
	УстановитьСтандартноеОформлениеНаСервере(Элементы.ОткрытьСотрудникиСписком);
	УстановитьСтандартноеОформлениеНаСервере(Элементы.ОткрытьСотрудникиПоПодразделениям);
	УстановитьСтандартноеОформлениеНаСервере(Элементы.ОткрытьСотрудникиПоГруппам);
	УстановитьСтандартноеОформлениеНаСервере(Элементы.ОткрытьКонтрагенты);
	УстановитьСтандартноеОформлениеНаСервере(Элементы.ОткрытьЛичныеАдресаты);
	
	УстановитьВыделенноеОформлениеНаСервере(ТекущийЭлементПредставления);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСтандартноеОформлениеНаСервере(Элемент)
	
	Элемент.Гиперссылка = Истина;
	Элемент.Шрифт = Новый Шрифт(Элемент.Шрифт, , , Ложь);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВыделенноеОформлениеНаСервере(Элемент)
	
	Элемент.Гиперссылка = Ложь;
	Элемент.Шрифт = Новый Шрифт(Элемент.Шрифт, , , Истина);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьАдреснуюКнигу(КомандаЗаполнения, ИндексЭлемента = Неопределено)
	
	Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();
	Запрос = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMGetAddressBookRequest");
	
	Если ИндексЭлемента <> Неопределено Тогда
		Элемент = Адресаты.НайтиПоИдентификатору(ИндексЭлемента);
		Запрос.parentID = Элемент.АдресатID;
	Иначе
		Элемент = Неопределено;
	КонецЕсли;
	
	ТипАдресатов = СтрЗаменить(КомандаЗаполнения,"Открыть","");
	
	Если ТипАдресатов = "СотрудникиПоПодразделениям" Тогда
		Элементы.ЗаголовокАдресатов.Заголовок = НСтр("ru = 'Сотрудники по подразделениям:'");
		Запрос.addressBookType = "usersInSubdivisions";
		Элементы.Адресаты.Отображение = ОтображениеТаблицы.Дерево;
		Элементы.Адресаты.НачальноеОтображениеДерева = НачальноеОтображениеДерева.НеРаскрывать;
	ИначеЕсли ТипАдресатов = "СотрудникиСписком" Тогда
		Элементы.ЗаголовокАдресатов.Заголовок = НСтр("ru = 'Сотрудники списком:'");
		Запрос.addressBookType = "usersList";
		Элементы.Адресаты.Отображение = ОтображениеТаблицы.Список;
	ИначеЕсли ТипАдресатов = "СотрудникиПоГруппам" Тогда
		Элементы.ЗаголовокАдресатов.Заголовок = НСтр("ru = 'Сотрудники по группам:'");
		Запрос.addressBookType = "usersInFolders";
		Элементы.Адресаты.Отображение = ОтображениеТаблицы.Дерево;
		Элементы.Адресаты.НачальноеОтображениеДерева = НачальноеОтображениеДерева.НеРаскрывать;
	ИначеЕсли ТипАдресатов = "ЛичныеАдресаты" Тогда
		Элементы.ЗаголовокАдресатов.Заголовок = НСтр("ru = 'Личные адресаты:'");
		Запрос.addressBookType = "personalRecipients";
		Элементы.Адресаты.Отображение = ОтображениеТаблицы.Дерево;
		Элементы.Адресаты.НачальноеОтображениеДерева = НачальноеОтображениеДерева.НеРаскрывать;
	ИначеЕсли ТипАдресатов = "Контрагенты" Тогда
		Если ИнтеграцияС1СДокументооборотПовтИсп.ИспользоватьТерминКорреспонденты() Тогда
			Элементы.ЗаголовокАдресатов.Заголовок = НСтр("ru = 'Корреспонденты:'");
		Иначе
			Элементы.ЗаголовокАдресатов.Заголовок = НСтр("ru = 'Контрагенты:'");
		КонецЕсли;
		Запрос.addressBookType = "correspondents";
		Элементы.Адресаты.Отображение = ОтображениеТаблицы.Дерево;
		Элементы.Адресаты.НачальноеОтображениеДерева = НачальноеОтображениеДерева.НеРаскрывать;
	КонецЕсли;
	
	Ответ = Прокси.execute(Запрос);
	ИнтеграцияС1СДокументооборот.ПроверитьВозвратВебСервиса(Прокси, Ответ);
	Если Элемент = Неопределено Тогда
		Адресаты.ПолучитьЭлементы().Очистить();
		КореньДерева = Адресаты.ПолучитьЭлементы();
	Иначе
		Элемент.ПолучитьЭлементы().Очистить();
		КореньДерева = Элемент.ПолучитьЭлементы();
	КонецЕсли;
	
	ЗаполнитьДеревоАдресатов(Ответ, КореньДерева);
	
	Если Элемент <> Неопределено Тогда
		Элемент.ПодпапкиСчитаны = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоАдресатов(Ответ, КореньДерева)
	
	Для каждого Элемент из Ответ.items Цикл
		СтрокаДерева = КореньДерева.Добавить();
 		Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьОбъектныйРеквизит(СтрокаДерева,Элемент.object,"Адресат");
		
		Если Элемент.object.objectID.type = "DMSubdivision" И Элемент.object.head <> Неопределено Тогда
			СтрокаДерева.РуководительID =  Элемент.object.head.objectID.ID;
		Иначе
			СтрокаРодителя = СтрокаДерева.ПолучитьРодителя();
			Если СтрокаРодителя <> Неопределено Тогда
				Если СтрокаДерева.АдресатID = СтрокаРодителя.РуководительID Тогда
					СтрокаДерева.Руководитель = Истина;
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
		
		Для каждого Адрес из Элемент.addresses Цикл
			СтрокаАдреса = СтрокаДерева.Адреса.Добавить();
			СтрокаАдреса.Адрес = Адрес;
			СтрокаАдреса.Картинка = 1;
		КонецЦикла;
		
		Если Элемент.isFolder Тогда
			СтрокаДерева.Картинка = 0;
		Иначе
			Если ТипАдресатов <> "Контрагенты" Тогда
				СтрокаДерева.Картинка = БиблиотекаКартинок.СостояниеПользователя02;
			Иначе
				СтрокаДерева.Картинка = ИнтеграцияС1СДокументооборотПереопределяемый.ИндексКартинкиЭлемента();
			КонецЕсли;
		КонецЕсли;
		
		СтрокаДерева.ЭтоГруппа = Элемент.isFolder;
		
		Если СтрокаДерева.ЭтоГруппа Тогда
			СтрокаДерева.ПодпапкиСчитаны = Ложь;
			СтрокаДерева.ПолучитьЭлементы().Добавить(); // чтобы отображался плюсик
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура АдресатыПередРазворачиванием(Элемент, Строка, Отказ)
	
	ОбрабатываемыйЭлемент = Адресаты.НайтиПоИдентификатору(Строка);
	
	Если НЕ ОбрабатываемыйЭлемент.ПодпапкиСчитаны Тогда
		ЗаполнитьАдреснуюКнигу(ТипАдресатов, Строка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
