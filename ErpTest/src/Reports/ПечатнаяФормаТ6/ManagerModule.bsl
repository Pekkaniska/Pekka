#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "Т6");
	НастройкиВарианта.Описание = НСтр("ru = 'Унифицированная форма № Т-6'");
	НастройкиВарианта.Включен = Ложь;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	ЗарплатаКадрыОтчетыРасширенный.ВывестиВКоллекциюПечатнуюФорму("Отчет.ПечатнаяФормаТ6",
		МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода, ВнешниеНаборыДанных(МассивОбъектов));
	
КонецПроцедуры

Процедура Сформировать(ДокументРезультат, РезультатКомпоновки, ОбъектыПечати = Неопределено) Экспорт
	
	КадровыйУчет.ВывестиНаПечатьТ6(
		ДокументРезультат,
		РезультатКомпоновки.ДанныеОтчета.Строки,
		РезультатКомпоновки.МакетПечатнойФормы,
		РезультатКомпоновки.ИдентификаторыМакета,
		ОбъектыПечати);
	
КонецПроцедуры

Функция ВнешниеНаборыДанных(МассивОбъектов = Неопределено) Экспорт
	
	ВнешниеНаборы = Новый Структура;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	
	Если МассивОбъектов = Неопределено Тогда
		Запрос.УстановитьПараметр("МассивОбъектов", Новый Массив);
	Иначе
		Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	КонецЕсли;
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Отпуск.Ссылка КАК СсылкаНаОбъект,
		|	Отпуск.Сотрудник КАК Сотрудник,
		|	ЗНАЧЕНИЕ(Справочник.ВидыОтпусков.Основной) КАК ВидОтпуска,
		|	Отпуск.ДатаНачалаОсновногоОтпуска КАК ДатаНачала,
		|	Отпуск.ДатаОкончанияОсновногоОтпуска КАК ДатаОкончания,
		|	ОтпускНачисления.ОплаченоДней КАК ОплаченоДней
		|ИЗ
		|	Документ.Отпуск КАК Отпуск
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Отпуск.Начисления КАК ОтпускНачисления
		|		ПО Отпуск.Ссылка = ОтпускНачисления.Ссылка
		|			И Отпуск.ВидРасчетаОсновногоОтпуска = ОтпускНачисления.Начисление
		|			И Отпуск.ДатаНачалаОсновногоОтпуска = ОтпускНачисления.ДатаНачала
		|			И Отпуск.ДатаОкончанияОсновногоОтпуска = ОтпускНачисления.ДатаОкончания
		|ГДЕ
		|	Отпуск.Ссылка В(&МассивОбъектов)
		|	И Отпуск.ПредоставитьОсновнойОтпуск
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ОтпускДополнительныеОтпуска.Ссылка,
		|	ОтпускДополнительныеОтпуска.Ссылка.Сотрудник,
		|	ОтпускДополнительныеОтпуска.ВидОтпуска,
		|	ОтпускДополнительныеОтпуска.ДатаНачала,
		|	ОтпускДополнительныеОтпуска.ДатаОкончания,
		|	ОтпускНачисления.ОплаченоДней
		|ИЗ
		|	Документ.Отпуск.ДополнительныеОтпуска КАК ОтпускДополнительныеОтпуска
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Отпуск.Начисления КАК ОтпускНачисления
		|		ПО ОтпускДополнительныеОтпуска.Ссылка = ОтпускНачисления.Ссылка
		|			И ОтпускДополнительныеОтпуска.ВидРасчета = ОтпускНачисления.Начисление
		|			И ОтпускДополнительныеОтпуска.ДатаНачала = ОтпускНачисления.ДатаНачала
		|			И ОтпускДополнительныеОтпуска.ДатаОкончания = ОтпускНачисления.ДатаОкончания
		|ГДЕ
		|	ОтпускДополнительныеОтпуска.Ссылка В(&МассивОбъектов)
		|	И ОтпускДополнительныеОтпуска.Ссылка.ПредоставитьДополнительныйОтпуск
		|	И ОтпускДополнительныеОтпуска.КоличествоДней > 0
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Отпуск.Ссылка,
		|	Отпуск.Сотрудник,
		|	ЗНАЧЕНИЕ(Справочник.ВидыОтпусков.Основной),
		|	Отпуск.ДатаНачалаОсновногоОтпуска,
		|	Отпуск.ДатаОкончанияОсновногоОтпуска,
		|	ОтпускНачисления.ОплаченоДней
		|ИЗ
		|	Документ.Отпуск КАК Отпуск
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Отпуск.Начисления КАК ОтпускНачисления
		|		ПО Отпуск.Ссылка = ОтпускНачисления.Ссылка
		|			И Отпуск.ВидРасчетаКомпенсацииОсновногоОтпуска = ОтпускНачисления.Начисление
		|			И (НАЧАЛОПЕРИОДА(Отпуск.ДатаНачалаОсновногоОтпуска, МЕСЯЦ) = ОтпускНачисления.ДатаНачала)
		|ГДЕ
		|	Отпуск.Ссылка В(&МассивОбъектов)
		|	И Отпуск.ПредоставитьКомпенсациюОсновногоОтпуска
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ОтпускДополнительныеОтпуска.Ссылка,
		|	ОтпускДополнительныеОтпуска.Ссылка.Сотрудник,
		|	ОтпускДополнительныеОтпуска.ВидОтпуска,
		|	ОтпускДополнительныеОтпуска.ДатаНачала,
		|	ОтпускДополнительныеОтпуска.ДатаОкончания,
		|	ОтпускНачисления.ОплаченоДней
		|ИЗ
		|	Документ.Отпуск.ДополнительныеОтпуска КАК ОтпускДополнительныеОтпуска
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Отпуск.Начисления КАК ОтпускНачисления
		|		ПО ОтпускДополнительныеОтпуска.Ссылка = ОтпускНачисления.Ссылка
		|			И ОтпускДополнительныеОтпуска.ВидРасчетаКомпенсации = ОтпускНачисления.Начисление
		|			И (НАЧАЛОПЕРИОДА(ОтпускДополнительныеОтпуска.ДатаНачала, МЕСЯЦ) = ОтпускНачисления.ДатаНачала)
		|ГДЕ
		|	ОтпускДополнительныеОтпуска.Ссылка В(&МассивОбъектов)
		|	И ОтпускДополнительныеОтпуска.Ссылка.ПредоставитьДополнительныйОтпуск
		|	И ОтпускДополнительныеОтпуска.КоличествоДнейКомпенсации > 0";
	
	ВнешниеНаборы.Вставить("ОплаченныеДниОтпусков", Запрос.Выполнить().Выгрузить());
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ВнешниеНаборы;
	
КонецФункции

#КонецОбласти

#КонецЕсли