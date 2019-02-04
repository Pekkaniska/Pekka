
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	УправлениеЭлементами();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьСпособыОбеспеченияПотребностей(Команда)
	
	ОткрытьФорму("Справочник.СпособыОбеспеченияПотребностей.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСхемыОбеспечения(Команда)
	
	ОткрытьФорму("Справочник.СхемыОбеспечения.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЗоныДоставки(Команда)
	
	ОткрытьФорму("Справочник.ЗоныДоставки.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьТипыТранспортныхСредств(Команда)

	ОткрытьФорму("Справочник.ТипыТранспортныхСредств.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПравилаРазмещения(Команда)

	ОткрытьФорму("РегистрСведений.ПравилаРазмещенияТоваровВЯчейках.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьТипоразмерыЯчеек(Команда)

	ОткрытьФорму("Справочник.ТипоразмерыЯчеек.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПрогнозыРасходаУпаковок(Команда)
	
	ОткрытьФорму("РегистрСведений.ПрогнозыРасходаУпаковок.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКатегорииЭксплуатации(Команда)
	
	ОткрытьФорму("Справочник.КатегорииЭксплуатации.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УправлениеЭлементами()
	
	ПравоДоступаЗоныДоставки 				= ПравоДоступа("Просмотр", Метаданные.Справочники.ЗоныДоставки);
	ПравоДоступаТипыТранспортныхСредств 	= ПравоДоступа("Просмотр", Метаданные.Справочники.ТипыТранспортныхСредств);
	ПравоДоступаПравилаРазмещения 			= ПравоДоступа("Просмотр", Метаданные.РегистрыСведений.ПравилаРазмещенияТоваровВЯчейках);
	ПравоДоступаТипоразмерыЯчеек 			= ПравоДоступа("Просмотр", Метаданные.Справочники.ТипоразмерыЯчеек);
	ПравоДоступаПрогнозыРасходаУпаковок 	= ПравоДоступа("Просмотр", Метаданные.РегистрыСведений.ПрогнозыРасходаУпаковок);
	ПравоДоступаКатегорииЭксплуатации 		= ПравоДоступа("Просмотр", Метаданные.Справочники.КатегорииЭксплуатации);
	ПравоДоступаСпособыОбеспеченияПотребностей = ПравоДоступа("Изменение", Метаданные.Справочники.СпособыОбеспеченияПотребностей);
	ПравоДоступаСхемыОбеспечения               = ПравоДоступа("Изменение", Метаданные.РегистрыСведений.СхемыОбеспечения);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
		"ОткрытьЗоныДоставки",
		"Видимость",
		ПравоДоступаЗоныДоставки);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
		"ОткрытьТипыТранспортныхСредств",
		"Видимость",
		ПравоДоступаТипыТранспортныхСредств);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
		"ОткрытьПравилаРазмещения",
		"Видимость",
		ПравоДоступаПравилаРазмещения);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
		"ОткрытьТипоразмерыЯчеек",
		"Видимость",
		ПравоДоступаТипоразмерыЯчеек);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
		"ОткрытьПрогнозыРасходаУпаковок",
		"Видимость",
		ПравоДоступаПрогнозыРасходаУпаковок);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
		"ОткрытьКатегорииЭксплуатации",
		"Видимость",
		ПравоДоступаКатегорииЭксплуатации);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
		"ОткрытьСпособыОбеспеченияПотребностей",
		"Видимость",
		ПравоДоступаСпособыОбеспеченияПотребностей);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
		"ОткрытьСхемыОбеспечения",
		"Видимость",
		ПравоДоступаСхемыОбеспечения);
		
	ЕстьДанныеДляОтображения =
		ПолучитьФункциональнуюОпцию("ИспользоватьУпаковкиНоменклатуры")
		ИЛИ ПолучитьФункциональнуюОпцию("ИспользоватьУправлениеДоставкой")
		ИЛИ ПолучитьФункциональнуюОпцию("ИспользоватьАдресноеХранение")
		ИЛИ ПолучитьФункциональнуюОпцию("ИспользоватьВнутреннееПотребление")
		ИЛИ ПолучитьФункциональнуюОпцию("ИспользоватьРасширенноеОбеспечениеПотребностей")
		ИЛИ ПравоДоступаЗоныДоставки
		ИЛИ ПравоДоступаТипыТранспортныхСредств
		ИЛИ ПравоДоступаПравилаРазмещения
		ИЛИ ПравоДоступаТипоразмерыЯчеек
		ИЛИ ПравоДоступаПрогнозыРасходаУпаковок
		ИЛИ ПравоДоступаКатегорииЭксплуатации;
		
	Элементы.ГруппаНеУстановленыНеобходимыеНастройки.Видимость = НЕ ЕстьДанныеДляОтображения;
	
КонецПроцедуры

#КонецОбласти
