
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Документ = Параметры.Документ;
	ДокументID = Параметры.ДокументID;
	ДокументТип = Параметры.ДокументТип;
	
	Если ЗначениеЗаполнено(ДокументID) Тогда 
		
		ПрочитатьСостоянияДокумента(Параметры);
		
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Состояние документа ""%1""'"),
			Документ);
		
	Иначе
		
		Если ДокументТип = "DMIncomingDocument" Тогда 
			СостояниеРегистрация = НСтр("ru='На регистрации'");
			СостояниеРегистрацияID = "НаРегистрации";
			СостояниеРегистрацияТип = "DMDocumentStatus";
		Иначе
			СостояниеРегистрация = НСтр("ru='Проект'");
			СостояниеРегистрацияID = "Проект";
			СостояниеРегистрацияТип = "DMDocumentStatus";
		КонецЕсли;
		
	КонецЕсли;
	
	Если Параметры.ТолькоПросмотр Тогда 
		
		ТолькоПросмотр = Истина;
		Элементы.ФормаЗаписать.Видимость = Ложь;
		Элементы.ФормаОтмена.Заголовок = НСтр("ru = 'Закрыть'");
		
	КонецЕсли;
	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	#Если ВебКлиент Тогда
	Если Не Параметры.ТолькоПросмотр Тогда
		
	Элементы.СостояниеСогласование.РедактированиеТекста = Ложь;
	Элементы.СостояниеУтверждение.РедактированиеТекста = Ложь;
	Элементы.СостояниеРегистрация.РедактированиеТекста = Ложь;
	Элементы.СостояниеРассмотрение.РедактированиеТекста = Ложь;
	Элементы.СостояниеИсполнение.РедактированиеТекста = Ложь;
	
	Элементы.СостояниеСогласование.КнопкаОчистки = Истина;
	Элементы.СостояниеУтверждение.КнопкаОчистки = Истина;
	Элементы.СостояниеРегистрация.КнопкаОчистки = Истина;
	Элементы.СостояниеРассмотрение.КнопкаОчистки = Истина;
	Элементы.СостояниеИсполнение.КнопкаОчистки = Истина;
		
	КонецЕсли;
	#КонецЕсли
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СостояниеСогласованиеПриИзменении(Элемент)
	
	ПриИзмененииСостояния(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СостояниеУтверждениеПриИзменении(Элемент)
	
	ПриИзмененииСостояния(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СостояниеРегистрацияПриИзменении(Элемент)
	
	ПриИзмененииСостояния(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СостояниеРассмотрениеПриИзменении(Элемент)
	
	ПриИзмененииСостояния(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СостояниеИсполнениеПриИзменении(Элемент)
	
	ПриИзмененииСостояния(Элемент);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ОчиститьСообщения();
	Если Не ПроверитьЗаполнение() Тогда 
		Возврат;
	КонецЕсли;
	
	Реквизиты = Новый Структура("Исполнение, Рассмотрение, Регистрация, Согласование, Утверждение");
	Результат = Новый Структура;
	
	Для каждого Реквизит Из Реквизиты Цикл
		ИмяРеквизита = Реквизит.Ключ;
		Результат.Вставить("Состояние" + ИмяРеквизита, ЭтаФорма["Состояние" + ИмяРеквизита]);
		Результат.Вставить("Состояние" + ИмяРеквизита + "ID", ЭтаФорма["Состояние" + ИмяРеквизита + "ID"]);
		Результат.Вставить("Состояние" + ИмяРеквизита + "Тип", ЭтаФорма["Состояние" + ИмяРеквизита + "Тип"]);
		
	КонецЦикла;
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьСостоянияДокумента(Параметры)
	
	Реквизиты = Новый Структура("Исполнение, Рассмотрение, Регистрация, Согласование, Утверждение");
	Для каждого Реквизит Из Реквизиты Цикл
		ИмяРеквизита = Реквизит.Ключ;
		ЭтаФорма["Состояние" + ИмяРеквизита] = Параметры["Состояние" + ИмяРеквизита];
		ЭтаФорма["Состояние" + ИмяРеквизита + "ID"] = Параметры["Состояние" + ИмяРеквизита + "ID"];
		ЭтаФорма["Состояние" + ИмяРеквизита + "Тип"] = Параметры["Состояние" + ИмяРеквизита + "Тип"];
	КонецЦикла; 
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПриИзмененииСостояния(Элемент)
	
	ЭтаФорма[Элемент.Имя] = Элемент.ТекстРедактирования;
	Если ЗначениеЗаполнено(ЭтаФорма[Элемент.Имя]) Тогда
		ЭтаФорма[Элемент.Имя + "Тип"] = "DMDocumentStatus";
	Иначе
		ЭтаФорма[Элемент.Имя + "Тип"] = "";
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти
