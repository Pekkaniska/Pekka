
////////////////////////////////////////////////////////////////////////////////
// Интерфейс взаимодействия с общими модулями конфигурации ERP.
//
// Клиентские методы.
//  
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Процедура уатНачалоВыбораСоглашенияСПоставщиком(Элемент, СтандартнаяОбработка, Партнер, Документ, 
		ДатаДокумента='00010101', ДоступноДляЗакупки = Ложь, СтруктураДополнительногоОтбора = Неопределено) Экспорт
	
	Попытка
		МодульЗакупкиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ЗакупкиКлиент");
	Исключение
		МодульЗакупкиКлиент = Неопределено;
	КонецПопытки;
	
	Если Не МодульЗакупкиКлиент = Неопределено Тогда 
		МодульЗакупкиКлиент.НачалоВыбораСоглашенияСПоставщиком(Элемент, СтандартнаяОбработка, Партнер, Документ, 
			ДатаДокумента, СтруктураДополнительногоОтбора);
	КонецЕсли;
	
КонецПроцедуры

Процедура уатРазрешитьРедактированиеРеквизитовОбъекта(Форма, Знач ИмяФормыРазблокировки = "", ОповещениеОРазблокировке = Неопределено) Экспорт
	
	Попытка
		МодульОбщегоНазначенияУТКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбщегоНазначенияУТКлиент");
	Исключение
		МодульОбщегоНазначенияУТКлиент = Неопределено;
	КонецПопытки;
	
	Если Не МодульОбщегоНазначенияУТКлиент = Неопределено Тогда 
		МодульОбщегоНазначенияУТКлиент.РазрешитьРедактированиеРеквизитовОбъекта(Форма, ИмяФормыРазблокировки, ОповещениеОРазблокировке);
	КонецЕсли;
	
КонецПроцедуры

Процедура уатНачалоВыбораСоглашенияСКлиентом(Элемент, СтандартнаяОбработка, Партнер, Документ, ДатаДокумента='00010101',
			ТолькоТиповые=Ложь, ТолькоИспользуемыеВРаботеТП=Ложь, ХозяйственнаяОперация=Неопределено) Экспорт
	
	Попытка
		МодульПродажиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПродажиКлиент");
	Исключение
		МодульПродажиКлиент = Неопределено;
	КонецПопытки;
	
	Если Не МодульПродажиКлиент = Неопределено Тогда 
		СтруктураПараметров = МодульПродажиКлиент.ПараметрыНачалаВыбораСоглашенияСКлиентом();
		
		СтруктураПараметров.Элемент = Элемент;
		СтруктураПараметров.Партнер = Партнер;
		СтруктураПараметров.Документ = Документ;
		СтруктураПараметров.ДатаДокумента = ДатаДокумента;
		СтруктураПараметров.ТолькоТиповые = ТолькоТиповые;
		СтруктураПараметров.ТолькоИспользуемыеВРаботеТП = ТолькоИспользуемыеВРаботеТП;
		СтруктураПараметров.ХозяйственнаяОперация = ХозяйственнаяОперация;
		
		МодульПродажиКлиент.НачалоВыбораСоглашенияСКлиентом(СтруктураПараметров, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

Процедура уатОтключитьОборудованиеПриЗакрытииФормы(Форма) Экспорт
	//ОбъединеннаяКонфигурацияERP = (Найти(Метаданные.Имя, "УправлениеПредприятием") <> 0);
	//Если ОбъединеннаяКонфигурацияERP Тогда
	//	МенеджерОборудованияКлиент.ОтключитьОборудованиеПриЗакрытииФормы(Форма);
	//КонецЕсли;
	Заглушка = Истина;
КонецПроцедуры

#КонецОбласти
