#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Справочники.КомплектыОтчетностиПерсучета.ДокументыСЗВПередЗаписью(ЭтотОбъект, РежимЗаписи);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	Если ПерсонифицированныйУчет.СведенияДокументаРазнесеныПоЛицевымСчетам(Ссылка) Тогда
		ДанныеДляПроведения = ДанныеДляПроведения();
		
		ПериодРасчетов = ?(ТипСведенийСЗВ = Перечисления.ТипыСведенийСЗВ.ИСХОДНАЯ, ОтчетныйПериод, КорректируемыйПериод);
		ПерсонифицированныйУчет.ЗарегистрироватьПереданныеВПФРВзносы(Движения, Организация, ПериодРасчетов, ДанныеДляПроведения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолныйПутьКИсточникуОшибки(СообщениеПользователю) Экспорт
	
	Поле = СообщениеПользователю.Поле;
	
	СтруктураПути = ПерсонифицированныйУчетКлиентСервер.СтруктураПутиКИсточникуОшибки(СообщениеПользователю.Поле);
		
	Если СтруктураПути.ИндексСтроки <> Неопределено
		И СтруктураПути.ПутьКРеквизиту = "ЗаписиОСтаже" Тогда
		
		Сотрудник = ЭтотОбъект[СтруктураПути.ПутьКРеквизиту][СтруктураПути.ИндексСтроки].Сотрудник;
		
		СтрокаТаблицыСотрудник = Сотрудники.Найти(Сотрудник, "Сотрудник");
		
		СтруктураПути.Родитель = ПерсонифицированныйУчетКлиентСервер.СтруктураПутиКОшибке();
		СтруктураПути.Родитель.ПутьКРеквизиту = "Сотрудники";
		СтруктураПути.Родитель.ИндексСтроки = СтрокаТаблицыСотрудник.НомерСтроки - 1;
		СтруктураПути.Родитель.ИмяРеквизитаТабличнойЧасти = "";
	КонецЕсли;
	
	Возврат СтруктураПути;
	
КонецФункции

Функция СформироватьЗапросДляПроверкиЗаполнения()
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("ТаблицаЗаписиОСтаже", ЗаписиОСтаже);
	Запрос.УстановитьПараметр("ТаблицаСотрудники", Сотрудники);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаСотрудники.НомерСтроки,
	|	ТаблицаСотрудники.Сотрудник,
	|	ТаблицаСотрудники.Фамилия,
	|	ТаблицаСотрудники.Имя,
	|	ТаблицаСотрудники.Отчество,
	|	ТаблицаСотрудники.АдресДляИнформирования,
	|	ТаблицаСотрудники.СтраховойНомерПФР,
	|	ТаблицаСотрудники.НачисленоСтраховая,
	|	ТаблицаСотрудники.УплаченоСтраховая,
	|	ТаблицаСотрудники.НачисленоНакопительная,
	|	ТаблицаСотрудники.УплаченоНакопительная
	|ПОМЕСТИТЬ ВТСотрудники
	|ИЗ
	|	&ТаблицаСотрудники КАК ТаблицаСотрудники";
	
	Запрос.Выполнить();
	
	НачалоПериода = НачалоМесяца(ОтчетныйПериод);
	ОкончаниеПериода = ПерсонифицированныйУчетКлиентСервер.ОкончаниеОтчетногоПериодаПерсУчета(ОтчетныйПериод);
	
	КадровыйУчет.СоздатьВТФизическиеЛицаРаботавшиеВОрганизации(Запрос.МенеджерВременныхТаблиц, Истина, Организация, НачалоПериода, ОкончаниеПериода);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СотрудникиДокумента.НомерСтроки,
	|	МИНИМУМ(ДублиСтрок.НомерСтроки) КАК НомерСтрокиДубль
	|ПОМЕСТИТЬ ВТДублиСтрокСотрудник
	|ИЗ
	|	ВТСотрудники КАК СотрудникиДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТСотрудники КАК ДублиСтрок
	|		ПО СотрудникиДокумента.НомерСтроки > ДублиСтрок.НомерСтроки
	|			И СотрудникиДокумента.Сотрудник = ДублиСтрок.Сотрудник
	|
	|СГРУППИРОВАТЬ ПО
	|	СотрудникиДокумента.НомерСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СотрудникиДокумента.НомерСтроки,
	|	МИНИМУМ(ДублиСтрок.НомерСтроки) КАК НомерСтрокиДубль
	|ПОМЕСТИТЬ ВТДублиСтрокСтраховойНомерПФР
	|ИЗ
	|	ВТСотрудники КАК СотрудникиДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТСотрудники КАК ДублиСтрок
	|		ПО СотрудникиДокумента.НомерСтроки > ДублиСтрок.НомерСтроки
	|			И СотрудникиДокумента.СтраховойНомерПФР = ДублиСтрок.СтраховойНомерПФР
	|			И СотрудникиДокумента.Сотрудник <> ДублиСтрок.Сотрудник
	|			И (СотрудникиДокумента.СтраховойНомерПФР <> """")
	|			И (СотрудникиДокумента.СтраховойНомерПФР <> ""   -   -      "")
	|
	|СГРУППИРОВАТЬ ПО
	|	СотрудникиДокумента.НомерСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СотрудникиДокумента.НомерСтроки,
	|	СотрудникиДокумента.Сотрудник КАК Сотрудник,
	|	СотрудникиДокумента.Фамилия,
	|	СотрудникиДокумента.Имя,
	|	СотрудникиДокумента.Отчество,
	|	СотрудникиДокумента.Сотрудник.Наименование КАК СотрудникНаименование,
	|	СотрудникиДокумента.АдресДляИнформирования,
	|	СотрудникиДокумента.СтраховойНомерПФР,
	|	ДублиСтрок.НомерСтрокиДубль КАК КонфликтующаяСтрока,
	|	ВЫБОР
	|		КОГДА АктуальныеСотрудники.ФизическоеЛицо ЕСТЬ NULL 
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК СотрудникРаботаетВОрганизации,
	|	ДублиСтрокСтраховойНомерПФР.НомерСтрокиДубль КАК КонфликтующаяСтрокаСтраховойНомер,
	|	СотрудникиДокумента.НачисленоСтраховая,
	|	СотрудникиДокумента.УплаченоСтраховая,
	|	СотрудникиДокумента.НачисленоНакопительная,
	|	СотрудникиДокумента.УплаченоНакопительная,
	|	СотрудникиДокумента.Сотрудник.ДатаРождения КАК ДатаРождения
	|ПОМЕСТИТЬ ВТСотрудникиДокумента
	|ИЗ
	|	ВТСотрудники КАК СотрудникиДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТДублиСтрокСотрудник КАК ДублиСтрок
	|		ПО СотрудникиДокумента.НомерСтроки = ДублиСтрок.НомерСтроки
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТДублиСтрокСтраховойНомерПФР КАК ДублиСтрокСтраховойНомерПФР
	|		ПО СотрудникиДокумента.НомерСтроки = ДублиСтрокСтраховойНомерПФР.НомерСтроки
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТФизическиеЛицаРаботавшиеВОрганизации КАК АктуальныеСотрудники
	|		ПО СотрудникиДокумента.Сотрудник = АктуальныеСотрудники.ФизическоеЛицо
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Сотрудник
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаЗаписиОСтаже.Сотрудник,
	|	ТаблицаЗаписиОСтаже.НомерСтроки,
	|	ТаблицаЗаписиОСтаже.ДатаНачалаПериода,
	|	ТаблицаЗаписиОСтаже.ДатаОкончанияПериода
	|ПОМЕСТИТЬ ВТТаблицаСтажа
	|ИЗ
	|	&ТаблицаЗаписиОСтаже КАК ТаблицаЗаписиОСтаже
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаписиОСтаже.НомерСтроки КАК НомерСтроки,
	|	0 КАК НомерОсновнойЗаписи,
	|	0 КАК НомерДополнительнойЗаписи,
	|	ЗаписиОСтаже.Сотрудник,
	|	ЗаписиОСтаже.ДатаНачалаПериода,
	|	ЗаписиОСтаже.ДатаОкончанияПериода,
	|	ЗНАЧЕНИЕ(Справочник.ОсобыеУсловияТрудаПФР.ПустаяСсылка) КАК ОсобыеУсловияТруда,
	|	ЗНАЧЕНИЕ(Справочник.СпискиПрофессийДолжностейЛьготногоПенсионногоОбеспечения.ПустаяСсылка) КАК КодПозицииСписка,
	|	ЗНАЧЕНИЕ(Справочник.ОснованияИсчисляемогоСтраховогоСтажа.ПустаяСсылка) КАК ОснованиеИсчисляемогоСтажа,
	|	0 КАК ПервыйПараметрИсчисляемогоСтажа,
	|	0 КАК ВторойПараметрИсчисляемогоСтажа,
	|	ЗНАЧЕНИЕ(Справочник.ПараметрыИсчисляемогоСтраховогоСтажа.ПустаяСсылка) КАК ТретийПараметрИсчисляемогоСтажа,
	|	ЗНАЧЕНИЕ(Справочник.ОснованияДосрочногоНазначенияПенсии.ПустаяСсылка) КАК ОснованиеВыслугиЛет,
	|	0 КАК ПервыйПараметрВыслугиЛет,
	|	0 КАК ВторойПараметрВыслугиЛет,
	|	0 КАК ТретийПараметрВыслугиЛет,
	|	ЗНАЧЕНИЕ(Справочник.ТерриториальныеУсловияПФР.ПустаяСсылка) КАК ТерриториальныеУсловия,
	|	0 КАК ПараметрТерриториальныхУсловий,
	|	ЛОЖЬ КАК ФиксСтаж,
	|	СотрудникиДокумента.НомерСтроки КАК НомерСтрокиСотрудник
	|ПОМЕСТИТЬ ВТЗаписиОСтаже
	|ИЗ
	|	ВТСотрудникиДокумента КАК СотрудникиДокумента
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТТаблицаСтажа КАК ЗаписиОСтаже
	|		ПО СотрудникиДокумента.Сотрудник = ЗаписиОСтаже.Сотрудник
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ЗаписиОСтаже.Сотрудник
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаСтажа.НомерСтроки КАК НомерСтрокиСтаж,
	|	СотрудникиДокумента.НомерСтроки КАК НомерСтрокиСотрудник,
	|	СотрудникиДокумента.Сотрудник КАК Сотрудник,
	|	СотрудникиДокумента.СотрудникНаименование,
	|	СотрудникиДокумента.АдресДляИнформирования,
	|	СотрудникиДокумента.СтраховойНомерПФР,
	|	СотрудникиДокумента.СотрудникРаботаетВОрганизации,
	|	СотрудникиДокумента.КонфликтующаяСтрока,
	|	СотрудникиДокумента.Фамилия,
	|	СотрудникиДокумента.Имя,
	|	ТаблицаСтажа.ДатаНачалаПериода,
	|	ТаблицаСтажа.ДатаОкончанияПериода,
	|	СотрудникиДокумента.КонфликтующаяСтрокаСтраховойНомер,
	|	СотрудникиДокумента.НачисленоСтраховая,
	|	СотрудникиДокумента.УплаченоСтраховая,
	|	СотрудникиДокумента.НачисленоНакопительная,
	|	СотрудникиДокумента.УплаченоНакопительная,
	|	СотрудникиДокумента.ДатаРождения КАК ДатаРождения,
	|	СотрудникиДокумента.Отчество
	|ИЗ
	|	ВТСотрудникиДокумента КАК СотрудникиДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТТаблицаСтажа КАК ТаблицаСтажа
	|		ПО СотрудникиДокумента.Сотрудник = ТаблицаСтажа.Сотрудник
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтрокиСотрудник,
	|	НомерСтрокиСтаж";
	
	Возврат Запрос;
	
КонецФункции

Процедура ПроверитьДанныеДокумента(Отказ = Ложь) Экспорт 
	Ошибки = Новый Массив;
	
	Если Не ПроверитьЗаполнение() Тогда
		Отказ = Истина;
	КонецЕсли;	
	
	ТекстОшибки = НСтр("ru = 'Форма СЗВ-6-2 подается за периоды до 2013 г.'");

	Если ТипСведенийСЗВ = Перечисления.ТипыСведенийСЗВ.ИСХОДНАЯ Тогда
		Если ОтчетныйПериод >= '20130101' Тогда
			ПерсонифицированныйУчетКлиентСервер.ДобавитьОшибкуЗаполненияЭлементаДокумента(Ошибки, Ссылка, ТекстОшибки, "ОтчетныйПериод", Отказ);
		КонецЕсли;
	Иначе
		Если КорректируемыйПериод >= '20130101' Тогда
			ПерсонифицированныйУчетКлиентСервер.ДобавитьОшибкуЗаполненияЭлементаДокумента(Ошибки, Ссылка, ТекстОшибки, "КорректируемыйПериод", Отказ);
		КонецЕсли;
	КонецЕсли;	
	
	Если Не ДополнительныеСвойства.Свойство("НеПроверятьДанныеОрганизации") Тогда
		ПерсонифицированныйУчет.ПроверитьДанныеОрганизации(ЭтотОбъект, Организация, Отказ);
	КонецЕсли;	
	
	ЗапросПоСтрокамДокумента = СформироватьЗапросДляПроверкиЗаполнения();
	ПерсонифицированныйУчет.ПроверитьЗаполнениеДанныхВзносахИСтаже(ЭтотОбъект, ЗапросПоСтрокамДокумента, Ошибки, Отказ, Ложь);
	
	Если ТипСведенийСЗВ <> Перечисления.ТипыСведенийСЗВ.ОТМЕНЯЮЩАЯ Тогда
		Период = ?(ТипСведенийСЗВ = Перечисления.ТипыСведенийСЗВ.ИСХОДНАЯ, ОтчетныйПериод, КорректируемыйПериод);
		
		ПерсонифицированныйУчет.ПроверитьЗаписиОСтаже(ЗапросПоСтрокамДокумента.МенеджерВременныхТаблиц, Ссылка, Период, Отказ, Ложь);		
	КонецЕсли;	
	
КонецПроцедуры

Функция ДанныеДляПроведения()
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Если ТипСведенийСЗВ = Перечисления.ТипыСведенийСЗВ.ИСХОДНАЯ Тогда
		Запрос.Текст =
		"ВЫБРАТЬ
		|	РеестрСЗВ_6_2Сотрудники.НачисленоСтраховая,
		|	РеестрСЗВ_6_2Сотрудники.УплаченоСтраховая,
		|	РеестрСЗВ_6_2Сотрудники.НачисленоНакопительная,
		|	РеестрСЗВ_6_2Сотрудники.УплаченоНакопительная,
		|	РеестрСЗВ_6_2Сотрудники.Сотрудник КАК ФизическоеЛицо,
		|	РеестрСЗВ_6_2Сотрудники.Ссылка.КатегорияЗастрахованныхЛиц,
		|	ЗНАЧЕНИЕ(Перечисление.ТипыДоговоровСЗВ63.ПустаяСсылка) КАК ТипДоговора
		|ИЗ
		|	Документ.РеестрСЗВ_6_2.Сотрудники КАК РеестрСЗВ_6_2Сотрудники
		|ГДЕ	
		|	РеестрСЗВ_6_2Сотрудники.Ссылка = &Ссылка";
	Иначе
		Запрос.Текст =
		"ВЫБРАТЬ
		|	РеестрСЗВ_6_2Сотрудники.ДоНачисленоСтраховая КАК НачисленоСтраховая,
		|	РеестрСЗВ_6_2Сотрудники.ДоУплаченоСтраховая КАК УплаченоСтраховая,
		|	РеестрСЗВ_6_2Сотрудники.ДоНачисленоНакопительная КАК НачисленоНакопительная,
		|	РеестрСЗВ_6_2Сотрудники.ДоУплаченоНакопительная КАК УплаченоНакопительная,
		|	РеестрСЗВ_6_2Сотрудники.Сотрудник КАК ФизическоеЛицо,
		|	РеестрСЗВ_6_2Сотрудники.Ссылка.КатегорияЗастрахованныхЛиц,
		|	ЗНАЧЕНИЕ(Перечисление.ТипыДоговоровСЗВ63.ПустаяСсылка) КАК ТипДоговора
		|ИЗ
		|	Документ.РеестрСЗВ_6_2.Сотрудники КАК РеестрСЗВ_6_2Сотрудники
		|ГДЕ
		|	РеестрСЗВ_6_2Сотрудники.Ссылка = &Ссылка";
	КонецЕсли;
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Функция ОкончаниеОтчетногоПериода() Экспорт
	
	Возврат ПерсонифицированныйУчетКлиентСервер.ОкончаниеОтчетногоПериодаПерсУчета(ОтчетныйПериод);
	
КонецФункции

#КонецОбласти

#КонецЕсли