#Область ПрограммныйИнтерфейс

#Область ПроверкаКонтрагентовВДокументах

// Определение вида документа.
//
// Параметры:
//  Форма								 - УправляемаяФорма - Форма документа, для которого необходимо получить описание.
//	Результат							 - Структура - Описывает вид документа. Ключи:
//  		"КонтрагентНаходитсяВШапке"			 	- Булево - Признак того, есть у документа контрагент в шапке
//  		"КонтрагентНаходитсяВТабличнойЧасти"	- Булево - Признак того, есть у документа контрагенты в табличных частях
//  		"СчетФактураНаходитсяВПодвале"		 	- Булево - Признак того, есть у документа счет-фактура в подвале
//  		"ЯвляетсяСчетомФактурой"				- Булево - Признак того, является ли сам документ счетом-фактурой.
Процедура ОпределитьВидДокумента(Форма, Результат) Экспорт
	
	//++ НЕ ГОСИС
	ТипИсточника = ТипЗнч(Форма);
	
	// Определение типа источника
	Если ТипИсточника = Тип("УправляемаяФорма") Тогда
		ДокументСсылка = Форма.Объект.Ссылка;
		ТипСсылки = ТипЗнч(ДокументСсылка);
	ИначеЕсли ТипИсточника = Тип("ДокументСсылка.РеализацияТоваровУслуг")
		Или ТипИсточника = Тип("ДокументСсылка.АвансовыйОтчет")
		Или ТипИсточника = Тип("ДокументСсылка.АктВыполненныхРабот")
		Или ТипИсточника = Тип("ДокументСсылка.ВводОстатков")
		Или ТипИсточника = Тип("ДокументСсылка.ВзаимозачетЗадолженности")
		Или ТипИсточника = Тип("ДокументСсылка.ВозвратТоваровМеждуОрганизациями")
		Или ТипИсточника = Тип("ДокументСсылка.ВозвратТоваровПоставщику")
		Или ТипИсточника = Тип("ДокументСсылка.ВозвратТоваровОтКлиента")
		Или ТипИсточника = Тип("ДокументСсылка.ВыкупВозвратнойТарыУПоставщика")
		Или ТипИсточника = Тип("ДокументСсылка.ВыкупВозвратнойТарыКлиентом")
		Или ТипИсточника = Тип("ДокументСсылка.ЗаписьКнигиПокупок")
		Или ТипИсточника = Тип("ДокументСсылка.ЗаписьКнигиПродаж")
		Или ТипИсточника = Тип("ДокументСсылка.КорректировкаРеализации")
		Или ТипИсточника = Тип("ДокументСсылка.КорректировкаПриобретения")
		Или ТипИсточника = Тип("ДокументСсылка.ОтчетКомитенту")
		Или ТипИсточника = Тип("ДокументСсылка.ОтчетКомиссионера")
		Или ТипИсточника = Тип("ДокументСсылка.ОтчетПоКомиссииМеждуОрганизациями")
		Или ТипИсточника = Тип("ДокументСсылка.ПередачаТоваровМеждуОрганизациями")
		Или ТипИсточника = Тип("ДокументСсылка.ПриобретениеТоваровУслуг")
		Или ТипИсточника = Тип("ДокументСсылка.ПриобретениеУслугПрочихАктивов")
		Или ТипИсточника = Тип("ДокументСсылка.РасходныйКассовыйОрдер")
		Или ТипИсточника = Тип("ДокументСсылка.РеализацияУслугПрочихАктивов")
		Или ТипИсточника = Тип("ДокументСсылка.СчетФактураВыданный") 
		Или ТипИсточника = Тип("ДокументСсылка.СчетФактураВыданныйАванс")
		Или ТипИсточника = Тип("ДокументСсылка.СчетФактураНалоговыйАгент")
		Или ТипИсточника = Тип("ДокументСсылка.СчетФактураПолученный")
		Или ТипИсточника = Тип("ДокументСсылка.СчетФактураПолученныйАванс")
		Или ТипИсточника = Тип("ДокументСсылка.СписаниеБезналичныхДенежныхСредств")
		
		//++ НЕ УТКА
		Или ТипИсточника = Тип("ДокументСсылка.ОтчетДавальцу")
		//-- НЕ УТКА
		//++ НЕ УТ
		Или ТипИсточника = Тип("ДокументСсылка.ПриобретениеУслугПоЛизингу")
		Или ТипИсточника = Тип("ДокументСсылка.ОтчетПереработчика")
		//-- НЕ УТ
		
		Тогда
		
		ТипСсылки = ТипИсточника;
		
	КонецЕсли;
	
	// Определение вида по типу источника.
	Если ТипСсылки = Тип("ДокументСсылка.РеализацияТоваровУслуг")
		Или ТипСсылки = Тип("ДокументСсылка.АктВыполненныхРабот")
		Или ТипСсылки = Тип("ДокументСсылка.ВозвратТоваровМеждуОрганизациями")
		Или ТипСсылки = Тип("ДокументСсылка.ВозвратТоваровОтКлиента")
		Или ТипСсылки = Тип("ДокументСсылка.ВозвратТоваровПоставщику") 
		Или ТипСсылки = Тип("ДокументСсылка.ВыкупВозвратнойТарыУПоставщика")
		Или ТипСсылки = Тип("ДокументСсылка.ВыкупВозвратнойТарыКлиентом")
		Или ТипСсылки = Тип("ДокументСсылка.ЗаписьКнигиПродаж")
		Или ТипСсылки = Тип("ДокументСсылка.КорректировкаРеализации")
		Или ТипСсылки = Тип("ДокументСсылка.КорректировкаПриобретения")
		Или ТипСсылки = Тип("ДокументСсылка.ОтчетКомитенту")
		Или ТипСсылки = Тип("ДокументСсылка.ПередачаТоваровМеждуОрганизациями") 
		Или ТипСсылки = Тип("ДокументСсылка.РеализацияУслугПрочихАктивов")
		Или ТипСсылки = Тип("ДокументСсылка.ПриобретениеТоваровУслуг")
		Или ТипСсылки = Тип("ДокументСсылка.ПриобретениеУслугПрочихАктивов")
		Или ТипСсылки = Тип("ДокументСсылка.ПриходныйКассовыйОрдер") 
		
		//++ НЕ УТКА
		Или ТипСсылки = Тип("ДокументСсылка.ОтчетДавальцу")
		//-- НЕ УТКА
		//++ НЕ УТ
		Или ТипСсылки = Тип("ДокументСсылка.ПриобретениеУслугПоЛизингу")
		Или ТипСсылки = Тип("ДокументСсылка.ОтчетПереработчика")
		//-- НЕ УТ
		
		Тогда
		
		Результат.Вставить("КонтрагентНаходитсяВШапке"   , Истина);
		Результат.Вставить("СчетФактураНаходитсяВПодвале", Истина);
		
	ИначеЕсли ТипСсылки = Тип("ДокументСсылка.ОперацияПоПлатежнойКарте")
		Или ТипСсылки = Тип("ДокументСсылка.ПоступлениеБезналичныхДенежныхСредств")
		Или ТипСсылки = Тип("ДокументСсылка.ПриходныйКассовыйОрдер")
		Или ТипСсылки = Тип("ДокументСсылка.РасходныйКассовыйОрдер")
		Или ТипСсылки = Тип("ДокументСсылка.СписаниеБезналичныхДенежныхСредств") Тогда

		Результат.Вставить("КонтрагентНаходитсяВШапке"   , Истина);
		
	ИначеЕсли ТипСсылки = Тип("ДокументСсылка.ОтчетКомиссионера")
		Или ТипСсылки = Тип("ДокументСсылка.ОтчетПоКомиссииМеждуОрганизациями") Тогда
		
		Результат.Вставить("КонтрагентНаходитсяВШапке"         , Истина);
		Результат.Вставить("КонтрагентНаходитсяВТабличнойЧасти", Истина);
		Результат.Вставить("СчетФактураНаходитсяВПодвале"      , Истина);
		
	ИначеЕсли ТипСсылки = Тип("ДокументСсылка.ВзаимозачетЗадолженности")
		Или ТипСсылки = Тип("ДокументСсылка.СчетФактураВыданный")
		Или ТипСсылки = Тип("ДокументСсылка.СчетФактураВыданныйАванс")
		Или ТипСсылки = Тип("ДокументСсылка.СчетФактураВыданныйАванс")
		Или ТипСсылки = Тип("ДокументСсылка.СчетФактураНалоговыйАгент")
		Или ТипСсылки = Тип("ДокументСсылка.СчетФактураПолученный")
		Или ТипСсылки = Тип("ДокументСсылка.СчетФактураПолученныйАванс")
		Или ТипСсылки = Тип("ДокументСсылка.ЗаписьКнигиПокупок") Тогда
		
		Результат.Вставить("ЯвляетсяСчетомФактурой", Истина);
		
	ИначеЕсли ТипСсылки = Тип("ДокументСсылка.СчетФактураКомиссионеру")
		Или ТипСсылки = Тип("ДокументСсылка.СчетФактураКомитента") Тогда
		
		Результат.Вставить("ЯвляетсяСчетомФактурой", Истина);
		Результат.Вставить("КонтрагентНаходитсяВТабличнойЧасти", Истина);
		
	ИначеЕсли ТипСсылки = Тип("ДокументСсылка.ВводОстатков") Тогда
		
		Если Форма.ИмяФормы = "Документ.ВводОстатков.Форма.ФормаТовары" Тогда
			
			Результат.Вставить("КонтрагентНаходитсяВШапке"         , Истина);
			Результат.Вставить("СчетФактураНаходитсяВПодвале"      , Истина);
			
		ИначеЕсли Форма.ИмяФормы = "Документ.ВводОстатков.Форма.ФормаРасчетыСПартнерами" Тогда
			
			Результат.Вставить("КонтрагентНаходитсяВТабличнойЧасти", Истина);
			
		КонецЕсли;
		
	ИначеЕсли ТипСсылки = Тип("ДокументСсылка.АвансовыйОтчет") Тогда
		
		Результат.Вставить("КонтрагентНаходитсяВТабличнойЧасти", Истина);
		
	КонецЕсли;
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Получение счета-фактуры, находящегося в подвале документа-основания, чья форма передана в качестве
//             параметра.
//
// Параметры:
//  Форма		 - УправляемаяФорма - Форма документа-основания, для которой необходимо получить счет-фактуру.
//  СчетФактура	 - ДокументСсылка - Счет-фактура, полученная для данного документа-основания.
Процедура ПолучитьСчетФактуру(Форма, СчетФактура) Экспорт
	
	//++ НЕ ГОСИС
	СчетФактура = ПроверкаКонтрагентовВызовСервераПереопределяемыйУТ.ПолучитьКонтрагентовСчетФактурДокумента(Форма.Объект.Ссылка);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Возможность доопределить сформированную подсказку для формы документа.
//
// Параметры:
//  Результат            - Структура - содержит текст подсказки и цвет фона подсказки.
//  СостояниеКонтрагента - ПеречислениеСсылка.СостоянияСуществованияКонтрагента - текущее состояние контрагента.
//  Цвета                - Структура - содержит цвета, используемые при выводе информации о состоянии контрагента.
//
Процедура ПослеФормированияПодсказкиВДокументе(Результат, СостояниеКонтрагента, Цвета) Экспорт
	
	//++ НЕ ГОСИС
	Если Цвета <> Неопределено Тогда
		
		Результат.Вставить("ЕстьОшибка", Результат.ЦветФона = Цвета.ЦветФонаНекорректногоКонтрагентаВДокументе);
		
	Иначе
		
		Результат.Вставить("ЕстьОшибка", Ложь);
		
	КонецЕсли;
	//-- НЕ ГОСИС
	
КонецПроцедуры 

#КонецОбласти

#Область ПроверкаКонтрагентовВОтчетах

// Вывод панели проверки в отчете.
//
// Параметры:
//  Форма	 				- УправляемаяФорма - Форма отчета, для которого выводится результат проверки контрагента.
//  СостояниеПроверки		- Строка - Текущее состояние проверки, может принимать следующие значения, либо быть пустой
//                                строкой: ВсеКонтрагентыКорректные
// 			НайденыНекорректныеКонтрагенты
// 			ДопИнформацияПоПроверке
// 			ПроверкаВПроцессеВыполнения
// 			НетДоступаКСервису.
//  СтандартнаяОбработка	- Булево - Если Ложь, то игнорируется стандартное действие и выполняется указанное в данной
//                                  процедуре.
Процедура УстановитьВидПанелиПроверкиКонтрагентовВОтчете(Форма, СтандартнаяОбработка, СостояниеПроверки = "") Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область ПроверкаКонтрагентовВСправочнике

// Отображение результата проверки контрагента в справочнике.
// Реализация тела метода является обязательной.
//
// Параметры:
//  Форма - УправляемаяФорма - Форма справочника, в котором выполнялась проверка контрагента.
//  	Результат проверки хранится в реквизите РеквизитыПроверкиКонтрагентов(Структура) формы контрагента.
//  	Структуру полей РеквизитыПроверкиКонтрагентов см. в процедуре ИнициализироватьРеквизитыФормыКонтрагент ОМ
//  	ПроверкаКонтрагентов.
//  ПредставлениеРезультатаПроверки	 - ФорматированнаяСтрока, Строка - представление результата проверки
//  					контрагента.
//
Процедура ОтобразитьРезультатПроверкиКонтрагентаВСправочнике(Форма, ПредставлениеРезультатаПроверки) Экспорт
	
	//++ НЕ ГОСИС
	ПроверкаКонтрагентовКлиентСерверПереопределяемыйУТ.ОтобразитьРезультатПроверкиКонтрагентаВСправочнике(Форма, ПредставлениеРезультатаПроверки);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Определяет строковое представление результата проверки контрагента.
//
// Параметры:
//  Форма - УправляемаяФорма - Форма справочника, в котором выполнялась проверка контрагента.
//  	Результат проверки хранится в реквизите РеквизитыПроверкиКонтрагентов(Структура) формы контрагента.
//  	Структуру полей РеквизитыПроверкиКонтрагентов см. в процедуре ИнициализироватьРеквизитыФормыКонтрагент ОМ
//  	ПроверкаКонтрагентов.
//  Текст - Строка - представление результата проверки контрагента.
//
Процедура ПриЗаполненииТекстаРезультатаПроверки(Форма, Текст) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#Область ПрочиеПроцедуры

// Получение объекта (ДанныеФормыСтруктура) и ссылки(ДокументСсылка, СправочникСсылка) документа или
// справочника,  в котором выполняется проверка контрагента, по форме.
// Обязательна к заполнению.
//
// Параметры:
//	Форма     - УправляемаяФорма - Форма документа или справочника, в котором выполняется проверка контрагента.
//	Результат - Структура - Объект и Ссылка, полученные по форме документа.
//		Ключи: "Объект" (Тип ДанныеФормыСтруктура) и "Ссылка" (Тип ДокументСсылка, СправочникСсылка).
//
Процедура ПриОпределенииОбъектаИСсылкиПоФорме(Форма, Результат) Экспорт
	
	//++ НЕ ГОСИС
	Если Форма.ИмяФормы = "Справочник.Партнеры.Форма.ФормаЭлементаРеквизитыКонтрагента" Тогда
		ИсточникОбъект = Форма;
		ИсточникСсылка = ИсточникОбъект.КонтрагентПартнера;
	Иначе
		ИсточникОбъект = Форма.Объект;
		ИсточникСсылка = ИсточникОбъект.Ссылка;
	КонецЕсли;
	
	Результат.Вставить("Объект", ИсточникОбъект); 
	Результат.Вставить("Ссылка", ИсточникСсылка);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Возможность дополнить параметры запуска фонового задания при проверке справочника.
//
// Параметры:
//  ДополнительныеПараметрыЗапуска - Структура - содержит параметры запуска.
//  Форма                          - УправляемаяФорма - форма, из которой запускается фоновое задание.
//
Процедура ДополнитьПараметрыЗапускаФоновогоЗадания(ДополнительныеПараметрыЗапуска, Форма) Экспорт

	//++ НЕ ГОСИС
	Если Форма.РеквизитыПроверкиКонтрагентов.Свойство("ЮрФизЛицо") Тогда
		ДополнительныеПараметрыЗапуска.Вставить("ЮрФизЛицо", Форма.РеквизитыПроверкиКонтрагентов.ЮрФизЛицо);
	КонецЕсли;
	
	Если Форма.РеквизитыПроверкиКонтрагентов.Свойство("НеИспользоватьКэш") Тогда
		ДополнительныеПараметрыЗапуска.Вставить("НеИспользоватьКэш", Форма.РеквизитыПроверкиКонтрагентов.НеИспользоватьКэш);
	КонецЕсли;
	//-- НЕ ГОСИС
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
