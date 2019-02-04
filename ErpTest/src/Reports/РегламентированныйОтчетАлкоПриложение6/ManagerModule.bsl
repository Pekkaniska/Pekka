#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ВерсияФорматаВыгрузки(Знач НаДату = Неопределено, ВыбраннаяФорма = Неопределено) Экспорт
	
	Если НаДату = Неопределено Тогда
		НаДату = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Если НаДату < '20060101' Тогда
		Возврат Перечисления.ВерсииФорматовВыгрузки.Версия201алко;
	ИначеЕсли НаДату >= '20110301' Тогда
		Возврат Перечисления.ВерсииФорматовВыгрузки.Версия401алко;
	Иначе
		Если ВыбраннаяФорма = "ФормаОтчета2006Кв1" Тогда
			Возврат Неопределено;
		ИначеЕсли ВыбраннаяФорма = "ФормаОтчета2006Кв2" Тогда
			Возврат Неопределено;
		Иначе
			Возврат Перечисления.ВерсииФорматовВыгрузки.Версия302алко;
		КонецЕсли;
	КонецЕсли;
		
КонецФункции

Функция ТаблицаФормОтчета() Экспорт
	
	ОписаниеТиповСтрока = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(0));
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("Дата"));
	ОписаниеТиповДата = Новый ОписаниеТипов(МассивТипов, , Новый КвалификаторыДаты(ЧастиДаты.Дата));
	
	МассивБулево = Новый Массив;
	МассивБулево.Добавить(Тип("Булево"));
	ОписаниеТиповБулево    = Новый ОписаниеТипов(МассивБулево);
	
	ТаблицаФормОтчета = Новый ТаблицаЗначений;
	ТаблицаФормОтчета.Колонки.Добавить("ФормаОтчета",        ОписаниеТиповСтрока);
	ТаблицаФормОтчета.Колонки.Добавить("ОписаниеОтчета",     ОписаниеТиповСтрока, "Утверждена",  20);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаНачалоДействия", ОписаниеТиповДата,   "Действует с", 5);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаКонецДействия",  ОписаниеТиповДата,   "         по", 5);
	ТаблицаФормОтчета.Колонки.Добавить("РедакцияФормы",      ОписаниеТиповСтрока, "Редакция формы", 20);
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2009Кв4";
	НоваяФорма.ОписаниеОтчета     = "Приложение 6 к Положению о представлении декларации об объемах производства, оборота и использования этилового спирта, алкогольной и спиртосодержащей продукции (Утверждено ПП РФ от 31.12.2005 № 858 (в ред. ПП РФ от 26.01.2010 N 26)) (выгрузка в формате 3.02).";
	НоваяФорма.РедакцияФормы	  = "от 26.01.2010 N 26, выгрузка в формате 3.02.";
	НоваяФорма.ДатаНачалоДействия = '20091201';
	НоваяФорма.ДатаКонецДействия  = '20100831';
		
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2009Кв4";
	НоваяФорма.ОписаниеОтчета     = "Приложение 6 к Положению о представлении декларации об объемах производства, оборота и использования этилового спирта, алкогольной и спиртосодержащей продукции (Утверждено ПП РФ от 31.12.2005 № 858 (в ред. ПП РФ от 26.01.2010 N 26)) (выгрузка в формате 3.05).";
	НоваяФорма.РедакцияФормы	  = "от 26.01.2010 N 26, выгрузка в формате 3.05.";
 	НоваяФорма.ДатаНачалоДействия = '20100901';
	НоваяФорма.ДатаКонецДействия  = '20110228';
		
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2012Кв3";
	НоваяФорма.ОписаниеОтчета     = "Приложение № 6 к Правилам представления деклараций об объеме производства, оборота и (или) использования этилового спирта, алкогольной и спиртосодержащей продукции, об использовании производственных мощностей (Утверждено ПП РФ от 09.08.2012 № 815).";
	НоваяФорма.РедакцияФормы	  = "от 09.08.2012 № 815.";
	НоваяФорма.ДатаНачалоДействия = '20120101';
	НоваяФорма.ДатаКонецДействия  = РегламентированнаяОтчетностьКлиентСервер.ПустоеЗначениеТипа(Тип("Дата"));
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2009Кв4";
	НоваяФорма.ОписаниеОтчета     = "Приложение 6 к Положению о представлении декларации об объемах производства, оборота и использования этилового спирта, алкогольной и спиртосодержащей продукции (Утверждено ПП РФ от 31.12.2005 № 858 (в ред. ПП РФ от 26.01.2010 N 26)) (выгрузка в формате 4.01).";
	НоваяФорма.РедакцияФормы	  = "от 26.01.2010 N 26, выгрузка в формате 4.01.";
	НоваяФорма.ДатаНачалоДействия = '20110301';
	НоваяФорма.ДатаКонецДействия  = '20120630';
	
	Возврат ТаблицаФормОтчета;
	
КонецФункции

Функция ДанныеРеглОтчета(ЭкземплярРеглОтчета) Экспорт
	
	Возврат Неопределено;
	
КонецФункции

Функция ДеревоФормИФорматов() Экспорт
	
	ФормыИФорматы = Новый ДеревоЗначений;
	ФормыИФорматы.Колонки.Добавить("Код");
	ФормыИФорматы.Колонки.Добавить("ДатаПриказа");
	ФормыИФорматы.Колонки.Добавить("НомерПриказа");
	ФормыИФорматы.Колонки.Добавить("ДатаНачалаДействия");
	ФормыИФорматы.Колонки.Добавить("ДатаОкончанияДействия");
	ФормыИФорматы.Колонки.Добавить("ИмяОбъекта");
	ФормыИФорматы.Колонки.Добавить("Описание");
	
	Форма20091201 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1152024", '20100126', "26", "ФормаОтчета2009Кв4");
	ОпределитьФорматВДеревеФормИФорматов(Форма20091201, "3.02", , , ,'20100831');
	ОпределитьФорматВДеревеФормИФорматов(Форма20091201, "3.05", , , '20100901', '20110228');
	ОпределитьФорматВДеревеФормИФорматов(Форма20091201, "4.01", , , '20110301');
	
	Форма20120701 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1152024", '2012-08-09', "815", "ФормаОтчета2012Кв3");
	ОпределитьФорматВДеревеФормИФорматов(Форма20120701, "4.20", , , '2012-01-01', '2013-12-31');
	ОпределитьФорматВДеревеФормИФорматов(Форма20120701, "4.30", , , '2014-01-01', '2015-08-31');
	ОпределитьФорматВДеревеФормИФорматов(Форма20120701, "4.31", , , '2015-09-01');
	
	Возврат ФормыИФорматы;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ОпределитьФормуВДеревеФормИФорматов(ДеревоФормИФорматов, Код, ДатаПриказа = '00010101', НомерПриказа = "", ИмяОбъекта = "",
			ДатаНачалаДействия = '00010101', ДатаОкончанияДействия = '00010101', Описание = "")
	
	НовСтр = ДеревоФормИФорматов.Строки.Добавить();
	НовСтр.Код = СокрЛП(Код);
	НовСтр.ДатаПриказа = ДатаПриказа;
	НовСтр.НомерПриказа = СокрЛП(НомерПриказа);
	НовСтр.ДатаНачалаДействия = ДатаНачалаДействия;
	НовСтр.ДатаОкончанияДействия = ДатаОкончанияДействия;
	НовСтр.ИмяОбъекта = СокрЛП(ИмяОбъекта);
	НовСтр.Описание = СокрЛП(Описание);
	Возврат НовСтр;
	
КонецФункции

Функция ОпределитьФорматВДеревеФормИФорматов(Форма, Версия, ДатаПриказа = '00010101', НомерПриказа = "",
			ДатаНачалаДействия = Неопределено, ДатаОкончанияДействия = Неопределено, ИмяОбъекта = "", Описание = "")
	
	НовСтр = Форма.Строки.Добавить();
	НовСтр.Код = СокрЛП(Версия);
	НовСтр.ДатаПриказа = ДатаПриказа;
	НовСтр.НомерПриказа = СокрЛП(НомерПриказа);
	НовСтр.ДатаНачалаДействия = ?(ДатаНачалаДействия = Неопределено, Форма.ДатаНачалаДействия, ДатаНачалаДействия);
	НовСтр.ДатаОкончанияДействия = ?(ДатаОкончанияДействия = Неопределено, Форма.ДатаОкончанияДействия, ДатаОкончанияДействия);
	НовСтр.ИмяОбъекта = СокрЛП(ИмяОбъекта);
	НовСтр.Описание = СокрЛП(Описание);
	Возврат НовСтр;
	
КонецФункции

#КонецОбласти

#КонецЕсли