/////////////////////////////////////////////////////////////////////////////////////
// НАЗНАЧЕНИЕ:
// МОДУЛЬ ПРЕДНАЗНАЧЕН ДЛЯ ОБРАБОТКИ ВВОДА СОТРУДНИКОВ В ПОЛЯ ВВОДА И ТАБЛИЧНЫЕ ЧАСТИ


/////////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТА УПРАВЛЕНИЯ "СОТРУДНИК" ТАБЛИЧНОЙ ЧАСТИ


/////////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТА УПРАВЛЕНИЯ "СОТРУДНИК" ШАПКИ

//Процедура открывает форму выбора сотрудника
//
&НаКлиенте
Процедура ДиалогВыбораСотрудника(ВладелецФормы = Неопределено, ПараметрыОтбора = Неопределено, 
		НачальноеЗначениеВыбора = Неопределено) Экспорт
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ТекущаяСтрока", НачальноеЗначениеВыбора);
	ПараметрыОткрытия.Вставить("РежимВыбора", Истина);
	
	//установим необходимые отборы
	Если ТипЗнч(ПараметрыОтбора) = Тип("Структура") Тогда
		ПараметрыОткрытия.Вставить("Отбор", ПараметрыОтбора);
	КонецЕсли;
	
	ОткрытьФорму("Справочник.Сотрудники.ФормаВыбора", ПараметрыОткрытия, ВладелецФормы);
КонецПроцедуры

// Функция возвращает список водителей по подстроке ввода
//
// Параметры
//  Текст 		- строка - начало гос. или гар. номера
//
// Возвращаемое значение:
//  СписокЗначений - список водителей, если их найдено не более 50
//  Неопределено - если найдено более 50 подходящих ТС
//
&НаСервере
Функция ПодобратьСписокВодителей(Знач Текст, НачальноеЗначение = Неопределено, Знач Организация_ = Неопределено) Экспорт
	
КонецФункции


//Процедура вызывается из обработчика АвтоПодборТекста поля ввода Сотрудник
//
//Параметры:
//	Элемент - элемент управления (поле НомерТС),
//	Текст, ТекстАвтоПодбора - Строка - параметры, переданные из метода АвтоПодборТекста,
//	СтандартнаяОбработка - Булево - флаг стандартной обработки события,
//
&НаКлиенте
Процедура СотрудникАвтоПодборТекста(Элемент, Знач Текст, ДанныеВыбора, СтандартнаяОбработка, Знач СтруктураДопПараметров = Неопределено) ЭКСПОРТ
	
	Если Текст = "" Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеВыбора = уатЗащищенныеФункцииСервер.ПодобратьСписокСотрудников(Текст, СтруктураДопПараметров);
	//Если ДанныеВыбора <> Неопределено И ДанныеВыбора.Количество() > 0 Тогда
		СтандартнаяОбработка = Ложь;
	//КонецЕсли;
	
КонецПроцедуры

//Процедура вызывается из обработчика ОкончаниеВводаТекста поля ввода НомерТС
//
//Параметры:
//	Элемент - элемент управления (поле НомерТС),
//	Текст - Строка - параметр, переданный из метода ОкончаниеВводаТекста,
//	Значение - значение поля ввода (номер ТС),
//	СтандартнаяОбработка - флаг стандартной обработки (здесь сбрасывается),
//	Организация - СправочникСсылка.Организации - организация
//
&НаКлиенте
Процедура СотрудникОкончаниеВводаТекста(Элемент, Знач Текст, ДанныеВыбора, СтандартнаяОбработка, Знач СтруктураДопПараметров = Неопределено) ЭКСПОРТ
	
	Если Текст = "" Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеВыбора = уатЗащищенныеФункцииСервер.ПодобратьСписокСотрудников(Текст, СтруктураДопПараметров);
	//Если ДанныеВыбора <> Неопределено И ДанныеВыбора.Количество() > 0 Тогда
		СтандартнаяОбработка = Ложь;
	//КонецЕсли;
	
КонецПроцедуры
