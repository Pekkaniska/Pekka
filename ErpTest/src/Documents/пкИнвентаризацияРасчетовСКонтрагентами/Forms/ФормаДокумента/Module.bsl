&НаКлиенте
Перем ТекущиеДанныеИдентификатор; //используется для передачи текущей строки в обработчик ожидания

/////////////////////////////////////////////////////////////////////////
&НаСервере
Функция ПолучитьЗначениеРеквизитаНаСервере(тОбъект, ИмяРевизита)
	
	Возврат тОбъект[ИмяРевизита];
	
КонецФункции

&НаСервере
Функция ПолучитьЗначениеПеречисленияНаСервере(ИмяПеречисления, ИмяЗначения)
	
	Возврат Перечисления[ИмяПеречисления][ИмяЗначения];
	
КонецФункции

/////////////////////////////////////////////////////////////////////////
// Стандартное (почти)

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗакрытьФорму()
	
	Закрыть();
	
КонецПроцедуры

#Область ОбработчикиКомандФормы
// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	
	Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтаФорма, Команда.Имя) Тогда
		РезультатВыполнения = Неопределено;
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
		ДополнительныеОтчетыИОбработкиКлиент.ПоказатьРезультатВыполненияКоманды(ЭтаФорма, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	//МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуСоздатьНаОсновании(Команда)
	
	//ВводНаОснованииКлиент.ВыполнитьПодключаемуюКомандуСоздатьНаОсновании(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

#КонецОбласти

/////////////////////////////////////////////////////////////////////////
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	// Обработчик механизма "ВерсионированиеОбъектов"
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	
	// Обработчик подсистемы "Внешние обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать

	//ВводНаОсновании.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюСоздатьНаОсновании);
	
	//МенюОтчеты.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюОтчеты);
	
	// ИнтеграцияС1СДокументооборотом
	//ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);
	
	ОбщегоНазначенияУТКлиент.ВыполнитьДействияПослеЗаписи(ЭтаФорма, Объект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеПоЗадолженностиНаСервере()
	
	Запрос=Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ХозрасчетныйОстатки.Счет КАК СчетРасчетов,
	               |	ХозрасчетныйОстатки.Субконто1 КАК Контрагент,
	               |	ХозрасчетныйОстатки.СуммаОстатокДт,
	               |	ХозрасчетныйОстатки.СуммаОстатокКт,
	               |	ХозрасчетныйОстатки.ВалютнаяСуммаОстатокДт,
	               |	ХозрасчетныйОстатки.ВалютнаяСуммаОстатокКт,
	               |	ХозрасчетныйОстатки.Валюта КАК ВалютаВзаиморасчетов
	               |ИЗ
	               |	РегистрБухгалтерии.Хозрасчетный.Остатки(
				   |			&Период,
	               |			Счет В ИЕРАРХИИ (&МассивСчетов),
	               |			,
	               |			Организация = &Организация
				   //|				И (&Подразделение = ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка)ИЛИ Подразделение = &Подразделение)
	               |					) КАК ХозрасчетныйОстатки
	               |ГДЕ
	               |	ХозрасчетныйОстатки.Организация = &Организация
				   //|	И (&Подразделение = ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка) ИЛИ ХозрасчетныйОстатки.Подразделение = &Подразделение)
	               |			
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Контрагент,
	               |	СчетРасчетов";
	Запрос.УстановитьПараметр("Организация", Объект.Организация);	
	Запрос.УстановитьПараметр("Подразделение", Объект.Подразделение);	
	Запрос.УстановитьПараметр("МассивСчетов", Объект.СчетаРасчетов.Выгрузить().ВыгрузитьКолонку("СчетРасчета"));
//Рарус Владимир Подрезов 07.07.2017
	//Запрос.УстановитьПараметр("Период", ?(ЗначениеЗаполнено(Объект.Дата),КонецДня(Объект.Дата),КонецДня(ТекущаяДата())));
	Запрос.УстановитьПараметр("Период", ?(ЗначениеЗаполнено(Объект.Дата),КонецДня(Объект.Дата),КонецДня(ТекущаяДата())) + 1);
//Рарус Владимир Подрезов Конец
	
	ВалютаРегл=Константы.ВалютаРегламентированногоУчета.Получить();
	
	ВыборкаЗапроса=Запрос.Выполнить().Выбрать();
	
	Объект.ДебиторскаяЗадолженность.Очистить();
	Объект.КредиторскаяЗадолженность.Очистить();
	
	Пока ВыборкаЗапроса.Следующий() Цикл
		Если ВыборкаЗапроса.СуммаОстатокДт>0 Тогда
			НоваяЗадолженность=Объект.ДебиторскаяЗадолженность.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяЗадолженность,ВыборкаЗапроса);
			НоваяЗадолженность.СуммаВзаиморасчетов=ВыборкаЗапроса.ВалютнаяСуммаОстатокДт;
			НоваяЗадолженность.Сумма=ВыборкаЗапроса.СуммаОстатокДт;
			НоваяЗадолженность.Подтверждено=НоваяЗадолженность.Сумма;
			Если Не ЗначениеЗаполнено(НоваяЗадолженность.ВалютаВзаиморасчетов) Тогда
				НоваяЗадолженность.ВалютаВзаиморасчетов=ВалютаРегл;
				НоваяЗадолженность.СуммаВзаиморасчетов=НоваяЗадолженность.Сумма;
			КонецЕсли; 
		КонецЕсли; 
		Если ВыборкаЗапроса.СуммаОстатокКт>0 Тогда
			НоваяЗадолженность=Объект.КредиторскаяЗадолженность.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяЗадолженность,ВыборкаЗапроса);
			НоваяЗадолженность.СуммаВзаиморасчетов=ВыборкаЗапроса.ВалютнаяСуммаОстатокКт;
			НоваяЗадолженность.Сумма=ВыборкаЗапроса.СуммаОстатокКт;
			НоваяЗадолженность.Подтверждено=НоваяЗадолженность.Сумма;
			Если Не ЗначениеЗаполнено(НоваяЗадолженность.ВалютаВзаиморасчетов) Тогда
				НоваяЗадолженность.ВалютаВзаиморасчетов=ВалютаРегл;
				НоваяЗадолженность.СуммаВзаиморасчетов=НоваяЗадолженность.Сумма;
			КонецЕсли; 
		КонецЕсли; 
	КонецЦикла; 	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДанныеПоЗадолженности(Команда)
	ЗаполнитьДанныеПоЗадолженностиНаСервере();
КонецПроцедуры

&НаСервере
Функция ИНВ_17НаСервере()
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	МакетИнв17=ДокументОбъект.ПолучитьИНВ_17();
	Возврат МакетИнв17;
КонецФункции

&НаКлиенте
Процедура ИНВ_17(Команда)
	МакетИнв17=ИНВ_17НаСервере();
	МакетИнв17.Показать();	
КонецПроцедуры

&НаСервере
Функция ИНВ_22НаСервере()
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	МакетИнв22=ДокументОбъект.ПолучитьИНВ_22();
	Возврат МакетИнв22;
КонецФункции

&НаКлиенте
Процедура ИНВ_22(Команда)
	МакетИнв22=ИНВ_22НаСервере();
	МакетИнв22.Показать();	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////




///////////////////////////////////////////////////////////////////////////////
