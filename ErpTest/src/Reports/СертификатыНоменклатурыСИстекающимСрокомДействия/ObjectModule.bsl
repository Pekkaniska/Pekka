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
	Настройки.События.ПослеЗаполненияПанелиБыстрыхНастроек = Истина;
КонецПроцедуры

// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// Подробнее - см. ОтчетыПереопределяемый.ПослеЗаполненияПанелиБыстрыхНастроек
//
Процедура ПослеЗаполненияПанелиБыстрыхНастроек(ЭтаФорма, ПараметрыЗаполнения) Экспорт
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьСертификатыНоменклатуры") Тогда
		Возврат;
	КонецЕсли;
	
	ПолеТипСертификата = ЭтаФорма.Отчет.КомпоновщикНастроек.Настройки.ПользовательскиеПоля.Элементы[0];
	ПолеКомпоновкиДанныхТипСертификата = ПолеТипСертификата.Варианты.Элементы[0].Отбор.Элементы[0].ЛевоеЗначение;
	ПолеТипСертификата.Варианты.Элементы.Очистить();
	
	МассивТиповСертификатов = Справочники.СертификатыНоменклатуры.СформироватьСписокВыбораТиповСертификатов();
	
	Для Каждого ТипСертификата Из МассивТиповСертификатов Цикл
		
		ВариантКомпановкиДанных = ПолеТипСертификата.Варианты.Элементы.Добавить();
		ВариантКомпановкиДанных.Использование = Истина;
		ВариантКомпановкиДанных.Значение = ТипСертификата;
		ВариантКомпановкиДанных.Представление = ТипСертификата;
		
		ЭлементОтбора = ВариантКомпановкиДанных.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.Использование  = Истина;
		ЭлементОтбора.ЛевоеЗначение  = ПолеКомпоновкиДанныхТипСертификата;
		ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.Содержит;
		ЭлементОтбора.ПравоеЗначение = ТипСертификата;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли