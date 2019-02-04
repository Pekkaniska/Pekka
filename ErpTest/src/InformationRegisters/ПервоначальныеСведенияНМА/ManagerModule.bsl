#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

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
	
#Область ОбновлениеИнформационнойБазы

// Обработчик обновления КА
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоДвижения = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра = Метаданные.РегистрыСведений.ПервоначальныеСведенияНМА.ПолноеИмя();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Данные.Регистратор КАК Ссылка
	|ИЗ
	|	РегистрСведений.ПервоначальныеСведенияНМА КАК Данные
	|ГДЕ
	|	Данные.ПорядокУчетаНУ = ЗНАЧЕНИЕ(Перечисление.ПорядокУчетаСтоимостиВнеоборотныхАктивов.ПустаяСсылка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Данные.Ссылка
	|ИЗ
	|	Документ.ВводОстатковВнеоборотныхАктивов2_4.НМА КАК Данные
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПервоначальныеСведенияНМА КАК ПервоначальныеСведенияНМА
	|		ПО Данные.Ссылка = ПервоначальныеСведенияНМА.Регистратор
	|			И Данные.Ссылка.Организация = ПервоначальныеСведенияНМА.Организация
	|ГДЕ
	|	Данные.Ссылка.Проведен
	|	И ПервоначальныеСведенияНМА.Организация ЕСТЬ NULL
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Данные.Ссылка
	|ИЗ
	|	Документ.ПеремещениеНМА2_4.НМА КАК Данные
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПервоначальныеСведенияНМА КАК ПервоначальныеСведенияНМА
	|		ПО Данные.Ссылка = ПервоначальныеСведенияНМА.Регистратор
	|			И Данные.Ссылка.Организация = ПервоначальныеСведенияНМА.Организация
	|ГДЕ
	|	Данные.Ссылка.Проведен
	|	И ПервоначальныеСведенияНМА.Организация ЕСТЬ NULL
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Данные.Ссылка
	|ИЗ
	|	Документ.ПереоценкаНМА2_4.НМА КАК Данные
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПервоначальныеСведенияНМА КАК ПервоначальныеСведенияНМА
	|		ПО Данные.Ссылка = ПервоначальныеСведенияНМА.Регистратор
	|			И Данные.Ссылка.Организация = ПервоначальныеСведенияНМА.Организация
	|ГДЕ
	|	Данные.Ссылка.Проведен
	|	И ПервоначальныеСведенияНМА.Организация ЕСТЬ NULL
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Данные.Ссылка
	|ИЗ
	|	Документ.ПодготовкаКПередачеНМА2_4.НМА КАК Данные
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПервоначальныеСведенияНМА КАК ПервоначальныеСведенияНМА
	|		ПО Данные.Ссылка = ПервоначальныеСведенияНМА.Регистратор
	|			И Данные.Ссылка.Организация = ПервоначальныеСведенияНМА.Организация
	|ГДЕ
	|	Данные.Ссылка.Проведен
	|	И ПервоначальныеСведенияНМА.Организация ЕСТЬ NULL
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Данные.Ссылка
	|ИЗ
	|	Документ.ПринятиеКУчетуНМА2_4 КАК Данные
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПервоначальныеСведенияНМА КАК ПервоначальныеСведенияНМА
	|		ПО Данные.Ссылка = ПервоначальныеСведенияНМА.Регистратор
	|			И Данные.Организация = ПервоначальныеСведенияНМА.Организация
	|ГДЕ
	|	Данные.Проведен
	|	И ПервоначальныеСведенияНМА.Организация ЕСТЬ NULL
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Данные.Ссылка
	|ИЗ
	|	Документ.СписаниеНМА2_4.НМА КАК Данные
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПервоначальныеСведенияНМА КАК ПервоначальныеСведенияНМА
	|		ПО Данные.Ссылка = ПервоначальныеСведенияНМА.Регистратор
	|			И Данные.Ссылка.Организация = ПервоначальныеСведенияНМА.Организация
	|ГДЕ
	|	Данные.Ссылка.Проведен
	|	И ПервоначальныеСведенияНМА.Организация ЕСТЬ NULL
	|";
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"), ДополнительныеПараметры);
	
КонецПроцедуры

// Обработчик обновления КА
// Производится заполнение нового ресурса "ПорядокУчетаНУ".
//
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	                                                                          
	МетаданныеРегистра = Метаданные.РегистрыСведений.ПервоначальныеСведенияНМА;
	ПолноеИмяРегистра = МетаданныеРегистра.ПолноеИмя();
	ПараметрыРезультата = ДанныеДляЗаполненияРегистра(Параметры.Очередь, ПолноеИмяРегистра);
		
	Если НЕ ПараметрыРезультата.ЕстьЗаписиВоВременныхТаблицах Тогда
		Параметры.ОбработкаЗавершена = Истина;
		Возврат;
	КонецЕсли;
	
	#Область ЗаполнениеРеквизита
	
	Результат = ПараметрыРезультата.ДанныеДляЗаполненияРеквизита;
	ВыборкаРегистраторов = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаРегистраторов.Следующий() Цикл
		
		Если ВыборкаРегистраторов.ЧитаемыеДанныеЗаблокированы Тогда
			Продолжить;
		КонецЕсли;
		
 		НачатьТранзакцию();
		Попытка
			
			Отказ = Ложь;
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяРегистра + ".НаборЗаписей");
			ЭлементБлокировки.УстановитьЗначение("Регистратор", ВыборкаРегистраторов.Регистратор);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			
			ВыборкаЗаписей = ВыборкаРегистраторов.Выбрать();
			ТаблицаДокументовПринятиеКУчетуНМА = Новый ТаблицаЗначений;
			ТаблицаДокументовПринятиеКУчетуНМА.Колонки.Добавить("ДокументПринятияКУчету", Новый ОписаниеТипов("ДокументСсылка.ПринятиеКУчетуНМА2_4"));			
			ТаблицаДокументовВводаОстатков = Новый ТаблицаЗначений;
			ТаблицаДокументовВводаОстатков.Колонки.Добавить("ДокументПринятияКУчету", Новый ОписаниеТипов("ДокументСсылка.ВводОстатковВнеоборотныхАктивов2_4"));
			
			Пока ВыборкаЗаписей.Следующий() Цикл
				
				Если Не ЗначениеЗаполнено(ВыборкаЗаписей.ДокументПринятияКУчетуУУ) Тогда
					Продолжить;
				КонецЕсли;
				
				Если ТипЗнч(ВыборкаЗаписей.ДокументПринятияКУчетуУУ) = Тип("ДокументСсылка.ПринятиеКУчетуНМА2_4") Тогда
					Если ТаблицаДокументовПринятиеКУчетуНМА.Найти(ВыборкаЗаписей.ДокументПринятияКУчетуУУ, "ДокументПринятияКУчету") = Неопределено Тогда
						СтрокаТаблицыДокументов = ТаблицаДокументовПринятиеКУчетуНМА.Добавить();
						СтрокаТаблицыДокументов.ДокументПринятияКУчету = ВыборкаЗаписей.ДокументПринятияКУчетуУУ;
					КонецЕсли;
				ИначеЕсли ТипЗнч(ВыборкаЗаписей.ДокументПринятияКУчетуУУ) = Тип("ДокументСсылка.ВводОстатковВнеоборотныхАктивов2_4") Тогда
					Если ТаблицаДокументовВводаОстатков.Найти(ВыборкаЗаписей.ДокументПринятияКУчетуУУ, "ДокументПринятияКУчету") = Неопределено Тогда
						СтрокаТаблицыДокументов = ТаблицаДокументовВводаОстатков.Добавить();
						СтрокаТаблицыДокументов.ДокументПринятияКУчету = ВыборкаЗаписей.ДокументПринятияКУчетуУУ;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			
			Если ТаблицаДокументовПринятиеКУчетуНМА.Количество() Тогда
				ЭлементБлокировки = Блокировка.Добавить("Документ.ПринятиеКУчетуНМА2_4");
				ЭлементБлокировки.ИсточникДанных = ТаблицаДокументовПринятиеКУчетуНМА;
				ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Ссылка", "ДокументПринятияКУчету");
				ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
			КонецЕсли;
			
			Если ТаблицаДокументовВводаОстатков.Количество() Тогда
				ЭлементБлокировки = Блокировка.Добавить("Документ.ВводОстатковВнеоборотныхАктивов2_4");
				ЭлементБлокировки.ИсточникДанных = ТаблицаДокументовВводаОстатков;
				ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Ссылка", "ДокументПринятияКУчету");
				ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
			КонецЕсли;
			
			ВыборкаЗаписей.Сбросить();

			Блокировка.Заблокировать();
			
			Набор = РегистрыСведений.ПервоначальныеСведенияНМА.СоздатьНаборЗаписей();
			Набор.Отбор.Регистратор.Установить(ВыборкаРегистраторов.Регистратор);
			
			Пока ВыборкаЗаписей.Следующий() Цикл
				
				СтрокаЗаписи = Набор.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаЗаписи, ВыборкаЗаписей);
				
				Если ВыборкаЗаписей.ВерсияДанных <> Неопределено Тогда
					
					ТекущаяВерсияДанных = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВыборкаЗаписей.ДокументПринятияКУчетуУУ, "ВерсияДанных");
					Если ТекущаяВерсияДанных <> ВыборкаЗаписей.ВерсияДанных Тогда
						Отказ = Истина;
						Прервать;
					КонецЕсли;
					
				КонецЕсли;
								
			КонецЦикла;
			
			Если Не Отказ Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьДанные(Набор);
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			ОтменитьТранзакцию();
			ТекстСообщения = НСтр("ru = 'Не удалось обработать документ: %Регистратор% по причине: %Причина%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Регистратор%", ВыборкаРегистраторов.Регистратор);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка,
				ВыборкаРегистраторов.Регистратор.Метаданные(), ТекстСообщения);
		КонецПопытки;
			
	КонецЦикла;
	
	#КонецОбласти
	
	#Область ЗаполнениеРегистра
	
	Если Не ПараметрыРезультата.ЕстьДанныеДляЗаполненияРегистра Тогда
		// Не все обработчики по заполнению документов завершены. Заполнять регистр можно только после полного заполнения документов.
		Параметры.ОбработкаЗавершена = Не ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяРегистра);
		Возврат;
	КонецЕсли;
	
	ДокументыИспользующиеРасчетСтоимости = Новый Структура("ПринятиеКУчетуНМА2_4");
	ДокументыИспользующиеОтложенноеФормированиеДвижений = Новый Структура();
	
	Результат = ПараметрыРезультата.ДанныеДляЗаполненияРегистра;
	ВыборкаРегистраторов = Результат.Выбрать();
	
	Пока ВыборкаРегистраторов.Следующий() Цикл
		
		НачатьТранзакцию();
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяРегистра + ".НаборЗаписей");
			ЭлементБлокировки.УстановитьЗначение("Регистратор", ВыборкаРегистраторов.Регистратор);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			Блокировка.Заблокировать();
			
			ТаблицаПервоначальныеСведенияНМА = Новый ТаблицаЗначений;
			
			Если ВыборкаРегистраторов.Проведен Тогда
				МенеджерДокумента = ОбщегоНазначения.МенеджерОбъектаПоСсылке(ВыборкаРегистраторов.Регистратор);
				Если ДокументыИспользующиеРасчетСтоимости.Свойство(ВыборкаРегистраторов.Регистратор.Метаданные().Имя) Тогда
					ТаблицыДляДвижений = ВнеоборотныеАктивы.ТаблицыДвиженийРасчетаСтоимости(ВыборкаРегистраторов.Регистратор);
					ТаблицаПервоначальныеСведенияНМА = Неопределено;
					Если ТипЗнч(ТаблицыДляДвижений) = Тип("Структура") Тогда
						ТаблицыДляДвижений.Свойство("ПервоначальныеСведенияНМА", ТаблицаПервоначальныеСведенияНМА);
					КонецЕсли;
				ИначеЕсли ДокументыИспользующиеОтложенноеФормированиеДвижений.Свойство(ВыборкаРегистраторов.Регистратор.Метаданные().Имя) Тогда
					ТаблицыДляДвижений = ВнеоборотныеАктивы.ТаблицыОтложенногоФормированияДвижений(ВыборкаРегистраторов.Регистратор);
					ТаблицаПервоначальныеСведенияНМА = Неопределено;
					Если ТипЗнч(ТаблицыДляДвижений) = Тип("Структура") Тогда
						ТаблицыДляДвижений.Свойство("ПервоначальныеСведенияНМА", ТаблицаПервоначальныеСведенияНМА);
					КонецЕсли;
				Иначе
					ДополнительныеСвойства = Новый Структура;
					ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(ВыборкаРегистраторов.Регистратор, ДополнительныеСвойства, РежимПроведенияДокумента.Неоперативный);
					МенеджерДокумента.ИнициализироватьДанныеДокумента(ВыборкаРегистраторов.Регистратор, ДополнительныеСвойства, "ПервоначальныеСведенияНМА");
					ТаблицыДляДвижений = ДополнительныеСвойства.ТаблицыДляДвижений;
					ТаблицаПервоначальныеСведенияНМА = Неопределено;
					Если ТипЗнч(ТаблицыДляДвижений) = Тип("Структура") Тогда
						ТаблицыДляДвижений.Свойство("ТаблицаПервоначальныеСведенияНМА", ТаблицаПервоначальныеСведенияНМА);
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
						
			Если ТаблицаПервоначальныеСведенияНМА <> Неопределено И ТаблицаПервоначальныеСведенияНМА.Количество() Тогда
				
				Набор = РегистрыСведений.ПервоначальныеСведенияНМА.СоздатьНаборЗаписей();
				Набор.Отбор.Регистратор.Установить(ВыборкаРегистраторов.Регистратор);
				Набор.Загрузить(ТаблицаПервоначальныеСведенияНМА);
				ОбновлениеИнформационнойБазы.ЗаписатьДанные(Набор);
				
			Иначе
				
				ДополнительныеПараметрыОтметкиОбработки = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
				ДополнительныеПараметрыОтметкиОбработки.ЭтоДвижения = Истина;
				ДополнительныеПараметрыОтметкиОбработки.ПолноеИмяРегистра = ПолноеИмяРегистра;
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(ВыборкаРегистраторов.Регистратор, ДополнительныеПараметрыОтметкиОбработки, Параметры.Очередь);
				
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			ОтменитьТранзакцию();
			ТекстСообщения = НСтр("ru = 'Не удалось обработать документ: %Регистратор% по причине: %Причина%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Регистратор%", ВыборкаРегистраторов.Регистратор);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка,
				ВыборкаРегистраторов.Регистратор.Метаданные(), ТекстСообщения);
		КонецПопытки;
		
	КонецЦикла;	
	
	#КонецОбласти
	
	Параметры.ОбработкаЗавершена = Не ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяРегистра);
	
КонецПроцедуры

Функция ДанныеДляЗаполненияРегистра(Очередь, ПолноеИмяРегистра)
	
	ДополнительныеПараметрыВыборкиДанныхДляОбработки = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыВыборкиДанныхДляОбработки();
	ДополнительныеПараметрыВыборкиДанныхДляОбработки.ВыбиратьПорциями = Ложь;
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	ПараметрыОбработки = ОбновлениеИнформационнойБазы.СоздатьВременнуюТаблицуРегистраторовРегистраДляОбработки(Очередь,
		Неопределено, ПолноеИмяРегистра, МенеджерВременныхТаблиц, ДополнительныеПараметрыВыборкиДанныхДляОбработки);
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаРегистраИзменения.Регистратор КАК Регистратор,
	|	ТаблицаРегистра.Период КАК Период,
	|	ТаблицаРегистра.НематериальныйАктив КАК НематериальныйАктив,
	|	ТаблицаРегистра.Организация КАК Организация,
	|	ТаблицаРегистра.СпособПоступления КАК СпособПоступления,
	|	ТаблицаРегистра.ПервоначальнаяСтоимостьУУ КАК ПервоначальнаяСтоимостьУУ,
	|	ТаблицаРегистра.ПервоначальнаяСтоимостьБУ КАК ПервоначальнаяСтоимостьБУ,
	|	ТаблицаРегистра.ПервоначальнаяСтоимостьНУ КАК ПервоначальнаяСтоимостьНУ,
	|	ТаблицаРегистра.ПервоначальнаяСтоимостьПР КАК ПервоначальнаяСтоимостьПР,
	|	ТаблицаРегистра.ПервоначальнаяСтоимостьВР КАК ПервоначальнаяСтоимостьВР,
	|	ТаблицаРегистра.МетодНачисленияАмортизацииБУ КАК МетодНачисленияАмортизацииБУ,
	|	ТаблицаРегистра.МетодНачисленияАмортизацииНУ КАК МетодНачисленияАмортизацииНУ,
	|	ТаблицаРегистра.Коэффициент КАК Коэффициент,
	|	ТаблицаРегистра.АмортизацияДо2002 КАК АмортизацияДо2002,
	|	ТаблицаРегистра.АмортизацияДо2009 КАК АмортизацияДо2009,
	|	ТаблицаРегистра.СтоимостьДо2002 КАК СтоимостьДо2002,
	|	ТаблицаРегистра.ФактическийСрокИспользованияДо2009 КАК ФактическийСрокИспользованияДо2009,
	|	ТаблицаРегистра.ДатаПриобретения КАК ДатаПриобретения,
	|	ТаблицаРегистра.ДатаПринятияКУчетуУУ КАК ДатаПринятияКУчетуУУ,
	|	ТаблицаРегистра.ДатаПринятияКУчетуБУ КАК ДатаПринятияКУчетуБУ,
	|	ТаблицаРегистра.ДокументПринятияКУчетуУУ КАК ДокументПринятияКУчетуУУ,
	|	ТаблицаРегистра.ДокументПринятияКУчетуБУ КАК ДокументПринятияКУчетуБУ,
	|	ТаблицаРегистра.ДокументСписания КАК ДокументСписания,
	|	ТаблицаРегистра.ПорядокУчетаНУ КАК ПорядокУчетаНУ
	|ПОМЕСТИТЬ ВТДляЗаполненияРеквизита
	|ИЗ
	|	ВТДляОбработки КАК ТаблицаРегистраИзменения
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПервоначальныеСведенияНМА КАК ТаблицаРегистра
	|		ПО ТаблицаРегистраИзменения.Регистратор = ТаблицаРегистра.Регистратор
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Регистратор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаРегистраИзменения.Регистратор КАК Документ,
	|	ЕСТЬNULL(ДанныеДокумента.Дата, ДАТАВРЕМЯ(1,1,1)) КАК Период,
	|	ЕСТЬNULL(ДанныеДокумента.Проведен, ЛОЖЬ) КАК Проведен
	|ПОМЕСТИТЬ ВТДляЗаполненияРегистра
	|ИЗ
	|	ВТДляОбработки КАК ТаблицаРегистраИзменения
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВводОстатковВнеоборотныхАктивов2_4 КАК ДанныеДокумента
	|		ПО ТаблицаРегистраИзменения.Регистратор = ДанныеДокумента.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПервоначальныеСведенияНМА КАК ТаблицаРегистра
	|		ПО ДанныеДокумента.Ссылка = ТаблицаРегистра.Регистратор
	|			И ДанныеДокумента.Организация = ТаблицаРегистра.Организация
	|ГДЕ
	|	ТаблицаРегистра.Организация ЕСТЬ NULL
	|	И ТаблицаРегистраИзменения.Регистратор ССЫЛКА Документ.ВводОстатковВнеоборотныхАктивов2_4
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаРегистраИзменения.Регистратор КАК Документ,
	|	ЕСТЬNULL(ДанныеДокумента.Дата, ДАТАВРЕМЯ(1,1,1)) КАК Период,
	|	ЕСТЬNULL(ДанныеДокумента.Проведен, ЛОЖЬ) КАК Проведен
	|ИЗ
	|	ВТДляОбработки КАК ТаблицаРегистраИзменения
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПеремещениеНМА2_4 КАК ДанныеДокумента
	|		ПО ТаблицаРегистраИзменения.Регистратор = ДанныеДокумента.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПервоначальныеСведенияНМА КАК ТаблицаРегистра
	|		ПО ДанныеДокумента.Ссылка = ТаблицаРегистра.Регистратор
	|			И ДанныеДокумента.Организация = ТаблицаРегистра.Организация
	|ГДЕ
	|	ТаблицаРегистра.Организация ЕСТЬ NULL
	|	И ТаблицаРегистраИзменения.Регистратор ССЫЛКА Документ.ПеремещениеНМА2_4
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаРегистраИзменения.Регистратор КАК Документ,
	|	ЕСТЬNULL(ДанныеДокумента.Дата, ДАТАВРЕМЯ(1,1,1)) КАК Период,
	|	ЕСТЬNULL(ДанныеДокумента.Проведен, ЛОЖЬ) КАК Проведен
	|ИЗ
	|	ВТДляОбработки КАК ТаблицаРегистраИзменения
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПереоценкаНМА2_4 КАК ДанныеДокумента
	|		ПО ТаблицаРегистраИзменения.Регистратор = ДанныеДокумента.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПервоначальныеСведенияНМА КАК ТаблицаРегистра
	|		ПО ДанныеДокумента.Ссылка = ТаблицаРегистра.Регистратор
	|			И ДанныеДокумента.Организация = ТаблицаРегистра.Организация
	|ГДЕ
	|	ТаблицаРегистра.Организация ЕСТЬ NULL
	|	И ТаблицаРегистраИзменения.Регистратор ССЫЛКА Документ.ПереоценкаНМА2_4
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаРегистраИзменения.Регистратор КАК Документ,
	|	ЕСТЬNULL(ДанныеДокумента.Дата, ДАТАВРЕМЯ(1,1,1)) КАК Период,
	|	ЕСТЬNULL(ДанныеДокумента.Проведен, ЛОЖЬ) КАК Проведен
	|ИЗ
	|	ВТДляОбработки КАК ТаблицаРегистраИзменения
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПодготовкаКПередачеНМА2_4 КАК ДанныеДокумента
	|		ПО ТаблицаРегистраИзменения.Регистратор = ДанныеДокумента.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПервоначальныеСведенияНМА КАК ТаблицаРегистра
	|		ПО ДанныеДокумента.Ссылка = ТаблицаРегистра.Регистратор
	|			И ДанныеДокумента.Организация = ТаблицаРегистра.Организация
	|ГДЕ
	|	ТаблицаРегистра.Организация ЕСТЬ NULL
	|	И ТаблицаРегистраИзменения.Регистратор ССЫЛКА Документ.ПодготовкаКПередачеНМА2_4
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаРегистраИзменения.Регистратор КАК Документ,
	|	ЕСТЬNULL(ДанныеДокумента.Дата, ДАТАВРЕМЯ(1,1,1)) КАК Период,
	|	ЕСТЬNULL(ДанныеДокумента.Проведен, ЛОЖЬ) КАК Проведен
	|ИЗ
	|	ВТДляОбработки КАК ТаблицаРегистраИзменения
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПринятиеКУчетуНМА2_4 КАК ДанныеДокумента
	|		ПО ТаблицаРегистраИзменения.Регистратор = ДанныеДокумента.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПервоначальныеСведенияНМА КАК ТаблицаРегистра
	|		ПО ДанныеДокумента.Ссылка = ТаблицаРегистра.Регистратор
	|			И ДанныеДокумента.Организация = ТаблицаРегистра.Организация
	|ГДЕ
	|	ТаблицаРегистра.Организация ЕСТЬ NULL
	|	И ТаблицаРегистраИзменения.Регистратор ССЫЛКА Документ.ПринятиеКУчетуНМА2_4
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаРегистраИзменения.Регистратор КАК Документ,
	|	ЕСТЬNULL(ДанныеДокумента.Дата, ДАТАВРЕМЯ(1,1,1)) КАК Период,
	|	ЕСТЬNULL(ДанныеДокумента.Проведен, ЛОЖЬ) КАК Проведен
	|ИЗ
	|	ВТДляОбработки КАК ТаблицаРегистраИзменения
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.СписаниеНМА2_4 КАК ДанныеДокумента
	|		ПО ТаблицаРегистраИзменения.Регистратор = ДанныеДокумента.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПервоначальныеСведенияНМА КАК ТаблицаРегистра
	|		ПО ДанныеДокумента.Ссылка = ТаблицаРегистра.Регистратор
	|			И ДанныеДокумента.Организация = ТаблицаРегистра.Организация
	|ГДЕ
	|	ТаблицаРегистра.Организация ЕСТЬ NULL
	|	И ТаблицаРегистраИзменения.Регистратор ССЫЛКА Документ.СписаниеНМА2_4
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Документ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаРегистра.Регистратор КАК Регистратор,
	|	ТаблицаРегистра.Период КАК Период,
	|	ТаблицаРегистра.НематериальныйАктив КАК НематериальныйАктив,
	|	ТаблицаРегистра.Организация КАК Организация,
	|	ТаблицаРегистра.СпособПоступления КАК СпособПоступления,
	|	ТаблицаРегистра.ПервоначальнаяСтоимостьУУ КАК ПервоначальнаяСтоимостьУУ,
	|	ТаблицаРегистра.ПервоначальнаяСтоимостьБУ КАК ПервоначальнаяСтоимостьБУ,
	|	ТаблицаРегистра.ПервоначальнаяСтоимостьНУ КАК ПервоначальнаяСтоимостьНУ,
	|	ТаблицаРегистра.ПервоначальнаяСтоимостьПР КАК ПервоначальнаяСтоимостьПР,
	|	ТаблицаРегистра.ПервоначальнаяСтоимостьВР КАК ПервоначальнаяСтоимостьВР,
	|	ТаблицаРегистра.МетодНачисленияАмортизацииБУ КАК МетодНачисленияАмортизацииБУ,
	|	ТаблицаРегистра.МетодНачисленияАмортизацииНУ КАК МетодНачисленияАмортизацииНУ,
	|	ТаблицаРегистра.Коэффициент КАК Коэффициент,
	|	ТаблицаРегистра.АмортизацияДо2002 КАК АмортизацияДо2002,
	|	ТаблицаРегистра.АмортизацияДо2009 КАК АмортизацияДо2009,
	|	ТаблицаРегистра.СтоимостьДо2002 КАК СтоимостьДо2002,
	|	ТаблицаРегистра.ФактическийСрокИспользованияДо2009 КАК ФактическийСрокИспользованияДо2009,
	|	ТаблицаРегистра.ДатаПриобретения КАК ДатаПриобретения,
	|	ТаблицаРегистра.ДатаПринятияКУчетуУУ КАК ДатаПринятияКУчетуУУ,
	|	ТаблицаРегистра.ДатаПринятияКУчетуБУ КАК ДатаПринятияКУчетуБУ,
	|	ТаблицаРегистра.ДокументПринятияКУчетуУУ КАК ДокументПринятияКУчетуУУ,
	|	ТаблицаРегистра.ДокументПринятияКУчетуБУ КАК ДокументПринятияКУчетуБУ,
	|	ТаблицаРегистра.ДокументСписания КАК ДокументСписания,
	|	ЕСТЬNULL(ПринятиеКУчетуНМА.ВерсияДанных, ЕСТЬNULL(ВводОстатковВнеоборотныхАктивов.Ссылка.ВерсияДанных, НЕОПРЕДЕЛЕНО)) КАК ВерсияДанных,
	|	ВЫБОР КОГДА ТаблицаРегистра.ПорядокУчетаНУ = ЗНАЧЕНИЕ(Перечисление.ПорядокУчетаСтоимостиВнеоборотныхАктивов.ПустаяСсылка)
	|		ТОГДА ЕСТЬNULL(ПринятиеКУчетуНМА.ПорядокУчетаНУ, ЕСТЬNULL(ВводОстатковВнеоборотныхАктивов.ПорядокУчетаНУ,
	|			ЗНАЧЕНИЕ(Перечисление.ПорядокУчетаСтоимостиВнеоборотныхАктивов.НачислятьАмортизацию)))
	|		ИНАЧЕ ТаблицаРегистра.ПорядокУчетаНУ КОНЕЦ КАК ПорядокУчетаНУ,
	|	НЕ ЗаблокированныеДокументыПринятияКУчету.Ссылка ЕСТЬ NULL КАК ЧитаемыеДанныеЗаблокированы
	|ИЗ
	|	ВТДляЗаполненияРеквизита КАК ТаблицаРегистра
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПринятиеКУчетуНМА2_4 КАК ПринятиеКУчетуНМА
	|		ПО (ТаблицаРегистра.ДокументПринятияКУчетуУУ = ПринятиеКУчетуНМА.Ссылка)
	|			И ТаблицаРегистра.НематериальныйАктив = ПринятиеКУчетуНМА.НематериальныйАктив
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВводОстатковВнеоборотныхАктивов2_4.НМА КАК ВводОстатковВнеоборотныхАктивов
	|		ПО (ТаблицаРегистра.ДокументПринятияКУчетуУУ = ВводОстатковВнеоборотныхАктивов.Ссылка)
	|			И ТаблицаРегистра.НематериальныйАктив = ВводОстатковВнеоборотныхАктивов.НематериальныйАктив
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТЗаблокированныеДокументыПринятияКУчету КАК ЗаблокированныеДокументыПринятияКУчету
	|		ПО (ЗаблокированныеДокументыПринятияКУчету.Ссылка = ТаблицаРегистра.ДокументПринятияКУчетуУУ)
	|ГДЕ
	|	ТаблицаРегистра.Регистратор В
	|			(ВЫБРАТЬ ПЕРВЫЕ 500
	|				ВТДляОбработкиРегистраторПолная.Регистратор КАК Регистратор
	|			ИЗ
	|				ВТДляЗаполненияРеквизита КАК ВТДляОбработкиРегистраторПолная
	|			УПОРЯДОЧИТЬ ПО
	|				ВТДляОбработкиРегистраторПолная.Период УБЫВ)
	|
	|ИТОГИ
	|	МАКСИМУМ(ЧитаемыеДанныеЗаблокированы)
	|ПО
	|	Регистратор;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Данные.Документ КАК Регистратор,
	|	Данные.Период КАК Период,
	|	Данные.Проведен КАК Проведен
	|ИЗ
	|	ВТДляЗаполненияРегистра КАК Данные
	|ГДЕ
	|	Данные.Документ В
	|			(ВЫБРАТЬ ПЕРВЫЕ 500
	|				ВТДляОбработкиРегистраторПолная.Документ КАК Документ
	|			ИЗ
	|				ВТДляЗаполненияРегистра КАК ВТДляОбработкиРегистраторПолная
	|			УПОРЯДОЧИТЬ ПО
	|				ВТДляОбработкиРегистраторПолная.Период ВОЗР);
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТДляЗаполненияРегистра
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТДляЗаполненияРеквизита";
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
		
	ПараметрыЗаблокированныхСсылок = ОбновлениеИнформационнойБазы.СоздатьВременнуюТаблицуЗаблокированныхДляЧтенияИИзмененияСсылок(
		Очередь, "Документ.ПринятиеКУчетуНМА2_4,Документ.ВводОстатковВнеоборотныхАктивов2_4", Запрос.МенеджерВременныхТаблиц);
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ВТДляОбработки", ПараметрыОбработки.ИмяВременнойТаблицы);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ВТЗаблокированныеДокументыПринятияКУчету", ПараметрыЗаблокированныхСсылок.ИмяВременнойТаблицы);
		
	Запрос.Текст = ТекстЗапроса;
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	Результат = Новый Структура("ЕстьЗаписиВоВременныхТаблицах,ЕстьДанныеДляЗаполненияРегистра,ДанныеДляЗаполненияРеквизита,ДанныеДляЗаполненияРегистра");
	Результат.ДанныеДляЗаполненияРеквизита = РезультатЗапроса[2];
	Результат.ДанныеДляЗаполненияРегистра  = РезультатЗапроса[3];
	ЕстьДанныеДляЗаполненияРеквизита = РезультатЗапроса[0].Выгрузить()[0].Количество <> 0;
	ЕстьДанныеДляЗаполненияРегистра = РезультатЗапроса[1].Выгрузить()[0].Количество <> 0;
	Результат.ЕстьЗаписиВоВременныхТаблицах = ЕстьДанныеДляЗаполненияРеквизита ИЛИ ЕстьДанныеДляЗаполненияРегистра;
	
	Если Не ЕстьДанныеДляЗаполненияРегистра Тогда
		Результат.ЕстьДанныеДляЗаполненияРегистра = Ложь;
	Иначе
		МассивИспользуемыхДокументов = Новый Массив;
		МассивИспользуемыхДокументов.Добавить("Документ.ВводОстатковВнеоборотныхАктивов2_4");
		МассивИспользуемыхДокументов.Добавить("Документ.ПеремещениеНМА2_4");
		МассивИспользуемыхДокументов.Добавить("Документ.ПереоценкаНМА2_4");
		МассивИспользуемыхДокументов.Добавить("Документ.ПодготовкаКПередачеНМА2_4");
		МассивИспользуемыхДокументов.Добавить("Документ.ПринятиеКУчетуНМА2_4");
		МассивИспользуемыхДокументов.Добавить("Документ.СписаниеНМА2_4");
		Результат.ЕстьДанныеДляЗаполненияРегистра = Не ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Очередь, МассивИспользуемыхДокументов);
	КонецЕсли;	
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли