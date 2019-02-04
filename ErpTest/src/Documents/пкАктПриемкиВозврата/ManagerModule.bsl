#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#Область СозданиеНаОсновании

// Заполняет список команд создания на основании.
// 
// Параметры:
//   КомандыСоздатьНаОсновании - ТаблицаЗначений - состав полей см. в функции ВводНаОсновании.СоздатьКоллекциюКомандСоздатьНаОсновании
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСоздатьНаОсновании, НастройкиФорм) Экспорт
	
	Документы.пкАктПриемкиВозврата.ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании);
	СозданиеНаОснованииПереопределяемый.ДобавитьКомандуСоздатьНаОснованииБизнесПроцессЗадание(КомандыСоздатьНаОсновании);
	
КонецПроцедуры

// Заполняет список команд создания на основании.
// 
// Параметры:
//   КомандыСоздатьНаОсновании - ТаблицаЗначений - состав полей см. в функции ВводНаОсновании.СоздатьКоллекциюКомандСоздатьНаОсновании
//
// Возвращаемое значение:
//	 КомандыСоздатьНаОсновании - ТаблицаЗначений - состав полей см. в функции ВводНаОсновании.СоздатьКоллекциюКомандСоздатьНаОсновании
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании) Экспорт

	 
	//Если ПравоДоступа("Добавление", Метаданные.Документы.уатПутевойЛист) Тогда
	//	КомандаСоздатьНаОсновании = КомандыСоздатьНаОсновании.Добавить();
	//	КомандаСоздатьНаОсновании.Идентификатор = Метаданные.Документы.уатПутевойЛист.ПолноеИмя();
	//	КомандаСоздатьНаОсновании.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(Метаданные.Документы.уатПутевойЛист);
	//	//КомандаСоздатьНаОсновании.ПроверкаПроведенияПередСозданиемНаОсновании = Истина;
	//	
	//	Возврат КомандаСоздатьНаОсновании;
	//КонецЕсли;

	//Возврат Неопределено;
КонецФункции

#КонецОбласти 
#КонецОбласти 

// Определяет реквизиты выбранного документа
//
// Параметры:
//	ДокументСсылка - Ссылка на документа
//
// Возвращаемое значение:
//	Структура - реквизиты выбранного документа
//
Функция РеквизитыДокумента(ДокументСсылка) Экспорт
	
	СтруктураРеквизитов = Новый Структура();
	
	Возврат СтруктураРеквизитов;

КонецФункции

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаОбъекта" Тогда
		Если ОбщегоНазначенияУТКлиентСервер.АвторизованВнешнийПользователь() Тогда
			СтандартнаяОбработка = Ложь;
			//ВыбраннаяФорма = "ФормаДокументаСамообслуживание";
		КонецЕсли;
	ИначеЕсли ВидФормы = "ФормаСписка" Тогда
		Если ОбщегоНазначенияУТКлиентСервер.АвторизованВнешнийПользователь() Тогда
			СтандартнаяОбработка = Ложь;
			//ВыбраннаяФорма = "ФормаСпискаСамообслуживание";
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область Проведение
#КонецОбласти

#Область Отчеты

// Заполняет список команд отчетов.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Настройки) Экспорт

	ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуСтруктураПодчиненности(КомандыОтчетов);
	
КонецПроцедуры

#КонецОбласти 

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

	//Акт приемки/возврата для печати на А4 (2016)
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Обработка.пкПечатьЛогистика";
	КомандаПечати.Идентификатор = "Доставка_АктПриемкиВовзвратаА4";
	КомандаПечати.Представление = НСтр("ru = 'Акт приемки/возврата для печати на А4 (2016)'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.Порядок = 13;
	
	//Акт приемки/возврата для печати на А4
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Обработка.пкПечатьЛогистика";
	КомандаПечати.Идентификатор = "Доставка_АктПриемкиВовзвратаА42017";
	КомандаПечати.Представление = НСтр("ru = 'Акт приемки/возврата для печати на А4'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.Порядок = 14;
	
	////Акт приемки/возврата для печати на А4 для Москвы
	//КомандаПечати = КомандыПечати.Добавить();
	//КомандаПечати.МенеджерПечати = "Обработка.пкПечатьЛогистика";
	//КомандаПечати.Идентификатор = "Доставка_АктПриемкиВовзвратаА4Москва";
	//КомандаПечати.Представление = НСтр("ru = 'Акт приемки/возврата для печати на А4 для Москвы'");
	//КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	//КомандаПечати.Порядок = 14;
	
	//Акт приемки/возврата для печати на А5 (2016)
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Обработка.пкПечатьЛогистика";
	КомандаПечати.Идентификатор = "Доставка_АктПриемкиВовзвратаА5";
	КомандаПечати.Представление = НСтр("ru = 'Акт приемки/возврата для печати на А5 (2016)'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.Порядок = 15;
	
	//Акт приемки/возврата для печати на А5
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Обработка.пкПечатьЛогистика";
	КомандаПечати.Идентификатор = "Доставка_АктПриемкиВовзвратаА52017";
	КомандаПечати.Представление = НСтр("ru = 'Акт приемки/возврата для печати на А5'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.Порядок = 16;
	
	////Акт приемки/возврата для печати на А5 для Москвы
	//КомандаПечати = КомандыПечати.Добавить();
	//КомандаПечати.МенеджерПечати = "Обработка.пкПечатьЛогистика";
	//КомандаПечати.Идентификатор = "Доставка_АктПриемкиВовзвратаА5Москва";
	//КомандаПечати.Представление = НСтр("ru = 'Акт приемки/возврата для печати на А5 для Москвы'");
	//КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	//КомандаПечати.Порядок = 16;
	
	//Доверенность
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Обработка.пкПечатьЛогистика";
	КомандаПечати.Идентификатор = "Доставка_Доверенность";
	КомандаПечати.Представление = НСтр("ru = 'Доверенность'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.Порядок = 17;
	
	//ТН (форма 1208)
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Обработка.пкПечатьЛогистика";
	КомандаПечати.Идентификатор = "Доставка_ТТН";
	КомандаПечати.Представление = НСтр("ru = 'ТН (форма 1208)'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.Порядок = 18;
	
КонецПроцедуры

// Сформировать печатные формы объектов
//
// ВХОДЯЩИЕ:
//   ИменаМакетов    - Строка    - Имена макетов, перечисленные через запятую
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать
//   ПараметрыПечати - Структура - Структура дополнительных параметров печати
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "КомплектДокументов") Тогда
		КоллекцияПечатныхФорм.Очистить();
		СформироватьКомплектПечатныхФорм(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати);
	КонецЕсли;
	
	ФормированиеПечатныхФорм.ЗаполнитьПараметрыОтправки(ПараметрыВывода.ПараметрыОтправки, МассивОбъектов, КоллекцияПечатныхФорм);
	
КонецПроцедуры

Функция СформироватьКомплектПечатныхФорм(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати) Экспорт
	
	Перем АдресКомплектаПечатныхФорм;
	
	Если ТипЗнч(ПараметрыПечати) = Тип("Структура") И ПараметрыПечати.Свойство("АдресКомплектаПечатныхФорм", АдресКомплектаПечатныхФорм) Тогда
		
		КомплектПечатныхФорм = ПолучитьИзВременногоХранилища(АдресКомплектаПечатныхФорм);
		
	Иначе
		
		КомплектПечатныхФорм = РегистрыСведений.НастройкиПечатиОбъектов.КомплектПечатныхФорм(
			Метаданные.Документы.пкАктПриемкиВозврата.ПолноеИмя(),
			МассивОбъектов, Неопределено);
		
	КонецЕсли;
		
	Если КомплектПечатныхФорм = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	СтруктураТипов = Новый Соответствие;
	СтруктураТипов.Вставить("Документ.пкАктПриемкиВозврата", МассивОбъектов);
	
	////Акт приемки/возврата для печати на А4 (2016)
	ИмяМакета = "Доставка_АктПриемкиВовзвратаА4";
	ТекущийКомплект = КомплектПечатныхФорм.Скопировать(Новый Структура("Имя,Печатать,",ИмяМакета,Истина));
	Если ТекущийКомплект.Количество() > 0 Тогда
		Если ТекущийКомплект.Колонки.Найти("Ссылка") <> Неопределено И ЗначениеЗаполнено(ТекущийКомплект[0].Ссылка) Тогда
			РегистрыСведений.НастройкиПечатиОбъектов.СкопироватьПечатнуюФормуВКоллекциюОдинЭкземпляр(КоллекцияПечатныхФорм, ИмяМакета);
			ТаблицаСсылок = ТекущийКомплект.Скопировать(,"Ссылка");
			ТаблицаСсылок.Свернуть("Ссылка");
			ТекущаяСтруктураТипов = Новый Соответствие;
			ТекущаяСтруктураТипов.Вставить("Документ.пкАктПриемкиВозврата", ТаблицаСсылок.ВыгрузитьКолонку("Ссылка"));
		Иначе
			РегистрыСведений.НастройкиПечатиОбъектов.СкопироватьПечатнуюФормуВКоллекцию(КоллекцияПечатныхФорм, ТекущийКомплект[0]);
			ТекущаяСтруктураТипов = СтруктураТипов;
		КонецЕсли;
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			ИмяМакета,
			ТекущийКомплект[0].Представление,
			Обработки.пкПечатьЛогистика.СформироватьПечатнуюФормуДоставка_АктПриемкиВовзвратаА4(ТекущаяСтруктураТипов, ОбъектыПечати, Новый Структура, ТекущийКомплект));

	КонецЕсли;
	
	////Акт приемки/возврата для печати на А4
	ИмяМакета = "Доставка_АктПриемкиВовзвратаА42017";
	ТекущийКомплект = КомплектПечатныхФорм.Скопировать(Новый Структура("Имя,Печатать,",ИмяМакета,Истина));
	Если ТекущийКомплект.Количество() > 0 Тогда
		Если ТекущийКомплект.Колонки.Найти("Ссылка") <> Неопределено И ЗначениеЗаполнено(ТекущийКомплект[0].Ссылка) Тогда
			РегистрыСведений.НастройкиПечатиОбъектов.СкопироватьПечатнуюФормуВКоллекциюОдинЭкземпляр(КоллекцияПечатныхФорм, ИмяМакета);
			ТаблицаСсылок = ТекущийКомплект.Скопировать(,"Ссылка");
			ТаблицаСсылок.Свернуть("Ссылка");
			ТекущаяСтруктураТипов = Новый Соответствие;
			ТекущаяСтруктураТипов.Вставить("Документ.пкАктПриемкиВозврата", ТаблицаСсылок.ВыгрузитьКолонку("Ссылка"));
		Иначе
			РегистрыСведений.НастройкиПечатиОбъектов.СкопироватьПечатнуюФормуВКоллекцию(КоллекцияПечатныхФорм, ТекущийКомплект[0]);
			ТекущаяСтруктураТипов = СтруктураТипов;
		КонецЕсли;
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			ИмяМакета,
			ТекущийКомплект[0].Представление,
			Обработки.пкПечатьЛогистика.СформироватьПечатнуюФормуДоставка_АктПриемкиВовзвратаА42017(ТекущаяСтруктураТипов, ОбъектыПечати, Новый Структура, ТекущийКомплект));

	КонецЕсли;
	
	////Акт приемки/возврата для печати на А4 для Москвы
	ИмяМакета = "Доставка_АктПриемкиВовзвратаА4Москва";
	ТекущийКомплект = КомплектПечатныхФорм.Скопировать(Новый Структура("Имя,Печатать,",ИмяМакета,Истина));
	Если ТекущийКомплект.Количество() > 0 Тогда
		Если ТекущийКомплект.Колонки.Найти("Ссылка") <> Неопределено И ЗначениеЗаполнено(ТекущийКомплект[0].Ссылка) Тогда
			РегистрыСведений.НастройкиПечатиОбъектов.СкопироватьПечатнуюФормуВКоллекциюОдинЭкземпляр(КоллекцияПечатныхФорм, ИмяМакета);
			ТаблицаСсылок = ТекущийКомплект.Скопировать(,"Ссылка");
			ТаблицаСсылок.Свернуть("Ссылка");
			ТекущаяСтруктураТипов = Новый Соответствие;
			ТекущаяСтруктураТипов.Вставить("Документ.пкАктПриемкиВозврата", ТаблицаСсылок.ВыгрузитьКолонку("Ссылка"));
		Иначе
			РегистрыСведений.НастройкиПечатиОбъектов.СкопироватьПечатнуюФормуВКоллекцию(КоллекцияПечатныхФорм, ТекущийКомплект[0]);
			ТекущаяСтруктураТипов = СтруктураТипов;
		КонецЕсли;
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			ИмяМакета,
			ТекущийКомплект[0].Представление,
			Обработки.пкПечатьЛогистика.СформироватьПечатнуюФормуДоставка_АктПриемкиВовзвратаА4Москва(ТекущаяСтруктураТипов, ОбъектыПечати, Новый Структура, ТекущийКомплект));

	КонецЕсли;
	
	////Акт приемки/возврата для печати на А5 (2016)
	ИмяМакета = "Доставка_АктПриемкиВовзвратаА5";
	ТекущийКомплект = КомплектПечатныхФорм.Скопировать(Новый Структура("Имя,Печатать,",ИмяМакета,Истина));
	Если ТекущийКомплект.Количество() > 0 Тогда
		Если ТекущийКомплект.Колонки.Найти("Ссылка") <> Неопределено И ЗначениеЗаполнено(ТекущийКомплект[0].Ссылка) Тогда
			РегистрыСведений.НастройкиПечатиОбъектов.СкопироватьПечатнуюФормуВКоллекциюОдинЭкземпляр(КоллекцияПечатныхФорм, ИмяМакета);
			ТаблицаСсылок = ТекущийКомплект.Скопировать(,"Ссылка");
			ТаблицаСсылок.Свернуть("Ссылка");
			ТекущаяСтруктураТипов = Новый Соответствие;
			ТекущаяСтруктураТипов.Вставить("Документ.пкАктПриемкиВозврата", ТаблицаСсылок.ВыгрузитьКолонку("Ссылка"));
		Иначе
			РегистрыСведений.НастройкиПечатиОбъектов.СкопироватьПечатнуюФормуВКоллекцию(КоллекцияПечатныхФорм, ТекущийКомплект[0]);
			ТекущаяСтруктураТипов = СтруктураТипов;
		КонецЕсли;
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			ИмяМакета,
			ТекущийКомплект[0].Представление,
			Обработки.пкПечатьЛогистика.СформироватьПечатнуюФормуДоставка_АктПриемкиВовзвратаА5(ТекущаяСтруктураТипов, ОбъектыПечати, Новый Структура, ТекущийКомплект));

	КонецЕсли;
	
	////Акт приемки/возврата для печати на А5
	ИмяМакета = "Доставка_АктПриемкиВовзвратаА52017";
	ТекущийКомплект = КомплектПечатныхФорм.Скопировать(Новый Структура("Имя,Печатать,",ИмяМакета,Истина));
	Если ТекущийКомплект.Количество() > 0 Тогда
		Если ТекущийКомплект.Колонки.Найти("Ссылка") <> Неопределено И ЗначениеЗаполнено(ТекущийКомплект[0].Ссылка) Тогда
			РегистрыСведений.НастройкиПечатиОбъектов.СкопироватьПечатнуюФормуВКоллекциюОдинЭкземпляр(КоллекцияПечатныхФорм, ИмяМакета);
			ТаблицаСсылок = ТекущийКомплект.Скопировать(,"Ссылка");
			ТаблицаСсылок.Свернуть("Ссылка");
			ТекущаяСтруктураТипов = Новый Соответствие;
			ТекущаяСтруктураТипов.Вставить("Документ.пкАктПриемкиВозврата", ТаблицаСсылок.ВыгрузитьКолонку("Ссылка"));
		Иначе
			РегистрыСведений.НастройкиПечатиОбъектов.СкопироватьПечатнуюФормуВКоллекцию(КоллекцияПечатныхФорм, ТекущийКомплект[0]);
			ТекущаяСтруктураТипов = СтруктураТипов;
		КонецЕсли;
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			ИмяМакета,
			ТекущийКомплект[0].Представление,
			Обработки.пкПечатьЛогистика.СформироватьПечатнуюФормуДоставка_АктПриемкиВовзвратаА52017(ТекущаяСтруктураТипов, ОбъектыПечати, Новый Структура, ТекущийКомплект));

	КонецЕсли;
	
	////Акт приемки/возврата для печати на А5 для Москвы
	ИмяМакета = "Доставка_АктПриемкиВовзвратаА5Москва";
	ТекущийКомплект = КомплектПечатныхФорм.Скопировать(Новый Структура("Имя,Печатать,",ИмяМакета,Истина));
	Если ТекущийКомплект.Количество() > 0 Тогда
		Если ТекущийКомплект.Колонки.Найти("Ссылка") <> Неопределено И ЗначениеЗаполнено(ТекущийКомплект[0].Ссылка) Тогда
			РегистрыСведений.НастройкиПечатиОбъектов.СкопироватьПечатнуюФормуВКоллекциюОдинЭкземпляр(КоллекцияПечатныхФорм, ИмяМакета);
			ТаблицаСсылок = ТекущийКомплект.Скопировать(,"Ссылка");
			ТаблицаСсылок.Свернуть("Ссылка");
			ТекущаяСтруктураТипов = Новый Соответствие;
			ТекущаяСтруктураТипов.Вставить("Документ.пкАктПриемкиВозврата", ТаблицаСсылок.ВыгрузитьКолонку("Ссылка"));
		Иначе
			РегистрыСведений.НастройкиПечатиОбъектов.СкопироватьПечатнуюФормуВКоллекцию(КоллекцияПечатныхФорм, ТекущийКомплект[0]);
			ТекущаяСтруктураТипов = СтруктураТипов;
		КонецЕсли;
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			ИмяМакета,
			ТекущийКомплект[0].Представление,
			Обработки.пкПечатьЛогистика.СформироватьПечатнуюФормуДоставка_АктПриемкиВовзвратаА5Москва(ТекущаяСтруктураТипов, ОбъектыПечати, Новый Структура, ТекущийКомплект));

	КонецЕсли;
	
	////Доверенность
	ИмяМакета = "Доставка_Доверенность";
	ТекущийКомплект = КомплектПечатныхФорм.Скопировать(Новый Структура("Имя,Печатать,",ИмяМакета,Истина));
	Если ТекущийКомплект.Количество() > 0 Тогда
		Если ТекущийКомплект.Колонки.Найти("Ссылка") <> Неопределено И ЗначениеЗаполнено(ТекущийКомплект[0].Ссылка) Тогда
			РегистрыСведений.НастройкиПечатиОбъектов.СкопироватьПечатнуюФормуВКоллекциюОдинЭкземпляр(КоллекцияПечатныхФорм, ИмяМакета);
			ТаблицаСсылок = ТекущийКомплект.Скопировать(,"Ссылка");
			ТаблицаСсылок.Свернуть("Ссылка");
			ТекущаяСтруктураТипов = Новый Соответствие;
			ТекущаяСтруктураТипов.Вставить("Документ.пкАктПриемкиВозврата", ТаблицаСсылок.ВыгрузитьКолонку("Ссылка"));
		Иначе
			РегистрыСведений.НастройкиПечатиОбъектов.СкопироватьПечатнуюФормуВКоллекцию(КоллекцияПечатныхФорм, ТекущийКомплект[0]);
			ТекущаяСтруктураТипов = СтруктураТипов;
		КонецЕсли;
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			ИмяМакета,
			ТекущийКомплект[0].Представление,
			Обработки.пкПечатьЛогистика.СформироватьПечатнуюФормуДоставка_Доверенность(ТекущаяСтруктураТипов, ОбъектыПечати, Новый Структура, ТекущийКомплект));

	КонецЕсли;
	
	//ТН (форма 1208)
	ИмяМакета = "Доставка_ТТН";
	ТекущийКомплект = КомплектПечатныхФорм.Скопировать(Новый Структура("Имя,Печатать,",ИмяМакета,Истина));
	Если ТекущийКомплект.Количество() > 0 Тогда
		Если ТекущийКомплект.Колонки.Найти("Ссылка") <> Неопределено И ЗначениеЗаполнено(ТекущийКомплект[0].Ссылка) Тогда
			РегистрыСведений.НастройкиПечатиОбъектов.СкопироватьПечатнуюФормуВКоллекциюОдинЭкземпляр(КоллекцияПечатныхФорм, ИмяМакета);
			ТаблицаСсылок = ТекущийКомплект.Скопировать(,"Ссылка");
			ТаблицаСсылок.Свернуть("Ссылка");
			ТекущаяСтруктураТипов = Новый Соответствие;
			ТекущаяСтруктураТипов.Вставить("Документ.пкАктПриемкиВозврата", ТаблицаСсылок.ВыгрузитьКолонку("Ссылка"));
		Иначе
			РегистрыСведений.НастройкиПечатиОбъектов.СкопироватьПечатнуюФормуВКоллекцию(КоллекцияПечатныхФорм, ТекущийКомплект[0]);
			ТекущаяСтруктураТипов = СтруктураТипов;
		КонецЕсли;
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			ИмяМакета,
			ТекущийКомплект[0].Представление,
			Обработки.пкПечатьЛогистика.СформироватьПечатнуюФормуДоставка_ТТН(ТекущаяСтруктураТипов, ОбъектыПечати, Новый Структура, ТекущийКомплект));

	КонецЕсли;
	
	РегистрыСведений.НастройкиПечатиОбъектов.СформироватьКомплектВнешнихПечатныхФорм(
		"Документ.пкАктПриемкиВозврата",
		МассивОбъектов,
		ПараметрыПечати,
		КоллекцияПечатныхФорм,
		ОбъектыПечати);
	
КонецФункции

Функция КомплектПечатныхФорм() Экспорт
	
	КомплектПечатныхФорм = РегистрыСведений.НастройкиПечатиОбъектов.ПодготовитьКомплектПечатныхФорм();
	
	//Акт приемки/возврата для печати на А4 (2016)
	РегистрыСведений.НастройкиПечатиОбъектов.ДобавитьПечатнуюФормуВКомплект(КомплектПечатныхФорм, "Доставка_АктПриемкиВовзвратаА4", НСтр("ru = 'Акт приемки/возврата для печати на А4 (2016)'"), 0);
	//Акт приемки/возврата для печати на А4
	РегистрыСведений.НастройкиПечатиОбъектов.ДобавитьПечатнуюФормуВКомплект(КомплектПечатныхФорм, "Доставка_АктПриемкиВовзвратаА42017", НСтр("ru = 'Акт приемки/возврата для печати на А4'"), 0);
	////Акт приемки/возврата для печати на А4 для Москвы
	//РегистрыСведений.НастройкиПечатиОбъектов.ДобавитьПечатнуюФормуВКомплект(КомплектПечатныхФорм, "Доставка_АктПриемкиВовзвратаА4Москва", НСтр("ru = 'Акт приемки/возврата для печати на А4 для Москвы'"), 0);
	//Акт приемки/возврата для печати на А5 (2016)
	РегистрыСведений.НастройкиПечатиОбъектов.ДобавитьПечатнуюФормуВКомплект(КомплектПечатныхФорм, "Доставка_АктПриемкиВовзвратаА5", НСтр("ru = 'Акт приемки/возврата для печати на А5 (2016)'"), 0);
	//Акт приемки/возврата для печати на А5
	РегистрыСведений.НастройкиПечатиОбъектов.ДобавитьПечатнуюФормуВКомплект(КомплектПечатныхФорм, "Доставка_АктПриемкиВовзвратаА52017", НСтр("ru = 'Акт приемки/возврата для печати на А5'"), 0);
	////Акт приемки/возврата для печати на А5 для Москвы
	//РегистрыСведений.НастройкиПечатиОбъектов.ДобавитьПечатнуюФормуВКомплект(КомплектПечатныхФорм, "Доставка_АктПриемкиВовзвратаА5Москва", НСтр("ru = 'Акт приемки/возврата для печати на А5 для Москвы'"), 0);
	//Доверенность
	РегистрыСведений.НастройкиПечатиОбъектов.ДобавитьПечатнуюФормуВКомплект(КомплектПечатныхФорм, "Доставка_Доверенность", НСтр("ru = 'Доверенность'"), 0);
	//ТН (форма 1208)
	РегистрыСведений.НастройкиПечатиОбъектов.ДобавитьПечатнуюФормуВКомплект(КомплектПечатныхФорм, "Доставка_ТТН", НСтр("ru = 'ТН (форма 1208)'"), 0);
	
	Возврат КомплектПечатныхФорм;
	
КонецФункции

Процедура ЗаполнитьСтруктуруПолучателейПечатныхФорм(СтруктураДанныхОбъектаПечати) Экспорт
	
	
КонецПроцедуры

Функция ДоступныеДляШаблоновПечатныеФормы() Экспорт

	МассивДоступныхПечатныхФорм = Новый Массив;
	ШаблоныСообщенийСервер.ДобавитьВМассивПечатныеФормыСчета(МассивДоступныхПечатныхФорм);
	
	Возврат МассивДоступныхПечатныхФорм

КонецФункции

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

Функция ПолноеИмяОбъекта()
	
	Возврат "Документ.пкАктПриемкиВозврата";
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
