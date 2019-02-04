
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//уатЗащищенныеФункцииСервер.уатСправочникФормаСпискаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	
	ТолькоПросмотр = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	//уатЗащищенныеФункцииКлиент.уатСправочникФормаСпискаПриОткрытии(Отказ, ДопПараметрыОткрытие);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ТекстСообщения = НСтр("ru = 'Данный объект предназначен для совместимости с предыдущей редакций. 
                               |Изменение данных запрещено!'; en = 'This object is for compatibility with previous editions.
                               | Modifying data is prohibited!'");
	ПоказатьПредупреждение(, ТекстСообщения, 60, НСтр("en='Data can be changed!';ru='Изменение данных запрещено!'"));
	Отказ = Истина;
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ  

&НаКлиенте
Процедура УстановитьОтборАдреса()
	
	ТекСтрока = Элементы.Список.ТекущаяСтрока;
	
	Если ТекСтрока = Неопределено Тогда 
		СписокАдресов.Отбор.Элементы.Очистить();
		СписокАдресов.КомпоновщикНастроек.Настройки.Отбор.Элементы.Очистить();
		Возврат;
	КонецЕсли;
	
	СписокАдресов.КомпоновщикНастроек.Настройки.Отбор.Элементы.Очистить();
	
	ЭлементОтбора                  = СписокАдресов.КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(
	                                  Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("Регион");
	ЭлементОтбора.ВидСравнения     = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение   = ТекСтрока;
	ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ЭлементОтбора.Использование    = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	УстановитьОтборАдреса();
КонецПроцедуры
