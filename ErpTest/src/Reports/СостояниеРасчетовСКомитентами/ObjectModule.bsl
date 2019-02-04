#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.События.ПриСозданииНаСервере = Истина;
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   Отказ - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Передается из параметров обработчика "как есть".
//
// См. также:
//   "УправляемаяФорма.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	
	КомпоновщикНастроекФормы = ЭтаФорма.Отчет.КомпоновщикНастроек;
	Параметры = ЭтаФорма.Параметры;
	
	Если Параметры.Свойство("ПараметрКоманды") Тогда
	
		ЗначенияФункциональныхОпций = Новый Структура("БазоваяВерсия", ПолучитьФункциональнуюОпцию("БазоваяВерсия"));
		СтрокаБазовая = ?(ЗначенияФункциональныхОпций.БазоваяВерсия, "Базовая", "");
		
		ЭтаФорма.ФормаПараметры.Отбор = Новый Структура("ОтчетКомитенту", Параметры.ПараметрКоманды);
		Параметры.КлючВарианта = "СостояниеРасчетовСКомитентамиКонтекст" + СтрокаБазовая;
		
	КонецЕсли;
	
	
	ФормаПараметры = ЭтаФорма.ФормаПараметры;
	
	Если ФормаПараметры.Свойство("Отбор")
		И ФормаПараметры.Отбор.Свойство("ОтчетКомитенту") Тогда
		
		Если ТипЗнч(ФормаПараметры.Отбор.ОтчетКомитенту) = Тип("ДокументСсылка.ОтчетКомитенту") Тогда
			Реквизиты = Документы.ОтчетКомитенту.РеквизитыДокумента(ФормаПараметры.Отбор.ОтчетКомитенту);
		ИначеЕсли ТипЗнч(ФормаПараметры.Отбор.ОтчетКомитенту) = Тип("ДокументСсылка.ОтчетКомитентуОСписании") Тогда
			Реквизиты = Документы.ОтчетКомитентуОСписании.РеквизитыДокумента(ФормаПараметры.Отбор.ОтчетКомитенту);
		Иначе
			Реквизиты = Неопределено;
		КонецЕсли;
		
		Если Реквизиты <> Неопределено Тогда
			Если ЗначениеЗаполнено(Реквизиты.Партнер) Тогда	
				ФормаПараметры.Отбор.Вставить("Комитент", Реквизиты.Партнер);
			КонецЕсли;
			
			Если ЗначениеЗаполнено(Реквизиты.НачалоПериода)
				ИЛИ ЗначениеЗаполнено(Реквизиты.КонецПериода) Тогда
				
				Период = Новый СтандартныйПериод;
				Период.Вариант = ВариантСтандартногоПериода.ПроизвольныйПериод;
				Период.ДатаНачала = Реквизиты.НачалоПериода;
				Период.ДатаОкончания = Реквизиты.КонецПериода;
				ФормаПараметры.Отбор.Вставить("Период", Период);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ТекстЗапроса = СхемаКомпоновкиДанных.НаборыДанных.РасчетыСКомитентами.Элементы.ТоварыОрганизаций.Запрос;

	ТекстЗапроса = СтрЗаменить(
		ТекстЗапроса, 
		"&ТекстЗапросаКоэффициентУпаковки1", 
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки("ЦеныНоменклатуры.Упаковка", "ЦеныНоменклатуры.Номенклатура"));

	СхемаКомпоновкиДанных.НаборыДанных.РасчетыСКомитентами.Элементы.ТоварыОрганизаций.Запрос = ТекстЗапроса;
	
	ФиксНастройкаПериода = ФиксированнаяНастройкаПараметра("Период");
	Если ФиксНастройкаПериода.Использование = Истина Тогда
		ПользНастройкаПериода = ПользовательскаяНастройкаПараметра("Период");
		ПользНастройкаПериода.Использование = Истина;
		ПользНастройкаПериода.Значение.ДатаНачала = ФиксНастройкаПериода.Значение.ДатаНачала;
		ПользНастройкаПериода.Значение.ДатаОкончания = ФиксНастройкаПериода.Значение.ДатаОкончания;
		
		ФиксНастройкаПериода.Использование = Ложь;
	КонецЕсли;
	
	СегментыСервер.ВключитьОтборПоСегментуПартнеровВСКД(КомпоновщикНастроек);	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ФиксированнаяНастройкаПараметра(ИмяПараметра)
	ПараметрДанных = КомпоновщикНастроек.ФиксированныеНастройки.ПараметрыДанных.Элементы.Найти(ИмяПараметра);
	
	Возврат ПараметрДанных;
КонецФункции

Функция ПользовательскаяНастройкаПараметра(ИмяПараметра)
	ПараметрДанных = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти(ИмяПараметра);
	Если ПараметрДанных <> Неопределено Тогда
		ПараметрПользовательскойНастройки = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(ПараметрДанных.ИдентификаторПользовательскойНастройки);
		Если ПараметрПользовательскойНастройки <> Неопределено Тогда
			Возврат ПараметрПользовательскойНастройки;
		Иначе
			Возврат ПараметрДанных;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции

#КонецОбласти

#КонецЕсли