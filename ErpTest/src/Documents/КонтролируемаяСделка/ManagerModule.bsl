#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Определяет список команд создания на основании.
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	
	
КонецПроцедуры

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица с командами отчетов. Для изменения.
//       См. описание 1 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуСтруктураПодчиненности(КомандыОтчетов);
	
	Возврат; //В дальнейшем будет добавлен код команд
	
КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции "УправлениеПечатью.СоздатьКоллекциюКомандПечати".
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

	// Акт об оказании услуг
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "КонтролируемаяСделка";
	КомандаПечати.Представление = НСтр("ru = 'Лист 1А'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	
КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Обработчик обновления УТ 11.4.3,
// заполняет коды ОКВЭД2 и ОКПД2 по кодам ОКВЭД и ОКП
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("КонвертацияОКП", Справочники.КлассификаторОКПД2.ТаблицаКонвертацииОКП_ОКПД2());
	Запрос.Параметры.Вставить("КонвертацияОКВЭД", Справочники.КлассификаторОКВЭД2.ТаблицаКонвертацииОКВЭД_ОКВЭД2());
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КонвертацияОКП.КодОКП,
	|	КонвертацияОКП.КодОКПД2
	|ПОМЕСТИТЬ КонвертацияОКП
	|ИЗ
	|	&КонвертацияОКП КАК КонвертацияОКП
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КонвертацияОКВЭД.КодОКВЭД,
	|	КонвертацияОКВЭД.КодОКВЭД2
	|ПОМЕСТИТЬ КонвертацияОКВЭД
	|ИЗ
	|	&КонвертацияОКВЭД КАК КонвертацияОКВЭД
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КонтролируемаяСделка.Ссылка
	|ИЗ
	|	КонвертацияОКП КАК КонвертацияОКП
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ОбщероссийскийКлассификаторПродукции КАК ОбщероссийскийКлассификаторПродукции
	|		ПО КонвертацияОКП.КодОКП = ОбщероссийскийКлассификаторПродукции.Код
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.КонтролируемаяСделка КАК КонтролируемаяСделка
	|		ПО (КонтролируемаяСделка.КодОКП = ОбщероссийскийКлассификаторПродукции.Ссылка)
	|ГДЕ
	|	КонтролируемаяСделка.УведомлениеОКонтролируемойСделке.ОтчетныйГод >= ДАТАВРЕМЯ(2017, 1, 1)
	|	И КонтролируемаяСделка.КодОКПД2 = ЗНАЧЕНИЕ(Справочник.КлассификаторОКПД2.ПустаяСсылка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	КонтролируемаяСделка.Ссылка
	|ИЗ
	|	КонвертацияОКВЭД КАК КонвертацияОКВЭД
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КлассификаторВидовЭкономическойДеятельности КАК КлассификаторВидовЭкономическойДеятельности
	|		ПО КонвертацияОКВЭД.КодОКВЭД = КлассификаторВидовЭкономическойДеятельности.Код
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.КонтролируемаяСделка КАК КонтролируемаяСделка
	|		ПО (КонтролируемаяСделка.КодОКВЭД = КлассификаторВидовЭкономическойДеятельности.Ссылка)
	|ГДЕ
	|	КонтролируемаяСделка.УведомлениеОКонтролируемойСделке.ОтчетныйГод >= ДАТАВРЕМЯ(2017, 1, 1)
	|	И КонтролируемаяСделка.КодОКВЭД2 = ЗНАЧЕНИЕ(Справочник.КлассификаторОКВЭД2.ПустаяСсылка)";
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
 	ПолноеИмяОбъекта = "Документ.КонтролируемаяСделка";
	МетаданныеДокумента = Метаданные.НайтиПоПолномуИмени(ПолноеИмяОбъекта);
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Результат = ОбновлениеИнформационнойБазы.СоздатьВременнуюТаблицуСсылокДляОбработки(Параметры.Очередь, ПолноеИмяОбъекта, МенеджерВременныхТаблиц);
	
	Если НЕ Результат.ЕстьДанныеДляОбработки Тогда
		Параметры.ОбработкаЗавершена = Истина;
		Возврат;
	КонецЕсли;
	Если НЕ Результат.ЕстьЗаписиВоВременнойТаблице Тогда
		Параметры.ОбработкаЗавершена = Ложь;
		Возврат;
	КонецЕсли; 
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Параметры.Вставить("КонвертацияОКП", Справочники.КлассификаторОКПД2.ТаблицаКонвертацииОКП_ОКПД2());
	Запрос.Параметры.Вставить("КонвертацияОКВЭД", Справочники.КлассификаторОКВЭД2.ТаблицаКонвертацииОКВЭД_ОКВЭД2());
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КонвертацияОКП.КодОКП,
	|	КонвертацияОКП.КодОКПД2
	|ПОМЕСТИТЬ КонвертацияОКП
	|ИЗ
	|	&КонвертацияОКП КАК КонвертацияОКП
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КонвертацияОКВЭД.КодОКВЭД,
	|	КонвертацияОКВЭД.КодОКВЭД2
	|ПОМЕСТИТЬ КонвертацияОКВЭД
	|ИЗ
	|	&КонвертацияОКВЭД КАК КонвертацияОКВЭД
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВложенныйЗапрос.Ссылка,
	|	ВложенныйЗапрос.ВерсияДанных,
	|	МАКСИМУМ(ВложенныйЗапрос.КодОКПД2) КАК КодОКПД2,
	|	МАКСИМУМ(ВложенныйЗапрос.КодОКВЭД2) КАК КодОКВЭД2
	|ИЗ
	|	(ВЫБРАТЬ
	|		КонтролируемаяСделка.Ссылка КАК Ссылка,
	|		КонтролируемаяСделка.ВерсияДанных КАК ВерсияДанных,
	|		КлассификаторОКПД2.Ссылка КАК КодОКПД2,
	|		NULL КАК КодОКВЭД2
	|	ИЗ
	|		ВТДляОбработкиКонтролируемаяСделка КАК ВТОбъектыДляОбработки
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.КонтролируемаяСделка КАК КонтролируемаяСделка
	|			ПО ВТОбъектыДляОбработки.Ссылка = КонтролируемаяСделка.Ссылка
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ КонвертацияОКП КАК КонвертацияОКП
	|			ПО (КонвертацияОКП.КодОКП = КонтролируемаяСделка.КодОКП.Код)
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КлассификаторОКПД2 КАК КлассификаторОКПД2
	|			ПО (КонвертацияОКП.КодОКПД2 = КлассификаторОКПД2.Код)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		КонтролируемаяСделка.Ссылка,
	|		КонтролируемаяСделка.ВерсияДанных,
	|		NULL,
	|		КлассификаторОКВЭД2.Ссылка
	|	ИЗ
	|		ВТДляОбработкиКонтролируемаяСделка КАК ВТОбъектыДляОбработки
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.КонтролируемаяСделка КАК КонтролируемаяСделка
	|			ПО ВТОбъектыДляОбработки.Ссылка = КонтролируемаяСделка.Ссылка
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ КонвертацияОКВЭД КАК КонвертацияОКВЭД
	|			ПО (КонвертацияОКВЭД.КодОКВЭД = КонтролируемаяСделка.КодОКВЭД.Код)
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КлассификаторОКВЭД2 КАК КлассификаторОКВЭД2
	|			ПО (КонвертацияОКВЭД.КодОКВЭД2 = КлассификаторОКВЭД2.Код)
	|	) КАК ВложенныйЗапрос
	|
	|СГРУППИРОВАТЬ ПО
	|	ВложенныйЗапрос.Ссылка,
	|	ВложенныйЗапрос.ВерсияДанных";
	
	НачатьТранзакцию();
		
	Попытка
		
		Блокировка = Новый БлокировкаДанных;
		
		ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяОбъекта);
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		
		ЭлементБлокировки = Блокировка.Добавить("Справочник.ОбщероссийскийКлассификаторПродукции");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
		
		ЭлементБлокировки = Блокировка.Добавить("Справочник.КлассификаторВидовЭкономическойДеятельности");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
		
		ЭлементБлокировки = Блокировка.Добавить("Справочник.КлассификаторОКПД2");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
		
		ЭлементБлокировки = Блокировка.Добавить("Справочник.КлассификаторОКВЭД2");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
		
		Блокировка.Заблокировать();
		
	Исключение
		
		ОтменитьТранзакцию();
		ТекстСообщения = НСтр("ru = 'Не удалось заблокировать данные для обработки контролируемых сделок по причине: %Причина%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
								УровеньЖурналаРегистрации.Предупреждение,
								МетаданныеДокумента,
								,
								ТекстСообщения);
		
		Параметры.ОбработкаЗавершена = Ложь;
		Возврат;
	КонецПопытки;
		
	Попытка
		Результат = Запрос.Выполнить();
		Если Результат.Пустой() Тогда
			ОтменитьТранзакцию();
			Параметры.ОбработкаЗавершена = Ложь;
			Возврат;
		КонецЕсли;
		
		Выборка = Результат.Выбрать();
	
		Пока Выборка.Следующий() Цикл
			СправочникОбъект = ОбновлениеИнформационнойБазыУТ.ПроверитьПолучитьОбъект(Выборка.Ссылка, Выборка.ВерсияДанных, Параметры.Очередь);
			Если СправочникОбъект = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			Если ЗначениеЗаполнено(Выборка.КодОКВЭД2) Тогда
				СправочникОбъект.КодОКВЭД2 = Выборка.КодОКВЭД2;
			КонецЕсли;
			Если ЗначениеЗаполнено(Выборка.КодОКПД2) Тогда
				СправочникОбъект.КодОКПД2 = Выборка.КодОКПД2;
			КонецЕсли;
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(СправочникОбъект, Истина);
		КонецЦикла;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ТекстСообщения = НСтр("ru = 'Не удалось обработать контролируемые сделки по причине: %Причина%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Предупреждение,
			МетаданныеДокумента,
			,
			ТекстСообщения);
		ВызватьИсключение;
	КонецПопытки;
	
	Параметры.ОбработкаЗавершена = Не ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяОбъекта);
	
КонецПроцедуры

// Добавляет команду создания документа "Лист 1А".
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	Если ПравоДоступа("Добавление", Метаданные.Документы.КонтролируемаяСделка) Тогда
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.КонтролируемаяСделка.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(Метаданные.Документы.КонтролируемаяСделка);
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		КомандаСоздатьНаОсновании.ФункциональныеОпции = "ИспользоватьУведомленияОКонтролируемыхСделках";
	

		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;

	Возврат Неопределено;
КонецФункции

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "КонтролируемаяСделка") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "КонтролируемаяСделка", НСтр("ru = 'Контролируемая сделка'"), 
			КонтролируемыеСделки.ПечатьКонтролируемыхСделок(МассивОбъектов, ОбъектыПечати));
	КонецЕсли;
	
	ОбщегоНазначенияБП.ЗаполнитьДополнительныеПараметрыПечати(МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);	

КонецПроцедуры

#КонецОбласти

#КонецЕсли
