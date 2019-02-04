
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры.НастройкаОтраженияВРеглУчете);
	
	Если Параметры.Свойство("ПодбираемыеАналитики") Тогда
		Для Каждого Аналитика Из Параметры.ПодбираемыеАналитики Цикл
			ПодбираемыеАналитики.Добавить(Аналитика);
		КонецЦикла;
	КонецЕсли;
	
//Рарурс Владимир Подрезов 17.03.2017
//	УправлениеЭлементамиФормы();
	СчетУчетаПриИзмененииСервер();
//Рарурс Владимир Подрезов Конец
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СчетУчетаПриИзменении(Элемент)
	
	СчетУчетаПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура Субконто1ПриИзменении(Элемент)
	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Субконто2ПриИзменении(Элемент)
	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Субконто3ПриИзменении(Элемент)
	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Субконто1НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СпособыСубконтоНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Субконто2НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СпособыСубконтоНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Субконто3НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СпособыСубконтоНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	НастройкаОтраженияВРеглУчете = Новый Структура;
	НастройкаОтраженияВРеглУчете.Вставить("СчетУчета", СчетУчета);
	НастройкаОтраженияВРеглУчете.Вставить("Субконто1", Субконто1);
	НастройкаОтраженияВРеглУчете.Вставить("Субконто2", Субконто2);
	НастройкаОтраженияВРеглУчете.Вставить("Субконто3", Субконто3);
	
	Закрыть(НастройкаОтраженияВРеглУчете);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервере
Процедура СчетУчетаПриИзмененииСервер()
	
	УправлениеЭлементамиФормы();
	
	ПоляОбъекта = Новый Структура("Субконто1, Субконто2, Субконто3", "Субконто1", "Субконто2", "Субконто3");
	БухгалтерскийУчетКлиентСервер.ПриИзмененииСчета(СчетУчета, ЭтаФорма, ПоляОбъекта, Ложь);
	
	СвойстваСчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(СчетУчета);
	Для НомерСубконто = 1 По СвойстваСчета.КоличествоСубконто Цикл
		ОписаниеТиповСубконто = СвойстваСчета["ВидСубконто" + НомерСубконто + "ТипЗначения"];
		Если ОписаниеТиповСубконто.СодержитТип(ТипЗнч(АналитикаАктивовПассивов)) И ЗначениеЗаполнено(АналитикаАктивовПассивов) Тогда
			ЭтаФорма["Субконто" + НомерСубконто] = АналитикаАктивовПассивов;
		КонецЕсли;
		Если ОписаниеТиповСубконто.СодержитТип(ТипЗнч(Подразделение)) И ЗначениеЗаполнено(Подразделение) Тогда
			ЭтаФорма["Субконто" + НомерСубконто] = Подразделение;
		КонецЕсли;
		Если ОписаниеТиповСубконто.СодержитТип(ТипЗнч(ФизическоеЛицо)) И ЗначениеЗаполнено(ФизическоеЛицо) Тогда
			ЭтаФорма["Субконто" + НомерСубконто] = ФизическоеЛицо;
		КонецЕсли;
	КонецЦикла;
	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура УправлениеЭлементамиФормы()
	
	ПоляФормы = Новый Структура(
		"Субконто1, Субконто2, Субконто3",
		"Субконто1", "Субконто2", "Субконто3");
	ЗаголовкиПолей = Новый Структура(
		"Субконто1, Субконто2, Субконто3",
		"ЗаголовокСубконто1", "ЗаголовокСубконто2", "ЗаголовокСубконто3");
	
	БухгалтерскийУчетКлиентСервер.ПриВыбореСчета(СчетУчета, ЭтаФорма, ПоляФормы, ЗаголовкиПолей);
	
	МассивЭлементов = Новый Массив;
	МассивЭлементов.Добавить("Субконто1");
	МассивЭлементов.Добавить("Субконто2");
	МассивЭлементов.Добавить("Субконто3");
	
	Для Каждого ЭлементФормы из МассивЭлементов Цикл
		Элементы[ЭлементФормы].Видимость = Элементы[ЭлементФормы].Видимость;
		Элементы["Заголовок" + ЭлементФормы].Видимость = Элементы[ЭлементФормы].Видимость;
	КонецЦикла;
	
	Если ПодбираемыеАналитики.Количество() > 0 Тогда
		
		СвойстваСчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(СчетУчета);
		Для НомерСубконто = 1 По СвойстваСчета.КоличествоСубконто Цикл
			
			Элементы["Субконто" + НомерСубконто].ПодсказкаВвода = "";
			
			ОписаниеТиповСубконто = СвойстваСчета["ВидСубконто" + НомерСубконто + "ТипЗначения"];
			
			Для Каждого Аналитика Из ПодбираемыеАналитики Цикл
				Если ОписаниеТиповСубконто.СодержитТип(Аналитика.Значение) Тогда
					Элементы["Субконто" + НомерСубконто].ПодсказкаВвода = НСтр("ru = '<подбирается автоматически>'");
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма)
	
	ПараметрыЗаписи = ПараметрыВыбораСубконто(ЭтаФорма, "Субконто%Индекс%");
	БухгалтерскийУчетКлиентСервер.ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, ЭтаФорма, "Субконто%Индекс%", "Субконто%Индекс%", ПараметрыЗаписи); 
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПараметрыВыбораСубконто(ЭтаФорма, ШаблонИмяПоляОбъекта)
	
	СписокПараметров = Новый Структура;
	Для Индекс = 1 По 3 Цикл
		ИмяПоля = СтрЗаменить(ШаблонИмяПоляОбъекта, "%Индекс%", Индекс);
		Если ТипЗнч(ЭтаФорма[ИмяПоля]) = Тип("СправочникСсылка.Контрагенты") Тогда
			СписокПараметров.Вставить("Контрагент", ЭтаФорма[ИмяПоля]);
		ИначеЕсли БухгалтерскийУчетКлиентСерверПереопределяемый.ПолучитьОписаниеТиповДоговора().СодержитТип(ТипЗнч(ЭтаФорма[ИмяПоля])) Тогда
			СписокПараметров.Вставить("ДоговорКонтрагента", ЭтаФорма[ИмяПоля]);
		ИначеЕсли ТипЗнч(ЭтаФорма[ИмяПоля]) = Тип("СправочникСсылка.Номенклатура") Тогда
			СписокПараметров.Вставить("Номенклатура", ЭтаФорма[ИмяПоля]);
		ИначеЕсли ТипЗнч(ЭтаФорма[ИмяПоля]) = Тип("СправочникСсылка.Склады") Тогда
			СписокПараметров.Вставить("Склад", ЭтаФорма[ИмяПоля]);
		КонецЕсли;
	КонецЦикла;
	
	СписокПараметров.Вставить("СчетУчета",     ЭтаФорма.СчетУчета);
	СписокПараметров.Вставить("Организация",   ЭтаФорма.Организация);
	
	Возврат СписокПараметров;
	
КонецФункции

&НаКлиенте
Процедура СпособыСубконтоНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПараметрыЗаписи = ПараметрыВыбораСубконто(ЭтаФорма, "Субконто%Индекс%");
	ОбщегоНазначенияБПКлиент.НачалоВыбораЗначенияСубконто(ЭтаФорма, Элемент, СтандартнаяОбработка, ПараметрыЗаписи);

КонецПроцедуры

#КонецОбласти

#КонецОбласти
